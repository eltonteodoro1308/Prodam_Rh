#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE OPERATION_INSERT        1
#DEFINE OPERATION_UPDATE        2
#DEFINE OPERATION_APPROVE       3
#DEFINE OPERATION_REPROVE       4
#DEFINE OPERATION_DELETE        5

//--------------------------------------------------------------------------
/*{Protheus.doc} F0101303
Responsavel por intermediar os dados na Camada 3 do web service
@owner      ademar.fernandes
@author     ademar.fernandes
@since      06/10/2015
@param
@return     lRet
@project    MAN00000011501_EF_013
@version    P 12.1.006
@obs        Observacoes
*/
//--------------------------------------------------------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT tProdamStruct2VAVR
	WSDATA FilEmployee			AS String OPTIONAL       //Filial do funcionario
	WSDATA RegEmployee			AS String OPTIONAL       //Matricula do funcionario
	WSDATA Department			As String OPTIONAL       //codigo do departamento
	WSDATA Name					As String OPTIONAL       //Nome do funcionario
	WSDATA AdmissionDate		As String OPTIONAL       //Admissao do funcionario
	WSDATA CodBeneficio			As String OPTIONAL       //Codigo do Beneficio
	WSDATA QtdDiasCalc			As String OPTIONAL       //Qtdd.Dias Calculados
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Alteracao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE ProdamChangeVAVR		DESCRIPTION "Alteracao de Beneficios VA e VR"
	WSDATA WsNull				As String OPTIONAL       //NULL
	WSDATA EmployeeFil			AS String OPTIONAL       //Filial do funcionario
	WSDATA Registration			AS String OPTIONAL       //Matricula do funcionario
	WSDATA TpConsulta  			As String OPTIONAL       //Solicitado pelo usuario
	WSDATA WsResult				As String OPTIONAL       //Resultado da operacao

	WSDATA ProdamStruct2VAVR    As tProdamStruct2VAVR    //Dados da etapa do workflow

	WSMETHOD BuscaVAVR	DESCRIPTION "Busca os dias dos Beneficios."
	WSMETHOD GravaVAVR	DESCRIPTION "Grava os dias nos Beneficios"
ENDWSSERVICE


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³ Metodo para buscar o VA e VR no SR0                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
WSMETHOD BuscaVAVR WSRECEIVE EmployeeFil, Registration WSSEND ProdamStruct2VAVR WSSERVICE ProdamChangeVAVR

Local lRet      := .T.
Local cQuerySRA := GetNextAlias()
Local nDiasDe	:= 0
Local nDiasAte	:= 0

//--VarInfo("EmployeeFil",EmployeeFil)
//--VarInfo("Registration",Registration)

//# POSICIONA NA TABELA U055
nDiasDe  := FTABELA("U055", 1, 4 )
nDiasAte := FTABELA("U055", 1, 5 )

VarInfo("nDiasDe  =>",nDiasDe)
VarInfo("nDiasAte =>",nDiasAte)

If nDiasDe > 0 .And. ( Day(dDatabase) >= nDiasDe .And. Day(dDatabase) <= nDiasAte )

BeginSql alias cQuerySRA
	SELECT SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_NOME,SRA.RA_DEPTO,SRA.RA_ADMISSA,SR0.R0_TPVALE,SR0.R0_CODIGO,SR0.R0_QDIACAL,R0_DPROPIN,R0_XORIGEM
	FROM %table:SR0% SR0
	INNER JOIN %table:SRA% SRA ON
		SRA.RA_FILIAL = SR0.R0_FILIAL AND
		SRA.RA_MAT    = SR0.R0_MAT AND
		SRA.%notDel%
	WHERE
		SR0.R0_FILIAL = %exp:EmployeeFil% AND
		SR0.R0_MAT    = %exp:Registration% AND
		SR0.%notDel%
	ORDER BY R0_TPVALE DESC
EndSql
//--Varinfo('query',GetLastQuery()[2])

If !(cQuerySRA)->(Eof())
	::ProdamStruct2VAVR:FilEmployee		:= EmployeeFil
	::ProdamStruct2VAVR:RegEmployee		:= Registration
	::ProdamStruct2VAVR:Department		:= (cQuerySRA)->RA_DEPTO
	::ProdamStruct2VAVR:Name			:= (cQuerySRA)->RA_NOME
	::ProdamStruct2VAVR:AdmissionDate	:= DTOC(STOD((cQuerySRA)->RA_ADMISSA))
	::ProdamStruct2VAVR:CodBeneficio	:= ""
	::ProdamStruct2VAVR:QtdDiasCalc		:= ""
		lFirst := .T.

	While !(cQuerySRA)->(Eof())
