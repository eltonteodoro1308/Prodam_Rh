#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "AP5MAIL.CH"
                              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSMEUCADFUNC ºAutor  ³Totvs           º Data ³  31/03/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WS que irá exibir os conhecimentos do funcionário no portalº±±
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
User Function _XZXZXZX ; Return  // "dummy" function - Internal Use

WSSTRUCT RA4STRU

WSDATA CATEGORIA  AS String
WSDATA DESCCAT	  AS String
WSDATA CODCURSO	  AS String
WSDATA DESCCUR	  AS String
WSDATA DESCENTIDA AS String
WSDATA DATAFIM	  AS String
WSDATA DURACAO	  AS String

ENDWSSTRUCT

WSSTRUCT CONHECIMENTO

WSDATA AREA	     	AS String
WSDATA DESCAREA	 	AS String
WSDATA CATEGORIA 	AS String
WSDATA DESCCAT	 	AS String
WSDATA CODCONHEC	AS String
WSDATA DESCCON	 	AS String
WSDATA NIVEL		AS String

ENDWSSTRUCT 
 
WSSTRUCT FUNCIONAL

WSDATA AREADEPTO	AS String
WSDATA FUNCAO	 	AS String
WSDATA DTINICIO 	AS Date
WSDATA DTFIM	 	AS Date
WSDATA ATIVIDADES	AS String
WSDATA DTALT	 	AS Date
WSDATA PROJETO		AS String
WSDATA SUBPROJETO	AS String

ENDWSSTRUCT 

WSSTRUCT CADASTRO

WSDATA NOME			AS String
WSDATA MATRICULA	AS String
WSDATA ADMISSAO	 	AS String
WSDATA CARGO	 	AS String
WSDATA ESPECIALIZ 	AS String
WSDATA DESCDEPTO 	AS String

ENDWSSTRUCT 

WSSTRUCT _RETCURSOS

WSDATA CODRET			AS STRING

WSDATA FORMACOES 		AS ARRAY OF RA4STRU 		OPTIONAL
WSDATA CAPACITACOES		AS ARRAY OF RA4STRU			OPTIONAL
WSDATA CERTIFICACOES	AS ARRAY OF RA4STRU			OPTIONAL
WSDATA CONHECIMENTOS    AS ARRAY OF CONHECIMENTO	OPTIONAL
WSDATA FUNCIONAIS		AS ARRAY OF FUNCIONAL		OPTIONAL
WSDATA CADASTRAIS		AS ARRAY OF CADASTRO		OPTIONAL


ENDWSSTRUCT

/***************************************************************************
* Definicao do Web Service 							                      *
***************************************************************************/
WSSERVICE WS_MEUCADFUNC DESCRIPTION "Consulta Meu Cadastro - Banco de Talentos"

   //WSDATA EMPRESA		AS String	
   //WSDATA WSFILIAL		AS String
   WSDATA MATRICULA		AS String
   WSDATA CURSOS		AS _RETCURSOS

   WSMETHOD GETCURSOS 			//Busca os cursos do funcionário
   //WSMETHOD SETCONHEC  	    //Método para atualizar/incluir os conhecimentos através do portal.

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

WSMETHOD GETCURSOS WSRECEIVE /*EMPRESA, WSFILIAL,*/ MATRICULA  WSSEND CURSOS WSSERVICE WS_MEUCADFUNC

//Local cZEmpresa := ::EMPRESA 	//Empresa no qual o portal esta sendo utilizado.
//Local cZFilial  := ::WSFILIAL  	//Filial na qual o portal esta sendo utilizado.
Local cZMat	    := ::MATRICULA	//Matrícula.

Local cQueryRA4 := ""			//Query para capturar as informações das tabelas RA1, RA4, SZ5, SRA.
Local cQuerySZ9 := ""			//Query para capturar as informações das tabelas SZ6, SZ7, SZ8, SZ9. 
Local cQueryRBN := ""			//Query para capturar as informações das tabelas RBN.

