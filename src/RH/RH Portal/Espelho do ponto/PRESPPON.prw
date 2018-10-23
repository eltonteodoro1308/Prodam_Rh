#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRESPPON
Serviço de consulta do espelho do ponto
@author  	Carlos Henrique 
@since     	17/08/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSSERVICE 	PRESPPON	DESCRIPTION "Serviço de consulta do espelho do ponto"
	WSDATA cPageType AS String OPTIONAL		//Tipo de pagina
	WSDATA FilTerminal AS String OPTIONAL		//Filial do funcionario
	WSDATA MatTerminal AS String OPTIONAL 		//Matricula do funcionario
	WSDATA PerAponta AS String OPTIONAL		//Periodo de apontamento
	WSDATA PerFiltro AS String OPTIONAL		//Filtro do Periodo de apontamento
	WSDATA SaldoBH AS String	 OPTIONAL			//Saldo do banco de horas
	WSDATA SitApo AS String OPTIONAL			//Situação do apontamento
	WSDATA EstRel AS Base64Binary 				//Estrutura do relatório
	WSMETHOD GETESPBH	DESCRIPTION "Consulta espelho do ponto e banco de horas"
ENDWSSERVICE
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GETESPBH
Consulta espelho do ponto e banco de horas
@author  	Carlos Henrique 
@since     	17/08/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD GETESPBH WSRECEIVE cPageType,FilTerminal,MatTerminal,PerAponta,SitApo,PerFiltro WSSEND EstRel WSSERVICE PRESPPON
Local nSaldoAnt	:= 0
Local nY			:= 0
Local aLancBH		:= {}

IF ::cPageType == "1"
	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	If SRA->(dbSeek(::FilTerminal+::MatTerminal))
		::EstRel:= Encode64(P16R02RUN(::cPageType,.T.,::FilTerminal,::MatTerminal,::PerAponta,::SitApo,::PerFiltro))
	EndIf	
ELSEIF ::cPageType == "2"
	P16R02SAL(2,@nSaldoAnt,::FilTerminal,::MatTerminal,::PerAponta,2,3) //Posicao 6 enviando 2-Horas Valorizadas
	::EstRel:= Encode64(P16R02PIC(nSaldoAnt))
ELSEIF cPageType == "3"
	P16R02SAL(3,@nSaldoAnt,::FilTerminal,::MatTerminal,::PerAponta,2,3) //Posicao 6 enviando 2-Horas Valorizadas
	::EstRel:= Encode64(P16R02PIC(nSaldoAnt))
ENDIF	

Return .T.
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02RUN
Gera relatório espelho de ponto em html
@author  	Totvs
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static function P16R02RUN(cPageType,lTerminal,cFilTerminal,cMatTerminal,cPerAponta,cSitApo,cPerFiltro)
Private cHtml			:= ""
Private cAviso		:= ""
Private aFilesOpen 	:= {"SP5", "SPN", "SP8", "SPG","SPB","SPL","SPC", "SPH", "SPF"}
Private bCloseFiles	:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
Private FilialDe		:= cFilTerminal 
Private FilialAte		:= cFilTerminal
Private CcDe			:= SRA->RA_CC 
Private CcAte			:= SRA->RA_CC 
Private TurDe			:= SRA->RA_TNOTRAB
Private TurAte		:= SRA->RA_TNOTRAB
Private MatDe			:= cMatTerminal
Private MatAte		:= cMatTerminal
Private NomDe			:= SRA->RA_NOME
Private NomAte		:= SRA->RA_NOME
Private cSit			:= fSituacao( NIL , .F. )
Private cCat			:= fCategoria( NIL , .F. )
Private nImpHrs		:= 3
Private nImpAut		:= 1
Private nCopias		:= 1
Private lSemMarc		:= .T.
Private cMenPad1		:= ""
Private cMenPad2		:= ""
Private cFilSPA	 	:= xFilial("SPA", SRA->RA_FILIAL)
Private dPerIni    	:= Stod( Subst( cPerAponta , 1 , 8 ) )
Private dPerFim    	:= Stod( Subst( cPerAponta , 9 , 8 ) ) 
Private dFilPerIni   := Stod( Subst( cPerFiltro , 1 , 8 ) )
Private dFilPerFim   := Stod( Subst( cPerFiltro , 9 , 8 ) )
Private lSexagenal	:= .T.
Private lImpRes		:= .F.
Private lImpTroca  	:= .F. 
Private lImpExcecao	:= .F.  
Private DeptoDe		:= SRA->RA_DEPTO
Private DeptoAte		:= SRA->RA_DEPTO
Private lImpMarc 		:= .T.
Private lCodeBar 		:= .F.
Private lBigLine 		:= .T.
Private aImp      	:= {}
Private aGrpImp      := {}
Private aTotais   	:= {}
Private aAbonados 	:= {}
Private aRetPortal   := {}
Private nOrdem   		:= 1

If ( lTerminal )
	//-- Verifica se foi possivel abrir os arquivos sem exclusividade
	If Pn090Open(@cHtml, @cAviso)
		cHtml := ""	
		cHtml := P16R02IMP(lTerminal,cPerAponta,cSitApo)
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Apos a obtencao da consulta solicitada fecha os arquivos     ³
		³ utilizados no fechamento mensal para abertura exclusiva      ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	    Aeval(aFilesOpen, bCloseFiles)
	Else
		cHtml := HtmlDefault( cAviso , cHtml )   
	Endif
Endif 


Return( cHtml )
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02RUN
Gera relatório espelho de ponto em html
@author  	Totvs
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P16R02IMP(lTerminal,cPerAponta,cSitApo)
Local aAbonosPer	:= {}
Local cOrdem		:= ""
Local cWhere		:= ""
Local cSituacao	:= ""
Local cCategoria	:= ""
Local cLastFil	:= "__cLastFil__"
Local cAcessaSRA	:= &("{ || " + ChkRH("PONR010","SRA","2") + "}")
Local cSeq			:= ""
Local cTurno		:= ""
Local cHtml		:= ""
Local cAliasSRA	:= GetNextAlias()
Local cAliasQTD	:= GetNextAlias()
Local lSPJExclu	:= !Empty( xFilial("SPJ") )
Local lSP9Exclu	:= !Empty( xFilial("SP9") )
Local nX			:= 0
Local nY			:= 0
Local lMvAbosEve	:= .F.
Local lMvSubAbAp	:= .F.
Local dDatBkp		:= DDATABASE
Private aFuncFunc	  	:= {SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1)}		
Private aMarcacoes 	:= {}
Private aTabPadrao 	:= {}
Private aTabCalend 	:= {}
Private aPeriodos  	:= {}
Private aId		  	:= {}
Private aResult	   	:= {}
Private aBoxSPC	   	:= STATICCALL(PONR010,LoadX3Box,"PC_TPMARCA") 
Private aBoxSPH	   	:= STATICCALL(PONR010,LoadX3Box,"PH_TPMARCA")
Private cCodeBar   	:= ""
Private dIniCale   	:= Ctod("//")	//-- Data Inicial a considerar para o Calendario
Private dFimCale   	:= Ctod("//")	//-- Data Final a considerar para o calendario
Private dMarcIni   	:= Ctod("//")	//-- Data Inicial a Considerar para Recuperar as Marcacoes
Private dMarcFim   	:= Ctod("//")	//-- Data Final a Considerar para Recuperar as Marcacoes
Private dIniPonMes 	:= Ctod("//")	//-- Data Inicial do Periodo em Aberto 
Private dFimPonMes 	:= Ctod("//")	//-- Data Final do Periodo em Aberto 
Private lImpAcum   	:= .F.
Private aCodAut     := {}

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi³
³nal preservamos-as nas variaveis: dCaleIni e dCaleFim.		   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dIniCale  	:= dPerIni   //-- Data Inicial a considerar para o Calendario
dFimCale  	:= dPerFim   //-- Data Final a considerar para o calendario

For nX:=1 to Len(cSit)
	If Subs(cSit,nX,1) <> "*"
		cSituacao += "'"+Subs(cSit,nX,1)+"'"
		If ( nX+1 ) <= Len(cSit)
			cSituacao += "," 
		EndIf
	EndIf
Next nX

If !Empty(cSituacao) .and. Subs(cSituacao,Len(cSituacao),1) == ","
	cSituacao := Subs(cSituacao,1,Len(cSituacao)-1)
EndIf     

For nX:=1 to Len(cCat)
	If Subs(cCat,nX,1) <> "*"
		cCategoria += "'"+Subs(cCat,nX,1)+"'"
		If ( nX+1 ) <= Len(cCat)
			cCategoria += "," 
		EndIf
	EndIf
Next nX

If !Empty(cCategoria) .and. Subs(cCategoria,Len(cCategoria),1) == ","
	cCategoria := Subs(cCategoria,1,Len(cCategoria)-1)
EndIf 

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Inicializa Variaveis Static								   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
( STATICCALL(PONR010,CarExtAut) , RstGetTabExtra() )

