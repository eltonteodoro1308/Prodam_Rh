#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100203()

@Project     MAN00000011501_EF_002
@author      Jackson Capelato
@since       23/09/2015
@version     P12.5
@Return      Validacao do campo PA2_DATAINI
@Obs         Verifica o tempo de grupo em meses
/*/

User function f0100203()

//	local cQuery := ''
//	local nTempo := 0
//
//	cQuery := " SELECT PA2_DATAIN, PA2_DATFIM FROM " + RetSqlName ("PA2") + " A "
//	cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND PA2_MAT = '"+FwFldGet('PA2_MAT')+"' AND PA2_GRUPO = '"+FwFldGet('PA2_GRUPO')+"' "
//
//	Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
//	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)
//
//	TCSetField("TRG1","PA2_DATAIN","D")
//	TCSetField("TRG1","PA2_DATFIM","D")
//
//	while ( TRG1->(!Eof()) )
//
//		dInicio := TRG1->(PA2_DATAIN)
//		dFim	:= iIf(!empty(TRG1->(PA2_DATFIM)),TRG1->(PA2_DATFIM),dDatabase)
//
//		nTempo 	+= dFim - dInicio
//
//		TRG1->(dbSkip())
//	End
//
//	M->PA2_TEMPO := nTempo

Return  .T.

User function f0100210()

//	local cQuery := ''
//	local nTempo := 0
//
//	If fieldpos("PA2_GSOMA")>0
//		cQuery := " SELECT PA2_DATAIN, PA2_DATFIM FROM " + RetSqlName ("PA2") + " A "
//		cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND PA2_MAT = '"+FwFldGet('PA2_MAT')+"' AND PA2_GSOMA = '"+FwFldGet('PA2_GSOMA')+"' "
//
//		Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
//		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)
//
//		TCSetField("TRG1","PA2_DATAIN","D")
//		TCSetField("TRG1","PA2_DATFIM","D")
//
//		while ( TRG1->(!Eof()) )
//
//			dInicio := TRG1->(PA2_DATAIN)
//			dFim	:= iIf(!empty(TRG1->(PA2_DATFIM)),TRG1->(PA2_DATFIM),dDatabase)
//
//			nTempo 	+= dFim - dInicio
//
//			TRG1->(dbSkip())
//		End
//
//		M->PA2_TEMPO := nTempo
//	EndIf

Return  .T.