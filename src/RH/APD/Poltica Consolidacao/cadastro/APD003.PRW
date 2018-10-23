#Include "Totvs.ch"
#Include "FwMVCDef.ch"
#Include "TopConn.ch"
#Include "APD003.ch"

#DEFINE OPER_FECHAR   10
#DEFINE OPER_CANCELAR 11
#DEFINE OPER_REATIVAR 12

Static lFechada := .F.

/*/{Protheus.doc} APD003

@type function
@author Jorge Heitor
@since 31/03/2016
@version 1.0
@description Funcionalidade para Cadastro de Configurações de Política de Consolidações"

/*/
User Function APD003()

	Local oBrowse	:= FwMBrowse():New()
	Local lCompart	:= U_APD003VC()
	Private lTemSZE	:= .F.
	
	If lCompart
	
		oBrowse:SetAlias("SZC")
		oBrowse:SetCacheView(.F.)
		oBrowse:DisableDetails()
		oBrowse:SetDescription(STR0001) //"Política de Consolidação"
		oBrowse:AddLegend("SZC->ZC_STATUS == '1'" , "GREEN",  STR0037 ) //"Política Ativa"
		oBrowse:AddLegend("SZC->ZC_STATUS == '2'" , "ORANGE", STR0038 ) //"Política Cancelada"
		oBrowse:AddLegend("SZC->ZC_STATUS == '3'" , "RED", 	  STR0039 ) //"Política Fechada"
		//oBrowse:SetFilterDefault()
		
		oBrowse:Activate()
		
	EndIf
	
Return

/*/{Protheus.doc} MenuDef

@type function
@author Jorge Heitor
@since 31/03/2016
@version 1.0
@description Função de Pré-carregamento dos itens de Menu

/*/
Static Function MenuDef()

	Local aRotina := {} //Array utilizado para controlar opcao selecionada
	
	ADD OPTION aRotina TITLE STR0002	ACTION "PesqBrw" 		OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE STR0003	ACTION "VIEWDEF.APD003" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE STR0004	ACTION "VIEWDEF.APD003" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE STR0005	ACTION "VIEWDEF.APD003" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE STR0006	ACTION "VIEWDEF.APD003" OPERATION 5 ACCESS 0 //"Excluir"

Return aRotina

/*/{Protheus.doc} ModelDef

@type function
@author Jorge Heitor
@since 31/03/2016
@version 1.0
@description Função de carregamento dos Modelos de Dados da Funcionalidade

/*/
Static Function ModelDef()

	Local oModel	:= MPFormModel():New('APD003M', /*Pre-Validacao*/,/*Pos-Validacao*/ , /*Commit*/,/*Cancel*/) 
	Local oStruSZC	:= FWFormStruct(1,"SZC")
	Local oStruSZD	:= FWFormStruct(1,"SZD")
	Local nX		:= 0

	oModel:AddFields("SZCMASTER",,oStruSZC)
	oModel:AddGrid("SZDDETAIL","SZCMASTER",oStruSZD,{|oModel,nLine,cAcao|Apd003VldDel(oModel,nLine,cAcao)})
	
	oModel:SetRelation( "SZDDETAIL", { { "ZD_FILIAL", "FWxFILIAL('SZD')" }, { "ZD_CODIGO", "ZC_CODIGO" } }, SZD->( IndexKey( 1 ) ) )
	oModel:GetModel( "SZDDETAIL" ):SetUniqueLine( { "ZD_CODPER" } )

	oModel:SetPrimaryKey({'ZC_FILIAL','ZC_CODIGO'})
	oModel:SetVldActivate({|oY| U_APD003I(oY)})
	oModel:SetPost({|oModel| U_APD003V(oModel)},.T.)
	
Return oModel

