#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

//======================================================================================================================
/*/{Protheus.doc} F0102402
GERA RELATÓRIO DE EXTRATO DO PROCESSO

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@menu		Rel.Extrato do Processo
@return     Nil

/*/
//======================================================================================================================

User Function F0102402 

Local aArea     	:= GetArea()
local cAlias 		:= getNextAlias()
Local lRet			:= .F.
Local oReport	
Private lWrapText 	:= .T.
Private aOrd 		:= {"PROCESSO"}
Private cPerg     	:= "APTX002"

CriaSX1(cPerg)     

lRet := Pergunte( cPerg , .T. )

If lRet
	  // INTERFACE DE IMPRESSÃO
    oReport := ReportDef(cAlias, cPerg)
    oReport :PrintDialog()
EndIf

RestArea(aArea)

Return ()

//======================================================================================================================
/*/{Protheus.doc} ReportDef
RELATÓRIO REAJUSTE PROCESSO TRABALHISTA

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     oReport
@param		cAlias, cPerg // Parametros para geração do relatório - processamento do extrato

/*/
//======================================================================================================================

Static Function ReportDef(cAlias, cPerg)

Local oReport	:= Nil
Local oSection	:= Nil
Local oSection1 := Nil
Local oSection2 := Nil
Local oSection3 := Nil
Local oCell1	:= Nil
Local cTitulo   := "EXTRATO DE CORREÇÃO DE PROCESSO TRABALHISTA"
local cHelp   	:= "Processa e Gera relatório do Extrato dos Processos."
Local CTitRept  := "F0102401"
Local cStrRE0  	:= "RE0"
Local cStrPA3 	:= "PA3"
local oBreak1                                  
    