Local aFor		:= {}
Local aCap		:= {}
Local aCert		:= {}
Local aAtiv		:= {}
Local aConhecs	:= {}
Local aFuncs	:= {}

Local oFormacoes := Nil

Local nX := 1
Local nY := 1
Local nZ := 1
Local nW := 1
Local nK := 1
Local nF := 1

Local cAliasRA4
Local cAliasSZ9
Local cAliasRBN

::CURSOS:FORMACOES		:= {}
::CURSOS:CAPACITACOES	:= {}
::CURSOS:CERTIFICACOES	:= {}
::CURSOS:CONHECIMENTOS	:= {}
::CURSOS:FUNCIONAIS		:= {}
::CURSOS:CADASTRAIS		:= {}

cQueryRA4 := "SELECT "
cQueryRA4 += "SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_ADMISSA, SQ3.Q3_DESCSUM, SRJ.RJ_DESC, SQB.QB_DESCRIC, " 														//Tabela SRA
cQueryRA4 += "RA1.RA1_CURSO, RA1.RA1_DESC, RA1.RA1_TIPOPP, RA1.RA1_CATEG, " 					//Tabela RA1
cQueryRA4 += "RA4.RA4_CURSO, RA4.RA4_ENTIDA, RA4.RA4_DATAFI, RA4.RA4_DURACA, RA4.RA4_UNDURA, "	//Tabela RA4
cQueryRA4 += "SZ5.Z5_CODIGO, SZ5.Z5_DESCRI "													//Tabela SZ5
cQueryRA4 += "FROM "
cQueryRA4 += RetSqlName("SRA") + " SRA "
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("RA4") + " RA4 ON "
cQueryRA4 += "SRA.RA_FILIAL  = RA4.RA4_FILIAL AND "
cQueryRA4 += "SRA.RA_MAT     = RA4.RA4_MAT    AND " 
cQueryRA4 += "SRA.D_E_L_E_T_ = RA4.D_E_L_E_T_ AND "
cQueryRA4 += "SRA.D_E_L_E_T_ = '' "
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("RA1") + " RA1 ON "
cQueryRA4 += "RA1.RA1_CURSO = RA4.RA4_CURSO AND "
cQueryRA4 += "RA4.D_E_L_E_T_ = RA1.D_E_L_E_T_  AND "
cQueryRA4 += "RA4.D_E_L_E_T_ = '' "	
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("SZ5") + " SZ5 ON "
cQueryRA4 += "RA1.RA1_FILIAL = SZ5.Z5_FILIAL  AND "
cQueryRA4 += "RA1.RA1_CATEG  = SZ5.Z5_CODIGO  AND "
cQueryRA4 += "RA1.D_E_L_E_T_ = SZ5.D_E_L_E_T_ AND "
cQueryRA4 += "RA1.D_E_L_E_T_ = '' "
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("SQ3") + " SQ3 ON "
cQueryRA4 += "SQ3.Q3_FILIAL  = '"+ xFilial("SQ3") +"' AND "
cQueryRA4 += "SQ3.Q3_CARGO   = SRA.RA_CARGO   AND " 
cQueryRA4 += "SQ3.D_E_L_E_T_ = '' "
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("SRJ") + " SRJ ON "
cQueryRA4 += "SRJ.RJ_FILIAL  = '"+ xFilial("SRJ") +"' AND "
cQueryRA4 += "SRJ.RJ_FUNCAO  = SRA.RA_CODFUNC  AND " 
cQueryRA4 += "SRJ.D_E_L_E_T_ = '' "
cQueryRA4 += "LEFT JOIN "
cQueryRA4 += RetSqlName("SQB") + " SQB ON "
cQueryRA4 += "SQB.QB_FILIAL  = '"+ xFilial("SQB") +"' AND "
cQueryRA4 += "SQB.QB_DEPTO   = SRA.RA_DEPTO  AND " 
cQueryRA4 += "SQB.D_E_L_E_T_ = '' "
cQueryRA4 += "WHERE "
cQueryRA4 += "SRA.RA_FILIAL = '"+ xFilial("SRA") +"' AND " 
cQueryRA4 += "SRA.RA_MAT    = '"+ cZMat    +"' AND "
cQueryRA4 += "SRA.D_E_L_E_T_ = ''"	
cQueryRA4 += "ORDER BY RA4.RA4_FILIAL, RA1.RA1_TIPOPP, RA1.RA1_CATEG, RA4.RA4_CURSO	"

