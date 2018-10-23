#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "AP5MAIL.CH"
                              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSMANRHKNOW ºAutor  ³Totvs           º Data ³  31/03/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WS que irá incluir/alterar/excluir 						  º±±
±±º			 ³ os conhecimentos do funcionário no portal				  º±±
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
User Function _XKKZKZK ; Return  // "dummy" function - Internal Use

WSSTRUCT KNOWSTRU

WSDATA AREA	     	AS String
WSDATA CATEGORIA 	AS String
WSDATA CODCONHEC	AS String
WSDATA NIVEL		AS String
WSDATA OPER			AS String
WSDATA INDICE		AS String


ENDWSSTRUCT 

/***************************************************************************
* Definicao do Web Service 							                      *
***************************************************************************/
WSSERVICE MANRHKNOW DESCRIPTION "Inclui/Altera/Exclui um Conhecimento - Meu Cadastro - Banco de Talentos"

   //WSDATA EMPRESA		AS String	
   //WSDATA WSFILIAL		AS String
   WSDATA MATRICULA		AS String
   WSDATA MANRHKNOW		AS KNOWSTRU
   WSDATA CODRET		AS String

   WSMETHOD WSMANKNOW 	//Inclui/Altera/Exclui um Conhecimento

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

WSMETHOD WSMANKNOW WSRECEIVE /*EMPRESA, WSFILIAL,*/ MATRICULA, MANRHKNOW  WSSEND CODRET WSSERVICE MANRHKNOW

//Local cZEmpresa := ::EMPRESA 	//Empresa no qual o portal esta sendo utilizado.
//Local cZFilial  := ::WSFILIAL  	//Filial na qual o portal esta sendo utilizado.
Local cZMat	    := ::MATRICULA	//Matrícula.
Local aSZ9Area	:= {}
Local nIndice   := 0

//Local aTables   := { "RA1", "RA4", "SZ5", "SZ6", "SZ7", "SZ8", "SZ9", "SRA", "RBN" }

//If RpcSetEnv( cZEmpresa, cZFilial, , , "TRM", "WSMANKNOW", aTables )
If ::MANRHKNOW:OPER == "4" //Alteração
	aSZ9Area := SZ9->(GetArea())
	nIndice	 := Val(::MANRHKNOW:INDICE)
	
	SZ9->(DbSetOrder(nIndice))
	If SZ9->(DbSeek(xFilial("SZ9")+cZMat+::MANRHKNOW:AREA+::MANRHKNOW:CATEGORIA+::MANRHKNOW:CODCONHEC))
		RecLock("SZ9",.F.)
			SZ9->Z9_NIVEL := ::MANRHKNOW:NIVEL
		MsUnlock()
		::CODRET 	:= "Solicitação realizada com sucesso"
	EndIf	
	
ElseIf ::MANRHKNOW:OPER == "5" //Exclusão
	aSZ9Area := SZ9->(GetArea())
	nIndice	 := Val(::MANRHKNOW:INDICE)
			
	SZ9->(DbSetOrder(nIndice))
	If SZ9->(DbSeek(xFilial("SZ9")+cZMat+::MANRHKNOW:AREA+::MANRHKNOW:CATEGORIA+::MANRHKNOW:CODCONHEC))
		RecLock("SZ9",.F.)
			SZ9->(DbDelete())
		MsUnlock()
		::CODRET 	:= "Solicitação realizada com sucesso"
	EndIf
	
ElseIf ::MANRHKNOW:OPER == "3" //Inclusão
	aSZ9Area := SZ9->(GetArea())
	If SZ9->(!DbSeek(xFilial("SZ9")+cZMat+::MANRHKNOW:AREA+::MANRHKNOW:CATEGORIA+::MANRHKNOW:CODCONHEC))
		RecLock("SZ9",.T.)
			SZ9->Z9_FILIAL := xFilial("SZ9")
			SZ9->Z9_MAT	   := cZMat
			SZ9->Z9_AREA   := ::MANRHKNOW:AREA
			SZ9->Z9_CATEG  := ::MANRHKNOW:CATEGORIA
			SZ9->Z9_CONHEC := ::MANRHKNOW:CODCONHEC
			SZ9->Z9_NIVEL  := ::MANRHKNOW:NIVEL
		MsUnlock()
		::CODRET 	:= "Solicitação realizada com sucesso"
	Else			
		::CODRET	:= "Conhecimento já cadastrado"
		Conout("Erro: " + ::CODRET)
	EndIf
EndIf

/*
Else
	::CODRET 	:= "Falha na abertura de ambiente."
EndIf
*/

Return .T.
