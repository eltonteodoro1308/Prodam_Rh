#include "rwmake.ch"
#Define CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PRELAPD  ³ Autor ³ Marcos Pereira        ³ Data ³ 16.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Geracao de XML com dados das avaliações de competencias    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Específico para a PRODAM                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PRELAPD()


// Declaracao de variaveis private
SetPrvt("lEnd,lContinua,nHdl,cPerg")
SetPrvt("cNomeArq,cLin,nGrava")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomeArq    := GetTempPath()+'PRELAPD.XML'
lEnd        := .F.
lContinua   := .T.
nHdl        := 0
nGrava      := 0
cPerg 		:= 'PRELAPD'

VerPerg()

Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000,000 TO 250,500 DIALOG oDlg TITLE 'Geração de Arquivo de Avaliações'

@ 030,010 SAY OemtoAnsi('Este programa irá gerar um arquivo no formato XML e irá ')
@ 040,010 SAY OemtoAnsi('abri-lo automaticamente pelo programa padrão configurado ')
@ 050,010 SAY OemtoAnsi('na estação de trabalho. ')
@ 060,010 SAY OemtoAnsi('Atenção no preenchimento de filtros.  ')

@ 104,162 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
@ 104,190 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 104,218 BMPBUTTON TYPE 1 ACTION Continua()

@ 010,005 TO 100,245

ACTIVATE DIALOG oDlg CENTERED

If nHdl > 0 .And. lContinua
	If fClose(nHdl)
		If nGrava > 0
			ShellExecute("open",cNomeArq,"","",2)
			
		Else
			If lContinua
				Aviso('AVISO','Não existem registros a serem gravados. A geração do arquivo ' + AllTrim(cNomeArq) + ' foi abortada ...',{'OK'})
			EndIf
		EndIf
	Else
		
		MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(cNomeArq)+'.')
		
	EndIf
EndIf

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Continua     ³ Autor ³                    ³Data ³ 09.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fun‡„o para continua‡„o do processamento (na confirma‡„o)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Continua()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis utilizadas pelo programa                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao (intervalo) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSQLExpr(cPerg)	                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
	If File(cNomeArq)
		If fErase(cNomeArq) == 0
			Exit
		Else
			MsgAlert('Ocorreram problemas na tentativa de deletar o arquivo temporário '+AllTrim(cNomeArq)+'.')
			Return
		EndIf
	Else
		Exit
	EndIf
EndDo

nHdl := fCreate(cNomeArq)

If nHdl == -1
	MsgAlert('O arquivo temporário '+AllTrim(cNomeArq)+' nao pode ser criado!.','Atenção!')
	Return
Endif

// Inicializa processamento
Processa({|lEnd| RunCont()}, 'Processando...')

Close(oDlg)

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   RunCont    ³ Autor ³                   ³ Data ³ 09.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processamento                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMAKE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunCont()

Local cTEMP := getnextalias()
Local aTpAv := {"Avaliador","Auto-Avaliação","Consenso"}

//Monta Query
cQuery := ""
cQuery += "Select RDC_CODAVA, RD6_DESC, RDC_CODTIP, RD5_DESC, RDC_DTIAVA, RDC_DTFAVA, " + CRLF
cQuery += "       QB_DEPTO, QB_DESCRIC, RDC_CODADO, RD0_NOME, RDC_CODNET, RD1_DESC, RDC_TIPOAV, RDC_CODDOR, " + CRLF
cQuery += "       (select RD0_NOME from " + RetSqlName("RD0") + " where RD0_CODIGO = RDC_CODDOR and D_E_L_E_T_ = '') as NOMEDOR, " + CRLF
cQuery += "       (select RD0_NOME from " + RetSqlName("RD0") + " where RD0_CODIGO = RDC_CODAPR and D_E_L_E_T_ = '') as NOMEAPR, " + CRLF
cQuery += "       RDB_CODCOM, RDM_DESC, SRA.RA_MAT, SRA2.RA_MAT AS MATDOR, RD6_CODVIS, RD4_DESC, " + CRLF 

