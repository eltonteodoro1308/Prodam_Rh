#INCLUDE "WSPRD002.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �WSPRD002  � Autor �Marcelo Faria          � Data �18.04.2016  ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Web Service responsavel pela avalia��o e fluxo do gestor     ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Portal GCH                                                   ���
���������������������������������������������������������������������������Ĵ��
��� Atualizacoes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Responsavel  � Data   �Tarefa�  Motivo da Alteracao                     ��� 
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

Function WSPRD002()
Return .T.


//�����������������������������������������������������Ŀ
//�Definicao da Estrutura dos campos                    �
//�������������������������������������������������������

WSSTRUCT TManagerFlowData
    WSDATA ManagerID                    AS String     OPTIONAL
    WSDATA ManagerName                  AS String     OPTIONAL
    WSDATA ItemsTotal                   AS Integer    OPTIONAL
    WSDATA PagesTotal                   AS Integer    OPTIONAL
    WSDATA ItemsOfManagerFlow           AS Array Of   ManagerFlowDetail   OPTIONAL
ENDWSSTRUCT

WSSTRUCT ManagerFlowDetail
    WSDATA EvaluationID                 As String     OPTIONAL     //C�digo da Avalia��o
    WSDATA EvaluationDesc               As String     OPTIONAL     //Descricao da Avalia��o
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
    WSDATA ApprovalDate                 As String     OPTIONAL     //Data do retorno de aprova��o do gestor
    WSDATA PositionID                   As String     OPTIONAL     //Posi��o da avalia��o
    WSDATA StartDateEval                As String     OPTIONAL     //Data Inicial da Avalia��o
    WSDATA EndDateEval                  As String     OPTIONAL     //Data Final da avalia��o
    WSDATA ObsOfApproval                As String     OPTIONAL     //Observa��o do processo de aprova��o
ENDWSSTRUCT


//�����������������������������������������������������Ŀ
//�Definicao do Web Service de Saldo de Dias de Folga   �
//�������������������������������������������������������
WSSERVICE  RHAPDManagerFlow             DESCRIPTION STR0001    //Fluxo de Avalia��es do Gestor
   WSDATA WsResult                      As String   OPTIONAL   //Retorno do m�todo

   WSDATA Action                        As String   OPTIONAL	//Ac�o sobre a avalia��o
   WSDATA Evaluation                    As String   OPTIONAL	//ID da Avalia��o
   WSDATA Evaluator                     As String   OPTIONAL	//ID do Avaliador
   WSDATA Evaluated                     As String   OPTIONAL	//ID do Avaliado
   WSDATA EvalType                      As String   OPTIONAL	//Tipo da Avalia��o (1-Avaliador; 2-Auto; 3-Consenso)
   WSDATA Level                         As String   OPTIONAL	//Nivel da Avalia��o
   WSDATA Observation                   As String   OPTIONAL	//Observa��o da Avalia��o

   WSDATA EmployeeFil                   As String   OPTIONAL	//Filial do funcionario
   WSDATA Registration                  As String   OPTIONAL	//Codigo da matricula
   WSDATA ParticipantId                 As String   OPTIONAL	//Codigo do Participante
   WSDATA Page                          As Integer  OPTIONAL	//Numero da Pagina, para paginacao
   WSDATA FilterField                   As String   OPTIONAL	//Campo para filtro
   WSDATA FilterValue                   As String   OPTIONAL	//Condicao de filtro das querys

   WSDATA ManagerFlowData               As TManagerFlowData    //Informa��es de resultado das avalia��es a serem aprovadas
   
   WSMETHOD GetManagerFlow              DESCRIPTION STR0002    //Metodo para listar as avalia��es pendentes de aprova��o do gestor
   WSMETHOD ActionsOnEvaluation         DESCRIPTION STR0003    //Metodo para o gestor realizar a��es em uma avalia��o
ENDWSSERVICE


