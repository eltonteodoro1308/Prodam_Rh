#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "PWSR010PRW.CH"

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PWSR010.prw   ³ Autor ³ Mauricio MR        		  ³ Data ³ 10.07.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de cadastramento do curriculo via Portal Candidato			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.  			            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ FNC  	      	 ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³MauricioMR  |08/09/09|00000021002/2009|Ajuste na manutencao dos campos de usuario³±±
±±³            |        |     			 |de dados pessoais ao acionar o botao adi- ³±±
±±³            |        |     			 |cionar de historico de carreira.          ³±±
±±³Allyson M.  |27/05/10|00000010132/2010|Ajuste p/ gravar descricao do curso infor-³±±
±±³            |        |     			 |mado pelo usuario caso o curso selecionado³±±
±±³            |        |     			 |seja 'Outros'.					        ³±±
±±³Allyson M.  |20/05/11|00000012100/2011|Incluida validacao para retirar os carac- ³±±
±±³            |        |     			 |teres '<' e '>' de todos os campos pois   ³±±
±±³            |        |     			 |sao utilizadas em tags html e funcoes     ³±±
±±³            |        |     			 |javascript e o candidato poderia digitar  ³±±
±±³            |        |     			 |para derrubar o banco ou outro fim.       ³±±
±±³            |        |     			 |Incluida validacao para nao permitir digi-³±±
±±³            |        |     			 |tar mais do que 18224 caracteres.         ³±±
±±³Allyson M.  |20/06/11|00000013746/2011|Adicionado chamada para validar o RFC do  ³±±
±±³            |        |     			 |candidato.     							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³R.Berti     |14/12/11|TECRDR|No MEX, a mascara numerica e' invertida (999,999.99)³±±
±±³            |        |      |Correcao de erros de exibicao(***,***.**)ou gravacao³±±
±±³            |        |      |incorreta campos(SQG) - Ult.Salario e Pret.Salarial.³±±
±±³Gustavo M.  |28/11/12|TGBPIQ|Ajuste para gravar corretamente a instituicao, caso ³±±
±±³            |        |      |usado a opcao "Outros".								³±±
±±³Luis Artuso |07/01/13|TGJWBH|Ajuste para exibir a descricao correta de:Cursos Re-³±±
±±³            |        |000151|levantes, Idiomas e Certificoes Tecnicas.           ³±±
±±³            |        |  2013|                                                    ³±±
±±³Emerson Camp|03/02/11|  PROJ|Implementacao dos controles de obrigatoriedade dos  ³±± 
±±³            |        |297701|campos da SQG                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±  
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/



/*************************************************************/
/* Apresenta formulario para inclusao 						 */
/*************************************************************/
Web Function PWSR010A()	//GetCurriculum

Local cHtml := ""
Local oObj

WEB EXTENDED INIT cHtml
	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	HttpSession->cCurricCpf 	:= HttpPost->cCurricCpf
	HttpSession->cCurricPass 	:= HttpPost->cCurricPass

	If !Empty( HttpSession->cCurricCpf ) //.And. !Empty( HttpSession->cCurricPass ) //Vem do PWSR000
		If oObj:GetCurriculum( "MSALPHA", HttpSession->cCurricCpf, HttpSession->cCurricPass, 1 )

			HttpSession->GetCurriculum 	:= {oObj:oWSGetCurriculumRESULT:oWSCURRIC1}
			HttpSession->GETTABLES 		:= {oObj:oWSGetCurriculumRESULT:oWSCURRIC2}

			If oObj:GetConfigField('SQG')
				/*  
					Cada objeto contem 2 caracteres S ou N 
					Primeiro caractere se e ou não obrigatorio S ou N
					Segundo caracter se e ou não visual na tela S ou N     
				*/
            	HttpSession->oConfig	:= oObj:OWSGETCONFIGFIELDRESULT
			EndIf
			
			If AllTrim(HttpPost->cCurricPass) == "654321"
	           HttpPost->cScript := "<script>alert('STR0001')</script>" //"Troque sua senha de acesso."
    	    EndIf

			cHtml += ExecInPage( "PWSR010" )

		Else
			HttpSession->cCurricCpf := ""
			Return RHALERT( "", STR0002, STR0003, "W_PWSR000.APW" ) //"Portal Candidato"###"CPF ou Senha invalido."

		EndIf
	Else
		Return RHALERT( "", STR0002, STR0004, "W_PWSR000.APW" ) //"Portal Candidato"###"CPF deve ser informado."

	EndIf

