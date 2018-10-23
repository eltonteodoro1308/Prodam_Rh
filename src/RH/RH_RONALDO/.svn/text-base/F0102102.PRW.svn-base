#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

Static 	__oModelCopy
Static oRHNModel
Static cEmpChg
Static aPerAtual


/*/ {Protheus.doc} F0102102()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       01/10/15
@version     P12.5
@Return      Controle de Planos Ativos - Ass. Medica
@Obs         Adaptação do Fonte GPEA001()
@menu        Controle de Planos Ativos - Ass. Medica
/*/

User Function F0102102()

Local oMBrowse
Local cFiltraRh

Private lSetCentury := __SetCentury( )

If ! lSetCentury
	__SetCentury( "on" )
EndIf

oMBrowse := FWMBrowse():New()

oMBrowse:SetAlias("SRA")
oMBrowse:SetDescription(OemToAnsi("Controle dos Planos Médico"))

GpLegMVC(@oMBrowse)

oMBrowse:ForceQuitButton()

cFiltraRh := CHKRH("F0102102","SRA","1")
oMBrowse:SetFilterDefault( cFiltraRh )

oMBrowse:DisableDetails()
oMBrowse:Activate()

If ! lSetCentury
	__SetCentury( "off" )
EndIf

Return

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE OemToAnsi('Pesquisar')  				ACTION "PESQBRW"         		OPERATION 1 ACCESS 0 DISABLE MENU 	//
ADD OPTION aRotina TITLE OemToAnsi('Visualizar')  				ACTION "VIEWDEF.F0102102" 		OPERATION 2 ACCESS 0 				//
ADD OPTION aRotina TITLE OemToAnsi('Planos Ativos') 		 	ACTION "VIEWDEF.F0102102" 		OPERATION 4 ACCESS 0				//
ADD OPTION aRotina TITLE OemToAnsi('Excluir'	)  				ACTION "VIEWDEF.F0102102" 		OPERATION 5 ACCESS 0			   	//
ADD OPTION aRotina TITLE OemToAnsi('Historico de Alteracoes')  	ACTION "VIEWDEF.GPEA002" 		OPERATION 2 ACCESS 0				//
ADD OPTION aRotina TITLE OemToAnsi('Consultar Calculo')  		ACTION "fViewCalc()" 			OPERATION 2 ACCESS 0				//
ADD OPTION aRotina TITLE OemToAnsi("Manut. Cálculo") 			ACTION "fManutCalc()"			OPERATION 4 ACCESS 0				//
ADD OPTION aRotina TITLE OemToAnsi('Transf. Lote')  			ACTION "fTransfLote()" 		    OPERATION 2 ACCESS 0				//
ADD OPTION aRotina TITLE OemToAnsi('Fechamento')  				ACTION "GPEM018(3)" 			OPERATION 2 ACCESS 0				//

Return aRotina

Static Function ModelDef()

Local oModel
Local oStructSRA
Local oStructRHK	// Titulares
Local oStructRHL	// Dependentes
Local oStructRHM	// Agregados

Local bActivate := { |oModel| f01021_Model(oModel) }

oModel:= MPFormModel():New("M0102102",,{ |oModel| Gp001PosValid(oModel) }, { |oModel| Gp001Commit(oModel) })
oModel:SetDescription( OemToAnsi("Controle dos Planos Médico") )

oStructSRA := FWFormStruct(1, "SRA",  { |cCampo| Gpa001SRAStru(cCampo) })
oModel:AddFields("M0102102_MSRA", NIL, oStructSRA)
oModel:GetModel("M0102102_MSRA"):SetDescription( OemToAnsi("Controle dos Planos Médico") )
oModel:GetModel("M0102102_MSRA"):SetOnlyQuery(.T.)
oModel:GetModel('M0102102_MSRA'):SetOnlyView(.T.)

oStructRHK := FWFormStruct(1, "RHK")
oStructRHK:SetProperty( "RHK_TPFORN", MODEL_FIELD_WHEN, { |oModel| f01021_NotEdit(oModel, "M0102102_MRHK") } )
oModel:AddGrid("M0102102_MRHK", "M0102102_MSRA", oStructRHK,{ |oModel,nLine,cAcao,cCampo| RHK_VlDel( oModel, nLine, cAcao, cCampo ) }, { |oModel| RHK_LinhaOK(oModel) },, { |oModel| RHK_TudoOK(oModel) } )

oModel:GetModel( "M0102102_MRHK" ):SetDescription( OemToAnsi("Planos Ativos do Titular") ) //
oModel:GetModel( "M0102102_MRHK" ):SetOptional( .T. )
oModel:SetRelation( "M0102102_MRHK", { { "RHK_FILIAL", 'xFilial("RHK",SRA->RA_FILIAL)' }, { "RHK_MAT", 'RA_MAT' }}, RHK->( IndexKey( 1 ) ) )

oStructRHL := FWFormStruct(1, "RHL")
oStructRHL:SetProperty( "RHL_CODIGO", MODEL_FIELD_WHEN, { |oModel| f01021_NotEdit(oModel, "M0102102_MRHL") } )
oModel:AddGrid("M0102102_MRHL", "M0102102_MRHK", oStructRHL,{ |oModel,nLine,cAcao,cCampo| RHL_VlDel( oModel, nLine, cAcao, cCampo ) }, { |oModel| RHL_LinhaOK(oModel) } )
oModel:GetModel( "M0102102_MRHL" ):SetDescription( OemToAnsi("Planos Ativos dos Dependentes") ) //
oModel:GetModel( "M0102102_MRHL" ):SetOptional( .T. )
oModel:GetModel( "M0102102_MRHL" ):SetUniqueLine( { 'RHL_CODIGO', 'RHL_TPPLAN', 'RHL_PLANO' } )
oModel:SetRelation( "M0102102_MRHL", { { "RHL_FILIAL", 'xFilial( "RHK" )' }, { "RHL_MAT", 'RHK_MAT' }, { "RHL_TPFORN", 'RHK_TPFORN' }, { "RHL_CODFOR", 'RHK_CODFOR' } }, RHL->( IndexKey( 1 ) ) )
oModel:SetPrimaryKey({"RHL_MAT", "RHL_CODIGO"})

oStructRHM := FWFormStruct(1, "RHM")
oStructRHM:SetProperty( "RHM_CODIGO", MODEL_FIELD_WHEN, { || .F. } )
oModel:AddGrid("M0102102_MRHM", "M0102102_MRHK", oStructRHM,{ |oModel,nLine,cAcao,cCampo| RHM_VlDel( oModel, nLine, cAcao, cCampo ) }, { |oModel| RHM_LinhaOK(oModel) })
oModel:GetModel( "M0102102_MRHM" ):SetDescription( OemToAnsi("Planos Ativos dos Agregados") ) //
oModel:GetModel( "M0102102_MRHM" ):SetOptional( .T. )
oModel:SetRelation( "M0102102_MRHM", { { "RHM_FILIAL", 'xFilial( "RHK" )' }, { "RHM_MAT", 'RHK_MAT' }, { "RHM_TPFORN", 'RHK_TPFORN' }, { "RHM_CODFOR", 'RHK_CODFOR' } }, RHM->( IndexKey( 1 ) ) )
oModel:SetPrimaryKey({"RHM_MAT", "RHM_CODIGO"})

oModel:SetActivate( bActivate )

Return( oModel )

Static Function ViewDef()
Local oView
Local oModel
Local oStructSRA
Local oStructRHK
Local oStructRHL
Local oStructRHM

// Vincular o View ao Model //
oModel := FWLoadModel("F0102102")

// Criacao da Interface //
oView := FWFormView():New()
oView:SetModel(oModel)

// Criacao do Cabecalho - SRA (Funcionario) //
oStructSRA := FWFormStruct(2, "SRA", { |cCampo| Gpa001SRAStru(cCampo) })
oStructSRA:SetNoFolder()
oView:AddField("F0102102_VSRA", oStructSRA, "M0102102_MSRA" )

// Criacao do Cabecalho - RHK (Planos Ativos do Titular) //
oStructRHK := FWFormStruct(2,"RHK")
oStructRHK:RemoveField("RHK_MAT")
oStructRHK:RemoveField("RHK_CDPSAG")
oView:AddGrid("F0102102_VRHK", oStructRHK, "M0102102_MRHK" )

// Criacao do Cabecalho - RHK (Planos Ativos dos Dependentes e Agregados) //
oStructRHL := FWFormStruct(2, "RHL")
oView:AddGrid("F0102102_VRHL", oStructRHL, "M0102102_MRHL" )
oStructRHL:RemoveField("RHL_MAT")
oStructRHL:RemoveField("RHL_TPFORN")
oStructRHL:RemoveField("RHL_CODFOR")

