#Include 'Protheus.ch'
#INCLUDE "APWEBEX.CH"

#DEFINE CODUSUARIO "MSALPHA"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR04
Metas individuais
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR04()
Local cHtml   := ""
Local oParam 	:= NIL

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"
	Default HttpGet->Periodo			:= ""
	Default HttpGet->StatusPer		:= "3"
	oParam := wscfgdictionary():new()
	wschgurl(@oParam,"CFGDICTIONARY.APW")
	
	If oParam:GetParam(CODUSUARIO,"MV_APDLIMP")		//Busca limite de peso
		HttpSession->LimPeso := val(alltrim(oParam:cGETPARAMRESULT))
	EndIf
	
	If oParam:GetParam(CODUSUARIO,"MV_APDLIMM")		//Busca limite de metas
		HttpSession->LimMeta := val(alltrim(oParam:cGETPARAMRESULT))
	EndIf
	              
	HttpSession->cTypeRequest 	:= ""		    
	HttpGet->titulo           	:= "Metas individuais por Período" 	    
	HttpGet->objetivo           := "Permite informar e avaliar as metas individuais por Período"
	HttpSession->aStructure	   	:= {}
	HttpSession->Periodo			:= HttpGet->Periodo
	HttpSession->StatusPer		:= HttpGet->StatusPer
	
	fGetInfRotina("B_PRPOR04.APW")
	GetMat()								//Pega a Matricula e a filial do participante logado

	cHtml := ExecInPage("PRPOR04A")
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP04EST
Monta tela de estrutura
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP04EST() 
Local cHtml   	:= ""
Local oParam	  	:= Nil                  
Local oOrg  		:= Nil
Local oObj  		:= Nil
Local nCnta		:= 0
Private lCorpManage
Private nPageTotal
Private nCurrentPage                                                                

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              
 	Default HttpGet->Page         	:= "1"
	Default HttpGet->FilterField   	:= ""
	Default HttpGet->FilterValue	:= ""
	Default HttpGet->EmployeeFilial	:= ""  
	Default HttpGet->Registration  	:= ""
	Default HttpGet->Periodo			:= ""
	Default HttpGet->StatusPer		:= "3"
	Default HttpGet->titulo        	:= "Metas individuais por Período" 	    
	Default HttpGet->objetivo      	:= "Permite informar e avaliar as metas individuais por Período"	
	
 	nCurrentPage:= Val(HttpGet->Page)

	oOrg := WSPRMETAS():New()
	WsChgURL(@oOrg,"PRMETAS.apw")  
	
	If Empty(HttpGet->EmployeeFilial) .And. Empty(HttpGet->Registration)
		oOrg:cParticipantID 	    := HttpSession->cParticipantID 		
		
		If HttpSession->lR7 .Or. ( ValType(HttpSession->RHMat) != "U" .And. !Empty(HttpSession->RHMat) )
			oOrg:cRegistration	 := HttpSession->RHMat
		EndIf	
	Else
		oOrg:cEmployeeFil  	    := HttpGet->EmployeeFilial
		oOrg:cRegistration 	    := HttpGet->Registration
	EndIf

	oOrg:cPeriod     		  	:= HttpGet->Periodo
	oOrg:nPage         		:= nCurrentPage
	oOrg:cFilterValue 		:= HttpGet->FilterValue
	oOrg:cFilterField   		:= HttpGet->FilterField
	oOrg:cStatusMetas			:= HttpGet->StatusPer	
   	
	IF oOrg:GetPerStruct()
		nPageTotal 		  		:= oOrg:oWSGetPerStructResult:nPagesTotal
		HttpSession->aStrPer		:= oOrg:oWSGetPerStructResult:oWSPERIODO	
		HttpSession->aStructure	:= oOrg:oWSGetPerStructResult:oWSLISTOFEMPLOYEE:OWSSTRUTEMPLOYEE
		HttpSession->StatusPer	:= HttpGet->StatusPer
	Else
		HttpSession->aStructure := {}
		nPageTotal 		      := 1
		
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR04.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf 
         
	cHtml := ExecInPage( "PRPOR04B" )

WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP04PAR
Monta tela de parametros
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP04PAR()
Local cHtml := ""
Local oObj  := Nil

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"			              
	HttpGet->titulo:= "Metas individuais por Período"
	HttpSession->DadosFunc := ARRAY(2)
	
	IF !EMPTY(HttpSession->aStructure)
		
		If (HttpGet->nIndice != "0") 
		  	cIndice := HttpGet->nIndice
		   	HttpSession->DadosFunc[1] := HttpSession->aStructure[val(cIndice)]

			IF cIndice=="1"
				HttpSession->Permitido:= .F.
			ELSE
				HttpSession->Permitido:= .T.		   
		   	ENDIF
		EndIf
		
		oObj := WSPRMETAS():New()
		WsChgURL(@oObj,"PRMETAS.APW")
	
		//Carrega metas do periodo
		IF oObj:GETMETAS(HttpSession->aStrPer:CCDPERATU,;
							HttpSession->DadosFunc[1]:CEMPLOYEEFILIAL,;
							HttpSession->DadosFunc[1]:cRegistration)
			HttpSession->DadosFunc[2]:= oObj:OWSGETMETASRESULT
		ELSE
			HttpSession->DadosFunc[2]:= {}
		ENDIF		
	ELSE	
		HttpSession->DadosFunc[1] := {}
		HttpSession->DadosFunc[2]:= {}
	EndIf
	
	cHtml := ExecInPage("PRPOR04C") 	    
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP04GRV
Realiza a gravação das metas
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP04GRV()
Local cHtml 		:= ""
Local cMsg  		:= ""
Local nCnta 		:= 0
Local cXmlMetas 	:= ""
Local aMetas 		:= {}

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              

	oObj := WSPRMETAS():New()
	WsChgURL(@oObj,"PRMETAS.APW")

	If oObj:PUTMETAS(httpGet->XmlMetas)
		IF oObj:OWSPUTMETASRESULT:LOK
			cHtml+= '<div style="text-align: left; vertical-align: middle; width: 400px;height:10px;">'
			cHtml+= '	<label class="Msgok">'
			cHtml+= oObj:OWSPUTMETASRESULT:CMSG
			cHtml+= '	</label>'
			cHtml+= '</div>'
		ELSE
			cHtml+= '<div style="text-align: left; vertical-align: middle; width: 400px;height:10px;">'
			cHtml+= '	<label class="MsgErro">'
			cHtml+= oObj:OWSPUTMETASRESULT:CMSG
			cHtml+= '	</label>'
			cHtml+= '</div>'
		ENDIF	
	Else		
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR05.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf
	
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP04REL
Monta relatório de metas
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP04REL()
Local cHtml   := ""
Local nCnta	:= 0
Local nCntb	:= 0
Local oDdMetas:= {}
Local oEquipe	:= {}
Local oObj  	:= Nil

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	               
	HttpGet->titulo:= "Relatório de metas"
	
	IF LEN(HttpSession->aStructure) == 1
		oOrg := WSPRMETAS():New()
		WsChgURL(@oOrg,"PRMETAS.APW")	 
		
		oOrg:cParticipantID 	   := ""  
		oOrg:cEmployeeFil  	 	:= HttpSession->aStructure[1]:CSUPFILIAL
		oOrg:cRegistration 	   	:= HttpSession->aStructure[1]:CSUPREGISTRATION
		oOrg:cPeriod     		  	:= HttpGet->Periodo
	   	
		IF oOrg:GetPerStruct()	
			oEquipe	:= oOrg:oWSGetPerStructResult:oWSLISTOFEMPLOYEE:OWSSTRUTEMPLOYEE
		ENDIF
	ELSE
		oEquipe:= HttpSession->aStructure	
	ENDIF
	
	HttpSession->aDadosMetas:= {}	
	IF !EMPTY(oEquipe)
		
		oObj := WSPRMETAS():New()
		WsChgURL(@oObj,"PRMETAS.APW")
	
		FOR nCnta:= 1 TO LEN(oEquipe)		
			IF oEquipe[nCnta]:lParticipaMetas
				//Carrega METAS do periodo
				oDdMetas:= {}
				IF oObj:GETMETAS(HttpSession->aStrPer:CCDPERATU,;
									oEquipe[nCnta]:CEMPLOYEEFILIAL,;
									oEquipe[nCnta]:CREGISTRATION)
					oDdMetas:= oObj:OWSGETMETASRESULT
				ELSE
					oDdMetas:OWSITENS:= {}
				ENDIF			
				
				FOR nCntb:= 1 TO LEN(oDdMetas:OWSITENS)
					AADD(HttpSession->aDadosMetas,;
							{oEquipe[nCnta]:CDESCRDEPARTMENT,;
							 oEquipe[nCnta]:CREGISTRATION,;
							 oEquipe[nCnta]:CNAME,;
							 HttpSession->aStrPer:CCDPERATU,;
							 oDdMetas:OWSITENS[nCntb]:CSEQUENCIA,;
							 oDdMetas:OWSITENS[nCntb]:CMETA,;
							 oDdMetas:OWSITENS[nCntb]:NPERCREAL,;
							 oDdMetas:OWSITENS[nCntb]:CJUSTIFIC})
				NEXT nCntb	
			ENDIF	 
		NEXT nCnta	
	ENDIF		 	    
	cHtml := ExecInPage("PRPOR04D")
