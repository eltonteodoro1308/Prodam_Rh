#INCLUDE "WSPRD002.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WSPRD002  ³ Autor ³Marcelo Faria          ³ Data ³18.04.2016  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pela avaliação e fluxo do gestor     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal GCH                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Responsavel  ³ Data   ³Tarefa³  Motivo da Alteracao                     ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function WSPRD002()
Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT TManagerFlowData
    WSDATA ManagerID                    AS String     OPTIONAL
    WSDATA ManagerName                  AS String     OPTIONAL
    WSDATA ItemsTotal                   AS Integer    OPTIONAL
    WSDATA PagesTotal                   AS Integer    OPTIONAL
    WSDATA ItemsOfManagerFlow           AS Array Of   ManagerFlowDetail   OPTIONAL
ENDWSSTRUCT

WSSTRUCT ManagerFlowDetail
    WSDATA EvaluationID                 As String     OPTIONAL     //Código da Avaliação
    WSDATA EvaluationDesc               As String     OPTIONAL     //Descricao da Avaliação
    WSDATA EvaluatedId                  As String     OPTIONAL     //Codigo do Avaliado
    WSDATA EvaluatedName                As String     OPTIONAL     //Nome do Avaliado
    WSDATA EvaluatorId                  As String     OPTIONAL     //Codigo do Avaliador
    WSDATA EvaluatorName                As String     OPTIONAL     //Nome do Avaliador
    WSDATA ProjectId                    As String     OPTIONAL     //Codigo do projeto
    WSDATA ProjectDesc                  As String     OPTIONAL     //Descricao do projeto
    WSDATA Net                          As String     OPTIONAL     //Rede
    WSDATA EvaluateType                 As String     OPTIONAL     //Tipo de avaliacao
    WSDATA TypeDescription              As String     OPTIONAL     //Descricao do Tipo de avaliacao
    WSDATA Level                        As String     OPTIONAL     //Nivel
    WSDATA SelfEvaluate                 As String     OPTIONAL     //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
    WSDATA SelfEvaluateDesc             As String     OPTIONAL     //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
    WSDATA AutoEvaluated                As String     OPTIONAL     //Finalizada AutoAvaliacao Em branco = Nao finalizada / Preenchida = Finalizada
    WSDATA EmailDate                    As String     OPTIONAL     //Data de envio de email ao gestor
    WSDATA ApprovalDate                 As String     OPTIONAL     //Data do retorno de aprovação do gestor
    WSDATA PositionID                   As String     OPTIONAL     //Posição da avaliação
    WSDATA StartDateEval                As String     OPTIONAL     //Data Inicial da Avaliação
    WSDATA EndDateEval                  As String     OPTIONAL     //Data Final da avaliação
    WSDATA ObsOfApproval                As String     OPTIONAL     //Observação do processo de aprovação
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Saldo de Dias de Folga   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHAPDManagerFlow             DESCRIPTION STR0001    //Fluxo de Avaliações do Gestor
   WSDATA WsResult                      As String   OPTIONAL   //Retorno do método

   WSDATA Action                        As String   OPTIONAL	//Acão sobre a avaliação
   WSDATA Evaluation                    As String   OPTIONAL	//ID da Avaliação
   WSDATA Evaluator                     As String   OPTIONAL	//ID do Avaliador
   WSDATA Evaluated                     As String   OPTIONAL	//ID do Avaliado
   WSDATA EvalType                      As String   OPTIONAL	//Tipo da Avaliação (1-Avaliador; 2-Auto; 3-Consenso)
   WSDATA Level                         As String   OPTIONAL	//Nivel da Avaliação
   WSDATA Observation                   As String   OPTIONAL	//Observação da Avaliação

   WSDATA EmployeeFil                   As String   OPTIONAL	//Filial do funcionario
   WSDATA Registration                  As String   OPTIONAL	//Codigo da matricula
   WSDATA ParticipantId                 As String   OPTIONAL	//Codigo do Participante
   WSDATA Page                          As Integer  OPTIONAL	//Numero da Pagina, para paginacao
   WSDATA FilterField                   As String   OPTIONAL	//Campo para filtro
   WSDATA FilterValue                   As String   OPTIONAL	//Condicao de filtro das querys

   WSDATA ManagerFlowData               As TManagerFlowData    //Informações de resultado das avaliações a serem aprovadas
   
   WSMETHOD GetManagerFlow              DESCRIPTION STR0002    //Metodo para listar as avaliações pendentes de aprovação do gestor
   WSMETHOD ActionsOnEvaluation         DESCRIPTION STR0003    //Metodo para o gestor realizar ações em uma avaliação
