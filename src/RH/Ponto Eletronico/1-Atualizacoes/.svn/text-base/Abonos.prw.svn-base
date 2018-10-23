#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fVldAbono	  ºAutor  ³Artuso         º Data ³  18/04/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se quantidade de horas de abono de um respectivo  º±±
±±º          ³ evento esta dentro da quantidade maxima permitida, confor- º±±
±±º          ³ me ACT - Cláusula 37                       				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION fVldAbono(cAlias)

	Local cAliasSP6		:= "SP6"
	Local cAliasSRA		:= "SRA"
	Local cAliasSPC		:= "SPC"
	Local cAliasTMP		:= GetNextAlias()
	Local nHorasAbo		:= 0
	Local lRet			:= .F.	
	Local nQtdeMax		:= 0
	Local nX			:= 0
	Local nLenAcols		:= 0
	Local nPosCodAbo	:= 0
	Local lContinua		:= .F.
	Local nHorasAcum	:= 0
	Local nPosQtAbono	:= 0
	Local cAliasApo		:= ""
	Local nAboTmp		:= 0
	Local nRet			:= 0	
	
	DEFAULT cAlias	:= ""
	
	lContinua	:= fValidCpos()
	
	If ( lContinua )
	
		//AjustaSX3()
		
		fAvalProc() // Avalia se o processo foi concluido. Maiores detalhes na rotina.
	
		cAliasApo	:= fCriaArqTmp()
		
		nQtdeMax	:= (cAliasSP6)->P6_XQTDEHR
		
		If (nQtdeMax > 0)	

			If ( !Empty( cAlias ) )	
			
				fGravaTMP(cAliasApo , "SPK")
				
				nHorasAbo	:= __TimeSum(nHorasAbo , nRet	:= fSomaAcum("SPK") )
				
			Else
			
				fGravaTMP(cAliasApo , "SPC")
			
				nHorasAbo	:= __TimeSum(nHorasAbo , nRet	:= fSomaAcum("SPC"))
			
			EndIf	
			
			nHorasAbo	:= __TimeSum(nHorasAbo , nRet	:= fSomaSPC())

			If ( !Empty(cAlias) )
			
				nHorasAbo	:= __TimeSum(nHorasAbo , nRet	:= fSomaTMP(cAliasApo , "SPK"))
				
			Else
			
				nHorasAbo	:= __TimeSum(nHorasAbo , nRet	:= fSomaTMP(cAliasApo , "SPC" ))

			EndIf
			
			/*If ( !Empty(cAlias) )

				nHorasAbo	:= __TimeSum(nHorasAbo , M->PK_HRSABO)
			
			EndIf*/
		
			If ( nHorasAbo > nQtdeMax )
			
				fDelLastApo(cAliasAPO)

				MsgAlert('De acordo com a clausula 37, a quantidade maxima de horas de abono para este evento é: ' + AllTrim(Str(nQtdeMax)) + ;
					" E a soma de horas para este evento é : " + AllTrim(Str(nHorasAbo)))
					
				If ( !Empty(cAlias) )
					
					aCols[n , GdFieldPos('PK_CODABO')]	:= 0
				
				Else
				
					aCols[n , GdFieldPos('PC_QTABONO')]	:= 0
				
				EndIf

			Else
			
				lRet	:= .T.
				
			EndIf

		Else
		
			lRet	:= .T.
		
		EndIf

	Else
	
		lRet	:= .T.
	
	EndIf
	
	(cAliasApo)->(dbCloseArea())

