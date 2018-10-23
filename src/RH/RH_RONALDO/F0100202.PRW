#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100202()

@Project     MAN00000011501_EF_002
@author      Jackson Capelato
@since       23/09/2015
@version     P12.5
@Return      Validacao do campo PA2_DATAIN
@Obs         Verifica o tempo de grupo em Meses    */

User function f0100202()
//
//	local nDIAS  := 0
//
//
//	IF EMPTY(M->PA2_DATFIM)
//		If M->PA2_DATAIN > dDataBase
//			nDIAS = 1
//		ELSEIf M->PA2_DATAIN < dDataBase
//			nDIAS := ROUND((dDataBase-M->PA2_DATAIN)/30,0)
//		ELSE
//			nDIAS = 1
//		ENDIF 
//	ELSE
//		If M->PA2_DATAIN > dDataBase
//			nDIAS = 1
//		ELSEIf M->PA2_DATAIN < dDataBase
//			IF dDataBase > M->PA2_DATFIM 
//				nDIAS := ROUND((M->PA2_DATFIM-M->PA2_DATAIN)/30,0)
//			ELSE
//				nDIAS := ROUND((dDataBase-M->PA2_DATAIN)/30,0)
//			ENDIF	
//		ELSE
//			nDIAS = 1
//		ENDIF
//	ENDIF
//
//	if ndias=0
//		ndias=1
//	endif   
//
//	M->PA2_TEMPO:=nDIAS

Return .T.
