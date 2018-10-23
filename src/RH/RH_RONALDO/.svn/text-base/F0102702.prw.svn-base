#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"


/*/ {Protheus.doc} F0102702()

@Project     MAN00000011501_EF_027
@author      Aline S Damasceno
@since       29/11/2015
@param  	 oModel 	- modelo da apuração
@since       29/11/2015
@version     P12.1.6
@Return      confirmação da geração da medição
@Obs         Função utilizada no processo de geração das medições através da apuração
/*/

User Function F0102702(oModel)

Local cMV_PAR01 := ''
Local cMV_PAR02 := ''
Local cMV_PAR03 := ''

Local cLocal    := ''
Local cAliasPLA := GetNextAlias()
Local cAliasCNB := GetNextAlias()
Local cAliasExt := GetNextAlias()

Local nI        := 0
Local nJ        := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nPos		:= 0
Local nItePed   := 0
Local nPosLocal := 0
Local nDecTFW   := 2
Local nDecTFX	:= 2
Local nDecTFY 	:= 2
Local nOperacao := 0

//Local cLocal    := ''
Local xAux      := Nil
Local xAuxPed   := Nil
Local nPosIAP   := 0
Local cNumPed   := ""
Local cWhereCob := ""
Local cOpcApu	:= ""
Local cQuery    := ''
Local cItem     := '0'
Local cIdPonto  := '' 
Local cIdModel  := '' 
Local cNumMed	:= ''

Local aPedCabec := {}
Local aPedItens := {}
Local aLocPed   := {}
Local aItePed   := {}
Local aAreaSX3  := {}
Local aPlan     := {}
Local aMedGCT   := {}
Local aTEVUpdate:= {}

Local aCabApu	:= {} // Dados para o cabecalho da apuração
Local aIteApu	:= {} // Dados para os dados da medicao normal
Local aItExApu  := {} // Dados para a medicao dos valores excedentes
Local aCmboCmp  := {}
Local aCabe	    := {}
Local aItem	    := {}
Local aItemExc  := {}
Local nPosPlan  := 0
Local nPosCab	:= 0
Local nPosExt   := 0
Local nTotMed   := 0 
Local nTotExt   := 0
Local nTotCab   := 0
Local nCount    := 0
Local nCountCNB := 0
Local cCodPai   := ''
Local cRevCtr   := ''

Local lRet      := .T. 
Local lMedExt   := .F.
Local nOperacao := 3


