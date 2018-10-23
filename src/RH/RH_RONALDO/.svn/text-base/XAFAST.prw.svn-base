#INCLUDE "GPEXCALC.CH" 
#INCLUDE "PROTHEUS.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fDiasAfast³ Autor ³ Equipe Rh - Mauro     ³ Data ³02/05/96  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Dias Afastados e Calc. dos Dias de Mat.,Aux.Doenca,Aux.Acid ³±±
±±³          ³e Fgts, diminuindo dos Dias Trabalhados                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fDiasAfast(nDiasAfas,Diastrab,dDtPesq,lSemanal)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FDAfas(nDiasAfas,DiasTrab,dDtPesq,lSemanal,cPgMater,cListAfas,aDetAfast,lExit)

Local aStruSR8  	:= {}
Local aStruRCM  	:= {}

Local cQuery		:= ""
Local cAliasQRY 	:= GetNextAlias()	
Local cPerFol		:= ""
Local cSemFol		:= ""

Local dPerIni		:= CtoD("//")
Local dPerFim		:= CtoD("//")

Local lSabNUtil 	:= .F. 
Local lParSab  		:= .F. 
Local lBissexto		:= .F.
Local lChkMes 		:= .F.
Local lRet			:= .T.

Local nDiaAt    	:= 0   //Dias da Semana de Trab. afastado
Local nDiaAd    	:= 0   //Dias da Semana de Desc. Afastado
Local nPosCpo		:= 0
Local nAuxAfa		:= 0
Local nDiasPagar	:= 0
Local nDEnc			:= 0
Local nDFGTS		:= 0
Local nDiasPeriodo	:= If(SUPERGETMV("MV_DIASPER",,"1") == "1",nDiasP,(If(SRA->RA_TIPOPGT =="M", nDiasC, P_NTOTDIAS)))
Local nMesMedAfa         
Local nDaPaPg := 0

