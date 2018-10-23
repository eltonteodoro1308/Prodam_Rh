//---------------------------------------------------------------------------------------
/*/{Protheus.doc} APD270DOR
@Descrição  PONTO DE ENTRADA NA MONTAGEM DA AVALIACAO PELO APDA270
@author     Marcos Pereira
@since     	22/11/2016
@version  	P.12      
@param 		PARAMIXB[1]	//Codido do avaliado em processamento
			PARAMIXB[2]	//Codigo do Periodo 
			PARAMIXB[3]	//Posicao do avaliador pre-selecionado no array de avaliadores
			PARAMIXB[4]	//Array de avaliadores
			PARAMIXB[5]	//Array contendo os avaliadores ja selecionados para a avaliado neste processamento
			PARAMIXB[6]	//Estrutura da tabela RDH - tipos de avaliacoes
			PARAMIXB[7]	//Conteudo da tabela RDH, contendo os registros do tipo de avaliacao em processamento
			PARAMIXB[8]	//Posicao atual do _aRdhCols, informando qual esta sendo processado no momento
			PARAMIXB[9]	//array contendo as posicoes dos avaliadores ja selecionados anteriormente para o avaliado
@return   Retornos possiveis:
			a) array com 2 posições, sendo:
				1 - numero da posicao do avaliador conforme array de avaliadores (recebido pelo PARAMIXB[4])
			   	2 - array dos avaliadores, que foi recebido pelo PARAMIXB[4] e pode ser manipulado por esse ponto de entrada
			b) numerico, sendo:
				0 (valor zero) - indica que o avaliador previamente selecionado e recebido pelo PARAMIXB[3] devera ser
				                 desprezado, para que a rotina possa escolher outro aleatoriamente
				1 (valor um) - despreza o avaliador e interrompe o processo de busca de avaliadores para o avaliado em processamento
@obs        
			Alterações Realizadas desde a Estruturação Inicial
			------------+-----------------+----------------------------------------------------------
			Data       	|Desenvolvedor    |Motivo                                                                                                                 
			------------+-----------------+----------------------------------------------------------
					  	|       		  | 
			------------+-----------------+----------------------------------------------------------
			/*/
//--------------------------------------------------------------------------------------- 

User Function APD270DOR()


Local uRet

Private _cCodAdo		:= PARAMIXB[1]	//Codido do avaliado em processamento
Private _cCodPer		:= PARAMIXB[2]	//Codigo do Periodo 
Private _nPosDOR		:= PARAMIXB[3]	//Posicao do avaliador pre-selecionado no array de avaliadores
Private _aRED			:= PARAMIXB[4]	//Array de avaliadores
Private _aTotPar		:= PARAMIXB[5]	//Array contendo os avaliadores ja selecionados para a avaliado neste processamento
Private _aRdhHeader		:= PARAMIXB[6]	//Estrutura da tabela RDH - tipos de avaliacoes
Private _aRdhCols		:= PARAMIXB[7]	//Conteudo da tabela RDH, contendo os registros do tipo de avaliacao em processamento
Private _nRdhLoop		:= PARAMIXB[8]	//Posicao atual do _aRdhCols, informando qual esta sendo processado no momento
Private _aPosAux		:= PARAMIXB[9]	//array contendo as posicoes dos avaliadores ja selecionados anteriormente para o avaliado
Private _cCodDor		:= _aRED[_nPosDOR,1]
Private _cItemAdo		
Private _cItemDor		
Private nMax

//Verifica se esta processando PARES
If _aRdhCols[_nRdhLoop,GdFieldPos( "RDH_NIVEL" , _aRdhHeader )] == '1' .and. ;
    _aRdhCols[_nRdhLoop,GdFieldPos( "RDH_AUTOAV" , _aRdhHeader )] == '2' .and. ;
     _aRdhCols[_nRdhLoop,GdFieldPos( "RDH_FEEDBK" , _aRdhHeader )] == '2'	
	
	_cItemAdo		:= _aRED[aScan( _aRED , { |x| x[1] == _cCodAdo  } ),3]
	_cItemDor		:= _aRED[_nPosDOR,3]
	nMax := SuperGetMV("ES_MAXPARE",,3)
	
	//Busca um novo avaliador
	uRet := fNewDor()		
		
EndIf

Return(uRet)


//-----------------------
Static Function fVerDor()
//-----------------------

Local nVezes  := 1
Local lRet 	:= .f.
Local cTemp
Local cQuery

//Verifica quantas vezes o avaliador ja foi selecionado na montagem em processamento
If ( nPos := ( aScan( _aTotPar , { |x| x[1] == _cCodDor  } ) ) ) > 0 
	nVezes += _aTotPar[nPos,4]
EndIf

//Se o avaliador ultrapassou a quantidade maxima permitida de avaliacoes, ou
// se avaliador e avaliado sao a mesma pessoa, ou
//  se o avaliador nao pertence ao mesmo nivel da visao que o avaliado 
If nVezes > nMax .or. ;
	_cCodAdo == _cCodDor .or. ;
	 _cItemDor <> _cItemAdo

	lRet := .t.

//Verifica nas avaliacoes ja gravadas quandas vezes o avaliador foi selecionado
Else
	cQuery := "Select count(*) AS TOTAL from " + RetSQLName("RDC") 
	cQuery += " where RDC_CODDOR = '" + _cCodDor + "' and "
	cQuery += "       RDC_CODAVA <> '" + GetMemVar("RD6_CODIGO") + "' and "
	cQuery += "       RDC_CODDOR <> RDC_CODADO and " 
	cQuery += "       RDC_NIVEL = '1' and RDC_TIPOAV = '1' and "
	cQuery += "       D_E_L_E_T_ = '' and "
	cQuery += "       RDC_CODAVA in (Select RD6_CODIGO from " + RetSQLName("RD6") + " where RD6_CODPER = '" + _cCodPer + "' and D_E_L_E_T_ = '')"
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


//-----------------------
Static Function fNewDor()
//-----------------------

Local aDisp := {}
Local nX
Local nPos
Local nPos2
Local xRet

//Verifica os avaliadores disponiveis
For nX := 1 to len(_aRED)
	If _aRED[nX,3] == _cItemAdo .and. _aRED[nX,1] <> _cCodAdo
		nPos := ( aScan( _aTotPar , { |x| x[1] == _aRED[nX,1] } ) )
		If nPos == 0
			_cCodDor := _aRED[nX,1]
			nPos := nX
		Else
			_cCodDor := _aTotPar[nPos,1]
		EndIf
		_cItemDor := _aRED[nX,3]

		//Verifica se o avaliador pre selecionado ainda nao consta como avaliador deste avaliado
		If ( nPos2 := ( aScan( _aPosAux , { |x| x == nX  } ) ) ) == 0
	
			//Verifica se o avaliador pre selecionado ultrapassa a quantidade permitida
			aVerDor := fVerDor()
			If !aVerDor[1]
				aadd(aDisp,{nX,aVerDor[2]}) //Guarda a posicao do avaliador conforme _aRED
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
	xRet := {aDisp1[nPos],aClone(_aRED)} //Devolve array com a posicao do avaliador e _aRED original
Else
	xRet := 1
EndIf

Return(xRet)


