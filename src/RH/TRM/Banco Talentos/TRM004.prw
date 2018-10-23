//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "FWBROWSE.CH"

//Variáveis Estáticas
Static cTitulo := "Cadastro de Áreas, Categorias e Conhecimentos"
 
/*/{Protheus.doc} TRM004
Função para cadastro de Áreas de Conhecimento (SZ6), Categorias de Conhecimento (SZ7) e Conhecimentos (SZ8).
@author Diego Santos
@since 24/03/2016
@version 12.1.6
@return Nil, Função não tem retorno
@obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function TRM004()

Local aArea   := GetArea()
Local oBrowse
 
//Instânciando FWMBrowse - Somente com dicionário de dados
oBrowse := FWMBrowse():New()
 
//Setando a tabela de cadastro de Autor/Interprete
oBrowse:SetAlias("SZ6")
 
    //Setando a descrição da rotina
oBrowse:SetDescription(cTitulo)
 
//Legendas
//oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN", "Original" )
//oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",   "Não Original" )
 
//Ativa a Browse
oBrowse:Activate()
 
RestArea(aArea)

Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Diego Santos                                                 |
 | Data:  24/03/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
 
Local aRot := {}

//Adicionando opções
ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.TRM004' OPERATION 1 ACCESS 0 //OPERATION 1
ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_INCTRM004()'    OPERATION 3 ACCESS 0 //OPERATION 3
ADD OPTION aRot TITLE 'Alterar'    ACTION 'U_ALTTRM004()'    OPERATION 4 ACCESS 0 //OPERATION 4
//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.TRM004' OPERATION 3 ACCESS 0 //OPERATION 3
//ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.TRM004' OPERATION 4 ACCESS 0 //OPERATION 4
ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.TRM004' OPERATION 5 ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Diego Santos                                                |
 | Data:  28/03/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()

Local oModel        := Nil

Local oStPai        := FWFormStruct(1, 'SZ6')
Local oStFilho  	:= FWFormStruct(1, 'SZ7')
Local oStNeto   	:= FWFormStruct(1, 'SZ8')

Local aAuxSZ6		:= aClone(oStPai:GetFields())
Local aAuxSZ7		:= aClone(oStFilho:GetFields())
Local aAuxSZ8		:= aClone(oStNeto:GetFields())

Local nX

Local aSZ7Rel       := {}
Local aSZ8Rel       := {}
 
//Criando o modelo e os relacionamentos
//MPFORMMODEL():New(<cID >, <bPre >, <bPost >, <bCommit >, <bCancel >)-> NIL
oModel := MPFormModel():New('TRM004X', /*bPre*/, {|oModel| U_VldZ6TRM004(oModel)} )
oModel:AddFields('SZ6MASTER',/*cOwner*/,oStPai)
oModel:AddGrid('SZ7DETAIL','SZ6MASTER',oStFilho,{ |oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue| VldZ7Cod(oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue)  })  //cOwner é para quem pertence
oModel:AddGrid('SZ8DETAIL','SZ7DETAIL',oStNeto ,{ |oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue| VldZ8Cod(oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue)  })  //cOwner é para quem pertence
 
//Fazendo o relacionamento entre o Pai e Filho
aAdd(aSZ7Rel, {'Z7_FILIAL', 'Z6_FILIAL'	} )
aAdd(aSZ7Rel, {'Z7_AREA'  , 'Z6_CODIGO' } )
 
//Fazendo o relacionamento entre o Filho e Neto
aAdd(aSZ8Rel, {'Z8_FILIAL', 'Z7_FILIAL'} )
aAdd(aSZ8Rel, {'Z8_CATEG',  'Z7_CODIGO'} )
aAdd(aSZ8Rel, {'Z8_AREA' ,  'Z7_AREA'  } ) 
 
