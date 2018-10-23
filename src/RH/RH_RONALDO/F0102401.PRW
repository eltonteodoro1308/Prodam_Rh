#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

//======================================================================================================================
/*/{Protheus.doc} F0102401
CALCULO DO EXTRATO DO PROCESSO TRABALHISTA

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     Nil
@menu		Calc.Extrato do Processo

/*/
//======================================================================================================================

User Function F0102401 

Local cAliasQry := GetNextAlias()
Local cAliasREL	:= ""
Local cAliasREO	:= ""
Local cAliasPA3	:= ""
Local aArea 	:= GetArea()
Local nVlAcao	:= 0
Local nVlCor	:= 0
Local nCont		:= 0
Local nCdDRec	:= 1
Local cTipo		:= ""
Local cMesAno	:= ""
Local cQuery    := ""
Local cCdPleit	:= ""
Local cCdDRec	:= ""
Local cRecnREO	:= ""
Local lRet		:= .F.

Private cPerg   := "APTX001"
Private cProvar := MV_PAR01  // Processo
Private nIndice := MV_PAR02  // Indice
Private nRecalc	:= MV_PAR03  // Recalcula

CriaSX1(cPerg)     


lRet := Pergunte( cPerg , .T. )

If lRet
		
	// Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeSqlExpr(cPerg) 
	
	cProvar:= "%" + MV_PAR01 + "%"
	
	nIndice:= MV_PAR02
	
	
	If !Empty(Alltrim(MV_PAR01))
			
		//============================================
		// Seleciona processos
		//============================================
		cQuery := "	SELECT "
		cQuery += "	RE0.RE0_FILIAL, RE0.RE0_NUM, RE0.RE0_DTPROC, RE0.RE0_TPACAO,  RE0.RE0_RECLAM, "
		cQuery += " RE0.RE0_VLRCSA, RE0.RE0_XVLEXT, RE0.R_E_C_N_O_ "
		cQuery += " FROM " + RetSqlName("RE0") + " RE0 	      "
		cQuery += " WHERE "
		cQuery += "	RE0.RE0_FILIAL = '" +xFilial("RE0")+ "' "
		cQuery += " AND RE0.D_E_L_E_T_ = '  ' "	
		cQuery += " AND " + MV_PAR01 + "" 
	
		cQuery :=  ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .T., .T.)
		
		If (cAliasQry)->(!Eof())	
			While (cAliasQry)->(!Eof())	
				cMesAno:= AnoMes(Date())
				cProces := (cAliasQry)->RE0_NUM
		
				DbSelectArea("PA3")
				PA3->(DbSetOrder(1)) //Filial+Processo
				
				If	PA3->(DbSeek(xFilial("PA3")+cProces+"1"+cMesAno))
					nVlAcao:= PA3->PA3_XVLATU
					nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
				
					//============================================
					// Atualiza Extrato na PA3 do Process
					//============================================
	   				RecLock("PA3",.F.)	
					PA3->PA3_XVLCOR	:= nVlCor
					PA3->PA3_XINDIC	:= nIndice
					PA3->(MsUnlock())		
				
					// Atualiza Valor Corrigido da RE0
					AtualExt(cProces, "1", nVlCor, " ")	
				
					//============================================
					// Insere outro Extrato na PA3 Processo
					//============================================
				ElseIf PA3->(DbSeek(xFilial("PA3")+cProces+"1")) .AND. PA3->PA3_XPERCA <> cMesAno
				
					// Seleciona os Processos do Extrato
					cAliasPA3:= SelecTab("PA3", cProces, "1", "")
				
					If (cAliasQry)->(!Eof())	
						nVlAcao:= (cAliasPA3)->PA3_XVLCOR
						nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
						RecLock("PA3",.T.)	
						PA3->PA3_FILIAL	:= FwXFilial("PA3")
						PA3->PA3_XCDPRO	:= cProces
						PA3->PA3_XTPCOR	:= "1"
						PA3->PA3_XVLATU	:= nVlAcao
						PA3->PA3_XVLCOR	:= nVlCor
						PA3->PA3_XPERCA	:= cMesAno
						PA3->PA3_XINDIC	:= nIndice
						PA3->(MsUnlock())
					
						// Atualiza Valor Corrigido da RE0
						AtualExt(cProces, "1", nVlCor, " ")	
					EndIf	
						//============================================
						// Insere Primeiro Extrato na PA3 PLEITO
						//============================================
				ElseIf !PA3->(DbSeek(xFilial("PA3")+cProces+"1")) 
					nVlAcao:= (cAliasQry)->RE0_VLRCSA
					nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
				
					RecLock("PA3",.T.)	
					PA3->PA3_FILIAL	:= FwXFilial("PA3")
					PA3->PA3_XCDPRO	:= cProces
					PA3->PA3_XTPCOR	:= "1"
					PA3->PA3_XVLATU	:= nVlAcao
					PA3->PA3_XVLCOR	:= nVlCor
					PA3->PA3_XPERCA	:= cMesAno
					PA3->PA3_XINDIC	:= nIndice
					PA3->(MsUnlock())
				
					// Atualiza Valor Corrigido da RE0
					AtualExt(cProces, "1", nVlCor, " ")
				EndIf
				// Seleciona os Pleitos do Processo
				cAliasREL:= SelecTab("REL", cProces, "2", "")
				If (cAliasREL)->(!Eof())	
					While (cAliasREL)->(!Eof())	
						cCdPleit:= (cAliasREL)->REL_CODPLT
					
						DbSelectArea("PA3")
						PA3->(DbSetOrder(2)) // FILIAL+XCDPRO+XTPCOR+XCDPLE+XPERCA  
						If PA3->(DbSeek(xFilial("PA3")+cProces+"2"+cCdPleit+cMesAno))
							nVlAcao:= PA3->PA3_XVLATU
							nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
							RecLock("PA3",.F.)	
							PA3->PA3_XVLCOR	:= nVlCor
							PA3->PA3_XINDIC	:= nIndice
							PA3->(MsUnlock())
						ElseIf PA3->(DbSeek(xFilial("PA3")+cProces+"2"+cCdPleit)) .AND. PA3->PA3_XPERCA <> cMesAno				
							// Seleciona os Processos do Extrato
							cAliasPA3:= SelecTab("PA3", cProces, "2", cCdPleit)			
							If (cAliasPA3)->(!Eof())			
								nVlAcao:= PA3->PA3_XVLCOR
								nVlCor := nVlAcao + nVlAcao *(nIndice / 100)		
								RecLock("PA3",.T.)	
								PA3->PA3_FILIAL	:= FwXFilial("PA3")
								PA3->PA3_XCDPRO	:= cProces
								PA3->PA3_XTPCOR	:= "2"
								PA3->PA3_XVLATU	:= nVlAcao
								PA3->PA3_CHVFIL := cCdPleit
								PA3->PA3_XVLCOR	:= nVlCor
								PA3->PA3_XPERCA	:= cMesAno
								PA3->PA3_XINDIC	:= nIndice
								PA3->(MsUnlock())
							EndIf
						ElseIf !PA3->(DbSeek(xFilial("PA3")+cProces+"2"+cCdPleit))
							nVlAcao:= (cAliasREL)->REL_VALPLT
							nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
						
							RecLock("PA3",.T.)	
							PA3->PA3_FILIAL	:= FwXFilial("PA3")
							PA3->PA3_XCDPRO	:= cProces
							PA3->PA3_XTPCOR	:= "2"
							PA3->PA3_XVLATU	:= nVlAcao
							PA3->PA3_CHVFIL := cCdPleit
							PA3->PA3_XVLCOR	:= nVlCor
							PA3->PA3_XPERCA	:= cMesAno
							PA3->PA3_XINDIC	:= nIndice
							PA3->(MsUnlock())
						EndIf	
						// Atualiza Valor do Pleito
						AtualExt(cProces, "2", nVlCor, cCdPleit)
						(cAliasREL)->(DbSkip())	
					EndDo
				EndIf
			
				// Seleciona Depósito Recursivo
				cAliasREO:= SelecTab("REO", cProces, "3", "")
			
				If (cAliasREO)->(!Eof())	
					While (cAliasREO)->(!Eof())	
						cCdDRec := StrZero(nCdDRec,6)
						cRecnREO:= (cAliasREO)->R_E_C_N_O_
						
						DbSelectArea("PA3")
						PA3->(DbSetOrder(1)) // PA3_FILIAL+PA3_XCDPRO+PA3_XTPCOR+PA3_XPERCA    
						If PA3->(DbSeek(xFilial("PA3")+cProces+"3"+cMesAno)) .AND. PA3->PA3_CHVFIL == cCdDRec
							nVlAcao:= PA3->PA3_XVLATU
							nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
							RecLock("PA3",.F.)	
							PA3->PA3_XVLCOR	:= nVlCor
							PA3->PA3_XINDIC	:= nIndice
							PA3->(MsUnlock())
							nCdDRec:= nCdDRec + 1
						ElseIf PA3->(DbSeek(xFilial("PA3")+cProces+"3")) .AND. PA3->PA3_XPERCA <> cMesAno 
				
							// Seleciona os Processos do Extrato
							cAliasPA3:= SelecTab("PA3", cProces, "3", cCdDRec)
					
							If (cAliasPA3)->(!Eof())
								nVlAcao:= PA3->PA3_XVLCOR
								nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
								RecLock("PA3",.T.)	
								PA3->PA3_FILIAL	:= FwXFilial("PA3")
								PA3->PA3_XCDPRO	:= cProces
								PA3->PA3_XTPCOR	:= "3"
								PA3->PA3_XVLATU	:= nVlAcao
								PA3->PA3_CHVFIL := cCdDRec
								PA3->PA3_XVLCOR	:= nVlCor
								PA3->PA3_XPERCA	:= cMesAno
								PA3->PA3_XINDIC	:= nIndice
								PA3->(MsUnlock())
								nCdDRec:= nCdDRec + 1
							EndIf
					
						ElseIf !PA3->(DbSeek(xFilial("PA3")+cProces+"3"))
				
							nVlAcao:= (cAliasREO)->REO_XDPREC
							nVlCor := nVlAcao + nVlAcao *(nIndice / 100)
							RecLock("PA3",.T.)	
							PA3->PA3_FILIAL	:= FwXFilial("PA3")
							PA3->PA3_XCDPRO	:= cProces
							PA3->PA3_XTPCOR	:= "3"
							PA3->PA3_XVLATU	:= nVlAcao
							PA3->PA3_CHVFIL := cCdDRec
							PA3->PA3_XVLCOR	:= nVlCor
							PA3->PA3_XPERCA	:= cMesAno
							PA3->PA3_XINDIC	:= nIndice
							PA3->(MsUnlock())
							nCdDRec:= nCdDRec + 1
						EndIf	
						// Atualiza Valor Deposito
						AtualExt(cProces, "3", nVlCor, cRecnREO)
						(cAliasREO)->(DbSkip())	
					EndDo
				EndIf
				(cAliasQry)->(DbSkip())	
			EndDo
				Help( "Processamento do Extrato realizado com Sucesso! ","Processamento do Extrato" ,,0) 
				RestArea(aArea)
				Return(.T.) 
		Else
			Help( "F0102401",1 , "Não existe registro com os parâmetros informados. ",,0) 
			RestArea(aArea)
			Return(.F.) 
		EndIf   
	Else
		Help( "F0102401",1 , "Necessário informar um número de processo. ",,0) 
		RestArea(aArea)
		Return(.F.) 
	EndIf   
