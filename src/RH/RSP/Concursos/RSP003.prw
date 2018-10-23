#include "Protheus.Ch"
#include "MSOle.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RSP003   º Autor ³ Marcos Pereira     º Data ³  01/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Convocação de candidatos com integração Word               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RSP003()
Local nOpcA := 0

Private cCadastro 	:= "Geração de arquivo Word para Convocação de Candidatos"
Private aSay 		:= {}
Private aButton 	:= {}
Private cFileOpen 	:= ""
Private cPerg 		:= "RSP003"

AjPerg(cPerg)
Pergunte(cPerg,.F.)
cFileOpen := MV_PAR03

aAdd( aSay, "Esta rotina irá gerar o documento word para convocação de candidatos." )

aAdd( aButton, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
aAdd( aButton, { 1,.T.,{|| nOpca := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpcA == 1
	Processa( {|| ImpWord() }, "Processando..." )
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpWord  º Autor ³ Marcos Pereira     º Data ³  01/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Criacao das variaveis e merge no Word                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpWord()

Local cFileSave := ""
Local cConcurso, dConvoc, cChaveSQG, cChaveSZ3, nPos
local nTotLin, nTotCmp, nXa, nXb, nX
Local cCamp
Local aMaster 	:= {}				    
Local aAux		:= {}
Local aAux2		:= {}
Local aSZ3		:= {}
Local cIndicador:= "RSP003"  //Indicador que deve ser criado no .DOT na posição inicial onde deverão ser gerados os registros
Private oWord     := Nil

cConcurso := MV_PAR01
dConvoc	  := MV_PAR02
cFileOpen := MV_PAR03

If empty(dConvoc) .or. empty(cConcurso) .or. empty(cFileOpen)
	MsgAlert("Todas as perguntas são de preenchimento obrigatório.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If left(cFileOpen,1) == '\'
	nPos := Rat("\",cFileOpen)
	If nPos > 0
		cArqLoc := AllTrim(Subst(cFileOpen, nPos+1,200 ))
	Else 
		cArqLoc := cFileOpen
	EndIF
	cPath := GETTEMPPATH()
	If Right( AllTrim(cPath), 1 ) != "\"
	   cPath += "\"
	Endif
	If !CpyS2T(cFileOpen, cPath, .T.)
		Return
	Endif
Else
	cArqLoc := cFileOpen
	cPath	 := ''
EndIf


cChaveSZ3 := xFilial("SZ3") + cConcurso
SZ3->(dbsetorder(1))
If SZ3->(dbseek(cChaveSZ3))
	While SZ3->(!eof()) .and. SZ3->(Z3_FILIAL+Z3_CODIGO) == cChaveSZ3
		If SZ3->Z3_STATUS == '1'
			cEspec := alltrim(FDESC("SQ3",SZ3->Z3_CARGO,"Q3_XESPECI")) 
			aadd(aSZ3,{SZ3->Z3_CARGO,SZ3->Z3_CARGO2,alltrim(FDESC("SQ3",SZ3->Z3_CARGO,"Q3_DESCSUM")) + if(empty(cEspec),""," - " + cEspec) + if(empty(SZ3->Z3_DCARGO2),""," - " + SZ3->Z3_DCARGO2) })
		EndIf
		SZ3->(dbskip())
	EndDo
EndIf

If len(aSZ3) == 0
	Alert("Não existem cargos configurados no cadastro do concurso selecionado.")
	Return
EndIf

cChaveSQG := xFilial("SQG")+cConcurso
SQG->(dbSetOrder(RetOrder("SQG","QG_FILIAL+QG_XCODCON+QG_CODFUN+QG_CIC")))
SQG->(dbseek(cChaveSQG))

While SQG->(!eof()) .and. SQG->(QG_FILIAL+QG_XCODCON) == cChaveSQG
	if SQG->QG_SITUAC $ '001/FUN' .and. SQG->QG_TPCURRI == '3' .and. SQG->QG_XDTCONV == dConvoc .and. empty(SQG->QG_XDTDESI) 
		nPos := aScan(aSZ3,{|x| x[1] == SQG->QG_CODFUN .and. x[2] == SQG->QG_XCARGO2})
		If nPos > 0
			aadd(aAux,{	alltrim(aSZ3[nPos,2])+' - '+alltrim(aSZ3[nPos,3]), SQG->QG_XINSCRI, alltrim(SQG->QG_NOME), SQG->QG_RG, SQG->QG_XCLASSI } )
		EndIf
	EndIf
	SQG->(dbskip())
EndDo

If len(aAux) == 0
	MsgAlert("Não foram encontradas convocações para o Concurso e Data informados.")
	Return
EndIf

//Ordena por Concurso e Classificacao
aSort( aAux,,, { |x,y| x[1]+strzero(x[5]) < y[1]+strzero(y[5]) } )

For nX := 1 to Len(aAux)
	aadd(aAux2,aAux[nX,1])				//1-Cargo
	aadd(aAux2,aAux[nX,2])				//2-Inscricao
	aadd(aAux2,aAux[nX,3])				//3-Nome
	aadd(aAux2,aAux[nX,4])				//4-RG
	aadd(aAux2,aAux[nX,5])				//5-Classificação
Next nX

aadd(aMaster,aAux2)																	

oWord := OLE_CreateLink()
OLE_NewFile( oWord, cPath+cArqLoc )

nTotLin	:= len(aMaster)
nTotCmp	:= 0

if nTotLin > 0
	nTotCmp	:= len(aMaster[1])
	OLE_SetDocumentVar( oWord, 'IndTab' , cIndicador )		// Nome do indicador da tabela
	OLE_SetDocumentVar( oWord, 'TLinhas' , nTotLin ) 		// Numero de linhas da tabela 
	OLE_SetDocumentVar( oWord, 'TCampos' , nTotCmp ) 		// Numero de campos da tabela 				
	
	FOR nXa := 1 TO nTotLin                                
		FOR nXb:= 1 TO nTotCmp
			cCamp := cIndicador+"_L" + allTrim(Str(nXa)) + "C" + allTrim(Str(nXb)) 
			OLE_SetDocumentVar( oWord, cCamp , aMaster[nXa][nXb] )
		NEXT nXb
	NEXT nXa 
	 
	OLE_ExecuteMacro( oWord , "CRIATAB" ) //A macro CRIATRAB deverá existir como DOT - A macro está copiada no fical deste fonte
	
endif

MsgAlert("Documento gerado no Word. Verifique o conteúdo na janela aberta no Word e salve o documento. Não feche esta janela antes de salvar o arquivo.")

//Encerrando o Link com o Documento                                      ?
OLE_CloseLink( oWord )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AjPerg   ³ Autor ³                        ³Data ³ 05.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Verificacao de Perguntas                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjPerg()

Local j, i
Local _sAlias := Alias()
Local aHelp		:= 	{}
	
dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
aHelp :={" Informe ou selecione o Concurso ",;
		 " para o qual deseja selecionar ",;
		 " os candidatos com agenda de ",;
		 " convocação já criada."	}
aAdd(aRegs,{cPerg,'01','Concurso ?                    ','','','mv_ch1','C',10,0,0,'G','ExistCpo("SZ2")             ','mv_par01','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','SZ2','','',aHelp})
aHelp :={" Informe a data de convocação a ",;
		 " ser utilizada como filtro. Serão ",;
		 " selecionados os candidatos que ",;
		 " possuírem essa data no campo de ",;
		 " data de convocação em seu currículo."	}
aAdd(aRegs,{cPerg,'02','Data de Convocação ?          ','','','mv_ch2','D',08,0,0,'G','NaoVazio()                  ','mv_par02','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Selecione o arquivo modelo do Word."	}
aAdd(aRegs,{cPerg,'03','Arquivo modelo do Word ?      ','','','mv_ch3','C',99,0,0,'G','U_fRsp3W()                  ','mv_par03','               ','','','','','        	      ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})

ValidPerg(aRegs,cPerg,.T.)

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fRsp3W   ³ Autor ³                        ³Data ³ 05.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Selecao do arquivo DOT                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fRsp3W()

Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Modelo Word | *.dot"

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diretório inicial se necessário
 * <ExpL1> - .F. botão salvar - .T. botão abrir
 * <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
 */
cFileOpen := cGetFile(cExtens,cTitulo1,,,.T.)
MV_PAR03 := cFileOpen
Return(cFileOpen)



// Macro que deverá ser incluida no .DOT
/*
Sub CRIATAB()
Dim IndTab  As String
Dim TLinhas As Integer
Dim TCampos As Integer
Dim cCampo  As String
Dim nXa As Integer
Dim nXb As Integer
Dim oFnt As Object

IndTab = ActiveDocument.Variables.Item("IndTab").Value
TLinhas = ActiveDocument.Variables.Item("TLinhas").Value
TCampos = ActiveDocument.Variables.Item("TCampos").Value

If IndTab <> "" And TLinhas > 0 And TCampos > 0 Then
    Selection.GoTo What:=wdGoToBookmark, Name:=IndTab
    Selection.Find.ClearFormatting
    With Selection.Find
        .Text = ""
        .Replacement.Text = ""
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With

    For nXa = 1 To TLinhas
        For nXb = 1 To TCampos
            ' Insere uma nova celula na tabela
            If Not (nXa = 1 And nXb = 1) Then
                Selection.MoveRight Unit:=wdCell
            End If
            ' Insere a variavel a celula
            cCampo = "DOCVARIABLE " & IndTab & "_L" & Trim(Str(nXa)) & "C" & Trim(Str(nXb))
            Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:=cCampo, PreserveFormatting:=True
        Next nXb
    Next nXa
End If

End Sub
*/

