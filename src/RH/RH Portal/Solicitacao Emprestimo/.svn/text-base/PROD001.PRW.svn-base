#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"

#DEFINE CODUSUARIO		"MSALPHA"

/*
{Protheus.doc} PROD001
Solicitação de empréstimo PRODAM.
@author	Leandro Drumond
@since 14/04/2016
*/

WebUser Function PROD001()

Local cHtml := ""
Local oObj
Local oParam

Default HttpSession->cMsgCalcMargem := ""
Default HttpSession->lEnvSolEmp		:= .T.

HttpCTType("text/html; charset=ISO-8859-1")

WEB EXTENDED INIT cHtml START "InSite"

oParam := WsCfgDictionary():new()
WsChgUrl(@oParam,"CFGDICTIONARY.APW")

If oParam:GetParam(CODUSUARIO,"MV_MSGMAR")		
	HttpSession->cMsgCalcMargem := RTrim(oParam:cGETPARAMRESULT)
EndIf

If oParam:GetParam(CODUSUARIO,"MV_SOLEMP")	
	HttpSession->lEnvSolEmp := oParam:cGETPARAMRESULT
EndIf

oObj := WSRHIDENTIFY():New()
WsChgURL(@oObj,"RHIDENTIFY.APW")

HttpSession->cRegistration 	:= HttpSession->AUSER[3]
HttpSession->cName			:= HttpSession->CPARTICIPANTNAME
HttpSession->cAdmissionDate	:= HttpSession->AMATS[1]:CADMISSIONDATE
HttpSession->cValMax		:= 0

	If oObj:BRWPERSONALDATA(CODUSUARIO, HttpSession->AUSER[1] )
		HttpSession->BRWPERSONALDATA := {oObj:oWSBRWPERSONALDATARESULT}
		
		oWSCredit := WSRHCredit():New()
		WsChgURL(@oWSCredit, "RHCredit.APW")
		oWSCredit:cBranch			:= HttpSession->AUSER[2] //Filial
		oWSCredit:cRegistration		:= HttpSession->AUSER[3] //Matricula	

		//Busca margem de crédito
		If oWSCredit:BrowseCredit()
			HttpSession->cValMax := TRANSFORM(oWSCredit:oWSBrowseCreditResult:nValMax,"@E 999,999.99")
		Else
			HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PROD001.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf			
	Else
		HttpSession->_HTMLERRO := { "Erro ", PWSGetWSError(), "W_PROD001.APW" }	//"Erro"
		Return ExecInPage("PWSAMSG" )
	EndIf

	cHtml := ExecInPage("PROD001")

WEB EXTENDED END

Return cHtml

WebUser Function PROD001A()

Local cHtml := "" 
Local oObj

HttpCTType("text/html; charset=ISO-8859-1")

WEB EXTENDED INIT cHtml START "InSite"

	oWSCredit := WSRHCredit():New()
	WsChgURL(@oWSCredit, "RHCredit.APW")
	oWSCredit:cBranch			:= HttpSession->AUSER[2] //Filial
	oWSCredit:cRegistration		:= HttpSession->AUSER[3] //Matricula
	
			
	oWSCredit:cValCredit		:= HttpPost->ValCredit
	oWSCredit:cDescCredit		:= HttpPost->DescCredit

	//Busca margem de crédito
	If !oWSCredit:SendCredit()
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PROD001.APW" }
		Return ExecInPage("PWSAMSG" )
	Else
		cHtml := "<script>alert('Solicitação efetuada.');</script>"
	EndIf

WEB EXTENDED END

Return cHtml