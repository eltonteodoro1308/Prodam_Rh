#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PPONM001 ³ Autor ³ Equipe RH             ³ Data ³ 24/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para gerar troca de turno para o proximo periodo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PPONM001( void )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PPONM001()

Local cCadastro	:= "Geração de Troca de Turno antes do Fechamento Mensal"  
Local CPERG		:= "PPONM001"
Local aSay		:= {}
Local aButt		:= {}                  
Local nOpc		:= 0
Private CPERG2	:= "APD002B"

aAdd( aSay, "Este rotina tem como finalidade a geração de troca de turno " )
aAdd( aSay, "para a data de início do próximo período de ponto, conforme " )
aAdd( aSay, "informada pelo usuário. " )
aAdd( aSay, "Execute somente quando pretende manter aberto o período     " )
aAdd( aSay, "anterior por um prazo longo." )

aAdd( aButt, { 5,.T.,{|| Pergunte(cPerg,.T.)     }})
aAdd( aButt, { 1,.T.,{|| FechaBatch(),	nOpc := 1 }})
aAdd( aButt, { 2,.T.,{|| FechaBatch()            }})
  
M001SX1(cPerg)

//Monta Tela Inicial
Pergunte(cPerg,.f.)
MV_PAR01 := ctod("//") //Forca data em branco para que o usuario preencha
FormBatch(cCadastro, aSay, aButt )

If nOpc > 0
	If empty(MV_PAR01)
		msgalert("Você ainda não verificou se a data no parâmetro está correta. Execute novamente com a data desejada.")
	ELseIf day(MV_PAR01) <> 16
		msgalert("O dia necessariamente tem que ser 16. Execute novamente e ajuste a data.")
	ElseIf MV_PAR01 > date()
		msgalert("A data informada não pode ser superior à data atual. Execute novamente e ajuste a data.")
	Else		
		If msgnoyes("Atenção: Serão geradas as trocas de turno para a data de "+dtoc(MV_PAR01)+". Deseja realmente continuar ?")
			Processa( {|| M001RUN() }, "Processando..." )
		EndIf
	EndIf
Endif

RETURN        

/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M001RUN     ºAutor  ³Totvs		       º Data ³19/06/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento                 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function M001RUN()

dNewData 	:= MV_PAR01
cNewData 	:= dtos(MV_PAR01) 
aTabPadrao	:= {}
aTabCalend	:= {}
aTurnos		:= {}
aSPJ		:= {}
nCont		:= 0

//Busca os turno que possuem sequencias
cQry := " Select Distinct(PJ_TURNO) from " + RetSQLName("SPJ")
cQry += " where PJ_SEMANA > '01' and D_E_L_E_T_ <> '*' "
cQry += " order by PJ_TURNO"
TcQuery cQry NEW ALIAS TMPSPJ	                                                   
While TMPSPJ->(!eof())
	aadd(aSPJ,TMPSPJ->PJ_TURNO)
	TMPSPJ->(dbskip())
EndDo
TMPSPJ->(dbclosearea())

//Busca os funcionarios a processar e a ultima troca de turno existente na SPF
cQry := " Select RA_FILIAL, RA_MAT, max(PF_DATA) as PF_DATA, PF_TURNODE, PF_TURNOPA, "
cQry += "        PF_REGRADE, PF_REGRAPA, PF_SEQUEDE, PF_SEQUEPA "
cQry += " from " + RetSQLName("SRA") + " SRA "
cQry += " left join " + RetSQLName("SPF") + " SPF on SPF.D_E_L_E_T_ <> '*' and PF_FILIAL = RA_FILIAL and "
cQry += "   PF_MAT = RA_MAT and PF_DATA in  "
cQry += "     (Select max(PF_DATA) as PF_DATA "
cQry += "       from " + RetSQLName("SPF") + " SPF2 "
cQry += "       where SPF2.D_E_L_E_T_ <> '*' and SPF2.PF_FILIAL = SRA.RA_FILIAL and SPF2.PF_MAT = SRA.RA_MAT and "
cQry += "             SPF2.PF_DATA < '" + cNewData + "' ) "
cQry += " where SRA.D_E_L_E_T_ <> '*' and RA_REGRA <> '' and "
cQry += " 	   (RA_DEMISSA = '' or RA_DEMISSA > '" + cNewData + "') and "
cQry += "       RA_ADMISSA <= '" + cNewData + "' "
cQry += " group by RA_FILIAL, RA_MAT, PF_TURNODE, PF_TURNOPA, PF_REGRADE, PF_REGRAPA, PF_SEQUEDE, PF_SEQUEPA 
cQry += " Order by RA_FILIAL, RA_MAT "
TcQuery cQry NEW ALIAS TMPSRA	                                                   

