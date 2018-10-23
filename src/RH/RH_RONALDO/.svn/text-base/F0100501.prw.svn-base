#INCLUDE "protheus.ch"

//--------------------------------------------------------------------------
/*{Protheus.doc} F0100501
Funcao executada pela Formula U_AUXAFAST
@owner      ademar.fernandes
@author     ademar.fernandes
@since      29/09/2015
@param      
@return     lRet
@project    MAN00000011501_EF_005
@version    P 12.1.006
@obs        Observacoes
*/
//--------------------------------------------------------------------------
User Function F0100501()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local LCALCULAR := .F.
	Local LGRAVA := .F.
	Local A12AFAST := {}
	Local DINIDATA := CTOD("//")
	Local DFIMDATA := CTOD("//")
	Local dDataIMes := CTOD("//")
	Local dDataAdt := CTOD("//")
	Local CTP2AFAST := ""
	Local NAUX01 := 0
	Local nGRT  := 0
	Local nSal := SRA->RA_SALARIO
	Local nInssAf := nAliqAf := nInssAd := nAliqAd := nPerc := nLinha := 0
	Local cTab := ""
	Local nValor := 0
	Local cTpRais := ""
	Local NSAL := nAfastAno := NAVOSAF2 := 0
	Local NDIASMES := nTempTrab := nTempAfast := nSalmes2 := nAcima := 0
	Local nVlfxAnt := nVlfxAtu := nDPagar := nDFxAtu := nDFxAnt := NPERCAUX02 := nGRTFxAtu := nGRTFxAAnt := ndaux01 := nBase := nDiaFim := nDiasSD := nQtDias := 0
		
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	EndIf
	
	nSalmes2 := SALMES
	
	FRETAFAS(DDATADE, DDATAATE, , , , , @A12AFAST)
	
	If (CTIPOROT $ "5*6")
		CVRBAFAST:= FTABELA("U052", 1, 9, DDATAREF )
		nAfastAno:= FBUSCAACM(CVRBAFAST,,CtoD("01/01/"+Substr(cAnoMes,1,4)),CtoD("31/12/"+Substr(cAnoMes,1,4)),"H")
		DDATADE := CtoD("01/01/"+Substr(cAnoMes,1,4))
		DDATAATE := CtoD("31/12/"+Substr(cAnoMes,1,4))
		FRETAFAS(DDATADE, DDATAATE, , , , , @A12AFAST)
	EndIf
	
	IF ( !EMPTY(A12AFAST) ) .or. nAfastAno > 0
		If EMPTY(A12AFAST) .and. nAfastAno > 0 .and. (CTIPOROT $ "5*6")
			FRETAFAS(CtoD("01/01/"+Substr(cAnoMes,1,4)), CtoD("31/12/"+Substr(cAnoMes,1,4)), , , , , @A12AFAST)
		EndIf
		NY := 1
		While ( NY <= LEN(A12AFAST) )
		
			If Empty(A12AFAST[NY,4])
				A12AFAST[NY,4] := DDATAATE
			EndIf
		
//		IF ( A12AFAST[NY,11] > 15 )
			IF ( A12AFAST[NY,4]-A12AFAST[NY,3]+1 > 15 )
				LCALCULAR := .T.
			EndIF
			
			IF ( A12AFAST[NY,4]-A12AFAST[NY,3]+1 > 15 )
				LCALCULAR := .T.
			EndIF
			
			If cTipoRot = "2" .and. MesAno(A12AFAST[NY,4]) = MesAno(dDataRef) .and. DiasTb >= M_DIASADT
				LCALCULAR := .F.
			EndIf
		
			NY += 1
		EndDo
		
		IF ( LCALCULAR )
		
			NX := 1
			While ( NX <= LEN(A12AFAST) )
			
				DINIDATA := A12AFAST[NX,03]
				DFIMDATA := A12AFAST[NX,04]
				CTP2AFAST := A12AFAST[NX,13]
				CPRORROG := POSICIONE("SR8",6,XFILIAL("SR8")+SRA->RA_MAT+DTOS(DINIDATA)+CTP2AFAST,"R8_XPGAUX")
				cTpRais := A12AFAST[NX,06]
				IF ( CPRORROG $ "1*3" ) .or. (CTIPOROT $ "5*6" .and. nAfastAno > 0)
					NDIAEMP := SR8->R8_DIASEMP
					NSALCALC := SR8->R8_XVLAUX
					NDIASPAG := SR8->R8_DPAGOS
					NDIASSD:= SR8->R8_SDPAGAR
					nDPagar := SR8->R8_DPAGAR
					CTPAFAST := A12AFAST[NX,05]
					dDtIniAf := DINIDATA
					nDiaFim:= Day(DDATAATE)
					dDtFimAf := DDATAATE
					If nDiaFim = 31
						dDtFimAf := dDtFimAf - 1
					ElseIf nDiaFim = 28
						dDtFimAf := dDtFimAf + 2
					ElseIf nDiaFim = 29
						dDtFimAf := dDtFimAf +1
					EndIf
					If !Empty(DFIMDATA)
						If DFIMDATA < DDATAATE
							dDtFimAf := DFIMDATA
						EndIf
					EndIf
					If DINIDATA < DDATADE
						dDtIniAf := DDATADE
					EndIf
