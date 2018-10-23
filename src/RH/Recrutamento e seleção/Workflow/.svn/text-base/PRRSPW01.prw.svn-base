#Include "Protheus.ch"
#INCLUDE "Topconn.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRRSPW01
Rotina de envio do workflow da requisição de pessoal para aprovação
@author  	Carlos Henrique
@since     	21/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function PRRSPW01(nOpc,oProcess)
local cObs		:= ""
local lLiberou:= .F.       
local cTab		:= "" 
local cQry		:= ""  
local cWfId	:= ""
local aNotif	:= {}
	
DO 	CASE 	
	//Envia a requisição de pessoal para aprovacao. 
	CASE nOpc == 1
		
		cTab	:= GetNextAlias()
		
	  	cQry := " SELECT ZZK.R_E_C_N_O_ RECZZK FROM "+RETSQLNAME("ZZK")+" ZZK"+CRLF
	  	cQry += " WHERE ZZK_FILIAL='"+xfilial("ZZK")+"'"+CRLF
	  	cQry += " 	AND ZZK_STATUS='1'"+CRLF
	  	cQry += " 	AND ZZK_WF=''"+CRLF
	  	cQry += " 	AND ZZK.D_E_L_E_T_=''"+CRLF
	  	cQry += " ORDER BY ZZK.R_E_C_N_O_"+CRLF
	  	                             
		TcQuery cQry NEW ALIAS (cTab)	                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())			
			DBSelectarea("ZZK")
			ZZK->(DBGoto((cTab)->RECZZK))
			IF !ZZK->(EOF())
				Reclock("ZZK",.F.)
				ZZK->ZZK_WF:= "1"
				MSUnlock()     		
								
				cWfId := PR20W01ENV(nOpc,ZZK->ZZK_FILIAL,TRIM(ZZK->ZZK_NUMREQ),{ZZK->ZZK_MATAPR},;
						ZZK->(ZZK_FILIAL+ZZK_NUMREQ+ZZK_DEPTO+ZZK_MATAPR),"","")										

				Reclock("ZZK",.F.)
				ZZK->ZZK_WF		:= IIF(EMPTY(cWfId),"","1")  		// WF 	  1 - Realizado o envio /  - Não Realizado o envio
	  			ZZK->ZZK_WFID		:= cWfId							// Rastreabilidade
				MSUnlock()     
			ENDIF
				
		(cTab)->(DBSkip())
		END
		
		(cTab)->(dbCloseArea())
		                
	//Processa retorno de aprovação
	CASE nOpc	== 2

		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cFilAnt	:= alltrim(oProcess:oHtml:RetByName("CFILANT"))

		cWFID     	:= oProcess:fProcessId
		cTo   		:= oProcess:cTo
		cChaveZZK	:= Rtrim(oProcess:oHtml:RetByName("CHAVE"))
		oProcess:Finish() // FINALIZA O PROCESSO

		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao			                  				
			// Posiciona na tabela de Alcadas 
			DBSelectArea("ZZK")
			DBSetOrder(1)
			DBSeek(cChaveZZK)      
			IF !FOUND() .OR. TRIM(ZZK->ZZK_WFID) <> TRIM(cWFID)
				CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + ZZK->ZZK_WFID)
				Return .T.
			ENDIF
			
			RECLOCK("ZZK",.F.)     
				ZZK->ZZK_STATUS	:= IIF(cOpc=="N","3","2")
				ZZK->ZZK_WF		:= "2"			// Status 2 - respondido
				ZZK->ZZK_OBS		:= cObs 
				ZZK->ZZK_DATLIB 	:= date() 
				ZZK->ZZK_HORLIB 	:= time()
			MSUNLOCK()	
			
			lLiberou := PR20W01LIB(ZZK->ZZK_NUMREQ)

			If lLiberou 
				
				dbselectarea("ZZJ")
				ZZJ->( dbSetOrder(1) )
				ZZJ->( dbSeek( xFilial( "ZZJ" ) + ZZK->ZZK_NUMREQ ) )
				While ZZJ->( !EOF() ) .And.  ZZJ->(ZZJ_FILIAL+ZZJ_NUMREQ) == xFilial("ZZJ")+ZZK->ZZK_NUMREQ
					aNotif:= { ZZJ->ZZJ_USRRES }
					RecLock( "ZZJ", .F. )
	              ZZJ->ZZJ_STATUS:=  IIF(cOpc=="N","3","4")
	              ZZJ->( MsUnlock() )
				ZZJ->( dbSkip() )
				ENDDO		
				
				PR20W01NOT(ZZK->ZZK_NUMREQ,@aNotif)
				PR20W01ENV(2,ZZK->ZZK_FILIAL,TRIM(ZZK->ZZK_NUMREQ),aNotif,;
							ZZK->(ZZK_FILIAL+ZZK_NUMREQ+ZZK_DEPTO+ZZK_MATAPR),ZZJ->ZZJ_STATUS,TRIM(cObs))					
												   					       			   	     			      			       
		  	ELSEIF cOpc == "N" 			  		
		  										  
				dbselectarea("ZZJ")
				ZZJ->( dbSetOrder(1) )
				ZZJ->( dbSeek( xFilial( "ZZJ" ) + ZZK->ZZK_NUMREQ ) )
				While ZZJ->( !EOF() ) .And.  ZZJ->(ZZJ_FILIAL+ZZJ_NUMREQ) == xFilial("ZZJ")+ZZK->ZZK_NUMREQ
					aNotif:= { ZZJ->ZZJ_USRRES }
					RecLock( "ZZJ", .F. )
	              ZZJ->ZZJ_STATUS:=  "3"
	              ZZJ->( MsUnlock() )
				ZZJ->( dbSkip() )
				ENDDO
				
				PR20W01NOT(ZZK->ZZK_NUMREQ,@aNotif)
				PR20W01ENV(2,ZZK->ZZK_FILIAL,TRIM(ZZK->ZZK_NUMREQ),aNotif,;
						ZZK->(ZZK_FILIAL+ZZK_NUMREQ+ZZK_DEPTO+ZZK_MATAPR),ZZJ->ZZJ_STATUS,TRIM(cObs))							
			
			ELSE
				// Executa rotina de envio do workflow
				U_PRRSPW01(1)										 				             
			ENDIF
		EndIf				
		
	//Processa cancelamento de aprovação
	CASE nOpc	== 3		

		PR20W01NOT(ZZJ->ZZJ_NUMREQ,@aNotif)
		PR20W01ENV(3,	ZZJ->ZZJ_FILIAL,TRIM(ZZJ->ZZJ_NUMREQ),aNotif,;
				ZZJ->(ZZJ_FILIAL+ZZJ_NUMREQ),ZZJ->ZZJ_STATUS,TRIM(cMotExc))	
		
	END CASE			
				
