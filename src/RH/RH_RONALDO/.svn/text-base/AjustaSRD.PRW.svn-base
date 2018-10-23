#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

USER FUNCTION fAjustaSRD()

	Processa( { ||fProcessa02() } , "Aguarde..." , "Processando a eliminação de duplicidades" , .T. )
	//Processa( { ||fProcessa() } , "Aguarde..." , "Processando a eliminação de duplicidades" , .T. )
	//Processa( { ||fCriaSRD()} )

RETURN

Static Function fProcessa02()

	StartJob("U_EXCLUI02" , GetEnvServer() , .T.)

Return


Static Function fProcessa()

	Local nTotReg		:= 0			
	Local nX			:= 0	
	Local nReg			:= 0
	Local cAliasSRD		:= ""
	Local aStru			:= {}
	Local cArqSRD		:= ""
	Local nQtdProc		:= 0
	Local nQtdReg		:= 0
	Local cQuery		:= ""
	Local cAliasTMP		:= ""
	Local cHoraIni		:= ""
	Local aAreaSRD		:= {}
	Local nLimiReg		:= 0
	Local nTotProc		:= 0
		
	cHoraIni	:= Time()
	
	ConOut('Inicio do processamento de exclusao de duplicidades : ' + cHoraIni)
	
	cArqSRD		:= RetSqlName("SRD")

	cAliasSRD	:= "SRD"
	
	If ( Select(cAliasSRD) == 0 )
	
		dbUseArea(.T. , "TOPCONN" , cArqSRD , cAliasSRD , .T. , .F. )
	
	EndIf
	
	aAreaSRD	:= (cAliasSRD)->(GetArea())
	
	aStru	:= (cAliasSRD)->(dbStruct())	

	nTotReg	:= (cAliasSRD)->(LastRec())
	
	cQuery	:= "SELECT MAX(R_E_C_N_O_) REGISTRO FROM " + cArqSRD + " WHERE RD_EMPRESA = 'X' OR RD_EMPRESA = '0' "
	
	cAliasTMP	:= GetNextAlias()
	
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)
	
	If !( (cAliasTMP)->(REGISTRO) == 0 )
	
		nReg		:= (cAliasTMP)->(REGISTRO)
	
	Else
		
		nReg		:= 1
	
	EndIf
	
	(cAliasTMP)->(dbCloseArea())
	
	nLimiReg	:= 1000
	
	nQtdReg	:= Int(NoRound((nTotReg - nReg) / nLimiReg))
	
	nQtdProc:= nReg + nQtdReg
	
	ProcRegua( nTotReg )	
	
	Do While (nReg <= nTotReg)
	
		++nX
	
		StartJob("U_fExclui",GetEnvServer(),.T. , cAliasSRD , cArqSRD , aStru , nReg , nQtdProc , nQtdReg , nX , nTotReg , nLimiReg )
		
		nTotProc	:= ( nReg * 100) / nTotReg
		
		//IncProc(" Quantidade processada : " + Str(nTotProc , 3) + " %" )
		
		nReg		+= nLimiReg
		
		nQtdProc	:= nReg + nLimiReg
		
		nQtdProc	:= Int(NoRound(nQtdProc))
		
	EndDo
	
	ConOut('Fim do Processamento da exclusao de duplicidades. Tempo total de execucao : ' + ElapTime(cHoraIni , Time()) )
	
	RestArea(aAreaSRD)

Return

