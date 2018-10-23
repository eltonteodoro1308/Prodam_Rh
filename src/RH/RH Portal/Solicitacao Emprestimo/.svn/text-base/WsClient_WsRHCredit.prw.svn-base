#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8888/ws/RHCREDIT.apw?WSDL
Gerado em        04/15/16 15:30:50
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FJXQPHK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRHCREDIT
------------------------------------------------------------------------------- */

WSCLIENT WSRHCREDIT

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD BROWSECREDIT
	WSMETHOD SENDCREDIT

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cBRANCH                   AS string
	WSDATA   cREGISTRATION             AS string
	WSDATA   oWSBROWSECREDITRESULT     AS RHCREDIT_TCREDITBROWSE
	WSDATA   cVALCREDIT                AS string
	WSDATA   cDESCCREDIT               AS string
	WSDATA   cSENDCREDITRESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRHCREDIT
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRHCREDIT
	::oWSBROWSECREDITRESULT := RHCREDIT_TCREDITBROWSE():New()
Return

WSMETHOD RESET WSCLIENT WSRHCREDIT
	::cBRANCH            := NIL 
	::cREGISTRATION      := NIL 
	::oWSBROWSECREDITRESULT := NIL 
	::cVALCREDIT         := NIL 
	::cDESCCREDIT        := NIL 
	::cSENDCREDITRESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRHCREDIT
Local oClone := WSRHCREDIT():New()
	oClone:_URL          := ::_URL 
	oClone:cBRANCH       := ::cBRANCH
	oClone:cREGISTRATION := ::cREGISTRATION
	oClone:oWSBROWSECREDITRESULT :=  IIF(::oWSBROWSECREDITRESULT = NIL , NIL ,::oWSBROWSECREDITRESULT:Clone() )
	oClone:cVALCREDIT    := ::cVALCREDIT
	oClone:cDESCCREDIT   := ::cDESCCREDIT
	oClone:cSENDCREDITRESULT := ::cSENDCREDITRESULT
Return oClone

// WSDL Method BROWSECREDIT of Service WSRHCREDIT

WSMETHOD BROWSECREDIT WSSEND cBRANCH,cREGISTRATION WSRECEIVE oWSBROWSECREDITRESULT WSCLIENT WSRHCREDIT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BROWSECREDIT xmlns="http://localhost:8888/">'
cSoap += WSSoapValue("BRANCH", ::cBRANCH, cBRANCH , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("REGISTRATION", ::cREGISTRATION, cREGISTRATION , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</BROWSECREDIT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8888/BROWSECREDIT",; 
	"DOCUMENT","http://localhost:8888/",,"1.031217",; 
	"http://localhost:8888/ws/RHCREDIT.apw")

::Init()
::oWSBROWSECREDITRESULT:SoapRecv( WSAdvValue( oXmlRet,"_BROWSECREDITRESPONSE:_BROWSECREDITRESULT","TCREDITBROWSE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SENDCREDIT of Service WSRHCREDIT

WSMETHOD SENDCREDIT WSSEND cBRANCH,cREGISTRATION,cVALCREDIT,cDESCCREDIT WSRECEIVE cSENDCREDITRESULT WSCLIENT WSRHCREDIT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SENDCREDIT xmlns="http://localhost:8888/">'
cSoap += WSSoapValue("BRANCH", ::cBRANCH, cBRANCH , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("REGISTRATION", ::cREGISTRATION, cREGISTRATION , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VALCREDIT", ::cVALCREDIT, cVALCREDIT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DESCCREDIT", ::cDESCCREDIT, cDESCCREDIT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SENDCREDIT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8888/SENDCREDIT",; 
	"DOCUMENT","http://localhost:8888/",,"1.031217",; 
	"http://localhost:8888/ws/RHCREDIT.apw")

::Init()
::cSENDCREDITRESULT  :=  WSAdvValue( oXmlRet,"_SENDCREDITRESPONSE:_SENDCREDITRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TCREDITBROWSE

WSSTRUCT RHCREDIT_TCREDITBROWSE
	WSDATA   nVALMAX                   AS float OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHCREDIT_TCREDITBROWSE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHCREDIT_TCREDITBROWSE
Return

WSMETHOD CLONE WSCLIENT RHCREDIT_TCREDITBROWSE
	Local oClone := RHCREDIT_TCREDITBROWSE():NEW()
	oClone:nVALMAX              := ::nVALMAX
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHCREDIT_TCREDITBROWSE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nVALMAX            :=  WSAdvValue( oResponse,"_VALMAX","float",NIL,NIL,NIL,"N",NIL,NIL) 
Return