cQueryRA4 := ChangeQuery(cQueryRA4)
cAliasRA4 := GetNextAlias()
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQueryRA4), cAliasRA4, .F., .T.)

While (cAliasRA4)->(!Eof())
	
	If (cAliasRA4)->RA1_TIPOPP == "001" //Formações
					
		
		aADD(::CURSOS:FORMACOES, WSClassNew("RA4STRU") )
		::CURSOS:FORMACOES[nX]:CATEGORIA 	:= (cAliasRA4)->RA1_CATEG 
		::CURSOS:FORMACOES[nX]:DESCCAT	 	:= (cAliasRA4)->Z5_DESCRI
		::CURSOS:FORMACOES[nX]:CODCURSO  	:= (cAliasRA4)->RA1_CURSO
		::CURSOS:FORMACOES[nX]:DESCCUR	 	:= (cAliasRA4)->RA1_DESC
		::CURSOS:FORMACOES[nX]:DESCENTIDA 	:= Posicione("RA0",1,xFilial("RA0")+(cAliasRA4)->RA4_ENTIDA,"RA0_DESC")
		::CURSOS:FORMACOES[nX]:DATAFIM	 	:= dtoc(stod((cAliasRA4)->RA4_DATAFI))
		::CURSOS:FORMACOES[nX]:DURACAO	 	:= Transform((cAliasRA4)->RA4_DURACA,if((cAliasRA4)->RA4_DURACA>int((cAliasRA4)->RA4_DURACA),"@RE 9999.99","@RE 9999")) 
		If (cAliasRA4)->RA4_UNDURA == 'A'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:FORMACOES[nX]:DURACAO += ' Anos'
			Else
				::CURSOS:FORMACOES[nX]:DURACAO += ' Ano'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'D'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:FORMACOES[nX]:DURACAO += ' Dias'
			Else
				::CURSOS:FORMACOES[nX]:DURACAO += ' Dia'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'M'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:FORMACOES[nX]:DURACAO += ' Meses'
			Else
				::CURSOS:FORMACOES[nX]:DURACAO += ' Mes'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'H'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:FORMACOES[nX]:DURACAO += ' Horas'
			Else
				::CURSOS:FORMACOES[nX]:DURACAO += ' Hora'
			Endif			
		EndIf		
		nX++
		
	ElseIf (cAliasRA4)->RA1_TIPOPP == "002" //Certificações
	
		aADD(::CURSOS:CERTIFICACOES, WSClassNew("RA4STRU") )
			::CURSOS:CERTIFICACOES[nY]:CATEGORIA 	:= (cAliasRA4)->RA1_CATEG 
			::CURSOS:CERTIFICACOES[nY]:DESCCAT	 	:= (cAliasRA4)->Z5_DESCRI
			::CURSOS:CERTIFICACOES[nY]:CODCURSO  	:= (cAliasRA4)->RA1_CURSO
			::CURSOS:CERTIFICACOES[nY]:DESCCUR	 	:= (cAliasRA4)->RA1_DESC
			::CURSOS:CERTIFICACOES[nY]:DESCENTIDA 	:= Posicione("RA0",1,xFilial("RA0")+(cAliasRA4)->RA4_ENTIDA,"RA0_DESC")
			::CURSOS:CERTIFICACOES[nY]:DATAFIM	 	:= dtoc(stod((cAliasRA4)->RA4_DATAFI))
			::CURSOS:CERTIFICACOES[nY]:DURACAO	 	:= Transform((cAliasRA4)->RA4_DURACA,if((cAliasRA4)->RA4_DURACA>int((cAliasRA4)->RA4_DURACA),"@RE 9999.99","@RE 9999"))
			If (cAliasRA4)->RA4_UNDURA == 'A'
				If (cAliasRA4)->RA4_DURACA > 1
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Anos'
				Else
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Ano'
				Endif			
			ElseIf (cAliasRA4)->RA4_UNDURA == 'D'
				If (cAliasRA4)->RA4_DURACA > 1
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Dias'
				Else
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Dia'
				Endif			
			ElseIf (cAliasRA4)->RA4_UNDURA == 'M'
				If (cAliasRA4)->RA4_DURACA > 1
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Mes'
				Else
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Meses'
				Endif			
			ElseIf (cAliasRA4)->RA4_UNDURA == 'H'
				If (cAliasRA4)->RA4_DURACA > 1
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Horas'
				Else
					::CURSOS:CERTIFICACOES[nY]:DURACAO += ' Hora'
				Endif			
			EndIf		
			
			nY++
  
	Else //Capacitações			
					
		aADD(::CURSOS:CAPACITACOES, WSClassNew("RA4STRU") )
		::CURSOS:CAPACITACOES[nZ]:CATEGORIA 	:= (cAliasRA4)->RA1_CATEG 
		::CURSOS:CAPACITACOES[nZ]:DESCCAT	 	:= (cAliasRA4)->Z5_DESCRI
		::CURSOS:CAPACITACOES[nZ]:CODCURSO  	:= (cAliasRA4)->RA1_CURSO
		::CURSOS:CAPACITACOES[nZ]:DESCCUR	 	:= (cAliasRA4)->RA1_DESC
		::CURSOS:CAPACITACOES[nZ]:DESCENTIDA 	:= Posicione("RA0",1,xFilial("RA0")+(cAliasRA4)->RA4_ENTIDA,"RA0_DESC")
		::CURSOS:CAPACITACOES[nZ]:DATAFIM	 	:= dtoc(stod((cAliasRA4)->RA4_DATAFI))
		::CURSOS:CAPACITACOES[nZ]:DURACAO	 	:= Transform((cAliasRA4)->RA4_DURACA,if((cAliasRA4)->RA4_DURACA>int((cAliasRA4)->RA4_DURACA),"@RE 9999.99","@RE 9999"))
		If (cAliasRA4)->RA4_UNDURA == 'A'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Anos'
			Else
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Ano'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'D'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Dias'
			Else
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Dia'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'M'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Mes'
			Else
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Meses'
			Endif			
		ElseIf (cAliasRA4)->RA4_UNDURA == 'H'
			If (cAliasRA4)->RA4_DURACA > 1
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Horas'
			Else
				::CURSOS:CAPACITACOES[nZ]:DURACAO += ' Hora'
			Endif			
		EndIf		
		
		nZ++
											
	EndIf  
	If nF == 1
		aADD(::CURSOS:CADASTRAIS, WSClassNew("CADASTRO") )
		::CURSOS:CADASTRAIS[1]:NOME		 	:= (cAliasRA4)->RA_NOME
		::CURSOS:CADASTRAIS[1]:MATRICULA 	:= (cAliasRA4)->RA_MAT 
		::CURSOS:CADASTRAIS[1]:ADMISSAO 	:= dtoc(stod((cAliasRA4)->RA_ADMISSA))
		::CURSOS:CADASTRAIS[1]:CARGO	 	:= (cAliasRA4)->Q3_DESCSUM
		::CURSOS:CADASTRAIS[1]:ESPECIALIZ 	:= (cAliasRA4)->RJ_DESC
		::CURSOS:CADASTRAIS[1]:DESCDEPTO 	:= (cAliasRA4)->QB_DESCRIC
		nF++
	EndIf
	(cAliasRA4)->(DbSkip())
	
