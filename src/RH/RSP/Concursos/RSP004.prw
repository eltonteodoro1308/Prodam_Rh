#Include "Totvs.Ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"  
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � RSP004  � Autor � Marcos Pereira          � Data �  03.03.16 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � POSI��O E BANCO DE RESERVA DA SELE��O P�BLICA                ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � RSP004() 	                                                ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS �  Motivo da Alteracao                     																���
���������������������������������������������������������������������������Ĵ��
���            �          �      �                                          ���
�������������������������������������������������������������������������������
*/

User Function RSP004()

Local aRegs := {}

Private oReport
Private cPerg			:= "RSP004"
Private aOrd    		:= {}
Private cTitulo	 	:= "POSI��O E BANCO DE RESERVA DA SELE��O P�BLICA"
Private lLandScape  	:= .t.

//Verifica Perguntas
AjPerg(cPerg)
Pergunte(cPerg,.T.)

If empty(MV_PAR01)
	MsgAlert("Selecione um concurso.")
	Return
EndIf

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � ReportDef  � Autor � Marcos Pereira        � Data � 03.03.16 ���
���������������������������������������������������������������������������Ĵ��
���Descri�ao � Montagem das defini��es do relat�rio                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � RSP004                                                       ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � RSP004                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

Static Function ReportDef()

Local cDescri  := ""

oReport := TReport():New(cPerg, cTitulo, cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri)
oReport:nFontBody := 7

oReport:OnPageBreak( { || If(oReport:oPage:nPage > 1, (oReport:Section(1):Init(), oReport:Section(1):PrintLine(), oReport:Section(1):Finish()), .F.) })

oFilial := TRSection():New(oReport, "Filiais", { "NQRY" }) 

oFilial:SetLineStyle()
oFilial:cCharSeparator := ""
oFilial:nLinesBefore   := 0

TRCell():New(oFilial,"","SZ2",SZ2->Z2_DESC)
TRCell():New(oFilial,"","SZ2","Banco de Reserva atualizado at� "+dtoc(date()))
TRCell():New(oFilial,"","SZ2","Validade at� "+dtoc(SZ2->Z2_DTVALID))

oCargo := TRSection():New(oFilial, "Cargos", ("NQRY") )

oCargo:SetLeftMargin(1)
oCargo:SetCellBorder("ALL",,, .T.)
oCargo:SetCellBorder("RIGHT")
oCargo:SetCellBorder("LEFT")
oCargo:SetCellBorder("BOTTOM")
oCargo:SetCellBorder("TOP")
oCargo:SetTotalInLine(.F.)  

