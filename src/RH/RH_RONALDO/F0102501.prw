#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TECA850.CH"

//-------------------------------------------------------------------
/*{Protheus.Doc} F0102501    
Criação do Campo Situacao do Produto 
Chamado por: Ponto de Entrada: AT850PLA pelo fonte TECA850
@project MAN00000011901_EF_025    
@author  Aline Sebrian Damasceno
@param   cCombo    - determina se planilha tem Reajuste
@param   cProposta - número da proposta comercial
@param   cRevisao  - revisão da proposta comercial
@param   cCodCli   - codigo do cliente
@param   cLjCli    - loja do cliente
@param   aLocal    - local de entrega
@param   aInfo     - Informações do contrato
@param   cTpPl     - Tipo da planilha

@version P12 R1.6
@since   16/11/2015  
@menu	 Gestão de Serviços                                                            
*/ 
//-------------------------------------------------------------------
User Function F0102501(cCombo,cProposta,cRevisao,cCodCli,cLjCli,aLocal,aInfo,cTpPl)
Local cItemTFH := ''
Local cItemTFF := ''
Local cItemTFG := ''
Local cItemTFI := ''

Local aArea	   := GetArea()
Local aHeader  := {}
Local aClien   := {}
Local aTdHeader:= {}
Local aTdItem  := {}
Local aTdClient:= {}

Local aItemPl  := {}
Local aItensPl := {}

Local cQuery   := ''
Local cAliasAD1:= ''
Local cNumero  := '000000'
Local cItem    := '000'
Local nCont    := 0
Local cLocal   := ''
Local cCodLocal := ''
Local lRetorno  := .T.

Default cCombo   := ''
Default cProposta:= ''
Default cRevisao := ''
Default cCodCli  := ''
Default cLjCli   := ''
Default aLocal   := {}
Default aInfo    := {}
Default cTpPl    := ''

