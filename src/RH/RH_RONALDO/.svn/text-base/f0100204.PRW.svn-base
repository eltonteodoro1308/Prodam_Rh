#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} f0100204()

@Project     MAN00000011501_EF_002
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return
@Param       cOrigem - Informa origem da chamada da funcao
@Obs         Função para Geração da verba Gratificacao de função - chamada do roteiro de calculo
/*/

user function f0100204(cOrigem)

	local cQuery := ''
	local aGrat  := {}
	local aTemp  := {}
	local nVLRGR := 0
	local nDIAS  := 0
	local nPredial:=0
	Local aArea 	:= GetArea()
	Local nA     := 0
	Local nNivel := 0
	Local nAfast := 0
	Local nMult  := 0
	Local dInicio := StoD("")
	Local dFim    := StoD("")
	Local dDatIni := StoD("")
	Local nX := 0
	Local aAfastamento := {}
	Local nDiasAfast := 0
	Local nVLRGRNP := 0
	Local nMesAtu := 0
	Local nMesSeg := 0
	Local dDtIni := CtoD("//")
	Local dDtFim := CtoD("//")
	Local cAvulso := ftabela('U050',02,06)
	Local nSeq := 1
	Local nDiasT := 0
	Local nTotalT := 0
	Local nTotal := 0
	Local nGratAno := 0
	Local nGratMes := 0
	Local nGratDia := 0
	Local nVLRGRTT := nDiasTT := 0

	If cOrigem = "P" .or. cOrigem = "X"
		Private P_QTDIAMES := 30
		Private NDPRGSALMA := 0
		Private NDIASC := 0
		Private DPERFIM := CTOD("//")
		Private cSemana := "01"
		DDATAREF:= DDATABASE
		M->P_QTDIAMES
		M->NDPRGSALMA
		M->NDIASC
		M->DPERFIM
		M->CSEMANA
	EndIf
	
	dDtIni:= RCH->RCH_DTINI
	dDtFim := RCH->RCH_DTFIM
	
	If (cOrigem = "P" .or. cOrigem = "X") 
		cRot := ""
		dDataDem := CtoD("//")
		nDiasMes := 0
		dDtIni := CtoD("01/"+Str(Month(dDataBase))+"/"+Str(Year(dDataBase)))
		dDtFim := dDataBase
	EndIf

	cQuery := " SELECT PA2_MAT MATR, RA_NOME NOME, PA2_TEMPO TEMPO, RA_SALARIO SALARIO, PA2_OPCDIR OPCDIR, PA2_DATAIN INICIO, PA2_DATFIM FINAL, PA2_TIPO TIPO, PA2_ANO ANO, PA2_MES MES, PA2_DIA DIA, "
	cQuery += " PA2_GRUPO GRUPO, RA_XTPCONT TPCONTR, PA0_GRPGRT TPGRUPO, PA1_VLNIV1 NIVEL1, PA1_VLNIV2 NIVEL2, PA1_VLMIN VLRMIN, PA2_MATSUB MATS, RA_SITFOLH SITUACA "
	cQuery += " FROM " + RetSqlName ("PA2")+" A "
	//cQuery += " INNER JOIN " + RetSqlName ("SRA") + " B ON RA_FILIAL=PA2_FILIAL AND RA_MAT = PA2_MAT AND RA_SITFOLH <> 'D' AND B.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN " + RetSqlName ("SRA") + " B ON RA_FILIAL=PA2_FILIAL AND RA_MAT = PA2_MAT AND B.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN " + RetSqlName ("PA0") + " C ON PA0_FILIAL=PA2_FILIAL AND PA0_GRUPO = PA2_GRUPO AND C.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN " + RetSqlName ("PA1") + " D ON PA1_FILIAL=PA2_FILIAL AND PA1_GRUPO = PA2_GRUPO AND D.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
	cQuery += " AND PA2_DATAIN <= '"+DTOS(dDtFim)+"' AND PA2_MAT = '"+SRA->RA_MAT+"' "
	cQuery += " AND PA2_TIPO = '1' "

	Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

	Do while !TRG1->(eof())
		
		lMuda := .F.
		
		If empty(TRG1->FINAL)
			dFim := dDtFim // data final não pode ser em branco
		ElseIf TRG1->FINAL < DTOS(dDtIni)
			TRG1->(DBSKIP())
			Loop
		Else
			dFim := Stod(TRG1->FINAL)
		EndIf
		
		If cRot == 'RES' .And. cOrigem <> "P" .and. cOrigem <> "X"//cTipoRot == 'RES'//"4" //'RES'
			dFim		:= Min(dDataDem,dFim) // pega o menor entre a demissão e o fim da gratificação
		EndIf

		nVLRGR 	:= 0
		dInicio := Max( dDtIni , STOD(TRG1->INICIO))
		dFim	:= Min( dDtFim , dFim )
		
		If dInicio < dFim
		nDias := Min(dFim - dInicio+1,30)
		Else
		nDias := Day(dFim)
		EndIf
		
		If Month2Str(RCH->RCH_DTFIM) $ "02" .and. nDias = 28
			nDias := nDias + 2
		EndIf
		
		If Month2Str(RCH->RCH_DTFIM) $ "02" .and. nDias = 29
			nDias := nDias + 3
		EndIf
		
		If cRot == 'RES' .And. cOrigem <> "P" .and. cOrigem <> "X"
			nDias := Min(nDias,DiasTrab)
		EndIf

		CVRBAFAST := FTABELA("U052", 1, 9, DDATAREF )
	
		If cOrigem <> "P" .and. cOrigem <> "X"
//	If cOrigem <> "X" 
			nDiasAux := fBuscaPd(CVRBAFAST,"H",cSemana)
				
			If (Day(RCH->RCH_DTFIM) == 31 .and.  STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM) .or. (Day(RCH->RCH_DTFIM) == 31 .and.  STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. nDiasP = 31) .and. cRot <> "RES"
				nDias := nDias - 1
			ElseIf (Day(RCH->RCH_DTFIM) == 28 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM) .or. (Day(RCH->RCH_DTFIM) == 28 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. nDiasP = 28) .and. cRot <> "RES"
				nDias := nDias + 2
			ElseIf (Day(RCH->RCH_DTFIM) == 29 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. STOD(TRG1->FINAL) >= RCH->RCH_DTFIM) .or. (Day(RCH->RCH_DTFIM) == 29 .and. STOD(TRG1->INICIO) > RCH->RCH_DTINI .and. nDiasP = 29) .and.  cRot <> "RES"
				nDias := nDias + 1
			EndIf

			nDias:= nDias - nDiasAux
		EndIf
			
		IF TRG1->SITUACA = 'A' .and. cOrigem <> "P" .and.  (cOrigem = "X" .or. cOrigem = "R")
			fRetAfas(dInicio, dFim, , , , , @aAfastamento)
			
			for nX:= 1 to Len(aAfastamento)
				If aAfastamento[nX][6] =='70' // -- Código 70 desconta
					nDiasAfast += aAfastamento[nX][2]
				Else
					//nDiasPg := fBuscaPd(aAfAstamento[nx][12],'H',cSemana)
					nDiasPg := fBuscaPd(aAfAstamento[nx][12],'H')
//					If aAfastamento[nX][2] > nDiasPg .and. aAfastamento[nX][6] <> '50'
//						nDiasAfast += (aAfastamento[nX][2] - nDiasPg)
//					EndIf
				EndIF
				nDias := nDias - nDiasAfast
			next
			
			
		ElseIf TRG1->SITUACA = 'F' .and. cRot = 'FOL'//cTipoRot = "1" //'FOL'
			nDias := Min(DiasTrab , nDias)
		ENDIF
		
		If (cOrigem = "P" .or. cOrigem = "X")// .and. cTipoRot <> "C" //(TRG1->SITUACA = 'F' .or. TRG1->SITUACA = 'A')
			nDias := 30
		EndIf
		
		nMult:= (nDIAS - nDiasMes) /30
		
		// verifica o tipo de contrato
//		If TRG1->TPCONTR = '1'
			nTempo := GETNEWPAR('FS_NIVGRAT',60)
			nGratAno := GETNEWPAR('MV_GRATANO',4)
			nGratMes := GETNEWPAR('MV_GRATMES',11)
			nGratDia := GETNEWPAR('MV_GRATDIA',30)
			
		/*	If  TRG1->TEMPO == (nTempo -1)
				//-- 59 meses, muda de faixa no meio do período
				//--Identificar a data de aniversário
				cQuery := " SELECT PA2_DATAIN INICIO "
				cQuery += " FROM " + RetSqlName ("PA2")+" A "
				cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
				cQuery += " AND PA2_MAT = '"+SRA->RA_MAT+"' "
				cQuery += " AND PA2_GRUPO = '"+TRG1->GRUPO +"'"
				cQuery += " AND PA2_TIPO = '1' "
				cQuery += " ORDER BY PA2_DATAIN"
				
				Iif( Select("TRG2") > 0,TRG2->(dbCloseArea()),Nil)
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG2",.F.,.T.)
			
				If !TRG2->(eof())
					dDatIni := Stod(TRG2->INICIO)
					If (lMuda := dDatIni > dInicio .and. dDatIni < dFim)
						nNivel := (TRG1->NIVEL1*(dDatIni - dInicio + 1) - TRG1->SALARIO +TRG1->NIVEL2*(dFim - (dDatIni+1) + 1 ))/nDias
						
						nVlrGr := ((dDatIni - dInicio + 1)*(TRG1->NIVEL1-TRG1->SALARIO) + (dFim - (dDatIni+1) + 1 )* (TRG1->NIVEL2-TRG1->SALARIO))/nDias
					EndIf
				 Endif */
