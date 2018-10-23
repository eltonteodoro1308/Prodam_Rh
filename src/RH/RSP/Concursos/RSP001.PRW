#INCLUDE "PROTHEUS.CH"

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё RSP001   ЁAutorЁ Marcos Pereira          Ё Data Ё12/02/2016Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o Ё Cadastro de Concursos X Cargos                             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           Ё
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁBOPS       ЁMotivo da Alteracao                Ё
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                                   Ё
Ё            Ё          Ё           Ё                                   Ё
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддды/*/
User Function RSP001()

Local aArea 		:= GetArea()
Local aAreaSZ2		:= SZ2->( GetArea() )
Local aAreaSZ3		:= SZ3->( GetArea() )

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁVerifica se o Modo de Acesso do SZ2 e SZ3 sao Iguais          Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( xRetModo( "SZ2" , "SZ3" , .T. ) )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define Array contendo as Rotinas a executar do programa      Ё
	Ё ----------- Elementos contidos por dimensao ------------     Ё
	Ё 1. Nome a aparecer no cabecalho                              Ё
	Ё 2. Nome da Rotina associada                                  Ё
	Ё 3. Usado pela rotina                                         Ё
	Ё 4. Tipo de Transa┤└o a ser efetuada                          Ё
	Ё    1 - Pesquisa e Posiciona em um Banco de Dados             Ё
	Ё    2 - Simplesmente Mostra os Campos                         Ё
	Ё    3 - Inclui registros no Bancos de Dados                   Ё
	Ё    4 - Altera o registro corrente                            Ё
	Ё    5 - Remove o registro corrente do Banco de Dados          Ё
	Ё    6 - Copiar                                                Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	Private aRotina := MenuDef() 
	Private cCadastro := OemToAnsi( "SeleГЦo PЗblica X Cargos" )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Chama a Funcao de Montagem do Browse                                   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	mBrowse( 6 , 1 , 22 , 75 , "SZ2" )

End Sequence
		
/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura os Dados de Entrada 											 Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
RestArea( aAreaSZ3 )
RestArea( aAreaSZ2 )
RestArea( aArea	   )

Return( NIL )

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё RSP001   ЁAutorЁ Marcos Pereira          Ё Data Ё12/02/2016Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o Ё Cadastro de Concursos X Cargos                             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁRSP001Mnt( cAlias , nReg , nOpc , lDlgPadSiga )			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁcAlias 		= Alias do arquivo                          	Ё
Ё          ЁnReg  		= Numero do registro                        	Ё
Ё          ЁnOpc   		= Numero da opcao selecionada               	Ё
Ё          ЁlDlgPadSiga	= Dialog no Padrao Siga                     	Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁRSP001()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function RSP001Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

Local aArea			:= GetArea(Alias())
Local aSvKeys		:= GetKeys()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aSZ2Header	:= {}
Local aSZ2Cols		:= {}
Local aSvSZ2Cols	:= {}
Local aSZ2Fields	:= {}
Local aSZ2Altera	:= {}
Local aSZ2NaoAlt	:= {}
Local aSZ2VirtEn	:= {}
Local aSZ2NotFields	:= {}
Local aSZ2Recnos	:= {}
Local aSZ2Keys		:= {}
Local aSZ2VisuEn	:= {}
Local aSZ3GdAltera  := {}
Local aSZ3GdNaoAlt	:= {}
Local aSZ3Recnos	:= {}
Local aSZ3Keys		:= {}
Local aSZ3NotFields	:= {}
Local aSZ3VirtGd	:= {}
Local aSZ3VisuGd	:= {}
Local aSZ3Header	:= {}
Local aSZ3Cols		:= {}
Local aSZ3Query		:= {}
Local aLog			:= {}
Local aLogTitle		:= {}
Local aLogGer		:= {}
Local aLogGerTitle	:= {}
Local aButtons		:= {}
Local aFreeLocks	:= {}
Local bSZ3GdDelOk	:= { |lDelOk| CursorWait() , lDelOk := SZ3GdDelOk( "SZ3" , NIL , nOpc , cCodSZ2 ) , CursorArrow() , lDelOk }
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }
Local bDialogInit	:= { || NIL }
Local bGetSZ2		:= { || NIL } 
Local bGetSZ3		:= { || NIL }
Local bSZ3Sort		:= { || NIL }
Local cSZ2KeySeek	:= ""
Local cFilSZ2		:= ""
Local cCodSZ2		:= ""
Local cMsgYesNo		:= ""
Local cTitLog		:= ""
Local lLocks		:= .F.
Local lExecLock		:= ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
Local lExcGeraLog	:= .F.
Local nOpcAlt		:= 0
Local nSZ2Usado		:= 0
Local nSZ3Usado		:= 0
Local nLoop			:= 0
Local nLoops		:= 0
Local nOpcNewGd		:= IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
Local nSZ3PosItem	:= 0
Local nSZ3ItemOrd	:= RetOrdem( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_CARGO" )
Local nSZ3GhostCol	:= 0
Local oDlg			:= NIL
Local oEnSZ2		:= NIL	
Local oGdSZ3		:= NIL

Private aSvSZ3Cols	:= {}
Private nGetSX8Len	:= GetSX8Len()
Private nAlter		:= nOpc
Private aGets
Private aTela

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Coloca o ponteiro do Cursor do Mouse em Estado de Espera     Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorWait()

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁCheca a Opcao Selecionada									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	aRotSetOpc( cAlias , @nReg , nOpc )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta os Dados para a Enchoice							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	aSZ2NotFields	:= { "Z2_FILIAL" }
	bGetSZ2			:= { |lLock,lExclu|	IF( lExecLock , ( lLock := .T. , lExclu	:= .T. ) , aSZ2Keys := NIL ),;
										aSZ2Cols := SZ2->(;
															GdBuildCols(	@aSZ2Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																			@nSZ2Usado		,;	//02 -> Numero de Campos em Uso
																			@aSZ2VirtEn		,;	//03 -> [@]Array com os Campos Virtuais
																			@aSZ2VisuEn		,;	//04 -> [@]Array com os Campos Visuais
																			"SZ2"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																			aSZ2NotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																			@aSZ2Recnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																			"SZ2"		   	,;	//08 -> Alias do Arquivo Pai
																			NIL				,;	//09 -> Chave para o Posicionamento no Alias Filho
																			NIL				,;	//10 -> Bloco para condicao de Loop While
																			NIL				,;	//11 -> Bloco para Skip no Loop While
																			NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
																			NIL				,;	//14 -> Se Sera considerado o Inicializador Padrao
																			NIL				,;	//15 -> Opcional, Carregar Todos os Campos
																			NIL				,;	//16 -> Opcional, Nao Carregar os Campos Virtuais
																			NIL				,;	//17 -> Opcional, Utilizacao de Query para Selecao de Dados
																			NIL				,;	//18 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
																			NIL				,;	//19 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
																			NIL				,;	//20 -> Carregar Coluna Fantasma
																			NIL				,;	//21 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
																			NIL				,;	//22 -> Verifica se Deve Checar se o campo eh usado
																			NIL				,;	//23 -> Verifica se Deve Checar o nivel do usuario
																			NIL				,;	//24 -> Verifica se Deve Carregar o Elemento Vazio no aCols
																			@aSZ2Keys		,;	//25 -> [@]Array que contera as chaves conforme recnos
																			@lLock			,;	//26 -> [@]Se devera efetuar o Lock dos Registros
																			@lExclu			 ;	//27 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																	    );
														  ),;
										IF( lExecLock , ( lLock .and. lExclu ) , .T. );
	  					} 
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁLock do Registro do SZ2									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lLocks := WhileNoLock( "SZ2" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZ2 ) )
		Break
	EndIF
	CursorWait()
	aSvSZ2Cols		:= aClone( aSZ2Cols )
	cFilSZ2			:= SZ2->Z2_FILIAL
	cCodSZ2			:= SZ2->Z2_CODIGO
	cSZ2KeySeek		:= ( cFilSZ2 + cCodSZ2 )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Cria as Variaveis de Memoria e Carrega os Dados Conforme o arЁ
	Ё quivo														   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	For nLoop := 1 To nSZ2Usado
		aAdd( aSZ2Fields , aSZ2Header[ nLoop , 02 ] )
		SetMemVar( aSZ2Header[ nLoop , 02 ] , aSZ2Cols[ 01 , nLoop ] , .T. )
	Next nLoop
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁDefine os Campos Editaveis na Enchoice Apenas na Inclusao( 3 )Ё
	Ёou Alteracao(4)											   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define os Campos Editaveis								   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		nLoops := Len( aSZ2VisuEn )
		For nLoop := 1 To nLoops
			aAdd( aSZ2NaoAlt , aSZ2VisuEn[ nLoop ] )
		Next nLoop
		IF ( nOpc == 4 )
			aAdd( aSZ2NaoAlt , "Z2_CODIGO" )
		EndIF
		nLoops := Len( aSZ2Fields )
		For nLoop := 1 To nLoops
			IF ( aScan( aSZ2NaoAlt , { |cNaoA| cNaoA == aSZ2Fields[ nLoop ] } ) == 0 )
				aAdd( aSZ2Altera , aSZ2Fields[ nLoop ] )
			EndIF
		Next nLoop
	
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta os Dados para a GetDados							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	aAdd( aSZ3NotFields , "Z3_FILIAL"  )
	aAdd( aSZ3NotFields , "Z3_CODIGO"	)
	aSZ3Query		:= Array( 05 )
	aSZ3Query[01]	:= "Z3_FILIAL='"+cFilSZ2+"'"
	aSZ3Query[02]	:= " AND "
	aSZ3Query[03]	:= "Z3_CODIGO='"+cCodSZ2+"'"
	aSZ3Query[04]	:= " AND "
	aSZ3Query[05]	:= "D_E_L_E_T_=' ' "
   /*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Quando For Inclusao Posiciona o SZ3 No Final do Arquivo	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( nOpc == 3  ) //Inclusao
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Garante que na Inclusao o Ponteiro do SZ3 estara em Eof()    Ё 
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		PutFileInEof( "SZ3" )
	EndIF
	SZ3->( dbSetOrder( nSZ3ItemOrd ) )
	bGetSZ3	:= { |lLock,lExclu| IF( lExecLock , ( lLock := .T. , lExclu := .T. ) , aSZ3Keys := NIL ),;
						 			aSZ3Cols := SZ3->(;
														GdBuildCols(	@aSZ3Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																		@nSZ3Usado		,;	//02 -> Numero de Campos em Uso
																		@aSZ3VirtGd		,;	//03 -> [@]Array com os Campos Virtuais
																		@aSZ3VisuGd		,;	//04 -> [@]Array com os Campos Visuais
																		"SZ3"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																		aSZ3NotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																		@aSZ3Recnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																		"SZ2"		   	,;	//08 -> Alias do Arquivo Pai
																		cSZ2KeySeek		,;	//09 -> Chave para o Posicionamento no Alias Filho
																		NIL				,;	//10 -> Bloco para condicao de Loop While
																		NIL				,;	//11 -> Bloco para Skip no Loop While
																		NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
																		NIL				,;	//13 -> Se Sera considerado o Inicializador Padrao
																		NIL				,;	//14 -> Opcional, Carregar Todos os Campos
																		NIL				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
																		aSZ3Query		,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
																		.F.				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
																		.F.				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
																		Altera			,;	//19 -> Carregar Coluna Fantasma
																		NIL				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
																		NIL				,;	//21 -> Verifica se Deve Checar se o campo eh usado
																		NIL				,;	//22 -> Verifica se Deve Checar o nivel do usuario
																		NIL				,;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
																		@aSZ3Keys		,;	//24 -> [@]Array que contera as chaves conforme recnos
																		@lLock			,;	//25 -> [@]Se devera efetuar o Lock dos Registros
																		@lExclu			,;	//26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																		NIL         	,;	//27 -> Numero maximo de Locks a ser efetuado
																		Altera			 ;	//28 -> Utiliza Numeracao na GhostCol
																    );
														  ),;
									IF( lExecLock , ( lLock .and. lExclu ) , .T. );
	  		    }
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁLock do Registro do SZ3									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lLocks := WhileNoLock( "SZ3" , NIL , NIL , 1 , 1 , .T. , NIL , 5 , bGetSZ3 ) )
		Break
	EndIF
	CursorWait()

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁMonta Bloco para Sort antes da Gravacao					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( ( nSZ3GhostCol := GdFieldPos( "GHOSTCOL" , aSZ3Header ) ) > 0 )
		bSZ3Sort := { |x,y| ( x[ nSZ3GhostCol ] < y[ nSZ3GhostCol ] ) }
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Salva o Conteudo do SZ3aCols para comparacao na saida		   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/

	aSvSZ3Cols	:= aClone( aSZ3Cols )
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega os Campos Editaveis para a GetDados				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	For nLoop := 1	To nSZ3Usado
		SetMemVar( aSZ3Header[ nLoop , 02 ] , GetValType( aSZ3Header[ nLoop , 08 ] , aSZ3Header[ nLoop , 04 ] ) , .T. )
		IF (;
				( aScan( aSZ3VirtGd		, aSZ3Header[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZ3VisuGd		, aSZ3Header[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZ3NotFields	, aSZ3Header[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZ3GdNaoAlt	, aSZ3Header[ nLoop , 02 ] ) == 0 )			;
		  	)
			aAdd( aSZ3GdAltera , aSZ3Header[ nLoop , 02 ] )
		EndIF
	Next nLoop
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁRedefine aSZ3Cols na Inclusao ou se vazio para que a numeracaoЁ
	Ёautomatica do campo Z3_ITEM seja feita corretamente na  GetDaЁ
	Ёdos. 														   Ё
	ЁUma outra opcao seria utilizar a funcao   GdNumItem("Z3_ITEM)Ё
	Ёno Inicializador padrao do campo Z3_ITEM e nao efetuar o ajusЁ
	Ёte abaixo ( Reinicializar aSZ3aCols )						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( ( Inclui ) .or. Empty( aSZ3Recnos ) )
		aSZ3Cols := {}
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁVerifica se Pode Efetuar a Delecao dos Registros			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( nOpc == 5 )
		cMsgYesNo	:= OemToAnsi("O sistema irА efetuar a verificaГЦo para ver se o registro selecionado" +	CRLF + ;	
								 "para exclusЦo estА sendo utilizado. A verificaГЦo pode ser demorada." + CRLF	+ CRLF	+ ;
								 "Confirma a exclusЦo?")
		cTitLog		:= OemToAnsi( "Log de verificaГЦo de exclusЦo" )
		CursorArrow()
		IF MsgYesNo( OemToAnsi( cMsgYesNo ) , cCadastro + " - " + OemToAnsi( cTitLog ) )
			CursorWait()
			nSZ3PosItem := GdFieldPos( "Z3_CARGO" , aSZ3Header )
			nLoops := Len( aSZ3Recnos )
			//Verificando os Itens
			
			For nLoop := 1 To nLoops
				IF !( ApdChkDel( "SZ3" , NIL , nOpc , ( cCodSZ2 + aSZ3Cols[ nLoop , nSZ3PosItem ] ) , .F. , @aLog , @aLogTitle ) )
					IF !( Empty( aLogGer ) )
						aAdd( aLogGer , aClone( aLog ) )
						aAdd( aLogGerTitle , aLogTitle[1] )
					EndIf
				EndIF
			Next nLoop
			
			//Verificando o Cabecalho
			IF !( lExcGeraLog := !Empty( aLogGer ) )
				IF !( ApdChkDel( cAlias , nReg , nOpc , cCodSZ2 , @lExcGeraLog , @aLog , @aLogTitle , { "SZ3" } ) )
					aAdd( aLogGer , aClone( aLog ) )
					aAdd( aLogGerTitle , aLogTitle[1] )
				EndIF
			EndIF
			IF ( lExcGeraLog := !Empty( aLogGer ) )
				cTitLog := "Log de Inconsistencia na ExclusЦo de Cargo no Concurso"
				CursorArrow()
				IF ( lExcGeraLog := MsgNoYes( "Deseja gerar Log?" , cCadastro + " " + cTitLog ) )  
					CursorWait()
						fMakeLog( aLogGer , aLogGerTitle , NIL , NIL , FunName() , cTitLog )
					CursorArrow()
				Else
					MsgInfo( OemToAnsi( "A chave a ser excluida estА sendo utilizada." + CRLF + "AtИ que as referЙncias a ela sejam eliminadas a mesma nЦo poderА ser excluida." ) , cCadastro + " " + cTitLog )
				EndIF
				Break
			EndIF	
		Else
			Break
		EndIF
		CursorWait()
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta as Dimensoes dos Objetos         					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	DEFAULT lDlgPadSiga	:= .F.
	aAdvSize		:= MsAdvSize( NIL , lDlgPadSiga )
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
	aAdd( aObjCoords , { 000 , 050 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o Bloco para a Tecla <CTRL-O> 						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	bSet15		:= { || IF(; 
								( ( nOpc == 3 ) .or. ( nOpc == 4 ) );					//Inclusao ou Alteracao
								.and.;
								RSP001TEncOk( nOpc , oEnSZ2 );							//Valida Todos os Campos da Enchoice
								.and.;
								oGdSZ3:TudoOk(),;										//Valida as Informacoes da GetDados
								(;
									nOpcAlt 	:= 1 ,;
									aSZ3Cols	:= oGdSZ3:aCols,;						//Redireciona o Ponteiro do aSZ3Cols
									RestKeys( aSvKeys , .T. ),;
									oDlg:End();
							 	),;
							 	IF(; 
							 		( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) ,;				//Inclusao ou Visualizacao
							 			(;
							 				nOpcAlt := 0 ,;
							 				.F.;
							 			 ),;
									(;
										nOpcAlt := IF( nOpc == 2 , 0 , 1 ) ,;		//Visualizacao ou Exclusao
										RestKeys( aSvKeys , .T. ),;
										oDlg:End();
							 		);
							 	  );
						   );
					 }
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o Bloco para a Teclas <CTRL-X>     	   			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	bSet24		:= { || ( nOpcAlt := 0 , RestKeys( aSvKeys , .T. ) , oDlg:End() ) }

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o Bloco para o Init do Dialog						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	bDialogInit := { ||;
							EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
					}
//							SetKey( VK_F4 , bGdPesq  ),;
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta o Dialogo Principal para a Manutencao das Formulas	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Monta o Objeto Enchoice para o SZ2                      	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		oEnSZ2	:= MsmGet():New(	cAlias		,;
									nReg		,;
									nOpc		,;
									NIL			,;
									NIL			,;
									NIL			,;
									aSZ2Fields	,;
									aObjSize[1] ,;
									aSZ2Altera	,;
									NIL			,;
									NIL			,;
									NIL			,;
									oDlg		,;
									NIL			,;
									.F.			,;
									NIL			,;
									.F.			 ;
								)
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Monta o Objeto GetDados para o SZ3						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		oGdSZ3	:= MsNewGetDados():New(	aObjSize[2,1]								,;
										aObjSize[2,2]								,;
										aObjSize[2,3]								,;
										aObjSize[2,4]								,;
										nOpcNewGd									,;
										"U_SZ3LinOk"								,;
										"U_SZ3LinOk"								,;
										""											,;
										aSZ3GdAltera								,;
										0											,;
										Val(Replicate("9",TamSx3("Z3_CARGO")[1]))	,;
										NIL											,;
										NIL											,;
										bSZ3GdDelOk									,;
										oDlg										,;
										aSZ3Header									,;
										aSZ3Cols		 							 ;
									  )
	ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Coloca o Ponteiro do Mouse em Estado de Espera			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	CursorWait()

	/*/                   			
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁQuando Confirmada a Opcao e Nao for Visualizacao Grava ou   ExЁ
	Ёclui as Informacoes do SZ2 e SZ3							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF( nOpcAlt == 1 )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Apenas se nao For Visualizacao              				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
 		IF ( nOpc != 2 )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Gravando/Incluido ou Excluindo Informacoes do SRY/SZ3        Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			MsAguarde(;
						{ ||;
								aSort( aSZ3Cols , NIL , NIL , bSZ3Sort ),;	//Sorteia as Informacoes do SZ3 para Comparacao Antes da Gravacao
								RSP001Grava(	nOpc		,;	//Opcao de Acordo com aRotina
							 					nReg		,;	//Numero do Registro do Arquivo Pai ( SZ2 )
							 					aSZ2Header	,;	//Campos do Arquivo Pai ( SZ2 )
							 					aSZ2Cols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZ2 )
							 					aSvSZ2Cols  ,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZ2 )
							 					aSZ2VirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZ2 )
							 					aSZ3Header	,;	//Campos do Arquivo Filho ( SZ3 )
							 					aSZ3Cols	,;	//Itens Atual do Arquivo Filho ( SZ3 )
							 					aSvSZ3Cols	,;	//Itens Anterior do Arquivo Filho ( RD2 )
							 					aSZ3VirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZ3 )
							 					aSZ3Recnos	 ;	//Recnos do Arquivo Filho ( SZ3 )
							  				);
						};
					)
		EndIF
	Else
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё RollBack da Numeracao Automatica            				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		While ( GetSX8Len() > nGetSX8Len )
			RollBackSX8()
		End While
	EndIF

