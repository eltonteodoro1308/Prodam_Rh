#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"

#DEFINE CONFIRMA 1
#DEFINE REDIGITA 2
#DEFINE ABANDONA 3

Static cTipoUsu := ''

/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD001  ³ Autor ³                        ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para inclusao de metas individuais para avaliacao   ³±±  
±±³          ³ no APD (tabela SZ0)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
User Function APD001(cTipo)

Local bCancel 	:= {||oDlg:End()}
Local oDlg               
Local oGet1
Local cFilRDU	:= xFilial("RDU",SRA->RA_FILIAL)
Local nRecnoRDU	:= 0

Default cTipo	 := " " //L=Usuario logado no portal  T=Equipe contida no arquivo 
	
Private nLimPeso := supergetmv("MV_APDLIMP",,3)
Private nLimMeta := supergetmv("MV_APDLIMM",,3)
Private cPeriodo := space(6)

Private cMeta	 := ""
Private cJustif	 := ""
Private oTMulti1
Private oTMulti2

Private aTextos	 := {}

cTipoUsu := cTipo

RDU->(dbsetorder(3))
RDU->(dbseek(cFilRDU,.t.))
While RDU->(!eof()) .and. RDU->RDU_FILIAL == cFilRDU 
	If ddatabase >= RDU->RDU_DATINI .and. ddatabase <= RDU->RDU_DATFIM
		cPeriodo  := RDU->RDU_CODIGO
		nRecnoRDU := RDU->(recno())
	EndIf
	RDU->(dbskip())
EndDo
RDU->(dbsetorder(1))
If nRecnoRDU > 0
	RDU->(dbgoto(nRecnoRDU))
EndIF 

Begin Sequence
  DEFINE MSDIALOG oDlg TITLE "Período" FROM 9,0 TO 22,80 OF oMainWnd 

	@ 60,025 SAY  "Selecione o Período: " OF oDlg PIXEL 
	@ 58,082 MSGET oGet1 VAR cPeriodo  PICTURE "@!" Valid fVerRDU() F3 "RDU_01" SIZE 25,10 OF oDlg PIXEL HASBUTTON 
    @ 58,140 MSGET if(empty(cPeriodo),"",alltrim(RDU->RDU_DESC)) VALID {|| ,oDlg:Refresh()} SIZE 140,10  OF oDlg Pixel WHEN .F. 	     	  	
                                                                                                                       
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||IIF(APD001Cont(),oDlg:End(),.F.)},bCancel)

End Sequence

Return


/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD001Cont³ Autor ³                      ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento                                              ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
Static Function APD001Cont()

LOCAL cFiltraRH		:= ''		//Variavel para filtro
LOCAL aIndexSRA    	:= {}		//Variavel Para Filtro
Private bFiltraBrw := {|| Nil}		//Variavel para Filtro
PRIVATE aRotina    :=  MenuDef() // ajuste para versao 9.12 - chamada da funcao MenuDef() que contem aRotina

cCadastro 			:= OemToAnsi("Metas individuais por Período")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Arquivo Esta Vazio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ChkVazio("SRA")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoUsu == 'L'  //Funcionario logado, visualiza a sua e da equipe (menos o gestor)
	cDepto 		:= Posicione("SRA",1,cFilAPD_+cMatAPD_,"RA_DEPTO")
	cFilGestor	:= Posicione("SQB",1,xFilial("SQB",cFilAPD_)+cDepto,"QB_FILRESP")
	cMatGestor	:= SQB->QB_MATRESP
	cFiltraRh := "RA_SITFOLH<>'D'.and.RA_FILIAL=='"+cFilAPD_+"'.and.RA_DEPTO=='"+cDepto+"'"
	If cFilAPD_+cMatAPD_ <> cFilGestor+cMatGestor
		cFiltraRh +=".and.!(RA_FILIAL+RA_MAT=='"+cFilGestor+cMatGestor+"')"
	EndIf
