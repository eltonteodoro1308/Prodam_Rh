#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8086/ws/WS_BTPESQ.apw?WSDL
Gerado em        09/30/16 11:37:40
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PSRAMBS ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWS_BTPESQ
------------------------------------------------------------------------------- */

WSCLIENT WSWS_BTPESQ

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD SEARCHFUNC

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSSEARCH                 AS WS_BTPESQ_SEARCHSTRU
	WSDATA   oWSSEARCHFUNCRESULT       AS WS_BTPESQ_ARRAYOFSTRING

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSEARCHSTRU             AS WS_BTPESQ_SEARCHSTRU

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWS_BTPESQ
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWS_BTPESQ
	::oWSSEARCH          := WS_BTPESQ_SEARCHSTRU():New()
	::oWSSEARCHFUNCRESULT := WS_BTPESQ_ARRAYOFSTRING():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSEARCHSTRU      := ::oWSSEARCH
Return

WSMETHOD RESET WSCLIENT WSWS_BTPESQ
	::oWSSEARCH          := NIL 
	::oWSSEARCHFUNCRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSEARCHSTRU      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWS_BTPESQ
Local oClone := WSWS_BTPESQ():New()
	oClone:_URL          := ::_URL 
	oClone:oWSSEARCH     :=  IIF(::oWSSEARCH = NIL , NIL ,::oWSSEARCH:Clone() )
	oClone:oWSSEARCHFUNCRESULT :=  IIF(::oWSSEARCHFUNCRESULT = NIL , NIL ,::oWSSEARCHFUNCRESULT:Clone() )

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSEARCHSTRU := oClone:oWSSEARCH
Return oClone

// WSDL Method SEARCHFUNC of Service WSWS_BTPESQ

WSMETHOD SEARCHFUNC WSSEND oWSSEARCH WSRECEIVE oWSSEARCHFUNCRESULT WSCLIENT WSWS_BTPESQ
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SEARCHFUNC xmlns="http://localhost:8086/">'
cSoap += WSSoapValue("SEARCH", ::oWSSEARCH, oWSSEARCH , "SEARCHSTRU", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SEARCHFUNC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8086/SEARCHFUNC",; 
	"DOCUMENT","http://localhost:8086/",,"1.031217",; 
	"http://localhost:8086/ws/WS_BTPESQ.apw")

::Init()
::oWSSEARCHFUNCRESULT:SoapRecv( WSAdvValue( oXmlRet,"_SEARCHFUNCRESPONSE:_SEARCHFUNCRESULT","ARRAYOFSTRING",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure SEARCHSTRU

WSSTRUCT WS_BTPESQ_SEARCHSTRU
	WSDATA   cAREA                     AS string OPTIONAL
	WSDATA   cATIVFUNC                 AS string OPTIONAL
	WSDATA   cCATEG                    AS string OPTIONAL
	WSDATA   cCONHEC                   AS string OPTIONAL
	WSDATA   cCURSOS                   AS string OPTIONAL
	WSDATA   cDEPART                   AS string OPTIONAL
	WSDATA   cNIVEL                    AS string OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cOPERADOR                 AS string OPTIONAL
	WSDATA   cVISAO                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_BTPESQ_SEARCHSTRU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_BTPESQ_SEARCHSTRU
Return

WSMETHOD CLONE WSCLIENT WS_BTPESQ_SEARCHSTRU
	Local oClone := WS_BTPESQ_SEARCHSTRU():NEW()
	oClone:cAREA                := ::cAREA
	oClone:cATIVFUNC            := ::cATIVFUNC
	oClone:cCATEG               := ::cCATEG
	oClone:cCONHEC              := ::cCONHEC
	oClone:cCURSOS              := ::cCURSOS
	oClone:cDEPART              := ::cDEPART
	oClone:cNIVEL               := ::cNIVEL
	oClone:cNOME                := ::cNOME
	oClone:cOPERADOR            := ::cOPERADOR
	oClone:cVISAO               := ::cVISAO
Return oClone

WSMETHOD SOAPSEND WSCLIENT WS_BTPESQ_SEARCHSTRU
	Local cSoap := ""
	cSoap += WSSoapValue("AREA", ::cAREA, ::cAREA , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ATIVFUNC", ::cATIVFUNC, ::cATIVFUNC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CATEG", ::cCATEG, ::cCATEG , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CONHEC", ::cCONHEC, ::cCONHEC , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CURSOS", ::cCURSOS, ::cCURSOS , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DEPART", ::cDEPART, ::cDEPART , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NIVEL", ::cNIVEL, ::cNIVEL , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OPERADOR", ::cOPERADOR, ::cOPERADOR , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VISAO", ::cVISAO, ::cVISAO , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ARRAYOFSTRING

WSSTRUCT WS_BTPESQ_ARRAYOFSTRING
	WSDATA   cSTRING                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_BTPESQ_ARRAYOFSTRING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_BTPESQ_ARRAYOFSTRING
	::cSTRING              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT WS_BTPESQ_ARRAYOFSTRING
	Local oClone := WS_BTPESQ_ARRAYOFSTRING():NEW()
	oClone:cSTRING              := IIf(::cSTRING <> NIL , aClone(::cSTRING) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_BTPESQ_ARRAYOFSTRING
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cSTRING ,  x:TEXT  ) } )
Return