oStructRHM := FWFormStruct(2, "RHM")
oView:AddGrid("F0102102_VRHM", oStructRHM, "M0102102_MRHM" )
oView:AddIncrementField( "F0102102_VRHM", "RHM_CODIGO" )
oStructRHM:RemoveField( "RHM_MAT" )
oStructRHM:RemoveField( "RHM_TPFORN" )
oStructRHM:RemoveField( "RHM_CODFOR" )

//Verificação de visualização dos campos RHK_TPCALC, RHL_TPCALC e RHM_TPCALC

DbSelectArea("SLY")
SLY->(DbSetOrder(1))  //LY_FILIAL+LY_TIPO+LY_AGRUP+LY_ALIAS+LY_FILENT+LY_CHVENT+LY_CODIGO+DTOS(LY_DTINI)
DbSelectArea("SG0")
SG0->(DbSetOrder(2))  //G0_FILIAL+G0_STATUS+G0_CODIGO

If ((!(SLY->(MsSeek(xFilial("SLY")+"PS")))) .OR. fRetCriter()=="" .OR. ((!(SG0->(MsSeek(xFilial("SG0")+"1"))))))
	oStructRHK:RemoveField("RHK_TPCALC")
	oStructRHL:RemoveField("RHL_TPCALC")
	oStructRHM:RemoveField("RHM_TPCALC")
EndIf

// Desenho da Tela //
oView:CreateHorizontalBox("SRA_HEAD", 12)
oView:CreateHorizontalBox("RHK_PLFUNC", 25)
oView:CreateHorizontalBox("PLDEPAGR", 63)

oView:CreateVerticalBox( 'RHL_PLDEP', 50, 'PLDEPAGR' )
oView:CreateVerticalBox( 'RHM_PLAGR', 50, 'PLDEPAGR' )

oView:SetOwnerView( "F0102102_VSRA", "SRA_HEAD" )
oView:SetOwnerView( "F0102102_VRHK", "RHK_PLFUNC" )
oView:SetOwnerView( "F0102102_VRHL", "RHL_PLDEP" )
oView:SetOwnerView( "F0102102_VRHM", "RHM_PLAGR" )

oView:EnableTitleView( "F0102102_VRHK", OemToAnsi("Planos Ativos do Titular") )
oView:EnableTitleView( "F0102102_VRHL", OemToAnsi("Planos Ativos dos Dependentes") )
oView:EnableTitleView( "F0102102_VRHM", OemToAnsi("Planos Ativos dos Agregados") )
oView:SetCloseOnOk({ || .T. })

Return oView

Static Function f01021_Model(oModel)
Local nOperation	:= oModel:GetOperation()

aPerAtual := {}

__oModelCopy:= FWLoadModel("F0102102")
__oModelCopy:SetOperation(nOperation)
__oModelCopy:SetActivate({|| .T.})
__oModelCopy:Activate()

Return( .T. )

Static Function Gp001PosValid(oModel )

Local aAreaGPE 		:= GetArea()
Local aRHKFields
Local aRHLFields

Local cTpDIRF

Local lRet 		:= .T.
Local lRHKDelet := .F.
Local lResult 	:= .F.

Local nI
Local nP
Local nJ
Local nLinha		:= 1
Local nRHKNLines
Local nRHKCpyLines
Local nRHLLine
Local nRHLCpyLines
Local nRHMLine
Local nRHMCpyLines

Local oRHNStruct
Local oRHKStruct
Local oRHLStruct
Local oRHMStruct
Local oCpyRHKStru
Local oCpyRHLStru
Local oCpyRHMStru
Local oRHKStru
Local oRHLStru
Local oRHMStru
Local oMdlAtual

oMdlAtual := FWModelActive()

oRHNModel := NIL
oRHNModel := FWLoadModel("GPEA002")
oRHNModel:SetOperation(3)
oRHNModel:SetActivate({|| .T.})
oRHNModel:Activate()

FWModelActive( oMdlAtual )

oRHNStruct	:= oRHNModel:GetModel( "GPEA002_MRHN" )
oRHKStruct	:= oModel:GetModel( "M0102102_MRHK" )
oRHLStruct	:= oModel:GetModel( "M0102102_MRHL" )
oRHMStruct	:= oModel:GetModel( "M0102102_MRHM" )
oCpyRHKStru := __oModelCopy:GetModel( "M0102102_MRHK" )