ElseIf cTipoUsu == 'T'
	cFiltraRh := U_FILTREQ() //Busca o filtro a ser utilizado no Browse
EndIf
//varinfo("cFiltraRH",cFiltraRH)
If empty(cFiltraRH) .or. cFiltraRH == "(RA_FILIAL=='@@')"
	MsgAlert("Não foi possível identificar os funcionários sob sua responsabilidade")
	Return
EndIf
bFiltraBrw 	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
Eval(bFiltraBrw)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetBrwCHGAll( .T. )
dbSelectArea("SRA")
mBrowse( 6, 1,22,75,"SRA",,,,,,fCriaCor() )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta o filtro utilizando a funcao FilBrowse                     	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("SRA",aIndexSra)
		
//Retorna o SET EPOCH padrao do framework
If(FindFunction( "RetPadEpoch" ))
	RetPadEpoch()
EndIf

Return


/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD001Atu ³ Autor ³                      ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento                                              ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
User Function APD001Atu(cAlias,nReg,nOpcx)
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }
Local cFil      	:= ""
Local cMat      	:= ""
Local nSavRec   	:= RecNo()
Local nCnt			:= 0.00
Local oDlg
Local oFont
Local oGroup
lOCAL nAt			:=0
Local oSay

local cTabela		:= "Metas individuais por Período"

Local aNoFields 	:= {"Z0_MAT","Z0_CODPER"}
Local bSeekWhile	:= {|| SZ0->Z0_FILIAL + SZ0->Z0_MAT + SZ0->Z0_CODPER }
Local uSeekFor		:= If(cTipoUsu=="L",{|| SZ0->Z0_STATUS=='1' },{|| SZ0->Z0_STATUS<>'' })
Local nSZ0Ord		:= RetOrdem( "SZ0", "Z0_FILIAL+Z0_MAT+Z0_CODPER+Z0_SEQ" )
Local nPosRec		:= 0

Local nPosMeta		
Local nPosJustif
Local lReadOnly		:= .F.
Local nX

Private aAC      	:= {"Abandona","Confirma"}
Private aColsRec 	:= {}   //--Array que contem o Recno() dos registros da aCols
Private nUsado		:=0
Private aHeaderAux	:= {}
Private aColsAux	:= {}
Private lAltera 	:= .f.
Private lResult 	:= .f.

If cTipoUsu == 'L' .and. (nOpcx == 3 .or. nOpcx == 4)
	Alert("Esta opção não está disponível para o seu perfil.")
	Return
EndIf

//Verifica as permissoes conforme as datas do cadastro de períodos RDU, o qual ja esta posicionado.
If date() >= RDU->RDU_INIINC .and. date() <= RDU->RDU_FIMINC
	lAltera := .t.
EndIf
If date() >= RDU->RDU_INIRES .and. date() <= RDU->RDU_FIMRES
	lResult := .t.
EndIf

cFil      	:= SRA->RA_FILIAL
cMat      	:= SRA->RA_MAT

cAlias	:= "SZ0"
cCod 	:= SRA->RA_MAT

