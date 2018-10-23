#INCLUDE 'PROTHEUS.CH'
/*/{Protheus.doc} GPE001
Função Main Calculo de PLR
@author TOTVS Protheus
@since  19/04/2016
@obs    
@version 1.0
/*/
User Function GPE001()
Local aRetParam	:= {} //Parametros utilizados para calculo
Local aAliasU001:= GetNextAlias()
Local cRGBALS	:= "RGBFIL"
Local lContinua	:= .T.
Local aTabTemp	:= {}

Private nTotFuncs	:= 0
Private cProv		:= ''

if fParam(aRetParam)
	/*
	aRetParam[2] = Período
	aRetParam[3] = Verba de Base
	aRetParam[4] = Consolidado APD
	aRetParam[5] = Redução por Atingimento
	aRetParam[6] = Qual a Tabela
	aRetParam[7] = Quem não tem Metas
	*/
	if ValType(aRetParam)=="A" .And. Len(aRetParam)>0
		
		//Localiza o provento de PLR (ID.0151)
		cProv	:= Posicione("SRV",2,xFilial("SRV")+'0151',"RV_COD")
		If empty(cProv)
			HELP(,,"CANCEL",,"Provento de PLR não encontrado no cadastro de verbas (ID.0151)",1,0)
	
		Else

			//Checa a existencia da tabela temporária de percentuais
			lContinua := IIF(aRetParam[5]==1 .And. PRDVLTAB(@aTabTemp,aRetParam),.T.,IIF(aRetParam[5]==2,.T.,.F.) )
			
			If !lContinua
				HELP(,,"CANCEL",,"A Tabela informada no parâmetro para % de PLR possui estrutura inválida.",1,0)

			Else 			
				//Verifica a existencia de periodo processado
				if PRDVLDPL(aRetParam,cRGBALS)
					Processa({|| lOk := PRDVLPRC(aRetParam, aTabTemp ,cRGBALS)},"Em processamento...")
					If nTotFuncs > 0
						HELP(,,"END",,"Processo Concluído com Sucesso. Funcionários Processados: "+strzero(nTotFuncs,6),1,0)
					Else
						HELP(,,"END",,"Não foram encontrados movimentos no período selecionado.",1,0)
					EndIf					
				else
					HELP(,,"CANCEL",,"Processo Cancelado pelo Usuário!",1,0)
				EndIf

			EndIf

		EndIf

	Else
		HELP(,,"CANCEL",,"Por gentileza, preencher todos os campos.",1,0)

	EndIf
Else
	HELP(,,"CANCEL",,"Processo Cancelado pelo Usuário!",1,0)
EndIf
if Select(cRGBALS)> 0 
	(cRGBALS)->(dbCloseArea())
EndIf		
//(aAliasU001)->(dbCloseArea())

Return .t.

/*/{Protheus.doc} PRDVLDPL
Valida se é Reprocessamento ou Processamento
@author TOTVS Protheus
@since  19/04/2016
@param aRetParam= Parametros preenchidos no parambox
@param	cRGBALS = Alias utilizado como base com dados da RGB
@obs   	aRetParam[2] = Período
		aRetParam[3] = Verba de Base
		aRetParam[4] = Consolidado APD
		aRetParam[5] = Redução por Atingimento
		aRetParam[6] = Qual a Tabela
		aRetParam[7] = Quem não tem Metas
@version 1.0
/*/
Static Function PRDVLDPL(aRetParam,cRGBALS)
Local cQry		:= ""

Local lContinua		:= .T.
Default cRGBALS		:= ""
Default aRetParam	:= {}


