#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8086/ws/GETZ6Z7Z8.apw?WSDL
Gerado em        04/11/16 17:15:18
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SAIWQRW ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSGETZ6Z7Z8
------------------------------------------------------------------------------- */

WSCLIENT WSGETZ6Z7Z8

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETINFO

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cOPER                     AS string
	WSDATA   cAREA                     AS string
	WSDATA   cCATEGORIA                AS string
	WSDATA   oWSGETINFORESULT          AS GETZ6Z7Z8_ARRAYOFSTRING

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSGETZ6Z7Z8
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151026 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSGETZ6Z7Z8
	::oWSGETINFORESULT   := GETZ6Z7Z8_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSGETZ6Z7Z8
	::cOPER              := NIL 
	::cAREA              := NIL 
	::cCATEGORIA         := NIL 
	::oWSGETINFORESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSGETZ6Z7Z8
Local oClone := WSGETZ6Z7Z8():New()
	oClone:_URL          := ::_URL 
	oClone:cOPER         := ::cOPER
	oClone:cAREA         := ::cAREA
	oClone:cCATEGORIA    := ::cCATEGORIA
	oClone:oWSGETINFORESULT :=  IIF(::oWSGETINFORESULT = NIL , NIL ,::oWSGETINFORESULT:Clone() )
Return oClone

// WSDL Method GETINFO of Service WSGETZ6Z7Z8

WSMETHOD GETINFO WSSEND cOPER,cAREA,cCATEGORIA WSRECEIVE oWSGETINFORESULT WSCLIENT WSGETZ6Z7Z8
Local cSoap := "" , oXmlRet
Local cUrl	:= "http://localhost:8291/" //GetPvProfString("XWEBURL", "name", "", GetAdv97() ) //GetMv("ES_URL")	//,.F.,"http://localhost:8086/")

BEGIN WSMETHOD

cSoap += '<GETINFO xmlns="'+cUrl+'">'
cSoap += WSSoapValue("OPER", ::cOPER, cOPER , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AREA", ::cAREA, cAREA , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CATEGORIA", ::cCATEGORIA, cCATEGORIA , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETINFO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	cUrl+"GETINFO",; 
	"DOCUMENT",cUrl,,"1.031217",; 
	cUrl+"/ws/GETZ6Z7Z8.apw")

::Init()
::oWSGETINFORESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETINFORESPONSE:_GETINFORESULT","ARRAYOFSTRING",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFSTRING

WSSTRUCT GETZ6Z7Z8_ARRAYOFSTRING
	WSDATA   cSTRING                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GETZ6Z7Z8_ARRAYOFSTRING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GETZ6Z7Z8_ARRAYOFSTRING
	::cSTRING              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT GETZ6Z7Z8_ARRAYOFSTRING
	Local oClone := GETZ6Z7Z8_ARRAYOFSTRING():NEW()
	oClone:cSTRING              := IIf(::cSTRING <> NIL , aClone(::cSTRING) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GETZ6Z7Z8_ARRAYOFSTRING
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cSTRING ,  x:TEXT  ) } )
Return