nRHKNLines	:= oRHKStruct:Length()
nRHKCpyLines:= oCpyRHKStru:Length()
For nI := 1 To nRHKNLines
	oRHKStruct:GoLine( nI )

	lRHKDelet := .F.
	uTypeoper := ""
	If nI <= nRHKCpyLines
		oCpyRHKStru:GoLine( nI )
		If !oCpyRHKStru:IsInserted()

			oRHKStru 	:= oRHKStruct:GetStruct()
			aRHKFields 	:= oRHKStru:GetFields()
			If oRHKStruct:IsUpdated()
				For nP := 1 To Len(aRHKFields)
					cCampo := aRHKFields[nP, MODEL_FIELD_IDFIELD ]
					If oRHKStruct:GetValue( cCampo ) <> oCpyRHKStru:GetValue( cCampo )

						If cCampo == "RHK_CODFOR"
							cTpDIRF := "01"
						ElseIf cCampo == "RHK_PLANO" .and. Empty(cTpDIRF)
							cTpDIRF := "03"
						ElseIf cCampo == "RHK_TPPLAN" .and. Empty(cTpDIRF)
							cTpDIRF := "02"
						ElseIf (cCampo == "RHK_PERINI" .Or. cCampo == "RHK_PERFIM")  .and. Empty(cTpDIRF)
							cTpDIRF := "04"
						ElseIf Empty(cTpDIRF)
							cTpDIRF := "05"
						EndIf
						uTypeoper := "1"
					EndIf
				Next nP

			ElseIf oRHKStruct:IsDeleted() .Or. oModel:GetOperation() == 5
				lResult := 	Gp001ChkDl()
				If lResult
					cTpDIRF := "01"
					uTypeoper := "2"
					lRHKDelet := .T.
				Else
					Help( ,, '',, OemToAnsi( '' ), 1, 0 )
					RestARea(aAreaGPE)
					Return lResult
				EndIF
			EndIf
		EndIf

		If !Empty( uTypeoper )
			If nLinha > 1
				oRHNStruct:AddLine()
			EndIf
			nLinha := nLinha + 1
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_FILIAL"	, SRA->RA_FILIAL )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_MAT"		, SRA->RA_MAT )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_DATA"		, dDataBase )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_OPERAC"	, uTypeOper )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_ORIGEM"	, "1" )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPALT"	, cTpDIRF )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPFORN"	, oCpyRHKStru:GetValue( "RHK_TPFORN" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_CODFOR"	, oCpyRHKStru:GetValue( "RHK_CODFOR" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_NOME"		, SRA->RA_NOME )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPPLAN"	, oCpyRHKStru:GetValue( "RHK_TPPLAN" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PLANO"	, oCpyRHKStru:GetValue( "RHK_PLANO" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PD"		, oCpyRHKStru:GetValue( "RHK_PD" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PDDAGR"	, oCpyRHKStru:GetValue( "RHK_PDDAGR" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERINI"	, oCpyRHKStru:GetValue( "RHK_PERINI" ) )
			oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERFIM"	, oCpyRHKStru:GetValue( "RHK_PERFIM" ) )
		EndIf
	EndIf

	oCpyRHLStru := __oModelCopy:GetModel( "M0102102_MRHL" )
	nRHLLine 	:= oRHLStruct:Length()
	nRHLCpyLines:= oCpyRHLStru:Length()
	If cTpDIRF <> "01"
		cTpDIRF := ""
	EndIf
	For nJ := 1 To nRHLLine
		oRHLStruct:GoLine( nJ )

		uTypeoper := ""
		If nJ <= nRHLCpyLines
			oCpyRHLStru:GoLine( nJ )
			If !oCpyRHLStru:IsInserted()
				oRHLStru 	:= oRHLStruct:GetStruct()
				aRHLFields 	:= oRHLStru:GetFields()
				If oRHLStruct:IsUpdated()
					For nP := 1 To Len(aRHLFields)
						cCampo := aRHLFields[nP, MODEL_FIELD_IDFIELD ]
						If oRHLStruct:GetValue( cCampo ) <> oCpyRHLStru:GetValue( cCampo )
							If cCampo == "RHL_PLANO" .and. Empty(cTpDIRF)
								cTpDIRF := "03"
							ElseIf cCampo == "RHL_TPPLAN" .and. Empty(cTpDIRF)
								cTpDIRF := "02"
							ElseIf (cCampo == "RHL_PERINI" .Or. cCampo == "RHL_PERFIM")  .and. Empty(cTpDIRF)
								cTpDIRF := "04"
							ElseIf Empty(cTpDIRF)
								cTpDIRF := "05"
							EndIf
							uTypeoper := "1"
						EndIf
					Next nP
				ElseIf oRHLStruct:IsDeleted() .Or. lRHKDelet
					uTypeoper := "2"
				EndIf
			EndIf

			If !Empty( uTypeoper )
				If nLinha > 1
					oRHNStruct:AddLine()
				EndIf
				nLinha := nLinha + 1
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_FILIAL"	, SRA->RA_FILIAL )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_MAT"		, SRA->RA_MAT )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_DATA"		, dDataBase )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_OPERAC"	, uTypeOper )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_ORIGEM"	, "2" )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPALT"	, cTpDIRF )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_CODIGO"	, oCpyRHLStru:GetValue( "RHL_CODIGO" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_NOME"		, oCpyRHLStru:GetValue( "RHL_NOME" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPFORN"	, oCpyRHKStru:GetValue( "RHK_TPFORN" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_CODFOR"	, oCpyRHKStru:GetValue( "RHK_CODFOR" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPPLAN"	, oCpyRHLStru:GetValue( "RHL_TPPLAN" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PLANO"	, oCpyRHLStru:GetValue( "RHL_PLANO" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PD"    	, oCpyRHKStru:GetValue( "RHK_PD" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PDDAGR"	, oCpyRHKStru:GetValue( "RHK_PDDAGR" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERINI"	, oCpyRHLStru:GetValue( "RHL_PERINI" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERFIM"	, oCpyRHLStru:GetValue( "RHL_PERFIM" ) )

			EndIf
		EndIf
	Next nJ

	// Gravacao do historio dos Agregados //
	oCpyRHMStru := __oModelCopy:GetModel( "M0102102_MRHM" )
	nRHMLine 		:= oRHMStruct:Length()
	nRHMCpyLines	:= oCpyRHMStru:Length()
	If cTpDIRF <> "01"
		cTpDIRF := ""
	EndIf
	For nJ := 1 To nRHMLine

		oRHMStruct:GoLine( nJ )

		uTypeoper := ""
		If nJ <= nRHMCpyLines
			oCpyRHMStru:GoLine( nJ )
			If !oCpyRHMStru:IsInserted()
				oRHMStru := oRHMStruct:GetStruct()
				aRHMFields := oRHMStru:GetFields()
				If oRHMStruct:IsUpdated()
					For nP := 1 To Len(aRHMFields)
						cCampo := aRHMFields[nP, MODEL_FIELD_IDFIELD ]
						If oRHMStruct:GetValue( cCampo ) <> oCpyRHMStru:GetValue( cCampo )
							If cCampo == "RHM_PLANO" .and. Empty(cTpDIRF)
								cTpDIRF := "03"
							ElseIf cCampo == "RHM_TPPLAN" .and. Empty(cTpDIRF)
								cTpDIRF := "02"
							ElseIf (cCampo == "RHM_PERINI" .Or. cCampo == "RHM_PERFIM")  .and. Empty(cTpDIRF)
								cTpDIRF := "04"
							ElseIf Empty(cTpDIRF)
								cTpDIRF := "05"
							EndIf
							uTypeoper := "1"
						EndIf
					Next nP
				ElseIf oRHMStruct:IsDeleted() .Or. lRHKDelet
					uTypeoper := "2"
				EndIf
			EndIf

			If !Empty( uTypeoper )
				If nLinha > 1
					oRHNStruct:AddLine()
				EndIf
				nLinha := nLinha + 1
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_FILIAL"	, SRA->RA_FILIAL )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_MAT"		, SRA->RA_MAT )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_DATA"		, dDataBase )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_OPERAC"	, uTypeOper )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_ORIGEM"	, "3" )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPALT"		, cTpDIRF )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPFORN"	, oCpyRHKStru:GetValue( "RHK_TPFORN" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_CODFOR"	, oCpyRHKStru:GetValue( "RHK_CODFOR" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_CODIGO"	, oCpyRHMStru:GetValue( "RHM_CODIGO" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_NOME"		, oCpyRHMStru:GetValue( "RHM_NOME" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_TPPLAN"	, oCpyRHMStru:GetValue( "RHM_TPPLAN" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PLANO"	, oCpyRHMStru:GetValue( "RHM_PLANO" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PD"		, oCpyRHKStru:GetValue( "RHK_PD" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PDDAGR"	, oCpyRHKStru:GetValue( "RHK_PDDAGR" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERINI"	, oCpyRHMStru:GetValue( "RHM_PERINI" ) )
				oRHNModel:LoadValue( "GPEA002_MRHN", "RHN_PERFIM"	, oCpyRHMStru:GetValue( "RHM_PERFIM" ) )
			EndIf
		EndIf
	Next nJ
Next nI

RestARea(aAreaGPE)

Return( lRet )

Static Function Gp001Commit(oModel)

FwFormCommit( oModel )
FwFormCommit( oRHNModel )

__oModelCopy:DeActivate()

f01021_Model(oModel)

Return .T.

Static Function Gpa001SRAStru( cCampo )
Local lRet := .F.

cCampo := AllTrim( cCampo )
If cCampo $ 'RA_MAT*RA_NOME*RA_ADMISSA'
	lRet := .T.
EndIf

Return lRet

Static Function RHK_LinhaOK(oRHKStruct)

Local aLog		:= { {}, {} }

Local cLog
Local cPerIni
Local cPerFim
Local cTpForn
Local cCodFor
Local cCodPlano

Local lRet 		:= .T.

Local nI
Local nLines

Local oModel		:= FWModelActive()
Local oRHLStruct	:= oModel:GetModel( "M0102102_MRHL" )
Local oRHMStruct	:= oModel:GetModel( "M0102102_MRHM" )
Local nLinAtual		:= 0

Local cMesAntes		:= ""

cTpForn 	:= oRHKStruct:GetValue( "RHK_TPFORN" )
cCodFor		:= oRHKStruct:GetValue( "RHK_CODFOR" )
cTpPlano	:= oRHKStruct:GetValue( "RHK_TPPLAN" )
cCodPlano	:= oRHKStruct:GetValue( "RHK_PLANO"	 )

lRet := f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano)

If ! lRet
	Return( lRet )
EndIf

cVerbaTit	:= oRHKStruct:GetValue( "RHK_PD" )
cVerbaDeAg	:= oRHKStruct:GetValue( "RHK_PDDAGR" )

If cVerbaTit == cVerbaDeAg
	Help( , , 'HELP', , OemToAnsi( "As Verbas do Titular e dos Dep./Agreg. não podem ser iguais!" ), 1, 0 )		//
	lRet := .F.
EndIf

cPerIni		:= oRHKStruct:GetValue( "RHK_PERINI" )
cPerFim		:= oRHKStruct:GetValue( "RHK_PERFIM" )
/*
If ! Empty( cPerFim )
	If Type("aPerAtual") == "U" .or. Empty(aPerAtual) .or. !(aPerAtual[1,8] == SRA->RA_PROCES)
		fGetPerAtual( @aPerAtual, xFilial("RCH"), SRA->RA_PROCES, If (SRA->RA_CATFUNC $ "P*A", fGetCalcRot("9"),fGetRotOrdinar()) )

		If Empty(aPerAtual)
			Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
			Return(.F.)
		EndIf
		cMesAntes := AnoMes(aPerAtual[1,6]-1)
	EndIf
	If Ctod( "01/"+Substr(cPerFim,1,2)+"/"+Substr(cPerFim,3,4) ) < Ctod( "01/"+Substr(cPerIni,1,2)+"/"+Substr(cPerIni,3,4) )
		Help(,,'HELP',,OemToAnsi('Periodo Final menor que o Periodo Inicial!'),1,0)				//
		lRet := .F.
	ElseIf Substr( cPerFim, 3, 4 ) + Substr( cPerFim, 1, 2 ) <= cMesAntes
		Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
		lRet := .F.
	EndIf
EndIf
*/
If Substr(cPerIni,3,4) + Substr(cPerIni,1,2) < Substr(Dtos(SRA->RA_ADMISSA),1,6)
	Help(,,'HELP',,OemToAnsi('Periodo Inicial menor que o Mês da Admissão do Funcionário!'),1,0)	//
	lRet := .F.
EndIf

If lRet
	cLog		:= ""
	nLinAtual	:= oRHKStruct:GetLine( )
	nLines		:= oRHKStruct:Length()
	For nI := 1 To nLines
		oRHKStruct:GoLine( nI )
		If 	oRHKStruct:GetValue( "RHK_TPFORN" ) == cTpForn .and. oRHKStruct:GetValue( "RHK_CODFOR" ) == cCodFor .and. ;
			oRHKStruct:GetValue( "RHK_TPPLAN" ) == cTpPlano  .and. oRHKStruct:GetValue( "RHK_PLANO" ) == cCodPlano .and. ;
			oRHKStruct:GetLine( ) <> nLinAtual	.and. ! oRHKStruct:IsDeleted()
			Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
			lRet := .F.
			Exit
		EndIf
	Next nI
	oRHKStruct:GoLine( nLinAtual )
EndIf

If lRet
	cLog := ""
	nLinAtual	:= oRHLStruct:GetLine( )
	nLines		:= oRHLStruct:Length()
	For nI := 1 To nLines
		oRHLStruct:GoLine( nI )

		If !Empty(oRHLStruct:GetValue( "RHL_CODIGO" ))
			cTpPlano	:= oRHLStruct:GetValue( "RHL_TPPLAN" )
			cCodPlano	:= oRHLStruct:GetValue( "RHL_PLANO" )

			If !f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano, .F.)
				aAdd( aLog[1], nI )
			EndIf
		EndIf
	Next nI
	oRHLStruct:GoLine( nLinAtual )

	nLinAtual	:= oRHMStruct:GetLine( )
	nLines		:= oRHMStruct:Length()
	For nI := 1 To nLines
		oRHMStruct:GoLine( nI )
		If !Empty(oRHMStruct:GetValue( "RHM_CODIGO" )) .And.!Empty(oRHMStruct:GetValue( "RHM_NOME" ))
			cTpPlano	:= oRHMStruct:GetValue( "RHM_TPPLAN" )
			cCodPlano	:= oRHMStruct:GetValue( "RHM_PLANO" )

			If !f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano, .F. )
				aAdd( aLog[2], nI )
			EndIf
		EndIf
	Next nI
	oRHMStruct:GoLine( nLinAtual )

	If Len( aLog[1] ) > 0 .Or. Len( aLog[2] ) > 0
		If Len( aLog[1] ) > 0
			cLog := OemToAnsi( 'Inconsistências nas Informações do Plano dos Dependentes: ' ) + CRLF //
			For nI := 1 To Len( aLog[1] )
				cLog += OemToAnsi(  "Linha: " ) + Str( aLog[1, nI], 3, 0 ) + CRLF  //
			Next
		EndIf

		If Len( aLog[2] ) > 0
			If !Empty(cLog)
				cLog += CRLF
			EndIf
			cLog += OemToAnsi(  'Inconsistências nas Informações do Plano dos Agregados: ' ) + CRLF //
			For nI := 1 To Len( aLog[2] )
				cLog += OemToAnsi( "Linha: " ) + Str( aLog[2, nI], 3, 0 ) + CRLF  //
			Next
		EndIf

		AutoGrLog( cLog )

		MostraErro()

		lRet := .F.

	EndIf
EndIf

If !IsInCallStack("GPEM027") .AND. lRet
	lRet := f01021_Calc("RHK")
EndIf

Return( lRet )

Static Function RHK_TudoOK(oModel)

Local aTpPD	:= {}

Local cPDAnt:= ""
Local cTipo	:= ""

Local lRet 	:= .T.

Local nI
Local nLines := oModel:Length()

aAdd( aTpPD, { "1", "" } ) // Assistencia Medica
aAdd( aTpPD, { "2", "" } ) // Assistencia Medica

For nI := 1 To nLines
	oModel:GoLine( nI )

	If !oModel:IsDeleted()
		cPDAnt 	:= oModel:GetValue( "RHK_PDDAGR" )
		If !Empty(cPDAnt)
			cTipo	:= oModel:GetValue( "RHK_TPFORN" )
			nPos := aScan( aTpPD, { |x| x[1] == cTipo .and. x[2] == cPDAnt } )
			If cTipo == "1"
				If nPos == 0
					aAdd( aTpPD, { "1", cPDAnt } ) // Assistencia Medica
				EndIf
				cTipo := "2"
			Else
				If nPos == 0
					aAdd( aTpPD, { "2", cPDAnt } ) // Assistencia Medica
				EndIf
				cTipo := "1"
			EndIf

			nPos := aScan( aTpPD, { |x| x[1] == cTipo .and. x[2] == cPDAnt } )
			If nPos > 0
				Help(,,'HELP',,OemToAnsi('As verbas entre Planos de Assist. Medica e Odontologica nao podem ser repetidas!'),1,0)	//
				lRet := .F.
			EndIf
		EndIf
	EndIf

Next nI

Return( lRet )

Static Function RHL_LinhaOK(oModel)
Local cPerIni
Local cPerFim
Local cTitPerIni
Local cTitPerFim
Local cTpForn
Local cCodFor
Local cCodPlano
Local cPDDAGR

Local lRet := .T.

Local oModelRHK
Local oStructRHK

Local cMesAntes		:= ""

// Validacao do Plano de Saude //
oModelRHK 	:= FWModelActive()
oStructRHK	:= oModelRHK:GetModel( "M0102102_MRHK" )
cTpForn		:= oStructRHK:GetValue("RHK_TPFORN")
cCodFor		:= oStructRHK:GetValue("RHK_CODFOR")
cTitPerIni	:= oStructRHK:GetValue("RHK_PERINI")
cTitPerFim	:= oStructRHK:GetValue("RHK_PERFIM")
cPDDAGR		:= oStructRHK:GetValue("RHK_PDDAGR")

cTpPlano	:= oModel:GetValue( "RHL_TPPLAN" )
cCodPlano	:= oModel:GetValue( "RHL_PLANO" )

lRet := f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano)

