#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH" 
#INCLUDE "PRD002.CH"

#DEFINE CODUSUARIO "MSALPHA"

/******************************************************************************
* Funcao: PRD002
* Autor: Marcelo Faria
* Data: 19/04/2016
* Workflow de Avaliação do Gestor
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista     ³ Data   ³FNC:            ³Motivo da Alteracao             ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³              ³        ³                ³                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

WebUser Function PRD002()
   Local   cHtml := ""
   Local   oParam

	HttpCTType("text/html; charset=ISO-8859-1")
      
	WEB EXTENDED INIT cHtml START "InSite"
		HttpGet->titulo          := STR0002 //"Controle de Avaliações do Gestor"
		HttpSession->PageLenght  := "20"

       // Carrega SM0
		OpenSm0()
		HttpSession->aSM0 := FWLoadSM0()

		fGetInfRotina("B_PRD002.APW")
		GetMat()								  //Pega a Matricula e a filial do participante logado

    	oParam	:= WSCFGDICTIONARY():NEW()
	   WsChgURL(@oParam,"CFGDICTIONARY.APW")
	   HttpSession->cCposCabec := ""
    	If oParam:GETPARAM( CODUSUARIO, "MV_CPOSCAB" )
	    	If !Empty(oParam:cGETPARAMRESULT)  .AND. oParam:cGETPARAMRESULT != ".F."
		    	HttpSession->cCposCabec := oParam:cGETPARAMRESULT
    		EndIf
	    EndIf                                      

    	//Se não existir o parâmetro ou não foi informado nenhum campo, 
    	// assumir todos os campos para apresentação
    	If Empty(HttpSession->cCposCabec)
	    	HttpSession->cCposCabec := "123456789A"
    	EndIf

    	HttpSession->RdAvaliador 	:= "N"
    	HttpSession->RdAvaliado  	:= "S"
    	HttpSession->FilterCodAva	:= ""
    	HttpSession->FilterCodDor	:= ""
    	HttpSession->Consulta		:= "N"
    	HttpSession->OpenWindow 	   := "N"

		cHtml := ExecInPage("PRD002A")
		
	WEB EXTENDED END
Return cHtml  


//* Lista as avaliações pendentes
WebUser Function PRD002B()
	Local cHtml   	  	:= ""
	Local oWF  

   Private oEval
   Private nPageTotal
   Private nCurrentPage                                                                 

	WEB EXTENDED INIT cHtml START "InSite"	              
	 	Default HttpGet->Page         		:= "1"
		Default HttpGet->FilterField     	:= ""
		Default HttpGet->FilterValue	    := ""
	 	nCurrentPage                       := Val(HttpGet->Page)

      	oWF := WSRHAPDManagerFlow():New()
		WsChgURL(@oWF,"RHAPDManagerFlow.APW")                             

		oWF:cParticipantID          := HttpSession->aUser[1] 		
		oWF:nPage                   := nCurrentPage
		oWF:cFilterValue            := HttpGet->FilterValue
		oWF:cFilterField            := HttpGet->FilterField

      	If oWF:GetManagerFlow()
			HttpSession->EvalManager := oWF:oWSGetManagerFlowResult
			nPageTotal               := oWF:oWSGetManagerFlowResult:nPagesTotal
		Else
			HttpSession->EvalManager := {}
			nPageTotal               := 0

			HttpSession->_HTMLERRO  := { STR0001, PWSGetWSError(), "W_PRD002B.APW","top" }	//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf 

		cHtml := ExecInPage( "PRD002B" )

	WEB EXTENDED END

Return cHtml


//* Consulta avaliação selecionada
WebUser Function PRD002C()
    Local oObj
	Local cHtml     := ""
	Local cAvaliacao:= ""
	Local cAvaliador:= ""
	Local cAvaliado := ""
	Local cTipoAv   := ""
	Local cProjeto  := ""

	WEB EXTENDED INIT cHtml START "InSite"	              

       cAvaliacao   := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CEVALUATIONID
       cAvaliador   := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CEVALUATORID
       cAvaliado    := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CEVALUATEDID
       cTipoAv      := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CSELFEVALUATE
       cProjeto     := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CPROJECTID
       cDataIni     := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->nInd)]:CSTARTDATEEVAL

		oObj := WSRHPERFORMANCEEVALUATE():New()
		WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
       	
		If oObj:GETPEVALUATE(CODUSUARIO, cAvaliado, cAvaliacao, cAvaliador, cTipoAv,,,,, sTod(cDataIni), cProjeto )
			HttpSession->GETPEVALUATE := oObj:oWSGETPEVALUATERESULT:oWSEVALUATELIST
			If len(HttpSession->GETPEVALUATE[1]:oWsListOfCompetence:oWsCompetences) == 0
				HttpSession->_HTMLERRO := { "Erro", "Não existem questões cadastradas para a avaliação atual.", "W_PROD003.APW" }
				Return ExecInPage("PWSAMSG" )
			EndIf
          //varinfo('HttpSession->GETPEVALUATE: ',HttpSession->GETPEVALUATE)

          cHtml := "W_PIMP012.APW?cEvaluatedID="+AllTrim(cAvaliado) + "&cPEvaluatedID=" + AllTrim(cAvaliacao) + "&cTipoAv="+ cTipoAv
		Else
			HttpSession->_HTMLERRO := { "Erro", PWSGetWSError(), "W_PRD002C.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf

	WEB EXTENDED END

Return cHtml


//* Aprovacao/Reprovação da avaliação pelo gestor
WebUser Function PRD002D()
Local oObj
Local cErro := ""
Local cHtml := ""

WEB EXTENDED INIT cHtml START "InSite"
   	oObj := WSRHAPDManagerFlow():New()
	WsChgURL(@oObj,"RHAPDManagerFlow.APW")                             
   
    //varinfo('HttpGet->Obs: ',HttpGet->Obs)
    //varinfo('HttpGet->Act: ',HttpGet->Act)
    //varinfo('HttpGet->Ind: ',HttpGet->Ind)
   
    oObj:cAction                 := HttpGet->Act //1-aprovação; 2-reprovação
    oObj:cParticipantID          := HttpSession->aUser[1]
    oObj:cEvaluation             := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->Ind)]:CEVALUATIONID
    oObj:cEvaluator              := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->Ind)]:CEVALUATORID
    oObj:cEvaluated              := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->Ind)]:CEVALUATEDID
    oObj:cEvalType               := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->Ind)]:CSELFEVALUATE
    oObj:cLevel                  := HttpSession->EvalManager:OWSITEMSOFMANAGERFLOW:OWSMANAGERFLOWDETAIL[val(HttpGet->Ind)]:CLEVEL
    oObj:cObservation            := HttpGet->Obs

   	If oObj:ActionsOnEvaluation()
		cHTML := oObj:cActionsOnEvaluationResult

       If cHTML == ''
          If HttpGet->Act == '1'
             cHTML := OemToAnsi(STR0003) //"Aprovacao Gravada com sucesso"  
          Else
             cHTML := OemToAnsi(STR0004) //"Reprovacao Gravada com sucesso"
          EndIf             
       EndIf
	Else
		HttpSession->_HTMLERRO := {STR0001, cErro, "W_PRD002D.APW"}	//"Erro" 
		Return ExecInPage("PWSAMSG" )
	EndIf	
WEB EXTENDED END

Return cHtml 