//--Seleciona funcionários de acordo com filtros
cWhere += "%"
cWhere += "SRA.RA_FILIAL >= '" + FilialDe + "' AND "
cWhere += "SRA.RA_FILIAL <= '" + FilialAte + "' AND "
cWhere += "SRA.RA_CC >= '" + CCDe + "' AND "
cWhere += "SRA.RA_CC <= '" + CCAte + "' AND "
cWhere += "SRA.RA_TNOTRAB >= '" + TurDe + "' AND "
cWhere += "SRA.RA_TNOTRAB <= '" + TurAte + "' AND "
cWhere += "SRA.RA_MAT >= '" + MatDe + "' AND "
cWhere += "SRA.RA_MAT <= '" + MatAte + "' AND "
cWhere += "SRA.RA_NOME >= '" + NomDe + "' AND "
cWhere += "SRA.RA_NOME <= '" + NomAte + "' AND "
cWhere += "SRA.RA_DEPTO >= '" + DeptoDe + "' AND "
cWhere += "SRA.RA_DEPTO <= '" + DeptoAte + "'"
If !Empty( cSituacao )
	cWhere += " AND SRA.RA_SITFOLH IN ( " + cSituacao + ") " 
EndIf
If !Empty(cCategoria)
	cWhere += " AND SRA.RA_CATFUNC IN ( " + cCategoria + ") "
EndIf
cWhere += " AND SRA.D_E_L_E_T_ = ' ' " 
cWhere += "%"

cOrdem := "%SRA.RA_FILIAL, SRA.RA_MAT%"

BeginSql Alias cAliasSRA
 	SELECT SRA.RA_FILIAL, SRA.RA_MAT
	FROM 
		%Table:SRA% SRA
	WHERE %Exp:cWhere%
	ORDER BY %Exp:cOrdem%	
EndSql 	

dbSelectArea('SRA')
SRA->( dbSetOrder( 1 ) )	

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Processa o Cadastro de Funcionarios						   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
While (cAliasSRA)->( !Eof() )

	//Posiciona no funcionário atual
	SRA->(DbSeek((cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT))
	
    /*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica a Troca de Filial           						  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !( SRA->RA_FILIAL == cLastFil )

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Alimenta as variaveis com o conteudo dos MV_'S correspondetes³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/		
		lMvAbosEve	:= ( Upper(AllTrim(SuperGetMv("MV_ABOSEVE",NIL,"N",cLastFil))) == "S" )	//--Verifica se Deduz as horas abonadas das horas do evento Sem a necessidade de informa o Codigo do Evento no motivo de abono que abona horas
		lMvSubAbAp	:= ( Upper(AllTrim(SuperGetMv("MV_SUBABAP",NIL,"N",cLastFil))) == "S" )	//--Verifica se Quando Abono nao Abonar Horas e Possuir codigo de Evento, se devera Gera-lo em outro evento e abater suas horas das Horas Calculadas
	    
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Atualiza a Filial Corrente           						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cLastFil := SRA->RA_FILIAL
		
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega periodo de Apontamento Aberto						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .F. , cLastFil )
			Exit
		EndIf

    	/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Obtem datas do Periodo em Aberto							  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		GetPonMesDat( @dIniPonMes , @dFimPonMes , cLastFil )
		
    	/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Atualiza o Array de Informa‡”es sobre a Empresa.			  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		aInfo := {}
		fInfo( @aInfo , cLastFil )
	
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega as Tabelas de Horario Padrao						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If ( lSPJExclu .or. Empty( aTabPadrao ) )
			aTabPadrao := {}
			fTabTurno( @aTabPadrao , If( lSPJExclu , cLastFil , NIL ) )
		EndIf

    	/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega TODOS os Eventos da Filial						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If ( Empty( aId ) .or. ( lSP9Exclu ) )
			aId := {}
			STATICCALL(PONR010,CarId,fFilFunc("SP9") , @aId , "*" )
		EndIf

		aCodAut := {}
		fTabSP4(@aCodAut,xFilial("SP4",cLastFil))

	EndIf

   	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Retorna Periodos de Apontamentos Selecionados				  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//	aPeriodos := STATICCALL(PONR010,Monta_per,dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )
	
	aPeriodos := P16R02PER(dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim)
   	
   	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Corre Todos os Periodos 									  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	naPeriodos := Len( aPeriodos )
	For nX := 1 To naPeriodos
		
   		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Reinicializa as Datas Inicial e Final a cada Periodo Lido.	  ³
		³Os Valores de dPerIni e dPerFim foram preservados nas   varia³
		³veis: dCaleIni e dCaleFim.									  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
       dPerIni	:= aPeriodos[ nX , 1 ]
       dPerFim	:= aPeriodos[ nX , 2 ] 
       
       // Altera a database para correto funcionamento da função GetMarcacoes
       DDATABASE	:= dPerFim 
   		
   		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Obtem as Datas para Recuperacao das Marcacoes				  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
       dMarcIni	:= aPeriodos[ nX , 3 ]
       dMarcFim	:= aPeriodos[ nX , 4 ]

   		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Verifica se Impressao eh de Acumulado						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		lImpAcum := ( dPerFim < dIniPonMes )
		   
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Retorna Turno/Sequencia das Marca‡”es Acumuladas			  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If ( lImpAcum )
			If SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni) ) ) .and. !Empty(SPF->PF_SEQUEPA)
				cTurno	:= SPF->PF_TURNOPA
				cSeq	:= SPF->PF_SEQUEPA
			Else
	    		/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Tenta Achar a Sequencia Inicial utilizando RetSeq()³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				If !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty( cSeq )
	    			/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Tenta Achar a Sequencia Inicial utilizando fQualSeq()		  ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					cSeq := fQualSeq( NIL , aTabPadrao , dPerIni , @cTurno )
				EndIf
			EndIf

			If ( Empty(cTurno) )
				SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
				Do While	( !EOF() ) .AND.;
						 	( SRA->RA_FILIAL + SRA->RA_MAT == SPF->PF_FILIAL + SPF->PF_MAT )
					If ( SPF->PF_DATA >= dPerIni .AND. SPF->PF_DATA <= dPerFim )						
						cTurno	:= SPF->PF_TURNOPA
						cSeq	:= SPF->PF_SEQUEPA
						Exit
					Else
						SPF->( dbSkip() )
					EndIf
				EndDo
			EndIf
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Obtem Codigo e Descricao da Funcao do Trabalhador na Epoca   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/			
			fBuscaCC(dMarcFim, @aFuncFunc[1], @aFuncFunc[2], Nil, .F. , .T.  ) 
			aFuncFunc[2]:= Substr(aFuncFunc[2], 1, 25)
			fBuscaFunc(dMarcFim, @aFuncFunc[3], @aFuncFunc[4],20, @aFuncFunc[5], @aFuncFunc[6],25, .F. )
		Else
   			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Considera a Sequencia e Turno do Cadastro            		  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			cTurno	:= SRA->RA_TNOTRAB
			cSeq	:= SRA->RA_SEQTURN  
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Obtem Codigo e Descricao da Funcao do Trabalhador     		  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/			
			aFuncFunc[1]:= SRA->RA_CC
			aFuncFunc[2]:= DescCc(aFuncFunc[1], SRA->RA_FILIAL, 25)
			aFuncFunc[3]:= SRA->RA_CODFUNC 
			aFuncFunc[4]:= DescFun(SRA->RA_CODFUNC , SRA->RA_FILIAL)
			aFuncFunc[6]:= DescCateg(SRA->RA_CATFUNC , 25)
		EndIf
	
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega Arrays com as Marca‡”es do Periodo (aMarcacoes), com³
		³o Calendario de Marca‡”es do Periodo (aTabCalend) e com    as³	
		³Trocas de Turno do Funcionario (aTurnos)					  ³	
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		( aMarcacoes := {} , aTabCalend := {} , aTurnos := {} )
		
		If lImpMarc   
		    /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Importante: 												  ³
			³ O periodo fornecido abaixo para recuperar as marcacoes   cor³
			³ respondente ao periodo de apontamentoo Calendario de 	 Marca³	
			³ ‡”es do Periodo ( aTabCalend ) e com  as Trocas de Turno  do³	
			³ Funcionario ( aTurnos ) integral afim de criar o  calendario³	
			³ com as ordens correspondentes as gravadas nas marcacoes	  ³	
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If !GetMarcacoes(	@aMarcacoes					,;	//Marcacoes dos Funcionarios
								@aTabCalend					,;	//Calendario de Marcacoes
								@aTabPadrao					,;	//Tabela Padrao
								@aTurnos					,;	//Turnos de Trabalho
								dPerIni 					,;	//Periodo Inicial
								dPerFim						,;	//Periodo Final
								SRA->RA_FILIAL				,;	//Filial
								SRA->RA_MAT					,;	//Matricula
								cTurno						,;	//Turno
								cSeq						,;	//Sequencia de Turno
								SRA->RA_CC					,;	//Centro de Custo
								If(lImpAcum,"SPG","SP8")	,;	//Alias para Carga das Marcacoes
								NIL							,;	//Se carrega Recno em aMarcacoes
								.T.							,;	//Se considera Apenas Ordenadas
							    .T.    						,;	//Se Verifica as Folgas Automaticas
							  	.F.    			 			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
						 )
				Loop
			EndIf
		EndIf					 
	   
	    aPrtTurn:={}
	    Aeval(aTurnos, {|x| If( x[2] >= dPerIni .AND. x[2]<= dPerFim, Aadd(aPrtTurn, x),Nil )} ) 
	   
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Reinicializa os Arrays aToais e aAbonados					  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		( aTotais := {} , aAbonados := {} )

	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Carrega os Abonos Conforme Periodo       					  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If 	lImpMarc
			fAbonosPer( @aAbonosPer , dPerIni , dPerFim , cLastFil , SRA->RA_MAT )
		EndIf

	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Carrega os Totais de Horas e Abonos.						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If 	lImpMarc	
			STATICCALL(PONR010,CarAboTot,@aTotais , @aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp )						
		EndIf
	
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Carrega o Array a ser utilizado na Impress„o.				  ³
		³aPeriodos[nX,3] --> Inicio do Periodo para considerar as  mar³
		³                    cacoes e tabela						  ³
		³aPeriodos[nX,4] --> Fim do Periodo para considerar as   marca³
		³                    coes e tabela							  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If ( !STATICCALL(PONR010,fMontaAimp,aTabCalend, aMarcacoes, @aImp,dMarcIni,dMarcFim, .F. , lImpAcum) .and. !( lSemMarc ) )
			Loop
		EndIf
		
		Aeval(aImp,{|x| aadd(aGrpImp,x)})
		
		/*
		FOR nY:=1 TO LEN(aImp)
			IF (ASCAN(aGrpImp,{|x| x[1]==aImp[nY][1]})== 0)
				AADD(aGrpImp,aImp[nY])
			ENDIF
		NEXT nY
		*/
		
		//cHtml := fImpFun(aImp,cPerAponta,cSitApo)		    
	
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Reinicializa Variaveis										  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		aImp      := {}
		aTotais   := {}
		aAbonados := {}
		
	Next nX
	
	cHtml := fImpFun(aGrpImp,cPerAponta,cSitApo,aPeriodos)

    (cAliasSRA)->( dbSkip() )

End While

(cAliasSRA)->(DbCloseArea())

DDATABASE:= dDatBkp

Return( cHtml )
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} fImpFun
Gera relatório espelho de ponto em html
@author  	Carlos Henrique
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function fImpFun(aImp,cPerAponta,cSitApo,aPeriodos)
Local cHtml		:= ""
Local cAuxHtm		:= ""    
Local nX        	:= 0
Local nY        	:= 0
Local nLenImp		:= 0
Local nSaldoAnt	:= 0
Local nSaldoDia	:= 0 
Local nLanFolha	:= 0 
Local aLancRH3	:= {}
Local aDtaBxaBH	:= {}
Local aLancBH		:= P16R02SAL(4,@nSaldoAnt,SRA->RA_FILIAL,SRA->RA_MAT,cPerAponta,2,3,@aDtaBxaBH) //Posicao 6 enviando 2-Horas Valorizadas
Local aAuxImp		:= {}
Local nPos			:= 0
Local nBH			:= 0
Local dIniPonVig	:= dIniPonMes
Local dFimPonVig	:= dFimPonMes
Local lSitSup		:= .F.
Local lSitRH		:= .F.
Local lSitApr		:= .F.
Local lSitRep		:= .F.
Local lSitImpar	:= .F.
Local lCorrigida	:= .F.
LOCAL dUltLanc	:= CTOD("")
LOCAL dDtSldAnt	:= CTOD("")
LOCAL dDtIniPer	:= CTOD("")
LOCAL dDtFimPer	:= CTOD("")
LOCAL lUltLanc	:= .F.
Local lSitAbn		:= .F.
LOCAL cAbono		:= ''
LOCAL cDtAbAnt	:= ''
Local nHrsBxa		:= 0
Local lLancBH		:= .F.
Local aAuxLBH		:= {}
Local lHrsAcum	:= .F.
LOCAL dDMenos1	:= DATE() -1
LOCAL nExpandir	:= 0

