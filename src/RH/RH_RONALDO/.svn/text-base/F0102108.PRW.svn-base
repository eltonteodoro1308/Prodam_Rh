#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} F0102108()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       05/10/15
@version     P12.5
@Return      Funcao para calculo de Assistencia Medica prodam
@menu        Calc. Assistencia Medica
@Obs
/*/

USER Function F0102108()    // GPEM016
	Local aArea	:= GetArea()
	Gpem020() //Chama a rotina de calculo
	RestArea(aArea)
Return
/*/ {Protheus.doc} F0102107()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       05/10/15
@version     P12.5
@Return      Funcao para calculo de Assistencia Medica prodam
@Obs         Rotina de calculo Plano de saude
/*/
user Function F0102107()          //fcalcpls()
	Local aArea			:= GetArea()
	Local aTitle		:= {}
	Local cCodForAnt	:= ""	// Codigo Fornecedor Anterior
	Local cTpFornAnt	:= ""	// Tipo do Fornecedor Anterior
	Local cCodPlano 	:= ""	//Código do Plano
	Local cTpPlano 	:= ""	//Tipo do Plano
	Local cAnoMesInT	:= ""	// Ano e Mes do Inicio do plano de saude do Titular
	Local cAnoMesFiT	:= ""	// Ano e Mes do Final do plano de saude do Titular
	Local cSpcCodigo 	:= Space(GetSx3Cache("RHR_CODIGO", "X3_TAMANHO"))
	Local cSpcTpPLan 	:= Space(GetSx3Cache("RHK_TPPLAN", "X3_TAMANHO"))
	Local cSpcPlano 	:= Space(GetSx3Cache("RHK_PLANO", "X3_TAMANHO"))
	Local lTemPlAtTi	:= .F.	// Define se Tem Algum Plano de saude Ativo para o Titular ou Nao (.F. = Nao Tem, .T. = Tem plano)
	Local lAchou 		:= .F.
	Local lRet			:= .T.
	Local lRbPlSaude	:= .F.
	Local nX			:= 0

	Private aLog		:= {}

	Aadd( aTitle, OemToAnsi("Tabela nao Cadastrada ou Valores fora da Faixa"  ))		//
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( "Dependentes e Agregados não calculados" ))		//
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( "Titular possui mais de um plano com mesmo Fornecedor" ) )	//
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( "Titular possui plano de saúde com Período Inicial e Final divergente do Mês e Ano do cálculo"  ) )	//
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( "Titular nao possui plano de saúde ativo para o Mês e Ano do cálculo" ) )	//
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( "Co-participação ou reembolso calculado mesmo com plano de saude expirado" ) )	//
	Aadd( aLog, {} )

	Begin Transaction

		DbSelectArea( "RHK" )
		RHK->(DbSetorder( RetOrdem( "RHK", "RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR" ) ))
		cPDDepAgr := ""
		if RHK->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
			While RHK->( !Eof() ) .and. RHK->RHK_FILIAL + RHK->RHK_MAT == SRA->RA_FILIAL + SRA->RA_MAT
				cAnoMesInT	:= Substr(RHK->RHK_PERINI,3,4) + Substr(RHK->RHK_PERINI,1,2)
				cAnoMesFiT	:= Substr(RHK->RHK_PERFIM,3,4) + Substr(RHK->RHK_PERFIM,1,2)
				//verifica se o funcionario possui algum plano ativo para o periodo informado.
				If (( cAnoMesInT > cAnoMes ) .or. ( cAnoMesInT <= cAnoMes .and. ! Empty( cAnoMesFiT ) .and. cAnoMesFiT < cAnoMes ))
					RHK->(DbSkip())
					Loop
				Else
					lAchou := .T.	// O Titular Possui um Plano de saude Ativo
					EXIT
				EndIf

				RHK->(dbSkip())

			EndDo
		EndIf
		// Gera log de calculo se nao houver plano do titular ativo para o Mes/Ano a calcular
		If ! lAchou
			If Len( aLog[5] ) == 0 .or. Ascan( aLog[5], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
				aAdd( aLog[5], 	Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) )
			EndIf
		EndIf

		// Calculo dos Planos do Titular //
		RHK->(dbGoTop())
		RHK->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))

		While RHK->( !Eof() ) .and. RHK->RHK_FILIAL + RHK->RHK_MAT == SRA->RA_FILIAL + SRA->RA_MAT

			// Atualiza variaveis de Ano e Mes de Inicio e Fim do plano de saude do Titular
			cAnoMesInT	:= Substr(RHK->RHK_PERINI,3,4) + Substr(RHK->RHK_PERINI,1,2)
			cAnoMesFiT	:= Substr(RHK->RHK_PERFIM,3,4) + Substr(RHK->RHK_PERFIM,1,2)

			// Gera log de calculo se houver duplicidade de plano para o titular
			If RHK->RHK_TPFORN == cTpFornAnt .and. RHK->RHK_CODFOR == cCodForAnt .and. RHK->RHK_TPPLAN == cTpPlano .AND. ;
					RHK->RHK_PLANO == cCodPlano
				If Len( aLog[3] ) == 0 .or. Ascan( aLog[3], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
					aAdd( aLog[3], Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) )
				EndIf
			Else
				// Carrega variaveis de Codigo e Tipo do Fornecedor e plano anteriores
				cCodForAnt	:= RHK->RHK_CODFOR
				cTpFornAnt	:= RHK->RHK_TPFORN
				cTpPlano 	:= RHK->RHK_TPPLAN
				cCodPlano	:= RHK->RHK_PLANO
			EndIf

			// Verifica se Per. Inicial e Final do plano do titular está divergente do Mes/Ano a calcular
			If (( cAnoMesInT > cAnoMes ) .or. ( cAnoMesInT <= cAnoMes .and. ! Empty( cAnoMesFiT ) .and. cAnoMesFiT < cAnoMes ))
				lTemPlAtTi := .F.
				RHK->(DbSkip())
				Loop
			Else
				lTemPlAtTi := .T.	// O Titular Possui um Plano de saude Ativo
			EndIf

			nVlrFunc := 0
			nVlrEmpr := 0
			nValFunc := 0
			nVlrTemp := 0
			lRet := fCalcPlano(1, RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, dDataRef, SRA->RA_NASC, @nVlrFunc, @nVlrEmpr, SRA->RA_FILIAL )

			If lRet
				fGravaCalc("1", cSpcCodigo, "1", RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, RHK->RHK_PD, nVlrFunc, nVlrEmpr )
			EndIf

			cPDDAgr := RHK->RHK_PDDAGR

			// Calculo dos Planos dos Dependentes //
			DbSelectArea( "RHL" )
			RHL->(DbSetorder( RetOrdem( "RHL", "RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO" ) ))
			If RHL->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR, .F. ))
				While RHL->( !Eof() ) .and. RHL->RHL_FILIAL + RHL->RHL_MAT + RHL->RHL_TPFORN + RHL->RHL_CODFOR == (SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR )

					If !((cAnoMes >= Substr(RHL->RHL_PERINI,3,4)+Substr(RHL->RHL_PERINI,1,2)) .and. Empty( RHL->RHL_PERFIM) .or. (cAnoMes >= Substr(RHL->RHL_PERINI,3,4)+Substr(RHL->RHL_PERINI,1,2)) .and. (cAnoMes <=  Substr(RHL->RHL_PERFIM,3,4)+Substr(RHL->RHL_PERFIM,1,2)))
						RHL->(DbSkip())
						Loop
					EndIf

					DbSelectArea( "SRB" )
					SRB->(DbSetOrder( RetOrdem( "SRB", "RB_FILIAL+RB_MAT" ) ) )
					SRB->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. )   )
					lHasDep 	:= .F.
					lRbPlSaude 	:= .F.
					While SRB->( !EOF() ) .and. SRB->RB_FILIAL + SRB->RB_MAT == SRA->RA_FILIAL + SRA->RA_MAT
						lRbPlSaude := SRB->RB_PLSAUDE == "1" .or. lRbPlSaude
						If SRB->RB_COD == RHL->RHL_CODIGO
							lHasDep := .T.
							Exit
						EndIf
						SRB->( DbSkip() )
					EndDo

					If lHasDep
						nVlrFunc := 0
						nVlrEmpr := 0
						lRet := fCalcPlano(2, RHL->RHL_TPFORN, RHL->RHL_CODFOR, RHL->RHL_TPPLAN, RHL->RHL_PLANO, dDataRef, SRB->RB_DTNASC, @nVlrFunc, @nVlrEmpr, SRA->RA_FILIAL )
						If lRet .and. Round(nVlrFunc,2) > 0 .or. Round(nVlrEmpr,2) > 0
							fGravaCalc("2", RHL->RHL_CODIGO, "1", RHL->RHL_TPFORN, RHL->RHL_CODFOR, RHL->RHL_TPPLAN, RHL->RHL_PLANO, cPDDAgr, nVlrFunc, nVlrEmpr )
						EndIf

						If lRet .and. Round(nVlrFunc,2) <= 0 .and. Round(nVlrEmpr,2) <= 0
							aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
								OemToAnsi( "Codigo" ) + " - " + RHL->RHL_CODIGO ) //
						EndIf
					ElseIf lRbPlSaude
						aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
							OemToAnsi( "Cadastro de dependentes com informação de que possui plano de saúde, porém não existe plano ativo."  ) ) //
					EndIf

					DbSelectArea( "RHL" )
					RHL->(DbSkip())

				EndDo
			Else
				DbSelectArea( "SRB" )
				SRB->(DbSetOrder( RetOrdem( "SRB", "RB_FILIAL+RB_MAT" ) ) )
				If SRB->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ) )
					aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
						OemToAnsi( "Cadastro de dependentes com informação de que possui plano de saúde, porém não existe plano ativo."  ) ) //"Cadastro de dependentes com informação de que possui plano de saúde, porém não existe plano ativo."
				EndIf
			EndIf

			// Calculo dos Planos dos Agregados //
			DbSelectArea( "RHM" )
			RHM->(DbSetorder( RetOrdem( "RHM", "RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO" ) )  )
			RHM->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR, .F. ))
			While RHM->( !Eof() ) .and. RHM->RHM_FILIAL + RHM->RHM_MAT + RHM->RHM_TPFORN + RHM->RHM_CODFOR == SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR

				If !((cAnoMes >= Substr(RHM->RHM_PERINI,3,4)+Substr(RHM->RHM_PERINI,1,2)) .and. Empty( RHM->RHM_PERFIM) .or. (cAnoMes >= Substr(RHM->RHM_PERINI,3,4)+Substr(RHM->RHM_PERINI,1,2)) .and. (cAnoMes <=  Substr(RHM->RHM_PERFIM,3,4)+Substr(RHM->RHM_PERFIM,1,2)))
					RHM->(	DbSkip()  )
					Loop
				EndIf
				nVlrFunc := 0
				nVlrEmpr := 0
				lRet := fCalcPlano(3, RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, dDataRef, RHM->RHM_DTNASC, @nVlrFunc, @nVlrEmpr, SRA->RA_FILIAL )

				If lRet .and. Round(nVlrFunc,2) > 0 .or. Round(nVlrEmpr,2) > 0
					fGravaCalc("3", RHM->RHM_CODIGO, "1", RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, cPDDAgr, nVlrFunc, nVlrEmpr )
				EndIf

				If lRet .and. Round(nVlrFunc,2) <= 0 .and. Round(nVlrEmpr,2) <= 0
					aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
						OemToAnsi( "Codigo" ) + " - " + RHM->RHM_CODIGO ) //
				EndIf

				DbSelectArea( "RHM" )
				RHM->(DbSkip()   )

			EndDo

			DbSelectArea( "RHK" )
			RHK->(DbSkip())
		EndDo

		// Calcular Reembolso e Co-participacao //
		DbSelectArea( "RHO" )
		RHO->(DbSetorder( RetOrdem( "RHO", "RHO_FILIAL+RHO_MAT+RHO_COMPPG" ) ) )
		RHO->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cAnoMes, .F. ))
		While RHO->( !Eof() ) .and. RHO->( RHO_FILIAL + RHO_MAT + RHO_COMPPG ) == SRA->( RA_FILIAL + RA_MAT ) + cAnoMes
			cTpLan := If( RHO->RHO_TPLAN == "1", "2", "3")
			fGravaCalc(RHO->RHO_ORIGEM, RHO->RHO_CODIGO, cTpLan, RHO->RHO_TPFORN, RHO->RHO_CODFOR, cSpcTpPLan, cSpcPlano, RHO->RHO_PD, RHO->RHO_VLRFUN, RHO->RHO_VLREMP, .T. )
			If !Empty(aLog[5])
				If Len( aLog[6] ) == 0 .OR. Ascan( aLog[6], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
					aAdd( aLog[6], 	Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME , 1, 45 ) + ;
						RHO_CODFOR + ;
						Substr(DTOS(RHO->RHO_DTOCOR),7,2) + "/" + Substr(DTOS(RHO->RHO_DTOCOR),5,2) + "/" + Substr(DTOS(RHO->RHO_DTOCOR),1,4 ) +;
						Substr(RHO_OBSERV,1,45))
				EndIf
			EndIf
			DbSelectArea( "RHO" )
			RHO->(DbSkip()  )
		EndDo

	End Transaction

	If !Empty(aLog[1])
		AddLogExecRot( aTitle[1] )
		For nX := 1 to Len(aLog[1])
			AddLogExecRot( aLog[1][nX])
		Next nX
	EndIf

	If !Empty(aLog[2])
		AddLogExecRot( aTitle[2] )
		For nX := 1 to Len(aLog[2])
			AddLogExecRot( aLog[2][nX])
		Next nX
	EndIf

	If !Empty(aLog[3])
		AddLogExecRot( aTitle[3] )
		For nX := 1 to Len(aLog[3])
			AddLogExecRot( aLog[3][nX])
		Next nX
	EndIf

	If !Empty(aLog[4])
		AddLogExecRot( aTitle[4] )
		For nX := 1 to Len(aLog[4])
			AddLogExecRot( aLog[4][nX])
		Next nX
	EndIf

	If !Empty(aLog[5])
		AddLogExecRot( aTitle[5] )
		For nX := 1 to Len(aLog[5])
			AddLogExecRot( aLog[5][nX])
		Next nX
	EndIf

	If !Empty(aLog[6])
		AddLogExecRot( aTitle[6] )
		For nX := 1 to Len(aLog[6])
			AddLogExecRot( aLog[6][nX])
		Next nX
	EndIf

	RestArea(aArea)

Return lRet

Static Function fCalcPlano( nTipo, cTpForn, cCodForn, cTpPlan, cCodPlan, dDtRef, dDtNasc, nVlrFunc, nVlrEmpr, cFilProc )
	Local aArea			:= GetArea()
	Local cTab
	Local cTpLogForn
	Local cTpLogPlano
	Local lRet 			:= .T.
	Local lCarTabFol 	:= .T.
	Local nLinha
	Local nLinTab
	Local nColVlr
	Local nColPorc
	Local nColTeto
	Local nBusca
	Local nValor
	Local nPercentual
	Local nTeto
	Local nSal		 := 0
	Local nGrat	 := 0
	Local nSubs	 := 0
	Local nValFunc := 0

	If cTpForn == "1"
		If cTpPlan == "1"
			cTab := "U053"
		EndIf
		cTpLogForn := OemToAnsi( "Assistência Medica"  )
	Else					// Assistencia Odontologica
		If cTpPlan == "1"
			cTab := "S013"
		ElseIf cTpPlan == "2"
			cTab := "S014"
		ElseIf cTpPlan == "3"
			cTab := "S030"
		ElseIf cTpPlan == "4"
			cTab := "S031"
		ElseIf cTpPlan == "5"
			cTab := "S060"
		EndIf
		cTpLogForn := OemToAnsi( "Assistência Odontologica" ) //
	EndIf

	//Ajuste para verificar se utiliza salario base ou salario incorporado
	If !P_SALINC
		If (SRA->RA_CATFUNC = "H")
			nBusca := SRA->RA_HRSMES * SRA->RA_SALARIO
		Else
			nBusca := nSalMes
		EndIf
	Else
		nBusca := nSalMes
	EndIf

	If cTpForn == "1"
		If nTipo == 1 // Titular
			nColPorc 	:= 6
		ElseIf nTipo == 2 // Dependente
		
	cQuery := " SELECT RB_DTNASC FROM " + RetSqlName ("SRB") + " A "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RB_FILIAL = '"+RHL->RHL_FILIAL+"' AND RB_MAT = '"+RHL->RHL_MAT+"' AND RB_COD = '"+RHL->RHL_CODIGO+"' "
	Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)
	TCSetField("TRG1","RB_DTNASC","D")
		nColVlr = 0
		nLim :=  DateDiffMonth( dDtRef + 30, TRG1->(RB_DTNASC) )
		
		If Empty(TRG1->(RB_DTNASC)) .or. nLim > 999
			nLim := 999
		EndIf
		
			IF RHL->RHL_XTPDEP = '01' .and. nLim <= Val(fTabela("U054",1,6))
				nColVlr 	:= 7
			ELSEIF RHL->RHL_XTPDEP = '02'  .and. nLim <= Val(fTabela("U054",2,6))
				nColVlr 	:= 9
			ELSEIF RHL->RHL_XTPDEP = '03' .and. nLim <=  Val(fTabela("U054",3,6))
				nColVlr 	:= 7
			ELSEIF RHL->RHL_XTPDEP = '04' .and. nLim <= Val(fTabela("U054",4,6))
				nColVlr 	:= 10
			ELSEIF RHL->RHL_XTPDEP = '05' .and. nLim <= Val(fTabela("U054",5,6))
				nColVlr 	:= 7
			ELSEIF RHL->RHL_XTPDEP = '06' .and. nLim <= Val(fTabela("U054",6,6))
				nColVlr 	:= 7
			ELSEIF RHL->RHL_XTPDEP = '07' .and. nLim <= Val(fTabela("U054",7,6))
				nColVlr 	:= 7
			ELSEIF RHM->RHM_XTPDEP = '08' .and. nLim <= Val(fTabela("U054",8,6))
				nColVlr 	:= 8
			ENDIF
			If nColVlr = 0
				nColVlr := 17
				aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
				OemToAnsi( "Codigo" ) + " - " + RHL->RHL_CODIGO  + " - Verificar o Tipo de Dependente") //		
			//Alert("Verificar o Tipo de Dependente da Matricula " +RHL->RHL_FILIAL+ " - " +RHL->RHL_MAT+ " Codigo " + RHL->RHL_CODIGO)
			EndIf
		ElseIf nTipo == 3 // Agregado

		nColVlr := 0
		nLim :=  DateDiffMonth( dDtRef + 30, RHM->RHM_DTNASC )
		
		If Empty(RHM->RHM_DTNASC) .or. nLim > 999
			nLim := 999
		EndIf
		
			IF RHM->RHM_XTPDEP = '08' .and. nLim <= Val(fTabela("U054",8,6))
				nColVlr 	:= 8
			ELSEIF RHM->RHM_XTPDEP = '05' .and. nLim <= Val(fTabela("U054",5,6))
				nColVlr 	:= 7
			ENDIF
			If nColVlr = 0
				nColVlr := 17
				aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
				OemToAnsi( "Codigo" ) + " - " + RHL->RHL_CODIGO  + " - Verificar o Tipo de Dependente") //		
			//Alert("Verificar o Tipo de Dependente da Matricula " +RHM->RHM_FILIAL+ " - " +RHM->RHM_MAT+ " Codigo " + RHM->RHM_CODIGO)
			EndIf
		EndIf
		nLinha:= fPosTab(cTab,cCodPlan,'=',4)
	ELSE
		If cTpPlan == "1" .or. cTpPlan == "2"
			If nTipo == 1 // Titular
				nColVlr 	:= 7
				nColPorc	:= 10
			ElseIf nTipo == 2 // Dependente
				nColVlr 	:= 8
				nColPorc	:= 11
			ElseIf nTipo == 3 // Agregado
				nColVlr 	:= 9
				nColPorc	:= 12
			EndIf
			nLinTab := 0
			If ( nLinha := fPosTab( cTab, cCodForn, "=", 13, cCodPlan, "=", 4, , , @nLinTab, lCarTabFol, cFilProc ) ) > 0 
				If ( nLinha := fPosTab(cTab, cCodPlan,"=",4,nBusca,"<=",6,,nLinTab,,,cFilProc ) ) > 0

					nValor 		:= fTabela(cTab,nLinha,nColVlr,,cFilProc)
					nPercentual := fTabela(cTab,nLinha,nColPorc,,cFilProc) / 100
					nVlrFunc  	:= Round( nValor * nPercentual, 2 )	// Arredondamento para nao dar diferenca entre calculo e valor total do plano
					nVlrEmpr	:= nValor - nVlrFunc
				EndIf
			EndIf

			If cTpPlan == "1"
				cTpLogPlano := OemToAnsi( "Faixa Salarial" ) //
			ElseIf cTpPlan == "2"
				cTpLogPlano := OemToAnsi( "Faixa Etaria" ) //
			EndIf
		ENDIF
	ENDIF

If cTpForn =="1"
	nGrat := U_f0100204('P')
	nSubs := U_f0100402('P')
	
	If nTipo == 1 // Titular
		nPercentual := fTabela(cTab,nLinha,nColPorc,,cFilProc) / 100
		nValor      := nSalMes + nGrat // + nSubs
	ELSE
		nPercentual := 0
		nValor 		:= fTabela(cTab,nLinha,nColVlr,,cFilProc)
	ENDIF

	IF nPercentual > 0
		nVlrFunc  	:= Round( nValor * nPercentual, 2 )		// Arredondamento para nao dar diferenca entre calculo e valor total do plano
	ELSE
		nVlrFunc  	:= nValor
	ENDIF

	If nTipo == 1
		nValFunc	:= fTabela(cTab,nLinha,17,,cFilProc)
		If nValFunc <> 0
			nVlrFunc := nVlrFunc + nValFunc
			ElseIf nValFunc = 0
			nVlrTemp := nVlrFunc
			nVlrFunc := 0
		EndIf
	EndIf
	
	nVlrEmpr	:= fTabela(cTab,nLinha,12,,cFilProc) + nVlrTemp
EndIf
	// Apos Primeira Carga, atualiza para .F. para nao carregar a cada funcionario
	lCarTabFol := .F.
	
	RestArea(aArea)
Return( lRet )
		
		
Static Function fGravaCalc(cOrigem, cCodDepAgr, cTipoLan, cTpForn, cCodForn, cTpPlan, cPlano, cPD, nVlrFun, nVlrEmp, lCopReemb )
	Local aArea		:= GetArea()
	Local lRHRTipo	:= RHR->( FieldPos( "RHR_TIPO" ) # 0 )

	DEFAULT lCopReemb := .F.	// Coparticipacao/Reembolso - Padrao eh False, pois esta var somente vira com True para regs da Tab. RHO

	DbSelectArea( "RHR" )
	RHR->(DbSetOrder( 1 ))
	RHR->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + 	cAnoMes + cOrigem + cCodDepAgr + cTipoLan + cTpForn + cCodForn + cTpPlan + cPlano + cPD, .F. ))

	If Eof()
		RHR->( RecLock( "RHR" , .T. ) )
		RHR->RHR_FILIAL := SRA->RA_FILIAL
		RHR->RHR_MAT 	:= SRA->RA_MAT
	Else
		RHR->( RecLock( "RHR" , .F. ) )
	EndIf

	RHR->RHR_DATA 		:= dDataBase
	RHR->RHR_ORIGEM	 	:= cOrigem
	RHR->RHR_CODIGO		:= cCodDepAgr
	RHR->RHR_TPLAN		:= cTipoLan
	RHR->RHR_TPFORN		:= cTpForn
	RHR->RHR_CODFORN		:= cCodForn
	RHR->RHR_TPPLAN		:= cTpPlan
	RHR->RHR_PLANO		:= cPlano
	RHR->RHR_PD			:= cPD

	// Qdo for informacao de Coparticipacao/Reembolso, deve-se somar os valores lancados na tabela RHO
	If !lCopReemb
		RHR->RHR_VLRFUN	:= nVlrFun
		RHR->RHR_VLREMP	:= nVlrEmp
	EndIf

	RHR->RHR_COMPPG		:= cAnoMes

	// Grava novo Campo RHR_Tipo = 1-Calculado
	If lRHRTipo
		RHR->RHR_TIPO := "1"
	EndIf

	RHR->(MsUnlock())

	RestArea( aArea )

Return( .T. )
