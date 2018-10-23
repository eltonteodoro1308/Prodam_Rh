#INCLUDE "PROTHEUS.CH"

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё CSA002   ЁAutorЁ Marcos Pereira          Ё Data Ё19/08/2016Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o Ё Grupo Quadro de Cargos X Vagas Autorizadas                 Ё
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
User Function CSA002()

Local aArea 		:= GetArea()
Local aAreaSZG		:= SZG->( GetArea() )
Local aAreaSZH		:= SZH->( GetArea() )

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁVerifica se o Modo de Acesso do SZG e SZH sao Iguais          Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( xRetModo( "SZG" , "SZH" , .T. ) )
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
	Private cCadastro := OemToAnsi( "Grupos Quadro de Cargos X Vagas Autorizadas" )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Chama a Funcao de Montagem do Browse                                   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	mBrowse( 6 , 1 , 22 , 75 , "SZG" )

End Sequence
		
/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura os Dados de Entrada 											 Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
RestArea( aAreaSZH )
RestArea( aAreaSZG )
RestArea( aArea	   )

Return( NIL )

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё CSA002   ЁAutorЁ Marcos Pereira          Ё Data Ё12/02/2016Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o Ё Cadastro de Grupos Quadro de Cargos X Vagas Autorizadas    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁCSA002Mnt( cAlias , nReg , nOpc , lDlgPadSiga )			    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁcAlias 		= Alias do arquivo                          	Ё
Ё          ЁnReg  		= Numero do registro                        	Ё
Ё          ЁnOpc   		= Numero da opcao selecionada               	Ё
Ё          ЁlDlgPadSiga	= Dialog no Padrao Siga                     	Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁCSA002()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function CSA002Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

Local aArea			:= GetArea(Alias())
Local aSvKeys		:= GetKeys()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aSZGHeader	:= {}
Local aSZGCols		:= {}
Local aSvSZGCols	:= {}
Local aSZGFields	:= {}
Local aSZGAltera	:= {}
Local aSZGNaoAlt	:= {}
Local aSZGVirtEn	:= {}
Local aSZGNotFields	:= {}
Local aSZGRecnos	:= {}
Local aSZGKeys		:= {}
Local aSZGVisuEn	:= {}
Local aSZHGdAltera  := {}
Local aSZHGdNaoAlt	:= {}
Local aSZHRecnos	:= {}
Local aSZHKeys		:= {}
Local aSZHNotFields	:= {}
Local aSZHVirtGd	:= {}
Local aSZHVisuGd	:= {}
Local aSZHHeader	:= {}
Local aSZHCols		:= {}
Local aSZHQuery		:= {}
Local aLog			:= {}
Local aLogTitle		:= {}
Local aLogGer		:= {}
Local aLogGerTitle	:= {}
Local aButtons		:= {}
Local aFreeLocks	:= {}
Local bSZHGdDelOk	:= { |lDelOk| CursorWait() , lDelOk := SZHGdDelOk( "SZH" , NIL , nOpc , cCodSZG ) , CursorArrow() , lDelOk }
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }
Local bDialogInit	:= { || NIL }
Local bGetSZG		:= { || NIL } 
Local bGetSZH		:= { || NIL }
Local bSZHSort		:= { || NIL }
Local cSZGKeySeek	:= ""
Local cFilSZG		:= ""
Local cCodSZG		:= ""
Local cMsgYesNo		:= ""
Local cTitLog		:= ""
Local lLocks		:= .F.
Local lExecLock		:= ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
Local lExcGeraLog	:= .F.
Local nOpcAlt		:= 0
Local nSZGUsado		:= 0
Local nSZHUsado		:= 0
Local nLoop			:= 0
Local nLoops		:= 0
Local nOpcNewGd		:= IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
Local nSZHPosItem	:= 0
Local nSZHItemOrd	:= RetOrdem( "SZH" , "ZH_FILIAL+ZH_GRUPO+ZH_ANOMES" )
Local nSZHGhostCol	:= 0
Local oDlg			:= NIL
Local oEnSZG		:= NIL	
Local oGdSZH		:= NIL