WEB EXTENDED END

Return cHtml

/*************************************************************/
/* Apresenta formulario para atualizacao					 */
/*************************************************************/
Web Function PWSR010B()	//GetCurriculum

Local cHtml := ""
Local oObj

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If !Empty(HttpPost->cCurricCpf)
		HttpSession->cCurricCpf 	:= HttpPost->cCurricCpf
		HttpSession->cCurricPass 	:= HttpPost->cCurricPass
	EndIf

	If !Empty( HttpSession->cCurricCpf ) //.And. !Empty( HttpSession->cCurricPass ) //Vem do PWSR000
		If oObj:GetCurriculum( "MSALPHA", HttpSession->cCurricCpf, HttpSession->cCurricPass, 2 )

			HttpSession->GetCurriculum 	:= {oObj:oWSGetCurriculumRESULT:oWSCURRIC1}
			HttpSession->GETTABLES 		:= {oObj:oWSGetCurriculumRESULT:oWSCURRIC2}
            
			If oObj:GetConfigField('SQG')
				/*  
					Cada objeto contem 2 caracteres S ou N 
					Primeiro caractere se e ou não obrigatorio S ou N
					Segundo caracter se e ou não visual na tela S ou N     
				*/
            	HttpSession->oConfig	:= oObj:OWSGETCONFIGFIELDRESULT
			EndIf
			
			If AllTrim(HttpSession->cCurricPass) == "654321"
	           HttpPost->cScript := "<script>alert('STR0001')</script>" //"Troque sua senha de acesso."
    	    EndIf

			cHtml += ExecInPage( "PWSR010" )

		Else
			HttpSession->cCurricCpf := ""
			Return RHALERT( "", STR0002, STR0003, "W_PWSR00D.APW" ) //"Portal Candidato"###"CPF ou Senha invalido."

		EndIf
	Else
		Return RHALERT( " ", STR0002, STR0004, "W_PWSR00D.APW" ) //"Portal Candidato"###"CPF deve ser informado."
	EndIf

WEB EXTENDED END

Return cHtml


//************************************************************/
// Gravacao do Curriculo (Todos os dados) - Grava e Sai
//************************************************************/
Web Function PWSR011()

Local cHtml	:= "W_PWSR010"
Local oObj	:= ""
Local nI 	:= 0

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW") 

	If HttpSession->GetCurriculum != Nil
		Pwsr010Atu( HttpSession->GetCurriculum[1] )
		If cPaisLoc == "MEX" .and. !ChkRfc(HttpSession->GetCurriculum[1]:cCPF, HttpSession->GetCurriculum[1]:cFirstName, HttpSession->GetCurriculum[1]:cSecondName, HttpSession->GetCurriculum[1]:cFirstSurname, HttpSession->GetCurriculum[1]:cSecondSurname, HttpSession->GetCurriculum[1]:dDateofBirth, HttpSession->GetCurriculum[1]:cGender, .T.)
			Return RHALERT( "", STR0002, STR0003, "W_PWSR00D.APW" ) //"Portal Candidato"###"CPF ou Senha invalido."
				//Return ExecInPage( "PWSR010" )
		Else
			//PARA GRAVAR DADOS DO USERFIELD
			For nI := 1 to len(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField)
				//SE TIPO FOR DATA, TRANSFORMA
				If HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserType == "D"
				   	HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag:= (&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ))
			    
				ElseIf HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserType == "N" 
				    
					If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
						&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ".", "" )
						&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ",", "." )
					Else
						&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ",", "" )
					EndIf
				
					HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag := (&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ))
				
				Else
					HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag := &( "HttpPost->"+Alltrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) )
				EndIf
			Next nI      
		    
			If oObj:SetCurriculum( "MSALPHA", HttpSession->GetCurriculum[1] )//oObj:oWSCURRIC1 )	//Dados Pessoais
				cHtml := "<script>window.location='htmls-rh/PwsrAgradece.htm';</script>"
				#ifdef SPANISH
					cHtml := "<script>window.location='htmls-rh/PwsrAgradece-esp.htm';</script>"
				#else
					#ifdef ENGLISH
						cHtml := "<script>window.location='htmls-rh/PwsrAgradece-ing.htm';</script>"
					#endif
				#endif
			Else
				Return RHALERT( "", STR0005, STR0006, "W_PWSR010.APW" ) //"Erro"###"Falha na gravação"
			EndIf
		EndIf
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END
Return cHtml

