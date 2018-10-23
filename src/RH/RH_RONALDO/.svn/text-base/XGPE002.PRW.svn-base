#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPE002    บ Autor ณ A.Shibao           บ Data ณ  05/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera relatorio com os dados da folha de pagamento p/ ser   บฑฑ
ฑฑบ          ณ enviado para Secretaria de Finan็as                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P12 - PRODAM                                               บฑฑ
ฑฑบA.Shibao  ณ Ajuste para tirar os espacos em brancos do campos          บฑฑ
ฑฑบ          ณ Ajuste para tratar os afastamentos "017/020" que ้ exlucivoบฑฑ
ฑฑบ          ณ para conselherios os demais afastados devem sair normal    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GPE002

Private cString, cPerg, oGeraTxt
Private _cFiltroRA

cPerg       := "RGPE002"
CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( " ** Relat๓rio Secretaria de Finan็as ** " ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL

@ 010, 018 SAY " Este programa ira gerar o arquivo com a folha de pagamento    " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " que serแ enviado para Secretaria de Finan็as                  " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY " Conforme os parametros selecionados.                          " SIZE 200, 007 OF oGeraTxt PIXEL

//DEFINE SBUTTON FROM 070,098 TYPE 5 ENABLE OF oGeraTxt ACTION (fFiltro())
DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณOKGERATXT บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RunCont  บ Autor ณ AP5 IDE            บ Data ณ  17/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function RunCont

Local cLin, nTotReg, nContReg
Local nVenci          := 0 
Local lPula           := .F.
Local lShAfas		  := .F.	

Private nU024a := nU024b := 0
Private nU025a := nU025b := 0
Private nU027  := 0
Private aTabSeg:= aTabPls:= aTabEnc:= {}

Private nHdl
Private cFilDe 		:= cFilAte := cMatDe := cMatAte := ""
Private cSaida      := ""

Pergunte(cPerg,.F.)

cPeriodo   	:= mv_par01
cSaida      := mv_par02  

// Tabela U024 - SEGURO DE VIDA 
fCarrTab(@aTabSeg,"U024", nil)

nU024a		:= Iif(ftabela("U024",1,4) > 0,ftabela("U024",1,4),0)
nU024b		:= Iif(ftabela("U024",1,5) > 0,ftabela("U024",1,5),0)
                                                                                                                                   
If nU024a == 0                                                                  
	Alert("Fator multiplicador da tabela U024 nao cadastrado")
	Return
Endif	

If nU024b == 0                                                                  
	Alert("% a ser aplicado da tabela U024 nao cadastrado")
	Return
Endif	


// Tabela U025 - PLANO DE SAUDE
fCarrTab(@aTabPls,"U025", nil)
nU025a		:= Iif(ftabela("U025",1,4) > 0,ftabela("U025",1,4),0)
nU025b		:= Iif(ftabela("U025",1,5) > 0,ftabela("U025",1,5),0)
                                                                                                                                   
If nU025a == 0                                                                  
	Alert("Fator divisor da tabela U025 nao cadastrado")
	Return
Endif	

If nU025b == 0                                                                  
	Alert("Fator multiplicador da tabela U025 nao cadastrado")
	Return
Endif       


// Tabela U024 - SEGURO DE VIDA 
fCarrTab(@aTabEnc,"U027", nil)

nU027		:= Iif(ftabela("U027",1,4) > 0,ftabela("U027",1,4),0)

If nU027 == 0                                                                  
	Alert("Fator encargos da tabela U027 nao cadastrado")
	Return
Endif	


// Cria Arquivo Texto
MsAguarde( {|| fMtaQuery(cSaida)}, "Processando...", "Selecao de Registros" )

If Select( "RGPE002" ) == 0  
    Alert("Nใo existe movimento na data selecionada")
	Return
EndIf

cSaida := Alltrim(cSaida)+".TXT" // Nome do Arquivo de Saida 

If File(AllTrim(cSaida))	
	FErase(AllTrim(cSaida))	
EndIf

nHdl := FCreate(AllTrim(cSaida),0)  

If nHdl == -1
	MsgAlert("O arquivo de nome "+cSaida+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

nTotReg  := 1
nContReg := 1
dbSelectArea( "RGPE002" )
dbGoTop()
Do While !Eof()
	dbSkip()
	If !Eof()
		nTotReg ++
	EndIf
EndDo

dbGoTop()

ProcRegua( nTotReg )

While !RGPE002->(Eof())
	
	IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
	
	nContReg++
	
	// Diretores tem outros vinculos entao fica como afastado no sistema e nao deve sair, porem os outros tipos de afastamento(doenca trab devem sair.)
	If RGPE002->RA_SITFOLH == "A"
		dbSelecTArea("SR8")
		SR8->(dbSetOrder(2))
		SR8->(dbGoTop())
		                
		If SR8->(dbSeek(xFilial("SR8")+ RGPE002->RA_MAT))
			Do While !SR8->(EOF()) .And. SR8->R8_MAT == RGPE002->RA_MAT
				cPerIni := Substr(DTOS(SR8->R8_DATAINI),1,6)
				cPerFim := Substr(DTOS(SR8->R8_DATAFIM),1,6)
				If ( cPeriodo >= cPerIni .and. Empty(cPerFim) ) .or. ( cPeriodo >= cPerIni .AND. cPeriodo <= cPerFim )    
					If SR8->R8_TIPOAFA  == "017"
						lPula:= .T.
					EndIf	
					If SR8->R8_TIPOAFA  == "020"
						lPula:= .T.				
					Endif	
				EndIf	
				SR8->(dbSkip())	
			Enddo
	    Endif			
			
		If 	lPula	
			RGPE002->(dbSkip())
		Endif

		lShAfas := .T.	
		
	Endif    
	
    // by ashibao 21/05/16 - Conselheiro estar ativo e sem remunera็ใo nao deve sair, solicitacao Carlos Alves.
	//If RGPE002->VENCIMENTOS == 0   .And. RGPE002->Q3_DESCSUM $ "Conselheiro"
	//		RGPE002->(dbSkip())                                         
	//Endif	
	
	//by ashibao 21/05/16 
	// Conselheiro estar ativo e sem remunera็ใo nao deve sair, solicitacao Carlos Alves.	
	// estagiario entrou dia 23/02/16 e o mes de geradao ้ 02/2016 entao este estagiario nao devera ir pois nao recebeu nd.
	If !lShAfas .And. RGPE002->VENCIMENTOS == 0 
		RGPE002->(dbSkip())                                         	
	Endif
		
	cLin := Right(Strzero(0,12)+alltrim(RGPE002->RA_CIC),12)							+ cSep
	cLin += alltrim(RGPE002->RA_NOMECMP)	  		 									+ cSep
	cLin += alltrim(RGPE002->Q3_DESCSUM)											 	+ cSep
	cLin += alltrim(RGPE002->CTT_DESC01)			 									+ cSep                                            
	
	cLin += substr(RGPE002->RA_ADMISSA,7,2)+ "/" + substr(RGPE002->RA_ADMISSA,5,2)+ "/" + substr(RGPE002->RA_ADMISSA,1,4)+ cSep
	cLin += substr(RGPE002->RA_NASC,7,2)   + "/" + substr(RGPE002->RA_NASC,5,2)   + "/" + substr(RGPE002->RA_NASC,1,4)   + cSep
	
	// Vencimentos
	nVenci:= RGPE002->VENCIMENTOS - RGPE002->DESCONTOS - RGPE002->DESC132
	If nVenci > 0 
		cLin += alltrim(strtran(Transform(nVenci,"@E 999,999,999.99"),".",""))  + cSep	
	Else                     
		cLin += alltrim(strtran(Transform(0,"@E 999,999,999.99"),".",""))       + cSep		
	Endif

	// Encargos	
	nEncar:= RGPE002->ENCARGOS * (nU027 / 100) + RGPE002->FGTS
	If nEncar > 0                                               
		cLin += alltrim(strtran(Transform(nEncar,"@E 999,999,999.99"),".",""))  + cSep	
	Else
		cLin += alltrim(strtran(Transform(0,"@E 999,999,999.99"),".",""))       + cSep		
	Endif
	
	// Beneficios
	// Regra seguro de vida que deve ser som
	If (RGPE002->RA_MAT >= "800000" .And. RGPE002->RA_MAT <= "899999") .OR. (RGPE002->RA_CATFUNC $ "AP")
		nSegur:= 0
	Else
		//nSegur:= nU024a * RGPE002->RA_SALARIO * (nU024b/100)	
		nSegur:= RGPE002->BASESEGVIDA
	Endif	
	
	
	// Regra Plano de saude que deve ser somado na coluna beneficios
	nPlano:= RGPE002->PLANO / nU025a * nU025b 
	

	nBenef:= RGPE002->BENEFICIOS + nSegur + nPlano
	
	cLin += alltrim(strtran(Transform(nBenef    ,"@E 999,999,999.99"),".",""))    + cSep
	
	If RGPE002->RA_DEMISSA >= mv_par01 + "01" 
		cLin += "60"   		 						   			+ cSep	
	Else	 
		cLin += RGPE002->RA_XVINCUL			 		            + cSep
    Endif
    
	If RGPE002->RA_XLIMINA $ "1/2/3"
		cLin += alltrim(RGPE002->RA_XLIMINA + ":" + RGPE002->RA_XNUMPRO) + cSep	
    Else
		cLin += "0"						                         + cSep	
	Endif    

	cLin += RGPE002->RA_XDETVIN	+ cSep

	cLin += "0"			 	   // + cSep  // outras remuneracoes

	cLin += cEol

//cLinOld := cLin

	fGravaTxt( cLin )
 
	
	lPula           := .F.
    lShAfas		  := .F.
	
	RGPE002->(dbSkip())
	
EndDo

RGPE002->(dbCloseArea())

fClose( nHdl )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณMicrosiga           บ Data ณ  07/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTATGPR01                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMtaQuery(cSaida)

Local cQuery    := ""
Local cArqPesq	:= ""

cQuery := " SELECT RA_MAT, RA_NOME, RA_CIC, RA_NOMECMP, RA_SALARIO, RA_DEMISSA, RA_SITFOLH, RA_CARGO, Q3_DESCSUM, CTT_DESC01, "
cQuery += "  RA_ADMISSA, RA_NASC, RA_XVINCUL, RA_XLIMINA, RA_XNUMPRO, RA_XDETVIN, RA_CATFUNC, "

// -- Vencimentos
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "  
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "                                                   
cQuery += "    AND RD_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' "  
cQuery += "    AND RV_XSECFIN = 'V')) as VENCIMENTOS, "                              

// -- Descontos
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "  
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "                                                   
cQuery += "    AND RD_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' "  
cQuery += "    AND RV_XSECFIN = 'D')) as DESCONTOS, "                              

// -- DESC132
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "  
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  AND RD_ROTEIR = '132'  "                                                   
cQuery += "    AND RD_PD IN ('505')) as DESC132, "  

// -- Encargos
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "                                                   
cQuery += "    AND RD_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RV_XSECFIN = 'E')) as ENCARGOS, " 

// -- FGTS
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "
cQuery += "    AND RD_PD IN ('855','854')) as FGTS, "                                                  

// -- Beneficios 
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "
cQuery += "    AND RD_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RV_XSECFIN = 'B')) as BENEFICIOS, "                              

// -- Plano de Saude
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "
cQuery += "    AND RD_PD IN ('523','527','691','511','512','513','514','515','516','524','694')) as PLANO, "                              

// -- Base Seguro de Vida
cQuery += "   (SELECT SUM(RD_VALOR) FROM "+ RetSqlName("SRD") + " WHERE D_E_L_E_T_ <> '*' "
cQuery += "    AND RD_DATARQ = '" + cPeriodo + "' AND RD_MAT = RA_MAT  "
cQuery += "    AND RD_PD IN ('950')) as BASESEGVIDA "        

cQuery += "   FROM "+ RetSqlName("SRA") + " RA"
//cQuery += "   INNER JOIN SRJ010 RJ on (RJ_FUNCAO = RA_CODFUNC) "
cQuery += "   INNER JOIN CTT010 CTT on (CTT_CUSTO = RA_CC)"
cQuery += "   INNER JOIN SQ3010 SQ3 on (Q3_CARGO = RA_CARGO) AND SQ3.D_E_L_E_T_ = ''"


cQuery += "   WHERE RA.D_E_L_E_T_ <> '*'"
//cQuery += "   AND RJ.D_E_L_E_T_ <> '*'"
cQuery += "   AND CTT.D_E_L_E_T_ <> '*'"
cQuery += "   AND ( RA_DEMISSA = '' OR RA_DEMISSA >= '"+ mv_par01+ "') "
cQuery += "   AND  RA_ADMISSA <= '" + mv_par01 + alltrim(str(f_ultdia(stod( mv_par01 + "01")))) + "' "
//cQuery += "   GROUP RA_MAT, RA_NOME, RA_CIC, RA_NOMECMP, RA_SALARIO, RA_DEMISSA, RA_SITFOLH, RA_CARGO, Q3_DESCSUM, CTT_DESC01, RA_ADMISSA, RA_NASC, RA_XVINCUL, RA_XLIMINA, RA_XNUMPRO
cQuery += "   ORDER BY RA_NOME "

	//Memowrite(cSaida,cQuery)

TCQuery cQuery New Alias "RGPE002"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGravaTxt บ Autor ณ Totvs              บ Data ณ  05/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do progrma principal                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บ Autor ณ Microsiga          บ Data ณ  09/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณObjetivo desta funcao e verificar se existe o grupo de      บฑฑ
ฑฑบ          ณperguntas, se nao existir a funcao ira cria-lo.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณcPerg -> Nome com  grupo de perguntas em questใo.           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSx1(cPerg)

Local aHelp := {}

PutSx1(cPerg,"01","Periodo AAAAMM? "     ,"","","mv_ch1","C",06,00,00,"G",""                       ,""   ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Local de Gravacao  ?" ,"","","mv_ch2","C",35,00,00,"G","naovazio"               , ""  ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","")

Return Nil                                                                            


/*
 SELECT RA_NOME, RA_MAT, RA_CIC, RA_NOMECMP, RA_SALARIO, RA_DEMISSA, RA_SITFOLH, RA_CARGO, Q3_DESCSUM, CTT_DESC01, RA_ADMISSA, RA_NASC, RA_XVINCUL, RA_XLIMINA, RA_XNUMPRO,
(SELECT SUM(RD_VALOR) FROM SRD010 WHERE D_E_L_E_T_ <> '*' AND RD_DATARQ = '201606' AND RD_MAT = RA_MAT AND RD_PD IN
(SELECT RV_COD FROM SRV010 WHERE D_E_L_E_T_ <> '*' AND RV_XSECFIN = 'V')) as VENCIMENTOS,
(SELECT SUM(RD_VALOR) FROM SRD010 WHERE D_E_L_E_T_ <> '*' AND RD_DATARQ = '201606' AND RD_MAT = RA_MAT AND RD_PD IN
(SELECT RV_COD FROM SRV010 WHERE D_E_L_E_T_ <> '*' AND RV_XSECFIN = 'E')) as ENCARGOS,
(SELECT SUM(RD_VALOR) FROM SRD010 WHERE D_E_L_E_T_ <> '*' AND RD_DATARQ = '201606' AND RD_MAT = RA_MAT AND RD_PD IN ('855')) as FGTS,
(SELECT SUM(RD_VALOR) FROM SRD010 WHERE D_E_L_E_T_ <> '*' AND RD_DATARQ = '201606' AND RD_MAT = RA_MAT AND RD_PD IN
(SELECT RV_COD FROM SRV010 WHERE D_E_L_E_T_ <> '*' AND RV_XSECFIN = 'B')) as BENEFICIOS,
(SELECT SUM(RD_VALOR) FROM SRD010 WHERE D_E_L_E_T_ <> '*' AND RD_DATARQ = '201606' AND RD_MAT = RA_MAT AND RD_PD IN ('523','527','691','511','512','513','514','515','516','524','694')) as PLANO
 FROM SRA010 RA INNER JOIN CTT010 CTT on (CTT_CUSTO = RA_CC)
 INNER JOIN SQ3010 SQ3 on (Q3_CARGO = RA_CARGO)
 WHERE RA.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND ( RA_DEMISSA = '' OR RA_DEMISSA >= '201606') AND  RA_ADMISSA <= '20160630'
 GROUP BY RA_NOME, RA_MAT, RA_CIC, RA_NOMECMP, RA_SALARIO, RA_DEMISSA, RA_SITFOLH, RA_CARGO, Q3_DESCSUM, CTT_DESC01, RA_ADMISSA, RA_NASC, RA_XVINCUL, RA_XLIMINA, RA_XNUMPRO
 ORDER BY RA_NOME
 */
 