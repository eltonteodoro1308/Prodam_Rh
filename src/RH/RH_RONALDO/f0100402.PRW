#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} f0100402()

@Project     MAN00000011501_EF_004
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return
@Obs         Função para Geração da verba Gratificacao de função - chamada do roteiro de calculo , para substituicoes
/*/

user function f0100402(cOrigem)

	local cQuery := ''
	local aGrat  := {}
	local aTemp  := {}
	local nVLRGR := 0
	local nDIAS  := 0
	local nPredial:=0
	Local aArea 	:= GetArea()
	Local lFarol := .t.
	Local dFim 	:= stod("")
	Local dInicio := stod("")
	Local nMult	:= 0
	Local nX := 0
	Local nGrat := 0
	Local nTotal := 0
	Local nValMin := 0
	Local cAvulso := ftabela('U050',02,06)
	Local nAvulso := 0

	cQuery := " SELECT PA2_MATSUB MATR, RA_NOME NOME, PA2_TEMPO TEMPO, RA_SALARIO SALARIO, PA2_OPCDIR OPCDIR, PA2_DATAIN INICIO, PA2_DATFIM FINAL, PA2_TIPO TIPO, "
	cQuery += " PA2_GRUPO GRUPO, RA_XTPCONT TPCONTR, PA0_GRPGRT TPGRUPO, PA1_VLNIV1 NIVEL1, PA1_VLNIV2 NIVEL2, PA1_VLMIN VLRMIN, PA2_MATSUB MATS "
	cQuery += " FROM " + RetSqlName ("PA2")+" A "
	cQuery += " INNER JOIN " + RetSqlName ("SRA") + " B ON RA_FILIAL=PA2_FILIAL AND RA_MAT = PA2_MAT AND RA_SITFOLH <> 'D' AND B.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN " + RetSqlName ("PA0") + " C ON PA0_FILIAL=PA2_FILIAL AND PA0_GRUPO = PA2_GRUPO AND C.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN " + RetSqlName ("PA1") + " D ON PA1_FILIAL=PA2_FILIAL AND PA1_GRUPO = PA2_GRUPO AND D.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
	cQuery += " AND PA2_DATAIN <= '"+DTOS(RCH->RCH_DTFIM)+"' AND PA2_DATFIM >= '"+DTOS(RCH->RCH_DTINI)+"' AND PA2_MAT = '"+SRA->RA_MAT+"' "
	cQuery += " AND PA2_TIPO = '2' "

	/*
	cQuery += " AND PA2_DATFIM >= '"+DTOS(RCH->RCH_DTINI)+"' "
	*/

	Iif( Select("TRG3") > 0,TRG3->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG3",.F.,.T.)

	dbSelectArea("TRG3")
	dbgotop()

	IF ALLTRIM(TRG3->MATR) <> '' .and. TRG3->TIPO == '2'

		Do while !TRG3->(eof()) .and. TRG3->TIPO == '2'

			nVLRGR 	:=0
			dInicio 	:= Max( RCH->RCH_DTINI , STOD(TRG3->INICIO))
			dFim		:= Min( RCH->RCH_DTFIM , STOD(TRG3->FINAL))
			
			If cTipoRot == "4" //'RES'
				dFim		:= Min(dDataDem,dFim) // pega o menor entre a demissão e o fim da gratificação
			EndIf
		
			nDias := Min(dFim - dInicio +1,30)
/*			
			If Day(RCH->RCH_DTFIM) == 31 .and.  STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM
				nDias := nDias - 1	
			ElseIf Day(RCH->RCH_DTFIM) == 28 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM
				nDias := nDias + 1
			ElseIf Day(RCH->RCH_DTFIM) == 29 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM
				nDias := nDias + 2
			EndIf
*/						
			nMult:= nDIAS/30

			IF TRG3->NIVEL1>TRG3->SALARIO
				nVLRGR := ABS(TRG3->NIVEL1 - TRG3->SALARIO)
			EndIf

			cQuery2 := " SELECT RGB_VALOR FROM " + RetSqlName ("RGB") + " A "
			cQuery2 += " WHERE A.D_E_L_E_T_ <> '*' AND RGB_FILIAL = '"+SRA->RA_FILIAL+"' AND RGB_MAT = '"+SRA->RA_MAT+"' AND RGB_ROTEIR = 'FOL' AND RGB_PD ='"+cAvulso+"'
			Iif( Select("TRG2") > 0,TRG2->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery2),"TRG2",.F.,.T.)	
			nAvulso := TRG2->(RGB_VALOR)
						
			IF TRG3->TPCONTR <> "2"
				nValMin := TRG3->VLRMIN
				nGrat := U_f0100204('S')				
				
				nVLRGR := (nVLRGR - nGrat - nAvulso) * nMult
				IF nVLRGR < nValMin  * nMult
					nVLRGR := nValMin * nMult
				EndIf
			Else
				nGrat := U_f0100204('S')
				nVLRGR := (nVLRGR - nGrat - nAvulso) * nMult
			EndIf
			
			aAdd(aGrat,{TRG3->MATR,TRG3->TPGRUPO,nVLRGR,nDIAS})
		TRG3->(DBSKIP())
		Enddo

		nTotal:=0
		nDIAS :=0

		if len(aGrat) > 0
			for nX:= 1 to Len(aGrat)
				nTotal += aGrat[nX][3]
				nDIAS  += aGrat[nX][4]
			next
			 
			fGERAVERBA(ftabela("U050",03,06),nTotal,nDIAS,,,"V","G",)
		endif
	ENDIF

Iif( Select("TRG3") > 0,TRG3->(dbCloseArea()),Nil)
	RestArea( aArea )

Return(IIF(cORIGEM="R",.T.,nTotal))