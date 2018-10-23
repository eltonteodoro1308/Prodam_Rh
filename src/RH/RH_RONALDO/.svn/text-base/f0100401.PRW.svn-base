#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} f0100401()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       28/09/2015
@version     P12.5
@Return
@Obs         Funcao para verificacao das datas em caso de substituicao
/*/

user function f0100401()

Local lFarol := .t.
Local nDias  := 0
Local nDpar  := 0

If M->PA2_TIPO = '2' //.AND. INCLUI
	nDias:=M->PA2_DATFIM-M->PA2_DATAIN
	nDpar:=GETNEWPAR('FS_SUBSLIM',180)
	If nDpar < nDias
		Alert('Data Final superior a '+strzero(GETNEWPAR('FS_SUBSLIM',180),3)+' Dias ')
		M->PA2_TIPO:='1'
		lFarol := .f.
	Else
		lFarol := .t.
	Endif
ELSE
	lFarol := .t.
ENDIF

RETURN lFarol