RETURN  
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20W01LIB
Verifica se possui outros niveis para aprovar 
@author  	Carlos Henrique
@since     	21/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
static function PR20W01LIB(cNumReq)
local cTab	:= GetNextAlias() 
local lRet	:= .t.
local cQry	:= ""
LOCAL nCnt	:= 0

DBSELECTAREA("ZZK")

cQry := " SELECT * FROM "+RETSQLNAME("ZZK")+" ZZK"+CRLF
cQry += " WHERE ZZK_FILIAL='"+xfilial("ZZK")+"'"+CRLF
cQry += " 	AND ZZK_STATUS=''"+CRLF
cQry += " 	AND ZZK_NUMREQ='"+cNumReq+"'"+CRLF
cQry += " 	AND ZZK.D_E_L_E_T_=''"+CRLF 
cQry += " 	ORDER BY R_E_C_N_O_ "+CRLF
  	
TcQuery cQry NEW ALIAS (cTab)	                                                   
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	nCnt++	
	// Proximo nivel Workflow
	IF nCnt == 1 .AND. EMPTY((cTab)->ZZK_STATUS)
		ZZK->(DBGOTO((cTab)->R_E_C_N_O_ ))
		IF ZZK->(!EOF())
			RECLOCK("ZZK",.F.)
				ZZK->ZZK_STATUS:= "1"
			MSUNLOCK()
		ENDIF
	ENDIF