// Validacao dos Periodos //
cPerIni := oModel:GetValue( "RHL_PERINI" )
cPerFim := oModel:GetValue( "RHL_PERFIM" )
/*
If ! Empty( cPerFim )
	If Type("aPerAtual") == "U" .or. Empty(aPerAtual) .or. !(aPerAtual[1,8] == SRA->RA_PROCES)
		fGetPerAtual( @aPerAtual, xFilial("RCH"), SRA->RA_PROCES, If (SRA->RA_CATFUNC $ "P*A", fGetCalcRot("9"),fGetRotOrdinar()) )

		If Empty(aPerAtual)
			Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
			Return(.F.)
		EndIf
		cMesAntes := AnoMes(aPerAtual[1,6]-1)
	EndIf
	If Ctod( "01/"+Substr(cPerFim,1,2)+"/"+Substr(cPerFim,3,4) ) < Ctod( "01/"+Substr(cPerIni,1,2)+"/"+Substr(cPerIni,3,4) )
		Help(,,'HELP',,OemToAnsi('Periodo Final menor que o Periodo Inicial!'),1,0)				//'Periodo Final menor que o Periodo Inicial!'
		lRet := .F.
	ElseIf Substr( cPerFim, 3, 4 ) + Substr( cPerFim, 1, 2 ) <= cMesAntes
		Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
		lRet := .F.
	EndIf
EndIf
*/
// Validacao do Periodo do Dependente em relacao ao Periodo do Titular
If lRet .and. Ctod( "01/"+Substr(cPerIni,1,2)+"/"+Substr(cPerIni,3,4) ) < Ctod( "01/"+Substr(cTitPerIni,1,2)+"/"+Substr(cTitPerIni,3,4) )
	Help(,,'HELP',,OemToAnsi('Periodo Inicial deve ser maior ou igual ao Periodo Inicial do Titular'),1,0)	//
	lRet := .F.
EndIf

If lRet .and. !Empty( cTitPerFim )
	If (Ctod( "01/"+Substr(cPerFim,1,2)+"/"+Substr(cPerFim,3,4) ) > Ctod( "01/"+Substr(cTitPerFim,1,2)+"/"+Substr(cTitPerFim,3,4) )) .Or. Empty( cPerFim )
		Help(,,'HELP',,OemToAnsi('Periodo Final deve ser menor ou igual ao Periodo Final do Titular'),1,0)	//
		lRet := .F.
	EndIf
EndIf

If lRet .and. Empty(cPDDAGR)
	Help(,,'HELP',,OemToAnsi('Existem lançamentos para Agregados/Dependentes. Obrigatorio o lançamento da Verba!'),1,0)	//
	lRet := .F.
EndIf

If !IsInCallStack("GPEM027") .AND. lRet
	lRet := f01021_Calc("RHL")
EndIf

Return( lRet )

Static Function RHM_LinhaOK(oModel)
Local cPerIni
Local cPerFim
Local cTitPerIni
Local cTitPerFim
Local cTpForn
Local cCodFor
Local cCodPlano
Local cPDDAGR
Local dDtNasc
Local cCPF

Local nAge

Local lRet := .T.

Local oModelRHK
Local oStructRHK

Local cMesAntes		:= ""

