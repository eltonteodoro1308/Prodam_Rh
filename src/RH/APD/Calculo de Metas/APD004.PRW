#Include "Totvs.ch"
#Include "FileIO.ch"
#Include "APD004.CH"

#DEFINE _ENTER chr(13)+chr(10)

/*/{Protheus.doc} APD004
Rotina de processamento dos c�lculos de Resultados de Metas
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 06/04/2016
/*/
User Function APD004()

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

	Private cCadastro 	:= OemToAnsi(STR0001)	//"C�lculo de Metas"
	Private nSavRec		:= 0

	Pergunte("APD004",.F.)

	/*
		Monta dimens�es dos objetos
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
		@ aGdCoord[1]+20,aGdCoord[2]+4 Say OemToAnsi( STR0002 ) Size 290,07 Pixel Font oFont Color CLR_BLUE
		@ aGdCoord[1]+32,aGdCoord[2]+4 Say OemToAnsi( STR0003 ) Size 290,07 Pixel Font oFont Color CLR_BLUE

		aButtons	:=	{;
						{STR0029  ,{ || Pergunte("APD004",.T. ) },STR0015,STR0015};
						}

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , { || nOpca 	:= 1, oDlg:End() } , { || nOpca 	:= 0 , oDlg:End() } , NIL , aButtons )

	SetaPilha()

	/*
		Variaveis utilizadas para Par�metros
	*/
	If nOpca == 1
		Processa({|lEnd| APD004Proc(),OemToAnsi(STR0001)}) //"C�lculo de Metas"
	EndIf

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} APD004Proc
Processamento dos c�lculos
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 06/04/2016
/*/
Static Function APD004Proc()

	Local nx
	Local cPeriodo		:= mv_par01
	Local cMatriculas	:= mv_par02 //Grava para Log
	Local lReprocessa	:= (mv_par03 == 1)
	Local aProcessados	:= {}
	Local aZerados		:= {}
	Local aLog			:= {}
	Local nResult		:= 0
	Local nRound		:= GetMV("MV_APDARRM")
	Local aMaxPot		:= {}
	Local nMaxPot		:= 0
	Local nPos			:= 0
	Local dDtCalc		:= Date()
	Local lCalc			:= .T. //Variavel de Controle
	Local nZerados		:= 0
	Local nProcessados	:= 0
	Local cSeq			:= ""
	Local nPosZera		:= 0
	Local nPosProc		:= 0

	//Atualiza par�metros com Range para transformar em filtro de query
	MakeSqlExpr("APD004")

	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,STR0022 + DtoC(Date()) + " / " + Time()) //"Data/Hora de In�cio do Processamento: "
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,"-------------")
	aAdd(aLog,STR0023) //"Par�metros: "
	aAdd(aLog,"-------------")
	aAdd(aLog,STR0024 + cPeriodo + " - " + Posicione("RDU",1,xFilial("RDU")+cPeriodo,"RDU_DESC")) //"Per�odo: " | |
	aAdd(aLog,STR0025 + cMatriculas) //"Matr�cula(s): "
	aAdd(aLog,STR0026 + Iif(lReprocessa,STR0027,STR0028)) //"Reprocessa?: " / "Sim" / "N�o"
	aAdd(aLog," ")

	/*
	-----------------------------------------------------------------
	Composi��o de Arrays Auxiliares
	-----------------------------------------------------------------
	*/

		/*
		----------------------------
		Composi��o do Array aMaxPot:
		----------------------------
		aMaxPot[x][1] -> Filial
		aMaxPot[x][2] -> Matricula
		aMaxPot[x][3] -> Periodo
		aMaxPot[x][4] -> Maximo Potencial
		aMaxPot[x][5] -> Nome do Funcion�rio
		*/

		/*
		---------------------------------
		Composi��o do Array aProcessados:
		---------------------------------
		aProcessados[x][1] -> Filial
		aProcessados[x][2] -> Matricula
		aProcessados[x][3] -> Nome
		aProcessados[x][4] -> Sequencia(s)
		*/

		/*
		-----------------------------
		Composi��o do Array aZerados:
		-----------------------------
		aZerados[x][1] -> Filial
		aZerados[x][2] -> Matricula
		aZerados[x][3] -> Nome
		aZerados[x][4] -> Sequencia(s)
		*/


	/*
	-----------------------------------------------------------------
	Busca Maximo potencial para todas as metas cadastradas no per�odo
	-----------------------------------------------------------------
	*/

	//Fecha Alias Tempor�rio caso exista
	If Select("PSZ0") > 0 ; PSZ0->(dbCloseArea()) ; EndIf

	//Monta Filtros SQL com base nos par�metros
	cWhere := " SZ0.D_E_L_E_T_ = '' AND SZ0.Z0_STATUS <> '2'" //Status diferente de "Cancelado"
	cWhere += " AND SZ0.Z0_CODPER = '" + cPeriodo + "' "
	//Filtra deletados da SRA, pois existe relacionamento
	cWhere += " AND SRA.D_E_L_E_T_ = '' "


	//Se tiver preenchido o range de matriculas, filtra pela filial corrente e pelo range de Matriculas
	If !Empty(mv_par02)

		cWhere += " AND " + mv_par02 //Strtran(StrTran(mv_par02,'BETWEEN','SZ0.Z0_MAT BETWEEN'),'IN', 'SZ0.Z0_MAT IN')
		cWhere += " AND SZ0.Z0_FILIAL = '" + FWxFilial("SZ0") + "' "

	EndIf

	cWhere := "%" + cWhere + "%"

	BeginSQL Alias "PSZ0"

		SELECT Z0_FILIAL, Z0_MAT, Z0_CODPER, (SUM(Z0_PESO) * 100) AS MAXPOT, SRA.RA_NOME
		FROM %Table:SZ0% SZ0
		INNER JOIN %Table:SRA% SRA ON
			SRA.RA_FILIAL = SZ0.Z0_FILIAL
			AND SRA.RA_MAT = SZ0.Z0_MAT
		WHERE %exp:cWhere%
		GROUP BY Z0_FILIAL, Z0_MAT, Z0_CODPER, SRA.RA_NOME

	EndSql

	dbSelectArea("PSZ0")
	While !PSZ0->(Eof())

		aAdd(aMaxPot,{PSZ0->Z0_FILIAL, PSZ0->Z0_MAT, PSZ0->Z0_CODPER, PSZ0->MAXPOT, PSZ0->RA_NOME})
		PSZ0->(dbSkip())

	End

	PSZ0->(dbCloseArea())

	cWhere := ""

	/*
	----------------------------------
	Busca dados para c�lculo das metas
	----------------------------------
	*/

	//Fecha Alias Tempor�rio caso exista
	If Select("TSZ0") > 0 ; TSZ0->(dbCloseArea()) ; EndIf

	//Monta Filtros SQL com base nos par�metros
	cWhere := " SZ0.D_E_L_E_T_ = '' AND SZ0.Z0_STATUS IN " + Iif(lReprocessa," ('1','3') ", " ('1') ")
	cWhere += " AND SZ0.Z0_CODPER = '" + cPeriodo + "' "

	//Se tiver preenchido o range de matriculas, filtra pela filial corrente e pelo range de Matriculas
	If !Empty(mv_par02)

		cWhere += " AND " + mv_par02 //Strtran(StrTran(mv_par02,'BETWEEN','SZ0.Z0_MAT BETWEEN'),'IN', 'SZ0.Z0_MAT IN')
		cWhere += " AND SZ0.Z0_FILIAL = '" + FWxFilial("SZ0") + "' "

	EndIf

	cWhere := "%" + cWhere + "%"

	//Inicia Sele��o de dados para c�lculo
	BeginSQL Alias "TSZ0"

		SELECT SZ0.R_E_C_N_O_ AS REG, Z0_FILIAL, Z0_MAT, Z0_CODPER,Z0_SEQ, Z0_META, Z0_PESO,Z0_PERC, Z0_STATUS, Z0_RESULT, Z0_DTCALC
		FROM %Table:SZ0% SZ0
		WHERE %exp:cWhere%

	EndSQL


	/*
	------------------------------
	Inicia processamento dos dados
	------------------------------
	*/
	dbSelectArea("TSZ0")
	While !TSZ0->(Eof())

		//Obtem informa��es iniciais para efetuar o c�lculo
		nPos := aScan(aMaxPot,{|x| x[1] == TSZ0->Z0_FILIAL .And. x[2] == TSZ0->Z0_MAT})

		//Se o % Realizado da Meta for 0
		If TSZ0->Z0_PERC == 0

			//Acumula Dados Zerados para compor o Log de Processamento
			nZerados++
			nPosZera := aScan(aZerados,{|x| x[1] == TSZ0->Z0_FILIAL .And. x[2] == TSZ0->Z0_MAT})

			If nPosZera == 0

				aAdd(aZerados,{TSZ0->Z0_FILIAL, TSZ0->Z0_MAT, aMaxPot[nPos][5], TSZ0->Z0_SEQ})

			Else

				aZerados[nPosZera][4] += "/" + TSZ0->Z0_SEQ

			EndIf

			lCalc := .F.

		Else

			lCalc := .T.

		EndIf

		If lCalc

			//Regra: ((Peso * Percentual de Atingimento) / Potencial Maximo de Atingimento) * 100
			nResult := Round((Round((TSZ0->Z0_PESO * TSZ0->Z0_PERC),nRound) / aMaxPot[nPos][4]) * 100,nRound)
			cSeq := TSZ0->Z0_SEQ

		Else

			nResult := 0
			cSeq := ""

		EndIf

		dbSelectArea("SZ0")
		dbGoTo(TSZ0->REG)
		RecLock("SZ0",.F.)

			SZ0->Z0_RESULT := nResult
			SZ0->Z0_DTCALC := dDtCalc
			SZ0->Z0_STATUS := "3" //Calculado

		SZ0->( MsUnlock() )

		//Processados
		nProcessados++

		//Log de Processados
		nPosProc := aScan(aProcessados,{|x| x[1] == TSZ0->Z0_FILIAL .And. x[2] == TSZ0->Z0_MAT})

		If nPosProc == 0

			aAdd(aProcessados,{TSZ0->Z0_FILIAL, TSZ0->Z0_MAT, aMaxPot[nPos][5], cSeq})

		Else

			aProcessados[nPosProc][4] += Iif(!Empty(cSeq), "/" + cSeq, cSeq)

		EndIf

		dbSelectArea("TSZ0")
		TSZ0->(dbSkip(1))

	End

	TSZ0->(dbCloseArea())

	aAdd(aLog,"-------------")
	aAdd(aLog,STR0018) //"Resumo: "
	aAdd(aLog,"-------------")
	aAdd(aLog,STR0019 + AllTrim(Str(nProcessados))) //"Registros Processados: "
	aAdd(aLog,STR0020 + AllTrim(Str(nZerados))) //"Resultados Zerados: "
	aAdd(aLog," ")
	aAdd(aLog,"----------------------------------------------------------------------")
	aAdd(aLog,STR0021 + DtoC(Date()) + " / " + Time()) //"Data/Hora de T�rmino do Processamento: "
	aAdd(aLog,"----------------------------------------------------------------------")

	_GravaLog(aLog,aProcessados,aZerados)

