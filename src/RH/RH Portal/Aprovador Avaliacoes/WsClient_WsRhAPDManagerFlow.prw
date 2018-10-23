#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:83/ws/RHAPDMANAGERFLOW.apw?WSDL
Gerado em        04/28/16 20:30:40
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _KSZONMK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRHAPDMANAGERFLOW
------------------------------------------------------------------------------- */

WSCLIENT WSRHAPDMANAGERFLOW

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ACTIONSONEVALUATION
	WSMETHOD GETMANAGERFLOW

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cACTION                   AS string
	WSDATA   cPARTICIPANTID            AS string
	WSDATA   cEVALUATION               AS string
	WSDATA   cEVALUATOR                AS string
	WSDATA   cEVALUATED                AS string
	WSDATA   cEVALTYPE                 AS string
	WSDATA   cLEVEL                    AS string
	WSDATA   cOBSERVATION              AS string
	WSDATA   cACTIONSONEVALUATIONRESULT AS string
	WSDATA   nPAGE                     AS integer
	WSDATA   cFILTERVALUE              AS string
	WSDATA   cFILTERFIELD              AS string
	WSDATA   oWSGETMANAGERFLOWRESULT   AS RHAPDMANAGERFLOW_TMANAGERFLOWDATA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRHAPDMANAGERFLOW
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRHAPDMANAGERFLOW
	::oWSGETMANAGERFLOWRESULT := RHAPDMANAGERFLOW_TMANAGERFLOWDATA():New()
Return

WSMETHOD RESET WSCLIENT WSRHAPDMANAGERFLOW
	::cACTION            := NIL 
	::cPARTICIPANTID     := NIL 
	::cEVALUATION        := NIL 
	::cEVALUATOR         := NIL 
	::cEVALUATED         := NIL 
	::cEVALTYPE          := NIL 
	::cLEVEL             := NIL 
	::cOBSERVATION       := NIL 
	::cACTIONSONEVALUATIONRESULT := NIL 
	::nPAGE              := NIL 
	::cFILTERVALUE       := NIL 
	::cFILTERFIELD       := NIL 
	::oWSGETMANAGERFLOWRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRHAPDMANAGERFLOW
Local oClone := WSRHAPDMANAGERFLOW():New()
	oClone:_URL          := ::_URL 
	oClone:cACTION       := ::cACTION
	oClone:cPARTICIPANTID := ::cPARTICIPANTID
	oClone:cEVALUATION   := ::cEVALUATION
	oClone:cEVALUATOR    := ::cEVALUATOR
	oClone:cEVALUATED    := ::cEVALUATED
	oClone:cEVALTYPE     := ::cEVALTYPE
	oClone:cLEVEL        := ::cLEVEL
	oClone:cOBSERVATION  := ::cOBSERVATION
	oClone:cACTIONSONEVALUATIONRESULT := ::cACTIONSONEVALUATIONRESULT
	oClone:nPAGE         := ::nPAGE
	oClone:cFILTERVALUE  := ::cFILTERVALUE
	oClone:cFILTERFIELD  := ::cFILTERFIELD
	oClone:oWSGETMANAGERFLOWRESULT :=  IIF(::oWSGETMANAGERFLOWRESULT = NIL , NIL ,::oWSGETMANAGERFLOWRESULT:Clone() )
Return oClone

// WSDL Method ACTIONSONEVALUATION of Service WSRHAPDMANAGERFLOW

WSMETHOD ACTIONSONEVALUATION WSSEND cACTION,cPARTICIPANTID,cEVALUATION,cEVALUATOR,cEVALUATED,cEVALTYPE,cLEVEL,cOBSERVATION WSRECEIVE cACTIONSONEVALUATIONRESULT WSCLIENT WSRHAPDMANAGERFLOW
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ACTIONSONEVALUATION xmlns="http://localhost:83/">'
cSoap += WSSoapValue("ACTION", ::cACTION, cACTION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PARTICIPANTID", ::cPARTICIPANTID, cPARTICIPANTID , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("EVALUATION", ::cEVALUATION, cEVALUATION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("EVALUATOR", ::cEVALUATOR, cEVALUATOR , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("EVALUATED", ::cEVALUATED, cEVALUATED , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("EVALTYPE", ::cEVALTYPE, cEVALTYPE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("LEVEL", ::cLEVEL, cLEVEL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("OBSERVATION", ::cOBSERVATION, cOBSERVATION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ACTIONSONEVALUATION>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:83/ACTIONSONEVALUATION",; 
	"DOCUMENT","http://localhost:83/",,"1.031217",; 
	"http://localhost:83/ws/RHAPDMANAGERFLOW.apw")

