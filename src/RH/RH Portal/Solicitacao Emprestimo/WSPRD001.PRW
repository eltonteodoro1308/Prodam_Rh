#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Ap5Mail.ch"

User Function WSPRD001()
Return

WSSTRUCT TCreditBrowse
	WSDATA ValMax				AS Float 				OPTIONAL
ENDWSSTRUCT

WSSERVICE RHCredit DESCRIPTION "Solicitação de Empréstimo"
	WSDATA WsNull               AS String
	WSDATA Branch				AS String
	WSDATA Registration			AS String
	WSDATA DescCredit			AS String
	WSDATA ValCredit			AS String
	WSDATA CreditBrowse   		As TCreditBrowse
	
	WSMETHOD BrowseCredit		DESCRIPTION "Método de consulta da margem de empréstimo"
	WSMETHOD SendCredit			DESCRIPTION "Método de envio da solicitação de empréstimo"
ENDWSSERVICE 

WSMETHOD BrowseCredit;
WSRECEIVE Branch, Registration;
WSSEND CreditBrowse;
WSSERVICE RHCredit
	Local aPerAtual			:= {}
	Local cFiltro
	Local cPerAnt
	Local cPdAux			:= SuperGetMV( "MV_VBSOLEM" , Nil , "" )
	Local cRotAux			:= fGetRotOrdinar()
	Local cSRDAlias			:= GetNextAlias()
varinfo("cPdAux",cPdAux)
varinfo("cRotAux",cRotAux)
varinfo("cSRDAlias",cSRDAlias)

	If Empty(cPdAux)
		SetSoapFault("CreditBrowse","Verba da Margem de empréstimo não cadastrada no parametro MV_VBSOLEM.")
		Return(.F.)	
	EndIf
	
	DbSelectArea("SRA")
	DbSeek(Self:Branch + Self:Registration)

	fGetPerAtual( @aPerAtual,xFilial("RCH", Self:Branch) , SRA->RA_PROCES , cRotAux )
varinfo("aPerAtual",aPerAtual)	
	cPerAnt := SubMesAno( aPerAtual[1,1] )
	
	cFiltro := " SRD.RD_FILIAL = '" + Self:Branch + "' AND "
	cFiltro	+= " SRD.RD_MAT = '" + Self:Registration + "' AND "
	cFiltro	+= " SRD.RD_PROCES = '" + SRA->RA_PROCES + "' AND "
	cFiltro	+= " SRD.RD_ROTEIR = '" + cRotAux + "' AND "
	cFiltro	+= " SRD.RD_PERIODO = '" + cPerAnt + "' AND "
	cFiltro	+= " SRD.RD_SEMANA = '" + aPerAtual[1,2] + "' AND "
	cFiltro	+= " SRD.RD_PD = '" + cPdAux + "' "
	cFiltro := "% " + cFiltro + " %"
	
	Self:CreditBrowse:= WSClassNew("TCreditBrowse")	   
	
	BEGINSQL alias cSRDAlias
			SELECT SRD.RD_VALOR
		      FROM %table:SRD% SRD
		     WHERE %exp:cFiltro% 
	           AND SRD.%notDel% 
	ENDSQL
varinfo("query",getlastquery()[2])	
	If (cSRDAlias)->( !Eof())
		::CreditBrowse:ValMax := (cSRDAlias)->RD_VALOR
	Else
		SetSoapFault("CreditBrowse","Margem de empréstimo não encontrada.")
		Return(.F.)	
	EndIf
	
	(cSRDAlias)->(DbCloseArea()) 

Return .T. 

