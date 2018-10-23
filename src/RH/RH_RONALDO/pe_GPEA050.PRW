#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} GPEA050()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       29/09/2015
@version     P12.5
@Return      Verificação de afastamento
@Obs         Função utilizada no processo de alteração e inclusão de afastamento
/*/

user function GPEA050()
Local lRet := .T.

lRet := u_F0100404()

Return lRet