cQry	 := "SELECT RV_CODFOL,RGB_FILIAL,RGB_PERIOD,"+CRLF
cQry	 += "RGB_PD,RGB_SEMANA,RGB_ROTEIR,RGB_VALOR,"+CRLF
cQry	 += "RGB_SEQ,RGB_NUMID,RGB_CODFUN,RGB_POSTO,"+CRLF
cQry	 += "RGB_DEPTO,RGB_PROCES,RGB.R_E_C_N_O_ POSREC, "+CRLF
cQry	 += "RGB_MAT, RDZ_CODRD0 "+CRLF
cQry	 += "FROM " + RetSqlTab("RGB")+CRLF
cQry	 += "INNER JOIN " + RetSqlTab("SRV") + " ON (RGB.RGB_PD = SRV.RV_COD AND RGB.D_E_L_E_T_ = '')" + CRLF
cQry	 += "INNER JOIN " + RetSqlTab("RDZ") + " ON (RDZ.RDZ_CODENT = (RGB.RGB_FILIAL+RGB.RGB_MAT) AND RDZ.D_E_L_E_T_ = '')" + CRLF
cQry	 += "WHERE RGB_FILIAL = '" + xFilial("RGB") 	+ "' AND " + CRLF
cQry	 += "RGB_PERIOD 	= '" + Substr(aRetParam[2],1,TamSx3("RGB_PERIOD")[1]) 	+ "' AND " + CRLF
cQry	 += "RGB_ROTEIR 	= 'PLR' AND " + CRLF
cQry	 += "RV_CODFOL 		= '0151' AND " + CRLF
cQry	 += "RGB.D_E_L_E_T_ = ''"

cQry	 := ChangeQuery(cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cRGBALS, .F., .T.)
if !(cRGBALS)->(Eof())
	If MsgYesNo("Já existe provento de PLR para este periodo. Deseja prosseguir com o Recálculo?")
		PRDVLDEL(cRGBALS)
	else
		lContinua	:= .F.
	EndIf
else
	If !MsgYesNo("Deseja prosseguir com o cálculo?")
		
		lContinua	:= .F.
	EndIf
EndIf

if lContinua
	if Select(cRGBALS)>0
		(cRGBALS)->(dbclosearea())
	EndIf
	cQry	 := "SELECT RV_CODFOL,RGB_FILIAL,RGB_PERIOD,"+CRLF
	cQry	 += "RGB_PD,RGB_SEMANA,RGB_ROTEIR,RGB_VALOR,"+CRLF
	cQry	 += "RGB_SEQ,RGB_NUMID,RGB_CODFUN,RGB_POSTO,RGB_CC,"+CRLF
	cQry	 += "RGB_DEPTO,RGB_PROCES,RGB.R_E_C_N_O_ POSREC,RGB_MAT,RDZ_CODRD0 "+CRLF
	cQry	 += "FROM " + RetSqlTab("RGB")+CRLF
	cQry	 += "INNER JOIN " + RetSqlTab("SRV") + " ON (RGB.RGB_PD = SRV.RV_COD AND RGB.D_E_L_E_T_ = '')" + CRLF
	cQry	 += "INNER JOIN " + RetSqlTab("RDZ") + " ON (RDZ.RDZ_CODENT = (RGB.RGB_FILIAL+RGB.RGB_MAT) AND RDZ.D_E_L_E_T_ = '')" + CRLF
	cQry	 += "WHERE RGB_FILIAL = '" + xFilial("RGB") 	+ "' AND " + CRLF
	cQry	 += "RGB_PERIOD 	= '" + Substr(aRetParam[2],1,TamSx3("RGB_PERIOD")[1]) 	+ "' AND " + CRLF
	cQry	 += "RGB_SEMANA 	= '" + RIGHT(aRetParam[2],TamSx3("RGB_SEMANA")[1]) 	+ "' AND " + CRLF
	cQry	 += "RGB_ROTEIR 	= 'PLR' AND " + CRLF
	cQry	 += "RGB_PD	 		= '" + aRetParam[3] +"' AND " + CRLF
	cQry	 += "RGB.D_E_L_E_T_ = ''"
	cQry	 := ChangeQuery(cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cRGBALS, .F., .T.)
	Count to nTotFuncs
EndIf


Return lContinua

/*/{Protheus.doc} PRDVLDEL
Valida se é Reprocessamento ou Processamento
@author TOTVS Protheus
@since  20/04/2016
@param	cRGBALS = Alias utilizado como base com dados da RGB
@obs   	
@version 1.0
/*/
Static Function PRDVLDEL(cRGBALS)

Local cPeriodo	:= ""

Default cRGBALS := ""

dbSelectArea("SZF")
dbSelectArea("RGB")
SZF->(DbSetOrder(4))

IncProc("Excluindo dados já processados antes de calcular...")
if !Empty(cRGBALS)
	While !(cRGBALS)->(eof())
		cPeriodo:= (cRGBALS)->RGB_PERIOD
		RGB->(dbGoto((cRGBALS)->POSREC))
		RecLock('RGB')
		DbDelete()
		RGB->(MsUnLock())
		(cRGBALS)->(dbSkip())
	EndDo