(cTab)->(dbskip())
END

(cTab)->(dbCloseArea())

lRet:= nCnt == 0		
		
return lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20W01ENV
Rotina de envio do workflow
@author  	Carlos Henrique
@since     	21/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
static function PR20W01ENV(nOpc,cFilAux,cNumDoc,aCodUsr,cChave,cStatus,cObs)
Local aArea		:= GETAREA()
Local cHttp		:= GetNewPar("MV_WFDHTTP","")
Local cMailAdm	:= GetNewPar("MV_WFADMIN","")
Local cTo			:= ""
Local cWfId		:= ""
Local oProcess	:= NIL
Local oHtml		:= NIL
Local cHtmlCheck	:= ""
Local cUrlWF 		:= ""
Local cPath 		:= "" 
Local cNomeApr	:= ""
Local nCnt			:= 0   
LOCAL cSituaca	:= "" 
LOCAL lBloq 		:= .F. 
LOCAL lAprPre		:= .F.
LOCAL cMatPre		:= ""
LOCAL cHtmCmp		:= ""
Local cTabZZK		:= ""
Local cQry			:= ""

FOR nCnt:= 1 TO LEN(aCodUsr)
	DBSELECTAREA("SRA")
	SRA->(DBSETORDER(1))
	IF SRA->(DBSEEK(XFILIAL("SRA")+aCodUsr[nCnt]))
		cTo	+= TRIM(SRA->RA_EMAIL)+";"
		IF nCnt == 1 .and. nOpc == 1
			cNomeApr	:= TRIM(SRA->RA_NOME)
		ENDIF	
	ENDIF	
NEXT nCnt
       
//obtem o url que vai no link via e-mail
cUrlWF := SuperGetMV("ES_WFURL",,"http://localhost:8089/") // [10.42.92.53:8089/wf0100]
	
If Right( cUrlWF, 1) != "/"
	cUrlWF += "/"
EndIF
cPath:=cUrlWF+"messenger/emp"+Alltrim(cEmpAnt)+"/WfProdam/" 
       
DO CASE
	//-- Envio de email para aprovacao
	CASE nOpc == 1		
		
		oProcess:= TWFProcess():New( "APRVRP", "Envio Aprovacao RP :" + cNumDoc )
		oProcess:NewTask( "Envio RP : "+xFilial('ZAJ') + cNumDoc, "\WORKFLOW\APROV_RP.HTM" )
		oProcess:cSubject	:= "Aprovacao da requisicao de pessoal - " + cNumDoc
		oProcess:bReturn 	:= ""
		oProcess:NewVersion(.T.)
		oProcess:cTo     	:= "" //cTo
		oProcess:cBody	:= ""
		oHtml     			:= oProcess:oHTML
		
		//-- Variaveis ocultas p/ rastreabilidade
		oHtml:ValByName( "CFILANT"	, xFilial("SCR"))	
		oHtml:ValByName( "CEMPANT"	, cEmpAnt)
		oHtml:ValByName( "CHAVE"		, cChave)	
		oHtml:ValByName( "WFID"		, oProcess:fProcessId)
		
	CASE nOpc == 2 //Retorno do Aprovador		
		
		oProcess:= TWFProcess():New( "APRVRP", "Posição de RP :" + cNumDoc )
		oProcess:NewTask( "Final RC : "+xFilial('ZZJ') + cNumDoc, "\WORKFLOW\RESP_RP.HTM" )
		oProcess:cSubject:= "Posicao de Aprovacao da requisicao de pessoal - " + cNumDoc
		oProcess:NewVersion(.T.)
		oProcess:cTo    	:= cTo 
		oHtml     			:= oProcess:oHTML

	CASE nOpc == 3 //cancelamento da aprovação		
		
		oProcess:= TWFProcess():New( "APRVRP", "Posição de RP :" + cNumDoc )
		oProcess:NewTask( "Final RC : "+xFilial('ZZJ') + cNumDoc, "\WORKFLOW\RESP_RP.HTM" )
		oProcess:cSubject:= "Cancelamento da Aprovacao da requisicao de pessoal - " + cNumDoc
		oProcess:NewVersion(.T.)
		oProcess:cTo    	:= cTo 
		oHtml     			:= oProcess:oHTML
				
