#include "Protheus.ch"
//#include "APD005.CH"

#DEFINE _ENTER chr(13)+chr(10)

/*/{Protheus.doc} APD005

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Rotina de processamento dos cálculos de Resultados de Política de Consolidação 

/*/
User Function APD005()

	Local aSays			:= {}
	Local aButtons		:= {}
	Local nOpca
	Local oDlg
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aGDCoord		:= {}
	Local aArea			:= GetArea()
	
	Private cCadastro 	:= OemToAnsi("Cálculo de Política de Consolidação")	
	Private nSavRec		:= 0
	Private _nRound		:= GetMV("MV_APDARRM")
	Private dDataCalc	:= Date()

	
	Pergunte("APD005",.F.)
	
	/*
	---------------------------
	Monta dimensões dos objetos
	---------------------------
	*/
	
	aAdvSize		:= MsAdvSize()
	aAdvSize[5]		:= (aAdvSize[5]/100) * 35	//horizontal
	aAdvSize[6]		:= (aAdvSize[6]/100) * 55	//Vertical
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	aGdCoord		:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*25), (((aObjSize[1,4])/100)*29.6) }	//1,3 Vertical /1,4 Horizontal
	
	SetaPilha()
	
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM  aAdvSize[7],20 TO aAdvSize[6]-50,600  OF oMainWnd PIXEL
	
		//@ aGdCoord[1]+7,aGdCoord[2]	GROUP oGroupCalc TO (aGdCoord[3]/1.2)+5,aGdCoord[4]+5  LABEL "" OF oDlg PIXEL
		//oGroupCalc:oFont:=oFont
		@ aGdCoord[1]+20,aGdCoord[2]+4 Say OemToAnsi( "Este programa tem como objetivo efetuar o Cálculo da Política de Consolidação," ) Size 290,07 Pixel Font oFont Color CLR_BLUE
		@ aGdCoord[1]+32,aGdCoord[2]+4 Say OemToAnsi( "com base no critério estabelecido em 'Parâmetros'" ) Size 290,07 Pixel Font oFont Color CLR_BLUE
		
		aButtons	:=	{;
						{"Perguntas"  ,{ || Pergunte("APD005",.T. ) },"Parâmetros","Parâmetros"};
						}
			
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , { || nOpca 	:= 1, oDlg:End() } , { || nOpca 	:= 0 , oDlg:End() } , NIL , aButtons )
	
	SetaPilha()

	/*
	------------------------------------
	Variaveis utilizadas para Parâmetros
	------------------------------------
	*/
	If nOpca == 1
		Processa({|lEnd| APD005Proc(),OemToAnsi("Cálculo de Política de Consolidação")}) 
	EndIf
	
	RestArea(aArea)

Return Nil

/*/{Protheus.doc} APD005Proc

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Processamento dos cálculos Consolidados

/*/
Static Function APD005Proc()

	Local nx
	Local lMetas		:= .F.			//Define se será processado o Cálculo das Avaliações de Metas (Carregado pela Função LoadMeta)
	Local lComp			:= .F.			//Define se será processado o Cálculo das Avaliações de Competencias (Carregado pela Função LoadMeta)
	Local lForma		:= .F.			//Define se será processado o Cálculo das Formações Acadêmicas (Carregado pela Função LoadMeta)
	Local nPerMeta		:= 0			//Percentual do Cálculo Consolidado a ser considerado para Metas (Carregado pela Função LoadMeta)
	Local nPerComp		:= 0			//Percentual do Cálculo Consolidado a ser considerado para Competências (Carregado pela Função LoadMeta)
	Local nPerForma		:= 0			//Percentual do Cálculo Consolidado a ser considerado para Formação Acadêmica (Carregado pela Função LoadMeta)
	Local aFunc			:= {}			//Lista de Funcionários (Filial e Matrícula) utilizada para seleção de Formação Acadêmica
	Local aPeriodos		:= {}			//Períodos que compõem a Política Consolidada (Carregado pela Função LoadMeta)
	Local lProcessa		:= .T.
	Local lTemSZE		:= .F.
	Private aLog		:= {}
	Private cPolitica	:= mv_par01
	Private cRD0		:= mv_par02
	Private cFiltro		:= ''
	
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"Data/Hora de Início do Processamento: " + DtoC(Date()) + " / " + Time()) //"Data/Hora de Início do Processamento: "
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"-------------")
	aAdd(aLog,"Parâmetros: ") //"Parâmetros: "
	aAdd(aLog,"-------------")
	aAdd(aLog,"Política de Consolidação: " + cPolitica + " - " + Posicione("SZC",1,xFilial("SZC")+cPolitica,"ZC_DESC")) //"Política de Consolidação: "
	
	aAdd(aLog," ")
	
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"Início da Leitura da Política: " + Time()) //"Início da Leitura da Política: "
	aAdd(aLog,"----------------------------------------------------------------------")
	/*
	-----------------------------
	Carrega diretivas da Política
	-----------------------------
	*/
	MsAguarde( { || LoadPolitica(cPolitica,@lComp,@nPerComp,@lMetas,@nPerMeta,@lForma,@nPerForma,@aPeriodos) } , "Aguarde", "Carregando Política " + cPolitica + "...")
	aAdd(aLog," ")
	aAdd(aLog,"-------------")
	aAdd(aLog,"Períodos: ") //"Períodos: "
	aAdd(aLog,"-------------")
	aEval(aPeriodos,{|x| aAdd(aLog,x[1] + " - " + Posicione("RDU",1,xFilial("RDU")+x[1],"RDU_DESC"))})
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"Término da Leitura da Política: " + Time()) //"Término da Leitura da Política: "
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog," ")	
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"Verificação de reprocessamento: " + Time()) //"Verificação de reprocessamento: "
	aAdd(aLog,"----------------------------------------------------------------------")
	/*
	---------------------------------------------------
	Verifica se existem Cálculos para a Política ()SZE)
	---------------------------------------------------
	*/
	lTemSZE := TemSZE(cPolitica)
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"Término da Verificação de reprocessamento: " + Time()) //"Término da Verificação de reprocessamento: "
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog," ")
	
	If lTemSZE
	
		If empty(cRD0)
			lProcessa := MsgNoYes("Foram encontrados registros de resultados para a política " + cPolitica + ". Deseja continuar e substituir o cálculo anterior de TODOS os participantes ?")
		Else
			lProcessa := MsgNoYes("Foi encontrado registro de resultado do participante para a política " + cPolitica + ". Deseja continuar e substituir o cálculo anterior do participante " + cRD0 + " ?")
		EndIf		
	EndIf
	
	If lProcessa
		
		/*
		-------------------------------------
		Exclui Registros da SZE (se houverem)
		-------------------------------------
		*/
		If lTemSZE
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Reprocessamento: " + Time()) //"Reprocessamento: "
			aAdd(aLog,"----------------------------------------------------------------------")
			MsAguarde( { || ExcluiSZE(cPolitica) } , "Aguarde", "Excluindo Resultados para a Política " + cPolitica + "...")
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Término do reprocessamento: " + Time()) //"Término do reprocessamento: "
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog," ")
		
		EndIf
		
		/*
		-------------------------------------
		Processa Metas
		-------------------------------------
		*/
		If lMetas
		
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Cálculos das Metas: " + Time()) //"Cálculos das Metas: "
			aAdd(aLog,"----------------------------------------------------------------------")
			MsAguarde( { || GeraMetas(nPerMeta,aPeriodos,@aFunc) } , "Aguarde", "Calculando Metas...")
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Término Cálculo das Metas: " + Time()) //"Término Cálculo das Metas: "
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog," ")
			
		EndIf
		
		/*
		-------------------------------------
		Processa Competências
		-------------------------------------
		*/
		If lComp
		
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Cálculos das Competências: " + Time()) //"Cálculos das Competências: "
			aAdd(aLog,"----------------------------------------------------------------------")
			MsAguarde( { || GeraComp(nPerComp,aPeriodos,@aFunc) } , "Aguarde", "Calculando Competências...")
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Término dos Cálculos das Competências: " + Time()) //"Término dos Cálculos das Competências: "
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog," ")
			
		EndIf
		
		/*
		-------------------------------------
		Processa Formação Acadêmica
		-------------------------------------
		*/
		If lForma
		
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Cálculos das Formações Acadêmicas: " + Time()) //"Cálculos das Formações Acadêmicas: "
			aAdd(aLog,"----------------------------------------------------------------------")
			MsAguarde( { || GeraForm(nPerForma,aPeriodos,aFunc) } , "Aguarde", "Calculando Formação Acadêmica...")
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog,"Término dos Cálculos das Formações Acadêmicas: " + Time()) //"Término dos Cálculos das Formações Acadêmicas: "
			aAdd(aLog,"----------------------------------------------------------------------")
			aAdd(aLog," ")
			
		EndIf
		
		/*
		-------------------------------------
		Processa Cálculo Consolidado
		-------------------------------------
		*/
		aAdd(aLog,"----------------------------------------------------------------------")
		aAdd(aLog,"Cálculos Consolidados: " + Time()) //"Cálculos Consolidados: "
		aAdd(aLog,"----------------------------------------------------------------------")
		MsAguarde( { || GeraCons() } , "Aguarde", "Efetuando Cálculo Consolidado...")
		aAdd(aLog,"----------------------------------------------------------------------")
		aAdd(aLog,"Término dos Cálculos Consolidados: " + Time()) //"Término dos Cálculos Consolidados: "
		aAdd(aLog,"----------------------------------------------------------------------")
		aAdd(aLog," ")
		
	EndIf
	
	_GravaLog(aLog,aFunc)
	