//Valida solicitações apenas quando algum tipo for selecionado (1 a 5)
IF cSitApo != "6" .and. cSitApo != "7"
	P16R02RH3(SRA->RA_FILIAL,SRA->RA_MAT,cPerAponta,@aLancRH3)
ENDIF

FOR nX:= 1 to len(aImp)	
	lSitSup	:= .F.
	lSitRH		:= .F.
	lSitApr	:= .F.
	lSitRep	:= .F.
	lSitRH		:= .F.
	lSitImpar	:= .F.

   //avalia lançamentos dos abonos (SPI)
	IF cSitApo == "6" .or. cSitApo == "7"
      IF (nX+1) <= len(aImp)
		   IF Dtoc(aImp[nX,1]) == Dtoc(aImp[nX+1,1]) //lancto de mesma data
    		  // armazena lancto marcação corrigida
             IF VALTYPE(aImp[nX,3]) == "A"
                cAbono += '; ' +aImp[nX,3,2] +' ' +aImp[nX,3,1]
                cDtAbAnt:= Dtoc(aImp[nX,1])
             	  lSitAbn := .T.
             EndIf
      		  loop 
       	Else
              IF lSitAbn
                 //Atualiza informação do abono em um único dia
	             IF VALTYPE(aImp[nX,3]) == "A" .and. VALTYPE(aImp[nX,3,1]) == "C"
						aImp[nX,3,1] := aImp[nX,3,1] + cAbono 
	             EndIf
              
                 lSitAbn	:= .F.
			      cAbono	:= ''
              EndIf        	
       	EndIf
       elseif (nX== len(aImp) .and. Dtoc(aImp[nX,1])== cDtAbAnt)
          IF lSitAbn
             //Atualiza informação do abono em um único dia
             IF VALTYPE(aImp[nX,3]) == "A" .and. VALTYPE(aImp[nX,3,1]) == "C"
					aImp[nX,3,1] := aImp[nX,3,1] + cAbono 
             EndIf
          
             lSitAbn	:= .F.
		      cAbono	:= ''
          EndIf       	
   		EndIf	
   EndIF
	
	IF LEN(aImp[nX]) > 3		
		nY:= LEN(aImp[nX]) - 3
		IF (nY%2)!= 0
			lSitImpar	:= .T.
		ENDIF
	ENDIF	
		
	IF EMPTY(aImp[nX,2]) .and. lSitImpar
		aImp[nX,2]	:= "Marcação Impar"
	ELSEIF !(LEN(aImp[nX]) > 3)  //IF UPPER(TRIM(aImp[nX,2]))=="** AUSENTE **"
		IF (nPos:= ASCAN(aLancRH3,{|x| x[1]==aImp[nX,1] })) > 0
			IF aLancRH3[nPos][2]== "1"
				aImp[nX,2]	:= "Pré Abono Aguardando Efetivacao do Gestor"
				aImp[nX,3]	:= {aLancRH3[nPos][3],aLancRH3[nPos][4],aLancRH3[nPos][5],""}
				lSitSup	:= .T.
			ELSEIF aLancRH3[nPos][2]== "2"
				aImp[nX,2]	:= "Pré Abono atendido"
				aImp[nX,3]	:= {aLancRH3[nPos][3],aLancRH3[nPos][4],aLancRH3[nPos][5],""}
				lSitApr	:= .T.
			ELSEIF aLancRH3[nPos][2]== "3"
				aImp[nX,2]	:= "Pré Abono Reprovado"
				aImp[nX,3]	:= {aLancRH3[nPos][3],aLancRH3[nPos][4],aLancRH3[nPos][5],""}
				lSitRep	:= .T.
			ELSEIF aLancRH3[nPos][2]== "4"
				aImp[nX,2]	:= "Pré Abono Aguardando Efetivacao do RH"
				aImp[nX,3]	:= {aLancRH3[nPos][3],aLancRH3[nPos][4],aLancRH3[nPos][5],""}
				lSitRH		:= .T.			
			ENDIF			
		ENDIF
	ENDIF


	IF lSitSup .AND. cSitApo == "1" //solicitações pedentes workflow
		AADD(aAuxImp,aImp[nX])	
	ELSEIF lSitApr .AND. cSitApo == "2" //solicitações atendidas
		AADD(aAuxImp,aImp[nX])	
	ELSEIF lSitRep .AND. cSitApo == "3" //solicitações reprovadas
		AADD(aAuxImp,aImp[nX])	
	ELSEIF lSitRH .AND. cSitApo == "4" //solicitações pendentes RH
		AADD(aAuxImp,aImp[nX])	
	ELSEIF (lSitSup .OR. lSitApr .OR. lSitRep .OR. lSitSup) .AND. cSitApo == "5" //Todas as solicitações
		AADD(aAuxImp,aImp[nX])	
	ELSEIF lSitImpar .OR. cSitApo == "6" //falta marcação
		IF UPPER(TRIM(aImp[nX,2]))=="** AUSENTE **" .AND. VALTYPE(aImp[nX,3]) != "A" 
			AADD(aAuxImp,aImp[nX])
		ELSEIF lSitImpar
			AADD(aAuxImp,aImp[nX])			
		ELSEIF VALTYPE(aImp[nX,3]) != "A" 
			IF UPPER(TRIM(aImp[nX,3]))=="** AUSENTE **"
				AADD(aAuxImp,aImp[nX])
			ENDIF	
		ENDIF
	ELSEIF !lSitSup .AND. !lSitApr .AND. !lSitRep .AND. !lSitSup .AND. cSitApo == "7" //Todas as marcações
		AADD(aAuxImp,aImp[nX])
		lHrsAcum	:= .T.
	ENDIF