RETURN lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fZeraHora	  ºAutor  ³Artuso         º Data ³  18/04/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina chamada atraves do campo PK_CODABO. Zera o aCols queº±±
±±º          ³ armazena a quantidade de horas, de modo a 'forçar' o usua- º±±
±±º          ³ rio a digitar tal quantidade, para que a rotina 'fVldAbono'º±±
±±º          ³ faca tal validacao, de acordo com a clausula 37 da CCT.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fZeraHora()

	Local cAliasSPK	:= "SPK"
	Local cAliasSP6	:= "SP6"
	
	If ( !Empty((cAliasSP6)->P6_XPERIOD ) )
	
		If ( RecLock(cAliasSPK , .F.) )
		
			aCols[1 , 4]	:= 0
		
			(cAliasSPK)->(PK_HRSABO)	:= 0
			
			(cAliasSPK)->(MsUnlock())
		
		EndIf	
	
	EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fValidCpos	  ºAutor  ³Artuso         º Data ³  02/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se os campos P6_XPERIOD e P6_XQTDEHR existem.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValidCpos()

	Local lRet			:= .T.
	Local cAliasSP6		:= "" 
	
	cAliasSP6	:= "SP6"

	If ( (cAliasSP6)->(FieldPos('P6_XPERIOD') == 0) )
	
		MsgAlert("O campo 'Periodo' nao existe no cadastro de motivo de abonos.")
		lRet	:= .F.
	
	EndIf

	If ( (cAliasSP6)->(FieldPos('P6_XQTDEHR') == 0 ) )
	
		MsgAlert("O campo 'Qtde. de Horas' nao existe no cadastro de motivo de abonos.")
		lRet	:= .F.
	
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fSomaAcum	  ºAutor  ³Artuso         º Data ³  03/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Totaliza o saldo de abonos da tabela de acumulados (SPH).  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSomaAcum(cAlias)

	Local nHoras		:= 0
	Local cWhere		:= ""	
	Local cQuery		:= ""
	Local cFields		:= ""
	Local cFrom			:= ""
	Local cAliasTMP		:= ""
	Local cAliasSRA		:= ""
	Local cFilSRA		:= ""
	Local cMatSRA		:= ""
	Local cAliasSP6		:= ""
	Local dIniPesq		:= cToD('')	
	Local cAliasSPC		:= ""
	Local cCodAbo		:= ""
	Local cChaveSP6		:= ""	
	Local aAreaSP6		:= {}
	Local cChar			:= ""
	
	cAliasSP6	:= "SP6"
	cAliasSPC	:= "SPC"
	cAliasSRA	:= "SRA"
	cAliasTMP	:= GetNextAlias()

	cFilSRA		:= (cAliasSRA)->(RA_FILIAL)
	cMatSRA		:= (cAliasSRA)->(RA_MAT)
	cChar		:= "'"
	
	If ( cAlias == 'SPC' )
		
		cCodAbo		:= AllTrim(M->PC_ABONO)
		
	Else
	
		cCodAbo		:= AllTrim(GDFIELDGET('PK_CODABO'))
	
	EndIf
	
	cChaveSP6	:= xFilial("SP6" , (cAliasSRA)->RA_FILIAL) + cCodAbo
	
	aAreaSP6	:= (cAliasSP6)->(GetArea())
	
	If ( (cAliasSP6)->(dbSeek(cChaveSP6)) )
		
		If ( (cAliasSP6)->P6_XPERIOD == "A" )
			
			dIniPesq	:= FirstYDate(dDataBase)
		
		Else
		
			dIniPesq	:= (dDataBase - 365)
		
		EndIf
		
		RestArea(aAreaSP6)

		cQuery	:= "SELECT "
		
		cFields	:= "PH_QTABONO "
		
		cFrom	:= "FROM " + RetSqlName("SPH") + " SPH "
		
		cWhere	:= "WHERE " + 	"SPH.PH_FILIAL = "	+ cChar + cFilSRA + cChar + " AND "
		cWhere	+= 				"SPH.PH_MAT = " 	+ cChar + cMatSRA + cChar + " AND "		
		cWhere	+= 				"SPH.PH_ABONO = " 	+ cChar + cCodAbo + cChar + " AND "		
		cWhere	+= 				"SPH.PH_DATA >= "	+ cChar + dToS(dIniPesq) + cChar + " AND "
		cWhere	+= 				"SPH.D_E_L_E_T_ = "	+ " '  ' "
		
		cQuery	+= cFields + cFrom + cWhere
		
		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)
		
		If ( (cAliasTMP)->(!EOF()) )
		
			Do While (cAliasTMP)->(!EOF())
			
				nHoras	:= __TimeSum(nHoras , (cAliasTMP)->PH_QTABONO)
				(cAliasTMP)->(dbSkip())
			
			EndDo
		
		EndIf
	
	EndIf
	
	(cAliasTMP)->(dbCloseArea())

