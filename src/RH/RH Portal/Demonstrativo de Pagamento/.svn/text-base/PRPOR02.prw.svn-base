#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
//#INCLUDE "PWSA180.CH"  
#DEFINE PAGE_LENGTH 10

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR02
Permite realizar a impressão do demonstrativo de pagamento - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR02()
	Local cHtml   := ""

	HttpCTType("text/html; charset=ISO-8859-1")	
	
	WEB EXTENDED INIT cHtml START "InSite"
		HttpGet->titulo           	:= "Demonstrativos de Pagamento" 	    
		HttpGet->objetivo           := "Apresenta os períodos disponíveis para consulta do demonstrativo de pagamento. De acordo com o período selecionado, é exibido o <br>"	
		HttpGet->objetivo           += "recibo de pagamento correspondente, que pode ser visualizado ou impresso. Os tipos de demonstrativo disponíveis são:<br>"
		HttpGet->objetivo           += "Adiantamento, Folha, 1ª Parcela 13º, 2ª Parcela 13º."	
		fGetInfRotina("B_PRPOR02.APW")
		GetMat()
					
		cHtml := ExecInPage("PRPOR02A")
	WEB EXTENDED END
Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP02PER
Permite realizar a impressão do demonstrativo de pagamento - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP02PER()
	Local cHtml   	:= ""
	Local oWSPayment
	Private nCurrentPage
	Private nPageTotal
	Private aPaymentReceipts

	HttpSession->nPageLength  := PAGE_LENGTH
	HttpSession->nPageTotal   := 0
	HttpSession->nCurrentPage := 0
	HttpSession->aReceipts    := {}

	HttpCTType("text/html; charset=ISO-8859-1")	 
	
	WEB EXTENDED INIT cHtml START "InSite"
	 	Default HttpGet->Page:= "1"
	 	Default HttpGet->FilterField:= ""
		Default HttpGet->FilterValue:= ""	 	
	 	nCurrentPage := Val(HttpGet->Page)
	 	
	 	If Type("cUsuario") != "U"
	 		PutGlbValue('CUSUARIO', httpSession->RHMAT) // Atribui valor na variavel pública
	 	EndIf
	 	
		oWSPayment := WSRHPaymentReceipts():New()
		WsChgURL(@oWSPayment, "RHPAYMENTRECEIPTS.APW")
		                     
		oWSPayment:cBranch	 		:= HttpSession->aUser[2] //Filial
		oWSPayment:cRegistration    := HttpSession->aUser[3] //Matricula
		oWSPayment:cFilterField		:= HttpGet->FilterField
		oWSPayment:cFilterValue		:= HttpGet->FilterValue	
		oWSPayment:nCurrentPage	 	:= nCurrentPage
		oWSPayment:cRHMat 			:= httpSession->RHMAT
	
	
		If oWSPayment:BrowsePaymentReceipts()
			aPaymentReceipts	:= oWSPayment:oWSBrowsePaymentReceiptsResult:oWSItens:oWSTPaymentReceiptsList
			nPageTotal			:= oWSPayment:oWSBrowsePaymentReceiptsResult:nPagesTotal			
			HttpSession->aReceipts := oWSPayment:oWSBrowsePaymentReceiptsResult:oWSItens:oWSTPaymentReceiptsList
		Else
			HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PWSA000.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf

		cHtml := ExecInPage( "PRPOR02B" )	
	WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP02PER
Permite realizar a impressão do demonstrativo de pagamento - Especifico Prodam
@author  	Carlos Henrique
@since     	07/017/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP02REL()
	Local cHtml   := ""
	Local oWSPayment
	Private oPaymentReceipt	
	Private aLancamentos
	
	HttpCTType("text/html; charset=ISO-8859-1")	
    
	WEB EXTENDED INIT cHtml START "InSite"
		oWSPayment := WSRHPaymentReceipts():New()
		WsChgURL(@oWSPayment, "RHPAYMENTRECEIPTS.APW")
		
		oWSPayment:cBranch	 	:= HttpGet->FilFunc
		oWSPayment:cRegistration	:= HttpGet->MatFunc		
		oWSPayment:nMonth			:= Val(HttpGet->Month)
		oWSPayment:nYear			:= Val(HttpGet->Year)
		oWSPayment:cWeek			:= HttpGet->Week
		oWSPayment:nType			:= Val(HttpGet->Type)
		oWSPayment:lArchived		:= IIF(HttpGet->Archived == "1", .T., .F.)				
		oWSPayment:cRHBranch 		:= HttpSession->aUser[2]
		oWSPayment:cRHReg			:= HttpSession->aUser[3]
		oWSPayment:cRHMat			:= HttpSession->RHMAT
		oWSPayment:cCompany			:= httpsession->aMats[1]:cEmployeeemp

		If oWSPayment:GetPaymentReceipt()
			oPaymentReceipt	:= oWSPayment:oWSGetPaymentReceiptResult
			aLancamentos	:= oWSPayment:oWSGetPaymentReceiptResult:oWSItens:oWSTPaymentReceiptsItem
		Else
			HttpSession->_HTMLERRO := {"Erro", PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf
		ASORT(aLancamentos,,,{|x,y| x:cCode < y:cCode } )	
		cHtml := ExecInPage("PRPOR02C")
	WEB EXTENDED END
Return cHtml


WebUser Function PRP02NR()

Local cHtml   := ""

HttpCTType("text/html; charset=ISO-8859-1")	
    
	WEB EXTENDED INIT cHtml START "InSite"

	cHtml := ExecInPage("PRPOR02D")
	WEB EXTENDED END

Return cHtml