//************************************************************/
// Gravacao do Curriculo (Todos os dados) - Grava e Continua
//************************************************************/
Web Function PWSR011A()

Local cHtml	:= "W_PWSR010"
Local oObj	:= ""
Local nI 	:= 0

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		Pwsr010Atu( HttpSession->GetCurriculum[1] )
	
		//PARA GRAVAR DADOS DO USERFIELD
		For nI := 1 to len(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField)
			//SE TIPO FOR DATA, TRANSFORMA
			If HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserType == "D"
			   	HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag:= CtoD(&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ))
		    
			ElseIf HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserType == "N" 
			    
				If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
					&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ".", "" )
					&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ",", "." )
				Else
					&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ) := StrTran( &( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ), ",", "" )
				EndIf
			
				HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag := (&( "HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) ))
			Else
				HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserTag := &( "HttpPost->"+Alltrim(HttpSession->GetCurriculum[1]:oWsUserFieldS:oWsUserField[nI]:cUserName) )
			EndIf
		Next nI   

		If oObj:SetCurriculum( "MSALPHA", HttpSession->GetCurriculum[1] )//oObj:oWSCURRIC1 )	//Dados Pessoais
			Return RHALERT( "", STR0007, STR0008, "W_PWSR010B.APW") //"Curriculo"###"Gravacao realizada com sucesso."
		Else
			Return RHALERT( "", STR0005, STR0006, "W_PWSR010.APW" ) //"Erro"###"Falha na gravação"
		EndIf
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Historico na HttpSession / Oobj     */
/*************************************************************/
Web Function PWSR012()

Local cAux	:= ""
Local cHtml := ""
Local oObj
Local nx	:= 0
Local ny	:= 0
Local nZ	:= 0
Local cTipo	:= HttpPost->cTipo
Local nI	:= Val(HttpPost->nI)
Local cTag	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")
  
	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory, RHCURRICULUM_HISTORY():New() )
	
			nX := Len( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory )
	
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:cCompany  		:= HttpPost->cCompany
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:cFunctionCode	:= HttpPost->cFunctionCode
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:dAdmissionDate 	:= Ctod(HttpPost->dAdmissionDate)
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:dDismissalDate	:= Ctod(HttpPost->dDismissalDate)
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:cActivity		:= HttpPost->cActivity
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldHIST:oWsUserField )
				HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldHIST:oWsUserField
		 		cAux := &("HttpPost->cUserTag"+AllTrim(str(nY)))//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux	
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->cCompany 			:= ""
			HttpPost->cFunctionCode 	:= ""
			HttpPost->dAdmissionDate 	:= ""
			HttpPost->dDismissalDate 	:= ""
			HttpPost->cActivity 		:= ""
	
			For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldHIST:oWsUserField  )
				&("HttpPost->cUserTag"+AllTrim(str(nZ)))	:= 	""
			Next nZ
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Historico.focus();</script>"
	
			If ExistBlock("PRS10Hist")
				ExecBlock("PRS10Hist",.F.,.F.,{HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[nX]}) //Rdmake recebe ParamIxb
			EndIf
	
	    ElseIf cTipo == "2"	//Alteracao
	
	    	If Len( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory ) > 0
	
				HttpPost->cCompany 			:= HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:cCompany
				HttpPost->cFunctionCode 	:= HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:cFunctionCode
				HttpPost->dAdmissionDate 	:= HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:dAdmissionDate
				HttpPost->dDismissalDate 	:= HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:dDismissalDate
				HttpPost->cActivity 		:= HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:cActivity
	
				For nx := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldHIST:oWsUserField  )
					&("HttpPost->cUserTag"+AllTrim(str(nX)))	:= 	HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory[ni]:oWsUserFields:oWsUserField[nx]:cUserTag
				Next nx
	
		        aDel( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory, nI )
		        aSize( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory, len( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory ) - 1 )
	
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Historico.focus();</script>"
	
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory ) > 0
		        aDel( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory, nI )
		        aSize( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory, len( HttpSession->GetCurriculum[1]:OWSLISTOFHISTORY:oWsHistory ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Historico.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Curso na HttpSession / Oobj         */
/* Alterado por: 	Juliana Barros - 05/09/2005				 */
/*************************************************************/
Web Function PWSR013()

Local cAux		:= ""
Local cHtml 	:= ""
Local cTipo		:= HttpPost->cTipo
Local nx		:= 0
Local nY 		:= 0
Local nZ 		:= 0
Local nI		:= Val(HttpPost->nI)
Local oObj		:= ""
Local cDescEnt 	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses, RHCURRICULUM_COURSES():New() )
			nx := Len( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses )
	
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:dGraduationDate		:= Ctod(HttpPost->dGraduationDate3)
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cType		 		:= "4"
			
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cCourseCode 			:= HttpPost->cCourse3Code
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cCourseDesc 			:= IIF(Type("HttpPost->lCourse3Other") != "U", HttpPost->cC3Desc, HttpPost->cCourse3Desc)
	
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEntityCode 			:= IIF(Type("HttpPost->lEntity3Other") != "U", "", HttpPost->cEntity3Code)
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEntityDesc 			:= HttpPost->cEntity3Desc
	
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEmployCourse		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEmployDescCourse	:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEmployEntity		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:cEmployDescEntity	:= ""
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField )
				HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField
		 		cAux := &("HttpPost->cr"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField[nY]:cUserName)+AllTrim(str(nY)))	//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->dGraduationDate3	:= ""
			HttpPost->cCourse3Code	 	:= ""
			HttpPost->cCourse3Desc	 	:= ""		
			HttpPost->cC3Desc	   		:= ""		
			HttpPost->cEntity3Code	 	:= ""
			HttpPost->cEntity3Desc		:= ""		
	
			For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField  )
				&("HttpPost->cr"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField[nZ]:cUserName)+AllTrim(str(nZ)))	:= 	""
			Next nZ
	
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Curso.focus();</script>"
	
			If ExistBlock("PRS10Cour")
				ExecBlock("PRS10Cour",.F.,.F.,{HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nX], HttpPost->cCourse3Desc}) //Rdmake recebe ParamIxb
			EndIf
	
	   	ElseIf cTipo == "2"	//Alteracao
	
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses ) > 0
	            HttpPost->dGraduationDate3	:= Dtoc(HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:dGraduationDate)
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cCourseDesc)
					HttpPost->cCourse3Code 		:= ""
					HttpPost->cCourse3Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cCourseCode
					HttpPost->lCourse3Other		:= .T.
				Else		
					HttpPost->cCourse3Code 		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cCourseCode
					HttpPost->cCourse3Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[nI]:cCourseDesc
				EndIf
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cEntityDesc)
					HttpPost->cEntity3Code		:= ""
					HttpPost->cEntity3Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cEntityCode
					HttpPost->lEntity3Other		:= .T.
				Else
					HttpPost->cEntity3Code		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cEntityCode
					HttpPost->cEntity3Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:cEntityDesc
				EndIf
				
				For nx := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField  )
					&("HttpPost->cr"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCOUR:oWsUserField[nX]:cUserName)+AllTrim(str(nX)))	:= 	HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses[ni]:oWsUserFields:oWsUserField[nx]:cUserTag
				Next nx
	
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses, len( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Curso.focus();</script>"
	
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses ) > 0
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses, len( HttpSession->GetCurriculum[1]:oWsListOfCourses:oWsCourses ) - 1 )
		    EndIf
	
		    //Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Curso.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Qualificacao na HttpSession / Oobj  */
