#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} f0100802()

@Project     MAN00000011501_EF_008
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return
@Obs         Função para Geração da verba de Auxilio Enxoval - chamada do roteiro de calculo
/*/

user function f0100802()

Local cQuery
Local nQT
Local nVLR
Local aArea		  := getarea()


cQuery := " SELECT RB_MAT MATR, RB_XPAGENX TIPO, RB_XENXOV VALOR FROM " + RetSqlName ("SRB") + " A "
cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RB_MAT = '"+SRA->RA_MAT+"'"

Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

dbSelectArea("TRG1")
dbgotop()
nQT:=0
nVLR:=0
DO WHILE !EOF()
	IF TRG1->TIPO = '3'
		nVLR:= TRG1->VALOR
		nQT := nQT + 1 
	ENDIF
	TRG1->(DBSKIP())
ENDDO
 
RestArea(aArea)
IF nQT>0
   fGERAVERBA(ftabela("U051",1,4),nVLR*nQT,nQT)
ENDIF  

Return .T.