End
	
cQuerySZ9 := "SELECT "
cQuerySZ9 += "SRA.RA_FILIAL, SRA.RA_MAT, " 															//Tabela SRA
cQuerySZ9 += "SZ9.Z9_FILIAL, SZ9.Z9_MAT, SZ9.Z9_AREA, SZ9.Z9_CATEG, SZ9.Z9_CONHEC, SZ9.Z9_NIVEL, " 	//Tabela SZ9
cQuerySZ9 += "SZ6.Z6_CODIGO, SZ6.Z6_DESCRI, " 														//Tabela SZ6
cQuerySZ9 += "SZ7.Z7_AREA, SZ7.Z7_CODIGO, SZ7.Z7_DESCRI, " 											//Tabela SZ7
cQuerySZ9 += "SZ8.Z8_AREA, SZ8.Z8_CATEG, SZ8.Z8_CODIGO, SZ8.Z8_DESCRI " 							//Tabela SZ8
cQuerySZ9 += "FROM "
cQuerySZ9 += RetSqlName("SRA") + " SRA "
cQuerySZ9 += "LEFT JOIN "
cQuerySZ9 += RetSqlName("SZ9") + " SZ9 ON "
cQuerySZ9 += "SRA.RA_FILIAL  = SZ9.Z9_FILIAL AND "
cQuerySZ9 += "SRA.RA_MAT     = SZ9.Z9_MAT    AND "	
cQuerySZ9 += "SRA.D_E_L_E_T_ = SZ9.D_E_L_E_T_ AND "
cQuerySZ9 += "SRA.D_E_L_E_T_ = '' "
cQuerySZ9 += "LEFT JOIN "
cQuerySZ9 += RetSqlName("SZ6") + " SZ6 ON "
cQuerySZ9 += "SZ9.Z9_AREA = SZ6.Z6_CODIGO AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = SZ6.D_E_L_E_T_ AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = '' "
cQuerySZ9 += "LEFT JOIN "
cQuerySZ9 += RetSqlName("SZ7") + " SZ7 ON "
cQuerySZ9 += "SZ9.Z9_AREA  = SZ7.Z7_AREA 	AND "
cQuerySZ9 += "SZ9.Z9_CATEG = SZ7.Z7_CODIGO 	AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = SZ7.D_E_L_E_T_ AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = '' "
cQuerySZ9 += "LEFT JOIN "
cQuerySZ9 += RetSqlName("SZ8") + " SZ8 ON "
cQuerySZ9 += "SZ9.Z9_AREA   = SZ8.Z8_AREA 	AND "
cQuerySZ9 += "SZ9.Z9_CATEG  = SZ8.Z8_CATEG 	AND "	
cQuerySZ9 += "SZ9.Z9_CONHEC = SZ8.Z8_CODIGO AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = SZ8.D_E_L_E_T_ AND "
cQuerySZ9 += "SZ9.D_E_L_E_T_ = '' "
cQuerySZ9 += "WHERE "
cQuerySZ9 += "SRA.RA_FILIAL = '"+ xFilial("SRA") +"' AND " 
cQuerySZ9 += "SRA.RA_MAT    = '"+ cZMat    +"' AND "
cQuerySZ9 += "SRA.D_E_L_E_T_ = ''"	
cQuerySZ9 += "ORDER BY SZ9.Z9_AREA, SZ9.Z9_CATEG, SZ9.Z9_CONHEC "	