User Function fExclui(cAliasSRD , cArqSRD , aStru , nReg , nQtdProc , nQtdReg , nThread , nTotReg , nLimiReg )

	Local cHoraIni		:= ""
	Local nPercent		:= 0	
	Local cQuery		:= ""
	Local cCondQry		:= ""
	Local xDado			:= NIL
	Local cAliasTMP		:= ""
	Local nContReg		:= 0
	Local nLen			:= 0
	Local nX			:= 0
	Local nPercReg		:= 0
	Local lExibe		:= .F.
	Local nPercNew		:= 0	
	Local nQtRegProc		:= 0
	Local nPercTotal	:= 0

	// Seta job para nao consumir licencas
	RpcSetType(3)

	// Seta job para empresa filial desejada
	RpcSetEnv( '01', '01' ,,,'PON')
	
	nLen	:= Len(aStru)

	cHoraIni	:= Time()	
	
	//ConOut( "THREAD : " + Str(nThread , 5) + " De: " + Str(nQtdReg) )
	
	nQtRegProc	:= nReg + nLimiReg
	
	Do While ((cAliasSRD)->(!EOF())) .AND. (nPercReg++ <= nLimiReg)
		
		//IncProc(" Quantidade processada : " + Str( nPercent , 3) + " %" )
		//IncProc(" Processando Registro : " + Str(++nReg , 10) + " De : " + Str(nQtdProc) + " - " + Str( nPercent , 3) + " %" )
		
		(cAliasSRD)->(dbGoTo(nReg))
		
		If ( (lExibe) .AND. (nPercNew > 0) .AND. (Mod(nPercNew , 10) == 0)  )
			
			//ConOut (" Processando Registro : " + Str(nReg , 10) + " De : " + Str(nQtRegProc) + " - " + Str( nPercent , 3) + " %" )
			//fWrite (nHandle , " Processando Registro : " + Str(nReg , 10) + " De : " + Str(nQtdProc) + " - " + Str( nPercent , 3) + " %" )
			
			lExibe	:= .F.
			
		EndIf
		
		//ConOut(" Processando Registro : " + Str(nReg , 10) + " De : " + Str(nQtdProc) )
		
		If ( Empty((cAliasSRD)->(RD_EMPRESA)) )

			cQuery		:= " SELECT SRD.R_E_C_N_O_ REGISTRO FROM " + cArqSRD + " SRD" + " WHERE "
			
			cCondQry	:= ""
			
			cCondQry	+= " SRD.R_E_C_N_O_ >= " + "'" + AllTrim(Str(nReg)) + "'" + " AND "
			
			For nX := 1 TO nLen
			
				If !( AllTrim(aStru[nX , 1]) == "RD_SEQ" )
				
					xDado	:= (cAliasSRD)->(FieldGet(FieldPos(aStru[nX , 1])))
					
					If ( ValType(xDado) == "N" )
						
						xDado	:= AllTrim(Str(xDado))
						
					ElseIf ( ValType(xDado) == "D" )
					
						xDado	:= dToS(xDado)
					
					EndIf
					
					cCondQry	+= aStru[nX , 1] + " = " + "'" + xDado + "'"					
				
					If ( nX < nLen )
						
						cCondQry	+= " AND "
						
					EndIf

				EndIf
			
			Next nX			
			
			cCondQry	+= " AND RD_EMPRESA <> 'X' "
			
			cQuery	+= cCondQry
			
			cAliasTMP	:= GetNextAlias()
			
			dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)
			
			nContReg	:= 0
			
			Do While (cAliasTMP)->(!EOF())
			
				nContReg++
				
				If ( nContReg > 1 )
				
					(cAliasSRD)->(dbGoTo((cAliasTMP)->REGISTRO))
					
					If ( RecLock(cAliasSRD , .F.) )						
					
						(cAliasSRD)->(RD_EMPRESA)	:= 'X'						
						(cAliasSRD)->(RD_FILIAL)	:= '99'						
						
						(cAliasSRD)->(MsUnlock())
					
					EndIf
					
				Else				
					
					If ( RecLock(cAliasSRD , .F.) )						
					
						(cAliasSRD)->(RD_EMPRESA)	:= '0'						
						
						(cAliasSRD)->(MsUnlock())
					
					EndIf
				
				EndIf
				
				(cAliasTMP)->(dbSkip())
			
			EndDo
			
			(cAliasTMP)->(dbCloseArea())
			
		EndIf
		
		//nReg	:= (cAliasSRD)->(Recno())
		
		//(cAliasSRD)->(dbSkip())
		
		nPercent	:= (nPercReg * 100) / nLimiReg		
		
		If ( Int(nPercent) > Int(nPercNew) )
		
			nPercNew	:= Int(nPercent)
			lExibe		:= .T.
		
		EndIf
		
		++nReg
	
	EndDo
	
	ConOut('Fim da Thread ' + Str(nThread , 5) + ' Tempo de Execução: ' + ElapTime(cHoraIni , Time() ))
	
	nPercTotal	:= Int((nReg * 100) / nTotReg)
	
	If ( Mod(nPercTotal , 1) == 0 )
		
		ConOut()
		ConOut("Total geral do processamento : " + Str(nPercTotal , 3) + "%")
		
	EndIf