EndIf

If SZF->(dbSeek(xFilial("SZF")+cPeriodo))
	While !SZF->(EOF()) .And. (SZF->ZF_PERIODO == cPeriodo)
		RecLock('SZF')
		DbDelete()
		SZF->(MsUnLock())
		SZF->(dbSkip())
	EndDo
EndIf


Return
/*/{Protheus.doc} PRDVLTAB
Valida quando a Redução por Atingimento é por Tabela
@author TOTVS Protheus
@since  20/04/2016
@param aRetParam= Parametros preenchidos no parambox
@param aTabU_   = Array que será consumido com os dados da tabela de usuario criada no SIGAGPE
@obs    aRetParam[2] = Período
		aRetParam[3] = Verba de Base
		aRetParam[4] = Consolidado APD
		aRetParam[5] = Redução por Atingimento
		aRetParam[6] = Qual a Tabela
		aRetParam[7] = Quem não tem Metas  
@version 1.0
/*/
Static Function PRDVLTAB(aTabU_,aRetParam)

Local lRet		:= .T.
Local cQry		:= ""
Local cTab		:= "RCCTAB"

if !Empty(cTab)
	
	IncProc("Verificando existência de tabela informada: '" + aRetParam[6] + "'")
	
	cQry	 := "select * from " + RetSqlTab("RCC")+CRLF
	cQry	 += "WHERE RCC_FILIAL = '" + xFilial("RCC") 	+ "' AND " + CRLF
	cQry	 += "RCC_CODIGO LIKE 	'" + aRetParam[6]		+ "' AND " + CRLF
	cQry	 += "RCC_CHAVE  LIKE 	'" + Substr(aRetParam[2],1,TamSx3("RGB_PERIOD")[1])		+ "' AND " + CRLF
	cQry	 += "D_E_L_E_T_ = ''"
	cQry	 := ChangeQuery(cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTab, .F., .T.)
	(cTab)->(dbGotop())
	
	if 	(cTab)->(eof())
		HELP(,,"INCONSISTENCIA",,"Favor verificar se a Tabela escolhida existe/possui registros.",1,0)
		lRet:= .F.
	else
		fCarrTab( @aTabU_, aRetParam[6],StoD(Substr(aRetParam[2],1,TamSx3("RGB_PERIOD")[1])+'01'), .T. )
		If !(valtype(aTabU_[1][5]) == 'N' .and. valtype(aTabU_[1][6]) == 'N' .and. valtype(aTabU_[1][7]) == 'N')
			lRet := .F.
		EndIf 
	EndIF
Else
	lRet:= .F.
EndIF
(cTab)->(dbCloseArea())

Return lRet

/*/{Protheus.doc} PRDVLPRC
Valida se é Reprocessamento ou Processamento
@author TOTVS Protheus
@since  19/04/2016
@param aTabU_   = Array com dados da tabela de usuario criada no SIGAGPE
@param aRetParam= Parametros preenchidos no parambox
@param	cRGBALS = Alias utilizado como base com dados da RGB
@param lRecur = Define se está sendo acionado recursivamente
@param nRedist = Valor a ser redistribuido
@param nBaseIni= Valor atualizado do total  distribuido
@param nBaseTot= Valor atualizado do total inicial a ser distribuido
@obs   	aRetParam[2] = Período
		aRetParam[3] = Verba de Base
		aRetParam[4] = Consolidado APD
		aRetParam[5] = Redução por Atingimento
		aRetParam[6] = Qual a Tabela
		aRetParam[7] = Quem não tem Metas  
@version 1.0
/*/
Static Function PRDVLPRC(aRetParam, aTabU_ ,cRGBALS,lRecur,nRedist,nBaseTot,nBaseIni)

Local nPerc		:= 0
Local nBase		:= 0
Local nNota		:= 0
Local nVlrPLR	:= 0
Local nX		:= 0
Local lReg		:= .F.
Local lInclui	:= .F.

Default lRecur 	:= .F.
Default	nRedist	:= 0
Default nBaseIni:= 0
Default nBaseTot:= 0
Default aTabU_	:= {}

