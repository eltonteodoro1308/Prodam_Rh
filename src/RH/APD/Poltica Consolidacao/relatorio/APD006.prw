#INCLUDE "TOTVS.CH"
#INCLUDE "REPORT.CH"

/*/{Protheus.doc} APD006
Relatório de Resultados de Política de Consolidação
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
/*/
User Function APD006()

Local oReport	:= Nil
Local lTReport	:= TRepInUse()

Private cPerg	:= "APD006"
Private aSelFil	:= {}
Private cPicture:= "@E 999." + Replicate('9',GetMV("MV_APDARRM",,4))


lRet	:= Pergunte( cPerg , .T. )

If lRet
	oReport:= ReportDef()
	oReport:PrintDialog()
EndIf

Return()

/*/{Protheus.doc} ReportDef
Função de definição do layout e formato do relatório
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@return object, Objeto criado com o formato do relatório
/*/
Static Function ReportDef()

Local oReport		:= Nil
Local oDeptos		:= Nil
Local oAvaliacoes	:= Nil
Local oNoDptoAval	:= Nil

/*
 * Chamada do pergunte com os parâmetros para definir o comportamento e filtros
 * do relatório
 */
Pergunte(cPerg,.F.)

/*
 * Definição padrão do relatório TReport
 */
oReport	:= TReport():New('APD006',"Resultados de Política de Consolidação" , 'APD006',{|oReport|PrintReport(oReport,cPerg)},)
oReport:SetLandScape()

/*
 * Desabilita o botão de parâmetros de customizações do relatório TReport
 */
oReport:ParamReadOnly()

//Seção Cabeçalho do Processo
oDeptos := TRSection():New(oReport,"Departamentos",{"SZC"})
//oDeptos:SetTitle(UPPER("Departamentos"))
oDeptos:SetHeaderSection(.T.)