Return

Static Function fCriaSRD()
	
	Local cAliasOri		:= ""
	Local cAliasDest	:= ""
	Local cArqOri		:= ""
	Local cArqDest		:= ""
	Local aDados		:= {}
	Local nX			:= 0
	Local nLen			:= 0
	Local aFields		:= {}
	Local xDado
	Local nCampo		:= 0
	
	cAliasOri	:= GetNextAlias()
	cAliasDest	:= GetNextAlias()
	
	cArqOri		:= "SRDORI01"
	cArqDest	:= "SRDORI"
	
	dbUseArea(.T. , "TOPCONN" , cArqOri  , cAliasOri  , .F. , .T.)
	dbUseArea(.T. , "TOPCONN" , cArqDest , cAliasDest , .F. , .F.)
	
	aFields	:= StrToKarr((cAliasOri)->CAMPO , ";")
	
	(cAliasOri)->(dbSkip())
	
	Do While (cAliasOri)->(!EOF())
	
		aDados	:= StrToKarr((cAliasOri)->CAMPO , ";")
		
		nLen	:= Len(aFields)
		
		If ( RecLock(cAliasDest , .T.) )
		
			For nX := 1 TO nLen
			
				xDado	:= aDados[nX]
				
				nCampo	:= FieldPos(aFields[nX])
				
				If ( TamSx3(aFields[nX])[3] == "N" )
					
					xDado	:= Val(xDado)
					
				ElseIf TamSx3(aFields[nX])[3] == "C"
				
					xDado	:= StrZero(Val(xDado) , Len((cAliasDest)->&(aFields[nX])))
					
				ElseIf TamSx3(aFields[nX])[3] == "D"
				
					xDado	:= cToD(xDado)
				
				EndIf
				
				FieldPut(nCampo , xDado)

			Next nX		
			
			(cAliasDest)->(MsUnlock())
		
		EndIf		
	
		(cAliasOri)->(dbSkip())
	
	EndDo
	
	(cAliasOri)->(dbCloseArea())
	(cAliasDest)->(dbCloseArea())

Return


Static Function fContaReg(cAlias)

	Local nTotReg		:= 0
	
	Do While (cAlias)->(!EOF())
	
		++nTotReg
		(cAlias)->(dbSkip())

	EndDo
	
	(cAlias)->(dbGoTop())
	
Return nTotReg