//				NDIASTOT := ( (dDtFimAf - DINIDATA) + 1 )
					NDIASAFTOT := ( (dDtFimAf - DINIDATA) + 1 )
					NDIASTOT := ( (dDtFimAf - dDtIniAf) + 1 )
					
					If dDtIniAf >= dDataRef
						If NDIASPAG == 0
							NDIASTOT := ( (dDtFimAf - dDtIniAf) + 1 ) - nDPagar
						Else
							NDIASTOT := ( (dDtFimAf - dDtIniAf) + 1 )// - nDPagar
						EndIf	
					EndIf
					
					If NDIASTOT > NDIASSD
						NDIASTOT := NDIASTOT - NDIASSD
					EndIf
					
						
				//IF ( CTPAFAST == "A" .AND. NDIASTOT > 15 )
					IF (CTPAFAST == "A" .AND. SR8->R8_XPGAUX $ "1/3") .or. (CTIPOROT $ "5*6" .and. nAfastAno > 0)
						NMYDIAS := A12AFAST[NX,02]
					//# POSICIONA NA TABELA U052
//					NAUX01 := FPOSTAB("U052", CTadminP2AFAST, "==", 4, NDIASTOT, "<=", 6)

						If NDIASAFTOT > 365
							nAcima := NDIASAFTOT - 365
							NDIASAFTOT := 365
						EndIf

						NAUX01 := FPOSTAB("U052", CTP2AFAST, "==", 4, NDIASAFTOT, "<=", 6)
						IF NDIASAFTOT > 365 .and. SR8->R8_XPGAUX = "3" .or. (CTIPOROT $ "5*6" .and. nAfastAno <> 0)
							NDIASAFTOT := 365
							NAUX01 := FPOSTAB("U052", CTP2AFAST, "==", 4, NDIASAFTOT, "<=", 6)
						EndIf
						IF ( NAUX01 > 0 )
//						IF ( LCONT := ( NDIASTOT <= 365 ) )
							IF ( LCONT := ( NDIASAFTOT <= 365 ) )
								NPERCAUX := FTABELA("U052", NAUX01, 7, DDATAREF )
								If NAUX01 > 1
									NPERCAUX02 := FTABELA("U052", NAUX01-1, 7, DDATAREF )
									ndaux01 := FTABELA("U052", NAUX01-1, 6, DDATAREF )
														
									If (DINIDATA +  ndaux01) >= dDtIniAf .and. (DINIDATA +  ndaux01) <= dDtFimAf .and. NAUX01 > 1
									//nDFxAnt := ((DINIDATA +  ndaux01) - dDtIniAf + NDIASPAG) - NDIASTOT - 1
										nDFxAnt := Day(dDtFimAf) - (dDtFimAf - (DINIDATA +  ndaux01))
									EndIf
								EndIf
								LGRAVA := .T.
							EndIF
						
							IF ( !LCONT )
								NPERCAUX := 60
								IF ( LACIDTRAB := (ALLTRIM(A12AFAST[NX,16]) == "P1") )
									LGRAVA := .T.
								EndIF
								IF ( !LACIDTRAB )
									IF ( CPRORROG == "3" )
										LGRAVA := .T.
									EndIF
								EndIF
							EndIF
						
							IF ( LGRAVA )
								CVRBAFAST := FTABELA("U052", NAUX01, 9, DDATAREF )
								CVRBMED := FTABELA("U052", NAUX01, 8, DDATAREF )
								nSALMES2 := SALMES
								SALMES := SRA->RA_SALARIO
								cQuery := " SELECT RG1_VALOR FROM " + RetSqlName ("RG1") + " A "
								cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RG1_FILIAL = '"+SRA->RA_FILIAL+"' AND RG1_MAT = '"+SRA->RA_MAT+"' AND RG1_ROT = 'FOL' "
								Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
								dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)
								//TCSetField("TRG1","RG1_VALOR","N")
								SALMES := SALMES + TRG1->(RG1_VALOR)
								nBase := SALMES
								//NSALCALC := IIF(!EMPTY(NSALCALC), (SALMES-NSALCALC), SALMES)
								NDIACALC := IIF(NDIASTOT > 30, 30, NDIASTOT)