Private aSvSZHCols	:= {}
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
	aSZGNotFields	:= { "ZG_FILIAL" }
	bGetSZG			:= { |lLock,lExclu|	IF( lExecLock , ( lLock := .T. , lExclu	:= .T. ) , aSZGKeys := NIL ),;
										aSZGCols := SZG->(;
															GdBuildCols(	@aSZGHeader		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																			@nSZGUsado		,;	//02 -> Numero de Campos em Uso
																			@aSZGVirtEn		,;	//03 -> [@]Array com os Campos Virtuais
																			@aSZGVisuEn		,;	//04 -> [@]Array com os Campos Visuais
																			"SZG"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																			aSZGNotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																			@aSZGRecnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																			"SZG"		   	,;	//08 -> Alias do Arquivo Pai
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
																			@aSZGKeys		,;	//25 -> [@]Array que contera as chaves conforme recnos
																			@lLock			,;	//26 -> [@]Se devera efetuar o Lock dos Registros
																			@lExclu			 ;	//27 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																	    );
														  ),;
										IF( lExecLock , ( lLock .and. lExclu ) , .T. );
	  					} 
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁLock do Registro do SZG									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lLocks := WhileNoLock( "SZG" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZG ) )
		Break
	EndIF
	CursorWait()
	aSvSZGCols		:= aClone( aSZGCols )
	cFilSZG			:= SZG->ZG_FILIAL
	cCodSZG			:= SZG->ZG_GRUPO
	cSZGKeySeek		:= ( cFilSZG + cCodSZG )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Cria as Variaveis de Memoria e Carrega os Dados Conforme o arЁ
	Ё quivo														   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	For nLoop := 1 To nSZGUsado
		aAdd( aSZGFields , aSZGHeader[ nLoop , 02 ] )
		SetMemVar( aSZGHeader[ nLoop , 02 ] , aSZGCols[ 01 , nLoop ] , .T. )
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
		nLoops := Len( aSZGVisuEn )
		For nLoop := 1 To nLoops
			aAdd( aSZGNaoAlt , aSZGVisuEn[ nLoop ] )
		Next nLoop
		IF ( nOpc == 4 )
			aAdd( aSZGNaoAlt , "ZG_GRUPO" )
		EndIF
		nLoops := Len( aSZGFields )
		For nLoop := 1 To nLoops
			IF ( aScan( aSZGNaoAlt , { |cNaoA| cNaoA == aSZGFields[ nLoop ] } ) == 0 )
				aAdd( aSZGAltera , aSZGFields[ nLoop ] )
			EndIF
		Next nLoop
	
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta os Dados para a GetDados							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	aAdd( aSZHNotFields , "ZH_FILIAL"  )
	aAdd( aSZHNotFields , "ZH_GRUPO"	)
	aSZHQuery		:= Array( 05 )
	aSZHQuery[01]	:= "ZH_FILIAL='"+cFilSZG+"'"
	aSZHQuery[02]	:= " AND "
	aSZHQuery[03]	:= "ZH_GRUPO='"+cCodSZG+"'"
	aSZHQuery[04]	:= " AND "
	aSZHQuery[05]	:= "D_E_L_E_T_=' ' "
   /*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Quando For Inclusao Posiciona o SZH No Final do Arquivo	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( nOpc == 3  ) //Inclusao
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Garante que na Inclusao o Ponteiro do SZH estara em Eof()    Ё 
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		PutFileInEof( "SZH" )
	EndIF
	SZH->( dbSetOrder( nSZHItemOrd ) )
	bGetSZH	:= { |lLock,lExclu| IF( lExecLock , ( lLock := .T. , lExclu := .T. ) , aSZHKeys := NIL ),;
						 			aSZHCols := SZH->(;
														GdBuildCols(	@aSZHHeader		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																		@nSZHUsado		,;	//02 -> Numero de Campos em Uso
																		@aSZHVirtGd		,;	//03 -> [@]Array com os Campos Virtuais
																		@aSZHVisuGd		,;	//04 -> [@]Array com os Campos Visuais
																		"SZH"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																		aSZHNotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																		@aSZHRecnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																		"SZG"		   	,;	//08 -> Alias do Arquivo Pai
																		cSZGKeySeek		,;	//09 -> Chave para o Posicionamento no Alias Filho
																		NIL				,;	//10 -> Bloco para condicao de Loop While
																		NIL				,;	//11 -> Bloco para Skip no Loop While
																		NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
																		NIL				,;	//13 -> Se Sera considerado o Inicializador Padrao
																		NIL				,;	//14 -> Opcional, Carregar Todos os Campos
																		NIL				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
																		aSZHQuery		,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
																		.F.				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
																		.F.				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
																		Altera			,;	//19 -> Carregar Coluna Fantasma
																		NIL				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
																		NIL				,;	//21 -> Verifica se Deve Checar se o campo eh usado
																		NIL				,;	//22 -> Verifica se Deve Checar o nivel do usuario
																		NIL				,;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
																		@aSZHKeys		,;	//24 -> [@]Array que contera as chaves conforme recnos
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
	ЁLock do Registro do SZH									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lLocks := WhileNoLock( "SZH" , NIL , NIL , 1 , 1 , .T. , NIL , 5 , bGetSZH ) )
		Break
	EndIF
	CursorWait()

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁMonta Bloco para Sort antes da Gravacao					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( ( nSZHGhostCol := GdFieldPos( "GHOSTCOL" , aSZHHeader ) ) > 0 )
		bSZHSort := { |x,y| ( x[ nSZHGhostCol ] < y[ nSZHGhostCol ] ) }
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Salva o Conteudo do SZHaCols para comparacao na saida		   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/

	aSvSZHCols	:= aClone( aSZHCols )
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega os Campos Editaveis para a GetDados				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	For nLoop := 1	To nSZHUsado
		SetMemVar( aSZHHeader[ nLoop , 02 ] , GetValType( aSZHHeader[ nLoop , 08 ] , aSZHHeader[ nLoop , 04 ] ) , .T. )
		IF (;
				( aScan( aSZHVirtGd		, aSZHHeader[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZHVisuGd		, aSZHHeader[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZHNotFields	, aSZHHeader[ nLoop , 02 ] ) == 0 ) .and.	;
		   		( aScan( aSZHGdNaoAlt	, aSZHHeader[ nLoop , 02 ] ) == 0 )			;
		  	)
			aAdd( aSZHGdAltera , aSZHHeader[ nLoop , 02 ] )
		EndIF
	Next nLoop
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁRedefine aSZHCols na Inclusao ou se vazio para que a numeracaoЁ
	Ёautomatica do campo ZH_ITEM seja feita corretamente na  GetDaЁ
	Ёdos. 														   Ё
	ЁUma outra opcao seria utilizar a funcao   GdNumItem("ZH_ITEM)Ё
	Ёno Inicializador padrao do campo ZH_ITEM e nao efetuar o ajusЁ
	Ёte abaixo ( Reinicializar aSZHaCols )						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( ( Inclui ) .or. Empty( aSZHRecnos ) )
		aSZHCols := {}
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
								CSA002TEncOk( nOpc , oEnSZG );							//Valida Todos os Campos da Enchoice
								.and.;
								oGdSZH:TudoOk(),;										//Valida as Informacoes da GetDados
								(;
									nOpcAlt 	:= 1 ,;
									aSZHCols	:= oGdSZH:aCols,;						//Redireciona o Ponteiro do aSZHCols
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
		Ё Monta o Objeto Enchoice para o SZG                      	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		oEnSZG	:= MsmGet():New(	cAlias		,;
									nReg		,;
									nOpc		,;
									NIL			,;
									NIL			,;
									NIL			,;
									aSZGFields	,;
									aObjSize[1] ,;
									aSZGAltera	,;
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
		Ё Monta o Objeto GetDados para o SZH						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		oGdSZH	:= MsNewGetDados():New(	aObjSize[2,1]								,;
										aObjSize[2,2]								,;
										aObjSize[2,3]								,;
										aObjSize[2,4]								,;
										nOpcNewGd									,;
										"U_SZHLinOk"								,;
										"U_SZHLinOk"								,;
										""											,;
										aSZHGdAltera								,;
										0											,;
										Val(Replicate("9",TamSx3("ZH_GRUPO")[1]))	,;
										NIL											,;
										NIL											,;
										bSZHGdDelOk									,;
										oDlg										,;
										aSZHHeader									,;
										aSZHCols		 							 ;
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
	Ёclui as Informacoes do SZG e SZH							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF( nOpcAlt == 1 )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Apenas se nao For Visualizacao              				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
 		IF ( nOpc != 2 )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Gravando/Incluido ou Excluindo Informacoes do SRY/SZH        Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			MsAguarde(;
						{ ||;
								aSort( aSZHCols , NIL , NIL , bSZHSort ),;	//Sorteia as Informacoes do SZH para Comparacao Antes da Gravacao
								CSA002Grava(	nOpc		,;	//Opcao de Acordo com aRotina
							 					nReg		,;	//Numero do Registro do Arquivo Pai ( SZG )
							 					aSZGHeader	,;	//Campos do Arquivo Pai ( SZG )
							 					aSZGCols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZG )
							 					aSvSZGCols  ,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZG )
							 					aSZGVirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZG )
							 					aSZHHeader	,;	//Campos do Arquivo Filho ( SZH )
							 					aSZHCols	,;	//Itens Atual do Arquivo Filho ( SZH )
							 					aSvSZHCols	,;	//Itens Anterior do Arquivo Filho ( RD2 )
							 					aSZHVirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZH )
							 					aSZHRecnos	 ;	//Recnos do Arquivo Filho ( SZH )
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
aAdd( aFreeLocks , { "SZG" , aSZGRecnos , aSZGKeys } )
aAdd( aFreeLocks , { "SZH" , aSZHRecnos , aSZHKeys } )
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
ЁFun┤┘o    ЁCSA002TEncOkЁAutorЁMarinaldo de Jesus    Ё Data Ё06/01/2004Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁTudoOk para a Enchoice                                      Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁCSA002TEncOk( nOpc , oEnSZG )								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ 															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁCSA002()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CSA002TEncOk( nOpc , oEnSZG )

Local lTudoOk := .T.
                
IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
	lTudoOk := EnchoTudOk( oEnSZG )
EndIF

Return( lTudoOk )

/*/
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSZHLinOk	ЁAutorЁMarinaldo de Jesus     Ё Data Ё06/01/2004Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё                                                            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁSZHLinOk( oBrowse )									    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ 															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁCSA002()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function SZHLinOk( oBrowse )

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
	PutFileInEof( "SZH" )
	
	Begin Sequence
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se a Linha da GetDados Nao Estiver Deletada				   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( GdDeleted() ) 

		//Valida o campo digitado Ano/Mes
		If !( lLinOk := len(alltrim(GdFieldGet( "ZH_ANOMES" ))) <> 6  .or. ;
			(val(right(GdFieldGet( "ZH_ANOMES" ),2)) > 0 .and. val(right(GdFieldGet( "ZH_ANOMES" ),2)) <= 12) )
			MsgInfo( OemToAnsi( "Ano/Mes invАlido.") , cCadastro )
			Break
		EndIf			
		 
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Verifica Itens Duplicados na GetDados						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aCposKey := GetArrUniqe( "SZH" )
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
ЁFun┤┘o    ЁSZHGdDelOk  ЁAutorЁMarinaldo de Jesus     Ё Data Ё06/01/2004Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValidar a Delecao na GetDados                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>								    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>								    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁCSA002()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SZHGdDelOk( cAlias , nRecno , nOpc , cCodigo )
         