Return Nil



/*/{Protheus.doc} LoadPolitica

@type function
@author Jorge Heitor
@since 14/04/2016
@version 1.0
@description Carrega dados da Política de Avaliação Consolidada

/*/
Static Function LoadPolitica(cPolitica,lComp,nPerComp,lMetas,nPerMeta,lForma,nPerForma,aPeriodos)

	//Caso o Alias esteja em uso, fecha o mesmo
	If Select("TSZC") > 0 ; TSZC->(dbCloseArea()) ; EndIf
	
	BeginSQL Alias "TSZC"
		
		SELECT * FROM %Table:SZC% SZC
		WHERE SZC.ZC_CODIGO = %Exp:cPolitica% AND SZC.%NotDel% AND SZC.ZC_STATUS = "1"
		
	EndSQL
	
	dbSelectArea("TSZC")
	If !TSZC->(Eof())
	
		lComp 		:= (TSZC->ZC_PERCOMP > 0)
		nPerComp 	:= TSZC->ZC_PERCOMP
		lMetas 		:= (TSZC->ZC_PERMETA > 0)
		nPerMeta 	:= TSZC->ZC_PERMETA 
		lForma 		:= (TSZC->ZC_PERFORM > 0)
		nPerForma 	:= TSZC->ZC_PERFORM
		cFiltro		:= TSZC->ZC_FILTRO
		
		TSZC->(dbCloseArea())
		
		/*
		--------------------------
		Carrega dados dos Períodos
		--------------------------
		*/
		If Select("TSZD") > 0 ; TSZD->(dbCloseArea()) ; EndIf
		
		BeginSQL Alias "TSZD"
		
			SELECT SZD.ZD_CODPER CODIGO,RDU.RDU_TIPO TIPO FROM %Table:SZD% SZD
			INNER JOIN %Table:RDU% RDU ON
				RDU.RDU_CODIGO = SZD.ZD_CODPER
			WHERE SZD.ZD_CODIGO = %Exp:cPolitica% AND SZD.%NotDel% AND RDU.%NotDel%
			ORDER BY SZD.ZD_CODPER,RDU.RDU_TIPO
			
		EndSQL
		
		dbSelectArea("TSZD")
		If !TSZD->(Eof())
		
			While !TSZD->(Eof())
			
				aAdd(aPeriodos,{TSZD->CODIGO,TSZD->TIPO})
				TSZD->(dbSkip())
				
			End
			
		EndIf
		
		TSZD->(dbCloseArea())		
		
	Else
	
		MsgStop("A política informada não foi encontrada e/ou não está ativa.")
		
	EndIf

Return Nil

/*/{Protheus.doc} TemSZE

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Verificação da existência de registros já processados com os parâmetros informados

/*/
Static Function TemSZE(cPolitica)

	Local lRet		:= .F.

	cWhere := " SZE.D_E_L_E_T_ = '' AND ZE_IDCONS = '" + cPolitica + "' "
	If !empty(cRD0)
		cWhere += " AND ZE_CODRD0 = '" + cRD0 + "' "
	EndIf
	cWhere := "%" + cWhere + "%" 

	
	//Caso o Alias esteja em uso, fecha o mesmo
	If Select("TSZE") > 0 ; TSZE->(dbCloseArea()) ; EndIf
	
	BeginSQL Alias "TSZE"
	
		SELECT COUNT(*) QTD FROM %Table:SZE% SZE
		WHERE %Exp:cWhere%
		
	EndSQL
	
	dbSelectArea("TSZE")
	
	If TSZE->QTD > 0
	
		lRet := .T.
		
	EndIf	

Return lRet

