#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RSP002   � Autor � Marcos Pereira     � Data �  23/02/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Concursos - Processo de Convoca��o                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RSP002()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCadastro := "Concursos - Processo de Convoca��o"
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZ2"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             		 {"Processar","U_RSP002MNT",0,2} ;
                   }

dbSelectArea(cString)
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSP002MNT � Autor � Marcos Pereira     � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Candidatos do Concurso                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RSP002MNT()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFiltraSZ2	:= ""
Local aIndexSZ2		:= {}
Private bFiltraBrw	:= { || NIL }  
Private cCadastro := "Candidatos do Concurso " + SZ2->Z2_CODIGO
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SQG"
Private cVaga_ 	:= ""

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
Private aRotina := { {"Pesquisar"			,"AxPesqui"		,0,1} ,;
		             {"Visualizar Curr�culo","AxVisual"		,0,2}, ;
		             {"Alterar Curr�culo"	,"AxAltera"		,0,4}, ;
					 {"Agenda"  			,"U_RSP2AG" 	,0,2}, ;
					 {"Legenda"  			,"U_RSP002L2" 	,0,7,,.F.} ; 
              }

dbSelectArea("SQG")
dbSetOrder(1)

aCampos:= {	{TitSX3("QG_XCODCON" )[1],"QG_XCODCON"},;     	
			{TitSX3("QG_CODFUN" )[1],"QG_CODFUN"},;
			{TitSX3("QG_DESCFUN" )[1],"QG_DESCFUN"},;
			{TitSX3("QG_XESPECI" )[1],"QG_XESPECI"},;
			{TitSX3("QG_XCARGO2" )[1],"QG_XCARGO2"},;
			{TitSX3("QG_XDCARG2" )[1],"QG_XDCARG2"},;
			{TitSX3("QG_XCLASSI" )[1],"QG_XCLASSI"},;
			{TitSX3("QG_XCOTA" )[1]	 ,"QG_XCOTA"},;
			{TitSX3("QG_NOME" )[1]	 ,"QG_NOME"},;
			{TitSX3("QG_MAT" )[1]	 ,"QG_MAT"},;
			{TitSX3("QG_CIC" )[1]	 ,"QG_CIC"},;
			{TitSX3("QG_XDTDESI" )[1],"QG_XDTDESI"};
		  } 	  

aColors	:=	{	                                    	 	 				 ;
			{ "!empty(SQG->QG_XDTDESI) .and. SQG->QG_ULTETAP <> 'Z2'"			, 'BR_PRETO'	}	,; //Desistente
			{ "!empty(SQG->QG_XDTDESI) .and. SQG->QG_ULTETAP == 'Z2'" 			, 'BR_BRANCO'	}	,; //Sem Pre-Requisitos
			{ "!empty(SQG->QG_XDTCONV).and.empty(QG_MAT).and.QG_SITUAC=='001'" 	, 'BR_AMARELO'	}	,; //Convocado
			{ "!empty(SQG->QG_XDTCONV).and.empty(QG_MAT).and.QG_SITUAC=='FUN'" 	, 'BR_LARANJA'	}	,; //Convocado (Funcionario)
			{ "empty(QG_XDTDESI).and.empty(QG_MAT).and.QG_SITUAC=='001'" 		, 'BR_VERDE'	}	,; //Disponivel
			{ "empty(QG_XDTDESI).and.empty(QG_MAT).and.QG_SITUAC=='FUN'" 		, 'BR_AZUL'		}	,; //Disponivel (Funcionario)
			{ "QG_SITUAC=='002'.or.(empty(QG_XDTDESI).and.!empty(QG_MAT).and.QG_SITUAC=='FUN')", 'BR_VERMELHO'} ; //Admitido
			}

cFiltraSZ2  := RSP2F1()
If cFiltraSZ2 == "ERRO"
	Return
EndIf

bFiltraBrw	:= {|| FilBrowse(cString,@aIndexSZ2,@cFiltraSZ2) }
Eval( bFiltraBrw )

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,aCampos, NIL , NIL , NIL ,, aColors)