Return nHoras


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fCriaArqTmp  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria o arquivo temporario que sera utilizado para armaze-  º±±
±±º          ³ nar os valores informados nos abonos. Esta saida sera uti- º±±
±±º          ³ lizada,pois nao ha como recuperar os valores do acols quan-º±±
±±º          ³ do o abono e' informado atraves do 'F4'.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaArqTmp()
	
	Local aStru		:= {}
	Local cAliasAPO	:= ""
	
	cAliasAPO	:= "APOSPC"
	
	dbUseArea(.T. , "TOPCONN" , "APOSPC" , "APOSPC" , .F. , .F.)
	
	If ( Select("APOSPC") == 0 )
	
		AADD(aStru , {"DATAAPO"	, "D" , 3 , 0})
		AADD(aStru , {"EVENTO" 	, "C" , 8 , 0})
		AADD(aStru , {"HORAS" 	, "N" , 5 , 2})
		
		dbCreate(cAliasAPO , aStru , "TOPCONN" )
		
		dbUseArea(.T. , "TOPCONN" , "APOSPC" , "APOSPC" , .F. , .F.)
	
	Endif
	
Return cAliasAPO

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PNA130GRV	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O P.E. sera utilizado para eliminar o arquivo temporario   º±±
±±º          ³ criado. Como nao ha nenhum tratamento efetuado nos aponta- º±±
±±º          ³ mentos, devera sempre retornar .T. para nao interferir no  º±±
±±º          ³ processo de gravacao dos apontamentos.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PNA130GRV

	Local cAliasAPO	:= ""
	Local cArquivo	:= ""
	
	cArquivo	:= "ABOPROC"
	
	cAliasAPO	:= "APOSPC"
	
	If ( Select("APOSPC") > 0 )
	
		(cAliasAPO)->(dbCloseArea())
		
		TcSqlExec("DROP TABLE APOSPC")
		
	Else
	
		TcSqlExec("DROP TABLE APOSPC")

	EndIf
	
	dbUseArea(.T. , "TOPCONN" , cArquivo , cArquivo , .F. , .F.)
	
	If ( RecLock(cArquivo , .F.) )
	
		(cArquivo)->FINALIZADO	:= "S"
		
		(cArquivo)->(MsUnlock())
	
	EndIf
	
	(cArquivo)->(dbCloseArea())

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fSomaTMP	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma as horas informadas que ainda nao foram gravadas na   º±±
±±º          ³ tabela de apontamentos (SPC).							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSomaTMP(cAliasAPO , cAlias)

	Local nTotAbono	:= 0
	Local cAliasSPC	:= ""
	Local aAreaSPC	:= {}
	Local cChaveSPC	:= ""
	Local cAliasSRA	:= ""
	Local cCodAbo	:= ""
	Local lSoma		:= .T.
	
	cAliasSPC	:= "SPC"
	
	cAliasSRA	:= "SRA"
	
	aAreaSPC	:= (cAliasSPC)->(GetArea())	
	
	(cAliasAPO)->(dbGoTop())
	
	(cAliasSPC)->(dbSetOrder(2))

	Do While (cAliasAPO)->(!EOF())
		
		cCodAbo		:= (cAliasAPO)->EVENTO
		
		cChaveSPC	:= xFilial('SPC') + (cAliasSRA)->RA_MAT + dToS((cAliasAPO)->DATAAPO)
		
		If ( (cAliasSPC)->(dbSeek(cChaveSPC)))
		
			Do While ( (lSoma) .AND. ((cAliasSPC)->(!EOF())) .AND. (cChaveSPC == (cAliasSPC)->(PC_FILIAL + PC_MAT + dToS(PC_DATA))))
			
				If ( AllTrim((cAliasSPC)->PC_ABONO) == AllTrim(cCodAbo) )
				
					lSoma	:= .F.
				
				EndIf
			
				(cAliasSPC)->(dbSkip())

			Enddo
		
		EndIf			
	
		If ( lSoma )
		
			nTotAbono	:= __TimeSum(nTotAbono , (cAliasAPO)->HORAS)
			
		Else
		
			lSoma	:= .T.
		
		EndIf
		
		(cAliasAPO)->(dbSkip())
	
	EndDo
	
	RestArea(aAreaSPC)

