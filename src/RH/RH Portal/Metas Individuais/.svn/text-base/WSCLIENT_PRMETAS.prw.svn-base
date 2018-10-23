#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8089/ws/PRMETAS.apw?WSDL
Gerado em        01/08/17 15:50:44
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WOPIYVE ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPRMETAS
------------------------------------------------------------------------------- */

WSCLIENT WSPRMETAS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETMETAS
	WSMETHOD GETPERSTRUCT
	WSMETHOD PUTMETAS

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cPERFILTRO                AS string
	WSDATA   cFILIALFUN                AS string
	WSDATA   cMATRICULA                AS string
	WSDATA   oWSGETMETASRESULT         AS PRMETAS_ARRAYOFITENS
	WSDATA   cPARTICIPANTID            AS string
	WSDATA   cPERIOD                   AS string
	WSDATA   cEMPLOYEEFIL              AS string
	WSDATA   cREGISTRATION             AS string
	WSDATA   nPAGE                     AS integer
	WSDATA   cFILTERVALUE              AS string
	WSDATA   cFILTERFIELD              AS string
	WSDATA   cSTATUSMETAS              AS string
	WSDATA   oWSGETPERSTRUCTRESULT     AS PRMETAS_TSTRUTDATA
	WSDATA   cXMLMETAS                 AS base64Binary
	WSDATA   oWSPUTMETASRESULT         AS PRMETAS_DADOSRET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPRMETAS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPRMETAS
	::oWSGETMETASRESULT  := PRMETAS_ARRAYOFITENS():New()
	::oWSGETPERSTRUCTRESULT := PRMETAS_TSTRUTDATA():New()
	::oWSPUTMETASRESULT  := PRMETAS_DADOSRET():New()
Return

WSMETHOD RESET WSCLIENT WSPRMETAS
	::cPERFILTRO         := NIL 
	::cFILIALFUN         := NIL 
	::cMATRICULA         := NIL 
	::oWSGETMETASRESULT  := NIL 
	::cPARTICIPANTID     := NIL 
	::cPERIOD            := NIL 
	::cEMPLOYEEFIL       := NIL 
	::cREGISTRATION      := NIL 
	::nPAGE              := NIL 
	::cFILTERVALUE       := NIL 
	::cFILTERFIELD       := NIL 
	::cSTATUSMETAS       := NIL 
	::oWSGETPERSTRUCTRESULT := NIL 
	::cXMLMETAS          := NIL 
	::oWSPUTMETASRESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPRMETAS
Local oClone := WSPRMETAS():New()
	oClone:_URL          := ::_URL 
	oClone:cPERFILTRO    := ::cPERFILTRO
	oClone:cFILIALFUN    := ::cFILIALFUN
	oClone:cMATRICULA    := ::cMATRICULA
	oClone:oWSGETMETASRESULT :=  IIF(::oWSGETMETASRESULT = NIL , NIL ,::oWSGETMETASRESULT:Clone() )
	oClone:cPARTICIPANTID := ::cPARTICIPANTID
	oClone:cPERIOD       := ::cPERIOD
	oClone:cEMPLOYEEFIL  := ::cEMPLOYEEFIL
	oClone:cREGISTRATION := ::cREGISTRATION
	oClone:nPAGE         := ::nPAGE
	oClone:cFILTERVALUE  := ::cFILTERVALUE
	oClone:cFILTERFIELD  := ::cFILTERFIELD
	oClone:cSTATUSMETAS  := ::cSTATUSMETAS
	oClone:oWSGETPERSTRUCTRESULT :=  IIF(::oWSGETPERSTRUCTRESULT = NIL , NIL ,::oWSGETPERSTRUCTRESULT:Clone() )
	oClone:cXMLMETAS     := ::cXMLMETAS
	oClone:oWSPUTMETASRESULT :=  IIF(::oWSPUTMETASRESULT = NIL , NIL ,::oWSPUTMETASRESULT:Clone() )
Return oClone

// WSDL Method GETMETAS of Service WSPRMETAS