If MV_PAR09 # 1 //Se não for agrugamento por Avaliação
	cQuery += "       (select RD2_DESC from " + RetSqlName("RD2") + CRLF
	cQuery += "           where RD2_CODIGO = RDB_CODCOM and D_E_L_E_T_ = '' and " + CRLF
	cQuery += "                 RD2_ITEM IN (select RD2_TREE from " + RetSqlName("RD2") + CRLF
	cQuery += "                                where RD2_CODIGO = RDB_CODCOM and RD2_ITEM = RDB_ITECOM and D_E_L_E_T_ = '') " + CRLF
	cQuery += "        ) as COMPET, " + CRLF
	cQuery += "       RDB_ITECOM, RD2_DESC, " + CRLF
EndIf
	
If MV_PAR09 == 1 //Agrupamento por Avaliação
	cQuery += "   Round((sum(RDD_RESOBT)/sum(RDD_PTOMAX))*10,2) as RDD_RESOBT, " + CRLF
	cQuery += "   RDC_DATRET, RDC_CODAPR, RDC_DTEMAP, RDC_DTRETA, RDC_CODOBS " + CRLF
	cQuery += "From " + RetSqlName("RDC") + " RDC " + CRLF
	cQuery += "Left join " + RetSqlName("RDD") + " RDD on RDD_CODAVA = RDC_CODAVA and " + CRLF
	cQuery += "  RDD_CODADO = RDC_CODADO and RDD_TIPOAV = RDC_TIPOAV and " + CRLF 
	cQuery += "  RDD_CODNET = RDC_CODNET and RDD.D_E_L_E_T_ = '' " + CRLF
	cQuery += "left  Join " + RetSqlName("RDB") + " RDB on RDC_ID = RDB_ID and RDB.D_E_L_E_T_ = '' " + CRLF
ElseIf MV_PAR09 == 2 //Agrupamento por Item de Competencia
	cQuery += "   Round((RDD_RESOBT/RDD_PTOMAX)*10,2) as RDD_RESOBT " + CRLF
	cQuery += "From " + RetSqlName("RDC") + " RDC " + CRLF
	cQuery += "left  Join " + RetSqlName("RDB") + " RDB on RDC_ID = RDB_ID and RDB.D_E_L_E_T_ = '' " + CRLF
	cQuery += "Left  join " + RetSqlName("RDD") + " RDD on RDD_CODAVA = RDC_CODAVA and " + CRLF
	cQuery += "  RDD_CODADO = RDC_CODADO and RDD_TIPOAV = RDC_TIPOAV and RDD_CODCOM = RDB_CODCOM and " + CRLF 
	cQuery += "  RDD_ITECOM = RDB_ITECOM and RDD_CODNET = RDC_CODNET and RDD.D_E_L_E_T_ = '' " + CRLF
ElseIf MV_PAR09 == 3	//Agrupamento por Questoes
	cQuery += "   RDB_CODQUE, COALESCE (CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),QO_QUEST)),'') AS QO_QUEST, (RDB_RESOBT*10) AS NOTA, " + CRLF
	cQuery += "   RDB_CODJUS " + CRLF
	cQuery += "From " + RetSqlName("RDC") + " RDC " + CRLF
	cQuery += "left  Join " + RetSqlName("RDB") + " RDB on RDC_ID = RDB_ID and RDB.D_E_L_E_T_ = '' " + CRLF
EndIf

