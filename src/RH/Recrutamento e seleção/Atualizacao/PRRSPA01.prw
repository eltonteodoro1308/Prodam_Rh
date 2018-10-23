#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "Topconn.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRRSPA01
Cadastro de requisição de pessoal
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function PRRSPA01()
Local oBrowse := FwMBrowse():New()

oBrowse:SetAlias("ZZJ")
oBrowse:SetDescription("Requisição de pessoal") 
oBrowse:DisableDetails() 

//Legendas para o browse
oBrowse:Addlegend( "ZZJ_STATUS=='1'"	, "BR_BRANCO"   	,"RP Em manutenção")
oBrowse:Addlegend( "ZZJ_STATUS=='2'"	, "BR_AMARELO"   	,"RP Em aprovação")
oBrowse:Addlegend( "ZZJ_STATUS=='3'"	, "BR_LARANJA"   	,"RP Reprovada")
oBrowse:Addlegend( "ZZJ_STATUS=='4'"	, "BR_VERDE"		,"RP Aguardando efetivação") 
oBrowse:Addlegend( "ZZJ_STATUS=='6'"	, "BR_PRETO"		,"RP Cancelada")
oBrowse:Addlegend( "U_PR20A01V()"		, "BR_VIOLETA"	,"RP e Vaga Cancelada")
oBrowse:Addlegend( "ZZJ_STATUS=='5'"	, "BR_VERMELHO"	,"RP Finalizada")

// Ativação da Classe
oBrowse:Activate()

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Rotina de definição do menu
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" ACTION "AxPesqui" OPERATION 1	ACCESS 0 		
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.PRRSPA01" OPERATION 2 ACCESS 0 		
ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.PRRSPA01" OPERATION 3	ACCESS 0 		
ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.PRRSPA01"	OPERATION 4	ACCESS 0
ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.PRRSPA01"	OPERATION 5	ACCESS 0 
ADD OPTION aRotina TITLE "Consulta aprovação" ACTION "U_PR20A01C"	OPERATION 6 ACCESS 0	
ADD OPTION aRotina TITLE "Cancela aprovação" ACTION "U_PR20A01X"	OPERATION 7 ACCESS 0
ADD OPTION aRotina TITLE "Envia aprovação" ACTION "U_PR20A01E"	OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE "Efetivar Requisição" ACTION "U_PR20A01F"	OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE "Impressão" ACTION "U_PR20A01I"	OPERATION 10 ACCESS 0
ADD OPTION aRotina TITLE "Legenda" ACTION "U_PR20A01L"	OPERATION 11 ACCESS 0		

Return(aRotina)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Rotina de definição do MODEL
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function ModelDef()
Local oStruZZJ 	:= FWFormStruct(1, "ZZJ")  
Local bPosVld 	:= {|oMld| PR20A01POS(oMld)}
Local oModel   	:= MPFormModel():New( "P20A01MD", /*bPreVld*/, bPosVld , /*bCommit*/ , /*bCancel*/ )
													
oModel:AddFields("ZZJMASTER", /*cOwner*/, oStruZZJ)
oModel:SetPrimaryKey({"ZZJ_FILIAL","ZZJ_NUMREQ"})
oModel:SetDescription("Requisição de pessoal")