/*
������������������������������������������������������������������������Ŀ
� Deleta o filtro utilizando a funcao FilBrowse                      	 �
��������������������������������������������������������������������������*/
EndFilBrw(cString,aIndexSZ2)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RSP002L2 � Autor � Marcos Pereira     � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Legenda                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RSP002L2()

	BrwLegenda	(cCadastro,"Legenda", {	{"BR_PRETO"	  , OemToAnsi("Desistente") }, ; 
										{"BR_BRANCO"  , OemToAnsi("Sem Pr�-Requisitos")	 			 }, ; 
										{"BR_AMARELO" , OemToAnsi("Convocado")	 			 }, ; 
										{"BR_LARANJA" , OemToAnsi("Convocado (Funcion�rio)")	 			 }, ; 
										{"BR_VERDE"   , OemToAnsi("Dispon�vel")	 			 }, ; 
										{"BR_AZUL" 	  , OemToAnsi("Dispon�vel (Funcion�rio)")}, ; 
										{"BR_VERMELHO", OemToAnsi("Admitido")				 }  ; 
								  	};
				) 

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RSP2AG   � Autor � Marcos Pereira     � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Executa a agenda do candidato                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RSP2AG()

Local aSRA   := SRA->(getArea())
Local aArea  := getarea()
Local cMat 	 := ""
Local lSZ3 	 := .f.

If SZ2->(dbseek(xFilial("SZ2")+SQG->QG_XCODCON))
	If SZ2->Z2_STATUS <> '1'
		Alert("O concurso n�o est� mais ativo.")
		Return
	ElseIf !empty(SZ2->Z2_DTVALID)
		If SZ2->Z2_DTVALID < date()
			Alert("A validade do concurso j� expirou.")
			Return
		ElseIf SZ2->Z2_DTVALID <= (Date()+30)
			MsgAlert("Aten��o � data de validade do concurso, pois a mesma expira em "+dtoc(SZ2->Z2_DTVALID)+".")
		EndIf
	EndIf
	If SZ3->(dbseek(xFilial("SZ3")+SZ2->Z2_CODIGO+SQG->QG_CODFUN))
		While SZ3->(!eof()) .and.  SZ3->(Z3_FILIAL+Z3_CODIGO+Z3_CARGO) == xFilial("SZ3")+SZ2->Z2_CODIGO+SQG->QG_CODFUN
			If SZ3->Z3_STATUS == '1'
				lSZ3 := .t.
				exit
			EndIf
			SZ3->(dbskip())
		EndDo
	EndIf 
EndIf				

If !lSZ3
	Alert("O candidato est� vinculado a um concurso no qual n�o existe o cargo "+SQG->QG_CODFUN+" com status Ativo.")
	Return
EndIf

If !empty(SQG->QG_XDTDESI)
	If !MsgNoYes("O candidato est� como "+if(SQG->QG_ULTETAP=='Z2',"'SEM PR�-REQUISITOS'","'DESISTENTE'")+" em seu curr�culo."  + CHR(13)+ CHR(10) + "Deseja realmente prosseguir ?")
		Return
	EndIf
EndIf
If empty(cVaga_) .and. empty(SQG->QG_MAT) .and. SQG->QG_SITUAC $ '001/FUN' .and. empty(SQG->QG_ULTVAGA)
	Alert("O c�digo da vaga n�o foi informado no par�metro inicial na tela anterior")
	Return
EndIf
If SQG->QG_SITUAC=='002' .or. (!empty(SQG->QG_MAT) .and. SQG->QG_SITUAC=='FUN')
	Alert("O candidato j� encontra-se admitido por esse curr�culo.")
	Return
Else
	//Verifica se o candidato ja � funcion�rio admitido por outro concurso.
	SRA->(dbsetorder(RetOrder("SRA","RA_CIC+RA_FILIAL+RA_MAT")))
	If SRA->(dbseek(SQG->QG_CIC))
		While SRA->(!eof()) .and. SRA->RA_CIC == SQG->QG_CIC
			If empty(SRA->RA_DEMISSA)
				cMat := SRA->RA_FILIAL+"/"+SRA->RA_MAT
				RestArea(aSRA)
				RestArea(aArea)
				If !MsgNoYes("O candidato j� � funcion�rio ativo com a matr�cula "+cMat+". Deseja realmente prosseguir ?")
					Return
				EndIf
				Exit
			EndIf
			SRA->(dbskip())
		EndDo
	EndIf                 
EndIf

Rs150List(3,3,cVaga_)