oReport:= TReport():New('F0102401',cTitulo,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:ShowHeader()
//============================================
// CABEÇALHO
//============================================
oSection := TRSection():New(oReport,"DADOS DO PROCESSO",{"RE0", "PA3"},aOrd)    
oSection:ShowHeader()
TRCell():New(oSection,"RE0_NUM", 	"RE0", "PROCESSO: ") 	
TRCell():New(oSection,"RE0_DESCR",  "RE0", "DESCRIÇÃO: ")    	
TRCell():New(oSection,"RE0_TPACAO", "RE0", "TIPO AÇÃO: ")		
TRCell():New(oSection,"RE0_RECLAM", "RE0", "CÓDIGO: ") 
TRCell():New(oSection,"RD0_NOME",   "RDO", "RECLAMANTE: ",PESQPICT("RD0","RD0_NOME"),,,{|| Posicione("RD0",1,xFilial("RD0")+ RE0->RE0_RECLAM , "RD0_NOME")},) 
TRCell():New(oSection,"RE0_DTPROC", "RE0", "DATA DA AÇÃO: ")    
//TRCEll():New( oSection,/*cName*/,/*cAlias*/,/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*{|| bBlock }*/,/*cAlign*/,.T.,/* cHeaderAlign*/,/*;lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

//============================================
// EXTRATO DO VALOR DO PROCESSO  
//============================================
oSection1 := TRSection():New(oSection, "CORREÇÃO VALOR CAUSA",{"PA3"},aOrd)
oSection1:ShowHeader()
TRCell():New(oSection1, "PA3_XVLATU", "PA3", "SALDO INCIAL") 	
TRCell():New(oSection1, "PA3_XPERCA", "PA3", "MÊS / ANO",,,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1, "PA3_XVLCOR", "PA3", "VALOR CORRIGIDO")
TRCell():New(oSection1, "PA3_XINDIC", "PA3", "INDICE")      	
oSection1:SetLeftMargin(12)

//============================================
// EXTRATO DOS PLEITOS  
//============================================
oSection2 := TRSection():New(oSection, "CORREÇÃO VALOR PLEITO",{"PA3"}, aOrd)
oSection2:ShowHeader()
TRCell():New(oSection2, "PA3_CHVFIL", "PA3", "VERBA")		
TRCell():New(oSection2, "REL_DESCR",  "REL", "DESCRIÇÃO",PESQPICT("REL","REL_DESCR"),,,{|| Posicione("REL",1,xFilial("REL")+ PA3->PA3_CHVFIL , "REL_DESCR")},) 
TRCell():New(oSection2, "PA3_XVLATU", "PA3", "SALDO INICIAL")
TRCell():New(oSection2, "PA3_XPERCA", "PA3", "MÊS / ANO",,,,,"RIGHT",,"RIGHT")
TRCell():New(oSection2, "PA3_XVLCOR", "PA3", "VALOR CORRIGIDO")	
TRCell():New(oSection2, "PA3_XINDIC", "PA3", "INDICE")      	
oSection2:SetLeftMargin(12)                           

//============================================
// EXTRATO DOS DEPÓSITO RECURSIVO 
//============================================
oSection3 := TRSection():New(oSection, "CORREÇÃO VALOR DEPÓSITO RECURSIVO", {"PA3"}, aOrd)
oSection3:ShowHeader()
TRCell():New(oSection3, "PA3_CHVFIL", "PA3", "RECURSO")	
TRCell():New(oSection3, "PA3_XVLATU", "PA3", "DEPÓSITO") 
TRCell():New(oSection3, "PA3_XPERCA", "PA3", "MÊS / ANO",,,,,"RIGHT",,"RIGHT")		
TRCell():New(oSection3, "PA3_XVLCOR", "PA3", "VALOR CORRIGIDO")
TRCell():New(oSection3, "PA3_XINDIC", "PA3", "INDICE")
oSection3:SetLeftMargin(12)

oSection:SetPageBreak(.T.)

Return oReport 

//======================================================================================================================
/*/{Protheus.doc} ReportPrint()
QUERY DE IMPRESSÃO DO RELATÓRIO

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     Nil
@param      oReport
/*/
//======================================================================================================================

Static Function ReportPrint(oReport)


Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local cAliasPA3 := GetNextAlias()
Local aArea     := GetArea()
Local aAreaPA3 	:= GetArea()
Local cProces	:= ""

Private oSection  := oReport:Section(1)
Private oSection1 := oReport:Section(1):Section(1)
Private oSection2 := oReport:Section(1):Section(2)
Private oSection3 := oReport:Section(1):Section(3)

Private nOrdem  := oSection3:GetOrder()

// Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
MakeSqlExpr(cPerg) 

//If !Empty(Alltrim(MV_PAR01))
		
	//============================================
	// Seleciona processos
	//============================================
	cQuery := "	SELECT "
	cQuery += "	RE0.RE0_FILIAL, RE0.RE0_NUM, RE0.RE0_DTPROC, RE0.RE0_TPACAO,  RE0.RE0_RECLAM, "
	cQuery += " RE0.RE0_VLRCSA, RE0.RE0_VLRCOR, RE0.R_E_C_N_O_ "
	cQuery += " FROM " + RetSqlName("RE0") + " RE0 	      "
	cQuery += " WHERE "
	cQuery += "	RE0.RE0_FILIAL = '" +xFilial("RE0")+ "' "
	cQuery += " AND RE0.D_E_L_E_T_ = '  ' "	 
	If !Empty(Alltrim(MV_PAR01))
		cQuery += " AND " + MV_PAR01 + "" 
	EndIf

	cQuery :=  ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .T., .T.)
	
	If (cAliasQry)->(!Eof())	
		While (cAliasQry)->(!Eof())	
			cProces := (cAliasQry)->RE0_NUM
	
			BEGIN REPORT QUERY oSection
			BeginSql alias cAliasPA3

			SELECT PA3.PA3_FILIAL, PA3.PA3_XCDPRO, PA3.PA3_XTPCOR, PA3.PA3_XVLATU,
			PA3.PA3_XVLCOR, PA3.PA3_CHVFIL, PA3.PA3_XPERCA, PA3.PA3_XINDIC,
			RE0.RE0_NUM, RE0.RE0_DESCR, RE0.RE0_TPACAO, RE0.RE0_RECLAM,  RE0.RE0_DTPROC
			FROM %table:RE0% RE0
			INNER JOIN %table:PA3% PA3 ON
			RE0.RE0_FILIAL = PA3.PA3_FILIAL AND
			RE0.RE0_NUM = PA3.PA3_XCDPRO AND
			PA3.%notDel%
			WHERE
			RE0.RE0_NUM = %Exp:cProces%
			ORDER BY PA3_XCDPRO, PA3.PA3_XTPCOR, PA3.PA3_CHVFIL, PA3.PA3_XPERCA

			EndSql
    		END REPORT QUERY oSection
  			//GetLastQuery()[2]
    	
			oSection:EndQuery()
		
			oSection1:SetParentQuery(.T.)
					
			oReport:Section(1):Section(1):SetLineCondition({|| IIf(PA3_XCDPRO = cProces .and. PA3_XTPCOR = "1",.T.,.F.)})
			oReport:Section(1):Section(2):SetLineCondition({|| IIf(PA3_XCDPRO = cProces .and. PA3_XTPCOR = "2",.T.,.F.)})
			oReport:Section(1):Section(3):SetLineCondition({|| IIf(PA3_XCDPRO = cProces .and. PA3_XTPCOR = "3",.T.,.F.)})
    
   	 		oSection:Print() //Imprimir
	
			(cAliasQry)->(dbSkip())
		EndDo
	Else
		Help( "F0102402",1 , "Não existe registro com os parâmetros informados. ",,0) 
		RestArea(aAreaPA3)
		RestArea(aArea)
		Return(.F.) 
	EndIf   
//Else
//	Help( "F0102402",1 , "Necessário informar um número de processo. ",,0) 
//	RestArea(aAreaPA3)
//	RestArea(aArea)
//	Return(.F.) 
//EndIf   

RestArea(aAreaPA3)
RestArea(aArea)
Return
    
//==========================================================================================
/*/{Protheus.doc} CriaSX1()
CRIA AS PERGUNTAS DO FILTRO DO RELATÓRIO

@project    MAN00000011501_EF_024
@author     Fanny Suzuki 
@since      25/09/2015
@version    P12
@return     Nil
@param      cPerg // Parametros para a geração do relatório / processamento do extrato
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
Aadd(aRegs,{"APTX002","01","Processo ?",       "¿Processo ?",     "Processo ?",     "MV_CH1",  "C",  99,     0,      0,      "R",   "",    "MV_PAR01",  "",   "",      "",     "RE0_NUM",  "",    "",   "",     "",     "",   "",   "",    "",      "",      "",   "",   "",   "",     "",     "",    "",    "",    "",     "",     "",    "RE0",  "",     "N",  aHelp,   aHelpI,  aHelpE,  cHelp})


ValidPerg(aRegs,cPerg,.T.)

Return Nil