End Sequence

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Coloca o Ponteiro do Mouse em Estado de Espera			   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorWait()

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁLibera os Locks             								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
aAdd( aFreeLocks , { "SZ2" , aSZ2Recnos , aSZ2Keys } )
aAdd( aFreeLocks , { "SZ3" , aSZ3Recnos , aSZ3Keys } )
ApdFreeLocks( aFreeLocks )

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁRestaura os Dados de Entrada								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
RestArea( aArea )

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura as Teclas de Atalho                				   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
RestKeys( aSvKeys , .T. )

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura o Ponteiro do Cursor do Mouse                  	   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorArrow()

Return( nOpcAlt )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁRSP001TEncOkЁAutorЁMarinaldo de Jesus    Ё Data Ё06/01/2004Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁTudoOk para a Enchoice                                      Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁRSP001TEncOk( nOpc , oEnSZ2 )								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ 															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁRSP001()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function RSP001TEncOk( nOpc , oEnSZ2 )

Local lTudoOk := .T.
                
IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
	lTudoOk := EnchoTudOk( oEnSZ2 )
EndIF

Return( lTudoOk )

/*/
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSZ3LinOk	ЁAutorЁMarinaldo de Jesus     Ё Data Ё06/01/2004Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё                                                            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁSZ3LinOk( oBrowse )									    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ 															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁRSP001()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function SZ3LinOk( oBrowse )

Local aCposKey	:= {}
Local lLinOk	:= .T.
Local nX
Local nLoop
/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Altera o Estado do Cursor  								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorWait()

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Evitar que os Inicializadores padroes sejam carregados indeviЁ
	Ё damente													   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	PutFileInEof( "SZ3" )
	
	Begin Sequence
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se a Linha da GetDados Nao Estiver Deletada				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( GdDeleted() ) 

		//Nao permite alteracao do codigo do cargo
		//               alteracao        nao И linha inicializada em branco      linha atual <= array ant       cargo anterior <> cargo atual
		If !(lLinOk := !(ALTERA .and. !(n == 1 .and. empty(aSvSZ3Cols[n,1])) .and. n <= len(aSvSZ3Cols) .and. aSvSZ3Cols[n,1] <> GdFieldGet( "Z3_CARGO" )))
			MsgInfo( OemToAnsi( "NЦo И possМvel alterar o Cargo incluМdo anteriormente." + CRLF + "A alternativa serА alterar a situaГЦo para '2-Cancelado'." ) , cCadastro )
			Break
		EndIf			
		 
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Verifica Itens Duplicados na GetDados						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aCposKey := GetArrUniqe( "SZ3" )
		IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
			Break
		EndIF
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Verifica Se o Campos Estao Devidamente Preenchidos		   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aCposKey := GdObrigat( aHeader )
		IF !( lLinOk := GdNoEmpty( aCposKey ) )
	    	Break
		EndIF
				
	EndIf
	End Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe Houver Alguma Inconsistencia na GetDados, Seta-lhe o Foco  Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lLinOk )
		oBrowse:SetFocus()
	EndIF

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura o Estado do Cursor								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorArrow()

Return( lLinOk )

/*/
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSZ3GdDelOk  ЁAutorЁMarinaldo de Jesus     Ё Data Ё06/01/2004Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValidar a Delecao na GetDados                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>								    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>								    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁRSP001()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SZ3GdDelOk( cAlias , nRecno , nOpc , cCodigo )
         
