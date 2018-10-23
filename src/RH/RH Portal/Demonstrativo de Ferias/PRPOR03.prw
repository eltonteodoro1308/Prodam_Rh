#Include 'Protheus.ch'
#INCLUDE "APWEBEX.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR03
Permite realizar a impressão do demonstrativo de férias - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR03()
	Local cHtml   := ""
	HttpCTType("text/html; charset=ISO-8859-1")
	WEB EXTENDED INIT cHtml START "InSite"
		HttpGet->titulo	:= "Recibos de Férias" 	    
		HttpGet->objetivo	:= "Disponibiliza as férias calculadas para o funcionário, possibilitando que seja impresso, ou somente visualizado, o recibo de pagamento do período selecionado."	
	
		fGetInfRotina("B_PRPOR03.APW")
		GetMat()
					
		cHtml := ExecInPage("PRPOR03A")
	WEB EXTENDED END
Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP03PER
Permite realizar a impressão do demonstrativo de férias - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP03PER()
	Local cHtml   	:= ""
	Local nCnt			:= 0
	Local dDatRef		:= CTOD("30/06/2016")
	Local oWSVacation
	Private nCurrentPage
	Private nPageTotal
	Private cLink:= "W_PWSA152.APW"	
	Private aPostos:= {}
	
	HttpCTType("text/html; charset=ISO-8859-1")
	
	WEB EXTENDED INIT cHtml START "InSite"
	 	Default HttpGet->Page:= "1"
	 	Default HttpGet->FilterField:= ""
		Default HttpGet->FilterValue:= ""	 	
	 	nCurrentPage:= Val(HttpGet->Page)
	 	
		oWSVacation := WSRHVacationReceipts():New()
		WsChgURL(@oWSVacation, "RHVACATIONRECEIPTS.APW")
		                     
		oWSVacation:cRegistration	:= HttpSession->aUser[3] //Filial
		oWSVacation:cBranch	 		:= HttpSession->aUser[2] //Matricula
		oWSVacation:cFilterField		:= HttpGet->FilterField
		oWSVacation:cFilterValue		:= HttpGet->FilterValue	
		oWSVacation:nCurrentPage	 	:= nCurrentPage
		oWSVacation:dEnjoymentStartDate

	
		If oWSVacation:BrowseVacationReceipts()
			//aVacationReceipts	:= oWSVacation:oWSBrowseVacationReceiptsResult:oWSItens:oWSTVacationReceiptsList
			aVacationReceipts	:= {}
			For nCnt:=1 TO LEN(oWSVacation:oWSBrowseVacationReceiptsResult:oWSItens:oWSTVacationReceiptsList)
				IF oWSVacation:oWSBrowseVacationReceiptsResult:oWSItens:oWSTVacationReceiptsList[nCnt]:DENJOYMENTSTARTDATE > dDatRef 
					AADD(aVacationReceipts,oWSVacation:oWSBrowseVacationReceiptsResult:oWSItens:oWSTVacationReceiptsList[nCnt]) 
				ENDIF	
			NEXT nCnt			
			nPageTotal	:= oWSVacation:oWSBrowseVacationReceiptsResult:nPagesTotal
		Else
			HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PWSA000.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf

		cHtml := ExecInPage( "PRPOR03B" )	
	WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP03REL
Permite realizar a impressão do demonstrativo de férias - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP03REL()
	Local cHtml   := ""
	Local oWSVacation
	Local oWSConfig
	Private oVacationReceipt	
	Private aLancamentos
	Private cPaisLoc:= ""
	Private cMessage	:= ""
	    
	HttpCTType("text/html; charset=ISO-8859-1")

	WEB EXTENDED INIT cHtml START "InSite"
		oWSConfig	:= WSCFGDICTIONARY():NEW()
		WsChgURL(@oWSConfig,"CFGDICTIONARY.APW")

		If oWSConfig:GetParam("MSALPHA", "MV_PAISLOC")
			cPaisLoc:= oWSConfig:cGetParamResult
		EndIf


		oWSVacation := WSRHVacationReceipts():New()
		WsChgURL(@oWSVacation, "RHVACATIONRECEIPTS.APW")
							
		oWSVacation:cRegistration	:= HttpSession->aUser[3] //Filial
		oWSVacation:cBranch	 		:= HttpSession->aUser[2] //Matricula
		oWSVacation:dAcquisitiveStartDate	:= CTOD(HttpGet->AcquisitiveStartDate)
		oWSVacation:dEnjoymentStartDate		:= CTOD(HttpGet->EnjoymentStartDate)
                          
		If oWSVacation:GetVacationReceipt()
			oVacationReceipt:= oWSVacation:oWSGetVacationReceiptResult
			aLancamentos	:= oWSVacation:oWSGetVacationReceiptResult:oWSItens:oWSTVacationReceiptsItem
			If oWSVacation:GetMessage() 
				cMessage		:= oWSVacation:CGETMESSAGERESULT
			Else
				HttpSession->_HTMLERRO := {"Erro", PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
				Return ExecInPage("PWSAMSG" )
			EndIf	
		Else
			HttpSession->_HTMLERRO := {"Erro", PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf
			
		cHtml := ExecInPage("PRPOR03C")
	WEB EXTENDED END
Return cHtml