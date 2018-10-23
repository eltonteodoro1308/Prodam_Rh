#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} GPRAM120()

@Project     MAN00000011501_EF_008
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return      Atualização de campo
@Obs         Ponto de entrada para atualizar os pagamentos do auxilio
/*/

user function GPRAM120()

U_f0100803()

U_F0100211()

return .t.
