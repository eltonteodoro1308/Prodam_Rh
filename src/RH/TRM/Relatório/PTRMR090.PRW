#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRMR090.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRMR090  ³ Autor ³ Eduardo Ju            ³ Data ³ 05/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Calendario de Cursos.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRMR090                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cecilia Car.³31/07/14³TPZWAO³AIncluido o fonte da 11 para a 12 e efetu-³±±
±±³            ³        ³      ³ada a limpeza.                            ³±±
±±³Flavio Corre³01/09/14³TQHXL4³Ajuste no Join da query referente Filiais ³±±
±±³            ³        ³      ³Alteraçao SXB e SX1 para trazer filial certa±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PTRMR090()

Local oReport
Local aArea := GetArea()             

Pergunte("PTR090R",.F.)
oReport := ReportDef()
oReport:PrintDialog()	  

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 05.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cAliasQry := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:=TReport():New("PTRMR090",STR0001,"PTR090R",{|oReport| PrintReport(oReport,cAliasQry)},STR0001+" "+STR0002+" "+STR0003)	//"Calendario de Cursos"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetTotalInLine(.F.) //Totaliza em linha
oReport:SetLandScape(.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao:³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,STR0011,{"RA2"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Calendario"
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1,"RA2_CALEND","RA2",STR0011)	//Codigo do Calendario 
TRCell():New(oSection1,"RA2_DESC","RA2","")		//Descricao do Calendario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0012,{"RA2","RA1","RA9","RA0","RA7"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/) //Curso
oSection2:SetTotalInLine(.F.) 
oSection2:SetLeftMargin(3) 
oCell := TRCell():New(oSection2,"RA2_CURSO","RA2","Curso")//Codigo do Curso   
oCell:SetSize(05)
TRCell():New(oSection2,"RA1_DESC","RA1",,,40)			//Descricao do Curso
oCell := TRCell():New(oSection2,"RA2_XSTATU","RA2",,,16)			//Status
oCell:SetCBox("1=Aguard.DOCs;2=Cancelado;3=Em Andam.p/GFC;4=Encam.p/GFC;5=Pesquisa;6=Postergado;7=Realizado;8=Realizado c/Pend;9=Realiz.Nao Fat")
TRCell():New(oSection2,"RA2_TURMA","RA2","Tur")//Turma
TRCell():New(oSection2,"RA2_DATAIN","RA2")		//Data Inicial
TRCell():New(oSection2,"RA2_DATAFI","RA2")		//Data Final
TRCell():New(oSection2,"RA2_ENTIDA","RA2","Entid.",,4)//Codigo da Entidade
TRCell():New(oSection2,"RA0_DESC","RA0")			//Descricao da Entidade
TRCell():New(oSection2,"RA2_INSTRU","RA2","Instrut.",,7)	//Codigo do Instrutor
TRCell():New(oSection2,"RA7_NOME","RA7","Nome do Instrutor")			//Nome do Instrutor
oCell := TRCell():New(oSection2,"RA2_HORARI","RA2",,,14)	//Horario 
oCell:SetSize(20)
TRCell():New(oSection2,"RA2_DURACA","RA2","Durac",)			//Duracao
TRCell():New(oSection2,"RA2_UNDURA","RA2","Un")			//Unidade de Duracao
TRCell():New(oSection2,"RA2_VAGAS","RA2","Vag")	//Numero de Vagas
TRCell():New(oSection2,"RA2_RESERV","RA2","Res")	//Numero de Vagas Reservadas
TRCell():New(oSection2,"RA2_LOCAL","RA2")			//Local
TRCell():New(oSection2,"RA2_CUSTO","RA2",STR0019)	//Custo Estimado
TRCell():New(oSection2,"RA2_HORAS","RA2")			//Horas
oCell := TRCell():New(oSection2,"RA2_REALIZ","RA2",STR0020)	//Situacao do Treinamento
oCell:SetCBox("S="+STR0008+";N="+STR0009+"; ="+STR0009)
oCell:SetSize(08)
TRCell():New(oSection2,"RA2_SINON","RA2",STR0021)	//Codigo do Sinonimo do Curso    
TRCell():New(oSection2,"RA9_DESCR","RA9")			//Descricao do Sinonimo do Curso                                               

//oSection2:Cell("RA1_DESC"):SetLineBreak()
//oSection2:SetTotalText({|| "Total de Cursos" })  
//TRFunction():New(oSection2:Cell("RA2_CURSO"),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
//oSection2:SetLineStyle()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Terceira Secao:³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2,"Funcionarios",{"RA2","RA3","SRA","SQB"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/) //Funcionarios
oSection3:SetTotalInLine(.F.) 
oSection3:SetLeftMargin(10) 
TRCell():New(oSection3,"RA_MAT"	,"SRA") //   
TRCell():New(oSection3,"RA_NOME","SRA")	//
TRCell():New(oSection3,"RA_DEPTO","SRA")	//
TRCell():New(oSection3,"QB_DESCRIC","SQB")	//
oCell := TRCell():New(oSection3,"RA3_RESERV","RA3","Situacao",,10)	//
oCell:SetCBox("R=Reservado;L=Lista Esp.;S=Solicitado")
oCell := TRCell():New(oSection3,"RA3_EMAIL","RA3","Email Enviado")	//
oCell:SetCBox("S=Sim;N=Nao; =Nao")

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Custo do Treinamento)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1) 
Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local lQuery    := .F. 
Local cWhere1   := ""
Local cWhere2   := ""
Local cOrder	:= ""
Local cFilRA1   := ""
Local cFilRA9   := ""
Local cFilRA0   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Filial                                   ³
//³ MV_PAR02        //  Calendario                               ³
//³ MV_PAR03        //  Curso                                    ³
//³ MV_PAR04        //  Turma                                    ³
//³ MV_PAR05        //  Periodo                                  ³
//³ MV_PAR06        //  Entidade                                 ³
//³ MV_PAR07        //  Instrutor                                ³
//³ MV_PAR08        //  Treinamento (Aberto-Baixado-Ambos)       ³
//³ MV_PAR09        //  Impr.Sinonimo Curso (Sim ou Nao)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao SQL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr("PTR090R")    