EndCase
	               
dbSelectArea("ZZJ")
dbSetOrder(1)
If dbSeek(xfilial("ZZJ")+cNumDoc)
	oHtml:ValByName( "ZZJ_NUMREQ"	, ZZJ->ZZJ_NUMREQ )
	oHtml:ValByName( "ZZJ_DATA"		, DTOC(ZZJ->ZZJ_DATA) )
	oHtml:ValByName( "ZZJ_DESCRI"  	, ZZJ->ZZJ_DESCRI )
	oHtml:ValByName( "ZZJ_NRVAGA"	, CVALTOCHAR(ZZJ->ZZJ_NRVAGA) )	
	
	oHtml:ValByName( "ZZJ_MATDIR"	, ZZJ->ZZJ_MATDIR )	
	oHtml:ValByName( "ZZJ_NOMDIR"	, ZZJ->ZZJ_NOMDIR )	
	oHtml:ValByName( "ZZJ_DEPDIR"	, POSICIONE("SQB",1,XFILIAL("SQB")+ZZJ->ZZJ_DEPDIR,"QB_DESCRIC") )
	
	oHtml:ValByName( "ZZJ_MATGER"	, ZZJ->ZZJ_MATGER )
	oHtml:ValByName( "ZZJ_NOMGER"	, ZZJ->ZZJ_NOMGER )	
	oHtml:ValByName( "ZZJ_DEPGER"	, POSICIONE("SQB",1,XFILIAL("SQB")+ZZJ->ZZJ_DEPGER,"QB_DESCRIC") )

	oHtml:ValByName( "ZZJ_MATCOR"	, ZZJ->ZZJ_MATCOR )
	oHtml:ValByName( "ZZJ_NOMCOR"	, ZZJ->ZZJ_NOMCOR )	
	oHtml:ValByName( "ZZJ_DEPCOR"	, POSICIONE("SQB",1,XFILIAL("SQB")+ZZJ->ZZJ_DEPCOR,"QB_DESCRIC") )

	
	oHtml:ValByName( "ZZJ_TURNO"	, ZZJ->ZZJ_TURNO )
	oHtml:ValByName( "ZZJ_HRTRA"	, ZZJ->ZZJ_HRTRA )
	oHtml:ValByName( "ZZJ_CARGO"	, ZZJ->ZZJ_CARGO )
	oHtml:ValByName( "ZZJ_DSCARG"	, ZZJ->ZZJ_DSCARG )
	oHtml:ValByName( "ZZJ_ESPEC"	, ZZJ->ZZJ_ESPEC )
	
	IF ZZJ->ZZJ_QUADRO
		oHtml:ValByName( "ZZJ_QUADRO"	, 'checked' )
	ELSE
		oHtml:ValByName( "ZZJ_QUADRO"	, '' )
	ENDIF	

	IF ZZJ->ZZJ_SUBST
		oHtml:ValByName( "ZZJ_SUBST"	, 'checked' )
	ELSE
		oHtml:ValByName( "ZZJ_SUBST"	, '' )
	ENDIF
	
	oHtml:ValByName( "ZZJ_NOMSUB"	, ZZJ->ZZJ_NOMSUB )
	IF !EMPTY(ZZJ->ZZJ_MESBAS)
		oHtml:ValByName( "ZZJ_MESBAS"	, UPPER(MesExtenso(CTOD("01/"+ZZJ->ZZJ_MESBAS)) + " de "+right(ZZJ->ZZJ_MESBAS,4)))
	ENDIF	
	oHtml:ValByName( "ZZJ_SALARI"	, TRANSFORM(ZZJ->ZZJ_SALARI,PESQPICT("ZZJ","ZZJ_SALARI")) )
	oHtml:ValByName( "ZZJ_FAIXA"	, ZZJ->ZZJ_FAIXA )
	oHtml:ValByName( "ZZJ_NIVEL"	, ZZJ->ZZJ_NIVEL )
	oHtml:ValByName( "ZZJ_OBS"		, ZZJ->ZZJ_OBS )