Return nTotAbono


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fSomaSPC	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Totaliza os apontamentos gravados nos acumulados de aponta-º±±
±±º          ³ mento.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSomaSPC()

	Local cQuery		:= ""
	Local cFields		:= ""
	Local cFrom			:= ""
	Local cWhere		:= ""
	Local cFilSRA		:= ""
	Local cMatSRA		:= ""
	Local cCodAbo		:= ""
	Local dIniPesq		:= cToD('')
	Local nHorasAbo		:= 0
	Local cAliasSP6		:= "SP6"
	Local cAliasSRA		:= "SRA"
	Local cAliasTMP		:= ""
	
	cFilSRA		:= (cAliasSRA)->RA_FILIAL
	cMatSRA		:= (cAliasSRA)->RA_MAT
	cCodAbo		:= AllTrim((cAliasSP6)->P6_CODIGO)
	cAliasTMP	:= GetNextAlias()
	
	If ( (cAliasSP6)->P6_XPERIOD == "A" )
		
		dIniPesq	:= FirstYDate(dDataBase)
	
	Else
	
		dIniPesq	:= (dDataBase - 365)
	
	EndIf

	cQuery	:= "SELECT "

	cFields	:= "SPC.PC_FILIAL , SPC.PC_MAT , SPC.PC_DATA , SPC.PC_ABONO , SPC.PC_QTABONO "
	
	cFrom	:= "FROM " + RetSqlName("SPC") + " SPC "
	
	cWhere	:= "WHERE "
	
	cWhere	+= "SPC.PC_FILIAL = '"+cFilSRA+"' AND "
	cWhere	+= "SPC.PC_MAT =  '"+cMatSRA+"' AND "
	cWhere	+= "SPC.PC_ABONO = '"+cCodAbo+"' AND "
	cWhere	+= "SPC.PC_DATA >= '"+dToS(dIniPesq)+"' AND "
	cWhere	+= "SPC.D_E_L_E_T_ = '' "
	
	cQuery	:= cQuery + cFields + cFrom + cWhere
	
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)	
	
	Do While ( ((cAliasTMP)->(!EOF())) .AND. (sToD((cAliasTMP)->PC_DATA) >= dIniPesq) )			
		
		nHorasAbo	:= __TimeSum(nHorasAbo , (cAliasTMP)->(PC_QTABONO) )

		(cAliasTMP)->(dbSkip())
	
	EndDo
	
	(cAliasTMP)->(dbCloseArea())
		