While .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe algum dado no arquivo                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( cAlias )
	dbSeek( cFil + cMat + cPeriodo)
  	nCnt := 0
   	While !EOF() .And. Z0_FILIAL + Z0_MAT + Z0_CODPER == cFil + cMat + cPeriodo
		nCnt++
		dbSkip()
    EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gerar o array aCols com os dependentes E Monta o cabecalho   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSeekKey := cFil + cMat + cPeriodo
	FillGetDados(nOpcx					,; //1-nOpcx - número correspondente à operação a ser executada, exemplo: 3 - inclusão, 4 alteração e etc;
				 cAlias					,; //2-cAlias - area a ser utilizada;
				 nSZ0Ord				,; //3-nOrder - ordem correspondente a chave de indice para preencher o  acols;
				 cSeekKey				,; //4-cSeekKey - chave utilizada no posicionamento da area para preencher o acols;
				 bSeekWhile				,; //5-bSeekWhile - bloco contendo a expressão a ser comparada com cSeekKey na condição  do While.
				 uSeekFor				,; //6-uSeekFor - pode ser utilizados de duas maneiras:1- bloco-de-código, condição a ser utilizado para executar o Loop no While;2º - array bi-dimensional contendo N.. condições, em que o 1º elemento é o bloco condicional, o 2º é bloco a ser executado se verdadeiro e o 3º é bloco a ser executado se falso, exemplo {{bCondicao1, bTrue1, bFalse1}, {bCondicao2, bTrue2, bFalse2}.. bCondicaoN, bTrueN, bFalseN};
				 aNoFields		   	    ,; //7-aNoFields - array contendo os campos que não estarão no aHeader;
				 NIL					,; //8-aYesFields - array contendo somente os campos que estarão no aHeader;
				 NIL					,; //9-lOnlyYes - se verdadeiro, exibe apenas os campos de usuário;
				 NIL					,; //10-cQuery - query a ser executada para preencher o acols(Obs. Nao pode haver MEMO);
				 NIL					,; //11-bMontCols - bloco contendo função especifica para preencher o aCols; Exmplo:{|| MontaAcols(cAlias)}
				 Iif(nCnt==0,.t.,.f.)   ,; //12-Caso inclusao inclua um registro em branco no acols
				 Nil			      	,; //13-aHeaderAux
				 Nil		      		,; //14-aColsAux
				 Nil		     	)  //15-bAfterCols
	nPosRec:=GdfieldPos("Z0_REC_WT")

    If nCnt > 0  .And. nOpcx = 3    //--Quando Inclusao e existir Registro
		Help(,,'Atenção',,OemToAnsi("Já existem metas para o período selecionado. Utilize a opção de Alteração."),1,0)
		Exit
    Elseif nCnt = 0 .And. nOpcx # 3  //--Quando Nao for Inclusao e nao existir Registro
		If cTipoUsu == 'L'
			Help(,,'Atenção',,OemToAnsi("Não existem metas para o período selecionado."),1,0)
		Else
			Help(,,'Atenção',,OemToAnsi("Não existem metas para o período selecionado. Utilize a opção de Inclusão."),1,0)
		EndIf
		Exit
	Endif
	
	// somente quando for inclusao, sequencia do dependente.
	If nCnt == 0
  	    aCols[1][1] := '01'
	EndIf

	nOpca := 0

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Monta as Dimensoes dos Objetos         					   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
		If lAltera
	   		lReadOnly := .F.
	   	Else
	   		lReadOnly := .T.
	   	EndIf
	
	
		aAdvSize		:= MsAdvSize()
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 1 , 5 }
		aAdd( aObjCoords , { 010 , 020 , .T. , .F. } )
		aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )

		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

		DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(RTRIM(cTabela)) FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL  

		@ aObjSize[1,1] , aObjSize[1,2]      GROUP oGroup TO aObjSize[1,3] ,aObjSize[1,4]*0.05 LABEL OemToAnsi("Matricula:") OF oDlg PIXEL		
		oGroup:oFont:= oFont
		@ aObjSize[1,1] , aObjSize[1,4]*0.07 GROUP oGroup TO aObjSize[1,3] ,aObjSize[1,4]*0.5  LABEL OemToAnsi("Nome:") OF oDlg PIXEL	
		oGroup:oFont:= oFont
		@ aObjSize[1,1] , aObjSize[1,4]*0.55 GROUP oGroup TO aObjSize[1,3] ,aObjSize[1,4]*0.9  LABEL OemToAnsi("Período:") OF oDlg PIXEL	
		oGroup:oFont:= oFont

		@ aObjSize[1,1]+10 , aObjSize[1,2]+05	    SAY OemToAnsi(SRA->RA_MAT)		SIZE 050,10 OF oDlg PIXEL FONT oFont
		@ aObjSize[1,1]+10 , aObjSize[1,4]*0.07+05		SAY OemToAnsi(SRA->RA_NOME) 	SIZE 146,10 OF oDlg PIXEL FONT oFont
		@ aObjSize[1,1]+10 , aObjSize[1,4]*0.55+05	SAY RDU->RDU_CODIGO + ' - ' + OemToAnsi(RDU->RDU_DESC) 	SIZE 120,10 OF oDlg PIXEL FONT oFont

		oGet			:= MSNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3] - 60,aObjSize[2,4],nOpcx,"U_APD001TOk","U_APD001TOk","+Z0_SEQ",,1,,,,"U_APDDelOk",,aHeader,aCols)
		oGet:bChange 	:= {|| U_APD001Chg(@oGet, oGet:nAt, oDlg, lReadOnly), oGet:Refresh() }

	   	bSet15	:= {||nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)}
	   	bSet24	:= {||oDlg:End()}
	   	
	   	nPosMeta	:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="Z0_META"})
	   	nPosJustif  := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="Z0_JUSTIF"}) 
	   	
	   	For nX := 1 To Len(aCols)
	   		If nX == 1
	   			If !Empty(aCols[nX][nPosMeta]) .Or. !Empty(aCols[nX][nPosJustif])
	   				cMeta 	:= aCols[nX][nPosMeta]
	   				cJustif	:= aCols[nX][nPosJustif]
	   				aAdd( aTextos, { nX, aCols[nX][nPosMeta], aCols[nX][nPosJustif] } )
	   			EndIf
	   		Else
	   			If !Empty(aCols[nX][nPosMeta]) .Or. !Empty(aCols[nX][nPosJustif])
	   				aAdd( aTextos, { nX, aCols[nX][nPosMeta], aCols[nX][nPosJustif] } )
	   			EndIf	   		
	   		EndIf  
	   	Next nX
	   		   	
	   	@ 120,001 SAY OemToAnsi('Meta: ') Of oDlg PIXEL SIZE 070,009
		oTMulti1 := TMultiget():Create(oDlg,{|u|If(Pcount()>0,cMeta:=u,cMeta)},130,01,250,50,,,,,,.T.,,,,,,lReadOnly) 		//Meta

		@ 120,280 SAY OemToAnsi('Justif Gestor: ') Of oDlg PIXEL SIZE 070,009
		oTMulti2 := TMultiget():Create(oDlg,{|u|If(Pcount()>0,cJustif:=u,cJustif)},130,280,250,50,,,,,,.T.,,,,,,lReadOnly) 	//Justif 
	   	
	   	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )

        IF nOpcA == REDIGITA
				LOOP
        ELSEIF nOpcA == CONFIRMA .And. nOpcx # 2
            Begin Transaction
                //--Gravacao
                APD001Grava(cAlias,nPosRec)
                //--Processa Gatilhos
                EvalTrigger()
            End Transaction
        Endif

	Exit
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := "SRA"
dbSelectArea(cAlias)
Go nSavRec