cQuery += "Inner Join " + RetSqlName("RD6") + " RD6 on RD6_CODIGO = RDC_CODAVA and RD6.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RD5") + " RD5 on RD5_CODTIP = RDC_CODTIP and RD5.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RD0") + " RD0 on RD0_CODIGO = RDC_CODADO and RD0.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RD1") + " RD1 on RD1_CODIGO = RDC_CODNET and RD1.D_E_L_E_T_ = '' " + CRLF
cQuery += "left  Join " + RetSqlName("RDM") + " RDM on RDM_CODIGO = RDB_CODCOM and RDM.D_E_L_E_T_ = '' " + CRLF
cQuery += "left  Join " + RetSqlName("RD2") + " RD2 on RD2_CODIGO = RDB_CODCOM and RD2_ITEM = RDB_ITECOM and RD2.D_E_L_E_T_ = '' " + CRLF
cQuery += "left  Join " + RetSqlName("SQO") + " SQO on QO_QUESTAO = RDB_CODQUE and SQO.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RDZ") + " RDZ on RDZ.RDZ_EMPENT = '" + cEmpAnt + "' and RDZ.RDZ_ENTIDA = 'SRA' and RDZ.RDZ_CODRD0 = RDC_CODADO and RDZ.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("SRA") + " SRA on SRA.RA_FILIAL+SRA.RA_MAT =  RDZ.RDZ_CODENT and SRA.D_E_L_E_T_ = '' and " + CRLF
cQuery += "                                     SRA.RA_ADMISSA < RDC.RDC_DTFAVA and (SRA.RA_DEMISSA = '' or SRA.RA_DEMISSA >= RDC.RDC_DTIAVA) and SRA.RA_AFASFGT <> 'X' " + CRLF
cQuery += "Inner Join " + RetSqlName("RDZ") + " RDZ2 on RDZ2.RDZ_EMPENT = '" + cEmpAnt + "' and RDZ2.RDZ_ENTIDA = 'SRA' and RDZ2.RDZ_CODRD0 = RDC_CODDOR and RDZ2.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("SRA") + " SRA2 on SRA2.RA_FILIAL+SRA2.RA_MAT =  RDZ2.RDZ_CODENT and SRA2.D_E_L_E_T_ = '' and " + CRLF
cQuery += "                                     SRA2.RA_ADMISSA < RDC.RDC_DTFAVA and (SRA2.RA_DEMISSA = '' or SRA2.RA_DEMISSA >= RDC.RDC_DTIAVA) and SRA2.RA_AFASFGT <> 'X' " + CRLF
cQuery += "Inner Join " + RetSqlName("SQB") + " SQB on QB_DEPTO = SRA.RA_DEPTO and SQB.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RDE") + " RDE on RDE_CODVIS = RD6_CODVIS AND RDE_CODPAR = RDC_CODADO AND RDE_STATUS = '1' AND RDE.D_E_L_E_T_ = '' " + CRLF
cQuery += "Inner Join " + RetSqlName("RD4") + " RD4 on RD4_CODIGO = RD6_CODVIS AND RD4_ITEM = RDE_ITEVIS AND RD4.D_E_L_E_T_ = '' " + CRLF
cQuery += "Where RDC.D_E_L_E_T_ = '' and "

//Condicao para buscar a maior matricula da RDZ quando o avaliador possuir mais que um registro no SRA e ambos 
//se enquadrarem nas condicoes de datas no inner join RDZ x SRA mais acima
cQuery += "      SRA2.RA_FILIAL+SRA2.RA_MAT in (select top 1 RDZ_CODENT from " + RetSqlName("RDZ") + " where RDZ_EMPENT = '" + cEmpAnt + "' AND RDZ_ENTIDA = 'SRA' AND RDZ_CODRD0 = RDC_CODDOR AND D_E_L_E_T_ = ' ' order by 1 desc)

If !empty(MV_PAR01)
	cQuery += " and " + MV_PAR01 + CRLF
EndIf

If !empty(MV_PAR02)
	cQuery += " and " + MV_PAR02 + CRLF
EndIf

If !empty(MV_PAR03)
	cQuery += " and " + MV_PAR03 + CRLF
EndIf

If !empty(MV_PAR04)
	cQuery += " and " + MV_PAR04 + CRLF
EndIf

If !empty(MV_PAR05)
	cQuery += " and " + MV_PAR05 + CRLF
EndIf

If !empty(MV_PAR06)
	cQuery += " and " + MV_PAR06 + CRLF
EndIf

If !empty(MV_PAR07)
	cQuery += " and " + MV_PAR07 + CRLF
EndIf

if MV_PAR08 <> 4  //Tipos de avaliadores
	cQuery += " and RDC_TIPOAV = '" + strzero(MV_PAR08,1) + "' " + CRLF