/* Alterado por: 	Juliana Barros - 05/09/2005				 */
/*************************************************************/
Web Function PWSR014()

Local cAux	:= ""
Local cHtml := ""
Local cTipo	:= HttpPost->cTipo
Local nx	:= 0
Local nY 	:= 0
Local nZ 	:= 0
Local nI	:= Val(HttpPost->nI)
Local oObj	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification, RHCURRICULUM_Qualification():New() )
			nx := Len( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification )
	
			HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nx]:cFactor  := HttpPost->cFactor1
			HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nx]:cDegree 	:= HttpPost->cDegree1
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField )
				HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField
		 		cAux := &("HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nY]:cUserName)+AllTrim(str(nY)))	//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->cFactor1	:= ""
			HttpPost->cDegree1 	:= ""
	
			For nX := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField  )
				&("HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nX]:cUserName)+AllTrim(str(nX)))	:= 	""
			Next nX
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Qualification.focus();</script>"
	
		   	If ExistBlock("PRS10Qual")
				ExecBlock("PRS10Qual",.F.,.F.,{HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[nX]}) //Rdmake recebe ParamIxb
			EndIf
	
		ElseIf cTipo == "2"	//Alteracao
	
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification ) > 0
	
	    		HttpPost->cFactor1 	:=	HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[ni]:cFactor
			 	HttpPost->cDegree1 	:=	HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[ni]:cDegree
	
				For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField  )
					&("HttpPost->"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nZ]:cUserName)+AllTrim(str(nZ)))	:= 	HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification[ni]:oWsUserFields:oWsUserField[nZ]:cUserTag
				Next nZ
	
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification, len( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification ) - 1 )
		    EndIf
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Qualification.focus();</script>"
	
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification ) > 0
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification, len( HttpSession->GetCurriculum[1]:oWsListOfQualification:oWSQualification ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Qualification.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Formacao na HttpSession / Oobj      */
/* Alterado por: 	Juliana Barros - 05/09/2005				 */
/*************************************************************/
Web Function PWSR015()

Local cAux		:= ""
Local cHtml 	:= ""
Local cTipo		:= HttpPost->cTipo
Local nx		:= 0
Local nY 		:= 0
Local nZ 		:= 0
Local nI		:= Val(HttpPost->nI)
Local oObj		:= ""
Local cDescEnt 	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation, RHCURRICULUM_Graduation():New() )
			nx := Len( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation )
	
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:dGraduationDate  	:= Ctod(HttpPost->dGraduationDate1)
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cType	 			:= "1"
	
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cCourseCode 		:= HttpPost->cCourse1Code
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cCourseDesc 		:= IIF(Type("HttpPost->lCourse1Other") != "U", HttpPost->cC1Desc, HttpPost->cCourse1Desc)
	
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEntityCode 		:= IIF(Type("HttpPost->lEntity1Other") != "U", "", HttpPost->cEntity1Code)
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEntityDesc 		:= HttpPost->cEntity1Desc
			
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cGrade 			:= HttpPost->cGrade1
	
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEmployCourse		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEmployDescCourse	:= ""
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEmployEntity		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:cEmployDescEntity	:= ""
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField )
				HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField
		 		cAux := &("HttpPost->ac" + AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField[nY]:cUserName) + AllTrim(STR(nY)))	//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->dGraduationDate1	:= ""
			HttpPost->cGrade1		 	:= ""
			HttpPost->cCourse1Code		:= ""
			HttpPost->cCourse1Desc		:= ""
			HttpPost->cC1Desc	   		:= ""
			HttpPost->cEntity1Code		:= ""
			HttpPost->cEntity1Desc		:= ""
			
			For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField  )
				&("HttpPost->ac"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField[nZ]:cUserName)+AllTrim(str(nZ)))	:= 	""
			Next nZ
	
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Formacao.focus();</script>"
	
			If ExistBlock("PRS10Grad")
				ExecBlock("PRS10Grad",.F.,.F.,{HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nX], HttpPost->cCourse1Desc}) //Rdmake recebe ParamIxb
			EndIf
	
		ElseIf cTipo == "2"	//Alteracao
	
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation ) > 0
	   	       	HttpPost->dGraduationDate1 	:= Dtoc(HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:dGraduationDate)
				HttpPost->cGrade1 			:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cGrade
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cCourseDesc)
					HttpPost->cCourse1Code 		:= ""
					HttpPost->cCourse1Desc		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cCourseCode
					HttpPost->lCourse1Other		:= .T.
				Else		
					HttpPost->cCourse1Code 		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cCourseCode
					HttpPost->cCourse1Desc		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[nI]:cCourseDesc
				EndIf
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cEntityDesc)
					HttpPost->cEntity1Code		:= ""
					HttpPost->cEntity1Desc		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cEntityCode
					HttpPost->lEntity1Other		:= .T.
				Else
					HttpPost->cEntity1Code		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cEntityCode
					HttpPost->cEntity1Desc		:= HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:cEntityDesc
				EndIf
			
				For nX := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField  )
					&("HttpPost->ac"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldGRAD:oWsUserField[nX]:cUserName)+AllTrim(str(nX)))	:= 	HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation[ni]:oWsUserFields:oWsUserField[nx]:cUserTag
				Next nX
	
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation, len( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation ) - 1 )
		    EndIf
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Formacao.focus();</script>"
			
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation ) > 0
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation, len( HttpSession->GetCurriculum[1]:oWsListOfGraduation:oWSGraduation ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Formacao.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Idioma na HttpSession / Oobj        */
/* Alterado por: 	Juliana Barros - 05/09/2005				 */
/*************************************************************/
Web Function PWSR016()

Local cAux		:= ""
Local cHtml 	:= ""
Local cTipo		:= HttpPost->cTipo
Local nx		:= 0
Local nY 		:= 0
Local nZ 		:= 0
Local nI		:= Val(HttpPost->nI)
Local oObj		:= ""
Local cDescEnt 	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages, RHCURRICULUM_Languages():New() )
			nx := Len( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages )
	
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:dGraduationDate  	:= Ctod(HttpPost->dGraduationDate4)
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cType	 			:= "3"
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cGrade	 			:= HttpPost->cGrade4
	
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cCourseCode 			:= HttpPost->cCourse4Code
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cCourseDesc			:= IIF(Type("HttpPost->lCourse4Other") != "U", HttpPost->cC4Desc, HttpPost->cCourse4Desc)
	
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEntityCode			:= IIF(Type("HttpPost->lEntity4Other") != "U", "", HttpPost->cEntity4Code)
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEntityDesc			:= HttpPost->cEntity4Desc
			
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEmployCourse		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEmployDescCourse	:= ""
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEmployEntity		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:cEmployDescEntity	:= ""
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField )
				HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField
		 		cAux := &("HttpPost->id"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField[nY]:cUserName)+AllTrim(str(nY)))	//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->dGraduationDate4	:= ""
	        HttpPost->cGrade4			:= ""
			HttpPost->cCourse4Code		:= ""
			HttpPost->cCourse4Desc		:= ""
			HttpPost->cC4Desc	   		:= ""		
			HttpPost->cEntity4Code		:= ""
			HttpPost->cEntity4Desc		:= ""
	
			For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField  )
				&("HttpPost->id"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField[nZ]:cUserName)+AllTrim(str(nZ)))	:= 	""
			Next nZ
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Idioma.focus();</script>"
	
			If ExistBlock("PRS10Lang")
				ExecBlock("PRS10Lang",.F.,.F.,{HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nX], HttpPost->cCourse4Desc}) //Rdmake recebe ParamIxb
			EndIf
	
		ElseIf cTipo == "2"	//Alteracao
	
			If Len( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages ) > 0
		        HttpPost->dGraduationDate4 	:= Dtoc(HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nI]:dGraduationDate)
				HttpPost->cGrade4 			:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nI]:cGrade		
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cCourseDesc)
					HttpPost->cCourse4Code 		:= ""
					HttpPost->cCourse4Desc		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cCourseCode
					HttpPost->lCourse4Other		:= .T.
				Else		
					HttpPost->cCourse4Code 		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cCourseCode
					HttpPost->cCourse4Desc		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[nI]:cCourseDesc
				EndIf
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cEntityDesc)
					HttpPost->cEntity4Code		:= ""
					HttpPost->cEntity4Desc		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cEntityCode
					HttpPost->lEntity4Other		:= .T.
				Else
					HttpPost->cEntity4Code		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cEntityCode
					HttpPost->cEntity4Desc		:= HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:cEntityDesc
				EndIf			
	
				For nX := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField  )
					&("HttpPost->id"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldLang:oWsUserField[nX]:cUserName)+AllTrim(str(nX)))	:= 	HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages[ni]:oWsUserFields:oWsUserField[nx]:cUserTag
				Next nX
	
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages, len( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages ) - 1 )
		    EndIf
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Idioma.focus();</script>"
	
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages ) > 0
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages, len( HttpSession->GetCurriculum[1]:oWsListOfLanguages:oWSLanguages ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Idioma.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Manutencao de Item de Certificacao na HttpSession / Oobj  */
/* Alterado por: 	Juliana Barros - 05/09/2005				 */
/*************************************************************/
Web Function PWSR017()

Local cAux		:= ""
Local cHtml 	:= ""
Local cTipo		:= HttpPost->cTipo
Local nx		:= 0
Local nY 		:= 0
Local nZ		:= 0
Local nI		:= Val(HttpPost->nI)
Local nPos		:= 0
Local oObj		:= ""
Local cDescEnt 	:= ""

WEB EXTENDED INIT cHtml

	oObj := WSRHCURRICULUM():New()
	WsChgURL(@oObj,"RHCURRICULUM.APW")

	If HttpSession->GetCurriculum != Nil
		If cTipo == "1"	//Inclusao
			aAdd( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification, RHCURRICULUM_Certification():New())		
			nx := Len( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification )
	
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:dGraduationDate		:= Ctod(HttpPost->dGraduationDate2)
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cType	 			:= "2"
	
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cCourseCode	 		:= HttpPost->cCourse2Code
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cCourseDesc	 		:= IIF(Type("HttpPost->lCourse2Other") != "U", HttpPost->cC2Desc, HttpPost->cCourse2Desc)
	
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEntityCode			:= IIF(Type("HttpPost->lEntity2Other") != "U", "" , HttpPost->cEntity2Code)
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEntityDesc			:= HttpPost->cEntity2Desc
	
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEmployCourse		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEmployDescCourse	:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEmployEntity		:= ""
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:cEmployDescEntity	:= ""
	
		  	//Campos Usuario
			HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nx]:oWsUserFields := RHCURRICULUM_ARRAYOFUSERFIELD():New()
	
			For nY := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField )
				HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nX]:oWsUserFields:oWsUserField := HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField
		 		cAux := &("HttpPost->ct"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nY]:cUserName)+AllTrim(str(nY)))	//cTag
				cAux :=	strtran( cAux, "<", "" )
				cAux :=	strtran( cAux, ">", "" )	
				If Len( cAux ) >= 18225
					cAux := SubStr( cAux, 1, 18225 )
				EndIf
				HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nX]:oWsUserFields:oWsUserField[nY]:cUserTag 		:= cAux
			Next nY
	
	        //Limpar conteudo para nova inclusao
		  	HttpPost->dGraduationDate2	:= ""
			HttpPost->cCourse2Code	 	:= ""
			HttpPost->cCourse2Desc	 	:= ""
			HttpPost->cC2Desc	 		:= ""		
			HttpPost->cEntity2Code	 	:= ""		
			HttpPost->cEntity2Desc	 	:= ""
	
			For nZ := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField  )
				&("HttpPost->ct"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nZ]:cUserName)+AllTrim(str(nZ)))	:= 	""
			Next nZ
	
			//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Certificacao.focus();</script>"
	
			If ExistBlock("PRS10Cert")
				ExecBlock("PRS10Cert",.F.,.F.,{HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nX], HttpPost->cCourse2Desc}) //Rdmake recebe ParamIxb
			EndIf
	
		ElseIf cTipo == "2"	//Alteracao
	
			If Len( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification ) > 0
		        HttpPost->dGraduationDate2 	:= Dtoc(HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:dGraduationDate)
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cCourseDesc)
					HttpPost->cCourse2Code 		:= ""
					HttpPost->cCourse2Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cCourseCode
					HttpPost->lCourse2Other		:= .T.
				Else		
					HttpPost->cCourse2Code 		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cCourseCode
					HttpPost->cCourse2Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[nI]:cCourseDesc
				EndIf
				
				If Empty(HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cEntityDesc)
					HttpPost->cEntity2Code		:= ""
					HttpPost->cEntity2Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cEntityCode
					HttpPost->lEntity2Other		:= .T.
				Else
					HttpPost->cEntity2Code		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cEntityCode
					HttpPost->cEntity2Desc		:= HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:cEntityDesc
				EndIf
				
				For nX := 1 To Len( HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField  )
					&("HttpPost->ct"+AllTrim(HttpSession->GetCurriculum[1]:oWsUserFieldCert:oWsUserField[nX]:cUserName)+AllTrim(str(nX)))	:= 	HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification[ni]:oWsUserFields:oWsUserField[nx]:cUserTag
				Next nX
	
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification, len( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification ) - 1 )
		    EndIf
	
	 		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Certificacao.focus();</script>"
	
	    ElseIf cTipo == "3"	//Exclusao
	    	If Len( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification ) > 0
		        aDel( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification, nI )
		        aSize( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification, len( HttpSession->GetCurriculum[1]:oWsListOfCertification:oWSCertification ) - 1 )
		    EndIf
	
	   		//Reposiciona o foco no Botao incluir apos clicar
			HttpPost->cScript := "<script>form10.Incluir_Certificacao.focus();</script>"
	
	    EndIf
	
		Return ExecInPage( "PWSR010" )
	Else
		Return RHALERT( " ", STR0002, STR0010, "W_PWSR00C.APW" ) //"Portal Candidato"###"Sua sessão expirou. Clique em Voltar para ser redirecionado para a página principal."
	EndIf