// Validacao do Plano de Saude //
oModelRHK 	:= FWModelActive()
oStructRHK	:= oModelRHK:GetModel( "M0102102_MRHK" )
cTpForn		:= oStructRHK:GetValue("RHK_TPFORN")
cCodFor		:= oStructRHK:GetValue("RHK_CODFOR")
cTitPerIni	:= oStructRHK:GetValue("RHK_PERINI")
cTitPerFim	:= oStructRHK:GetValue("RHK_PERFIM")
cPDDAGR		:= oStructRHK:GetValue("RHK_PDDAGR")

cTpPlano	:= oModel:GetValue( "RHM_TPPLAN" )
cCodPlano	:= oModel:GetValue( "RHM_PLANO" )

lRet := f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano)

// Validacao dos Periodos //
cPerIni := oModel:GetValue( "RHM_PERINI" )
cPerFim := oModel:GetValue( "RHM_PERFIM" )
/*
If ! Empty( cPerFim )
	If Type("aPerAtual") == "U" .or. Empty(aPerAtual) .or. !(aPerAtual[1,8] == SRA->RA_PROCES)
		fGetPerAtual( @aPerAtual, xFilial("RCH"), SRA->RA_PROCES, If (SRA->RA_CATFUNC $ "P*A", fGetCalcRot("9"),fGetRotOrdinar()) )

		If Empty(aPerAtual)
			Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
			Return(.F.)
		EndIf
		cMesAntes := AnoMes(aPerAtual[1,6]-1)
	EndIf
	If Ctod( "01/"+Substr(cPerFim,1,2)+"/"+Substr(cPerFim,3,4) ) < Ctod( "01/"+Substr(cPerIni,1,2)+"/"+Substr(cPerIni,3,4) )
		Help(,,'HELP',,OemToAnsi('Periodo Final menor que o Periodo Inicial!'),1,0)				//'Periodo Final menor que o Periodo Inicial!'
		lRet := .F.
	ElseIf Substr( cPerFim, 3, 4 ) + Substr( cPerFim, 1, 2 ) <= cMesAntes
		Help( , , 'HELP', , OemToAnsi( 'Periodo Final deve ser Igual ou Maior ao Mês do Periodo Atual.' + CRLF + 'Caso queira reativar o plano, retire o Período Final e altere os dados se for necessário.' + CRLF+CRLF + 'Novos registros devem ser informados apenas em caso de novo Fornecedor de Plano de saúde.'  ), 1, 0 )	// '" ### " "
		lRet := .F.
	EndIf
EndIf
*/
// Validacao do Periodo do Dependente em relacao ao Periodo do Titular
If lRet .and. Ctod( "01/"+Substr(cPerIni,1,2)+"/"+Substr(cPerIni,3,4) ) < Ctod( "01/"+Substr(cTitPerIni,1,2)+"/"+Substr(cTitPerIni,3,4) )
	Help(,,'HELP',,OemToAnsi('Periodo Inicial deve ser maior ou igual ao Periodo Inicial do Titular'),1,0)	//
	lRet := .F.
EndIf

If lRet .and. !Empty( cTitPerFim )
	If (Ctod( "01/"+Substr(cPerFim,1,2)+"/"+Substr(cPerFim,3,4) ) > Ctod( "01/"+Substr(cTitPerFim,1,2)+"/"+Substr(cTitPerFim,3,4) )) .Or. Empty( cPerFim )
		Help(,,'HELP',,OemToAnsi('Periodo Final deve ser menor ou igual ao Periodo Final do Titular'),1,0)	//
		lRet := .F.
	EndIf
EndIf

If lRet .and. Empty(cPDDAGR)
	Help(,,'HELP',,OemToAnsi('Existem lançamentos para Agregados/Dependentes. Obrigatorio o lançamento da Verba!'),1,0)	//
	lRet := .F.
EndIf

// Validar idade do Agregado para CPF
dDtNasc		:= oModel:GetValue("RHM_DTNASC")
cCPF		:= oModel:GetValue("RHM_CPF")

If lRet .and. Empty( cCPF )
	nAge := DateDiffYear( dDataBase , dDtNasc )
	If nAge > 18
		Help(,,'HELP',,OemToAnsi("É necessario informar o CPF para maiores de 18 anos para Planos de Saúde."),1,0)	//
	EndIf
EndIf

If !IsInCallStack("GPEM027") .AND. lRet
	lRet := f01021_Calc("RHM")
EndIf

Return( lRet )
/*/ {Protheus.doc} F0102103()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       01/10/15
@version     P12.5
@Return      Controle de Planos Ativos - Ass. Medica
@Obs         Adaptação do Fonte GPEA001()
/*/
User Function f0102103()

Local lRet := .F.

Local oModel

If IsInCallStack('U_F0102102')
	DbSelectArea( "SRB" )
	SRB->(DbSetOrder( 1 ))
	SRB->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
	While !Eof() .and. (SRB->RB_FILIAL + SRB->RB_MAT == SRA->RA_FILIAL + SRA->RA_MAT)
		If SRB->RB_COD == M->RHL_CODIGO
			lRet := .T.
			Exit
		EndIf
		SRB->(DbSkip())
	EndDo

	If Eof() .and. !lRet
		Help(,,'HELP',,OemToAnsi("Sequencia do Beneficiario nao cadastrado!"),1,0)	//
	Else
		oModel 		:= FWModelActive()

		oModel:LoadValue("M0102102_MRHL", "RHL_NOME", SRB->RB_NOME)
	EndIf

	Return( lRet )
else
	return fVldSRB()
EndIf

Return
/*/ {Protheus.doc} f0102104()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       01/10/15
@version     P12.5
@Return      Controle de Planos Ativos - Ass. Medica
@param       cCodSeq, caracter, código da sequencia
@Obs         Adaptação do Fonte GPEA001()
/*/
User function f0102104(cCodSeq)

Local cRet
Local lRet 			:= .F.
Local oModel 		:= FWModelActive()
Local oStructRHL
Local nRegRHL

DEFAULT cCodSeq := ""

If IsInCallStack('U_F0102102')
	oStructRHL	:= oModel:GetModel( "M0102102_MRHL" )
	nRegRHL		:= oStructRHL:Length()
	If nRegRHL == 0

		DbSelectArea( "SRB" )
		SRB->(DbSetOrder( 1 ))
		SRB->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
		While !Eof() .and. (SRB->RB_FILIAL + SRB->RB_MAT == SRA->RA_FILIAL + SRA->RA_MAT)
			If SRB->RB_COD == cCodSeq
				lRet := .T.
				Exit
			EndIf
			SRB->(DbSkip()  )
		EndDo
		If Eof() .Or. !lRet
			cRet := ""
		Else
			cRet := SRB->RB_NOME
		EndIf
	Else
		cRet := ""
	EndIf

	Return( cRet )
else
	return fInitSRB(cCodSeq)
EndIf

Return
/*/ {Protheus.doc} F0102105()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       01/10/15
@version     P12.5
@Return      Controle de Planos Ativos - Ass. Medica
@Obs         Adaptação do Fonte GPEA001()
/*/
user Function f0102105()

Local cVar := Alltrim(ReadVar())
Local cTpForn
Local cCodFor
Local cTpPlano
Local cCodPlano

Local lRet := .T.

Local oModel
Local oStructRHK
Local oStructRHN

If IsInCallStack('U_F0102102')
	oModel 		:= FWModelActive()

	If cVar <> "M->RHN_PLANO"
		oStructRHK	:= oModel:GetModel( "M0102102_MRHK" )
		cTpForn		:= oStructRHK:GetValue("RHK_TPFORN")
		cCodFor		:= oStructRHK:GetValue("RHK_CODFOR")
	Else
		oStructRHN	:= oModel:GetModel( "M0102102_MRHN" )
		cTpForn		:= oStructRHN:GetValue("RHN_TPFORN")
		cCodFor		:= oStructRHN:GetValue("RHN_CODFOR")
	EndIf

	If cVar == "M->RHK_PLANO"
		cTpPlano := oStructRHK:GetValue("RHK_TPPLAN")
		cCodPlano := oStructRHK:GetValue("RHK_PLANO")
	ElseIf cVar == "M->RHL_PLANO"
		oStructRHL	:= oModel:GetModel( "M0102102_MRHL" )
		cTpPlano := oStructRHL:GetValue("RHL_TPPLAN")
		cCodPlano := oStructRHL:GetValue("RHL_PLANO")
	ElseIf cVar == "M->RHM_PLANO"
		oStructRHM	:= oModel:GetModel( "M0102102_MRHM" )
		cTpPlano := oStructRHM:GetValue("RHM_TPPLAN")
		cCodPlano := oStructRHM:GetValue("RHM_PLANO")
	ElseIf cVar == "M->RHN_PLANO"
		cTpPlano := oStructRHN:GetValue("RHN_TPPLAN")
		cCodPlano := oStructRHN:GetValue("RHN_PLANO")
	EndIf

	lRet := f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano)

	Return( lRet )