WSMETHOD GETMETAS WSSEND cPERFILTRO,cFILIALFUN,cMATRICULA WSRECEIVE oWSGETMETASRESULT WSCLIENT WSPRMETAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETMETAS xmlns="http://localhost:8089/">'
cSoap += WSSoapValue("PERFILTRO", ::cPERFILTRO, cPERFILTRO , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILIALFUN", ::cFILIALFUN, cFILIALFUN , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MATRICULA", ::cMATRICULA, cMATRICULA , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETMETAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8089/GETMETAS",; 
	"DOCUMENT","http://localhost:8089/",,"1.031217",; 
	"http://localhost:8089/ws/PRMETAS.apw")

::Init()
::oWSGETMETASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETMETASRESPONSE:_GETMETASRESULT","ARRAYOFITENS",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETPERSTRUCT of Service WSPRMETAS

WSMETHOD GETPERSTRUCT WSSEND cPARTICIPANTID,cPERIOD,cEMPLOYEEFIL,cREGISTRATION,nPAGE,cFILTERVALUE,cFILTERFIELD,cSTATUSMETAS WSRECEIVE oWSGETPERSTRUCTRESULT WSCLIENT WSPRMETAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPERSTRUCT xmlns="http://localhost:8089/">'
cSoap += WSSoapValue("PARTICIPANTID", ::cPARTICIPANTID, cPARTICIPANTID , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PERIOD", ::cPERIOD, cPERIOD , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("EMPLOYEEFIL", ::cEMPLOYEEFIL, cEMPLOYEEFIL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("REGISTRATION", ::cREGISTRATION, cREGISTRATION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PAGE", ::nPAGE, nPAGE , "integer", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERVALUE", ::cFILTERVALUE, cFILTERVALUE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERFIELD", ::cFILTERFIELD, cFILTERFIELD , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("STATUSMETAS", ::cSTATUSMETAS, cSTATUSMETAS , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETPERSTRUCT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8089/GETPERSTRUCT",; 
	"DOCUMENT","http://localhost:8089/",,"1.031217",; 
	"http://localhost:8089/ws/PRMETAS.apw")

::Init()
::oWSGETPERSTRUCTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETPERSTRUCTRESPONSE:_GETPERSTRUCTRESULT","TSTRUTDATA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PUTMETAS of Service WSPRMETAS

WSMETHOD PUTMETAS WSSEND cXMLMETAS WSRECEIVE oWSPUTMETASRESULT WSCLIENT WSPRMETAS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PUTMETAS xmlns="http://localhost:8089/">'
cSoap += WSSoapValue("XMLMETAS", ::cXMLMETAS, cXMLMETAS , "base64Binary", .F. , .F., 0 , NIL, .F.) 
cSoap += "</PUTMETAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8089/PUTMETAS",; 
	"DOCUMENT","http://localhost:8089/",,"1.031217",; 
	"http://localhost:8089/ws/PRMETAS.apw")

::Init()
::oWSPUTMETASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PUTMETASRESPONSE:_PUTMETASRESULT","DADOSRET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFITENS

WSSTRUCT PRMETAS_ARRAYOFITENS
	WSDATA   oWSITENS                  AS PRMETAS_ITENS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_ARRAYOFITENS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_ARRAYOFITENS
	::oWSITENS             := {} // Array Of  PRMETAS_ITENS():New()
Return