WEB EXTENDED END


/*************************************************************/
/* Atualiza Dados Pessoais da Session com Post 		         */
/*************************************************************/
Static Function Pwsr010Atu( oObj )

Local nx 			:= 0
Local ny 			:= 0
Local aCurricClass 	:= {}

aCurricClass 	:= ClassDataArr(oObj)	//Seta ponteiro do array no objeto

For nx := 1 To Len(HttpPost->aPost)
	ny := Ascan(aCurricClass, {|x| x[1] == HttpPost->aPost[nx] })
	If ny > 0

		If Left(HttpPost->aPost[nx],1) == "D"
			aCurricClass[ny][2] := Ctod(&("HttpPost->"+HttpPost->aPost[nx]))
			&("HttpSession->GetCurriculum[1]:"+HttpPost->aPost[nx]) := Ctod(&("HttpPost->"+HttpPost->aPost[nx]))
		ElseIf Left(HttpPost->aPost[nx],1) == "N"

			If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
				&( "HttpPost->" + HttpPost->aPost[nx] ) := StrTran( &( "HttpPost->" + HttpPost->aPost[nx] ), ".", "" )
				&( "HttpPost->" + HttpPost->aPost[nx] ) := StrTran( &( "HttpPost->" + HttpPost->aPost[nx] ), ",", "." )
			Else
				&( "HttpPost->" + HttpPost->aPost[nx] ) := StrTran( &( "HttpPost->" + HttpPost->aPost[nx] ), ",", "" )
			EndIf

			aCurricClass[ny][2] := Val(&("HttpPost->"+HttpPost->aPost[nx])	)
			&("HttpSession->GetCurriculum[1]:"+HttpPost->aPost[nx]) := Val(&("HttpPost->"+HttpPost->aPost[nx]))
		Else
			aCurricClass[ny][2] := &("HttpPost->"+HttpPost->aPost[nx])
			&("HttpSession->GetCurriculum[1]:"+HttpPost->aPost[nx]) := &("HttpPost->"+HttpPost->aPost[nx])
		EndIf

	EndIf
