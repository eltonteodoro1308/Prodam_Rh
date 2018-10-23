#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} F0102701()

@Project     MAN00000011501_EF_028
@author      Aline S Damasceno
@since       29/11/2015
@version     P12.1.6
@Return      Informa��es da planilha do contrato
@Obs         Fun��o utilizada no processo de gera��o das planilhas no Edital de compras publicas
/*/

User Function F0102701(oModel)
Local lRetorno := .T.

BeginTran()

If IsBlind()
	lRetorno := u_F0102702(oModel)
Else
	FWMsgRun(,{|| lRetorno := u_F0102702(oModel) } , nil ,'Processando Apura��o  '  )
EndIf


If (!lRetorno)
	DisarmTransacation()
Else			
	FWModelActive( oModel )
	
	If !IsBlind()
		FWMsgRun(,{|| FWFormCommit( oModel ) },  , 'Gerando Medi��o' )
		ApMsgAlert("Apura��o/Medi��o efetuada com sucesso.",'Aviso') // "Apura��o/Medi��o efetuada com sucesso."
	Else
		FWFormCommit( oModel )	
	EndIf
EndIf

EndTran()

Return lRetorno