EndIf

RestArea(aArea)

Return lRet
    
//==========================================================================================
/*/{Protheus.doc} CriaSX1()
CRIA AS PERGUNTAS PARA O CALCULO

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     Nil
@param      cPerg // Parametros para a geração do relatório - processamento do extrato
/*/
//==========================================================================================   
        
Static Function CriaSX1(cPerg)
  
Local aRegs     := {}
Local aHelp     := {}
Local aHelpE    := {}
Local aHelpI    := {}   
Local cHelp     := ""

//============================================
// PROCESSO
//============================================
aHelp := { "Informe intervalo de Processos que ",;
           "deseja considerar para impressao do ",;
           "relatorio." }
aHelpE:= { "Informe intervalo de Processos que ",;
           "desea considerar para impresion del ",;
           "informe." }
aHelpI:= { "Enter registration range Process to be ",;
           "considered for printing the report." }
cHelp := ".APTPROCESS."

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)    

//          Grupo     Ordem Pergunta Portugues  Pergunta Espanhol  Pergunta Ingles  Variavel   Tipo  Tamanho Decimal Presel  GSC   Valid   Var01        Def01 DefSPA1  DefEng1  Cnt01     Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3     GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp
Aadd(aRegs,{"APTX001","01","Processo ?",       "¿Processo ?",     "Processo ?",     "MV_CH1",  "C",  99,     0,      0,      "R",   "",    "MV_PAR01",  "",   "",      "",     "RE0_NUM",  "",    "",   "",     "",     "",   "",   "",    "",      "",      "",   "",   "",   "",     "",     "",    "",    "",    "",     "",     "",    "RE0",  "",     "N",  aHelp,   aHelpI,  aHelpE,  cHelp})