ENDWSSERVICE


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetManagerFlow      ³ Autor ³Marcelo Faria        ³Data ³18.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³listar as avaliações pendentes de aprovação do gestor               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal GCH                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetManagerFlow WSRECEIVE ParticipantID, Page, FilterValue, FilterField WSSEND ManagerFlowData WSSERVICE RHAPDManagerFlow 
Local nP         := 1
Local nI         := 0
Local cCampo     := ""
Local cFiltro    := ""
Local cWhere     := ""
Local cQueryRDC  := GetNextAlias()
	
	DEFAULT Self:ParticipantID  := ""
	DEFAULT Self:Page 			:= 1
	DEFAULT Self:FilterField		:= ""
	DEFAULT Self:FilterValue		:= ""

    If Self:ParticipantID == ""
       return .T.
    EndIf    

	cCampo	  := Self:FilterField
	cFiltro  := Self:FilterValue


    //Busca RDC (Agenda - Movimento das Avaliações)
    //*********************************************
    cWhere := "%"
    cWhere += " AND RDC.RDC_CODAPR  = '" + Self:ParticipantID  + "'"
    cWhere += " AND RDC.RDC_DTEMAP <> ''"
    cWhere += " AND RDC.RDC_DTRETA  = ''"

    If !Empty(cFiltro) .AND. !Empty(cCampo)
		If (cCampo == "1")	  //Codigo do Avaliado                                                                       ³
			cWhere += " AND RDC.RDC_CODADO LIKE '%" + Replace(cFiltro,"'","") + "%'"
		ElseIf (cCampo == "2") //Nome do Avaliado
			cWhere += " AND RD0.RD0_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
		EndIf
	EndIf

    cWhere += "%"

    BeginSql alias cQueryRDC
        SELECT RDC.*, RD0.RD0_NOME
        FROM %table:RDC% RDC

        LEFT JOIN %table:RD0% RD0
			   ON  RD0.RD0_CODIGO = RDC.RDC_CODADO  AND
					RD0.RD0_FILIAL = %xfilial:RD0%   AND
					RD0.%notdel%

        WHERE RDC.%notDel%               
              %exp:cWhere%

        Order by RDC.RDC_DTEMAP        
    EndSql 
    //varinfo('LastQuery',GetLastQuery()[2])

	COUNT TO nRecCount
	(cQueryRDC)->(DbGoTop())

    ::ManagerFlowData                    := WsClassNew('TManagerFlowData')
    ::ManagerFlowData:ItemsTotal         := 0
    ::ManagerFlowData:ItemsOfManagerFlow := {}

    ::ManagerFlowData:PagesTotal         := Ceiling(nRecCount / PAGE_LENGTH)
    If self:Page > 1
		(cQueryRDC)->(DBSkip((self:Page-1) * PAGE_LENGTH))
    EndIf

    ::ManagerFlowData:ManagerID          := self:ParticipantID
    ::ManagerFlowData:ManagerName        := ""
    dbSelectArea("RD0")
    RD0->( dbSetOrder(1) ) //RD0_FILIAL+RD0_CODIGO
    If RD0->( dbSeek(xFilial("RD0") + self:ParticipantID) )
		::ManagerFlowData:ManagerName     := RD0->RD0_NOME
    EndIf

    While !(cQueryRDC)->(Eof())
         ::ManagerFlowData:ItemsTotal  += 1

         aadd(::ManagerFlowData:ItemsOfManagerFlow,WsClassNew('ManagerFlowDetail'))

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluationID       := (cQueryRDC)->RDC_CODAVA                                        //Código da Avaliação
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluationDesc     := AllTrim(FDesc("RD6", (cQueryRDC)->RDC_CODAVA, "RD6_DESC",,,1)) //Descricao da Avaliação
         
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluatedId        := (cQueryRDC)->RDC_CODADO                                        //Codigo do Avaliado
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluatedName      := (cQueryRDC)->RD0_NOME                                          //Nome do Avaliado

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluatorId        := (cQueryRDC)->RDC_CODDOR                                        //Codigo do Avaliador
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluatorName      := AllTrim(FDesc("RD0", (cQueryRDC)->RDC_CODDOR, "RD0_NOME",,,1)) //Nome do Avaliador

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:ProjectId          := (cQueryRDC)->RDC_CODPRO                                        //Codigo do projeto
         If ExistBlock("MSGETPROJECT")
			 ::ManagerFlowData:ItemsOfManagerFlow[nP]:ProjectDesc	   := ExecBlock("MSGETPROJECT", .F., .F., {RDA->RDA_CODPRO}):Description
         Else
			 ::ManagerFlowData:ItemsOfManagerFlow[nP]:ProjectDesc	   := AllTrim(FDesc("RDN", RDA->RDA_CODPRO, "RDN_DESC",,,1))
         EndIf
         
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:Net                := (cQueryRDC)->RDC_CODNET                                        //Rede
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluateType       := (cQueryRDC)->RDC_CODTIP                                        //Tipo de avaliacao
         If RD5->(dbSeek(xFilial("RD5")+(cQueryRDC)->RDC_CODTIP)) 
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:TypeDescription := RD5->RD5_DESC                                                  //Descricao do Tipo de avaliacao
         Else
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:TypeDescription := ""
         EndIf

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:Level              := (cQueryRDC)->RDC_NIVEL                                         //Nivel
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:SelfEvaluate       := (cQueryRDC)->RDC_TIPOAV                                        //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:SelfEvaluateDesc   := OpBxTipoAv( .F., .T., (cQueryRDC)->RDC_TIPOAV )                //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
		  ::ManagerFlowData:ItemsOfManagerFlow[nP]:AutoEvaluated      := IIf(!Empty(RDC->RDC_DATRET),"SIM","NAO")                       //VERIFICA SE SUBORDINADO SE AUTO-AVALIOU

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EmailDate          := (cQueryRDC)->RDC_DTEMAP                                        //Data de envio de email ao gestor
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:ApprovalDate       := (cQueryRDC)->RDC_DTRETA                                        //Data do retorno de aprovação do gestor
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:PositionID         := (cQueryRDC)->RDC_ID                                            //Posição da avaliação

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:StartDateEval      := (cQueryRDC)->RDC_DTIAVA                                        //Data Inicial da Avaliação
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EndDateEval        := (cQueryRDC)->RDC_DTFAVA                                        //Data Final da Avaliação

         If !Empty((cQueryRDC)->RDC_CODOBS)
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:ObsOfApproval   := Msmm((cQueryRDC)->RDC_CODOBS,,,,,,,,,"RDY")                    //Observação de aprovação do gestor
         Else
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:ObsOfApproval   := ""    
         EndIf    
            
         nP++
        (cQueryRDC)->(dbSkip())
    EndDo

   (cQueryRDC)->(dbCloseArea())