NEXT 


//-- Imprime Marcações
nLenImp := Len(aAuxImp)

For nX := 1 To nLenImp
	IF (aAuxImp[nX,1]>=dFilPerIni .and. aAuxImp[nX,1]<=dFilPerFim)   						
		nExpandir++
		
		IF nExpandir == 1
			dDtSldAnt	:= aAuxImp[nX,1]-1	
		ENDIF
	ENDIF	
NEXT nX

If nLenImp > 0
	cHtml +=	'<div id="divBtImp" name="divBtImp" align="right">'  + CRLF
	//cHtml +=	'<input type="button" name="BtnImprimir" class="B02"  value="Imprimir" onclick="javascript:ImpRelatorio();"/>'  + CRLF
	cHtml +=	'<input type="button" name="BtnExpandirTodos" class="B02"  value="Expandir Todos" onclick="javascript:ExpandirTodos('+ cvaltochar(nExpandir) +');"/>'  + CRLF
	cHtml +=	'</div">'  + CRLF	
	nExpandir	:= 1
ENDIF

//cHtml +=	'<div id="divImprimir" name="divImprimir">'  + CRLF
cHtml +=	'<table width="100%" border="1" class="R01" cellpadding="0" cellspacing="0">'  + CRLF

If nLenImp > 0
	
	FOR nY:=1 TO LEN(aLancBH)				
		IF aLancBH[nY][1] <= dDtSldAnt

			IF UPPER(aLancBH[nY][7]) == "BAIXADO"	
				IF aLancBH[nY][4] > 0
					nHrsBxa:= SubHoras(nHrsBxa,aLancBH[nY][4])					
				Endif
	
				IF aLancBH[nY][5] > 0
					nHrsBxa:= SomaHoras(nHrsBxa,aLancBH[nY][5])				
				Endif
			Endif
		
			IF aLancBH[nY][4] > 0
				nSaldoAnt:= SubHoras(nSaldoAnt,aLancBH[nY][4])					
			Endif

			IF aLancBH[nY][5] > 0
				nSaldoAnt:= SomaHoras(nSaldoAnt,aLancBH[nY][5])				
			Endif
							
		ELSEIF aLancBH[nY][1] <= dDMenos1 		
			AADD(aAuxLBH,aLancBH[nY])								
		Endif
	NEXT nY

	cHtml +=	'	<tr>'  + CRLF
	cHtml +=	'		<td width="100%" class="R01">'  + CRLF
	cHtml +=	'			<br />'  + CRLF
	cHtml +=	'				<table width="100%" class="R01" border="0" cellspacing="2" cellpadding="2">'  + CRLF
	cHtml +=	'					<tr>'  + CRLF
	cHtml +=	'						<td width="10%" class="R01"></td>'  + CRLF
	cHtml +=	'						<td width="60%" class="R01"></td>'  + CRLF
	cHtml +=	'						<td width="30%" class="R01" align="Right"><font size="1"><b>* Marcação Manual</b></font></td>'  + CRLF
	cHtml +=	'					</tr>'  + CRLF
	cHtml +=	'					<tr>'  + CRLF
	cHtml +=	'						<td width="10%" class="R01"><b>Matrícula</b></td>'  + CRLF
	cHtml +=	'						<td width="60%" class="R01"><b>Nome</b></td>'  + CRLF
	cHtml +=	'						<td width="30%" class="R01"><b>Horário</b></td>'  + CRLF
	cHtml +=	'					</tr>'  + CRLF
	cHtml +=	'					<tr>'  + CRLF
	cHtml +=	'						<td class="R01">'+SRA->RA_MAT+'</td>'  + CRLF
	cHtml +=	'						<td class="R01">'+SRA->RA_NOME+'</td>'  + CRLF
	cHtml +=	'						<td class="R01">'+GetAdvFVal("SR6","R6_DESC",xFilial("SR6")+SRA->RA_TNOTRAB,1)+'</td>'  + CRLF	
	cHtml +=	'					</tr>'  + CRLF
	cHtml +=	'					<tr>'  + CRLF
	cHtml +=	'						<td colspan="2" class="R01"><b>Período de apontamento vigente:</b> '+ Dtoc(dIniPonVig) +' até '+ Dtoc(dFimPonVig) +'</td>'  + CRLF	
	cHtml +=	'						<td class="R01"><b>Saldo do BH em '+dtoc(dDtSldAnt)+':</b>   '+ P16R02PIC(nSaldoAnt) +'</td>'  + CRLF
	cHtml +=	'					</tr>'  + CRLF
	cHtml +=	'					<tr>'  + CRLF
	cHtml +=	'						<td width="100%" colspan="3" class="R01">'  + CRLF
	cHtml +=	'							<table width="100%" class="R02">'  + CRLF

	For nX := 1 To nLenImp
		
		cAuxHtm :=	'							<tr>'  + CRLF
		cAuxHtm +=	'								<td class="R01" width="50%"><font size="2"><b>'+ Dtoc(aAuxImp[nX,1]) +' - '+ DiaSemana(aAuxImp[nX,1]) +'</b></font></td>'  + CRLF
		
		IF LEN(aAuxImp[nX])< 4 .and. EMPTY(aAuxImp[nX,2])
		   //Tratamento para quando existir evento de abono sem marcação de batidas   
		   IF VALTYPE(aAuxImp[nX,3]) != "A" 
 			   cAuxHtm +=	'								<td class="R01" width="50%"><font color="blue" size="2">Situação: '+aAuxImp[nX,3]+'</font></td>'  + CRLF
          ELSE
    			cAuxHtm +=	'								<td class="R01" width="50%">&nbsp;</td>'  + CRLF
          ENDIF
		ELSEIF !EMPTY(aAuxImp[nX,2])
			cAuxHtm +=	'								<td class="R01" width="50%"><font color="blue" size="2">Situação: '+aAuxImp[nX,2]+'</font></td>'  + CRLF		
		ELSE
			cAuxHtm +=	'								<td class="R01" width="50%">&nbsp;</td>'  + CRLF
		ENDIF
		
		cAuxHtm +=	'							</tr>'  + CRLF
		cAuxHtm +=	'							<tr>'  + CRLF
							
		lCorrigida	:= .F.
		IF LEN(aAuxImp[nX]) > 3
			FOR nY:=4 TO LEN(aAuxImp[nX])
				IF "*"$aAuxImp[nX][nY]
					lCorrigida	:= .T.
					EXIT
				ENDIF
			NEXT nY
		ENDIF
		
		IF lCorrigida
			//cAuxHtm +=	'							<td class="R01"><b>Marcações:</b></td>'  + CRLF			
			IF LEN(aAuxImp[nX]) > 3
				cAuxHtm +=	'							<td class="R01"><b>Marcações:</b><font size="2">'+ CRLF			
				FOR nY:=4 TO LEN(aAuxImp[nX])
					IF !"*"$aAuxImp[nX][nY]
						cAuxHtm += aAuxImp[nX][nY]+' '
					ENDIF	
				NEXT nY
				cAuxHtm += '								</font></td>'  + CRLF	
			ELSE
				cAuxHtm +=	'							<td class="R01"><b>Marcações:</b></td>'  + CRLF
			ENDIF			
		ELSE	
			IF LEN(aAuxImp[nX]) > 3
				cAuxHtm +=	'							<td class="R01"><b>Marcações:</b><font size="2">'+ CRLF			
				FOR nY:=4 TO LEN(aAuxImp[nX])
					cAuxHtm += aAuxImp[nX][nY]+' '
				NEXT nY
				cAuxHtm += '								</font></td>'  + CRLF	
			ELSE
				cAuxHtm +=	'							<td class="R01"><b>Marcações:</b></td>'  + CRLF
			ENDIF
		ENDIF	
		
		IF lHrsAcum
			dUltLanc	:= CTOD("")
			lLancBH	:= .F.
			FOR nY:=1 TO LEN(aAuxLBH)
				
				//ULTIMO LANCAMENTO DO MES
				IF MONTH(aAuxLBH[nY,1]) <= MONTH(aAuxImp[nX,1]) .and. VAL(LEFT(DTOC(aAuxLBH[nY,1]),2))<= 15
					dUltLanc:= aAuxLBH[nY,1]
				ENDIF
				
				IF aAuxLBH[nY][1] == aAuxImp[nX,1] 	
					lLancBH:= .T.
					IF aAuxLBH[nY][4] > 0
						nSaldoAnt:= SubHoras(nSaldoAnt,aAuxLBH[nY][4])										
					Endif
		
					IF aAuxLBH[nY][5] > 0
						nSaldoAnt:= SomaHoras(nSaldoAnt,aAuxLBH[nY][5])				
					Endif
				ELSEIF lLancBH
					EXIT								
				Endif
			NEXT nY
			
			lUltLanc:= .F.
			IF EMPTY(dUltLanc) .AND. !EMPTY(aAuxImp[nX,1])
				lUltLanc:= LEFT(DTOC(aAuxImp[nX,1]),2)=="15" 
			ELSEIF !EMPTY(dUltLanc) .and. LEFT(DTOC(dUltLanc),2)=="15" 
				lUltLanc:= aAuxImp[nX,1] == dUltLanc
			ENDIF
			
			IF lUltLanc
				nLanFolha:= P16R02BXA(2,SRA->RA_FILIAL,SRA->RA_MAT,aAuxImp[nX,1],2,CTOD(""))
			ENDIF
	
			IF lUltLanc .and. nSaldoAnt!=0 .AND. nLanFolha!=0
							
				cAuxHtm +=	'							<td class="R01">
				
				IF nSaldoAnt < 0
					cAuxHtm +=	'							<b>Total Saldo:</b><font color="red"> '+ P16R02PIC(nSaldoAnt) +'</font>'  + CRLF
				ELSE
					cAuxHtm +=	'							<b>Total Saldo:</b><font color="blue"> '+ P16R02PIC(nSaldoAnt) +'</font>'  + CRLF
				ENDIF	
				
				IF nLanFolha < 0
					nSaldoAnt	:= SomaHoras(nSaldoAnt,nLanFolha*-1)
				ELSEIF nLanFolha > 0
					//nSaldoAnt	:= SomaHoras(nSaldoAnt,nLanFolha*-1)
					nSaldoAnt	:= SubHoras(nSaldoAnt,nLanFolha)
				ENDIF					
				
				IF nLanFolha < 0
					cAuxHtm +=	'								<br><b>Desconto no Mês:</b><font color="red"> '+ P16R02PIC(nLanFolha) +'</font>'  + CRLF
				ELSE
					cAuxHtm +=	'								<br><b>Pago no Mês:</b><font color="blue"> '+ P16R02PIC(nLanFolha) +'</font>'  + CRLF
				ENDIF
				
				nLanFolha	:= 0
				
				IF nSaldoAnt < 0
					cAuxHtm +=	'							<br><b>Horas Acumuladas:</b><font color="red"> '+ P16R02PIC(nSaldoAnt) +'</font>'  + CRLF
				ELSE
					cAuxHtm +=	'							<br><b>Horas Acumuladas:</b><font color="blue"> '+ P16R02PIC(nSaldoAnt) +'</font>'  + CRLF
				ENDIF
				
				cAuxHtm +=	'							</td>'  + CRLF			
				
			ELSE
				IF nSaldoAnt < 0
					cAuxHtm +=	'						<td class="R01"><b>Horas Acumuladas:</b><font color="red"> '+ P16R02PIC(nSaldoAnt) +'</font></td>'  + CRLF
				ELSE
					cAuxHtm +=	'						<td class="R01"><b>Horas Acumuladas:</b><font color="blue"> '+ P16R02PIC(nSaldoAnt) +'</font></td>'  + CRLF
				ENDIF			
			ENDIF			
		ENDIF
		
		cAuxHtm +=	'								<td class="R01">&nbsp;</td>'  + CRLF
		
		cAuxHtm +=	'							</tr>'  + CRLF

		IF lCorrigida
			cAuxHtm +=	'							<tr>'  + CRLF
			cAuxHtm +=	'								<td class="R01"><b>Marcação corrigida:</b><font size="2">'+ CRLF			
			FOR nY:=4 TO LEN(aAuxImp[nX])
				cAuxHtm += aAuxImp[nX][nY]+' '
			NEXT nY
			cAuxHtm += '									</font></td>'  + CRLF						
			cAuxHtm +=	'								<td class="R01">&nbsp;</td>'  + CRLF
			cAuxHtm +=	'								<td class="R01">&nbsp;</td>'  + CRLF
			cAuxHtm +=	'							</tr>'  + CRLF		
		EndIf
		
		IF VALTYPE(aAuxImp[nX,3]) == "A"
			cAuxHtm +=	'							<tr>'  + CRLF
			cAuxHtm +=	'								<td class="R01"><b>Abonos considerados:</b> '+aAuxImp[nX,3,2]+' '+alltrim(aAuxImp[nX,3,3])+' - '+aAuxImp[nX,3,1]+'</td>'  + CRLF
			cAuxHtm +=	'								<td class="R01">&nbsp;</td>'  + CRLF
			cAuxHtm +=	'								<td class="R01">&nbsp;</td>'  + CRLF
			cAuxHtm +=	'							</tr>'  + CRLF
		ENDIF
		
		cAuxHtm +=	'							<tr>'  + CRLF
		cAuxHtm +=	'								<td class="R01" colspan="3">'  + CRLF
		cAuxHtm +=	'									<table width="100%" class="R03">'  + CRLF
		cAuxHtm +=	'										<tr class="R03">'  + CRLF
		cAuxHtm +=	'											<td class="R03">'  + CRLF
		cAuxHtm +=	'												<a href="javascript:Detalhes('+ cvaltochar(nExpandir) +',false);" class="LinkDetalhes"><b>Detalhes</b></a>'  + CRLF
		cAuxHtm +=	'											</td>'  + CRLF
		cAuxHtm +=	'											<td class="R03" width="10px">'  + CRLF
		cAuxHtm +=	'												<div id="ButDet'+ cvaltochar(nExpandir) +'">'  + CRLF
		cAuxHtm +=	'													<a href="javascript:Detalhes('+ cvaltochar(nExpandir) +',false);" class="LinkDetalhes"><b>Exibir</b></a>'  + CRLF
		cAuxHtm +=	'												</div>'  + CRLF
		cAuxHtm +=	'											</td>'  + CRLF
		cAuxHtm +=	'										</tr>'  + CRLF
		cAuxHtm +=	'										<tr>'  + CRLF
		cAuxHtm +=	'											<td class="R01" colspan="2">'  + CRLF
		cAuxHtm +=	'												<div id="Detalhes'+ cvaltochar(nExpandir) +'" style="display:none;">
		cAuxHtm +=	'													<table width="100%" class="R02">'  + CRLF
		cAuxHtm +=	'														<tr>'  + CRLF
		cAuxHtm +=	'															<td class="R01"><b>Apontamentos</b></td>'  + CRLF
		cAuxHtm +=	'															<td class="R01" width="10px"><b>Saldos</b></td>'  + CRLF
		cAuxHtm +=	'														</tr>'  + CRLF
		
		nBH	:= 0
		nSaldoDia	:= 0
		FOR nY:=1 TO LEN(aAuxLBH)
			IF aAuxLBH[nY][1] == aAuxImp[nX,1]	
				nBH++
				IF aAuxLBH[nY][4] > 0
					nSaldoDia:= SubHoras(nSaldoDia,aAuxLBH[nY][4])				
					cAuxHtm +=	'												<tr>'  + CRLF			
					cAuxHtm +=	'													<td class="R01">'+aAuxLBH[nY][2]+' - '+ TRIM(aAuxLBH[nY][3]) +' - Debito </td>'  + CRLF
					cAuxHtm +=	'													<td class="R01" align="right"><font color="red">-'+ P16R02PIC(aAuxLBH[nY][4]) +'</font></td>'  + CRLF
					cAuxHtm +=	'												</tr>'  + CRLF					
				Endif
	
				IF aAuxLBH[nY][5] > 0
					nSaldoDia:= SomaHoras(nSaldoDia,aAuxLBH[nY][5])
					cAuxHtm +=	'												<tr>'  + CRLF
					//cAuxHtm +=	'													<td class="R01">'+aAuxLBH[nY][2]+' - '+ TRIM(aAuxLBH[nY][3]) +' - Credito - '+ TRIM(aAuxLBH[nY][7]) +'</td>'  + CRLF
					cAuxHtm +=	'													<td class="R01">'+aAuxLBH[nY][2]+' - '+ TRIM(aAuxLBH[nY][3]) +' - Credito </td>'  + CRLF
					cAuxHtm +=	'													<td class="R01" align="right"><font color="blue">'+ P16R02PIC(aAuxLBH[nY][5]) +'</font></td>'  + CRLF
					cAuxHtm +=	'												</tr>'  + CRLF					
				Endif				
			Endif
		NEXT nY
		
		IF nBH == 0			
			cAuxHtm +=	'													<tr bgcolor="#F2F2F2">'  + CRLF
			cAuxHtm +=	'														<td colspan="8"><span><strong><center>N&atilde;o existem registros para exibi&ccedil;&atilde;o</center></strong></span></td>'  + CRLF
			cAuxHtm +=	'													</tr>'  + CRLF		
		ENDIF
				
		cAuxHtm +=	'														<tr>'  + CRLF		
		
		cAuxHtm +=	'															<td class="R01" align="right"><b>Saldo do dia:</b></td>'  + CRLF
		
		IF nSaldoDia < 0
			cAuxHtm +=	'														<td class="R01" align="right"><font color="red">'+ P16R02PIC(nSaldoDia) +'</font></td>'  + CRLF
		ELSE
			cAuxHtm +=	'														<td class="R01" align="right"><font color="blue">'+ P16R02PIC(nSaldoDia) +'</font></td>'  + CRLF
		ENDIF
			
		cAuxHtm +=	'														</tr>'  + CRLF			

		cAuxHtm +=	'													</table>'  + CRLF		
		cAuxHtm +=	'												</div>'  + CRLF											
		cAuxHtm +=	'											</td>'  + CRLF
		cAuxHtm +=	'										</tr>'  + CRLF
		cAuxHtm +=	'									</table>'  + CRLF
		cAuxHtm +=	'								<td>'  + CRLF
		cAuxHtm +=	'							</tr>'  + CRLF
		
		IF (aAuxImp[nX,1]>=dFilPerIni .and. aAuxImp[nX,1]<=dFilPerFim)   						
			cHtml += cAuxHtm
			nExpandir++
		ENDIF
			
	Next nX
	
	cHtml +=	'						</table>'  + CRLF
	cHtml +=	'					</td>'  + CRLF
	cHtml +=	'				</tr>'  + CRLF		
	cHtml +=	'				</table>'  + CRLF
	cHtml +=	'			</td>'  + CRLF
	cHtml +=	'		</tr>'  + CRLF	