Next nx

Return Nil


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³RetUserFields³ Autor ³ Mauricio MR	      ³ Data ³ 04/09/09 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Identifica e trata inicializacao dos campos do formulario   ³
³          ³para alimentacao do curriculo.                              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

Function RetUserFields(;
						xVar,	; //01 - Campo do formulario
						m		; //02 - Posicao do campo na estrutura do webservice do curriculo
					   )
Local lNil	:= .F.
Local xRet:= ''  

If xVar == Nil 
    lNil:= .T.
	If HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'D'
       xVar:= Ctod(Space(8))
    ElseIf HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'N'
             
      	If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
			xVar  := StrTran( HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag , ".", "" )
			xVar  := StrTran(xVar , ",", "." )
		Else
			xVar  := StrTran( HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag , ",", "" )
		EndIf
       
    Else 
		xVar:= ''    
    Endif
Else    
	xVar:= xVar
Endif    


If ( Empty(HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag ) )
	If Empty(xVar)
		xRet:= Alltrim(xVar)
	Else 
	    IF HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'D'
		   If( Len(xVar)<8 )
		          	xRet:=xVar
		   Else 
		         	xRet:=StoD(xVar)
		   Endif 
		ElseIF  HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'N'
	    
	    	If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
				xRet  := StrTran( xVar , ",", "" )
				xRet  := StrTran(xRet , ".", "," )
			Else
				xRet  := StrTran( xVar , ",", "" )  
			Endif	
		                     
			xRet:=AllTrim(xVar)
		Else 
			xRet:=AllTrim(xVar)
		Endif   
	Endif         
Else
    IF HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'D'
	    If( len(HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag) < 8 )
				xRet:=HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag 
		Else
				IF lNil
					xRet:=Stod(HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag) 
				Else 
					xRet:=HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag 
				Endif	
        Endif
    ElseIF HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserType == 'N'
	    
	    	If (Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT") .And. cPaisLoc <> "MEX"
				xRet  := StrTran( HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag , ",", "" )
				xRet  := StrTran(xRet , ".", "," )
			Else
				xRet  := StrTran( HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag , ",", "" )
			EndIf                                                                        
		
			xRet:=Val(AllTrim(HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag))
    Else 
       	xRet:=AllTrim(HttpPost->GetCurriculum[1]:oWsUserFields:oWsUserField[m]:cUserTag)
    Endif    
Endif  
Return xRet