Local lTCpoFgts 	:= ( Type("SRA->RA_PERFGTS") # "U" )

DEFAULT lExit 		:= .F.

If Type("lAdmissao") == "U"
	lAdmissao := .F.
EndIf

aAfaTar := {}

lDiaQbSegFer 		:= If(Type("lDiaQbSegFer") == "U",.F.,lDiaQbSegFer) // Variavel

//-- Se mnemonico aperiodo nao tiver sido carregado, efetua a carga
If Type( "aPeriodo" ) = "U" .or. Empty(aPeriodo)
	aPeriodo := {}
	nPosSem	 := 0
	lRet := fCarPeriodo( cPeriodo, cRot, @aPeriodo, , @nPosSem, lExit )
	If lExit .And. !lRet
		Return(.F.)
	EndIf
EndIf

//--Situacao do Funcionario na data de referencia
lDissidio 	:= If( type("lDissidio")=="U",.F.,lDissidio)
nDiasLRem   := If (Type( "nDiasLRem" ) # "N", 0, nDiasLRem)
nDiasSRem   := If (Type( "nDiasSRem" ) # "N", 0, nDiasSRem)
dDtPesq 	:= If (dDtPesq 	== Nil, If( Type("dDatadem") == "D" .and. !Empty(dDatadem),dDatadem, aPeriodo[nPosSem,4] ) , dDtPesq)
lSemanal	:= If (lSemanal	== Nil , .T. , lSemanal)
lSemanal	:= If ( Type("P_SALINC")#"U" .And. P_SALINC, .F., lSemanal )
cListAfas   := If (cListAfas== Nil , "*" , cListAfas)
nDPrgSalMa  := If (Type( "nDPrgSalMa" ) # "N", 0, nDPrgSalMa)
cSitFolh	:= If( Type("cSitFolh")=="U",SRA->RA_SITFOLH,cSitFolh)

If cPaisLoc == "PAR"
	lParSab := If(SRA->RA_SABUTIL == "1",.T.,.F.)
EndIf

If cPaisLoc == "PAR" .And. !lParSab
 	lSabNUtil := .T.
EndIf

//-- Array Criado no Roteiro se Vier por Fora Cria o array caso nao exista
If Type("aVarRot") = "U"
	aVarRot := {}
EndIf

dPerIni := aPeriodo[nPosSem,3]
dPerFim	:= aPeriodo[nPosSem,4]

If !(Type('cCompl') == "U") .and. cCompl == "S" //--Rescisao complementar, nao deve calcular afastamentos
	dPerIni := StoD(AnoMes(dDataDem) + "01")
	dPerFim	:= dDataDem
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para anos bissextos                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lBissexto	:= ( Mod( Year(dDtPesq), 4 ) == 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata Dias Trabalhados para Afastamentos e Ferias            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDiasAfas := nDiasMat := nDPrgSalMa:= nDiasEnf := nDiasPg := nDiasFgts := 0
nDiaAt    := nDiaAd   := nDiasFer := nDiasLRem	:= nDiasEnc := 0
nDRecesso := 0 //Dias Recesso Estagiario
lSalINSS  := .F.

aStruSR8  := SR8->( dbStruct() )
aStruRCM  := RCM->( dbStruct() )

cQuery 	:= 	"SELECT * "
cQuery 	+=		"FROM " + RetSqlName("SR8") + " SR8 "
cQuery	+=		"INNER JOIN " + RetSqlName("RCM") + " RCM "
cQUery	+=			"ON R8_TIPOAFA = RCM_TIPO "
cQuery 	+=		"WHERE R8_FILIAL = '" + SRA->RA_FILIAL + "' AND "
cQuery	+=			"R8_MAT = '" + SRA->RA_MAT + "' AND "
cQuery	+=			"R8_DATAINI >= '" + DtoS(SRA->RA_ADMISSA) + "' AND "
cQuery	+=			"( R8_DATAFIM >= '" + DtoS(dPerIni) + "' OR " + "R8_DATAFIM = '' )" + " AND "
cQuery	+=			"RCM_FILIAL = '" + xFilial("RCM") + "' AND "
cQuery 	+=			"RCM_TIPOAF <> '3' AND "
cQuery 	+=			"RCM.D_E_L_E_T_ <> '*' AND "
cQuery 	+=			"SR8.D_E_L_E_T_ <> '*' "
cQuery	+=		"ORDER BY " + SqlOrder("R8_FILIAL+R8_MAT+R8_DATAINI+R8_TIPO") + " "

cQuery 	:= ChangeQuery(cQuery)
				
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQRY)

For nPosCpo := 1 To Len(aStruSR8)
	If aStruSR8[nPosCpo][2]<>"C"
		TcSetField(cAliasQRY,aStruSR8[nPosCpo][1],aStruSR8[nPosCpo][2],aStruSR8[nPosCpo][3],aStruSR8[nPosCpo][4])
	EndIf
Next nPosCpo

For nPosCpo := 1 To Len(aStruRCM)
	If aStruRCM[nPosCpo][2]<>"C"
		TcSetField(cAliasQRY,aStruRCM[nPosCpo][1],aStruRCM[nPosCpo][2],aStruRCM[nPosCpo][3],aStruRCM[nPosCpo][4])
	EndIf
Next nPosCpo

While (cAliasQRY)->(!Eof())

	nDiasSaldo 	:= 0
	nDiasDisp	:= 0
	nDiasPagar 	:= 0
	
	If (cAliasQRY)->R8_DATAINI > dPerFim
		(cAliasQRY)->(dbSkip())
		Loop
	EndIf	
	
	If (cAliasQRY)->R8_DPAGOS > 0
		nDiasSaldo := (cAliasQRY)->R8_SDPAGAR				
	Else
		If (cAliasQRY)->R8_DPAGAR > 0
			nDiasSaldo	:= (cAliasQRY)->R8_DPAGAR 
		Else
			nDiasSaldo	:= 0
		EndIf				
	EndIf
	
	//Para rescisao, verifica se o periodo de cálculo é posterior ao período em aberto da folha, 
	//pois o afastamento não estará com o saldo atualizado
	If IsInCallStack("GPEM040") .And. fGetLastPer( @cPerFol, @cSemFol , cProcesso, fGetRotOrdinar(), .T., .F. )
		If cPeriodo > cPerFol
			aAreaSRC := SRC->( GetArea() )
			SRC->( dbSetOrder(1) )
			If SRC->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + (cAliasQRY)->R8_PD) )
				While SRC->( !EoF() .And. SRC->RC_FILIAL + SRC->RC_FILIAL + SRC->RC_PD + AllTrim(SRC->RC_NUMID) == SRA->RA_FILIAL + SRA->RA_FILIAL + (cAliasQRY)->R8_PD + AllTrim((cAliasQRY)->R8_NUMID) )
					nDiasSaldo -= SRC->RC_HORAS
					SRC->( dbSkip() )
				End While
			EndIf
			RestArea( aAreaSRC )
		EndIf
	EndIf
	
	If (cAliasQRY)->R8_DATAINI >= dPerIni
		If (SUPERGETMV("MV_DIASPER",,"1") == "2" .AND. Day(dPerFim) == 31 .And. nDiasC == 30 .And. SRA->RA_CATFUNC = "M") .And. !((cAliasQRY)->RCM_TIPOAF == '4') 
			//nDiasDisp	:= dPerFim - (cAliasQRY)->R8_DATAINI + 1 //04/09/18 - Tirado o menos -1 porque estava calculando um dia a mais nos meses de 31 dias. Prb identiifcado especialmnete no afastamento de licenca maternidade
			nDiasDisp	:= dPerFim - (cAliasQRY)->R8_DATAINI
		Else
			If P_PGSALFEV
				nDiasDisp	:= If(Day(dPerFim) <= 29 .And. nDiasC == 30 .And. !((cAliasQRY)->RCM_TIPOAF == '4') .And. !((cAliasQRY)->RCM_CODSEF $ "O1*P1"), If(Day(dPerFim) == 28,dPerFim - (cAliasQRY)->R8_DATAINI + 3,dPerFim - (cAliasQRY)->R8_DATAINI + 2) ,dPerFim - (cAliasQRY)->R8_DATAINI + 1)	
			Else
				nDiasDisp	:= dPerFim - (cAliasQRY)->R8_DATAINI + 1
			EndIf	
		EndIf						
	Else
		If (SUPERGETMV("MV_DIASPER",,"1") == "2" .AND. Day(dPerFim) == 31 .And. nDiasC == 30 .And. SRA->RA_CATFUNC = "M") .And. !((cAliasQRY)->RCM_TIPOAF == '4')
			nDiasDisp	:= dPerFim - dPerIni
		Else
			If P_PGSALFEV
				nDiasDisp	:= If(Day(dPerFim) <= 29 .And. nDiasC == 30 .And. !((cAliasQRY)->RCM_TIPOAF == '4') .And. !((cAliasQRY)->RCM_CODSEF $ "O1*P1"), If(Day(dPerFim) == 28,dPerFim - dPerIni + 3,dPerFim - dPerIni + 2) ,dPerFim - dPerIni + 1)	
			Else
				nDiasDisp	:= dPerFim - dPerIni + 1
			EndIf
		EndIf		
	EndIf

	//Se não for férias e afastamento no periodo inteiro assume afastamento com a quantidade de dias do mês
	If !((cAliasQRY)->RCM_TIPOAF == '4') .And. (Day((cAliasQRY)->R8_DATAINI) == 1 .Or. (cAliasQRY)->R8_DATAINI < dPerIni) .And. Day(dPerFim) == nDiasDisp
		nDiasDisp := DiasTrab
	EndIf 	

	If (cAliasQRY)->R8_DATAINI >= dPerIni		
		If !Empty((cAliasQRY)->R8_DATAFIM) .and. (cAliasQRY)->R8_DATAFIM <= dPerFim
			nAuxAfa	:= (cAliasQRY)->R8_DATAFIM - (cAliasQRY)->R8_DATAINI + 1
		Else
			If (SUPERGETMV("MV_DIASPER",,"1") == "2" .AND. Day(dPerFim) == 31 .And. nDiasC == 30 .And. SRA->RA_CATFUNC = "M") .And. !((cAliasQRY)->RCM_TIPOAF == '4') 
				nAuxAfa	:= dPerFim - (cAliasQRY)->R8_DATAINI
			Else
				If P_PGSALFEV
					nAuxAfa	:= If(Day(dPerFim) <= 29 .And. nDiasC == 30 .And. !((cAliasQRY)->RCM_TIPOAF == '4') .And. !((cAliasQRY)->RCM_CODSEF $ "O1*P1"), If(Day(dPerFim) == 28,dPerFim - (cAliasQRY)->R8_DATAINI + 3,dPerFim - (cAliasQRY)->R8_DATAINI + 2) ,dPerFim - (cAliasQRY)->R8_DATAINI + 1)				
				Else
					nAuxAfa	:= dPerFim - (cAliasQRY)->R8_DATAINI + 1
				EndIf				
			EndIf
		EndIf
	Else
		If !Empty((cAliasQRY)->R8_DATAFIM) .and. (cAliasQRY)->R8_DATAFIM <= dPerFim
			nAuxAfa := (cAliasQRY)->R8_DATAFIM - dPerIni + 1	
			If SubStr((cAliasQRY)->RCM_CODSEF,1,1) == "Q"
				nDiasSaldo	:= (cAliasQRY)->R8_DATAFIM - dPerIni + 1
			EndIf
		Else
			If P_PGSALFEV
				nAuxAfa	:= If(Day(dPerFim) <= 29 .And. nDiasC == 30 .And. !((cAliasQRY)->RCM_TIPOAF == '4') .And. !((cAliasQRY)->RCM_CODSEF $ "O1*P1"), If(Day(dPerFim) == 28,dPerFim - dPerIni + 3,dPerFim - dPerIni + 2) ,dPerFim - dPerIni + 1)							
			Else
				nAuxAfa	:= dPerFim - dPerIni + 1
			EndIf						
		EndIf	
	EndIf
	
	//Se não for férias e afastamento no periodo inteiro assume afastamento com a quantidade de dias do mês
	If !((cAliasQRY)->RCM_TIPOAF == '4') .And. (Day((cAliasQRY)->R8_DATAINI) == 1 .Or. (cAliasQRY)->R8_DATAINI < dPerIni) .And. Day(dPerFim) == nAuxAfa
		nAuxAfa := DiasTrab
	EndIf 
	
	If !lDissidio
		//Se nao for adiantamento e afastamento de ferias
		If !(cTipoRot == "2" .And. (cAliasQRY)->RCM_TIPOAF == "4")
			nDiasPagar 	:= Min(nDiasSaldo,nDiasDisp)
		EndIf		
    Else
    	If (cAliasQRY)->R8_DIASEMP == 0
    		nDiasPagar := 0
    	ElseIf !Empty((cAliasQRY)->R8_DATAFIM) 
    		If (dPerIni - (cAliasQRY)->R8_DATAINI + 1 ) > (cAliasQRY)->R8_DIASEMP
    			nDiasPagar := 0
    		Else
    			nDiasPagar := Min(Min(dPerFim,(cAliasQRY)->R8_DATAFIM) - (Max(dPerIni,(cAliasQRY)->R8_DATAINI)) + 1,(cAliasQRY)->R8_DIASEMP)
    			If nDiasPagar > (cAliasQRY)->R8_DIASEMP - (dPerIni - (cAliasQRY)->R8_DATAINI )
//    				nDiasPagar :=  Min(nDiasPagar ,(cAliasQRY)->R8_DIASEMP - (dPerIni - (cAliasQRY)->R8_DATAINI + 1))
    				nDiasPagar :=  Min(nDiasPagar ,(cAliasQRY)->R8_DIASEMP - (dPerIni - (cAliasQRY)->R8_DATAINI ))
    			EndIf
    		EndIf
    	Else           
			If (dPerIni - (cAliasQRY)->R8_DATAINI + 1 ) > (cAliasQRY)->R8_DIASEMP
    			nDiasPagar := 0
    		Else
    			nDiasPagar := Min(dPerFim - (Max(dPerIni,(cAliasQRY)->R8_DATAINI)) + 1,(cAliasQRY)->R8_DIASEMP)
    			If (dPerIni - (cAliasQRY)->R8_DATAINI + 1) > 0
    				nDiasPagar :=  Max((nDiasPagar - (dPerIni - (cAliasQRY)->R8_DATAINI + 1)),0)
    			EndIf
    		EndIf
		EndIf
    EndIf
    //Se nDiasPagar for 31, e calculo for por 30 dias, deve igualar variaveis, para que não ocorra proporcionalização incorreta.
    lBissexto := ( Mod( val(left(cPeriodo,4)), 4 ) == 0 )
    If right(cPeriodo,2) == '02' .and. ( (lBissexto .and. nDiasPagar == 29) .or. (!lBissexto .and. nDiasPagar == 28) )
    	nDiasPagar := 30
    EndIf
    nDiasPagar := Min(nDiasPeriodo,nDiasPagar)                       
	nDiasAfas += nAuxAfa
	
	If (cAliasQRY)->RCM_DEPFGT == "1" .OR. (cAliasQRY)->RCM_TIPO = "001"  //Ferias      
		If AllTrim((cAliasQRY)->RCM_CODSEF) == "M" .And. !(lTCpoFgts .And. SRA->RA_PERFGTS > 0.00) 
			nDiasFgts 	+= nDiasPagar 
		Else
			nDFgts		:= Min(DiasTrab,nAuxAfa)
			If (cAliasQRY)->RCM_TIPO != "001"
				nDiasFgts	+= nDFgts
			EndIf
		EndIf
	EndIf     
	
	If (cAliasQRY)->RCM_TIPO = "001"  //Ferias
		nDiasFer += nAuxAfa
	EndIf  
	
	If (cAliasQRY)->RCM_ENCEMP == "1"
		nDEnc		:= Min(DiasTrab,(nAuxAfa - nDiasPagar))
		nDiasEnc	+= nDEnc
	EndIf
	
	If (cAliasQRY)->RCM_MESMED > 0 .and. SRA->RA_CATFUNC $ (cAliasQRY)->RCM_CATMED
		nMesMedAfa := (cAliasQRY)->RCM_MESMED
	Else
		nMesMedAfa := 0
	EndIf

	If nDFgts > 0 .and. SRA->RA_CATFUNC == "C" 
		If (cAliasQRY)->RCM_CODSEF == "P1"  
			fVarRot("nMedComiss",( nMedComiss / nDiasC * nDiasPagar),"A")  
		Else
			fVarRot("nMedComiss",( nMedComiss / nDiasC * nDFgts),"A")  
		EndIf
	EndIf
	
	If nDiasPagar > 0
		nDiasPg += nDiasPagar  //Soma valor de dias a pagar no mnemonico
		If SR8->(ColumnPos( "R8_PROADIC")) > 0
			If (cAliasQRY)->R8_PROADIC != "1" .Or. (cAliasQRY)->RCM_CODSEF $ "Q1*Q2*Q3*Q4*Q5*Q6"
				nDaPaPg += nDiasPagar
			EndIf
		Else
			nDaPaPg += nDiasPagar
		EndIf
		
		If (cAliasQRY)->RCM_CODSEF	$ "Q1*Q3"
			nDiasMat += nDiasPagar
		EndIf
		If (cAliasQRY)->RCM_CODSEF	== "Q2"
			nDPrgSalMa += nDiasPagar
		EndIf
		
		//RECESSO ESTAGIARIO
		If (cAliasQRY)->R8_TIPOAFA == '002' .And. SRA->RA_CATFUNC $ '*E*G*'
			//Se parte do recesso ocorrer no mes seguinte efetua todo o calculo no primeiro mes
			If MesAno((cAliasQRY)->R8_DATAINI) == MesAno(dDtPesq) .And. MesAno((cAliasQRY)->R8_DATAFIM) > MesAno(dDtPesq)
				nDiasPagar   := (cAliasQRY)->R8_DURACAO
			EndIf
		EndIf
		
		aAdd(aDetAfas,	{	(cAliasQRY)->R8_PD			,;		//Codigo verba
							nDiasPagar					,;      //Qtd Dias a Pagar
							(cAliasQRY)->R8_NUMID		,;		//Numero ID
							nDFgts						,;		//Dias para FGTS
							nDEnc						,;      //Dias para Encargos
							nAuxAfa				   		,;		//Total dias afastados
							(cAliasQRY)->RCM_CODSEF		,;		//Codigo SEFIP
							(cAliasQRY)->R8_DATAINI		,;		//Data Inicial do Afastamento
							nMesMedAfa					})		//Quantidade de meses para calculo de media
	EndIf
	
	// Adiciona afastamento em mnemonico para porporcionalidade de tarefas
	If MesAno((cAliasQRY)->R8_DATAINI) == MesAno(dDtPesq) .Or.;
	MesAno((cAliasQRY)->R8_DATAINI) < MesAno(dDtPesq) .And. ( Empty((cAliasQRY)->R8_DATAFIM) .Or. MesAno((cAliasQRY)->R8_DATAFIM) >= MesAno(dDtPesq) )
		aAdd( aAfaTar, {(cAliasQRY)->R8_SEQ	 , (cAliasQRY)->R8_TIPO , (cAliasQRY)->R8_DATAINI , (cAliasQRY)->R8_DATAFIM , (cAliasQRY)->R8_CONTAFA , .F. } )
	EndIf
	
	(cAliasQRY)->(dbSkip())
Enddo

DbSelectArea(cAliasQRY)
DbCloseArea()

DiasTrab -= nDiasAfas

If !(SRA->RA_CATFUNC $ "D*H*T*G")
	//?-Tratamento para diminuir o Afastamento de Maternidade quando no mesmo mes que Ferias
	If (nDiasFer + nDiasMat + nDPrgSalMa) > nDiasPeriodo  
		IF nDPrgSalMa > 0                           
			nDPrgSalMa -= Max(((nDiasFer + nDiasMat + nDPrgSalMa) - nDiasPeriodo), 0)
		Else
			nDiasMat -= ((nDiasFer + nDiasMat) - nDiasPeriodo)
		Endif	
	EndIf
EndIf

DiasTrab := If(DiasTrab<0,0,DiasTrab)

If cPaisLoc <> "BRA"
	nDiasFgts := 0
EndIf	

Return