Return oModel
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Rotina de definição do VIEW
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum  
/*/
//---------------------------------------------------------------------------------------
Static Function ViewDef()
Local oView    := FWFormView():New()
Local oStruZZJ := FWFormStruct(2, "ZZJ")  
Local oModel   := FWLoadModel("PRRSPA01")           	

oView:SetModel(oModel)
oView:AddField("VIEW_ZZJ", oStruZZJ, "ZZJMASTER")

oView:CreateHorizontalBox("SUPERIOR", 100)
oView:SetOwnerView("VIEW_ZZJ", "SUPERIOR")

Return oView
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01POS
Rotina de pos-validação 
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR20A01POS(oModel)
LOCAL lRet		:= .T.
LOCAL cStRP	:= FWFLDGET("ZZJ_STATUS")
LOCAL lAumQua	:= FWFLDGET("ZZJ_QUADRO")
LOCAL lSubEmp	:= FWFLDGET("ZZJ_SUBST")
Local nOper	:= oModel:GETOPERATION()

// Valida alteração
IF cStRP!="1" .AND. nOper == 4
	MSGALERT("Só é permitido alterar a requisição com status 'Em manutenção'!")
	lRet:= .F.
ENDIF

// Valida exclusão
IF cStRP!="1" .AND. nOper == 5
	MSGALERT("Só é permitido excluir a requisição com status 'Em manutenção'!")
	lRet:= .F.
ENDIF

// Valida se os campos de aumento de quadro e substituição estão ativos
IF lAumQua .AND. lSubEmp
	MSGALERT("Não é permitido marcar a opção de aumento de quadro e substituição de funcionarios na mesma requisição!")
	lRet:= .F.
ENDIF



Return lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01L
Rotina de exibição da Legenda
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user Function PR20A01L()
Local oLegenda  :=  FWLegend():New()

oLegenda:Add("","BR_BRANCO"   	,"RP Em manutenção")
oLegenda:Add("","BR_AMARELO"   	,"RP Em aprovação")
oLegenda:Add("","BR_LARANJA"   	,"RP Reprovada")
oLegenda:Add("","BR_VERDE"		,"RP Aguardando efetivação") 
oLegenda:Add("","BR_VERMELHO"	,"RP Finalizada")
oLegenda:Add("","BR_PRETO"		,"RP Cancelada")
oLegenda:Add("","BR_VIOLETA"	,"RP e Vaga Cancelada")
	                                                         
oLegenda:Activate()
oLegenda:View()
oLegenda:DeActivate()

Return( .T. )
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01V
Consulta se a vaga esta ativa ou cancelada
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user Function PR20A01V()
Local aArea:= GETAREA()
Local cTab	:= ""
Local lRet	:= .F.

// No caso de requisição encerrada checa se a vaga está ativa
IF ZZJ->ZZJ_STATUS=='5'
	cTab:= GetNextAlias()
	BeginSql Alias cTab
		SELECT * FROM %TABLE:SQS% SQS  
		WHERE QS_FILIAL=%xfilial:SQS%
		AND QS_XNUMREQ=%exp:ZZJ->ZZJ_NUMREQ%
		AND SQS.D_E_L_E_T_ =''
	EndSql
	//GETLastQuery()[2]
	
	(cTab)->(dbSelectArea((cTab)))                    
	(cTab)->(dbGoTop())                               	
	IF (cTab)->(!EOF()) 
		lRet:= (cTab)->QS_NRVAGA == 0
	ENDIF
	(cTab)->(dbCloseArea())
ENDIF				

RESTAREA(aArea)
Return lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01E
Rotina que realiza o reenvio de aprovação
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function PR20A01E()
LOCAL aAprov	:= {} 
LOCAL aAuxApr	:= {} 
LOCAL nCnt		:= 0
LOCAL nPos		:= 0
LOCAL lAprPre	:= SUPERGETMV("PR_APRPRE",.T.,.F.)
LOCAL lAprCor	:= SUPERGETMV("PR_APRCOR",.T.,.F.)

IF ZZJ->ZZJ_STATUS == "1"
	IF MSGYESNO("Confirma o envio da requisição para aprovação ?")
		
		AADD(aAuxApr,ZZJ->ZZJ_MATGER)
		
		AADD(aAuxApr,ZZJ->ZZJ_MATDIR)

		IF lAprCor
			AADD(aAuxApr,ZZJ->ZZJ_MATCOR)
		ENDIF	

		AADD(aAuxApr,TRIM(SUPERGETMV("PR_MATGFD",.T.,"")))
		
		AADD(aAuxApr,TRIM(SUPERGETMV("PR_MATDAF",.T.,"")))
		
		IF lAprPre
			AADD(aAuxApr,TRIM(SUPERGETMV("PR_MATPRE",.T.,"")))
		ENDIF
			
		
		//Checa se tem aprovador duplicado
		FOR nCnt:= 1 TO LEN(aAuxApr)
			IF ASCAN(aAprov,{|x| x == aAuxApr[nCnt] }) == 0
				AADD(aAprov,aAuxApr[nCnt])
			ENDIF
		NEXT nCnt
		
		FOR nCnt:= 1 TO LEN(aAprov)
			IF !EMPTY(aAprov[nCnt])
				RECLOCK("ZZK",.T.)
					ZZK->ZZK_FILIAL	:= XFILIAL("ZZK")
					ZZK->ZZK_NUMREQ	:= ZZJ->ZZJ_NUMREQ
					ZZK->ZZK_MATAPR	:= aAprov[nCnt] 
					ZZK->ZZK_DEPTO 	:= POSICIONE("SRA",1,XFILIAL("SRA")+aAprov[nCnt],"RA_CC") 
					ZZK->ZZK_NOMAP 	:= POSICIONE("SRA",1,XFILIAL("SRA")+aAprov[nCnt],"RA_NOME")
					// Seta status para envio para o primeiro aprovador
					IF nCnt==1
						ZZK->ZZK_STATUS	:= "1"
					ENDIF	
				MSUNLOCK()
			ENDIF
		NEXT nCnt
		
		RECLOCK("ZZJ",.F.)
			ZZJ->ZZJ_STATUS:= "2"
		MSUNLOCK()
		
		U_PRRSPW01(1)
		
		MSGINFO("Envio para aprovação realizado com sucesso!")
	ENDIF
ELSE
	MSGALERT("Só é permitido enviar uma requisição para aprovação com status 'Em manutenção'!")
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01F
Rotina que efetiva a requisição e efetiva a vaga
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function PR20A01F()
LOCAL aAprov	:= {} 
LOCAL nCnt		:= 0
Local oModel 	:= nil
LOCAL aVgaAut	:= {}
Private cCadastro := 'Cadastro de Vagas'

IF ZZJ->ZZJ_STATUS == "4"
	IF MSGYESNO("Confirma a efetivação da requisição ?")
	
		RecLock("SQS",.T.)
		SQS->QS_VAGA		:= GetSxeNum("SQS","QS_VAGA")
		SQS->QS_DESCRIC	:= ZZJ->ZZJ_DESCRI		 
		SQS->QS_CC			:= ZZJ->ZZJ_DEPGER		 
		SQS->QS_FUNCAO	:= ZZJ->ZZJ_CARGO		 
		SQS->QS_NRVAGA	:= ZZJ->ZZJ_NRVAGA		 
		SQS->QS_DTABERT	:= DATE()				
		SQS->QS_VCUSTO	:= ZZJ->ZZJ_SALARI		
		SQS->QS_MATRESP	:= ZZJ->ZZJ_MATGER		
		SQS->QS_XNUMREQ	:= ZZJ->ZZJ_NUMREQ			
	  	SQS->( MsUnlock())
	  	
	  	ConfirmSX8()
	
		RecLock( "ZZJ", .F. )
	   	ZZJ->ZZJ_STATUS:=  "5"
	   	ZZJ->( MsUnlock())
	      		
		RSP100Alt("SQS",SQS->(RECNO()),4)
		
		MSGINFO("Efetivação realizada com sucesso!")	
	ENDIF
ELSE
	MSGALERT("Só é permitido efetivar a requisição com status 'Aguardando efetivação'!")
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01I
Rotina de impressão da requisição
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function PR20A01I()
local cDirTmp := GetTempPath()
lOCAL cDirHtml:= "" 
Local cHtmImp	:= ""

IF ZZJ->ZZJ_STATUS $ "4,5"
	If !ExistDir(cDirTmp)
		MSGALERT("Caminho não encontrado: "+cDirTmp)
	ELSE	
		cHtmImp+= ' <SCRIPT LANGUAGE="JavaScript">'
		cHtmImp+= ' window.print()'
		cHtmImp+= ' </SCRIPT>'	
			
		cDirHtml:= TRIM(cDirTmp)	
		IF RIGHT(cDirHtml,1)== "\"
			cDirHtml:= cDirHtml + ZZJ->ZZJ_NUMREQ + ".HTML"
			MemoWrite(cDirHtml, Decode64(ZZJ->ZZJ_HTMAPR)+CRLF+cHtmImp )
		ELSE
			cDirHtml:= cDirHtml +"\"+ ZZJ->ZZJ_NUMREQ + ".HTML"
			MemoWrite(cDirHtml, Decode64(ZZJ->ZZJ_HTMAPR)+CRLF+cHtmImp )			
		ENDIF	
		
		IF FILE(cDirHtml)
			ShellExecute( "Open", cDirHtml , "", "C:\", 1 )
		ELSE
			msgalert("Problema para gerar o relatório!")
		ENDIF			
	EndIf	
ELSE
	MSGALERT("Só é permitido imprimir a requisição com status 'Aguardando efetivação' ou 'Finalizada'!")
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01C
Rotina consulta aprovação
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION PR20A01C()
local oDlg			:= NIL
Local oPnltop		:= NIL
Local oPnl01		:= NIL
Local oPnl02		:= NIL
Local oPnl03		:= NIL 		                   
local aHeadAux	:= {} 
local aColsAux	:= {}
local aYesFields	:= {"ZZK_STATUS","ZZK_DEPTO","ZZK_MATAPR","ZZK_NOMAP","ZZK_DATLIB","ZZK_HORLIB"} 
Local oFont		:= NIL
Local cTab			:= GetNextAlias()
Local cQry			:= "" 
Local nUsado		:= 0  
Local nLin			:= 0 
LOCAL cUsrResp	:= ZZJ->ZZJ_NOMRES 
LOCAL cSituaca	:= "" 
LOCAL lBloq 		:= .F.
LOCAL cMsgObs		:= ""  
PRIVATE oGetD01	:= NIL

DBSELECTAREA("SX3")        
SX3->(DBSETORDER(1))
SX3->(DBSEEK("ZZK"))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "ZZK"
	IF Ascan(aYesFields,{|x| TRIM(x) == TRIM(SX3->X3_CAMPO) }) > 0 		
		Aadd(aHeadAux,{AllTrim(X3Titulo()),;
						TRIM(SX3->X3_CAMPO),;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						"",;
						SX3->X3_WHEN,;
						SX3->X3_VISUAL,;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})			
	ENDIF
SX3->(dbSkip())		
EndDo

For nCnt:= 1 TO len(aYesFields) 
	IF nCnt== 1
		cQry += " SELECT "+aYesFields[nCnt]+CRLF	
	ELSE
		cQry += " 			,"+aYesFields[nCnt]+CRLF	
	ENDIF						
NEXT nCnt

cQry+= "     		,COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZZK_OBS )),'') ZZK_OBS"+CRLF
cQry+= "     		,R_E_C_N_O_ AS RECZZK"+CRLF
cQry += " FROM "+RETSQLNAME("ZZK")+" ZZK"+CRLF
cQry += " WHERE ZZK_FILIAL='"+xfilial("ZZK")+"'"+CRLF
cQry += " 	AND ZZK_NUMREQ='"+ZZJ->ZZJ_NUMREQ+"'"+CRLF
cQry += " 	AND ZZK.D_E_L_E_T_=''"+CRLF
cQry += " ORDER BY R_E_C_N_O_"+CRLF

TcQuery cQry NEW ALIAS (cTab)

TCSETFIELD(cTab,"ZZK_DATLIB","D")

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
While (cTab)->(!Eof())        		
	nUsado:= len(aHeadAux)
	AADD(aColsAux,Array(nUsado+3))
	nLin:= len(aColsAux)   	       				
	For nCnt:= 1 TO nUsado 
		IF aHeadAux[nCnt][02] == "ZZK_STATUS"
		   Do Case
				Case EMPTY((cTab)->ZZK_STATUS)
					aColsAux[nLin][nCnt] := IIF(lBloq,"3",(cTab)->&(aHeadAux[nCnt][2])) 
				Case (cTab)->ZZK_STATUS == "1" 
					cSituaca := "Em Aprovação"
					aColsAux[nLin][nCnt] := (cTab)->&(aHeadAux[nCnt][2])
				Case (cTab)->ZZK_STATUS == "2"
					cSituaca := "Aprovada"
					aColsAux[nLin][nCnt] := (cTab)->&(aHeadAux[nCnt][2])
				Case (cTab)->ZZK_STATUS == "3"
					cSituaca := "Reprovada"
					lBloq := .T.
					aColsAux[nLin][nCnt] := (cTab)->&(aHeadAux[nCnt][2])
			EndCase			 	
		ELSE		 
			aColsAux[nLin][nCnt]:= (cTab)->&(aHeadAux[nCnt][2])
		ENDIF						
	NEXT nCnt    
	aColsAux[nLin][nUsado+1]:= (cTab)->ZZK_OBS
	aColsAux[nLin][nUsado+2]:= (cTab)->RECZZK
	aColsAux[nLin][nUsado+3]:= .F.					    	   	   	   
(cTab)->(dbSkip())	
End  
(cTab)->(dbCloseArea()) 

IF !EMPTY(aColsAux)	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE "Requisição de pessoal - Aprovação" From 109,95 To 400,800 OF oMainWnd PIXEL	

		oPnltop:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,15,.F.,.F. )
		oPnltop:Align := CONTROL_ALIGN_TOP
		
		@ 02,7 SAY "Requisição:" Of oPnltop FONT oBold PIXEL SIZE 46,9  
		@ 02,50 MSGET ZZJ->ZZJ_NUMREQ Picture "@"  When .F. PIXEL SIZE 38,9 Of oPnltop FONT oBold
		@ 02,103 SAY "Responsavel:" Of oPnltop PIXEL SIZE 50,9 FONT oBold 
		@ 02,150 MSGET cUsrResp Picture "@" When .F. of oPnltop PIXEL SIZE 103,9 FONT oBold


		oPnl01:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,15,.F.,.F. )
		oPnl01:Align := CONTROL_ALIGN_BOTTOM	
		
		oPnl02:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,30,.F.,.F. )
		oPnl02:Align := CONTROL_ALIGN_BOTTOM	
		
		oPnl03:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,12,.T.,.T. )
		oPnl03:Align := CONTROL_ALIGN_BOTTOM	

		@ 02,02 Say "Observação :" Of oPnl03 Pixel			
		@ 02,238 SAY "Situação:" Of oPnl03 PIXEL SIZE 52,9 
		@ 02,268 SAY cSituaca Of oPnl03 PIXEL SIZE 120,9 FONT oBold
		

		@ 5, 5 Get oMemo Var cMsgObs Memo Size 200, 145 WHEN .F. Of oPnl02 Pixel 
		oMemo:bRClicked := { || AllwaysTrue() }	  
		oMemo:align:= CONTROL_ALIGN_ALLCLIENT	
		
		@ 02,280 BUTTON "Reenviar" SIZE 35 ,10  FONT oDlg:oFont ACTION (PR20A01REN(nUsado)) Of oPnl01 PIXEL
		@ 02,320 BUTTON "Fechar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oPnl01 PIXEL
		  
		oGetD01:=MsNewGetDados():New(38,3,120,400,1,"AllwaysTrue","AllwaysTrue",,,,999,,,,oDlg,aHeadAux,aColsAux)
		oGetD01:oBrowse:bChange	:= {|| cMsgObs:= oGetD01:aCols[oGetD01:NAT][nUsado+1] , oMemo:Refresh() } 
		oGetD01:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
		oGetD01:LINSERT:= .F.
				
	ACTIVATE MSDIALOG oDlg CENTERED
ELSE
	Msgalert("Está Requisição não possui dados de aprovação!")	
ENDIF

RETURN 
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01REN
Rotina que realiza o reenvio de aprovação
@author  	Carlos Henrique
@since     	19/10/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
static function PR20A01REN(nUsado)
LOCAL nPosST:= GDFieldPos("ZZK_STATUS",oGetD01:AHEADER)

IF EMPTY(oGetD01:ACOLS[oGetD01:NAT][nPosST])
	msgalert('Não é permitido realizar o reenvio de aprovação para situação "Aguardando".')
Elseif oGetD01:ACOLS[oGetD01:NAT][nPosST]== "2"
	msgalert('Não é permitido realizar o reenvio de aprovação para situação "Aprovada".')
Elseif oGetD01:ACOLS[oGetD01:NAT][nPosST]== "3"
	msgalert('Não é permitido realizar o reenvio de aprovação para situação "Reprovada".')	
Else		
	IF msgyesno("Confirma o reenvio da aprovação ?")
		DBSelectArea("ZZK")
		ZZK->(DBGOTO(oGetD01:ACOLS[oGetD01:NAT][nUsado+2]))    
		IF ZZK->(!eof()) 
			IF !EMPTY(ZZK->ZZK_WFID)
				WFKillProcess(ZZK->ZZK_WFID) // Finaliza processo workflow anterior
			ENDIF
			RECLOCK("ZZK",.F.)
			ZZK->ZZK_STATUS	:= "1"	
			ZZK->ZZK_WF		:= ""
			ZZK->ZZK_WFID		:= ""
			MSUNLOCK()
		
		ENDIF	
		
		// Executa rotina de envio do workflow
		U_PRRSPW01(1)
		
		msginfo("Reenvio realizado com sucesso.")
	ENDIF
ENDIF

RETURN

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01X
Rotina de cancelamento da aprovação
@author  	Carlos Henrique
@since     	18/11/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function PR20A01X()
LOCAL oDlg		:= nil
LOCAL oPnl01	:= nil
LOCAL oPnl02	:= nil
LOCAL oMemo	:= nil
LOCAL lTudoOK	:= .T.
Private cMotExc:= ""

IF ZZJ->ZZJ_STATUS$"2,4"
	IF MSGYESNO("Confirma o cancelamento da aprovação ?")
		WHILE EMPTY(cMotExc)
			// Monta tela para informar o motivo do cancelamento
			DEFINE MSDIALOG oDlg TITLE "Esta requisição já foi submetida aprovação" FROM 0,0 TO 240,500 PIXEL
				oPnl01:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,20,.F.,.F. )
				oPnl01:Align := CONTROL_ALIGN_TOP
				@ 02,7 SAY "Informe o motivo do cancelamento da aprovação:" Of oPnl01  PIXEL SIZE 150,12  				

				oPnl02:= TPanel():New(0,0 ,'' ,oDlg , ,.T. ,.T. ,,,0,15,.F.,.F. )
				oPnl02:Align := CONTROL_ALIGN_BOTTOM
				
				@ 5, 5 Get oMemo Var cMotExc Memo Size 200, 145 Of oDlg Pixel 
				oMemo:bRClicked := { || AllwaysTrue() }	  
				oMemo:align:= CONTROL_ALIGN_ALLCLIENT	
													 
				DEFINE SBUTTON FROM 02,213 TYPE 1 ACTION (oDlg:End()) ENABLE OF oPnl02
			ACTIVATE MSDIALOG oDlg CENTER		
		
			IF EMPTY(cMotExc)
				IF Aviso("Atencao","Para o cancelamento é necessário informar o motivo, o que deseja fazer ?",{"Informar","Desistir"}) == 2
					MSGALERT("Cancelamento abortado!!")
					lTudoOK:= .F.
					EXIT
				ENDIF	
			ENDIF
		END	
		
		IF lTudoOK
			//Executa envio de e-mail
			U_PRRSPW01(3)
		
			DBSelectarea("ZZK")
			ZZK->(DBSetOrder(1))
			IF ZZK->(DBSeek(xfilial("ZZK")+ZZJ->ZZJ_NUMREQ))
				WHILE !ZZK->(EOF()) .AND. ZZK->(ZZK_FILIAL+ZZK_NUMREQ)==XFILIAL("ZZK")+ZZJ->ZZJ_NUMREQ
					RECLOCK("ZZK",.T.)
						DBDELETE()
					MSUNLOCK()			
				ZZK->(DBSKIP())
				END
			ENDIF	
					
			RECLOCK("ZZJ",.F.)
				ZZJ->ZZJ_STATUS:= "6"
			MSUNLOCK()
			
			MSGINFO("Cancelamento realizado com sucesso!")
		ELSE
			MSGALERT("Cancelamento não realizado!")	
		ENDIF
	ENDIF
ELSE
	MSGALERT("Só é permitido cancelar uma requisição com status 'Em aprovação'!")
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR20A01G
Gatilho ZZJ_CARGO
@author  	Carlos Henrique
@since     	18/11/2016
@version  	P.12.1.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER function PR20A01G(cCampo)
Local xRet
Local dDatRef

DBSELECTAREA("SQ3")
SQ3->(DBSETORDER(1))
IF SQ3->(DBSEEK(XFILIAL("SQ3")+M->ZZJ_CARGO))

	DBSELECTAREA("RBR")
	RBR->(DBSETORDER(1))	
	RBR->(DBSEEK(XFILIAL("RBR")+SQ3->Q3_TABELA))
	WHILE !RBR->(EOF()) .AND. RBR->(RBR_FILIAL+RBR_TABELA)==XFILIAL("RBR")+SQ3->Q3_TABELA
		IF RBR->RBR_APLIC=="1"
			dDatRef:= 	RBR->RBR_DTREF
			EXIT
		ENDIF
	RBR->(DBSKIP())
	END 
	
	IF !EMPTY(dDatRef)
		DBSELECTAREA("RB6")
		RB6->(DBSETORDER(3))
		IF RB6->(DBSEEK(XFILIAL("RB6")+SQ3->Q3_TABELA+dtos(dDatRef)+SQ3->Q3_TABNIVE+"01"))
			xRet:= &("RB6->"+cCampo)
		ENDIF 
	ENDIF
ENDIF

return xRet