WEB EXTENDED END

Return cHtml
/********************************************************************/
/* Banco de Talentos - Monta loading para gerar EXCEL							 */
/********************************************************************/

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP04ADD
Adiciona linha na grid
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP04ADD()	
Local cHtml	:= ""
local nPesoAux:= 0
local cSeq		:= TRIM(HttpGet->cSeq)
local nCntPeso:= 0

cHtml+= '	<td>'+CRLF
cHtml+= '		<input name="txtSeq__'+cSeq+'" id="txtSeq__'+cSeq+'" disabled class="Campo"  type="text" value="'+ STRZERO(val(cSeq),2) +'" style="width:100%"/>'+CRLF
cHtml+= '	</td>'+CRLF
cHtml+= '	<td>'+CRLF

IF (HttpGet->IncMetas=='1' .OR. val(HttpGet->TotCancel) > 0)				
	cHtml+= '			<textarea name="txtMeta__'+cSeq+'" id="txtMeta__'+cSeq+'" class="CampoTxtarea" rows="1" cols="50" style="width:100%;height:100%;"></textarea>'+CRLF
ELSE
	cHtml+= '			<textarea name="txtMeta__'+cSeq+'" disabled id="txtMeta__'+cSeq+'" class="CampoTxtarea" rows="1" cols="50" style="width:100%;height:100%;"></textarea>'+CRLF					
ENDIF
		
cHtml+= '	</td>'+CRLF
cHtml+= '	<td>'+CRLF

cHtml+= '<select name="ddlPeso__'+cSeq+'" id="ddlPeso__'+cSeq+'" class="Campo" style="width:100%">'+CRLF

For nCntPeso:=1 to val(HttpGet->LimPeso) 
	cHtml+= '	<option value="'+ cvaltochar(nCntPeso) +'">'+ cvaltochar(nCntPeso) +'</option>'+CRLF
NEXT nY		

cHtml+= '</select>'+CRLF			
cHtml+= '	</td>
cHtml+= '	<td>

IF HttpGet->ResMetas == "1" 			
	cHtml+= '			<input name="txtRealizado__'+cSeq+'" id="txtRealizado__'+cSeq+'" class="Campo" type="text" value="0" style="width:100%" maxlength="3" onkeypress="return ValidaNumero(event)" onblur="ValidaMaximo(this)"/>'+CRLF
Else
	cHtml+= '			<input name="txtRealizado__'+cSeq+'" disabled id="txtRealizado__'+cSeq+'" class="Campo" type="text" value="0" style="width:100%" maxlength="3" onkeypress="return ValidaNumero(event)" onblur="ValidaMaximo(this)"/>'+CRLF					
