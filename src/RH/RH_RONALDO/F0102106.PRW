#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} F0102106()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       05/10/15
@version     P12.5
@Return      Funcao para Consulta Padrao de Assistencia Medica U054
@Obs
/*/

USER Function F0102106()                                                                  '

xRet := Gp310SXB("U054", 'U54_ID', { || .T. } )

If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
	VAR_IXB := &__READVAR
EndIf

If ValType(xRet) <> "L"
	xRet := .F.
EndIf

Return( xRet )