EndIf

If MV_PAR09 == 1 //Agrupamento por Avaliação
	cQuery += "Group by RDC_CODAVA, RD6_DESC, RDC_CODTIP, RD5_DESC, RDC_DTIAVA, " + CRLF
	cQuery += "         RDC_DTFAVA, QB_DEPTO, QB_DESCRIC, RDC_CODADO, RD0_NOME, RDC_CODNET, RD1_DESC, " + CRLF
	cQuery += "         RDC_CODDOR, RDB_CODCOM, RDM_DESC, RDC_TIPOAV, RDC_DATRET, RDC_CODAPR, RDC_DTEMAP, "
	cQuery += "         RDC_DTRETA, RDC_CODOBS, SRA.RA_MAT, SRA2.RA_MAT, RD6_CODVIS, RD4_DESC " + CRLF
	cQuery += "Order by RDC_CODAVA, QB_DEPTO, QB_DESCRIC, RDC_CODADO, RDC_CODNET, RDC_TIPOAV, RDB_CODCOM " + CRLF

ElseIf MV_PAR09 == 2 //Agrupamento por Item de Competencia
	cQuery += "Group by RDC_CODAVA, RD6_DESC, RDC_CODTIP, RD5_DESC, RDC_DTIAVA, " + CRLF
	cQuery += "         RDC_DTFAVA, QB_DEPTO, QB_DESCRIC, RDC_CODADO, RD0_NOME, RDC_CODNET, RD1_DESC, " + CRLF
	cQuery += "         RDC_CODDOR, RDB_CODCOM, RDM_DESC, RDB_ITECOM, RD2_DESC, RDD_RESOBT, RDD_PTOMAX, 
	cQuery += "         RDC_TIPOAV, RDC_CODAPR, SRA.RA_MAT, SRA2.RA_MAT, RD6_CODVIS, RD4_DESC " + CRLF
	cQuery += "Order by RDC_CODAVA, QB_DEPTO, QB_DESCRIC, RDC_CODADO, RDC_CODNET, RDC_TIPOAV, RDB_CODCOM, RDB_ITECOM " + CRLF

ElseIf MV_PAR09 == 3 //Agrupamento por questões 
	cQuery += "Order by RDC_CODAVA, RDC_CODADO, RDC_CODNET, RDC_TIPOAV, RDB_CODCOM, RDB_ITECOM, RDB_CODQUE " + CRLF

Endif

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTEMP,.T.,.F.)

(cTEMP)->(dbGoTop())

//Monta o XML

cLin := '<?xml version="1.0"  encoding="ISO-8859-1" ?>' + CRLF 
cLin += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cLin += ' xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
cLin += ' xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
cLin += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
cLin += ' xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
cLin += ' <Styles>' + CRLF
cLin += '  <Style ss:ID="Default" ss:Name="Normal">' + CRLF
cLin += '   <Alignment ss:Vertical="Bottom"/>' + CRLF
cLin += '   <Borders/>' + CRLF
cLin += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
cLin += '   <Interior/>' + CRLF
cLin += '   <NumberFormat/>' + CRLF
cLin += '   <Protection/>' + CRLF
cLin += '  </Style>' + CRLF
cLin += '  <Style ss:ID="s71">' + CRLF
cLin += '   <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>' + CRLF
cLin += '  </Style>' + CRLF
cLin += '  <Style ss:ID="s72">' + CRLF
cLin += '   <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>' + CRLF
cLin += '   <NumberFormat ss:Format="Short Date"/>' + CRLF
cLin += '  </Style>' + CRLF
cLin += '  <Style ss:ID="s73">' + CRLF
cLin += '   <Interior ss:Color="#9BC2E6" ss:Pattern="Solid"/>' + CRLF
cLin += '  </Style>' + CRLF
cLin += ' </Styles>' + CRLF
cLin += ' <Worksheet ss:Name="prelapd">' + CRLF
cLin += '  <Table>' + CRLF

