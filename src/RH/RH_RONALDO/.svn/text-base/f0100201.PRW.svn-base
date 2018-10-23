#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100201()

@Project     MAN00000011501_EF_002
@author      Jackson Capelato
@since       23/09/2015
@version     P12.5
@Return      Cadastro tabela PA2
@Obs         Cadastro de Designação de Função e Substituição
@menu        Cadastro de Designação de Função e Substituição
/*/

User function f0100201()
	Local oBrwRB0

	oBrwRB0:= FwmBrowse():New()
	oBrwRB0:SetAlias( 'PA2' )
	oBrwRB0:SetDescription( "Cadastro de Designação de Função e Substituição" )

	oBrwRB0:ForceQuitButton()

	oBrwRB0:Activate()

Return NIL


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.f0100201'	OPERATION 2 ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE "Incluir"		ACTION 'VIEWDEF.f0100201'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"		ACTION 'VIEWDEF.f0100201'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"		ACTION 'VIEWDEF.f0100201'	OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	Local oStruRB0 	:= FWFormStruct( 1, 'PA2')
	Local oModel

	oModel := MPFormModel():New('M0100201')//,,{|oModel|u_F0100212(oModel)})

	aAux1 := FwStruTrigger('PA2_FUNGRA', 'PA2_DFUNGR','SQ3->Q3_DESCSUM',.T.,'SQ3',1,'xFilial("PA0")+FwFldGet("PA2_FUNGRA")',,'1')
	aAux2 := FwStruTrigger('PA2_FUNGRA', 'PA2_GRUPO' ,'SQ3->Q3_XGRPFUN',.T.,'SQ3',1,'xFilial("PA0")+FwFldGet("PA2_FUNGRA")',,'2')

	oStruRB0:AddTrigger( aAux1[1], aAux1[2], aAux1[3], aAux1[4])//--Gatilho para preenchimento grupo
	oStruRB0:AddTrigger( aAux2[1], aAux2[2], aAux2[3], aAux2[4])//--Gatilho para preenchimento grupo

	oModel:AddFields( 'PA2MASTER',, oStruRB0)

	oStruRB0:SetProperty( "PA2_OPCDIR" , MODEL_FIELD_WHEN,FWBuildFeature( STRUCT_FEATURE_WHEN, "U_F0100206()" )) //-- Não permite alterar
	//oStruRB0:SetProperty( "PA2_FUNGRA" , MODEL_FIELD_VALID,FWBuildFeature( STRUCT_FEATURE_VALID, "ExistCpo('SQ3')" )) 
	oStruRB0:SetProperty( "PA2_MATSUB"   , MODEL_FIELD_VALID,FWBuildFeature( STRUCT_FEATURE_VALID, "ExistCpo('SRA')" )) 

	oModel:SetDescription(  "Cadastro de Referência de Gratificação de Função" )
	oModel:GetModel( 'PA2MASTER' ):SetDescription(  "Cadastro de Referência de Gratificação de Função" )
	oModel:SetPrimaryKey( { } )

Return oModel


Static Function ViewDef()

	Local oModel	:= FWLoadModel( 'f0100201' )
	Local oStruRB0 	:= FWFormStruct( 2, 'PA2' )
	Local oView

	oView := FWFormView():New()
	oView:SetModel( oModel )


	oView:AddField( 'VIEW_PA2', oStruRB0, 'PA2MASTER' )
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_PA2', 'TELA' )
	oView:setCloseOnOk({|| .t.})

Return oView

/*/{Protheus.doc} F0100206
Informa se campo PA2_OPCDIR pode ser alterado ou não
@project 	MAN00000011501_EF_002
@author 	izac.ciszevski
@since 		26/11/2015
@version 	1.0
@return 	lRet, permite alterar ou não o campo PA2_OPCDIR
/*/
User Function F0100206()
	Local aAreas := {GetArea() , SRA->(GetArea()) }
	Local lRet := .F.
	Local oView

	If ! (lRet := Posicione('SRA',1,xFilial('SRA')+FWFldGet('PA2_MAT'),'RA_XTPCONT') == '2')
		If !empty(FWFldGet('PA2_OPCDIR'))
			FWFldPut('PA2_OPCDIR','',,,,.T.)// Força o conteúdo se não dá loop infinito.
			oView := FwViewActive()
			oView:Refresh()
		EndIf
	EndIf
	aEval(aAreas,{|x| RestArea(x) })

Return lRet

/*/{Protheus.doc} F0100211
@author izac.ciszevski
@since 11/12/2015
@type function
/*/
user function F0100211()

/*	cQuery := " UPDATE " + RetSqlName("PA2") + " SET PA2_TEMPO = PA2_TEMPO + 1"
	cQuery += " WHERE PA2_FILIAL = '"+SRA->RA_FILIAL+"' AND PA2_MAT = '"+SRA->RA_MAT+"'"// AND PA2_DATAIN = '"+PA2->PA2_DATAIN+"'" 
	TCSQLExec(cQuery)

	cQuery := "COMMIT"
	TCSQLExec(cQuery) */
			nDif := 0
			nTempo := 0
			cQuery := " SELECT PA2_DATAIN, PA2_DATFIM, R_E_C_N_O_ PA2RECNO FROM " + RetSqlName ("PA2") + " A "
			cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND PA2_FILIAL = '"+SRA->RA_FILIAL+"' AND PA2_MAT = '"+SRA->RA_MAT+"' AND PA2_TIPO = '1' "

			Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

			TCSetField("TRG1","PA2_DATAIN","D")
			TCSetField("TRG1","PA2_DATFIM","D")

			while ( TRG1->(!Eof()) )
				dInicio := TRG1->(PA2_DATAIN)
				dFim	:= iIf(!empty(TRG1->(PA2_DATFIM)),TRG1->(PA2_DATFIM),dDatabase)
				nDif := dFim - dInicio
				nTempo := nTempo + nDif + 1

				TRG1->(dbSkip())
			End

			nTempoT := NoRound(nTempo)
			nTempo := NoRound(nTempo/30,0)
				
			nTempoA := INT(nTempoT/365.25)
			nTempoM := INT((nTempoT - nTempoA * 365.25) / 30.41667)
			nTempoD := INT(nTempoT - nTempoA * 365.25 - nTempoM * 30.41667)
			
			TRG1->(dbgotop())
			while ( TRG1->(!Eof()) )
				PA2->(dbgoto(TRG1->PA2RECNO))
				RecLock("PA2",.F.)
				PA2->PA2_TEMPO := nTempo
				PA2->PA2_ANO := nTempoA
				PA2->PA2_MES := nTempoM
				PA2->PA2_DIA := nTempoD
				PA2->(msUnlock())
				TRG1->(dbSkip())
			End	