TRCell():New( oDeptos, "RD4_DESC"		, "RD4", /*X3Titulo*/RetTitle("RD4_DESC"), /*Picture*/, /*Tamanho*/,/*lPixel*/,,/*nALign*/ "CENTER",;
			/*lLineBreak*/,/*cHeaderAlign*/"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )//Desc Departamento

//Seção - Com quebra de departamento.
oAvaliacoes := TRSection():New(oReport,"Com quebra Depto",{"SZE"})
TRCell():New( oAvaliacoes, "ZE_MAT"    , "SZE", /*X3Titulo*/"Matric."   , /*Picture*/, TamSX3("ZE_MAT")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "ZE_CODRD0" , "SZE", /*X3Titulo*/"Partic."		, /*Picture*/, TamSX3("ZE_CODRD0")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "RD0_NOME"  , "RD0", /*X3Titulo*/"Nome Participante"	 , /*Picture*/, TamSX3("RD0_NOME")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "ZE_MEDTOT" , "SZE", /*X3Titulo*/"Result.Final"	 , cPicture /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "ZE_PENDENC", "SZE", /*X3Titulo*/"Status"			 , /*Picture*/, 28/*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "GRUPO_01"  , "SZE", /*X3Titulo*/"Metas"				 ,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "GRUPO_02"  , "SZE", /*X3Titulo*/"Compet."		 ,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "GRUPO_03"  , "SZE", /*X3Titulo*/"Formação"			 ,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "Q3_DESCSUM", "SQ3", /*X3Titulo*/"Cargo"				 , /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oAvaliacoes, "RJ_DESC"   , "SRJ", /*X3Titulo*/"Especialização"	 , /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )

//Seção - Sem quebra de departamento.
oNoDptoAval := TRSection():New(oReport,"Sem quebra Depto",{"SZE"})
TRCell():New( oNoDptoAval, "RD4_DESC"	, "RD4", /*X3Titulo*/"Descrição"		, /*Picture*/, /*Tamanho*/,/*lPixel*/,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )//Desc Departamento
TRCell():New( oNoDptoAval, "RESPONSAVEL", "RD0", /*X3Titulo*/"Responsável"		, /*Picture*/, TamSX3("RD0_NOME")[1],/*lPixel*/,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )//Responsavel
TRCell():New( oNoDptoAval, "ZE_MAT"     , "SZE", /*X3Titulo*/"Matric."     			, /*Picture*/, TamSX3("ZE_MAT")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "ZE_CODRD0"	, "SZE", /*X3Titulo*/"Partic."				, /*Picture*/, TamSX3("ZE_CODRD0")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "RD0_NOME" 	, "RD0", /*X3Titulo*/"Nome Participante"	, /*Picture*/, TamSX3("RD0_NOME")[1],/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "ZE_MEDTOT"	, "SZE", /*X3Titulo*/"Result.Final"		, cPicture /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "ZE_PENDENC" , "SZE", /*X3Titulo*/"Status"			    , /*Picture*/, 28/*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "GRUPO_01"	, "SZE", /*X3Titulo*/"Metas"				,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "GRUPO_02"	, "SZE", /*X3Titulo*/"Compet."			,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "GRUPO_03"	, "SZE", /*X3Titulo*/"Formação"				,  /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "RIGHT",/*lLineBreak*/,/*cHeaderAlign*/"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "Q3_DESCSUM" , "SQ3", /*X3Titulo*/"Cargo"				, /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )
TRCell():New( oNoDptoAval, "RJ_DESC"    , "SRJ", /*X3Titulo*/"Especialização"		, /*Picture*/, /*TamSX3("")[1]*/,/*lPixel*/.F.,,/*nALign*/ "LEFT",/*lLineBreak*/,/*cHeaderAlign*/"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T. )

Return oReport

/*/{Protheus.doc} PrintReport
Função para busca das informações que serão impressas no relatório
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@param oReport, object, Objeto para manipulação das seções, atributos e dados do relatório.
@param cPerg, characters, Identificação do Grupo de Perguntas do relatório
/*/
Static Function PrintReport(oReport,cPerg)

Local oDeptos		:= oReport:Section(1)
Local oAvaliacoes	:= oReport:Section(2)
Local oNoDptoAval	:= oReport:Section(3)
Local nX			:= 0
Local cPolitica		:= MV_PAR01
Local nQuebra		:= MV_PAR02
Local cDepto		:= ""
Local cQuery		:= ""
Local lCtrlIni		:= .T.
Local aStatus		:= {}

Private cVisao 		:= ''
Private cAliasQry	:= GetNextAlias()

aadd(aStatus,{"0","Finalizado"})
aadd(aStatus,{"1","Avaliação não finalizada"})
aadd(aStatus,{"2","Pendente com o Aprovador"})
aadd(aStatus,{"3","Consenso não finalizado"})
aadd(aStatus,{"4","Cons.finalizado c/cálc.pend."})


SRA->(dbsetorder(1))
SZE->(dbsetorder(1))
RDE->(dbsetorder(8))
RD4->(dbsetorder(1))

//Busca a visao na politica
cAuxAlias := "QAUX"
BeginSQL ALIAS cAuxAlias
	SELECT max(RDU_XVISAO) AS VISAO
	FROM %table:RDU% RDU
	INNER JOIN %table:SZD% SZD ON RDU_CODIGO = ZD_CODPER AND
	                              ZD_CODIGO = %exp:cPolitica% AND
	                              SZD.%notDel%
	WHERE
	RDU.%notDel%
EndSQL

If (cAuxAlias)->( !Eof() )
	cVisao := (cAuxAlias)->VISAO
Else
	cVisao := Posicione("AI8",4,xFilial("AI8")+"000006"+"W_PWSX700.APW","AI8_VISAPV")
Endif
(cAuxAlias)->( dbCloseArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Nome da Secao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SkipLine()
oReport:PrintText("Consolidado: " + cPolitica + " - " + Posicione("SZC",1,xFilial("SZC")+cPolitica,"ZC_DESC") )

cQuery += "SELECT SZE.ZE_MAT, SZE.ZE_CODRD0, SZE.ZE_MEDTOT, SZE.ZE_PENDENC, SZE.ZE_FILMAT, SZE.ZE_MAT, "
cQuery += "SZE.ZE_DTCALC, SZE.ZE_FILIAL, SZE.ZE_CODRD0, SZE.ZE_IDCONS, SZE.ZE_GRUPO, "
cQuery += "RDE.RDE_CODPAR, RDE.RDE_ITEVIS, RD4.RD4_DESC, RD4.RD4_ITEM, RD4.RD4_TREE, RD0.RD0_NOME "
cQuery += "FROM "+RetSqlName("SZE")+ " SZE "
cQuery += "LEFT JOIN "+RetSqlName("RD0")+ " RD0 on RD0.RD0_CODIGO =  SZE.ZE_CODRD0  AND RD0.D_E_L_E_T_ = '' "
cQuery += "LEFT JOIN "+RetSqlName("RDE")+ " RDE on RDE_CODVIS = '" + cVisao + "' and RDE_CODPAR = ZE_CODRD0 AND "
cQuery += "    RDE_STATUS = '1' AND RDE.D_E_L_E_T_ = '' "
cQuery += "LEFT JOIN "+RetSqlName("RD4")+ " RD4 on RD4_CODIGO = '" + cVisao + "' and RD4_ITEM = RDE.RDE_ITEVIS AND RDE.D_E_L_E_T_ = '' "
cQuery += "WHERE "
cQuery += "SZE.ZE_IDCONS = '" + cPolitica 		+ "' AND "
cQuery += "SZE.ZE_GRUPO = '99' AND "
cQuery += "SZE.ZE_FILIAL = '" + xFilial("SZE")	+ "' AND "
cQuery += "SZE.D_E_L_E_T_ = '' "

If !empty(MV_PAR03)
	MV_PAR03 := alltrim(MV_PAR03)
	cQuery += "AND SZE.ZE_PENDENC IN ("
	For nX := 1 to len(MV_PAR03)
		If substr(MV_PAR03,nX,1) <> ' '
			cQuery += "'"+substr(MV_PAR03,nX,1)+"',"
		EndIf
	Next nX
	cQuery := left(cQuery,len(cQuery)-1) + ") "
EndIf

cQuery += "ORDER BY "
If MV_PAR02 == 1 //Quebra por departamento.
	cQuery += "RD4.RD4_DESC,ZE_MEDTOT DESC "
Else
	cQuery += "ZE_MEDTOT DESC "
EndIf

//Conout(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .T., .T.)

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter((cAliasQry)->( RecCount() ))

If (cAliasQry)->(!Eof())

	While (cAliasQry)->(!Eof())

		//-- Incrementa a régua da tela de processamento do relatório
		oReport:IncMeter()

		//-- Verifica se o usuário cancelou a impressão do relatorio
		If oReport:Cancel()
			Exit
		EndIf

		//Posiciona SRA
		SRA->(dbseek( (cAliasQry)->(ZE_FILMAT+ZE_MAT) ))

		//Busca Funcao e Cargo no historico (SR7)
		cCodFunc := cCodCarg := cDescFunc := cDescCarg := ''
		fBuscaCarg(stod((cAliasQry)->ZE_DTCALC),@cCodFunc,@cDescFunc,@cCodCarg,@cDescCarg )

		//Busca as notas detalhadas
		aNotas := fBuscaNota()

		If nQuebra == 1 //Quebra por departamento
			If Empty(cDepto)

				cDepto := (cAliasQry)->RD4_DESC
				oDeptos:Init()//Inicializa quebra por departamentos
				oDeptos:Cell("RD4_DESC"):SetValue((cAliasQry)->RD4_DESC)
				oDeptos:PrintLine()
				oDeptos:Finish()

				oAvaliacoes:Init()
				oAvaliacoes:Cell("ZE_MAT"    ):SetValue((cAliasQry)->ZE_MAT)
				oAvaliacoes:Cell("ZE_CODRD0" ):SetValue((cAliasQry)->ZE_CODRD0)
				oAvaliacoes:Cell("RD0_NOME"  ):SetValue((cAliasQry)->RD0_NOME)
				oAvaliacoes:Cell("ZE_MEDTOT" ):SetValue((cAliasQry)->ZE_MEDTOT)
				oAvaliacoes:Cell("ZE_PENDENC"):SetValue(aStatus[aScan(aStatus,{|x| x[1]==(cAliasQry)->ZE_PENDENC}),2])
				oAvaliacoes:Cell("GRUPO_01"  ):SetValue(aNotas[01])
				oAvaliacoes:Cell("GRUPO_02"  ):SetValue(aNotas[02])
				oAvaliacoes:Cell("GRUPO_03"  ):SetValue(aNotas[03])
				oAvaliacoes:Cell("Q3_DESCSUM"):SetValue(cDescCarg)
				oAvaliacoes:Cell("RJ_DESC"   ):SetValue(cDescFunc)
				oAvaliacoes:PrintLine()

			ElseIf cDepto <> (cAliasQry)->RD4_DESC

				oReport:SkipLine()

				cDepto := (cAliasQry)->RD4_DESC
				oDeptos:Init()//Inicializa quebra por departamentos
				oDeptos:Cell("RD4_DESC"):SetValue((cAliasQry)->RD4_DESC)
				oDeptos:PrintLine()
				oDeptos:Finish()

				oAvaliacoes:Finish()
				oAvaliacoes:Init()
				oAvaliacoes:Cell("ZE_MAT"    ):SetValue((cAliasQry)->ZE_MAT)
				oAvaliacoes:Cell("ZE_CODRD0" ):SetValue((cAliasQry)->ZE_CODRD0)
				oAvaliacoes:Cell("RD0_NOME"  ):SetValue((cAliasQry)->RD0_NOME)
				oAvaliacoes:Cell("ZE_MEDTOT" ):SetValue((cAliasQry)->ZE_MEDTOT)
				oAvaliacoes:Cell("ZE_PENDENC"):SetValue(aStatus[aScan(aStatus,{|x| x[1]==(cAliasQry)->ZE_PENDENC}),2])
				oAvaliacoes:Cell("GRUPO_01"  ):SetValue(aNotas[01])
				oAvaliacoes:Cell("GRUPO_02"  ):SetValue(aNotas[02])
				oAvaliacoes:Cell("GRUPO_03"  ):SetValue(aNotas[03])
				oAvaliacoes:Cell("Q3_DESCSUM"):SetValue(cDescCarg)
				oAvaliacoes:Cell("RJ_DESC"   ):SetValue(cDescFunc)
				oAvaliacoes:PrintLine()


			Else

				oAvaliacoes:Cell("ZE_MAT"    ):SetValue((cAliasQry)->ZE_MAT)
				oAvaliacoes:Cell("ZE_CODRD0" ):SetValue((cAliasQry)->ZE_CODRD0)
				oAvaliacoes:Cell("RD0_NOME"  ):SetValue((cAliasQry)->RD0_NOME)
				oAvaliacoes:Cell("ZE_MEDTOT" ):SetValue((cAliasQry)->ZE_MEDTOT)
				oAvaliacoes:Cell("ZE_PENDENC"):SetValue(aStatus[aScan(aStatus,{|x| x[1]==(cAliasQry)->ZE_PENDENC}),2])
				oAvaliacoes:Cell("GRUPO_01"  ):SetValue(aNotas[01])
				oAvaliacoes:Cell("GRUPO_02"  ):SetValue(aNotas[02])
				oAvaliacoes:Cell("GRUPO_03"  ):SetValue(aNotas[03])
				oAvaliacoes:Cell("Q3_DESCSUM"):SetValue(cDescCarg)
				oAvaliacoes:Cell("RJ_DESC"   ):SetValue(cDescFunc)
				oAvaliacoes:PrintLine()

			EndIf
		Else // Não quebra por depto

			If lCtrlIni
				oNoDptoAval:Init() //Ranking Geral sem quebra por departamento.
				lCtrlIni := .F.
			EndIf

			cDepto := (cAliasQry)->RD4_DESC
			oNoDptoAval:Cell("RD4_DESC"):SetValue((cAliasQry)->RD4_DESC)
			oNoDptoAval:Cell("RESPONSAVEL"):SetValue(fBusResp())
			oNoDptoAval:Cell("ZE_MAT"    ):SetValue((cAliasQry)->ZE_MAT)
			oNoDptoAval:Cell("ZE_CODRD0" ):SetValue((cAliasQry)->ZE_CODRD0)
			oNoDptoAval:Cell("RD0_NOME"  ):SetValue((cAliasQry)->RD0_NOME)
			oNoDptoAval:Cell("ZE_MEDTOT" ):SetValue((cAliasQry)->ZE_MEDTOT)
			oNoDptoAval:Cell("ZE_PENDENC"):SetValue(aStatus[aScan(aStatus,{|x| x[1]==(cAliasQry)->ZE_PENDENC}),2])
			oNoDptoAval:Cell("GRUPO_01"  ):SetValue(aNotas[01])
			oNoDptoAval:Cell("GRUPO_02"  ):SetValue(aNotas[02])
			oNoDptoAval:Cell("GRUPO_03"  ):SetValue(aNotas[03])
			oNoDptoAval:Cell("Q3_DESCSUM"):SetValue(cDescCarg)
			oNoDptoAval:Cell("RJ_DESC"   ):SetValue(cDescFunc)

			oNoDptoAval:PrintLine()

		EndIf

		(cAliasQry)->(DbSkip())
	End

EndIf

Return

/*/{Protheus.doc} fBuscaCarg
Carrega Cargo e Funcao conforme historico na SR7
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@param dDataDe, date, descricao
@param cCodFunc, characters, descricao
@param cDescFunc, characters, descricao
@param cCodCarg, characters, descricao
@param cDescCarg, characters, descricao
/*/
Static Function fBuscaCarg(dDataDe,cCodFunc, cDescFunc, cCodCarg, cDescCarg )

Local aSR7 := SR7->( GetArea() )

SR7->(dbsetorder(2)) //Utiliar o indice 2 para tratamento correto da sequencia quando ha registros na mesma data

If SR7->( dbSeek( SRA->(RA_FILIAL + RA_MAT) )  )
	While SR7->(!EOF()) .and. MesAno(SR7->R7_DATA)	<= MesAno(dDataDe) .AND.;
								SR7->R7_FILIAL 	== SRA->RA_FILIAL .AND. ;
								SR7->R7_MAT   	== SRA->RA_MAT
		cCodFunc 	:=	SR7->R7_FUNCAO
		If !empty(SR7->R7_DESCFUN)
			cDescFunc 	:= 	SR7->R7_DESCFUN									 //-- 20 Bytes
		Else
			cDescFunc 	:= 	fDesc( "SRJ", SR7->R7_FUNCAO, "RJ_DESC" )
		EndIf
		cCodCarg	:=  SR7->R7_CARGO
		If !empty(SR7->R7_DESCCAR)
			cDescCarg 	:= 	SR7->R7_DESCCAR									 //-- 20 Bytes
		Else
			cDescCarg 	:= 	fDesc( "SQ3", SR7->R7_CARGO, "Q3_DESCSUM" )
		EndIf
		SR7->(dbSkip())
	EndDo
EndIf
If empty(cCodFunc)
	cCodFunc 	:=	SRA->RA_CODFUNC
	cDescFunc	:=  LEFT(fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC" ),30)
EndIf
If empty(cCodCarg)
	cCodCarg 	:=	SRA->RA_CARGO
	cDescCarg	:=  LEFT(fDesc("SQ3",SRA->RA_CARGO,"Q3_DESCSUM" ),30)
EndIf
RestArea(aSR7)
Return

/*/{Protheus.doc} fBuscaNota
Carrega Cargo e Funcao conforme historico na SR7
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018

@return array, aNotas
/*/
Static Function fBuscaNota()

Local aNotas := {"NT","NT","NT"} //Grupos 01 a 03

SZE->(dbseek((cAliasQry)->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS)))

While SZE->(!eof()) .and. SZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS) == (cAliasQry)->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS)
	If SZE->ZE_GRUPO <> '99'
		aNotas[val(SZE->ZE_GRUPO)] := Transform(SZE->ZE_MEDTOT,cPicture)
	EndIf
	SZE->(dbskip())
EndDo

Return(aNotas)

/*/{Protheus.doc} fBusResp
Busca o responsavel pelo Depto conforme a visao
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 25/10/2018
@return characters, cRet
/*/
Static Function fBusResp()

Local cRet 	:=  ''

If RD4->(dbseek(xFilial("RD4")+cVisao+(cAliasQry)->RDE_ITEVIS))
	If RDE->(dbseek(xFilial("RDE")+cVisao+RD4->RD4_TREE+'1'))
		cRet := Posicione("RD0",1,xFilial("RD0")+RDE->RDE_CODPAR,"RD0_NOME")
	EndIf
EndIf

Return(cRet)
