#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8089/ws/PRESPPON.apw?WSDL
Gerado em        02/21/17 09:48:32
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PNUOOSQ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPRESPPON
------------------------------------------------------------------------------- */

WSCLIENT WSPRESPPON

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETESPBH

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCPAGETYPE                AS string
	WSDATA   cFILTERMINAL              AS string
	WSDATA   cMATTERMINAL              AS string
	WSDATA   cPERAPONTA                AS string
	WSDATA   cSITAPO                   AS string
	WSDATA   cPERFILTRO                AS string
	WSDATA   cGETESPBHRESULT           AS base64Binary

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPRESPPON
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPRESPPON
Return

WSMETHOD RESET WSCLIENT WSPRESPPON
	::cCPAGETYPE         := NIL 
	::cFILTERMINAL       := NIL 
	::cMATTERMINAL       := NIL 
	::cPERAPONTA         := NIL 
	::cSITAPO            := NIL 
	::cPERFILTRO         := NIL 
	::cGETESPBHRESULT    := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPRESPPON
Local oClone := WSPRESPPON():New()
	oClone:_URL          := ::_URL 
	oClone:cCPAGETYPE    := ::cCPAGETYPE
	oClone:cFILTERMINAL  := ::cFILTERMINAL
	oClone:cMATTERMINAL  := ::cMATTERMINAL
	oClone:cPERAPONTA    := ::cPERAPONTA
	oClone:cSITAPO       := ::cSITAPO
	oClone:cPERFILTRO    := ::cPERFILTRO
	oClone:cGETESPBHRESULT := ::cGETESPBHRESULT
Return oClone

// WSDL Method GETESPBH of Service WSPRESPPON

WSMETHOD GETESPBH WSSEND cCPAGETYPE,cFILTERMINAL,cMATTERMINAL,cPERAPONTA,cSITAPO,cPERFILTRO WSRECEIVE cGETESPBHRESULT WSCLIENT WSPRESPPON
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETESPBH xmlns="http://localhost:8089/">'
cSoap += WSSoapValue("CPAGETYPE", ::cCPAGETYPE, cCPAGETYPE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERMINAL", ::cFILTERMINAL, cFILTERMINAL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MATTERMINAL", ::cMATTERMINAL, cMATTERMINAL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PERAPONTA", ::cPERAPONTA, cPERAPONTA , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("SITAPO", ::cSITAPO, cSITAPO , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PERFILTRO", ::cPERFILTRO, cPERFILTRO , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETESPBH>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8089/GETESPBH",; 
	"DOCUMENT","http://localhost:8089/",,"1.031217",; 
	"http://localhost:8089/ws/PRESPPON.apw")

::Init()
::cGETESPBHRESULT    :=  WSAdvValue( oXmlRet,"_GETESPBHRESPONSE:_GETESPBHRESULT:TEXT","base64Binary",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