EndIf

IF nOpc == 1		
	//-- Primeiro envio para Aprovação
	oProcess:bReturn := "u_PRRSPW01(2)"
             
	cRootDir:=oProcess:oWF:cRootDir //-->  \workflow\emp99\	
	cProcess := oProcess:Start(cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cProcess + ".htm"
	
	//-- Cria nova tarefa para enviar um e-mail com o link do HMTL de aprovação.
	oProcess:NewTask("Link RC", "\workflow\Link.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	oProcess:NewVersion(.T.)
	oProcess:cTo		:= cTo 
	oProcess:cSubject	:= "Aprovacao da requisicao de pessoal - Filial: "+xFilial('ZZJ')+" / Numero: "+cNumDoc
	
	oHtml    := oProcess:oHTML
	oHtml:ValByName( "cnome",cNomeApr)
	oHtml:ValByName( "descproc"	 , "da requisição de pessoal n° "+cNumDoc)

	//-- Link de Aprovação.
	oHtml:ValByName("proclink",cPath+cHtmlFile)
	cProcess := oProcess:Start(cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\")
	
	cWfId:= oProcess:fProcessId

ELSEIF nOpc == 2
	
	cTabZZK:= GetNextAlias()
	
  	cQry := " SELECT * FROM "+RETSQLNAME("ZZK")+" ZZK"+CRLF
  	cQry += " WHERE ZZK_FILIAL='"+xfilial("ZZK")+"'"+CRLF
  	cQry += " 	AND ZZK_NUMREQ='"+cNumDoc+"'"+CRLF
  	cQry += " 	AND ZZK.D_E_L_E_T_=''"+CRLF
  	cQry += " ORDER BY ZZK.R_E_C_N_O_"+CRLF
  	                             
	TcQuery cQry NEW ALIAS (cTabZZK)
	
	TCSETFIELD(cTabZZK,"ZZK_DATLIB","D")
	
	(cTabZZK)->(dbSelectArea((cTabZZK)))                    
	(cTabZZK)->(dbGoTop())                               	
	WHILE (cTabZZK)->(!EOF())

		IF EMPTY((cTabZZK)->ZZK_STATUS)
			IF lBloq
				AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
			ELSE
				AAdd((oHtml:ValByName( "A.1"	)), "Aguardando" )
			ENDIF					
		ELSEIF (cTabZZK)->ZZK_STATUS == "1"
			cSituaca := "Em Aprovação"		
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
		ELSEIF (cTabZZK)->ZZK_STATUS == "2"
			cSituaca := "Aprovada"
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca)
		ELSEIF (cTabZZK)->ZZK_STATUS == "3"
			cSituaca := "Reprovada"
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
		ENDIF
		
		AAdd((oHtml:ValByName( "A.2"  	)), (cTabZZK)->ZZK_DEPTO)
		AAdd((oHtml:ValByName( "A.3"   	)), (cTabZZK)->ZZK_MATAPR)
		AAdd((oHtml:ValByName( "A.4"   	)), (cTabZZK)->ZZK_NOMAP)
		AAdd((oHtml:ValByName( "A.5"   	)), DTOC((cTabZZK)->ZZK_DATLIB))
		AAdd((oHtml:ValByName( "A.6"   	)), (cTabZZK)->ZZK_HORLIB)

	(cTabZZK)->(dbskip())			
	END
	(cTabZZK)->(dbCloseArea())				
	
	//Adiciona linha de aprovação do Presidente
	lAprPre:= SUPERGETMV("PR_APRPRE",.T.,.F.)
	IF lAprPre
	
		cHtmCmp+= "<table style='width: 100%;' class='SitTable' cellspacing='1'>"	
		cHtmCmp+= "<tr>"
		cHtmCmp+= "     <td width='40%' class='AprovSitTit'>Situação da requisição:</td>"
		cHtmCmp+= "	<td width='60%' class='AprovSitItem'>"+cSituaca+"</td>"
		cHtmCmp+= "</tr>"
		cHtmCmp+= "</table>"
			
		oHtml:ValByName( "HTMCOMP"	, cHtmCmp )	
	ELSE
		cMatPre:= SUPERGETMV("PR_MATPRE",.T.,"")
		
		cHtmCmp+= "<br>"
		cHtmCmp+= "<h3>"
		cHtmCmp+= "	Aprovação do Presidente"
		cHtmCmp+= "</h3>"
		cHtmCmp+= "<table style='width: 100%;' class='ManTable' cellspacing='1'>"
		cHtmCmp+= "	<tr>"
		cHtmCmp+= "		<td width='10%' class='ManHeader'>Departamento</td>"
		cHtmCmp+= "		<td width='10%' class='ManHeader'>Matricula</td>"
		cHtmCmp+= "		<td width='45%' class='ManHeader'>Nome</td>"
		cHtmCmp+= "		<td width='20%' class='ManHeader'>Assinatura</td>"
		cHtmCmp+= "		<td width='10%' class='ManHeader'>Data</td>"
		cHtmCmp+= "		<td width='5%' class='ManHeader'>Hora</td>"
		cHtmCmp+= "	</tr>"
		cHtmCmp+= "	<tbody>"
		cHtmCmp+= "	<tr>"
		cHtmCmp+= "		<td class='ManItens'>"+POSICIONE("SRA",1,XFILIAL("SRA")+cMatPre,"RA_CC")+"</td>"
		cHtmCmp+= "		<td class='ManItens'>"+cMatPre+"</td>"
		cHtmCmp+= "		<td class='ManItens'>"+POSICIONE("SRA",1,XFILIAL("SRA")+cMatPre,"RA_NOME")+"</td>"
		cHtmCmp+= "		<td class='ManItens'>&nbsp;</td>"
		cHtmCmp+= "		<td class='ManItens'>&nbsp;</td>"
		cHtmCmp+= "		<td class='ManItens'>&nbsp;</td>"
		cHtmCmp+= "	</tr>"
		cHtmCmp+= "	</tbody>"
		cHtmCmp+= "</table>"

		oHtml:ValByName( "HTMCOMP"	, cHtmCmp )
	ENDIF		

	cProcess := oProcess:Start(cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\"+ cProcess + ".htm"	
		
	dbSelectArea("ZZJ")
	dbSetOrder(1)
	If dbSeek(xfilial("ZZJ")+cNumDoc)	
		RECLOCK("ZZJ",.F.)
		ZZJ->ZZJ_HTMAPR:= Encode64(memoread(cHtmlFile))
		MSUNLOCK()
	ENDIF
	
	FERASE(cHtmlFile)	
	
	oProcess:Finish()		

ELSEIF nOpc == 3

	cTabZZK:= GetNextAlias()
	
  	cQry := " SELECT * FROM "+RETSQLNAME("ZZK")+" ZZK"+CRLF
  	cQry += " WHERE ZZK_FILIAL='"+xfilial("ZZK")+"'"+CRLF
  	cQry += " 	AND ZZK_NUMREQ='"+cNumDoc+"'"+CRLF
  	cQry += " 	AND ZZK.D_E_L_E_T_=''"+CRLF
  	cQry += " ORDER BY ZZK.R_E_C_N_O_"+CRLF
  	                             
	TcQuery cQry NEW ALIAS (cTabZZK)
	
	TCSETFIELD(cTabZZK,"ZZK_DATLIB","D")
	
	(cTabZZK)->(dbSelectArea((cTabZZK)))                    
	(cTabZZK)->(dbGoTop())                               	
	WHILE (cTabZZK)->(!EOF())

		IF EMPTY((cTabZZK)->ZZK_STATUS)
			IF lBloq
				AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
			ELSE
				AAdd((oHtml:ValByName( "A.1"	)), "Aguardando" )
			ENDIF					
		ELSEIF (cTabZZK)->ZZK_STATUS == "1"
			cSituaca := "Em Aprovação"		
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
		ELSEIF (cTabZZK)->ZZK_STATUS == "2"
			cSituaca := "Aprovada"
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca)
		ELSEIF (cTabZZK)->ZZK_STATUS == "3"
			cSituaca := "Reprovada"
			AAdd((oHtml:ValByName( "A.1"	)), cSituaca )
		ENDIF
		
		AAdd((oHtml:ValByName( "A.2"  	)), (cTabZZK)->ZZK_DEPTO)
		AAdd((oHtml:ValByName( "A.3"   	)), (cTabZZK)->ZZK_MATAPR)
		AAdd((oHtml:ValByName( "A.4"   	)), (cTabZZK)->ZZK_NOMAP)
		AAdd((oHtml:ValByName( "A.5"   	)), DTOC((cTabZZK)->ZZK_DATLIB))
		AAdd((oHtml:ValByName( "A.6"   	)), (cTabZZK)->ZZK_HORLIB)

	(cTabZZK)->(dbskip())			
	END
	(cTabZZK)->(dbCloseArea())	

	cHtmCmp+= " <table style='width: 100%;' border='0' cellspacing='1'>
	cHtmCmp+= "   <tbody>
	cHtmCmp+= " 	<tr>
	cHtmCmp+= " 		<td align='center' colspan='3' height='15' width='100%' bgcolor='#3F5B7B'><b><i><font face='Arial' size='3' color='#FFFFFF'>Motivo de cancelamento:</font></i></b></td>
	cHtmCmp+= " 	</tr>	
	cHtmCmp+= " 	<tr>
	cHtmCmp+= " 		<td width='100%' colspan='3' align='LEFT'>
	cHtmCmp+= " 			<textarea name='MOTIVO' rows='5' cols='50' style='width:100%;'>"+cObs+"</textarea>
	cHtmCmp+= " 		</td>
	cHtmCmp+= " 	</tr>	
	cHtmCmp+= "   </tbody>  
	cHtmCmp+= " </table>

	oHtml:ValByName( "HTMCOMP"	, cHtmCmp )

	cProcess := oProcess:Start(cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cHttp+IIf(Right(Alltrim(cHttp),1)=="\","","\")+"messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\"+ cProcess + ".htm"	
		
	dbSelectArea("ZZJ")
	dbSetOrder(1)
	If dbSeek(xfilial("ZZJ")+cNumDoc)	
		RECLOCK("ZZJ",.F.)
		ZZJ->ZZJ_HTMAPR:= Encode64(memoread(cHtmlFile))
		MSUNLOCK()
	ENDIF
	
	FERASE(cHtmlFile)	
	
	oProcess:Finish()		

Endif

RESTAREA(aArea)
Return cWfId
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20W01NOT
Seleciona os participantes da aprovação da Requisição de pessoal
@author  	Carlos Henrique
@since     	21/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
static function PR20W01NOT(cNumDoc,aNotif)
Local cTab	:= GetNextAlias()

BeginSql Alias cTab
	SELECT ZZK_MATAPR FROM %TABLE:ZZK% ZZK  
	WHERE ZZK_FILIAL=%xfilial:ZZK%
	AND ZZK_NUMREQ=%exp:cNumDoc%
	AND ZZK.D_E_L_E_T_ =''
EndSql
//GETLastQuery()[2]

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	IF ASCAN(aNotif,{|x| x==(cTab)->ZZK_MATAPR }) == 0
		AADD(aNotif,(cTab)->ZZK_MATAPR)
	ENDIF
(cTab)->(dbskip())			
END
(cTab)->(dbCloseArea())				

RETURN