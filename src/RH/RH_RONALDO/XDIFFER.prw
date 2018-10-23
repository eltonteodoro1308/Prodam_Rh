/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction³fCDifFerias    ºAutor  ³Leandro Drumond  º Data ³ 06/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Verifica existencia de diferenca de ferias				      º±±
±±º        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ Roteiro de Calculo - Folha                                   º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function XDIFFER()
Local aArea			:= GetArea()
Local aSaveMnemo	:= {}
Local aGrvFer		:= {}
Local aPdMSeg		:= {}
Local cDataRef		:= If(cTipoRot == "4", AnoMes(dDataDem),AnoMes(dDataDe)) //Inicio do periodo   
Local cTpRotSv		:= cTipoRot
Local dDtMesSeg		:= CtoD("")
Local lGeraDif		:= .F.
Local lFirst		:= .T.
Local nElem			:= 0
Local nElem1		:= 0
Local nCount		:= 0
Local nPos			:= 0
Local nPosAux		:= 0
Local nDiasMes		:= 0
Local nDiasMse		:= 0
Local nTamAux		:= 0
Local nOrderSRR		:= RetOrder("SRR","RR_FILIAL+RR_MAT+RR_PERIODO+RR_ROTEIR+RR_SEMANA+RR_PD+RR_CC+RR_ITEM+RR_CLVL+RR_SEQ+DTOS(RR_DATA)")
Local lsvDissidio	
Local aPdFer		:= {}
Local dDtFim		
Local dDtIni
Local nSalDif		:= 0
Local cCodMedFer	:= aCodFol[75,1] +'*'+aCodFol[76,1]+'*'+;  	//Media de ferias
						aCodFol[343,1]+'*'+	aCodFol[344,1]+'*'+;//Media de ferias Comissionados
						aCodFol[345,1]+'*'+aCodFol[346,1]+'*'+; //Media de ferias Tarefeiros
						aCodFol[636,1]+'*'+aCodFol[637,1]+'*'+; //Media de ferias Professor
						aCodfol[82,1] +'*'+aCodFol[83,1]		//Medias s/ Horas Extras
Local aApdX_ := aclone(aPd)
Private aDif_Fer		:= {}

lDissidio 	:= If( type("lDissidio")=="U",.F.,lDissidio)
lsvDissidio	:= lDissidio
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera o array aDifFer com os periodos de ferias no mes para nao ³
//³haver duplicidade de calculo na diferenca durante a rescisao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If cTipoRot == "4"
	aDifFer		:= {}  //Mnemonico
Endif

DbSelectArea("SRR")
DbSelectArea("SRH")