cLin += '   <Row>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Avaliação</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Avaliação</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Tipo Avaliação</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Tipo Avaliação</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Período Inicial</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Período Final</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Depto</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Departamento</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Visão</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Item da Visão</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Avaliado</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Matr.Avaliado</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nome Avaliado</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Rede</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Rede</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Tipo do Avaliador</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Avaliador</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Matr.Avaliador</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nome Avaliador</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Compet.</Data></Cell>' + CRLF
cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Competência</Data></Cell>' + CRLF

If MV_PAR09 == 1
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Pontuação</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Status</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Data Finalização</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Aprovador</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nome Aprovador</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Data Envio p/Aprov.</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Data Retorno Aprov.</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Observ.Aprovador</Data></Cell>' + CRLF
ElseIf MV_PAR09 == 2
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Grupo Competência</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Item</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Item</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Pontuação</Data></Cell>' + CRLF
ElseIf MV_PAR09 == 3
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Grupo Competência</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Item</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Item</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod.Questão</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Desc.Questão</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nota</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Justificativa</Data></Cell>' + CRLF
EndIf

cLin += '   </Row>' + CRLF

ProcRegua(0)

(cTEMP)->(dbGoTop())

While (cTEMP)->(!Eof())
	
	//Incrementa a regua
	IncProc('Gerando o Arquivo...')

	If nGrava == 0
		fGravaReg()
	EndIf
		
	cLin := '    <Row>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODAVA + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD6_DESC + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODTIP + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD5_DESC + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + dtoc(stod((cTEMP)->RDC_DTIAVA)) + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + dtoc(stod((cTEMP)->RDC_DTFAVA)) + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->QB_DEPTO + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->QB_DESCRIC + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD6_CODVIS + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD4_DESC + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODADO + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RA_MAT + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD0_NOME + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODNET + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD1_DESC + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + aTpAv[val((cTEMP)->RDC_TIPOAV)] + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODDOR + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->MATDOR + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->NOMEDOR + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDB_CODCOM + '</Data></Cell>' + CRLF
	cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDM_DESC + '</Data></Cell>' + CRLF
	
	If MV_PAR09 == 1
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="Number">' + alltrim(transform((cTEMP)->RDD_RESOBT,"@R 9999.9999")) + '</Data></Cell>' + CRLF
		If empty((cTEMP)->RDB_CODCOM)
			cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">Não iniciada</Data></Cell>' + CRLF
		ElseIf empty((cTEMP)->RDC_DATRET)
			cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">Não finalizada</Data></Cell>' + CRLF
		ElseIf !empty((cTEMP)->RDC_CODAPR) .and. empty((cTEMP)->RDC_DTRETA)
			cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">Aguardando Aprovador</Data></Cell>' + CRLF
		ElseIf !empty((cTEMP)->RDC_CODAPR) .and. !empty((cTEMP)->RDC_DTRETA)
			cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">Finalizada</Data></Cell>' + CRLF
		Else
			cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">Finalizada</Data></Cell>' + CRLF
		EndIf	
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + dtoc(stod((cTEMP)->RDC_DATRET)) + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDC_CODAPR + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->NOMEAPR + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + dtoc(stod((cTEMP)->RDC_DTEMAP)) + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + dtoc(stod((cTEMP)->RDC_DTRETA)) + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + alltrim(ApdMsMm((cTEMP)->RDC_CODOBS)) + '</Data></Cell>' + CRLF
	ElseIf MV_PAR09 == 2
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->COMPET + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDB_ITECOM + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD2_DESC + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="Number">' + alltrim(transform((cTEMP)->RDD_RESOBT,"@R 9999.9999")) + '</Data></Cell>' + CRLF
	ElseIf MV_PAR09 == 3
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->COMPET + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDB_ITECOM + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RD2_DESC + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + (cTEMP)->RDB_CODQUE + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + alltrim((cTEMP)->QO_QUEST) + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="Number">' + alltrim(transform((cTEMP)->NOTA,"@R 9999.9999")) + '</Data></Cell>' + CRLF
		cLin += '    <Cell ss:StyleID="s71"><Data ss:Type="String">' + alltrim(ApdMsMm((cTEMP)->RDB_CODJUS)) + '</Data></Cell>' + CRLF
	EndIf
	
	cLin += '    </Row>' + CRLF
	

	fGravaReg()

	(cTemp)->(dbskip())
	