If nOpcx == 3    //--Quando Inclusao
   MBrChgLoop(.F.)
EndIf

Return


/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD001Grava ³ Autor ³                    ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao da SZ0                                            ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
Static Function APD001Grava(cAlias,nPosRec)
Local lLock		:=.T.
Local ny		:=	0
Local nMaxArray :=	Len(aHeader)
Local n		  	:= 0
Local wn		:= 0
Local lTravou	:= .F.

dbSelectArea(cAlias)

For n:=1 TO Len(aCols)
	lTravou:=.F.
	Begin Transaction

	If aCols[n][nPosRec] > 0 
	        MSGoto(aCols[n][nPosRec])
	        RecLock(cAlias,.F.,.T.)
		lTravou:=.T.
	Else
	    If !(aCols[n][Len(aCols[n])])
			RecLock(cAlias,.T.)
			lTravou:=.T.
		EndIf
    Endif
	If lTravou
        //--Verifica se esta deletado
        If aCols[n][Len(aCols[n])]
	        		If ( APD001ChkDel( cAlias , , , , , GetMemVar( "Z0_MAT" ), .F. ) )
			            dbDelete()
	        		EndIf
        Else
	        Replace SZ0->Z0_FILIAL WITH SRA->RA_FILIAL
	        Replace SZ0->Z0_MAT    WITH SRA->RA_MAT
	        Replace SZ0->Z0_CODPER WITH cPeriodo
        Endif
	    For ny := 1 To nMaxArray
	        cCampo    := Trim(aHeader[ny][2])
	        If  "Z0_REC_WT" # cCampo
		        xConteudo := aCols[n,ny]
		        Replace &cCampo With xConteudo
	        EndIf
	    Next ny
	Endif
	MsUnlock()
    End Transaction
