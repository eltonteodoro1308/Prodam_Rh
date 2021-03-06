#INCLUDE "TbiConn.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"
#INCLUDE 'FWMVCDEF.CH'

/*/ {Protheus.doc} f0100405()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       29/09/2015
@version     P12.5
@Return      Verifica��o de afastamento
@Obs         Fun��o utilizada no processo de altera��o e inclus�o de afastamento
/*/

user function f0100405()

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
			    FWExecView('Cadastro de Substitui��o de Fun��o','f0100201', MODEL_OPERATION_INSERT, , { || .T. }, , , )
			endif
		endif
	EndIf
EndIf

Return lRet