If !Empty(cProposta) .And. !Empty(cRevisao)	
	For nCont:=1 To Len(aLocal)	
		cCodLocal	:= aLocal[nCont][1]
		cLocal		:= aLocal[nCont][2]

		ABS->(DbSetOrder(1))
		If ABS->(DbSeek(xFilial("ABS") + aLocal[nCont][2] ))
			
			TFJ->(DbSetOrder(2))
			If TFJ->(DbSeek(xFilial("TFJ") + cProposta + cRevisao))
				If TFJ->TFJ_AGRUP == "2"
					cCodCli := ABS->ABS_CLIFAT
					cLjCli	:= ABS->ABS_LJFAT				
				ElseIf TFJ->TFJ_AGRUP == "1" .AND. ABS->ABS_ENTIDA == "1"
					cCodCli := ABS->ABS_CODIGO
					cLjCli	:= ABS->ABS_LOJA
				ElseIf TFJ->TFJ_AGRUP == "1" .AND. ABS->ABS_ENTIDA == "2"
					If !Empty(Posicione("SUS",1,xFilial("SUS")+ABS->ABS_CODIGO,"US_CODCLI"))
						cCodCli := Posicione("SUS",1,xFilial("SUS")+ABS->ABS_CODIGO,"US_CODCLI")
						cLjCli	:= Posicione("SUS",1,xFilial("SUS")+ABS->ABS_CODIGO,"US_LOJACLI")
					Else					
						Help(,,'AT850LOCXCLI',, "Não será possível realizar a Geração do Contrato porque o Local de Atendimento do Orçamento de Serviços da Proposta Comercial não pode estar relacionado a um Prospect que ainda não seja um Cliente!",3,0)//"Não será possível realizar a Geração do Contrato porque o Local de Atendimento do Orçamento de Serviços da Proposta Comercial não pode estar relacionado a um Prospect que ainda não seja um Cliente!"
						RestArea( aArea )
						Return (.F.)
					EndIf
				EndIf		
			EndIf
			
			If aScan(aTdClient, {|x| x[4][2]==cCodCli .AND. x[5][2]==cLjCli}) == 0 //Adiciona cliente somente se não existir no aTdClient		
				Aadd(aClien,{"CNC_FILIAL"	, xFilial("CNC"), NIL })
				Aadd(aClien,{"CNC_NUMERO"	, aInfo[10][2]	, NIL })
				Aadd(aClien,{"CNC_REVISA"	, aInfo[12][2]	, NIL })
				Aadd(aClien,{"CNC_CLIENT"	, cCodCli		, NIL })
				Aadd(aClien,{"CNC_LOJACL"	, cLjCli		, NIL })
				Aadd(aTdClient,aClien)
			EndIf
		EndIf
			
		cAliasTFL:= GetNextAlias()
		
		cQuery := " SELECT TFF.TFF_XTPPL TPPLAN FROM "+RetSQLName("TFF")+" TFF "
		cQuery += " INNER JOIN "+RetSQLName("TFJ")+" TFJ ON TFJ.TFJ_FILIAL = " + xFilial("TFJ") + " AND TFJ.TFJ_PROPOS = '"+cProposta+"' AND TFJ.TFJ_PREVIS = '" + cRevisao + "'  AND TFJ.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFL")+" TFL ON TFL.TFL_FILIAL = " + xFilial("TFL") + " AND TFF.TFF_CODPAI = TFL.TFL_CODIGO  AND TFL.TFL_LOCAL  = '" + cLocal   + "'  AND TFL.TFL_CODPAI = TFJ.TFJ_CODIGO AND TFL.D_E_L_E_T_ = '' "
		cQuery += " WHERE TFF.TFF_FILIAL = " + xFilial("TFF") + " AND TFF.D_E_L_E_T_ = '' "
		cQuery += " GROUP BY TFF_XTPPL "
		cQuery += " UNION "
		cQuery += " SELECT TFG.TFG_XTPPL TPPLAN FROM "+RetSQLName("TFG")+ " TFG "
		cQuery += " INNER JOIN "+RetSQLName("TFJ")+" TFJ ON TFJ.TFJ_FILIAL = " + xFilial("TFJ") + " AND TFJ.TFJ_PROPOS = '"+cProposta+"' AND TFJ.TFJ_PREVIS = '" + cRevisao +"'  AND TFJ.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFF")+" TFF ON TFF.TFF_FILIAL = " + xFilial("TFF") + " AND TFG.TFG_CODPAI = TFF.TFF_COD     AND TFF.TFF_LOCAL  = '" + cLocal   +"'  AND TFF.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFL")+" TFL ON TFL.TFL_FILIAL = " + xFilial("TFL") + " AND TFF.TFF_CODPAI = TFL.TFL_CODIGO  AND TFL.TFL_CODPAI = TFJ.TFJ_CODIGO AND TFL.TFL_LOCAL      = '"+cLocal+"' AND TFL.D_E_L_E_T_ = '' "
		cQuery += " WHERE TFG.TFG_FILIAL = " + xFilial("TFG") + " AND TFG.D_E_L_E_T_ = '' "
		cQuery += " GROUP BY TFG_XTPPL "
		cQuery += " UNION "
		cQuery += " SELECT TFH.TFH_XTPPL TPPLAN FROM  "+RetSQLName("TFH")+" TFH "
		cQuery += " INNER JOIN "+RetSQLName("TFJ")+" TFJ ON TFJ.TFJ_FILIAL = " + xFilial("TFJ") + " AND TFJ.TFJ_PROPOS = '"+cProposta+"' AND TFJ.TFJ_PREVIS  = '" + cRevisao + "'  AND TFJ.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFF")+" TFF ON TFF.TFF_FILIAL = " + xFilial("TFF") + " AND TFH.TFH_CODPAI = TFF.TFF_COD     AND TFF.TFF_LOCAL   = '" + cLocal   + "'  AND TFF.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFL")+" TFL ON TFL.TFL_FILIAL = " + xFilial("TFL") + " AND TFF.TFF_CODPAI = TFL.TFL_CODIGO  AND TFL.TFL_CODPAI  = TFJ.TFJ_CODIGO AND TFL.TFL_LOCAL       = '"+cLocal+"' AND TFL.D_E_L_E_T_ = '' "
		cQuery += " WHERE TFF.TFF_FILIAL = " + xFilial("TFF") + " AND TFF.D_E_L_E_T_ = '' "
		cQuery += " GROUP BY TFH_XTPPL "
		cQuery += " UNION "
		cQuery += " SELECT TFI.TFI_XTPPL TPPLAN FROM "+RetSQLName("TFI")+" TFI "
		cQuery += " INNER JOIN "+RetSQLName("TFJ")+" TFJ ON TFJ.TFJ_FILIAL = " + xFilial("TFJ") + " AND TFJ.TFJ_PROPOS = '"+cProposta+"' AND TFJ.TFJ_PREVIS = '"+cRevisao+"' AND TFJ.D_E_L_E_T_ = '' "
		cQuery += " INNER JOIN "+RetSQLName("TFL")+" TFL ON TFL.TFL_FILIAL = " + xFilial("TFL") + " AND TFI.TFI_CODPAI = TFL.TFL_CODIGO  AND TFL.TFL_LOCAL  = '"+cLocal  +"' AND TFL.TFL_CODPAI=TFJ.TFJ_CODIGO AND TFL.D_E_L_E_T_ = '' "
		cQuery += " WHERE TFI.TFI_FILIAL = " + xFilial("TFI") + " AND TFI.D_E_L_E_T_ = '' "
		cQuery += " GROUP BY TFI_XTPPL "
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTFL,.T.,.T.)
		
		While !(cAliasTFL)->(Eof())	
		//Informações para criação dos itens das planilhas
			aHeader	 :=	{}
			aItemPl	 :=	{}
			aItensPl :=	{}
			cNumero	 :=	SOMA1(cNumero)
		
			TFL->(DbSetOrder(1))
			TFL->(DbSeek(xFilial("TFL")+cCodLocal))
	
			Aadd(aHeader,{"CNA_FILIAL"		, xFilial("CNA")		, NIL })
			Aadd(aHeader,{"CNA_NUMERO"		, cNumero				, NIL })
			Aadd(aHeader,{"CNA_TIPPLA"		, (cAliasTFL)->TPPLAN	, NIL })
			Aadd(aHeader,{"CNA_DTINI"		, aInfo[2][2]			, NIL })
			Aadd(aHeader,{"CNA_DTFIM"		, aInfo[8][2]			, NIL })
			If cCombo == STR0005
				Aadd(aHeader,{"CNA_FLREAJ"	, "1"				 	, NIL })
			Else
				Aadd(aHeader,{"CNA_FLREAJ"	, "2"					, NIL })
			EndIf
			Aadd(aHeader,{"CNA_CLIENT"		, cCodCli				, NIL })
			Aadd(aHeader,{"CNA_LOJACL"		, cLjCli				, NIL })
			Aadd(aTdHeader,aHeader)
			
			If TFL->TFL_TOTRH > 0
				TFF->(DbSetOrder(3))
				TFF->(DbSeek(xFilial("TFF")+TFL->TFL_CODIGO))
				
				While !TFF->(Eof()) .And. (TFF->TFF_FILIAL+TFF->TFF_CODPAI== xFilial("TFF")+TFL->TFL_CODIGO)
					If TFF->TFF_XTPPL == (cAliasTFL)->TPPLAN
						aItemPl	:=	{}
						cItem	:=	SOMA1(cItem)
						
						Aadd(aItemPl,{"CNB_FILIAL"		, xFilial("CNB")	, NIL })
						Aadd(aItemPl,{"CNB_NUMERO"		, cNumero			, NIL })
						Aadd(aItemPl,{"CNB_ITEM"		, cItem				, NIL })
						Aadd(aItemPl,{"CNB_PRODUT"		, TFF->TFF_PRODUT	, NIL })
						Aadd(aItemPl,{"CNB_QUANT"		, TFF->TFF_QTDVEN	, NIL })
						Aadd(aItemPl,{"CNB_TS"			, TFJ->TFJ_TES		, NIL })
						Aadd(aItemPl,{"CNB_VLUNIT"		, TFF->TFF_PRCVEN	, NIL })
						Aadd(aItemPl,{"CNB_PEDTIT"		, "1"				, NIL })
						Aadd(aItensPl, aItemPl)
						
						TFF->(RecLock( "TFF", .F. ))
						 TFF->TFF_CONTRT := aInfo[10][2]
						 TFF->TFF_CONREV := aInfo[12][2]
						 TFF->TFF_XPLAN  := cNumero
						 TFF->TFF_XITPL	 := cItem
						TFF->(MsUnLock()) 
					EndIf
	
					TFF->(DbSkip())	
				End
				cItemTFF	:= cItem
			EndIf
			If TFL->TFL_TOTMI > 0	
				TFF->(DbSetOrder(3))
				TFF->(DbSeek(xFilial("TFF")+TFL->TFL_CODIGO))
				
				While !TFF->(Eof()) .And. (TFF->TFF_FILIAL+TFF->TFF_CODPAI== xFilial("TFF")+TFL->TFL_CODIGO)
					TFG->(DbSetOrder(2))
					TFG->(DbSeek(xFilial("TFG")+cLocal))
					
					While !TFG->(Eof()) 
						If (TFG->TFG_FILIAL+TFG->TFG_CODPAI == xFilial("TFG")+TFF->TFF_COD)
							If TFG->TFG_XTPPL == (cAliasTFL)->TPPLAN
								aItemPl	:=	{}
								cItem	:=	SOMA1(cItem)
								Aadd(aItemPl,{"CNB_FILIAL"		, xFilial("CNB")	, NIL })
								Aadd(aItemPl,{"CNB_NUMERO"		, cNumero			, NIL })
								Aadd(aItemPl,{"CNB_ITEM"		, cItem 			, NIL })
								Aadd(aItemPl,{"CNB_PRODUT"		, TFG->TFG_PRODUT	, NIL })
								Aadd(aItemPl,{"CNB_QUANT"		, TFG->TFG_QTDVEN	, NIL })
								Aadd(aItemPl,{"CNB_VLUNIT"		, TFG->TFG_PRCVEN	, NIL })
								Aadd(aItemPl,{"CNB_TS"			, TFG->TFG_TES  	, NIL })
								Aadd(aItemPl,{"CNB_PEDTIT"		, "1"				, NIL })
								Aadd(aItensPl, aItemPl)
								
								TFG->(RecLock( "TFG", .F. ))
								 TFG->TFG_XCONTR := aInfo[10][2]
						 		 TFG->TFG_XREVCO := aInfo[12][2]
								 TFG->TFG_XPLAN	 := cNumero
								 TFG->TFG_XITPL	 := cItem
								TFG->(MsUnLock()) 
							EndIf
						EndIf
						
						TFG->(DbSkip())	
					End
					TFF->(DbSkip())	
				End
				cItemTFG	:= cItem
			EndIf
			If TFL->TFL_TOTMC > 0
				TFF->(DbSetOrder(3))
				TFF->(DbSeek(xFilial("TFF")+TFL->TFL_CODIGO))
				
				While !TFF->(Eof()) .And. (TFF->TFF_FILIAL+TFF->TFF_CODPAI== xFilial("TFF")+TFL->TFL_CODIGO)
					TFH->(DbSetOrder(2))
					TFH->(DbSeek(xFilial("TFH")+cLocal))
					
					While !TFH->(Eof()) 
						If (TFH->TFH_FILIAL+TFH->TFH_CODPAI == xFilial("TFH")+TFF->TFF_COD)
							If TFH->TFH_XTPPL == (cAliasTFL)->TPPLAN
								aItemPl	:=	{}
								cItem	:=	SOMA1(cItem)
								Aadd(aItemPl,{"CNB_FILIAL"		, xFilial("CNB")	, NIL })
								Aadd(aItemPl,{"CNB_NUMERO"		, cNumero			, NIL })
								Aadd(aItemPl,{"CNB_ITEM"		, cItem 			, NIL })
								Aadd(aItemPl,{"CNB_PRODUT"		, TFH->TFH_PRODUT	, NIL })
								Aadd(aItemPl,{"CNB_QUANT"		, TFH->TFH_QTDVEN	, NIL })
								Aadd(aItemPl,{"CNB_VLUNIT"		, TFH->TFH_PRCVEN	, NIL })
								Aadd(aItemPl,{"CNB_TS"			, TFH->TFH_TES  	, NIL })
								Aadd(aItemPl,{"CNB_PEDTIT"		, "1"				, NIL })
								Aadd(aItensPl, aItemPl)

								TFH->(RecLock( "TFH", .F. ))
								 TFH->TFH_XCONTR := aInfo[10][2]
						 		 TFH->TFH_XREVCO := aInfo[12][2]
								 TFH->TFH_XPLAN  := cNumero
								 TFH->TFH_XITPL	 := cItem
								TFH->(MsUnLock()) 
							EndIf
						EndIf
						
						TFH->(DbSkip())	
					End
					TFF->(DbSkip())	
				End
				cItemTFH	:= cItem
			EndIf
			If TFL->TFL_TOTLE > 0
				TFI->(DbSetOrder(3))
				TFI->(DbSeek(xFilial("TFI")+TFL->TFL_CODIGO))
				
				While !TFI->(Eof()) .And. (TFI->TFI_FILIAL+TFI->TFI_CODPAI == xFilial("TFI")+TFL->TFL_CODIGO)
					If TFI->TFI_XTPPL == (cAliasTFL)->TPPLAN
						aItemPl	:=	{}
						cItem	:=	SOMA1(cItem)
						Aadd(aItemPl,{"CNB_FILIAL"		, xFilial("CNB")		 , NIL })
						Aadd(aItemPl,{"CNB_NUMERO"		, cNumero				 , NIL })
						Aadd(aItemPl,{"CNB_ITEM"		, cItem 				 , NIL })
						Aadd(aItemPl,{"CNB_PRODUT"		, TFI->TFI_PRODUT  		 , NIL })
						Aadd(aItemPl,{"CNB_QUANT"		, At850Unit(TFI->TFI_COD)[1], NIL})
						Aadd(aItemPl,{"CNB_VLUNIT"		, At850Unit(TFI->TFI_COD)[2], NIL })
						Aadd(aItemPl,{"CNB_TS"			, TFI->TFI_TES  		 , NIL })
						Aadd(aItemPl,{"CNB_PEDTIT"		, TFL->TFL_PEDTIT		 , NIL })
						Aadd(aItensPl, aItemPl)
						
						TFI->(RecLock( "TFI", .F. ))
						 TFI->TFI_CONTRT := aInfo[10][2]
						 TFI->TFI_CONREV := aInfo[12][2]
						 TFI->TFI_XPLAN	 := cNumero
						 TFI->TFI_XITPL	 := cItem
						TFI->(MsUnLock())
					EndIf
					
					TFI->(DbSkip())	
				End
				cItemTFI	:= cItem
			EndIf
			
			Aadd(aTdItem,aItensPl)	
			(cAliasTFL)->(DbSkip())	
		End
	Next nCont

	lRetorno := At850Gct(aInfo,aTdClient,aTdHeader,aTdItem)
	(cAliasTFL)->(dbCloseArea())	