/*/{Protheus.doc} ViewDef

@type function
@author Jorge Heitor
@since 31/03/2016
@version 1.0
@description Função de carregamento da Interface de Manutenção dos Registros

/*/
Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oModel	:= FwLoadModel("APD003")
	Local oStruSZC1	:= FWFormStruct(2,"SZC")
	Local oStruSZC2	:= FWFormStruct(2,"SZC")
	Local oStruSZD	:= FWFormStruct(2,"SZD")

	//Remove campos para organização dos dados
	oStruSZC1:RemoveField("ZC_PERCOMP")
	oStruSZC1:RemoveField("ZC_PERMETA")
	oStruSZC1:RemoveField("ZC_PERFORM")
	oStruSZC1:RemoveField("ZC_FILTRO")
	
	//Remove campos já utilizados na estrutura superior
	oStruSZC2:RemoveField("ZC_FILIAL")
	oStruSZC2:RemoveField("ZC_CODIGO")
	oStruSZC2:RemoveField("ZC_DESC")
	oStruSZC2:RemoveField("ZC_STATUS")
	oStruSZC2:RemoveField("ZC_PORTAL")
	
	//Remove campo de relacionamento
	oStruSZD:RemoveField("ZD_CODIGO")
	
	oView:SetModel(oModel)

	oView:AddField("VIEWSZC1",oStruSZC1,"SZCMASTER")
	oView:AddField("VIEWSZC2",oStruSZC2,"SZCMASTER")
	oView:AddGrid("VIEWSZD",oStruSZD,"SZDDETAIL")	
	
	oView:CreateHorizontalBox('SZCFIELD',23)
	oView:CreateHorizontalBox('SZCPERC',22)
	oView:CreateHorizontalBox('SZDGRID',55)
	
	oView:SetOwnerView('VIEWSZC1','SZCFIELD')
	oView:SetOwnerView('VIEWSZC2','SZCPERC')
	oView:SetOwnerView('VIEWSZD','SZDGRID')
	
	oView:EnableControlBar(.T.)
	oView:EnableTitleView("VIEWSZC1", STR0007) //"Dados básicos:"
	oView:EnableTitleView("VIEWSZC2", STR0008) //"Percentuais de distribuição:"
	oView:EnableTitleView("VIEWSZD" , STR0009) //"Períodos envolvidos:"

Return oView

/*/{Protheus.doc} APD003V

@type function
@author Jorge Heitor
@since 31/03/2016
@version 1.0
@description Validações "TudoOK" para manutenção de uma Política de Consolidação 

/*/
User Function APD003V(oModel)

	Local lRet     	:= .T.
	Local nOpc     	:= oModel:GetOperation()    
	Local oModelSZC	:= oModel:GetModel("SZCMASTER")
	Local oModelSZD := oModel:GetModel("SZDDETAIL")
 	Local nI 		:= 0
 	Local nItens	:= 0
 	Local nPercComp	:= 0
 	Local nPercMeta	:= 0
 	Local nPercForm	:= 0
 	Local cMsg		:= ""
 	Local aTipos	:= {}
 	Local lObrigaC	:= .F. //Valida preenchimento obrigatorio do percentual de Avaliação de Competências
 	Local lObrigaM	:= .F. //Valida preenchimento obritatorio do percentual de Metas
	
	If nOpc == 3 .Or. nOpc == 4 // 3 incluir 4 altera
		
		nPercComp := oModelSZC:GetValue("ZC_PERCOMP")
		nPercMeta := oModelSZC:GetValue("ZC_PERMETA")
		nPercForm := oModelSZC:GetValue("ZC_PERFORM")
		
		//Se não totalizar 100.00%, não permite prosseguir
		If nPercComp + nPercMeta + nPercForm <> 100.00 
	
			lRet := .F.
			cMsg := STR0010 //"A soma dos percentuais da distribuição obrigatoriamente deverá ser 100%"
			
		EndIf
		
		//Validação da Obrigatoriedade de se informar Percentual de Competencia
		If lRet
			
			//Efetua a leitura dos tipos distintos existentes 
			nItens := oModelSZD:Length(.F.)
			
			If nItens > 0
				For nI := 1 To nItens
					If !oModelSZD:IsDeleted(nI)
						If oModelSZD:GoLine(nI) == nI
							If aScan(aTipos,{|x| AllTrim(x) == oModelSZD:GetValue("ZD_TIPOPER")}) == 0
								aAdd(aTipos,oModelSZD:GetValue("ZD_TIPOPER"))
							EndIf
						EndIf
					EndIf						
				Next nI
				
				For nI := 1 To Len(aTipos)
					If oModelSZC:GetValue("ZC_FILTRO") == '3' //Ambos
						If aTipos[nI] == "4" .And. oModelSZC:GetValue("ZC_PERCOMP") <= 0.00
							lRet := .F.
							cMsg := STR0011 //"É necessario informar o Percentual de Avaliações de Competência."
							Exit
						ElseIf aTipos[nI] == "3" .And. oModelSZC:GetValue("ZC_PERMETA") <= 0.00
							lRet := .F.
							cMsg := STR0012 //"É necessario informar o Percentual de Avaliações de Metas."
							Exit
						EndIf
					EndIf
				Next nI
			Else
				lRet := .F.
				cMsg := STR0013 //"É necessário informar um ou mais períodos relacionados à Política de Consolidação."
			EndIf
		EndIf
	Endif
	
	If !lRet .And. !Empty(cMsg)
		oModel:SetErrorMessage("",,oModel:GetId(),"","APD003V",cMsg)
	EndIf

