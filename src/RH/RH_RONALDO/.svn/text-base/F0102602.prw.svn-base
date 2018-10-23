#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*{Protheus.Doc} F0102602  
Rotina customizada no pos valid nos folders produtos do edital
Chamado por: Ponto de Entrada: GCPA200
@project MAN00000011901_EF_026   
@author  Aline Sebrian Damasceno

@version P12 R1.6
@since   16/11/2015  
@menu	 Gestão de Compras Publicas                                                        
*/ 
//-------------------------------------------------------------------
User Function F0102602()

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
	
	If cIdModel == 'CO2DETAIL' .And.  cIdPonto ==  'FORMLINEPOS' 
		If !Empty(FwFldGet('CO2_CODPRO')) .And. Empty(FwFldGet('CO2_XTPPL')) .And. M->CO1_IMEDIA='2'
  			Aviso( "Atenção", "Informar o Tipo da Planilha no Folder " + "Produtos", { "OK" }) 
	   		lRet := .F.
	   	EndIf   
	EndIf
EndIf
		
Return lRet		
	