//-- Filtragem do relatório
//-- Query do relatório da secao 1
lQuery := .T.          
cOrder := "%RA2_FILIAL,RA2_CALEND,RA2_CURSO%"   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Treinamento Aberto-Baixado-Ambos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	          
If MV_PAR08 == 1	 //Aberto  
	cWhere1 := "%RA2_REALIZ <> 'S' AND%"
	cWhere2 := "%0=1 AND%"
ElseIf MV_PAR08 == 2 //Baixado
	cWhere1 := "%0=1 AND%"
	cWhere2 := "%RA2_REALIZ = 'S' AND%"
Else
	cWhere1 := "%RA2_REALIZ <> 'S' AND%"
	cWhere2 := "%RA2_REALIZ = 'S' AND%"
EndIf           

If !empty(MV_PAR01)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR01) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR01) + ' AND%'
EndIf
If !empty(MV_PAR02)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR02) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR02) + ' AND%'
EndIf
If !empty(MV_PAR03)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR03) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR03) + ' AND%'
EndIf
If !empty(MV_PAR04)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR04) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR04) + ' AND%'
EndIf
If !empty(MV_PAR06)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR06) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR06) + ' AND%'
EndIf
If !empty(MV_PAR07)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + ' ' + alltrim(MV_PAR07) + ' AND%'
	cWhere2 := left(cWhere2,len(cWhere2)-1) + ' ' + alltrim(MV_PAR07) + ' AND%'
EndIf
If !empty(MV_PAR10)
    cAux := alltrim(MV_PAR10)
    cStatus := ''
    For nX := 1 to len(cAux)
    	cStatus += "'"+substr(cAux,nX,1)+"',"
    Next nX
    cStatus := left(cStatus,len(cStatus)-1)
	cWhere1 := left(cWhere1,len(cWhere1)-1) + " RA2_XSTATU in (" + cStatus + ") AND%"
	cWhere2 := left(cWhere2,len(cWhere2)-1) + " RA2_XSTATU in (" + cStatus + ") AND%"
EndIf

oReport:Section(1):BeginQuery()	
    
cFilRA1 := "% AND "+FWJoinFilial( "RA1", "RA2" )+"%"
cFilRA9 := "% AND "+FWJoinFilial( "RA9", "RA2" )+"%"
cFilRA0	:= "% AND "+FWJoinFilial( "RA2", "RA0" )+"%"