EndIf

RestArea( aArea )
Return  lRetorno

/*/{Protheus.doc} At850Unit
Obtem o valor unitario da LE acumulado

@project    MAN00000011501_EF_025
@author     Aline S Damasceno
@since      25/11/2015
@version    P12.1.6
@return     Valor Unitário acumulado
@param		cCod - Codigo da Locação de Equipamento

/*/
Static Function At850Unit(cCod)
Local aArea		:= GetArea()
Local nValor    := 0
Local nQtde     := 0
Local cQuery    := ""
Local cAliasTEV := GetNextAlias()
	
cQuery := "Select SUM(TEV_QTDE) Qtde , SUM(TEV_VLRUNI) ValorUni from "+RetSQLName("TEV")+" TEV WHERE TEV_FILIAL=" + xFilial('TEV') + "  AND TEV_CODLOC = '"+cCod+"' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTEV,.T.,.T.)
	
If !(cAliasTEV)->(Eof())	
	nQtde  := (cAliasTEV)->Qtde
	nValor := (cAliasTEV)->ValorUni
EndIf

RestArea( aArea )
Return {nQtde,nValor}


//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} At850Gct
Gera planilha do contrato e cronogramas financeiros e contábeis.

@author Bruno.Rosa
@since 10/02/14
@version P11 R9
@param aMaster:Contrato
@param aDetCli:Clientes
@param aDetCab:Planilhas
@param aDetItem:Itens Planilhas

