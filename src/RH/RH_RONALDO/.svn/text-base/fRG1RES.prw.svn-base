#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fCalcRG1  ³ Autor ³ Equipe RH            ³ Data ³ 26.04.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua carga dos lancamentos fixos.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fRG1RES()  
Local aArea			:= GetArea()
Local cAliasX		:= ""
Local cQuery		:= ""  
Local cVerba		:= ""
Local cVerbaDic 	:= "" 
Local cTpCalc		:= ""  
Local cNumId 		:= ""
Local cCodCor 		:= ""
Local cProp 		:= ""
Local cCC 			:= ""  
Local cTab 			:= ""    
Local cVbACu 		:= ""
Local cNIDAcu 		:= ""  
Local cTpVbAcu		:= ""   
Local dDtIniPgto 	:= CtoD("//")
Local dDtFimPagto 	:= CtoD("//")
Local dDtAdem		:= CtoD("//")
Local lInCorp 		:= .F.
Local lGravaRG1 	:= .F.  
Local lAdm 			:= .F.
Local lDem 			:= .F. 
Local nRef 			:= 0
Local nPercVrb 		:= 0  
Local nPosv 		:= 0  
Local nValTab 		:= 0  
Local nValor 		:= 0
Local nLin 			:= 0
Local nCol 			:= 0     
Local nPosPd		:= 0
Local nValSRC 		:= 0
Local nHorasSRC 	:= 0
Local nSeq 			:= 0 
Local nCasasDec		:= 0  
Local nDiaIniRG1	:= 0   
Local nDiaFimRG1	:= 0 
Local nDiasPer		:= If( SuperGetMV("MV_DIASPER", .F., "1") == "1", nDiasP, If(SRA->RA_TIPOPGT =="M", P_QTDIAMES, P_NTOTDIAS) )
Local nBaseAcu		:= 0 
Local nRefAcu		:= 0  
Local nSeqAcu       := 0

	If ( cTipoRot == "3" )
        cAnoMes := AnoMes(GetMemVar("RH_DATAINI"))    
 	EndIf 
 	
 	cAliasX:= GetNextAlias()
 	cQuery := " SELECT * FROM " + RetSqlName('RG1') + " WHERE "
 	cQuery += " RG1_FILIAL='" + SRA->RA_FILIAL + "' AND " + "RG1_MAT='" + SRA->RA_MAT + "' AND "    
  	cQuery += " RG1_DINIPG<= '" + cAnoMes +  STRZERO(F_ULTDIA(dDataRef),2) + "'"     
   	If ( cTipoRot == "4" )
   			cQuery += " AND ( RG1_ROT = '" + cRot + "' OR RG1_ROT = '" + fGetRotOrdinar() + "' ) AND "
   	Else
   		cQuery += " AND RG1_ROT = '" + cRot + "' AND "    
   	EndIf
    cQuery +="( RG1_DFIMPG =  '        ' "+ " OR " + "RG1_DFIMPG >= '" + cAnomes + '01' + "'  ) "    
    cQuery += " AND "    
    cQuery += " D_E_L_E_T_<> '*'"     
    cQuery += " ORDER BY RG1_FILIAL,RG1_MAT,RG1_ORDEM,RG1_PD,RG1_DINIPG"  
    cQuery := ChangeQuery(cQuery)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasX)
	
	cPpdAcFixos:= ""
	
	If (cAliasX)->( !EOF() )
		cVerbAdic := FGETCODFOL("0001") + "*" + FGETCODFOL("0002") + "*" + FGETCODFOL("0003") + "*" + FGETCODFOL("0004") + ;
					 "*" + FGETCODFOL("0005") + "*" + FGETCODFOL("0036") + "*" + FGETCODFOL("0037") + "*" + FGETCODFOL("0038") + ;
					 "*" + FGETCODFOL("0039")
	EndIf
		
    While (cAliasX)->( !EOF() )
	    
    	If (cAliasX)->RG1_AUTOM != "1"  //  Nao possui calculo automatico 
    		(cAliasX)->( dbSkip() )
			Loop
   		EndIf  
    		
		dDtFimPg 	:= (cAliasX)->RG1_DFIMPG
		cVerba 		:= (cAliasX)->RG1_PD   
		
		// Indenizacao rescisao
		If (  cVerba == fGetCodFol("0110")  )
			(cAliasX)->( dbSkip() )
			Loop
		EndIf      
		
		//Se for roteiro da Folha/AUT e funcionario demitido, nao faz o calculo
