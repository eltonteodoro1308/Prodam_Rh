#INCLUDE "PROTHEUS.CH"
#INCLUDE "APDM010.CH"

Static lAPD010VQ := ExistBlock( "APD010VQ" )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³APDM010     ³ Autor ³ Eduardo Ju              ³ Data ³ 17.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calculo do Resultado da Avaliacao a partir das Avaliacoes       ³±±
±±³          ³e/ou Avaliados selecionados (Miscelanea).                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³BOPS       ³Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cecilia Car.³04/07/2014³TPZWF1     ³Incluido o fonte da 11 para a 12 e efe-³±±
±±³            ³          ³           ³tuada a limpeza.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*/{Protheus.doc} APDM010
Calculo do Resultado da Avaliacao a partir das Avaliacoes
e/ou Avaliados selecionados (Miscelanea).
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 22/10/2018
/*/
Function APDM010()

Local cFiltra		:= ""			//Variavel para filtro
Local aIndFil		:= {}			//Variavel Para Filtro
Private bFiltraBrw 	:= {|| Nil}		//Variavel para Filtro
Private aRotina := MenuDef() // ajuste para versao 9.12 - chamada da funcao MenuDef() que contem aRotina

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := OemtoAnsi(STR0017)	//"Cálculo do Resultado da Avaliação"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RD6")
dbSetOrder(1)

cFiltra 	:= CHKRH(FunName(),"RD6","1")
bFiltraBrw 	:= {|| FilBrowse("RD6",@aIndFil,@cFiltra) }
Eval(bFiltraBrw)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RD6")
dbGoTop()

mBrowse(6, 1, 22, 75, "RD6")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta o filtro utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("RD6",aIndFil)

dbSelectArea("RD9")//Itens Avaliacoes versus Avaliados
dbSetOrder(1)

dbSelectArea("RD6")//Avaliacoes
dbSetOrder(1)

dbSelectArea("RDC")//Itens Envio Envio/Retorno Avaliacoes
dbSetOrder(1)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³APD010SX1 ³ Autor ³Eduardo Ju             ³ Data ³17.03.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajuste do SX1 para Calculo da Avaliacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD010SX1                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function APDM010Perg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                                    ³
//³mv_par01		//"Avaliacao De"                                           ³
//³mv_par02		//"Avaliacao Ate"                                          ³
//³mv_par03		//"Avaliado De"                                            ³
//³mv_par04		//"Avaliado Ate"                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
Pergunte("APM010",.T.)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³APDM010CALCM³ Autor ³ Eduardo Ju		    ³ Data ³ 18.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calculo do Resultado da Avaliacao de acordo com as          ³±±
±±³          ³Avaliacoes e Avaliados selecionados pelo Usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³1- cAlias                                                   ³±±
±±³          ³2- nReg                                                     ³±±
±±³          ³3- nOpc                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function APDCALCM(cAlias,nReg,nOpc)

  /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ A partir da Rotina Calculo das Avaliacoes em Miscelanea  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	APDM010CALC(cAlias,nReg,nOpc,1)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³APDM010CALC ³ Autor ³ Eduardo Ju		      ³ Data ³ 17.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calculo do Resultado por Questao e por Item de Competencia. 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³1- cAlias - Alias                                            	³±±
±±³          ³2- nReg - Registro                                           	³±±
±±³          ³3- nOpc - Opcao                                              	³±±
±±³          ³4- nTipo (1, 2 ou 3)                                        	³±±
±±³          ³	1- Calculo a partir das Avaliacoes e Avaliados Selecionados ³±±
±±³          ³ na rotina de 'Calcular Avaliacao' em Miscelanea.             ³±±
±±³          ³	2- Calculo a partir da Avaliacao Corrente na rotina de      ³±±
±±³          ³ 'Calcular' em Avalicao (Montagem).                           ³±±
±±³          ³	3- Calculo a partir do Avaliado Corrente atraves do Botao   ³±±
±±³          ³ 'Calcular Avaliacao' na Avaliacao+Montagem+Avaliados.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function APDM010CALC(cAlias,nReg,nOpc,nTipo,lGeraLog)

Local aArea				:= GetArea()
Local aSays				:= {}
Local aButtons			:= {}
Local nOpca 			:= 0

Local cFunction		:= "APDM010"
Local cTitle    	:= OemtoAnsi(STR0017)	//"Cálculo do Resultado da Avaliação"
Local bProcess	  	:= {|oSelf| APDACalculo( cAlias, nReg, nTipo, oSelf,@lGeraLog)}
Local cDescription	:=	OemToAnsi(STR0001) +" "+; //"Cálculo das Médias "
						OemToAnsi(STR0002) +" "+; //"Efetua Cálculo das Médias do Avaliado e gera "
						OemToAnsi(STR0003)        //"arquivo de Log mostrando os resultados obtidos. "

Private cCodAvaliacao	:= RD6->RD6_CODIGO
Private cPerg           := ""
Private lRelease11		:= (GetRpoRelease("R1.1"))

DEFAULT lGeraLog	:=	.F.

If nTipo == 1
	cPerg := "APM010"
Elseif nTipo=2
	cPerg := "APDM10"
EndIf

If  lRelease11

	/*

	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ+ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica  Retorno das  avaliacoes  e mostra log de ocorrencias     |
	³ de acordo com  parametro desejado                                  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Pergunte(cPerg, .F. )
	If nTipo == 3
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Executa o Processo de Calculo das Medias caso Avaliacao estiver ativa     |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If fAvalAtivo(nReg)
			Processa( {|| APDACalculo( cAlias, nReg, nTipo ) } )
    	Endif
	Else
		tNewProcess():New(cFunction,cTitle,bProcess,cDescription,cPerg,,,,,,.T.)
	Endif

	If ( (lGeraLog) .AND. (fVerRetorno(nTipo)) )

		FMakeLog( { aLog } , aLogTitle , , NIL , NIL , cTitulo,"M","P",,.F., cAlias )
		lGeraLog	:=	.F.

	EndIf
Else
	If nTipo <> 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as perguntas selecionadas                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte(cPerg, .F. )

		AADD(aSays,OemToAnsi(STR0001) )
		AADD(asays,OemToAnsi(STR0002) )
		AADD(asays,OemToAnsi(STR0003) )
		AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
		AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
		AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
		FormBatch(OemToAnsi(STR0004) , aSays, aButtons )
	Else
		nOpca := 1 //Calcular Avaliacao
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica  Retorno das  avaliacoes  e mostra log de ocorrencias     |
	³ de acordo com  parametro desejado                                  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	If 	nOpca = 1 .and. fVerRetorno( nTipo )
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Executa o Processo de Calculo das Medias caso Avaliacao estiver ativa     |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If fAvalAtivo(nReg)
			Processa( {|| APDACalculo( cAlias, nReg, nTipo ) } )
	    Endif
	Endif
EndIf

RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAvalAtivo  ºAutor  ³Microsiga           º Data ³  27/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica retorno das avaliacoes                               º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fAvalAtivo(nReg,nTipo)

Local lAtivo	:= .T.

RD6->(dbGoTo(nReg))

If RD6->RD6_STATUS <>"1"
	If nTipo <> 1
		AVISO("",OemToAnsi(STR0012),{"Ok"} ) 	//-- "Nao e possivel efetuar o Calculo das Medias. Avaliacao ja foi encerrada. "
		lAtivo	:= .F.
	Else  //Quando rotina de Calcular em Miscelanea, nao eh mostrado o Aviso
		lAtivo	:= .F.
	EndIf
Endif

Return (lATivo)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVerRetorno ºAutor  ³Microsiga           º Data ³  10/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica retorno das avaliacoes                               º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerRetorno(nTipo)

Local nOpcCalc		:= 1.00
Private cAvaliaDe	:= ""
Private cAvaliaAte	:= ""
Private cAdoDe 		:= ""
Private cAdoAte		:= ""
Private cAvalDe		:= ""
Private cAvalAte	:= ""
Private nLogOcorr	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe os valores dos Parametros para Calculo em Miscelanea  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 1
	cAvaliaDe	:= mv_par01
	cAvaliaAte	:= mv_par02
	cAdoDe 		:= mv_par03
	cAdoAte		:= mv_par04
	nLogOcorr   := mv_par05
ElseIf nTipo == 2
	cAvalDe		:= mv_par01
	cAvalAte	:= mv_par02
	nLogOcorr	:= mv_par03
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Gera e mostra arquivo de Log de Ocorrencias
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If nLogOcorr = 1 // -- Sim

	fAPDAGeraLog(nTipo)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Apresenta Tela de escolha :   Pergunta se efetua calculo independente de todas as  |
	³avaliacoes terem  retornados ou nao                                                |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ApdaLogCalc(@nOpcCalc)

Endif
Return ( if(nOpcCalc=1,.T.,.F.) )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAPDAGeraLogºAutor  ³Microsiga           º Data ³  10/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica retorno das avaliacoes                               º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fAPDAGeraLog(nTipo,lGeraLog)

Local nCountRet		:= nCountNaoRet	:= 0
Local cAvaliado 	:= ""
Static aLogTitle		:=	{}
Static aLog 			:=	{}
Static cTitulo 		:= OemToAnsi(STR0006)
DEFAULT lGeraLog	:=	.F.


	aAdd(aLogTitle , space(5) + OemToAnsi(STR0007) )
	//--123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//-- 999999 - -XXXXXXXX(Avaliado )XXXXXXXX
	//--     Avaliador                              Rede                              Dt Envio      Dt Retorno"
	//--     999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/9999    99/99/9999
   	//--                                            Total Geral ...                   9999          9999
	aAdd(aLog,OemToAnsi(STR0004))
	aAdd(aLog, cCodAvaliacao  + space(2)  + fDesc( "RD6",cCodAvaliacao, "RD6_DESC" ) )
	aAdd(aLog,  " ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o retorno das Avaliacoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo <> 1
		DbSelectarea("RDC")
		If dbSeek(xFilial("RDC") + cCodAvaliacao, .F. )
			While  !RDC->(Eof() ) .and. xFilial("RDC") + cCodAvaliacao = RDC->RDC_FILIAL + RDC->RDC_CODAVA .and. ;
				RDC->RDC_CODADO >= cAvalDe .and. RDC->RDC_CODADO  <= cAvalAte
				If cAvaliado  # RDC->RDC_CODADO
					aAdd(aLog,RDC->RDC_CODADO + "-" + fDesc( "RD0" ,RDC->RDC_CODADO , "RD0_NOME" )  )
					cAvaliado 	:= RDC->RDC_CODADO
	 	        Endif
				If !empty(RDC_DATRET)
					nCountRet++
				Endif
				If !empty(RDC_DATENV)
					nCountNaoRet++
				Endif
				aAdd(aLog,space(5) + RDC->RDC_CODDOR + "-" + fDesc( "RD0" ,RDC->RDC_CODDOR , "RD0_NOME" ) + ;
				                      RDC->RDC_CODNET + "-" + fDesc( "RD1" ,RDC->RDC_CODNET , "RD1_DESC" )+  space(1) + ;
				                      dtoc(RDC->RDC_DATENV)+ space(6) + dtoc(RDC->RDC_DATRET)  )
				RDC->( dbSkip() )
			Enddo
		Endif
	Else
		//EM ANALISE -> Em primeira instancia, nao considerado
		DbSelectarea("RDC")
		If dbSeek(xFilial("RDC") + cAvaliaDe + cAdoDe, .F.)
			While  !RDC->(Eof() ) .And. RDC->RDC_CODAVA >= cAvaliaDe .And. RDC->RDC_CODAVA <= cAvaliaAte .And. ;
				RDC->RDC_CODADO >= cAdoDe .And. RDC->RDC_CODADO  <= cAdoAte

				If cAdoDe  # RDC->RDC_CODADO
					aAdd(aLog,RDC->RDC_CODADO + "-" + fDesc( "RD0" ,RDC->RDC_CODADO , "RD0_NOME" )  )
					cAdoDe 	:= RDC->RDC_CODADO
	 	        Endif
				If !empty(RDC_DATRET)
					nCountRet++
				Endif
				If !empty(RDC_DATENV)
					nCountNaoRet++
				Endif
				aAdd(aLog,space(5) + RDC->RDC_CODDOR + "-" + fDesc( "RD0" ,RDC->RDC_CODDOR , "RD0_NOME" ) + ;
				                      RDC->RDC_CODNET + "-" + fDesc( "RD1" ,RDC->RDC_CODNET , "RD1_DESC" )+  space(1) + ;
				                      dtoc(RDC->RDC_DATENV)+ space(6) + dtoc(RDC->RDC_DATRET)  )
				RDC->( dbSkip() )
			Enddo
		Endif
	EndIf

	//-- Total Geral
	aAdd(aLog,  " ")
	aAdd(aLog, SPACE(45) + OemToAnsi(STR0008) +space(19)+ StrZero(nCountRet,4) + space(10)+  StrZero(nCountNaoRet,4)  )

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Gera e Mostra o Log 										  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//Obs.: Gera-se logo somente para tipo 2 e 3. Para tipo 1, gerado log na rotina de Calculo.
	If ( lGeraLog ) .AND. ( nTipo <> 1 )
		FMakeLog( { aLog } , aLogTitle , , NIL , NIL , cTitulo,"M","P",,.F. )
	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APDALogCalc ºAutor  ³Microsiga           º Data ³  10/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                              º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function APDALogCalc(nOpcCalc)

Local bSvSet15	:= { || NIL }
Local bSvSet24	:= { || NIL }
Local oRadioCalc
Local oDlg
Local oGroupCalc
Local oFont
Local cTexto	:= ""
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aGDCoord		:= {}

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Monta as Dimensoes dos Objetos         					   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aAdvSize		:= MsAdvSize()
aAdvSize[5]	:=	(aAdvSize[5]/100) * 70	//horizontal
aAdvSize[6]	:=  (aAdvSize[6]/100) * 50	//Vertical
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )
aGdCoord	:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*50), (((aObjSize[1,4])/100)*62) }	//1,3 Vertical /1,4 Horizontal

SetaPilha()
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001 ) FROM  aAdvSize[7],20 TO aAdvSize[6]-50,460  OF oMainWnd PIXEL //094,001 TO 250,400

	@ aGdCoord[1]+5 , aGdCoord[2]	GROUP oGroupCalc TO (aGdCoord[3]/1.5),aGdCoord[4]+10  LABEL OemToAnsi(STR0011) OF oDlg PIXEL //"Selecione o Objeto da Pesquisa"
	oGroupCalc:oFont:=oFont
	@ aGdCoord[1]+15,aGdCoord[2]+10	RADIO oRadioCalc VAR nOpcCalc 	ITEMS 	OemToAnsi(STR0009), ;			//--Sim //030,010
														OemToAnsi(STR0010)  ;			//--Nao
				SIZE 100,010 OF oDlg PIXEL

	oDlg:bSet15 := { || oDlg:End() }
	bSvSet15 := SetKey( 15 , oDlg:bSet15 )
	oDlg:bSet24 := { || nOpcCalc := 0 , oDlg:End() }
	bSvSet24 := SetKey( 24 , oDlg:bSet24 )

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , oDlg:bSet15 , oDlg:bSet24 )

SetaPilha()
SetKey( 15 , bSvSet15 )
SetKey( 24 , bSvSet24 )

Return nOpcCalc

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APDACalculo ºAutor  ³Microsiga           º Data ³  10/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo das Medias                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function APDACalculo(cAlias, nReg, nTipo, oSelf , lGeraLog )

Local aOpenFile 		:= {"RD5"}

//--Variaveis Getdados
Local cKey			:= ""
Local bSkip			:= NIL
LocaL bKey			:= NIL
Local aVisual		:= {}
Local aVirtGd		:= {}
Local aRecnos		:= {}
Local aNotFields	:= {}

//-- Variaveis para calculo
Local aVlrQuestao 	:= {}               //-- Array contendo os valores obtidos de cada Questao
Local aMediaItemNet	:= {}				//-- Array contendo a Media por competencia / Rede
Local aTotItemNet	:= {}				//-- Array contendo a pontuação máxima por item de competencia
Local aLogMsg		:= {}				// Array para armazenar mensagem de falha de calculo

Local cTitulo 		:= OemToAnsi(STR0006)

Local  lRetRd6		:= .T.

PRIVATE	aTpAvaliacao:= {}
PRIVATE	aRede     	:= {}

DEFAULT lGeraLog		:=.F.

dbSelectArea( "RD5" )

dbSelectArea( "RD6" )

If nTipo =1         // Miscelancia (Ranger de avaliacao e avaliadao)
	cAvaliaDe		:= mv_par01
	cAvaliaAte		:= mv_par02
	cAdoDe 			:= mv_par03
	cAdoAte	  		:= mv_par04
	nLogOcorr 		:= mv_par05
	cCodAvaliacao	:= cAvaliaDe
    bWhile			:= {|| RD6->RD6_CODIGO >= cAvaliaDe .AND.RD6->RD6_CODIGO  <= cAvaliaAte }
ElseIf nTipo=2		// Montagem (Ranger de avaliados)
	cAdoDe 			:= mv_par01
	cAdoAte  		:= mv_par02
	nLogOcorr		:= mv_par03
	cCodAvaliacao	:= RD6->RD6_CODIGO
    bWhile			:= {|| RD6->RD6_CODIGO==cCodAvaliacao}
ElseIf nTipo=3 		// Montagem ( botao de calculo somente de um avaliado)
	cAvaliaDe			:= RD9->RD9_CODAVA
	cAvaliaAte			:= RD9->RD9_CODAVA
	cAdoDe 				:= RD9->RD9_CODADO
	cAdoAte				:= RD9->RD9_CODADO
	nLogOcorr           := 0
	cCodAvaliacao		:= RD9->RD9_CODAVA
    bWhile				:= {|| RD6->RD6_CODIGO==cCodAvaliacao}
EndIf

RD5->(dbSetOrder(1))
RD5->(dbSeek(xFilial("RD5")+cCodAvaliacao))

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ GETDADOS							                         ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Private aHeader[0], aCols[0], nUsado:=0

If nTipo <> 1
	dbSelectArea( "RD6" )
	RD6->(dbGoTo(nReg))
Else
 	RD6->(dbSetOrder(1))
	RD6->( dbSeek(xFilial("RD6") + cAvaliaDe, .T. ) )
EndIf

aLogMsg	:={}

If nTipo == 3  .or. !lRelease11
	ProcRegua( RD6->( Reccount() ) )
Else
	oSelf:SetRegua1(RD6->( Reccount() ))
	oSelf:SaveLog(STR0001 + " - " + STR0020)	//"Inicio do Processamento"
EndIf

While !RD6->( Eof() ).And. Eval(bWhile)

	If nTipo == 3 .or. !lRelease11
		IncProc(OemToAnsi(STR0018)+": "+RD6->RD6_CODIGO)
	Else
		oSelf:IncRegua1(OemToAnsi(STR0018)+": "+RD6->RD6_CODIGO)
	EndIf

	If RD6->RD6_STATUS <> "1"

		If nTipo <> 1
			AVISO("",OemToAnsi(STR0012),{"Ok"} ) 				//-- "Nao e possivel efetuar o Calculo das Medias. Avaliacao ja foi encerrada. "
			lAtivo	:= .F.
		Else
			lAtivo	:= .F.
		EndIf

    Else

    	If nLogOcorr == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Alimenta Log com as avaliacoes as quais os avaliados estavam com o RDB possivelmente vazios  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aLogMsg,  " ")
			aAdd(aLogMsg, "["+RD6->RD6_CODIGO+"]" + RD6->RD6_DESC )
		EndIf

	Endif

	cKey	:= SubStr( &( IndexKey() ) , 1 , 8 )
	bKey	:= { ||SubStr( &( IndexKey() ) , 1 , 8 )}
	bSkip	:= {|| RDB->RDB_CODAVA <> RD6->RD6_CODIGO .or. ( RDB->RDB_CODADO < cAdoDe .OR. RDB->RDB_CODADO > cAdoAte )  }

	aCols 	:=RDB->( GdMontaCols( @aHeader , @nUsado , @aVirtGd , @aVisual , NIL , aNotFields , @aRecnos , "RDB",cKey ,bKey ,bSkip) )

	cCodAvaliacao := RD6->RD6_CODIGO
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carrega tabelas                                              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fAPDACarTab(aOpenFile)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Calcula Valor para Cada questao respondida  (RDB)            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	aVlrQuestao	:= fCalcQuestao( aCols, aheader)

	If Empty(aTotItemNet) .or. aTotItemNet[1,1] <> cCodAvaliacao
		aTotItemNet := fCalcTotItem()
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Calculo da Media por Item de Competencia/Rede  (RDD)          |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Len(aVlrQuestao) > 0
		aMediaItemNet 	:= fCalcMediaComp(aVlrQuestao)
	EndIF

	If Empty(aVlrQuestao) .or. Empty(aMediaItemNet)

		If nTipo <> 1
			AVISO(" ",OemToAnsi(STR0013)+ CRLF + OemToAnsi(STR0014)  ,{"Ok"} )   //-- "Calculo nao foi efetuado. Verifique os parametros"
		EndIf

	Elseif Empty(aVlrQuestao) .or. Empty(aMediaItemNet) .And. nTipo == 2

	    If nLogOcorr == 1
	    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Alimenta Log com as avaliacoes as quais os avaliados estavam com o RDB possivelmente vazios  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aLogMsg, "["+RD6->RD6_CODIGO+"]" + RD6->RD6_DESC ) //Codigo e Descricao da Avaliacao
		EndIf

	Else
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Efetua gravacao de registro no arquivos                      ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		lRet := fSaveFile( aMediaItemNet,aVlrQuestao,aTotItemNet)
		aMediaItemNet := {}
		//Durante o laço lRetRd6 alterou o seu estado para .F. ele não altera até o fim do processo
		If lRetRd6
			lRetRd6	:= lRet
		EndIf
	Endif

    RD6->(dbSkip())
EndDo

If lRetRd6
	AVISO("",OemToAnsi(STR0005),{"Ok"} ) 				//-- Calculo efetuado com  sucesso
Else
	AVISO("",OemToAnsi(STR0022),{"Ok"} ) 				//-- As Avaliacoes nao foram calculadas para todos os respectivos avaliados, verifique o log do sistema!
EndIf

If lRelease11 .AND. nTipo <> 3
	oSelf:SaveLog(STR0001 + " - " + STR0021)	//"Término do Processamento"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibicao do log de mensagens ao final do processamento quando selecionado a opcao 1-Imprime Log  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nLogOcorr == 1 )
	If Len( aLogMsg ) > 2
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Gera e Mostra o Log 										  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		FMakeLog( { aLogMsg } ,{OemToAnsi( STR0019 )}, , NIL , NIL , cTitulo,"M","P",,.F. ) //"As Avaliacoes abaixo nao foram calculadas para todos os seus respectivos avaliados:"
	Else
		lGeraLog	:=	.T.
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalcQuestao      ºAutor  ³Aline Correa do Valeº Data ³ 12/02/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo Valor da Questao                                            º±±
±±º          ³                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fCalcQuestao(aCols,aHeader)

Local aArea			:= GetArea()
Local aVlrQuestao	:= {}
Local nVlrQuestao	:= 0 				//-- Valor da Questao
Local nQuestao 		:= 0				//--
Local nPosCodAdo	:= GdFieldPos("RDB_CODADO", aHeader  )
Local nPosCodPro	:= GdFieldPos("RDB_CODPRO", aHeader  )
Local nPosCodDor	:= GdFieldPos("RDB_CODDOR", aHeader  )
Local nPosDtIava	:= GdFieldPos("RDB_DTIAVA", aHeader  )
Local nPosDtFava	:= GdFieldPos("RDB_DTFAVA", aHeader  )
Local nPosCom		:= GdFieldPos("RDB_CODCOM", aHeader  )
Local nPosIte		:= GdFieldPos("RDB_ITECOM", aHeader  )
Local nPosNet		:= GdFieldPos("RDB_CODNET", aHeader  )
Local nPosQue		:= GdFieldPos("RDB_CODQUE", aHeader  )
Local nPosAlt		:= GdFieldPos("RDB_CODALT", aHeader  )
Local nPosTip		:= GdFieldPos("RDB_CODTIP", aHeader  )
Local nPosTipoAv    := GdFieldPos("RDB_TIPOAV", aHeader  )
Local nPosEscala    := GdFieldPos("RDB_ESCALA", aHeader  )
Local nPosIteesc    := GdFieldPos("RDB_ITEESC", aHeader  )
Local nPosMod	    := GdFieldPos("RDB_CODMOD", aHeader  )

For nQuestao := 1 to Len( aCols )

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Retorna valor de uma questao e  salva no array aVlrQuestao    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//Condicao abaixo reconsiderada para calcular a todos os tipos de avaliadores (rdb_tipoav)
	//If aCols[nQuestao,nPosTipoAv] == "3" //Somente quando Avaliacao de Consenso
	nVlrQuestao	:= fVlrQuestao(aCols[nQuestao,nPosCom],aCols[nQuestao,nPosIte],aCols[nQuestao,nPosQue], aCols[nQuestao,nPosAlt], aCols[nQuestao,nPosEscala], aCols[nQuestao,nPosIteesc])
	If !Empty(aCols[nQuestao,nPosCodAdo]+aCols[nQuestao,nPosCodDor]+aCols[nQuestao,nPosCom]+aCols[nQuestao,nPosIte]+aCols[nQuestao,nPosNet]+aCols[nQuestao,nPosQue])
		aadd(	aVlrQuestao,;
								{;
									xFilial("RDB"),;				//01
									cCodAvaliacao,;					//02
									aCols[nQuestao,nPosCodAdo],;	//03
									aCols[nQuestao,nPosCodPro],;	//04
									aCols[nQuestao,nPosCodDor],;	//05
									aCols[nQuestao,nPosDtIava],;	//06
									aCols[nQuestao,nPosDtFava],;	//07
									aCols[nQuestao,nPosCom],;		//08
									aCols[nQuestao,nPosIte],;		//09
									aCols[nQuestao,nPosNet],;		//10
									aCols[nQuestao,nPosQue],;		//11
									nVlrQuestao,;					//12
									aCols[nQuestao,nPosTip],;		//13
									aCols[nQuestao,nPosTipoAv],;	//14
									aCols[nQuestao,nPosDtFava],;	//15
									aCols[nQuestao,nPosMod],;		//16
								};
			)
	EndIf
	//EndIf
Next Questao
RestArea(aArea)
Return aVlrQuestao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVlrQuestao       ºAutor  ³Aline Correa do Valeº Data ³ 12/02/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo - pontuacao da  Questao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVlrQuestao(cCodCom,cCodItem, cCodQuestao, cAlternativa, cEscala, cIteesc )

Local nPontos 			:= 0
Local nPtosQuestao		:= 0
Local nVlrQst			:= 1 // Conter calculo do fator da questa
Local nVlrGrImp			:= 1 // Contem o fafor do grau de importancia da questa
//Obs.: Variaveis declaradas acima como 1 devido os calculos
Local nRet				:= 0

dbSelectArea("SQO")
If dbSeek(xFilial("SQO") + cCodQuestao ,.f.)
	nPontos	:= SQO->QO_PONTOS
	If SQO->QO_TIPOOBJ == "3" //Dissertativa
		nPtosQuestao := nPontos
	EndIf
	If RD5->RD5_TIPO == "2" //Pesquisa
		nPtosQuestao := 1
	Else
		If Empty( SQO->QO_ESCALA )
			dbSelectArea("SQP")
			If dbSeek(xFilial("SQP") +  cCodQuestao + StrZero(Val(cAlternativa),2))
				nVlrQst:= SQP->QP_PERCENT / 100
			Endif
		Else
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo do Fator da Alternativa da Questao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RBL->( dbSetOrder( 1 ) )
			If RBL->( dbSeek( xFilial("RBL") + SQO->QO_ESCALA + StrZero(Val(cAlternativa),2) ))
				nVlrQst:= RBL->RBL_VALOR / 100
			Endif
		EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo do Fator do Grau de Importancia da Alternativa  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cIteesc) .And. RBL->( dbSeek( xFilial("RBL") + cEscala + cIteesc ))
			nVlrGrImp:=(RBL->RBL_VALOR / 100 )
		Endif

		If lAPD010VQ
			IF ( ValType( nRet := ExecBlock( "APD010VQ", .F. , .F. ,{nPontos, nVlrQst, nVlrGrImp} ) ) == "N" )
			   nPtosQuestao += nRet
			Else
				nPtosQuestao += nPontos*nVlrQst*nVlrGrImp
			EndIF
		Else
			nPtosQuestao += nPontos*nVlrQst*nVlrGrImp
		EndIf

	EndIf
Endif

Return  ( nPtosQuestao )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fCalcMediaComp ³ Autor ³Eduardo Ju        ³ Data ³15.03.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calculo do valor da Media por Item de competencia           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APDM010                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCalcMediaComp(aVlrQuestao)

Local aArea			:= GetArea()
Local aMediaItemComp:= {}				//-- Array de Retorno

//-- Ptos por Questao
Local nQuestao		:= 0

Local cCodAdo 		:= ""
Local cCodPro       := ""
Local dDtIava
Local dDtFava
Local cCodCom		:= ""
Local cCoditem		:= ""
Local cCodNet  		:= ""
Local cCodTip		:= ""
Local cCodTipAv		:= ""

Local lApdm010Block := ExistBlock( "APD01001"	)

aSort(aVlrQuestao , , , {|x,y|  x[3]+ x[8]+x[9] + x[10] + x[14] <  y[3]+ y[8]+ y[9] + y[10]  + y[14]   })

For nQuestao := 1 to Len(aVlrQuestao)
	If (cCodAdo + cCodCom + cCodItem + cCodnet + cCodTipAv) != aVlrQuestao[nQuestao,3]+;
		aVlrQuestao[nQuestao,8]+aVlrQuestao[nQuestao,9]+aVlrQuestao[nQuestao,10]+aVlrQuestao[nQuestao,14]

		cCodAdo 		:= aVlrQuestao[nQuestao,3]
		cCodPro         := aVlrQuestao[nQuestao,4]
		dDtIava         := aVlrQuestao[nQuestao,6]
		dDtFava         := aVlrQuestao[nQuestao,7]
		cCodCom			:= aVlrQuestao[nQuestao,8]
		cCodItem		:= aVlrQuestao[nQuestao,9]
		cCodNet  		:= aVlrQuestao[nQuestao,10]
		cCodTip			:= aVlrQuestao[nQuestao,13]
		cCodTipAv		:= aVlrQuestao[nQuestao,14]

		aadd(aMediaItemComp,{;
								cCodAvaliacao,;	//01
								cCodAdo,;		//02
								cCodPro,;		//03
								dDtIava,;		//04
								dDtFava,;		//05
								cCodCom,;		//06
								cCodItem,;		//07
								cCodNet,;		//08
								0,;				//09
								cCodTip,;		//10
								cCodTipAv;		//11
							 };
			 )
	Endif
	aMediaItemComp[Len(aMediaItemComp)][9] += aVlrQuestao[nQuestao,12]
Next nQuestao

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Ponto de Entrada para tratamento da media.                   ³
³ Permite que seja feita a media aritmetica das notas sem consi³
³ derar os pesos dos itens de competencia.
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF ( lApdm010Block )
	IF ( ValType( aRet := ExecBlock("APD01001", .F. , .F. ,{aMediaItemComp,aVlrQuestao}) ) == "A" )
	   aMediaItemComp   := aClone(aRet)
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura os dados de entrada                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( aArea )

Return ( aMediaItemComp )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |fSaveFile ºAutor  ³Microsiga           º Data ³  10/28/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava RDD e RDB                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSaveFile( aMediaItemNet,aVlrQuestao,aTotItemNet)

Local aArea			:= GetArea( )
Local lRet			:= .T.

Begin Sequence

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Salva Media Item Compet. / Rede                               ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If fGravaRDD(aMediaItemNet,aTotItemNet)
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³Salva Resultado por Questao                                   ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If !fGravaRDB(aVlrQuestao)
			lRet	:= .F.
			Break
		Endif
	Else
		lRet := .F.
		Break
	EndIf


End Sequence

RestArea( aArea )

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fGravaRDD ³ Autor ³Eduardo Ju             ³ Data ³17.03.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Salva o Valor da Media por Item de Competencia / Rede       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APDM010                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fGravaRDD(aMediaItemNet,aTotItemNet)

Local aArea		:= GetArea()
Local nAvaliado	:= 0
Local nPosAux	:= 0
Local nPtoMax	:= 0
Local cKey		:= ""
Local lOk		:= .F.

RDD->( dbSetOrder(1))

For nAvaliado := 1 to Len(aMediaItemNet )

	cKey 	:= xFilial("RDD") +aMediaItemNet[ nAvaliado,1 ] + aMediaItemNet[ nAvaliado,2 ] + aMediaItemNet[ nAvaliado,3 ] + dTos( aMediaItemNet[ nAvaliado,4 ] ) + aMediaItemNet[ nAvaliado,6 ] + aMediaItemNet[ nAvaliado,7 ]+ aMediaItemNet[ nAvaliado,8 ]+ aMediaItemNet[ nAvaliado,11 ]
	If RDD->(dbSeek(ckey))
		RDD->( RecLock("RDD",.F.,.T.) )		//-- altera
		lOk	:= .T.
	Else
		RDD->( RecLock("RDD",.T.,.T.) )		//-- Inclui
		lOk	:= .T.
	EndIf

	If (nPosAux := aScan(aTotItemNet,{|x| x[4] == aMediaItemNet[nAvaliado,7] })) > 0
		nPtoMax := aTotItemNet[nPosAux][5]
	Else
		nPtoMax := 0
	EndIf

	RDD->RDD_FILIAL		:= xFilial("RDB")
	RDD->RDD_CODAVA		:= aMediaItemNet[nAvaliado,1]
	RDD->RDD_CODADO		:= aMediaItemNet[nAvaliado,2]
	RDD->RDD_CODPRO		:= aMediaItemNet[nAvaliado,3]
	RDD->RDD_DTIAVA     := aMediaItemNet[nAvaliado,4]
	RDD->RDD_DTFAVA		:= aMediaItemNet[nAvaliado,5]
	RDD->RDD_CODCOM		:= aMediaItemNet[nAvaliado,6]
	RDD->RDD_ITECOM 	:= aMediaItemNet[nAvaliado,7]
	RDD->RDD_CODNET		:= aMediaItemNet[nAvaliado,8]
	RDD->RDD_RESOBT		:= aMediaItemNet[nAvaliado,9]
	RDD->RDD_CODTIP		:= aMediaItemNet[nAvaliado,10]
	RDD->RDD_TIPOAV		:= aMediaItemNet[nAvaliado,11]
	RDD->RDD_PTOMAX		:= nPtoMax
	RDD->(MsUnlock())
Next nAvaliado

RestArea(aArea)
Return (lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGravaRDB ºAutor  ³Microsiga           º Data ³  10/28/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Salva Valor da Questao                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fGravaRDB(aVlrQuestao)

Local aArea			:= GetArea()
Local nVlrQuestao 	:= 0
Local cKey			:= ""
Local lOk			:= .F.

RDB->(dbSetOrder(1))
For  nVlrQuestao := 1 to Len( aVlrQuestao )
    cKey:= xFilial("RDB")+ cCodAvaliacao + aVlrQuestao[nVlrQuestao,3]+ aVlrQuestao[nVlrQuestao,4]+ aVlrQuestao[nVlrQuestao,5]+ dTos(aVlrQuestao[nVlrQuestao,6])+ aVlrQuestao[nVlrQuestao,8]+ aVlrQuestao[nVlrQuestao,9]+ aVlrQuestao[nVlrQuestao,10]+ aVlrQuestao[nVlrQuestao,11]+ aVlrQuestao[nVlrQuestao,14]
	If RDB->(dbSeek(ckey))
		RDB->( RecLock("RDB",.F.,.T.) )			  		//-- Alteracao
		RDB->RDB_RESOBT	:= aVlrQuestao[nVlrQuestao,12] 		//-- Vlr Questao
		RDB->( MsUnlock() )
		lOk		:= .T.
	Endif

Next nVlrQuestao

//Grava o Resultado obtido na tabela de Habilidades do funcionario
fGravaRBI(aVlrQuestao)

RestArea(aArea)
Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGravaRBI ºAutor  ³Flavio S. Correa    º Data ³  29/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Salva resultado obitido na tabela de habilidades do Func   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fGravaRBI(aVlrQuestao)

Local aArea			:= GetArea()
Local nI			:= 0
Local nJ			:= 0
Local nValor		:= 0
Local nQtd			:= 0
Local nMedia		:= 0
Local cKey			:= ""
Local cItem			:= ""
Local lOk			:= .F.
Local aHabilidade	:= {}
Local aValor		:= {}

DbSelectaREA("RD8")
RD8->(dbSetOrder(1))//RD8_FILIAL+RD8_CODMOD+RD8_CODCOM+RD8_ITECOM+RD8_CODQUE

//MONTA ARRAY COM AS HABILIDADES E O RESULTADO DAS QUESTOES CORRESPONDENTES
For nI := 1 To Len(aVlrQuestao)
	If RD8->(dbSeek(xFilial("RD8")+aVlrQuestao[nI][16]+aVlrQuestao[nI][08]+aVlrQuestao[nI][09]+aVlrQuestao[nI][11] ) )
		If !Empty(RD8->RD8_HABIL)
			If Len(aHabilidade) > 0
				nPos := Ascan(aHabilidade,{|x| x[1] == RD8->RD8_HABIL })
				If nPos > 0
					aadd(aHabilidade[nPos][2],aVlrQuestao[nI,12])
				Else
					aadd(aHabilidade,{RD8->RD8_HABIL,{aVlrQuestao[nI,12]},aVlrQuestao[nI,3] }) //habilidade e valor
				EndIf
			Else
				aadd(aHabilidade,{RD8->RD8_HABIL,{aVlrQuestao[nI,12]},aVlrQuestao[nI,3] }) //habilidade e valor
			EndIf
		EndIf
	EndIf
Next nI

RBI->(dbSetOrder(1))
RBG->(dbSetOrder(1))
RBL->(dbSetOrder(1))

For nI := 1 To Len(aHabilidades)
	nQtd	:= Len(aHabilidades[nI][2])
	aEval(aHabilidades[nI][2],{|x| nValor += x })
	nMedia	:= round(nValor / nQtd,2)

	If nMedia > 0
		//comparacao de escala
		If RBG->(dbSeek(xFilial("RBG")+aHabilidade[nI][1]) )
			If RBL->( dbSeek( xFilial("RBL") + RBG->RBG_ESCALA ))
		    	While !RBL->(Eof()) .And. RBL->(RBL_FILIAL+RBL_ESCALA) == xFilial("RBL") + RBG->RBG_ESCALA
		    		Aadd(aValor,{RBL->RBL_ITEM,RBL->RBL_VALOR})
		    		RBL->(dbSkip())
		    	EndDo
			EndIf
			aValor := aSort(aValor,,,{|x,y| x[2] < y[2]})
			For nJ := 1 To Len(aValor)
				If nMedia < aValor[nJ][2]
					Exit
				EndIf
				cItem := aValor[nJ][1]
			Next nJ

			If !Empty(cItem)
				lAchou := RBI->(dbSeek(xFilial("RBI")+aHabilidade[nI][3]) )
				//grava historico da habilidade
				If lAchou
					RecLock("RAS",.T.)
						RAS->RAS_FILIAL	:= xFilial("RAS")
						RAS->RAS_MAT	:= aHabilidade[nI][3]
						RAS->RAS_HABIL	:= RBI->RBI_HABIL
						RAS->RAS_ESCALA	:= RBI->RBI_ESCALA
						RAS->RAS_ITESCA	:= RBI->RBI_ITESCA
						RAS->RAS_TIPGRV	:= RBI->RBI_TIPGRV
						RAS->RAS_DATA	:= RBI->RBI_DATA
						RAS->RAS_RESULT	:= RBI->RBI_RESULT
					RAS->(msUnlock())
				EndIf

				//grava habilidade do funcionario
			    RecLock("RBI",!lAchou)
					RBI->RBI_FILIAL	:= xFilial("RAS")
					RBI->RBI_MAT	:= aHabilidade[nI][3]
					RBI->RBI_HABIL	:= aHabilidade[nI][1]
					RBI->RBI_ESCALA	:= RBL->RBL_ESCALA
					RBI->RBI_ITESCA	:= cItem
					RBI->RBI_TIPGRV	:= ""
					RBI->RBI_DATA	:= dDatabase
					RBI->RBI_RESULT	:= nMedia
			    RBI->(msunlock())
			EndIf
		EndIf
	EndIf
Next nI


RestArea(aArea)
Return(lOk)

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fAPDACarTab	   ³ Autor ³Natie Sugahara       ³ Data ³24/10/2002³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³															   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³															   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                         					   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³NIL     													   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observa‡„o³                                                      	       ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generica                                                       ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Function fAPDACarTab( aOpenFile )

Local aArea			:= GetArea()
Local nFiles

For nFiles	:= 1 TO Len(aOpenFile)
	//-- Rede
	If aOpenFile[nFiles] ="RD1"
		dbSelectArea(aOpenFile[nFiles])
		If dbSeek(xFilial(aOpenFile[nFiles]) ,.f.)
			While RD1->( !eof() )  .and. xFilial(aOpenFile[nFiles])  = RD1_FILIAL
				aadd(aRede,{RD1->RD1_FILIAL,RD1->RD1_CODIGO, RD1->RD1_DESC } )
				RD1->( dbSkip() )
			Enddo
		Endif
	ElseIf aOpenFile[nFiles] ="RDE"
		//-- Participante na estrutura
		dbSelectArea( aOpenFile[nFiles] )
		dbSetOrder(2)
		If dbSeek( xFilial(aOpenFile[nFiles]) + M->RD6_CODVIS ,.f. )
			While RDE->( !eof() )  .and. xFilial(aOpenFile[nFiles]) + M->RD6_CODVIS = RDE_FILIAL+ RDE_CODVIS
				Aadd(aPartEstru , {RDE->RDE_FILIAL,RDE_CODVIS,RDE_ITEVIS,RDE_CODPAR }  )
				RDE->( dbSkip() )
			Enddo
		EndIf
	Endif

Next nFiles

RestArea(aArea)

Return( NIL )

/*
{Protheus.doc} fCalcTotItem
Função para calcular ototal de pontos possível em cada item de competência
@author	Leandro Drumond
@since 13/04/2016
*/
Static Function fCalcTotItem()
Local aArea			:= GetArea()
Local aRet			:= {}
Local nPos			:= 0
Local nValAux		:= 0

