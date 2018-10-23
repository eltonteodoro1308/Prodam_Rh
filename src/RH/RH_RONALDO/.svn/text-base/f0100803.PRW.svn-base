#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100803()

@Project     MAN00000011501_EF_008
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return      Atualização de campo
@Obs         Ponto de entrada para atualizar os pagamentos do auxilio
/*/

user function f0100803()

Local cQuery
Local aArea 	:= GetArea()
Local aAreaSRB	:= SRB->( GetArea() )

cQuery := " SELECT RB_MAT MATR, RB_COD SEQU, RB_XPAGENX TIPO, RB_XENXOV VALOR FROM " + RetSqlName ("SRB") + " A "
cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RB_MAT = '"+SRA->RA_MAT+"' AND RB_XPAGENX = '3' "

Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

dbSelectArea("TRG1")
dbgotop()

DO WHILE !EOF()
	
	dbselectarea("SRB")
	SRB->(dbsetorder(1))
	dbgotop()
	
	SRB->(Dbseek(xfilial("SRB")+TRG1->MATR))
	
	DO WHILE SRB->RB_MAT = TRG1->MATR
		
		IF SRB->RB_XPAGENX = '3'
			RecLock("SRB",.F.)
			SRB->RB_XPAGENX := '1'
			SRB->( MsUnLock() )
		ENDIF
		
		SRB->(DBSKIP())
	ENDDO
	dbSelectArea("TRG1")
	TRG1->(DBSKIP())
	
ENDDO

RestArea( aArea	   )
RestArea( aAreaSRB )

Return