BeginSql Alias cAliasQry 

	%noparser%

	With CALEND(RA2_FILIAL,RA2_CALEND,RA2_DESC,RA2_CURSO,RA1_DESC,RA2_TURMA,RA2_DATAIN,RA2_DATAFI,RA2_ENTIDA, RA0_DESC,RA2_INSTRU,RA7_NOME,RA2_HORARI,RA2_DURACA,
	RA2_UNDURA,RA2_VAGAS,RA2_RESERV, RA2_LOCAL,RA2_CUSTO,RA2_HORAS,RA2_REALIZ,RA2_SINON,RA9_DESCR, RA_MAT,RA_NOME,RA_DEPTO,QB_DESCRIC,RA3_CALEND,
	RA3_CURSO,RA3_EMAIL,RA3_RESERV,RA2_XSTATU) 
	as (
			SELECT	RA2_FILIAL,RA2_CALEND,RA2_DESC,RA2_CURSO,RA1_DESC,RA2_TURMA,RA2_DATAIN,RA2_DATAFI,RA2_ENTIDA,
					RA0_DESC,RA2_INSTRU,RA7_NOME,RA2_HORARI,RA2_DURACA,RA2_UNDURA,RA2_VAGAS,RA2_RESERV,
					RA2_LOCAL,RA2_CUSTO,RA2_HORAS,RA2_REALIZ,RA2_SINON,RA9_DESCR,
					RA_MAT,RA_NOME,RA_DEPTO,QB_DESCRIC,RA3_CALEND,RA3_CURSO,RA3_EMAIL,RA3_RESERV,RA2_XSTATU
			FROM 	%table:RA2% RA2  
			LEFT JOIN %table:RA1% RA1 
				ON RA1_CURSO = RA2_CURSO
				AND RA1.%NotDel%
				%exp:cFilRA1%              
			LEFT JOIN %table:RA9% RA9
				ON RA9_SINONI   = RA2_SINON
				AND RA9.%NotDel%
				%exp:cFilRA9%
			LEFT JOIN %table:RA0% RA0
				ON RA0_ENTIDA = RA2_ENTIDA
				AND RA0.%NotDel%		
				%exp:cFilRA0%
			LEFT JOIN %table:RA7% RA7
				ON RA7_INSTRU = RA2_INSTRU
				AND RA7.%NotDel%  
			LEFT JOIN %table:RA3% RA3
				ON RA3_CALEND = RA2_CALEND and RA3_CURSO = RA2_CURSO and RA3_TURMA = RA2_TURMA
				AND RA3.%NotDel%   
			LEFT JOIN %table:SRA% SRA
				ON RA_FILIAL = RA3_FILIAL and RA_MAT = RA3_MAT
				AND SRA.%NotDel%   
			LEFT JOIN %table:SQB% SQB
				ON QB_DEPTO = RA_DEPTO
				AND SQB.%NotDel%  
		    WHERE	%exp:cWhere1%   
				RA2.%NotDel% 
		
			UNION ALL
		
			SELECT	RA2_FILIAL,RA2_CALEND,RA2_DESC,RA2_CURSO,RA1_DESC,RA2_TURMA,RA2_DATAIN,RA2_DATAFI,RA2_ENTIDA,
					RA0_DESC,RA2_INSTRU,RA7_NOME,RA2_HORARI,RA2_DURACA,RA2_UNDURA,RA2_VAGAS,RA2_RESERV,
					RA2_LOCAL,RA2_CUSTO,RA2_HORAS,RA2_REALIZ,RA2_SINON,RA9_DESCR,
					RA_MAT,RA_NOME,RA_DEPTO,QB_DESCRIC,RA4_CALEND as RA3_CALEND,RA4_CURSO as RA3_CURSO,' ' as RA3_EMAIL,'R' as RA3_RESERV,RA2_XSTATU
			FROM 	%table:RA2% RA2  
			LEFT JOIN %table:RA1% RA1 
				ON RA1_CURSO = RA2_CURSO
				AND RA1.%NotDel%
				%exp:cFilRA1%              
			LEFT JOIN %table:RA9% RA9
				ON RA9_SINONI   = RA2_SINON
				AND RA9.%NotDel%
				%exp:cFilRA9%
			LEFT JOIN %table:RA0% RA0
				ON RA0_ENTIDA = RA2_ENTIDA
				AND RA0.%NotDel%		
				%exp:cFilRA0%
			LEFT JOIN %table:RA7% RA7
				ON RA7_INSTRU = RA2_INSTRU
				AND RA7.%NotDel%  
			LEFT JOIN %table:RA4% RA4
				ON RA4_CALEND = RA2_CALEND and RA4_CURSO = RA2_CURSO and RA4_TURMA = RA2_TURMA
				AND RA4.%NotDel%   
			LEFT JOIN %table:SRA% SRA
				ON RA_FILIAL = RA4_FILIAL and RA_MAT = RA4_MAT
				AND SRA.%NotDel%   
			LEFT JOIN %table:SQB% SQB
				ON QB_DEPTO = RA_DEPTO
				AND SQB.%NotDel%  
		    WHERE	%exp:cWhere2%   
				RA2.%NotDel% 
		)

	Select * from CALEND

	group by RA2_CALEND,RA2_DESC,RA2_CURSO,RA1_DESC,RA2_TURMA,RA2_DATAIN,RA2_DATAFI,RA2_ENTIDA, RA0_DESC,
	         RA2_INSTRU,RA7_NOME,RA2_HORARI,RA2_DURACA,RA2_UNDURA,RA2_VAGAS,RA2_RESERV, RA2_LOCAL,RA2_CUSTO,
	         RA2_HORAS,RA2_REALIZ,RA2_SINON,RA9_DESCR, RA_MAT,RA_NOME,RA_DEPTO,QB_DESCRIC,RA3_CALEND,RA3_CURSO,
	         RA3_EMAIL,RA3_RESERV,RA2_XSTATU, RA2_FILIAL  										
	ORDER BY %Exp:cOrder%                 		