/*
			If lFirst .And. !((cQuerySRA)->R0_TPVALE == "2") //-VA
				::ProdamStruct2VAVR:CodBeneficio	+= "00"+"/"
				::ProdamStruct2VAVR:QtdDiasCalc		+= "00"+"/"
			EndIf
			lFirst := .F.
*/
		If (cQuerySRA)->R0_XORIGEM == "P"
			::ProdamStruct2VAVR:CodBeneficio	+= Alltrim((cQuerySRA)->R0_CODIGO)+"/"
			::ProdamStruct2VAVR:QtdDiasCalc		+= StrZero((cQuerySRA)->R0_DPROPIN,2)+"/"
		Else
			::ProdamStruct2VAVR:CodBeneficio	+= Alltrim((cQuerySRA)->R0_CODIGO)+"/"
			::ProdamStruct2VAVR:QtdDiasCalc		+= StrZero((cQuerySRA)->R0_QDIACAL,2)+"/"
		EndIf
		(cQuerySRA)->(dbSkip())
	EndDo
Else
	::ProdamStruct2VAVR:FilEmployee		:= EmployeeFil
	::ProdamStruct2VAVR:RegEmployee		:= Registration
	::ProdamStruct2VAVR:Department		:= ""
	::ProdamStruct2VAVR:Name			:= ""
	::ProdamStruct2VAVR:AdmissionDate	:= ""
	::ProdamStruct2VAVR:CodBeneficio	:= ""
	::ProdamStruct2VAVR:QtdDiasCalc		:= ""
EndIf
(cQuerySRA)->( DbCloseArea() )
EndIf

Varinfo("CodBeneficio 1 ==>",::ProdamStruct2VAVR:CodBeneficio)
Varinfo("QtdDiasCalc 01 ==>",::ProdamStruct2VAVR:QtdDiasCalc)
::ProdamStruct2VAVR:CodBeneficio := Iif(!Empty(Alltrim(::ProdamStruct2VAVR:CodBeneficio)), ::ProdamStruct2VAVR:CodBeneficio, "00")
::ProdamStruct2VAVR:QtdDiasCalc  := Iif(!Empty(Alltrim(::ProdamStruct2VAVR:QtdDiasCalc)), ::ProdamStruct2VAVR:QtdDiasCalc, "00")

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³ Metodo para gavar o VA e VR no SR0                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//--WSMETHOD GravaVAVR WSRECEIVE EmployeeFil, Registration WSSEND WsNull WSSERVICE ProdamChangeVAVR
WSMETHOD GravaVAVR WSRECEIVE EmployeeFil, Registration, TpConsulta WSSEND WsResult WSSERVICE ProdamChangeVAVR

Local nSoma1 := 0
Local nSoma2 := 0
Local a1Area := GetArea()
Local a2Area := SR0->(GetArea())
Local cQuerySRA := GetNextAlias()

DEFAULT Self:EmployeeFil  := ""
DEFAULT Self:Registration := ""
DEFAULT Self:TpConsulta   := ""

BeginSql alias cQuerySRA
	SELECT *
	FROM %table:SR0% SR0
	WHERE
		SR0.R0_FILIAL = %exp:EmployeeFil% AND
		SR0.R0_MAT    = %exp:Registration% AND
		SR0.%notDel%
	ORDER BY R0_TPVALE DESC
EndSql

//-Soma os valores para gravar posteriormente
dbSelectArea(cQuerySRA)
While !(cQuerySRA)->(Eof())

	nSoma1 += (cQuerySRA)->R0_QDIACAL
	nSoma2 += (cQuerySRA)->R0_DPROPIN
	(cQuerySRA)->(dbSkip())
EndDo
dbGoTop()

//-Atualiza os dados na tabela SR0
While !(cQuerySRA)->(Eof())

	dbSelectArea("SR0")
	SR0->(dbSetOrder(3))	//-R0_FILIAL+R0_MAT+R0_TPVALE+R0_CODIGO (1=VR e 2=VA)
	SR0->(dbSeek( (cQuerySRA)->(R0_FILIAL+R0_MAT+R0_TPVALE+R0_CODIGO),.F.))
	//--ConOut(Found())
	//--ConOut("TIPO VALE ====> "+(cQuerySRA)->R0_TPVALE)
	//--ConOut("TP CONSULTA ==> "+::TpConsulta)
	If (cQuerySRA)->R0_TPVALE == "2"

		RecLock("SR0",.F.)
		If ::TpConsulta == "VA"
			SR0->R0_DPROPIN := Iif(nSoma2>0, nSoma2, nSoma1)
		Else
			SR0->R0_DPROPIN := 0
		EndIf
		SR0->R0_XORIGEM := "P"
		SR0->(MsUnlock())

	Else	//-"VR"

		RecLock("SR0",.F.)
		If ::TpConsulta == "VR"
			SR0->R0_DPROPIN := Iif(nSoma2>0, nSoma2, nSoma1)
		Else
			SR0->R0_DPROPIN := 0
		EndIf
		SR0->R0_XORIGEM := "P"
		SR0->(MsUnlock())

	EndIf

	dbSelectArea(cQuerySRA)
	(cQuerySRA)->(dbSkip())
EndDo

(cQuerySRA)->( DbCloseArea() )

// com essa organização abaixo, se precisar retornar algum tipo de msg diferente ao usuário
// seria só colocar um result diferente e tratar a msg lá no APH

// realiza as operações
//(IF) Se funcionou a operação
       ::WsResult := "1"
// (Else)
//--       ::WsResult := "0"
// (EndIf)

RestArea(a2Area)
RestArea(a1Area)
Return .T.
