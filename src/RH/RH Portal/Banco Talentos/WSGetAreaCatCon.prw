#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "AP5MAIL.CH"
                              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSGetAreaCatCon ºAutor  ³Totvs        º Data ³  31/03/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WS que irá buscar 						  				  º±±
±±º			 ³ os area, categoria e conhecimentos no portal				  º±±
±±º          ³ de gestão de capital humano (APD)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PRODAM - Portal de Gestão de Capital Humano (SIGAAPD)      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/**************************************************************************
* Definicao da estruturas utilizadas                                      *
***************************************************************************/
User Function _XKZXYZJ ; Return  // "dummy" function - Internal Use

/***************************************************************************
* Definicao do Web Service 							                      *
***************************************************************************/
WSSERVICE GETZ6Z7Z8 DESCRIPTION "Busca as Áreas, Categorias e Conhecimentos."

   WSDATA OPER			AS String
   WSDATA AREA			AS String OPTIONAL
   WSDATA CATEGORIA		AS String OPTIONAL
   WSDATA CONHECIMENTO	AS String OPTIONAL
   WSDATA RETORNO		AS Array of String

   WSMETHOD GETINFO 	//Inclui/Altera/Exclui um Conhecimento

ENDWSSERVICE 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETCURSOS ºAutor  ³Diego Santos   º Data ³  31/03/16        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os cursos, conhecimentos e atividades funcionais do  º±±
±±º          ³ funcionário da mesma forma que a rotina TRM002 presente no º±±
±±º			 ³ módulo de Treinamentos (SIGATRM)							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PRODAM - Portal de Gestão de Capital Humano (SIGAAPD)      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSMETHOD GETINFO WSRECEIVE OPER, AREA, CATEGORIA WSSEND RETORNO WSSERVICE GETZ6Z7Z8

Local cQuery 	:= ""
Local cAliasTMP	

If AllTrim(::OPER) == "1" //Área

	cAliasTMP := GetNextAlias()
	
	cQuery := "SELECT * FROM "+RetSqlName("SZ6")+" SZ6 "
	cQuery += "WHERE SZ6.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY Z6_DESCRI, Z6_CODIGO "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
	
	While (cAliasTMP)->(!Eof())
		aADD( ::RETORNO, (cAliasTMP)->Z6_CODIGO + " - " + RTrim((cAliasTMP)->Z6_DESCRI))
		(cAliasTMP)->(DbSkip())
	End
	
	  
ElseIf AllTrim(::OPER) == "2" //Categoria
	
	cAliasTMP := GetNextAlias()

	cQuery := "SELECT * FROM "+RetSqlName("SZ7")+ " SZ7 "
	cQuery += "WHERE SZ7.Z7_AREA = '"+::AREA+"' AND SZ7.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY Z7_DESCRI, Z7_CODIGO "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
	
	While (cAliasTMP)->(!Eof())
		aADD( ::RETORNO, (cAliasTMP)->Z7_CODIGO + " - " + RTrim((cAliasTMP)->Z7_DESCRI))
		(cAliasTMP)->(DbSkip())
	End
	
	 
ElseIf AllTrim(::OPER) == "3" //Conhecimento

	cAliasTMP := GetNextAlias()

	cQuery := "SELECT * FROM "+RetSqlName("SZ8")+" SZ8 "
	cQuery += "WHERE SZ8.Z8_AREA = '"+::AREA+"' AND "
	cQuery += "SZ8.Z8_CATEG = '"+::CATEGORIA+"' AND "
	cQuery += "D_E_L_E_T_ = '' "
	cQuery += "ORDER BY Z8_DESCRI, Z8_CODIGO "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
	
	While (cAliasTMP)->(!Eof())
		aADD( ::RETORNO, (cAliasTMP)->Z8_CODIGO + " - " + RTrim((cAliasTMP)->Z8_DESCRI))
		(cAliasTMP)->(DbSkip())
	End
	
EndIf	

Return .T.
