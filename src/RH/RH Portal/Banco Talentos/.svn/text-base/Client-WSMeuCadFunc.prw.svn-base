#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8086/ws/WS_MEUCADFUNC.apw?WSDL
Gerado em        03/02/17 17:55:52
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IJQQSZX ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWS_MEUCADFUNC
------------------------------------------------------------------------------- */

WSCLIENT WSWS_MEUCADFUNC

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETCURSOS

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cMATRICULA                AS string
	WSDATA   oWSGETCURSOSRESULT        AS WS_MEUCADFUNC__RETCURSOS

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWS_MEUCADFUNC
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWS_MEUCADFUNC
	::oWSGETCURSOSRESULT := WS_MEUCADFUNC__RETCURSOS():New()
Return

WSMETHOD RESET WSCLIENT WSWS_MEUCADFUNC
	::cMATRICULA         := NIL 
	::oWSGETCURSOSRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWS_MEUCADFUNC
Local oClone := WSWS_MEUCADFUNC():New()
	oClone:_URL          := ::_URL 
	oClone:cMATRICULA    := ::cMATRICULA
	oClone:oWSGETCURSOSRESULT :=  IIF(::oWSGETCURSOSRESULT = NIL , NIL ,::oWSGETCURSOSRESULT:Clone() )
Return oClone

// WSDL Method GETCURSOS of Service WSWS_MEUCADFUNC

WSMETHOD GETCURSOS WSSEND cMATRICULA WSRECEIVE oWSGETCURSOSRESULT WSCLIENT WSWS_MEUCADFUNC
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETCURSOS xmlns="http://localhost:8086/">'
cSoap += WSSoapValue("MATRICULA", ::cMATRICULA, cMATRICULA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETCURSOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8086/GETCURSOS",; 
	"DOCUMENT","http://localhost:8086/",,"1.031217",; 
	"http://localhost:8086/ws/WS_MEUCADFUNC.apw")

::Init()
::oWSGETCURSOSRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETCURSOSRESPONSE:_GETCURSOSRESULT","_RETCURSOS",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure _RETCURSOS