//============================================
// INDICE
//============================================
aHelp := { "Informe o Indice que será utilizado ",;
           "para o calculo do relatório." }
aHelpE:= { "Informe o Indice que será utilizado ",;
           "para o calculo do relatório." }
aHelpI:= {"Informe o Indice que será utilizado ",;
           "para o calculo do relatório." }
cHelp := ".APTINDICE."

PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)    

//          Grupo     Ordem Pergunta Portugues  Pergunta Espanhol  Pergunta Ingles  Variavel  Tipo  Tamanho Decimal Presel  GSC   Valid   Var01        Def01 DefSPA1  DefEng1  Cnt01      Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3     GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp
Aadd(aRegs,{"APTX001","02", "Indice ?",         "¿Indice ?",       "Indice ?",      "MV_CH2", "N",  18,     9,      0,      "G",   "",    "MV_PAR02",  "",   "",      "",       "",        "",    "",   "",     "",     "",   "",   "",    "",      "",      "",   "",   "",   "",     "",     "",    "",    "",    "",     "",     "",    "",     "",     "N",  aHelp,   aHelpI,  aHelpE,  cHelp})

ValidPerg(aRegs,cPerg,.T.)

Return Nil


//==========================================================================================
/*/{Protheus.doc} AtualExt

GRAVA EXTRATO DO PROCESSO, PLEITO E DEP. RECURSIVO NO PROCESSO

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     Nil
@param		cProces, cTipo, nVlCor, cCodPlei // Número do processo, Tipo(Processo, Pleito e Recursivo) Valor Corrigido e Número do Pleito

/*/
//==========================================================================================   