/*/{Protheus.doc} ExcluiSZE

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Exclui informações de Processamento de Cálculo Consolidado Anterior

/*/
Static Function ExcluiSZE(cPolitica)

	Local aArea		:= GetArea()
	
	dbSelectArea("SZE")

	If empty(cRD0)
		dbSetOrder(2) //ZE_IDCONS
		cChave := cPolitica
	Else
		dbSetOrder(1) //ZE_FILIAL+ZE_CODRD0+ZE_IDCONS
		cChave := xFilial("SZE")+cRD0+cPolitica
	EndIf
	
	dbGoTop()
	
	dbSeek(cChave)
	If Found()
	
		While !SZE->(Eof()) .and. If( empty(cRD0), SZE->ZE_IDCONS == cChave, SZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS) == cChave )
		
			RecLock("SZE",.F.)
			
				dbDelete()
				
			MsUnlock()
			
			SZE->(dbSkip())
			
		End
		
	EndIf
	
	RestArea(aArea)

Return Nil

/*/{Protheus.doc} GeraMetas

@type function
@author Jorge Heitor
@since 14/04/2016
@version 1.0
@description Calcula Resultado Consolidado de Avaliações de Metas

/*/
Static Function GeraMetas(nPerMeta,aPeriodos,aFunc)

	Local aArea		:= GetArea()
	Local aSZE		:= {}
	Local cGrupo	:= "01"
	Local nPos		:= 0
	Local nPosFunc	:= 0
	Local cMetasIn	:= ""
	Local cWhere	:= ""
	Local x
	Local cChave	:= ""
	Local lErro		:= .f.
	Local cCodRD0	:= ""
	
	/*
	------------------------
	Composição do Array aSZE
	------------------------
	aSZE[x][1]  -> Z0_FILIAL
	aSZE[x][2]  -> Z0_MAT
	aSZE[x][3]  -> cPolitica
	aSZE[x][4]  -> cGrupo
	aSZE[x][5]  -> ZD_CODPER
	aSZE[x][6]  -> nPerMeta
	aSZE[x][7]  -> nTotPer
	aSZE[x][8]  -> nMedParc
	aSZE[x][9]  -> nMedFin
	aSZE[x][10] -> Date()
	*/
	
	//Cria Condição WHERE para os períodos do tipo "Meta"
	aEval(aPeriodos,{|y| cMetasIn += Iif(y[2] == '3' , "'" + y[1] + "',","")})
	
	cMetasIn := "(" + SubString(cMetasIn,1,Len(cMetasIn)-1) + ")"

	If cMetasIn <> "()"
	
		cWhere := " Z0_STATUS = '3' AND SZ0.D_E_L_E_T_ = '' AND SRA.D_E_L_E_T_ = '' "
		cWhere += " AND Z0_CODPER IN " + cMetasIn
		cWhere := "%" + cWhere + "%" 
		
		//Caso esteja aberto o Alias, fecha-o
		If Select("TSZ0") > 0 ; TSZ0->(dbCloseArea()) ; EndIf
	  	
		BeginSQL Alias "TSZ0"
		
			SELECT SRA.R_E_C_N_O_ as SRARECNO, SRA.RA_DEPTO, SZ0.Z0_FILIAL, SZ0.Z0_MAT, SZ0.Z0_CODPER,SUM(SZ0.Z0_RESULT) Z0_RESULT, COUNT(SZ0.Z0_MAT) FATOR
			FROM %Table:SZ0% SZ0
			inner join  %Table:SRA% SRA ON RA_FILIAL = Z0_FILIAL and RA_MAT = Z0_MAT
			WHERE %Exp:cWhere%
			GROUP BY SRA.R_E_C_N_O_, RA_DEPTO, Z0_FILIAL,Z0_MAT,Z0_CODPER
			ORDER BY Z0_FILIAL,Z0_MAT,Z0_CODPER
			
		EndSQL
		
		dbSelectArea("TSZ0")
		While !TSZ0->(Eof())
		
			//Verifica filtro e despreza funcionario
			If cFiltro <> '3' //Diferente de Ambos
				SRA->(dbgoto(TSZ0->SRARECNO))
				cAux := U_fFiltroAva()
				If cFiltro == '1' //Somente Gestores
					If !(cAux $ ("09/10/11/12/13")) 
						TSZ0->(dbSkip())
						loop
					EndIf
				Else	//Demais
					If (cAux $ ("09/10/11/12/13")) 
						TSZ0->(dbSkip())
						loop
					EndIf
				EndIf										
			EndIf	

//			nTotPer := Round((TSZ0->Z0_RESULT / TSZ0->FATOR),_nRound)
			nTotPer := Round((TSZ0->Z0_RESULT ),_nRound)
			
			//Busca na RDZ o codigo RD0 com base na Filial e Matricula
			If cChave <> (TSZ0->Z0_FILIAL+TSZ0->Z0_MAT)
				If !( U_fBuscaRD0(TSZ0->Z0_FILIAL,TSZ0->Z0_MAT,@cCodRD0) )
					aAdd(aLog,"Código do participante não encontrado para a filial/matrícula " + TSZ0->Z0_FILIAL+TSZ0->Z0_MAT + " no período de metas " + TSZ0->Z0_CODPER )
					lErro := .t.
					TSZ0->(dbSkip())
					loop
				EndIf
			EndIf
			If !empty(cRD0) 
				If cRD0 <> cCodRD0
					TSZ0->(dbSkip())
					loop
				Else
					cCodRD0 := cRD0
				EndIf
			EndIf
			cChave := (TSZ0->Z0_FILIAL+TSZ0->Z0_MAT)

			//Verifica se o Funcionário existe no Array de Funcionarios (Para pesquisa de Formação Acadêmica)
			If aScan(aFunc,{|z| z[1] == cCodRD0 }) <= 0
			
				aAdd(aFunc,{cCodRD0,TSZ0->Z0_FILIAL,TSZ0->Z0_MAT,TSZ0->RA_DEPTO})
				
			EndIf

			//Verifica se o Funcionário ja existe no array de Gravação do SZE (mediante filtros)
			nPos := aScan(aSZE,{|x| x[1] == TSZ0->Z0_FILIAL .And. x[2] == TSZ0->Z0_MAT .And. x[5] == TSZ0->Z0_CODPER})
		
			If nPos <= 0
			
				aAdd(aSZE,{xFilial("RDD",TSZ0->Z0_FILIAL), cCodRD0, cPolitica, cGrupo,TSZ0->Z0_CODPER,nPerMeta,nTotPer,0,0,dDataCalc,TSZ0->Z0_FILIAL, TSZ0->Z0_MAT,TSZ0->RA_DEPTO,"0"})
				
			EndIf
			
			TSZ0->(dbSkip())
		
		End
		
		If len(aSZE) > 0

			//Processa Média Parcial para o ultimo registro de cada Funcionário (Serão totalizados todos os períodos)
			cChave := aSZE[1][1] + aSZE[1][2] //Filial + Codigo RD0
			nValor := 0
			nFator := 0
			
			For x := 1 To Len(aSZE)
				
				If cChave <> aSZE[x][1] + aSZE[x][2]
				
					aSZE[x-1][8] := Round(nValor / nFator,_nRound) //Media Parcial
					aSZE[x-1][9] := Round(aSZE[x-1][8] * (aSZE[x-1][6]/100),_nRound)
					nValor := 0
					nFator := 0
				
				EndIf
				
				nValor += aSZE[x][7]
				nFator ++
				
				cChave := aSZE[x][1] + aSZE[x][2]		
			
			Next x
			
			//Processa último Funcionário
			nLast := Len(aSZE)
			aSZE[nLast][8] := Round(nValor / nFator,_nRound) //Media Parcial
			aSZE[nLast][9] := Round(aSZE[nLast][8] * (aSZE[nLast][6]/100),_nRound)
			nValor := 0
			nFator := 0
			
			MsAguarde( { || GravaSZE(aSZE) } , "Aguarde", "Gravando Metas...")

		EndIf

	EndIf
		
	RestArea(aArea)