/*/
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Metodo    �GetManagerFlow      � Autor �Marcelo Faria        �Data �18.04.2016 ���
���������������������������������������������������������������������������������Ĵ��
���Descricao �listar as avalia��es pendentes de aprova��o do gestor               ���
���������������������������������������������������������������������������������Ĵ��
���Uso       �Portal GCH                                                          ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
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


    //Busca RDC (Agenda - Movimento das Avalia��es)
    //*********************************************
    cWhere := "%"
    cWhere += " AND RDC.RDC_CODAPR  = '" + Self:ParticipantID  + "'"
    cWhere += " AND RDC.RDC_DTEMAP <> ''"
    cWhere += " AND RDC.RDC_DTRETA  = ''"

    If !Empty(cFiltro) .AND. !Empty(cCampo)
		If (cCampo == "1")	  //Codigo do Avaliado                                                                       �
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

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluationID       := (cQueryRDC)->RDC_CODAVA                                        //C�digo da Avalia��o
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EvaluationDesc     := AllTrim(FDesc("RD6", (cQueryRDC)->RDC_CODAVA, "RD6_DESC",,,1)) //Descricao da Avalia��o
         
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
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:ApprovalDate       := (cQueryRDC)->RDC_DTRETA                                        //Data do retorno de aprova��o do gestor
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:PositionID         := (cQueryRDC)->RDC_ID                                            //Posi��o da avalia��o

         ::ManagerFlowData:ItemsOfManagerFlow[nP]:StartDateEval      := (cQueryRDC)->RDC_DTIAVA                                        //Data Inicial da Avalia��o
         ::ManagerFlowData:ItemsOfManagerFlow[nP]:EndDateEval        := (cQueryRDC)->RDC_DTFAVA                                        //Data Final da Avalia��o

         If !Empty((cQueryRDC)->RDC_CODOBS)
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:ObsOfApproval   := Msmm((cQueryRDC)->RDC_CODOBS,,,,,,,,,"RDY")                    //Observa��o de aprova��o do gestor
         Else
            ::ManagerFlowData:ItemsOfManagerFlow[nP]:ObsOfApproval   := ""    
         EndIf    
            
         nP++
        (cQueryRDC)->(dbSkip())
    EndDo

   (cQueryRDC)->(dbCloseArea())

Return .T.



/*/
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Metodo    �ActionsOnEvaluation  � Autor �Marcelo Faria       �Data �25.04.2016 ���
���������������������������������������������������������������������������������Ĵ��
���Descricao �Metodo para o gestor realizar a��es em uma avalia��o                ���
���������������������������������������������������������������������������������Ĵ��
���Uso       �Portal GCH                                                          ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
/*/
WSMETHOD ActionsOnEvaluation WSRECEIVE Action, ParticipantID, Evaluation, Evaluator, Evaluated, EvalType, Level, Observation WSSEND WsResult WSSERVICE RHAPDManagerFlow 
Local nRet                 := 0
Local cObs                 := ""
Local IdObs                := ""
Local cQuery               := ""
Local cWhere               := ""
Local cQueryRDC            := GetNextAlias()
	
DEFAULT Self:Action        := "" //1-Aprova��o; 2-Reprova��o
DEFAULT Self:ParticipantID := ""
DEFAULT Self:Evaluation    := ""
DEFAULT Self:Evaluator     := ""
DEFAULT Self:Evaluated     := ""
DEFAULT Self:EvalType      := ""
DEFAULT Self:Level         := ""
DEFAULT Self:Observation   := ""

    Self:wsResult := ""
    If Self:Action == ""
       Self:wsResult := STR0004 //"A��o n�o informada!"
       return .T.
    ElseIf Self:ParticipantID == ""
       Self:wsResult := STR0005 //"C�digo do Respons�vel pela a��o n�o informado!"
       return .T.
    ElseIf Self:Evaluation == ""
       Self:wsResult := STR0006 //"C�digo da Avalia��o n�o informada!"
       return .T.
    ElseIf Self:Evaluator == ""
       Self:wsResult := STR0007 //"C�digo do Avaliador n�o informado!"
       return .T.
    ElseIf Self:Evaluated == ""
       Self:wsResult := STR0008 //"C�digo do Avaliado n�o informado!"
       return .T.
    ElseIf Self:EvalType == ""
       Self:wsResult := STR0009 //"Tipo da Avalia��o n�o informado!"
       return .T.
    ElseIf Self:Level == ""
       Self:wsResult := STR0010 //"N�vel da avalia��o n�o informado!"
       return .T.
    EndIf    


    //Busca RDC (Agenda - Movimento das Avalia��es)
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
       Self:wsResult := STR0011 //"Avalia��o n�o localizada!"
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
             Self:wsResult := STR0012 //"Erro na atualiza��o - Participante n�o localizado!"
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

          cObs += "Em: " + dToc(dDataBase) +' �s ' + Time()                            + CHR(13) + CHR(10)
          cObs += "-----------------------------------"                                + CHR(13) + CHR(10)

          ApdMsMm(RDC->RDC_CODOBS, NIL, NIL, cObs, 1, NIL, NIL, "RDC", "RDC_CODOBS")
          RDC->( MsUnlock() )

       Else
          Self:wsResult := STR0013 //"Erro na atualiza��o - RECNO n�o confere!"
          return .T.
       EndIf
    Else   
       Self:wsResult := STR0014 //"Erro na atualiza��o - Registro n�o localizado!"
       return .T.
    EndIf


    If Self:Action == "1"
       
       //Copia avalia��o
       U_APDCopyC(Self:Evaluation, Self:Evaluated, Self:Evaluator)

       //Envio do email
       If !(U_MontaMail(3, Self:Evaluated, Self:Evaluator, Self:Observation))  
           conout('ActionsOnEvaluation - N�o foi poss�vel o envio do e-mail de aprova��o')
       EndIf
        
    Else
       
       If !(U_MontaMail(4, Self:Evaluated, Self:Evaluator, Self:Observation))  
           conout('ActionsOnEvaluation - N�o foi poss�vel o envio do e-mail de reprova��o')
       EndIf
       
    EndIf


Return .T.