Return .T.



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³ActionsOnEvaluation  ³ Autor ³Marcelo Faria       ³Data ³25.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Metodo para o gestor realizar ações em uma avaliação                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal GCH                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ActionsOnEvaluation WSRECEIVE Action, ParticipantID, Evaluation, Evaluator, Evaluated, EvalType, Level, Observation WSSEND WsResult WSSERVICE RHAPDManagerFlow 
Local nRet                 := 0
Local cObs                 := ""
Local IdObs                := ""
Local cQuery               := ""
Local cWhere               := ""
Local cQueryRDC            := GetNextAlias()
	
DEFAULT Self:Action        := "" //1-Aprovação; 2-Reprovação
DEFAULT Self:ParticipantID := ""
DEFAULT Self:Evaluation    := ""
DEFAULT Self:Evaluator     := ""
DEFAULT Self:Evaluated     := ""
DEFAULT Self:EvalType      := ""
DEFAULT Self:Level         := ""
DEFAULT Self:Observation   := ""

    Self:wsResult := ""
    If Self:Action == ""
       Self:wsResult := STR0004 //"Ação não informada!"
       return .T.
    ElseIf Self:ParticipantID == ""
       Self:wsResult := STR0005 //"Código do Responsável pela ação não informado!"
       return .T.
    ElseIf Self:Evaluation == ""
       Self:wsResult := STR0006 //"Código da Avaliação não informada!"
       return .T.
    ElseIf Self:Evaluator == ""
       Self:wsResult := STR0007 //"Código do Avaliador não informado!"
       return .T.
    ElseIf Self:Evaluated == ""
       Self:wsResult := STR0008 //"Código do Avaliado não informado!"
       return .T.
    ElseIf Self:EvalType == ""
       Self:wsResult := STR0009 //"Tipo da Avaliação não informado!"
       return .T.
    ElseIf Self:Level == ""
       Self:wsResult := STR0010 //"Nível da avaliação não informado!"
       return .T.
    EndIf    


    //Busca RDC (Agenda - Movimento das Avaliações)
    //*********************************************
    cWhere := "%"
    cWhere += " AND RDC.RDC_CODAVA  = '" + Self:Evaluation + "'"
    cWhere += " AND RDC.RDC_CODDOR  = '" + Self:Evaluator + "'"
    cWhere += " AND RDC.RDC_CODADO  = '" + Self:Evaluated + "'"
    cWhere += " AND RDC.RDC_TIPOAV  = '" + Self:EvalType + "'"
    cWhere += " AND RDC.RDC_NIVEL   = '" + Self:Level + "'"
    cWhere += " AND RDC.RDC_CODAPR  = '" + Self:ParticipantID  + "'"
    cWhere += " AND RDC.RDC_DTEMAP <> ''"
    cWhere += " AND RDC.RDC_DTRETA  = ''"
    cWhere += "%"

    BeginSql alias cQueryRDC
        SELECT *
        FROM %table:RDC% RDC
        WHERE RDC.%notDel%               
              %exp:cWhere%
    EndSql 

    IF (cQueryRDC)->(Eof())
       Self:wsResult := STR0011 //"Avaliação não localizada!"
       return .T.
    EndIf


   //Atualiza RDC
   //*********************************************
    dbSelectArea("RDC")
    RDC->( dbSetOrder(8) ) // RDC_FILIAL+RDC_ID+RDC_CODAVA
    If RDC->( dbSeek((cQueryRDC)->RDC_FILIAL + (cQueryRDC)->RDC_ID +(cQueryRDC)->RDC_CODAVA) )


       If RDC->(RECNO()) == (cQueryRDC)->R_E_C_N_O_
          //Busca nome participante
          dbSelectArea("RD0")
          RD0->( dbSetOrder(1) ) //RD0_FILIAL+RD0_CODIGO
          If !RD0->( dbSeek(xFilial("RD0") + self:ParticipantID) )
             Self:wsResult := STR0012 //"Erro na atualização - Participante não localizado!"
             return .T.
          EndIf

          cObs := Msmm((cQueryRDC)->RDC_CODOBS,,,,,,,,,"RDY")
          cObs +=  '"' + Self:Observation +'"' + CHR(13) + CHR(10)
          cObs += CHR(13) + CHR(10)

          Reclock("RDC",.F.)
          If Self:Action == "1" 
            //aprovado por: 
            cObs += "Aprovado por: " + RD0->RD0_NOME                                   + CHR(13) + CHR(10)
            RDC->RDC_DTRETA := dDataBase
          Else
            //reprovado por: 
            cObs += "Reprovado por: " + RD0->RD0_NOME                                  + CHR(13) + CHR(10)

            RDC->RDC_CODAPR := ''
            RDC->RDC_DTEMAP := Ctod("//")
            RDC->RDC_DATRET := Ctod("//")   
          EndIf

          cObs += "Em: " + dToc(dDataBase) +' às ' + Time()                            + CHR(13) + CHR(10)
          cObs += "-----------------------------------"                                + CHR(13) + CHR(10)

          ApdMsMm(RDC->RDC_CODOBS, NIL, NIL, cObs, 1, NIL, NIL, "RDC", "RDC_CODOBS")
          RDC->( MsUnlock() )

       Else
          Self:wsResult := STR0013 //"Erro na atualização - RECNO não confere!"
          return .T.
       EndIf
    Else   
       Self:wsResult := STR0014 //"Erro na atualização - Registro não localizado!"
       return .T.
    EndIf


    If Self:Action == "1"
       
       //Copia avaliação
       U_APDCopyC(Self:Evaluation, Self:Evaluated, Self:Evaluator)

       //Envio do email
       If !(U_MontaMail(3, Self:Evaluated, Self:Evaluator, Self:Observation))  
           conout('ActionsOnEvaluation - Não foi possível o envio do e-mail de aprovação')
       EndIf
        
    Else
       
       If !(U_MontaMail(4, Self:Evaluated, Self:Evaluator, Self:Observation))  
           conout('ActionsOnEvaluation - Não foi possível o envio do e-mail de reprovação')
       EndIf
       
    EndIf


Return .T.