::Init()
::cACTIONSONEVALUATIONRESULT :=  WSAdvValue( oXmlRet,"_ACTIONSONEVALUATIONRESPONSE:_ACTIONSONEVALUATIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETMANAGERFLOW of Service WSRHAPDMANAGERFLOW

WSMETHOD GETMANAGERFLOW WSSEND cPARTICIPANTID,nPAGE,cFILTERVALUE,cFILTERFIELD WSRECEIVE oWSGETMANAGERFLOWRESULT WSCLIENT WSRHAPDMANAGERFLOW
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETMANAGERFLOW xmlns="http://localhost:83/">'
cSoap += WSSoapValue("PARTICIPANTID", ::cPARTICIPANTID, cPARTICIPANTID , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PAGE", ::nPAGE, nPAGE , "integer", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERVALUE", ::cFILTERVALUE, cFILTERVALUE , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERFIELD", ::cFILTERFIELD, cFILTERFIELD , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETMANAGERFLOW>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:83/GETMANAGERFLOW",; 
	"DOCUMENT","http://localhost:83/",,"1.031217",; 
	"http://localhost:83/ws/RHAPDMANAGERFLOW.apw")

::Init()
::oWSGETMANAGERFLOWRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETMANAGERFLOWRESPONSE:_GETMANAGERFLOWRESULT","TMANAGERFLOWDATA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TMANAGERFLOWDATA

WSSTRUCT RHAPDMANAGERFLOW_TMANAGERFLOWDATA
	WSDATA   oWSITEMSOFMANAGERFLOW     AS RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL OPTIONAL
	WSDATA   nITEMSTOTAL               AS integer OPTIONAL
	WSDATA   cMANAGERID                AS string OPTIONAL
	WSDATA   cMANAGERNAME              AS string OPTIONAL
	WSDATA   nPAGESTOTAL               AS integer OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHAPDMANAGERFLOW_TMANAGERFLOWDATA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHAPDMANAGERFLOW_TMANAGERFLOWDATA
Return

WSMETHOD CLONE WSCLIENT RHAPDMANAGERFLOW_TMANAGERFLOWDATA
	Local oClone := RHAPDMANAGERFLOW_TMANAGERFLOWDATA():NEW()
	oClone:oWSITEMSOFMANAGERFLOW := IIF(::oWSITEMSOFMANAGERFLOW = NIL , NIL , ::oWSITEMSOFMANAGERFLOW:Clone() )
	oClone:nITEMSTOTAL          := ::nITEMSTOTAL
	oClone:cMANAGERID           := ::cMANAGERID
	oClone:cMANAGERNAME         := ::cMANAGERNAME
	oClone:nPAGESTOTAL          := ::nPAGESTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHAPDMANAGERFLOW_TMANAGERFLOWDATA
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ITEMSOFMANAGERFLOW","ARRAYOFMANAGERFLOWDETAIL",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSITEMSOFMANAGERFLOW := RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL():New()
		::oWSITEMSOFMANAGERFLOW:SoapRecv(oNode1)
	EndIf
	::nITEMSTOTAL        :=  WSAdvValue( oResponse,"_ITEMSTOTAL","integer",NIL,NIL,NIL,"N",NIL,NIL) 
	::cMANAGERID         :=  WSAdvValue( oResponse,"_MANAGERID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMANAGERNAME       :=  WSAdvValue( oResponse,"_MANAGERNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPAGESTOTAL        :=  WSAdvValue( oResponse,"_PAGESTOTAL","integer",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFMANAGERFLOWDETAIL

WSSTRUCT RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL
	WSDATA   oWSMANAGERFLOWDETAIL      AS RHAPDMANAGERFLOW_MANAGERFLOWDETAIL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL
	::oWSMANAGERFLOWDETAIL := {} // Array Of  RHAPDMANAGERFLOW_MANAGERFLOWDETAIL():New()
Return

WSMETHOD CLONE WSCLIENT RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL
	Local oClone := RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL():NEW()
	oClone:oWSMANAGERFLOWDETAIL := NIL
	If ::oWSMANAGERFLOWDETAIL <> NIL 
		oClone:oWSMANAGERFLOWDETAIL := {}
		aEval( ::oWSMANAGERFLOWDETAIL , { |x| aadd( oClone:oWSMANAGERFLOWDETAIL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHAPDMANAGERFLOW_ARRAYOFMANAGERFLOWDETAIL
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MANAGERFLOWDETAIL","MANAGERFLOWDETAIL",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMANAGERFLOWDETAIL , RHAPDMANAGERFLOW_MANAGERFLOWDETAIL():New() )
			::oWSMANAGERFLOWDETAIL[len(::oWSMANAGERFLOWDETAIL)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure MANAGERFLOWDETAIL

WSSTRUCT RHAPDMANAGERFLOW_MANAGERFLOWDETAIL
	WSDATA   cAPPROVALDATE             AS string OPTIONAL
	WSDATA   cAUTOEVALUATED            AS string OPTIONAL
	WSDATA   cEMAILDATE                AS string OPTIONAL
	WSDATA   cENDDATEEVAL              AS string OPTIONAL
	WSDATA   cEVALUATEDID              AS string OPTIONAL
	WSDATA   cEVALUATEDNAME            AS string OPTIONAL
	WSDATA   cEVALUATETYPE             AS string OPTIONAL
	WSDATA   cEVALUATIONDESC           AS string OPTIONAL
	WSDATA   cEVALUATIONID             AS string OPTIONAL
	WSDATA   cEVALUATORID              AS string OPTIONAL
	WSDATA   cEVALUATORNAME            AS string OPTIONAL
	WSDATA   cLEVEL                    AS string OPTIONAL
	WSDATA   cNET                      AS string OPTIONAL
	WSDATA   cOBSOFAPPROVAL            AS string OPTIONAL
	WSDATA   cPOSITIONID               AS string OPTIONAL
	WSDATA   cPROJECTDESC              AS string OPTIONAL
	WSDATA   cPROJECTID                AS string OPTIONAL
	WSDATA   cSELFEVALUATE             AS string OPTIONAL
	WSDATA   cSELFEVALUATEDESC         AS string OPTIONAL
	WSDATA   cSTARTDATEEVAL            AS string OPTIONAL
	WSDATA   cTYPEDESCRIPTION          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHAPDMANAGERFLOW_MANAGERFLOWDETAIL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHAPDMANAGERFLOW_MANAGERFLOWDETAIL
Return

WSMETHOD CLONE WSCLIENT RHAPDMANAGERFLOW_MANAGERFLOWDETAIL
	Local oClone := RHAPDMANAGERFLOW_MANAGERFLOWDETAIL():NEW()
	oClone:cAPPROVALDATE        := ::cAPPROVALDATE
	oClone:cAUTOEVALUATED       := ::cAUTOEVALUATED
	oClone:cEMAILDATE           := ::cEMAILDATE
	oClone:cENDDATEEVAL         := ::cENDDATEEVAL
	oClone:cEVALUATEDID         := ::cEVALUATEDID
	oClone:cEVALUATEDNAME       := ::cEVALUATEDNAME
	oClone:cEVALUATETYPE        := ::cEVALUATETYPE
	oClone:cEVALUATIONDESC      := ::cEVALUATIONDESC
	oClone:cEVALUATIONID        := ::cEVALUATIONID
	oClone:cEVALUATORID         := ::cEVALUATORID
	oClone:cEVALUATORNAME       := ::cEVALUATORNAME
	oClone:cLEVEL               := ::cLEVEL
	oClone:cNET                 := ::cNET
	oClone:cOBSOFAPPROVAL       := ::cOBSOFAPPROVAL
	oClone:cPOSITIONID          := ::cPOSITIONID
	oClone:cPROJECTDESC         := ::cPROJECTDESC
	oClone:cPROJECTID           := ::cPROJECTID
	oClone:cSELFEVALUATE        := ::cSELFEVALUATE
	oClone:cSELFEVALUATEDESC    := ::cSELFEVALUATEDESC
	oClone:cSTARTDATEEVAL       := ::cSTARTDATEEVAL
	oClone:cTYPEDESCRIPTION     := ::cTYPEDESCRIPTION
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHAPDMANAGERFLOW_MANAGERFLOWDETAIL
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAPPROVALDATE      :=  WSAdvValue( oResponse,"_APPROVALDATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAUTOEVALUATED     :=  WSAdvValue( oResponse,"_AUTOEVALUATED","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEMAILDATE         :=  WSAdvValue( oResponse,"_EMAILDATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cENDDATEEVAL       :=  WSAdvValue( oResponse,"_ENDDATEEVAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATEDID       :=  WSAdvValue( oResponse,"_EVALUATEDID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATEDNAME     :=  WSAdvValue( oResponse,"_EVALUATEDNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATETYPE      :=  WSAdvValue( oResponse,"_EVALUATETYPE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATIONDESC    :=  WSAdvValue( oResponse,"_EVALUATIONDESC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATIONID      :=  WSAdvValue( oResponse,"_EVALUATIONID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATORID       :=  WSAdvValue( oResponse,"_EVALUATORID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEVALUATORNAME     :=  WSAdvValue( oResponse,"_EVALUATORNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLEVEL             :=  WSAdvValue( oResponse,"_LEVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNET               :=  WSAdvValue( oResponse,"_NET","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOBSOFAPPROVAL     :=  WSAdvValue( oResponse,"_OBSOFAPPROVAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPOSITIONID        :=  WSAdvValue( oResponse,"_POSITIONID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPROJECTDESC       :=  WSAdvValue( oResponse,"_PROJECTDESC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPROJECTID         :=  WSAdvValue( oResponse,"_PROJECTID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSELFEVALUATE      :=  WSAdvValue( oResponse,"_SELFEVALUATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSELFEVALUATEDESC  :=  WSAdvValue( oResponse,"_SELFEVALUATEDESC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSTARTDATEEVAL     :=  WSAdvValue( oResponse,"_STARTDATEEVAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTYPEDESCRIPTION   :=  WSAdvValue( oResponse,"_TYPEDESCRIPTION","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


