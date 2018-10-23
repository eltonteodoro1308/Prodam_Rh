#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "PWSA100.CH"
#DEFINE cCodUser "MSALPHA"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ Tela inicial de Solicitação de Ferias                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ FNC            ³  Motivo da Alteracao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos|30/04/14|TPKFN9          |Replica alterações realizadas   ³±±
±±³              |        |                |pela manutenção até 05/02/14    ³±±
±±³              |        |                |chamado TIHRV8, changeset 204825³±±
±±³              |        |                |na P11.80                       ³±±
±±³Allyson M     |24/06/15|TSO576          |Ajuste p/ armazenar o cadastro  ³±±
±±³              |        |                |das programacoes de ferias em   ³±±
±±³              |        |                |uma variavel p/ ser utilizada   ³±±
±±³              |        |                |na pagina HTML                  ³±±
±±³Renan Borges  ³14/07/15³TSRISM          ³Ajuste para apenas carregar a pa³±±
±±³              ³        ³                ³gina se não houver erro na carga³±±
±±³              ³        ³                ³da estrutura organizacional.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*******************************************************************
* Funcao: PWSA0100a
* Autor: Tatiane Vieira Matias
* Data: 07/03/2008   
* Tela inicial de Solicitação de Ferias
********************************************************************/
Web Function PWSA100a()

	Local cHtml   	:= ""
	Local oParam  		:= Nil

	WEB EXTENDED INIT cHtml START "InSite"	              
		HttpSession->cPaisLoc		:= cPaisLoc
		HttpSession->cTypeRequest 	:= "B"		  	// Solicitação de Ferias
		HttpGet->titulo          	:= STR0004 		//"Solicitação de Ferias"
		HttpSession->aStructure  	:= {}
		HttpSession->cHierarquia 	:= ""
		HttpSession->cPdiasFe	 	:= ""
		
	    oParam	:= WSCFGDICTIONARY():NEW()
		WsChgURL(@oParam, "CFGDICTIONARY.APW")
		
		If oParam:GETPARAM("MSALPHA", "MV_PDIASFE")
			// Verifica se existe o parametro e nao esta vazio.
			If oParam:cGETPARAMRESULT <> ".F." .And. !Empty(oParam:cGETPARAMRESULT)
				HttpSession->cPdiasFe := oParam:cGETPARAMRESULT
            Else
				HttpSession->cPdiasFe := "10"
			EndIf					
		EndIf
		
		fGetInfRotina("W_PWSA100A.APW")
		GetMat()								//Pega a Matricula e a filial do participante logado

		cHtml := ExecInPage("PWSA120A")
	WEB EXTENDED END

Return cHtml


/*******************************************************************
* Funcao: PWSA101
* Autor: Tatiane Vieira Matias
* Data: 07/03/2008
* Lista dos funcionários da equipe
********************************************************************/
Web Function PWSA101()
	Local cHtml   	  	:= ""
	Local oParam	  	:= Nil
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
		Default HttpGet->FilterField     	:= ""
		Default HttpGet->FilterValue	    := ""
		Default HttpGet->EmployeeFilial   	:= ""  
		Default HttpGet->Registration     	:= ""
	 	nCurrentPage:= Val(HttpGet->Page)

		oOrg := WSORGSTRUCTURE():New()
		WsChgURL(@oOrg,"ORGSTRUCTURE.APW")  
		
		If Empty(HttpGet->EmployeeFilial) .And. Empty(HttpGet->Registration)
			oOrg:cParticipantID 	    := HttpSession->cParticipantID 		
			
			If ValType(HttpSession->RHMat) != "U" .And. !Empty(HttpSession->RHMat)
				oOrg:cRegistration	 := HttpSession->RHMat
			EndIf	
		Else
			oOrg:cEmployeeFil  	    := HttpGet->EmployeeFilial
			oOrg:cRegistration 	    := HttpGet->Registration
		EndIf

		oOrg:cVision     		    := HttpSession->aInfRotina:cVisao
		oOrg:nPage         		    := nCurrentPage
		oOrg:cFilterValue 		    := HttpGet->FilterValue
		oOrg:cFilterField   		    := HttpGet->FilterField
		oOrg:cRequestType 		    := HttpSession->cTypeRequest
	   	
		IF oOrg:GetStructure()
			HttpSession->aStructure  := aClone(oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE)
			nPageTotal 		       := oOrg:oWSGetStructureResult:nPagesTotal
         
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
		
		OpenSm0()
		HttpSession->aSM0 := FWLoadSM0()

		// Solicitacao de Transferencia
		If HttpSession->cTypeRequest == '4'
			lCorpManage	:= fIsCorpManage()		
			if lCorpManage
				HttpSession->lGestaoCorp := .T.			
			Else
				HttpSession->lGestaoCorp := .F.			
			EndIf

			//Objeto que retorna o conteudo do Parametro "MV_ORGCFG" (SX6)
			//0=Nao utiliza; 1=Utiliza com controle de postos; 2=Utiliza sem controle de postos
			oParam	:= WSCFGDICTIONARY():NEW()
			WsChgURL(@oParam,"CFGDICTIONARY.APW") 

			If oParam:GETPARAM( "MSALPHA", "MV_ORGCFG" ) 
				// Verifica se existe o parametro
				If oParam:cGETPARAMRESULT <> ".F."
					HttpSession->cOrgCfg := oParam:cGETPARAMRESULT
                else
					HttpSession->cOrgCfg := "0"
				EndIf
			EndIf
		EndIf

		// Solicitacao de Desligamento
		If HttpSession->cTypeRequest == '6'
			If (FASE4())
				HttpSession->lFase4 := .T.			
			Else
				HttpSession->lFase4 := .F.			
			EndIf
		EndIf
             
		cHtml := ExecInPage( "PWSA120" )

	WEB EXTENDED END