//		EndIf
			
		If !lMuda
/*				If TRG1->TEMPO < nTempo
					nNivel:= TRG1->NIVEL1
				Else
					nNivel:= TRG1->NIVEL2
				EndIf
			Endif */
			If TRG1->ANO <= nGratAno .and. TRG1->MES <= nGratMes .and. TRG1->DIA < nGratDia
				nNivel:= TRG1->NIVEL1
			Else
				nNivel:= TRG1->NIVEL2
			EndIf
		Endif
		//Else
		IF TRG1->OPCDIR = "1" .and. TRG1->ANO <= nGratAno .and. TRG1->MES <= nGratMes .and. TRG1->DIA < nGratDia
			nNivel:= TRG1->NIVEL1
		ELSEIF TRG1->OPCDIR = "1" .and. TRG1->ANO > nGratAno
			nNivel:= TRG1->NIVEL2
		ELSEIF TRG1->OPCDIR = "2"
			nNivel:= TRG1->NIVEL2
		EndIf
	//	EndIf
		
		If !lMuda
			IF nNivel > TRG1->SALARIO
				nVLRGR := ABS(nNivel - TRG1->SALARIO)
			Endif
		EndIf
		
		If cRot <> "FOL" .and. cRot <> "FER"
			cQuery2 := " SELECT RGB_VALOR FROM " + RetSqlName ("RGB") + " A "
			cQuery2 += " WHERE A.D_E_L_E_T_ <> '*' AND RGB_FILIAL = '"+SRA->RA_FILIAL+"' AND RGB_MAT = '"+SRA->RA_MAT+"' AND RGB_ROTEIR = 'FOL' AND RGB_PD ='"+cAvulso+"'
			Iif( Select("TRG2") > 0,TRG2->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery2),"TRG2",.F.,.T.)
		
			nVLRGR := nVLRGR + TRG2->(RGB_VALOR)
		EndIf
		
		iF nVLRGR < TRG1->VLRMIN .and. SRA->RA_XTPCONT = "1"
			nVLRGR := TRG1->VLRMIN
		EndIf
		
		If cRot == 'FER'
			nDIAS  := M->RH_DFERIAS
			nVLRGRNP := nVLRGR
			//nVLRGR := nVLRGR * (nDIAS)/30
			nMesAtu := (nVLRGR / 30) * (nDiasFM)
			nMesSeg := (nVLRGR / 30) * (nDiasFMS)
			nVLRGR := nMesAtu + nMesSeg