Else
	cHtml += 	'		<tr><td colspan="6" align="center"><span class="TituloMenor"><strong><center>N&atilde;o existem registros para exibi&ccedil;&atilde;o</center></strong></span></td></tr>'  + CRLF
EndIf

cHtml += 	'</table>'  + CRLF
//cHtml +=	'</div>'  + CRLF

Return( cHtml )
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02RH3
Retorna os lançamentos de justificativas de pré abono
@author  	Carlos Henrique
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static function P16R02RH3(cFilSra,cMatric,cPerAponta,aLancRH3)
LOCAL aArea	:= GETAREA()
LOCAL cTab		:= GetNextAlias()
Local dPerIni	:= Stod( Subst( cPerAponta , 1 , 8 ) )
Local dPerFim	:= Stod( Subst( cPerAponta , 9 , 8 ) )	
Local cHoraIni:= ""
Local cHoraFim:= ""
Local cAbono	:= ""
LOCAL nTotDias:= 0
LOCAL dRefAbo	:= CTOD("")
LOCAL nCnt		:= 0
Private dIniAbo:= CTOD("")
Private dFimAbo:= CTOD("")

BeginSql Alias cTab
	SELECT * FROM %TABLE:RH3% RH3	
	WHERE RH3_FILIAL=%exp:cFilSra%
	AND RH3_MAT=%exp:cMatric%
	AND RH3_TIPO='8'
	AND RH3.D_E_L_E_T_ ='' 
