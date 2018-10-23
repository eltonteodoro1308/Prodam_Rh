#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ APD002   ³ Autor ³ Equipe RH             ³ Data ³ 30/03/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para reabrir etapa da avaliação                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ APD002( void )                                             ³±±
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
User Function APD002 
                   
Local cCadastro	:= "Reabrir Etapa da Avaliação"  
Local CPERG		:= "APD002"
Local aSay		:= {}
Local aButt		:= {}                  
Local nOpc		:= 0
Private CPERG2	:= "APD002B"

aAdd( aSay, "Este programa tem como finalidade permitir reabrir uma etapa da " )
aAdd( aSay, "avaliação, selecionando o participante e a etapa a reabrir. " )

aAdd( aButt, { 5,.T.,{|| Pergunte(cPerg,.T.)     }})
aAdd( aButt, { 1,.T.,{|| FechaBatch(),	nOpc := 1 }})
aAdd( aButt, { 2,.T.,{|| FechaBatch()            }})
  
APD002SX1(cPerg)
APD002SX1(cPerg2)

//Monta Tela Inicial
Pergunte(cPerg,.t.)
FormBatch(cCadastro, aSay, aButt )

If nOpc > 0
	Processa( {|| APD002RUN() }, "Processando..." )
Endif

RETURN        
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ APD002RUN  ºAutor  ³Totvs		       º Data ³19/06/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento                 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function APD002RUN() 
Local cCodnet 	:= ""
Local cTipoAv 	:= ""
Local cDesTip  	:= ""  
LOCAL cTaba 	:= GetNextAlias()
LOCAL cTabb 	:= ""
LOCAL cQrya	  	:= ""  
LOCAL cQryb	  	:= ""  
LOCAL lValida	:= .T.
LOCAL cCodAva	:= MV_PAR01
LOCAL cCodAdo	:= MV_PAR02
LOCAL cCodDor	:= ''
LOCAL lRet		:= .T.
Local nCount	:= 0
Local cAvals	:= ""
Local lCalc		:= .f.
Local lPolit	:= .f.
Local nRecnoCons:= 0

IF MV_PAR03 == 1        
		
	cTipoAv := "2"
	cDesTip := "Auto-Avaliacao"	
	
ELSEIF MV_PAR03 == 2 

	cTipoAv := "1"
	cDesTip := "Avaliação"
	
ELSEIF MV_PAR03 == 3      

	cTipoAv := "3"
	cDesTip := "Consenso"
			
ENDIF         

cQrya:= " SELECT RD0_CODIGO"+CRLF
cQrya+= "		,RD0_NOME"+CRLF
cQrya+= "		,RDC_FILIAL"+CRLF
cQrya+= "		,RDC_CODAVA"+CRLF
cQrya+= "		,RDC_CODADO"+CRLF
cQrya+= "		,RDC_CODDOR"+CRLF
cQrya+= "		,RDC_CODPRO"+CRLF
cQrya+= "		,RDC_CODNET"+CRLF
cQrya+= "		,RDC_DATRET"+CRLF
cQrya+= "		,RDC_TIPOAV"+CRLF
cQrya+= "		,RDC_CODAPR"+CRLF
cQrya+= "		,RDC_DTRETA"+CRLF
cQrya+= "		,RDC.R_E_C_N_O_"+CRLF
cQrya+= "		,RDH_NIVEL"+CRLF
cQrya+= "		,RDH_AUTOAV"+CRLF
cQrya+= "		,RDH_FEEDBK"+CRLF
cQrya+= "FROM "+RETSQLNAME("RDC")+" RDC"+CRLF
cQrya+= "INNER JOIN "+RETSQLNAME("RD0")+" RD0 ON RD0_FILIAL='"+XFILIAL("RD0")+"'"+CRLF
cQrya+= "	AND RD0_CODIGO=RDC_CODADO"+CRLF
cQrya+= "	AND RDC.D_E_L_E_T_=''"+CRLF
cQrya+= "INNER JOIN "+RETSQLNAME("RDH")+" RDH ON RDH_FILIAL='"+XFILIAL("RDH")+"'"+CRLF
cQrya+= "   AND RDH_CODNET = RDC_CODNET and RDH_CODTIP = RDC_CODTIP"+CRLF
cQrya+= "WHERE RDC_FILIAL='"+XFILIAL("RDC")+"'"+CRLF 
cQrya+= "	AND RDC_TIPOAV='"+cTipoAv+"'"+CRLF
cQrya+= "	AND RDC_CODAVA='"+MV_PAR01+"'"+CRLF
cQrya+= "	AND RDC_CODADO='"+MV_PAR02+"'"+CRLF
cQrya+= "	AND RDC.D_E_L_E_T_=''"+CRLF
cQrya+= "	AND RDH.D_E_L_E_T_=''"+CRLF
cQrya+= "ORDER BY RD0_CODIGO"+CRLF