Static Function AtualExt(cProces, cTipo, nVlCor, cCodPlei)

Local lRet:= .T.


If cTipo == "1"
	//============================================
	// Atualiza Valor Corrigido do Processo na RE0  
	//============================================
	DbSelectArea("RE0")
	RE0->(DbSetOrder(1)) //Filial+Processo
	If	RE0->(DbSeek(xFilial("RE0")+cProces))
		RecLock("RE0",.F.)	
		RE0->RE0_XVLEXT := nVlCor
		RE0->(MsUnlock())
	Else 
		lRet:= .T.	
	EndIf
ElseIf cTipo == "2"	
	//============================================
	// Atualiza Valor Corrigido do Pleito na REL 
	//============================================
	DbSelectArea("REL")
	REL->(DbSetOrder(1)) //Filial+Processo+Pleito
	If	REL->(DbSeek(xFilial("REL")+cProces+cCodPlei))
		RecLock("REL",.F.)	
		REL->REL_VLRCOR := nVlCor
		REL->(MsUnlock())
	EndIf
ElseIf cTipo == "3"
	//============================================
	// Atualiza Valor Corrigido do Dep. Recursivo
	//============================================
	DbSelectArea("REO")
	REO->(DbSetOrder(1)) //Filial+Processo+
	
	REO->(DbGoTo(cCodPlei)) 
	RecLock("REO",.F.)	
	REO->REO_XDPCOR := nVlCor
	REO->(MsUnlock())