Return



Static Function RSP2F1()
Local cCargo 	:= ''
Local cFiltro 	:= "("
Private cPerg   := "XRSP2F12" // Nome do arquivo de perguntas do SX1

//Verifica Perguntas
AjPerg(cPerg)
If !(Pergunte(cPerg,.T.))
	Return("ERRO")
EndIf

cVaga_ := MV_PAR02 

//Busca o cargo atraves da vaga selecionada
If !empty(MV_PAR02)
	cCargo := Posicione("SQS",1,xFilial("SQS")+MV_PAR02,"QS_FUNCAO") 
EndIf
If !empty(cCargo) .and. !empty(MV_PAR03) .and. cCargo <>  MV_PAR03
	Alert("O cargo selecionado n�o corresponde ao cargo vinculado na vaga tamb�m selecionada. Utilize somente um desses campos.")
	Return("ERRO")
EndIf
If empty(cCargo) .and. !empty(MV_PAR03)
	cCargo := MV_PAR03
EndIf

//Filtra somente o concurso posicionado
If MV_PAR01 == 1
	cFiltro := "(QG_XCODCON = '"+SZ2->Z2_CODIGO+"'"
EndIf

//Filtra pelo cargo informado ou pela vaga
If !empty(cCargo)
	If !(cFiltro == "(")
		cFiltro += ".and."
	EndIf
	cFiltro += "QG_CODFUN = '" + cCargo + "'"
EndIf

//Filtra pelo cargo do edital
If !empty(MV_PAR04)
	If !(cFiltro == "(")
		cFiltro += ".and."
	EndIf
	cFiltro += "QG_XCARGO2 = '" + MV_PAR04 + "'"
EndIf

//Filtra pela Reserva de Cota
If !(MV_PAR05==4)
	If !(cFiltro == "(")
		cFiltro += ".and."
	EndIf
	cFiltro += "alltrim(QG_XCOTA) = '" + if(MV_PAR05==3,"",strzero(MV_PAR05,1)) + "'"
EndIf

//Filtra concursos ativos
If MV_PAR06 == 1
	If !(cFiltro == "(")
		cFiltro += ".and."
	EndIf
	cFiltro += "FDESC('SZ2',SQG->QG_XCODCON,'Z2_STATUS') = '1'"
EndIf

//Filtra pela data de validade do concurso
If !empty(MV_PAR07)
	If !(cFiltro == "(")
		cFiltro += ".and."
	EndIf
	cFiltro += "dtos(FDESC('SZ2',SQG->QG_XCODCON,'Z2_DTVALID')) >= '" + dtos(MV_PAR07) + "'"
EndIf

If cFiltro == "("
	cFiltro := ""
Else
	cFiltro += ")"
EndIf

Return(cFiltro)


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
aHelp :={" Informe Sim quando desejar que sejam ",;
		 " filtrados somente os curr�culos ",;
		 " vinculados ao concurso posicionado ",;
		 " nesta tela inicial."	}