Return

/*/{Protheus.doc} GeraComp

@type function
@author Jorge Heitor
@since 14/04/2016
@version 1.0
@description Calcula Resultado Consolidado de Avaliações de Competências

/*/
Static Function GeraComp(nPerComp,aPeriodos,aFunc)

	Local aArea		:= GetArea()
	Local aSZE		:= {}
	Local cGrupo	:= "02"
	Local nPos		:= 0
	Local nPosFunc	:= 0
	Local cCompIn	:= ""
	Local cWhere	:= ""
	Local nTotAva	:= 0
	Local x
	Local cChave	:= ""
	Local lErro		:= .f.
	Local cFil		:= ""
	Local cMat		:= ""
	Local cDepto	:= ""
	
	RDC->(dbsetorder(1))
		
	/*
	------------------------
	Composição do Array aSZE
	------------------------
	aSZE[x][1]  -> RDD_FILIAL
	aSZE[x][2]  -> RDD_CODADO
	aSZE[x][3]  -> cPolitica
	aSZE[x][4]  -> cGrupo
	aSZE[x][5]  -> RDD_CODAVA
	aSZE[x][6]  -> nPerComp
	aSZE[x][7]  -> nTotAva
	aSZE[x][8]  -> nMedParc
	aSZE[x][9]  -> nMedFin
	aSZE[x][10] -> Date()
	*/
	
	//Cria Condição WHERE para os períodos do tipo "Competência"
	aEval(aPeriodos,{|y| cCompIn += Iif(y[2] == '4' , "'" + y[1] + "',","")})
	
	cCompIn := "(" + SubString(cCompIn,1,Len(cCompIn)-1) + ")"
	
	If cCompIn <> "()"
	
		cWhere := " RD6.D_E_L_E_T_ = '' "
		cWhere += " AND RD6.RD6_CODPER IN " + cCompIn
		cWhere := "%" + cWhere + "%" 
		
		//Caso esteja aberto o Alias, fecha-o
		If Select("TRD6") > 0 ; TRD6->(dbCloseArea()) ; EndIf
	  	
		BeginSQL Alias "TRD6"
		
			SELECT RD6_CODIGO,RD6_DESC,RD6_STATUS
			FROM %Table:RD6% RD6
			WHERE %Exp:cWhere%
			ORDER BY RD6_CODIGO
			
		EndSQL
		
		dbSelectArea("TRD6")
		While !TRD6->(Eof())
		
		/* Desabilitado para permitir o calculo a qualquer momento. Prodam necessida calcular varias vezes.
			//Caso a Pesquisa ainda esteja aberta, coloca no LOG e pula para a próxima
			If TRD6->RD6_STATUS <> '2'
			
				aAdd(aLog,"A avaliação " + TRD6->RD6_CODIGO + " - " + AllTrim(TRD6->RD6_DESC) + " não foi processada, pois está com status 'Aberto'.")
				TRD6->(dbSkip())
				Loop
			
			EndIf
		*/	
			/*
			--------------------------------------
			Busca resultados para a pesquisa atual
			--------------------------------------
			*/
			//Fecha Alias caso esteja aberto
			If Select("TRDD") > 0 ; TRDD->(dbCloseArea()) ; EndIf
			
			//Monta Cláusula Where 
			cWhere := " RDC.D_E_L_E_T_ = ''"
			cWhere += " AND RDC.RDC_CODAVA = '" + TRD6->RD6_CODIGO + "'"
			cWhere += " AND RDC.RDC_TIPOAV IN ('1','3')"
			cWhere += " AND RDC_NIVEL = '2' "
			If !empty(cRD0)
				cWhere += " AND RDC_CODADO = '" + cRD0 + "' "
			EndIf
			cWhere := "%" + cWhere + "%" 
			
			BeginSQL Alias "TRDD"
			
				SELECT RDC.RDC_FILIAL, RDC.RDC_CODAVA, RDC.RDC_CODADO, RDC.RDC_TIPOAV, SUM(RDD.RDD_PTOMAX) RDD_PTOMAX, 
				       SUM(RDD.RDD_RESOBT) RDD_RESOBT, RDC_DATRET, RDC_NIVEL, RDC.R_E_C_N_O_, RDD.RDD_CODAVA
				FROM %Table:RDC% RDC
				LEFT JOIN %Table:RDD% RDD on  RDC_FILIAL = RDD_FILIAL and RDC_CODAVA = RDD_CODAVA and 
				                              RDC_CODADO = RDD_CODADO and RDC_CODNET = RDD_CODNET and
				                              RDC_TIPOAV = RDD_TIPOAV and RDD.%NotDel%
				WHERE %Exp:cWhere%
				GROUP BY RDC.RDC_FILIAL, RDC.RDC_CODAVA, RDC.RDC_CODADO, RDC.RDC_TIPOAV, RDC.RDC_DATRET, RDC.RDC_NIVEL, RDC.R_E_C_N_O_, RDD.RDD_CODAVA
				ORDER BY RDC.RDC_FILIAL ASC, RDC.RDC_CODAVA ASC, RDC.RDC_CODADO ASC, RDC.RDC_TIPOAV DESC
			
			EndSQL
			
			lErro := .f.
			
			SRA->(dbsetorder(1))

			dbSelectArea("TRDD")
			While !TRDD->(Eof())
				
				//Se for o mesmo funcionario anterior, para a mesma avaliação, pula, pois pega apenas o primeiro registro.
				If cChave == TRDD->RDC_FILIAL + TRDD->RDC_CODAVA + TRDD->RDC_CODADO
			
					TRDD->(dbSkip())
					Loop
			
				EndIf

				//Alimenta informações de Funcionarios para Formação Acadêmica Consolidada
				nPosFunc := aScan(aFunc,{|z| z[1] == TRDD->RDC_CODADO })
				If nPosFunc <= 0 
				
					//Busca a Filial e Matricula na RDZ
					If !( U_fBuscaMat(TRDD->RDC_CODADO,@cFil,@cMat,@cDepto) )
						aAdd(aLog,"Filial/Matricula não encontrados para avaliado " + TRDD->RDC_CODADO + " na avaliação " + TRD6->RD6_CODIGO + " - " + AllTrim(TRD6->RD6_DESC))
						lErro := .t.
						TRDD->(dbSkip())
						loop
					EndIf

					//Verifica filtro e despreza funcionario
					If cFiltro <> '3' //Diferente de Ambos
						SRA->(dbseek(cFil+cMat))
						cAux := U_fFiltroAva()
						If cFiltro == '1' //Somente Gestores
							If !(cAux $ ("09/10/11/12/13")) 
								TRDD->(dbSkip())
								loop
							EndIf
						Else	//Demais
							If (cAux $ ("09/10/11/12/13")) 
								TRDD->(dbSkip())
								loop
							EndIf
						EndIf										
					EndIf	

					aAdd(aFunc,{TRDD->RDC_CODADO,cFil,cMat,cDepto})
			
				Else

					//Verifica filtro e despreza funcionario
					If cFiltro <> '3' //Diferente de Ambos
						SRA->(dbseek(aFunc[nPosFunc,2]+aFunc[nPosFunc,3]))
						cAux := U_fFiltroAva()
						If cFiltro == '1' //Somente Gestores
							If !(cAux $ ("09/10/11/12/13")) 
								TRDD->(dbSkip())
								loop
							EndIf
						Else	//Demais
							If (cAux $ ("09/10/11/12/13")) 
								TRDD->(dbSkip())
								loop
							EndIf
						EndIf										
					EndIf	
				
					cFil 	:= aFunc[nPosFunc,2]
					cMat 	:= aFunc[nPosFunc,3]
					cDepto 	:= aFunc[nPosFunc,4]
				
				EndIf

				//Se for Tipo 3-Avaliacao e nao encontrou RDD significa que nao encontrou resultado 
				//calculado para consenso e devera avancar para tratar o tipo 1-Avaliacao
				If TRDD->RDC_TIPOAV = '3' .and. empty(TRDD->RDD_CODAVA)  
					TRDD->(dbSkip())
					Loop
				EndIf			
				
				//Calculo do Resultado Obtido 
				nTotAva := Round((TRDD->RDD_RESOBT/TRDD->RDD_PTOMAX) * 100,_nRound)
				
				lTemCons := .f.
				cStatus  := ''

				//Se for Tipo 1-Avaliacao significa que nao encontrou resultado calculado para consenso na RDD
				If TRDD->RDC_TIPOAV = '1' 
				
					//Verifica se tem data de finalizacao
					If empty(TRDD->RDC_DATRET)
					
						cStatus := 'AVNF' //Avalicao Nao Finalizada
						
					Else
				
						//Posiciona a RDC com o registro encontrado na TRDD
						RDC->(dbgoto(TRDD->R_E_C_N_O_)) 
	
						//Verifica se tem aprovador e se esta finalizado pelo mesmo
						If !empty(RDC->RDC_CODAPR)
							If empty(RDC->RDC_DTRETA)
								cStatus := 'APNF' //Aprovador Nao Finalizado
							Else
								cStatus := 'APF' 	//Aprovador Finalizado
							EndIf
						Else
							cStatus := 'AVF' 		//Avaliacao Finalizada
						EndIf
						

						If cStatus $ 'APF/AVF'

							//Verifica na RDC se ha consenso previsto
							cChave := RDC->(RDC_FILIAL+RDC_CODAVA+RDC_CODADO+RDC_CODPRO+RDC_CODDOR+DTOS(RDC_DTIAVA)+RDC_CODNET+RDC_NIVEL)+'3'
							If RDC->(dbseek(cChave))
								if empty(RDC->RDC_DATRET)
									cStatus := 'CNF'  //Consenso Nao Finalizado
								Else
									cStatus := 'CF'	//Consenso Finalizado, porem sem calculo final na RDD							
								EndIf
							EndIf
								
						EndIf

					EndIf
					
				//Tipo 3-Consenso
				Else
					If empty(TRDD->RDC_DATRET)
						cStatus := 'CNF'  //Consenso Nao Finalizado
					Else
						cStatus := 'CC'	//Consenso Finalizado e calculado
					EndIf
					
				EndIf							
					

				//Verifica status para gravar SZE como pendencia
				If cStatus == 'AVNF'
					cPend := '1' 	//Avaliacao nao finalizada
				ElseIf cStatus == 'APNF'
					cPend := '2'	//Pendente com o Aprovador
				ElseIf cStatus == 'CNF'
					cPend := '3'	//Consenso nao finalizado
				ElseIf cStatus == 'CF'
					cPend := '4'	//Consenso finalizado c/calculo pendente
				ElseIf cStatus $ 'APF/AVF/CC' .or. empty(cStatus)
					cPend := '0'	//Finalizado
				Else
					cPend := ''				
				EndIF

				//Alimenta Array aSZE
				aAdd(aSZE,{TRDD->RDC_FILIAL,TRDD->RDC_CODADO, cPolitica, cGrupo, TRDD->RDC_CODAVA, nPerComp,nTotAva,0,0,dDataCalc,cFil,cMat,cDepto,cPend})
				
				//Atualiza chave para verificação 
				cChave := TRDD->RDC_FILIAL + TRDD->RDC_CODAVA + TRDD->RDC_CODADO
				
				TRDD->(dbSkip())
				
			EndDo
			
			If lErro
				aAdd(aLog,"###  ERRO   ###  A avaliação " + TRD6->RD6_CODIGO + " - " + AllTrim(TRD6->RD6_DESC) + " foi processada, porém com erro.")
			Else
				aAdd(aLog,"A avaliação " + TRD6->RD6_CODIGO + " - " + AllTrim(TRD6->RD6_DESC) + " foi processada com sucesso!")
			EndIf
			
			TRD6->(dbSkip())
		
		EndDo
		
		If Len(aSZE) > 0

			//Processa Média Parcial para o ultimo registro de cada Funcionário (Serão totalizados todos os períodos)
			cChave := aSZE[1][1] + aSZE[1][2] //Filial + Codigo RD0
			nValor := 0
			nFator := 0
			
			For x := 1 To Len(aSZE)
				
				If cChave <> aSZE[x][1] + aSZE[x][2]
				
					aSZE[x-1][8] := Round( (nValor / (nFator * 100)) * 100,_nRound) //Media Parcial
					aSZE[x-1][9] := Round(aSZE[x-1][8] * (aSZE[x-1][6]/100),_nRound) //Resultado considerando o Peso
					nValor := 0
					nFator := 0
				
				EndIf
				
				nValor += aSZE[x][7]
				nFator ++
				
				cChave := aSZE[x][1] + aSZE[x][2]
			
			Next x
			
			//Processa último Funcionário
			nLast := Len(aSZE)
			aSZE[nLast][8] := Round( (nValor / (nFator * 100)) * 100,_nRound) //Media Parcial
			aSZE[nLast][9] := Round(aSZE[nLast][8] * (aSZE[nLast][6]/100),_nRound)
			nValor := 0
			nFator := 0
			
			MsAguarde( { || GravaSZE(aSZE) } , "Aguarde", "Gravando Competências...")
			
		EndIf

		//Fecha alias temporários
		If Select("TRD6") > 0 ; TRD6->(dbCloseArea()) ; EndIf
		If Select("TRDD") > 0 ; TRDD->(dbCloseArea()) ; EndIf
		
	EndIf

