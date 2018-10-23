#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPEA1210.CH"  

#Define nColTam  20  // Tamanho limite para conteudo de impressao
#Define nColSpc  3   // Coluna de espacamento entre registros impressos
#Define nLimImp  9 // Limite de campos para impressao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao      ³ RSP210   ³  Autor  ³                         ³ Data ³  18/02/16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao   ³ Importacao de dados                                    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso         ³ Generico                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ FNC          ³ Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³          ³              ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RSP210()     
Local aSays		:= {}
Local aButtons	:= {}	
Local aPerg1	:= {}
Local aPerg2	:= {}
Local nOpca 	:= 0

Private cPerg1		:= "XRSP200A"	// Gp. perguntas sobre a importacao  
Private cPerg2		:= "XRSP200B"	// Gp. perguntas especifico SQG

	cCadastro := OemToAnsi("Importações")
	
	AADD(aSays,OemToAnsi("Esta rotina importa dados para os seguintes arquivos: ") + CRLF )  
	AADD(aSays,OemToAnsi("SQG - Currículos") + CRLF )  
	AADD(aSays,OemToAnsi("Conforme definido na rotina de cadastro de Layout de Importacao."))
	                
	AADD(aButtons, { 5,.T.,{|| aPerg := RSP210Perg(@aPerg1,@aPerg2)  } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,If(rsp210OK(),FechaBatch(),nOpca:=0) }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
		
	FormBatch( cCadastro, aSays, aButtons )
	If nOpca == 1                      
		 Processa({|lEnd| RSP210Processa(aPerg1,aPerg2),"Importacao de dados"}) 
	EndIf

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                                                                  
±±³Funcao    ³ RSP210Perg ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa grupos de perguntas.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function RSP210Perg(aPerg1,aPerg2)
Local aArea		:= GetArea()   
Local cAliasArq	:= ""

	//Verifica Perguntas
	AjPerg(cPerg1)
	AjPerg(cPerg2)
	
	Pergunte(cPerg1,.F.)	
	
	If Pergunte(cPerg1,.T.)
	
		// Carregando variaveis mv_par??     
	    AADD(aPerg1, {mv_par01,mv_par02}) 
	    dbSelectArea( "SZ4" ) 
		dbSetOrder(1) // Z4_FILIAL + Z4_CODIGO +Z4_TBDEST + Z4_CPO
		If SZ4->(dbSeek( xFilial("SZ4") + mv_par02 ) ) 
			cAliasArq 	:= SZ4->Z4_TBDEST
	    Else                                                                          
	       	Help( ,, 'HELP',, OemToAnsi("Layout não cadastrado."), 1, 0)       
		    Return
		EndIf  
	      
		If cAliasArq == "SQG"	
	   		Pergunte(cPerg2,.F.) 
			Pergunte(cPerg2,.T.)	  
			AADD(aPerg2,{mv_par01})	
		EndIf    

	EndIf
	
	RestArea(aArea)
	
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                                                                  
±±³Funcao    ³ RSP210PROC ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura Arquivo Texto e Gravacao no Arq. destino.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function RSP210Processa(aPerg1,aPerg2)
Local aAux		   		:= {}                    
Local cHelp     
Local cConteudo	   		:= ""   
Local cCodFil			:= ""
Local cFilPd			:= ""  
Local cCC				:= ""      
Local lFirstGrv			:= .T.  
Local lPula				:= .F.
Local lVerfCamp
Local tregs
Local m_mult     
Local nHandle
Local nBytes
Local nSize
Local nX
Local nY

Private aCampos			:= {}	// Campos gravados no layout de impressao(SZ4)
Private aStru			:= {}	// Campos da estrutura = campos gravados no layout de impressao(SZ4) + adicionais a depender do alias destino  
Private aReg			:= {}	// Array com registros a serem importados que passaram pela validacao inicial
Private aRegSv			:= {}	// Copia de aReg
Private aTitle	   		:= {}	// Titulo de log de importacao
Private aLog			:= {}	// Log de importacao
Private aTitleEr		:= {}	// Titulo de log de registros nao importados
Private aLogEr			:= {}	// Log de registros nao importados    
Private aLogVld			:= {}	// Log de registros importados validos          
Private aRegGrv			:= {}  	// Array de registro importados - Pos 1 = Chave do registro ja gravado , Pos 2 = Sequencia do registro ja gravado
Private aRegSbr			:= {} 	// Array de registros sobrepostos e importados  - Pos 1 = Chave do registro  
Private cTitImpres		:= ""	// Titulo de impressao 
Private cArq1			:= ""	// Arquivo da estrutura
Private dDataRef                
// Variaveis carregas nos perguntes
Private cArquivo
Private cCodigo   
Private cSituacao
Private cAliasArq
Private cNomeArq
Private cCondicao          
Private cConcurso	
Private lCond       	 := .T.
Private nSobrepoe   	 := 2 //Nao
Private nTotaliza 
Private aCargos			

	Begin Sequence    
	
		If Len(aPerg1) > 0 // Selecionou botao 'Ok' primeiro   
			cArquivo		:=	AllTrim(aPerg1[1][1])		// Nome do Aquivo Texto
			cCodigo			:= 	aPerg1[1][2]	   			// Codigo da Tabela da Importacao 
		Else // Selecionou botao 'Paramentos' primeiro 
		  	Pergunte(cPerg1,.F.)
			cArquivo		:=	mv_par01		// Nome do Aquivo Texto
			cCodigo			:= 	mv_par02	   	// Codigo da Tabela da Importacao 
	    EndIf 
	    	   
		If Len(aPerg2) > 0 // Selecionou botao 'Ok' primeiro   
			cConcurso		:= 	aPerg2[1][1]	// Concurso de Selecao Publica
		Else // Selecionou botao 'Paramentos' primeiro 
			Pergunte(cPerg2,.F.)
			cConcurso		:= 	mv_par01	   	// Concurso de Selecao Publica
	    EndIf
		
		dbSelectArea( "SZ4" ) 
		dbSetOrder(1) // Z4_FILIAL + Z4_CODIGO +Z4_TBDEST + Z4_CPO
		If SZ4->(dbSeek( xFilial("SZ4") + cCodigo ) ) 
			cAliasArq 	:= SZ4->Z4_TBDEST
			cNomeArq  	:= SZ4->Z4_DESC
			cCondicao	:= SZ4->Z4_COND 		
			lCond := A210Form(cCondicao)		
	    Else                                                                          
	       	Help( ,, 'HELP',, OemToAnsi("Layout não cadastrado."), 1, 0)       
		    Return
		EndIf  

		If cAliasArq == 'SQG'
			//Verifica cadastro do Concurso
			SZ2->(dbsetorder(1))
			If !(SZ2->(dbseek(xFilial("SZ2")+cConcurso)))
		       	Help( ,, 'HELP',, OemToAnsi("Concurso não encontrado."), 1, 0)       
				Break
			ElseIf SZ2->Z2_STATUS <> '1' //Diferente de 1-Ativo
		       	Help( ,, 'HELP',, OemToAnsi("O Concurso selecionado não está mais ativo."), 1, 0)       
				Break
			EndIf
			//Verifica os cargos do Concurso
			cChaveSZ3 := xFilial("SZ3")+cConcurso
			SZ3->(dbsetorder(1))
			SZ3->(dbseek(cChaveSZ3))
			aCargos  := {}
			While SZ3->(!eof()) .and. SZ3->(Z3_FILIAL+Z3_CODIGO) == cChaveSZ3
				If SZ3->Z3_STATUS == '1'
					aadd(aCargos,{SZ3->Z3_CARGO2,SZ3->Z3_CARGO,fDesc("SQ3",SZ3->Z3_CARGO,"Q3_DESCSUM") })
				EndIf
				SZ3->(dbskip())
			EndDo
			If len(aCargos) == 0
		       	Help( ,, 'HELP',, OemToAnsi("Não há cargos ativos para o Concurso selecionado."), 1, 0)       
				Break
			EndIf
			//Verifica se ja existe algum curriculo vinculado ao Concurso
			SQG->(dbSetOrder(RetOrder("SQG","QG_FILIAL+QG_XCODCON+QG_CODFUN+QG_CIC")))
			If SQG->(dbseek(xFilial("SQG")+cConcurso))
				If !(MsgNoYes("Já existe currículo na base de dados vinculado ao Concurso selecionado. Deseja continuar e sobrepor os registros ?"))						
					Break
				EndIf
				While SQG->(!eof()) .and. SQG->QG_XCODCON == cConcurso
					If !(empty(SQG->QG_MAT))
				       	Help( ,, 'HELP',, OemToAnsi("Já existe currículo com matrícula preenchida para o Concurso selecionado." + CRLF + "A importação não será realizada."), 1, 0)       
						Break
					EndIf
					SQG->(dbskip())
				EndDo
				nSobrePoe := 1 //Sim
			EndIf				   
		EndIf				
			
		If !File(cArquivo)
			Help(" ",1,"A210NOPEN") // "Nao foi possivel abrir o arquivo."
			Break
		EndIf   

		// Cria arquivo Temporario      
		Cria_Temp()
		
		// Abre arquivo texto informado 
		nHandle := fOpen( cArquivo ,64)
		If Ferror() # 0 .Or. nHandle < 0
		    Help(" ",1,"A210NOPEN")	// "Nao foi possivel abrir o arquivo."
		    Break
		EndIf
		
		aFile   := Directory( cArquivo )
		nSize   := aFile[1,2]
		
		TXT       := fReadStr( nHandle,nSize )
		cTXTCopia := TXT // Copia de TXT para verificar o numero de linhas
		nLinhas   := 0
		nBytes    := 0
		//Verifica o numero de linhas do arquivo.
		While (Len(cTXTCopia) # 0)
			nBytes := (At( CHR(13)+ CHR(10),cTXTCopia )) + 1
			cTXTCopia := SubStr(cTXTCopia , nBytes + 1 , len(cTXTCopia))
			nLinhas++
			If (nBytes == 1)
				Exit
			EndIf
		End
		
		cTXTCopia := TXT // Copia de TXT novamente
		nBytes := (At( CHR(13)+ CHR(10),TXT )) + 1 // Numero de Bytes da primeira linha
		
		fSeek( nHandle,0,0 )
		
		// Cria a Regua de processamento de registros              
		tregs = nLinhas-1
		m_mult=1
		If tregs > 0
		    m_mult=70/tregs
		EndIf
		
		// Carrega Regua Processamento	                               
		ProcRegua(nLinhas)
		
		// PASSO 1 - Carregar todas as linhas do arquivo no array aReg
		For nX:= 1 To nLinhas
		
			// Move Regua Processamento	                                   
			IncProc("Importacao de dados") 
						
		    // Le cada linha do arquivo texto 
		    TXT := fReadStr( nHandle,nBytes )  	
				    

		    If ValType( lCond ) # "L"
				cLog := STR0011+cCodigo+" "+STR0012 // "Condicao do codigo "###"nao esta retornando valor logico"
				AADD(aTitleEr,cLog)
				AADD(aLogEr,STR0013+cCondicao) // "Condicao: "
		 		Exit
			EndIf 
			
			aAux 	:= {}  
			lPula	:= .F.
     		lVerfCamp := .T.
		
			
			 //Verifica se a Linha preenchida completamente.
		    If(nBytes < aCampos[len(aCampos)][3])
		    	nY := 1 
           	While(aCampos[nY][3] < nBytes)
           		nY++ 	
           	EnD           		
               	cLog := If(nY > 1 , STR0085 + "  " + aCampos[nY][7] , STR0086) //Não foi preenchido o campo###Linha não foi preenchida
               	lPula:= .T.
               	lVerfCamp := .F.
               	AADD(aTitleEr,cLog)							
               	AADD(aLogEr,STR0018+StrZero(nX,6)+" - "+Subs(TXT,1,Len(txt)-1)) // "Linha: "
		    EndIf
			        
			cTXTCopia := SubStr(cTXTCopia,nBytes + 1,len(cTXTCopia)) // Atualiza cTXTCopia, removendo a linha que foi verificada.
		    nBytes    := (At( CHR(13)+ CHR(10),cTXTCopia )) + 1	// Calcula os Bytes da prox.linha
			        	          		
			For nY := 1 to Len(aCampos)
				// Posicoes no array aCampos:
                // 1- Campo         	// 5- Ordem		// 9-  Picture
                // 2- Pos. Inicial		// 6- Ordem Log	// 10- Sufixo
                // 3- Pos.Final			// 7- Titulo
                // 4- Formula 			// 8- Tipo 
                		  			 
			    If !Empty( aCampos[nY][4] ) .And. (aCampos[nY][2] == 0 .And. aCampos[nY][3] == 0)
			        cErForm := A210Form(aCampos[nY][4])
                    If cErForm == "ERRO" 
						cLog := STR0014 //"Formula Invalida"
						AADD(aTitleEr,cLog)  
						AADD(aLogEr, STR0081+aCampos[nY][7] )  //"Campo " 					
			            lPula		:= .T.
			            cConteudo	:= ""
					Else
						cConteudo	:= cErForm
			        EndIf 
			    ElseIf (aCampos[nY][2] # 0 .And. aCampos[nY][3] # 0) .And. Empty( aCampos[nY][4] )
			    	   cConteudo := SubStr( TXT,aCampos[nY][2],aCampos[nY][3]-aCampos[nY][2]+1)
			    EndIf
		    		    		
		    	// Validacoes de campos especificos = MATRICULA/VERBA 
		    	If nY == 1 // Filial
		    		cCodFil	:= cConteudo 
		    	EndIf 

			 	If lPula 
			 		Exit 
			 	Else			
					AADD(aAux, cConteudo ) 	// Inclui funcionario importado	 
				EndIf		        	 				                         
				    				                                    
		    Next nY 
		    
			// Grava no array principal onde estao todos os registros a serem importados.
			If lCond .And. !lPula .And. Len(aAux) == Len(aCampos)
				AADD(aReg,aAux)     
				
			Else
				Loop
			EndIf
			
		Next nX
		
		lOK := .t.
		
		If cAliasArq == 'SQG'
			//Verifica se todos os codigos de cargos do arquivo txt existem na SZ3
			cInvalidos := ''
		    nPosCarg:= aScan(aStru,{|x| x[1] == "CODFUN" })
			For nX := 1 to len(aReg)
				If (nPosA := aScan(aCargos,{|x| alltrim(x[1]) == alltrim(aReg[nX][nPosCarg]) })) == 0
					If !(( alltrim(aReg[nX][nPosCarg]) + ' ') $ cInvalidos)
						cInvalidos += alltrim(aReg[nX][nPosCarg]) + ' '
					EndIf
				Else
					aReg[nX][nPosCarg] := aCargos[nPosA,2]	//Troca o codigo do cargo do TXT pelo do protheus		
				EndIf
			Next nX
			If !empty(cInvalidos)
		       	Help( ,, 'HELP',, OemToAnsi("No arquivo existem os códigos de cargo abaixo e os mesmos não constam no cadastro do Concurso:" + CRLF + cInvalidos), 1, 0)       
				lOK := .f.
			EndIf
		EndIf					
		
		If lOK
		
			// Abre pergunte para correta captura de parametros
			// na funcao RetPergLog (dentro de fMakeLog em GPEXREL)
			Pergunte(cPerg1,.F.) 
				 		
			// PASSO 2 - Gravar no arquivo temporario e realizar validacoes 
			fGravaTRP()  
			
			// PASSO 3 - Gravar no alias destino o conteudo do arquivo temporario           
		 	fGrava210()  
	 	
		EndIf

	 	// PASSO 4 - Gerar Log 
	 	fGerarLog(.T.,.F.,0,0,"") 
	 	 
	 	If Len(aLog) == 0 
			cLog := STR0011+cCodigo // "Condicao do codigo 
			AADD(aTitle,cLog)  
			AADD(aLog,{"  "+STR0031+" => "+cCondicao}) // "Nenhum registro atendeu a condicao de filtro do parametro"
		EndIf 
		
	 	fClose(nHandle)
		                                                                  
		fMakeLog(aLog,aTitle,"XRSP200A") // Log dos registros importados      
		
	End Sequence 
			
	// Se foi criado arquivo temporario de ser excluido    
	If ( Select( "TRP" ) > 0 )
		dbSelectArea("TRP")
		dbCloseArea()
		FErase(cArq1+GetDBExtension())
		FErase(cArq1+OrdBagExt())
	EndIf 
	
Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Cria_Temp ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria arquivo temporario e titulo de impressao.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ RSP210    												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Cria_Temp()      
Local aArea		:= GetArea()       
Local cTitulo	:= ""
Local cCond		:= ""
Local nCont		:= 0        
Local nX		:= 0

	dbSelectArea( "SZ4" ) 
	dbSetOrder(1) // Z4_FILIAL + Z4_CODIGO + Z4_TBDEST + Z4_CPO
	If SZ4->(dbSeek( xFilial("SZ4") + cCodigo ) )  
		While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == xFilial("SZ4") .And. SZ4->Z4_CODIGO = cCodigo  
			AADD(aCampos,{AllTrim(SZ4->Z4_CPO),SZ4->Z4_POSINI,SZ4->Z4_POSFIN,SZ4->Z4_FORM, Z4_ORDEM, Z4_ORDLOG })
	   		nCont++
	   	SZ4->(dbSkip())
		End  
	EndIf    
	
	// Ordena array de acordo com campo 'Ordem de Log'
	ASort(aCampos,,,{|x,y| x[6] < y[6]})  
	
	If nCont > 0 
		dbSelectArea("SX3")
		DbSetOrder(2) //X3_CAMPO 
				
		For nX := 1 to Len(aCampos)
			If SX3->(dbSeek( aCampos[nX][1] ) )		 							
				cCampo 	:= aCampos[nX][1]
				nPos	:= AT("_",cCampo)
				cSufixo := SUBSTR(cCampo,nPos+1,Len(cCampo))  
				AADD(aStru,{cSufixo,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  					
				AADD(aCampos[nX],SX3->X3_TITULO )
				AADD(aCampos[nX],SX3->X3_TIPO)  
				AADD(aCampos[nX],SX3->X3_PICTURE)      
				AADD(aCampos[nX],cSufixo)
				// Inclui no titulo de impressao apenas qtde do limite de impressao
				If nX <= nLimImp  
					cTitulo	:= SX3->X3_TITULO
					cTitulo	:= SubStr(cTitulo+Space(nColTam-Len(cTitulo)),1,nColTam)
					cTitImpres += cTitulo+Space(nColSpc)
				EndIf 		 													 										
		    EndIf
		Next nX	     //"Linha  "
		cTitImpres:= STR0067 + cTitImpress	
		
		// Adiciona no final da estrutura campo que determina posicao no array aReg
		AADD(aStru,{"POSREG","N",5,0})	

	EndIf   	
 	
	cArq1 	  	:= CriaTrab(aStru, .T. )
	dbUseArea(.T.,,cArq1,"TRP",.F.,.F.)     

 	If cAliasArq == "SQG"   
 		cCond 	:= "FILIAL" 	//"FILIAL + CIC" // Filial + CPF 
 	Else
 		cCond 	:= ""  	// Filial 
 	EndIf	                                                                   
 	
	IndRegua("TRP",cArq1,cCond)	//"Selecionando Registros ..."    
	
	RestArea(aArea)

Return( Nil )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fGravaTRP ³ Autor ³ Equipe RH            ³ Data ³ 18/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua Gravacao dos dados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ RSP210   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGravaTRP()  
Local aArea		  := GetArea()
Local cAlias	  := "TRP"         
Local nX		  := 0  
Local nY 		  := 0
Local nPosCPF	  := 0 
Local nPosCarg	  := 0 
Local xConteudo
   
	Begin Sequence   
	
        // Clona array de registros gerais para utilizar na impressao da linha na funcao fGerarLog
        aRegSv := aClone(aReg)
        
	    dbSelectArea("TRP") 
	    dbSetOrder(1)  
	    
		If Len(aReg) > 0  
		
			// ESPECIFICOS - CURRICULOS
			If cAliasArq == "SQG"  
				// Todos os campos obrigatorios devem fazer parte da chave 
			    nPosCPF	:= aScan(aStru,{|x| x[1] == "CIC" })
			    nPosCarg:= aScan(aStru,{|x| x[1] == "CODFUN" })
				If nPosCPF>0 .And. nPosCarg>0  				
					For nX := 1 to Len(aReg)  	   
						cKey := aReg[nX][1] + aReg[nX][nPosCPF] + cConcurso + aReg[nX][nPosCarg] // Filial + CPF + Concurso + Cargo
						If !( TRP->( dbSeek( cKey ) ) )  // Inclusao
							RecLock("TRP",.T. ) 		
							// Grava conteudo no arquivo temporario
							For nY := 1 to Len(aCampos)			
								Do Case       
									Case aCampos[nY][8] == "C" 
										xConteudo := aReg[nX][nY]
									Case aCampos[nY][8] == "N"   
										xConteudo := Val(aReg[nX][nY])
										aReg[nX][nY] :=  Transform(Val(aReg[nX][nY]),aCampos[nY][9])
									Case aCampos[nY][8] == "D"   
											cData	:= aReg[nX][nY]
											cData	:= If( "/" $ cData,;
															cData, ;
												   			Substr(cData,1,2)+  "/" + Substr(cData,3,2) + "/" +  Substr(cData,5, Len(cData));
												              ) 
											aReg[nX][nY] := cData
										xConteudo := CtoD(cData)
								End Case												
								&(cAlias+"->"+aCampos[nY][10]) := xConteudo	      
							Next nY	  
							&(cAlias+"->"+"POSREG") := nX 
				 	   		MsUnlock()
				 	 	Else
				 	 		// Adiciona no Log - Arquivo nao importado				
							nPosReg	:= nX                   
							fGerarLog(.F.,.T.,nPosReg,1,"")
							Loop
				 	 	EndIf
					Next nX 
				EndIf 				 
			EndIf
		EndIf
        
    End Sequence
    
	RestArea(aArea)

Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fGrava210 ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua gravacao dos dados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ RSP210   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGrava210() 
Local aArea		    := GetArea() 
Local aErro		    := {0,0}
Local cData		    := "" 
Local nX		    := 0 
Local nY            := 0
Local nErro		    := 0
Local nPosReg	    := 0 
Local nPosSbr	    := 0 
Local nPosCod	    := 0
Local xConteudo	    := 0 
Local cPrefixo		:= cAliasArq

	DbSelectArea(cAliasArq) 
	If cAliasArq == "SQG"
		dbSetOrder(RetOrder("SQG","QG_FILIAL+QG_CIC+QG_XCODCON+QG_CODFUN"))
		cPrefixo := "QG"
		SRA->(dbsetorder(RetOrder("SRA","RA_CIC+RA_FILIAL+RA_MAT")))
	EndIf
	
	DbSelectArea("TRP")   
	TRP->(DbGoTop()) 
	nY := 1 //Inicializa o contador de linhas da TRP.
	
	Begin Transaction 
	
		While !TRP->( EoF() )  
						
			// ESPECIFICOS CURRICULOS
			If cAliasArq == "SQG" 
				lSRA := .f.
				cChave := TRP->FILIAL + TRP->CIC + cConcurso + TRP->CODFUN         
				If SQG->(dbSeek(cChave)) 
					If nSobrePoe == 1 //Sim
						RecLock( cAliasArq,.F. ) // Altera   
						For nX := 1 to Len(aStru)			
							If alltrim(aStru[nX][1]) $ "POSREG/CURRIC" 
								Loop
							Else
								xConteudo := TRP->&(aStru[nX][1])
							EndIf										
							&(cAliasArq+"->"+cPrefixo+"_"+aStru[nX][1]) :=  xConteudo   
						Next nX 
						SQG->QG_DESCFUN := aCargos[ aScan(aCargos,{|x| alltrim(x[2]) == SQG->QG_CODFUN }),  3]

						//Verifica se o candidato já consta como funcionario ativo
						If empty(SQG->QG_SITUAC)
							If SRA->(dbseek(SQG->QG_CIC))
								While SRA->(!eof()) .and. SRA->RA_CIC == SQG->QG_CIC
									If empty(SRA->RA_DEMISSA)
										lSra := .t.
										exit
									EndIf
									SRA->(dbskip())
								EndDo
							EndIf                 
							SQG->QG_SITUAC := if(lSRA,'FUN','001')
						ElseIf SQG->QG_SITUAC == 'FUN
							lSRA := .t.
						EndIf
					
						// Adiciona no Log - Arquivo importado 
						nPosReg	:= TRP->POSREG    
						MsUnlock() 
						nPosSbr := aScan(aRegSbr,{|x| x[1] == cChave}) 
						If nPosSbr == 0          
							AADD(aRegSbr,{ cChave, nPosReg , 0 } ) // Adiciona no array de reg sobrepostos  
						EndIf
						fGerarLog(.F.,.F.,nPosReg,0,cChave,lSRA)														
					Else
						// Adiciona no Log - Arquivo nao importado (itens da chave)				
						nPosReg	:= TRP->POSREG                    
						fGerarLog(.F.,.T.,nPosReg,1,"")
						TRP->( dbSkip() )   
						Loop
					EndIf		
				Else 				                               
					RecLock( cAliasArq,.T. ) // Inclui
					For nX := 1 to Len(aStru)			
						If aStru[nX][1] == "POSREG"  
							Loop
						Else
							xConteudo := TRP->&(aStru[nX][1])
						EndIf										
						&(cAliasArq+"->"+cPrefixo+"_"+aStru[nX][1]) :=  xConteudo   
					Next nX     
					SQG->QG_CURRIC  := GetSX8Num("SQG","QG_CURRIC")
					SQG->QG_XCODCON := cConcurso
					SQG->QG_DESCFUN := aCargos[ aScan(aCargos,{|x| alltrim(x[2]) == SQG->QG_CODFUN }),  3]
					
					//Verifica se o candidato já consta como funcionario ativo
					If SRA->(dbseek(SQG->QG_CIC))
						While SRA->(!eof()) .and. SRA->RA_CIC == SQG->QG_CIC
							If empty(SRA->RA_DEMISSA)
								lSra := .t.
								exit
							EndIf
							SRA->(dbskip())
						EndDo
					EndIf                 
					SQG->QG_SITUAC := if(lSRA,'FUN','001')
					
					// Adiciona no Log - Arquivo importado 
					nPosReg	:= TRP->POSREG
					MsUnlock()
					ConfirmSX8()
					fGerarLog(.F.,.F.,nPosReg,0,"",lSRA) 	      
				EndIf	
			EndIf	

			
		nY++	//Contabiliza as Linhas da TRP
			
		TRP->( dbSkip() ) 
			
		Enddo 
		
	End Transaction 
	
	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fGerarLog ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para geracao de log.							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGerarLog(lFirstGrv,lError,nPosReg,nErro,cChave,lSRA)
Local aArea		:= GetArea()
Local cLog		:= ""  
Local cLinha	:= "" 
Local cTpFor	:= ""
Local cTpOrg	:= ""
Local cDesc		:= ""
Local xTxt1     := ""
Local xTxt2		:= ""
Local xConteudo	:= "" 
Local lSobrepoe	:= .F.  
Local nPosGrv	:= 0   
Local nPosLg	:= 0  
Local nPosVlr	:= 0
Local nX		:= 0

DEFAULT nPosReg	:= 0
DEFAULT nErro	:= 0   
DEFAULT cChave	:= ""
DEFAULT lSRA	:= .f.

	If lFirstGrv  	// Grava todas as informacoes em aTitle/aLog
		// Associa titulo de impressao
		If Len(aLogVld) > 0
			cLog 		:= oEmToAnsi("Registros Importados") + " -> " + AllTrim(cNomeArq)  + " (" + cAliasArq + ")    " 	//-- "Registros Importados + ## + Nome Tabela + ## Verba  + ##" 	   
			AADD(aTitle,cLog)   
			AADD(aLog, { Space(2) + cTitImpres }  )  
			nPosGrv	:= Len(aLog)
			// Grava log dos registros importados  
			If Len(aLogVld) > 0   			
				For nX := 1 to Len(aLogVld)
		  			AADD( aLog[nPosGrv], Space(2) + aLogVld[nX] )   
				Next nX	
			EndIf
		EndIf	 
		If Len(aLogEr) > 0   	     
			// Grava log dos registros importados  		 			
			For nX := 1 to Len(aLogEr)
	  			AADD( aLog, { Space(2) + aTitleEr[nX] })
	  			nPosGrv	:= Len(aLog) 
	  			AADD( aLog[nPosGrv], Space(2) + aLogEr[nX]  )   
			Next nX			
		EndIf		
	ElseIf !lError .And. nPosReg > 0  .And. nErro == 0 // Arquivos validos importados 
		    // Tratamento quando sobrepor
			If nSobrePoe == 1
		    	nPosSbr	:= aScan(aRegSbr,{|x| x[1] == cChave})  
				If nPosSbr > 0
					If Empty(aRegSbr[nPosSbr][3])
						aRegSbr[nPosSbr][3] := Len(aLogVld)+1 // Guarda posicao no aLogVld onde foi gravado 
					Else
						 lSobrepoe 	:= .T.
						 nPosLg		:=  aRegSbr[nPosSbr][3]   // Substitui registro no aLogVld
					EndIf
				EndIf
			EndIf  
			xTxt2 := StrZero(nPosReg,6) + " " 						
			
			For nX := 1 to Len(aCampos)   
				// Fixar tamanho 
				//           20         2           20
				// |Titulo------------|---|Titulo------------|
				// |Conteudo----------|---|Conteudo----------| 
				// Somente imprime os campos obrigatorios
				If nX  <= nLimImp   
					xConteudo	:= AllTrim(aReg[nPosReg][nX])
					If lSRA .and. aCampos[nX,1] == 'QG_NOME'
						xConteudo := "(F)"+xConteudo
					EndIf
					xConteudo 	:= SubStr(xConteudo+Space(nColTam-Len(xConteudo)),1,nColTam)
					xTxt2 		+= xConteudo + Space(nColSpc)
					 
				EndIf
			Next nX  
			xTxt1	+= xTxt2    
			    
		    If lSobrepoe      
		    	aLogVld[nPosLg] := xTxt1  
		    Else     		    	 
		    	AADD( aLogVld , xTxt1 )   
		    EndIf

    ElseIf lError .And. nPosReg > 0  .And. nErro > 0 // Arquivos invalidos NAO importados        	
    	// ESPECIFICOS
		If cAliasArq == "SQG" 
			For nX := 1 to Len(aReg[nPosReg]) 
				cLinha+= aRegSv[nPosReg][nX]
			Next nX 					
		    If nErro == 1 	// Registro ja existe 
		    	cLog := STR0068 + STR0050 //"Analise o conteudo dos campos obrigatorios do alias destino  - "###"Registro(s) nao importado(s)." 
				AADD(aTitleEr,cLog)    
				AADD(aLogEr,STR0018+StrZero(nPosReg,6)+" - "+cLinha) // "Linha: "	
			EndIf
		EndIf    	
	EndIf
		
 
    RestArea(aArea)
    
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Form ³ Autor ³ Wiliam                ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento da formula.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A210Form( cFormula,Txt )
Local bErro      := ErrorBlock( { |e| A210Error( e ) } )
Local lResult    := .T.
Local cEnd
	
	cFormula := AllTrim( cFormula )
	If Len(cFormula) > 0
	    lResult := A210Exec( @cFormula )
	EndIf     
	
	ErrorBlock( bErro ) 
	
	If ValType(cFormula)=="N"
	    cFormula := Str(cFormula)
	ElseIf	ValType(cFormula)=="D"   
		cFormula := DtoC(cFormula) 
	EndIf
	
	If !lResult
	    cFormula := "ERRO"
	EndIf

Return ( cFormula )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Exec ³ Autor ³ Wiliam                ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executa a formula e retorna o resultado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A210Exec( cFormula )

	Local lRet
	
	Begin Sequence
	    cFormula := &(cFormula)
	    lRet := .T.
		Recover
	    lRet := .F.
	End Sequence

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Error ³ Autor ³ Wiliam               ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento de erros da formula.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A210Error( oError )

	If oError:gencode > 0
		Help(" ",1,"A210FORM") // "A formula do parametro de importacao de valores variaveis esta com erro."       
		Break
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RSP210XB  ³ Autor ³ Equipe RH            ³ Data ³ 28/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Constroi F3 para tabela SZ4.				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function RSP210XB( cTabela, cCpoRet )
Local aArea			:= GetArea()
Local aObject 		:= {}              
Local aSize 		:= {}  
Local aCordW 		:= {125,0,400,635} 
Local aSvRot 		:= Nil       
Local aCGD			:= {}
Local cCampo
Local cCaption
Local cPict
Local cValid
Local cF3
Local cWhen    
Local cBlkGet
Local cBlkWhen    
Local cBlkVld     
Local cSvField		:= &(ReadVar())
Local cMyCpo 		:= ""   
Local cLineOk 		:= "AllwaysTrue()"
Local cAllOk  		:= "AllwaysTrue()"
Local cCpoAux		:= "" 
Local cPesq    		:= Space(30)    
Local lDelGetD 		:= .F. 
Local lAllOk 
Local lExist   		:= .F.
Local nCpoRet 		:= 0
Local nOpca	   		:= 0 
Local nObject
Local nAuxWidth 	:= 0
Local nCount 		:= 0
Local nOpcx			:= 7 
Local nX
Local nY
Local nLargSay
Local nLargGet
Local nCntCmb 		:= 0
Local nMaxCmb 		:= 5	//# Nr.Maximo de opcoes no Combo
Local nPos 			:= At("+", cCpoRet )  
Local oDlg  
Local oSay
Local oGet 
Local oSaveGetdad 	:= Nil
Local oTop
Local oBottom
Local i
Local uConteudo 

Private aCombo  	:= {}
Private aMyCombo	:= {}
Private aSXBCols   	:= {}
Private aSXBHeader 	:= {}
Private aC 			:= {}  
Private aColsBkp 	:= {}
Private cCombo  	:= "" 
Private cFilSZ4  	:= ""
Private cDescSZ4 	:= ""   
Private cTitulo 	:= ""
Private lPesqComp 	:= .F. //Variavel que indica se a pesquisa esta sendo feita com mais de um campo
Private lCheck		
Private nUsado  	:= 0 
Private nMax 		:= 0   
Private oCombo
Private oPesq
Private oBtn1
Private oCheckBox  
// OBSERVACAO IMPORTANTE
// Ao serem incluidos novos alias, campo Filial
// devera ser incluido nessa variavel para montagem
// do F3 com filtro  
Private cCposFiltros	:= "QG_FILIAL*"

	If cTabela == Nil.Or. cCpoRet == Nil
		MsgAlert(OemToAnsi(STR0058),OemToAnsi(STR0047))	//"Atencao"###"Nao e possivel continuar pois faltam parametros nesta funcao!"
		Return(.F.)
	EndIf

	If nPos > 0
		lPesqComp := .T.
	EndIf

	cFilSZ4  := xFilial("SZ4")
	cDescSZ4 := OemToAnsi("Layout de Importação de Currículos")

	// Posiciona no SZ4
	dbSelectArea("SZ4")
   
	// Monta conteudo dos objetos
	U_RSP210MA(cTabela,xFilial("SZ4")) 

	// Variaveis inicializadas no teste
	cTitulo		:= cTabela+" - "+cDescSZ4
	nMax 		:= Len(aSXBCols)
	aColsBkp 	:= aClone(aSXBCols)
	
	// Variaveis inicializadas no teste
	AADD(aC,{"cMyCpo", {15,001},"",,,,.F.,})     

	// Variaveis inicializadas no teste
	nCount++
	__cLineOk := cLineOK
	__nOpcx	 := nOpcx
	If nCount > 1
		oSaveGetdad := oGetDados
		oSaveGetdad:oBrowse:lDisablePaint := .t.
	EndIf

	oGets := {}  
	
	If Type("aRotina") == "A"
		aSvRot := aClone(aRotina)
	EndIf
	aRotina := {}
	For nX := 1 to nOpcX
		AADD(aRotina,{"","",0,nOpcx})
	Next

	aCGD	:=Iif(Len(aCGD)==0,{34,5,128,315},aCGD)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oMainWnd
        
		If Len(aC) > 0			
		
			For nX := 1 to Len(aSXBHeader)				
				// Monta o aCombo 
				AADD( aCombo, Alltrim(aSXBHeader[nX][1]) )
				aAdd( aMyCombo, {Alltrim(aSXBHeader[nX][1]),Alltrim(aSXBHeader[nX][2])} )		
			Next nX
   			
			@ 000,000 SCROLLBOX oTop
			Aadd(aSize,aCGD[1]+13)
			Aadd(aObject,oTop)
			nObject := 2
					
			@ 005,005 SAY OemToAnsi(STR0060) SIZE 35,07 OF oTop PIXEL	//"Pesquisar por: "
			@ 005,045 MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 080,010 OF oTop PIXEL  			
			@ 005,145 MSGET oPesq VAR cPesq PICTURE "@!" VALID Iif(!Empty(cCombo),PesqDados(cPesq),fValPesq()) SIZE 80,10 OF oTop PIXEL 						
			@ 013,475 BTNBMP oBtn1 RESOURCE "btpesq" SIZE 025,025 OF oTop PIXEL ACTION ( PesqDados(cPesq) )			
			
			For i:=1 to Len(aC)
				cCampo:=aC[i,1]
				nX:=aC[i,2,1]-13
				nY:=aC[i,2,2]
				cCaption:=Iif(Empty(aC[i,3])," ",aC[i,3])
				cPict:=Iif(Empty(aC[i,4]),Nil,aC[i,4])
				cValid:=Iif(Empty(aC[i,5]),".T.",aC[i,5])
				cF3:=Iif(Empty(aC[i,6]),NIL,aC[i,6])
				cWhen    := Iif(aC[i,7]==NIL,".T.",Iif(aC[i,7],".T.",".F."))
				cWhen    := Iif(!(Str(nOpcx,1,0)$"346"),".F.",cWhen)
				cBlKSay  := "{|| OemToAnsi('"+cCaption+"')}"
				
				oSay     := TSay():New( nX+1, nY, &cBlkSay,oTop,,, .F., .F., .F., .T.,,,,, .F., .F., .F., .F., .F. )
				nLargSay := GetTextWidth(0,cCaption) / 1.8  // estava 2.2
				cCaption := oSay:cCaption
				
				cBlkGet  := "{ | u | If( PCount() == 0, "+cCampo+","+cCampo+":= u ) }"
				cBlKVld  := "{|| "+cValid+"}"
				cBlKWhen := "{|| "+cWhen+"}"
							
				oGet := TGet():New( nX, nY+nLargSay,&cBlKGet,oTop,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
				AADD(oGets,oGet)
			Next
		EndIf

		oGetDados := MsNewGetDados():New(aCGD[1],;			// nTop
										 aCGD[2],;   		// nLelft
										 aCGD[3],; 			// nBottom
			                             aCGD[4],;			// nRright
										 Nil,;	    		// controle do que podera ser realizado na GetDado - nstyle
										 "SXBMod2LOk()",;	// Funcao para validar a edicao da linha - ulinhaOK  (funcao no GPEA310)
										 "AllwaysTrue()",;	// Funcao para validar todas os registros da GetDados - uTudoOK
		  								 Nil,;				// cIniCPOS
										 Nil,;		        // aAlter
										 0,; 				// nfreeze
										 nMax,;  			// nMax
										 Nil,;		 		// cFieldOK
										 Nil,;				// usuperdel
										 .F.,;	        	// udelOK
										 @oDlg,;        	// objeto de dialogo - oWnd
										 @aSXBHeader,;		// Vetor com Colunas - AparHeader
										 @aSXBCols;			// Vetor com Header - AparCols
							)
		
		AADD(aObject,oGetDados:oBrowse)
		AADD(aSize,Nil)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,lAllOk:=__Mod2OK(cAllOk),Iif(lAllOk,oDlg:End(),nOpca:=0)},{||oDlg:End()},,),;
									AlignObject(oDlg,aObject,1,nObject,aSize),oGetDados:oBrowse:Refresh())

	nCount--
	If nCount > 0
		oGetDados := oSaveGetDad
		oGetDados:oBrowse:lDisablePaint := .f.
	EndIf
	If ValType(aSvRot) == "A"
		aRotina := aClone(aSvRot)
	EndIf

	If nOpca == 1 .And. Len(aSXBCols) > 0
		If !lPesqComp
			nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
			VAR_IXB  := aSXBCols[oGetDados:nAt,nCpoRet]
		Else         
			VAR_IXB := ""	
			While lPesqComp
				cCpoAux := Substr(cCpoRet, 1, nPos - 1)
				cCpoRet := Substr(cCpoRet, nPos +1)    
	
				nCpoRet := GdFieldPos(cCpoAux, aSXBHeader)
				VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
	
				nPos := At("+", cCpoRet )
				lPesqComp := If (nPos > 0, .T., .F.)
				
				If nPos == 0
					nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
					VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
				EndIf
			EndDo
		EndIf
	Else
		VAR_IXB := cSvField
		RestArea(aArea)
		Return .T.
	EndIf

RestArea( aArea )

Return(nOpca == 1)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RSP210MA       ³ Autor ³ Equipe RH        ³ Data ³  22/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta aCols com campos para o F3 SZ4.				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP210  									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
User Function RSP210MA(cTab,cFilSZ4)   
Local aArea	  		:= GetArea()
Local nCont			:= 0    
Local nCnt
Local nQtdLin		:= 7000
Local uValor

    // Monta aHeader
	dbSelectArea("SX3")
	dbSetOrder(1) // X3_ARQUIVO + X3_ORIGEM	  
	If SX3->(dbSeek(cTab))
		While !Eof() .And. SX3->X3_ARQUIVO == cTab		
			If AllTrim(SX3->X3_CAMPO) $ "Z4_FILIAL*Z4_CODIGO*Z4_DESC*RGJ_TBDEST"
				aAdd(aSXBHeader,{ 	SX3->X3_TITULO, ;	//# 01
									SX3->X3_CAMPO, ;	//# 02
									SX3->X3_PICTURE, ;	//# 03
									SX3->X3_TAMANHO, ;	//# 04
									SX3->X3_DECIMAL, ;	//# 05
									Nil, ;				//# 06
									Nil, ;				//# 07
									SX3->X3_TIPO, ;		//# 08
									Nil,  ;	     		//# 09
									SX3->X3_CONTEXT } )	//# 10 Real ou Virtual  
							
			EndIf
			dbSkip()
		EndDo 
	EndIf 
	
	// Monta aCols
	dbSelectArea( "SZ4" )
	SZ4->( dbSetOrder( 1 ) )	// Z4_FILIAL + Z4_CODIGO 
	If SZ4->(dbSeek(cFilSZ4))
		While ! Eof() .And. SZ4->Z4_FILIAL == ( cFilSZ4  ) 
			If allTrim(SZ4->Z4_CPO) $ cCposFiltros // Campos 'Filial' dos alias destino	 	
				AADD(aSXBCols,Array(Len(aSXBHeader)+1))
				For nCnt := 1 To Len(aSXBHeader)	
					cCampo := Alltrim(aSXBHeader[nCnt,02])		
						If aSXBHeader[nCnt,08] == "N"
							uValor := Val( SZ4->&(cCampo) )
						ElseIf aSXBHeader[nCnt,08] == "D"
							uValor := Ctod( SZ4->&(cCampo) )
						Else
							uValor := SZ4->&(cCampo)
						EndIf
						aSXBCols[Len(aSXBCols)][nCnt] := uValor		  
				Next nCnt
				aSXBCols[Len(aSXBCols)][Len(aSXBHeader)+1] := .F.
				nCont += 1
				If nCont > nQtdLin
					Exit
				EndIf 
			EndIf
			dbSkip()
		EndDo  
	EndIf  

	RestArea( aArea )

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ rsp210Ok      ³ Autor ³ Equipe RH 		     ³ Data ³18/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Confirma configuracao de parametros. 						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210 						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function rsp210Ok()
Return (MsgYesNo(OemToAnsi(STR0046),OemToAnsi(STR0047))) // "Confirma configuracao dos parametros?"##"Atencao"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fCargoSZ3      ³ Autor ³ Equipe RH 		     ³ Data ³18/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca o codigo do cargo na SZ3 com base no codigo do TXT        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP210 						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fEstCiv(cEstCiv)
Local cRet := left(cEstCiv,1)
If !(cRet $ 'S/C/V')
	cRet := ""
EndIf
Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AjPerg    ³ Autor ³                        ³Data ³ 05.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Verificacao de Perguntas                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjPerg(cPerg)

Local j, i
Local _sAlias := Alias()
Local aHelp   := {}
	
dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,10)
aRegs:={}

If alltrim(cPerg) == alltrim(cPerg1)
	aHelp :={" Informe ou selecione o arquivo TXT que ",;
			 " contem os dados a serem importados."	}
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
	aAdd(aRegs,{cPerg,'01','Arquivo ?                     ','','','mv_ch1','C',99,0,0,'G','fDir()                          ','mv_par01','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
	aHelp :={" Informe ou selecione o código do Layout ",;
			 " de importação que deverá ser utilizado."	}
	aAdd(aRegs,{cPerg,'02','Layout ?                      ','','','mv_ch2','C',03,0,0,'G',"NaoVazio() .And. ExistCpo('SZ4')",'mv_par02','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','SZ4','','',aHelp})
Else
	aHelp :={" Informe ou selecione o Concurso ao qual ",;
			 " será vinculada a importação dos ",;
			 " currículos."	}
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
	aAdd(aRegs,{cPerg,'01','Concurso ?                    ','','','mv_ch1','C',10,0,0,'G',"NaoVazio() .And. ExistCpo('SZ2')",'mv_par01','               ','','','','','               ','','','','','             ','','','','','              ','','','','','               ','','','','SZ2','','',aHelp})
EndIf

ValidPerg(aRegs,cPerg,.T.)

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return