Return Nil

/*/{Protheus.doc} _GravaLog
Apresenta LOG (Resumo) e permite visualizar Log Completo dos dados processados
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 08/04/2016
@param aLog, array, aLog
@param aProcessados, array, aProcessados
@param aZerados, array, aZerados
/*/
Static Function _GravaLog(aLog,aProcessados,aZerados)

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

	Private cCadastro 	:= OemToAnsi(STR0004) //"Processamento Conclu�do"

	If nHandle < 0

		MsgStop(STR0005) //"_GravaLog - N�o foi possivel criar o arquivo de Log."

	EndIf

	cLog := STR0017 + _ENTER //"Processo conclu�do! Clique em 'Confirmar' para mais detalhes."
	cLog += _ENTER

	For x := 1 To Len(aLog)

		cLog += aLog[x] + _ENTER
		FWrite(nHandle,aLog[x]+_ENTER)

	Next x

	FWrite(nHandle,_ENTER)
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,STR0010 + _ENTER) //"LISTA DE REGISTROS PROCESSADOS COM SUCESSO"
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,_ENTER)
	FWrite(nHandle,PadR(STR0012,10) + PadR(STR0013,10) + PadR(STR0014,35) + PadR(STR0016,60) + _ENTER) //"Filial" | "Matr�cula" | "Nome" | "Meta(s)"
	FWrite(nHandle,Replicate("-",9) + " " + Replicate("-",9) + " " + Replicate("-",34) + " " + Replicate("-",59) + " " + _ENTER)

	For x := 1 To Len(aProcessados)

		FWrite(nHandle,PadR(aProcessados[x][1],10) + PadR(aProcessados[x][2],10) + PadR(aProcessados[x][3],35) + PadR(aProcessados[x][4],60) + _ENTER)

	Next x

	FWrite(nHandle,_ENTER)
	FWrite(nHandle,_ENTER)
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,STR0011 + _ENTER)
	FWrite(nHandle,Replicate("-",115) + _ENTER)
	FWrite(nHandle,_ENTER)
	FWrite(nHandle,PadR(STR0012,10) + PadR(STR0013,10) + PadR(STR0014,35) + PadR(STR0016,60) + _ENTER) //"Filial" | "Matr�cula" | "Nome" | "Meta(s)"
	FWrite(nHandle,Replicate("-",9) + " " + Replicate("-",9) + " " + Replicate("-",34) + " " + Replicate("-",59) + " " + _ENTER)

	For x := 1 To Len(aZerados)

		FWrite(nHandle,PadR(aZerados[x][1],10) + PadR(aZerados[x][2],10) + PadR(aZerados[x][3],35) + PadR(aZerados[x][4],60) + _ENTER)

	Next x

	FClose(nHandle)

	/*
		Monta dimens�es dos objetos
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
		Variaveis utilizadas para Par�metros
	*/
	If nOpca == 1
		AbreLog(cArq)
	EndIf

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} AbreLog
Valida��es espec�ficas para constatar se o per�odo informado no par�metro pode ser utilizado para o C�lculo de Metas
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 07/04/2016
@param cArquivo, characters, cArquivo
/*/
Static Function AbreLog(cArquivo)

	Local cNomeArq	:= Iif(SubStr(cArquivo,1,1) $ "\", SubsTr(cArquivo, RAT("\",cArquivo) ,Len(cArquivo)),cArquivo)
	Local cDirLocal	:= GetTempPath()

	If CpyS2T(cArquivo,cDirLocal)

		ShellExecute("Open",cDirLocal + cNomeArq, "", "C:\", 3 )

	Else

		MsgStop(STR0008 + cNomeArq + STR0009) // "Falha na c�pia do arquivo " | " para visualiza��o. O arquivo estar� dispon�vel na pasta '\SYSTEM\' do Servidor."

	Endif

Return Nil

/*/{Protheus.doc} APD004P
Valida��es espec�ficas para constatar se o per�odo informado no par�metro pode ser utilizado para o C�lculo de Metas
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 07/04/2016
@param cPeriodo, characters, cPeriodo
@return logical, lRet
/*/
User Function APD004P(cPeriodo)

	Local lRet	:= .T.
	Local cMsg	:= ""
	Local aArea	:= GetArea()

	dbSelectArea("RDU")
	RDU->(dbSetOrder(1))
	dbGoTop()
	RDU->(dbSeek(xFilial("RDU")+cPeriodo))

	If Found()

		If RDU->RDU_FIMRES >= Date()

			lRet := .F.
			cMsg := STR0006 //"O Per�odo informado ainda encontra-se aberto para Manuten��o dos Resultados das Metas. (Campo RDU_FIMRES)"

		Endif

	EndIf

	If !Empty(cMsg) .And. !lRet

		help("APD004P",   ,"RDU_FIMRES"      ,STR0007, cMsg,1,0,,,,,) //"Per�odo"

	EndIf

	RestArea(aArea)

Return lRet