Enddo

If nGrava > 0
	cLin := '    </Table>' + CRLF
	cLin += '   </Worksheet>' + CRLF
	cLin += '  </Workbook>' + CRLF
	fGravaReg()
EndIf

(cTEMP)->(dbclosearea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fGravaReg    ³ Autor ³                   ³ Data ³ 09.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Registros no Arquivo Texto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGravaReg()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraKit                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGravaReg()

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgYesNo('Ocorreu um erro na gravacao do arquivo '+AllTrim(cNomeArq)+'.   Continua?','Atencao!')
		lContinua := .F.
		Return
	Endif
Else
	nGrava++
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   VerPerg    ³ Autor ³                   ³ Data ³ 09.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica  as perguntas, Incluindo-as caso n„o existam      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VerPerg                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerPerg()

aRegs     := {}

cPerg := Left(cPerg,6)

//X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP
aAdd(aRegs,{cPerg,"01","Filial ?                      ","Filial ?                      ","Filial ?                      ","mv_ch1","C",99,0,0,"R","","mv_par01","","","","RDC_FILIAL","","","","","","","","","","","","","","","","","","","","","XM0","","",""})
aAdd(aRegs,{cPerg,"02","Avaliacao ?                   ","Avaliacao ?                   ","Avaliacao ?                   ","mv_ch2","C",99,0,0,"R","","mv_par02","","","","RDC_CODAVA","","","","","","","","","","","","","","","","","","","","","RD6","","",""})
aAdd(aRegs,{cPerg,"03","Avaliado ?                    ","Avaliado ?                    ","Avaliado ?                    ","mv_ch3","C",99,0,0,"R","","mv_par03","","","","RDC_CODADO","","","","","","","","","","","","","","","","","","","","","RD0","","",""})
aAdd(aRegs,{cPerg,"04","Competencia ?                 ","Competencia ?                 ","Competencia ?                 ","mv_ch4","C",99,0,0,"R","","mv_par04","","","","RDB_CODCOM","","","","","","","","","","","","","","","","","","","","","RDM","","",""})
aAdd(aRegs,{cPerg,"05","Item de Competencia ?         ","Item de Competencia ?         ","Item de Competencia ?         ","mv_ch5","C",99,0,0,"R","","mv_par05","","","","RDB_ITECOM","","","","","","","","","","","","","","","","","","","","","RD2","","",""})
aAdd(aRegs,{cPerg,"06","Tipo Avaliacao ?              ","Tipo Avaliacao ?              ","Tipo Avaliacao ?              ","mv_ch6","C",99,0,0,"R","","mv_par06","","","","RDC_CODTIP","","","","","","","","","","","","","","","","","","","","","RD5","","",""})
aAdd(aRegs,{cPerg,"07","Rede ?                        ","Rede ?                        ","Rede ?                        ","mv_ch7","C",99,0,0,"R","","mv_par07","","","","RDC_CODNET","","","","","","","","","","","","","","","","","","","","","RD1","","",""})
aAdd(aRegs,{cPerg,"08","Tipo do Avaliador ?           ","Tipo do Avaliador ?           ","Tipo do Avaliador ?           ","mv_ch8","N", 1,0,0,"C","","mv_par08","Avaliador",'','','','','AutoAvaliacao','','','','','Consenso','','','','','Todos','','','','','               ','','','','   ',''})
aAdd(aRegs,{cPerg,"09","Nível de Agrupamento ?        ","Nível de Agrupamento ?        ","Nível de Agrupamento ?        ","mv_ch9","N", 1,0,0,"C","","mv_par09","Avaliação",'','','','','Item Compet.','','','','','Questões','','','','','     ','','','','','               ','','','','   ',''})

ValidPerg(aRegs,cPerg ,.F.)

Return