TRCell():New(oCargo,"CARGO"		,"NQRY","Cargos"				,            , TamSX3("Z3_CARGO2")[1] + 3 + TamSX3("Q3_DESCSUM")[1] + 3 + TamSX3("Q3_XESPECI")[1] + 3 + TamSX3("Z3_DCARGO2")[1], /*lPixel*/, /*bBlock*/, ) 
TRCell():New(oCargo,"RESERVA"	,"NQRY","Reserva Edital "	,"@E 999"    , 14 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"INSCRITOS"	,"NQRY","N� Inscritos "	    ,"@E 999,999", 12 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"HOMOLOG"	,"NQRY","Homologados "		,"@E 999"    , 11 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"CHAMADOS"	,"NQRY","Chamados "			,"@E 999"    , 08 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"DESISTENTE","NQRY","Desistentes "		,"@E 999"    , 11 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"CONTRATACA","NQRY","Em Contrata��o "	,"@E 999"    , 11 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"ADMITIDOS"	,"NQRY","Admitidos "			,"@E 999"    , 09 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")
TRCell():New(oCargo,"RESERVAF"	,"NQRY","Reserva "			,"@E 999"    , 07 /*nSize*/, .F. /*lPixel*/, /*bBlock*/, "CENTER")

//-- Totalizador
oCargo:SetTotalText({|| 'Totais' }) 
TRFunction():New(oCargo:Cell("RESERVA")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("INSCRITOS")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999,999"	/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("HOMOLOG")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("CHAMADOS")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("DESISTENTE"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("CONTRATACA"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("ADMITIDOS")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oCargo:Cell("RESERVAF")	,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@R 999"		/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

oReport:SetLandScape()
oReport:DisableOrientation()

Return(oReport)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � ReportPrint  � Autor � Marcos Pereira      � Data � 03.03.16 ���
���������������������������������������������������������������������������Ĵ��
���Descri�ao � Montagem das defini��es do relat�rio                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � RSP004                                                       ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � RSP004                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport)

Local oFilial    	:= oReport:Section(1)
Local oCargo     	:= oReport:Section(1):Section(1)
Local cSZ3Fil	 	:= "%" + FwJoinFilial("SQG","SZ3") + "%"
Local cSQ3Fil	 	:= "%" + FwJoinFilial("SZ3","SQ3") + "%"

//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
//MakeSqlExpr(cPerg)

cCodCon := MV_PAR01

If Select("NQRY") > 0
	NQRY->(DbCloseArea())
EndIf
If Select("TQRY") > 0
	TQRY->(DbCloseArea())
EndIf

BeginSql Alias "TQRY"

select Q3_FILIAL, Z3_CARGO, Z3_CARGO2, Z3_DCARGO2, Q3_DESCSUM, Q3_XESPECI, Z3_RESERVA, Z3_INSCRIT, count(QG_XCLASSI) as HOMOLOG, 
	(select count(QG_XDTCONV) from %table:SQG% 
		where 
			QG_XCODCON = %Exp:cCodCon% and 
			QG_XDTCONV <> %Exp:''% and
			%notDel% and
			QG_XCARGO2 = Z3_CARGO2 and 
			QG_CODFUN = Z3_CARGO) as CHAMADOS,
	(select count(QG_XDTDESI) from %table:SQG%
		where 
			QG_XCODCON = %Exp:cCodCon% and 
			QG_XDTDESI <> %Exp:''% and
			%notDel% and
			QG_XCARGO2 = Z3_CARGO2 and 
			QG_CODFUN = Z3_CARGO) as DESISTENTES,
	0 as CONTRATACAO, 
	(select count(QG_XDTCONV) from %table:SQG% 
		where 
			QG_XCODCON = %Exp:cCodCon% and 
			QG_XDTCONV <> %Exp:''% and
			QG_XDTDESI = %Exp:''% and
			( (QG_MAT <> %Exp:''% and QG_SITUAC = %Exp:'FUN'%) or QG_SITUAC = %Exp:'002'% ) and
			%notDel% and
			QG_XCARGO2 = Z3_CARGO2 and 
			QG_CODFUN = Z3_CARGO) as ADMITIDOS,
	0 as RESERVA
from %table:SZ3% SZ3
left join %table:SQG% SQG on %exp:cSZ3Fil% and Z3_CODIGO = QG_XCODCON and QG_XCARGO2 = Z3_CARGO2 and 
                             Z3_CARGO = QG_CODFUN and Z3_STATUS = %Exp:'1'% and 
                             QG_XCODCON = %Exp:cCodCon% and 	SQG.%notDel%
left join %table:SQ3% SQ3 on %exp:cSQ3Fil% and Q3_CARGO = Z3_CARGO and SQ3.%notDel% 
where
	SZ3.%notDel%
group by Q3_FILIAL, QG_CODFUN, Z3_CARGO, Q3_DESCSUM, Q3_XESPECI, Z3_CARGO2, Z3_DCARGO2, Z3_RESERVA, Z3_INSCRIT
order by Z3_CARGO2

EndSql


aStruct := { 	{ "CARGO"	   , "C", TamSX3("Z3_CARGO2")[1] + 3 + TamSX3("Q3_DESCSUM")[1] + 3 + TamSX3("Q3_XESPECI")[1] + 1 + TamSX3("Z3_DCARGO2")[1], 0 }, ;
				{ "RESERVA"	   , "N", TamSX3("Z3_RESERVA")[1], 0 }, ;
				{ "INSCRITOS"  , "N", TamSX3("Z3_INSCRIT")[1], 0 }, ;
				{ "HOMOLOG"    , "N", 3, 0 }, ;
				{ "CHAMADOS"   , "N", 3, 0 }, ;
				{ "DESISTENTE" , "N", 3, 0 }, ;
				{ "CONTRATACA" , "N", 3, 0 }, ;
				{ "ADMITIDOS"  , "N", 3, 0 }, ;
				{ "RESERVAF"   , "N", 3, 0 }, ;
      			{ "FILIAL"     , "C", TamSX3("Q3_FILIAL")[1], 0 } }
cArqTRB := CriaTrab(aStruct,.T.)

// Disponibiliza a tabela tempor�ria para uso pelo programa
dbUseArea(.T.,,cArqTRB,"NQRY",.F.)
// Cria o arquivo de indice para a tabela temporaria
IndRegua("NQRY", cArqTRB, "FILIAL+CARGO",,,'...')


TQRY->(dbgotop())

While TQRY->(!eof())
	RecLock("NQRY",.T.)
		NQRY->CARGO	 		:= 	TQRY->Z3_CARGO2 + ' -  ' + alltrim(TQRY->Q3_DESCSUM) + If(empty(TQRY->Q3_XESPECI),""," -  " + alltrim(TQRY->Q3_XESPECI)) + " " + alltrim(TQRY->Z3_DCARGO2)
		NQRY->RESERVA 		:= 	TQRY->Z3_RESERVA
		NQRY->INSCRITOS		:= 	TQRY->Z3_INSCRIT
		NQRY->HOMOLOG 		:= 	TQRY->HOMOLOG
		NQRY->CHAMADOS 		:= 	TQRY->CHAMADOS
		NQRY->DESISTENTE 		:= 	TQRY->DESISTENTE
		NQRY->ADMITIDOS 		:= 	TQRY->ADMITIDOS
		NQRY->CONTRATACA 		:= 	max(TQRY->CHAMADOS - TQRY->DESISTENTE - TQRY->ADMITIDOS, 0) 
		NQRY->RESERVAF	 	:= 	TQRY->HOMOLOG - TQRY->CHAMADOS
		NQRY->FILIAL	 		:= 	TQRY->Q3_FILIAL
	NQRY->(DbUnLock())
	TQRY->(dbskip())
EndDo


oCargo:SetParentFilter({|cParam| NQRY->FILIAL == cParam}, {|| NQRY->FILIAL })

oFilial:Print()

If Select("NQRY") > 0
	NQRY->(DbCloseArea())
EndIf
If Select("TQRY") > 0
	TQRY->(DbCloseArea())
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjPerg   � Autor �                        �Data � 05.09.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Verificacao de Perguntas                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjPerg()

Local j, i
Local _sAlias := Alias()
Local aHelp		:= 	{}
	
dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
aHelp :={" Informe ou selecione o Concurso."  }
aAdd(aRegs,{cPerg,'01','Concurso ?                    ','','','mv_ch1','C',10,0,0,'G','ExistCpo("SZ2")             ','mv_par01','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','SZ2','','',aHelp})

ValidPerg(aRegs,cPerg,.T.)

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return