else
	return FVLDPLANO()
EndIf

return

Static Function f01021_FVAL(cTpForn, cCodFor, cTpPlano, cCodPlano, lHelp)
Local cCodTab := ""

Local lRet 	  := .T.

Local nColFor := 0
Local nPosTab
Local lChange := .F.

DEFAULT lHelp	:= .T.

If Type("cEmpChg") == "U"
	cEmpChg := cEmpAnt
ElseIf ( cEmpChg != cEmpAnt )
	lChange := lChange
EndIf

If cTpForn == "1"
	If cTpPlano == "1"
		cCodTab := "U053"
		nColFor := 16
	ElseIf cTpPlano == "2"
		cCodTab := "S009"
		nColFor := 13
	ElseIf cTpPlano == "3"
		cCodTab := "S028"
		nColFor := 12
	ElseIf cTpPlano == "4"
		cCodTab := "S029"
		nColFor := 15
	ElseIf cTpPlano == "5"
		cCodTab := "S059"
		nColFor := 14
	EndIf
ElseIf cTpForn == "2"
	If cTpPlano == "1"
		nColFor := 13
		cCodTab := "S013"
	ElseIf cTpPlano == "2"
		cCodTab := "S014"
		nColFor := 13
	ElseIf cTpPlano == "3"
		cCodTab := "S030"
		nColFor := 12
	ElseIf cTpPlano == "4"
		cCodTab := "S031"
		nColFor := 15
	ElseIf cTpPlano == "5"
		cCodTab := "S060"
		nColFor := 14
	EndIf
EndIf

nPosTab := fPosTab( cCodTab,cCodFor,"=",nColFor,cCodPlano,"=",4,,,,lChange)

If nPosTab <= 0
	If lHelp
		Help(,,'HELP',,OemToAnsi('Codigo do Plano nao cadastrado!'),1,0)	//
	EndIf
	lRet := .F.
EndIf

Return( lRet )

/*Function fViewCalc()                       //jackson

Private cCompFil := ""

If Pergunte("GPA001",.T.)

cCompFil := Substr(MV_PAR01,3,4) + Substr(MV_PAR01,1,2)

FWExecView(OemToAnsi(STR0021), "GPEM008" )

EndIf

Return  */

/*Function fValFor(nItem) //jackson
Local cCodTab

Local nPosTab

Local lRet

If MV_PAR09 == 1
cCodTab := "S016"
Else
cCodTab := "S017"
EndIf

nPosTab := fPosTab( cCodTab, If(nItem==1, MV_PAR10, MV_PAR11),"=",4)

If nPosTab <= 0
Help(,,'HELP',,OemToAnsi(STR0045),1,0)	//"Fornecedor não cadastrado!"
lRet := .F.
EndIf

If lRet
If MV_PAR10 == MV_PAR11
Help(,,'HELP',,OemToAnsi(STR0043),1,0)	//"Codigo de Fornecedor De/Para devem ser diferentes!"
lRet := .F.
EndIf
EndIf

Return( lRet ) */

/*Function GP001_MEDODO() //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S016"
Else
cCons := "S017"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )   */

/*
Function GP001_FXSAL() //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S008"
Else
cCons := "S013"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )   */

/*

Function GP001_FXETA()       //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S009"
Else
cCons := "S014"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )   */

/*
Function GP001_VLRFX()      //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S028"
Else
cCons := "S030"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )   */

/*
Function GP001_PESAL() //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S029"
Else
cCons := "S031"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )   */

/*
Function GP001_SALETA()         //jackson
Local xRet
Local cCons := ""
Local cCpoRet

If MV_PAR09 == 1
cCons := "S059"
Else
cCons := "S060"
EndIf

cCpoRet := "CODIGO"
xRet := Gp310SXB(cCons, cCpoRet )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
VAR_IXB := &__READVAR
Endif

If ValType(xRet) <> "L"
xRet := .F.
EndIf

Return( xRet )  */

Static Function RHK_VlDel( oModelGrid, nLinha, cAcao, cCampo )
Local lRet       := .T.
Local oModel     := oModelGrid:GetModel()

// Se o dependente possuir calculo nao pode deletar
If cAcao == 'DELETE' .And. Gp001Calc(1, oModel, nLinha, cCampo) == .T.
	lRet := .F.
	Help( ,, "Atencao",, OemToAnsi( "Há valores calculados para o titular e por isso não é permitido excluÍ-lo do plano ativo. Aconselhamos o preenchimento do campo (Per. Final) nos planos activos ao invés da eliminação do plano." ), 1, 0 )	// ##
EndIf
Return lRet

Static Function RHL_VlDel( oModelGrid, nLinha, cAcao, cCampo )
Local lRet       := .T.
Local oModel     := oModelGrid:GetModel()

// Se o dependente possuir calculo nao pode deletar
If cAcao == 'DELETE' .And. Gp001Calc(2, oModel, nLinha, cCampo) == .T.
	lRet := .F.
	Help( ,, "Atencao",, OemToAnsi( "Há valores calculados para o dependente e por isso não é permitido excluÍ-lo do plano ativo. Aconselhamos o preenchimento do campo (Per. Final) nos planos activos ao invés da eliminação do plano." ), 1, 0 )	// ##
EndIf
Return lRet

Static Function RHM_VlDel( oModelGrid, nLinha, cAcao, cCampo )
Local lRet       := .T.
Local oModel     := oModelGrid:GetModel()

// Se o dependente possuir calculo nao pode deletar
If cAcao == 'DELETE' .And. Gp001Calc(3, oModel, nLinha, cCampo) == .T.
	lRet := .F.
	Help( ,, "Atencao",, OemToAnsi( "Há valores calculados para o agregado e por isso não é permitido excluÍ-lo do plano ativo. aconselhamos o preenchimento do campo (Per. Final) nos planos activos ao invés da eliminação do plano." ), 1, 0 )	//"Atencao" ##
EndIf
Return lRet

Static Function Gp001Calc( nTipo, oModelGrid, nLinha, cCampo)
Local lRet       := .F.
Local cPesqFil   := ""
Local cPesqMat   := ""
Local cPesqOri   := ""
Local cPesqCod   := ""
Local cPesqTpF 	 := ""
Local cPesqCodF	 := ""
Local cPesqTpP	 := ""
Local cPesqCodP	 := ""
Local cPesqDe    := ""
Local cPesqAte   := ""
Local cCposQuery := ""
Local cAliasRHR  := "RHR"
Local aArea		 := RHR->(GetArea())

Local oModel
Local oStructRHK
Local oStructRHL
Local oStructRHM

oModel 		:= FWModelActive()
oStructRHK	:= oModel:GetModel( "M0102102_MRHK" )
oStructRHL	:= oModel:GetModel( "M0102102_MRHL" )
oStructRHM	:= oModel:GetModel( "M0102102_MRHM" )

cPesqFil  := SRA->RA_FILIAL
cPesqMat  := SRA->RA_MAT
cPesqTpF  := oStructRHK:GetValue( "RHK_TPFORN" )
cPesqCodF := oStructRHK:GetValue( "RHK_CODFOR" )

If nTipo == 1 //titular
	cPesqOri   := "1"
	cPesqCod   := "  "
	cPesqTpP   := oStructRHK:GetValue( "RHK_TPPLAN" )
	cPesqCodP  := oStructRHK:GetValue( "RHK_PLANO"	 )
	cPesqDe    := oStructRHK:GetValue( "RHK_PERINI" )
	cPesqAte   := oStructRHK:GetValue( "RHK_PERFIM" )
ElseIf nTipo == 2 //dependente
	cPesqOri   := "2"
	cPesqCod   := oStructRHL:GetValue( "RHL_CODIGO" )
	cPesqTpP   := oStructRHL:GetValue( "RHL_TPPLAN" )
	cPesqCodP  := oStructRHL:GetValue( "RHL_PLANO"	 )
	cPesqDe    := oStructRHL:GetValue( "RHL_PERINI" )
	cPesqAte   := oStructRHL:GetValue( "RHL_PERFIM" )
Else //agregado
	cPesqOri   := "3"
	cPesqCod   := oStructRHM:GetValue( "RHM_CODIGO" )
	cPesqTpP   := oStructRHM:GetValue( "RHM_TPPLAN" )
	cPesqCodP  := oStructRHM:GetValue( "RHM_PLANO"	 )
	cPesqDe    := oStructRHM:GetValue( "RHM_PERINI" )
	cPesqAte   := oStructRHM:GetValue( "RHM_PERFIM" )
EndIf

cPesqDe := Substr(cPesqDe,3,4)+Substr(cPesqDe,1,2)

If Empty(cPesqAte)
	cPesqAte := 999999
Else
	cPesqAte := Substr(cPesqAte,3,4)+Substr(cPesqAte,1,2)
