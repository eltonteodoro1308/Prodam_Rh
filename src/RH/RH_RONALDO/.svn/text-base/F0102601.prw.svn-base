#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} F0102601()

@Project     MAN00000011501_EF_026
@author      Aline S Damasceno
@since       29/11/2015
@param  	 oModel 	- modelo do contrato
@param  	 cAliasCO2 	- Alias da tabela de produtos do GCP
@param  	 aFils 		- Filiais
@param  	 aRetorno 	- retorno de lote
@param  	 lLote 		- inclusao por lote
@param  	 lAta 		- Ata
@param  	 lRateio 	- Se planilha possui rateio
@param  	 lVenda 	- se tipo do contrato é de vendas
@param  	 aProds		- relação de produtos
@param  	 cCodEdt	- codigo do edital
@param  	 cNumPro 	- numero do processo
@param  	 cCodFor 	- codigo do fornecedor
@param  	 cLoja 		- loja do fornecedor

@version     P12.1.6
@Return      Informações da planilha do contrato
@Obs         Função utilizada no processo de geração das planilhas no Edital de compras publicas
/*/

User Function F0102601(oModel,cAliasCO2,aFils,aRetorno,lLote,lAta,lRateio,lVenda,aProds,cCodEdt,cNumPro,cCodFor,cLoja)
Local aArea	   := GetArea()
Local oCNADetail	
Local oCPDDetail	
Local oCNBDetail	
Local oCNCDetail	

Local nLinhaPla     := 0
Local nPosNCtr      := 0
Local nQuant        := 0
Local nI            := 0
Local cItPla        := '000000'
Local cItemCNB      := '000'
Local cAliasTip     := ''
Local cQuery        := ''
Local lRet 			:= .T.

Default oModel      := nil
Default cAliasCO2   := ''
Default aFils       := {}
Default aRetorno    := {}
Default lLote       := .F.
Default lAta        := .F.
Default lRateio     := .F.
Default aProds      := {}
Default cCodEdt     := ''
Default cNumPro     := ''
Default cCodFor		:= ''
Default cLoja		:= ''

oCNADetail	:= oModel:GetModel("CNADETAIL")
oCPDDetail	:= oModel:GetModel("CPDDETAIL")
oCNBDetail	:= oModel:GetModel("CNBDETAIL")
oCNCDetail	:= oModel:GetModel("CNCDETAIL")

If lVenda// Se for vendas, retorna Falso, processo padrão
	lRet := .F.
EndIf

If lAta // Se for ata, retorna Falso, processo padrão
	lRet := .F.
EndIf


If !Empty(cNumPro) .And. !Empty(cCodEdt)
	If lRet
	
		If !(cAliasCO2)->(Eof())
		
			cAliasTip:= GetNextAlias()
			
			cQuery := " Select CO2_XTPPL TPPLAN From  " + RetSQLName("CO2") + " CO2 "
			cQuery += " INNER JOIN  "+ RetSQLName("CO3") + " CO3 "
	   		cQuery += " ON  CO2.CO2_FILIAL   = CO3.CO3_FILIAL "
	   		cQuery += " And CO2.CO2_CODEDT   = CO3.CO3_CODEDT "
	   		cQuery += " And CO2.CO2_NUMPRO   = CO3.CO3_NUMPRO "
	   		cQuery += " And CO2.CO2_REVISA   = CO3.CO3_REVISA " 
	     	cQuery += " And CO2.CO2_CODPRO   = CO3.CO3_CODPRO " 
			cQuery += " Where CO2_FILIAL     = '" +xFilial("CO2")+"'"
			cQuery += "   And CO2_CODEDT     = '" +cCodEdt  +"'"
			cQuery += "   And CO2_NUMPRO     = '" +cNumPro  +"'"
			cQuery += "   And CO2_STATUS     = '1' "
			cQuery += "   And CO3.CO3_CODIGO = '" +cCodFor  +"' 
			cQuery += "   And CO3.CO3_LOJA   = '" +cLoja    +"'"
			cQuery += "   And CO3.CO3_STATUS = '5'"
			cQuery += "   And CO2.D_E_L_E_T_ = '' "
			cQuery += "   And CO3.D_E_L_E_T_ = '' "
			cQuery += " Group By CO2_XTPPL"
	
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTip,.T.,.T.)
			
			While !(cAliasTip)->(Eof())	
			
				//-- Carrega dados da Planilha
				If nLinhaPla == 0
					If cItPla <> Replicate("0", (TamSx3('CNA_NUMERO')[1]))
						oCNADetail:AddLine()
					EndIf
					cItPla := Soma1(cItPla)
					
					oCNADetail:SetValue('CNA_FORNEC', oCNCDetail:GetValue('CNC_CODIGO'))
					oCNADetail:SetValue('CNA_LJFORN', oCNCDetail:GetValue('CNC_LOJA'))
	
					oCNADetail:SetValue('CNA_TIPPLA',(cAliasTip)->TPPLAN)
					oCNADetail:SetValue('CNA_NUMERO',cItPla)
					oCNADetail:SetValue('CNA_DTINI' ,dDataBase)
			
					//-- Carrega todas as filiais autorizadas
					For nI := 1 To Len(aFils)
						If !Empty(oCPDDetail:GetValue('CPD_FILAUT'))
							oCPDDetail:AddLine()
						EndIf
						oCPDDetail:SetValue('CPD_FILAUT', aFils[nI])
						oCPDDetail:SetValue('CPD_NUMPLA', cItPla)
					Next nI
				Else
					//-- Posiciona na ultima planilha inclusa.
					oCNADetail:GoLine(nLinhaPla)
				EndIf
			
				(cAliasCO2)->(dbGoTop())
				While (cAliasCO2)->(!Eof())
					CO2->(dbSetOrder(1))//CO2_FILIAL+CO2_CODEDT+CO2_NUMPRO+CO2_CODPRO
					CO2->(dbSeek(xFilial("CO2")+cCodEdt+cNumPro+(cAliasCO2)->CO2_CODPRO))
					If (cAliasTip)->TPPLAN == CO2->CO2_XTPPL
						If Len(aProds) == 0 .Or. Ascan(aProds, (cAliasCO2)->CO2_CODPRO) > 0
							If 	cItemCNB <> Replicate("0",(TamSx3('CNB_ITEM')[1]))
								oCNBDetail:AddLine()
							EndIf
							cItemCNB := Soma1(cItemCNB)
							oCNBDetail:SetValue('CNB_ITEM',cItemCNB)
							oCNBDetail:SetValue('CNB_PRODUT',(cAliasCO2)->CO2_CODPRO)
							oCNBDetail:SetValue('CNB_GCPIT' ,(cAliasCO2)->CO2_ITEM)
							oCNBDetail:SetValue('CNB_GCPLT' ,(cAliasCO2)->CO3_LOTE)
	
	
							aRetorno := aR()
							nPosNCtr := aScan(aRetorno,{|x| x[2] + x[8] == (cAliasCO2)->CO2_CODPRO + (cAliasCO2)->CO3_LOTE })
	
							If CO1->CO1_REMAN .And. nPosNCtr > 0
								nQuant := aRetorno[nPosNCtr,3]
								oCNBDetail:SetValue('CNB_QUANT',nQuant)
							Else
								oCNBDetail:SetValue('CNB_QUANT',IIf(lAta,(cAliasCO2)->CPE_QUANT,(cAliasCO2)->CO2_QUANT))
							EndIf
										
							If !lLote
								oCNBDetail:SetValue('CNB_VLUNIT',(cAliasCO2)->CO3_VLUNIT)
								oCNBDetail:SetValue('CNB_VLTOTR',(cAliasCO2)->CO3_VLUNIT * oCNBDetail:GetValue('CNB_QUANT'))
							ElseIf !lAta
								oCNBDetail:SetValue('CNB_VLUNIT',(cAliasCO2)->CP6_PRCUN)
								oCNBDetail:SetValue('CNB_VLTOTR',(cAliasCO2)->CP6_PRCUN * oCNBDetail:GetValue('CNB_QUANT'))
							EndIf
				
							If A400GetIt(CX0->CX0_CODNE,(cAliasCO2)->CO2_CODPRO)
								oCNBDetail:LoadValue('CNB_CODNE', CX0->CX0_CODNE)
								oCNBDetail:LoadValue('CNB_ITEMNE', CX1->CX1_ITEM)
							EndIf
						EndIf
					EndIf
					(cAliasCO2)->(dbSkip())
				End
				(cAliasTip)->(dbSkip())
			End
			
		EndIf
	EndIf
EndIf

RestArea( aArea )
Return lRet