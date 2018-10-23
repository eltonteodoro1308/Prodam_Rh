#INCLUDE "protheus.ch"

//--------------------------------------------------------------------------
/*{Protheus.doc} F0101305
Funcao executada pela Formula U_VAZERATR
@owner      ademar.fernandes
@author     ademar.fernandes
@since      19/10/2015
@param
@return     lRet
@project    MAN00000011501_EF_013
@version    P 12.1.006
@obs        Observacoes
*/
//--------------------------------------------------------------------------
User Function F0101305()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea := GetArea()

IF Len(AVACALC) > 0

	dbSelectArea("SR0")
	SR0->(dbSetOrder(3))	//-R0_FILIAL+R0_MAT+R0_TPVALE+R0_CODIGO
	SR0->(dbSeek(xFilial("SR0")+SRA->RA_MAT+"2"+SubStr(AVACALC[1,1],10,6),.F.))

	If SR0->(R0_TPVALE = "2" .And. R0_XORIGEM == "P" .And. R0_DPROPIN = 0)

		//# ZERA OS VALORES DO ARRAY AVACALC
		NZ := 1
		While ( NZ <= LEN(AVACALC) )

			AVACALC[NZ,02] := 0
			AVACALC[NZ,03] := 0
			AVACALC[NZ,04] := 0
			AVACALC[NZ,05] := 0
			AVACALC[NZ,06] := 0
			AVACALC[NZ,07] := 0

			NZ += 1
		EndDo
	EndIF
EndIF

RestArea(aArea)
Return(.T.)