WSSTRUCT WS_MEUCADFUNC__RETCURSOS
	WSDATA   oWSCADASTRAIS             AS WS_MEUCADFUNC_ARRAYOFCADASTRO OPTIONAL
	WSDATA   oWSCAPACITACOES           AS WS_MEUCADFUNC_ARRAYOFRA4STRU OPTIONAL
	WSDATA   oWSCERTIFICACOES          AS WS_MEUCADFUNC_ARRAYOFRA4STRU OPTIONAL
	WSDATA   cCODRET                   AS string
	WSDATA   oWSCONHECIMENTOS          AS WS_MEUCADFUNC_ARRAYOFCONHECIMENTO OPTIONAL
	WSDATA   oWSFORMACOES              AS WS_MEUCADFUNC_ARRAYOFRA4STRU OPTIONAL
	WSDATA   oWSFUNCIONAIS             AS WS_MEUCADFUNC_ARRAYOFFUNCIONAL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC__RETCURSOS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC__RETCURSOS
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC__RETCURSOS
	Local oClone := WS_MEUCADFUNC__RETCURSOS():NEW()
	oClone:oWSCADASTRAIS        := IIF(::oWSCADASTRAIS = NIL , NIL , ::oWSCADASTRAIS:Clone() )
	oClone:oWSCAPACITACOES      := IIF(::oWSCAPACITACOES = NIL , NIL , ::oWSCAPACITACOES:Clone() )
	oClone:oWSCERTIFICACOES     := IIF(::oWSCERTIFICACOES = NIL , NIL , ::oWSCERTIFICACOES:Clone() )
	oClone:cCODRET              := ::cCODRET
	oClone:oWSCONHECIMENTOS     := IIF(::oWSCONHECIMENTOS = NIL , NIL , ::oWSCONHECIMENTOS:Clone() )
	oClone:oWSFORMACOES         := IIF(::oWSFORMACOES = NIL , NIL , ::oWSFORMACOES:Clone() )
	oClone:oWSFUNCIONAIS        := IIF(::oWSFUNCIONAIS = NIL , NIL , ::oWSFUNCIONAIS:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC__RETCURSOS
	Local oNode1
	Local oNode2
	Local oNode3
	Local oNode5
	Local oNode6
	Local oNode7
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CADASTRAIS","ARRAYOFCADASTRO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSCADASTRAIS := WS_MEUCADFUNC_ARRAYOFCADASTRO():New()
		::oWSCADASTRAIS:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_CAPACITACOES","ARRAYOFRA4STRU",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSCAPACITACOES := WS_MEUCADFUNC_ARRAYOFRA4STRU():New()
		::oWSCAPACITACOES:SoapRecv(oNode2)
	EndIf
	oNode3 :=  WSAdvValue( oResponse,"_CERTIFICACOES","ARRAYOFRA4STRU",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSCERTIFICACOES := WS_MEUCADFUNC_ARRAYOFRA4STRU():New()
		::oWSCERTIFICACOES:SoapRecv(oNode3)
	EndIf
	::cCODRET            :=  WSAdvValue( oResponse,"_CODRET","string",NIL,"Property cCODRET as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_CONHECIMENTOS","ARRAYOFCONHECIMENTO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSCONHECIMENTOS := WS_MEUCADFUNC_ARRAYOFCONHECIMENTO():New()
		::oWSCONHECIMENTOS:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_FORMACOES","ARRAYOFRA4STRU",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSFORMACOES := WS_MEUCADFUNC_ARRAYOFRA4STRU():New()
		::oWSFORMACOES:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_FUNCIONAIS","ARRAYOFFUNCIONAL",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSFUNCIONAIS := WS_MEUCADFUNC_ARRAYOFFUNCIONAL():New()
		::oWSFUNCIONAIS:SoapRecv(oNode7)
	EndIf
Return

// WSDL Data Structure ARRAYOFCADASTRO

WSSTRUCT WS_MEUCADFUNC_ARRAYOFCADASTRO
	WSDATA   oWSCADASTRO               AS WS_MEUCADFUNC_CADASTRO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_ARRAYOFCADASTRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_ARRAYOFCADASTRO
	::oWSCADASTRO          := {} // Array Of  WS_MEUCADFUNC_CADASTRO():New()
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_ARRAYOFCADASTRO
	Local oClone := WS_MEUCADFUNC_ARRAYOFCADASTRO():NEW()
	oClone:oWSCADASTRO := NIL
	If ::oWSCADASTRO <> NIL 
		oClone:oWSCADASTRO := {}
		aEval( ::oWSCADASTRO , { |x| aadd( oClone:oWSCADASTRO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_ARRAYOFCADASTRO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CADASTRO","CADASTRO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCADASTRO , WS_MEUCADFUNC_CADASTRO():New() )
			::oWSCADASTRO[len(::oWSCADASTRO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFRA4STRU

WSSTRUCT WS_MEUCADFUNC_ARRAYOFRA4STRU
	WSDATA   oWSRA4STRU                AS WS_MEUCADFUNC_RA4STRU OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_ARRAYOFRA4STRU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_ARRAYOFRA4STRU
	::oWSRA4STRU           := {} // Array Of  WS_MEUCADFUNC_RA4STRU():New()
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_ARRAYOFRA4STRU
	Local oClone := WS_MEUCADFUNC_ARRAYOFRA4STRU():NEW()
	oClone:oWSRA4STRU := NIL
	If ::oWSRA4STRU <> NIL 
		oClone:oWSRA4STRU := {}
		aEval( ::oWSRA4STRU , { |x| aadd( oClone:oWSRA4STRU , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_ARRAYOFRA4STRU
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RA4STRU","RA4STRU",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRA4STRU , WS_MEUCADFUNC_RA4STRU():New() )
			::oWSRA4STRU[len(::oWSRA4STRU)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFCONHECIMENTO

WSSTRUCT WS_MEUCADFUNC_ARRAYOFCONHECIMENTO
	WSDATA   oWSCONHECIMENTO           AS WS_MEUCADFUNC_CONHECIMENTO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_ARRAYOFCONHECIMENTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_ARRAYOFCONHECIMENTO
	::oWSCONHECIMENTO      := {} // Array Of  WS_MEUCADFUNC_CONHECIMENTO():New()
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_ARRAYOFCONHECIMENTO
	Local oClone := WS_MEUCADFUNC_ARRAYOFCONHECIMENTO():NEW()
	oClone:oWSCONHECIMENTO := NIL
	If ::oWSCONHECIMENTO <> NIL 
		oClone:oWSCONHECIMENTO := {}
		aEval( ::oWSCONHECIMENTO , { |x| aadd( oClone:oWSCONHECIMENTO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_ARRAYOFCONHECIMENTO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONHECIMENTO","CONHECIMENTO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCONHECIMENTO , WS_MEUCADFUNC_CONHECIMENTO():New() )
			::oWSCONHECIMENTO[len(::oWSCONHECIMENTO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFFUNCIONAL

WSSTRUCT WS_MEUCADFUNC_ARRAYOFFUNCIONAL
	WSDATA   oWSFUNCIONAL              AS WS_MEUCADFUNC_FUNCIONAL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_ARRAYOFFUNCIONAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_ARRAYOFFUNCIONAL
	::oWSFUNCIONAL         := {} // Array Of  WS_MEUCADFUNC_FUNCIONAL():New()
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_ARRAYOFFUNCIONAL
	Local oClone := WS_MEUCADFUNC_ARRAYOFFUNCIONAL():NEW()
	oClone:oWSFUNCIONAL := NIL
	If ::oWSFUNCIONAL <> NIL 
		oClone:oWSFUNCIONAL := {}
		aEval( ::oWSFUNCIONAL , { |x| aadd( oClone:oWSFUNCIONAL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_ARRAYOFFUNCIONAL
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FUNCIONAL","FUNCIONAL",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFUNCIONAL , WS_MEUCADFUNC_FUNCIONAL():New() )
			::oWSFUNCIONAL[len(::oWSFUNCIONAL)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CADASTRO

WSSTRUCT WS_MEUCADFUNC_CADASTRO
	WSDATA   cADMISSAO                 AS string
	WSDATA   cCARGO                    AS string
	WSDATA   cDESCDEPTO                AS string
	WSDATA   cESPECIALIZ               AS string
	WSDATA   cMATRICULA                AS string
	WSDATA   cNOME                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_CADASTRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_CADASTRO
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_CADASTRO
	Local oClone := WS_MEUCADFUNC_CADASTRO():NEW()
	oClone:cADMISSAO            := ::cADMISSAO
	oClone:cCARGO               := ::cCARGO
	oClone:cDESCDEPTO           := ::cDESCDEPTO
	oClone:cESPECIALIZ          := ::cESPECIALIZ
	oClone:cMATRICULA           := ::cMATRICULA
	oClone:cNOME                := ::cNOME
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_CADASTRO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cADMISSAO          :=  WSAdvValue( oResponse,"_ADMISSAO","string",NIL,"Property cADMISSAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCARGO             :=  WSAdvValue( oResponse,"_CARGO","string",NIL,"Property cCARGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCDEPTO         :=  WSAdvValue( oResponse,"_DESCDEPTO","string",NIL,"Property cDESCDEPTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cESPECIALIZ        :=  WSAdvValue( oResponse,"_ESPECIALIZ","string",NIL,"Property cESPECIALIZ as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMATRICULA         :=  WSAdvValue( oResponse,"_MATRICULA","string",NIL,"Property cMATRICULA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RA4STRU

WSSTRUCT WS_MEUCADFUNC_RA4STRU
	WSDATA   cCATEGORIA                AS string
	WSDATA   cCODCURSO                 AS string
	WSDATA   cDATAFIM                  AS string
	WSDATA   cDESCCAT                  AS string
	WSDATA   cDESCCUR                  AS string
	WSDATA   cDESCENTIDA               AS string
	WSDATA   cDURACAO                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_RA4STRU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_RA4STRU
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_RA4STRU
	Local oClone := WS_MEUCADFUNC_RA4STRU():NEW()
	oClone:cCATEGORIA           := ::cCATEGORIA
	oClone:cCODCURSO            := ::cCODCURSO
	oClone:cDATAFIM             := ::cDATAFIM
	oClone:cDESCCAT             := ::cDESCCAT
	oClone:cDESCCUR             := ::cDESCCUR
	oClone:cDESCENTIDA          := ::cDESCENTIDA
	oClone:cDURACAO             := ::cDURACAO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_RA4STRU
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCATEGORIA         :=  WSAdvValue( oResponse,"_CATEGORIA","string",NIL,"Property cCATEGORIA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCODCURSO          :=  WSAdvValue( oResponse,"_CODCURSO","string",NIL,"Property cCODCURSO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDATAFIM           :=  WSAdvValue( oResponse,"_DATAFIM","string",NIL,"Property cDATAFIM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCCAT           :=  WSAdvValue( oResponse,"_DESCCAT","string",NIL,"Property cDESCCAT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCCUR           :=  WSAdvValue( oResponse,"_DESCCUR","string",NIL,"Property cDESCCUR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCENTIDA        :=  WSAdvValue( oResponse,"_DESCENTIDA","string",NIL,"Property cDESCENTIDA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDURACAO           :=  WSAdvValue( oResponse,"_DURACAO","string",NIL,"Property cDURACAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CONHECIMENTO

WSSTRUCT WS_MEUCADFUNC_CONHECIMENTO
	WSDATA   cAREA                     AS string
	WSDATA   cCATEGORIA                AS string
	WSDATA   cCODCONHEC                AS string
	WSDATA   cDESCAREA                 AS string
	WSDATA   cDESCCAT                  AS string
	WSDATA   cDESCCON                  AS string
	WSDATA   cNIVEL                    AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_CONHECIMENTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_CONHECIMENTO
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_CONHECIMENTO
	Local oClone := WS_MEUCADFUNC_CONHECIMENTO():NEW()
	oClone:cAREA                := ::cAREA
	oClone:cCATEGORIA           := ::cCATEGORIA
	oClone:cCODCONHEC           := ::cCODCONHEC
	oClone:cDESCAREA            := ::cDESCAREA
	oClone:cDESCCAT             := ::cDESCCAT
	oClone:cDESCCON             := ::cDESCCON
	oClone:cNIVEL               := ::cNIVEL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_CONHECIMENTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAREA              :=  WSAdvValue( oResponse,"_AREA","string",NIL,"Property cAREA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCATEGORIA         :=  WSAdvValue( oResponse,"_CATEGORIA","string",NIL,"Property cCATEGORIA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCODCONHEC         :=  WSAdvValue( oResponse,"_CODCONHEC","string",NIL,"Property cCODCONHEC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCAREA          :=  WSAdvValue( oResponse,"_DESCAREA","string",NIL,"Property cDESCAREA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCCAT           :=  WSAdvValue( oResponse,"_DESCCAT","string",NIL,"Property cDESCCAT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCCON           :=  WSAdvValue( oResponse,"_DESCCON","string",NIL,"Property cDESCCON as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNIVEL             :=  WSAdvValue( oResponse,"_NIVEL","string",NIL,"Property cNIVEL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure FUNCIONAL

WSSTRUCT WS_MEUCADFUNC_FUNCIONAL
	WSDATA   cAREADEPTO                AS string
	WSDATA   cATIVIDADES               AS string
	WSDATA   dDTALT                    AS date
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINICIO                 AS date
	WSDATA   cFUNCAO                   AS string
	WSDATA   cPROJETO                  AS string
	WSDATA   cSUBPROJETO               AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_MEUCADFUNC_FUNCIONAL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_MEUCADFUNC_FUNCIONAL
Return

WSMETHOD CLONE WSCLIENT WS_MEUCADFUNC_FUNCIONAL
	Local oClone := WS_MEUCADFUNC_FUNCIONAL():NEW()
	oClone:cAREADEPTO           := ::cAREADEPTO
	oClone:cATIVIDADES          := ::cATIVIDADES
	oClone:dDTALT               := ::dDTALT
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINICIO            := ::dDTINICIO
	oClone:cFUNCAO              := ::cFUNCAO
	oClone:cPROJETO             := ::cPROJETO
	oClone:cSUBPROJETO          := ::cSUBPROJETO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_MEUCADFUNC_FUNCIONAL
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAREADEPTO         :=  WSAdvValue( oResponse,"_AREADEPTO","string",NIL,"Property cAREADEPTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cATIVIDADES        :=  WSAdvValue( oResponse,"_ATIVIDADES","string",NIL,"Property cATIVIDADES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::dDTALT             :=  WSAdvValue( oResponse,"_DTALT","date",NIL,"Property dDTALT as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::dDTFIM             :=  WSAdvValue( oResponse,"_DTFIM","date",NIL,"Property dDTFIM as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::dDTINICIO          :=  WSAdvValue( oResponse,"_DTINICIO","date",NIL,"Property dDTINICIO as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
	::cFUNCAO            :=  WSAdvValue( oResponse,"_FUNCAO","string",NIL,"Property cFUNCAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cPROJETO           :=  WSAdvValue( oResponse,"_PROJETO","string",NIL,"Property cPROJETO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSUBPROJETO        :=  WSAdvValue( oResponse,"_SUBPROJETO","string",NIL,"Property cSUBPROJETO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