EndSql

//GETLastQuery()[2]
(cTab)->(dbSelectArea((cTab)))                    

TCSETFIELD(cTab,"RH3_DTSOLI","D")

DBSELECTAREA("RH4")
RH4->(DBSETORDER(1))

(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	
	DBSEEK(XFILIAL("RH4")+(cTab)->RH3_CODIGO)
	WHILE RH4->(!EOF()) .AND. RH4->(RH4_FILIAL+RH4_CODIGO)==XFILIAL("RH4")+(cTab)->RH3_CODIGO
		IF TRIM(RH4->RH4_CAMPO)=="RF0_HORINI"
			cHoraIni:= STRTRAN(RH4->RH4_VALNOV,".",":")
		ELSEIF TRIM(RH4->RH4_CAMPO)=="RF0_HORFIM"	
			cHoraFim:= STRTRAN(RH4->RH4_VALNOV,".",":")
		ELSEIF TRIM(RH4->RH4_CAMPO)=="TMP_ABOND"
			cAbono := RH4->RH4_VALNOV		
		ELSEIF TRIM(RH4->RH4_CAMPO)=="RF0_DTPREI"
			dIniAbo := CTOD(TRIM(RH4->RH4_VALNOV))
		ELSEIF TRIM(RH4->RH4_CAMPO)=="RF0_DTPREF"
			dFimAbo := CTOD(TRIM(RH4->RH4_VALNOV))			
		ENDIF	
	RH4->(dbskip())
	END
	
	IF TYPE("dIniAbo") == "D" .AND. TYPE("dFimAbo") == "D"
		IF dIniAbo >= dPerIni .AND. dFimAbo <= dPerFim	
			nTotDias	:= DateDiffDay(dIniAbo,dFimAbo)+1
			dRefAbo	:= dIniAbo
			FOR nCnt:= 1 TO nTotDias
				AADD(aLancRH3,{dRefAbo,(cTab)->RH3_STATUS,cAbono,cHoraIni,cHoraFim})
				dRefAbo:= dRefAbo + 1
			NEXT nCnt
		ENDIF

		IF dPerFim < dIniAbo
			EXIT
		ENDIF				
	ENDIF
	

//		RH4->(DBGOTOP())
//		DBSEEK(XFILIAL("RH4")+(cTab)->RH3_CODIGO)
//		WHILE RH4->(!EOF()) .AND. RH4->(RH4_FILIAL+RH4_CODIGO)==XFILIAL("RH4")+(cTab)->RH3_CODIGO
//			IF TRIM(RH4->RH4_CAMPO)=="RF0_HORINI"
//				cHoraIni:= STRTRAN(RH4->RH4_VALNOV,".",":")
//			ELSEIF TRIM(RH4->RH4_CAMPO)=="RF0_HORFIM"	
//				cHoraFim:= STRTRAN(RH4->RH4_VALNOV,".",":")
//			ELSEIF TRIM(RH4->RH4_CAMPO)=="TMP_ABOND"
//				cAbono := RH4->RH4_VALNOV	
//			ENDIF	
//		RH4->(dbskip())
//		END
//		AADD(aLancRH3,{(cTab)->RH3_DTSOLI,(cTab)->RH3_STATUS,cAbono,cHoraIni,cHoraFim})
	
(cTab)->(dbskip()) 	
END
(cTab)->(dbCloseArea()) 	

RESTAREA(aArea)
Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02SAL
Retorna o saldo em banco de horas do funcionario no periodo
@author  	Carlos Henrique
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P16R02SAL(nTipo,nSaldoAnt,cFilSra,cMatric,cPerAponta,nHoras,nTpEvento,aDtaBxaBH)
LOCAL aArea		:= GETAREA()
Local nSaldo  	:= 0
Local aDet     	:= {}
Local dDtIni		:= Stod( Subst( cPerAponta , 1 , 8 ) )
Local dDtFim		:= Stod( Subst( cPerAponta , 9 , 8 ) )
Local aQuad		:= P16R02QUAD(dDtIni,dDtFim)
Local dUltDtSPI	:= CTOD("")
Local aCodEve  	:= {}
Local nCntEve  	:= 0
Local lStSPC  	:= .T.
Local lOK  		:= .F.
Local nY  			:= 0
Local nHrsBxa		:= 0
Local nSldAux		:= 0
LOCAL dDMenos1	:= DATE() -1
DEFAULT aDtaBxaBH	:= {}

IF (nTipo == 4 .OR. nTipo == 3) .AND. !EMPTY(aQuad)
	dDtIni	:= aQuad[1][1]
	dDtFim	:= aQuad[LEN(aQuad)][2]
ENDIF

//IF nTipo == 3
//	GetPonMesDat(@dDtIni,@dDtFim,"__cLastFil__")
//ENDIF

// 1 - Data
// 2 - Codigo do Evento
// 3 - Descricao do Evento
// 4 - Quantidade de Horas Debito
// 5 - Quantidade de Horas Credito
// 6 - Saldo
// 7 - Status

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica lancamentos no Banco de Horas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SPI" )
dbSetOrder(2)
dbSeek( cFilSra + cMatric)
While SPI->(!Eof()) .And. SPI->(PI_FILIAL+PI_MAT) == cFilSra+cMatric
  	dUltDtSPI:= SPI->PI_DATA
  	
  	IF ASCAN(aDtaBxaBH,{|x| x[1]==SPI->PI_DTBAIX }) == 0
  		AADD(aDtaBxaBH,{SPI->PI_DTBAIX,0})
  	ENDIF
  		
  	// Totaliza Saldo Anterior
	If SPI->PI_STATUS == " " .And. SPI->PI_DATA < dDtIni
		If PosSP9( SPI->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" 
			If nHoras==1	// Horas Normais
				nSaldoAnt:=SomaHoras(nSaldoAnt,SPI->PI_QUANT)
			Else
				nSaldoAnt:=SomaHoras(nSaldoAnt,SPI->PI_QUANTV)
			Endif
	 	Else
			If nHoras==1
				nSaldoAnt:=SubHoras(nSaldoAnt,SPI->PI_QUANT)
			Else
				nSaldoAnt:=SubHoras(nSaldoAnt,SPI->PI_QUANTV)
			Endif
	 	Endif
	nSaldo := nSaldoAnt
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica os Lancamentos a imprimir                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim
		dbSkip()
		Loop
	Endif
	
	//-- Verifica tipo de Evento quando for diferente de Ambos
	If nTpEvento <> 3
		If !fBscEven(SPI->PI_PD,2,nTpEvento)
			SPI->(dbSkip())
			Loop
		EndIf
	Else
		PosSP9( SPI->PI_PD ,SRA->RA_FILIAL )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumula os lancamentos de Proventos/Desconto em Array        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SP9->P9_TIPOCOD $ "1*3"
		IF (nTipo == 4 .or. nTipo == 3)
			nSaldo:=SomaHoras(nSaldo,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		ELSE
			nSaldo:=SomaHoras(nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		ENDIF	
	Else
		IF (nTipo == 4 .or. nTipo == 3)
			nSaldo:=SubHoras (nSaldo,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		ELSE
			nSaldo:=SubHoras (nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		ENDIF	
	Endif
		
	aAdd(aDet,{SPI->PI_DATA,;
				SPI->PI_PD,;
				  DescPdPon(SPI->PI_PD,SPI->PI_FILIAL),;
				  If(SP9->P9_TIPOCOD $ "1*3",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)),;
				  If(SP9->P9_TIPOCOD $ "1*3",If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV),0),;
				  nSaldo,;
				  IF(SPI->PI_STATUS=="B","Baixado","Pendente"),; 
				  0})
				  
	nY:= LEN(aDet)
				  
	IF SPI->PI_STATUS=="B"	
		IF aDet[nY][4] > 0
			nHrsBxa:= SubHoras(nHrsBxa,aDet[nY][4])					
		Endif

		IF aDet[nY][5] > 0
			nHrsBxa:= SomaHoras(nHrsBxa,aDet[nY][5])				
		Endif
	Endif

	IF aDet[nY][4] > 0
		nSldAux:= SubHoras(nSldAux,aDet[nY][4])					
	Endif

	IF aDet[nY][5] > 0
		nSldAux:= SomaHoras(nSldAux,aDet[nY][5])				
	Endif
	
	IF ASCAN(aDtaBxaBH,{|x| x[1]==SPI->PI_DATA }) > 0
		IF nHrsBxa < 0
			aDet[nY][8]:= nHrsBxa 
		ELSEIF nHrsBxa > 0
			aDet[nY][8]:= nHrsBxa 
		ENDIF		
	ENDIF 				  
				  
dbSelectArea( "SPI" )
SPI->( dbSkip() )
Enddo

// Para tipo 1 considera apenas lançamento em banco de horas
IF nTipo == 1
	nSaldoAnt:= nSaldo
ELSE //IF dUltDtSPI >= dDtIni .AND. dUltDtSPI <= dDtFim
	
	//Verifica lancamentos no ponto que vai para Banco de Horas
	SPC->(dbsetorder(2))
	SPC->(dbSeek( cFilSra + cMatric + dtos(dUltDtSPI),.t. )) 
	While SPC->(!Eof()) .And. SPC->(PC_FILIAL+PC_MAT) == cFilSra+cMatric
		
		// Calcula apenas para datas que não foram para banco de horas
		If SPC->PC_DATA <= dUltDtSPI
			SPC->(dbSkip())
			Loop
		Endif 
	  	
	  	aCodEve := {}
	  	IF EMPTY(SPC->PC_PDI)
		  	IF !EMPTY(SPC->PC_ABONO)
		  		AADD(aCodEve,{SPC->PC_PD,SomaHoras(SPC->PC_QUANTC,SPC->PC_QTABONO*-1)})
		  	ELSE
		  		AADD(aCodEve,{SPC->PC_PD,SomaHoras(SPC->PC_QUANTC,SPC->PC_QUANTI*-1)})
		  	ENDIF	  	
	  	ELSE
	  		AADD(aCodEve,{SPC->PC_PD,SomaHoras(SPC->PC_QUANTC,SPC->PC_QUANTI*-1)})
	  		IF SPC->PC_QUANTI > 0
	  			AADD(aCodEve,{SPC->PC_PDI,SPC->PC_QUANTI})
	  		ENDIF		  		
	  	ENDIF
	  	
	  	FOR nCntEve:= 1 TO LEN(aCodEve)

		  	lStSPC	:= .F.
			
			PosSP9( aCodEve[nCntEve][1] ,SRA->RA_FILIAL )
			
			If SP9->P9_CLASEV == "01" .AND. SP9->P9_BHORAS=="S" //Hora Extra
				lStSPC	:= .T.
			ElseIf SP9->P9_CLASEV $ "02*03*04*05" .AND. SP9->P9_BHORAS=="S" //Faltas/Atrasos/Saida antecipada	
				lStSPC	:= .T.
			ElseIf SP9->P9_IDPON $ "003N*004A*027N*028A" .AND. SP9->P9_BHORAS=="S" //Adicional Noturno
				lStSPC	:= .T.  	
		  	ENDIF
		  	
		  	// Totaliza Saldo Anterior
			If lStSPC .And. SPC->PC_DATA < dDtIni
				nPercVal := if(SP9->P9_BHPERC==0.or.SP9->P9_BHPERC==100,100,SP9->P9_BHPERC) / 100
				nPropBH  := SP9->P9_PBH / 100
//				nHorasBH := aCodEve[nCntEve][2] * nPercVal * nPropBH
				nHorasBH := fConvHr(aCodEve[nCntEve][2],"D") * nPercVal * nPropBH
				nHorasBH := fConvHr(nHorasBH,"H")
				If SP9->P9_TIPOCOD $ "1*3" 
					nSaldoAnt:=SomaHoras(nSaldoAnt,nHorasBH)
			 	Else
					nSaldoAnt:=SubHoras(nSaldoAnt,nHorasBH)
			 	Endif
			nSaldo := nSaldoAnt
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica os Lancamentos a imprimir                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	!lStSPC .or. SPC->PC_DATA < dDtIni .Or. SPC->PC_DATA > dDtFim
				//SPC->(dbSkip())
				exit //Loop
			Endif
			
			//-- Verifica tipo de Evento quando for diferente de Ambos
			If nTpEvento <> 3
				If !fBscEven(aCodEve[nCntEve][1],2,nTpEvento)
					//SPC->(dbSkip())
					exit //Loop
				EndIf
			Else
				PosSP9( aCodEve[nCntEve][1] ,SRA->RA_FILIAL )
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula os lancamentos de Proventos/Desconto em Array        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPercVal := if(SP9->P9_BHPERC==0.or.SP9->P9_BHPERC==100,100,SP9->P9_BHPERC) / 100
			nPropBH  := SP9->P9_PBH / 100
			nHorasBH := fConvHr(aCodEve[nCntEve][2],"D") * nPercVal * nPropBH
			nHorasBH := fConvHr(nHorasBH,"H")
		
			If SP9->P9_TIPOCOD $ "1*3"
				nSaldo:= SomaHoras(nSaldo,nHorasBH)
			Else
				nSaldo:= SubHoras (nSaldo,nHorasBH)
			Endif
		
			aAdd(aDet,{SPC->PC_DATA,;
						aCodEve[nCntEve][1],;
						  DescPdPon(aCodEve[nCntEve][1],SPC->PC_FILIAL),;
						  If(SP9->P9_TIPOCOD $ "1*3",0,nHorasBH),;
						  If(SP9->P9_TIPOCOD $ "1*3",nHorasBH,0),;
						  nSaldo,;
						  "Pendente" })
		NEXT aCodEve		
			  
	SPC->( dbSkip() )
	Enddo
ENDIF

/*
IF nTipo == 3 .AND. DATE()==dDtFim
	nSaldoAnt:= SomaHoras(nSaldo,P16R02BXA(2,cFilSra,cMatric,dDtFim,2,CTOD(""))) //nSaldo - P16R02BXA(2,cFilSra,cMatric,dDtFim,2,CTOD(""))
ELSEIF nTipo == 3 
	nSaldoAnt:= SomaHoras(nSaldo,P16R02BXA(2,cFilSra,cMatric,dDtFim,2,CTOD(""))) //nSaldo + P16R02BXA(2,cFilSra,cMatric,dDtFim,2,CTOD(""))	
ENDIF
*/

IF nTipo == 3
	nSaldoAnt:= 0
	FOR nY:=1 TO LEN(aDet)
		IF aDet[nY][1] <= dDMenos1				
			IF aDet[nY][1] <= dDtFim	
				IF aDet[nY][4] > 0
					nSaldoAnt:= SubHoras(nSaldoAnt,aDet[nY][4])					
				Endif

				IF aDet[nY][5] > 0
					nSaldoAnt:= SomaHoras(nSaldoAnt,aDet[nY][5])				
				Endif
			ENDIF									
		Endif	
	NEXT nY
ENDIF

RESTAREA(aArea)
Return(aDet)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02PIC
Realiza a formatação do valor
@author  	Carlos Henrique
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P16R02PIC(nValor)
Local cPict	:= PESQPICT("SPI","PI_QUANT")
Local cRet		:= StrTran(Transform(nValor,cPict),",",":")

cRet:= ALLTRIM(cRet)

RETURN cRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02BXA
Retorna o valor de banco de horas baixado no periodo
@author  	Carlos Henrique
@since     	30/08/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static function P16R02BXA(nTipo,cFilSra,cMatric,dDatRef,nHoras,dDtIniPer)
LOCAL aArea		:= GETAREA()
LOCAL cTab			:= GetNextAlias()
LOCAL nRet			:= 0
LOCAL cPeriodo	:= MESANO(dDatRef)

IF nTipo == 1

	BeginSql Alias cTab
		SELECT P9_TIPOCOD,PI_QUANT,PI_QUANTV FROM %TABLE:SPI% SPI
		INNER JOIN %TABLE:SP9% SP9 ON P9_FILIAL=%xfilial:SP9%
			AND P9_CODIGO=PI_PD
			AND SP9.D_E_L_E_T_='' 
		WHERE PI_FILIAL=%exp:cFilSra% 
			AND PI_MAT=%exp:cMatric% 
			AND PI_DATA BETWEEN %exp:dDtIniPer% AND %exp:dDatRef%
			AND PI_STATUS='B'
			AND SPI.D_E_L_E_T_=''
	EndSql
	
ELSEIF nTipo == 2

	BeginSql Alias cTab
		SELECT P9_TIPOCOD,PI_QUANT,PI_QUANTV FROM %TABLE:SPI% SPI
		INNER JOIN %TABLE:SP9% SP9 ON P9_FILIAL=%xfilial:SP9%
			AND P9_CODIGO=PI_PD
			AND SP9.D_E_L_E_T_='' 
		WHERE PI_FILIAL=%exp:cFilSra% 
			AND PI_MAT=%exp:cMatric% 
			AND LEFT(PI_DTBAIX,6)=%exp:cPeriodo%
			AND PI_STATUS='B'
			AND SPI.D_E_L_E_T_=''
	EndSql
	
ELSEIF nTipo == 3

	BeginSql Alias cTab
		SELECT P9_TIPOCOD,PI_QUANT,PI_QUANTV FROM %TABLE:SPI% SPI
		INNER JOIN %TABLE:SP9% SP9 ON P9_FILIAL=%xfilial:SP9%
			AND P9_CODIGO=PI_PD
			AND SP9.D_E_L_E_T_='' 
		WHERE PI_FILIAL=%exp:cFilSra% 
			AND PI_MAT=%exp:cMatric% 
			AND PI_DATA BETWEEN %exp:dDtIniPer% AND %exp:dDatRef%
			AND SPI.D_E_L_E_T_=''
	EndSql	
	
ENDIF

//GETLastQuery()[2]

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())  
WHILE !(cTab)->(Eof())
	IF (cTab)->P9_TIPOCOD$"1*3"
		If nHoras==1	// Horas Normais
			nRet:=SomaHoras(nRet,(cTab)->PI_QUANT)
		Else
			nRet:=SomaHoras(nRet,(cTab)->PI_QUANTV)
		Endif	
	ELSE
		If nHoras==1
			nRet:=SubHoras(nRet,(cTab)->PI_QUANT)
		Else
			nRet:=SubHoras(nRet,(cTab)->PI_QUANTV)
		Endif
	ENDIF	 
(cTab)->(dbskip())
END
(cTab)->(dbCloseArea())

RESTAREA(aArea)	
return nRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02PER
Monta periodo para consulta
@author  	Carlos Henrique
@since     	15/05/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P16R02PER( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )
LOCAL nAnoIni:= Year(dDataIni)
LOCAL nAnoFim:= Year(dDataFim)
LOCAL dAuxIni	:= dDataIni
LOCAL dAuxFim	:= dDataFim
LOCAL nMesIni := 0
LOCAL nMesFim := 0
Local nCnta	:= 0
Local nCntb	:= 0
Local aRetPer	:= {}
Local cPAPONTA:= TRIM(STRTRAN(SuperGetMV("MV_PAPONTA",,""),"/",""))
local cDiaIni	:= LEFT(cPAPONTA,2)
local cDiaFim	:= RIGHT(cPAPONTA,2)

FOR nCnta:= nAnoIni TO nAnoFim
	
	IF nCnta == nAnoIni
		nMesIni := Month(dDataIni)	  
	ELSE
		nMesIni := 1			
	ENDIF
	
	IF nCnta == nAnoFim 
		nMesFim := Month(dDataFim)
	ELSE
		nMesFim := 12 	
	ENDIF	
	
	FOR nCntb:= nMesIni TO nMesFim	
		dAuxIni:= CTOD(cDiaIni+'/'+ STRZERO(nCntb,2) +'/'+ CVALTOCHAR(nCnta))
		
		IF nCntb==12
			dAuxFim:= CTOD(cDiaFim+'/01/'+ CVALTOCHAR(nCnta+1))		
		ELSE
			dAuxFim:= CTOD(cDiaFim+'/'+ STRZERO(nCntb+1,2) +'/'+ CVALTOCHAR(nCnta))
		ENDIF		
			
		IF dAuxIni >= dDataIni .and. dAuxFim <= dDataFim				
			aAdd(aRetPer,{dAuxIni,; 
			 				dAuxFim,; 
			 				dAuxIni,; 
			 				dAuxFim})			
		ENDIF			   
	NEXT nCntb
	
NEXT nCnta	

Return aRetPer 
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R02QUAD
Monta os quadrimestres
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P16R02QUAD(dDataIni,dDataFim)
LOCAL nAnoIni:= Year(dDataIni)
LOCAL nAnoFim:= Year(dDataFim)
LOCAL nMesIni := 0
LOCAL nMesFim := 0
Local nCnta	:= 0
Local nCntb	:= 0
Local lQuad1	:= .T.
Local lQuad2	:= .T.
Local lQuad3	:= .T.
Local aRetQuad:= {}
Local cPAPONTA:= TRIM(STRTRAN(SuperGetMV("MV_PAPONTA",,""),"/",""))
local cDiaIni	:= LEFT(cPAPONTA,2)
local cDiaFim	:= RIGHT(cPAPONTA,2)

FOR nCnta:= nAnoIni TO nAnoFim

	lQuad1	:= .T.
	lQuad2	:= .T.
	lQuad3	:= .T.
	
	IF nCnta == nAnoIni
		nMesIni := Month(dDataIni)	  
	ELSE
		nMesIni := 1			
	ENDIF
	
	IF nCnta == nAnoFim 
		nMesFim := Month(dDataFim)
	ELSE
		nMesFim := 12 	
	ENDIF	
	
	FOR nCntb:= nMesIni TO nMesFim	
		IF lQuad1 .AND. (nCntb >= 1 .AND. nCntb <= 4) .and.; 
			dDataIni>= CTOD(cDiaIni+'/12/'+ CVALTOCHAR(nCnta-1)) .and.; 
				dDataFim <= CTOD(cDiaFim+'/04/'+ CVALTOCHAR(nCnta))			
				aAdd(aRetQuad,{ CTOD(cDiaIni+'/12/'+ CVALTOCHAR(nCnta-1)),; 
				 				   CTOD(cDiaFim+'/04/'+ CVALTOCHAR(nCnta))} )		 				   				  								  	
			lQuad1:= .F.							  		
		ELSEIF lQuad2 .AND.  (nCntb >= 5 .AND. nCntb <= 8) .and.; 
			dDataIni>= CTOD(cDiaIni+'/04/'+ CVALTOCHAR(nCnta)) .and.; 
				dDataFim <= CTOD(cDiaFim+'/08/'+ CVALTOCHAR(nCnta))
				aAdd(aRetQuad,{ CTOD(cDiaIni+'/04/'+ CVALTOCHAR(nCnta)),; 
				 				   CTOD(cDiaFim+'/08/'+ CVALTOCHAR(nCnta))})
			lQuad2:= .F.							  	
		ELSEIF lQuad3 .AND.  (nCntb >= 9 .AND. nCntb <= 12) .and.; 
			dDataIni>= CTOD(cDiaIni+'/08/'+ CVALTOCHAR(nCnta)) .and.; 
				dDataFim <= CTOD(cDiaFim+'/12/'+ CVALTOCHAR(nCnta))
				aAdd(aRetQuad,{ CTOD(cDiaIni+'/08/'+ CVALTOCHAR(nCnta)),; 
				 				   CTOD(cDiaFim+'/12/'+ CVALTOCHAR(nCnta))})
			lQuad3:= .F.				  	
		ENDIF
	NEXT nCntb
NEXT nCnta	

Return aRetQuad 