If DbSeek(SRA->RA_FILIAL+SRA->RA_MAT) 
	While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRH->RH_FILIAL+SRH->RH_MAT
		If AnoMes(SRH->RH_DATAINI) == cDataRef .or. AnoMes(SRH->RH_DATAFIM) == cDataRef .or. ( SRH->RH_ABOPEC <> "1"  .and. AnoMes(SRH->RH_DATAFIM + SRH->RH_DABONPE) == cDataRef )
			
			
			//-- Gera aDifFer que sera utilizado no calculo do INSS
			nDiasMse := 0

			If Month(dDataDe) < 12
				dDtMesSeg 	:= CtoD("01/"+StrZero(Month(dDataDe)+1,2)+"/"+StrZero(Year(dDataDe),4),"DDMMYY")
			Else
				dDtMesSeg 	:= CtoD("01/01/"+StrZero(Year(dDataDe)+1,4),"DDMMYY")
			Endif				
			
			If Month(SRH->RH_DATAINI)==Month(SRH->RH_DATAFIM) .And. Year(SRH->RH_DATAINI) == Year(SRH->RH_DATAFIM)
				nDiasMse	:= 0
			Else
				If MesAno(SRH->RH_DATAFIM) > MesAno(dDtMesSeg)
					nDiasMse 	:= f_UltDia(dDtMesSeg)
					If Month(SRH->RH_DATAINI) == 1 .And. Month(SRH->RH_DATAFIM) == 3
						nDiasMse := nDiasMse + Day(SRH->RH_DATAFIM) 
					EndIf
				Else	
					nDiasMse 	:= Day(SRH->RH_DATAFIM) - SRH->RH_DIALRE1
				Endif   
			EndIf  
			
			If lFirst
				//Se foi pago abono pecuniário apóso período de férias, soma os dias de abono da data fim
				dDtFim	:= If(SRH->RH_DABONPE > 0 .and. SRH->RH_ABOPEC <> '1', SRH->RH_DATAINI + SRH->RH_DFERIAS + SRH->RH_DABONPE ,SRH->RH_DATAFIM) 
				dDtIni	:= SRH->RH_DATAINI
				nSalDif	:= SRH->RH_SALDIF
				lFirst	:= .F.
			EndIf
			
			Aadd(aDifFer,{ SRH->(Recno()) , nDiasMes , nDiasMse })
			//--Fim geracao aDifFer
            If !lDissidio
				If SRA->RA_CATFUNC == "C"  
					// Se comissionista puro
					lGeraDif := If (SRA->RA_SALARIO == 0, .T., .F.)
				Else
					If MesAno(dDtIni) == cPeriodo
						lGeraDif := ( SRH->RH_SALARIO > 0 .AND. SRH->RH_SALARIO <> SRA->RA_SALARIO ) .OR. P_LDIFMED
					ElseIf MesAno(dDtFim) == cPeriodo
						lGeraDif := ( SRH->RH_SALDIF > 0 .AND. SRH->RH_SALDIF <> SRA->RA_SALARIO ) .OR. P_LDIFMED
					EndIf
				EndIf
			Else
				lGeraDif := !Empty(SRH->RH_SALARIO) .AND. SRH->RH_SALARIO <> SALARIO				
			EndIf  
					
			If lGeraDif
                
				aDif_Fer := {}
				
				SRR->(DbSetOrder(nOrderSRR))
				If SRR->(DbSeek(SRH->(RH_FILIAL+RH_MAT+RH_PERIODO+RH_ROTEIR+RH_NPAGTO)))
					While SRR->(!Eof() .and. RR_FILIAL + RR_MAT + RR_PERIODO + RR_ROTEIR + RR_SEMANA == SRH->RH_FILIAL + SRH->RH_MAT + SRH->RH_PERIODO + SRH->RH_ROTEIR + SRH->RH_NPAGTO )
						If ( SRH->RH_DTRECIB == SRR->RR_DATAPAG )
							aAdd(aDif_Fer,{SRR->RR_PD,SRR->RR_VALOR,0,0,0})
						EndIf
						SRR->(DbSkip())
					EndDo
				EndIf
				
				If !Empty(aDif_Fer)
				
					If Empty(aSaveMnemo)
						aSaveMnemo	:= SaveMnemonicos() //Salva os mnemonicos utilizados no calculo da folha
					EndIf
					
					SetMnemonicos(NIL,NIL,.T.) //Reseta mnemonicos    
					
					cRotPr			:= cTpRotSv	// Grava Roteiro Primario
					
					cRot			:= SRH->RH_ROTEIR
					cPeriodo		:= SRH->RH_PERIODO
					cNumPag			:= SRH->RH_NPAGTO
					cProcesso		:= SRA->RA_PROCES
					cTipoRot		:= "3" //Ferias
					lCalcFol		:= .T.	//Indica que esta calculando a folha de pagamento, para executar apenas parte do roteiro de feriias
					
					//Carrega variaveis na memoria para utilizacao no roteiro de ferias
					SetMemVar( "RH_DTRECIB" ,SRH->RH_DTRECIB ,.T.)
					SetMemVar( "RH_DATAINI" ,SRH->RH_DATAINI ,.T.)
					SetMemVar( "RH_DATAFIM" ,SRH->RH_DATAFIM ,.T.)
					SetMemVar( "RH_PERC13S" ,SRH->RH_PERC13S ,.T.)
					SetMemVar( "RH_DFERIAS" ,SRH->RH_DFERIAS ,.T.)
					SetMemVar( "RH_DABONPE" ,SRH->RH_DABONPE ,.T.)
					SetMemVar( "RH_DFERVEN" ,SRH->RH_DFERVEN ,.T.)
					SetMemVar( "RH_DBASEAT" ,SRH->RH_DBASEAT ,.T.)
					SetMemVar( "RH_DATABAS" ,SRH->RH_DATABAS ,.T.)
					SetMemVar( "RH_ABOPEC"  ,SRH->RH_ABOPEC  ,.T.)
					SetMemVar( "RH_DIALRE1" ,SRH->RH_DIALRE1 ,.T.)
					SetMemVar( "RH_DIALREM" ,SRH->RH_DIALREM ,.T.)
				
					lDissidio 		:= lsvDissidio
					cSvSetRot 		:= SetRotExec( cRot )
					cSvSetPer 		:= SetPeriodCalc( cPeriodo )
					cSvSetNumPago 	:= SetNumPgCalc( cNumPag )
					
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³ Executa as formulas do roteiro de ferias                   ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					ExecRot( SRA->RA_FILIAL , cRot )
				
					SetRotExec( cSvSetRot )
					SetPeriodCalc( cSvSetPer )
					SetNumPgCalc( cSvSetNumPago )
					
					nElem := Len(aPd)
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CONTA OS ELEMENTOS VALIDOS PARA MONTAR O NOVO aCols        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nElem1 := 0
					aEval(aPd,{ |X| nElem1 += If( Round(x[5],2) = 0.00 .Or. X[9]=="D" ,0 ,1) })
					
					If nElem1 > 0
						//Se foi calculado verba de férias mes seguinte, e no calculo original não possui esta verba, significa que o calculo original não foi feito na P12,
						//portanto, carrega array com verbas do mes seguinte para somar nas verbas do mes e calcular a diferença corretamente.
						If (aScan(aPd, {|x| x[1] == aCodFol[73,1] .and. x[9] <> "D"})) > 0 .and. (aScan(aDif_Fer, {|x| x[1] == aCodFol[73,1]})) == 0
							aPdMSeg := fCarPdMSeg()
						EndIf
						
						aSort( aPD ,,, { |x,y| x[1] + x[11] < y[1] + y[11] } )
						
						For nCount = 1 To nElem
							If Round(aPd[nCount,5],2) == 0.00 .Or. aPd[nCount,9] == "D"
								Loop
							EndIf
							
							//Se for dissidio com férias pagas em dois meses, e estiver calculando o primeiro período de férias, verifica se verba possui configuração para dissidio.
							//No último período, inclui todas as verbas pois precisa fazer a alteração das verbas de mes e mês seguinte.
							If lDissidio .and. ( MesAno(dDtFim) == MesAno(dDtIni) .or. MesAno(dDtFim) <> cSvSetPer ) .and. PosSrv(aPd[nCount,01], xFilial("SRV", SRA->RA_FILIAL), "RV_COMPL_") == "N"
								Loop
							EndIf
							
							nPos := Ascan(aDif_Fer,{ |X| X[1] = aPd[nCount,01] } )
							
							If nPos > 0
								aDif_Fer[nPos,3] += Round(aPd[nCount,05],2)
								aDif_Fer[nPos,4] += aPd[nCount,04]
							Else
								If (nPosAux := Ascan(aPdMSeg,{ |X| X[1] = aPd[nCount,01] } )) > 0
									nPos := Ascan(aDif_Fer,{ |X| X[1] = aPdMSeg[nPosAux,02] } )
								EndIf							
								If nPos > 0
									aDif_Fer[nPos,3] += Round(aPd[nCount,05],2)
									aDif_Fer[nPos,4] += aPd[nCount,04]									
								Else
									aAdd(aDif_Fer,{aPd[nCount,01],0,Round(aPd[nCount,05],2),aPd[nCount,04],0})
								EndIf
							EndIf
						Next
	                    For nCount := 1 to Len(aDif_Fer)
                    		aDif_Fer[nCount,5] := aDif_Fer[nCount,3]-aDif_Fer[nCount,2]
	                    Next nCount
                    EndIf
                    
						If lDissidio
							RestoreMnemonicos( aSaveMnemo ) //Restaura os mnemonicos originais

							//Força valores de ferias de mes seguinte que estao virando mes

							//Busca a gratificacao 
							nGratFull := 0
							nGratProp := 0
							If (nPosAux1 := Ascan(aApdX_,{ |X| X[1] = '036' } )) > 0
								nGratFull := aApdX_[nPosAux1,5]
								nGratProp := aApdX_[nPosAux1,5]
								If aApdX_[nPosAux1,4] <> 30 
									nGratFull := (nGratFull/aApdX_[nPosAux1,4])*30
								EndIf
							ElseIf (nPosAux1 := Ascan(aApdX_,{ |X| X[1] = '033' } )) > 0
								nGratFull := aApdX_[nPosAux1,5]
								nGratProp := aApdX_[nPosAux1,5]
								If aApdX_[nPosAux1,4] <> 30 
									nGratFull := (nGratFull/aApdX_[nPosAux1,4])*30
								EndIf
							EndIf 

							//Abono Pecuniario = Salario com Anuenio incorporado
							If (nPosAux1 := Ascan(aDif_Fer,{ |X| X[1] = '114' } )) > 0
								If (nPosAux2 := Ascan(aApdX_,{ |X| X[1] = '115' } )) > 0
									aDif_Fer[nPosAux1,3] := round(( (salmes + nGratFull)/30)*aApdX_[nPosAux2,4],2)
									aDif_Fer[nPosAux1,5] := aDif_Fer[nPosAux1,3] - aDif_Fer[nPosAux1,2]
								EndIf
							EndIf

							//1/3 do Abono Pecuniario = Abono + medias Abono
							If (nPosAux1 := Ascan(aDif_Fer,{ |X| X[1] = '101' } )) > 0
								//Considera o Abono
								If (nPosAux3 := Ascan(aDif_Fer,{ |X| X[1] = '114' } )) > 0
									aDif_Fer[nPosAux1,3] := aDif_Fer[ nPosAux3, 3]
								Else
									aDif_Fer[nPosAux1,3] := 0
								EndIf
								//Soma as medias de abono
								If (nPosAux2 := Ascan(aApdX_,{ |X| X[1] = '261' } )) > 0
									aDif_Fer[nPosAux1,3] += aApdX_[nPosAux2,5]
								EndIf
								If (nPosAux2 := Ascan(aApdX_,{ |X| X[1] = '265' } )) > 0
									aDif_Fer[nPosAux1,3] += aApdX_[nPosAux2,5]
								EndIf
								aDif_Fer[nPosAux1,3] := aDif_Fer[nPosAux1,3]/3
								aDif_Fer[nPosAux1,5] := aDif_Fer[nPosAux1,3] - aDif_Fer[nPosAux1,2]
							EndIf
							//1/3 das Ferias = Ferias + medias + anuenio + Gratif
							If (nPosAux1 := Ascan(aDif_Fer,{ |X| X[1] = '107' } )) > 0
								//Considera as ferias
								If (nPosAux3 := Ascan(aApdX_,{ |X| X[1] = '207' } )) > 0
									aDif_Fer[nPosAux1,3] := aApdX_[ nPosAux3, 5]
									nAnuRef := aApdX_[ nPosAux3, 4]
								Else
									aDif_Fer[nPosAux1,3] := 0
									nAnuRef := 0
								EndIf
								//Soma as medias
								If (nPosAux2 := Ascan(aApdX_,{ |X| X[1] = '260' } )) > 0
									aDif_Fer[nPosAux1,3] += aApdX_[nPosAux2,5]
								EndIf
								If (nPosAux2 := Ascan(aApdX_,{ |X| X[1] = '253' } )) > 0
									aDif_Fer[nPosAux1,3] += aApdX_[nPosAux2,5]
								EndIf
								//Soma o anuenio
								If (nPosAux2 := Ascan(aPD,{ |X| X[1] = '132' } )) > 0
									If nAnuRef > 0 .and. nAnuRef < 30 
										aDif_Fer[nPosAux1,3] += (aPD[nPosAux2,5]/30)*nAnuRef
									Else
										aDif_Fer[nPosAux1,3] += aPD[nPosAux2,5]
									EndIf
								EndIf
								aDif_Fer[nPosAux1,3] += nGratProp
								aDif_Fer[nPosAux1,3] := aDif_Fer[nPosAux1,3]/3
								aDif_Fer[nPosAux1,5] := aDif_Fer[nPosAux1,3] - aDif_Fer[nPosAux1,2]
							EndIf
								 
							/*
							For nY := 1 to len(aDif_Fer)
								If aDif_Fer[nY,1] $ '101/107/114' .and. aDif_Fer[nY,3] == 0 .and. aDif_Fer[nY,5] == 0 .and. aDif_Fer[nY,2] > 0
									If aDif_Fer[nY,1] == '114'
										If (nPosAux := Ascan(aApdX_,{ |X| X[1] = '115' } )) > 0
											aDif_Fer[nY,3] := round((salmes/30)*aApdX_[nPosAux,4],2)
											aDif_Fer[nY,5] := aDif_Fer[nY,3] - aDif_Fer[nY,2] 
										EndIf
									ElseIf aDif_Fer[nY,1] == '101'
										If (nPosAux := Ascan(aApdX_,{ |X| X[1] = '115' } )) > 0
											aDif_Fer[nY,3] := round(((salmes/30)*aApdX_[nPosAux,4])/3,2)
											aDif_Fer[nY,2] := aApdX_[ Ascan(aApdX_,{ |X| X[1] = '106' } ), 5]
											aDif_Fer[nY,5] := aDif_Fer[nY,3] - aDif_Fer[nY,2] 
										EndIf
									ElseIf aDif_Fer[nY,1] == '107'
//										aDif_Fer[nY,3] := round(((salmes/30)*nDiasMse)/3,2)
										aDif_Fer[nY,3] := round(((salmes/30)*nDiasMse)/3,2)
										aDif_Fer[nY,2] := aApdX_[ Ascan(aApdX_,{ |X| X[1] = '108' } ), 5]
										aDif_Fer[nY,5] := aDif_Fer[nY,3] - aDif_Fer[nY,2] 
									EndIf
								EndIf
							Next nX
							*/

						EndIf
															
                   	aAdd(aGrvFer,{SRH->(Recno()),aDif_Fer})
                    
				EndIf
			EndIf
		EndIf
		
		SRH->(DbSkip())
	EndDo