EndSql

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo EndQuery ( Classe TRSection )                                    ³
//³Prepara o relatório para executar o Embedded SQL.                       ³
//³ExpA1 : Array com os parametros do tipo Range                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oReport:Section(1):EndQuery({MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR06,MV_PAR07})	//*Array com os parametros do tipo Range*
oReport:Section(1):EndQuery()	//*Array com os parametros do tipo Range*
	
//-- Inicio da impressao do fluxo do relatório
oReport:SetMeter(RA2->(LastRec()))	

//-- Utiliza a query do Pai
oSection2:SetParentQuery()
oSection2:SetParentFilter( { |cParam| (cAliasQry)->RA2_CALEND == cParam .and. (!empty((cAliasQry)->RA_MAT) .or. (cAliasQry)->RA2_RESERV==0 ) },{ || (cAliasQry)->RA2_CALEND })
oSection3:SetParentQuery()
oSection3:SetParentFilter( { |cParam| (cAliasQry)->(RA2_CALEND+RA2_CURSO+RA2_TURMA) == cParam .and. !empty((cAliasQry)->RA_MAT)  },{ || (cAliasQry)->(RA2_CALEND+RA2_CURSO+RA2_TURMA) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Suprimir o Sinonimo do Curso  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 <> 1
	oSection2:Cell("RA2_SINON"):Disable()
	oSection2:Cell("RA9_DESCR"):Disable()
EndIf                                  

oSection1:Print()	 //Imprimir

Return Nil   



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ RA2XSTAT ³ Autor ³                       ³ Data ³ 28/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar o Status (pergunta no SX1)					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³      				   									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ 							   								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function RA2XSTAT(l1Elem)

Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local oWnd

Local aTipo	:= {}
l1Elem := If (l1Elem = Nil , .F. , .T.)

oWnd := GetWndDefault()

cAlias 	:= Alias() 					 // Salva Alias Anterior
MvPar	:= &(Alltrim(ReadVar()))	 // Carrega Nome da Variavel do Get em Questao
mvRet	:= Alltrim(ReadVar())		 // Iguala Nome da Variavel ao Nome variavel de Retorno

aTipo:={"Aguard.DOCs","Cancelado","Em Andam.p/GFC","Encam.p/GFC","Pesquisa","Postergado","Realizado","Realizado c/Pend","Realiz.Nao Fat."}
MvParDef:="123456789"
cTitulo := "Status"

f_Opcoes(@MvPar,cTitulo,aTipo,MvParDef,12,49,l1Elem) 	// Chama funcao f_Opcoes
&MvRet := mvpar										 	// Devolve Resultado
dbSelectArea(cAlias) 								 	// Retorna Alias

If oWnd != Nil
	GetdRefresh()
Endif

Return .T.