Local cItem			:= GdFieldGet( "Z3_CARGO" )
Local lDelOk 		:= .T.
Local lStatusDel	:= .F.

Begin Sequence

	//Quando for Visualizacao ou Exclusao Abandona
	IF (;
			( nOpc == 2 ) .or. ;	//Visualizacao
			( nOpc == 5 );			//Exclusao
		)
		Break
	EndIF

	lStatusDel	:= !( GdDeleted() ) //Inverte o Estado
	
	IF ( lStatusDel )	//Deletar
    	IF !( nOpc == 3  )	//Quando nao for Inclusao
   			IF !( lDelOk := ApdChkDel( cAlias , nRecno , nOpc , ( cCodigo + cItem ) , .F. , NIL , NIL , NIL , NIL , .T. ) )
				CursorArrow()
				MsgInfo( OemToAnsi( "Este Cargo neste Concurso jА foi utilizado e nЦo poderА ser excluМdo." + CRLF + "A alternativa serА alterar a situaГЦo para '2-Cancelado'." ) , cCadastro )
   				Break
   			EndIF
    	EndIF
	EndIF

End Sequence
	
Return( lDelOk )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁRSP001Grava ЁAutorЁMarinaldo de Jesus    Ё Data Ё06/01/2004Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё                                                            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁRSP001()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function RSP001Grava(	nOpc		,;	//Opcao de Acordo com aRotina
							 	nReg		,;	//Numero do Registro do Arquivo Pai ( SZ2 )
							 	aSZ2Header	,;	//Campos do Arquivo Pai ( SZ2 )
							 	aSZ2Cols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZ2 )
							 	aSvSZ2Cols  ,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZ2 )
							 	aSZ2VirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZ2 )
							 	aSZ3Header	,;	//Campos do Arquivo Filho ( SZ3 )
							 	aSZ3Cols	,;	//Itens Atual do Arquivo Filho ( SZ3 )
							 	aSvSZ3Cols	,;	//Itens Anterior do Arquivo Filho ( RD2 )
							 	aSZ3VirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZ3 )
							 	aSZ3Recnos	 ;	//Recnos do Arquivo Filho ( SZ3 )
							  )

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Variaveis de Inicializacao Obrigatoria					  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local aMestre	:= GdPutIStrMestre( 01 )
Local aItens	:= {}
Local cOpcao	:= IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )
Local lAllModif	:= .F.
Local lSZ2Modif	:= .F.
Local lSZ3Modif	:= .F.
Local lSZ3Delet	:= .F.

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Variaveis que serao inicializadas no Corpo da Funcao		  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local aSZ3ColDel
Local aSZ3RecDel
Local nLoop
Local nLoops

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Altera o Estado do Cursor  								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorWait()

	IF ( cOpcao <> "DELETE" )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Verifica se Houveram Modificacoes no RDV					   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( lSZ3Modif := !ArrayCompare( aSZ3Cols , aSvSZ3Cols ) )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Deleto todos os Itens que nao Estao OK					   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			GdSuperDel( aSZ3Header , @aSZ3Cols , NIL , .T. , GdGetBlock( "SZ3" , aSZ3Header , .F. ) ) 
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Separa os Itens que foram Deletados     					   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			lSZ3Delet := GdSplitDel( aSZ3Header , @aSZ3Cols , @aSZ3Recnos , @aSZ3ColDel , @aSZ3RecDel  )
		EndIF
	Else
		lSZ3Modif := .T.
		lSZ2Modif := .T.
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega os Itens Apenas se Houveram Alteracoes ou na ExclusaoЁ
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( lSZ3Modif )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Carrega as Informacoes deletadas RD4                   	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( lSZ3Delet )

			aAdd( aItens , GdPutIStrItens() )
			nItens := Len( aItens )
		
			aItens[ nItens , 01 ] := "SZ3"
			aItens[ nItens , 02 ] := NIL
			aItens[ nItens , 03 ] := aClone( aSZ3Header )
			aItens[ nItens , 04 ] := aClone( aSZ3ColDel )
			aItens[ nItens , 05 ] := aClone( aSZ3VirtGd )
			aItens[ nItens , 06 ] := aClone( aSZ3RecDel )

		EndIF

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Carrega as Informacoes do SZ3                   			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aAdd( aItens , GdPutIStrItens() )
		nItens := Len( aItens )

		aItens[ nItens , 01 ] := "SZ3"
		aItens[ nItens , 02 ] := {;
									{ "FILIAL" , xFilial( "SZ3" , xFilial( "SZ2" ) ) },;
									{ "CODIGO" , GetMemVar( "Z2_CODIGO" ) };
							 	 }
		aItens[ nItens , 03 ] := aClone( aSZ3Header )
		aItens[ nItens , 04 ] := aClone( aSZ3Cols   )
		aItens[ nItens , 05 ] := aClone( aSZ3VirtGd )
		aItens[ nItens , 06 ] := aClone( aSZ3Recnos )

	EndIF

	IF !( lSZ2Modif )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Atualiza aSZ2Cols para Verificar se Houveram Alteracoes	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		nLoops := Len( aSZ2Header )
		For nLoop := 1 To nLoops
			aSZ2Cols[ 01 , nLoop ] := GetMemVar( aSZ2Header[ nLoop , 02 ] )
		Next nLoop
		lSZ2Modif := !( ArrayCompare( aSZ2Cols , aSvSZ2Cols ) )
	EndIF	

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta a Gravacao ou Exclusao Apenas se Houveram Alteracoes  ouЁ
	Ё se foi Selecionada a Exclusao								   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
 	lAllModif := ( ( lSZ3Modif ) .or. ( lSZ2Modif ) )


	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se Houveram Alteracoes, ou Exclusao efetua a Gravacao        Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( lAllModif )
		
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Seta a Gravacao ou Exclusao Apenas se Houveram Alteracoes  ouЁ
		Ё se foi Selecionada a Exclusao								   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aMestre[ 01 , 01 ]	:= "SZ2"
		aMestre[ 01 , 02 ]	:= nReg
		aMestre[ 01 , 03 ]	:= ( ( nOpc == 5 ) .or. !( fCompArray( aSZ2Cols , aSvSZ2Cols ) ) )
		aMestre[ 01 , 04 ]	:= aClone( aSZ2Header )
		aMestre[ 01 , 05 ]	:= aClone( aSZ2VirtEn )
		aMestre[ 01 , 06 ]	:= {}
		aMestre[ 01 , 07 ]	:= aClone( aItens )
		
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Grava as Informacoes                        				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		GdPutInfoData( aMestre , cOpcao , .F. , .F. )
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Confirmando a Numeracao Automatica          				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		While ( GetSX8Len() > nGetSX8Len )
			ConfirmSX8()
		End While

	EndIF
	
/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura o Estado do Cursor								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorArrow()

Return( NIL )

/*                                	
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё MenuDef		ЁAutorЁ  Luiz Gustavo     Ё Data Ё28/12/2006Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁIsola opcoes de menu para que as opcoes da rotina possam    Ё
Ё          Ёser lidas pelas bibliotecas Framework da Versao 9.12 .      Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё< Vide Parametros Formais >									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Uso      ЁRSP001                                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Retorno  ЁaRotina														Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais >									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/   

Static Function MenuDef()

 Local aRotina :=   {;
							{ "Pesquisar"  	, "AxPesqui"	, 0 , 01,,.F.} ,; //"Pesquisar"
							{ "Visualizar" 	, "U_RSP001Mnt" , 0 , 02 } ,; //"Visualizar"
							{ "Incluir" 	, "U_RSP001Mnt" , 0 , 03 } ,; //"Incluir"
							{ "Alterar" 	, "U_RSP001Mnt" , 0 , 04 } ,; //"Alterar"
							{ "Excluir" 	, "U_RSP001Mnt" , 0 , 05 }  ; //"Excluir"
						}
Return aRotina