lInclui	:= IIF(!lRecur,.T.,.F.)
dbSelectArea("RGB")
RGB->(dbSetOrder(6))//RGB_FILIAL+RGB_MAT+RGB_PERIOD+RGB_ROTEIR+RGB_SEMANA+RGB_PD
dbSelectArea("SZF")
SZF->(dbSetOrder(3))//ZF_FILIAL+ZF_MAT+ZF_PERIODO+ZF_NUMPAG
dbSelectArea("SZE")
SZE->(dbSetOrder(1))//ZE_FILIAL+ZE_CODRD0+ZE_IDCONS+ZE_GRUPO+ZE_KEY

if lInclui
	IncProc("Calculando...")
else
	IncProc("Calculando..Aplicando a redistribuição...")
EndIf

(cRGBALS)->(dbGotop())
While !(cRGBALS)->(eof())
	nPerc		:= 0
	nBase		:= 0
	nNota		:= 0
	nVlrPLR		:= 0
	lReg		:= .F.
	If lInclui .And. SZE->(dbSeek(xFilial("SZE")+(cRGBALS)->RDZ_CODRD0+aRetParam[4]+"01"))
		While !SZE->(Eof()) .And. (SZE->ZE_FILIAL+SZE->ZE_CODRD0+SZE->ZE_IDCONS+SZE->ZE_GRUPO)==(xFilial("SZE")+(cRGBALS)->RDZ_CODRD0+aRetParam[4]+"01")
			nPerc := SZE->ZE_MEDPARC
			nNota := SZE->ZE_MEDPARC
			lReg	:= .T.
			SZE->(dbSkip())
		EndDo
	EndIf
	
	if lReg
		if aRetParam[5]== 1 //Redução por Atingimento (1=Usar tabela)
			for nX:= 1 to Len(aTabU_)
				if aTabU_[nX][5] <= nPerc .And. aTabU_[nX][6] >= nPerc
					nPerc := aTabU_[nX][7]
					Exit
				EndIf
			Next
		EndIf
		
		nVlrPLR := round(((cRGBALS)->RGB_VALOR * nPerc)/100,2)
		nRedist	+= (cRGBALS)->RGB_VALOR - nVlrPLR
		nBaseIni+= (cRGBALS)->RGB_VALOR
	Else
		if !lRecur
			if aRetParam[7] ==  1 //Quem não tem Metas (1=Zera o PLR;2=Considera 100%)
				nPerc	:= 0
			Else
				nPerc	:= 100
			EndIf
			If nPerc == 0
				nVlrPLR := 0
			ElseIf nPerc == 100
				nVlrPLR := (cRGBALS)->RGB_VALOR
			Else
				nVlrPLR := round(((cRGBALS)->RGB_VALOR * nPerc)/100,2)
			EndIf
			nRedist	+= (cRGBALS)->RGB_VALOR - nVlrPLR
			nBaseIni+= (cRGBALS)->RGB_VALOR
		Endif
	EndIf

	SZF->(dbSeek(xFilial("SZF")+(cRGBALS)->RGB_MAT+(cRGBALS)->RGB_PERIOD+(cRGBALS)->RGB_SEMANA))
	Reclock("SZF",lInclui)
	if lInclui
		SZF->ZF_FILIAL	:= xFilial("SZF")
		SZF->ZF_MAT		:= (cRGBALS)->RGB_MAT
		SZF->ZF_PERIODO	:= (cRGBALS)->RGB_PERIOD
		SZF->ZF_NUMPAG	:= (cRGBALS)->RGB_SEMANA
		SZF->ZF_BASE	:= (cRGBALS)->RGB_VALOR
		SZF->ZF_NOTA	:= nNota
		SZF->ZF_PERCRED := nPerc
		SZF->ZF_CALC1	:= nVlrPLR
	else
		If nBaseIni == nBaseTot
			SZF->ZF_CALC2	:=  SZF->ZF_CALC1
		Else
			nVlrPLR	:=  round( ( nBaseIni * SZF->ZF_CALC1) / nBaseTot, 2 )
			SZF->ZF_CALC2	:=  nVlrPLR
		EndIf
	EndIf
	SZF->(MsUnlock())
	
	If SZF->ZF_CALC2 > 0
		//RGB_FILIAL+RGB_MAT+RGB_PERIOD+RGB_ROTEIR+RGB_SEMANA+RGB_PD