Return lRet

/*/{Protheus.doc} APD003I

@type function
@author Jorge Heitor
@since 04/04/2016
@version 1.0
@description Efetua validações iniciais para permitir ou não a alteração de uma Politica 

/*/
User Function APD003I(oModel)

	Local lRet		:= .T.
	Local nOpc		:= oModel:GetOperation()
	Local cMsg		:= ""
	
	lFechada := .F.
	lTemSZE	 := .F.
	
	//Tratamento para Alteração/Exclusão
	If (nOpc == 4 .Or. nOpc == 5) .And. SZC->ZC_STATUS == "3" //Fechada
		lFechada := .T.
	EndIf
	
	If lRet .and. ( nOpc == 4 .or. nOpc == 5 )
		//Verifica existencia de algum registro na tabela SZE (resultados) para a política
		lTemSZE := TemSZE(SZC->ZC_CODIGO)
	EndIf

	If lRet .and. nOpc == 5 .and. lTemSZE
		cMsg := STR0014 + STR0016 + STR0033 //"A Política selecionada não pode ser excluída, pois existe calculo efetuado."		
		lRet := .F.
	EndIf 
		
	If !Empty(cMsg)
		oModel:SetErrorMessage("",,oModel:GetId(),"","APD003I",cMsg)
	EndIf
		 	
Return lRet


/*/{Protheus.doc} TemSZE

@type function
@author Jorge Heitor
@since 04/04/2016
@version 1.0
@description Verifica se determinado código de Politica de Consolidação já possui resultados gravados 

/*/
Static Function TemSZE(cPolitica)

	Local lRet		:= .F.
	Local aArea		:= GetArea()
	Local cQuery	:= "SELECT COUNT(*) QTD FROM " + RetSqlName("SZE") + " SZE WHERE SZE.D_E_L_E_T_ = '' AND ZE_IDCONS = '" + cPolitica + "'"
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TSZE") > 0 ; TSZE->(dbCloseArea()) ; EndIf
	
	TcQuery cQuery ALIAS "TSZE" NEW
	
	dbSelectArea("TSZE")
	
	If !Eof() .And.TSZE->QTD > 0
		lRet := .T.
	EndIf
	
	TSZE->(dbCloseArea())
	
	RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} APD003C

@type function
@author Jorge Heitor
@since 04/04/2016
@version 1.0
@description Inicialização de Campos 

/*/
User Function APD003C(cCampo)

	Local oModel	:= FwModelActive()
	Local xRet		
	Local nOpc		:= oModel:GetOperation()
	Local aArea		:= GetArea()
	
	If nOpc <> 3
		If cCampo == "ZD_INIPER"
			xRet := Posicione("RDU",1,FWxFilial("RDU") + SZD->ZD_CODPER,"RDU_DATINI") //oModel:GetModel("SZDDETAIL"):GetValue("ZD_CODPER"),"RDU_DATINI")
		ElseIf cCampo == "ZD_FIMPER"
			xRet := Posicione("RDU",1,FWxFilial("RDU") + SZD->ZD_CODPER,"RDU_DATFIM") //oModel:GetModel("SZDDETAIL"):GetValue("ZD_CODPER"),"RDU_DATFIM")
		ElseIf cCampo == "ZD_TIPOPER"
			xRet := Posicione("RDU",1,FWxFilial("RDU") + SZD->ZD_CODPER,"RDU_TIPO") //oModel:GetModel("SZDDETAIL"):GetValue("ZD_CODPER"),"RDU_TIPO")
		ElseIf cCampo == "ZD_DESCPER"
			xRet := Posicione("RDU",1,FWxFilial("RDU") + SZD->ZD_CODPER,"RDU_DESC") //oModel:GetModel("SZDDETAIL"):GetValue("ZD_CODPER"),"RDU_DESC")
		EndIf
	ElseIf nOpc == 3 //Para inclusão manda dados zerados
		If cCampo $ "ZD_INIPER/ZD_FIMPER"
			xRet := CtoD("  /  /  ")
		ElseIf cCampo == "ZD_TIPOPER"
			xRet := " "
		ElseIf cCampo == "ZD_DESCPER"
			xRet := Space(TamSX3("ZD_DESCPER")[1])
		EndIf
	EndIf
	
	RestArea(aArea)
	
Return xRet

/*/{Protheus.doc} APD003X

@type function
@author Jorge Heitor
@since 04/04/2016
@version 1.0
@description Validação de Campos da Rotina 