Return

/*/{Protheus.doc} F0100212
@author izac.ciszevski
@since 11/12/2015
@type function
/*/
user function F0100212()
	Local cIdPonto   := '' 
	Local cIdModel   := '' 
	Local cTipPla    := ''
	Local cProduto   := ''
	local cQuery := ''
	local nTempo := 0
	Local aParam     := PARAMIXB 

	If aParam <> NIL 
		oObj       := aParam[1] 
		cIdPonto   := aParam[2] 
		cIdModel   := aParam[3] 

		If cIdPonto == 'MODELCOMMITNTTS'

			cQuery := " SELECT PA2_DATAIN, PA2_DATFIM, R_E_C_N_O_ PA2RECNO FROM " + RetSqlName ("PA2") + " A "

			If PA2->(fieldpos("PA2_GSOMA"))>0
				cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND PA2_FILIAL = '"+SRA->RA_FILIAL+"' AND PA2_MAT = '"+FWFldGet("PA2_MAT")+"' AND PA2_GSOMA = '"+FWFldGet("PA2_GSOMA")+"' AND PA2_TIPO = '1' "
			Else
				cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND PA2_FILIAL = '"+SRA->RA_FILIAL+"' AND PA2_MAT = '"+FWFldGet("PA2_MAT")+"' AND PA2_GRUPO = '"+FWFldGet("PA2_GRUPO")+"' AND PA2_TIPO = '1' "
			EndIf

			Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

			TCSetField("TRG1","PA2_DATAIN","D")
			TCSetField("TRG1","PA2_DATFIM","D")

			while ( TRG1->(!Eof()) )

				dInicio := TRG1->(PA2_DATAIN)
				dFim	:= iIf(!empty(TRG1->(PA2_DATFIM)),TRG1->(PA2_DATFIM),dDatabase)

				nTempo 	+= dFim - dInicio + 1

				TRG1->(dbSkip())
			End

			nTempoT := NoRound(nTempo)
			nTempo := NoRound(nTempo/30,0)
				
			nTempoA := INT(nTempoT/365.25)
			nTempoM := INT((nTempoT - nTempoA * 365.25) / 30.41667)
			nTempoD := INT(nTempoT - nTempoA * 365.25 - nTempoM * 30.41667)
			
			TRG1->(dbgotop())
			while ( TRG1->(!Eof()) )
				PA2->(dbgoto(TRG1->PA2RECNO))
				RecLock("PA2",.F.)
				PA2->PA2_TEMPO := nTempo
				PA2->PA2_ANO := nTempoA
				PA2->PA2_MES := nTempoM
				PA2->PA2_DIA := nTempoD
				PA2->(msUnlock())
				TRG1->(dbSkip())
			End
		EndIf
	EndIf

Return .T. 

User Function M0100201()
	u_F0100212()
Return .T.