Return cHtml

/********************************************************************
* Funcao: PWSA102
* Autor: Tatiane Vieira Matias
* Data: 17/03/2008
* Informacoes do funcionario
********************************************************************/
Web Function PWSA102()
	Local n
	Local cHtml   		 := ""
	Local cParam		 := ""
	Private cPageRequest := ""
		
  	If !(Valtype(HttpGet->cTypeRequest) == "U")
		HttpSession->cTypeRequest := HttpGet->cTypeRequest
  	EndIf
  	
  	If (Valtype(HttpGet->nIndice) == "U") .or. ( HttpGet->nIndice == "0" .and. !(Valtype(HttpSession->nIndice) == "U") )
  		HttpGet->nIndice := HttpSession->nIndice
  	EndIf
  	
  	If ValType(HttpGet->nOperacao) == "U" .and. !(ValType(HttpSession->nOperacao) == "U")
  		HttpGet->nOperacao := HttpSession->nOperacao
  	EndIf  

	// Monta Empresa-Unidade
	If (HttpGet->nOperacao $ "1") 
		HttpSession->cEmpFil := ""
		For n := 1 to Len(HttpSession->aSM0)
  			If !(Valtype(HttpGet->nIndice) == "U")
				If (HttpSession->aSM0[n][2] == HttpSession->aStructure[val(HttpGet->nIndice)]:CEMPLOYEEFILIAL)
					HttpSession->cEmpFil := HttpSession->aSM0[n][3] + HttpSession->aSM0[n][4] + space(len(HttpSession->aSM0[n][4]))
				EndIf
			Else				
      			If (HttpSession->cTypeRequest == "F")	// Espelho de Ponto
					If (HttpSession->aSM0[n][2] == HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cFilTransfTo)
						HttpSession->cEmpFil := HttpSession->aSM0[n][3] + HttpSession->aSM0[n][4] + space(len(HttpSession->aSM0[n][4]))
					EndIf
				EndIf       
         	EndIf
		Next
	EndIf

    // Solicitacao de treinamento
    If (HttpSession->cTypeRequest == "A")
		HttpSession->nIndice := HttpGet->nIndice
		If (HttpGet->nOperacao == "1")
			cParam	:= '?'
			//Solicitacao a partir do Filtro no fonte PWSA290C
    		If !HttpGet->txtFiltroCurso == Nil
    			If HttpGet->btnFiltraCurso <> Nil
    				cParam	+= "FilterField="+HttpGet->ddlFiltroCurso+"&FilterValue="+HttpGet->txtFiltroCurso+"&cFilVal2="+HttpGet->cFilVal2+"&cFilFie2="+HttpGet->cFilFie2
    			Else	
    				cParam	+= "FilterField=&FilterValue=&cFilVal2="+HttpGet->cFilVal2+"&cFilFie2="+HttpGet->cFilFie2
    			EndIf
    		EndIf
    		
    		//Solicitacao a partir do Filtro no fonte PWSA290C
    		If !HttpGet->txtFiltroOutroCurso == Nil
    			If Len(cParam) > 1
	    			cParam	+= "&"
	    		EndIf
    			If HttpGet->btnFiltraOutroCurso <> Nil
    				cParam	+= "FilterField2="+HttpGet->ddlFiltroOutroCurso+"&FilterValue2="+HttpGet->txtFiltroOutroCurso+"&cFilVal="+HttpGet->cFilVal+"&cFilFie="+HttpGet->cFilFie
    			Else	
    				cParam	+= "FilterField2=&FilterValue2=&cFilVal="+HttpGet->cFilVal+"&cFilFie="+HttpGet->cFilFie
    			EndIf
    		EndIf
    		
    		If !HttpGet->Page == Nil
    			If Len(cParam) > 1
	    			cParam	+= "&"
	    		EndIf
    			cParam	+= "Page="+HttpGet->Page+"&nIndice="+HttpGet->nIndice
    		EndIf 
    		
    		If !HttpGet->OutPage == Nil
    			If Len(cParam) > 1
	    			cParam	+= "&"
	    		EndIf
    			cParam	+= "OutPage="+HttpGet->OutPage
    		EndIf
    		
    		If !HttpGet->FilterCateg == Nil
	    		cParam += "&FilterCateg="+HttpGet->FilterCateg
	    		cParam += "&FilterType="+HttpGet->FilterType
	    	EndIf
	    	
	    	If !HttpGet->FilterCateg1 == Nil
	    		cParam += "&FilterCateg="+HttpGet->FilterCateg1
	    		cParam += "&FilterType="+HttpGet->FilterType1
	    	EndIf
	    	    		
			cPageRequest := "W_PWSA221.APW"+cParam
		elseif (HttpGet->nOperacao == "3")
			cPageRequest := "W_PWSA221a.APW"
		Endif				
  	EndIf
    // Solicitacao de ferias
    If (HttpSession->cTypeRequest == "B")
		cPageRequest := "W_PWSA102B.APW"
  	EndIf
    // Solicitacao de transferencia
    If (HttpSession->cTypeRequest == "4")
		cPageRequest := "W_PWSA141.APW"
  	EndIf
    // Solicitacao de desligamento
    If (HttpSession->cTypeRequest == "6")
		cPageRequest := "W_PWSA131.APW"
  	EndIf
    // Solicitacao de acao salarial
    If (HttpSession->cTypeRequest == "7")
		cPageRequest := "W_PWSA121.APW"
  	EndIf
    // Solicitacao de justificativa
    If (HttpSession->cTypeRequest == "8")
		cPageRequest := "W_PWSA161.APW"
  	EndIf
  	// Mapa de Treinamento
    If (HttpSession->cTypeRequest == "C")
		cPageRequest := "W_PWSA330B.APW"	
  	EndIf  	  	
  	// Competencia
    If (HttpSession->cTypeRequest == "D")
		cPageRequest := "W_PWSA350B.APW"	
  	EndIf   	 	  	
  	// Banco de Horas
    If (HttpSession->cTypeRequest == "E")
		cPageRequest := "W_PWSA300B.APW"	
  	EndIf   	 	  	
  	// Espelho de Ponto
    If (HttpSession->cTypeRequest == "F")
    	//Solicitacao a partir do Filtro no fonte PWSA290C
    	If !HttpGet->FilterValue == Nil
    		cParam	:= "?FilterField="+HttpGet->FilterField+"&FilterValue="+HttpGet->FilterValue
    	EndIf
		cPageRequest := "W_PWSA290B.APW"+cParam	
  	EndIf   	 	  	
  	// Tabela de Horario
    If (HttpSession->cTypeRequest == "G")
		cPageRequest := "W_PWSA310B.APW"	
  	EndIf        	  	
    // Dados cadastrais
    If (HttpSession->cTypeRequest == "CAD")
		cPageRequest := "W_PWSA261.APW"
  	EndIf
    // Ferias Programadas
    If (HttpSession->cTypeRequest == "FERPROG")
		cPageRequest := "W_PWSA271.APW"
  	EndIf
  	
  	// Gap de Fatores
    If (HttpSession->cTypeRequest == "I")
		cPageRequest := "W_PWSA231.APW"	
  	EndIf
  	
  	// Gap de Habilidades
    If (HttpSession->cTypeRequest == "J")
		cPageRequest := "W_PWSA241.APW"	
  	EndIf
  	
  	// Tabela de Dependentes
    If (HttpSession->cTypeRequest == "K")
		cPageRequest := "W_PWSA171.APW"	
  	EndIf
  	
  	// Tabela de Afastamentos
    If (HttpSession->cTypeRequest == "L")
		cPageRequest := "W_PWSA211.APW"	
  	EndIf


   //Gestao Publica - Alteracao de Jornada
   If (HttpSession->cTypeRequest == "N")
       cPageRequest := "W_PWSA511.APW" 
   EndIf
   //Gestao Publica - Saldo de Ferias
   If (HttpSession->cTypeRequest == "O")
       cPageRequest := "W_PWSA521.APW" 
   EndIf
   //Gestao Publica - Programacao de Ferias
   If (HttpSession->cTypeRequest == "P")
       cPageRequest := "W_PWSA531.APW" 
   EndIf
   //Gestao Publica - Diarias
   If (HttpSession->cTypeRequest == "Q")
       cPageRequest := "W_PWSA541.APW" 
   EndIf
   //Gestao Publica - Licenca e Afastamento
   If (HttpSession->cTypeRequest == "R")
       cPageRequest := "W_PWSA551.APW" 
   EndIf
   //Gestao Publica - Certidao Funcional
   If (HttpSession->cTypeRequest == "S")
       cPageRequest := "W_PWSA561.APW" 
   EndIf
   //Gestao Publica - Saldo de Dias de Folga
   If (HttpSession->cTypeRequest == "T")
       cPageRequest := "W_PWSA571.APW" 
   EndIf  	
  	// Solictação de Subsídio Acadêmico
    If (HttpSession->cTypeRequest == "V")
		cPageRequest := "W_PWSA381.APW"	
  	EndIf  
   //Historico Salarial
   If (HttpSession->cTypeRequest == "X")
       cPageRequest := "W_PWSA391.APW"
  	EndIf   	  
   //Marcação manual do ponto 
   If (HttpSession->cTypeRequest == "Z")
       cPageRequest := "W_PWSA401.APW"
  	EndIf 
  	HttpCTType("text/html; charset=ISO-8859-1")
   	WEB EXTENDED INIT cHtml START "InSite"
		cHtml := ExecInPage( "PWSA102" )	
   	WEB EXTENDED END
	
	