SRA->(dbsetorder(1))
SPF->(dbsetorder(1))

ProcRegua(0)

While TMPSRA->(!eof())

	IncProc("Fil/Mat "+TMPSRA->RA_FILIAL+"/"+TMPSRA->RA_MAT)

	//Executa somente se nao existir registro na SPF para a mesma data
	If !SPF->(dbseek(TMPSRA->(RA_FILIAL+RA_MAT)+cNewData))
			
		SRA->(dbseek(TMPSRA->(RA_FILIAL+RA_MAT)))
	
		If empty(TMPSRA->PF_DATA)
			cLastTno := SRA->RA_TNOTRAB
			cLastReg := SRA->RA_REGRA
			cLastSeq := SRA->RA_SEQTURN
			dPerIni	 := SRA->RA_ADMISSA
		Else
			cLastTno := TMPSRA->PF_TURNOPA
			cLastReg := TMPSRA->PF_REGRAPA
			cLastSeq := TMPSRA->PF_SEQUEPA
			dPerIni	 := stod(TMPSRA->PF_DATA)
		EndIf
		cNextTno := cLastTno
		cNextReg := cLastReg
		cNextSeq := cLastSeq
		
		//Verifica se o turno do funcionario possue sequencia
		If aScan( aSPJ , { |x| x == cLastTno } )  > 0
			
	
			//Cria o Calendario de Marcacoes do Funcionario 
			aTabPadrao := {}
			aTabCalend := {}
			aTurnos    := {}
			IF CriaCalend(  				dPerIni		,; //01 -> Periodo Inicial
					   						dNewData	,; //02 -> Periodo Final (Com um Dia a Mais para a Obtencao da Proxima Sequencia)
											cLastTno	,; //03 -> Turno de Trabalho
											cLastSeq	,; //04 -> Sequencia de Turno
											@aTabPadrao	,; //05 -> Tabela de Horario Padrao
											@aTabCalend	,; //06 -> Calendario de Marcacoes
											SRA->RA_FILIAL	,; //07 -> Filial do Funcionario
											SRA->RA_MAT	,; //08 -> Matricula do Funcionario
											NIL   		,; //09 -> Centro de Custo do Funcionario (Nao Passar Pois Nao precisa carregar as Excecoes)
											@aTurnos	,; //10 -> Array com as Trocas de Turno
											NIL			,; //11 -> Array com Todas as Excecoes do Periodo
											NIL			,; //12 -> Se executa Query para a Montagem da Tabela Padrao
											.F.			,; //13 -> Se executa a funcao se sincronismo do calendario
											.F.			 ; //14 -> Se forca a Criacao de novo Calendario	
					  		)

				//Guarda o Posicionamento do Ultimo dia Do Calendario ( Neste Caso o Ultimo dia 
				//Corresponde ao Inicio do Proximo Periodo de Apontamento )												   ?
				IF ( ( nTamCalen := Len( aTabCalend ) ) > 0.00 )
					
					/*
					Obtem Turno, Sequencia e Regra referente ao Primeiro dia do  
					Novo periodo. Essas informacoes serao utilizadas para criar 
					a troca de turno do primeiro dia do proximo periodo (se for 
					necessario ).											   				
					*/
					nPosTab:= 0
					cNextTno := GetInfoPosTab(	14						,;	//01 - Posicao em aTabCalend para Obtencao da Informacao
												"1E"					,;	//02 - Flag da Marcacao "1E,1S,..."
												dNewData				,;	//03 - Data em aTabCalend
												aTabCalend			 	,;	//04 - Calendario de Marcacoes
												NIL						,;	//05 -> Tabela de Horario Padrao
												NIL						,;	//06 -> Periodo Inicial de Apontamento
												NIL						,;	//07 -> Periodo Final de Apontamento	
												NIL						,;	//08 -> Informacao Referente a Funcionario
												NIL						,;	//09 -> Turno de Trabalho
												NIL						,;	//10 -> Sequencia
												NIL						,;	//11 -> Filial
												NIL						,;  //12 -> Carrega Excecoes 
												NIL						,;	//13 -> Bloco para Pesquisa em aTabCalend
												@nPosTab				;	//14 -> Retorno da Posicao do aTabCalend 	
					   						  )
					cNextSeq :=  If( Empty(nPosTab), Space(1), aTabCalend[ nPosTab , 08 	] )
					cNextReg  := If( Empty(nPosTab), Space(1), aTabCalend[ nPosTab , 23	    ] )
												    			 
					/*
					Verifica a Ultima Ordem do Calendario de Marcacoes            
					*/
					nPosTab:= 0
					cUltOrd := GetInfoPosTab(	02						,;	//01 - Posicao em aTabCalend para Obtencao da Informacao
												"1E"					,;	//02 - Flag da Marcacao "1E,1S,..."
												dNewData-1				,;	//03 - Data em aTabCalend
												aTabCalend				,;	//04 - Calendario de Marcacoes
							   					NIL						,;	//05 -> Tabela de Horario Padrao
												NIL						,;	//06 -> Periodo Inicial de Apontamento
												NIL						,;	//07 -> Periodo Final de Apontamento	
												NIL						,;	//08 -> Informacao Referente a Funcionario
												NIL						,;	//09 -> Turno de Trabalho
												NIL						,;	//10 -> Sequencia
												NIL						,;	//11 -> Filial
												NIL						,;  //12 -> Carrega Excecoes 
												NIL						,;	//13 -> Bloco para Pesquisa em aTabCalend
												@nPosTab				;	//14 -> Retorno da Posicao do aTabCalend 	
					   						  )
					/*
					Obtem Ultimo Turno, Sequencia e Regra do Periodo Atual confor
					me Calendario de Marcacao. Essas informacoes serao utiliza- 
					das para criar a troca de turno do primeiro dia do proximo 
					periodo ( ser for necessario ).				               				
					*/
					cLastTno := If( Empty(nPosTab), Space(1), aTabCalend[ nPosTab , 14 		] )
					cLastSeq := If( Empty(nPosTab), Space(1), aTabCalend[ nPosTab , 08 		] )
					cLastReg := If( Empty(nPosTab), Space(1), aTabCalend[ nPosTab , 23	   	] )
				
				EndIf
			
			EndIf
			
		EndIf
	
		//Cria a troca de turno
		RecLock("SPF",.t.)
			SPF->PF_FILIAL	:= SRA->RA_FILIAL
			SPF->PF_MAT		:= SRA->RA_MAT
			SPF->PF_DATA	:= dNewData
			SPF->PF_TURNODE	:= cLastTno
			SPF->PF_TURNOPA := cNextTno
			SPF->PF_REGRADE := cLastReg
			SPF->PF_REGRAPA := cNextReg
			SPF->PF_SEQUEDE := cLastSeq
			SPF->PF_SEQUEPA := cNextSeq
		SPF->(MsUnlock())
		nCont++
			
	EndIf
	
	TMPSRA->(dbskip())
	
EndDo
TMPSRA->(dbclosearea())

msgalert("Registros gerados: "+strzero(nCont,5))
	
Return()

/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M001SX1    ºAutor  ³Totvs               º Data ³19/06/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza parametros        								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function M001SX1(cPerg)
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

AADD(aDados,{cPerg,'01','Data Início Próx.Período ?','Data Início Próx.Período ?','Data Início Próx.Período ?','MV_CH1','D',TAMSX3("PF_DATA")[1],0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )

//
// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

RestArea( aAreaDic )
RestArea( aArea )   
RETURN