/*		ElseIf cRot == '132'//"6" //'132'
			nDIAS  := nAvos
			
		nVLRGR := 0	
		nVLRGR := nVLRGR + FBUSCAACM("033" , ,(dDataRef - 335), (dDataRef),"V") + ;
		FBUSCAACM("034" , ,(dDataRef - 335), (dDataRef),"V") + ;
		FBUSCAACM("038" , ,(dDataRef - 335), (dDataRef),"V") + ;
		FBUSCAACM("036" , ,(dDataRef - 335), (dDataRef),"V") + ;
		FBUSCAACM("433" , ,(dDataRef - 335), (dDataRef),"V") + ;
		FBUSCAACM("633" , ,(dDataRef - 335), (dDataRef),"V")
		nVLRGR := nVLRGR /12
			
			nVLRGR := nVLRGR * (nAvos/12)
*/		ElseIf cOrigem == 'S'
			nVLRGRNP := nVLRGR
			nVLRGR := nVLRGR
		Else//RES
			nVLRGRNP := nVLRGR
			nVLRGR := nVLRGR * nMult
		Endif
			
		If TRG1->ANO = nGratAno .and. TRG1->MES = nGratMes
			nDiasT1 := 30 - TRG1->DIA
			nVLRGRT1 := (ABS(TRG1->NIVEL1 - TRG1->SALARIO)/30)*nDiasT1
			nDiasT2 := nDias - nDiasT1
			nVLRGRT2 := (ABS(TRG1->NIVEL2 - TRG1->SALARIO)/30)*nDiasT2
			nVLRGR := (nVLRGRT1 + nVLRGRT2) * nMult
			nDias := nDiasT1 + nDiasT2
		EndIf
		
		aAdd(aGrat,{TRG1->MATR,TRG1->TPGRUPO,nVLRGR,nDIAS})

