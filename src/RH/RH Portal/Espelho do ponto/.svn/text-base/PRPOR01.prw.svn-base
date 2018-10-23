#Include 'Protheus.ch'
#INCLUDE "APWEBEX.CH"

#DEFINE CODUSUARIO "MSALPHA"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPOR01
Espelho do ponto
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRPOR01()
Local cHtml   := ""
local oParam	:= nil
local aRetPer	:= {}

HttpCTType("text/html; charset=ISO-8859-1")
WEB EXTENDED INIT cHtml START "InSite"	              
	HttpSession->cTypeRequest 	:= ""		    
	HttpGet->titulo           	:= "Espelho do ponto" 	    
	HttpGet->objetivo           := "Disponibiliza para consulta as informações do ponto."
	HttpSession->aStructure	   	:= {}
	
	fGetInfRotina("B_PRPOR01.APW")
	GetMat()								//Pega a Matricula e a filial do participante logado

	oParam := wscfgdictionary():new()
	WSCHGURL(@oParam,"CFGDICTIONARY.APW")
	
	If oParam:GetParam(CODUSUARIO,"MV_PAPONTA")		//Consulta inicio e fim do periodo de apontamento
		httpSession->cPAPONTA := alltrim(oParam:cGETPARAMRESULT)
	Else
		HttpSession->aQuadrimestre := {}		
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR01.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf 	
	
	HttpSession->aQuadrimestre	:= MontaQuad(httpSession->cPAPONTA,@aRetPer)
	//HttpSession->aPeriodos		:= aRetPer
	
	cHtml := ExecInPage("PRPOR01A")
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP01EST
Monta tela de estrutura
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP01EST() 
Local cHtml   	:= ""
Local oParam	  	:= Nil                  
Local oOrg  		:= Nil
Local oObj  		:= Nil
LOCAL nDia 		:= DAY(DATE())
Local dDatIniFim	:= IIF(nDia==16,DTOS(DATE()-1),DTOS(DATE()))
Local cPerAponta	:= dDatIniFim + dDatIniFim
Local cPerApAux	:= dDatIniFim + dDatIniFim  
Private lCorpManage
Private nPageTotal
Private nCurrentPage                                                                 

WEB EXTENDED INIT cHtml START "InSite"	              
 	Default HttpGet->Page         	:= "1"
	Default HttpGet->FilterField   	:= ""
	Default HttpGet->FilterValue	:= ""
	Default HttpGet->EmployeeFilial	:= ""  
	Default HttpGet->Registration  	:= ""
	Default HttpGet->dDataIni  		:= ""
	Default HttpGet->dDataFim  		:= ""
 	nCurrentPage:= Val(HttpGet->Page)

 	IF !EMPTY(HttpGet->dDataIni) .and. !EMPTY(HttpGet->dDataFim)
		cPerApAux		:= SUBSTR(Httpget->dDataIni,7,10)+;
								SUBSTR(Httpget->dDataIni,4,2)+;
								SUBSTR(Httpget->dDataIni,1,2)+;
								SUBSTR(Httpget->dDataFim,7,10)+;
								SUBSTR(Httpget->dDataFim,4,2)+;
								SUBSTR(Httpget->dDataFim,1,2)	
 	
		cPerAponta  	:= SUBSTR(Httpget->dDataFim,7,10)+;
								SUBSTR(Httpget->dDataFim,4,2)+;
								SUBSTR(Httpget->dDataFim,1,2)+;
								SUBSTR(Httpget->dDataFim,7,10)+;
								SUBSTR(Httpget->dDataFim,4,2)+;
								SUBSTR(Httpget->dDataFim,1,2)		
	ENDIF
	
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

	oOrg:cVision     		  	:= HttpSession->aInfRotina:cVisao
	oOrg:nPage         		:= nCurrentPage
	oOrg:cFilterValue 		:= HttpGet->FilterValue
	oOrg:cFilterField   		:= HttpGet->FilterField
	oOrg:cRequestType 		:= HttpSession->cTypeRequest
   	
	IF oOrg:GetStructure()
		nPageTotal 		   := oOrg:oWSGetStructureResult:nPagesTotal
		
		oObj := WSPRESPPON():New()
		WsChgURL(@oObj,"PRESPPON.APW")

		FOR nCnta:=1 TO LEN(oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE)
			//Ajusta descrição do Departamento
			U_PRPORE01(@oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:cDescrDepartment)
			
			IF oObj:GETESPBH( "3",;
								oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:CEMPLOYEEFILIAL,;
								oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:cRegistration,;
								cPerAponta,;
								"")
				oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:NTOTAL:= Decode64(oObj:CGETESPBHRESULT)
			ELSE
				oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[nCnta]:NTOTAL:= ""	
			ENDIF			 
		NEXT nCnta
					
		HttpSession->aStructure	:= oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE		
		HttpSession->cQuadSel	:= DTOC(Stod(Subst(cPerApAux,1,8)))+" -- "+ DTOC(Stod(Subst(cPerApAux,9,8)))
	Else
		HttpSession->aStructure := {}
		nPageTotal 		      := 1
		
		HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR01.APW" }	
		Return ExecInPage("PWSAMSG" )
	EndIf 
         
	cHtml := ExecInPage( "PRPOR01B" )

WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MontaQuad
Monta os quadrimestres
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION MontaQuad(cPAPONTA,aRetPer)
Local aRet		:= {}
local cDiaIni	:= LEFT(cPAPONTA,2)
local cDiaFim	:= RIGHT(cPAPONTA,2)
Local dDataAtu:= DATE()
LOCAL AnoAtu  := Year(dDataAtu)
LOCAL AnoAnt1 := AnoAtu-1
LOCAL AnoAnt2 := AnoAtu-2
LOCAL aAuxPer	:= {}
			
IF dDataAtu >= CTOD(cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1)) .AND. dDataAtu <= CTOD(cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))

	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))  
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt2) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAnt1))

ELSEIF dDataAtu >= CTOD(cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)) .AND. dDataAtu <= CTOD(cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu))

	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAnt1))	

ELSEIF dDataAtu >= CTOD(cDiaIni+'/08/'+ CVALTOCHAR(AnoAtu)) .AND. dDataAtu <= CTOD(cDiaFim+'/12/'+ CVALTOCHAR(AnoAtu))

	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))	

//Tratamento para o mes de dezembro	
ELSEIF dDataAtu >= CTOD(cDiaIni+'/12/'+ CVALTOCHAR(AnoAtu)) .AND. dDataAtu <= LASTDATE(CTOD(cDiaIni+'/12/'+ CVALTOCHAR(AnoAtu))) 

	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAtu) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu+1)) 
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))	

ENDIF
			
RETURN aRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP01PAR
Monta tela de parametros
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP01PAR()
Local cHtml   	:= ""

HttpGet->Horario := "08:00 as 17:00" // tratamento para buscar horario	
	
WEB EXTENDED INIT cHtml START "InSite"			              
	
	HttpGet->titulo           	:= "Espelho do ponto" 	    
	HttpGet->objetivo           := "Disponibiliza para consulta as informações do ponto."
	
	IF TYPE("HttpGet->nIndice")!="U" .and. (HttpGet->nIndice != "0")
		cIndice := HttpGet->nIndice
	  	HttpSession->DadosFunc := HttpSession->aStructure[val(cIndice)]
		cHtml := ExecInPage("PRPOR01C")
	ELSE
		HttpSession->_HTMLERRO := { "Menssagem", "Realize o login novamente.", "B_PRPOR01.APW" }	
		Return ExecInPage("PWSAMSG" )	   
	EndIf	
	
	 
WEB EXTENDED END

Return cHtml
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRP01REL
Monta relatório
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WebUser Function PRP01REL()
Local cHtml   		:= ""
Local lRet				:= .T.
Local lTerminal		:= .T.
Local lPortal			:= .T.	
Local lReturn			:= .F. // .T. Retorno Logico Quando Validacao e .F. retorna os periodos
Local cFilTerminal	:= ""
Local cMatTerminal	:= ""
Local cPerAponta  	:= SUBSTR(Httpget->dDataIni,7,10)+;
							SUBSTR(Httpget->dDataIni,4,2)+;
							SUBSTR(Httpget->dDataIni,1,2)+;
							SUBSTR(Httpget->dDataFim,7,10)+;
							SUBSTR(Httpget->dDataFim,4,2)+;
							SUBSTR(Httpget->dDataFim,1,2)
Local cPerFiltro  	:= SUBSTR(Httpget->dDtUserini,7,10)+;
							SUBSTR(Httpget->dDtUserini,4,2)+;
							SUBSTR(Httpget->dDtUserini,1,2)+;
							SUBSTR(Httpget->dDtUserfim,7,10)+;
							SUBSTR(Httpget->dDtUserfim,4,2)+;
							SUBSTR(Httpget->dDtUserfim,1,2)
Local cStatusAp		:= Httpget->StatusAp
Local cPageType		:= Httpget->PageType

WEB EXTENDED INIT cHtml START "InSite"	

	HttpCTType("text/html; charset=ISO-8859-1")

	IF TYPE("HttpGet->nIndice")!="U" .and. (HttpGet->nIndice != "0")
	   cIndice := HttpGet->nIndice
	   HttpSession->DadosFunc := HttpSession->aStructure[val(cIndice)]

		cFilTerminal	:= HttpSession->DadosFunc:cEmployeeFilial
		cMatTerminal	:= HttpSession->DadosFunc:cRegistration
	
		oObj := WSPRESPPON():New()
		WsChgURL(@oObj,"PRESPPON.APW")
		
		IF cPageType == "2"
			IF oObj:GETESPBH("2",cFilTerminal,cMatTerminal,cPerAponta,"")
				cHtml:= "<b>Banco de horas:</b> " + Decode64(oObj:CGETESPBHRESULT)
			ELSE
				cHtml:= "<b>Banco de horas:</b> 0:00"
			ENDIF
		ELSE
			IF oObj:GETESPBH(cPageType,cFilTerminal,cMatTerminal,cPerAponta,cStatusAp,cPerFiltro)
				cHtml:= Decode64(oObj:CGETESPBHRESULT)
			ELSE
				HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "B_PRPOR01.APW" }	
				Return ExecInPage("PWSAMSG" )
			ENDIF
		ENDIF	
	ELSE
		HttpSession->_HTMLERRO := { "Menssagem", "Realize o login novamente.", "B_PRPOR01.APW" }	
		Return ExecInPage("PWSAMSG" )	   
	EndIf	
 	
WEB EXTENDED END	
	
Return cHtml