WSMETHOD SendCredit;
WSRECEIVE Branch, Registration,ValCredit,DescCredit;
WSSEND WSNull;
WSSERVICE RHCredit
	Local aAreaRD0
	Local cMailTo			:= SuperGetMV( "MV_EMSOLEM" , Nil , "" )
	Local cMailCC			:= ""
	Local cMailConta		:= ""
	Local cMailSenha		:= ""
	Local cMailServer		:= ""
	Local cBody				:= ""
	Local lSSL				:= SuperGetMv("MV_RELSSL")
	Local lTLS				:= SuperGetMv("MV_RELTLS")
	Local lOk				:= .T.
	Local lAutentic			:= .T.
	Local nAt				:= 0
	Local nErro				:= 0
	Local oMessage			:= NIL
	Local nPort				:= 0	

	If !Empty(AllTrim(GetMV("MV_RHCONTA"))) .And. !Empty(AllTrim(GetMV("MV_RHSENHA"))) .And. !Empty(AllTrim(GetMV("MV_RHSERV")))
		cMailConta := AllTrim(GetMV("MV_RHCONTA"))
		cMailSenha := AllTrim(GetMV("MV_RHSENHA"))
		cMailServer:= AllTrim(GetMV("MV_RHSERV"))
		lMailAuth  := SuperGetMv("MV_RHAUTEN")
	Else
		cMailConta := AllTrim(GetMV("MV_RELACNT"))
		cMailSenha := AllTrim(GetMV("MV_RELPSW"))
		cMailServer:= AllTrim(GetMV("MV_RELSERV"))
		lMailAuth  := SuperGetMv("MV_RELAUTH")
	EndIf

	If Empty(cMailConta) .or. Empty(cMailSenha) .or. Empty(cMailServer)
		SetSoapFault("SendCredit","Dados para envio do e-mail não foram definidos. Consulte o administrador.")
		Return(.F.)	
	EndIf

	nAt	  :=  At(':' , cMailServer)
	
	// Para autenticacao, a porta deve ser enviada como parametro[nSmtpPort] na chamada do método oMail:Init().
	// A documentacao de TMailManager pode ser consultada por aqui : http://tdn.totvs.com/x/moJXBQ
	If ( nAt > 0 )
		cServer		:= SubStr(cMailServer , 1 , (nAt - 1) )
		nPort		:= Val(AllTrim(SubStr(cMailServer , (nAt + 1) , Len(cMailServer) )) )
	Else
		cServer		:= cMailServer
	EndIf

	oMailManager := TMailManager():New()
	
	If lTLS
		oMailManager:SetUseTLS(.T.)
	EndIf
	
	If lSSL
		oMailManager:SetUseSSL(.T.)
	EndIf
	
	If (nErro := oMailManager:Init( "", cServer, cMailConta, cMailSenha, 0, nPort )) != 0
		cErro := oMailManager:GetErrorString( nErro )
		SetSoapFault("SendCredit","00001 - Falha no servidor de e-mail. " + cErro )
		Return(.F.)		
	EndIf
	
   	If (nErro := oMailManager:SMTPConnect()) != 0
   		cErro := oMailManager:GetErrorString( nErro )
		SetSoapFault("SendCredit","00002 - Falha no servidor de e-mail. " + cErro )
		Return(.F.)
   	EndIf
   	
   	If lMailAuth
   	    If (nErro := oMailManager:SMTPAuth(cMailConta,cMailSenha)) != 0
   	    	cErro := oMailManager:GetErrorString( nErro )
   	    	SetSoapFault("SendCredit","00003 - Falha no servidor de e-mail. " + cErro )
   	    	Return(.F.)
   	    EndIf
   	EndIf

   	//--Monta corpo do e-mail
    DbSelectArea("SRA")
    DbSetOrder(1)
    DbSeek(Self:Branch+Self:Registration)
    
	aAreaRD0 := GetArea()
	dbSelectArea("RD0")
	RD0->( dbSetOrder(6) )	//RD0_FILIAL+RD0_CIC+RD0_CODIGO
	RD0->( dbSeek(xFilial("RD0")+SRA->RA_CIC) )
	cMailCC := RD0->RD0_EMAIL
	RestArea(aAreaRD0)	

	cBody := "<html><style type='text/css'><!-- .texto {font-family: Arial, Helvetica, sans-serif;font-size: 12px;"
	cBody += "color: #333333;text-decoration: none;font-weight: normal;}"
	cBody += ".titulo {	font-family: Arial, Helvetica, sans-serif;font-size: 16px;"
	cBody += "color: #19167D;text-decoration: none;font-weight: bold;} --> </style><body>"
	cBody += "<table width='550' border='0' cellpadding='0' cellspacing='0'><tr>"
	cBody += "<td height='263' align='left' valign='top' class='texto'><p class='titulo'><strong><font size='3'>"
	cBody += "Solicito empréstimo conforme detalhes abaixo:"
	cBody += "</font></strong></p><br><br>"
    cBody += "<b>Solicitante:</b> " + SRA->RA_NOME + "<br><br>"
    cBody += "<b>Valor solicitado:</b> " + Self:ValCredit + "<br><br>"
    cBody += "<b>Observações: </b> " + Self:DescCredit
	cBody += "</body></html>"
   	
   	oMessage := TMailMessage():New
   	
   	oMessage:Clear()
   	
   	oMessage:cFrom		:= 'Workflow RH <'+cMailConta+'>' 
   	oMessage:cTo		:= cMailto
   	oMessage:cCc		:= cMailCC
   	oMessage:cBcc		:= ''
   	oMessage:cSubject	:= 'Solicitacao de Emprestimo'
   	oMessage:cBody		:= cBody
   	 
   	If (nErro := oMessage:Send(oMailManager)) != 0
   		cErro := oMailManager:GetErrorString( nErro )
    	SetSoapFault("SendCredit","00004 - Falha no envio do e-mail. " + cErro )
    	Return(.F.)
   	EndIf

   	If (nErro := oMailManager:SMTPDisconnect()) != 0
   		cErro := oMailManager:GetErrorString( nErro )
   		Conout( "WSPRD001 - Falha na desconexão do servidor de e-mail - " + cErro )
   	EndIf   	

Return .T.