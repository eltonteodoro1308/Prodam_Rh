#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH" 
#INCLUDE "PWSX700.CH"

#DEFINE CODUSUARIO		"MSALPHA"

/******************************************************************************
* Funcao: PWSX700
* Autor: Marcelo Faria
* Data: 05/04/2016
* Resultado da Avaliacao Consolidada
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

//* Seleciona Politica Consolidada
Web Function PWSX700()
   Local   cHtml := ""
   Local   oPolicy
   Private oPolicies
      
	WEB EXTENDED INIT cHtml START "InSite"
		HttpGet->titulo          := STR0002 //"Avaliação Consolidada"
		HttpSession->PageLenght  := "20"
		HttpSession->aStructure	 := {}
		HttpSession->cHierarquia	 := ""

       // Carrega SM0
		OpenSm0()
		HttpSession->aSM0 := FWLoadSM0()

		fGetInfRotina("W_PWSA160.APW")
		GetMat()								  //Pega a Matricula e a filial do participante logado

      	oPolicy := WSRHAPDConsolidated():New()
		WsChgURL(@oPolicy,"RHAPDConsolidated.APW")                             

      	If oPolicy:GetPolicies()
			oPolicies := oPolicy:oWSGetPoliciesResult
		Endif

		cHtml := ExecInPage("PWSX700A")
	WEB EXTENDED END
Return cHtml  


//* Informações da Equipe
Web Function PWSX701()
	Local cHtml   	:= ""
   Local aPostPolicy := {}

	WEB EXTENDED INIT cHtml START "InSite"
		HttpGet->titulo          := STR0002 	//"Avaliação Consolidada"
		HttpSession->aStructure	 := {}
		HttpSession->cHierarquia	 := ""

		If(valtype(HttpPost->optPolicy) != "U")
			aPostPolicy := StrTokArr2(HttpPost->optPolicy,"##",.T.)
	       HttpSession->cPolicy     := alltrim(aPostPolicy[1])
	       HttpSession->cPolicyDesc := alltrim(aPostPolicy[2])
		Else
			If(valtype(HttpSession->cPolicy) == "U")
		       HttpSession->cPolicy     := "00000"
		       HttpSession->cPolicyDesc := ""
		    EndIf
		EndIf

		GetMat()								   //Pega a Matricula e a filial do participante logado

		cHtml := ExecInPage("PWSX700B")
	WEB EXTENDED END
Return cHtml  


//* Resultado Consolidado do Funcionário
Web Function PWSX702()
Local oObj
Local cHtml   := ""
Local nIndice := 0

If(valtype(HttpGet->nIndice) != "U")
   nIndice := val(HttpGet->nIndice) 
EndIf

WEB EXTENDED INIT cHtml START "InSite"   	
    //GetMat()//Pega filial e matricula do participante 

    nIndice :=  val(HttpGet->nIndice)
   	If (HttpGet->nOperacao == "1")  
   		HttpSession->DadosFunc := HttpSession->aStructure[nIndice]
	EndIf

   	oObj := WSRHAPDConsolidated():New()
	WsChgURL(@oObj,"RHAPDConsolidated.APW")

	oObj:cPolicy       := HttpSession->cPolicy
	oObj:cEmployeeFil  := HttpSession->aStructure[nIndice]:cEmployeeFilial
	oObj:cRegistration := HttpSession->aStructure[nIndice]:cRegistration

	oObj:cSupEmployeeFil  := HttpSession->aUser[2]
	oObj:cSupRegistration := HttpSession->aUser[3]

	If oObj:GetConsolidated()     
		oConsolidado := oObj:oWSGetConsolidatedResult
	Else
		HttpSession->_HTMLERRO  := { STR0001, PWSGetWSError(), "W_PWSA000.APW","top" }	//"Erro"
		Return ExecInPage("PWSAMSG" )
		//oConsolidado := {}
	EndIf

    cHtml := ExecInPage( "PWSX702" )  
	
WEB EXTENDED END
Return cHtml


//* Lista dos funcionários da equipe
Web Function PWSX703()
	Local cHtml   	  	:= ""
	Local oParam	  	    := Nil
	Local cHierarquia 	:= ""    
	Local nPos        	:= 0                
	Local aAux        	:= {}  
	Local nAux        	:= 0
	Local nNivel      	:= 0
	Local oOrg  

	Private lCorpManage
	Private nPageTotal
	Private nCurrentPage                                                                 

	HttpCTType("text/html; charset=ISO-8859-1")

	WEB EXTENDED INIT cHtml START "InSite"	              
	 	Default HttpGet->Page         		:= "1"
		Default HttpGet->PageLength       	:= HttpSession->PageLenght
		Default HttpGet->Order           	:= "desc"
		Default HttpGet->FilterField     	:= ""
		Default HttpGet->FilterValue	    := ""
		Default HttpGet->EmployeeFilial   	:= ""  
		Default HttpGet->Registration     	:= ""
	 	nCurrentPage                       := Val(HttpGet->Page)

      	oOrg := WSRHAPDConsolidated():New()
		WsChgURL(@oOrg,"RHAPDConsolidated.APW")                             

		//oOrg := WSORGSTRUCTURE():New()
		//WsChgURL(@oOrg,"ORGSTRUCTURE.APW")  
		
		If Empty(HttpGet->EmployeeFilial) .And. Empty(HttpGet->Registration)
			oOrg:cParticipantID 	    := HttpSession->cParticipantID 		
			
			If ValType(HttpSession->RHMat) != "U" .And. !Empty(HttpSession->RHMat)
				oOrg:cRegistration	 := HttpSession->RHMat
			EndIf	
		Else
			oOrg:cEmployeeFil  	    := HttpGet->EmployeeFilial
			oOrg:cRegistration 	    := HttpGet->Registration
		EndIf

		oOrg:cPolicy       		    := HttpSession->cPolicy
		oOrg:cVision       		    := HttpSession->aInfRotina:cVisao
		oOrg:nPage         		    := nCurrentPage
		oOrg:cFilterValue 		    := HttpGet->FilterValue
		oOrg:cFilterField   		    := HttpGet->FilterField
		oOrg:cRankingOrder 		    := HttpGet->Order
       oOrg:nPageLength             := val(HttpGet->PageLength)
		HttpSession->PageLenght      := HttpGet->PageLength

       IF oOrg:GetStructRanking()
			HttpSession->aStructure  := aClone(oOrg:oWSGetStructRankingResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE)
			nPageTotal 		       := oOrg:oWSGetStructRankingResult:nPagesTotal
         
         // *****************************************************************
         // Inicio - Monta Hierarquia                                                 
         // *****************************************************************
			cHierarquia := '<ul style="list-style-type: none;"><li><a href="#" class="links" onclick="javascript:GoToPage(null,1,null,null,null,null,' +;
					       "'" + HttpSession->aStructure[1]:cEmployeeFilial + "'," +;
					       "'" + HttpSession->aStructure[1]:cRegistration + "'" + ')">'

			If Empty(HttpSession->cHierarquia) .or. (HttpSession->cParticipantID == HttpSession->aStructure[1]:cParticipantID)
				nNivel                 := 1    
				HttpSession->cHierarquia := ""
			Else
				aAux := Str2Arr(HttpSession->cHierarquia, "</ul>")
				If (nPos := aScan(aAux, {|x| cHierarquia $ x })) > 0
					For nAux := len(aAux) to nPos step -1
						aDel(aAux,nAux)
						aSize(aAux,Len(aAux)-1)
					Next nAux
				EndIf
				HttpSession->cHierarquia := ""
				For nPos := 1 to Len(aAux)
					HttpSession->cHierarquia += aAux[nPos] + "</ul>"
				Next nPos

				nNivel := Iif(Len(aAux) > 0,Len(aAux)+1,1)
			EndIf
			
			For nPos := 1 to nNivel
				cHierarquia += '&nbsp;&nbsp;&nbsp;'
			Next nPos
			cHierarquia += Alltrim(str(nNivel)) + " . " + HttpSession->aStructure[1]:cName + '</a></li></ul>'
	            
			HttpSession->cHierarquia += cHierarquia
         	// Fim - Monta Hierarquia
		Else
			HttpSession->aStructure := {}
			nPageTotal 		      := 1

			HttpSession->_HTMLERRO  := { STR0001, PWSGetWSError(), "W_PWSA000.APW","top" }	//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf 
		            
		cHtml := ExecInPage( "PWSX700C" )

	WEB EXTENDED END
Return cHtml


//Busca as metas (analitico)
Web Function PWSX704()
Local oObj
Local cHtml   := ""
Local nIndice := 0
Local nX, nY
Local aMetas := {}
Local aEvaluations := {}
Local nPerGoals  := 0 
Local nPerAssess := 0

Private oPolicy

If(valtype(HttpGet->nIndice) != "U")
   nIndice := val(HttpGet->nIndice) 
EndIf

WEB EXTENDED INIT cHtml START "InSite"   	
    //GetMat()//Pega filial e matricula do participante 

    nIndice :=  val(HttpGet->nIndice)
   	If (HttpGet->nOperacao == "1")  
   		HttpSession->DadosFunc := HttpSession->aStructure[nIndice]
	EndIf

	If(valtype(HttpPost->optPolicy) != "U")
		aPostPolicy := StrTokArr2(HttpPost->optPolicy,"##",.T.)
       HttpSession->cPolicy     := alltrim(aPostPolicy[1])
       HttpSession->cPolicyDesc := alltrim(aPostPolicy[2])
	Else
		If(valtype(HttpSession->cPolicy) == "U")
	       HttpSession->cPolicy     := "00000"
	       HttpSession->cPolicyDesc := ""
	    EndIf
	EndIf

  	oPolicy := WSRHAPDConsolidated():New()
	WsChgURL(@oPolicy,"RHAPDConsolidated.APW")                             

  	If oPolicy:GetPolicies(HttpSession->cPolicy)
		oPolicies := oPolicy:oWSGetPoliciesResult
	Endif

	oPolicyAct := OPOLICIES:OWSITEMSOFPOLICY:OWSPOLICYCABEC[1]:OWSITEMSOFPOLICYDETAIL

	oObj := WSPRMETAS():New()
	WsChgURL(@oObj,"PRMETAS.APW")

	For nX := 1 to len(oPolicyAct:OWSPOLICYDETAIL)

		If oPolicyAct:OWSPOLICYDETAIL[nX]:CPERIODTYPE == '3'

			//Carrega metas do periodo
			IF oObj:GETMETAS(oPolicyAct:OWSPOLICYDETAIL[nX]:CPERIODID,;
								HttpSession->DadosFunc:CEMPLOYEEFILIAL,;
								HttpSession->DadosFunc:cRegistration)
				For nY := 1 to len(oObj:OWSGETMETASRESULT:OWSITENS)
					aadd(aMetas,oObj:OWSGETMETASRESULT:OWSITENS[nY])
				Next nY

			ENDIF		

		EndIf

	Next  nX

	HttpSession->Metas := aMetas

	oObj := WSRHPERFORMANCEEVALUATE():New()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
       	
	For nX := 1 to len(oPolicyAct:OWSPOLICYDETAIL)

		If oPolicyAct:OWSPOLICYDETAIL[nX]:CPERIODTYPE == '4'

			For nY := 1 to len(oPolicyAct:OWSPOLICYDETAIL[nX]:CEvaluations) step 7

				//Carrega as avaliacoes por competencias
				cAvaliado 	:= HttpSession->DadosFunc:CPARTICIPANTID
				cAvaliacao 	:= substr(oPolicyAct:OWSPOLICYDETAIL[nX]:CEvaluations,nY,6)
				cAvaliador 	:= '@@@@@@'
				cTipoAv 	:= '3'
				dDateFrom	:= stod(oPolicyAct:OWSPOLICYDETAIL[nX]:CPeriodInitialDate)
				
				If oObj:GETPEVALUATE(CODUSUARIO, cAvaliado, cAvaliacao, cAvaliador, cTipoAv,,,,,dDateFrom) //, cProjeto )
					HttpSession->GETPEVALUATE := oObj:oWSGETPEVALUATERESULT:oWSEVALUATELIST
					If !empty(HttpSession->GETPEVALUATE[1]:CEvaluatorID)
						aadd(aEvaluations,HttpSession->GETPEVALUATE[1])
					EndIf
				EndIf

			Next nY
			
		Endif

	Next nX

	HttpSession->GETPEVALUATE := aEvaluations

	//Carrega Outras Pontuacoes
	oPolicy:cPolicy       := HttpSession->cPolicy
	oPolicy:cEmployeeFil  := HttpSession->aStructure[nIndice]:cEmployeeFilial
	oPolicy:cRegistration := HttpSession->aStructure[nIndice]:cRegistration

	oPolicy:cSupEmployeeFil  := HttpSession->aUser[2]
	oPolicy:cSupRegistration := HttpSession->aUser[3]

	aOthers := {}
	If oPolicy:GetConsolidated()     
		For nX := 1 to len(OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT)
			If OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CGROUP == '03'
				aadd(aOthers,OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CKEYDESC)
			EndIf
			//Guarda percentuais da politica
			If OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CGROUP == '01'
				nPerGoals  := val(OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CWEIGHT)
			ElseIf OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CGROUP == '02'
				nPerAssess  := val(OPOLICY:OWSGETCONSOLIDATEDRESULT:OWSITEMSOFCONSOLIDATED:OWSCONSOLIDATEDRESULT[nX]:CWEIGHT)
			Endif
		Next nX
	EndIf
	HttpSession->Others 	:= aOthers
	HttpSession->PerGoals 	:=  nPerGoals 
	HttpSession->PerAssess 	:=  nPerAssess
	
	cHtml := ExecInPage("PWSX704")
	 	    
WEB EXTENDED END

Return cHtml