//								IF ( LCOND := (NDIACALC < 30) )
//									NDIACALC := (NDIACALC-NDIAEMP)//+NDIASPAG
//								EndIF
//								IF dDtFimAf >= DINIDATA .and. dDtFimAf <= DFIMDATA
//									NDIACALC := Day(dDtFimAf)
//								ENDIF
								cTab   := "U014"
								If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
									nPerc := fTabela(cTab,nLinha,7)
								EndIf
								nDFxAtu := NDIACALC - nDFxAnt - nAcima
								
								If (nDFxAtu + nDFxAnt) < 30 .and. cTipoRot == "2"
									nDFxAtu := (30 - nDFxAnt)
//									nDFxAtu := (30 - nDFxAtu + nDFxAnt) + nDFxAtu + nDFxAnt
								EndIf
								
								nTempTrab := DiasTrab
								nTempAfast := nDiasPg
								
								If !(cTipoRot $ "1/2/3/4/5/6")
									nGRT:= U_f0100204('X')
								EndIf
								
								If cTipoRot $ "1/3/4/5/6"
									nGRT:= U_f0100204('Y')
								EndIf
								
								DiasTrab := nTempTrab
								nDiasPg := nTempAfast
								
								//NVALOR := (NSALCALC / 30 * NDIACALC)
								//NVALOR := nVlfxAtu + nVlfxAnt
								//NVALOR := ROUND((NVALOR*NPERCAUX/100), MSDECIMAIS(1))
								//nGRT := (nGRT / 30 * NDIACALC)
								//nGRTFxAtu := ((nGRT / 30) * nDFxAtu) * NPERCAUX / 100
								//nGRTFxAAnt := ((nGRT / 30) * nDFxAnt) * NPERCAUX02 / 100
								//nGRT := nGRTFxAtu + nGRTFxAAnt
								//nGRT := ROUND((nGRT*NPERCAUX/100), MSDECIMAIS(1))
								
								NMEDIA := IIF( NoRound(((DDATAATE - SRA->RA_ADMISSA)/30),0) < 12, NoRound(((DDATAATE - SRA->RA_ADMISSA)/30),0), 12)
				           	//NADICNOT := FBUSCAACM( FTABELA("U052", NAUX01, 10, DDATAREF ) , , CTOD(SUBSTR(DTOC(DDATADE),1,6)+STR((YEAR(DDATADE)-1),4)), DDATAATE,"H")
								NADICNOT := FBUSCAACM( FTABELA("U052", NAUX01, 10, DDATAREF ) , , CTOD(SUBSTR(DTOC(dinidata),1,6)+STR((YEAR(dinidata)-1),4)), CTOD(STR(DAY(DINIDATA))+"/"+STR(MONTH(DINIDATA)-1)+"/"+STR((YEAR(DINIDATA)),4)),"H")
								NADICNOT := ROUND((NADICNOT / NMEDIA), MSDECIMAIS(1))
								NVALADICNOT := (NADICNOT * SALHORA) * (nPerc/100)
							   //NADICNOT := (NVALADICNOT / 30) * NDIACALC
								//NVALADICNOT := ROUND((NVALADICNOT*NPERCAUX/100), MSDECIMAIS(1))
								//NADICNOT := (NVALADICNOT / 30) * NDIACALC
								nInssAf := nAliqAf := 0
								
								IF (CTIPOROT $ "5*6")
									Calc_Inss(ATINSS13,(nBase+NVALADICNOT+nGRT),@nInssAf,,,,@nAliqAf)
								ELSE
									Calc_Inss(aTInss,(nBase+NVALADICNOT+nGRT),@nInssAf,,,,@nAliqAf)
								ENDIF
								
								NVALOR := nBase - nInssAf + NVALADICNOT + nGRT - NSALCALC

								//If cTipoRot == "2"
								//	NDIACALC := nDFxAtu + nDFxAnt
								//EndIf
								
								IF !(CTIPOROT $ "5*6") .and. cTpRais <> "10"
									nVlfxAtu:= ((NVALOR / 30) * nDFxAtu) * NPERCAUX / 100
									nVlfxAnt:= ((NVALOR / 30) * nDFxAnt) * NPERCAUX02 / 100
									NVALOR := nVlfxAtu + nVlfxAnt
								ELSE
									If nAfastAno >= 365 .or. DINIDATA < CtoD("01/01/"+Substr(cAnoMes,1,4))
										NAVOSAF2 := Round(nAfastAno,-1) / 30
										If NAVOSAF2 > 1
											NAVOSAF2 := Int(NAVOSAF2)
										EndIf
										If NAVOSAF2 > 0 .and. NAVOSAF2 < 1
											NAVOSAF2 := 1
										EndIf
									Else
										NAVOSAF2 := NAVOSAF
									EndIf
									If cTpRais <> "10"
									NVALOR := (NVALOR / 12) * NAVOSAF2
									nDFxAtu := NAVOSAF2
									nDFxAnt := 0
									EndIf
								ENDIF
													
								///nInssAf := (nInssAf / 30 * NDIACALC)
								//NADICNOT := (NVALADICNOT / 30) * NDIACALC
								//nGRT := (nGRT / 30) * NDIACALC
								//NVALOR := NVALOR - nInssAf + NADICNOT + nGRT
														
							//# GRAVA O COMPLEMENTO DO AUXILIO                       
								nQtDias := (nDFxAtu + nDFxAnt)
									If nQtDias < 0
										nQtDias := 0
									EndIf
								IF (!EMPTY(CVRBAFAST) .AND. NVALOR > 0 ) .and. cTipoRot <> "2" .and. cTipoRot <> "3" .and. cTipoRot <> "6"
									FGERAVERBA(CVRBAFAST, NVALOR, nQtDias)
								ElseIf cTipoRot == "6"
									FGERAVERBA("041", NVALOR, nQtDias)
								ELSEIF (cTipoRot $ "2" .or. cRot $ "ADI") .and. SR8->R8_XPGAUX $ "1/3/4"
									SALMES := NVALOR
									dDataAdt:= aPeriodo[1][17]
									dDataIMes:= aPeriodo[1][3]
									If DINIDATA >= dDataIMes .and. DINIDATA <= dDataAdt
										SALMES := SRA->RA_SALARIO
									EndIf
								ELSEIF cTipoRot == "3"
								ElseIf cTipoRot == "6"
									N13SAL := NVALOR * (nAvos/12)
								EndIF
							