EndIf

If !Empty(aSaveMnemo)
	RestoreMnemonicos( aSaveMnemo ) //Restaura os mnemonicos originais
EndIf

//Ferias Mes Seguinte
If !Empty(dDtFim)
	If MesAno(dDtFim) == cPeriodo 
		fCargaTrans(@aPdFer)
		If Len(aGrvFer) > 0
			nTamAux := Len(aGrvFer[1,2])
			nCount := 0
			While .T.
				nCount++
				If nCount > nTamAux
					Exit
				EndIf
				nPos := aScan(aPdFer,{|x| x[1]==aGrvFer[1][2][nCount][1] }) //Verba que será alterada
				If  nPos > 0 .and. aPdFer[nPos][3] == "F"
					nPos1 := aScan(aGrvFer[1][2],{|x| x[1]==aPdFer[nPos][2] }) //verba a excluir
					If nPos1 > 0
						aDel(aGrvFer[1][2],nPos1)
						aSize(aGrvFer[1][2],Len(aGrvFer[1][2])-1)
						If nPos1 < nCount
							nCount--
						EndIf
						nTamAux--
					EndIf
					//Se as férias iniciaram no período anterior e não houve diferença de salário
					If MesAno(dDtIni) < cPeriodo .And. ( nSalDif == 0 .OR. nSalDif == Salario ) .And. !lDissidio
						//Deleta a verbas de mês seguinte se estiver com mnemônico desabilitado ou se não for as verbas de médias
						//pois as diferenças já foram geradas no mês anterior
						If !P_LDIFMED .Or. (P_LDIFMED .And. !aGrvFer[1][2][nCount][1] $ cCodMedFer)
							nPos1 := aScan(aGrvFer[1][2],{|x| x[1]==aGrvFer[1][2][nCount][1] }) //verba a excluir
							aDel(aGrvFer[1][2],nPos1)
							aSize(aGrvFer[1][2],Len(aGrvFer[1][2])-1)
							If nPos < nCount
								nCount--
							EndIf
							nTamAux--
						EndIf
					Else
						aGrvFer[1][2][nCount][1] := aPdFer[nPos][2]					
					EndIf
				ElseIf MesAno(dDtIni) < cPeriodo
					//Se não possui verba de mês seguinte, verifica se a verba existe no movimento do mês, 
					//se não existir no movimento, significa que foi pago no mês anterior e não deve ser calculado novamente.
					nPos := aScan(aPd, {|x| x[1] == aGrvFer[1][2][nCount][1] .and. x[9] <> "D"})
					If nPos == 0
						aDel(aGrvFer[1][2],nCount)
						aSize(aGrvFer[1][2],Len(aGrvFer[1][2])-1)
						nCount--
						nTamAux--					
					EndIf
				EndIf
			EndDo
		EndIf
	EndIf