DbSelectArea("RD8")
DbSetOrder(1) //RD8_FILIAL+RD8_CODMOD+RD8_CODCOM+RD8_ITECOM+RD8_CODQUE

DbSelectArea("SQO")
DbSetOrder(1) //QO_FILIAL+QO_QUESTAO

DbSelectArea("RBL")
DbSetOrder(1) //RBL_FILIAL+RBL_ESCALA+RBL_ITEM

DbSelectArea("RDO")
DbSetOrder(1) //RDO_FILIAL+RDO_CODMOD+RDO_CODCOM+RDO_ITECOM+RDO_ESCALA+RDO_ITEESC

//Se existe relevancia (RDO)
If RDO->(DbSeek(xFilial("RDO")+ RD6->RD6_CODMOD + RD6->RD6_CODCOM))
	While RDO->(!Eof() .AND. RDO->(RDO_FILIAL + RDO_CODMOD + RDO_CODCOM) == xFilial("RDO")+ RD6->RD6_CODMOD + RD6->RD6_CODCOM)
		If RD8->(DbSeek(xFilial("RD8") + RDO->(RDO_CODMOD + RDO_CODCOM + RDO_ITECOM)))
			While RD8->(!Eof() .AND. RD8->(RD8_FILIAL+RD8_CODMOD+RD8_CODCOM+RD8_ITECOM) == xFilial("RD8") + RDO->(RDO_CODMOD + RDO_CODCOM + RDO_ITECOM))
				If SQO->(DbSeek(xFilial("SQO")+RD8->RD8_CODQUE)) .and. SQO->QO_ESCALA <> ""
				 	If RBL->(DbSeek(xFilial("RBL")+SQO->QO_ESCALA))
				 		nValAux := 0
				 		While RBL->(!Eof()) .and. RBL->(RBL_FILIAL + RBL_ESCALA) == xFilial("RBL") + SQO->QO_ESCALA
				 			If RBL->RBL_VALOR > nValAux
				 				nValAux := RBL->RBL_VALOR
				 			EndIf
							RBL->(DbSkip())
						EndDo
						If nValAux > 0
							If ( nPos := aScan(aRet,{|x| x[2]+x[3]+x[4] == RDO->(RDO_CODMOD + RDO_CODCOM + RDO_ITECOM) }) ) == 0
								aAdd(aRet,{RD6->RD6_CODIGO,RDO->RDO_CODMOD,RDO->RDO_CODCOM,RDO->RDO_ITECOM,nValAux})
							Else
								aRet[nPos][5] += nValAux
							EndIf
						EndIf
					EndIf
				EndIf
				RD8->(DbSkip())
			EndDo
		EndIf
		RDO->(DbSkip())
	EndDo