RestArea(aArea)
	
Return

/*/{Protheus.doc} GeraForm

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Calcula Resultados de Formação Academica

/*/
Static Function GeraForm(nPerForma,aPeriodos,aFunc)

	Local aArea		:= GetArea()
	Local cWhere	:= ""
	Local nMax		:= 100
	Local nPontos	:= 0
	Local cGrupo	:= "03"
	Local cJoinRA1	:= "% AND " + FWJoinFilial( "RA4", "RA1" ) + " %"
	Local aSZE		:= {}
	Local x
	Local cCodRD0	:= ""
	Local cChave	:= ""
	
	/*
	------------------------
	Composição do Array aSZE
	------------------------
	aSZE[x][1]  -> RA4_FILIAL
	aSZE[x][2]  -> RA4_MAT
	aSZE[x][3]  -> cPolitica
	aSZE[x][4]  -> cGrupo
	aSZE[x][5]  -> RA4_CURSO
	aSZE[x][6]  -> nPerForm
	aSZE[x][7]  -> RA1_PONTOS
	aSZE[x][8]  -> nMedParc
	aSZE[x][9]  -> nMedFin
	aSZE[x][10] -> Date()
	*/
	
	//Ao inves de processar Funcionário por Funcionário, pego todos os cursos que tem pontuação e os funcionarios que o fizeram, consultando no aFunc
	If Select("TRA4") > 0 ; TRA4->(dbCloseArea()) ; EndIf
	
	BeginSQL Alias "TRA4"
	
		SELECT SRA.R_E_C_N_O_ as SRARECNO, RA_DEPTO, RA4_FILIAL, RA4_MAT, RA4_CURSO, RA1_PONAPD
		FROM %Table:RA4% RA4 
		INNER JOIN %Table:RA1% RA1 ON
			RA1.RA1_CURSO = RA4.RA4_CURSO %Exp:cJoinRA1%
		INNER JOIN %Table:SRA% SRA ON
			RA_FILIAL = RA4_FILIAL and RA_MAT = RA4_MAT
		INNER JOIN %Table:SZE% SZE ON
			ZE_FILMAT = RA4_FILIAL and ZE_MAT = RA4_MAT and ZE_GRUPO IN ('01','02') and ZE_IDCONS = %Exp:cPolitica%
		WHERE RA4.RA4_FORMAC = '1'
			AND RA4.%NotDel%
			AND RA1.%NotDel%
			AND SRA.%NotDel%
			AND SZE.%NotDel%
			AND RA1.RA1_PONAPD > 0
		Group by SRA.R_E_C_N_O_, RA_DEPTO, RA4_FILIAL, RA4_MAT, RA4_CURSO, RA1_PONAPD
		
	EndSQL
	
	dbSelectArea("TRA4")
	While !TRA4->(Eof())

		//Verifica filtro e despreza funcionario
		If cFiltro <> '3' //Diferente de Ambos
			SRA->(dbgoto(TRA4->SRARECNO))
			cAux := U_fFiltroAva()
			If cFiltro == '1' //Somente Gestores
				If !(cAux $ ("09/10/11/12/13")) 
					TRA4->(dbSkip())
					loop
				EndIf
			Else	//Demais
				If (cAux $ ("09/10/11/12/13")) 
					TRA4->(dbSkip())
					loop
				EndIf
			EndIf										
		EndIf	

		//Busca na RDZ o codigo RD0 com base na Filial e Matricula
		If cChave <> (TRA4->RA4_FILIAL+TRA4->RA4_MAT)
			If !( U_fBuscaRD0(TRA4->RA4_FILIAL,TRA4->RA4_MAT,@cCodRD0) )
				aAdd(aLog,"Código do participante não encontrado para a filial/matrícula " + TRA4->RA4_FILIAL,TRA4->RA4_MAT + " no cadastro de formação acadêmica." )
				lErro := .t.
				TRA4->(dbSkip())
				loop
			EndIf
		EndIf
		If !empty(cRD0) 
			If cRD0 <> cCodRD0
				TRA4->(dbSkip())
				loop
			Else
				cCodRD0 := cRD0
			EndIf
		EndIf
	
		cChave := (TRA4->RA4_FILIAL,TRA4->RA4_MAT)
	
		nPos := aScan(aFunc,{|x| x[1] == cCodRD0 })
		
		If nPos > 0
		
			aAdd(aSZE,{"",cCodRD0,cPolitica,cGrupo,TRA4->RA4_CURSO,nPerForma,TRA4->RA1_PONAPD,0,0,dDataCalc,TRA4->RA4_FILIAL,TRA4->RA4_MAT,TRA4->RA_DEPTO,"0"})
		
		EndIf 
		
		TRA4->(dbSkip())
		
	End
	
	TRA4->(dbCloseArea())
	
	If Len(aSZE) > 0
	
		//Processa Média Parcial para o ultimo registro de cada Funcionário (Serão totalizados todos os períodos)
		cChave := aSZE[1][1] + aSZE[1][2] //Filial + Matricula
		nValor := 0
		nFator := 0
		
		For x := 1 To Len(aSZE)
			
			If cChave <> aSZE[x][1] + aSZE[x][2]
			
				aSZE[x-1][8] := Round(nValor,_nRound) //Media Parcial (Considera a pontuação atingida)
				aSZE[x-1][9] := Round(Iif(nValor > 100,100,nValor) * (aSZE[x-1][6]/100),_nRound) //Resultado considerando o Peso (Considera Teto de 100 pontos)
				nValor := 0
				//nFator := 0
			
			EndIf
			
			nValor += aSZE[x][7]
			//nFator ++
			
			cChave := aSZE[x][1] + aSZE[x][2]
		
		Next x
		
		//Processa último Funcionário
		nLast := Len(aSZE)
		aSZE[nLast][8] := Round(nValor,_nRound) //Media Parcial (Considera a pontuação atingida)
		aSZE[nLast][9] := Round(Iif(nValor > 100,100,nValor) * (aSZE[nLast][6]/100),_nRound) //Resultado considerando o Peso (Considera Teto de 100 pontos)
		nValor := 0
		nFator := 0
		
		MsAguarde( { || GravaSZE(aSZE) } , "Aguarde", "Gravando Formação Acadêmica...")
	
	EndIf

	RestArea(aArea)

