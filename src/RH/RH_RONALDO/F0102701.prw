#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} F0102701()

@Project     MAN00000011501_EF_028
@author      Aline S Damasceno
@since       29/11/2015
@version     P12.1.6
@Return      Informações da planilha do contrato
@Obs         Função utilizada no processo de geração das planilhas no Edital de compras publicas
/*/

User Function F0102701(oModel)
Local lRetorno := .T.

BeginTran()

If IsBlind()
	lRetorno := u_F0102702(oModel)
Else
	FWMsgRun(,{|| lRetorno := u_F0102702(oModel) } , nil ,'Processando Apuração  '  )
EndIf


If (!lRetorno)
	DisarmTransacation()
Else			
	FWModelActive( oModel )
	
	If !IsBlind()
		FWMsgRun(,{|| FWFormCommit( oModel ) },  , 'Gerando Medição' )
		ApMsgAlert("Apuração/Medição efetuada com sucesso.",'Aviso') // "Apuração/Medição efetuada com sucesso."
	Else
		FWFormCommit( oModel )	
	EndIf
EndIf

EndTran()

Return lRetorno