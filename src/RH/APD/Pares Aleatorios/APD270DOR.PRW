#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} APD270DOR
PONTO DE ENTRADA NA MONTAGEM DA AVALIACAO PELO APDA270
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author Marcos Pereira
@since 	22/11/2016
@param PARAMIXB[1], characters, Codido do avaliado em processamento
@param PARAMIXB[2], characters, Codigo do Periodo
@param PARAMIXB[3], numeric, Posicao do avaliador pre-selecionado no array de avaliadores
@param PARAMIXB[4], array, Array de avaliadores
@param PARAMIXB[5], array, Array contendo os avaliadores ja selecionados para a avaliado neste processamento
@param PARAMIXB[6], Array, Estrutura da tabela RDH - tipos de avaliacoes
@param PARAMIXB[7], array, Conteudo da tabela RDH, contendo os registros do tipo de avaliacao em processamento
@param PARAMIXB[8], numeric, Posicao atual do aRdhCols, informando qual esta sendo processado no momento
@param PARAMIXB[9], array, Array contendo as posicoes dos avaliadores ja selecionados anteriormente para o avaliado
@return undefined, Retornos possiveis:
a) array com 2 posições, sendo:
   1 - numero da posicao do avaliador conforme array de avaliadores (recebido pelo PARAMIXB[4])
   2 - array dos avaliadores, que foi recebido pelo PARAMIXB[4] e pode ser manipulado por esse ponto de entrada
b) numerico, sendo:
   0 (valor zero) - indica que o avaliador previamente selecionado e recebido pelo PARAMIXB[3] devera ser
                    desprezado, para que a rotina possa escolher outro aleatoriamente
   1 (valor um) - despreza o avaliador e interrompe o processo de busca de avaliadores para o avaliado em processamento