Return

/*/{Protheus.doc} GeraCons

@type function
@author Jorge Heitor
@since 06/04/2016
@version 1.0
@description Calcula Média Final Consolidada (Com base nos dados da tabela SZE que forem contemplados pela execução da rotina)

/*/
Static Function GeraCons()

	Local aArea		:= GetArea()
	Local cGrupo	:= "99"
	Local cKey		:= "000000"
	Local aSZE		:= {}
	
	SZE->(dbsetorder(1))
	
	/*
	------------------------
	Composição do Array aSZE
	------------------------
	aSZE[x][1]  -> ZE_FILIAL
	aSZE[x][2]  -> cCdoRD0
	aSZE[x][3]  -> cPolitica
	aSZE[x][4]  -> cGrupo
	aSZE[x][5]  -> cKey
	aSZE[x][6]  -> nPerForm
	aSZE[x][7]  -> RA1_PONTOS
	aSZE[x][8]  -> nMedParc
	aSZE[x][9]  -> nMedFin
	aSZE[x][10] -> Date()
	aSZE[x][11] -> cFil
	aSZE[x][12] -> cMat
	aSZE[x][13] -> cDepto
	*/
	
	cWhere := " ZE_IDCONS = '" + cPolitica + "' "
	If !empty(cRD0)
		cWhere += " AND ZE_CODRD0 = '" + cRD0 + "' "
	EndIf
	cWhere := "%" + cWhere + "%" 
	
	If Select("TSZE") > 0 ; TSZE->(dbCloseArea()) ; EndIf
	
	BeginSQL Alias "TSZE"
		
		SELECT ZE_FILIAL, ZE_CODRD0, RA_DEPTO, ZE_FILMAT, ZE_MAT, ZE_IDCONS, SUM(ZE_MEDTOT) MEDIA
		FROM %Table:SZE% SZE
		INNER JOIN %Table:SRA% SRA ON RA_FILIAL = ZE_FILMAT and RA_MAT = ZE_MAT
		WHERE %Exp:cWhere%
		AND ZE_GRUPO IN ('01','02','03')
		AND SZE.%NotDel%
		AND SRA.%NotDel%
		GROUP BY ZE_FILIAL,ZE_CODRD0,RA_DEPTO,ZE_FILMAT,ZE_MAT,ZE_IDCONS
		
	EndSQL
	
	dbSelectArea("TSZE")
	While !TSZE->(Eof())
	
		//Verifica se algum grupo possui pendencia
		cPend := '0'
		SZE->(dbseek(TSZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS)))
		While SZE->(!eof()) .and. SZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS) == TSZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS)
			If SZE->ZE_PENDENC <> '0'
				If val(SZE->ZE_PENDENC) > val(cPend)
					cPend := SZE->ZE_PENDENC
				EndIf
			EndIf
			SZE->(dbskip())
		EndDo
	
		aAdd(aSZE,{'',TSZE->ZE_CODRD0, cPolitica, cGrupo, cKey, 0, 0, 0, Round(TSZE->MEDIA,_nRound), dDataCalc,TSZE->ZE_FILMAT,TSZE->ZE_MAT,TSZE->RA_DEPTO,cPend})
		
		TSZE->(dbskip())
	End
	
	MsAguarde( { || GravaSZE(aSZE) } , "Aguarde", "Gravando Cálculo Consolidado...")
	
	RestArea(aArea)