Return nHorasAbo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fGravaTMP	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava no arquivo temporario o abono cadastrado que nao foi º±±
±±º          ³ gravado na SPC. Maiores detalhes podem ser consultados na  º±±
±±º          ³ documentacao da rotina fCriaArqTmp.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGravaTMP(cAliasAPO , cAlias)

	Local cQuery	:= ""
	Local cAliasTMP	:= ""
	Local cCodAbo	:= ""
	
	cAliasTMP	:= GetNextAlias()
	
	If ( cAlias == 'SPC' )
		
		cCodAbo		:= AllTrim(M->PC_ABONO)
		
	Else
	
		cCodAbo		:= AllTrim(GDFIELDGET('PK_CODABO'))
	
	EndIf	
	
	cQuery	:= " SELECT HORAS FROM APOSPC WHERE "
	
	If ( cAlias == "SPC" )
	
		cCodAbo		:= AllTrim(M->PC_ABONO)
	
		cQuery	+= " DATAAPO = " + "'" + dToS(GdFieldGet('PC_DATA')) + "'" + " AND "	
		cQuery	+= " HORAS = "   + "'" + cCodAbo + "'" + " AND "
		cQuery	+= " EVENTO = " + "'" + AllTrim(M->PC_ABONO) + "'"		
	
	Else
	
		cCodAbo		:= AllTrim(GDFIELDGET('PK_CODABO'))
	
		cQuery	+= " DATAAPO = " + "'" + dToS(GdFieldGet('PK_DATA')) + "'" + " AND "	
		cQuery	+= " HORAS = "   + "'" + cCodAbo + "'"  + " AND "
		cQuery	+= " EVENTO = " + "'" + AllTrim(GDFIELDGET('PK_CODABO')) + "'"
	
	EndIf
	
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)

	If ( (cAliasTMP)->(EOF()) )
	
		RecLock(cAliasAPO , .T.)
		
	Else
	
		RecLock(cAliasAPO , .F.)
		
	EndIf	

	If ( cAlias  == "SPC")
		
		(cAliasAPO)->DATAAPO	:= GdFieldGet('PC_DATA')
		(cAliasAPO)->HORAS		:= GdFieldGet('PC_QTABONO')
		(cAliasAPO)->EVENTO		:= AllTrim(M->PC_ABONO)
	
	Else
	
		(cAliasAPO)->DATAAPO	:= GdFieldGet('PK_DATA')
		(cAliasAPO)->HORAS		:= M->PK_HRSABO
		(cAliasAPO)->EVENTO		:= AllTrim(GDFIELDGET('PK_CODABO'))
		
	EndIf
	
	(cAliasAPO)->(MsUnlock())
	
	(cAliasTMP)->(dbCloseArea())
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fZeraTMP	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Elimina os registros gravados na tabela temporaria (APOSPC)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fZeraTMP(cAliasAPO)

	TcSqlExec("DELETE FROM APOSPC")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  AjustaSX3	  ºAutor  ³Artuso         º Data ³  06/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua ajuste no dicionario para avaliacao das funcoes 	  º±±
