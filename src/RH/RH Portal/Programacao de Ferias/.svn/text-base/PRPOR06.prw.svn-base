#Include 'Protheus.ch'
#INCLUDE "APWEBEX.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR06
Programação de ferias
@author  	Carlos Henrique 
@since     	04/07/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR06() //W_PWSA270.APW  
Local cHtml   	:= ""

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              
	HttpSession->cTypeRequest 	:= ""		    
	HttpGet->titulo           	:= "Programação de férias" 	    
	HttpGet->objetivo           := "Disponibiliza para consulta as informações da programação de férias."
	HttpSession->aStructure	   	:= {}
	
	fGetInfRotina("B_PRPOR06.APW")
	GetMat()								//Pega a Matricula e a filial do participante logado

	cHtml := ExecInPage("PRPOR06A")
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR02
@author  	Carlos Henrique 
@since     	04/07/2016
@version  	P.12.6     
@return   	Nenhum  
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP06PFE()
Local cHtml	:= ""
Local oParam	:= Nil                  
Local oOrg		:= Nil
Local oObj		:= Nil
Local nCnta	:= 1
Local nCntb	:= 1
Local aPeriodos  
Private lCorpManage
Private nPageTotal
Private nCurrentPage                                                                 

WEB EXTENDED INIT cHtml START "InSite"	              
 	Default HttpGet->Page         	:= "1"
	Default HttpGet->FilterField   	:= ""
	Default HttpGet->FilterValue	:= ""
	Default HttpGet->EmployeeFilial	:= ""  
	Default HttpGet->Registration  	:= ""
	nCurrentPage:= Val(HttpGet->Page)

	oOrg := WSORGSTRUCTURE():New()
	WsChgURL(@oOrg,"ORGSTRUCTURE.APW")  
	
	If Empty(HttpGet->EmployeeFilial) .And. Empty(HttpGet->Registration)
		oOrg:cParticipantID 	    := HttpSession->cParticipantID 		
		
		If HttpSession->lR7 .Or. ( ValType(HttpSession->RHMat) != "U" .And. !Empty(HttpSession->RHMat) )
			oOrg:cRegistration	 := HttpSession->RHMat
		EndIf	
	Else
		oOrg:cEmployeeFil  	    := HttpGet->EmployeeFilial
		oOrg:cRegistration 	    := HttpGet->Registration
	EndIf

	oOrg:cVision     		  		:= HttpSession->aInfRotina:cVisao
	oOrg:nPage         			:= nCurrentPage
	oOrg:cFilterValue 			:= HttpGet->FilterValue
	oOrg:cFilterField   			:= HttpGet->FilterField
	oOrg:cRequestType 			:= HttpSession->cTypeRequest
	HttpSession->aStrucFerias	:= {} //aSize(oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE,1)
   	
	IF oOrg:GetStructure()
		nPageTotal:= oOrg:oWSGetStructureResult:nPagesTotal
		oObj := WSRHVacation():New()
		WsChgURL(@oObj,"RHVACATION.APW") 	
	
		FOR nCnta:= 1 to LEN(oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE)
			oObj:cEmployeeFil  	:= oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:CEMPLOYEEFILIAL
			oObj:cRegistration	:= oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:cRegistration
			
			//Ajusta descrição do Departamento
			U_PRPORE01(@oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:cDescrDepartment)
			
			If oObj:GetVacProgEffect()
				AADD(HttpSession->aStrucFerias,{oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta],;
					oObj:oWSGETVACPROGEFFECTRESULT:oWSListOfVacProgEffect:oWSDataVacProgEffect})
			Else
				AADD(HttpSession->aStrucFerias,{oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta],;
					 {}})
			EndIf						
		NEXT nCnta			
	Else
		HttpSession->aStrucFerias 	:= {}
		nPageTotal 		      		:= 1		
		HttpSession->_HTMLERRO 		:= { "Erro", PWSGetWSError(), "B_PRPOR06.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf 
         
	cHtml := ExecInPage( "PRPOR06B" )

WEB EXTENDED END

Return cHtml