TcQuery cQrya NEW ALIAS (cTaba)	                                                   
(cTaba)->(dbSelectArea((cTaba)))                    
(cTaba)->(dbGoTop())                               	

nCount := 0
cAvals := ""
While (cTaba)->(!EOF())
	nCount++
	cAvals += (cTaba)->RDC_CODDOR + " - "
	cAvals += Posicione("RD0",1,xFilial("RD0")+(cTaba)->RDC_CODDOR,"RD0_NOME") + " "
	If (cTaba)->RDH_NIVEL == '1' .and. (cTaba)->RDH_AUTOAV = '2' .and. (cTaba)->RDH_FEEDBK = '2'
		cAvals += "(Mesmo nível)" + CRLF
	ElseIf (cTaba)->RDH_NIVEL == '2'
		cAvals += "(Nível Superior)" + CRLF
	ElseIf (cTaba)->RDH_NIVEL == '3'
		cAvals += "(Nível Inferior)" + CRLF
	Else
		cAvals += CRLF
	EndIf
	(cTaba)->(dbskip())
EndDo
If nCount > 1
	MsgAlert("Na próxima tela informe o código correspondente a um dos avaliadores listados abaixo:"+CRLF+cAvals)
	If !(Pergunte(cPerg2,.t.))
		MsgAlert("Processo cancelado.")
		lRet := .f.
	Else	
		cCodDor := MV_PAR01
		If !(cCodDor $ cAvals)
			MsgAlert("Código de avaliador inválido. Reinicie o processo.")
			lRet := .f.
		EndIf
	EndIf
	If lRet
		(cTaba)->(dbGoTop())                               	
		While (cTaba)->(!EOF()) .and. !((cTaba)->RDC_CODDOR == cCodDor)
			(cTaba)->(dbskip())
		EndDo
	EndIf
ElseIf nCount == 1
	(cTaba)->(dbGoTop())                               	
EndIf