cQuerySZ9 := ChangeQuery(cQuerySZ9)
cAliasSZ9 := GetNextAlias()
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuerySZ9), cAliasSZ9, .F., .T.)

While (cAliasSZ9)->(!Eof())

	aADD(::CURSOS:CONHECIMENTOS, WSClassNew("CONHECIMENTO") )
	
	::CURSOS:CONHECIMENTOS[nW]:AREA 		:= (cAliasSZ9)->Z9_AREA
	::CURSOS:CONHECIMENTOS[nW]:DESCAREA 	:= (cAliasSZ9)->Z6_DESCRI
	::CURSOS:CONHECIMENTOS[nW]:CATEGORIA 	:= (cAliasSZ9)->Z9_CATEG
	::CURSOS:CONHECIMENTOS[nW]:DESCCAT 		:= (cAliasSZ9)->Z7_DESCRI
	::CURSOS:CONHECIMENTOS[nW]:CODCONHEC	:= (cAliasSZ9)->Z9_CONHEC
	::CURSOS:CONHECIMENTOS[nW]:DESCCON 		:= (cAliasSZ9)->Z8_DESCRI
	::CURSOS:CONHECIMENTOS[nW]:NIVEL 		:= (cAliasSZ9)->Z9_NIVEL		
	
	nW++
			
	(cAliasSZ9)->(DbSkip())