Next n

Return

/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD001TOk  ³ Autor ³                     ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao TudoOK                                           ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
User Function APD001TOk()
Local nPeso  := 0
Local nMetas := 0
Local nPosSta:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_STATUS"})
Local nPosMet:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_META"})
Local nPosPes:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_PESO"})
Local nZ

For nZ  := 1 to len(aCols)
	cStatus:= aCols[nZ,nPosSta]
	If cStatus == '1'
		If empty(aCols[nZ,nPosMet])
			Help(,,'Atenção',,OemToAnsi("A descrição da meta não pode ficar sem conteúdo."),1,0)
			Return(.f.)
			Exit
		ElseIf empty(aCols[nZ,nPosPes])
			Help(,,'Atenção',,OemToAnsi("O peso não pode ficar sem conteúdo."),1,0)
			Return(.f.)
			Exit
		Else	
			nPeso  += aCols[nZ,nPosPes]
			nMetas++
		EndIf
	ElseIf cStatus == '3' //Calculado
		Help(,,'Atenção',,OemToAnsi("Este período de avaliação já encontra-se calculado. Cancele esta operação."),1,0)
		Return(.f.)
		Exit
	EndIf
Next nZ
If nMetas > nLimMeta
	Help(,,'Atenção',,OemToAnsi("O limite de quantidade de Metas ativas por período já atingiu o limite máximo de "+strzero(nLimMeta,3)+"."),1,0)
	Return(.f.)
ElseIf nPeso > nLimPeso
	Help(,,'Atenção',,OemToAnsi("O somatório dos Pesos dos registros ativos já atingiu o limite máximo de "+strzero(nLimPeso,3)+"."),1,0)
	Return(.f.)
EndIf
			
Return(.t.)


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Menu Funcional

@return aRotina - Estrutura
[n,1] Nome a aparecer no cabecalho
[n,2] Nome da Rotina associada
[n,3] Reservado
[n,4] Tipo de Transação a ser efetuada:
1 - Pesquisa e Posiciona em um Banco de Dados
2 - Simplesmente Mostra os Campos
3 - Inclui registros no Bancos de Dados
4 - Altera o registro corrente
5 - Remove o registro corrente do Banco de Dados
6 - Alteração sem inclusão de registros
7 - Cópia
8 - Imprimir
[n,5] Nivel de acesso
[n,6] Habilita Menu Funcional
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina :=  {}

	aadd( aRotina, { "Pesquisar"  , "PesqBrw" 	 , 	0 , 1,,.F.} )
	aadd( aRotina, { "Visualizar" , "U_APD001Atu", 	0 , 2} )
	aadd( aRotina, { "Incluir" 	  , "U_APD001Atu",	0 , 3} )
	aadd( aRotina, { "Alterar" 	  , "U_APD001Atu",	0 , 4} )
	aadd( aRotina, { "Legenda"	 , "GpLegend"   ,	0 , 7 , ,.F.} )