If lRet

	If  nCount == 0		
		Alert("Etapa não encontrada para participante: "+cCodAdo+" e avaliação:" + cCodAva)	
		lValida := .F.
	
	Else
			
		IF EMPTY((cTaba)->RDC_DATRET)
			Alert(cDesTip + " não se encontra finalizada!")
			lValida := .F.

		Else
		
			If cTipoAv == '3' //Consenso
			
				IF !MsgNoYes("O Consenso já está finalizado. Deseja realmente reabrí-lo ?"+CRLF+CRLF+"Nesse caso deverá revisar as justificativas nas questões, pois essas continuarão com o conteúdo inserido no consenso anterior." )
					lValida := .F.
				EndIf

			EndIf

			If cTipoAv == '1' //Avaliacao
			
				//Verifica se está no passo do aprovador -> Existe codigo de aprovador e nao tem data de retorno do mesmo
				If empty((cTaba)->RDC_DTRETA) .and. !empty((cTaba)->RDC_CODAPR)
					Alert(cDesTip + " já está no passo do Gestor para aprovação. Solicite ao mesmo que rejeite, reabrindo então automaticamente a Avaliação.")
					lValida := .F.
				
				//Se tem data de retorno do aprovador, significa que esta no consenso, ou nao tem consenso previsto
				ElseIf !empty((cTaba)->RDC_DTRETA) .or. (empty((cTaba)->RDC_DTRETA) .and. empty((cTaba)->RDC_CODAPR))
					//Verifica se o consenso tem data de fechamento
					dDtFech 	:= ctod("//")
					nRecnoCons 	:= 0
					cQry:= " SELECT RDC_DATRET, R_E_C_N_O_ "+CRLF
					cQry+= " FROM "+RETSQLNAME("RDC")+" RDC"+CRLF
					cQry+= " WHERE RDC_FILIAL='"+(cTaba)->RDC_FILIAL+"'"+CRLF 
					cQry+= "	AND RDC_TIPOAV='3'"+CRLF
					cQry+= "	AND RDC_CODAVA='"+(cTaba)->RDC_CODAVA+"'"+CRLF
					cQry+= "	AND RDC_CODADO='"+(cTaba)->RDC_CODADO+"'"+CRLF
					cQry+= "	AND RDC_CODDOR='"+(cTaba)->RDC_CODDOR+"'"+CRLF
					cQry+= "	AND RDC.D_E_L_E_T_=''"+CRLF
					TcQuery cQry NEW ALIAS TempRDC	                                                   
			
					IF TempRDC->(!EOF())
						dDtFech		:= TempRDC->RDC_DATRET
						nRecnoCons 	:= TempRDC->R_E_C_N_O_
					EndIf	
					TempRDC->(dbclosearea())
			
					If !empty(dDtFech)
						IF !MsgNoYes("O Consenso já está finalizado. Deseja realmente reabrir para a etapa da avaliação ?"+CRLF+CRLF+"Nesse caso deverá revisar as justificativas nas questões, pois essas continuarão com o conteúdo inserido no consenso anterior." )
							lValida := .F.
						EndIf
					EndIf	
	
				EndIf
			
			EndIf
			
		EndIF

	EndIf
	
	If lValida
	
		//Verifique se ja existe calculo
		lCalc := .f.
		cTabb := GetNextAlias()
		cQryb:= "		SELECT COUNT(*) AS TOT FROM "+RETSQLNAME("RDD")+"  RDD"+CRLF
		cQryb+= "		  WHERE RDD_FILIAL='"+XFILIAL("RDD")+"'"+CRLF
		cQryb+= "		  AND RDD_CODNET='"+(cTaba)->RDC_CODNET+"'"+CRLF
		cQryb+= "		  AND RDD_TIPOAV='"+(cTaba)->RDC_TIPOAV+"'"+CRLF
		cQryb+= "		  AND RDD_CODADO='"+(cTaba)->RDC_CODADO+"'"+CRLF
		cQryb+= "		  AND RDD_CODAVA='"+(cTaba)->RDC_CODAVA+"'"+CRLF
		cQryb+= "		  AND RDD.D_E_L_E_T_=''"+CRLF
		TcQuery cQryb NEW ALIAS (cTabb)	                                                   
		If (cTabb)->(!eof())
			If (cTabb)->TOT > 0
				lCalc := .t.
			EndIf
		EndIf			
		(cTabb)->(dbCloseArea())

		If lValida .and. lCalc 		
			IF !MsgNoYes(cDesTip + " já possui cálculo efetuado. Deseja realmente prosseguir ?"+CRLF+CRLF+"Nesse caso atente-se para executar novamente o cálculo da avaliação." )
				lValida := .F.
			EndIf
		EndIf			

		If lValida
		
			//Verifica se tem Politica de Consolidacao calculada
			If Select("TempSZE") > 0
				TempSZE->( dbCloseArea())
			EndIf
			lPolit := .f.
			cQry:= " SELECT * "+CRLF
			cQry+= " FROM "+RETSQLNAME("SZE")+" SZE"+CRLF
			cQry+= " WHERE ZE_CODRD0='"+(cTaba)->RDC_CODADO+"'"+CRLF
			cQry+= "	AND ZE_KEY='"+(cTaba)->RDC_CODAVA+"'"+CRLF
			cQry+= "	AND SZE.D_E_L_E_T_=''"+CRLF
			TcQuery cQry NEW ALIAS TempSZE	                                                   
	
			IF TempSZE->(!EOF())
				lPolit := .t.
				IF !MsgNoYes("Existe Política de Consolidação com cálculo efetuado. Continua ?"+CRLF+CRLF+"Nesse caso atente-se para executar novamente o cálculo da Política." )
					lValida := .F.
				EndIf
			EndIf
				
		EndIf
		
		If lValida

			If lCalc
				//Deleta o calculo da avaliacao para a qual esta voltando
				cTabb := GetNextAlias()
				cQryb:= "		SELECT R_E_C_N_O_ as RECNO FROM "+RETSQLNAME("RDD")+"  RDD"+CRLF
				cQryb+= "		  WHERE RDD_FILIAL='"+XFILIAL("RDD")+"'"+CRLF
				cQryb+= "		  AND RDD_CODNET='"+(cTaba)->RDC_CODNET+"'"+CRLF
				cQryb+= "		  AND RDD_TIPOAV='"+(cTaba)->RDC_TIPOAV+"'"+CRLF
				cQryb+= "		  AND RDD_CODADO='"+(cTaba)->RDC_CODADO+"'"+CRLF
				cQryb+= "		  AND RDD_CODAVA='"+(cTaba)->RDC_CODAVA+"'"+CRLF
				cQryb+= "		  AND RDD.D_E_L_E_T_=''"+CRLF
				TcQuery cQryb NEW ALIAS (cTabb)	                                                   
				While (cTabb)->(!eof())
					RDD->(dbgoto((cTabb)->RECNO))
					Reclock("RDD",.F.)
						RDD->(DBDELETE())
					RDD->( msUnlock() )
					(cTabb)->(dbskip())	
				EndDo			
				(cTabb)->(dbCloseArea())
				//Se estiver voltando para 1-Avaliacao, deleta tambem o consenso
				If (cTaba)->RDC_TIPOAV == '1'
					cTabb := GetNextAlias()
					cQryb:= "		SELECT R_E_C_N_O_ as RECNO FROM "+RETSQLNAME("RDD")+"  RDD"+CRLF
					cQryb+= "		  WHERE RDD_FILIAL='"+XFILIAL("RDD")+"'"+CRLF
					cQryb+= "		  AND RDD_CODNET='"+(cTaba)->RDC_CODNET+"'"+CRLF
					cQryb+= "		  AND RDD_TIPOAV='3'"+CRLF
					cQryb+= "		  AND RDD_CODADO='"+(cTaba)->RDC_CODADO+"'"+CRLF
					cQryb+= "		  AND RDD_CODAVA='"+(cTaba)->RDC_CODAVA+"'"+CRLF
					cQryb+= "		  AND RDD.D_E_L_E_T_=''"+CRLF
					TcQuery cQryb NEW ALIAS (cTabb)	                                                   
					While (cTabb)->(!eof())
						RDD->(dbgoto((cTabb)->RECNO))
						Reclock("RDD",.F.)
							RDD->(DBDELETE())
						RDD->( msUnlock() )
						(cTabb)->(dbskip())	
					EndDo			
					(cTabb)->(dbCloseArea())
				EndIf
			EndIf
			
			If lPolit
				SZE->(dbsetorder(1))
				While TempSZE->(!eof())
					SZE->(dbseek(xFilial("SZE")+TempSZE->ZE_CODRD0+TempSZE->ZE_IDCONS))
					While SZE->(!eof()) .and. SZE->(ZE_FILIAL+ZE_CODRD0+ZE_IDCONS) ==  xFilial("SZE")+TempSZE->ZE_CODRD0+TempSZE->ZE_IDCONS
						Reclock("SZE",.F.)
							SZE->(DBDELETE())
						SZE->( msUnlock() )	
						SZE->(dbskip())
					EndDo
					TempSZE->(dbskip())
				EndDo
			EndIf
			TempSZE->(dbclosearea())

			//Limpa a data de fechamento do Consenso
			If nRecnoCons > 0
				RDC->(dbgoto(nRecnoCons))
				RecLock("RDC",.f.)
					RDC->RDC_DATRET := ctod("//")
				RDC->(MsUnLock())
	
				//Exclui respostas do Consenso
				RDB->(DbSetOrder(6))
				RDB->(DbSeek((cTaba)->(RDC_FILIAL+RDC_CODPRO+RDC_CODAVA+RDC_CODADO+RDC_CODDOR)))
				While RDB->(!Eof()) .and. RDB->(RDB_FILIAL+RDB_CODPRO+RDB_CODAVA+RDB_CODADO+RDB_CODDOR) == (cTaba)->(RDC_FILIAL+RDC_CODPRO+RDC_CODAVA+RDC_CODADO+RDC_CODDOR)
				    IF RDB->RDB_TIPOAV == '3'	
						RDB->(Reclock("RDB",.F.))
							RDB->(DBDELETE())
						RDB->( msUnlock() )	
					EndIf
					RDB->( DbSkip() )
				EndDo    
			EndIf

			//Limpa a data de fechamento da Avaliacao e outros campos
			RDC->(dbgoto((cTaba)->R_E_C_N_O_))
			RecLock("RDC",.f.)
				RDC->RDC_DATRET	:= ctod("//")
				If cTipoAv == '1' //Avaliação
					RDC->RDC_CODAPR := ''
					RDC->RDC_DTEMAP := ctod("//")
					RDC->RDC_DTRETA := ctod("//")
				EndIf
			RDC->(MsUnLock())

		    MSGINFO("Foi reaberto para "+cDesTip+" o processo do participante " +(cTaba)->RD0_NOME)
		    		    
		EndIf				
		
	ENDIF               