EndIf

If !ExeInAs400()
	If ( Select( cAliasRHR ) > 0 )
		( cAliasRHR )->( dbCloseArea() )
	EndIf
	cCposQuery 	:= "%RHR.RHR_FILIAL, RHR.RHR_MAT, RHR_CODIGO, RHR_TPPLAN, RHR_TPFORN, RHR_CODFOR, RHR_PLANO, RHR_COMPPG%"

	BeginSql alias cAliasRHR
		SELECT %exp:cCposQuery%
		FROM %table:RHR% RHR
		WHERE  RHR.RHR_FILIAL = %exp:cPesqFil%
		AND RHR.RHR_ORIGEM = %exp:cPesqOri%
		AND RHR.RHR_MAT = %exp:cPesqMat%
		AND RHR.RHR_CODIGO = %exp:cPesqCod%
		AND RHR.RHR_TPFORN = %exp:cPesqTpF%
		AND RHR.RHR_CODFOR = %exp:cPesqCodF%
		AND RHR.RHR_TPPLAN = %exp:cPesqTpP%
		AND RHR.RHR_PLANO = %exp:cPesqCodP%
		AND RHR.RHR_COMPPG BETWEEN %exp:cPesqDe% AND %exp:cPesqAte%
		AND RHR.%notDel%
	EndSql
EndIf

If !(cAliasRHR)->( Eof()	 )
	lRet := .T.
EndIf

( cAliasRHR )->( dbCloseArea() )

RHR->(RestArea(aArea))

Return lRet

/*
Function GP001Fech()

Gpem018(3) //Fechamento do plano de saude

Return Nil  */

Static Function f01021_Calc(cTab)

Local lRet := .T.
Local oModel := FwModelActive()
Local oStructSRA := oModel:GetModel("M0102102_MSRA")
Local cRA_MAT := oStructSRA:GetValue("RA_MAT")

Local oStructRHK := oModel:GetModel("M0102102_MRHK")
Local cM_TPCALCK := oStructRHK:GetValue("RHK_TPCALC")
Local cM_TPFORN := oStructRHK:GetValue("RHK_TPFORN")
Local cM_CODFOR := oStructRHK:GetValue("RHK_CODFOR")
Local cM_TPPLAN := oStructRHK:GetValue("RHK_TPPLAN")
Local cM_PLANO := oStructRHK:GetValue("RHK_PLANO")
Local cM_PD := oStructRHK:GetValue("RHK_PD")
Local cM_PDDAGR := oStructRHK:GetValue("RHK_PDDAGR")
Local cM_PERINI := oStructRHK:GetValue("RHK_PERINI")
Local cM_PERFIM := oStructRHK:GetValue("RHK_PERFIM")

Local oStructRHL := oModel:GetModel("M0102102_MRHL")
Local cM_TPCALCL := oStructRHL:GetValue("RHL_TPCALC")
Local cM_CODL := oStructRHL:GetValue("RHL_CODIGO")
Local cM_PERINIL := oStructRHL:GetValue("RHL_PERINI")
Local cM_PERFIML := oStructRHL:GetValue("RHL_PERFIM")

Local oStructRHM := oModel:GetModel("M0102102_MRHM")
Local cM_TPCALCM := oStructRHM:GetValue("RHM_TPCALC")
Local cM_NOMEM := oStructRHM:GetValue("RHM_NOME")
Local cM_PERINIM := oStructRHM:GetValue("RHM_PERINI")
Local cM_PERFIMM := oStructRHM:GetValue("RHM_PERFIM")

Local nLinhas := 0
Local nCountL := 0
Local nCountM := 0
Local nI := 0
Local lMsg := .F.

DbSelectArea("RHK")
RHK->(DbSetOrder(1))
(RHK->(MsSeek(xFilial("RHK")+cRA_MAT)))

DbSelectArea("RHM")
RHM->(DbSetOrder(1))
(RHM->(MsSeek(xFilial("RHM")+cRA_MAT)))

DbSelectArea("RHL")
RHL->(DbSetOrder(1))
(RHL->(MsSeek(xFilial("RHL")+cRA_MAT)))

nLinhas := oStructRHL:GetQtdLine()

For nI := 1 To nLinhas
	oStructRHL:GoLine(nI)
	If !oStructRHL:IsDeleted() .AND. !Empty(cM_CODL)
		nCountL := nCountL +1
	EndIf
Next nI

nLinhas := oStructRHM:GetQtdLine()

For nI := 1 To nLinhas
	oStructRHM:GoLine(nI)
	If !oStructRHM:IsDeleted() .AND. !Empty(cM_NOMEM)
		nCountM:= nCountM+1
	EndIf
Next nI

//O campo RHK_TPCALC não pode ser alterado para "2-Automático"
If (RHK->RHK_TPCALC == "1" .OR. RHK->RHK_TPCALC == " ") .AND. cM_TPCALCK == "2" .AND. cTab == "RHK"
	lRet := .F.
	Help(" ", 1, "Help",, OemToAnsi('O tipo de cálculo não pode ser alterado para Automático'), 1, 0) //
EndIf

//Verifica se há conteúdo no campo RHK_CDPSAG
If Empty(RHK->RHK_CDPSAG) .AND. lRet
	//Se não houver conteúdo, os campos RHM_TPCALC e RHL_TPCALC não podem ser alterados para "2-Automático"
	If (RHM->RHM_TPCALC == "1" .OR. RHM->RHM_TPCALC == " ") .AND. cM_TPCALCM == "2"
		lRet := .F.
		Help(" ", 1, "Help",, OemToAnsi('O tipo de cálculo não pode ser alterado para Automático'), 1, 0) //
	EndIf
	If (RHL->RHL_TPCALC == "1" .OR. RHL->RHL_TPCALC == " ") .AND. cM_TPCALCL == "2"
		lRet := .F.
		Help(" ", 1, "Help",, OemToAnsi('O tipo de cálculo não pode ser alterado para Automático'), 1, 0) //
	EndIf
Else
	//Havendo conteúdo no campo RHK_CDPSAG, os campos RHM_TPCALC e RHL_TPCALC podem ser alterados para automático apenas*
	//*se houver registro nas tabelas SL0 ou SLE
	DbSelectArea("SG0")
	SG0->(DbSetOrder(2))//G0_FILIAL+G0_STATUS+G0_CODIGO
	If cM_TPCALCM == "2" .AND. lRet
		DbSelectArea("SLE")
		SLE->(DbSetOrder(1))//LE_FILIAL+LE_CODIGO+LE_TPFORN+LE_CODFORN
		If !(SLE->(MsSeek(xFilial("SLE")+RHK->RHK_CDPSAG))) .OR. !(SG0->(MsSeek(xFilial("SG0")+"1"+RHK->RHK_CDPSAG)))
			lRet := .F.
			Help(" ", 1, "Help",, OemToAnsi('O tipo de cálculo não pode ser alterado para Automático. Verifique a definição de plano de saúde.'), 1, 0) //
		EndIf
	EndIf
	If cM_TPCALCL == "2"
		DbSelectArea("SL0")
		SL0->(DbSetOrder(1))//L0_FILIAL+L0_CODIGO+L0_TPFORN+L0_CODFORN
		If (!(SL0->(MsSeek(xFilial("SL0")+RHK->RHK_CDPSAG))) .OR. !(SG0->(MsSeek(xFilial("SG0")+"1"+RHK->RHK_CDPSAG)))) .AND. lRet
			lRet := .F.
			Help(" ", 1, "Help",, OemToAnsi('O tipo de cálculo não pode ser alterado para Automático. Verifique a definição de plano de saúde.'), 1, 0) //
		EndIf
	EndIf
EndIf

If RHK->RHK_TPCALC == "2" .AND. cM_TPCALCK == "2" .AND. lRet
	//Se um dos campos abaixo for alterado, o tipo de cálculo torna-se 1-Informado
	If RHK->RHK_TPFORN <> cM_TPFORN .OR. RHK->RHK_CODFOR <> cM_CODFOR .OR. RHK->RHK_TPPLAN <> cM_TPPLAN .OR. RHK->RHK_PLANO <> cM_PLANO;
		.OR. RHK->RHK_PD <> cM_PD .OR. RHK->RHK_PDDAGR <> cM_PDDAGR .OR. RHK->RHK_PERINI <> cM_PERINI .OR. RHK->RHK_PERFIM <> cM_PERFIM
		MsgAlert(OemToAnsi("Essas alterações impactam diretamente no tipo de cálculo e ele se tornará '1-Informado'"))//
		oModel:SetValue("M0102102_MRHK", "RHK_TPCALC", "1")
		If nCountL > 0
			oModel:SetValue("M0102102_MRHL", "RHL_TPCALC", "1")
		EndIf
		If nCountM > 0
			oModel:SetValue("M0102102_MRHM", "RHM_TPCALC", "1")
		EndIf
	EndIf

	DbSelectArea("SRB")
	cIndKeySRB	:= "RB_FILIAL+RB_MAT+RB_COD"
	cArqSRB := CriaTrab( Nil, .F. )
	IndRegua( "SRB", cArqSRB, cIndKeySRB, , , '', .T. )
	nIndexSRB	:= SRB->( RetIndex( ) ) + 1
	SRB->(DbSetOrder(nIndexSRB))

	If SRB->(MsSeek(xFilial("SRB")+cRA_MAT+cM_CODL)) .AND. nCountL > 0 .AND. lRet
		If cM_TPCALCL == "2" .AND. SRB->RB_PLSAUDE == "2"
			Help(" ", 1, "Help",, OemToAnsi("O campo 'Tem Plano de Saúde' no cadastro de dependentes está preenchido como '2-Não'."), 1, 0)//
			lRet := .F.
		EndIf
	EndIf
