#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "AP5MAIL.CH"
                              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WSMANRHKNOW �Autor  �Totvs           � Data �  31/03/16    ���
�������������������������������������������������������������������������͹��
���Desc.     � WS que ir� incluir/alterar/excluir 						  ���
���			 � os conhecimentos do funcion�rio no portal				  ���
���          � de gest�o de capital humano (APD)                          ���
�������������������������������������������������������������������������͹��
���Uso       � PRODAM - Portal de Gest�o de Capital Humano (SIGAAPD)      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GETCURSOS �Autor  �Diego Santos   � Data �  31/03/16        ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca os cursos, conhecimentos e atividades funcionais do  ���
���          � funcion�rio da mesma forma que a rotina TRM002 presente no ���
���			 � m�dulo de Treinamentos (SIGATRM)							  ���
�������������������������������������������������������������������������͹��
���Uso       � PRODAM - Portal de Gest�o de Capital Humano (SIGAAPD)      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSMETHOD WSMANKNOW WSRECEIVE /*EMPRESA, WSFILIAL,*/ MATRICULA, MANRHKNOW  WSSEND CODRET WSSERVICE MANRHKNOW

//Local cZEmpresa := ::EMPRESA 	//Empresa no qual o portal esta sendo utilizado.
//Local cZFilial  := ::WSFILIAL  	//Filial na qual o portal esta sendo utilizado.
Local cZMat	    := ::MATRICULA	//Matr�cula.
Local aSZ9Area	:= {}
Local nIndice   := 0

//Local aTables   := { "RA1", "RA4", "SZ5", "SZ6", "SZ7", "SZ8", "SZ9", "SRA", "RBN" }

//If RpcSetEnv( cZEmpresa, cZFilial, , , "TRM", "WSMANKNOW", aTables )
If ::MANRHKNOW:OPER == "4" //Altera��o
	aSZ9Area := SZ9->(GetArea())
	nIndice	 := Val(::MANRHKNOW:INDICE)
	
	SZ9->(DbSetOrder(nIndice))
	If SZ9->(DbSeek(xFilial("SZ9")+cZMat+::MANRHKNOW:AREA+::MANRHKNOW:CATEGORIA+::MANRHKNOW:CODCONHEC))
		RecLock("SZ9",.F.)
			SZ9->Z9_NIVEL := ::MANRHKNOW:NIVEL
		MsUnlock()
		::CODRET 	:= "Solicita��o realizada com sucesso"
	EndIf	
	
ElseIf ::MANRHKNOW:OPER == "5" //Exclus�o
	aSZ9Area := SZ9->(GetArea())
	nIndice	 := Val(::MANRHKNOW:INDICE)
			
	SZ9->(DbSetOrder(nIndice))
	If SZ9->(DbSeek(xFilial("SZ9")+cZMat+::MANRHKNOW:AREA+::MANRHKNOW:CATEGORIA+::MANRHKNOW:CODCONHEC))
		RecLock("SZ9",.F.)
			SZ9->(DbDelete())
		MsUnlock()
		::CODRET 	:= "Solicita��o realizada com sucesso"
	EndIf
	
ElseIf ::MANRHKNOW:OPER == "3" //Inclus�o
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
		::CODRET 	:= "Solicita��o realizada com sucesso"
	Else			
		::CODRET	:= "Conhecimento j� cadastrado"
		Conout("Erro: " + ::CODRET)
	EndIf
EndIf

/*
Else
	::CODRET 	:= "Falha na abertura de ambiente."
EndIf
*/

Return .T.
