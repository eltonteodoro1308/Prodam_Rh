#INCLUDE "TbiConn.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"
#INCLUDE 'FWMVCDEF.CH'

/*/ {Protheus.doc} f0100404()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       29/09/2015
@version     P12.5
@Return      Verificação de afastamento
@Obs         Função utilizada no processo de alteração e inclusão de afastamento
/*/

user function f0100404()

Local aParam     := PARAMIXB
Local lRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.
Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''

If aParam <> NIL
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]

	lIsGrid    := ( Len( aParam ) > 3 )

	If cIdPonto == 'MODELCOMMITNTTS'
		if SRA->RA_XTPCONT='2'
			IF SimNao('Necessario cadastrar substituto, proceder agora? ',,,,,'Questao ?') == "S"
				FWExecView('Cadastro de Substituição de Função','f0100201', MODEL_OPERATION_INSERT, , { || .T. }, , , )
			endif
		endif
	EndIf
EndIf

Return lRet
