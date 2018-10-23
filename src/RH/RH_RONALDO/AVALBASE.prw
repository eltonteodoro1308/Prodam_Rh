#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//**************************************************************************************
//**************************************************************************************
//** Ferramenta para a an�lise de conte�do em tabelas padr�es do Protheus        
//** As situa��es analisadas s�o:
//** - Campos com caracteres especiais;                                   
//** - Campos com caracteres acentuados;
//** - Campos obrigat�rios sem conte�do;
//** - Campos de CGC/CNPJ com conte�do inv�lido (para cliente e fornecedor);
//** - Campos validados com PERTENCE e com conte�do inv�lido;
//** - Campos com refer�ncia em outra tabela e com conte�do inv�lido.     
//**************************************************************************************
//**************************************************************************************
User Function AVALBASE()
//**************************************************************************************
	
	Local oProcess
	Local lOk 			:= .F.
	Local a			:= 0
	Local cTxtLog		:= ""
	Local cEol 		:= chr(13)+ chr(10)
	Local lCabEspec	:= .T.
	Local lCabAcent	:= .T.
	Local lCabObrig	:= .T.
	Local lCabCGC 	:= .T.
	Local lCabPertenc	:= .T.
	Local lCabRelac	:= .T.
	Local nHandle
	Local cDirLog		:= ""
	Local cArqLog		:= ""
	Local cDtTmIni	:= ""
	Local cDtTmFim	:= ""
	
	Private cTab		:= "   "
	Private cDir		:= SPACE(100)
	Private cSep		:= "|"
	Private aLogRet 	:= {}
	Private lChk1		:= .F.
	Private lChk2		:= .F.
	Private aSX2		:= {}

	DEFINE MSDIALOG oDlg TITLE "An�lise de base" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 015, 011 SAY oSay1 PROMPT "Informe o ALIAS da tabela a ser analisada " SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 120 GET oGet1 VAR cTab Picture "@!" SIZE 020, 010 VALID VLDSX2(cTab) OF oDlg COLORS 0, 16777215 PIXEL
	@ 035, 011 SAY oSay2 PROMPT "Informe o caminho para salvar o arquivo de LOG da an�lise " SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 048, 011 GET oGet2 VAR cDir Picture "@!" SIZE 190, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
	@ 065, 011 SAY oSay3 PROMPT "Realizar as seguintes corre��es:" SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 075, 015 CheckBox oChkMar1 Var  lChk1 Prompt "- corrigir caracteres acentuados, trocando-os pelos respectivos caracteres sem o acento;"   Message  Size 250, 010 Pixel Of oDlg
	@ 085, 015 CheckBox oChkMar2 Var  lChk2 Prompt "- retirar caracteres especiais, trocando-os por espacos em branco."   Message  Size 250, 010 Pixel Of oDlg
	DEFINE SBUTTON oSButton3 FROM 048, 210 TYPE 14 OF oDlg ENABLE action(cDir := ALLTRIM(cGetFile("Arquivo TEXTO|*.TXT",'Selec�o de pasta', 0,'', .T., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.)))
	DEFINE SBUTTON oSButton1 FROM 110, 210 TYPE 01 OF oDlg ENABLE action(lOk:=VLDOK(),IIF(lOk,oDlg:end(),.T.))
	DEFINE SBUTTON oSButton2 FROM 110, 170 TYPE 02 OF oDlg ENABLE action(oDlg:end())

	ACTIVATE MSDIALOG oDlg CENTERED


	If lOk
	
		/// Posiciona no ALIAS 
		dbSelectArea("SX2")
		dbSetOrder(1)
		If dbSeek(cTab)
			cArquivo := Upper(Alltrim(SX2->X2_ARQUIVO))
		Else
			cArquivo := cTab
		EndIf

		lOk := ApMsgYesNo("Confirma a execu��o da an�lise da tabela "+AllTrim(cArquivo)+" ?")
		
		If lOk
			cDtTmIni := DTOC(Date()) + " " + Time()
		
			dbSelectArea("SX2")
			dbSetOrder(1)
			dbGoTop()
			Do While !Eof()
				aadd(aSX2,SX2->X2_ARQUIVO)
				dbSkip()
			EndDo
		
			oProcess := MsNewProcess():New({|lEnd| ProcIni(lEnd,oProcess)},"Processando an�lise de dados","Aguarde...",.T.)
			oProcess:Activate()

			cDtTmFim := DTOC(Date()) + " " + Time()
			
			cArqLog := AllTrim(cDir) + "LOG_TAB_" + cTab + "_" + DTOS(DATE())+"_"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+".TXT"
			nHandle := MsfCreate(cArqLog,0)
			IF nHandle < 0
				MsgAlert( "Falha na cria��o do arquivo de LOG." )
			Else
				If Len(aLogRet)<=0
					fWrite(nHandle, "Nenhuma inconsistencia encontrada..." )
				Else
				
					cTxtLog := "LOG DE PROCESSAMENTO DA TABELA " + cArquivo + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "INICIO : " + cDtTmIni + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "FINAL  : " + cDtTmFim + cEol
					fWrite(nHandle, cTxtLog )
					If lChk1
						cTxtLog := " - Selecionada a opcao de correcao dos caracteres acentuados."+cEol
						fWrite(nHandle, cTxtLog )
					EndIf
					If lChk2
						cTxtLog := " - Selecionada a opcao de correcao dos caracteres especiais."+cEol
						fWrite(nHandle, cTxtLog )
					EndIf
	
					///Ordena o vetor por tabela e tipo de ocorr�ncia
					aLogRet 	:= aSort(aLogRet,,,{|x,y| x[1]+x[2]< y[1]+y[2]} )
					For a:=1 to Len(aLogRet)
						Do Case

						Case aLogRet[a,1] == "PROCESPEC"
							If lCabEspec
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com caracteres especiais" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabEspec := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )
				
						Case aLogRet[a,1] == "PROCACENT"
							If lCabAcent
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com caracteres acentuados" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabAcent := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )

						Case aLogRet[a,1] == "PROCOBRIG"
							If lCabObrig
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos obrigatorios sem conteudo" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabObrig := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCCGC"
							If lCabCGC
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos de CGC/CNPJ com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabCGC := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCPERTENC"
							If lCabPertenc
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos validados com PERTENCE e com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO ESPERADO"  + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabPertenc := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5]+ cSep + aLogRet[a,6] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCRELAC"
							If lCabRelac
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )								
								cTxtLog := "Inconsistencias : Campos com referencia em outra tabela e com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CONSULTA<F3>" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabRelac := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cSep + aLogRet[a,6] + cEol
							fWrite(nHandle, cTxtLog )
					
						EndCase
					Next
				Endif
				fClose(nHandle)
				ApMsgInfo("Gerado o arquivo de LOG : " + cEol+ cArqLog)
			EndIf
		EndIf
	EndIf
	
