#INCLUDE "TbiConn.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} f0100403()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       29/09/2015
@version     P12.5
@Return      Envio de E-mail de aviso de final de substituicao
@Obs         Funcao Schedulle
/*/

user function f0100403()

Local cHTML		:= ""
Local cQuery	:= ""
Local cDestino  := ALLTRIM(GETMV("FS_EMSUBST"))
Local nLIMITE   := GETMV("FS_SUBSLIM")
Local dDATA     := DATE()
Local nDIAS     := 0
Local cMENS     := ''
Local cError    := ""
Local cSubject	:= "WorkFlow - vencimento de substituição"
Local cPassword	:= GetMV("MV_RELPSW")
Local cServer	:= GetMV("MV_RELSERV")
Local cAccount	:= GetMV("MV_RELACNT")
Local cFrom		:= GetMV("MV_RELACNT")
Local lAuth    	:= GETMV("MV_RELAUTH")
Local lConnect	:= .T.

ConOut(Padr("Iniciando WorkFlow de envio de email para alerta de encerramento de substituicao ",80))

CQUERY:=" SELECT PA2_DATFIM,PA2_MATSUB,PA2_MAT FROM " + RetSqlName ("PA2") + " "
cQuery+=" WHERE PA2_TIPO = '2' AND PA2_FILSUB <> '' AND PA2_DATFIM > '"+DTOS(dDATABASE)+"' AND D_E_L_E_T_<>'*' "

cQuery := ChangeQuery( cQuery )

Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

dbSelectArea("TRG1")
dbgotop()

DO WHILE !EOF()
	
	dDATA := STOD(TRG1->PA2_DATFIM)
	nDIAS := dDATA - dDATABASE
	
	IF nDIAS = 30 .OR. nDIAS = 60
		
		cMENS:= 'Atenção ! '+CRLF
		cMENS+= 'Está para vencer em '+strzero(nDIAS,2)+' a Substituição do Funcionario '+TRG1->PA2_MATSUB+' pelo Funcionario '+TRG1->PA2_MAT+'.'+CRLF
		cMENS+= 'Favor providenciar nova substituição se necessario.'
		
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
		
		If lAuth
			lRetAuth := MailAuth(cAccount,cPassword)
		Else
			lRetAuth := .T.
		EndIf
		If lRetAuth
			SEND MAIL FROM cFrom TO cDestino CC '' SUBJECT cSubject BODY cMENS RESULT lEnviado
			If !lEnviado
				GET MAIL ERROR cError
				ConOut("Erro ao Enviar E-Mail : " + cError)
			Else
				ConOut("E-Mail enviado com Sucesso")
			EndIf
		Else
			ConOut("Erro ao autenticar no servidor de e-mail")
		EndIf
		
		DISCONNECT SMTP SERVER    
		
		If nDIAS = 30
		   dbselectarea("PA2")
		   PA2->(DbSetOrder(1))
		   PA2->(dbSeek(xFilial("PA2")+TRG1->PA2_MAT))
		   If !eof()
		      RecLock("PA2",.f.)
		      PA2->PA2_EM30 := '1'
	    	  PA2->(MsUnlock()) 
		   ENDIF
		ELSEIf nDIAS = 60
		   dbselectarea("PA2")
		   PA2->(DbSetOrder(1))
		   PA2->(dbSeek(xFilial("PA2")+TRG1->PA2_MAT))
		   If !eof()
		      RecLock("PA2",.f.)
		      PA2->PA2_EM60 := '1'
	    	  PA2->(MsUnlock()) 
		   ENDIF
		ENDIF      
		
	ENDIF
	
	dbSelectArea("TRG1")
	TRG1->(DBSKIP())
	
ENDDO

Return
