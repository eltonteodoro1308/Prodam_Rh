#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE  CRLF  Chr(13)+Chr(10)

/*/{Protheus.doc} APD007
Replica do cadastro de Visao do APD.
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 23/10/2018
/*/
User Function APD007()

Local aSays:={}, aButtons:= {},aRegs := {} //<== arrays locais de preferencia

SetPrvt("cCadastro,cPerg,nOpca,nX_,nPos")
SetPrvt("lContinua,cNomeArq,cLin,lEnd,nAviso,cCab1,cCab2,cCab3,nReg")

//Iniciar Variaveis
cCadastro	:= OemToAnsi("Replica de Visão do APD")
cPerg		:= "VISAO001_"
nReg    	:= 1
nIdEnd      := 0
lContinua	:= .T.
lEnd		:= .T.
aInfoE		:= {}
aSet		:= {}

fChkPerg()
Pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi("Este programa replica uma Visão do APD.") )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,Iif(GpconfOK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| fVBProc(),"Gerando Visão"})
Endif


Return

/*/{Protheus.doc} fVBProc
Definir
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 23/10/2018
/*/
Static Function fVBProc()

//Variaveis das Perguntas
Pergunte(cPerg,.F.)

//Carrega as Variaveis das Perguntas
cVisao		:= mv_par01	//Avalicao
lAloca		:= if(mv_par02==1,.t.,.f.)
CODIGO 		:= ''

DbSelectArea("RDK")
DbSelectArea("RD4")

//Fechamento das Tabelas Temporarias
If Select("R0NW") > 0
	DbSelectArea("R0NW")
	DbCloseArea("R0NW")
EndIf

//Monta Query de Filtro
cQuery := ""
cQuery += "Select max(RDK_CODIGO) as Totvs "
cQuery += " FROM " + RETSQLNAME("RDK")
cQuery += " where D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )
R0NW->(DbGotop())

CODIGO := strzero(val(R0NW->Totvs) + 1, 6)

DbCloseArea("R0NW")

//Monta Query de Filtro
cQuery := ""
cQuery += "Select RDK_FILIAL,RDK_DESC,RDK_HIERAR,RDK_TIPO "
cQuery += " FROM " + RETSQLNAME("RDK")
cQuery += " Where RDK_CODIGO = '" + cVisao + "'"
cQuery += " and D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)

//Abre Tabela
dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )

R0NW->(DbGotop())

//Cria a RDK  - cabecalho
RDK->(Reclock("RDK",.T.))
RDK->RDK_FILIAL	:= R0NW->RDK_FILIAL
RDK->RDK_CODIGO := CODIGO
RDK->RDK_DESC	:= R0NW->RDK_DESC
RDK->RDK_HIERAR	:= R0NW->RDK_HIERAR
RDK->RDK_TIPO	:= R0NW->RDK_TIPO
RDK->RDK_DTINCL	:= date()
RDK->RDK_STATUS	:= '1'
RDK->( msUnlock() )

DbCloseArea("R0NW")

//Monta Query de Filtro
cQuery := ""
cQuery += "Select RD4_FILIAL,RD4_ITEM,RD4_EMPIDE,RD4_FILIDE,RD4_CODIDE,RD4_DESC,RD4_TREE,RD4_CHAVE "
cQuery += " FROM " + RETSQLNAME("RD4") //RDK
cQuery += " Where RD4_CODIGO = '" + cVisao + "'"
cQuery += " and D_E_L_E_T_ = '' "
cQuery += " ORDER BY RD4_FILIAL, RD4_CODIGO, RD4_ITEM"

cQuery := ChangeQuery(cQuery)

//Abre Tabela
dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )

R0NW->(DbGotop())

While R0NW->(!Eof())

	//Cria a RD4 - Itens da visao
	RD4->(Reclock("RD4",.T.))
	RD4->RD4_FILIAL	:= R0NW->RD4_FILIAL
	RD4->RD4_CODIGO := CODIGO
	RD4->RD4_ITEM	:= R0NW->RD4_ITEM
	RD4->RD4_EMPIDE	:= R0NW->RD4_EMPIDE
	RD4->RD4_FILIDE	:= R0NW->RD4_FILIDE
	RD4->RD4_CODIDE := R0NW->RD4_CODIDE
	RD4->RD4_DESC 	:= R0NW->RD4_DESC
	RD4->RD4_TREE 	:= R0NW->RD4_TREE
	RD4->RD4_CHAVE 	:= R0NW->RD4_CHAVE
	//RD4->RD4_DATA 	:= R0NW->RD4_DATA
	//RD4->RD4_STATUS := R0NW->RD4_STATUS
	RD4->( msUnlock() )

	R0NW->(DbSkip())

	IncProc('Replicando a Estrutura... ')

EndDo

DbCloseArea("R0NW")

If lAloca

	//Monta Query de Filtro
	cQuery := ""
	cQuery += "Select RDE_FILIAL,RDE_CODPAR,RDE_ITEVIS,RDE_XAPROV "
	cQuery += " FROM " + RETSQLNAME("RDE") //RDK
	cQuery += " Where RDE_CODVIS = '" + cVisao + "'"
	cQuery += " and D_E_L_E_T_ = '' and RDE_STATUS = '1' "
	cQuery += " ORDER BY RDE_FILIAL, RDE_ITEVIS, RDE_CODPAR"

	cQuery := ChangeQuery(cQuery)

	//Abre Tabela
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )

	R0NW->(DbGotop())

	While R0NW->(!Eof())

		//Cria a RD4 - Itens da visao
		RD4->(Reclock("RDE",.T.))
		RDE->RDE_FILIAL	:= R0NW->RDE_FILIAL
		RDE->RDE_CODPAR	:= R0NW->RDE_CODPAR
		RDE->RDE_CODVIS := CODIGO
		RDE->RDE_ITEVIS	:= R0NW->RDE_ITEVIS
		RDE->RDE_DATA	:= date()
		RDE->RDE_STATUS	:= '1'
		RDE->RDE_XAPROV := R0NW->RDE_XAPROV
		RDE->( msUnlock() )

		R0NW->(DbSkip())

		IncProc('Replicando as Alocações... ')

	EndDo

	DbCloseArea("R0NW")

EndIf

Alert("Finalizada a replicação da Visão "+cVisao+" para "+CODIGO+".")

Return

/*/{Protheus.doc} fChkPerg
Definir
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 23/10/2018
/*/
Static Function fChkPerg()

Local aRegs	:= {}
Local aHelp

aHelp :={" Informe o código da visão do APD",;
		 " que deverá ser replicada. "	}
aAdd(aRegs,{cPerg,'01','Visao p/replicar       ?','','','mv_ch1','C',06,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','RDK','','',aHelp})
aHelp :={" Deseja que as alocações também",;
		 " sejam replicadas ?"	}
aAdd(aRegs,{cPerg,'02','Replica alocações      ?','','','mv_ch2','N',01,0,0,'C','           ','mv_par02','Sim            ','','','','','Não          ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})

ValidPerg(aRegs,cPerg)

Return