aAdd(aRegs,{cPerg,'01','Somente Concurso Posicionado? ','','','mv_ch1','N',01,0,0,'C','                            ','mv_par01','Sim            ','','','','','Nao            ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Informe ou selecione a vaga. Atrav�s ",;
		 " dela a rotina ir� identificar o cargo ",;
		 " vinculado � mesma e utilizar� como ",;
		 " filtro, mostrando na tela seguinte ",;
		 " somente os curr�culos vinculados ao ",;
		 " cargo. ",;
		 " Se deixar a vaga em branco, o Cargo ",;
		 " informado na pr�xima pergunta ser� ",;
		 " utilizado como filtro. ",;
		 " A vaga ser� obrigat�ria caso desejar ",;
		 " executar a Agenda para convoca��o, na ",;
		 " pr�xima tela."	}
aAdd(aRegs,{cPerg,'02','Vaga ?                        ','','','mv_ch2','C',06,0,0,'G','Vazio() .or. ExistCpo("SQS")','mv_par02','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','SQS','','',aHelp})
aHelp :={" Informe ou selecione o cargo para o ",;
		 " qual deseja filtrar os curr�culos ",;
		 " vinculados ao mesmo."	}
aAdd(aRegs,{cPerg,'03','Cargo ?                       ','','','mv_ch3','C',05,0,0,'G','Vazio() .or. ExistCpo("SQ3")','mv_par03','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','XSQ3','','',aHelp})
aHelp :={" Informe o c�digo do cargo conforme o ",;
		 " Edital. Se deixar em branco, ser�o ",;
		 " exibidos todos os registros vinculados ",;
		 " ao c�digo do cargo selecionado acima."	}
aAdd(aRegs,{cPerg,'04','Cargo Edital ?                ','','','mv_ch4','C',03,0,0,'G','U_RSP002C2()                ','mv_par04','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Selecione a op��o desejada para filtrar ",;
		 " os curr�culos que possuem ou n�o ",;
		 " reserva de cotas."	}
aAdd(aRegs,{cPerg,'05','Reserva de Cota ?             ','','','mv_ch5','N',01,0,0,'C','                            ','mv_par05','Deficientes    ','','','','','Negros/Afrodesc','','','','','Demais       ','','','','','Nao filtrar   ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Informe Sim quando desejar filtrar ",;
		 " somente os curr�culos vinculados ",;
		 " a concurso com status Ativo."	}
aAdd(aRegs,{cPerg,'06','Somente Concursos ativos ?    ','','','mv_ch6','N',01,0,0,'C','                            ','mv_par06','Sim            ','','','','','Nao            ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Caso informada uma data, a mesma ser� ",;
		 " utilizada para filtrar os curr�culos ",;
		 " vinculados a concursos que possuem ",;
		 " data de validade maior ou igual a ",;
		 " data informada."	}
aAdd(aRegs,{cPerg,'07','Concursos validos ate ?       ','','','mv_ch7','D',08,0,0,'G','                            ','mv_par07','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})

ValidPerg(aRegs,cPerg,.T.)

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return


/* 
����������������������������������������������������������������������������� 
����������������������������������������������������������������������������� 
�������������������������������������������������������������������������Ŀ�� 
���Funcao    �RSP002C2  � Autor �                       � Data �03/02/2014��� 
�������������������������������������������������������������������������Ĵ�� 
���Descricao �Seleciona o Cargo Edital                                    ��� 
�������������������������������������������������������������������������Ĵ�� 
���Sintaxe   � RSP002C2()                                           	  ��� 
�������������������������������������������������������������������������Ĵ�� 
���Parametros�                                                            ��� 
�������������������������������������������������������������������������Ĵ�� 
��� Uso      �           					                              ��� 
��������������������������������������������������������������������������ٱ� 
����������������������������������������������������������������������������� 
����������������������������������������������������������������������������� */

User Function RSP002C2()
Local aArea		:= GetArea()
Local MvPar, nX

Local cTitulo  := 'Cargo Edital' 
Local MvParDef := ''
Local lRet     := .T.
Local lOpt     := .F.
Local cAlias   := Alias() 

Private aRegs  := {}

If MV_PAR01 == 2 .or. empty(MV_PAR03) //Se Nao para concurso posicionado ou com Cargo em branco
	MsgAlert("Esta op��o somente est� dispon�vel para utiliza��o em concurso posicionado e com Cargo informado.")
	MV_PAR04 := ''

Else
	SZ3->(dbsetorder(1))
	cChave := xFilial("SZ3")+SZ2->Z2_CODIGO+MV_PAR03
	SZ3->(dbseek(cChave))
	While SZ3->(!eof()) .and. SZ3->(Z3_FILIAL+Z3_CODIGO+Z3_CARGO) == cChave
		aadd(aRegs,SZ3->Z3_CARGO2+' - '+SZ3->Z3_DCARGO2)
		SZ3->(dbskip())
	EndDo

	aSort(aRegs,,,{ | x,y | x < y } )

	For nX := 1 to Len(aRegs)
		MvParDef += left(aRegs[nX],3)
	Next nX	

	MvPar:=&(Alltrim(ReadVar())) //Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())	 //Iguala Nome da Variavel ao Nome variavel de Retorno
	
	//Chama funcao f_Opcoes
	lOpt := f_Opcoes(@MvPar,cTitulo,aRegs,MvParDef,,,.T.,3)
	
	 If lOpt
		&MvRet :=  MvPar
	EndIf

EndIf

dbSelectArea(cAlias) // Retorna Alias
RestArea(aArea)
Return(lRet)
                     
