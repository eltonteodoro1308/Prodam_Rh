#INCLUDE "GPEXCALC.CH" 
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FCalcPensao³ autor ³ Jose Ricardo        ³ Data ³ 11/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula a Pensao Alimenticia (Cad. Func./Cad. Beneficiarios³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FCalcPensao(cInss,cIR,cPensao,nPercPensao,dDataPgto,cTipo,lCarrBenef,cFilialCor,cNumDepIr,cTipoPgto,cSitFolha,aPensao)
Local nValBase   := nLiqTemp   := 0
Local nValInss   := nValIR     := 0
Local nNrSlMin   := nValFixo   := 0
Local nValPensao := nVlPens131 := 0
Local nPosRot	 := 0
Local cMVProPens := SUPERGETMV("MV_PROPENS",,"S")
Local cRotVerba  := ""
Local cVbBaseP   := ""
Local cVb131     := ""
Local cVbPLR     := ""
Local cVbAdt     := ""
Local cVbFer     := ""
Local lCalSlLiq  := .T.
Local lCadPensao := .T.
Local lCalSlBru  := .F.
Local lUsarIR    := .T.
Local aCodBenef  := {}
Local aOldBenef	 := {}
Local nIndProp   := 1
Local cSemAtual  := If(Type("cSemana") == Nil, "  ", cSemana)
Local nPos,nPos2,nPos3,nPosAdt,nCnt1,cTipoPens
Local aPdIR		 := {}		// array que guardar o ultimo IR gerado
Local nPosIR	 := 0		// variavel para posicionamento das verbas que serao geradas
Local nx		 := 0		// variavel para looping e atualizacao dos valores de IR.
Local nVal_Peal	 := 0		// variavel que armazena o valor total das pensoes alimenticias de adiantamento salarial.
Local nPosx		 := 0		// variavel para looping
Local cCodPenAdt := ""		// variavel que contem o codigo da verba de pensao para demonstracao da pensao do adiantamento.
Local nIndPropAnt:= 1
Local cMVPENSOUT := SuperGetMv("MV_PENSOUT",,"S")	// Parametro que indica se deve abater as pensoes de todos os
													// beneficiarios calculados ate o momento para apurar o IR do
													// beneficiario corrente.
Local nPosP132	 := 0
													
//-- Variaveis utilizadas na integracao com o PLS
Local c_Pensao		:= ""
Local n_PercPensao	:= 0
Local n_ValFixo		:= 0
Local n_NrSlMin		:= 0
Local c_VbBaseP		:= ""
Local l_CalSlLiq	:= .T.

Local nTamVF		:= 0
Local nTamSM		:= 0
Local nTamPC		:= 0

//-- Variaveis utilizadas na integracao com o PLS
DEFAULT cSitFolha	:= SRA->RA_SITFOLH
DEFAULT lCarrBenef	:= .T.
DEFAULT aPensao		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indica o tipo de calculo na rescisao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipo     := If(cTipo == Nil, Space(3), UPPER(cTipo))
cTipoPens := Space(3)

If cTipoRot == "4"
	cTipoPens := If( Empty(cTipo), "FOL", If(UPPER(cTipo) == "13O", "132", cTipo) )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica roteiro p/ prop. pensao sobre Sal.Minimo e Val.Fixo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoRot $ "1/4/9"
	nIndProp := ( Min( (DiasTrab+If(SRA->RA_TIPOPGT=="S",DiasDsr,0)+nDiasPg), 30 ) / P_QTDIAMES )
ElseIf cTipoRot == "3"
	nIndProp := ( Min( M->RH_DFERIAS, 30 ) / P_QTDIAMES )
ElseIf cTipoRot == "2"
	nIndProp := ( Min( DiasTb, 30 ) / P_QTDIAMES )
ElseIf cTipoRot $ "5/6"
	nIndProp := ( Min( nAvos, 12 ) / 12 )
EndIf
nIndPropAnt	:= nIndProp

If lCarrBenef
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca informacoes no cadastro de beneficiarios				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBusCadBenef( @aCodBenef, cTipoPens )
	
	If cTipoRot = "9"
		u_fBusCadBenef( @aCodBenef, cTipoPens )
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao houver dados calcula a partir do % do cadastro de func³
//³ ou trata a informacao enviada no array aPensao.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCodBenef) == 0
	If Len(aPensao) > 0
		For nx := 1 to Len(aPensao)
			If Len(aPensao[nx]) == 6
				c_Pensao	:= If(ValType(aPensao[nx,1]) == ValType(cPensao),aPensao[nx,1],cPensao)
				n_PercPensao:= If(ValType(aPensao[nx,2]) == ValType(nPercPensao),aPensao[nx,2],nPercPensao)
				n_ValFixo	:= If(ValType(aPensao[nx,3]) == ValType(nValFixo),aPensao[nx,3],nValFixo)
				n_NrSlMin	:= If(ValType(aPensao[nx,4]) == ValType(nNrSlMin),aPensao[nx,4],nNrSlMin)
				c_VbBaseP	:= If(ValType(aPensao[nx,5]) == ValType(cVbBaseP),aPensao[nx,5],cVbBaseP)
				l_CalSlLiq	:= If(ValType(aPensao[nx,6]) == ValType(lCalSlLiq),aPensao[nx,6],lCalSlLiq)
				Aadd(aCodBenef, { c_Pensao, n_PercPensao, n_ValFixo, n_NrSlMin, c_VbBaseP, l_CalSlLiq, aCodFol[172,1], cVbPLR, "", "", "", "", "", "", "", "" })
			EndIf
		Next nx
	else
		Aadd(aCodBenef, { cPensao, nPercPensao, nValFixo, nNrSlMin, cVbBaseP, lCalSlLiq, aCodFol[172,1], cVbPLR, "", "", "", "", "", "", "", "" })
	EndIf
	lCadPensao := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena o array de beneficiarios iniciando pelas pensoes fixas³
//³ salario minimo, utilizacao do IR e depois percentuais.		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamVF := TamSX3("RQ_VALFIXO")[1]
nTamSM := TamSX3("RQ_NRSLMIN")[1]
nTamPC := TamSX3("RQ_PERCENT")[1]
cIR := aCodFol[66 ,1]
If cTipoRot = "3"
	cIR := aCodFol[67,1]
EndIf
If cTipoRot = "6"
	cIR := aCodFol[71,1]
EndIf

nPos  := Ascan(aCodBenef, { |X| X[3] <>0 } )
nPos1 := Ascan(aCodBenef, { |X| X[4] <>0 } )
nPos2 := Ascan(aCodBenef, { |X| X[5] $ cIR } ) 
nPos3 := Ascan(aCodBenef, { |X| X[6] == .T. } ) 

aOldBenef := aClone( aCodBenef ) // Armazena copia do aCodBenef original
aEval( aCodBenef, { |W| aAdd( W, If( Empty(W[5]) .Or. cIR $ W[5], "0", "1" ) ) } ) // Adiciona um elemento para identificar se usa(0) ou nao(1) o IR na base de calculo

If npos+npos1+npos2+NPOS3 > 0 .and. cTipoRot $ "1/9"
	aSort( aCodBenef ,,, {|X,Y| StrZero(X[3],nTamVF)+StrZero(X[4],nTamSM)+X[Len(X)]+StrZero(X[2],nTamPC) > StrZero(Y[3],nTamVF)+StrZero(Y[4],nTamSM)+Y[Len(Y)]+StrZero(Y[2],nTamPC) })
EndIf

For nCnt1 := 1 To Len(aCodBenef)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega array com dados do cad. de pens. ou % do cad. de Func³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nIndProp	:= nIndPropAnt
	cPensao     := If( cTipo == "DFE", aCodBenef[nCnt1,13], aCodBenef[nCnt1,1] )
	nPercPensao := aCodBenef[nCnt1,2]
	nValFixo    := aCodBenef[nCnt1,3]
	nNrSlMin    := aCodBenef[nCnt1,4]
	cVbBaseP    := aCodBenef[nCnt1,5]
	lCalSlLiq   := aCodBenef[nCnt1,6]
	cVb131      := aCodBenef[nCnt1,7]
	cVbPLR      := aCodBenef[nCnt1,8]
	cVbAdt      := aCodBenef[nCnt1,14]
	cRotVerba   := aCodBenef[nCnt1,16]
    cVbFer		:= Substr( cRotVerba, AT( "FER", cRotVerba )+ 3,3 ) // CODIGO PENSAO DE FERIAS INFORMADO NO CADASTRO DE BENEFICIARIOS.
	
	If nNrSlMin > 0 .And. cTipo == "DFE"
		nIndProp := fDifPensaoSM( nNrSlMin, .F. )	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pensao sobre salario minimo e valor fixo.					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cMVProPens == "N"
		If nValFixo > 0 .Or. nNrSlMin > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando for calculo de folha, o funcionario estiver em ferias ³
			//³ e nao tiver codigo de pensao de ferias e tiver codigo de pen-³
			//³ sao de folha nao proporcionalizamos a pensao alimenticia.    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTipoRot $ "1/9"
				nIndProp	:= 1
				If cSitFolha == "F" .And. ( nPosRot := AT( "FER", cRotVerba ) ) > 0
					If	!Empty( Substr( cRotVerba, nPosRot + 3, 3 ) ) .and. ;
						fLocaliaPd(Substr( cRotVerba, nPosRot + 3, 3 )) > 0
						nIndProp	:= 0
					EndIf
				Else 
					If lDissidio .and. Ascan(aPd, { |X| X[1] = cVbFer .And. X[9] # "D" } ) > 0  // SER FOR DISSIDIO, VERIFICAR SE TEM CODIGO PENSAO FERIAS 
						nIndProp	:= 0                                                          // NO CADASTRO DE BENEFICIARIOS E NOS ACUMULADOS (APD)
					EndIf
				EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando for calculo de ferias e o funcionario nao tiver codigo³
			//³ de pensao de folha e tiver codigo de pensao de ferias nao    ³
			//³ proporcionalizamos a pensao alimenticia.                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf cTipoRot $"3*4*5*6"
				nIndProp	:= 1
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta o indice de proporcionalizacao para Pensao 1a.parcela ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoRot == "5" .And. ( nValFixo > 0 .Or. nNrSlMin > 0 )
		 //-- a variavel cVb131 contem o codigo da pensao de 2a parcela 
		 //-- quando for o calculo da 1a parcela do 13o salario
		If !Empty(cPensao) .And. !Empty(cVb131)
			nIndProp	:= nIndProp * nPercentual
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a pensao sobre Participacao nos Lucros e Resultados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoRot == "F"
		fPensPLR(cVbPLR,nPercPensao,nValFixo,nNrSlMin,lCalSlLiq,dDataPgto,cVbBaseP)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao existir codigo de pensao ou percentual, le proximo    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPensao) .Or. (nPercPensao == 0 .And. nValFixo == 0 .And. nNrSlMin == 0) .Or.;
	   ( ( nValFixo > 0 .Or. nNrSlMin > 0 ) .And. nIndProp == 0 )
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se ja foi lancado um codigo de pensao, le proximo elemento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Ascan(aPd, { |X| X[1] = cPensao .And. X[3] = cSemAtual .And. X[9] # "D" } ) > 0
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Semanalistas nao tiverem proventos calculados ou se eles  ³	
	//³ nao tiverem incidencia de Pensao Alim. cancela o calculo     ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If SRA->RA_TIPOPGT = "S"          
		If Ascan(aPd, { |X| X[3] == cSemAtual .And. X[9] # "D" } ) > 0             
			If Ascan(aPd, { |X| X[3]==cSemAtual .And. PosSrv( X[1],SRA->RA_FILIAL,"RV_PENSAO")=="S" .And. X[9] # "D" } ) <= 0
				Return
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o IR esta contido nos codigos de base da pensao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lUsarIR := ( Empty(cVbBaseP) .Or. cIR $ cVbBaseP )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pegar o Valor do Imposto de Renda Calculado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValIR := 0.00
	If lUsarIR
		nPos := Ascan(aPd, { |X| X[1] = cIR .And. X[3] = cSemAtual .And. X[9] # "D" } )
		If nPos > 0
			nValIR := aPd[nPos,5]
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta base da pensao ou utiliza val. fixo do cad. benef.	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValBase   := 0.00
	nValPensao := 0.00
	nLiqTemp   := 0.00
	If nValFixo > 0
		nValPensao := nValFixo * nIndProp //Proporcionaliza valor fixo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao efetuar o calculo p/ Valor Fixo na Rescisao Complementar ³
		//³ Ou na Diferenca de Ferias                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cCompl == "S" .Or. cTipo == "DFE"
			Loop
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pensao sobre 1a parcela em separado no calc. ferias ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipoRot = "3" .and. !Empty(cVb131)  .and. ;
		   PosSrv(cVb131,SRA->RA_FILIAL,"RV_PENSAO") = "S"
			nVlPens131 := NoRound( (nValFixo * M->RH_PERC13S)/100 ,MsDecimais(1))
			FGeraVerba(cVb131,nVlPens131,nPercPensao,cSemAtual,,"V",,,,dDataPgto)
		EndIf
	ElseIf nNrSlMin > 0
		nValPensao	:= NoRound(Val_SalMin * nNrSlMin, MsDecimais(1)) * nIndProp //Proporcionaliza salario minimo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcular pensao sobre 1a parcela em separado no calc. ferias ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipoRot = "3" .and. !empty(cVb131) .and. ;
		   PosSrv(cVb131,SRA->RA_FILIAL,"RV_PENSAO") = "S"
			nVlPens131 	:= NoRound( ((Val_SalMin * nNrSlMin) * M->RH_PERC13S)/100 ,MsDecimais(1))
			nVlPens131 	:= NoRound( (nVlPens131 * nPercPensao / 100),MsDecimais(1))
			FGeraVerba(cVb131,nVlPens131,nPercPensao,cSemAtual,,"V",,,,dDataPgto)		
		EndIf	
	Else
		If cTipoRot = "2"
			u_fBsPensAdt(aPd,@nValBase)
		ElseIf cTipoRot = "5"
			If lCadPensao
				Aeval( aPd ,{ |X|  If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
				SomaInc(X,28,@nValBase,,,,,,.F.,aCodFol),"") })
			Else
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[22,1] .And. X[3] = cSemAtual .And. X[9] # "D" } )
				If nPos > 0
					nValBase := aPd[nPos,5]
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Somas as verbas com "S" para Pensao Alimenticia  		     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf cTipoRot $ "1/9"
			If cTipo == "DFE" //Monta base para pensao da Diferenca de Ferias
				Aeval( aPd ,{ |X| If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
				SomaInc(X,28,@nValBase,,,,,,.F.,aCodFol),"") })
			Else
			   If !(cPaisLoc $ "CHI")
					Aeval( aPd ,{ |X| If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
					SomaInc(X,28,@nValBase,11,'N',12,'N', , .F.,aCodFol),"") })
				Else
					Aeval( aPd ,{ |X| If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
					SomaInc(X,28,@nValBase,11,'N',,, , .F.,aCodFol),"") })
				EndIf	
			EndIf
		ElseIf cTipoRot = "4"
			If cTipo == "FER"
				Aeval( aPd ,{ |X|  If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
				SomaInc(X,28,@nValBase,11,'S',12,'N', , .F.,aCodFol),"") })
			ElseIf cTipo == "13O"
				Aeval( aPd ,{ |X|  If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
				SomaInc(X,28,@nValBase,11,'N',12,'S', , .F.,aCodFol),"") })
			Else
				Aeval( aPd ,{ |X|  If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
				SomaInc(X,28,@nValBase,11,'N',12,'N', , .F.,aCodFol),"") })
			EndIf
		Else
			Aeval( aPd ,{ |X|  If(X[1]$cVbBaseP.Or.Empty(cVbBaseP),;
			SomaInc(X,28,@nValBase,,,,,,.F.,aCodFol),"") })

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcular pensao sobre 1a parcela em separado no calc. ferias ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTipoRot = "3"
				nPos    := Ascan(aPd, { |X| X[1] = aCodFol[22,1] .And. X[3] = cSemAtual .And. X[9] # "D"})
				If Ascan(aPd , { |X|  X[1] = aCodFol[22,1] .and. X[1]$cVbBaseP}) > 0				
					If !Empty(cVb131) .and. PosSrv(aPd[nPos,1],SRA->RA_FILIAL,"RV_PENSAO") = "S"			
						nValBase   -= aPd[nPos,5]
						nVlPens131 := NoRound(((aPd[nPos,5] * nPercPensao)/100),MsDecimais(1))
						FGeraVerba(cVb131,nVlPens131,nPercPensao,cSemAtual,,"V",,,,dDataPgto)
					else
						If PosSrv(aPd[nPos,1],SRA->RA_FILIAL,"RV_PENSAO") = "S"			
							nValBase   -= aPd[nPos,5]
							nVlPens131 := NoRound(((aPd[nPos,5] * nPercPensao)/100),MsDecimais(1))
							FGeraVerba(cVb131,nVlPens131,nPercPensao,cSemAtual,,"V",,,,dDataPgto)
						EndIf 
					EndIf
				else	
					If Empty(cVbBaseP) .and. nPos > 0 .And. PosSrv(aPd[nPos,1],SRA->RA_FILIAL,"RV_PENSAO") = "S" 
						nValBase   -= aPd[nPos,5]
						nVlPens131 := NoRound(((aPd[nPos,5] * nPercPensao)/100),MsDecimais(1))
						FGeraVerba(cVb131,nVlPens131,nPercPensao,cSemAtual,,"V",,,,dDataPgto)
					EndIf
				EndIf
			EndIf
		EndIf
		nValBase	:= If(nValBase < 0 ,0, nValBase )
		nLiqTemp 	:= NoRound(nValBase,2)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcular pensao se nao for informado valor fixo 			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nValFixo == 0 .And. nNrSlMin == 0
	If cTipoRot = "6"
		nValPensao := NoRound((((nLiqTemp) * nPercPensao)/100),2)
	Else
		nValPensao := NoRound((((nLiqTemp-nValIR) * nPercPensao)/100),2)
	EndIf
	ElseIf nNrSlMin > 0
		If nNrSlMin > 0 .And. cTipo == "DFE"
			nValPensao := fDifPensaoSM( nNrSlMin, .T. )
		EndIf	
		nValPensao := NoRound((nValPensao * nPercPensao / 100),MsDecimais(1))
	EndIf
	If cPaisLoc == "CHI" .And. (cTipoRot == "5" .or. nValFixo > 0)
		nValPensao := Round(nValPensao,MsDecimais(1))   
	EndIf
	
	FGeraVerba(cPensao,nValPensao,nPercPensao,cSemAtual,,"V",,,,dDataPgto)
	
	If (cTipoRot == "5").Or. (cTipoRot == "2" .And. !lCadPensao) .Or. nValFixo > 0 .Or. nNrSlMin > 0
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao utilizar IR, sair depois de calcular a pensao		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lUsarIR
		Loop
	EndIf
	
	nValPensao := 0
	lCalSlBru  := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver mais de uma pensao, marcar codigos anteriores como ³
	//³ deletados para nao serem utilizados como deducao na base I.R.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cMVPENSOUT == "N"
		u_fVerVbBenef(aCodBenef,1,nCnt1)
	EndIf
	
	While Max((((nLiqTemp-nValIR) * nPercPensao)/100),nValPensao) - Min((((nLiqTemp-nValIR) * nPercPensao)/100),nValPensao) > 0.01
		nValPensao := NoRound((((nLiqTemp-nValIR) * nPercPensao)/100),2)
		nValPensao := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura codigo de Pensao em aPd								 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan(aPd, { |X| X[1] = cPensao .And. X[3] = cSemAtual .And. X[9] # "D" } )
		If nPos > 0
			aPd[nPos,5] := nValPensao
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se for calculo pelo bruto, cancela apos o primeiro calculo   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCalSlBru
			Exit
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo valor do I.R. para deducao na pensao				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc == "BRA"
			If cTipoRot = "3" .Or. (cTipoRot =="4" .And. cTipo = "FER")
				//fcIrFer(aCodfol,aTabIr,If ( cTipo = "FER" , .T.,.F.),IF(cTipoRot =="4" .and. cTipo == "FER",M->RG_DATAHOM,M->RH_DTRECIB),.T.,If (cTipoRot = "3" ,"F",nil))
				fcIrFer(aCodfol,aTabIr,If ( cTipoRot = "3" , .T.,.F.),IF(cTipoRot =="4" .and. cTipo == "FER",M->RG_DATAHOM,M->RH_DTRECIB),.T.,If (cTipoRot = "3" ,"F",nil))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Deletar base do I.R. p/ recalculo (utilizar pensao p/deducao)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[16,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
				If nPos > 0
					aPd[nPos,9] = 'D'
				EndIf
			ElseIf cTipoRot = "5" .Or. (cTipoRot =="4" .And. cTipo = "13O") 
				fcIr13o(aCodfol,If ( cTipo == "13O",aTabIr,aTabIr13), If(cTipoRot = "3" .Or. (cTipoRot == "4" .And. cTipo == "13O" .And. lRecRes .And. cCompl == "N"), .T., .F.),If (cTipo = "13O",.T.,.F.),If(cTipoRot =="4",nIr13P,nil))
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[27,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Salva a ultima base do IR para finalizacao do calculo de Pensao ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (nPosIR	:= Ascan(aPdIR, { |X| X[1] == aCodFol[27,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' }) ) > 0
					If nPos > 0
						aPdIR[nPosIR,4]		:= aPd[nPos,4]
						aPdIR[nPosIR,5]		:= aPd[nPos,5]
						aPdIR[nPosIR,9]		:= " "
					Else
						aPdIR[nPosIR,9]		:= "D"
					EndIf
				Else
					If nPos > 0
						aAdd(aPdIR , aClone( aPd[nPos] ) )
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Deletar base do I.R. p/ recalculo (utilizar pensao p/deducao)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nPos > 0
					aPd[nPos,9] = 'D'
				EndIf
			ElseIf cTipoRot = "2"
				nBaseIrAdi := Base_Ini    // Preserva base (sera alterada durante o calculo)
				FM010IncIR()		       // Calcula o I.R.
				Base_Ini   := nBaseIrAdi   // Retorna a base original
				nValIR     := IR_CALC      // Preserva o valor do I.R.
				IR_CALC    := 0.00         // Zera o I.R. para um novo calculo
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se verba de adiantamento nao incidir pensao, nao dever ser   ³
				//³ utilizada para abater da base IR de salario.                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosAdt := 0
				If Empty(cVbAdt) .Or. PosSrv(aCodFol[7,1],xFilial("SRV"),"RV_PENSAO") # "S"
					nPosAdt := Ascan(aPd, { |X| X[1] == aCodFol[7,1] .And. X[3] == cSemAtual .And. X[9] # "D" })
					If nPosAdt > 0
						aPd[nPosAdt,9] := 'D'
					EndIf
				EndIf
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calculo do IR para deducao na PENSAO                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				fCIr(aCodfol,If(cTipoRot = "6",aTabIR13,aTabIr),if(cTipoRot == "4","R",nil),dDataPgto,cFilialCor,cNumDepIr,cTipoPgto)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Retornar como nao deletado o codigo de desconto do Adto      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nPosAdt > 0
					aPd[nPosAdt,9] := ' '
				EndIf
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Deletar base do I.R. p/ recalculo (utilizar pensao p/deducao)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[15,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
				If nPos > 0
					aPd[nPos,9] := 'D'
				EndIf
			EndIf
		Else
		   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo do IR para deducao na PENSAO                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc <> "CHI" .Or. cTipoRot $ "1|2|9"
				LocGananc()
			EndIf	
		   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Deletar base do I.R. p/ recalculo (utilizar pensao p/deducao)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTipoRot $ "1/9"
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[15,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
			ElseIf cTipoRot = "3" .Or. (cTipoRot =="4" .And. cTipo = "FER")
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[16,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
			ElseIf cTipoRot $ "5|6" .Or. (cTipoRot =="4" .And. cTipo = "13O")
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[27,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
			Else
				nPos := Ascan(aPd, { |X| X[1] = aCodFol[15,1] .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' })
    		EndIf
			If nPos > 0
				aPd[nPos,9] := 'D'
			EndIf				
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recuperar o valor do I.R.                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan(aPd, { |X| X[1] = cIR .And. X[3] = cSemAtual .And. X[9] # "D" } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva o ultimo valor de IR para finalizacao do calculo de Pensao da 2a parc. 13o. salario ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipoRot = "6" .Or. (cTipoRot =="4" .And. cTipo = "13O")
			If (nPosIR	:= Ascan(aPdIR, { |X| X[1] == cIR .And. X[3] = cSemAtual .And. X[9] # "D" .And. X[7] # 'I' }) ) > 0
				If nPos > 0
					aPdIR[nPosIR,4]		:= aPd[nPos,4]
					aPdIR[nPosIR,5]		:= aPd[nPos,5]
					aPdIR[nPosIR,9]		:= " "
				else
					aPdIR[nPosIR,9]		:= "D"
				EndIf
			else
				If nPos > 0
					aAdd(aPdIR , aClone( aPd[nPos] ) )
				EndIf
			EndIf
		EndIf

		If nPos > 0
			nValIR := NoRound(aPd[nPos,5],2)
			
			//-- Deleta para ser calculado novamente
			If cTipoRot $  "1*4*6*3*9" .And. aPd[nPos,7] # "I"
				aPd[nPos,9] := "D"
			EndIf
		EndIf


		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao for calculo pelo liquido, indica que e pelo bruto	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lCalSlLiq
			lCalSlBru := .T.
		EndIf
	Enddo
	
		nPos := Ascan(aPd, { |X| X[1] = cPensao .And. X[3] = cSemAtual .And. X[9] # "D" } )
		If nPos > 0 .and. !(cTipoRot $ "6")
			aPd[nPos,5] := (nValBase - nValIR) * (nPercPensao/100)
			nValPensao := (nValBase - nValIR) * (nPercPensao/100)
		Else
			aPd[nPos,5] := (nValBase) * (nPercPensao/100)
			nValPensao := (nValBase) * (nPercPensao/100)
		EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativar os codigos anteriormente deletados para calculo		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cMVPENSOUT == "N"
		u_fVerVbBenef(aCodBenef,2,nCnt1)
	EndIf
	If cPaisLoc == "CHI"
		nPos := Ascan(aPd, { |X| X[1] = cPensao .And. X[3] = cSemAtual .And. X[9] # "D" } )
		If nPos > 0
			aPd[nPos,5] := Round(aPd[nPos,5],MsDecimais(1))
		EndIf
	EndIf
Next nCnt1

aCodBenef := aClone( aOldBenef ) // Restaura aCodBenf original

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento especial quando for roteiro da 2¦ parcela do 13§	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoRot = "6" .or. ( cTipoRot = "4" .and. cTipo == "13O" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preservando o ultimo ir calculado de 13o salario pois se o funcionario tem pensao na ³
	//³ primeira parcela do 13o salario abateremos a pensao completa da base de calculo do IR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aPdIR) == 0 	.Or. cMVPENSOUT == "N"
		If cPaisLoc == "BRA"
			fcIr13o(aCodfol,If(cTipoRot = "6",aTabIR13,aTabIr), If(cTipoRot = "3" .Or. (cTipoRot == "4" .And. cTipo == "13O" .And. lRecRes .And. cCompl == "N"), .T., .F.),If (cTipo = "13O",.T.,.F.),If(cTipoRot =="4",nIr13P,nil))
		Else
			If cPaisLoc <> "CHI"
				LocGananc()
			EndIf	
		EndIf			
	Else
		For nx := 1 to len(aPdIR)
			If aPdIR[nx,9] <> "D"
				if ( nPosIR := Ascan(aPd, { |X| X[1] == aPdIR[nx,1] .And. X[3] == aPdIR[nx,3] .And. X[7] == aPdIR[nx,7] }) ) > 0
					aPd[nPosIR,4]	:= aPdIR[nx,4]
					aPd[nPosIR,5]	:= aPdIR[nx,5]
					aPd[nPosIR,9]	:= aPdIR[nx,9]
				else
					aAdd( aPd , aClone( aPdIR[nx] ) )
				EndIf
			EndIf
		next nx
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajuste da pensao alimenticia quando existir pensao na 1a.parc³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCnt1   := 1 To Len(aCodBenef)
		cPensao := aCodBenef[nCnt1,1]
		cVb131  := aCodBenef[nCnt1,7]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa Codigo de Pensao Descontado na 1o. Parcela			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos2 := Ascan(aPd, { |X| X[1] = cVb131 .And. X[3] = cSemAtual .AND. X[9] # "D" } )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura codigo de Pensao em aPd							     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos3 := Ascan(aPd, { |X| X[1] = cPensao .And. X[3] = cSemAtual .AND. X[9] # "D" } )
		If nPos3 > 0
			If nPos2 > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Abate da Pensao da 2¦ Parc. a Pensao Descontada na 1¦ Parcela³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aPd[nPos3,5] := NoRound(aPd[nPos3,5] - aPd[nPos2,5],MsDecimais(1))
			EndIf
			aPd[nPos3,5] := If(aPd[nPos3,5] < 0, 0, aPd[nPos3,5])
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera o Valor da Primeira se tiver valor da Segunda para nao descontar novamente na 2¦. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPos2 > 0 .And. aPd[nPos3,5] > 0
			aPd[nPos2,5] := 0.00
		EndIf
		
		If nPos3 > 0 .And. ( Ascan(aPd, { |x| x[1] = aCodFol[247,1] .And. x[3] = cSemAtual .And. x[9] # "D" } ) > 0 ) .And.;
		  Type("aValP132") == "A" .And. ( ( nPosP132 := Ascan( aValP132, { |x| x[1] = cPensao } ) ) > 0 )
		  	aPd[nPos3,5] := Max(NoRound(aPd[nPos3,5] - aValP132[nPosP132,2],MsDecimais(1)), 0)
		EndIf
	Next nCnt1

EndIf
If cTipoRot = "6"
fDelPD(aCodFol[071,1],,)
fDelPD(aCodFol[027,1],,)
NIR13_B := 0
EndIf

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³fBsPensAdt()³ autor ³ Emerson Rosa        ³ Data ³ 18/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta Base de Pensao para o Adiantamento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fBsPensAdt(aPd, nValBase)
Local nAdt, cAlias := ALIAS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza valor do adiantamento como base p/ calculo da pensao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If PosSrv(aCodFol[6,1],xFilial("SRV"),"RV_PENSAO") == "S" .And. Type("Val_Adto") # "U"
	nValBase := Val_Adto
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega valor da base com demais verbas que incidem pensao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nAdt := 1 To Len(aPd)
	If aPd[nAdt,1] # aCodfol[6,1] .And. aPd[nAdt,3] == cSemana
		PosSrv( aPd[nAdt,1], SRA->RA_FILIAL)
		If SRV->RV_PENSAO == "S" .And. SRV->RV_ADIANTA == "S"
			If SRV->RV_TIPOCOD $ "1*3"    // Provento/Base
				nValBase += aPd[nAdt,5]
			ElseIf SRV->RV_TIPOCOD == "2" // Desconto
				nValBase -= aPd[nAdt,5]
			EndIf
		EndIf
	EndIf
Next nAdt
dbSelectArea( cAlias )

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fVerVbBene³ Autor ³ Emerson Rosa de Souza ³ Data ³ 07.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Deletar ou limpar delecao para calculo do I.R. 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aCodBenef - Array contendo os codigos de benef calculados  ³±±
±±³          ³ nProceder - Indica se devera deletar ou limpar delecao	  ³±±
±±³          ³ nNroCod   - Numero de codigos de benef ja calculados	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fVerVbBenef(aCodBenef,nProceder,nNroCod)
Local nCnt4,nPosCod

If nNroCod > 1
	For nCnt4 := 1 To nNroCod-1
		If nProceder == 1 // Deletar verba para nao entrar no calculo do I.R.
			nPosCod := Ascan(aPd, { |X| X[1] = aCodBenef[nCnt4,1] .AND. X[9] # "D" } )
			If nPosCod > 0
				aPd[nPosCod,9] := "D"
			EndIf
		Else 		      // Limpar delecao
			nPosCod := Ascan(aPd, { |X| X[1] = aCodBenef[nCnt4,1] .AND. X[9] = "D" } )
			If nPosCod > 0
				aPd[nPosCod,9] := ""
			EndIf
		EndIf
	Next nCnt4
EndIf

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fBusCadBenef³ autor ³ Emerson Rosa        ³ Data ³ 02/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carrega array com informacoes do cadastro de beneficiarios ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fBusCadBenef(aCodBenef,cRotCalc,aIncVerb,lDadosBenef,cFilFun,cMatFun,dDtaComp)
Local aArea 	:= GetArea()
Local aAux   	:= {}
Local aRotAux   := {fGetCalcRot("1"),fGetCalcRot("2"),fGetCalcRot("3"),fGetCalcRot("4"),fGetCalcRot("5"),fGetCalcRot("6"),fGetCalcRot("9")} //Melhoria de performance, nao executar a funcao dentro do while
Local cChaveComp,nArray,nCntVb, lTemCpoPLR, lTemCpoCta, lTemCpoDFE, lTemCpoImp, lDtIniPg
Local dDataCalc
Local cFunname	:= Upper(Alltrim(Funname()))     
Local lPortal   := Type("httpHeadIn->Host") != "U"
Local nUltDia	:= 0

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verifica se eh Gestao Publica                                 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

lDissidio := If(type("lDissidio")=="U",.F.,lDissidio)	    // Variavel utilizada no Calculo do Dissidio

aCodBenef   := {}
cRotCalc    := If(cRotCalc    == Nil .Or. Empty(cRotCalc),cRot,cRotCalc)
lDadosBenef := If(lDadosBenef == Nil, .F., lDadosBenef)
cFilFun		:= If(cFilFun     == Nil, SRA->RA_FILIAL, cFilFun )
cMatFun		:= If(cMatFun     == Nil, SRA->RA_MAT, cMatFun )
cProcesso 	:= If (Type("cProcesso") == "U", SRA->RA_PROCES, cProcesso)

If lPortal
	nUltDia:= f_UltDia( CToD( "01" + "/" + StrZero(Month(date()), 2) + "/" + StrZero(Year(date()), 4) ) )            
	DEFAULT dDtaComp := CToD( StrZero(nUltDia, 2) + "/" + StrZero(Month(date()), 2) + "/" + StrZero(Year(date()), 4) ) 
Else
	DEFAULT dDtaComp := dDataAte
EndIf

dbSelectArea( "SRQ" )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Teste a existencia do campo  - Gestão Pública                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lDtIniPg := ( FieldPos( "RQ_DTINIPG" ) # 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Teste a existencia do campo  -                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTpBenef := ( FieldPos( "RQ_TPBENEF" ) != 0 )  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verbas (Identificadores) a ser incluidas no array de benef   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aIncVerb != Nil
	For nCntVb := 1 To Len(aIncVerb)
		If !Empty(aIncVerb[nCntVb])
			aAdd(aCodBenef, { aIncVerb[nCntVb], 0, 0, 0, "", .F., "", "", "", "", "", "", "", "", "", "", "", "" } )
		EndIf
	Next nCntVb
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega array com dados do cadastro de beneficiarios	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dbSeek( cFilFun + cMatFun )
	nArray := 0
	While SRQ->RQ_FILIAL+SRQ->RQ_MAT == cFilFun + cMatFun
		
		If 	(!Empty(SRQ->RQ_DTINI) .or. !Empty(SRQ->RQ_DTFIM))
				//Se for ferias nao utilizar o cFolMes, e sim a data de recebimento das ferias
			  	If cRotCalc == "FER" .and. cFunname $ "GPEM030|GPEM060"
		 			dDataCalc := M->RH_DTRECIB	
		  	 	Else
				   //cFolMes -> Ano e mes de competencia para calc folha
					dDataCalc := If(lDissidio,dDatabase, dDtaComp) 
			 	EndIf

				If (!Empty(SRQ->RQ_DTINI) .and. dDataCalc < SRQ->RQ_DTINI) .or.;
				   (!Empty(SRQ->RQ_DTFIM) .and. dDataCalc > SRQ->RQ_DTFIM)
					dbSkip()
					Loop
				EndIf		
		EndIf
		
		aAux := { "", 0, 0, 0, "", .F., "", "", "", "", "", "", "", "", "S", "", "", "",0,"","", "" } //22 POSICOES
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no elemento 1 do array a VERBA para geracao do benef	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cRotCalc == aRotAux[2]
			aAux[1] := SRQ->RQ_VERBADT
		ElseIf cRotCalc == aRotAux[1] 
			aAux[1] := SRQ->RQ_VERBFOL
		ElseIf cRotCalc == aRotAux[3]
			aAux[1] := SRQ->RQ_VERBFER
		ElseIf cRotCalc == aRotAux[5]
			aAux[1] := SRQ->RQ_VERB131
		ElseIf cRotCalc == aRotAux[6]
			aAux[1] := SRQ->RQ_VERB132
		EndIf
		
		If cTipoRot = "9"
			aAux[1] := SRQ->RQ_VERBFOL
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no array demais campos do cadastro de beneficiarios	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux[2] := SRQ->RQ_PERCENT
		aAux[3] := SRQ->RQ_VALFIXO
		aAux[4] := SRQ->RQ_NRSLMIN
		aAux[5] := SRQ->RQ_VERBAS
		aAux[6] := ( SRQ->RQ_CALSLIQ == "S" )
		aAux[7] := If(cRotCalc $ aRotAux[5] + aRotAux[1],SRQ->RQ_VERB132,SRQ->RQ_VERB131)
		aAux[8] := SRQ->RQ_VERBPLR

		If lDadosBenef 
			aAux[09] := SRQ->RQ_NOME
			aAux[10] := SRQ->RQ_BCDEPBE
			aAux[11] := SRQ->RQ_CTDEPBE
		  	aAux[12] := SRQ->RQ_CIC //ADICIONANDO O NUMERO DO CPF DO BENEFICIARIO NO ARRAY
		EndIf
		aAux[13] := SRQ->RQ_VERBDFE
		aAux[14] := SRQ->RQ_VERBADT //Verba do Adto para utilizacao na pensao da folha
		aAux[15] := SRQ->RQ_IMPCTRE //Imprime %Pensao no Termo de Rescisao de contrato

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar os roteiros e as verbas correspondentes a cada pensao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAux[16] := "ADI" + SRQ->RQ_VERBADT + "FOL" + SRQ->RQ_VERBFOL +;
					 "FER" + SRQ->RQ_VERBFER + "131" + SRQ->RQ_VERB131 +;
					 "132" + SRQ->RQ_VERB132 + "RES" + SRQ->RQ_VERBPLR
					 
		aAux[16] += "RRA" + SRQ->RQ_VERBRRA

		If lDtIniPg
			aAux[17] := SRQ->RQ_DTINIPG      //Data inicio do Pagamento da Pensão - Usado na nova folha
			aAux[18] := SRQ->RQ_DTFIMPG		 //Data fim do Pagamento da Pensão - Usado na nova folha
		EndIf
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³ Verifica se existem outras verbas para composicao da base	 ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		aAux[19] := SRQ->(Recno())		
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³ Verifica se deve carregar Tipo de Beneficiario				 ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If lTpBenef 
			aAux[20] := SRQ->RQ_TPBENEF
			aAux[21] := SRQ->RQ_ORDEM
		EndIf

		//ATRIBUI TIPO DA CONTA PARA DEPOSITO; USO EM GPEM080 (GERACAO DE ARQUIVO LIQUIDO)
		If Type("lUsaBanco") <> "U" .AND. lUsaBanco
			aAux[22] := SRQ->RQ_TPCTSAL
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existem outras verbas para composicao da base	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChaveComp := SRQ->RQ_FILIAL+SRQ->RQ_MAT+SRQ->RQ_ORDEM
		dbSkip()
		
		While SRQ->RQ_FILIAL+SRQ->RQ_MAT+SRQ->RQ_ORDEM==cChaveComp
			aAux[5] += AllTrim(SRQ->RQ_VERBAS)
			dbSkip()
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Somente carregar array se existir codigo de benef ou tiver   ³
		//³ codigo de pensao para PLR ou tiver codigo de pensao da 1a    ³
		//³ parc.no calculo da 2a.parc.p/utilizacao como deducao de IR.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aAux[1]) .Or. !Empty(aAux[8]) .Or. ( cRotCalc $ aRotAux[6] + aRotAux[1] .And. !Empty(aAux[7]) )
			aAdd(aCodBenef, aAux )
		EndIf
	EndDo
EndIf

RestArea(aArea)

Return .T.
