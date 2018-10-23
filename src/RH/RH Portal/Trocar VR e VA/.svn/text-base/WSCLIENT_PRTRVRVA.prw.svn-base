#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.10.73.94:8089/ws/PRTRVRVA.apw?WSDL
Gerado em        07/08/16 17:41:17
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WAAORVK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPRTRVRVA
------------------------------------------------------------------------------- */

WSCLIENT WSPRTRVRVA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETVAVR
	WSMETHOD PUTVAVR

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cFILIALFUN                AS string
	WSDATA   cMATRICULA                AS string
	WSDATA   oWSGETVAVRRESULT          AS PRTRVRVA_AESTVAVR
	WSDATA   cRECNOVR                  AS string
	WSDATA   cCODVR                    AS string
	WSDATA   cRECNOVA                  AS string
	WSDATA   cCODVA                    AS string
	WSDATA   cPUTVAVRRESULT            AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPRTRVRVA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPRTRVRVA
	::oWSGETVAVRRESULT   := PRTRVRVA_AESTVAVR():New()
Return

WSMETHOD RESET WSCLIENT WSPRTRVRVA
	::cFILIALFUN         := NIL 
	::cMATRICULA         := NIL 
	::oWSGETVAVRRESULT   := NIL 
	::cRECNOVR           := NIL 
	::cCODVR             := NIL 
	::cRECNOVA           := NIL 
	::cCODVA             := NIL 
	::cPUTVAVRRESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPRTRVRVA
Local oClone := WSPRTRVRVA():New()
	oClone:_URL          := ::_URL 
	oClone:cFILIALFUN    := ::cFILIALFUN
	oClone:cMATRICULA    := ::cMATRICULA
	oClone:oWSGETVAVRRESULT :=  IIF(::oWSGETVAVRRESULT = NIL , NIL ,::oWSGETVAVRRESULT:Clone() )
	oClone:cRECNOVR      := ::cRECNOVR
	oClone:cCODVR        := ::cCODVR
	oClone:cRECNOVA      := ::cRECNOVA
	oClone:cCODVA        := ::cCODVA
	oClone:cPUTVAVRRESULT := ::cPUTVAVRRESULT
Return oClone

// WSDL Method GETVAVR of Service WSPRTRVRVA

WSMETHOD GETVAVR WSSEND cFILIALFUN,cMATRICULA WSRECEIVE oWSGETVAVRRESULT WSCLIENT WSPRTRVRVA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETVAVR xmlns="http://10.10.73.94:8089/">'
cSoap += WSSoapValue("FILIALFUN", ::cFILIALFUN, cFILIALFUN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MATRICULA", ::cMATRICULA, cMATRICULA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETVAVR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.10.73.94:8089/GETVAVR",; 
	"DOCUMENT","http://10.10.73.94:8089/",,"1.031217",; 
	"http://10.10.73.94:8089/ws/PRTRVRVA.apw")

::Init()
::oWSGETVAVRRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETVAVRRESPONSE:_GETVAVRRESULT","AESTVAVR",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PUTVAVR of Service WSPRTRVRVA

WSMETHOD PUTVAVR WSSEND cRECNOVR,cCODVR,cRECNOVA,cCODVA WSRECEIVE cPUTVAVRRESULT WSCLIENT WSPRTRVRVA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PUTVAVR xmlns="http://10.10.73.94:8089/">'
cSoap += WSSoapValue("RECNOVR", ::cRECNOVR, cRECNOVR , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CODVR", ::cCODVR, cCODVR , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("RECNOVA", ::cRECNOVA, cRECNOVA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CODVA", ::cCODVA, cCODVA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</PUTVAVR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.10.73.94:8089/PUTVAVR",; 
	"DOCUMENT","http://10.10.73.94:8089/",,"1.031217",; 
	"http://10.10.73.94:8089/ws/PRTRVRVA.apw")