End

cQueryRBN := "SELECT "
cQueryRBN += "SRA.RA_FILIAL, SRA.RA_MAT, "	//Tabela SRA
cQueryRBN += "RBN.RBN_MAT, RBN.RBN_DEPTO, RBN_FUNCAO, RBN_DTINI, RBN_DTFIM, "   //Tabela RBN
cQueryRBN += "RBN.RBN_ATIVID, RBN.RBN_DTALT, RBN.RBN_PROJET, RBN.RBN_SUBPRO "  //Tabela RBN
cQueryRBN += "FROM "
cQueryRBN += RetSqlName("SRA") + " SRA "
cQueryRBN += "LEFT JOIN "
cQueryRBN += RetSqlName("RBN") + " RBN ON "
cQueryRBN += "SRA.RA_FILIAL  = RBN.RBN_FILIAL AND "
cQueryRBN += "SRA.RA_MAT     = RBN.RBN_MAT    AND "	
cQueryRBN += "SRA.D_E_L_E_T_ = RBN.D_E_L_E_T_ AND "
cQueryRBN += "SRA.D_E_L_E_T_ = '' "
cQueryRBN += "WHERE "
cQueryRBN += "SRA.RA_FILIAL = '"+ xFilial("SRA") +"' AND " 
cQueryRBN += "SRA.RA_MAT    = '"+ cZMat    +"' AND "
cQueryRBN += "SRA.D_E_L_E_T_ = '' "	
cQueryRBN += "ORDER BY RBN.RBN_DEPTO"	

cQueryRBN := ChangeQuery(cQueryRBN)
cAliasRBN := GetNextAlias()
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQueryRBN), cAliasRBN, .F., .T.)

While (cAliasRBN)->(!Eof())

	aADD(::CURSOS:FUNCIONAIS, WSClassNew("FUNCIONAL") )

	::CURSOS:FUNCIONAIS[nK]:AREADEPTO 		:= (cAliasRBN)->RBN_DEPTO
	::CURSOS:FUNCIONAIS[nK]:FUNCAO 			:= (cAliasRBN)->RBN_FUNCAO
	::CURSOS:FUNCIONAIS[nK]:DTINICIO 		:= StoD((cAliasRBN)->RBN_DTINI)
	::CURSOS:FUNCIONAIS[nK]:DTFIM 			:= StoD((cAliasRBN)->RBN_DTFIM)
	::CURSOS:FUNCIONAIS[nK]:ATIVIDADES 		:= (cAliasRBN)->RBN_ATIVID
	::CURSOS:FUNCIONAIS[nK]:DTALT 			:= StoD((cAliasRBN)->RBN_DTALT)
	::CURSOS:FUNCIONAIS[nK]:PROJETO 		:= (cAliasRBN)->RBN_PROJET
	::CURSOS:FUNCIONAIS[nK]:SUBPROJETO 		:= (cAliasRBN)->RBN_SUBPRO
	
	nK++		
			
	(cAliasRBN)->(DbSkip())
End

::CURSOS:CODRET 		:= "Solicitação realizada com sucesso"

Return .T.