/*/
User Function APD270DOR()


Local uRet

Private cCodAdo		:= PARAMIXB[1]	//Codido do avaliado em processamento
Private cCodPer		:= PARAMIXB[2]	//Codigo do Periodo
Private nPosDOR		:= PARAMIXB[3]	//Posicao do avaliador pre-selecionado no array de avaliadores
Private aRED			:= PARAMIXB[4]	//Array de avaliadores
Private aTotPar		:= PARAMIXB[5]	//Array contendo os avaliadores ja selecionados para a avaliado neste processamento
Private aRdhHeader		:= PARAMIXB[6]	//Estrutura da tabela RDH - tipos de avaliacoes
Private aRdhCols		:= PARAMIXB[7]	//Conteudo da tabela RDH, contendo os registros do tipo de avaliacao em processamento
Private nRdhLoop		:= PARAMIXB[8]	//Posicao atual do aRdhCols, informando qual esta sendo processado no momento
Private aPosAux		:= PARAMIXB[9]	//array contendo as posicoes dos avaliadores ja selecionados anteriormente para o avaliado
Private cCodDor		:= aRED[nPosDOR,1]
Private cItemAdo
Private cItemDor
Private nMax

//Verifica se esta processando PARES
If aRdhCols[nRdhLoop,GdFieldPos( "RDH_NIVEL" , aRdhHeader )] == '1' .and. ;
    aRdhCols[nRdhLoop,GdFieldPos( "RDH_AUTOAV" , aRdhHeader )] == '2' .and. ;
     aRdhCols[nRdhLoop,GdFieldPos( "RDH_FEEDBK" , aRdhHeader )] == '2'

	cItemAdo		:= aRED[aScan( aRED , { |x| x[1] == cCodAdo  } ),3]
	cItemDor		:= aRED[nPosDOR,3]
	nMax := SuperGetMV("ES_MAXPARE",,3)

	//Busca um novo avaliador
	uRet := fNewDor()

EndIf

Return(uRet)

/*/{Protheus.doc} fVerDor
Descrição auto-gerada.
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@return array, {lRet,nVezes}
/*/
Static Function fVerDor()

Local nVezes  := 1
Local lRet 	:= .f.
Local cTemp
Local cQuery

//Verifica quantas vezes o avaliador ja foi selecionado na montagem em processamento
If ( nPos := ( aScan( aTotPar , { |x| x[1] == cCodDor  } ) ) ) > 0
	nVezes += aTotPar[nPos,4]
EndIf

//Se o avaliador ultrapassou a quantidade maxima permitida de avaliacoes, ou
// se avaliador e avaliado sao a mesma pessoa, ou
//  se o avaliador nao pertence ao mesmo nivel da visao que o avaliado
If nVezes > nMax .or. ;
	cCodAdo == cCodDor .or. ;
	 cItemDor <> cItemAdo

	lRet := .t.

//Verifica nas avaliacoes ja gravadas quandas vezes o avaliador foi selecionado
Else
	cQuery := "Select count(*) AS TOTAL from " + RetSQLName("RDC")
	cQuery += " where RDC_CODDOR = '" + cCodDor + "' and "
	cQuery += "       RDC_CODAVA <> '" + GetMemVar("RD6_CODIGO") + "' and "
	cQuery += "       RDC_CODDOR <> RDC_CODADO and "
	cQuery += "       RDC_NIVEL = '1' and RDC_TIPOAV = '1' and "
	cQuery += "       D_E_L_E_T_ = '' and "
	cQuery += "       RDC_CODAVA in (Select RD6_CODIGO from " + RetSQLName("RD6") + " where RD6_CODPER = '" + cCodPer + "' and D_E_L_E_T_ = '')"
	cQuery := ChangeQuery(cQuery)

	cTemp := "APD270DOR" //getnextalias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTemp,.T.,.F.)

	nVezes += (cTemp)->TOTAL
	If nVezes > nMax
		lRet := .t.
	EndIf

	(cTemp)->(dbCloseArea())

EndIf

Return({lRet,nVezes})

/*/{Protheus.doc} fNewDor
Descrição auto-gerada.
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@return undefined, uRet
/*/
Static Function fNewDor()

Local aDisp := {}
Local nX
Local nPos
Local nPos2
Local uRet

//Verifica os avaliadores disponiveis
For nX := 1 to len(aRED)
	If aRED[nX,3] == cItemAdo .and. aRED[nX,1] <> cCodAdo
		nPos := ( aScan( aTotPar , { |x| x[1] == aRED[nX,1] } ) )
		If nPos == 0
			cCodDor := aRED[nX,1]
			nPos := nX
		Else
			cCodDor := aTotPar[nPos,1]
		EndIf
		cItemDor := aRED[nX,3]

		//Verifica se o avaliador pre selecionado ainda nao consta como avaliador deste avaliado
		If ( nPos2 := ( aScan( aPosAux , { |x| x == nX  } ) ) ) == 0

			//Verifica se o avaliador pre selecionado ultrapassa a quantidade permitida
			aVerDor := fVerDor()
			If !aVerDor[1]
				aadd(aDisp,{nX,aVerDor[2]}) //Guarda a posicao do avaliador conforme aRED
			EndIf

		Endif
	EndIf
Next nX

//Se encontrou disponiveis, faz randomico e retorna o codigo do avaliador
If len(aDisp) > 0
	aSort(aDisp,,,{|x,y| x[2]<y[2]})
	aDisp1 := {}
	nVezes := aDisp[1,2] //Armazena a menor quantidade
	For nX := 1 to len(aDisp)
		If !(aDisp[nX,2] <= nVezes)
			exit
		EndIf
		aadd(aDisp1,aDisp[nX,1])
	Next nX
	nPos := Randomize( 1, len(aDisp1)+1 )
	uRet := {aDisp1[nPos],aClone(aRED)} //Devolve array com a posicao do avaliador e aRED original
Else
	uRet := 1
EndIf

Return(uRet)