//		RGB->(dbSeek(xFilial("RGB")+(cRGBALS)->RGB_MAT+(cRGBALS)->RGB_PERIOD+(cRGBALS)->RGB_ROTEIR+(cRGBALS)->RGB_SEMANA+cProv))
//		Reclock("RGB",lInclui)
		Reclock("RGB",.t.)
		RGB->RGB_FILIAL :=  xFilial("RGB")
		RGB->RGB_MAT	:= (cRGBALS)->RGB_MAT
		RGB->RGB_PERIOD := (cRGBALS)->RGB_PERIOD
		RGB->RGB_SEMANA := (cRGBALS)->RGB_SEMANA
		RGB->RGB_PROCES	:= (cRGBALS)->RGB_PROCES
		RGB->RGB_PD 	:= cProv
		RGB->RGB_ROTEIR := 'PLR'
		RGB->RGB_TIPO1  := 'V'
		RGB->RGB_TIPO2  := 'G'
		RGB->RGB_CC 	:= (cRGBALS)->RGB_CC
		RGB->RGB_DEPTO	:= (cRGBALS)->RGB_DEPTO
		RGB->RGB_SEQ	:= (cRGBALS)->RGB_SEQ
		RGB->RGB_NUMID	:= (cRGBALS)->RGB_NUMID
		RGB->RGB_CODFUN := (cRGBALS)->RGB_CODFUN
		RGB->RGB_POSTO	:= (cRGBALS)->RGB_POSTO
		RGB->RGB_VALOR	:=  SZF->ZF_CALC2
		
		RGB->(MsUnlock())
	EndIf

	(cRGBALS)->(dbSkip())
EndDo


if !lRecur 
	nBaseTot	:= nBaseIni - nRedist
	lRecur		:= .T.
	PRDVLPRC(aRetParam,aTabU_,cRGBALS,lRecur,nRedist,nBaseTot,nBaseIni)
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fParam
Definicao de Parametros de Processamento
@type function fParam
@author Totvs Protheus
@since  19/04/2016
@version 1.0
//---------------------------------------------------------------------
/*/
Static Function fParam(aRetParam)

Local lParam
Local aParam		:= 	{}
Local cTitulo		:= 'Bônus vinculado a Metas individuais'
Local cNomArq		:= 'GPE001'
Local cTexto  		:= 'Parametros a serem preenchidos'

aAdd(aParam, {9,cTexto,170,40,.T.})//1
aAdd(aParam, {1,"Período PLR (aaaa/mm-np)"	,Space( TamSx3( "RCH_PER" )[1])+Space( TamSx3( "RCH_NUMPAG" )[1]),'@R 9999/99-99', 'U_fRCHPLR()', 'RCHZZZ', "",70, .T.})//2
aAdd(aParam, {1,"Verba de Base"				, CriaVar("RV_COD",.F.), PesqPict("SRV","RV_COD"),	'EXISTCPO("SRV")',	"SRV","", 3, .T.})//2
aAdd(aParam, {1,"Política de Consolidação"	, CriaVar("ZC_CODIGO",.F.), PesqPict("SZC","ZC_CODIGO"), 'EXISTCPO("SZC")',	"SZC", "", 6,.T.})//3
aAdd(aParam, {3,"Redução por Atingimento"	, "3",{"Usar tabela",'Usar resultado exato'},80,"", .T.,"" })//4
aAdd(aParam, {1,"Qual Tabela"				,Space( TamSx3( "RCB_CODIGO" )[1]),'@!', "", 'RCB', "",6, .F.})//5
aAdd(aParam, {3,"Quem não tem Metas"		, "3",{"Zerar o PLR",'Considera 100%'},80,"", .T.,"" })//6

lParam := ParamBox(aParam, cTitulo, aRetParam,,,.T.,,,,cNomArq,.T.,.T. )


Return	lParam


User Function fRCHPLR()
Local lRet   := .f.
Local cChave := xFilial("RCH")+MV_PAR02
RCH->(dbsetorder(9))
If RCh->(dbseek(cChave))
	While RCH->(!eof()) .and. RCH->(RCH_FILIAL+RCH_PER+RCH_NUMPAG) == cChave 
		If RCH->RCH_ROTEIR=="PLR" .AND.  Empty(RCH->RCH_DTINTE) .AND. Empty(RCH->RCH_DTPGAD)
			lRet := .t.
			exit
		EndIf
		RCH->(dbskip())
	EndDo		
EndIf
Return(lRet)