///		TRG1->(DBSKIP())
///	Enddo
	
		If len(aGrat) == 0 .and. cRot == 'RES'
		//-- Query na SRD para verificar se nos ultimos n meses houve gratificação
			nMeses := GETNEWPAR('FS_RESGRAT',6)
		
			cQuery:=" SELECT "
			cQuery+="    SRD.RD_VALOR "
			cQuery+=" FROM "+ RetSqlName("SRD") + " SRD "
			cQuery+=" WHERE "
			cQuery+="        SRD.RD_FILIAL  = '"+xFilial("SRD")+"' "
			cQuery+="    AND SRD.RD_MAT = '"+ SRA->RA_MAT +"'"
			cQuery+="    AND SRD.RD_PD   ='"+ ftabela("U050",01,06) +"'"
			cQuery+="    AND SRD.RD_DATARQ   BETWEEN '" + Left(Dtos(dDataBase - nMeses*30),6) +  "' AND '"+ Left(Dtos(dDataBase),6)+"'"
			cQuery+="    AND SRD.D_E_L_E_T_ = ' ' "
			cQuery+="    ORDER BY RD_VALOR "
		
			Iif( Select("TRG3") > 0,TRG3->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG3",.F.,.T.)
	
			nDias := dDataDem - dDtIni + 1
		
			If !TRG3->(eof())
			 
				nVlrGr := (TRG2->RD_VALOR/RG2->RD_HORAS)*30 //-- proporcionaliza para 30 novamente
			
				nVlrGr := nVlrGr * nDias /30
			
				aAdd(aGrat,{SRA->RA_MAT,'',nVlrGr,nDias})
			Endif
		EndIf
	
		nPredial	:=0
		nTotal		:=0
	
		if len(aGrat) > 0
			aTemp:=aSort(aGrat,,,{|x,y| x[3]>y[3]})

			For nA := 1 to len(aTemp)
				If aTemp[nA][2] = '1'
					nPredial+=aTemp[nA][3]
				endif
			Next

			if aTemp[1][2] = '1' .and. len(aTemp) > 1
				nTotal := aTemp[2][3]
				nDias    := aTemp[2][4]
			else
				if aTemp[1][2] = '1'
					nPredial := aTemp[1][3]
				ELSE
					nTotal   := aTemp[nSeq][3]
					nDias    := aTemp[nSeq][4]
				endif
			endif

			nTotal:=nTotal+nPredial

/*		IF nTotal > 0 .and. cOrigem = 'R'
			IF cRot == "FER" //'FER'
		//	fGERAVERBA(ftabela("U050",04,06),nTotal,nDIAS,,,"V","G",)
				fGERAVERBA(ftabela("U050",04,06),nMesAtu,nDiasFM,,,"V","G",,,,,nSeq,)
				fGERAVERBA(ftabela("U050",08,06),nMesSeg,nDiasFMS,,,"V","G",,,,,nSeq,)
				fGERAVERBA(ftabela("U050",07,06),nVLRGRNP,30,,,"V","G",,,,,nSeq,)
			ElseIF cRot == "RES" //'RES'
				fGERAVERBA(ftabela("U050",05,06),nTotal,nDIAS,,,"V","G",,,,,nSeq,)
				fGERAVERBA(ftabela("U050",07,06),nVLRGRNP,30,,,"V","G",,,,,nSeq,)
			ElseIF cRot == "132" //'132'
				fGERAVERBA(ftabela("U050",06,06),nTotal,nDIAS,,,"V","G",,,,,nSeq,)
			Else
				fGERAVERBA(ftabela("U050",01,06),nTotal,nDIAS,,,"V","G",,,,,nSeq,)
			EndIf
		ENDIF */
		endif
		
		nDiasT := nDiasT + nDias
		nTotalT := nTotalT + nTotal
		
//		nSeq++
		TRG1->(DBSKIP())
	Enddo

	IF nTotal > 0 .and. cOrigem = 'R'
		IF cRot == "FER" //'FER'
		//	fGERAVERBA(ftabela("U050",04,06),nTotal,nDIAS,,,"V","G",)
			fGERAVERBA(ftabela("U050",04,06),nMesAtu,nDiasFM,,,"V","G",,,,,nSeq,)
			fGERAVERBA(ftabela("U050",08,06),nMesSeg,nDiasFMS,,,"V","G",,,,,nSeq,)
			fGERAVERBA(ftabela("U050",07,06),nVLRGRNP,30,,,"V","G",,,,,nSeq,)
		ElseIF cRot == "RES" //'RES'
			fGERAVERBA(ftabela("U050",05,06),nTotalT,nDiasT,,,"V","G",,,,.T.,nSeq,)
			fGERAVERBA(ftabela("U050",07,06),nVLRGRNP,30,,,"V","C",,,,.T.,nSeq,)
//			SALMES := SALMES - nVLRGRNP
		ElseIF cRot == "132" //'132'
			fGERAVERBA(ftabela("U050",06,06),nTotal,nDIAS,,,"V","G",,,,,nSeq,)
		ElseIf SRA->RA_SITFOLH = 'F'
			fGERAVERBA(ftabela("U050",01,06),nTotal,nDIAS,,,"V","G",,,,,nSeq,)
		Else
			fGERAVERBA(ftabela("U050",01,06),nTotalT,nDIAST,,,"V","G",,,,,nSeq,)
		EndIf
	ENDIF
	
	
	Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
	
	RestArea( aArea )

Return(IIF(cORIGEM="R",.T.,nTotal))
