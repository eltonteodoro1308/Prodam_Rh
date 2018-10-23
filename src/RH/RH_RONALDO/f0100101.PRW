#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*/ {Protheus.doc} f0100101()

@Project     MAN00000011501_EF_001
@author      Jackson Capelato        
@since       21/09/2015
@version     P12.5
@Return      Cadastro tabela PA0
@Obs         Cadastro de Grupos de Funções Gratificadas
@menu        Cadastro de Grupos de Funções Gratificadas
/*/
User Function F0100101()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PA0')
	oBrowse:SetDescription('Cadastro de Grupos de Funções Gratificadas')
	oBrowse:Activate()

Return NIL

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title 'Visualizar' 	Action 'VIEWDEF.F0100101' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 		Action 'VIEWDEF.F0100101' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' 		Action 'VIEWDEF.F0100101' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' 		Action 'VIEWDEF.F0100101' OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
	Local oStruMod 	:= FWFormStruct(1,'PA0')
	Local oModel	:= MPFormModel():New('M0100101') 
	oModel:AddFields('COMMASTER',, oStruMod)
	oModel:SetPrimaryKey({})
	oModel:SetDescription('Cadastro de Grupos de Funções Gratificadas')
	oModel:GetModel('COMMASTER'):SetDescription('Cadastro de Grupos de Funções Gratificadas')
	
Return oModel

Static Function ViewDef()
	Local oModel 	:= FWLoadModel('F0100101')
	Local oStruView := FWFormStruct(2,'PA0')
	Local oView		:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('VIEW_COM', oStruView, 'COMMASTER')
	oView:CreateHorizontalBox('SUPERIOR', 100 )
	oView:SetOwnerView('VIEW_COM', 'SUPERIOR')

Return oView