/*		If (cAliasX)->RG1_ROT $ "FOL*AUT" .And. cSitFolh == "D"
			(cAliasX)->( dbSkip() )
			Loop
		EndIf
*/		
		cTpCalc 	:= (cAliasX)->RG1_TPCALC
		nRef 		:= (cAliasX)->RG1_REFER   
		
		dbSelectArea("SRV")
		dbSetOrder(RetOrder("SRV", "RV_FILIAL+RV_COD"))
		If SRV->(dbSeek(xFilial("SRV", (cAliasX)->RG1_FILIAL)+ cVerba))
			nPercVrb 	:= If (SRV->RV_PERC == 0,100,SRV->RV_PERC) 
			cCodCor 	:= SRV->RV_CODCORR
			lIncorp 	:= If( SRV->RV_INCORP == "S",.T.,.F.)
		EndIf 
	  				
		cProp 		:= (cAliasX)->RG1_PROP
		cProp 		:= If( ( cProp == "1" .And. !( cVerba $ cVerbAdic ) )  ,"S","N")
		lGravaRG1 	:= .F.
		cCC 		:=  (cAliasX)->RG1_CC
		nValTab 	:= 0
		cNumID 		:= (cAliasX)->RG1_NUMID  
		
		// Posiciona na Matriz de Incidencia
		fIncide(cVerba)
		nPosv := aScan(aPdv, { |x| x[1] == cVerba } )
						
		Do Case  
			Case cTpCalc == "1"  // Valor
				nValor 		:= (cAliasX)->RG1_VALOR
				lGravaRG1 	:= .T.
			Case cTpCalc == "2"  // Dias 
				If aPdv[nPosv,34] == "1"
					nValor 		:= nRef * SALDOR / 100 * nPercVrb
				Else
					nValor 		:= nRef * SALDIA / 100 * nPercVrb
				EndIf				
				lGravaRG1 	:= .T.
			Case cTpCalc == "3"  // Horas 
				If aPdv[nPosv,34] == "1"
					nValor 		:= nRef * SALHOR / 100 * nPercVrb
				Else
					nValor 		:= nRef * SALHORA / 100 * nPercVrb
				EndIf
				lGravaRG1 	:= .T.
			Case cTpCalc == "4"  // Tabela  
				cTab := (cAliasX)->RG1_CODTAB
				nLin := (cAliasX)->RG1_LINHA
				nCol := (cAliasX)->RG1_COLUNA
				nValTab := FTABELA(CTAB,NLIN,NCOL)
				nRef := If( nRef == 0,nPercVrb,nRef)
				If ( ValType(nValTab) <> "U" )
					nValor := nRef * nValTab/ 100 
					lGravaRG1 := .T.
				EndIf
			Case cTpCalc == "5"  // Acumulador 
				cPpdAcFixos += (cAliasX)->RG1_PD + "-"    
				If ( cTipoRot $ "1*3" )      
					cVbAcu 		:= cVerba
					cNIDAcu 	:= (cAliasX)->RG1_NUMID   
					cTpVbAcu	:= SRV->RV_TIPO 
					nSeqAcu     := nSeq
					nRefAcu		:= nRef
      				nBaseAcu 	+= nRef * (cAliasX)->RG1_VALOR / 100
           		EndIf
				lGravaRG1 	:= .T.
			Case cTpCalc == "6"  // Percentual Salario Base  
				If aPdv[nPosv,34] == "1"
					nValor 		:= nRef * SALARIO / 100 * nPercVrb
				Else
					nValor 		:= nRef * SALMES / 100
				EndIf				 
				lGravaRG1 	:= .T.
			Case cTpCalc == "7"  // Percentual Salario Minimo  
				nValor 		:= nRef * VAL_SALMIN / 100 
				lGravaRG1 	:= .T.
		End Case
		
		NTOTADIC += nValor
		
		If ( cProp == "S" .And. cTpCalc <> "8" ) 
			dDtIniPgto 	:= DDATADE
   			dDtFimPagto := DDATAATE
      		dDtAdem		:= If( cTipoRot == "4", GetMemVar("RG_DATADEM"), SRA->RA_DEMISSA ) 
                    
            // Funcionario admitido no periodo que esta sendo calculado
            If ( ( lAdm := ( cAnoMes == AnoMes(SRA->RA_ADMISSA) ) ) )
        		dDtIniPgto := SRA->RA_ADMISSA
       		EndIf      				     			      
                                    
        	// Funcionario  demitido no periodo que esta sendo calculado
        	If ( ( lDem := ( cAnoMes == AnoMes(dDtAdem) ) ) )    
         		dDtFimPagto := dDtAdem  
    		EndIf
    
    		// Data do termino do pagamento dentro do periodo que esta sendo calculado
    		If ( ( cAnomes == AnoMes(StoD(dDtFimPg)) ) )    
      			If ( ( !lDem .Or. ( lDem .And. dDtFimPg < dDtAdem ) ) )    
         			dDtFimPagto := StoD(dDtFimPg)  
            	EndIf       
  			EndIf 
  					
  			// Data do termino do pagamento fora do periodo que esta sendo calculado
    		If ( ( cAnomes < AnoMes(StoD(dDtFimPg)) ) )    
      			dDtFimPagto := sToD( SubStr(dDtFimPg, 1, 4) + SubStr(dDtFimPg, 5, 2) + StrZero(nDiasPer, 2) )                		      
  			EndIf
    				
			nDiaIniRG1 	:= DAY(dDtIniPgto)
			nDiaFimRG1 	:= Min(DAY(dDtFimPagto),nDiasPer)
			If cTpCalc == "3"//Horas
				nRef	:= nRef / nDiasPer * DiasTrab
			Else
				nRef	:= ( nDiaFimRG1 - nDiaIniRG1 + 1 ) - NDIASAFAS
			EndIf 
			nValor 		:= nValor / nDiasPer * DiasTrab
		
		EndIf  
				
		If ( lGravaRG1 )   				
			nPosPd	:= FLocaliaPd( cVerba )   
			If cPaisLoc == "COL" 
				nCasasDec := RHDECIMAIS
			Else           
				nCasasDec := 2
			EndIf 	 
			// Verba existe no aPd com tipo diferente de 'I - Informado'				
			If (  nPosPd > 0 .And. aPd[nPosPd,07] # "I" ) 
				If ( SRV->RV_QTDLANC $ " *1" )    
					nValSRC 		:= aPd[nPosPd,05]    
					nHorasSRC 		:= If (aPd[nPosPd,06]=="H",fConvHoras(aPd[nPosPd,04],"1"),aPd[nPosPd,04])    
					aPd[nPosPd,05]	+= nValSRC		//Valor
					aPd[nPosPd,04]	+= nHorasSRC	//Horas  
				EndIf        
				If ( SRV->RV_QTDLANC > "1" .And. nValor > 0 )   
					FMatriz(cVerba, Round(nValor, nCasasDec),  nRef, CNUMPAG, cCC , SRV->RV_TIPO,,,,,.T., STR(nSeq,1),,,,cNumID)   
				EndIf    
    		EndIf
                    
    		// Verba nao existe no aPd, permite lancamento e valor maior que zero
			// Nao sendo do tipo acumulador e roteiro de Folha/Ferias
 			If nPosPd == 0 .And. SRV->RV_QTDLANC <> "0" .And. nValor > 0 .And.  If(cTpCalc == "5" .And. !cTipoRot $ "1*3", .F., .T.) 
    			FMatriz(cVerba, Round(nValor, nCasasDec),  nRef,CNUMPAG,cCC,SRV->RV_TIPO ,,,,,.T.,STR(nSeq,1),,,,cNumID)    
       		EndIf
                    
        	// Codigo correspondente a verba
        	If ( !Empty(cCodCor) )    
        		PosSRV(cCodCor,SRA->RA_FILIAL) 
        		nPosPd	:= FLocaliaPd( cVerba )     
          		If ( nPosPd > 0 )    
            		If ( SRV->RV_QTDLANC $ " *1" )    
	              		nValSRC 		:= aPd[nPosPd,05]    
						nHorasSRC 		:= If (aPd[nPosPd,06]=="H",fConvHoras(aPd[nPosPd,04],"1"),aPd[nPosPd,04])    
						aPd[nPosPd,05]	+= nValSRC		//Valor
						aPd[nPosPd,04]	+= nHorasSRC	//Horas     
                     EndIf   
    
                    If ( SRV->RV_QTDLANC > "1" .And. nValor > 0 )    
						FMatriz(cCodCor, Round(nValor, nCasasDec),  nRef,CNUMPAG,cCC,SRV->RV_TIPO,,,,,.T.,STR(nSeq,1),,,,cNumID )    
                    EndIf    
                EndIf
        
        		If nPosPd == 0  .And. SRV->RV_QTDLANC <> "0" .And. nValor > 0 
          			FMatriz(cCodCor, Round(nValor, nCasasDec),nRef,CNUMPAG,cCC,SRV->RV_TIPO,,,,,.T.,STR(nSeq,1),,,,cNumID)   
        		EndIf    
          	EndIf  
                                        
        EndIf  
        
        SRV->(dbCloseArea())
				    
	   (cAliasX)->( dbSkip() )
	EndDo  
		
	// Existiram lancamentos do tipo acumulador
	If nBaseAcu > 0     
		nValor 	:= nBaseAcu
		FMatriz(cVbAcu, Round(nValor, nCasasDec),nRefAcu,CNUMPAG,cCC,cTpVbAcu,,,,,.T.,STR(nSeqAcu,1),,,,cNIDAcu)  			
	EndIf
		
	(cAliasX)->(dbCloseArea())
	
RestArea(aArea)

Return( Nil )