Return


Static Function VLDSX2()
	Local lRet := .F.

	dbSelectArea("SX2")
	dbSetOrder(1)
	If Empty(cTab) .or. dbseek(cTab)
		lRet := .T.
	Else
		ApMsgInfo("ALIAS " + cTab + " n�o encontrado.")
	EndIf

Return(lRet)



Static Function VLDOK()
	Local lRet := .F.

	If !Empty(cTab) .and. !Empty(cDir)
		lRet := .T.
	Else
		ApMsgInfo("Parametros n�o informados corretamente !")
	EndIf

Return(lRet)



Static Function ProcIni(lEnd,oObj)
	Local aSX3			:= {}
	Local a			:= 0
	Local aRet 		:= {}
	Local cArquivo	:= ""
	Local lObrig		:= .F.

			
	/// Posiciona no ALIAS 
	dbSelectArea("SX2")
	dbSetOrder(1)
	If dbSeek(cTab)
		cArquivo := Upper(Alltrim(SX2->X2_ARQUIVO))
				
		aSX3 := {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		If dbSeek(cTab)
			Do While !EOF() .And. SX3->X3_ARQUIVO == cTab
				If SX3->X3_CONTEXT <> "V"
					lObrig :=X3Obrigat(X3_CAMPO)
					AADD(aSX3,{ TRIM(X3_TITULO), X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_F3, lObrig, X3_VALID })
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo
		EndIf
				
		oObj:SetRegua1(5)
				
		oObj:IncRegua1("Analisando " + AllTrim(cArquivo) + " ..." )
		ProcExec(oObj,cArquivo,aSX3)
		Inkey(0.5)

	EndIf
	
Return Nil





Static Function ProcExec(oObj,cArquivo,aSX3)
	Local cChave 		:= SX2->X2_CHAVE
	Local cX2Unic		:= AllTrim(SX2->X2_UNICO)
	LOcal cCampo		:= ""
	Local cChaveReg	:= ""
	Local Conteud 	:= ""
	Local lValid
	Local x			:= 0
	Local i			:= 0
	Local nPos			:= 0
	//Local aStr
	Local nRecCount	:= 0
	Local nCount		:= 0
	Local cPercent	:= "0"
	 
	//aStr := {" ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","!","&","@","#","$","%","(",")","-","_","=",".","<",">",",",";",":","?","/","|","\","+","*"}
	
	///Abre a tabela e posiciona no primeiro registro
	dbSelectArea(cChave)
	///Retira o Indice, pois se houver a necessidade de atualizar um conte�do que � chave, n�o ir� deslocar o ponteiro
	dbSetOrder(0)
	///Vai para o primeiro tegistro.
	dbGoTop()
	///Executa o Loop abaixo at� o final da tabela
	nRecCount := RecCount()
	oObj:SetRegua2(nRecCount)
	Do While !Eof()
		aAreaAnt := GETAREA()
		nCount += 1
		cPercent := AllTrim(Transform(nCount / nRecCount * 100 ,"@E 9999"))
		oObj:IncRegua2("Analisando ... " + cPercent + " %" )
		For x:=1 to Len(aSX3)
			cCampo 	:= aSX3[x][2]
			cTipo  	:= aSX3[x][3]
			cF3 		:= aSX3[x][6]
			lObrig 	:= aSX3[x][7]
			cValid 	:= alltrim( upper (aSX3[x][8] ) )
			nPosPert  	:= AT("PERTENCE(",cValid)
			xConteud 	:= &(cChave+"->"+cCampo)
			cChaveReg 	:= IIF(Empty(cX2Unic),"",&(cChave+"->("+cX2Unic+")"))

			///------------------------------
			///Valida Caracteres Acentuados
			///------------------------------
			IF cTipo == "C" .and. !("_USERL" $ cCampo)
				///Executa a apena a an�lise do conte�do para verificar se possui acento e retorna .T. ou .F.
				lValid := fAcento(xConteud,.F.)
				If lValid
					AADD(aLogRet,{"PROCACENT",cChave,cChaveReg,cCampo,xConteud})
					///-------------------------------------------------------------------------------------------
					///Se foi selecionada a op��o de corre��o de acentua��o, executa a atualiza��o do campo.
					///-------------------------------------------------------------------------------------------
					If lChk1
						cCpoAtu 	:= cChave+"->"+cCampo
						cContNew 	:= fAcento(xConteud,.T.)
						If RecLock(cChave,.F.)
							&(cCpoAtu) := cContNew
							MsUnlock()
						EndIf
					EndIf
				EndIf
			EndIf


			///------------------------------
			///Valida Caracteres Especiais
			///------------------------------
			IF cTipo == "C" .and. !("_USERL" $ cCampo)
				///Executa a apena a an�lise do conte�do para verificar se possui caractere diferente de letras, n�meros e acentos
				lValid := fEspecial(xConteud,.F.)
				/*
				cContUp := UPPER(xConteud)
				lvalid := .F.
				If Len(cContUp) > 0
					For i:=1 to Len(cContUp)
						nPos := aScan(aStr,Substr(cContUp,i,1))
						If nPos <= 0
							lvalid := .T.
						EndIf
					Next i
				EndIf
				*/
				If lValid
					AADD(aLogRet,{"PROCESPEC",cChave,cChaveReg,cCampo,xConteud})
					///-------------------------------------------------------------------------------------------------
					///Se foi selecionada a op��o de corre��o de caracteres espec�ficos, executa a atualiza��o do campo.
					///-------------------------------------------------------------------------------------------------
					If lChk2
						cCpoAtu 	:= cChave+"->"+cCampo
						cContNew 	:= fEspecial(xConteud,.T.)
						If RecLock(cChave,.F.)
							&(cCpoAtu) := cContNew
							MsUnlock()
						EndIf
					EndIf

				EndIf
			EndIf



			///--------------------------------------
			///Valida Campos Obrigat�rios em branco
			///--------------------------------------
			If lObrig
				
				IF cTipo == "C"
					lValid := AllTrim(xConteud) == ""
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,xConteud})
					EndIf
				EndIf

				IF cTipo == "N"
					lValid := xConteud = 0
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,STR(xConteud)})
					EndIf
				EndIf
				
				IF cTipo == "D"
					lValid := AllTrim(DTOS(xConteud)) == ""
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,dtos(xConteud)})
					EndIf
				EndIf
				
			EndIf



			///--------------------------------------
			///Valida CNPJ / CPF
			///--------------------------------------
			If AllTrim(cCampo) $ "A1_CGC#A2_CGC" .and. !Empty(xConteud)
				IF ! CGC(xConteud,,.F.)
					AADD(aLogRet,{"PROCCGC",cChave,cChaveReg,cCampo,xConteud})
				EndIf
			EndIf
			

			///------------------------------------------
			///Valida conte�do de campos com o PERTENCE
			///------------------------------------------
			If cTipo == "C" .and. nPosPert > 0
				If !Empty(xConteud)
					cContem := Substr(cValid,nPosPert+10)
					nPosFim := AT(")",cContem)
					If nPosFim > 0
						cContem := Substr(cContem,1,nPosFim-2)
					EndIf
					If !(xConteud $ cContem)
						AADD(aLogRet,{"PROCPERTENC",cChave, cChaveReg, cCampo, cContem, xConteud})
					EndIf
				EndIf
			EndIf


			///--------------------------------------------------------
			///Valida relacionamento de campos com outras tabelas
			///--------------------------------------------------------
			If cTipo == "C" .and. !Empty(cF3)
				lValid 	:= .F.
				If Len(AllTrim(cF3)) = 3 .and. !Empty(xConteud) .AND. aScan(aSX2,AllTrim(cF3)) > 0   //Substr(cF3,1,1) <> "X" .AND. cF3 <> "SM0"   
	
					//dbSelectArea("SX2")
					//dbSetOrder(1)
					//If dbSeek(cF3)
											
					dbSelectArea(cF3)
					dbSetOrder(1)
					cChvRel := xFilial(AllTrim(cF3)) + xConteud
					If !dbSeek(cChvRel)
						lValid := .T.
					EndIf

					If lValid
						AADD(aLogRet,{"PROCRELAC",cChave, cChaveReg, cF3, cCampo, xConteud})
					EndIf

					//EndIf
				EndIf
				If Len(AllTrim(cF3)) = 2 .and. !Empty(xConteud)
	
					//dbSelectArea("SX2")
					//dbSetOrder(1)
					//If dbSeek(cF3)
						
					dbSelectArea("SX5")
					dbSetOrder(1)
					cChvRel := xFilial("SX5") + AllTrim(cF3) + xConteud
					If !dbSeek(cChvRel)
						lValid := .T.
					EndIf

					If lValid
						AADD(aLogRet,{"PROCRELAC",cChave, cChaveReg, "SX5"+cF3, cCampo, xConteud})
					EndIf

					//EndIf
				EndIf
			EndIf
			
		Next
		
		RestArea(aAreaAnt)
		dbSelectArea(cChave)
		dbSKip()

	EndDo