@return lRet, lógico 
/*/
//--------------------------------------------------------------------------------------------------------------------

Static Function At850Gct(aMaster,aDetCli,aDetCab,aDetItem)

Local oModel, oAux, oStruct
Local nI := 0
Local nJ := 0
Local nL := 0
Local nK := 0
Local nW := 0
Local nX := 0
Local nZ := 0
Local nPos := 0
Local nPlan := 0
Local lRet := .T.
Local aAux := {}
Local nItErro := 0
Local lAux := .T.
Local cMaster := "CN9"
Local cDetItm	:= "CNB"
Local aDetail := {"CNC","CNA"}
Local aCposCab := {}
Local aCposDet := {}

aCposCab := aClone(aMaster)

aAdd( aCposDet, aDetCli )
aAdd( aCposDet, aDetCab )

dbSelectArea( "CNC" )
dbSetOrder( 1 )

dbSelectArea( "CNA" )
dbSetOrder( 1 )

dbSelectArea( "CNB" )
dbSetOrder( 1 )

dbSelectArea( cMaster )
dbSetOrder( 1 )

oModel := FWLoadModel( 'CNTA301' )
oModel:SetOperation( 3 )
oModel:Activate()

// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
oAux := oModel:GetModel( cMaster + 'MASTER' )

// Obtemos a estrutura de dados do cabeçalho
oStruct := oAux:GetStruct()
aAux := oStruct:GetFields()
	
	If lRet
		For nI := 1 To Len( aCposCab )
			
			// Verifica se os campos passados existem na estrutura do cabeçalho
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCposCab[nI][1] ) } ) ) > 0
				If !( lAux := oModel:SetValue( cMaster + 'MASTER', aCposCab[nI][1],aCposCab[nI][2] ) )
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf
	
	If lRet
				
		For nI := 1 To Len( aCposDet )
		
			// Instanciamos apenas a parte do modelo referente aos dados do item
			oAux := oModel:GetModel( aDetail[nI] + 'DETAIL' )

			// Obtemos a estrutura de dados do item
			oStruct := oAux:GetStruct()
			aAux := oStruct:GetFields()
			
			
			For nJ := 1 To Len( aCposDet[nI] )			
				nItErro := 0  //Pensar caso tenha mais itens para um mesmo detalhe do model				
				If nJ > 1
					If ( nItErro := oAux:AddLine() ) <> nJ
						lRet := .F.
						Exit
					EndIf
				EndIf
				
				oModel:GetModel(aDetail[nI]+'DETAIL'):GoLine(nJ)
				
				For nL := 1 To Len(aCposDet[nI][nJ])	
											
					If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCposDet[nI][nJ][nL][1] ) } ) ) > 0
						If !( lAux := oModel:SetValue( aDetail[nI] + 'DETAIL', aCposDet[nI][nJ][nL][1], aCposDet[nI][nJ][nL][2] ) )
							lRet := .F.
							nItErro := nJ
							Exit
						EndIf
					EndIf
				
				Next
				
				If lRet .and. nI == 2 
					
					// Instanciamos apenas a parte do modelo referente aos dados do item
					oAux := oModel:GetModel( cDetItm + 'DETAIL' )

					// Obtemos a estrutura de dados do item
					oStruct := oAux:GetStruct()
					aAux := oStruct:GetFields()
					
					For nk := 1 To Len(aDetItem) //Itens da planilha
								
						For nX := 1 To Len(aDetItem[nk])
						
							If ( nPlan := aScan(aDetItem[nK],{ || aDetItem[nK][nX][2][2] == aCposDet[nI][nJ][2][2] } ) ) > 0
							
								nItErro := 0  				
								If nX > 1
									If ( nItErro := oAux:AddLine() ) <> nX
										lRet := .F.
										Exit
									EndIf
								EndIf
													
								For nW := 1 To Len(aDetItem[nK][nX])		
									
									If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aDetItem[nk][nX][nW][1] ) } ) ) > 0								
										If !( lAux := oModel:SetValue( cDetItm + 'DETAIL', aDetItem[nk][nX][nW][1], aDetItem[nk][nX][nW][2] ) )
											lRet := .F.
											nItErro := nX
											Exit
										EndIf								
									EndIf
									
								Next
									
							EndIf
					
						Next
					
					Next
					
				// Instanciamos apenas a parte do modelo referente aos dados do item
				oAux := oModel:GetModel( aDetail[nI] + 'DETAIL' )
	
				// Obtemos a estrutura de dados do item
				oStruct := oAux:GetStruct()
				aAux := oStruct:GetFields()
				
				EndIf
				
			Next
			
			If !lRet
				Exit
			EndIf
		Next
	EndIf
	
	If lRet 
		For nZ := 1 To Len(aCposDet[2])
			oModel:GetModel(aDetail[2]+'DETAIL'):GoLine(nZ)
			If MsgYesNo(I18N(STR0093+STR0094,;
								{ oModel:GetModel(aDetail[2]+'DETAIL'):GetValue("CNA_NUMERO"),;
									Alltrim(STR(oModel:GetModel(aDetail[2]+'DETAIL'):GetValue("CNA_VLTOT")))} )) //"Deseja gerar cronogramas para a planilha: "##" Valor: "##
				DbSelectArea("CN1")
				DbSetOrder(1)
				If CN1->(DbSeek(xFilial("CN1")+aCposCab[1][2]))
					If CN1->CN1_MEDEVE == "2"
						CN300AddCrg()  //Cria cronograma financeiro
					EndIf
					If CN1->CN1_CROCTB == "1"
						CN300AddCtb()	 //Cria cronograma contábil
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	
	If lRet
		If ( lRet := oModel:VldData() )
		
			// Se o dados foram validados faz-se a gravação efetiva dos
			// dados (commit)
			oModel:CommitData()
		EndIf
	EndIf
	
	If !lRet

		aErro := oModel:GetErrorMessage()

		AutoGrLog( STR0083 + ' [' + AllToChar( aErro[1] ) + ']' )	//"Id do formulário de origem:"
		AutoGrLog( STR0084 + ' [' + AllToChar( aErro[2] ) + ']' )	//"Id do campo de origem: "
		AutoGrLog( STR0085 + ' [' + AllToChar( aErro[3] ) + ']' )	//"Id do formulário de erro: "
		AutoGrLog( STR0086 + ' [' + AllToChar( aErro[4] ) + ']' )	//"Id do campo de erro: "
		AutoGrLog( STR0087 + ' [' + AllToChar( aErro[5] ) + ']' )	//"Id do erro: "
		AutoGrLog( STR0088 + ' [' + AllToChar( aErro[6] ) + ']' )	//"Mensagem do erro: "
		AutoGrLog( STR0089 + ' [' + AllToChar( aErro[7] ) + ']' )	//"Mensagem da solução: "
		AutoGrLog( STR0090 + ' [' + AllToChar( aErro[8] ) + ']' )	//"Valor atribuído: "
		AutoGrLog( STR0091 + ' [' + AllToChar( aErro[9] ) + ']' )	//"Valor anterior: "
		If nItErro > 0
			AutoGrLog( STR0092 + ' [' + AllTrim( AllToChar( nItErro ) ) + ']' )	//"Erro no Item: "
		EndIf
		MostraErro()
	EndIf

	oModel:DeActivate()

Return lRet