WSMETHOD CLONE WSCLIENT PRMETAS_ARRAYOFITENS
	Local oClone := PRMETAS_ARRAYOFITENS():NEW()
	oClone:oWSITENS := NIL
	If ::oWSITENS <> NIL 
		oClone:oWSITENS := {}
		aEval( ::oWSITENS , { |x| aadd( oClone:oWSITENS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_ARRAYOFITENS
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITENS","ITENS",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSITENS , PRMETAS_ITENS():New() )
			::oWSITENS[len(::oWSITENS)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TSTRUTDATA

WSSTRUCT PRMETAS_TSTRUTDATA
	WSDATA   oWSLISTOFEMPLOYEE         AS PRMETAS_ARRAYOFSTRUTEMPLOYEE OPTIONAL
	WSDATA   nPAGESTOTAL               AS integer OPTIONAL
	WSDATA   oWSPERIODO                AS PRMETAS_ESTPER
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_TSTRUTDATA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_TSTRUTDATA
Return

WSMETHOD CLONE WSCLIENT PRMETAS_TSTRUTDATA
	Local oClone := PRMETAS_TSTRUTDATA():NEW()
	oClone:oWSLISTOFEMPLOYEE    := IIF(::oWSLISTOFEMPLOYEE = NIL , NIL , ::oWSLISTOFEMPLOYEE:Clone() )
	oClone:nPAGESTOTAL          := ::nPAGESTOTAL
	oClone:oWSPERIODO           := IIF(::oWSPERIODO = NIL , NIL , ::oWSPERIODO:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_TSTRUTDATA
	Local oNode1
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTOFEMPLOYEE","ARRAYOFSTRUTEMPLOYEE",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTOFEMPLOYEE := PRMETAS_ARRAYOFSTRUTEMPLOYEE():New()
		::oWSLISTOFEMPLOYEE:SoapRecv(oNode1)
	EndIf
	::nPAGESTOTAL        :=  WSAdvValue( oResponse,"_PAGESTOTAL","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_PERIODO","ESTPER",NIL,"Property oWSPERIODO as s0:ESTPER on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSPERIODO := PRMETAS_ESTPER():New()
		::oWSPERIODO:SoapRecv(oNode3)
	EndIf
Return

// WSDL Data Structure DADOSRET

WSSTRUCT PRMETAS_DADOSRET
	WSDATA   cMSG                      AS string OPTIONAL
	WSDATA   lOK                       AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_DADOSRET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_DADOSRET
Return

WSMETHOD CLONE WSCLIENT PRMETAS_DADOSRET
	Local oClone := PRMETAS_DADOSRET():NEW()
	oClone:cMSG                 := ::cMSG
	oClone:lOK                  := ::lOK
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_DADOSRET
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMSG               :=  WSAdvValue( oResponse,"_MSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ITENS

WSSTRUCT PRMETAS_ITENS
	WSDATA   cDTACALC                  AS string OPTIONAL
	WSDATA   lEXCLUI                   AS boolean OPTIONAL
	WSDATA   cFILIAL                   AS string OPTIONAL
	WSDATA   cJUSTIFIC                 AS string OPTIONAL
	WSDATA   cMATRIC                   AS string OPTIONAL
	WSDATA   cMETA                     AS string OPTIONAL
	WSDATA   nPERCREAL                 AS float OPTIONAL
	WSDATA   cPERIODO                  AS string OPTIONAL
	WSDATA   nPESO                     AS integer OPTIONAL
	WSDATA   nRECNO                    AS integer OPTIONAL
	WSDATA   nRESULT                   AS float OPTIONAL
	WSDATA   cSEQUENCIA                AS string OPTIONAL
	WSDATA   cSTATUS                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_ITENS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_ITENS
Return

WSMETHOD CLONE WSCLIENT PRMETAS_ITENS
	Local oClone := PRMETAS_ITENS():NEW()
	oClone:cDTACALC             := ::cDTACALC
	oClone:lEXCLUI              := ::lEXCLUI
	oClone:cFILIAL              := ::cFILIAL
	oClone:cJUSTIFIC            := ::cJUSTIFIC
	oClone:cMATRIC              := ::cMATRIC
	oClone:cMETA                := ::cMETA
	oClone:nPERCREAL            := ::nPERCREAL
	oClone:cPERIODO             := ::cPERIODO
	oClone:nPESO                := ::nPESO
	oClone:nRECNO               := ::nRECNO
	oClone:nRESULT              := ::nRESULT
	oClone:cSEQUENCIA           := ::cSEQUENCIA
	oClone:cSTATUS              := ::cSTATUS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_ITENS
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDTACALC           :=  WSAdvValue( oResponse,"_DTACALC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lEXCLUI            :=  WSAdvValue( oResponse,"_EXCLUI","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cFILIAL            :=  WSAdvValue( oResponse,"_FILIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cJUSTIFIC          :=  WSAdvValue( oResponse,"_JUSTIFIC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMATRIC            :=  WSAdvValue( oResponse,"_MATRIC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMETA              :=  WSAdvValue( oResponse,"_META","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPERCREAL          :=  WSAdvValue( oResponse,"_PERCREAL","float",NIL,NIL,NIL,"N",NIL,NIL) 
	::cPERIODO           :=  WSAdvValue( oResponse,"_PERIODO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPESO              :=  WSAdvValue( oResponse,"_PESO","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::nRECNO             :=  WSAdvValue( oResponse,"_RECNO","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::nRESULT            :=  WSAdvValue( oResponse,"_RESULT","float",NIL,NIL,NIL,"N",NIL,NIL) 
	::cSEQUENCIA         :=  WSAdvValue( oResponse,"_SEQUENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTATUS            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFSTRUTEMPLOYEE

WSSTRUCT PRMETAS_ARRAYOFSTRUTEMPLOYEE
	WSDATA   oWSSTRUTEMPLOYEE          AS PRMETAS_STRUTEMPLOYEE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_ARRAYOFSTRUTEMPLOYEE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_ARRAYOFSTRUTEMPLOYEE
	::oWSSTRUTEMPLOYEE     := {} // Array Of  PRMETAS_STRUTEMPLOYEE():New()
Return

WSMETHOD CLONE WSCLIENT PRMETAS_ARRAYOFSTRUTEMPLOYEE
	Local oClone := PRMETAS_ARRAYOFSTRUTEMPLOYEE():NEW()
	oClone:oWSSTRUTEMPLOYEE := NIL
	If ::oWSSTRUTEMPLOYEE <> NIL 
		oClone:oWSSTRUTEMPLOYEE := {}
		aEval( ::oWSSTRUTEMPLOYEE , { |x| aadd( oClone:oWSSTRUTEMPLOYEE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_ARRAYOFSTRUTEMPLOYEE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRUTEMPLOYEE","STRUTEMPLOYEE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRUTEMPLOYEE , PRMETAS_STRUTEMPLOYEE():New() )
			::oWSSTRUTEMPLOYEE[len(::oWSSTRUTEMPLOYEE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ESTPER

WSSTRUCT PRMETAS_ESTPER
	WSDATA   cCDPERATU                 AS string OPTIONAL
	WSDATA   cDSPERATU                 AS string OPTIONAL
	WSDATA   lINCMETAS                 AS boolean OPTIONAL
	WSDATA   cPERFILIAL                AS string OPTIONAL
	WSDATA   lRESMETAS                 AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_ESTPER
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_ESTPER
Return

WSMETHOD CLONE WSCLIENT PRMETAS_ESTPER
	Local oClone := PRMETAS_ESTPER():NEW()
	oClone:cCDPERATU            := ::cCDPERATU
	oClone:cDSPERATU            := ::cDSPERATU
	oClone:lINCMETAS            := ::lINCMETAS
	oClone:cPERFILIAL           := ::cPERFILIAL
	oClone:lRESMETAS            := ::lRESMETAS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_ESTPER
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCDPERATU          :=  WSAdvValue( oResponse,"_CDPERATU","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDSPERATU          :=  WSAdvValue( oResponse,"_DSPERATU","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lINCMETAS          :=  WSAdvValue( oResponse,"_INCMETAS","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cPERFILIAL         :=  WSAdvValue( oResponse,"_PERFILIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lRESMETAS          :=  WSAdvValue( oResponse,"_RESMETAS","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRUTEMPLOYEE

WSSTRUCT PRMETAS_STRUTEMPLOYEE
	WSDATA   cADMISSIONDATE            AS string
	WSDATA   cCATFUNC                  AS string OPTIONAL
	WSDATA   cCATFUNCDESC              AS string OPTIONAL
	WSDATA   cCATFUNCDESCSUP           AS string OPTIONAL
	WSDATA   cCATFUNCSUP               AS string OPTIONAL
	WSDATA   cCOST                     AS string OPTIONAL
	WSDATA   cCOSTID                   AS string OPTIONAL
	WSDATA   cDEPARTMENT               AS string
	WSDATA   cDESCRDEPARTMENT          AS string OPTIONAL
	WSDATA   cDESCSITUACAO             AS string OPTIONAL
	WSDATA   cEMAIL                    AS string OPTIONAL
	WSDATA   cEMPLOYEEEMP              AS string OPTIONAL
	WSDATA   cEMPLOYEEFILIAL           AS string
	WSDATA   cFILIALDESCR              AS string OPTIONAL
	WSDATA   cFUNCTIONDESC             AS string OPTIONAL
	WSDATA   cFUNCTIONID               AS string OPTIONAL
	WSDATA   lFUNCTIONSUBST            AS boolean OPTIONAL
	WSDATA   cHOURSMONTH               AS string OPTIONAL
	WSDATA   cITEM                     AS string OPTIONAL
	WSDATA   cKEYVISION                AS string OPTIONAL
	WSDATA   nLEVELHIERAR              AS integer OPTIONAL
	WSDATA   nLEVELSUP                 AS integer OPTIONAL
	WSDATA   cNAME                     AS string
	WSDATA   cNAMESUP                  AS string OPTIONAL
	WSDATA   lPARTICIPAMETAS           AS boolean OPTIONAL
	WSDATA   cPARTICIPANTID            AS string OPTIONAL
	WSDATA   cPOSITION                 AS string OPTIONAL
	WSDATA   cPOSITIONID               AS string OPTIONAL
	WSDATA   lPOSSUIEQUIPE             AS boolean OPTIONAL
	WSDATA   lPOSSUISOLIC              AS boolean OPTIONAL
	WSDATA   cREGISTRATION             AS string
	WSDATA   nSALARY                   AS float OPTIONAL
	WSDATA   cSITUACAO                 AS string OPTIONAL
	WSDATA   cSTATUSEMPLOYEE           AS string OPTIONAL
	WSDATA   cSUPEMPRESA               AS string OPTIONAL
	WSDATA   cSUPFILIAL                AS string OPTIONAL
	WSDATA   cSUPREGISTRATION          AS string OPTIONAL
	WSDATA   nTOTAL                    AS integer OPTIONAL
	WSDATA   cTYPEEMPLOYEE             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRMETAS_STRUTEMPLOYEE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRMETAS_STRUTEMPLOYEE
Return

WSMETHOD CLONE WSCLIENT PRMETAS_STRUTEMPLOYEE
	Local oClone := PRMETAS_STRUTEMPLOYEE():NEW()
	oClone:cADMISSIONDATE       := ::cADMISSIONDATE
	oClone:cCATFUNC             := ::cCATFUNC
	oClone:cCATFUNCDESC         := ::cCATFUNCDESC
	oClone:cCATFUNCDESCSUP      := ::cCATFUNCDESCSUP
	oClone:cCATFUNCSUP          := ::cCATFUNCSUP
	oClone:cCOST                := ::cCOST
	oClone:cCOSTID              := ::cCOSTID
	oClone:cDEPARTMENT          := ::cDEPARTMENT
	oClone:cDESCRDEPARTMENT     := ::cDESCRDEPARTMENT
	oClone:cDESCSITUACAO        := ::cDESCSITUACAO
	oClone:cEMAIL               := ::cEMAIL
	oClone:cEMPLOYEEEMP         := ::cEMPLOYEEEMP
	oClone:cEMPLOYEEFILIAL      := ::cEMPLOYEEFILIAL
	oClone:cFILIALDESCR         := ::cFILIALDESCR
	oClone:cFUNCTIONDESC        := ::cFUNCTIONDESC
	oClone:cFUNCTIONID          := ::cFUNCTIONID
	oClone:lFUNCTIONSUBST       := ::lFUNCTIONSUBST
	oClone:cHOURSMONTH          := ::cHOURSMONTH
	oClone:cITEM                := ::cITEM
	oClone:cKEYVISION           := ::cKEYVISION
	oClone:nLEVELHIERAR         := ::nLEVELHIERAR
	oClone:nLEVELSUP            := ::nLEVELSUP
	oClone:cNAME                := ::cNAME
	oClone:cNAMESUP             := ::cNAMESUP
	oClone:lPARTICIPAMETAS      := ::lPARTICIPAMETAS
	oClone:cPARTICIPANTID       := ::cPARTICIPANTID
	oClone:cPOSITION            := ::cPOSITION
	oClone:cPOSITIONID          := ::cPOSITIONID
	oClone:lPOSSUIEQUIPE        := ::lPOSSUIEQUIPE
	oClone:lPOSSUISOLIC         := ::lPOSSUISOLIC
	oClone:cREGISTRATION        := ::cREGISTRATION
	oClone:nSALARY              := ::nSALARY
	oClone:cSITUACAO            := ::cSITUACAO
	oClone:cSTATUSEMPLOYEE      := ::cSTATUSEMPLOYEE
	oClone:cSUPEMPRESA          := ::cSUPEMPRESA
	oClone:cSUPFILIAL           := ::cSUPFILIAL
	oClone:cSUPREGISTRATION     := ::cSUPREGISTRATION
	oClone:nTOTAL               := ::nTOTAL
	oClone:cTYPEEMPLOYEE        := ::cTYPEEMPLOYEE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRMETAS_STRUTEMPLOYEE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cADMISSIONDATE     :=  WSAdvValue( oResponse,"_ADMISSIONDATE","string",NIL,"Property cADMISSIONDATE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCATFUNC           :=  WSAdvValue( oResponse,"_CATFUNC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCATFUNCDESC       :=  WSAdvValue( oResponse,"_CATFUNCDESC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCATFUNCDESCSUP    :=  WSAdvValue( oResponse,"_CATFUNCDESCSUP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCATFUNCSUP        :=  WSAdvValue( oResponse,"_CATFUNCSUP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCOST              :=  WSAdvValue( oResponse,"_COST","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCOSTID            :=  WSAdvValue( oResponse,"_COSTID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDEPARTMENT        :=  WSAdvValue( oResponse,"_DEPARTMENT","string",NIL,"Property cDEPARTMENT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCRDEPARTMENT   :=  WSAdvValue( oResponse,"_DESCRDEPARTMENT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDESCSITUACAO      :=  WSAdvValue( oResponse,"_DESCSITUACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEMAIL             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEMPLOYEEEMP       :=  WSAdvValue( oResponse,"_EMPLOYEEEMP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEMPLOYEEFILIAL    :=  WSAdvValue( oResponse,"_EMPLOYEEFILIAL","string",NIL,"Property cEMPLOYEEFILIAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFILIALDESCR       :=  WSAdvValue( oResponse,"_FILIALDESCR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFUNCTIONDESC      :=  WSAdvValue( oResponse,"_FUNCTIONDESC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFUNCTIONID        :=  WSAdvValue( oResponse,"_FUNCTIONID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lFUNCTIONSUBST     :=  WSAdvValue( oResponse,"_FUNCTIONSUBST","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cHOURSMONTH        :=  WSAdvValue( oResponse,"_HOURSMONTH","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cITEM              :=  WSAdvValue( oResponse,"_ITEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cKEYVISION         :=  WSAdvValue( oResponse,"_KEYVISION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nLEVELHIERAR       :=  WSAdvValue( oResponse,"_LEVELHIERAR","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::nLEVELSUP          :=  WSAdvValue( oResponse,"_LEVELSUP","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNAME              :=  WSAdvValue( oResponse,"_NAME","string",NIL,"Property cNAME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNAMESUP           :=  WSAdvValue( oResponse,"_NAMESUP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lPARTICIPAMETAS    :=  WSAdvValue( oResponse,"_PARTICIPAMETAS","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cPARTICIPANTID     :=  WSAdvValue( oResponse,"_PARTICIPANTID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPOSITION          :=  WSAdvValue( oResponse,"_POSITION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPOSITIONID        :=  WSAdvValue( oResponse,"_POSITIONID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lPOSSUIEQUIPE      :=  WSAdvValue( oResponse,"_POSSUIEQUIPE","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lPOSSUISOLIC       :=  WSAdvValue( oResponse,"_POSSUISOLIC","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cREGISTRATION      :=  WSAdvValue( oResponse,"_REGISTRATION","string",NIL,"Property cREGISTRATION as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nSALARY            :=  WSAdvValue( oResponse,"_SALARY","float",NIL,NIL,NIL,"N",NIL,NIL) 
	::cSITUACAO          :=  WSAdvValue( oResponse,"_SITUACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTATUSEMPLOYEE    :=  WSAdvValue( oResponse,"_STATUSEMPLOYEE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSUPEMPRESA        :=  WSAdvValue( oResponse,"_SUPEMPRESA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSUPFILIAL         :=  WSAdvValue( oResponse,"_SUPFILIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSUPREGISTRATION   :=  WSAdvValue( oResponse,"_SUPREGISTRATION","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTOTAL             :=  WSAdvValue( oResponse,"_TOTAL","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cTYPEEMPLOYEE      :=  WSAdvValue( oResponse,"_TYPEEMPLOYEE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