Return













Static Function fAcento(cTxt,lChange)
	Local xRet
	Local cRet		:= ""
	Local i		:= 0
	Local nPos		:= 0
	Local aStr1	:= {}
	Local aStr2	:= {}
	Local lAcento	:= .F.

	aStr1	:= {"�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"}  //,"�","�","+","�","�","�","�","�","�","�","�","'"} 
	aStr2	:= {"a","e","i","o","u","A","E","I","O","U","a","e","i","o","u","A","E","I","O","U","a","e","i","o","u","A","E","I","O","U","a","o","A","O","a","e","i","o","u","A","E","I","O","U"," "," ","c","C"}  //,"C","O","A","O"," ","a","c","o","e","a","o"," "} 

	If cTxt = Nil .or. ValType(cTxt)<> "C"
		cTxt := ""
	EndIf

	If Len(cTXT) > 0
		For i:=1 to Len(cTXT)
			nPos := aScan(aStr1,Substr(cTXT,i,1))
			If nPos > 0
				cRet := cRet + aStr2[nPos]
				lAcento := .T.
			Else
				cRet := cRet + Substr(cTXT,i,1)
			EndIf
		Next
	EndIf

	If lChange
		xRet := cRet
	Else
		xRet := lAcento
	EndIf

Return(xRet)




Static Function fEspecial(cTxt,lChange)
	Local xRet
	Local cRet		:= ""
	Local i		:= 0
	Local nPos		:= 0
	Local aStr	:= {}
	Local lEspec	:= .F.


	aStr := {" ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","!","&","@","#","$","%","(",")","-","_","=",".","<",">",",",";",":","?","/","|","\","+","*"}

	If cTxt = Nil .or. ValType(cTxt)<> "C"
		cTxt := ""
	EndIf

	cContUp := UPPER(xConteud)
	If Len(cTXT) > 0
		For i:=1 to Len(cTXT)
			nPos := aScan(aStr,Substr(cContUp,i,1))
			If nPos > 0
				cRet := cRet + Substr(cTXT,i,1)
			Else
				cRet := cRet + " "
				lEspec := .T.
			EndIf
		Next
	EndIf

	If lChange
		xRet := cRet
	Else
		xRet := lEspec
	EndIf

Return(xRet)