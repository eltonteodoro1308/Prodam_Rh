#Include 'Protheus.ch'
#INCLUDE "APWEBEX.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR05
Troca VA e VR
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR05()
Local cHtml   	:= ""

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              
	HttpSession->cTypeRequest 	:= ""		    
	HttpGet->titulo           	:= "Troca de Beneficios Vale alimentação e Vale refeição" 	    
	HttpSession->aStructure	   	:= {}
	
	fGetInfRotina("B_PRPOR05.APW")
	GetMat() //Pega a Matricula e a filial do participante logado

	oObj := WSPRTRVRVA():New()
	WsChgURL(@oObj,"PRTRVRVA.APW")

	If oObj:GETVAVR(HttpSession->aUser[02],HttpSession->aUser[03])
		HttpPost->DadosFunc := oObj:oWSGETVAVRRESULT
	Else
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR05.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf
	
	cHtml := ExecInPage("PRPOR05A")
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP05GRV
Realiza a gravação da troca do VR e VA
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP05GRV()
Local cHtml   	:= ""
Local cRecnoVR	:= Httpget->cRecnoVR
Local cCodVR		:= Httpget->cCodVR
Local cRecnoVA	:= Httpget->cRecnoVA
Local cCodVA		:= Httpget->cCodVA

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              

	oObj := WSPRTRVRVA():New()
	WsChgURL(@oObj,"PRTRVRVA.APW")

	If oObj:PUTVAVR(cRecnoVR,cCodVR,cRecnoVA,cCodVA)
		cHtml+= '<div style="text-align: left; vertical-align: middle; width: 400px;height:10px;">'
		cHtml+= '	<label class="Msgok">'
		cHtml+= oObj:CPUTVAVRRESULT
		cHtml+= '	</label>'
		cHtml+= '</div>'
	Else		
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR05.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf
	
WEB EXTENDED END

Return cHtml