EndIf	
If !Empty(aGrvFer)
   	If lDissidio 
   		For nX := 1 to len(aPD)
   			aPd[nX,2] := SRA->RA_CC
   		Next nX
   		For nX := 1 to len(aPDOld)
   			aPdOld[nX,2] := SRA->RA_CC
   		Next nX
   	EndIf
   	fGrvDifFer(aGrvFer)
EndIf

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction³fGrvDifFer     ºAutor  ³Leandro Drumond  º Data ³ 07/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Gera diferenca de ferias no aPd.                              º±±
±±º        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ Roteiro de Calculo - Folha                                   º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGrvDifFer(aDif_Fer)

Local aArea			:= GetArea()
Local aFerAux		:= {}
Local aGrvDif		:= {}
Local cPdDif		:= ""
Local cSeq			:= " "
Local cSeqAux		:= ""
Local cLastSeq		:= ""
Local nRecSRH		:= 0
Local nPos			:= 0
Local nPosFer		:= 0
Local nPosSeq		:= 0
Local nX			:= 0
Local nY			:= 0
Local cTipo2		:= ""
					
For nX := 1 to Len(aDif_Fer)
	nRecSRH := aDif_Fer[nX,1]
	aFerAux := aDif_Fer[nX,2]
	cTipo2  := ""
	
	If lDissidio
		If ( nPosFer := aScan( aFerAux, {|x| x[1] == aCodFol[72,1] } ) ) > 0 
			If ( nPosSeq := aScan( aPdOld, {|x| x[1] == aCodFol[72,1] .And. x[5] == aFerAux[nPosFer, 2] } ) ) > 0
				cSeq := aPdOld[nPosSeq, 11]
				cTipo2 := aPdOld[nPosSeq, 7]
			Else
				If Empty(cLastSeq)
					cSeq 	 := Str( Len(aDif_Fer)+1, 1)
					cLastSeq := cSeq
				Else
					cSeq 	 := Str( Val(cLastSeq)+1, 1 )
					cLastSeq := cSeq			
				EndIf
			EndIf
		EndIf
	Else
		cSeq := If(nX == 1, " ", Str(nX-1, 1) )
	EndIf
	
	For nY := 1 to Len(aFerAux)
		If !lDissidio .And. aFerAux[nY,5] >= 0
			cPdDif := PosSrv(aFerAux[nY,1],xFilial("SRR"),"RV_FERSEG")
			If !Empty(cPdDif)
				If Empty(aGrvDif)
					aAdd(aGrvDif,{cPdDif,aFerAux[nY,5],aFerAux[nY,4],aFerAux[nY,2]})
				ElseIf( nPos := Ascan(aGrvDif,{ |X| X[1] == cPdDif } ) ) > 0
					aGrvDif[nPos,2] += aFerAux[nY,5]
				Else
					aAdd(aGrvDif,{cPdDif,aFerAux[nY,5],aFerAux[nY,4],aFerAux[nY,2]})
				EndIf
			EndIf
		ElseIf lDissidio
			aAdd(aGrvDif,{aFerAux[nY,1],aFerAux[nY,3],aFerAux[nY,4],aFerAux[nY,2]})
		EndIf
	Next nY
			
	
	If !Empty(aGrvDif)
		For nY := 1 to Len(aGrvDif)

			If lDISSIDIO
			
				If ( nPosSeq := aScan( aPdOld, {|x| x[1] == aGrvDif[nY,1]  } ) ) > 0
					cSeqAux := aPdOld[nPosSeq, 11]
					cTipo2  := aPdOld[nPosSeq, 7]
				Else
					cSeqAux := cSeq
					cTipo2  := ""
				EndIf
			
			Else

				If ( nPosSeq := aScan( aPdOld, {|x| x[1] == aGrvDif[nY,1] .And. x[5] == aGrvDif[nY,4] } ) ) > 0
					cSeqAux := aPdOld[nPosSeq, 11]
					cTipo2  := aPdOld[nPosSeq, 7]
				Else
					cSeqAux := cSeq
					cTipo2  := ""
				EndIf

			EndIf

			If Ascan(aPd,{ |X| X[1]+X[3]+X[11] == aGrvDif[nY,1] + cSemana + cSeqAux + cTipo2 } ) > 0
				While .T.
					cSeqAux := Soma1(cSeqAux)
					If Ascan(aPd,{ |X| X[1]+X[3]+X[11] == aGrvDif[nY,1] + cSemana + cSeqAux } ) == 0
						Exit
					EndIf			
				EndDo
				If cSeqAux > "9"
					cSeqAux := "9"
				EndIf
			EndIf

			fGeraVerba(aGrvDif[nY,1],aGrvDif[nY,2],aGrvDif[nY,3], Nil, Nil, Nil, Nil, Nil, Nil, Nil, .T., aGrvDif[nY,4], Nil, cSeqAux)
		Next nY
	EndIf
	
	DbSelectArea("SRH")
	DbGoTo(nRecSRH)
	
Next nX

RestArea(aArea)

Return Nil