Return

/*/{Protheus.doc} GravaSZE

@type function
@author Jorge Heitor
@since 14/04/2016
@version 1.0
@description Grava Array gerado pelas Funções na tabela SZE

/*/
Static Function GravaSZE(aSZE)

	Local aArea		:= GetArea()
	Local x
	
	dbSelectArea("SZE")
	
	For x := 1 To Len(aSZE)
	
		If empty(cRD0) .or. aSZE[x][2] == cRD0
	
			RecLock("SZE",.T.)
			
				SZE->ZE_FILIAL	:= aSZE[x][1]
				SZE->ZE_CODRD0	:= aSZE[x][2]
				SZE->ZE_IDCONS	:= aSZE[x][3]
				SZE->ZE_GRUPO	:= aSZE[x][4]
				SZE->ZE_KEY		:= aSZE[x][5]
				SZE->ZE_PESO	:= aSZE[x][6]
				SZE->ZE_RESOBT	:= aSZE[x][7]
				SZE->ZE_MEDPARC	:= aSZE[x][8]
				SZE->ZE_MEDTOT	:= aSZE[x][9]
				SZE->ZE_DTCALC	:= aSZE[x][10]
				SZE->ZE_FILMAT	:= aSZE[x][11]
				SZE->ZE_MAT		:= aSZE[x][12]
				SZE->ZE_DEPTO	:= aSZE[x][13]
				SZE->ZE_PENDENC := aSZE[x][14]
				
			MsUnlock()

		EndIF
	
	Next x
	
	RestArea(aArea)
	
Return

//Valida Parâmetros de processamento

User Function APD005V(cPolitica)

	Local lRet := .T.
	Local aArea := GetArea()
	Local cMsg  := ''
	Local cStatus := Posicione("SZC",1,FWxFilial("SZC") + cPolitica,"ZC_STATUS")
	
	If  cStatus $ "2/3"
	
		lRet := .F.
		cMsg := "A Politica de Consolidação informada encontra-se "+If(cStatus=='2','cancelada','fechada')+"." 
		
	EndIf
	
	If !Empty(cMsg) .And. !lRet
	
		help("APD005V",,"ZC_STATUS","Política",cMsg,1,0,,,,,) //"Política"
		
	EndIf
	
	RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} _GravaLog

@type function
@author Jorge Heitor
@since 08/04/2016
@version 1.0
@description Apresenta LOG (Resumo) e permite visualizar Log Completo dos dados processados