ENDIF			

cHtml+= '	</td>
cHtml+= '	<td>

IF HttpGet->ResMetas == "1" 
	cHtml+= '	<select name="ddlStatus__'+cSeq+'" id="ddlStatus__'+cSeq+'" class="Campo" style="width:100%">'+CRLF
	cHtml+= '		<option value="1" selected>Ativo</option>'+CRLF
	cHtml+= '		<option value="2">Cancelado</option>'+CRLF									
	cHtml+= '	</select>'+CRLF
ELSE
	cHtml+= '	<select name="ddlStatus__'+cSeq+'" id="ddlStatus__'+cSeq+'" disabled class="Campo" style="width:100%">'+CRLF
	cHtml+= '		<option value="1" selected>Ativo</option>'+CRLF
	cHtml+= '		<option value="2">Cancelado</option>'+CRLF
	cHtml+= '		<option value="3">Calculado</option>'+CRLF										
	cHtml+= '	</select>'+CRLF						
ENDIF

cHtml+= '	</td>'+CRLF
cHtml+= '	<td>'+CRLF

IF HttpGet->ResMetas == "1"			
	cHtml+= '<textarea name="txtJustifiq__'+cSeq+'" id="txtJustifiq__'+cSeq+'" class="CampoTxtarea" rows="1" cols="50" style="width:100%;height:100%;"></textarea>'+CRLF
ELSE
	cHtml+= '<textarea name="txtJustifiq__'+cSeq+'" id="txtJustifiq__'+cSeq+'" disabled class="CampoTxtarea" rows="1" cols="50" style="width:100%;height:100%;"></textarea>'+CRLF					
ENDIF

cHtml+= '	</td>'+CRLF
cHtml+= '	<td>'+CRLF
cHtml+= '		<input name="txtDtCalculo__'+cSeq+'" id="txtDtCalculo__'+cSeq+'" disabled class="Campo" type="text" value="" style="width:100%"/>'+CRLF
cHtml+= '	</td>'+CRLF
cHtml+= '	<td>'+CRLF
cHtml+= '		<input name="txtResultado__'+cSeq+'" id="txtResultado__'+cSeq+'" disabled class="Campo" type="text" value="" style="width:100%"/>'+CRLF
cHtml+= '	</td>'+CRLF
cHtml+= '	<td id="ImgCancela__'+ cSeq +'">'+CRLF
cHtml+= '		<input type="hidden" id="txtFilial__'+cSeq+'" name="txtFilial__'+cSeq+'" value="'+ HttpSession->DadosFunc[1]:CEMPLOYEEFILIAL +'"  style="width:100%" />'+CRLF
cHtml+= '		<input type="hidden" name="txtMatric__'+cSeq+'" id="txtMatric__'+cSeq+'" value="'+ HttpSession->DadosFunc[1]:cRegistration +'"  style="width:100%" />'+CRLF
cHtml+= '		<input type="hidden" name="txtPerido__'+cSeq+'" id="txtPerido__'+cSeq+'" value="'+ HttpSession->aStrPer:CCDPERATU +'"  style="width:100%" />'+CRLF
cHtml+= '		<input type="hidden" name="txtRecno__'+cSeq+'" id="txtRecno__'+cSeq+'" value="0"  style="width:100%" />'+CRLF
cHtml+= '		<input type="hidden" name="txtExclui__'+cSeq+'" id="txtExclui__'+cSeq+'" value=".F."  style="width:100%" />'+CRLF
cHtml+= '		<a href="#" onclick="ExcluirMeta('+ cSeq +','+ IIF(HttpGet->ResMetas == "1",'1','2') +')">'+CRLF
cHtml+= '			<img id="img_equipe" name="img_equipe" src="imagens-rh/cancela.gif" width="20" height="20" border="0">'+CRLF
cHtml+= '		</a>'+CRLF						
cHtml+= '	</td>'+CRLF

Return cHtml