::Init()
::cPUTVAVRRESULT     :=  WSAdvValue( oXmlRet,"_PUTVAVRRESPONSE:_PUTVAVRRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure AESTVAVR

WSSTRUCT PRTRVRVA_AESTVAVR
	WSDATA   cDEPARTAMENTO             AS string
	WSDATA   cDIAFIM                   AS string
	WSDATA   cDIAINI                   AS string
	WSDATA   cDTADMISSAO               AS string
	WSDATA   cFILIALFUN                AS string
	WSDATA   cMATRICULA                AS string
	WSDATA   cNOME                     AS string
	WSDATA   cRECNOVA                  AS string
	WSDATA   cRECNOVR                  AS string
	WSDATA   oWSTABOPCOES              AS PRTRVRVA_ARRAYOFATABVAVR
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRTRVRVA_AESTVAVR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRTRVRVA_AESTVAVR
Return

WSMETHOD CLONE WSCLIENT PRTRVRVA_AESTVAVR
	Local oClone := PRTRVRVA_AESTVAVR():NEW()
	oClone:cDEPARTAMENTO        := ::cDEPARTAMENTO
	oClone:cDIAFIM              := ::cDIAFIM
	oClone:cDIAINI              := ::cDIAINI
	oClone:cDTADMISSAO          := ::cDTADMISSAO
	oClone:cFILIALFUN           := ::cFILIALFUN
	oClone:cMATRICULA           := ::cMATRICULA
	oClone:cNOME                := ::cNOME
	oClone:cRECNOVA             := ::cRECNOVA
	oClone:cRECNOVR             := ::cRECNOVR
	oClone:oWSTABOPCOES         := IIF(::oWSTABOPCOES = NIL , NIL , ::oWSTABOPCOES:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRTRVRVA_AESTVAVR
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDEPARTAMENTO      :=  WSAdvValue( oResponse,"_DEPARTAMENTO","string",NIL,"Property cDEPARTAMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDIAFIM            :=  WSAdvValue( oResponse,"_DIAFIM","string",NIL,"Property cDIAFIM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDIAINI            :=  WSAdvValue( oResponse,"_DIAINI","string",NIL,"Property cDIAINI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDTADMISSAO        :=  WSAdvValue( oResponse,"_DTADMISSAO","string",NIL,"Property cDTADMISSAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFILIALFUN         :=  WSAdvValue( oResponse,"_FILIALFUN","string",NIL,"Property cFILIALFUN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMATRICULA         :=  WSAdvValue( oResponse,"_MATRICULA","string",NIL,"Property cMATRICULA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cRECNOVA           :=  WSAdvValue( oResponse,"_RECNOVA","string",NIL,"Property cRECNOVA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cRECNOVR           :=  WSAdvValue( oResponse,"_RECNOVR","string",NIL,"Property cRECNOVR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode10 :=  WSAdvValue( oResponse,"_TABOPCOES","ARRAYOFATABVAVR",NIL,"Property oWSTABOPCOES as s0:ARRAYOFATABVAVR on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode10 != NIL
		::oWSTABOPCOES := PRTRVRVA_ARRAYOFATABVAVR():New()
		::oWSTABOPCOES:SoapRecv(oNode10)
	EndIf
Return

// WSDL Data Structure ARRAYOFATABVAVR

WSSTRUCT PRTRVRVA_ARRAYOFATABVAVR
	WSDATA   oWSATABVAVR               AS PRTRVRVA_ATABVAVR OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRTRVRVA_ARRAYOFATABVAVR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRTRVRVA_ARRAYOFATABVAVR
	::oWSATABVAVR          := {} // Array Of  PRTRVRVA_ATABVAVR():New()
Return

WSMETHOD CLONE WSCLIENT PRTRVRVA_ARRAYOFATABVAVR
	Local oClone := PRTRVRVA_ARRAYOFATABVAVR():NEW()
	oClone:oWSATABVAVR := NIL
	If ::oWSATABVAVR <> NIL 
		oClone:oWSATABVAVR := {}
		aEval( ::oWSATABVAVR , { |x| aadd( oClone:oWSATABVAVR , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRTRVRVA_ARRAYOFATABVAVR
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ATABVAVR","ATABVAVR",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSATABVAVR , PRTRVRVA_ATABVAVR():New() )
			::oWSATABVAVR[len(::oWSATABVAVR)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ATABVAVR

WSSTRUCT PRTRVRVA_ATABVAVR
	WSDATA   cCODVA                    AS string
	WSDATA   cCODVR                    AS string
	WSDATA   cDESCVA                   AS string
	WSDATA   cDESCVR                   AS string
	WSDATA   cDIASVA                   AS string
	WSDATA   cDIASVR                   AS string
	WSDATA   cSTATUS                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRTRVRVA_ATABVAVR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRTRVRVA_ATABVAVR
Return

WSMETHOD CLONE WSCLIENT PRTRVRVA_ATABVAVR
	Local oClone := PRTRVRVA_ATABVAVR():NEW()
	oClone:cCODVA               := ::cCODVA
	oClone:cCODVR               := ::cCODVR
	oClone:cDESCVA              := ::cDESCVA
	oClone:cDESCVR              := ::cDESCVR
	oClone:cDIASVA              := ::cDIASVA
	oClone:cDIASVR              := ::cDIASVR
	oClone:cSTATUS              := ::cSTATUS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRTRVRVA_ATABVAVR
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODVA             :=  WSAdvValue( oResponse,"_CODVA","string",NIL,"Property cCODVA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCODVR             :=  WSAdvValue( oResponse,"_CODVR","string",NIL,"Property cCODVR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCVA            :=  WSAdvValue( oResponse,"_DESCVA","string",NIL,"Property cDESCVA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCVR            :=  WSAdvValue( oResponse,"_DESCVR","string",NIL,"Property cDESCVR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDIASVA            :=  WSAdvValue( oResponse,"_DIASVA","string",NIL,"Property cDIASVA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDIASVR            :=  WSAdvValue( oResponse,"_DIASVR","string",NIL,"Property cDIASVR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSTATUS            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,"Property cSTATUS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


