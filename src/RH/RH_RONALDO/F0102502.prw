#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TECA850.CH"

//-------------------------------------------------------------------
/*{Protheus.Doc} F0102502  
Rotina customizada no pos valid nos folders de RH, MI, MC, LE
Chamado por: Ponto de Entrada: TECA740 
@project MAN00000011901_EF_025    
@author  Aline Sebrian Damasceno

@version P12 R1.6
@since   16/11/2015  
@menu	 Gestão de Serviços                                                            
*/ 
//-------------------------------------------------------------------
User Function F0102502()
Local aArea		 := GetArea()
Local aParam     := PARAMIXB 
Local lRet       := .T. 
Local oObj       := '' 
Local cIdPonto   := '' 
Local cIdModel   := '' 
Local cTipPla    := ''
Local cProduto   := ''

If aParam <> NIL 
	oObj       := aParam[1] 
	cIdPonto   := aParam[2] 
	cIdModel   := aParam[3] 
	
	Do Case
		Case cIdModel == 'TFF_RH'
			cProduto := FwFldGet('TFF_PRODUT')
			cTipPla  := FwFldGet('TFF_XTPPL')
			cFolder  := "Recursos Humanos"
		Case cIdModel == 'TFG_MI'
			cProduto := FwFldGet('TFG_PRODUT')
			cTipPla  := FwFldGet('TFG_XTPPL')
			cFolder  := "Materiais de Implantação"
		Case cIdModel == 'TFH_MC'
			cProduto := FwFldGet('TFH_PRODUT')
			cTipPla  := FwFldGet('TFH_XTPPL')
			cFolder  := "Materiais de Consumo"
		Case cIdModel == 'TFI_LE'
			cProduto := FwFldGet('TFI_PRODUT')
			cTipPla  := FwFldGet('TFI_XTPPL')
			cFolder  := "Locação de Equipamentos"
	End Case

 	If cIdPonto ==  'FORMLINEPOS' 
 		If !Empty(cProduto) .And. Empty(cTipPla) .And. M->ADY_TPCONT =='4'
 			Help(,,'PLANGCT',,  "Informar o Tipo da Planilha no Folder " ,1,0)
 	 		lRet := .F.
 	 	EndIf
	EndIf
EndIf 

RestArea( aArea )
Return lRet