Return aRotina


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³APD001ChkDel ³Autor³                      ³ Data ³09/01/2013³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Verifica se os Registros podem ser Deletados                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³           	                                                ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APD001ChkDel(	cAlias		,;	//Alias do Arquivo Principal
								nReg		,;	//Recno do Arquivo Principal
								nOpcx		,;	//Opcao do Arquivo Principal
								cCodigo		,;	//Chave para Exclusao (Sem a Filial)
								lBtExclui    ;
							   )

Local aAreas		:= {}
Local aNotSx9Check	:= {}
Local cKeyDel		:= ""
Local lChkDelOk 	:= .T.
Local nPosRec		:= GdfieldPos("Z0_REC_WT")
Local nRegOr		:= 0
Local nRegDe		:= 0
Local aRecnos		:= {}

DEFAULT cAlias		:= Alias()
DEFAULT nReg		:= ( cAlias )->( Recno() )
DEFAULT nOpcx		:= 5
DEFAULT cCodigo		:= ""

( cAlias )->( MsGoto( nReg ) )
cKeyDel	:= cCodigo

If lBtExclui
	For nRegOr := 1 To Len(Acols)
		If !Acols[nRegOr,nPosRec+1]
			aAdd( aRecnos, Acols[nRegOr,nPosRec] )
		EndIf
	Next nRegOr
Else
	aAdd( aRecnos, nReg )
EndIf

For nRegDe := 1 To Len( aRecnos )

	lChkDelOk  := ChkDelRegs(	cAlias					,;	//Alias do Arquivo Principal
								aRecnos[nRegDe]			,;	//Registro do Arquivo Principal
								nOpcx					,;	//Opcao para a AxDeleta
								xFilial( cAlias )		,;	//Filial do Arquivo principal para Delecao
								NIL						,;	//Chave do Arquivo Principal para Delecao
								aAreas					,;	//Array contendo informacoes dos arquivos a serem pesquisados
								NIL						,;	//Mensagem para MsgYesNo
								NIL						,;	//Titulo do Log de Delecao
								NIL						,;	//Mensagem para o corpo do Log
								.F.				 		,;	//Se executa AxDeleta
								.T.						,;	//Se deve Mostrar o Log
								NIL						,;	//Array com o Log de Exclusao
								NIL				 		,;	//Array com o Titulo do Log
								NIL						,;	//Bloco para Posicionamento no Arquivo
								NIL						,;	//Bloco para a Condicao While
								NIL						,;	//Bloco para Skip/Loop no While
								NIL						,;	//Verifica os Relacionamentos no SX9
								aNotSx9Check			,;	//Alias que nao deverao ser Verificados no SX9
								NIL				 	 	,;	//Se faz uma checagem soft
								.f.				 		 ;  //Se esta executando rotina automatica
							)

	If !lChkDelOk
		Exit
	EndIf
Next nRegDe

Return( lChkDelOk  )