/*/
Static Function _GravaLog(aLog,aFunc)

	Local aSays			:= {}
	Local aButtons		:= {}
	Local nOpca
	Local oDlg1
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aGDCoord		:= {}
	Local aArea			:= GetArea()
	Local cLog			:= ""
	Local cArq			:= "\SYSTEM\" + CriaTrab( , .F. ) + ".txt"
	Local nHandle		:= fCreate(cArq)
	Local x
	
	Private cCadastro 	:= OemToAnsi("Processamento Concluído") //"Processamento Concluído"
	
	If nHandle < 0
		
		MsgStop("_GravaLog - Não foi possivel criar o arquivo de Log.") //"_GravaLog - Não foi possivel criar o arquivo de Log."
	
	EndIf
	
	cLog := "Processo concluído! Clique em 'Confirmar' para mais detalhes." + _ENTER //"Processo concluído! Clique em 'Confirmar' para mais detalhes."
	cLog += _ENTER
	
	For x := 1 To Len(aLog)
	
		cLog += aLog[x] + _ENTER
		FWrite(nHandle,aLog[x]+_ENTER)
	
	Next x

	FWrite(nHandle,_ENTER)
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,"LISTA DE FUNCIONARIOS PROCESSADOS" + _ENTER) //"LISTA DE FUNCIONARIOS PROCESSADOS"
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,_ENTER)
	FWrite(nHandle,PadR("Codigo",10) + PadR("Filial",10) + PadR("Matrícula",10) + PadR("Nome",35) + _ENTER) //"Codigo" | "Filial" | "Matrícula" | "Nome" 
	FWrite(nHandle,Replicate("-",9) + " " + Replicate("-",9) + " " + Replicate("-",9) + " " + Replicate("-",34) + " " + _ENTER)
	
	For x := 1 To Len(aFunc)
	
		FWrite(nHandle,PadR(aFunc[x][1],10) + PadR(aFunc[x][2],10) + PadR(aFunc[x][3],10) + PadR(Posicione("SRA",1,aFunc[x][2]+aFunc[x][3],"RA_NOME"),35) + _ENTER)
	
	Next x
	
	FClose(nHandle)

	/*
		Monta dimensões dos objetos
	*/
	aAdvSize		:= MsAdvSize()
	aAdvSize[5]		:= (aAdvSize[5]/100) * 35	//horizontal
	aAdvSize[6]		:= (aAdvSize[6]/100) * 55	//Vertical
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	aGdCoord		:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*25), (((aObjSize[1,4])/100)*29.6) }	//1,3 Vertical /1,4 Horizontal
	
	SetaPilha()
	
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg1 TITLE cCadastro FROM  aAdvSize[7],20 TO aAdvSize[6]-50,600  OF oMainWnd PIXEL
	
		@ aGdCoord[1]+7,aGdCoord[2]	GROUP oGroup1 TO (aGdCoord[3]*1.9)+5,aGdCoord[4]+5  LABEL "" OF oDlg1 PIXEL
		oGroup1:oFont:=oFont
		@ aGdCoord[1]+11,aGdCoord[2]+4 Get oGet Var cLog Memo Size 273,173 OF oGroup1 Pixel
		
		aButtons	:=	{}
			
	ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar( oDlg1 , { || nOpca 	:= 1, oDlg1:End() } , { || nOpca 	:= 0 , oDlg1:End() } , NIL , aButtons )
	
	SetaPilha()
	
	/*
		Variaveis utilizadas para Parâmetros
	*/
	If nOpca == 1
		AbreLog(cArq)
	EndIf
	
	RestArea(aArea)
	
Return Nil

/*/{Protheus.doc} AbreLog

@type function
@author Jorge Heitor
@since 07/04/2016
@version 1.0
@description Validações específicas para constatar se o período informado no parâmetro pode ser utilizado para o Cálculo de Metas

/*/
Static Function AbreLog(cArquivo)

	Local cNomeArq	:= Iif(SubStr(cArquivo,1,1) $ "\", SubsTr(cArquivo, RAT("\",cArquivo) ,Len(cArquivo)),cArquivo)
	Local cDirLocal	:= GetTempPath()

	If CpyS2T(cArquivo,cDirLocal)
	
		ShellExecute("Open",cDirLocal + cNomeArq, "", "C:\", 3 )
		
	Else
	
		MsgStop("Falha na cópia do arquivo " + cNomeArq + " para visualização. O arquivo estará disponível na pasta '\SYSTEM\' do Servidor.") // "Falha na cópia do arquivo " | " para visualização. O arquivo estará disponível na pasta '\SYSTEM\' do Servidor."
	
	Endif

Return Nil



/*/{Protheus.doc} fBuscaMat

@type function
@author 
@since 07/04/2016
@version 1.0
@description Busca Filial e Matricula de registro ativo no SRA a partir do codigo da RD0

/*/
User Function fBuscaMat(cCodAdo,cFil,cMat,cDepto)

Local aArea:= GetArea()
Local aRDZ := RDZ->(GetArea())
Local aSRA := SRA->(GetArea())
Local lAchou := .f.
Local dDemissa := ctod("//")

SRA->(dbsetorder(1))
RDZ->(dbsetorder(2))

If RDZ->(dbseek(xFilial("RDZ")+cCodAdo+cEmpAnt))
	While RDZ->(!eof()) .and. RDZ->RDZ_CODRD0 == cCodAdo .and. RDZ->RDZ_EMPENT == cEmpAnt
		If SRA->(dbseek(RDZ->RDZ_CODENT))
			If empty(SRA->RA_DEMISSA)
				cFil 	:= SRA->RA_FILIAL
				cMat 	:= SRA->RA_MAT
				cDepto 	:= SRA->RA_DEPTO
				lAchou 	:= .t.
				Exit
			ElseIf SRA->RA_DEMISSA > dDemissa
				cFil 	:= SRA->RA_FILIAL
				cMat 	:= SRA->RA_MAT
				cDepto 	:= SRA->RA_DEPTO
				lAchou 	:= .t.
			EndIf
		EndIf
		RDZ->(dbskip())
	EndDo
EndIf

RestArea(aRDZ)
RestArea(aSRA)
RestArea(aArea)

Return(lAchou)


/*/{Protheus.doc} fBuscaRD0

@type function
@author 
@since 07/04/2016
@version 1.0
@description Busca o código RD0 a partir da Filial e Matricula passados como parametro

/*/
User Function fBuscaRD0(cFil,cMat,cCodRD0)

Local aArea:= GetArea()
Local aRDZ := RDZ->(GetArea())
Local lAchou := .f.

RDZ->(dbsetorder(1))

If RDZ->(dbseek(xFilial("RDZ")+cEmpAnt+cFil+'SRA'+cFil+cMat))
	cCodRD0 := RDZ->RDZ_CODRD0
	lAchou := .t.
EndIf

RestArea(aRDZ)
RestArea(aArea)

Return(lAchou)

				