/*/
User Function APD003X(cCampo)

	Local lRet		:= .T.
	Local oModel	:= FwModelActive()
	Local cMsg		:= ""
	
	If cCampo $ "ZC_PERCOMP/ZC_PERMETA/ZC_PERFORM"
		xConteudo := oModel:GetModel("SZCMASTER"):GetValue(cCampo)
		If xConteudo > 100.00
			lRet := .F.
			cMsg := STR0018 //"Não é possível inserir um valor maior que 100.00 para este campo."
		EndIf
	EndIf
	
Return lRet

/*/{Protheus.doc} APD003VC

@author Jorge Heitor
@since 19/04/2016
@version P12.1.6
@description Validação de Compartilhamento entre tabelas

/*/
User Function APD003VC()

	Local lRet		:= .T.
	Local cEnt		:= chr(13) + chr(10)
	Local i			:= 0
	Local aTabs		:= {'SZC','SZD','RDU','RD6','SZE'}
	Local cTabs		:= ''
	Local lDiverg	:= .F.
	Local aArea		:= GetArea()
	
	dbSelectArea("SX2")
	dbSetOrder(1)
	
	For i := 1 to Len(aTabs)
		dbSeek(aTabs[i])
		cTabs += aTabs[i] + ": " + SX2->X2_MODO + '-' + SX2->X2_MODOUN + '-' + SX2->X2_MODOEMP + cEnt
		If SX2->X2_MODO <> "C" .Or. SX2->X2_MODOUN <> "C" .Or. SX2->X2_MODOEMP <> "C"
			lDiverg := .T.
		EndIf
	Next i
	
	If lDiverg
		MsgAlert( STR0025 + cEnt + cEnt;    //"As tabelas abaixo devem estar todas configuradas como 'Compartilhadas':"
		+ cTabs + cEnt + STR0026, STR0027 ) //'Avise o Administrador do sistema'###'Compartilhamentos'
		lRet := .F.
	EndIf

	RestArea(aArea)
	
	If !lRet
		Final()
	EndIf

Return(lRet)

/*/{Protheus.doc} Apd003VldDel

@author Leandro Drumond
@since 28/04/2016
@version P12.1.6
@description Validação da grid SZD

/*/
Static Function Apd003VldDel(oModel,nLine,cAcao)
Local lRet	:= .T.

If cAcao == "DELETE" 
	If lFechada
		Help( ,, STR0031,, STR0035, 1, 0 ) //Atenção ## Política fechada não pode ter os períodos excluídos 
		lRet := .F.
	EndIf
	If lRet .and. lTemSZE
		Help( ,, STR0031,, STR0036, 1, 0 ) //Atenção ## Política possui cálculo e não pode ter os períodos excluídos 
		lRet := .F.
	EndIf
EndIf

Return lRet

/*/{Protheus.doc} SZCWhen

@author Leandro Drumond
@since 28/04/2016
@version P12.1.6
@description When dos campos SZC

/*/
User Function SZCWhen()
Local lRet := !lTemSZE .and. !lFechada

If ( ReadVar() == "M->ZC_DESC" .or. ReadVar() == "M->ZC_STATUS" ).and. !lFechada
	lRet := .T.
EndIf

Return lRet

/*/{Protheus.doc} ZcStatusVld

@author Leandro Drumond
@since 28/04/2016
@version P12.1.6
@description Valid do campo ZC_STATUS

/*/
User Function ZcStatusVld()
Local lRet		:= .T.
Local cVar		:= &(ReadVar())
Local oModel	:= FwModelActive()

If !lTemSZE .and. cVar == "3"
	Help( ,, STR0031,, STR0032, 1, 0 ) //Atenção ## Não existe cálculo efetuado. Utilize a opção de exclusão
	lRet := .F.
ElseIf SZC->ZC_STATUS =="2" .and. cVar == "3"
	Help( ,, STR0031,, STR0034, 1, 0 ) //Atenção ## A politica deve ser reativada antes de efetuar o fechamento.
	lRet := .F.
EndIf

If lRet .and. cVar == "3"
	lRet := .F.
	IF MsgNoYes(STR0028) //"Atenção: você optou por realizar o fechamento da Política. Tem certeza que deseja fechá-la ?"	
		If MsgNoYes(STR0020) //"Confirma o fechamento da Política de Cálculo Consolidado? (Esta operação é irreversível)"
			lRet:= .T.
		EndIf
	EndIf
	If !lRet
		oModel:LoadValue("SZCMASTER","ZC_STATUS",SZC->ZC_STATUS) //Retorna o valor anterior
		M->ZC_STATUS := SZC->ZC_STATUS
	EndIf
EndIf 

Return lRet	