oModel:SetRelation('SZ7DETAIL', aSZ7Rel, SZ7->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
oModel:GetModel('SZ7DETAIL'):SetUniqueLine({"Z7_FILIAL","Z7_CODIGO"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
oModel:SetPrimaryKey({})
 
oModel:SetRelation('SZ8DETAIL', aSZ8Rel, SZ8->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
oModel:GetModel('SZ8DETAIL'):SetUniqueLine({"Z8_FILIAL","Z8_CODIGO"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
oModel:SetPrimaryKey({})
 
//Setando as descrições
oModel:SetDescription(cTitulo)
oModel:GetModel('SZ6MASTER'):SetDescription('Áreas do Conhecimento')
oModel:GetModel('SZ7DETAIL'):SetDescription('Categorias do Conhecimento')
oModel:GetModel('SZ8DETAIL'):SetDescription('Conhecimentos')

For nX := 1 To Len(aAuxSZ7)
	If aAuxSZ7[nX][3] $ "Z7_AREA"
		oStFilho:SetProperty( aAuxSZ7[nX][3] , MODEL_FIELD_WHEN, {||.F.})
	Else
		oStFilho:SetProperty( aAuxSZ7[nX][3] , MODEL_FIELD_WHEN, {||.T.})			
	EndIf
Next nX

For nX := 1 To Len(aAuxSZ8)
	If aAuxSZ8[nX][3] $ "Z8_CATEG"
		oStNeto:SetProperty( aAuxSZ8[nX][3] , MODEL_FIELD_WHEN, {||.F.})
	Else
		oStNeto:SetProperty( aAuxSZ8[nX][3] , MODEL_FIELD_WHEN, {||.T.})			
	EndIf
Next nX

oStFilho:SetProperty( "Z7_AREA"	, MODEL_FIELD_INIT , {|| oModel:GetModel('SZ6MASTER'):GetValue('Z6_CODIGO') } )
oStNeto:SetProperty ( "Z8_CATEG", MODEL_FIELD_INIT , {|| oModel:GetModel('SZ7DETAIL'):GetValue('Z7_CODIGO') } )
oStNeto:SetProperty ( "Z8_AREA", MODEL_FIELD_INIT  , {|| oModel:GetModel('SZ7DETAIL'):GetValue('Z7_AREA') } )

If IsInCallStack("U_ALTTRM004")
	oStPai:SetProperty  ( 	"Z6_CODIGO", MODEL_FIELD_WHEN , {|| .F. } )
EndIf	
 
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Diego Santos                                               |
 | Data:  28/03/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()

Local oView     	:= Nil
Local oStPai        := FWFormStruct(2, 'SZ6')
Local oStFilho  	:= FWFormStruct(2, 'SZ7')
Local oStNeto       := FWFormStruct(2, 'SZ8')

Local oModel        := FWLoadModel('TRM004')

//Estruturas das tabelas e campos a serem considerados
Local aAuxSZ6		:= aClone(oStPai:GetFields())
Local aAuxSZ7		:= aClone(oStFilho:GetFields())
Local aAuxSZ8		:= aClone(oStNeto:GetFields())

Local nX
 
//Criando a View
oView := FWFormView():New()
oView:SetModel(oModel)
 
//Adicionando os campos do cabeçalho e o grid dos filhos
oView:AddField('VIEW_SZ6'	,oStPai  ,	'SZ6MASTER')

oView:AddGrid('VIEW_SZ7' 	,oStFilho,	'SZ7DETAIL')
oView:AddGrid('VIEW_SZ8' 	,oStNeto ,	'SZ8DETAIL')
 
//Setando o dimensionamento de tamanho
oView:CreateHorizontalBox('CABEC',20)
oView:CreateHorizontalBox('GRID' ,40)
oView:CreateHorizontalBox('GRID2',40)
//oView:CreateHorizontalBox('TOTAL',13)
 
//Amarrando a view com as box
oView:SetOwnerView('VIEW_SZ6','CABEC')
oView:SetOwnerView('VIEW_SZ7','GRID')
oView:SetOwnerView('VIEW_SZ8','GRID2')
//oView:SetOwnerView('VIEW_TOT','TOTAL')
 
//Habilitando título
oView:EnableTitleView('VIEW_SZ6','Áreas')
oView:EnableTitleView('VIEW_SZ7','Categorias')
oView:EnableTitleView('VIEW_SZ8','Conhecimentos')
 
//Remove chave da SZ7 que deve ser alimentada automaticamente.
For nX := 1 To Len(aAuxSZ7)
	If aAuxSZ7[nX][1] $ "Z7_AREA"
		oStFilho:RemoveField( aAuxSZ7[nX][1] )
	EndIf
Next nX

//Remove chave da SZ7 que deve ser alimentada automaticamente.
For nX := 1 To Len(aAuxSZ8)
	If AllTrim(aAuxSZ8[nX][1]) $ "Z8_CATEG|Z8_AREA"
		oStNeto:RemoveField( aAuxSZ8[nX][1] )
	EndIf
Next nX

oView:SetFieldAction("Z6_CODIGO", {|oModel| U_SetZ7Area(oModel) 	} )
oView:SetFieldAction("Z7_CODIGO", {|oModel| U_SetZ8Categ(oModel) 	} )

Return oView

//Cabecalho SetZ7Area
/*---------------------------------------------------------------------*
 | Func:  SetZ7Area                                                    |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Seta valor na chave da tabela SZ7 a partir do                |
 |        digitado na tabela SZ6.									   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
User Function SetZ7Area(oModel)

Local lRet		:= .T.

Local nX

Local oModelSZ6 := oModel:GetModel('SZ6MASTER')
Local oModelSZ7 := oModel:GetModel('SZ7DETAIL')
Local oModelSZ8 := oModel:GetModel('SZ8DETAIL')

Local oView 	:= FWViewActive()
Local cArea		:= oModelSZ6:GetValue("Z6_CODIGO")

oModelSZ7:Goline(1)
For nX := 1 To oModelSZ7:Length()
	oModelSZ7:GoLine(nX)
	oModelSZ7:LoadValue("Z7_AREA", Alltrim(cArea))
Next nX

oModelSZ8:Goline(1)
For nX := 1 To oModelSZ8:Length()
	oModelSZ8:Goline(nX)
	oModelSZ8:LoadValue("Z8_AREA", Alltrim(cArea))
Next nX

Return lRet

/*---------------------------------------------------------------------*
 | Func:  SetZ8Categ                                                    |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Seta valor na chave da tabela SZ8 a partir do                |
 |        digitado na tabela SZ7.									   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function SetZ8Categ(oModel)

Local lRet		:= .T.

Local nX

Local oModelSZ6 := oModel:GetModel('SZ6MASTER')
Local oModelSZ7 := oModel:GetModel('SZ7DETAIL')
Local oModelSZ8 := oModel:GetModel('SZ8DETAIL')

Local oView 	:= FWViewActive()
Local cCateg	:= oModelSZ7:GetValue("Z7_CODIGO")
Local cArea		:= oModelSZ6:GetValue("Z6_CODIGO")

oModelSZ8:Goline(1)
For nX := 1 To oModelSZ8:Length()
	oModelSZ8:GoLine(nX)
	oModelSZ8:LoadValue("Z8_CATEG", Alltrim(cCateg))
	oModelSZ8:LoadValue("Z8_AREA" , Alltrim(cArea) )
Next nX

Return lRet
	
/*---------------------------------------------------------------------*
 | Func:  INCTRM004                                                    |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Inclusão de Area, Categorias e Conhecimentos                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function INCTRM004

Local oModelCon := FWLoadModel("TRM004")//Carrega estrutura do model

oModelCon:SetOperation( MODEL_OPERATION_INSERT ) //Define operação de inclusao
oModelCon:Activate()							 //Ativa o model

FWExecView( "Inclusão de Áreas, Categorias e Conhecimentos" , "TRM004", 3,  /*oDlgKco*/, {|| .T. } , /*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/, /*cOperatId*/ , /*cToolBar*/ , oModelCon )

Return .T.

/*---------------------------------------------------------------------*
 | Func:  ALTTRM004                                                    |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Alteração de Area, Categorias e Conhecimentos                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
User Function ALTTRM004

Local oModelCon := FWLoadModel("TRM004")//Carrega estrutura do model

oModelCon:SetOperation( MODEL_OPERATION_UPDATE ) //Define operação de inclusao
oModelCon:Activate()							 //Ativa o model

FWExecView( "Alteração de Áreas, Categorias e Conhecimentos" , "TRM004", 3,  /*oDlgKco*/, {|| .T. } , /*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/, /*cOperatId*/ , /*cToolBar*/ , oModelCon )

Return .T.

/*---------------------------------------------------------------------*
 | Func:  VldZ7Cod                                                     |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Validação Z7_CODIGO						                   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function VldZ7Cod(oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue)

Local lRet     := .T.
Local oModel   := FWModelActive()

Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local cMsg		:= ""

Local oModelSZ6	:= oModel:GetModel('SZ6MASTER')
Default oModelGrid 	:= oModel:GetModel('SZ7DETAIL')
	 
If !oModelGrid:IsInserted() .And. cField == "Z7_CODIGO"	//Se não estiver sendo inserida.	
	lRet := .F.	
Else
	lRet := .T.	
EndIf

If nOpc == "DELETE"

	cMsg	:= "Não é possível excluir Áreas/Categorias e Conhecimentos já cadastrados a funcionário(s)." + Chr(13) + Chr(10)
	cMsg	+= "Por favor, exclua o conhecimento do(s) funcionário(s) e realize o processo novamente."

	cQuery := "SELECT * FROM "+RetSqlName("SZ9")+" SZ9 "
	cQuery += "WHERE "
	cQuery += "SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' AND "
	cQuery += "SZ9.Z9_AREA = '" + oModelSZ6:GetValue("Z6_CODIGO") + "' AND "
	cQuery += "SZ9.Z9_CATEG  = '" + oModelGrid:GetValue("Z7_CODIGO") + "' AND "
	cQuery += "SZ9.D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	If (cAliasQry)->(!Eof())
		lRet := .F.
		oModel:SetErrorMessage("",,oModel:GetId(),"","VldZ7Cod",OemToAnsi(cMsg))	
	EndIf
	
EndIf

Return lRet

/*---------------------------------------------------------------------*
 | Func:  VldZ8Cod                                                     |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Validação Z8_CODIGO						                   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function VldZ8Cod(oModelGrid, nLine, nOpc, cField, xValue, xCurrentValue)

Local lRet     := .T.
Local oModel   := FWModelActive()

Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local cMsg		:= ""

Local  oModelSZ6	:= oModel:GetModel('SZ6MASTER')
Local  oModelSZ7	:= oModel:GetModel('SZ7DETAIL')
Local  oModelSZ8	:= oModel:GetModel('SZ8DETAIL')

Default oModelGrid 	:= oModel:GetModel('SZ8DETAIL')
	 
If !oModelGrid:IsInserted() .And. cField == "Z8_CODIGO"	//Se não estiver sendo inserida.	
	lRet := .F.	
Else
	lRet := .T.	
EndIf

If nOpc == "DELETE"

	cMsg	:= "Não é possível excluir Áreas/Categorias e Conhecimentos já cadastrados a funcionário(s)." + Chr(13) + Chr(10)
	cMsg	+= "Por favor, exclua o conhecimento do(s) funcionário(s) e realize o processo novamente."

	cQuery := "SELECT * FROM "+RetSqlName("SZ9")+" SZ9 "
	cQuery += "WHERE "
	cQuery += "SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' AND "
	cQuery += "SZ9.Z9_AREA = '" + oModelSZ6:GetValue("Z6_CODIGO")+ "' AND "
	cQuery += "SZ9.Z9_CATEG = '" + oModelSZ7:GetValue("Z7_CODIGO")+ "' AND "
	cQuery += "SZ9.Z9_CONHEC  = '" + oModelGrid:GetValue("Z8_CODIGO") + "' AND "
	cQuery += "SZ9.D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	If (cAliasQry)->(!Eof())
		lRet := .F.
		oModel:SetErrorMessage("",,oModel:GetId(),"","VldZ8Cod",OemToAnsi(cMsg))	
	EndIf
	
EndIf

Return lRet

/*---------------------------------------------------------------------*
 | Func:  VldZ6TRM004                                                  |
 | Autor: Diego Santos                                                 |
 | Data:  28/03/2016                                                   |
 | Desc:  Valida Exclusão de Area, Categorias e Conhecimentos          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
User Function VldZ6TRM004( oModel )

Local lRet     		:= .T.
Local oModel   		:= FWModelActive()
Local nOperation 	:= oModel:GetOperation()

Local  oModelSZ6	:= oModel:GetModel('SZ6MASTER')
Local  oModelSZ7	:= oModel:GetModel('SZ7DETAIL')
Local  oModelSZ8	:= oModel:GetModel('SZ8DETAIL')

Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local cMsg		:= ""

If nOperation == MODEL_OPERATION_DELETE 
 
	cMsg	:= "Não é possível excluir Áreas/Categorias e Conhecimentos já cadastrados a funcionário(s)." + Chr(13) + Chr(10)
	cMsg	+= "Por favor, exclua o conhecimento do(s) funcionário(s) e realize o processo novamente."
	
	cQuery := "SELECT * FROM "+RetSqlName("SZ9")+" SZ9 "
	cQuery += "WHERE "
	cQuery += "SZ9.Z9_FILIAL = '" + xFilial("SZ9") + "' AND "
	cQuery += "SZ9.Z9_AREA 	 = '" + oModelSZ6:GetValue("Z6_CODIGO") + "' AND "
	cQuery += "SZ9.D_E_L_E_T_ = '' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	If (cAliasQry)->(!Eof())
		lRet := .F.
		oModel:SetErrorMessage("",,oModel:GetId(),"","VldZ6TRM004",OemToAnsi(cMsg))
		//MsgAlert( cMsg, "Aviso" )
	EndIf

EndIf

Return lRet
