#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
//#INCLUDE "PWSA590.CH"

Web Function PWSA590()

Local cHtml   		:= ""

Private cDescCargo 	:= ""
Private cRespCargo	:= ""
Private cSkillCargo	:= ""
Private cRelacCargo	:= ""

HttpCTType("text/html; charset=ISO-8859-1")

WEB EXTENDED INIT cHtml START "InSite"

	HttpGet->titulo             := "Descritivo de Cargos"
	HttpSession->aStructure	   	:= {}
	HttpSession->cHierarquia	:= ""
	HttpSession->aCargos 		:= {}
	
	fGetInfRotina("W_PWSA590.APW")
	GetMat()	//Pega a Matricula e a filial do participante logado

	cHtml := ExecInPage("PWSA590")

WEB EXTENDED END

Return cHtml 

Web Function PWSA590A()

Local oWSCargos
Local cHtml	:= ""

cDescCargo 	:= ""
cRespCargo	:= ""
cSkillCargo	:= ""
cRelacCargo	:= ""

HttpCTType("text/html; charset=ISO-8859-1")

HttpGet->titulo        := "Descritivo de Cargos"
   	
WEB EXTENDED INIT cHtml START "InSite"

 	DEFAULT HttpGet->Page:= "1"
 	DEFAULT HttpGet->FilterField:= ""
	DEFAULT HttpGet->FilterValue:= ""
	DEFAULT HttpGet->Position:= "0"
	DEFAULT HttpGet->PageTotal:= "1"
	
	nPageTotal :=  Val(HttpGet->PageTotal)
	nCurrentPage:= Val(HttpGet->Page)
	nVar		:= Val(HttpGet->Position)
	
	HttpGet->FilterValue := DecodeUTF8(HttpGet->FilterValue)
		
	oWSCargos := WSRHPost():New()
	WsChgURL(@oWSCargos, "RHPost.APW")
	
	oWSCargos:cFilterField		:= HttpGet->FilterField
	oWSCargos:cFilterValue		:= HttpGet->FilterValue	
	oWSCargos:nCurrentPage		:= nCurrentPage	

	//Busca cargos			
	If nVar == 0 //.and. !Empty(oWSCargos:cFilterValue)
		If oWSCargos:BrowsePost()
			aCargos		:= oWSCargos:oWSBrowsePostResult:oWSItens:oWSTPostList
			nPageTotal	:= oWSCargos:oWSBrowsePostResult:nPagesTotal
			HttpSession->aCargos := aClone(aCargos)
		Else
			HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PWSA590A.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf
		nVar := 0
	Else
		aCargos := aClone(HttpSession->aCargos)
		If Len(aCargos) == 0
			nPageTotal := 1
		EndIf
		If !Empty(aCargos) .and. nVar > 0
			cDescCargo 	:= aCargos[nVar]:cDescDet
			cRespCargo	:= aCargos[nVar]:cResp
			cSkillCargo	:= aCargos[nVar]:cSkills
			cRelacCargo	:= aCargos[nVar]:cRelac
		EndIf
	EndIf
	
	cHtml := ExecInPage("PWSA590A")
WEB EXTENDED END	

Return cHtml