/*/       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fVerRDU    ³ Autor ³                     ³ Data ³12/01/2016³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do periodo selecionado                           ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/   
Static Function fVerRDU()

RDU->(dbsetorder(1))
If RDU->(dbseek(xFilial("RDU",SRA->RA_FILIAL)+cPeriodo))
	If RDU->RDU_TIPO <> '3' 
		Alert("Este período não se refere a avaliação por metas.")
		Return(.f.)
	EndIf
Else
	Alert("Período inválido.")
	Return(.f.)
EndIf
Return(.t.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ SZ0When    ³ Autor ³                   ³ Data ³ 15/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ When da tabela SZ0                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SZ0When()
	Local lRet 		:= .T.
	Local cStatus	:= aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_STATUS"})]
	Local cCpo		:= alltrim(substr(readvar(),4,10))
	
//	varinfo("readvar=",readvar())
	If cStatus <> "1" //Nao permite quando status diferente de 1=ativo
		lRet := .f.
	ElseIf cTipoUsu == 'L' //Usuario logado editando as suas metas proprias
		lRet := .F.
	ElseIf cCpo $ "Z0_RESULT|" //Campos que nunca serão mostrados
		lRet := .F.
 	Else //Gestor editando as metas da sua equipe
		If cCpo $ "Z0_META|Z0_PESO|Z0_PERC|Z0_STATUS|Z0_JUSTIF"
			If cCpo $ "Z0_PERC|" .and. !lResult
				lRet := .f.
			ElseIf cCpo $ "Z0_META|Z0_PESO|Z0_STATUS" .and. !lAltera
				lRet := .f.
			EndIf			
		Else
 			lRet := .F.
 		EndIf
	EndIF
Return lRet  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ SZ0Val     ³ Autor ³                   ³ Data ³ 15/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Validacoes dos campos da tabela SZ0                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SZ0Val()
	Local lRet 		:= .T.
	Local nPos	 := aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_STATUS"})
	Local cCpo		:= alltrim(substr(readvar(),4,10))
	Local uConteudo := &(readvar())
	Local nZ
	Local nPeso		:= 0
	
//	varinfo("readvar=",readvar())
	If aCols[n,nPos] <> '1' //Status diferente de ativo
		Help(,,'Atenção',,OemToAnsi("Somente registros com status 1-Ativo podem ser alterados."),1,0)
		lRet := .f.
	ElseIf empty(uConteudo) .and. cCpo $ 'Z0_META'
		Help(,,'Atenção',,OemToAnsi("Este campo não pode ficar sem conteúdo."),1,0)
		lRet := .f.
	ElseIf cCpo == 'Z0_PESO'
		For nZ := 1 to len(aCols)
			cStatus:= aCols[nZ,nPos]
			If cStatus == '1'
				If n == nZ
					nPeso += uConteudo
				Else
					nPeso += aCols[nZ,aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_PESO"})]
				EndIf
			EndIf
		Next nZ
		If nPeso > nLimPeso
			Help(,,'Atenção',,OemToAnsi("O somatório dos Pesos dos registros ativos ultrapassam o limite máximo de "+strzero(nLimPeso,3)+"."),1,0)
			lRet := .f.
		EndIf					
	ElseIf cCpo == 'Z0_PERC'
		If uConteudo < 0 .or. uConteudo > 100
			Help(,,'Atenção',,OemToAnsi("O percentual deve estar entre 0% e 100%."),1,0)
			lRet := .f.
		EndIf
	ElseIf cCpo == 'Z0_STATUS'
		If !(uConteudo $ '12')
			Help(,,'Atenção',,OemToAnsi("Utilize somente status 1-Ativo ou 2-Cancelado."),1,0)
			lRet := .f.
		EndIf
	EndIf

Return lRet  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ APDDelOk³ Autor ³                   ³ Data ³ 15/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Função para não permitir a deleção dos acols na NewGetDados ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function APDDelOk
Return .F.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ APD001Chg³ Autor ³                   ³ Data ³ 15/01/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ BChange da NewGetDados para atualizar gets de meta e justif ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function APD001Chg(oGetDados, nLinha, oDlg, lReadOnly)

Local nPosMeta		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="Z0_META"})
Local nPosJustif  	:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="Z0_JUSTIF"}) 

cMeta 		:= aCols[nLinha][nPosMeta]
oTMulti1 	:= TMultiget():Create(oDlg,{|u|If(Pcount()>0,cMeta:=u,cMeta)},130,01,250,50,,,,,,.T.,,,,,,lReadOnly) 		//Meta	
	
cJustif 	:= aCols[nLinha][nPosJustif]
oTMulti2 	:= TMultiget():Create(oDlg,{|u|If(Pcount()>0,cJustif:=u,cJustif)},130,280,250,50,,,,,,.T.,,,,,,lReadOnly) 	//Justif	
		
Return