EndIf

(cTaba)->(dbCloseArea())

return  

/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ APD002SX1  ºAutor  ³Totvs               º Data ³19/06/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza parametros        								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function APD002SX1(cPerg)
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
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

If cPerg == "APD002"
	AADD(aDados,{cPerg,'01','Avaliação ?','Avaliação ?','Avaliação ?','MV_CH1','C',TAMSX3("RDA_CODAVA")[1],0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','RD6','','','','',''} )
	AADD(aDados,{cPerg,'02','Codigo do Particip.?','Codigo do Particip.?','Codigo do Particip.?','MV_CH2','C',TAMSX3("RDA_CODADO")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','RD0','','','','',''} )
	AADD(aDados,{cPerg,'03','Etapa para reabrir ?','Etapa para reabrir ?','Etapa para reabrir ?','MV_CH3','C',1,0,1,'C','','MV_PAR03','Auto Avaliação','Auto Avaliação','Auto Avaliação','','','Avaliador','Avaliador','Avaliador','','','Consenso','Consenso','Consenso','','','      ','      ','      ','','','','','','','','','','','',''} )
Else
	AADD(aDados,{cPerg,'01','Codigo do Avaliador ?','Codigo do Avaliador ','Codigo do Avaliador ','MV_CH1','C',TAMSX3("RDA_CODDOR")[1],0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','RD0','','','','',''} )
EndIf

//
// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
	If cPerg == "APD002"
		AADD(aHelp, {'01',{'Informe o código da avaliação.'},{''},{''}}) 
		AADD(aHelp, {'02',{'Informe o código do participante.'},{''},{''}})
		AADD(aHelp, {'03',{'Informe a etapa que deseja reabrir.'},{''},{''}}) 
	Else
		AADD(aHelp, {'01',{'Informe o código do Avaliador.'},{''},{''}}) 
	EndIf
			
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN


/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ APDCopyC ºAutor  ³Totvs		           º Data ³12/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia os itens da avaliacao para consenso 				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
User Function APDCopyC(cCodAva,cCodAdo,cCodDor)

Local cTabRDB	:= ""
Local cTabRDC	:= ""
Local cQry		:= ""            
Local cIDAval	:= ""
Local cIDCons	:= ""                
Local aRDB		:= RDB->(getarea())

//Busca o ID da Avaliacao
cTabRDC := GetNextAlias()
cQry:= " SELECT RDC_ID "+CRLF
cQry+= " FROM "+RETSQLNAME("RDC")+" RDC"+CRLF
cQry+= " WHERE RDC_FILIAL='"+xFilial("RDC")+"'"+CRLF 
cQry+= "	AND RDC_CODAVA='"+cCodAva+"'"+CRLF
cQry+= "	AND RDC_CODADO='"+cCodAdo+"'"+CRLF
cQry+= "	AND RDC_CODDOR='"+cCodDor+"'"+CRLF
cQry+= "	AND RDC_TIPOAV='1'"+CRLF
cQry+= "	AND RDC.D_E_L_E_T_=''"+CRLF
TcQuery cQry NEW ALIAS (cTabRDC)	         
If (cTabRDC)->(!eof())
	cIDAval	:= (cTabRDC)->RDC_ID
EndIf	
(cTabRDC)->(dbclosearea())

//Busca o ID do Consenso
cTabRDC := GetNextAlias()
cQry:= " SELECT RDC_ID "+CRLF
cQry+= " FROM "+RETSQLNAME("RDC")+" RDC"+CRLF
cQry+= " WHERE RDC_FILIAL='"+xFilial("RDC")+"'"+CRLF 
cQry+= "	AND RDC_CODAVA='"+cCodAva+"'"+CRLF
cQry+= "	AND RDC_CODADO='"+cCodAdo+"'"+CRLF
cQry+= "	AND RDC_CODDOR='"+cCodDor+"'"+CRLF
cQry+= "	AND RDC_TIPOAV='3'"+CRLF
cQry+= "	AND RDC.D_E_L_E_T_=''"+CRLF
TcQuery cQry NEW ALIAS (cTabRDC)	         
If (cTabRDC)->(!eof())
	cIDCons	:= (cTabRDC)->RDC_ID
EndIf	
(cTabRDC)->(dbclosearea())

//Se encontrou consenso configurado
If !empty(cIDCons)

	//Deleta os itens do consenso na RDB, se já existirem
	cChave := xFilial("RDB")+cCodAva+cCodAdo 
	RDB->(DbSetOrder(1))
	RDB->(DbSeek(cChave))
	While RDB->(!Eof()) .and. RDB->(RDB_FILIAL+RDB_CODAVA+RDB_CODADO) == cChave
	    IF RDB->RDB_ID == cIDCons	
			RDB->(Reclock("RDB",.F.))
				RDB->(DBDELETE())
			RDB->( msUnlock() )	
		EndIf
		RDB->( DbSkip() )
	EndDo    
	
	//Busca os itens da avaliacao na RDB que serao replicados
	cTabRDB := GetNextAlias()
	cQry:= " SELECT * "
	cQry+= "    FROM " + RetSqlName("RDB") + " "
	cQry+= " WHERE RDB_ID = '"+ cIDAval+"' "
	cQry+= "    AND D_E_L_E_T_ = '' " 
	TcQuery cQry NEW ALIAS (cTabRDB)
	
	(cTabRDB)->(dbGoTop())                              	
	While (cTabRDB)->(!eof())
		RDB->(Reclock("RDB",.T.))			
			RDB->RDB_FILIAL 		:= (cTabRDB)->RDB_FILIAL
			RDB->RDB_CODAVA 		:= (cTabRDB)->RDB_CODAVA
			RDB->RDB_CODADO 		:= (cTabRDB)->RDB_CODADO
			RDB->RDB_CODPRO 		:= (cTabRDB)->RDB_CODPRO
			RDB->RDB_CODDOR 		:= (cTabRDB)->RDB_CODDOR
			RDB->RDB_TIPOAV	   		:= '3'
			RDB->RDB_DTIAVA 		:= STOD((cTabRDB)->RDB_DTIAVA)
			RDB->RDB_DTFAVA	  		:= STOD((cTabRDB)->RDB_DTFAVA)
			RDB->RDB_CODMOD 		:= (cTabRDB)->RDB_CODMOD
			RDB->RDB_CODCOM 		:= (cTabRDB)->RDB_CODCOM
			RDB->RDB_ITECOM  		:= (cTabRDB)->RDB_ITECOM
			RDB->RDB_CODTIP	  		:= (cTabRDB)->RDB_CODTIP
			RDB->RDB_CODNET 		:= (cTabRDB)->RDB_CODNET
			RDB->RDB_CODQUE 		:= (cTabRDB)->RDB_CODQUE
			RDB->RDB_CODALT 		:= (cTabRDB)->RDB_CODALT
			RDB->RDB_ESCALA 		:= (cTabRDB)->RDB_ESCALA
			RDB->RDB_ITEESC 		:= (cTabRDB)->RDB_ITEESC
			RDB->RDB_RESOBT	  		:= (cTabRDB)->RDB_RESOBT
			RDB->RDB_CODMEM	  		:= (cTabRDB)->RDB_CODMEM
			RDB->RDB_CODJUS	  		:= (cTabRDB)->RDB_CODJUS
			RDB->RDB_ID 			:= cIDCons
		RDB->( msUnlock() )
		(cTabRDB)->(dbskip())
	EndDo	 
	(cTabRDB)->(dbCloseArea())

EndIf

RestArea(aRDB)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EnvMail      ³ Autor ³                  ³ Data ³ 12/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia emails                                              |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EnvMail(cSubject,cMensagem,cEMail)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cSubject  - Assunto                                       ³±±
±±³          ³ cMensagem - Corpo do E-mail                               ³±±
±±³          ³ cEMail     - Conta que recebera o eMail                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EnvMail(cSubject,cMensagem,cEMail,aFiles,lMsg)

Local lEnvioOK 		:= .F.	// Variavel que verifica se foi conectado OK
Local lMailAuth		:= .f.
Local cMailServer	:= ''
Local cMailConta	:= ''
Local cMailSenha	:= ''
Local lUseSSL		:= SuperGetMV("MV_RELSSL" ,,.F.)
Local lUseTLS		:= SuperGetMV("MV_RELTLS" ,,.F.)
Local oMail			:= NIL
Local nErro			:= 0
Local nArqErro		:= 0
Local cMsgErro		:= ""
Local cUsuario		:= ''
Local cFrom 		:= ''
Local oMessage		:= NIL
Local nPort			:= 0
Local nAt			:= 0
Local cServer		:= ""
Local nX			:= 0
Local lErroFile		:= .F.

DEFAULT aFiles 		:= {}
DEFAULT lMsg		:= .f.

If !Empty(AllTrim(GetMV("MV_RHCONTA"))) .And. !Empty(AllTrim(GetMV("MV_RHSENHA"))) .And. !Empty(AllTrim(GetMV("MV_RHSERV")))
   cMailConta := AllTrim(GetMV("MV_RHCONTA"))
   cMailSenha := AllTrim(GetMV("MV_RHSENHA"))
   cMailServer:= AllTrim(GetMV("MV_RHSERV"))
   lMailAuth  := SuperGetMv("MV_RHAUTEN")
   
ElseIf !Empty(AllTrim(GetMV("MV_RELACNT"))) .And. !Empty(AllTrim(GetMV("MV_RELPSW"))) .And. !Empty(AllTrim(GetMV("MV_RELSERV")))
	cMailServer	:= Alltrim(SuperGetMv("MV_RELSERV",, ""))
	cMailConta	:= Alltrim(SuperGetMV("MV_RELACNT",, ""))
	cMailSenha	:= Alltrim(SuperGetMV("MV_RELPSW" ,, ""))
	lMailAuth   := SuperGetMv("MV_RELAUTH")

Else
   cMailConta := AllTrim(GetMV("MV_EMCONTA"))
   cMailSenha := AllTrim(GetMV("MV_EMSENHA"))
   cMailServer:= AllTrim(GetMV("MV_RELSERV"))							
   lMailAuth  := SuperGetMv("MV_RELAUTH")

EndIf

If At("@",cMailConta) > 0
	cFrom := 'Workflow RH <'+cMailConta+'>'
Else
	If lMsg
		MsgAlert( OemToAnsi( "Não há configuração válida para a conta que enviará o email." ) )
	Else
		conout("### ERRO ### Nao ha configuracao valida para a conta que enviara o email.")
	EndIf
	Return .f.
EndIf

cUsuario		:= SubStr(cMailConta,1,At("@",cMailConta)-1)

If (!Empty(cMailServer)) .AND. (!Empty(cMailConta)) .AND. (!Empty(cMailSenha))
	
	oMail := TMailManager():New()
	oMail:SetUseSSL(lUseSSL)
	oMail:SetUseTLS(lUseTLS)
	nAt	  :=  At(':' , cMailServer)
	
	// Para autenticacao, a porta deve ser enviada como parametro[nSmtpPort] na chamada do método oMail:Init().
	// A documentacao de TMailManager pode ser consultada por aqui : http://tdn.totvs.com/x/moJXBQ
	If ( nAt > 0 )
		cServer		:= SubStr(cMailServer , 1 , (nAt - 1) )
		nPort		:= Val(AllTrim(SubStr(cMailServer , (nAt + 1) , Len(cMailServer) )) )
	Else
		cServer		:= cMailServer
	EndIf
	
	oMail:Init("", cServer, cMailConta, cMailSenha , 0 , nPort)	
	//Init( < cMailServer >, < cSmtpServer >, < cAccount >, < cPassword >, [ nMailPort ], [ nSmtpPort ] )
	
	nErro := oMail:SMTPConnect()
		
	If ( nErro == 0 )

		If lMailAuth

			// try with account and pass
			nErro := oMail:SMTPAuth(cMailConta, cMailSenha)
			If nErro != 0
				// try with user and pass
				nErro := oMail:SMTPAuth(cUsuario, cMailSenha)
				If nErro != 0
					If lMsg
						MsgAlert( OemToAnsi( "Falha na conexão com servidor de e-mail." ) )
					Else
						conout("### ERRO ### Falha na conexao com servidor de e-mail")
					EndIf	
					Return .f.
				EndIf
			EndIf
		Endif
		
		oMessage := TMailMessage():New()
		
		//Limpa o objeto
		oMessage:Clear()
		
		//Popula com os dados de envio
		oMessage:cFrom 		:= cFrom
		oMessage:cTo 		:= cEmail
		oMessage:cCc 		:= ""
		oMessage:cBcc 		:= ""
		oMessage:cSubject 	:= cSubject
		oMessage:cBody 		:= cMensagem
		
		For nX :=1 to Len(aFiles)
			nArqErro := oMessage:AttachFile( aFiles[nX] )
			
			If (nArqErro < 0)
				cMsgErro := oMail:GetErrorString(nArqErro)
				If lMsg
					MsgAlert( OemToAnsi( "Falha no envio do e-mail. Erro retornado: " + cMsgErro ) )
				Else
					conout("### ERRO ### Falha no envio do e-mail. Erro retornado: " + cMsgErro)
				EndIf	
				lErroFile	:= .T.
				Exit
			EndIf
		Next		
		
		If !lErroFile
			//Envia o e-mail
			nErro := oMessage:Send( oMail )
			
			If !(nErro == 0)
				cMsgErro := oMail:GetErrorString(nErro)
				If lMsg
					MsgAlert( OemToAnsi( "Falha no envio do e-mail. Erro retornado: " + cMsgErro ) )
				Else
					conout("### ERRO ### Falha no envio do e-mail. Erro retornado: " + cMsgErro)
				EndIf	
			Else
				lEnvioOk	:= .T.
			EndIf
		EndIf

		//Desconecta do servidor
		oMail:SmtpDisconnect()
		
	Else
	
		cMsgErro := oMail:GetErrorString(nErro)
		If lMsg
			MsgAlert( OemToAnsi( "Falha na conexão com servidor de e-mail" ) )
		Else
			conout("### ERRO ### Falha na conexao com servidor de e-mail")
		EndIf	
		
	EndIf
	
Else

	If ( Empty(cMailServer) )
		If lMsg
			Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Else
			conout("### ERRO ### O Servidor de SMTP nao foi configurado")
		EndIf
	EndIf

	If ( Empty(cMailConta) )
		If lMsg
			Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Else
			conout("### ERRO ### A Conta do email nao foi configurada")
		EndIf
	EndIf
	
	If Empty(cMailSenha)
		If lMsg
			Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Else
			conout("### ERRO ### A Senha do email nao foi configurada")
		EndIf
	EndIf
	
EndIf

Return( lEnvioOK )