//Se nao existe relevancia
Else
	If RD8->(DbSeek(xFilial("RD6") + RD6->RD6_CODMOD + RD6->RD6_CODCOM))
		While RD8->(!Eof()) .AND. RD8->(RD8_FILIAL+RD8_CODMOD+RD8_CODCOM) == RD6->(RD6_FILIAL+RD6_CODMOD+RD6_CODCOM)
			If SQO->(DbSeek(xFilial("SQO")+RD8->RD8_CODQUE)) .and. SQO->QO_ESCALA <> ""
			 	If RBL->(DbSeek(xFilial("RBL")+SQO->QO_ESCALA))
			 		nValAux := 0
			 		While RBL->(!Eof() .and. RBL_FILIAL + RBL_ESCALA == xFilial("RBL") + SQO->QO_ESCALA)
			 			If RBL->RBL_VALOR > nValAux
			 				nValAux := RBL->RBL_VALOR/100
			 			EndIf
						RBL->(DbSkip())
					EndDo
					If nValAux > 0
						If ( nPos := aScan(aRet,{|x| x[2]+x[3]+x[4] == RD8->(RD8_CODMOD + RD8_CODCOM + RD8_ITECOM) }) ) == 0
							aAdd(aRet,{RD6->RD6_CODIGO,RD8->RD8_CODMOD,RD8->RD8_CODCOM,RD8->RD8_ITECOM,nValAux})
						Else
							aRet[nPos][5] += nValAux
						EndIf
					EndIf
				EndIf
			EndIf
			RD8->(DbSkip())
		EndDo
	EndIf
EndIf

RestArea(aArea)

Return aRet

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ MenuDef		³Autor³  Luiz Gustavo     ³ Data ³21/12/2006³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Isola opcoes de menu para que as opcoes da rotina possam    ³
³          ³ser lidas pelas bibliotecas Framework da Versao 9.12 .      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³APDM010                                                     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 Local aRotina := { 	{ OemToAnsi(STR0015),'PesqBrw', 0, 1,,.F.}, ;	//"Pesquisar"
						{ OemToAnsi(STR0016),'APDCALCM'	, 0, 4} }	//"Calcular"

Return aRotina