User Function Exclui02()

	Local cAliasSRD		:= ""
	Local aStruSRD		:= {}
	Local cArqTMP		:= ""
	Local cQuery		:= ""
	Local cWhere		:= ""
	Local nX			:= 0
	Local cFields		:= ""
	Local nLen			:= 0
	Local cGroupBy		:= ""
	Local nTotReg		:= 0
	Local nReg			:= 0
	Local cAliasDel		:= ""
	Local cArqSRD		:= ""
	Local cHoraIni	:= ""
	Local nPercent	:= 0
	Local nPercNew	:= 0
	Local lExibe		:= .F.
	
	// Seta job para nao consumir licencas
	RpcSetType(3)

	// Seta job para empresa filial desejada
	RpcSetEnv( '01', '01' ,,,'PON')
	
	cAliasSRD		:= "SRD"
	aStruSRD		:= (cAliasSRD)->(dbStruct())
	nLen			:= Len(aStruSRD)
	
	cArqTMP			:= GetNextAlias()	
	
	cArqSRD			:= RetSqlName("SRD")
	
	cHoraIni		:= Time()
	
	For nX := 1 TO nLen
	
		If !( AllTrim(aStruSRD[nX , 1]) == "RD_SEQ" )
			
			cFields	+= aStruSRD[nX , 1]
		
			If ( nX < nLen )
				
				cFields	+= ","
				
			EndIf

		EndIf
	
	Next nX
	
	cGroupBy	:= cFields
	
	cFields		+= ",QTD"
	
	cQuery		:= " WITH " + cArqTMP + "( " + cFields + " )"
	
	cQuery		+= " AS " + "( "
	
	cQuery			+= "SELECT " + cGroupBy + ",COUNT(*) AS QTD "
	
	cQuery			+= " FROM " + cArqSRD
	
	cQuery			+= " GROUP BY " + cGroupBy
	
	cQuery		+= " )"
	
	cQuery		+= " SELECT * FROM " + cArqTmp + " WHERE QTD > 1 "
	
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTMP , .F. , .T.)
	
	nTotReg		:= fContaReg(cArqTMP)
	
	ProcRegua(nTotReg)
	
	Do While (cArqTMP)->(!EOF())
	
		If ( ++nReg >= nPercNew )
		
			nPercNew	+= 100
			nPercent	:= (nReg * 100) / nTotReg
			
			ConOut("Processando registro : " + Str(nReg , 6) + " De : " + Str(nTotReg) + " - " + PadL(AllTrim(Str(Int(nPercent))) , 4) + " %" )			
			lExibe	:= .F.
			
		EndIf
		
		cAliasDel	:= GetNextAlias()

		cQuery		:= " SELECT R_E_C_N_O_ REGISTRO FROM " + cArqSRD + " " + cAliasDEL + " WHERE "
		
		cCondQry	:= ""
		
		For nX := 1 TO nLen
		
			If !( AllTrim(aStruSRD[nX , 1]) == "RD_SEQ" )
			
				xDado	:= (cArqTMP)->(FieldGet(FieldPos(aStruSRD[nX , 1])))
				
				If ( ValType(xDado) == "N" )
					
					xDado	:= AllTrim(Str(xDado))
					
				ElseIf ( ValType(xDado) == "D" )
				
					xDado	:= dToS(xDado)
				
				EndIf
				
				cCondQry	+= aStruSRD[nX , 1] + " = " + "'" + xDado + "'"					
			
				If ( nX < nLen )
					
					cCondQry	+= " AND "
					
				EndIf

			EndIf
		
		Next nX
		
		cQuery	+= cCondQry
		
		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasDEL , .F. , .T.)
		
		nContReg	:= 0
		
		Do While (cAliasDEL)->(!EOF())
		
			nContReg++
			
			If ( nContReg > 1 )
			
				(cAliasSRD)->(dbGoTo((cAliasDEL)->REGISTRO))
				
				If ( RecLock(cAliasSRD , .F.) )						
				
					(cAliasSRD)->(RD_EMPRESA)	:= 'X'						
					(cAliasSRD)->(RD_FILIAL)	:= '99'						
					
					(cAliasSRD)->(MsUnlock())
				
				EndIf
			
			EndIf
			
			(cAliasDEL)->(dbSkip())
		
		EndDo
		
		(cAliasDEL)->(dbCloseArea())
		
		nPercent	:= (nReg * 100) / nTotReg		
		
		If ( Int(nPercent) > Int(nPercNew) )
		
			nPercNew	:= Int(nPercent)
			lExibe		:= .T.
		
		EndIf		
		
		(cArqTMP)->(dbSkip())
	
	Enddo
	
	(cArqTMP)->(dbCloseArea())
	
	ConOut('Fim de processamento. Tempo decorrido : ' + ElapTime(cHoraIni , Time()))

Return