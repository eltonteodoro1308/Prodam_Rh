#INCLUDE "protheus.ch"

//--------------------------------------------------------------------------
/*{Protheus.doc} F0100502
Funcao executada pela Formula U_VRFAFAST
@owner      ademar.fernandes
@author     ademar.fernandes
@since      01/10/2015
@param
@return     lRet
@project    MAN00000011501_EF_005
@version    P 12.1.006
@obs        Observacoes
*/
//--------------------------------------------------------------------------
User Function F0100502()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LCALCULAR := .F.
A12AFAST := {}
FRETAFAS(DDATADE, DDATAATE, , , , , @A12AFAST)

IF ( !EMPTY(A12AFAST) )
	
	NY := 1
	While ( NY <= LEN(A12AFAST) )
		
		IF ( A12AFAST[NY,11] > 15 )
			LCALCULAR := .T.
		EndIF
		
		NY += 1
	EndDo
	
	IF ( LCALCULAR )
		
		NX := 1
		While ( NX <= LEN(A12AFAST) )
			
			DINIDATA := A12AFAST[NX,03]
			CTP2AFAST := A12AFAST[NX,13]
			CPRORROG := POSICIONE("SR8",6,XFILIAL("SR8")+SRA->RA_MAT+DTOS(DINIDATA)+CTP2AFAST,"R8_XPGAUX")
			IF ( CPRORROG $ "1*3" )
				
				CTPAFAST := A12AFAST[NX,05]
				NDIASTOT := ( (DDATAATE - DINIDATA) + 1 )
				
				IF ( CTPAFAST == "A" .AND. NDIASTOT > 365 )
					
					//# CASO O AFASTAMENTO NAO FOR ACIDENTE DE TRABALHO
					IF ( LACIDTRAB := !(ALLTRIM(A12AFAST[NX,16]) == "P1") )
						
						//# ZERA OS VALORES DO ARRAY AVRCALC
						NZ := 1
						While ( NZ <= LEN(AVRCALC) )
							
							AVRCALC[NZ,02] := 0
							AVRCALC[NZ,03] := 0
							AVRCALC[NZ,04] := 0
							AVRCALC[NZ,05] := 0
							AVRCALC[NZ,06] := 0
							AVRCALC[NZ,07] := 0
							
							NZ += 1
						EndDo
					EndIF
				EndIF
			EndIF
			
			NX += 1
		EndDo
	EndIF
EndIF

Return(.T.)