EndIf			

Return

//==========================================================================================
/*/{Protheus.doc} SelecTab

SELECT DAS TABELAS

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     cAliasTb
@param		cTab, cProces, cTipo, cCdPlei // Tabela, Número do Processo, Tipo do Processo e Código do Pleito

/*/
//==========================================================================================   

Static Function SelecTab(cTab, cProces, cTipo, cCdPlei ) 

Local cQuery	:= ""
Local cAliasTb	:= GetNextAlias()
Local aAreaTab 	:= GetArea()

// Seleciona os Pleitos do Processo
If cTab == "REL"
	cQuery := " SELECT "
	cQuery += " REL.REL_FILIAL, REL.REL_PRONUM, REL.REL_CODPLT, REL.REL_XVLEXT,  "
	cQuery += " REL.REL_VALPLT "
	cQuery += " FROM " + RetSqlName("REL") + " REL "
	cQuery += " WHERE "
	cQuery += " REL.REL_FILIAL = '" +xFilial("REL")+ "'  "
	cQuery += " AND REL.D_E_L_E_T_ = '  ' "	
	cQuery += " AND REL.REL_PRONUM = '" + cProces + "'"

	cQuery :=  ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTb, .T., .T.)
// Seleciona Depósitos Recursivos
ElseIf cTab == "REO"	
	cQuery := " SELECT "
	cQuery += " REO.REO_FILIAL, REO.REO_PRONUM, REO.REO_TIPO, REO.REO_XDPREC,  "
	cQuery += " REO.REO_XDPCOR, REO.R_E_C_N_O_ "
	cQuery += " FROM " + RetSqlName("REO") + " REO "
	cQuery += " WHERE "
	cQuery += " REO.REO_FILIAL = '" +xFilial("REO")+ "'  "
	cQuery += " AND REO.D_E_L_E_T_ = '  ' "	
	cQuery += " AND REO.REO_PRONUM = '" + cProces + "'"
	cQuery += " AND REO.REO_TIPO =  'DEP' "
	
	cQuery :=  ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTb, .T., .T.)
// Seleciona Extrato da PA3
ElseIf cTab == "PA3"
	cQuery := " SELECT "
	cQuery += " PA3.PA3_FILIAL, PA3.PA3_XCDPRO, PA3.PA3_XTPCOR, PA3.PA3_XVLATU, PA3.PA3_XPERCA, "
	cQuery += " PA3.PA3_XVLCOR, PA3.PA3_CHVFIL, PA3.PA3_XINDIC, PA3.R_E_C_N_O_  "
	cQuery += " FROM " + RetSqlName("PA3") + " PA3 "
	cQuery += " WHERE "
	cQuery += " PA3.PA3_FILIAL = '" +xFilial("PA3")+ "'  "
	cQuery += " AND PA3.D_E_L_E_T_ = '  ' "	
	cQuery += " AND PA3.PA3_XCDPRO = '" + cProces + "'"
	If cTipo == "1"
		cQuery += " AND PA3.PA3_XTPCOR =  '1' "
	EndIf
	If cTipo == "2"
		cQuery += " AND PA3.PA3_XTPCOR =  '2' "
		cQuery += " AND PA3.PA3_CHVFIL = '" + cCdPlei + "'"
	EndIf
	If cTipo == "3"
		cQuery += " AND PA3.PA3_XTPCOR =  '3' "
		cQuery += " AND PA3.PA3_CHVFIL = '" + cCdPlei + "'"
	EndIf
	cQuery += " ORDER BY PA3.PA3_XPERCA ASC "
	
	cQuery :=  ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTb, .T., .T.)
	
 EndIf
	RestArea(aAreaTab)
Return (cAliasTb)