Local lDelOk 		:= .T.
/*
Local lStatusDel	:= .F.
Local cItem			:= GdFieldGet( "ZH_CARGO" )

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
*/	
Return( lDelOk )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCSA002Grava ЁAutorЁMarinaldo de Jesus    Ё Data Ё06/01/2004Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё                                                            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁCSA002()	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CSA002Grava(	nOpc		,;	//Opcao de Acordo com aRotina
							 	nReg		,;	//Numero do Registro do Arquivo Pai ( SZG )
							 	aSZGHeader	,;	//Campos do Arquivo Pai ( SZG )
							 	aSZGCols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZG )
							 	aSvSZGCols  ,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZG )
							 	aSZGVirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZG )
							 	aSZHHeader	,;	//Campos do Arquivo Filho ( SZH )
							 	aSZHCols	,;	//Itens Atual do Arquivo Filho ( SZH )
							 	aSvSZHCols	,;	//Itens Anterior do Arquivo Filho ( RD2 )
							 	aSZHVirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZH )
							 	aSZHRecnos	 ;	//Recnos do Arquivo Filho ( SZH )
							  )

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Variaveis de Inicializacao Obrigatoria					  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local aMestre	:= GdPutIStrMestre( 01 )
Local aItens	:= {}
Local cOpcao	:= IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )
Local lAllModif	:= .F.
Local lSZGModif	:= .F.
Local lSZHModif	:= .F.
Local lSZHDelet	:= .F.

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Variaveis que serao inicializadas no Corpo da Funcao		  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local aSZHColDel
Local aSZHRecDel
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
		IF ( lSZHModif := !ArrayCompare( aSZHCols , aSvSZHCols ) )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Deleto todos os Itens que nao Estao OK					   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			GdSuperDel( aSZHHeader , @aSZHCols , NIL , .T. , GdGetBlock( "SZH" , aSZHHeader , .F. ) ) 
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Separa os Itens que foram Deletados     					   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			lSZHDelet := GdSplitDel( aSZHHeader , @aSZHCols , @aSZHRecnos , @aSZHColDel , @aSZHRecDel  )
		EndIF
	Else
		lSZHModif := .T.
		lSZGModif := .T.
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega os Itens Apenas se Houveram Alteracoes ou na ExclusaoЁ
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( lSZHModif )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Carrega as Informacoes deletadas RD4                   	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( lSZHDelet )

			aAdd( aItens , GdPutIStrItens() )
			nItens := Len( aItens )
		
			aItens[ nItens , 01 ] := "SZH"
			aItens[ nItens , 02 ] := NIL
			aItens[ nItens , 03 ] := aClone( aSZHHeader )
			aItens[ nItens , 04 ] := aClone( aSZHColDel )
			aItens[ nItens , 05 ] := aClone( aSZHVirtGd )
			aItens[ nItens , 06 ] := aClone( aSZHRecDel )

		EndIF

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Carrega as Informacoes do SZH                   			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		aAdd( aItens , GdPutIStrItens() )
		nItens := Len( aItens )

		aItens[ nItens , 01 ] := "SZH"
		aItens[ nItens , 02 ] := {;
									{ "FILIAL" , xFilial( "SZH" , xFilial( "SZG" ) ) },;
									{ "GRUPO" , GetMemVar( "ZG_GRUPO" ) };
							 	 }
		aItens[ nItens , 03 ] := aClone( aSZHHeader )
		aItens[ nItens , 04 ] := aClone( aSZHCols   )
		aItens[ nItens , 05 ] := aClone( aSZHVirtGd )
		aItens[ nItens , 06 ] := aClone( aSZHRecnos )

	EndIF

	IF !( lSZGModif )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Atualiza aSZGCols para Verificar se Houveram Alteracoes	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		nLoops := Len( aSZGHeader )
		For nLoop := 1 To nLoops
			aSZGCols[ 01 , nLoop ] := GetMemVar( aSZGHeader[ nLoop , 02 ] )
		Next nLoop
		lSZGModif := !( ArrayCompare( aSZGCols , aSvSZGCols ) )
	EndIF	

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta a Gravacao ou Exclusao Apenas se Houveram Alteracoes  ouЁ
	Ё se foi Selecionada a Exclusao								   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
 	lAllModif := ( ( lSZHModif ) .or. ( lSZGModif ) )


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
		aMestre[ 01 , 01 ]	:= "SZG"
		aMestre[ 01 , 02 ]	:= nReg
		aMestre[ 01 , 03 ]	:= ( ( nOpc == 5 ) .or. !( fCompArray( aSZGCols , aSvSZGCols ) ) )
		aMestre[ 01 , 04 ]	:= aClone( aSZGHeader )
		aMestre[ 01 , 05 ]	:= aClone( aSZGVirtEn )
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
Ё Uso      ЁCSA002                                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Retorno  ЁaRotina														Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais >									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/   

Static Function MenuDef()

 Local aRotina :=   {;
							{ "Pesquisar"  	, "AxPesqui"	, 0 , 01,,.F.} ,; //"Pesquisar"
							{ "Visualizar" 	, "U_CSA002Mnt" , 0 , 02 } ,; //"Visualizar"
							{ "Incluir" 	, "U_CSA002Mnt" , 0 , 03 } ,; //"Incluir"
							{ "Alterar" 	, "U_CSA002Mnt" , 0 , 04 } ,; //"Alterar"
							{ "Excluir" 	, "U_CSA002Mnt" , 0 , 05 }  ; //"Excluir"
						}
Return aRotina