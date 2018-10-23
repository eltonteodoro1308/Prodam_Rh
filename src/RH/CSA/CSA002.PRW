#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    � CSA002   �Autor� Marcos Pereira          � Data �19/08/2016�
�����������������������������������������������������������������������Ĵ
�Descri��o � Grupo Quadro de Cargos X Vagas Autorizadas                 �
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                                                    �
�����������������������������������������������������������������������Ĵ
�            ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL           �
�����������������������������������������������������������������������Ĵ
�Programador �Data      �BOPS       �Motivo da Alteracao                �
�����������������������������������������������������������������������Ĵ
�            �          �           �                                   �
�            �          �           �                                   �
�������������������������������������������������������������������������/*/
User Function CSA002()

Local aArea 		:= GetArea()
Local aAreaSZG		:= SZG->( GetArea() )
Local aAreaSZH		:= SZH->( GetArea() )

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	�Verifica se o Modo de Acesso do SZG e SZH sao Iguais          �
	����������������������������������������������������������������/*/
	IF !( xRetModo( "SZG" , "SZH" , .T. ) )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Define Array contendo as Rotinas a executar do programa      �
	� ----------- Elementos contidos por dimensao ------------     �
	� 1. Nome a aparecer no cabecalho                              �
	� 2. Nome da Rotina associada                                  �
	� 3. Usado pela rotina                                         �
	� 4. Tipo de Transa��o a ser efetuada                          �
	�    1 - Pesquisa e Posiciona em um Banco de Dados             �
	�    2 - Simplesmente Mostra os Campos                         �
	�    3 - Inclui registros no Bancos de Dados                   �
	�    4 - Altera o registro corrente                            �
	�    5 - Remove o registro corrente do Banco de Dados          �
	�    6 - Copiar                                                �
	����������������������������������������������������������������/*/
	Private aRotina := MenuDef() 
	Private cCadastro := OemToAnsi( "Grupos Quadro de Cargos X Vagas Autorizadas" )

	/*/
	������������������������������������������������������������������������Ŀ
	� Chama a Funcao de Montagem do Browse                                   �
	��������������������������������������������������������������������������/*/
	mBrowse( 6 , 1 , 22 , 75 , "SZG" )

End Sequence
		
/*/
������������������������������������������������������������������������Ŀ
� Restaura os Dados de Entrada 											 �
��������������������������������������������������������������������������/*/
RestArea( aAreaSZH )
RestArea( aAreaSZG )
RestArea( aArea	   )

Return( NIL )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    � CSA002   �Autor� Marcos Pereira          � Data �12/02/2016�
�����������������������������������������������������������������������Ĵ
�Descri��o � Cadastro de Grupos Quadro de Cargos X Vagas Autorizadas    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �CSA002Mnt( cAlias , nReg , nOpc , lDlgPadSiga )			    �
�����������������������������������������������������������������������Ĵ
�Parametros�cAlias 		= Alias do arquivo                          	�
�          �nReg  		= Numero do registro                        	�
�          �nOpc   		= Numero da opcao selecionada               	�
�          �lDlgPadSiga	= Dialog no Padrao Siga                     	�
�����������������������������������������������������������������������Ĵ
�Uso       �CSA002()	                                                �
�������������������������������������������������������������������������/*/
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
��������������������������������������������������������������Ŀ
� Coloca o ponteiro do Cursor do Mouse em Estado de Espera     �
����������������������������������������������������������������/*/
CursorWait()

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	�Checa a Opcao Selecionada									   �
	����������������������������������������������������������������/*/
	aRotSetOpc( cAlias , @nReg , nOpc )

	/*/
	��������������������������������������������������������������Ŀ
	� Monta os Dados para a Enchoice							   �
	����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	�Lock do Registro do SZG									   �
	����������������������������������������������������������������/*/
	IF !( lLocks := WhileNoLock( "SZG" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZG ) )
		Break
	EndIF
	CursorWait()
	aSvSZGCols		:= aClone( aSZGCols )
	cFilSZG			:= SZG->ZG_FILIAL
	cCodSZG			:= SZG->ZG_GRUPO
	cSZGKeySeek		:= ( cFilSZG + cCodSZG )

	/*/
	��������������������������������������������������������������Ŀ
	� Cria as Variaveis de Memoria e Carrega os Dados Conforme o ar�
	� quivo														   �
	����������������������������������������������������������������/*/
	For nLoop := 1 To nSZGUsado
		aAdd( aSZGFields , aSZGHeader[ nLoop , 02 ] )
		SetMemVar( aSZGHeader[ nLoop , 02 ] , aSZGCols[ 01 , nLoop ] , .T. )
	Next nLoop
	
	/*/
	��������������������������������������������������������������Ŀ
	�Define os Campos Editaveis na Enchoice Apenas na Inclusao( 3 )�
	�ou Alteracao(4)											   �
	����������������������������������������������������������������/*/
	IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )

		/*/
		��������������������������������������������������������������Ŀ
		� Define os Campos Editaveis								   �
		����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	� Monta os Dados para a GetDados							   �
	����������������������������������������������������������������/*/
	aAdd( aSZHNotFields , "ZH_FILIAL"  )
	aAdd( aSZHNotFields , "ZH_GRUPO"	)
	aSZHQuery		:= Array( 05 )
	aSZHQuery[01]	:= "ZH_FILIAL='"+cFilSZG+"'"
	aSZHQuery[02]	:= " AND "
	aSZHQuery[03]	:= "ZH_GRUPO='"+cCodSZG+"'"
	aSZHQuery[04]	:= " AND "
	aSZHQuery[05]	:= "D_E_L_E_T_=' ' "
   /*/
	��������������������������������������������������������������Ŀ
	� Quando For Inclusao Posiciona o SZH No Final do Arquivo	   �
	����������������������������������������������������������������/*/
	IF ( nOpc == 3  ) //Inclusao
		/*/
		��������������������������������������������������������������Ŀ
		� Garante que na Inclusao o Ponteiro do SZH estara em Eof()    � 
		����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	�Lock do Registro do SZH									   �
	����������������������������������������������������������������/*/
	IF !( lLocks := WhileNoLock( "SZH" , NIL , NIL , 1 , 1 , .T. , NIL , 5 , bGetSZH ) )
		Break
	EndIF
	CursorWait()

	/*/
	��������������������������������������������������������������Ŀ
	�Monta Bloco para Sort antes da Gravacao					   �
	����������������������������������������������������������������/*/
	IF ( ( nSZHGhostCol := GdFieldPos( "GHOSTCOL" , aSZHHeader ) ) > 0 )
		bSZHSort := { |x,y| ( x[ nSZHGhostCol ] < y[ nSZHGhostCol ] ) }
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Salva o Conteudo do SZHaCols para comparacao na saida		   �
	����������������������������������������������������������������/*/

	aSvSZHCols	:= aClone( aSZHCols )
	/*/
	��������������������������������������������������������������Ŀ
	� Carrega os Campos Editaveis para a GetDados				   �
	����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	�Redefine aSZHCols na Inclusao ou se vazio para que a numeracao�
	�automatica do campo ZH_ITEM seja feita corretamente na  GetDa�
	�dos. 														   �
	�Uma outra opcao seria utilizar a funcao   GdNumItem("ZH_ITEM)�
	�no Inicializador padrao do campo ZH_ITEM e nao efetuar o ajus�
	�te abaixo ( Reinicializar aSZHaCols )						   �
	����������������������������������������������������������������/*/
	IF ( ( Inclui ) .or. Empty( aSZHRecnos ) )
		aSZHCols := {}
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Monta as Dimensoes dos Objetos         					   �
	����������������������������������������������������������������/*/
	DEFAULT lDlgPadSiga	:= .F.
	aAdvSize		:= MsAdvSize( NIL , lDlgPadSiga )
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
	aAdd( aObjCoords , { 000 , 050 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

	
	/*/
	��������������������������������������������������������������Ŀ
	� Define o Bloco para a Tecla <CTRL-O> 						   �
	����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	� Define o Bloco para a Teclas <CTRL-X>     	   			   �
	����������������������������������������������������������������/*/
	bSet24		:= { || ( nOpcAlt := 0 , RestKeys( aSvKeys , .T. ) , oDlg:End() ) }

	/*/
	��������������������������������������������������������������Ŀ
	� Define o Bloco para o Init do Dialog						   �
	����������������������������������������������������������������/*/
	bDialogInit := { ||;
							EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
					}
//							SetKey( VK_F4 , bGdPesq  ),;
	
	/*/
	��������������������������������������������������������������Ŀ
	� Monta o Dialogo Principal para a Manutencao das Formulas	   �
	����������������������������������������������������������������/*/
	DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL
		/*/
		��������������������������������������������������������������Ŀ
		� Monta o Objeto Enchoice para o SZG                      	   �
		����������������������������������������������������������������/*/
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
		��������������������������������������������������������������Ŀ
		� Monta o Objeto GetDados para o SZH						   �
		����������������������������������������������������������������/*/
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
	��������������������������������������������������������������Ŀ
	� Coloca o Ponteiro do Mouse em Estado de Espera			   �
	����������������������������������������������������������������/*/
	CursorWait()

	/*/                   			
	��������������������������������������������������������������Ŀ
	�Quando Confirmada a Opcao e Nao for Visualizacao Grava ou   Ex�
	�clui as Informacoes do SZG e SZH							   �
	����������������������������������������������������������������/*/
	IF( nOpcAlt == 1 )
		/*/
		��������������������������������������������������������������Ŀ
		� Apenas se nao For Visualizacao              				   �
		����������������������������������������������������������������/*/
 		IF ( nOpc != 2 )
			/*/
			��������������������������������������������������������������Ŀ
			� Gravando/Incluido ou Excluindo Informacoes do SRY/SZH        �
			����������������������������������������������������������������/*/
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
		��������������������������������������������������������������Ŀ
		� RollBack da Numeracao Automatica            				   �
		����������������������������������������������������������������/*/
		While ( GetSX8Len() > nGetSX8Len )
			RollBackSX8()
		End While
	EndIF

End Sequence

/*/
��������������������������������������������������������������Ŀ
� Coloca o Ponteiro do Mouse em Estado de Espera			   �
����������������������������������������������������������������/*/
CursorWait()

/*/
��������������������������������������������������������������Ŀ
�Libera os Locks             								   �
����������������������������������������������������������������/*/
aAdd( aFreeLocks , { "SZG" , aSZGRecnos , aSZGKeys } )
aAdd( aFreeLocks , { "SZH" , aSZHRecnos , aSZHKeys } )
ApdFreeLocks( aFreeLocks )

/*/
��������������������������������������������������������������Ŀ
�Restaura os Dados de Entrada								   �
����������������������������������������������������������������/*/
RestArea( aArea )

/*/
��������������������������������������������������������������Ŀ
� Restaura as Teclas de Atalho                				   �
����������������������������������������������������������������/*/
RestKeys( aSvKeys , .T. )

/*/
��������������������������������������������������������������Ŀ
� Restaura o Ponteiro do Cursor do Mouse                  	   �
����������������������������������������������������������������/*/
CursorArrow()

Return( nOpcAlt )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �CSA002TEncOk�Autor�Marinaldo de Jesus    � Data �06/01/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �TudoOk para a Enchoice                                      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �CSA002TEncOk( nOpc , oEnSZG )								�
�����������������������������������������������������������������������Ĵ
�Parametros� 															�
�����������������������������������������������������������������������Ĵ
�Uso       �CSA002()	                                                �
�������������������������������������������������������������������������/*/
Static Function CSA002TEncOk( nOpc , oEnSZG )

Local lTudoOk := .T.
                
IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
	lTudoOk := EnchoTudOk( oEnSZG )
EndIF

Return( lTudoOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �SZHLinOk	�Autor�Marinaldo de Jesus     � Data �06/01/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �                                                            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �SZHLinOk( oBrowse )									    �
�����������������������������������������������������������������������Ĵ
�Parametros� 															�
�����������������������������������������������������������������������Ĵ
�Uso       �CSA002()	                                                �
�������������������������������������������������������������������������/*/
User Function SZHLinOk( oBrowse )

Local aCposKey	:= {}
Local lLinOk	:= .T.
Local nX
Local nLoop
/*/
��������������������������������������������������������������Ŀ
� Altera o Estado do Cursor  								   �
����������������������������������������������������������������/*/
CursorWait()

	/*/
	��������������������������������������������������������������Ŀ
	� Evitar que os Inicializadores padroes sejam carregados indevi�
	� damente													   �
	����������������������������������������������������������������/*/
	PutFileInEof( "SZH" )
	
	Begin Sequence
	/*/
	��������������������������������������������������������������Ŀ
	� Se a Linha da GetDados Nao Estiver Deletada				   �
	����������������������������������������������������������������/*/
	IF !( GdDeleted() ) 

		//Valida o campo digitado Ano/Mes
		If !( lLinOk := len(alltrim(GdFieldGet( "ZH_ANOMES" ))) <> 6  .or. ;
			(val(right(GdFieldGet( "ZH_ANOMES" ),2)) > 0 .and. val(right(GdFieldGet( "ZH_ANOMES" ),2)) <= 12) )
			MsgInfo( OemToAnsi( "Ano/Mes inv�lido.") , cCadastro )
			Break
		EndIf			
		 
		/*/
		��������������������������������������������������������������Ŀ
		� Verifica Itens Duplicados na GetDados						   �
		����������������������������������������������������������������/*/
		aCposKey := GetArrUniqe( "SZH" )
		IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
			Break
		EndIF
	
		/*/
		��������������������������������������������������������������Ŀ
		� Verifica Se o Campos Estao Devidamente Preenchidos		   �
		����������������������������������������������������������������/*/
		aCposKey := GdObrigat( aHeader )
		IF !( lLinOk := GdNoEmpty( aCposKey ) )
	    	Break
		EndIF
				
	EndIf
	End Sequence

	/*/
	��������������������������������������������������������������Ŀ
	�Se Houver Alguma Inconsistencia na GetDados, Seta-lhe o Foco  �
	����������������������������������������������������������������/*/
	IF !( lLinOk )
		oBrowse:SetFocus()
	EndIF

/*/
��������������������������������������������������������������Ŀ
� Restaura o Estado do Cursor								   �
����������������������������������������������������������������/*/
CursorArrow()

Return( lLinOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �SZHGdDelOk  �Autor�Marinaldo de Jesus     � Data �06/01/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �Validar a Delecao na GetDados                               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>								    �
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>								    �
�����������������������������������������������������������������������Ĵ
�Uso       �CSA002()	                                                �
�������������������������������������������������������������������������/*/
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
				MsgInfo( OemToAnsi( "Este Cargo neste Concurso j� foi utilizado e n�o poder� ser exclu�do." + CRLF + "A alternativa ser� alterar a situa��o para '2-Cancelado'." ) , cCadastro )
   				Break
   			EndIF
    	EndIF
	EndIF

End Sequence
*/	
Return( lDelOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �CSA002Grava �Autor�Marinaldo de Jesus    � Data �06/01/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �                                                            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �CSA002()	                                                �
�������������������������������������������������������������������������/*/
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
�������������������������������������������������������������Ŀ
� Variaveis de Inicializacao Obrigatoria					  �
���������������������������������������������������������������/*/
Local aMestre	:= GdPutIStrMestre( 01 )
Local aItens	:= {}
Local cOpcao	:= IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )
Local lAllModif	:= .F.
Local lSZGModif	:= .F.
Local lSZHModif	:= .F.
Local lSZHDelet	:= .F.

/*/
�������������������������������������������������������������Ŀ
� Variaveis que serao inicializadas no Corpo da Funcao		  �
���������������������������������������������������������������/*/
Local aSZHColDel
Local aSZHRecDel
Local nLoop
Local nLoops

/*/
��������������������������������������������������������������Ŀ
� Altera o Estado do Cursor  								   �
����������������������������������������������������������������/*/
CursorWait()

	IF ( cOpcao <> "DELETE" )
		/*/
		��������������������������������������������������������������Ŀ
		� Verifica se Houveram Modificacoes no RDV					   �
		����������������������������������������������������������������/*/
		IF ( lSZHModif := !ArrayCompare( aSZHCols , aSvSZHCols ) )
			/*/
			��������������������������������������������������������������Ŀ
			� Deleto todos os Itens que nao Estao OK					   �
			����������������������������������������������������������������/*/
			GdSuperDel( aSZHHeader , @aSZHCols , NIL , .T. , GdGetBlock( "SZH" , aSZHHeader , .F. ) ) 
			/*/
			��������������������������������������������������������������Ŀ
			� Separa os Itens que foram Deletados     					   �
			����������������������������������������������������������������/*/
			lSZHDelet := GdSplitDel( aSZHHeader , @aSZHCols , @aSZHRecnos , @aSZHColDel , @aSZHRecDel  )
		EndIF
	Else
		lSZHModif := .T.
		lSZGModif := .T.
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Carrega os Itens Apenas se Houveram Alteracoes ou na Exclusao�
	����������������������������������������������������������������/*/
	IF ( lSZHModif )

		/*/
		��������������������������������������������������������������Ŀ
		� Carrega as Informacoes deletadas RD4                   	   �
		����������������������������������������������������������������/*/
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
		��������������������������������������������������������������Ŀ
		� Carrega as Informacoes do SZH                   			   �
		����������������������������������������������������������������/*/
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
		��������������������������������������������������������������Ŀ
		� Atualiza aSZGCols para Verificar se Houveram Alteracoes	   �
		����������������������������������������������������������������/*/
		nLoops := Len( aSZGHeader )
		For nLoop := 1 To nLoops
			aSZGCols[ 01 , nLoop ] := GetMemVar( aSZGHeader[ nLoop , 02 ] )
		Next nLoop
		lSZGModif := !( ArrayCompare( aSZGCols , aSvSZGCols ) )
	EndIF	

	/*/
	��������������������������������������������������������������Ŀ
	� Seta a Gravacao ou Exclusao Apenas se Houveram Alteracoes  ou�
	� se foi Selecionada a Exclusao								   �
	����������������������������������������������������������������/*/
 	lAllModif := ( ( lSZHModif ) .or. ( lSZGModif ) )


	/*/
	��������������������������������������������������������������Ŀ
	� Se Houveram Alteracoes, ou Exclusao efetua a Gravacao        �
	����������������������������������������������������������������/*/
	IF ( lAllModif )
		
		/*/
		��������������������������������������������������������������Ŀ
		� Seta a Gravacao ou Exclusao Apenas se Houveram Alteracoes  ou�
		� se foi Selecionada a Exclusao								   �
		����������������������������������������������������������������/*/
		aMestre[ 01 , 01 ]	:= "SZG"
		aMestre[ 01 , 02 ]	:= nReg
		aMestre[ 01 , 03 ]	:= ( ( nOpc == 5 ) .or. !( fCompArray( aSZGCols , aSvSZGCols ) ) )
		aMestre[ 01 , 04 ]	:= aClone( aSZGHeader )
		aMestre[ 01 , 05 ]	:= aClone( aSZGVirtEn )
		aMestre[ 01 , 06 ]	:= {}
		aMestre[ 01 , 07 ]	:= aClone( aItens )
		
		/*/
		��������������������������������������������������������������Ŀ
		� Grava as Informacoes                        				   �
		����������������������������������������������������������������/*/
		GdPutInfoData( aMestre , cOpcao , .F. , .F. )
	
		/*/
		��������������������������������������������������������������Ŀ
		� Confirmando a Numeracao Automatica          				   �
		����������������������������������������������������������������/*/
		While ( GetSX8Len() > nGetSX8Len )
			ConfirmSX8()
		End While

	EndIF
	
/*/
��������������������������������������������������������������Ŀ
� Restaura o Estado do Cursor								   �
����������������������������������������������������������������/*/
CursorArrow()

Return( NIL )

/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � MenuDef		�Autor�  Luiz Gustavo     � Data �28/12/2006�
�����������������������������������������������������������������������Ĵ
�Descri��o �Isola opcoes de menu para que as opcoes da rotina possam    �
�          �ser lidas pelas bibliotecas Framework da Versao 9.12 .      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �CSA002                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/   

Static Function MenuDef()

 Local aRotina :=   {;
							{ "Pesquisar"  	, "AxPesqui"	, 0 , 01,,.F.} ,; //"Pesquisar"
							{ "Visualizar" 	, "U_CSA002Mnt" , 0 , 02 } ,; //"Visualizar"
							{ "Incluir" 	, "U_CSA002Mnt" , 0 , 03 } ,; //"Incluir"
							{ "Alterar" 	, "U_CSA002Mnt" , 0 , 04 } ,; //"Alterar"
							{ "Excluir" 	, "U_CSA002Mnt" , 0 , 05 }  ; //"Excluir"
						}
Return aRotina