±±ºDesc.     ³ de validacao de usuario.                               	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX3()

	Local aAreaSX3	:= {}
	Local cAliasSX3	:= ""
	Local lGrava	:= .F.
	
	cAliasSX3	:= "SX3"
	aAreaSX3	:= (cAliasSX3)->(GetArea())
	
	(cAliasSX3)->(dbSetOrder(2))
	
	If ( ((cAliasSX3)->(dbSeek("PC_ABONO"))) .AND. (AllTrim((cAliasSX3)->X3_VLDUSER) <> 'U_fVldAbono()') )
		
		lGrava	:= fTrava(cAliasSX3)
		
		If ( lGrava )
		
			(cAliasSX3)->(X3_VLDUSER)	:= 'U_fVldAbono()'
			
			(cAliasSX3)->(MsUnlock())
			
		Else
		
			cMsg	:= fGeraMsg('PC_ABONO')
			Alert(cMsg)
		
		EndIf
	
	EndIf
	
	If ( ((cAliasSX3)->(dbSeek("PK_CODABO"))) .AND. (AllTrim((cAliasSX3)->X3_VLDUSER) <> 'U_fZeraHora()') )
		
		lGrava	:= fTrava(cAliasSX3)
		
		If ( lGrava )
		
			(cAliasSX3)->(X3_VLDUSER)	:= 'U_fZeraHora()' 
			
			(cAliasSX3)->(MsUnlock())
		Else
		
			cMsg	:= fGeraMsg('PK_CODABO')
			Alert(cMsg)
		
		EndIf
	
	EndIf
	
	If ( ((cAliasSX3)->(dbSeek("PK_HRSABO"))) .AND. (AllTrim((cAliasSX3)->X3_VLDUSER) <> 'U_fVldAbono("SPK")') )
		
		lGrava	:= fTrava(cAliasSX3)
		
		If ( lGrava )
		
			(cAliasSX3)->(X3_VLDUSER)	:= 'U_fVldAbono("SPK")'
			
			(cAliasSX3)->(MsUnlock())
			
		Else
		
			cMsg	:= fGeraMsg('PK_HRSABO')
			Alert(cMsg)
		
		EndIf
	
	EndIf

	RestArea(aAreaSX3)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fTrava		  ºAutor  ³Artuso         º Data ³  07/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Avalia se o registro esta disponivel para atualizacao. 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTrava(cAlias , lFound)

	Local lRet		:= .F.
	DEFAULT lFound	:= .T.
	
	If ( RecLock(cAlias , !lFound) ) // Inverter a operacao, pois RecLock '.T.', insere registro, '.F.' substitui.
		
		lRet	:= .T.
	
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fGeraMsg	  ºAutor  ³Artuso         º Data ³  07/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                         	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGeraMsg(cCampo)

	Local cRet	:= ""
	
	cRet	:= 'Não foi possível atualizar o campo X3_VLDUSER do registro ' + cCampo + ". Certifique-se que o SX3 está disponível para atualização."

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fDelLastApo  ºAutor  ³Artuso         º Data ³  07/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apaga o ultimo valor inserido no abono, quando exceder a   º±±
±±ºDesc.     ³ quantidade de horas. Isto sera feito para que o usuario in-º±±
±±ºDesc.     ³ forme a quantidade restante de horas para complementar o toº±±
±±ºDesc.     ³ tal de horas do abono, sem sair da getdados.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fDelLastApo(cAlias)

	(cAlias)->(dbGoTo(LastRec()))
	
	If ( (RecLock(cAlias , .F.)) )
	
		(cAlias)->(dbDelete())
		
		(cAlias)->(MsUnlock())
	
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  fAvalProc    ºAutor  ³Artuso         º Data ³  07/06/16      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina ira avaliar o estado da ultima validacao. Moti-º±±
±±ºDesc.     ³ vo: Quando ha interrupcao no processo (manutencao de abono º±±
±±ºDesc.     ³ cancelada, por exemplo, os abonos permanecerao na tabela   º±±
±±ºDesc.     ³ temporaria (APOSPC), sendo que serao computados para o pro-º±±
±±ºDesc.     ³ ximo calculo, acarretando em totalizacao indevida das horas.±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAvalProc()

	Local cArqTMP	:= ""
	Local cArquivo	:= ""
	Local aStruTMP	:= {}
	
	cArqTMP		:= GetNextAlias()
	cArquivo	:= "ABOPROC"
	
	dbUseArea(.T. , "TOPCONN" , cArquivo , cArquivo , .F. , .F.)
	
	If ( Select(cArquivo) == 0 )
	
		AADD(aStruTMP , {"FINALIZADO" , "C" , 1 , 0} )
		
		dbCreate(cArquivo , aStruTMP , "TOPCONN")
		
		dbUseArea(.T. , "TOPCONN" , cArquivo , cArquivo , .F. , .F.)

		If ( RecLock(cArquivo , .T.) )
		
			(cArquivo)->FINALIZADO	:= "N"
			
			(cArquivo)->(MsUnlock())
		
		EndIf
		
	Else
	
		If ( (cArquivo)->FINALIZADO == "N" )
		
			TcSqlExec("DROP TABLE APOSPC")			

		Else

			If ( (cArquivo)->FINALIZADO == "S" )
				
				If ( RecLock(cArquivo , .F.) )
				
					(cArquivo)->FINALIZADO	:= "N"
					
					(cArquivo)->(MsUnlock())
				
				EndIf						
			
			EndIf
			
		EndIf
	
	EndIf
	
	(cArquivo)->(dbCloseArea())

Return