Return cHtml

/*******************************************************************
* Funcao: PWSA102A
* Autor: Tatiane Vieira Matias
* Data: 28/12/2010
* Informacoes do funcionario - Cabecalho
********************************************************************/
Web Function PWSA102A()
Local cHtml    	   := ""
Local oRequest
local oOrg
WEB EXTENDED INIT cHtml START "InSite"

	HttpSession->_HTMLERRO := ""

  	If (HttpGet->nOperacao == "1")
  	
  		If (HttpSession->cTypeRequest == "F")	// Espelho de Ponto
			If HttpGet->nIndice != "0" .And. HttpSession->IndTransf	 == "0"
		   		HttpPost->DadosFunc 			:= HttpSession->aStructure[val(HttpGet->nIndice)]
				HttpSession->IndTransf	:= "0"
		   	Else  		
		   		//Carrega Dados atuais do funcionario
				HttpPost->DadosFunc     := HttpSession->aStructure[1]

				//Pagina recarregada pelo filtro 
				If HttpSession->IndTransf		!= "0"
					HttpGet->nIndiceTransf := HttpSession->IndTransf 
				EndIf
												
				//Atualiza informacoes com dados da matricula transferida
				HttpSession->IndTransf						:= HttpGet->nIndiceTransf
												
				HttpPost->DadosFunc:cEmployeeFilial		:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cFilTransfFrom 
				HttpPost->DadosFunc:cFilialDescr   		    := HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cFilialDescr
				HttpPost->DadosFunc:cRegistration		 	:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cFilTransfFrom +;
															   " - "+HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cRegTransfFrom 
				HttpPost->DadosFunc:cName 					:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cName 
				HttpPost->DadosFunc:cAdmissionDate		    := HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cAdmissionDate 
				HttpPost->DadosFunc:cNameSup				:= "" 
				HttpPost->DadosFunc:cPosition				:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cPosition 
				HttpPost->DadosFunc:cFunctionDesc			:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cFunctionDesc 
				HttpPost->DadosFunc:cDescrDepartment	    := HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cDescrDepartment 
				HttpPost->DadosFunc:cCost					:= HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:cCost 
				HttpPost->DadosFunc:nSalary				    := HttpSession->aUserTransf:OWSLISTOFTRANSFERS:OWSDATAEMPLOYEETRANSF[val(HttpGet->nIndiceTransf)]:nSalary 
			EndIf  	  
		Else
			If !(Valtype(HttpGet->nIndice) == "U")
		   		HttpPost->DadosFunc        	:= HttpSession->aStructure[val(HttpGet->nIndice)]
				HttpSession->FuncSubst    	:= .F.
                If HttpSession->lGSP
                	HttpSession->FuncSubst :=  HttpSession->aStructure[val(HttpGet->nIndice)]:lFunctionSubst
                EndIf   
			EndIf
		EndIf			   		
   		
  	ElseIf (HttpGet->nOperacao $ "3*4")
			oRequest := HttpSession->oRequests[val(HttpGet->nIndiceSolic)]
	
			oOrg := WSORGSTRUCTURE():New()                                                  
			WsChgURL(@oOrg,"ORGSTRUCTURE.APW")  
			
		   	If (HttpSession->cTypeRequest == "A") 	// Treinamento
				fGetInfRotina("W_PWSA220.APW") 		//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"RA3_FILIAL")
				oOrg:cRegistration  := PegaValores(oRequest,"RA3_MAT")
			EndIf
		   	If (HttpSession->cTypeRequest == "B") 	// Ferias
				fGetInfRotina("W_PWSA100A.APW") 	//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"R8_FILIAL")
				oOrg:cRegistration  := PegaValores(oRequest,"R8_MAT")
			EndIf
		   	If (HttpSession->cTypeRequest == "4") 	// Transferencia
				fGetInfRotina("W_PWSA140.APW") 		//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"RE_FILIALD")
				oOrg:cRegistration  := PegaValores(oRequest,"RE_MATD")
			EndIf
		   	If (HttpSession->cTypeRequest == "6") 	// Desligamento
				fGetInfRotina("W_PWSA130.APW") 		//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
				oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
			EndIf
		   	If (HttpSession->cTypeRequest == "7") 	// Acao Salarial
				fGetInfRotina("W_PWSA120.APW") 		//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"RB7_FILIAL")
				oOrg:cRegistration  := PegaValores(oRequest,"RB7_MAT")
			EndIf
		   	If (HttpSession->cTypeRequest == "8") 	// Justificativa
				fGetInfRotina("W_PWSA160.APW") 		//Retorno HttpSession->aInfRotina
				oOrg:cEmployeeFil   := PegaValores(oRequest,"RF0_FILIAL")
				oOrg:cRegistration  := PegaValores(oRequest,"RF0_MAT")
			EndIf
           	If (HttpSession->cTypeRequest == "N")   // Gestao Publica - Alteracao de Jornada
                fGetInfRotina("W_PWSA510.APW")      //Retorno HttpSession->aInfRotina
                oOrg:cEmployeeFil   := PegaValores(oRequest,"PF_FILIAL")
                oOrg:cRegistration  := PegaValores(oRequest,"PF_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "O")   // Gestao Publica - Saldo de Ferias
               fGetInfRotina("W_PWSA520.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "P")   // Gestao Publica - Programacao de Ferias
               fGetInfRotina("W_PWSA530.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "Q")   // Gestao Publica - Diaria
               fGetInfRotina("W_PWSA540.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "R")   // Gestao Publica - Licenca e Afastamento
               fGetInfRotina("W_PWSA550.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "S")   // Gestao Publica - Certidao Funcional
               fGetInfRotina("W_PWSA560.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf
           	If (HttpSession->cTypeRequest == "T")   // Gestao Publica - Saldos de Dias de Folga
               fGetInfRotina("W_PWSA570.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RA_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RA_MAT")
            EndIf            
           If (HttpSession->cTypeRequest == "V")   // Solic. Subsídio Acadêmico
               fGetInfRotina("W_PWSA380.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"RI1_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"RI1_MAT")
           EndIf
           If (HttpSession->cTypeRequest == "Z")   // Marcação manual do ponto
               fGetInfRotina("W_PWSA400.APW")      //Retorno HttpSession->aInfRotina
               oOrg:cEmployeeFil   := PegaValores(oRequest,"P8_FILIAL")
               oOrg:cRegistration  := PegaValores(oRequest,"P8_MAT")
           EndIf
            

			oOrg:cVision	        := HttpSession->aInfRotina:cVisao
						   	
			If oOrg:GetStructure()
				HttpPost->DadosFunc := aClone(oOrg:oWSGetStructureResult:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE)[1]
			ElseIf (HttpSession->cTypeRequest == "6")
				HttpSession->_HTMLERRO  := { STR0001, PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
				cHtml := ExecInPage("PWSAMSG" )
			EndIf 

 		EndIf
 	HttpCTType("text/html; charset=ISO-8859-1")
 	If Empty(HttpSession->_HTMLERRO)
		cHtml := ExecInPage( "PWSA102A" )	
	EndIf
WEB EXTENDED END

Return cHtml

/*******************************************************************
* Funcao: PWSA102B
* Autor: Tatiane Vieira Matias
* Data: 28/12/2010
* Informacoes do funcionario - dados solicitacao de ferias
********************************************************************/
Web Function PWSA102B()
Local aFerProg := {}
Local cHtml 		:= ""
Local nIndice  := 0
Local oObj 
Local oRequest
Local oFerias
Local oWSFerProg
Local nReg

  If (HttpGet->nOperacao == "1")
		If(valtype(HttpGet->nIndiceSolic) != "U")
		   nIndice := val(HttpGet->nIndice) 
		EndIf
	ElseIf (HttpGet->nOperacao $ "3*4")
		If(valtype(HttpGet->nIndiceSolic) != "U")
		   nIndice := val(HttpGet->nIndiceSolic) 
		EndIf
	EndIf	
			
WEB EXTENDED INIT cHtml START "InSite"	
    GetMat()	//Pega filial e matricula do participante 

	//Busca ferias programadas do funcionario
	oWSFerProg := WsRHVACATION():New()
	WsChgURL(@oWSFerProg, "RHVACATION.apw")

	HTTPGet->nDiasAbo	:= 0
	HTTPGet->nDiasProg	:= 0
    If (HttpGet->nOperacao == "1") .and. (nIndice > 0)
		oWSFerProg:cEmployeeFil	:= HttpSession->aStructure[nIndice]:cEmployeeFilial
		oWSFerProg:cRegistration	:= HttpSession->aStructure[nIndice]:cRegistration
		If oWSFerProg:GetVacProgEffect()
			aFerProg 			:= oWSFerProg:oWSGETVACPROGEFFECTRESULT:oWSListOfVacProgEffect:oWSDataVacProgEffect
			HTTPGet->aFerProg 	:= oWSFerProg:oWSGETVACPROGEFFECTRESULT:oWSListOfVacProgEffect:oWSDataVacProgEffect

			For nReg := 1 to Len(aFerProg)
				HTTPGet->nDiasAbo  +=	aFerProg[nReg]:nAllowDays
				HTTPGet->nDiasProg +=	aFerProg[nReg]:nVacationDays
			Next nReg
		EndIf
	EndIf
	
	//Busca Dados montagem da solicitacao
	oObj := WSRHVacation():New()
	WsChgURL(@oObj,"RHVACATION.APW")  

    If (HttpGet->nOperacao == "1")  
		oObj:cEmployeeFil  := HttpSession->aStructure[nIndice]:cEmployeeFilial
		oObj:cRegistration := HttpSession->aStructure[nIndice]:cRegistration

		If oObj:GetPerAbert()     
			HttpGet->aPeriodos := aSize( oObj:oWSGetPerAbertResult:oWSListOfPeriod:oWSPeriodVacationProg, 1 )
		Else
			HttpGet->aPeriodos := {}
		EndIf
    ElseIf (HttpGet->nOperacao $ "3*4")
		oRequest := HttpSession->oRequests[nIndice]
		oFerias  := WSClassNew("RHREQUEST_TVACATION")
		
		oFerias:cInitialDate                  	:= PegaValores(oRequest,"R8_DATAINI")
		oFerias:cFinalDate                    	:= PegaValores(oRequest,"R8_DATAFIM")
		oFerias:nDays                         	:= PegaValores(oRequest,"R8_DURACAO")
		oFerias:cPecuniaryAllowance          	:= PegaValores(oRequest,"TMP_ABONO")
		oFerias:cThirteenthSalary1stInstall 	:= PegaValores(oRequest,"TMP_1P13SL")
	                                                                           
		HttpPost->Ferias := oFerias

		oObj:cEmployeeFil  := PegaValores(oRequest,"R8_FILIAL")
		oObj:cRegistration := PegaValores(oRequest,"R8_MAT")
	EndIf

	If oObj:GetTypeCalcDay()
       HttpSession->cTipoCalcDia := oObj:cGetTypeCalcDayResult
	EndIf
	
	HttpCTType("text/html; charset=ISO-8859-1")
	cHtml := ExecInPage( "PWSA102B" )	

WEB EXTENDED END

Return cHtml

                     
/*******************************************************************
* Funcao: PWSA103
* Autor: Tatiane Vieira Matias
* Data: 29/12/10
* Solicitação de Ferias - Gravacao   
********************************************************************/
Web Function PWSA103()

Local cHtml   	   := ""
Local oObj    
Local oOrg

WEB EXTENDED INIT cHtml START "InSite"   

    oOrg := WSORGSTRUCTURE():New()
	WsChgURL(@oOrg,"ORGSTRUCTURE.APW")
                       
	oOrg:cParticipantID 	:= HttpSession->cParticipantID
	oOrg:cTypeOrg       	:= ""
	oOrg:cVision        	:= HttpSession->aInfRotina:cVisao
	If ValType(HttpSession->RHMat) != "U" .And. !Empty(HttpSession->RHMat)
		oOrg:cRegistration	:= HttpSession->RHMat
	EndIf	
		 
    If oOrg:GetStructure()
    	oObj := WSRHREQUEST():New()
		WsChgURL(@oObj,"RHREQUEST.APW")

		oObj:oWSREQUEST:cBRANCH              	:= HttpSession->aStructure[val(HttpPost->nIndice)]:cEmployeeFilial
		oObj:oWSREQUEST:cREGISTRATION          	:= HttpSession->aStructure[val(HttpPost->nIndice)]:cRegistration
		oObj:oWSREQUEST:cStarterBranch         	:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:cEmployeeFilial
		oObj:oWSREQUEST:cStarterRegistration   	:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:cRegistration
		oObj:oWSREQUEST:cVISION                	:= HttpSession->aInfRotina:cVisao
		oObj:oWSREQUEST:cOBSERVATION    		:= HttpPost->txtobs
		oObj:oWSREQUEST:cApproverBranch		   	:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:cSupFilial
		oObj:oWSREQUEST:cApproverRegistration 	:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:cSupRegistration
		oObj:oWSREQUEST:nApproverLevel		   	:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:nLevelSup
		oObj:oWSREQUEST:cDepartAPR	 			:= oOrg:OWSGETSTRUCTURERESULT:oWSLISTOFEMPLOYEE:OWSDATAEMPLOYEE[1]:cDepartAprovador
		                                    
		//Solicitacao de Ferias
		If HttpSession->cTypeRequest == "B" 
			oObj:oWSVacationRequest:cBranch                    	   	:= HttpSession->aStructure[val(HttpPost->nIndice)]:cEmployeeFilial
			oObj:oWSVacationRequest:cRegistration                  	:= HttpSession->aStructure[val(HttpPost->nIndice)]:cRegistration
			oObj:oWSVacationRequest:cName                      	   	:= HttpSession->aStructure[val(HttpPost->nIndice)]:cName
			oObj:oWSVacationRequest:cInitialDate                   	:= HttpPost->txtdtInicial
			oObj:oWSVacationRequest:cFinalDate               	   	:= HttpPost->txtdtFinal
			oObj:oWSVacationRequest:nDays                    	   	:= val(HttpPost->txtdias)
			oObj:oWSVacationRequest:cPecuniaryAllowance        		:= Iif( Valtype(HttpPost->chkAbono) == "U", ".F.", ".T.")
			oObj:oWSVacationRequest:cThirteenthSalary1stInstall		:= Iif( Valtype(HttpPost->chk1Parc13Sal) == "U", ".F.", ".T.")
	     
			If oObj:AddVacationRequest()
				HttpGet->msg          := STR0014 // "Operacao realizada com sucesso"			
		        W_PWSA100a()
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
				Return ExecInPage("PWSAMSG" )
			EndIf        
		EndIf
	Else
		HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_PWSA000.APW" }	//"Erro"
		Return ExecInPage("PWSAMSG" )
	EndIf

WEB EXTENDED END

Return cHtml   

/*******************************************************************
* Funcao: fGetInfRotina
* Autor: Tatiane Vieira Matias
* Data: 17/03/2008
* Retorna informacoes do menu Programacao de ferias 
* (visao, nivel inicial e nivel de aprovacao)
********************************************************************/
Function fGetInfRotina(cRotina)
	Local oMenuGPE
	Local cCodMenu := ""
	Local nI       := 0     
	Local nJ       := 0
	Local nZ       := 0
	
	Default cRotina  := If(HttpSession->cTypeRequest == "B","W_PWSA100a.APW","")
	             
	HttpSession->aInfRotina := {}
	
	For nI := 1 To Len( HttpSession->_aMenu )
		If !Empty(cCodMenu)
			exit
		EndIf
		
		If Upper(Alltrim(HttpSession->_aMenu[nI][1]:cProcedureCall)) == Upper(AllTrim(cRotina))
        	cCodMenu := HttpSession->_aMenu[nI][1]:cCode
        	exit
		Else
			For nJ := 2 To Len( HttpSession->_aMenu[nI] )
				For nZ := 1 To Len( HttpSession->_aMenu[nI][nJ] )
					If Upper(AllTrim(HttpSession->_aMenu[nI][nJ][nZ]:cProcedureCall)) == Upper(AllTrim(cRotina))
        				cCodMenu := HttpSession->_aMenu[nI][nJ][nZ]:cCode
        				exit
					EndIf
				Next nZ
			Next nJ
		EndIf
	Next nI
	
	oMenuGPE := WSMENU():New()
	WsChgURL(@oMenuGPE, "MENU.APW")

	//Buscar dados do item de menu
	If oMenuGPE:GetDadosMenu(HttpSession->PRT_CODE, cCodMenu)
		If !Empty(oMenuGPE:oWSGETDadosMenuRESULT)
			HttpSession->aInfRotina := oMenuGPE:oWSGETDadosMenuRESULT
		EndIf                                                        
	EndIf

Return .T.
                      
/*******************************************************************
* Funcao: PWSA104
* Autor: Tatiane Vieira Matias & Marcelo M Faria
* Data: 30/01/11
* Solicitação de Férias - Calculo da data final
********************************************************************/
Web Function PWSA104()
Local cHtml 	 := ""
Local dDataFinal := ""
Local Dia, Mes

	HttpCTType("text/html; charset=ISO-8859-1")
	
	WEB EXTENDED INIT cHtml	

		oObj := WSRHVacation():New()
		WsChgURL(@oObj,"RHVACATION.APW")  

		oObj:cStartDateVacation  := HttpGet->dtini
		oObj:nVacationDays		 := Val(HttpGet->qtdedias)
		
		// Busca GetCalend para calculo oficial da data final
		// utilizando dias uteis, tambem verificando feriados
		If oObj:GetCalendDate()
    	   dDataFinal := CTOD(oObj:cGetCalendDateResult)
		EndIf
    
		// Formata data para DD/MM/YYYY
		If dDataFinal <> ctod("//") 
			Dia := DAY(dDataFinal)
			IF Dia < 10
			   cHtml += "0" + LTRIM(STR(Dia))
			Else
			   cHtml += LTRIM(STR(Dia))
			EndIf

			Mes := MONTH(dDataFinal)
			IF Mes < 10
			   cHtml += +"/0" + LTRIM(STR(Mes))
			Else
			   cHtml += +"/"  + LTRIM(STR(Mes))
			EndIf

			cHtml += "/" +LTRIM(STR(YEAR(dDataFinal)))
		EndIf

	WEB EXTENDED END
RETURN cHtml

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0()
Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20  
	dbUseArea( .T.,, "sigamat.emp", "SM0", .T., .T. )             
 	If !Empty( Select( "SM0" ) ) 
  		lOpen := .T. 
    	dbSetIndex("sigamat.ind") 
     	Exit        
	EndIf
 	Sleep( 500 ) 
Next nLoop

If !lOpen
	HttpSession->_HTMLERRO := { STR0094, PWSGetWSError(), "W_PWSA000.APW"}  //"Nao foi possivel a abertura da tabela de empresas de forma exclusiva !"
EndIf

Return(lOpen)