If oModel <> Nil
	nOperacao := oModel:GetOperation()
	lMedExt    := nOperacao==2
	cOpcApu	   := oModel:GetModel("TFVMASTER"):GetValue("TFV_HREXTR")
	cMV_PAR01  := oModel:GetModel("TFVMASTER"):GetValue("TFV_CONTRT")  // Contrato
	cMV_PAR02  := oModel:GetModel("TFVMASTER"):GetValue("TFV_DTINI")   // Data Inicial
	cMV_PAR03  := oModel:GetModel("TFVMASTER"):GetValue("TFV_DTFIM")   // Data Final
	cRevCtr    := Posicione("CN9",1,xFilial("CN9")+cMV_PAR01,"CN9_REVISA")
	cLocal     := "%("
	
	If lMedExt
		BeginSql Alias cAliasExt
		
			SELECT 
				TFL.TFL_CODIGO, TFL.TFL_LOCAL, TFL.TFL_CONTRT, TFL.TFL_CONREV, TFL.TFL_PLAN,
		  		TFL.TFL_ITPLRH, TFL.TFL_ITPLMI, TFL.TFL_ITPLMC, TFL.TFL_ITPLLE, ABS.ABS_CCUSTO, 
		  		TFJ.TFJ_CODENT, TFJ.TFJ_LOJA, TFJ.TFJ_CONDPG
		  	FROM 
		  		%table:TFL% TFL
			JOIN %table:ABS% ABS ON
		  		ABS.ABS_FILIAL = %xFilial:ABS% AND
		  		ABS.ABS_LOCAL = TFL.TFL_LOCAL AND 
		  		ABS.%NotDel%  		
			JOIN %table:TFJ% TFJ ON
				TFJ.TFJ_FILIAL = %xFilial:TFJ% AND 
				TFJ.TFJ_CODIGO = TFL.TFL_CODPAI AND 
				TFJ.%NotDel%  		
			WHERE 
				TFL.TFL_FILIAL = %xFilial:TFL% AND 
				TFL.TFL_CONTRT = %Exp:cMV_PAR01%  AND 
				TFL.TFL_CONREV = %Exp:cRevCtr%  AND 
				TFL.%NotDel%
		
		EndSql
		
		(cAliasExt)->(dbGoTop())
		
		While (cAliasExt)->(!Eof())	
			aAdd( aLocPed, { 	(cAliasExt)->TFL_CODIGO,; 
								(cAliasExt)->ABS_CCUSTO,; 
								(cAliasExt)->TFJ_CODENT,; 
								(cAliasExt)->TFJ_LOJA,;
								(cAliasExt)->TFJ_CONDPG } )
			
			nPosLocal := aScan(aItePed, { |x| x[1] == oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFL") } )		
			
			If nPosLocal == 0
			
				aAdd( aItePed, { oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFL"),; 
							 { { { "C6_ITEM", StrZero( 1, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFWDETAIL"):GetValue("TFW_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_TES", A930Tes( "TFF", oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFF") ), Nil } } } } )
							  	
			Else
			 
				nItePed := Len(aItePed[nPosLocal][2])+1
				
				aAdd( aItePed[nPosLocal][2], { { "C6_ITEM", StrZero( nItePed, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFWDETAIL"):GetValue("TFW_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRTOT"),nDecTFW), Nil },;
							  	{ "C6_TES", A930Tes( "TFF", oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFF") ), Nil } } )
			 
			EndIf	
			
			nPosLocal := aScan(aItePed, { |x| x[1] == oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFL") } )
			
			If nPosLocal == 0
			
				aAdd( aItePed, { oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFL"),; 
							 { { { "C6_ITEM", StrZero( 1, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFXDETAIL"):GetValue("TFX_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_TES", A930Tes( "TFG", oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFF") ), Nil } } } } )
							  	
			Else
			 
				nItePed := Len(aItePed[nPosLocal][2])+1
				
				aAdd( aItePed[nPosLocal][2], { { "C6_ITEM", StrZero( nItePed, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFXDETAIL"):GetValue("TFX_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED"),nDecTFX), Nil },;
							  	{ "C6_TES", A930Tes( "TFG", oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFF") ), Nil } } )
							  	
			EndIf
	
			nPosLocal := aScan(aItePed, { |x| x[1] == oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFL") } )
			
			If nPosLocal == 0
			
				aAdd( aItePed, { oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFL"),; 
							 { { { "C6_ITEM", StrZero( 1, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFYDETAIL"):GetValue("TFY_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_TES", A930Tes( "TFH", oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFF") ), Nil } } } } )
							  	
			Else
			 
				nItePed := Len(aItePed[nPosLocal][2])+1
				
				aAdd( aItePed[nPosLocal][2], { { "C6_ITEM", StrZero( nItePed, TamSx3('C6_ITEM')[1] ), Nil },; 
							  	{ "C6_PRODUTO", oModel:GetModel("TFYDETAIL"):GetValue("TFY_PRODUT"), Nil },;
							  	{ "C6_QTDVEN", 1, Nil },;
							  	{ "C6_PRCVEN", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_PRUNIT", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_VALOR", Round(oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED"),nDecTFY), Nil },;
							  	{ "C6_TES", A930Tes( "TFH", oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFF") ), Nil } } )
							  	
			EndIf	
			
			cLocal += "'" + (cAliasExt)->TFL_LOCAL + "'"
			
			(cAliasExt)->(dbSkip())
			
			If (cAliasExt)->(!Eof())
				cLocal += ","
			EndIf
		 
		EndDo
		(cAliasExt)->(dbCloseArea())	
	Else
			
		// Sql para buscar todos os locais e planilha disponiveis no contrato
		BeginSql Alias cAliasPLA
		
		
			Select * from %table:CNA% CNA
			INNER JOIN %table:TFJ% TFJ ON
			           TFJ.TFJ_FILIAL = %xFilial:TFJ% AND 
			           TFJ.TFJ_CONTRT = CNA_CONTRA AND 
			           TFJ.TFJ_CONREV = CNA_REVISA AND
			           TFJ.%NotDel%  
			INNER JOIN %table:TFL% TFL ON 
			           TFL.TFL_FILIAL = %xFilial:TFL% AND 
			           TFL.TFL_CONTRT = CNA_CONTRA AND 
			           TFL.TFL_CONREV = CNA_REVISA AND
			           TFL.%NotDel%  
			INNER JOIN %table:ABS% ABS ON 
			           ABS.ABS_FILIAL= %xFilial:ABS% AND 
			           ABS.ABS_LOCAL = TFL_LOCAL AND
			           ABS.%NotDel%  
			WHERE CNA.CNA_FILIAL=%xFilial:CNA% AND CNA.CNA_CONTRA = %Exp:cMV_PAR01%  AND CNA.CNA_REVISA= %Exp:cRevCtr% 
			ORDER BY CNA_NUMERO
		
		EndSql
		
		
		(cAliasPLA)->(dbGoTop())
		
		While (cAliasPLA)->(!Eof())	
			nCount++
			
		
			// Itens para o cabecalho da apuração
			aAdd(aCabApu, { 	(cAliasPLA)->TFL_CODIGO, (cAliasPLA)->TFL_CONTRT,; 
								(cAliasPLA)->TFL_CONREV, (cAliasPLA)->CNA_NUMERO,;
								0 } )//Total da medição
									
					
			BeginSql Alias cAliasCNB
		
					
			Select * from %table:CNB% CNB
				WHERE CNB.CNB_FILIAL = %xFilial:CNB% 
				AND CNB.CNB_CONTRA   = %Exp:cMV_PAR01%  
				AND CNB.CNB_REVISA   = %Exp:cRevCtr%  
				AND CNB.CNB_NUMERO   = %Exp:(cAliasPLA)->CNA_NUMERO%  
				ORDER BY CNB_NUMERO, CNB_ITEM
			
			EndSql
						
			While !(cAliasCNB)->(Eof())
						
					nCountCNB++							
					cCodPai := getTipo((cAliasPLA)->TFL_CONTRT,(cAliasPLA)->TFL_CONREV,(cAliasPLA)->CNA_NUMERO,(cAliasCNB)->CNB_ITEM )[1]
					cItem   := getTipo((cAliasPLA)->TFL_CONTRT,(cAliasPLA)->TFL_CONREV,(cAliasPLA)->CNA_NUMERO,(cAliasCNB)->CNB_ITEM )[2]
					
					aAdd(aIteApu, { cItem , (cAliasPLA)->TFL_CODIGO, (cAliasPLA)->CNA_NUMERO,; 
										  (cAliasCNB)->CNB_ITEM, 0,cCodPai} )
		
					// Verificar a quantidade de casas decimais dos campos
					aAreaSX3  := SX3->(GetArea())	
					DbSelectArea("SX3")
					SX3->(dbSetOrder(2))
					If SX3->(DbSeek("TFW_VLRTOT"))	
						nDecTFW := SX3->X3_DECIMAL 
					Endif	
					If SX3->(DbSeek("TFX_VLRMED"))	
						nDecTFX := SX3->X3_DECIMAL  
					Endif	
					If SX3->(DbSeek("TFY_VLRMED"))	
						nDecTFY := SX3->X3_DECIMAL  
					Endif	
					SX3->(RestArea(aAreaSX3))
		
					
					// ----- MEDIÇAO RH
					//Totalizando itens da apuração do RH
					For nI := 1 To oModel:GetModel("TFWDETAIL"):Length()	
							
						oModel:GetModel("TFWDETAIL"):GoLine(nI)
						
						If aIteApu[nCountCNB][1]== "RH" .And. aIteApu[nCountCNB][2] == oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFL").And. aIteApu[nCountCNB][6] == oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFF")
							nTotMed := oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRMED")  
							nTotExt := oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLREXT")		
							
							If cOpcApu == "1"
									
								nTotMed += nTotExt + aIteApu[nCountCNB][5]
								aIteApu[nCountCNB][5] := Round(nTotMed,2)
										
							Else				
							
								nTotMed += aIteApu[nCountCNB][5]			
								aIteApu[nCountCNB][5] := Round(nTotMed,2)	
								
								nPosExt := aScan( aItExApu, { |x| x[1] == 'RH' .And. ; 
																		             x[2] == aIteApu[nCountCNB][2] } )
																		             
								If nPosExt >  0			
									nTotExt += aItExApu[nPosExt][5]
									aItExApu[nPosExt][5] := Round(nTotExt,2)
								Else			
									aAdd(aItExApu, { 	aIteApu[nCountCNB][1], aIteApu[nCountCNB][2],;
														aIteApu[nCountCNB][3], aIteApu[nCountCNB][4],;
														Round(nTotExt,2) } )			
								EndIf				 
							Endif	
	
							aCabApu[nCount][5] += nTotMed +  nTotExt
						EndIf
										
					Next nI
					 
					 
					 
					// ----- MEDIÇAO MATERIAL DE IMPLANTACAO
					//Totalizando itens do Material de Implantaçao
					For nI := 1 To oModel:GetModel("TFXDETAIL"):Length()
						
						oModel:GetModel("TFXDETAIL"):GoLine(nI)
						      			
						If aIteApu[nCountCNB][1]== 'MI' .And. aIteApu[nCountCNB][2] == oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFL").And. aIteApu[nCountCNB][6] == oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFF")
							nTotMed := oModel:GetModel("TFXDETAIL"):GetValue("TFX_VLRMED") + aIteApu[nCountCNB][5]		
							aIteApu[nCountCNB][5] := Round(nTotMed,2)
			
							aCabApu[nCount][5] += nTotMed
						EndIf
	
						
					Next nI
			 
									
					// ----- MEDIÇAO MATERIAL DE CONSUMO
					//Totalizando itens do Material de Consumo
					For nI := 1 To oModel:GetModel("TFYDETAIL"):Length()
						
						oModel:GetModel("TFYDETAIL"):GoLine(nI)
	
						If  aIteApu[nCountCNB][1]== 'MC' .And. aIteApu[nCountCNB][2] == oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFL").And. aIteApu[nCountCNB][6] == oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFF")
							nTotMed := oModel:GetModel("TFYDETAIL"):GetValue("TFY_VLRMED") + aIteApu[nCountCNB][5]		
							aIteApu[nCountCNB][5] := Round(nTotMed,2)
							
							aCabApu[nCount][5] += nTotMed	
						EndIf	
					
					Next nI
					
					// ----- MEDIÇAO LOCACAO DE EQUIPAMENTO
					//Totalizando itens de Locacao de Equipamento
					For nI := 1 To oModel:GetModel("TFLDETAIL"):Length()
					
						oModel:GetModel("TFLDETAIL"):GoLine(nI)
						
						If aIteApu[nCountCNB][1]== 'LE' .And. aIteApu[nCountCNB][2] == oModel:GetModel("TFLDETAIL"):GetValue("TFL_CODIGO").And. aIteApu[nCountCNB][6] == oModel:GetModel("TFZDETAIL"):GetValue('TFZ_CODTFI')
						
							nTotMed := oModel:GetModel("TFLDETAIL"):GetValue("TFL_VALTOT") + aIteApu[nCountCNB][5]		
							aIteApu[nCountCNB][5] := Round(nTotMed,2)
							
							aCabApu[nCount][5] += nTotMed 
						EndIf
				
					Next nI
					
		
					
					(cAliasCNB)->(dbSkip())
				EndDo
		
				(cAliasCNB)->(dbCloseArea())
		
			
			cLocal += "'" + (cAliasPLA)->TFL_LOCAL + "'"
		
			 
			(cAliasPLA)->(dbSkip())
			
			If (cAliasPLA)->(!Eof())
				cLocal += ","
			EndIf
		EndDo
		
		
		(cAliasPLA)->(dbCloseArea())	
	EndIf
			
	If lMedExt
	
		// GERACAO DO PEDIDO PARA A MEDICAO FORA DO CONTRATO
		For nI:=1 To Len(aLocPed)	
			
			nPosLocal := aScan( aItePed, { |x| x[1] == aLocPed[nI][1] } )
			
			aPedCabec := {}
			aPedItens := {}
			xAuxPed   := {}
			aRateio   := {}		
		 
			If nPosLocal > 0
			
				For nX:=1 To Len(aItePed[nPosLocal][2])	
					aAdd( xAuxPed, {} )		
					For nY:=1 To Len(aItePed[nPosLocal][2][nX])				
						aAdd( xAuxPed[Len(xAuxPed)], aItePed[nPosLocal][2][nX][nY] )
					Next nY			
				Next nX	
				
				aPedItens := aClone( xAuxPed )		
										
			EndIf
			
			If Len(aPedItens) > 0
			
				aAdd( aPedCabec, { 'C5_TIPO'   , 'N', Nil } )
				aAdd( aPedCabec, { 'C5_CLIENTE', aLocPed[nI][3], Nil } )
				aAdd( aPedCabec, { 'C5_LOJACLI', aLocPed[nI][4], Nil } )
				aAdd( aPedCabec, { 'C5_CONDPAG', aLocPed[nI][5], Nil } )	
				
				aAdd( aRateio, { "01", { { { "AGG_ITEM"  , "01", Nil },;
											 { "AGG_PERC"  , 100, Nil },;
											 { "AGG_CC"    , aLocPed[nI][2], Nil },;
											 { "AGG_CONTA" , "", Nil },;
											 { "AGG_ITEMCT", "", Nil },;
											 { "AGG_CLVL"  , "", Nil } } } } )									
										
				lMsErroAuto := .F.
				MsExecAuto( { |w,x,y,z| MATA410( w, x, y, Nil, Nil, Nil, Nil, z ) }, aPedCabec, aPedItens, 3, aRateio )
									     
				If lMsErroAuto
					lRet := .F.
					xAuxPed := GetAutoGrLog()
					MostraErro()
				Else 
					lRet := .T.
					
					If !Empty(oModel:GetModel("TCVDETAIL"):GetValue("TCV_NUMAPU"))						
						oModel:GetModel("TCVDETAIL"):AddLine()
					EndIf
						 
					oModel:GetModel("TCVDETAIL"):SetValue("TCV_FILIAL", xFilial("TCV") )
					oModel:GetModel("TCVDETAIL"):SetValue("TCV_NUMAPU" , oModel:GetModel("TFVMASTER"):GetValue("TFV_CODIGO") )
					oModel:GetModel("TCVDETAIL"):SetValue("TCV_NUMPED" , SC5->C5_NUM )			
													
				EndIf	
							
			EndIf 
		
		Next nI
	
	Else 
		
		// REALIZACAO DA MEDICAO NO GCT, ATRAVES DOS DADOS COLETADOS E TOTALIZADOS
		nPosIAP  := 0
		aMedGCT  := {}
		cNumMed  := ""

		
		For nI:=1 To Len(aCabApu)
			aItemExc := {}		
			lRet := .T.
		
			If aCabApu[nI][5] > 0
		
			    // Cria matriz para atualizar os itens dos grids com numero e item da medição
	
				cNumMed := CriaVar('CND_NUMMED', .T.) 
			    
	                                                                                       
				aAdd( aMedGCT, { aCabApu[nI][1], cNumMed, "", "", "", "" } )     
			
				// Tela para seleção da competencia e parcela
				xAux := a930Com( cMV_PAR01, cRevCtr,aCabApu[nI][4], aCabApu[nI][1] )
				
				// Quando usuário fechar sem preessionar o Ok, aborta o processo de geração/gravação
				If !xAux == Nil
					// identifica a competência para geração da medição
					aCmboCmp := aClone( xAux ) 
					aCabe	:=	{}
					aItem	:=	{}
						
					// Cabecalho para envio da medição para o GCT	
					aAdd( aCabe, { "CND_FILIAL", xFilial("CND"), NIL } )	
					aAdd( aCabe, { "CND_CONTRA", aCabApu[nI][2], NIL } )
					aAdd( aCabe, { "CND_REVISA", aCabApu[nI][3], NIL } )
					aAdd( aCabe, { "CND_NUMERO", aCabApu[nI][4], NIL } )			
					
					//-------------------------------------
					//  Verifica se 
					If Len( aCmboCmp ) > 0
						aAdd( aCabe, { "CND_COMPET", aCmboCmp[1][1], NIL } )
						aAdd( aCabe, { "CND_PARCEL", aCmboCmp[1][2], NIL } )
					Else
						aAdd( aCabe, { "CND_COMPET", Space(TamSX3('CND_COMPET')[1]), NIL } )
						aAdd( aCabe, { "CND_PARCEL", Space(TamSX3('CND_PARCEL')[1]), NIL } )
					EndIf
						
					aAdd( aCabe, { "CND_NUMMED"	, cNumMed		, NIL } )
					aAdd( aCabe, { "CND_VLTOT"	, aCabApu[nI][5], NIL } )
						
					// Itens apurados para o RH 
					For nZ := 1 to len(aIteApu)
						
						If aIteApu[nZ][1]=='RH' .And. aIteApu[nZ][2]== aCabApu[nI][1] .And. aIteApu[nZ][3]== aCabApu[nI][4]
						
							aAdd( aItem, {} )
							aAdd( aItem[Len(aItem)], { "CNE_ITEM"  , aIteApu[nZ][4], NIL } )
							aAdd( aItem[Len(aItem)], { "CNE_VLTOT", aIteApu[nZ][5], NIL } )
							aMedGCT[Len(aMedGCT)][3] := aIteApu[nZ][4] // Item da Medição
											
							If cOpcApu == "2"
								nPosPlan := aScan( aItExApu, { |x| x[1] == 'RH' .And. x[2] == aCabApu[nI][1] } )
								If nPosPlan > 0 .AND. aItExApu[nPosPlan][5] > 0
									aAdd( aItemExc, {} )				
									aAdd( aItemExc[Len(aItemExc)], { "CNE_ITEM"  , aItExApu[nPosPlan][4], NIL } )
									aAdd( aItemExc[Len(aItemExc)], { "CNE_QUANT"  , 1, NIL } )
									aAdd( aItemExc[Len(aItemExc)], { "CNE_VLUNIT", aItExApu[nPosPlan][5], NIL } )	
								EndIf 	
							EndIf
								
						EndIf
						
						// Itens apurados para os materiais de implantação 
	
						If aIteApu[nZ][1]=='MI' .And. aIteApu[nZ][2]== aCabApu[nI][1] .And. aIteApu[nZ][3]== aCabApu[nI][4]
							aAdd( aItem, {} )
							aAdd( aItem[Len(aItem)], { "CNE_ITEM"  , aIteApu[nZ][4], NIL } )
							aAdd( aItem[Len(aItem)], { "CNE_VLTOT", aIteApu[nZ][5], NIL } )
							aMedGCT[Len(aMedGCT)][4] := aIteApu[nZ][4] // Item da Medição		
						EndIf
						
						// Itens apurados para os materiais de consumo 
				
						If aIteApu[nZ][1]=='MC' .And. aIteApu[nZ][2]== aCabApu[nI][1] .And. aIteApu[nZ][3]== aCabApu[nI][4]
							aAdd( aItem, {} )
							aAdd( aItem[Len(aItem)], { "CNE_ITEM"  , aIteApu[nZ][4], NIL } )
							aAdd( aItem[Len(aItem)], { "CNE_VLTOT", aIteApu[nZ][5], NIL } ) 
						EndIf
						
						// Itens apurados para os equipamentos de locacao 
	
						If aIteApu[nZ][1]=='LE' .And. aIteApu[nZ][2]== aCabApu[nI][1] .And. aIteApu[nZ][3]== aCabApu[nI][4]
							aAdd( aItem, {} )
							aAdd( aItem[Len(aItem)], { "CNE_ITEM"  , aIteApu[nZ][4], NIL } )
							aAdd( aItem[Len(aItem)], { "CNE_VLTOT", aIteApu[nZ][5], NIL } )
							aMedGCT[Len(aMedGCT)][6] := aIteApu[nZ][4] // Item da Medição		
						EndIf	
					Next nZ
						
					If Len(aCmboCmp) > 0 .And. ! A930Sld(	aCabe[2][2], aCabe[3][2], aCmboCmp[1][3], aCmboCmp[1][1], aCabe[8][2], ;
																cOpcApu, If( Len(aItExApu) > 0, aItExApu[nPosPlan][5], {} ) )
						MsgInfo("Valor total de medição não previsto no cronograma."+CRLF+"O mesmo deve ser reestruturado.")//"Valor total de medição não previsto no cronograma."+CRLF+"O mesmo deve ser reestruturado."
						lRet:= .F.
					EndIf	
					
					
					If lRet .And. Len(aCabe) > 0 .And. Len(aItem) > 0
						lMsErroAuto:= .F.
						MsExecAuto({|a,b,c,d|, CNTA120(a,b,c,Nil,Nil,Nil,d)},aCabe,aItem,3,aItemExc)
						If !lMsErroAuto
							lMsErroAuto := .F.						
							MsExecAuto({|a,b,c,d|, CNTA120(a,b,c,Nil,Nil,Nil,d)},aCabe,aItem,6,aItemExc)
							
							If lMsErroAuto
								If Empty(NomeAutoLog()) .OR. Empty(MemoRead(NomeAutoLog()))
									Help(,,'AT930ERRMD2',,'erro',1,0)
								Else
									MostraErro()
								EndIf
								lRet:= .F.
								Exit		
							EndIf
						Else
							If Empty(NomeAutoLog()) .OR. Empty(MemoRead(NomeAutoLog()))
								Help(,,'AT930ERRMD1',,'erro',1,0)
							Else
								MostraErro()
							EndIf
							lRet:= .F.
							Exit
						EndIf	
					EndIf
				EndIf	
			EndIf
		Next nI
	
	EndIf 
	
	cLocal += ")%"
	
	If lRet
		fGravaAp(lMedExt, oModel,cMV_PAR01,cMV_PAR02,cMV_PAR03,cRevCtr,aMedGCT,cLocal)
	EndIf

EndIf

Return lRet

/*/ {Protheus.doc} getTipo()

@Project     MAN00000011501_EF_027
@author      Aline S Damasceno
@since       29/11/2015
@param  	 cContra 	- numero do contrato
@param  	 cRevisa 	- numero da revisao
@param  	 cPlan 		- numero da planilha
@param  	 cItem 		- numero do item da planilha
@since       29/11/2015
@version     P12.1.6
@Return      Tipo do produto
@Obs         Função utilizada para identificar se produto é RH, MI, MC ou LE
/*/
Static Function getTipo(cContra,cRevisa,cPlan,cItem)
Local cTipo   := ''
Local cCodPai := ''
Local cAliasTipo:= GetNextAlias()

//Recursos Humanos
BeginSql Alias cAliasTipo
	SELECT * FROM %table:TFF%  TFF Where TFF_FILIAL= %xFilial:TFF%  
	     AND TFF.TFF_CONTRT = %Exp:cContra% 
	     AND TFF.TFF_CONREV = %Exp:cRevisa% 
         AND TFF.TFF_XPLAN  = %Exp:cPlan% 
	     AND TFF.TFF_XITPL  = %Exp:cItem%
	     AND TFF.%NotDel%  
EndSql

If (cAliasTipo)->(!Eof())	
	cCodPai := (cAliasTipo)->TFF_COD
	cTipo := 'RH'
EndIf

(cAliasTipo)->(dbCloseArea())	

//Material de Implementação
BeginSql Alias cAliasTipo
	SELECT * FROM %table:TFG%  TFG Where TFG_FILIAL= %xFilial:TFG%  
	     AND TFG.TFG_XCONTR = %Exp:cContra% 
	     AND TFG.TFG_XREVCO = %Exp:cRevisa% 
         AND TFG.TFG_XPLAN  = %Exp:cPlan% 
	     AND TFG.TFG_XITPL  = %Exp:cItem%
	     AND TFG.%NotDel%  
EndSql

If (cAliasTipo)->(!Eof())	
	cCodPai := (cAliasTipo)->TFG_CODPAI
	cTipo := 'MI'
EndIf

(cAliasTipo)->(dbCloseArea())	

//Material de Consumo
BeginSql Alias cAliasTipo
	SELECT * FROM %table:TFH%  TFH Where TFH_FILIAL= %xFilial:TFH%  
	     AND TFH.TFH_XCONTR = %Exp:cContra% 
	     AND TFH.TFH_XREVCO = %Exp:cRevisa% 
         AND TFH.TFH_XPLAN  = %Exp:cPlan% 
	     AND TFH.TFH_XITPL  = %Exp:cItem%
	     AND TFH.%NotDel%  
EndSql

If (cAliasTipo)->(!Eof())	
	cCodPai := (cAliasTipo)->TFH_CODPAI
	cTipo  := 'MC'
EndIf

(cAliasTipo)->(dbCloseArea())	

//Locação de Equipamentos
BeginSql Alias cAliasTipo
	SELECT * FROM %table:TFI%  TFI Where TFI_FILIAL= %xFilial:TFI%  
	     AND TFI.TFI_CONTRT = %Exp:cContra% 
	     AND TFI.TFI_CONREV = %Exp:cRevisa% 
         AND TFI.TFI_XPLAN  = %Exp:cPlan% 
	     AND TFI.TFI_XITPL  = %Exp:cItem%
	     AND TFI.%NotDel%  
EndSql

If (cAliasTipo)->(!Eof())	
	cCodPai := (cAliasTipo)->TFI_COD
	cTipo := 'LE'
EndIf

(cAliasTipo)->(dbCloseArea())	
Return {cCodPai,cTipo}


/*/ {Protheus.doc} a930Com()

@Project     MAN00000011501_EF_027
@author      Aline S Damasceno
@since       29/11/2015
@param  	 cContra 	- numero do contrato
@param  	 cRevisa 	- numero da revisao
@param  	 cPlan 		- numero da planilha
@param  	 cLocal     - Local x Orçamento que será selecionado a Competência
@since       29/11/2015
@version     P12.1.6
@Return      ExpL	aRet - array com valores da competência e parcela
@Obs         Tela de seleção da competência.
/*/

Static Function a930Com(cContrato,cRevis,cNumPlan,cLocal)
Local oDlg      := Nil
Local oOk		:= Nil
Local oCancel   := Nil
Local oBottom	:= Nil
Local oCombo	:= Nil
Local oPanel    := Nil
Local aAreaCNF  :=GetArea()
Local aCmboCmp  :={}
Local cCmboCmp  :=""
Local aRet      :={}
Local cTitulo	:= "Seleção de Competência"
Local cAliasCNF	:= "CNF" 
Local lRet	    := .F.
lOCAL cQuery    := ""
Local lOk       := .F.
Local cCronog   := ''

DbSelectArea(cAliasCNF)
DbSetOrder(1)
cAliasCNF:= GetNextAlias()
cQuery		:= "SELECT CNA_NUMERO, CNA_CONTRA, CNA_CRONOG, CNF_COMPET " 
cQuery		+= " FROM " + RetSQLName("CNA")
cQuery		+= " INNER JOIN " + RetSQLName("CNF")
cQuery		+= " ON "+ RetSQLName("CNA")+".CNA_CRONOG = "+ RetSQLName("CNF")+".CNF_NUMERO"
cQuery		+= " WHERE CNA_NUMERO ='"+cNumPlan+"'" 
cQuery		+= " AND CNA_CONTRA ='"+cContrato+"'"
cQuery		+= " AND CNA_REVISA ='"+cRevis+"'"
cQuery		+= " AND CNF_CONTRA ='"+cContrato+"'"
cQuery		+= " AND CNF_REVISA ='"+cRevis+"'"
cQuery      += " ORDER BY CNF_NUMERO, CNF_CONTRA, CNF_PARCEL "

cQuery		:= ChangeQuery(cQuery)	
DbUseArea(.T., "TOPCONN",TcGenQry(,,cQuery), cAliasCNF, .T., .T.)

cCronog	:=	(cAliasCNF)->CNA_CRONOG

While!(cAliasCNF)->(Eof()) 
	Aadd(aCmboCmp,(cAliasCNF)->CNF_COMPET)
	(cAliasCNF)->(DbSkip())
EndDo


oDlg := FWDialogModal():New()
	oDlg:SetBackGround( .T. )
	oDlg:SetTitle( cTitulo )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	oDlg:SetEscClose( .T. )
	oDlg:SetSize( 100, 150 )
	oDlg:EnableFormbar( .T. )

	//----------------------------------------
	// Cria a Janela
	//----------------------------------------
	oDlg:CreateDialog()

	//----------------------------------------
	// Cria o Painel
	//----------------------------------------
	oPanel := oDlg:GetPanelMain()

	oDlg:CreateFormBar()

	oSay := TSay():New( 10, 10, { || "Local x Orçamento: " + cLocal  }, oPanel,,,,,,.T.) //"Códido do Motivo:"


	oSay := TSay():New( 30, 10, { || "Selecione a Competência:" }, oPanel,,,,,,.T.) //"Selecione a Competência:"
	@ 30, 35  COMBOBOX oCombo VAR cCmboCmp ITEMS aCmboCmp SIZE 50, 10 OF oPanel PIXEL 	                   
	

  			
	oDlg:AddButton( "Confirmar"	,{|| lOk:= .T. , oDlg:Deactivate() }, "Confirmar"	, , .T., .F., .T., )//"Confirmar"	
	oDlg:AddButton( "Sair",{||  lOk:= .f. , oDlg:Deactivate() }, "Sair", , .T., .F., .T., )//"Sair"
	

oDlg:Activate()


If lOk
	Aadd(aRet,{cCmboCmp,Posicione("CNF",2,xFilial("CNF")+cContrato+cRevis+cCronog+cCmboCmp,"CNF_PARCEL"),cCronog})
Else
	aRet := Nil
EndIf

RestArea(aAreaCNF)
		
Return aRet



/*{Protheus.doc}  A930Sld()
@param 		ExpC:Contrato a ser utilzado na medicao
@param 		ExpC:Revisão do contrato a ser utilzado na medicao
@param 		ExpC:Cronograma financeiro do contrato a ser utilzado na medicao
@param 		ExpC:Competencia do contrato a ser utilzado na medicao
@param 		ExpN:Valor total da medição a ser consistido
@param 		ExpC:Indica o tipo de geração de excedentes selecionado pelo usuário na medição
@param 		ExpN:Valor total das horas extras

@author 	Serviços 
@since  	27/11/2014
@version	P12.1.6
@return 	lRet - confirmação da validação da competência
@Obs        Verifica se o saldo da medição do contrato, esta dentro do limite do cronograma financeiro.
*/

Static Function A930Sld(cContrato, cRevisao, cCronog, cComp, nValMed, cOpcHE, nVlrTotHE)

Local lRet    := .F.
Local nLimMed := 0
Local aArea   := GetArea()

Default cOpcHE 	:= "1" // por padrão considera normal+hora extra dentro do limite do contrato
Default nVlrTotHE 	:= 0

CN9->(dbSetOrder(1))

If CN9->(dbSeek(xFilial("CN9")+cContrato+cRevisao))
	
	dbSelectArea("CN1")
	CN1->(dbSetOrder(1))
	
	If CN1->(dbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
	
		nLimMed := CN1->CN1_LMTMED
		
		dbSelectArea("CNF")
		CNF->(dbSetOrder(2))
				
		If CNF->(dbSeek(xFilial("CNF")+cContrato+cRevisao+cCronog+cComp))
			
			If cOpcHE == "2" // caso HE seja cobrada como excedente da medição
				nValMed -= nVlrTotHE
			EndIf
					
			lRet := ((CNF->CNF_SALDO+((CNF->CNF_VLPREV*nLimMed)/100)) >= nValMed )		
		EndIf
			 
	EndIf
	
EndIf
	
RestArea(aArea)
	
Return(lRet)


/*{Protheus.doc}  A930Tes()

@param 		ExpC:Tipo da TES a ser retornada
@param 		ExpC:Codigo do recurso a ser pesquisado

@author 	Serviços 
@since  	27/11/2015
@return 	cRet - Retorna a TES do orçamento de serviços para a geração do pedido
@version	P12 
@Obs        Retorna a TES do orçamento de serviços para a geração do pedido
*/
Static Function A930Tes( cTipo, cCodTFF )

Local cRet      := ""
Local aArea	  := GetArea()
Local cAliasTES := GetNextAlias()

BeginSql Alias cAliasTES

	SELECT 
		TFJ.TFJ_TES, TFJ.TFJ_TESMI, TFJ.TFJ_TESMC 
	FROM 
		%table:TFF% TFF
	JOIN %table:TFL% TFL ON 
		TFL.TFL_FILIAL = %xFilial:TFL% AND	
		TFL.TFL_CODIGO = TFF.TFF_CODPAI AND 
		TFL.%NotDel%
	JOIN %table:TFJ% TFJ ON
		TFJ.TFJ_FILIAL = %xFilial:TFJ% AND 
		TFJ.TFJ_CODIGO = TFL.TFL_CODPAI AND 
		TFJ.%NotDel%
	WHERE 
		TFF.TFF_FILIAL = %xFilial:TFF% AND 
		TFF.TFF_COD = %Exp:cCodTFF% AND 
		TFF.%NotDel%
	
EndSql
		
If cTipo = "TFF"
	cRet := (cAliasTES)->TFJ_TES
ElseIf cTipo = "TFG"
	cRet := (cAliasTES)->TFJ_TESMI 
ElseIf cTipo = "TFH"
	cRet := (cAliasTES)->TFJ_TESMC
EndIf		
	
RestArea(aArea)

Return(cRet)


/*{Protheus.doc}  fGravaAp()

@param 		lMedExt:verifica se controla excedente
@param 		oModel    :Modelo da apuração da medição
@param 		cMV_PAR01 :numero do contrato
@param 		cMV_PAR02 :data inicial
@param 		cMV_PAR03 :data final
@param 		cRevCtr   :revisao do contrato
@param 		aMedGCT   :medição do GCT
@param 		cLocal    :base de atendimento

@author 	Serviços 
@since  	27/11/2015
@version	P12.1.6
@Obs        Grava as tabelas referente apuração da medição de serviços
*/
Static Function fGravaAp(lMedExt, oModel,cMV_PAR01,cMV_PAR02,cMV_PAR03,cRevCtr,aMedGCT,cLocal)
Local nI := 0
Local nJ := 0
Local nX := 0
Local nY := 0
Local nZ := 0
Local nVlrHora := 0					
Local nVlrTot  := 0
Local nPercHre := 0
Local nQtdBase := 0
Local xAux:= 0
Local aRetDet :={}
Local cAliasAB9 := GetNextAlias()
Local cAliasIMI := GetNextAlias()
Local cAliasIMC := GetNextAlias()
Local cAliasTEW := GetNextAlias()
Local nPosCNA  := 0
Local aTEVUpdate := {}

Local lFilTFF		:= FindFunction("ExistFilTFF") .And. ExistFilTFF()
Local cOperConc := if(Trim(Upper(TcGetDb())) $ "ORACLE,POSTGRES,DB2,INFORMIX","||","+")


cIdcABQ := "%ABQ.ABQ_CONTRT" + cOperConc + "ABQ.ABQ_ITEM" + cOperConc + "ABQ.ABQ_ORIGEM%"

// Atualiza as tabelas com dados gerados da medições do GCT

	FwModelActive(oModel) // restabele o model da apuração como o ativo

	If lMedExt	
		cWhereCob := "%TFF.TFF_COBCTR = '2' AND TFF.TFF_PRCVEN > 0%" 
	Else	 
	 	cWhereCob := "%TFF.TFF_COBCTR <> '2' %"
	EndIf

	//Populando campos para a apuração do RH
	
	IF !lFilTFF
		BeginSql Alias cAliasAB9
		
			SELECT 
				AB9.AB9_FILIAL, AB9.AB9_NUMOS, AB9.AB9_CODTEC, AB9.AB9_SEQ                                                                                                                         
			FROM 
				%table:ABB% ABB
			JOIN %table:AB9% AB9 ON 
				AB9.AB9_FILIAL = %xFilial:AB9% AND 
				AB9.AB9_ATAUT = ABB.ABB_CODIGO AND 
				AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND
				RTrim(LTrim(AB9.AB9_ITAPUR))=' ' AND
				AB9.%NotDel%
			JOIN %table:ABA% ABA ON 
				ABA.ABA_FILIAL = %xFilial:ABA% AND
				ABA.ABA_NUMOS = AB9.AB9_NUMOS AND 
				ABA.ABA_SEQ  =  AB9.AB9_SEQ AND
				ABA.%NotDel%
			JOIN %table:ABQ% ABQ ON 
				ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
				ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
				ABQ.%NotDel%
			JOIN %table:TFF% TFF ON 
				TFF.TFF_FILIAL = %xFilial:TFF% AND 
				TFF.TFF_COD = ABQ.ABQ_CODTFF AND
				%Exp:cWhereCob%				   AND			 
				TFF.%NotDel%
			JOIN %table:TFL% TFL ON
				TFL.TFL_FILIAL = %xFilial:TFL% AND 
				TFL.TFL_CODIGO = TFF.TFF_CODPAI AND 
				TFL.TFL_CONTRT = %Exp:cMV_PAR01% AND 
				TFL.TFL_CONREV = %Exp:cRevCtr% AND 
				TFL.%NotDel%	
			WHERE
				ABB.ABB_FILIAL = %xFilial:ABB% AND 
				ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
				ABB.ABB_DTINI >= %Exp:cMV_PAR02% AND 
				ABB.ABB_DTINI <= %Exp:cMV_PAR03% AND 
				ABB.ABB_DTFIM >= %Exp:cMV_PAR02% AND 
				ABB.ABB_DTFIM <= %Exp:cMV_PAR03% AND 
				ABQ.ABQ_CONTRT = %Exp:cMV_PAR01% AND
				ABB.%NotDel%
			GROUP BY 
				AB9.AB9_FILIAL, AB9.AB9_NUMOS, AB9.AB9_CODTEC, AB9.AB9_SEQ
		
		EndSql
	ELSE
		BeginSql Alias cAliasAB9
		
			SELECT 
				AB9.AB9_FILIAL, AB9.AB9_NUMOS, AB9.AB9_CODTEC, AB9.AB9_SEQ                                                                                                                         
			FROM 
				%table:ABB% ABB
			JOIN %table:AB9% AB9 ON 
				AB9.AB9_FILIAL = %xFilial:AB9% AND 
				AB9.AB9_ATAUT = ABB.ABB_CODIGO AND 
				AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND
				RTrim(LTrim(AB9.AB9_ITAPUR))=' ' AND
				AB9.%NotDel%
			JOIN %table:ABA% ABA ON 
				ABA.ABA_FILIAL = %xFilial:ABA% AND
				ABA.ABA_NUMOS = AB9.AB9_NUMOS AND 
				ABA.ABA_SEQ  =  AB9.AB9_SEQ AND
				ABA.%NotDel%
			JOIN %table:ABQ% ABQ ON 
				ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
				ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
				ABQ.%NotDel%
			JOIN %table:TFF% TFF ON 
				TFF.TFF_FILIAL = %xFilial:TFF% AND
				TFF.TFF_FILIAL = ABQ.ABQ_FILTFF AND 
				TFF.TFF_COD = ABQ.ABQ_CODTFF AND
				%Exp:cWhereCob%				   AND			 
				TFF.%NotDel%
			JOIN %table:TFL% TFL ON
				TFL.TFL_FILIAL = %xFilial:TFL% AND 
				TFL.TFL_CODIGO = TFF.TFF_CODPAI AND 
				TFL.TFL_CONTRT = %Exp:cMV_PAR01% AND 
				TFL.TFL_CONREV = %Exp:cRevCtr% AND 
				TFL.%NotDel%	
			WHERE
				ABB.ABB_FILIAL = %xFilial:ABB% AND 
				ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
				ABB.ABB_DTINI >= %Exp:cMV_PAR02% AND 
				ABB.ABB_DTINI <= %Exp:cMV_PAR03% AND 
				ABB.ABB_DTFIM >= %Exp:cMV_PAR02% AND 
				ABB.ABB_DTFIM <= %Exp:cMV_PAR03% AND 
				ABQ.ABQ_CONTRT = %Exp:cMV_PAR01% AND
				ABB.%NotDel%
			GROUP BY 
				AB9.AB9_FILIAL, AB9.AB9_NUMOS, AB9.AB9_CODTEC, AB9.AB9_SEQ
		
		EndSql
	ENDIF		

	dbSelectArea("AB9")
	AB9->(dbSetOrder(1))
	
	While (cAliasAB9)->(!Eof())		
	
		If AB9->(dbSeek(xFilial("AB9")+(cAliasAB9)->AB9_NUMOS + ;
						 (cAliasAB9)->AB9_CODTEC + (cAliasAB9)->AB9_SEQ))  
			Reclock("AB9",.F.)
			AB9->AB9_ITAPUR := FwFldGet("TFV_CODIGO")
			MsUnlock()				
		EndIf
		(cAliasAB9)->(dbSkip())
		
	EndDo
	
	If lMedExt
		cWhereCob := "%TFG.TFG_COBCTR = '2' AND TFG.TFG_PRCVEN > 0%" 
	Else		 
	 	cWhereCob := "%TFG.TFG_COBCTR <> '2' %"
	EndIf	
	
	// Populando campos para a apuração dos Materiais de implantação
	BeginSql Alias cAliasIMI
	
		SELECT 
			TFS.TFS_CODIGO
		FROM 
			%table:TFS% TFS
		JOIN %table:TFG% TFG ON
			TFG.TFG_FILIAL = %xFilial:TFG% AND 
			TFS.TFS_CODTFG = TFG.TFG_COD AND
			%Exp:cWhereCob%				 AND			
			TFG.%NotDel%
		JOIN %table:TFF% TFF ON
			TFF.TFF_FILIAL = %xFilial:TFF% AND 
			TFF.TFF_COD = TFG.TFG_CODPAI AND 
			TFF.%NotDel%	
	 	JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL% AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI AND 
			TFL.%NotDel%			
		WHERE
			TFS.TFS_FILIAL = %xFilial:TFS%  	AND
			RTrim(LTrim(TFS.TFS_ITAPUR))=' '   AND
			TFS.TFS_DTAPON >= %Exp:cMV_PAR02% 	AND
			TFS.TFS_DTAPON <= %Exp:cMV_PAR03% 	AND 
			TFL.TFL_CONTRT = %Exp:cMV_PAR01%  	AND
			TFL.TFL_CONREV = %Exp:cRevCtr%	AND
			TFF.TFF_LOCAL IN %Exp:cLocal%		AND			
			TFS.%NotDel%
								
	EndSql
	
	dbSelectArea("TFS")
	TFS->(dbSetOrder(1))
	
	While (cAliasIMI)->(!Eof())		
	
		If TFS->(dbSeek(xFilial("TFS")+(cAliasIMI)->TFS_CODIGO))
			Reclock("TFS",.F.)
			TFS->TFS_ITAPUR := FwFldGet("TFV_CODIGO")
			MsUnlock()				
		EndIf	
			
		(cAliasIMI)->(dbSkip())
		
	EndDo
	
	If lMedExt
		cWhereCob := "%TFH.TFH_COBCTR = '2' AND TFH.TFH_PRCVEN > 0%" 
	Else		 
	 	cWhereCob := "%TFH.TFH_COBCTR <> '2' %"
	EndIf		

	// Populando campos para a apuração dos Materiais de consumo
	BeginSql Alias cAliasIMC
		
		SELECT
			TFT.TFT_CODIGO
		FROM 
			%table:TFT% TFT
		JOIN %table:TFH% TFH ON
			TFH.TFH_FILIAL = %xFilial:TFH% AND 
			TFT.TFT_CODTFH = TFH.TFH_COD AND
			%Exp:cWhereCob%				 AND				
			TFH.%NotDel%
		JOIN %table:TFF% TFF ON
			TFF.TFF_FILIAL = %xFilial:TFF% AND 
			TFF.TFF_COD = TFH.TFH_CODPAI AND 
			TFF.%NotDel%
	 	JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL% AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI AND 
			TFL.%NotDel%						
		WHERE
			TFT.TFT_FILIAL = %xFilial:TFT% 		AND 
			RTrim(LTrim(TFT.TFT_ITAPUR))=' '   AND
			TFT.TFT_DTAPON >= %Exp:cMV_PAR02% 	AND
			TFT.TFT_DTAPON <= %Exp:cMV_PAR03% 	AND		
			TFL.TFL_CONTRT = %Exp:cMV_PAR01%  	AND
			TFL.TFL_CONREV = %Exp:cRevCtr%  	AND 
			TFF.TFF_LOCAL IN %Exp:cLocal%		AND
			TFT.%NotDel%		
	
	EndSql
		
	DbSelectArea("TFT")
	TFT->( DbSetOrder( 1 ) )
	
	While (cAliasIMC)->(!Eof())		
	
		If TFT->(dbSeek(xFilial("TFT")+(cAliasIMC)->TFT_CODIGO))
			Reclock("TFT",.F.)
			TFT->TFT_ITAPUR := FwFldGet("TFV_CODIGO")
			MsUnlock()				
		EndIf	
		
		(cAliasIMC)->(dbSkip())
			
	EndDo

	// Populando campos para a apuração dos Equipamentos de Locação
	BeginSql Alias cAliasTEW
	
		SELECT 
			TEW.TEW_FILIAL, TEW.TEW_CODMV 
		FROM 
			%table:TEW% TEW
		JOIN %table:TFI% TFI ON
			TFI.TFI_FILIAL = %xFilial:TFI%  AND 
			TFI.TFI_COD = TEW.TEW_CODEQU    AND 
			TFI.%NotDel%
		JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL%  AND
			TFL.TFL_CODIGO = TFI.TFI_CODPAI AND 
			TFL.TFL_CONTRT = %Exp:cMV_PAR01% AND 
			TFL.TFL_CONREV = %Exp:cRevCtr% AND 
			TFL.%NotDel%	
		WHERE 	
			TEW.TEW_FILIAL = %xFilial:TFT%	     AND 			
			TEW.TEW_DTRINI <= %Exp:cMV_PAR03% AND 
			(
				(LTRIM(RTRIM(TEW.TEW_DTRFIM)) = ' ' OR TEW.TEW_DTRFIM >= %Exp:cMV_PAR02%) AND
				(LTRIM(RTRIM(TEW.TEW_DTAMNT)) = ' ' OR TEW.TEW_DTAMNT >= %Exp:cMV_PAR02%) 
			) AND			
			TEW.%NotDel%
	EndSql
	
	DbSelectArea("TEW")
	TEW->( DbSetOrder( 1 ) )
	
	While (cAliasTEW)->(!Eof())		
	
		If TEW->(dbSeek(xFilial("TEW")+(cAliasTEW)->TEW_CODMV))
			Reclock("TEW",.F.)
			TEW->TEW_ITAPUR := FwFldGet("TFV_CODIGO")
			MsUnlock()				
		EndIf	
		
		(cAliasTEW)->(dbSkip())	
			
	EndDo
	
	// Atualizando os grids com os dados de medição gerada pelo GCT
	//Atualizando itens da apuração do RH
	nVlrHora := 0					
	nVlrTot  := 0
	nPercHre := 0
	
	For nI := 1 To oModel:GetModel("TFWDETAIL"):Length()
			
		oModel:GetModel("TFWDETAIL"):GoLine(nI)		
		nPosCNA := aScan( aMedGCT, { |x| x[1] == oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFL") } )
		
		If nPosCNA > 0 
			oModel:GetModel("TFWDETAIL"):SetValue("TFW_NUMMED", aMedGCT[nPosCNA][2])
			oModel:GetModel("TFWDETAIL"):SetValue("TFW_ITMED", aMedGCT[nPosCNA][3])
		EndIf
		
		//Atualizando a tabela de detalhes da apuração		
		aRetDet := A930QDetRH( oModel:GetModel("TFVMASTER"):GetValue("TFV_CONTRT"),; 
								   oModel:GetModel("TFVMASTER"):GetValue("TFV_DTINI"),; 
								   oModel:GetModel("TFVMASTER"):GetValue("TFV_DTFIM"),; 
						          oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFF"),;
						          oModel:GetModel("TFWDETAIL"):GetValue("TFW_CODTFL"),; 
						          oModel:GetModel("TFVMASTER"):GetValue("TFV_CODIGO"),; 
						          .F., lMedExt)
						  
		For nX:=1 To Len(aRetDet[1])		
			For nY:=1 To Len(aRetDet[1][nX])					
				
				If !Empty(oModel:GetModel("TIPDETAIL"):GetValue("TIP_CODEQU")) .And. ;
					!Empty(oModel:GetModel("TIPDETAIL"):GetValue("TIP_CODTEC"))
					
					oModel:GetModel("TIPDETAIL"):AddLine()
				EndIf 				
				
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_FILIAL", xFilial("TIP")		   )
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_CODTEC", aRetDet[1][nX][nY][1])
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_QTDE"  , aRetDet[1][nX][nY][3])
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_VLRAPR", aRetDet[1][nX][nY][4])
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_DTINI" , FwFldGet("TFV_DTINI"))
				oModel:GetModel("TIPDETAIL"):SetValue("TIP_DTFIM" , FwFldGet("TFV_DTFIM"))
				
				If nX == 2 
					
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_HEMOT", aRetDet[1][nX][nY][5])					
										
					nPercHre := aRetDet[1][nX][nY][4] / oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLHORE")					
					nVlrTot := oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLREXT") * nPercHre
					 
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_VLRMED", nVlrTot)
					
				Else 
					
					nVlrHora :=	oModel:GetModel("TFWDETAIL"):GetValue("TFW_VLRMED") / ;
								   	oModel:GetModel("TFWDETAIL"):GetValue("TFW_HORAN")
					
					nVlrTot := aRetDet[1][nX][nY][3] * nVlrHora	   	
								   	 						
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_VLRMED", nVlrTot) 
						
				EndIf 					
			
			Next		
		Next 
		
	Next nI
		
	//Atualizando itens do Material de Implantaçao
	For nI := 1 To oModel:GetModel("TFXDETAIL"):Length()
			
		oModel:GetModel("TFXDETAIL"):GoLine(nI)		
		nPosCNA := aScan( aMedGCT, { |x| x[1] == oModel:GetModel("TFXDETAIL"):GetValue("TFX_CODTFL") } )	
		
		If nPosCNA > 0 
			oModel:GetModel("TFXDETAIL"):SetValue("TFX_NUMMED", aMedGCT[nPosCNA][2])
			oModel:GetModel("TFXDETAIL"):SetValue("TFX_ITMED", aMedGCT[nPosCNA][4])
		EndIf		
	
	Next nI
	
	//Atualizando itens do Material de Consumo
	For nI := 1 To oModel:GetModel("TFYDETAIL"):Length()
			
		oModel:GetModel("TFYDETAIL"):GoLine(nI)		
		nPosCNA := aScan( aMedGCT, { |x| x[1] == oModel:GetModel("TFYDETAIL"):GetValue("TFY_CODTFL") } )
		
		If nPosCNA > 0 
			oModel:GetModel("TFYDETAIL"):SetValue("TFY_NUMMED", aMedGCT[nPosCNA][2])
			oModel:GetModel("TFYDETAIL"):SetValue("TFY_ITMED", aMedGCT[nPosCNA][5])
		EndIf
	
	Next nI
	
	//Atualizando itens de Locacao de Equipamento
	For xAux := 1 To oModel:GetModel("TFLDETAIL"):Length()
		oModel:GetModel("TFLDETAIL"):GoLine(xAux)

		nPosCNA := aScan( aMedGCT, { |x| x[1] == oModel:GetModel("TFLDETAIL"):GetValue("TFL_CODIGO") } )
		
		If nPosCNA > 0 
		
			For nJ := 1 To oModel:GetModel("TFIPRODUT"):Length()
				oModel:GetModel("TFIPRODUT"):GoLine(nJ)
				
				aRetDet  := A930QDetLE(oModel:GetModel("TFIPRODUT"):GetValue("TFI_COD"))
				nQtdBase := Len(aRetDet)				
									
				For nI := 1 To oModel:GetModel("TFZDETAIL"):Length()
				
					oModel:GetModel("TFZDETAIL"):GoLine(nI)		
					oModel:GetModel("TFZDETAIL"):SetValue("TFZ_NUMMED", aMedGCT[nPosCNA][2])
					oModel:GetModel("TFZDETAIL"):SetValue("TFZ_ITMED", aMedGCT[nPosCNA][6])
					
					aAdd( aTEVUpdate, { oModel:GetModel("TFZDETAIL"):GetValue('TFZ_CODTFI'), ;
										oModel:GetModel("TFZDETAIL"):GetValue('TFZ_CODTEV'), ;
										oModel:GetModel("TFZDETAIL"):GetValue('TFZ_QTDAPU') } )
															
					If oModel:GetModel("TFZDETAIL"):GetValue("TFZ_MODCOB") == "2"
					
						For nX := 1 To nQtdBase							
							aRetDet[nX][4] := oModel:GetModel("TFZDETAIL"):GetValue("TFZ_VLRUNI") * aRetDet[nX][2]							
							aRetDet[nX][5] := oModel:GetModel("TFZDETAIL"):GetValue("TFZ_QTDAPU") * aRetDet[nX][7] 																					 
							aRetDet[nX][6] := oModel:GetModel("TFZDETAIL"):GetValue("TFZ_VLRUNI") * aRetDet[nX][5]														
						Next
					 
					Else
					
						For nX := 1 To nQtdBase
							
							aAdd( aRetDet, { aRetDet[nX][1],; 						    						// Base de atendimento  
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_QTDE")  ,; 						// Qtde prevista na apuracao								
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_MODCOB"),; 			  			// Modo de cobrança
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_VLRUNI") * ;
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_QTDE"),;   			  			// Valor apurado 
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_QTDAPU") * aRetDet[nX][7],; 	// Qtde medida								
								oModel:GetModel("TFZDETAIL"):GetValue("TFZ_VLRUNI") * ;
								(oModel:GetModel("TFZDETAIL"):GetValue("TFZ_QTDAPU") * aRetDet[nX][7]),; 	// Valor medido
								aRetDet[nX][7] } )																// Percentual do item equivalente a locação 
							
						Next 
					
					EndIf
					
				Next nI
				
				For nX:=1 To Len(aRetDet)		
					
					If !Empty(oModel:GetModel("TIPDETAIL"):GetValue("TIP_CODEQU")) .Or. ;
						!Empty(oModel:GetModel("TIPDETAIL"):GetValue("TIP_CODTEC"))
						
						oModel:GetModel("TIPDETAIL"):AddLine()
					EndIf
					 
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_FILIAL", xFilial("TIP")		   )
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_DTINI" , FwFldGet("TFV_DTINI")  )
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_DTFIM" , FwFldGet("TFV_DTFIM")  )
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_CODEQU", aRetDet[nX][1]			)
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_QTDE"  , aRetDet[nX][2]			) 
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_HEMOT" , aRetDet[nX][3]			)	
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_VLRAPR", aRetDet[nX][4]			)
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_QTDMED", aRetDet[nX][5]			)			
					oModel:GetModel("TIPDETAIL"):SetValue("TIP_VLRMED", aRetDet[nX][6]			) 
				
				Next
			
			Next nJ
		
		EndIf	
				
	Next xAux
	
	//Atualiza o saldo dos registros da TEV
	DbSelectArea('TEV')
	TEV->(DbSetOrder(1))  // TEV_FILIAL+TEV_CODLOC+TEV_ITEM
	For nI := 1 To Len(aTEVUpdate)
	
		If TEV->(DbSeek(xFilial('TEV')+aTEVUpdate[nI,1]+aTEVUpdate[nI,2]))
			
			nJ := TEV->TEV_SLD - aTEVUpdate[nI,3]
			Reclock('TEV', .F.)
			TEV->TEV_SLD := nJ
			TEV->(MsUnlock())
			
		EndIf
	
	Next nI


Return

/*{Protheus.doc}  A930QDetRH()
@param 		ExpC:Contrato a ser utilzado no detalhe
@param 		ExpC:Data Inicial da apuração/medição
@param 		ExpC:Data Final da apuração/medição
@param 		ExpC:Codigo do recurso humano a ser utilizado no detalhe
@param 		ExpC:Codigo do local a ser utilizado no detalhe
@param 		ExpC:Codigo da apuração para a pesquisa no estorno
@param 		ExpL:Para identificar se vai ser retornado dados para a tela ou processamento

@author 	Serviços 
@since  	27/11/2015
@version	P12 
@return 	ExpA: Array com os dados do detalhe do RH
@obs		Gera as informações do detalhes de horas apuradas do RH.
/*/
Static Function A930QDetRH(cContrato, cDataIni, cDataFim, cCodTFF, cCodTFL, cIdApur, lTela,lMedExt)

Local aRet      := {}
Local aHrNormal := {}
Local aTecHrN   := {}
Local aHrExtra  := {}
Local aTecHrE   := {}
Local aHrOsE    := {}
Local cHora 	  := ""
Local cMinutos  := "" 
Local cMod 	  := ""
Local cIdcABQ   := ""
Local cWhereCob := ""
Local nPos      := 0
Local nVlrTot   := 0
Local nHreTot   := 0
Local nTecHor   := 0
Local nValTot   := 0 
Local cAliasAB9 := GetNextAlias()
Local cAliasABR := GetNextAlias()

Local cRevCtr   := Posicione("CN9",7,xFilial("CN9")+cContrato+"05","CN9_REVISA")
Local cOperConc := if(Trim(Upper(TcGetDb())) $ "ORACLE,POSTGRES,DB2,INFORMIX","||","+")
Local cOperador := "%" + cOperConc + "%"

Local lFilTFF   := FindFunction("ExistFilTFF") .And. ExistFilTFF()

Default cIdApur := ""
Default lTela   := .T.

If Trim(Upper(TcGetDb())) $ "ORACLE,POSTGRES,DB2,INFORMIX"	
			
	//Calculo para horas
	cHora    := "(SUM(CAST(LEFT(ABR.ABR_TEMPO,2) AS INTEGER)) * 60)"
	
	//Calculo para minutos
	cMinutos := "SUM(CAST(RIGHT(ABR.ABR_TEMPO,2) AS INTEGER))" 
	
	cMod := "%Right( Concat( '00', Cast((" + cHora + "+" + cMinutos + ") / 60 as VarChar(2))),2)"
	cMod += " || ':' || "
	cMod += "Right( Concat( '00', Cast(Mod((" + cHora + "+" + cMinutos + "), 60) as VarChar(2))),2)%" 

Else

	//Calculo para horas
	cHora := "( Sum(datepart(hh,convert(varchar,ABR.ABR_TEMPO,108))) * 60 + " 
	cHora += "Sum(datepart(mi,convert(varchar,ABR.ABR_TEMPO,108))) ) / 60"
	
	//Calculos para os minutos
	cMinutos := "( Sum(datepart(hh,convert(varchar,ABR.ABR_TEMPO,108))) * 60 + " 
	cMinutos += "Sum(datepart(mi,convert(varchar,ABR.ABR_TEMPO,108))) ) % 60"

	//Horas formatadas
	cMod := "%Replicate('0', 2 - DataLength(LTrim(RTrim(Convert(Varchar, " + cHora + " ))))) + "
	cMod += "Convert(Varchar," + cHora + ") + ':' + "
 	cMod += "Replicate('0', 2 - DataLength(Ltrim(Rtrim(Convert(Varchar, " + cMinutos + "))))) + " 
	cMod += "Convert(Varchar," + cMinutos + ")%"
	   
EndIF	

cIdcABQ := "%ABQ.ABQ_CONTRT" + cOperConc + "ABQ.ABQ_ITEM" + cOperConc + "ABQ.ABQ_ORIGEM%"

If lMedExt	
	cWhereCob := "%TFF.TFF_COBCTR = '2' AND TFF.TFF_PRCVEN > 0%" 
Else	 
 	cWhereCob := "%TFF.TFF_COBCTR <> '2' %"
EndIf

// Aba detalhes Recursos Humanos - Horas Normais
IF !lFilTFF
	BeginSql Alias cAliasAB9
		
		SELECT
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG,
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN
	  	FROM
			%table:ABB% ABB
		JOIN %table:AB9% AB9 ON 
			AB9.AB9_FILIAL = %xFilial:AB9% AND 
			AB9.AB9_ATAUT = ABB.ABB_CODIGO AND
			AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND 
			RTrim(LTrim(AB9.AB9_ITAPUR))=%Exp:cIdApur% AND
			AB9.%NotDel%	
	   JOIN %table:AB7% AB7 ON 
	  		AB7.AB7_FILIAL = %xFilial:AB7% AND 
	  		AB7.AB7_NUMOS %Exp:cOperador% AB7.AB7_ITEM = AB9.AB9_NUMOS AND
			AB7.%NotDel% 
	   JOIN %table:AB6% AB6 ON 
	  		AB6.AB6_FILIAL = %xFilial:AB6% AND 
	  		AB6.AB6_NUMOS = AB7.AB7_NUMOS AND
			AB6.%NotDel% 
	  	JOIN %table:ABQ% ABQ ON 
			ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
			ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
			ABQ.%NotDel%
		JOIN %table:TFF% TFF ON 
			TFF.TFF_FILIAL = %xFilial:TFF% AND		 
			TFF.TFF_COD = ABQ.ABQ_CODTFF   AND 
			TFF.TFF_COD = %Exp:cCodTFF%    AND
			%Exp:cWhereCob%				   AND	
			TFF.%NotDel%
		JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL%   AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI  AND
			TFL.TFL_CODIGO = %Exp:cCodTFL%   AND 
			TFL.TFL_CONTRT = %Exp:cContrato% AND 
			TFL.TFL_CONREV = %Exp:cRevCtr%   AND		
			TFL.%NotDel% 
	   LEFT JOIN %table:ABS% ABS ON
			ABS.ABS_FILIAL = %xFilial:ABS% AND 
			ABS.ABS_LOCAL = TFL.TFL_LOCAL AND 
			ABS.%NotDel%
		LEFT JOIN %table:AA1% AA1 ON 
	  		AA1.AA1_FILIAL = %xFilial:AA1% AND 
	  		AA1.AA1_CODTEC = ABB.ABB_CODTEC AND 
	  		AA1.%NotDel%
		WHERE
			ABB.ABB_FILIAL = %xFilial:ABB% AND 
			ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
			ABB.ABB_DTINI >= %Exp:cDataIni% AND 
			ABB.ABB_DTINI <= %Exp:cDataFim% AND 
			ABB.ABB_DTFIM >= %Exp:cDataIni% AND 
			ABB.ABB_DTFIM <= %Exp:cDataFim% AND
			ABQ.ABQ_CONTRT = %Exp:cContrato% AND
			ABB.%NotDel%  	 
		GROUP BY 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG,
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN
		ORDER BY
			ABB.ABB_CODTEC, AB9.AB9_DTCHEG,AB9.AB9_HRCHEG,AB9.AB9_DTSAID, AB9.AB9_HRSAID
				
			
	EndSql  
ELSE
	BeginSql Alias cAliasAB9
		
		SELECT
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG,
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN
	  	FROM
			%table:ABB% ABB
		JOIN %table:AB9% AB9 ON 
			AB9.AB9_FILIAL = %xFilial:AB9% AND 
			AB9.AB9_ATAUT = ABB.ABB_CODIGO AND
			AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND 
			RTrim(LTrim(AB9.AB9_ITAPUR))=%Exp:cIdApur% AND
			AB9.%NotDel%	
	   JOIN %table:AB7% AB7 ON 
	  		AB7.AB7_FILIAL = %xFilial:AB7% AND 
	  		AB7.AB7_NUMOS %Exp:cOperador% AB7.AB7_ITEM = AB9.AB9_NUMOS AND
			AB7.%NotDel% 
	   JOIN %table:AB6% AB6 ON 
	  		AB6.AB6_FILIAL = %xFilial:AB6% AND 
	  		AB6.AB6_NUMOS = AB7.AB7_NUMOS AND
			AB6.%NotDel% 
	  	JOIN %table:ABQ% ABQ ON 
			ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
			ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
			ABQ.%NotDel%
		JOIN %table:TFF% TFF ON 
			TFF.TFF_FILIAL = %xFilial:TFF% AND		 
			TFF.TFF_FILIAL = ABQ.ABQ_FILTFF   AND 
			TFF.TFF_COD = ABQ.ABQ_CODTFF   AND
			TFF.TFF_COD = %Exp:cCodTFF%    AND
			%Exp:cWhereCob%				   AND	
			TFF.%NotDel%
		JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL%   AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI  AND
			TFL.TFL_CODIGO = %Exp:cCodTFL%   AND 
			TFL.TFL_CONTRT = %Exp:cContrato% AND 
			TFL.TFL_CONREV = %Exp:cRevCtr%   AND		
			TFL.%NotDel% 
	   LEFT JOIN %table:ABS% ABS ON
			ABS.ABS_FILIAL = %xFilial:ABS% AND 
			ABS.ABS_LOCAL = TFL.TFL_LOCAL AND 
			ABS.%NotDel%
		LEFT JOIN %table:AA1% AA1 ON 
	  		AA1.AA1_FILIAL = %xFilial:AA1% AND 
	  		AA1.AA1_CODTEC = ABB.ABB_CODTEC AND 
	  		AA1.%NotDel%
		WHERE
			ABB.ABB_FILIAL = %xFilial:ABB% AND 
			ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
			ABB.ABB_DTINI >= %Exp:cDataIni% AND 
			ABB.ABB_DTINI <= %Exp:cDataFim% AND 
			ABB.ABB_DTFIM >= %Exp:cDataIni% AND 
			ABB.ABB_DTFIM <= %Exp:cDataFim% AND
			ABQ.ABQ_CONTRT = %Exp:cContrato% AND
			ABB.%NotDel%  	 
		GROUP BY 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG,
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN
		ORDER BY
			ABB.ABB_CODTEC, AB9.AB9_DTCHEG,AB9.AB9_HRCHEG,AB9.AB9_DTSAID, AB9.AB9_HRSAID
				
			
	EndSql
ENDIF

While (cAliasAB9)->(!Eof())		

	IF lTela 
	
		aAdd( aHrNormal, { (cAliasAB9)->AB9_NUMOS		,	(cAliasAB9)->AB9_SEQ,;
						   (cAliasAB9)->AB9_TOTFAT		,	StoD((cAliasAB9)->AB6_EMISSA),;
						   StoD((cAliasAB9)->AB9_DTCHEG),	(cAliasAB9)->AB9_HRCHEG,  ;
						   StoD((cAliasAB9)->AB9_DTSAID),	(cAliasAB9)->AB9_HRSAID,;
						   (cAliasAB9)->TFF_CONTRT		,	(cAliasAB9)->TFF_CONREV,; 
						   (cAliasAB9)->TFF_LOCAL		,	(cAliasAB9)->ABS_DESCRI,;
						   (cAliasAB9)->ABB_CODTEC		,	(cAliasAB9)->AA1_NOMTEC })
						    
	Else						   
			
		nVlrCont := ((cAliasAB9)->TFF_PRCVEN - (cAliasAB9)->TFF_VALDES) * (cAliasAB9)->TFF_QTDVEN  
		nVlrHor  := nVlrCont / (cAliasAB9)->ABQ_TOTAL   
		nHorTot  := HoraToInt((cAliasAB9)->AB9_TOTFAT) * nVlrHor
		
		nPos := aScan( aTecHrN, {|x| x[1] == (cAliasAB9)->ABB_CODTEC } )
	
		If nPos == 0		
			aAdd( aTecHrN, { (cAliasAB9)->ABB_CODTEC, nVlrHor, HoraToInt((cAliasAB9)->AB9_TOTFAT), nHorTot } )		
		Else
		
			nTecHor := aTecHrN[nPos][3] + HoraToInt((cAliasAB9)->AB9_TOTFAT)
			nValTot := aTecHrN[nPos][4] + nHorTot
			
			aTecHrN[nPos][3] := nTecHor
			aTecHrN[nPos][4] := nValTot		
			 	
		EndIf
		
	EndIf	
							   	
	(cAliasAB9)->(dbSkip())
	
EndDo

// Aba detalhes Recursos Humanos - Horas Extras
IF !lFilTFF

	BeginSql Alias cAliasABR
		
		SELECT 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG, 
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN, ABR.ABR_MOTIVO, ABN.ABN_DESC, 
			TFU.TFU_CODIGO, TFU.TFU_VALOR, %Exp:cMod% TOT_HOR							 					 
		FROM 
	  		%table:ABB% ABB
		JOIN %table:AB9% AB9 ON 
			AB9.AB9_FILIAL = %xFilial:AB9% AND 
			AB9.AB9_ATAUT = ABB.ABB_CODIGO AND
			AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND 
			RTrim(LTrim(AB9.AB9_ITAPUR))=%Exp:cIdApur% AND
			AB9.%NotDel%		
		JOIN %table:AB7% AB7 ON 
	  		AB7.AB7_FILIAL = %xFilial:AB7% AND 
	  		AB7.AB7_NUMOS %Exp:cOperador% AB7.AB7_ITEM = AB9.AB9_NUMOS AND
			AB7.%NotDel% 
	   JOIN %table:AB6% AB6 ON 
	  		AB6.AB6_FILIAL = %xFilial:AB6% AND 
	  		AB6.AB6_NUMOS = AB7.AB7_NUMOS AND
			AB6.%NotDel% 
	  	JOIN %table:ABQ% ABQ ON 
			ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
			ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
			ABQ.%NotDel%		
		JOIN %table:TFF% TFF ON 
			TFF.TFF_FILIAL = %xFilial:TFF% AND 
			TFF.TFF_COD = ABQ.ABQ_CODTFF AND 
			TFF.TFF_COD = %Exp:cCodTFF%   AND
			%Exp:cWhereCob%				   AND		
			TFF.%NotDel%
		JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL%   AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI  AND 
			TFL.TFL_CODIGO = %Exp:cCodTFL%   AND
			TFL.TFL_CONTRT = %Exp:cContrato% AND 
			TFL.TFL_CONREV = %Exp:cRevCtr%   AND 
			TFL.%NotDel%
		JOIN %table:ABR% ABR ON
			ABR.ABR_FILIAL = %xFilial:ABR%  AND 
			ABR.ABR_AGENDA = ABB.ABB_CODIGO AND
			ABR.ABR_DTINI >= %Exp:cDataIni% AND 
			ABR.ABR_DTFIM <= %Exp:cDataFim% AND
			ABR.%NotDel% 
		JOIN %table:ABN% ABN ON
			ABN.ABN_FILIAL = %xFilial:ABN% AND 
			ABN.ABN_CODIGO = ABR.ABR_MOTIVO AND	
			ABN.ABN_TIPO = '04' 				AND 	 
			ABN.%NotDel%
		LEFT JOIN %table:TFU% TFU ON
			TFU.TFU_FILIAL = %xFilial:TFU%  AND
			TFU.TFU_CODTFF = TFF.TFF_COD    AND		 
			TFU.TFU_CODABN = ABR.ABR_MOTIVO AND		 
			TFU.%NotDel% 
	   LEFT JOIN %table:ABS% ABS ON
			ABS.ABS_FILIAL = %xFilial:ABS% AND 
			ABS.ABS_LOCAL = TFL.TFL_LOCAL AND 
			ABS.%NotDel%
		LEFT JOIN %table:AA1% AA1 ON 
	  		AA1.AA1_FILIAL = %xFilial:AA1% AND 
	  		AA1.AA1_CODTEC = ABB.ABB_CODTEC AND 
	  		AA1.%NotDel%
		WHERE
			ABB.ABB_FILIAL = %xFilial:ABB% AND 
			ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
			ABB.ABB_DTINI >= %Exp:cDataIni% AND 
			ABB.ABB_DTINI <= %Exp:cDataFim% AND 
			ABB.ABB_DTFIM >= %Exp:cDataIni% AND 
			ABB.ABB_DTFIM <= %Exp:cDataFim% AND 
			ABQ.ABQ_CONTRT = %Exp:cContrato% AND
			ABB.%NotDel%	
		GROUP BY 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG, 
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN, ABR.ABR_MOTIVO, ABN.ABN_DESC, 
			TFU.TFU_CODIGO, TFU.TFU_VALOR
		ORDER BY
			ABB.ABB_CODTEC, AB9.AB9_DTCHEG,AB9.AB9_HRCHEG,AB9.AB9_DTSAID, AB9.AB9_HRSAID
		
	
	EndSql
ELSE
	BeginSql Alias cAliasABR
		
		SELECT 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG, 
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN, ABR.ABR_MOTIVO, ABN.ABN_DESC, 
			TFU.TFU_CODIGO, TFU.TFU_VALOR, %Exp:cMod% TOT_HOR							 					 
		FROM 
	  		%table:ABB% ABB
		JOIN %table:AB9% AB9 ON 
			AB9.AB9_FILIAL = %xFilial:AB9% AND 
			AB9.AB9_ATAUT = ABB.ABB_CODIGO AND
			AB9.AB9_NUMOS = ABB.ABB_CHAVE  AND 
			RTrim(LTrim(AB9.AB9_ITAPUR))=%Exp:cIdApur% AND
			AB9.%NotDel%		
		JOIN %table:AB7% AB7 ON 
	  		AB7.AB7_FILIAL = %xFilial:AB7% AND 
	  		AB7.AB7_NUMOS %Exp:cOperador% AB7.AB7_ITEM = AB9.AB9_NUMOS AND
			AB7.%NotDel% 
	   JOIN %table:AB6% AB6 ON 
	  		AB6.AB6_FILIAL = %xFilial:AB6% AND 
	  		AB6.AB6_NUMOS = AB7.AB7_NUMOS AND
			AB6.%NotDel% 
	  	JOIN %table:ABQ% ABQ ON 
			ABQ.ABQ_FILIAL = %xFilial:ABQ% AND 
			ABB.ABB_IDCFAL = %Exp:cIdcABQ%  AND
			ABQ.%NotDel%		
		JOIN %table:TFF% TFF ON 
			TFF.TFF_FILIAL = %xFilial:TFF% AND
			TFF.TFF_FILIAL = ABQ.ABQ_FILTFF AND 
			TFF.TFF_COD = ABQ.ABQ_CODTFF AND 
			TFF.TFF_COD = %Exp:cCodTFF%   AND
			%Exp:cWhereCob%				   AND		
			TFF.%NotDel%
		JOIN %table:TFL% TFL ON
			TFL.TFL_FILIAL = %xFilial:TFL%   AND 
			TFL.TFL_CODIGO = TFF.TFF_CODPAI  AND 
			TFL.TFL_CODIGO = %Exp:cCodTFL%   AND
			TFL.TFL_CONTRT = %Exp:cContrato% AND 
			TFL.TFL_CONREV = %Exp:cRevCtr%   AND 
			TFL.%NotDel%
		JOIN %table:ABR% ABR ON
			ABR.ABR_FILIAL = %xFilial:ABR%  AND 
			ABR.ABR_AGENDA = ABB.ABB_CODIGO AND
			ABR.ABR_DTINI >= %Exp:cDataIni% AND 
			ABR.ABR_DTFIM <= %Exp:cDataFim% AND
			ABR.%NotDel% 
		JOIN %table:ABN% ABN ON
			ABN.ABN_FILIAL = %xFilial:ABN% AND 
			ABN.ABN_CODIGO = ABR.ABR_MOTIVO AND	
			ABN.ABN_TIPO = '04' 				AND 	 
			ABN.%NotDel%
		LEFT JOIN %table:TFU% TFU ON
			TFU.TFU_FILIAL = %xFilial:TFU%  AND
			TFU.TFU_CODTFF = TFF.TFF_COD    AND		 
			TFU.TFU_CODABN = ABR.ABR_MOTIVO AND		 
			TFU.%NotDel% 
	   LEFT JOIN %table:ABS% ABS ON
			ABS.ABS_FILIAL = %xFilial:ABS% AND 
			ABS.ABS_LOCAL = TFL.TFL_LOCAL AND 
			ABS.%NotDel%
		LEFT JOIN %table:AA1% AA1 ON 
	  		AA1.AA1_FILIAL = %xFilial:AA1% AND 
	  		AA1.AA1_CODTEC = ABB.ABB_CODTEC AND 
	  		AA1.%NotDel%
		WHERE
			ABB.ABB_FILIAL = %xFilial:ABB% AND 
			ABB.ABB_CHEGOU = 'S' AND ABB.ABB_ATENDE = '1' AND 
			ABB.ABB_DTINI >= %Exp:cDataIni% AND 
			ABB.ABB_DTINI <= %Exp:cDataFim% AND 
			ABB.ABB_DTFIM >= %Exp:cDataIni% AND 
			ABB.ABB_DTFIM <= %Exp:cDataFim% AND 
			ABQ.ABQ_CONTRT = %Exp:cContrato% AND
			ABB.%NotDel%	
		GROUP BY 
			AB9.AB9_NUMOS, AB9.AB9_SEQ, AB9.AB9_TOTFAT, AB6.AB6_EMISSA, AB9.AB9_DTCHEG, 
			AB9.AB9_HRCHEG, AB9.AB9_DTSAID, AB9.AB9_HRSAID, TFF.TFF_CONTRT, TFF.TFF_CONREV, 
			TFF.TFF_LOCAL, ABS.ABS_DESCRI, ABB.ABB_CODTEC, AA1.AA1_NOMTEC, ABQ.ABQ_TOTAL, 
			TFF.TFF_PRCVEN, TFF.TFF_VALDES, TFF.TFF_QTDVEN, ABR.ABR_MOTIVO, ABN.ABN_DESC, 
			TFU.TFU_CODIGO, TFU.TFU_VALOR
		ORDER BY
			ABB.ABB_CODTEC, AB9.AB9_DTCHEG,AB9.AB9_HRCHEG,AB9.AB9_DTSAID, AB9.AB9_HRSAID
		
	
	EndSql
ENDIF

While (cAliasABR)->(!Eof())
		
	If Len(Alltrim((cAliasABR)->TFU_CODIGO)) > 0 // Campos de hora extra
		nVlrHor  := (cAliasABR)->TFU_VALOR
		nHorTot  := HoraToInt((cAliasABR)->TOT_HOR) * nVlrHor
	Else
		nVlrCont := ((cAliasABR)->TFF_PRCVEN - (cAliasABR)->TFF_VALDES) * (cAliasABR)->TFF_QTDVEN  
		nVlrHor  := nVlrCont / (cAliasABR)->ABQ_TOTAL   
		nHorTot  := HoraToInt((cAliasABR)->TOT_HOR) * nVlrHor
	EndIf

	IF lTela
	
		aAdd( aHrOsE, { (cAliasABR)->AB9_NUMOS		,	(cAliasABR)->AB9_SEQ,;
						   (cAliasABR)->ABR_MOTIVO	    ,  (cAliasABR)->ABN_DESC,;
						   AllTrim((cAliasABR)->TOT_HOR),	StoD((cAliasABR)->AB6_EMISSA),;
						   StoD((cAliasABR)->AB9_DTCHEG),	(cAliasABR)->AB9_HRCHEG,  ;
						   StoD((cAliasABR)->AB9_DTSAID),	(cAliasABR)->AB9_HRSAID,;
						   (cAliasABR)->TFF_CONTRT		,	(cAliasABR)->TFF_CONREV,; 
						   (cAliasABR)->TFF_LOCAL		,	(cAliasABR)->ABS_DESCRI,;
						   (cAliasABR)->ABB_CODTEC		,	(cAliasABR)->AA1_NOMTEC })
		
		nPos := aScan( aHrExtra, {|x| x[1]== (cAliasABR)->ABR_MOTIVO } )
		
		If nPos > 0	
		
			nHreTot := HoraToInt(aHrExtra[nPos][3]) + HoraToInt((cAliasABR)->TOT_HOR)
			nVlrTot := aHrExtra[nPos][5] + nHorTot
			
			aHrExtra[nPos][3] := AllTrim(IntToHora(nHreTot))
			aHrExtra[nPos][5] := Round(nVlrTot,2)
			
		Else
			aAdd(aHrExtra, {(cAliasABR)->ABR_MOTIVO, (cAliasABR)->ABN_DESC,;
				 			 AllTrim((cAliasABR)->TOT_HOR), Round(nVlrHor,2), Round(nHorTot,2) })		 
		EndIf
		
	Else 						
				
		nPos := aScan( aTecHrE, {|x| x[1] == (cAliasABR)->ABB_CODTEC .And. x[5] == (cAliasABR)->ABR_MOTIVO } )
	
		If nPos == 0		
			
			aAdd( aTecHrE, { (cAliasABR)->ABB_CODTEC,; 
								nVlrHor,;
								HoraToInt((cAliasABR)->TOT_HOR),;
								nHorTot,; 
								(cAliasABR)->ABR_MOTIVO } )
							    		
		Else
		
			nTecHor := aTecHrE[nPos][3] + HoraToInt((cAliasABR)->TOT_HOR)
			nValTot := aTecHrE[nPos][4] + nHorTot
			
			aTecHrE[nPos][3] := nTecHor
			aTecHrE[nPos][4] := nValTot		
			 	
		EndIf
		
		nPos := aScan( aTecHrN, {|x| x[1] == (cAliasABR)->ABB_CODTEC } )
		
		If nPos > 0
		
			nTecHor := aTecHrN[nPos][3] - HoraToInt((cAliasABR)->TOT_HOR)
			nValTot := aTecHrN[nPos][2] * nTecHor
			
			aTecHrN[nPos][3] := nTecHor
			aTecHrN[nPos][4] := nValTot	
		
		EndIf
		 
	Endif 		
	
	(cAliasABR)->(dbSkip())	
	
EndDo

IF lTela 
	aAdd( aRet, { aHrNormal, aHrOsE, aHrExtra } )
Else 
	aAdd( aRet, { aTecHrN, aTecHrE } )
Endif 	

Return(aRet)

/*{Protheus.doc}  At930QDetLE()

@param 		ExpC:Contrato a ser utilzado no detalhe
@param 		ExpC:Data Inicial da apuração/medição
@param 		ExpC:Data Final da apuração/medição
@param 		ExpC:Codigo do recurso humano a ser utilizado no detalhe
@param 		ExpC:Codigo do local a ser utilizado no detalhe
@param 		ExpC:Codigo da apuração para a pesquisa no estorno
@param 		ExpL:Para identificar se vai ser retornado dados para a tela ou processamento

@author 	Serviços 
@since  	27/11/2015
@version	P12.1.6
@return 	ExpA: Array com os dados do detalhe do RH
@obs		Gera as informações do detalhes da Locação de Equipamentos para os equipamentos.
/*/
Static Function A930QDetLE(cCodTFI)

Local cAliasTEW := GetNextAlias()
Local cDtInTFV  := FwFldGet("TFV_DTINI")
Local cDtFiTFV  := FwFldGet("TFV_DTFIM")
Local dDataFim   
Local dDataIni   
Local aRet		  := {}
Local nDifDias  := 0 
Local nPosEq	  := 0
Local nTotDias  := 0
Local nLE		  := 0

BeginSql Alias cAliasTEW

SELECT  TEW_MOTIVO ,
        TEW_CODMV ,
        TEW_BAATD ,
        TEW_PRODUT ,
        TEW_DTRINI ,
        TEW_DTRFIM ,
        TEW_DTAMNT ,
        TEW_SUBSTI
FROM    %table:TEW% TEW
WHERE   TEW_FILIAL = %xFilial:TEW%
        AND TEW_CODEQU = %Exp:cCodTFI%
        AND ( 
			( TEW.TEW_DTRINI BETWEEN %Exp:cDtInTFV% AND %Exp:cDtFiTFV% )
			OR 
			( TEW.TEW_MOTIVO <> ' '
				AND LTRIM(RTRIM(TEW.TEW_DTAMNT)) <> ' ' 
				AND TEW.TEW_DTAMNT BETWEEN %Exp:cDtInTFV% AND %Exp:cDtFiTFV% )
			OR
			( TEW.TEW_MOTIVO = ' '
				AND LTRIM(RTRIM(TEW.TEW_DTRFIM)) <> ' ' 
				AND LTRIM(RTRIM(TEW.TEW_DTAMNT)) = ' ' 
				AND TEW.TEW_DTRFIM BETWEEN %Exp:cDtInTFV% AND %Exp:cDtFiTFV% )
			OR
			( TEW.TEW_DTRINI < %Exp:cDtInTFV% AND 
				( 
					( TEW.TEW_MOTIVO <> ' ' AND ( LTRIM(RTRIM(TEW.TEW_DTAMNT))=' ' OR TEW.TEW_DTAMNT > %Exp:cDtFiTFV% ) )
					OR
					( TEW.TEW_MOTIVO = ' ' AND ( LTRIM(RTRIM(TEW.TEW_DTRFIM))=' ' OR TEW.TEW_DTRFIM > %Exp:cDtFiTFV% ) )
				)
			)
		)
        AND TEW.%NotDel%

EndSql

While (cAliasTEW)->(!EoF())

	If Len(AllTrim((cAliasTEW)->TEW_DTAMNT)) > 0
		dDataFim := (cAliasTEW)->TEW_DTAMNT
	ElseIf Len(AllTrim((cAliasTEW)->TEW_DTRFIM)) > 0
		dDataFim := (cAliasTEW)->TEW_DTRFIM
	Else 
		dDataFim := cDtFiTFV
	EndIf
	
	If valType(dDataFim) == "C"
		dDataFim := StoD(dDataFim)
	EndIf
	
	If Len(AllTrim((cAliasTEW)->TEW_DTRINI)) > 0
		dDataIni := (cAliasTEW)->TEW_DTRINI
	Else
		dDataIni := cDtInTFV
	EndIf
	
	If valType(dDataIni) == "C"
		dDataIni := StoD(dDataIni)
	EndIf 

	nDifDias := (dDataFim - dDataIni) + 1
	
	nPosEq := aScan( aRet, { |x| x[1] == (cAliasTEW)->TEW_BAATD } )
	
	If nPosEq == 0	
		aAdd( aRet, { (cAliasTEW)->TEW_BAATD, nDifDias, "2", 0, 0, 0, 0 } )
	Else 		
		aRet[nPosEq][2] += nDifDias 				
	EndIf
	
	nTotDias += nDifDias						
	
	(cAliasTEW)->(dbSkip())

EndDo

For nLE:=1 To Len(aRet)
	aRet[nLE][7] := aRet[nLE][2] / nTotDias  // Percentual do item equivalente a locação
Next
		
Return(aRet)	