/*							//# CALCULA MEDIA DE ADICIONAL NOTURNO
							NMEDIA := IIF( NoRound(((DDATAATE - SRA->RA_ADMISSA)/30),0) < 12, NoRound(((DDATAATE - SRA->RA_ADMISSA)/30),0), 12)
							NADICNOT := FBUSCAACM( FTABELA("U052", NAUX01, 10, DDATAREF ) , , CTOD(SUBSTR(DTOC(DDATADE),1,6)+STR((YEAR(DDATADE)-1),4)), DDATAATE)
							NADICNOT := ROUND((NADICNOT / NMEDIA), MSDECIMAIS(1))
							NADICNOT := NADICNOT / 30 * NDIACALC									
							Calc_Inss(aTInss,NADICNOT,@nInssAd,,,,@nAliqAd)
							nInssAd := (nInssAd / 30 * NDIACALC)
							NADICNOT := NADICNOT - nInssAd
							//# GRAVA A MEDIA DE ADIC. NOTURNO
							IF ( !EMPTY(CVRBMED) .AND. NADICNOT > 0 ) .and. cTipoRot == "2"
								FGERAVERBA(CVRBMED, NADICNOT)
							EndIF */
							EndIF
						EndIF
					EndIF
				EndIF
				NX += 1
			EndDo
			IF (cTipoRot == "2" .AND. NVALOR == 0 .and. SRA->RA_SITFOLH == "A" .and. cTpRais $ "10/20/30/40/60/70" .and. SR8->R8_XPGAUX <> "4" .AND. NDIASPG == 0) //.or. (cTipoRot == "2" .AND. NVALOR == 0 .and. SRA->RA_SITFOLH == "A" .and. SR8->R8_XPGAUX == "2")
				//SALMES := NVALOR
				CALCULE := "N"
				NoPrcReg()
			ENDIF
		EndIF
	EndIF
	If cTipoRot <> "2"
		SALMES := nSALMES2
	EndIf
Return(.T.)