EndIf

//Se o campo RHK_TPCALC for alterado para "1-Informado", os campos RHL_TPCALC e RHM_TPCALC também serão alterados para "1-Informado"
If (RHK->RHK_TPCALC == "2" .OR. RHK->RHK_TPCALC == " ") .AND. cM_TPCALCK == "1" .AND. cTab == "RHK" .AND. lRet
	If RHL->(MsSeek(xFilial("RHL")+cRA_MAT)) .AND. nCountL > 0
		If !lMsg
			MsgInfo(OemToAnsi('O tipo de cálculo dos dependentes e dos agregados também será alterado para 1-Informado'),OemToAnsi(''))//
			lMsg := .T.
		EndIf
		oModel:LoadValue("M0102102_MRHL", "RHL_TPCALC", "1")
	EndIf
	If RHM->(MsSeek(xFilial("RHM")+cRA_MAT)) .AND. nCountM > 0
		If !lMsg
			MsgInfo(OemToAnsi('O tipo de cálculo dos dependentes e dos agregados também será alterado para 1-Informado'),OemToAnsi(''))//O tipo de cálculo dos dependentes e dos agregados também será alterado para 1-Informado
			lMsg := .T.
		EndIf
		oModel:LoadValue("M0102102_MRHM", "RHM_TPCALC", "1")
	EndIf
	oModel:LoadValue("M0102102_MRHK", "RHK_CDPSAG", "    ")
EndIf

//Se um dos campos abaixo for alterado, o tipo de cálculo torna-se 1-Informado
cM_TPPLAN := oStructRHL:GetValue("RHL_TPPLAN")
cM_PLANO := oStructRHL:GetValue("RHL_PLANO")
If RHL->RHL_TPCALC == "2" .AND. lRet
	If  nCountL > 0 .AND. (RHL->RHL_TPPLAN <> cM_TPPLAN .OR. RHL->RHL_PLANO <> cM_PLANO .OR. RHL->RHL_PERINI <> cM_PERINIL .OR. RHL->RHL_PERFIM <> cM_PERFIML)
		MsgAlert(OemToAnsi("Essas alterações impactam diretamente no tipo de cálculo e ele se tornará '1-Informado'"))//
		oModel:SetValue("M0102102_MRHL", "RHL_TPCALC", "1")
	EndIf
EndIf

cM_TPPLAN := oStructRHM:GetValue("RHM_TPPLAN")
cM_PLANO := oStructRHM:GetValue("RHM_PLANO")
If RHM->RHM_TPCALC == "2" .AND. lRet
	If nCountM > 0 .AND. (RHM->RHM_TPPLAN <> cM_TPPLAN .OR. RHM->RHM_PLANO <> cM_PLANO .OR. RHM->RHM_PERINI <> cM_PERINIM .OR. RHM->RHM_PERFIM <> cM_PERFIMM)
		MsgAlert(OemToAnsi("Essas alterações impactam diretamente no tipo de cálculo e ele se tornará '1-Informado'"))//
		oModel:SetValue("M0102102_MRHM", "RHM_TPCALC", "1")
	EndIf
EndIf

Return lRet

Static Function f01021_NotEdit(oStruct, cModel)
Local lRet	:= .T.

Local nCpyLines

Local oCpyStru := __oModelCopy:GetModel( cModel )

nCpyLines	:= oCpyStru:Length()

If oStruct:GetLine() <= nCpyLines .And. !oStruct:IsInserted()
	lRet := .F.
EndIf

Return( lRet )

/*/ {Protheus.doc} f01021_VForn()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       01/10/15
@version     P12.5
@Return      Controle de Planos Ativos - Ass. Medica  - validacao de campo
@param       cCodTab, caracter, código da tabela
@Obs         Adaptação do Fonte GPEA001()
/*/
User Function f01021_VForn(cCodTab)
Local lRet := .F.
Local nPosIni := 1
Local nLenCod
Local nOrdem
Local nX := 1

Local cVar		:= Alltrim(ReadVar())
Local cFOrigem := ""

Local oModel
Local oStructRHX
Local cTpForn
Local cCampo

If IsInCallStack('U_F0102102')

	If cVar == "M->RB_CODAMED" .or. cVar == "SRB->RB_CODAMED" // DEPENDENTES ASSISTENCIA MEDICA
		cFOrigem := xFilial("SRB")
	ElseIf cVar == "M->RB_ASODONT" .or. cVar == "SRB->RB_ASODONT" // DEPENDENTES ASSISTENCIA ODONTOLOGICA
		cFOrigem := xFilial("SRB")
	ElseIf __READVAR == "M->CODFOR"           //CONSULTA F3 A PARTIR DE UMA TABELA SNNN
		cFOrigem := aCols[n][1]

	ElseIf cVar $ "M->RHK_CODFOR/M->RHL_CODFOR/M->RHM_CODFOR/M->RHN_CODFOR/M->RHO_CODFOR/M->JX_CODFORN"
		oModel 		:= FWModelActive()

		If cVar == "M->RHK_CODFOR"
			oStructRHX	:= oModel:GetModel( "M0102102_MRHK" )
			cTpForn		:= oStructRHX:GetValue("RHK_TPFORN")
		ElseIf cVar == "M->RHL_CODFOR"
			oStructRHX	:= oModel:GetModel( "M0102102_MRHL" )
			cTpForn		:= oStructRHX:GetValue("RHL_TPFORN")
		ElseIf cVar == "M->RHM_CODFOR"
			oStructRHX	:= oModel:GetModel( "M0102102_MRHM" )
			cTpForn		:= oStructRHX:GetValue("RHM_TPFORN")
		ElseIf cVar == "M->RHN_CODFOR"
			oStructRHX	:= oModel:GetModel( "GPEA002_MRHN" )
			cTpForn		:= oStructRHX:GetValue("RHN_TPFORN")
		ElseIf cVar == "M->RHO_CODFOR"
			oStructRHX	:= oModel:GetModel( "GPEA003_MRHO" )
			cTpForn		:= oStructRHX:GetValue("RHO_TPFORN")
		ElseIf cVar == "M->JX_CODFORN"
			oStructSJX	:= oModel:GetModel( "GPEA063_MSJX" )
			cTpForn := oStructSJX:GetValue("JX_TPFORN")
		EndIf

		If FunName() = "GPEA063"
			cFOrigem := xFilial("SJX")
		Else
			cFOrigem := xFilial("SRA")
		EndIf

		If cTpForn == "1"
			cCodTab := "S016"
		ElseIf cTpForn == "2"
			cCodTab := "S017"
		EndIf

		M->CODFOR := &(cVar)
	EndIf

	RCB->(dbSetOrder(3))
	RCB->(dbSeek(xFilial("RCB")+"U53_CODPLA"+cCodTab))

	nLenCod := RCB->RCB_TAMAN
	nOrdem := Val(RCB->RCB_ORDEM)

	RCB->(dbSetOrder(1))
	RCB->(dbSeek(xFilial("RCB")+cCodTab))

	While nX < nOrdem .and. RCB->RCB_CODIGO == cCodTab

		If Val(RCB->RCB_ORDEM) < nOrdem
			nPosIni += RCB->RCB_TAMAN
			nX := nX +1
		EndIf
		RCB->(DbSkip())
	EndDo

	RCC->(dbSetOrder(1))

	If RCC->(dbSeek(xFilial("RCC")+cCodTab))
		While RCC->RCC_CODIGO == cCodTab .and. !lRet
			If M->CODFOR == SubStr(RCC->RCC_CONTEU,nPosIni,nLenCod) .and.;
				(Empty(RCC->RCC_FIL) .or. RCC->RCC_FIL == cFOrigem)
				lRet := .T.
			EndIf
			RCC->(DbSkip())
		EndDo
	EndIf

	Return lRet

else
	return FVLDPLANO()
EndIf

return
