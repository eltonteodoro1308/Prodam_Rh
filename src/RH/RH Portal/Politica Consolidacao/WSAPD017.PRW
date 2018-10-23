#INCLUDE "WSAPD017.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 20

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WSAPD017  ³ Autor ³Marcelo Faria          ³ Data ³05.04.2016  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pela avaliação consolidada           ³±±
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

Function WSAPD017()
Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT TPolicyData
    WSDATA ItemsTotal                   AS Integer                OPTIONAL
    WSDATA ItemsOfPolicy                AS Array Of   PolicyCabec   OPTIONAL
ENDWSSTRUCT

WSSTRUCT PolicyCabec
    WSDATA BranchPolicyID               As String     OPTIONAL     //Filial da Politica
    WSDATA PolicyID                     As String     OPTIONAL     //ID da Politica
    WSDATA PolicyDesc                   As String     OPTIONAL     //Descricao da Politica
    WSDATA PercCompetence               As Float      OPTIONAL     //Peso Percentual sobre competencias
    WSDATA PercGoal                     As Float      OPTIONAL     //Peso Percentual sobre metas
    WSDATA PercFormation                As Float      OPTIONAL     //Peso Percentual sobre formacao academica
    WSDATA RegID                        As Integer    OPTIONAL     //ID do Registro
    WSDATA ItemsTotalDetail             AS Integer    OPTIONAL
    WSDATA ItemsOfPolicyDetail          AS Array Of   PolicyDetail   OPTIONAL
ENDWSSTRUCT

WSSTRUCT PolicyDetail
    WSDATA PeriodID                     As String     OPTIONAL     //ID do Periodo
    WSDATA PeriodDesc                   As String     OPTIONAL     //Descricao da Licenca
    WSDATA PeriodType                   As String     OPTIONAL     //Tipo do Periodo
    WSDATA PeriodTypeDesc               As String     OPTIONAL     //Descrição do Tipo do Periodo
    WSDATA PeriodInitialDate            As String     OPTIONAL		//Data inicial do período
    WSDATA PeriodFinalDate              As String     OPTIONAL		//Data final do período
    WSDATA Evaluations		            As String     OPTIONAL		//Codigos das Avaliacoes
ENDWSSTRUCT

WSSTRUCT TConsolidatedData 
    WSDATA EmployeeFilial               As String			    	 //Filial do funcionario
    WSDATA Registration                 As String				    //Codigo da matricula
    WSDATA Name                         As String				    //Nome do funcionario
    WSDATA PolicyID                     As String                  //ID da Politica Consolidada
    WSDATA PolicyDesc                   As String     OPTIONAL     //Descricao da Politica
    WSDATA ItemsTotalGoals              AS Integer                       OPTIONAL
    WSDATA ItemsTotalAssessments        AS Integer                       OPTIONAL
    WSDATA ItemsTotalOthers             AS Integer                       OPTIONAL
    WSDATA ItemsOfConsolidated          AS Array Of   ConsolidatedResult OPTIONAL
ENDWSSTRUCT

WSSTRUCT ConsolidatedResult
    WSDATA Group                        As String     OPTIONAL     //Grupo 
    WSDATA GroupDesc                    As String     OPTIONAL     //Descrição do Grupo 
    WSDATA Key                          As String     OPTIONAL     //Chave do grupo
    WSDATA KeyDesc                      As String     OPTIONAL     //Descrição da Chave do grupo
    WSDATA Weight                       As String     OPTIONAL     //Peso
    WSDATA ProfitFor                    As String     OPTIONAL     //Resultado Obtido
    WSDATA PartialAverage               As String     OPTIONAL     //Média Parcial
    WSDATA TotalAverage                 As String     OPTIONAL     //Média Final
    WSDATA ProcessDate                  As String     OPTIONAL		//Data de processamento
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Saldo de Dias de Folga   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHAPDConsolidated            DESCRIPTION STR0001   //Avaliações Consolidadas
   WSDATA WsNull                        As String   OPTIONAL  //NULL
   
   WSDATA ParticipantId                 As String   OPTIONAL	//Codigo do Participante
   WSDATA TypeOrg                       As String   OPTIONAL	//Verifica se a Arquitetura Organizacional é por Posto ou Departamento
   WSDATA Vision                        As String   OPTIONAL	//Visao
   WSDATA EmployeeFil                   As String   OPTIONAL	//Filial do funcionario
   WSDATA Registration                  As String   OPTIONAL	//Codigo da matricula
   WSDATA Page                          As Integer  OPTIONAL	//Numero da Pagina, para paginacao
   WSDATA PageLength                    As Integer  OPTIONAL	//Total de Registros por página
   WSDATA FilterField                   As String   OPTIONAL	//Campo para filtro
   WSDATA FilterValue                   As String   OPTIONAL	//Condicao de filtro das querys
   WSDATA RankingOrder                  As String   OPTIONAL	//Tipo de solicitação
   WSDATA SupEmployeeFil                As String   OPTIONAL	//Filial do superior
   WSDATA SupRegistration               As String   OPTIONAL	//Codigo da matricula do superior

   WSDATA EmployeeData                  As TEmployeeData	   //Estrutura Organizacional

   WSDATA Policy                        AS String   OPTIONAL   //Politica Consolidada
   WSDATA PolicyData                    As TPolicyData         //Informações das Politicas Consolidadas

   WSDATA ConsolidatedData              As TConsolidatedData   //Informações de resultado do funcionário para a política consolidada

   WSMETHOD GetStructRanking            DESCRIPTION STR0002    //Metodo para listar a estrutura organizacional e ranking consolidado
   WSMETHOD GetPolicies                 DESCRIPTION STR0003    //Metodo para buscar as politicas consolidadas
   WSMETHOD GetConsolidated             DESCRIPTION STR0004    //Metodo para buscar resultado consolidado do funcionario
ENDWSSERVICE


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetConsolidated     ³ Autor ³Marcelo Faria        ³Data ³05.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Metodo para buscar resultado consolidado do funcionario             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal GCH                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetConsolidated WSRECEIVE Policy, EmployeeFil, Registration, SupEmployeeFil, SupRegistration WSSEND ConsolidatedData WSSERVICE RHAPDConsolidated 
Local nP                  := 1
Local nI                  := 0
Local cWhere              := ""
Local cQuerySZE           := GetNextAlias()
Local lMyConsolidated     := .t.
Local nArred			  := GetMV('MV_APDARRM',,4)

DEFAULT Self:Policy       := ""
DEFAULT Self:EmployeeFil  := ""
DEFAULT Self:Registration := ""
DEFAULT Self:SupEmployeeFil  := ""
DEFAULT Self:SupRegistration := ""

	If (Self:EmployeeFil + Self:Registration) <> (Self:SupEmployeeFil + Self:SupRegistration)
		lMyConsolidated     := .f.
	EndIf

    ::ConsolidatedData                       := WsClassNew('TConsolidatedData')
    ::ConsolidatedData:EmployeeFilial        := ""
    ::ConsolidatedData:Registration          := ""
    ::ConsolidatedData:Name                  := ""
    ::ConsolidatedData:PolicyID              := ""
    ::ConsolidatedData:PolicyDesc            := ""
    ::ConsolidatedData:ItemsTotalGoals       := 0
    ::ConsolidatedData:ItemsTotalAssessments := 0
    ::ConsolidatedData:ItemsTotalOthers      := 0
    ::ConsolidatedData:ItemsOfConsolidated   := {}

    If Self:Policy == "" .or. Self:Registration == ""
       return .T.
    EndIf    

    dbSelectArea("SRA")
    SRA->( dbSetOrder(1) )
    If SRA->( dbSeek(Self:EmployeeFil + Self:Registration ))
       ::ConsolidatedData:EmployeeFilial     := Self:EmployeeFil
       ::ConsolidatedData:Registration       := Self:Registration
       ::ConsolidatedData:Name               := SRA->RA_NOME
    Else
		SetSoapFault("GetConsolidated",PorEncode(STR0008)) //"Matricula não encontrada"
       return .T.
    EndIf    

    dbSelectArea("SZC")
    SZC->( dbSetOrder(1) )
    If SZC->( dbSeek(xFilial("SZC") + Self:Policy ))
       ::ConsolidatedData:PolicyID           := SZC->ZC_CODIGO
       ::ConsolidatedData:PolicyDesc         := SZC->ZC_DESC
    Else
		SetSoapFault("GetConsolidated",PorEncode(STR0009)) //"Politica não encontrada"
       return .T.
    EndIf    


    //Busca SZE (Resultado Consolidado)
    //*********************************
    cWhere := "%"
    cWhere += " AND SZE.ZE_FILMAT  = '" + SRA->RA_FILIAL  + "'"
    cWhere += " AND SZE.ZE_MAT     = '" + SRA->RA_MAT     + "'"
    cWhere += " AND SZE.ZE_IDCONS  = '" + SZC->ZC_CODIGO  + "'"
    cWhere += "%"

    BeginSql alias cQuerySZE
        SELECT *
        FROM %table:SZE% SZE
        WHERE SZE.%notDel%               
              %exp:cWhere%
        Order by SZE.ZE_GRUPO, SZE.ZE_KEY        
    EndSql 
    //varinfo('LastQuery',GetLastQuery()[2])

    While !(cQuerySZE)->(Eof())

         aadd(::ConsolidatedData:ItemsOfConsolidated,WsClassNew('ConsolidatedResult'))
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Group          := (cQuerySZE)->ZE_GRUPO
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Key            := (cQuerySZE)->ZE_KEY
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Weight         := str((cQuerySZE)->ZE_PESO)
         If lMyConsolidated .and. (cQuerySZE)->ZE_PENDENC <> '0'
		         ::ConsolidatedData:ItemsOfConsolidated[nP]:ProfitFor      := 'Não Liberado'
		         ::ConsolidatedData:ItemsOfConsolidated[nP]:PartialAverage := 'Não Liberado'
		         ::ConsolidatedData:ItemsOfConsolidated[nP]:TotalAverage   := 'Não Liberado'
		 Else
 			  ::ConsolidatedData:ItemsOfConsolidated[nP]:ProfitFor      := Transform((cQuerySZE)->ZE_RESOBT,"@R 999."  + Replicate('9',nArred))
	         ::ConsolidatedData:ItemsOfConsolidated[nP]:PartialAverage := Transform((cQuerySZE)->ZE_MEDPARC,"@R 999." + Replicate('9',nArred))
	         ::ConsolidatedData:ItemsOfConsolidated[nP]:TotalAverage   := Transform((cQuerySZE)->ZE_MEDTOT,"@R 999."  + Replicate('9',nArred))
		 EndIf
		 ::ConsolidatedData:ItemsOfConsolidated[nP]:ProcessDate    := (cQuerySZE)->ZE_DTCALC

         If (cQuerySZE)->ZE_GRUPO == "01" //Metas
            ::ConsolidatedData:ItemsTotalGoals                   += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0010)

            dbSelectArea("RDU")
            RDU->( dbSetOrder(1) )
            If RDU->( dbSeek(xFilial("RDU") + (cQuerySZE)->ZE_KEY ))
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := RDU->RDU_DESC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf    
            
         ElseIf (cQuerySZE)->ZE_GRUPO == "02" //Desempenho  
            ::ConsolidatedData:ItemsTotalAssessments             += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0011)

            dbSelectArea("RD6")
            RD6->( dbSetOrder(1) )
            If RD6->( dbSeek(xFilial("RD6") + (cQuerySZE)->ZE_KEY ))
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := RD6->RD6_DESC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf

         ElseIf (cQuerySZE)->ZE_GRUPO == "03" //Formação  
            ::ConsolidatedData:ItemsTotalOthers += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0012)

            dbSelectArea("RA1")
            RA1->( dbSetOrder(1) )
            If RA1->( dbSeek(xFilial("RA1") + (cQuerySZE)->ZE_KEY ))
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := RA1->RA1_DESC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf
         
         ElseIf (cQuerySZE)->ZE_GRUPO == "99" //Consolidado  
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0013)
            ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc   := ""
         EndIf            
            
         nP++
         (cQuerySZE)->(dbSkip())
    EndDo

   (cQuerySZE)->(dbCloseArea())

Return .T.



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetStructRanking    ³ Autor ³Marcelo Faria        ³Data ³05.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Metodo para listar a estrutura organizacional e ranking consolidado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal GCH                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetStructRanking WSRECEIVE Policy, ParticipantID, TypeOrg, Vision, EmployeeFil, Registration, Page, PageLength, FilterValue, FilterField, RankingOrder WSSEND EmployeeData WSSERVICE RHAPDConsolidated 
	Local lQryResp       	:= .F.
	Local lCont          	:= .T.
	Local nPos   	     		:= 0
	Local nPosItem   	   		:= 0
	Local nReg		     		:= 0
	Local nFunc		    	:= 0
	Local cItem  	     		:= ""
	Local cChave         	:= ""
	Local cLike          	:= ""
	Local cDeptos        	:= ""
	Local cRespDeptos    	:= ""
	Local cNome          	:= ""
	Local cParticipantId 	:= ""
	Local cRD4Alias      	:= "QRD4"
	Local cAuxAlias      	:= "QAUX"
	Local cVision
	Local cEmpSM0	     		:= SM0->M0_CODIGO
	Local aChvItem	   		:= {}
	Local aRet           	:= {}
	Local aDeptos	     		:= {}
	Local PageLen  			:= 20
	Local nX 			 		:= 0
	Local nJ		     		:= 1
	Local nRecCount 	 		:= 0
	Local cWhere    	 		:= ""
	Local cWhereOrder	 		:= ""
	Local cAuxAlias1 	 		:= GetNextAlias()
	Local cAuxAlias2     	:= GetNextAlias()
	Local cChaveComp     	:= ""
	Local nTamEmpFil	 		:= TamSX3("RDZ_FILENT")[1]	//Tamanho do campo RDZ_FILENT
	Local nTamRegist	 		:= TamSX3("RDZ_CODENT")[1]	//Tamanho do campo RDZ_CODENT
	Local cCampoMat
	Local cEmpFil
	Local cRegist
	Local cCampo
	Local cChaveItem			:= ""
	Local cFiltro				:= ""
	Local cFilRD4				:= ""
	Local cFilSQB				:= ""
	Local cFilSRA				:= ""
	Local cMatSup		       := ""
	Local nArred				:= GetMV('MV_APDARRM',,4)
	
	DEFAULT Self:Policy         := ""
	DEFAULT Self:ParticipantID  := ""
	DEFAULT Self:TypeOrg 		:= ""
	DEFAULT Self:Vision 	  		:= ""
	DEFAULT Self:EmployeeFil		:= ""
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:Page 			:= 1
	DEFAULT Self:PageLength		:= PAGE_LENGTH
	DEFAULT Self:FilterField		:= ""
	DEFAULT Self:FilterValue		:= ""
	DEFAULT Self:RankingOrder	:= "desc"
	
	cVision  := Self:Vision
	cCampo	  := Self:FilterField
	cFiltro  := Self:FilterValue

	If Empty(self:Policy)
		SetSoapFault("GetStructRanking",PorEncode(STR0007))	 //"Politica não informada"
		Return .T.
	EndIf	

	If Empty(::ParticipantID)
		If !Empty(::EmployeeFil) .and. !Empty(::Registration)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Prepara corretamente tamanho campo para busca no RDZ                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cEmpFil := ::EmployeeFil  + Space(nTamEmpFil - Len(self:EmployeeFil))
			cRegist := ::Registration + Space(nTamRegist - (Len(self:Registration)+Len(cEmpFil)))
			
			dbSelectArea("RDZ")
			RDZ->( dbSetOrder(1) ) //RDZ_FILIAL+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA+RDZ_CODENT+RDZ_CODRD0
			If RDZ->( dbSeek(xFilial("RDZ") + cEmpSM0 + xFilial("SRA", cEmpFil) + "SRA" + cEmpFil + cRegist))
				dbSelectArea("RD0")
				RD0->( dbSetOrder(1) ) //RD0_FILIAL+RD0_CODIGO
				If RD0->( dbSeek(xFilial("RD0") + RDZ->RDZ_CODRD0) )
					cParticipantId := RD0->RD0_CODIGO
				EndIf
			EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localizar o funcionário(SRA) a partir do ID logado (participante - RD0)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cParticipantId := ::ParticipantID
	EndIf


	If Participant(cParticipantId , aRet, , ::Registration)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Departamento (sem visao)                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If ::TypeOrg == "0"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta a estrutura de departamentos                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDeptos := fEstrutDepto( aRet[3] )
			
			cItem  := ""
			cLike  := ""
			cChave := ""
		EndIf
		
		dbSelectArea("SRA")
		SRA->( dbSetOrder(1) )
		SRA->( dbSeek(aRet[3] +aRet[1] ) )
		
		::EmployeeData:ListOfEmployee := {}
		aadd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
		nFunc++
		::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial 	    := aRet[3]
		::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= aRet[1]
		::EmployeeData:ListOfEmployee[nFunc]:ParticipantID		:= cParticipantId
		::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(aRet[2])
		::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(aRet[5])
		::EmployeeData:ListOfEmployee[nFunc]:Department    		:= aRet[8]
		::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment	    := fDesc('SQB',aRet[8],'SQB->QB_DESCRIC',,,1)
		::EmployeeData:ListOfEmployee[nFunc]:Item          		:= cItem
		::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= cChave
		::EmployeeData:ListOfEmployee[nFunc]:LevelHierar		   := (len(Alltrim(cChave))/3)-1
		::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "1"
		::EmployeeData:ListOfEmployee[nFunc]:Situacao			   := SRA->RA_SITFOLH
		::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + SRA->RA_SITFOLH, "X5DESCRI()", NIL, aRet[3]))
		::EmployeeData:ListOfEmployee[nFunc]:FunctionId      	:= SRA->RA_CODFUNC
		::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc    	:= Alltrim(Posicione('SRJ',1,xFilial("SRJ", SRA->RA_FILIAL)+SRA->RA_CODFUNC,'SRJ->RJ_DESC'))
		::EmployeeData:ListOfEmployee[nFunc]:CostId           	:= SRA->RA_CC
		::EmployeeData:ListOfEmployee[nFunc]:Cost             	:= Alltrim(Posicione('CTT',1,xFilial("CTT",SRA->RA_FILIAL)+Alltrim(SRA->RA_CC),'CTT->CTT_DESC01'))
		::EmployeeData:ListOfEmployee[nFunc]:PositionId			:= SRA->RA_CARGO
		::EmployeeData:ListOfEmployee[nFunc]:Position           := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+SRA->RA_CARGO,'SQ3->Q3_DESCSUM'))
		::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst      := .F.
		::EmployeeData:ListOfEmployee[nFunc]:Salary			    := SRA->RA_SALARIO
		::EmployeeData:ListOfEmployee[nFunc]:FilialDescr	       := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
		::EmployeeData:ListOfEmployee[nFunc]:CatFunc		       := SRA->RA_CATFUNC
		::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc	       := Alltrim(FDESC("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()"))
		::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic        := .F.
    	::EmployeeData:ListOfEmployee[nFunc]:HoursMonth 			:= Transform(0,"@R 999." + Replicate('9',nArred))

		dbSelectArea("SZE")
		SZE->( dbSetOrder(1) ) // ZE_FILIAL+ZE_CODRD0+ZE_IDCONS+ZE_GRUPO+ZE_KEY
		If SZE->( dbSeek( xFilial("RD0") + cParticipantId + Self:Policy + "99" + "000000"))
	    	::EmployeeData:ListOfEmployee[nFunc]:HoursMonth := Transform(SZE->ZE_MEDTOT,"@R 999." + Replicate('9',nArred))
	    	::EmployeeData:ListOfEmployee[nFunc]:Situacao	 := SZE->ZE_PENDENC
		Else
			::EmployeeData:ListOfEmployee[nFunc]:Situacao := 'X' //Nao calculado
		EndIf

		If ::TypeOrg == "0"
			If (nPos := aScan(aDeptos, {|x| x[1] == aRet[8]})) > 0
				cChave := aDeptos[nPos][5]
				::EmployeeData:ListOfEmployee[nFunc]:KeyVision    := cChave
				::EmployeeData:ListOfEmployee[nFunc]:LevelHierar  := (len(Alltrim(cChave))/3)-1
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados da Equipe                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Departamento (com visao)                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		cWhere := "%"
		If !Empty(cFiltro) .AND. !Empty(cCampo)
			If(cCampo == "1")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Matricula                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhere += " AND SRA.RA_MAT LIKE '%" + Replace(cFiltro,"'","") + "%'"
			ElseIf(cCampo == "2")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nome                                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhere += " AND SRA.RA_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
			ElseIf(cCampo == "3")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Admissao                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhere += " AND SRA.RA_ADMISSA LIKE '%" + Replace(dToS(cToD(cFiltro)),"'","") + "%'"
			ElseIf(cCampo == "4")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Departamento                                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhere += " AND SRA.RA_DEPTO LIKE '%" + Replace(cFiltro,"'","") + "%'"
			ElseIf(cCampo == "5")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Situacao                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhere += " AND SRA.RA_SITFOLH LIKE '%" + Replace(cFiltro,"'","") + "%'"
			EndIf
		EndIf

           cWhereOrder := cWhere + " order by SZE.ZE_MEDTOT " +Self:RankingOrder +", RD0.RD0_NOME%"
			cWhere += "%"
			
			//Busca a visao na politica
			BeginSQL ALIAS cAuxAlias
				SELECT max(RDU_XVISAO) AS VISAO
				FROM %table:RDU% RDU
				INNER JOIN %table:SZD% SZD ON RDU_CODIGO = ZD_CODPER AND 
				                              ZD_CODIGO = %exp:self:Policy% AND
				                              SZD.%notDel%
				WHERE 
				RDU.%notDel%
			EndSQL
			If (cAuxAlias)->( !Eof() )
				cVision := (cAuxAlias)->VISAO
			Endif
			(cAuxAlias)->( dbCloseArea() )
			
			//Busca as datas iniciais e finais dos periodos envolvidos na politica
			cDatIni := ''
			cDatFim := ''
			BeginSQL ALIAS cAuxAlias
				SELECT max(RDU_DATFIM) AS DATFIM, min(RDU_DATINI) as DATINI
				FROM %table:RDU% RDU
				INNER JOIN %table:SZD% SZD ON RDU_CODIGO = ZD_CODPER AND 
				                              ZD_CODIGO = %exp:self:Policy% AND
				                              SZD.%notDel%
				WHERE 
				RDU.%notDel%
			EndSQL
			If (cAuxAlias)->( !Eof() )
				cDatIni := (cAuxAlias)->DATINI
				cDatFim := (cAuxAlias)->DATFIM
			Endif
			(cAuxAlias)->( dbCloseArea() )
			
			RD4->(dbsetorder(2)) //RD4_FILIAL+RD4_CODIGO+RD4_TREE+RD4_ITEM+DTOS(RD4_DATA)
			
			//Busca a alocacao ativa do usuario logado na visao do APD
			cItemVis := ''
			RDE->(dbsetorder(6)) //RDE_FILIAL+RDE_CODVIS+RDE_CODPAR+RDE_STATUS
			If RDE->(dbseek(xFilial("RDE", aRet[3]) + cVision + cParticipantId + "1"))
				cItemVis := RDE->RDE_ITEVIS
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Selecionar todos os departamentos que o funcionario logado é responsável³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			BEGINSQL ALIAS cRD4Alias
				SELECT
				SRA.RA_SITFOLH,
				SRA.RA_FILIAL,
				SRA.RA_MAT,
				RD0.RD0_NOME,
				RD0.RD0_CODIGO,
				SRA.RA_NOME,
				SRA.RA_NOMECMP,
				SRA.RA_ADMISSA,
				SRA.RA_DEPTO,
				RD4.RD4_ITEM,
				RD4.RD4_TREE,
				RD4.RD4_CHAVE,
				SRA.RA_CC,
				SRA.RA_CARGO,
				SRA.RA_CODFUNC,
				SRA.RA_SALARIO,
				SRA.RA_CATFUNC,
				SRA.RA_HRSMES,
				SZE.ZE_MEDTOT,
				SZE.ZE_PENDENC,
				RD4.RD4_ITEM
				
				FROM %table:RD0% RD0

				INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIGO = %exp:cVision% AND
				RD4.RD4_FILIAL = %xfilial:RD4%        AND
				RD4.RD4_TREE = %exp:cItemVis% AND
				RD4.%notdel%

				INNER JOIN %table:RDE% RDE ON RDE.RDE_CODVIS = %exp:cVision% AND
				RDE.RDE_CODPAR = RD0.RD0_CODIGO AND
				RDE.RDE_FILIAL = %xfilial:RDE% AND 
				RDE.RDE_ITEVIS = RD4.RD4_ITEM AND
				RDE.RDE_STATUS = '1' AND
				RDE.%notdel%

				INNER JOIN %table:RDZ% RDZ ON RDZ.RDZ_CODRD0 = RDE.RDE_CODPAR AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%    		  AND
				RDZ.RDZ_EMPENT = %exp:cEmpSM0%    		  AND
				RDZ.%notdel%

				INNER JOIN %table:SRA% SRA  ON SRA.RA_FILIAL || SRA.RA_MAT = RDZ.RDZ_CODENT AND
				SRA.D_E_L_E_T_ = '' 
				
				LEFT JOIN %table:SZE% SZE  ON SZE.ZE_FILIAL = %xfilial:RD0%   AND
				SZE.ZE_CODRD0 = RD0.RD0_CODIGO           AND
				SZE.ZE_IDCONS = %exp:self:Policy%        AND
				SZE.ZE_GRUPO = '99'                      AND
     			SZE.%notdel%

				WHERE 
				RD0.%notDel% and (SRA.RA_DEMISSA = '' or (SRA.RA_DEMISSA <= %exp:cDatFim% and SRA.RA_ADMISSA >= %exp:cDatIni% )) 
		
				%exp:cWhereOrder%

			EndSql

			COUNT TO nRecCount
			(cRD4Alias)->(DbGoTop())

			::EmployeeData:PagesTotal := Ceiling(nRecCount / Self:PageLength)
			If ::Page > 1
				(cRD4Alias)->(DBSkip((::Page-1) * Self:PageLength))
			EndIf
			
			While (cRD4Alias)->( !Eof() ) .AND.;
					Len(::EmployeeData:ListOfEmployee) <= Self:PageLength

				If (cRD4Alias)->RA_FILIAL + (cRD4Alias)->RA_MAT <> aRet[3] + aRet[1]
					If aScan( EmployeeData:ListOfEmployee, {|x| AllTrim( x:EmployeeFilial ) == AllTrim( (cRD4Alias)->RA_FILIAL ) .And. AllTrim( x:Registration ) == AllTrim( (cRD4Alias)->RA_MAT ) } ) == 0
						nFunc++
						aadd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
						::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial  	:= (cRD4Alias)->RA_FILIAL
						::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= (cRD4Alias)->RA_MAT
						::EmployeeData:ListOfEmployee[nFunc]:ParticipantID  	   := (cRD4Alias)->RD0_CODIGO
						::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(If(! Empty((cRD4Alias)->RA_NOMECMP),(cRD4Alias)->RA_NOMECMP,If(!Empty((cRD4Alias)->RD0_NOME),(cRD4Alias)->RD0_NOME,(cRD4Alias)->RA_NOME)))						
						::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(STOD((cRD4Alias)->RA_ADMISSA))
						::EmployeeData:ListOfEmployee[nFunc]:Department    		:= (cRD4Alias)->RA_DEPTO
						::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment   	:= Alltrim(Posicione('SQB',1,xFilial("SQB")+(cRD4Alias)->RA_DEPTO,'SQB->QB_DESCRIC'))
						::EmployeeData:ListOfEmployee[nFunc]:Item          		:= (cRD4Alias)->RD4_ITEM
						::EmployeeData:ListOfEmployee[nFunc]:SupFilial      	   := ::EmployeeData:ListOfEmployee[1]:EmployeeFilial
						::EmployeeData:ListOfEmployee[nFunc]:SupRegistration	   := ::EmployeeData:ListOfEmployee[1]:Registration
						::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= aRet[2]
						::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= (cRD4Alias)->RD4_CHAVE
						::EmployeeData:ListOfEmployee[nFunc]:LevelHierar		   := (len(Alltrim((cRD4Alias)->RD4_CHAVE))/3)-1
						::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "2"
						::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= ::EmployeeData:ListOfEmployee[1]:LevelHierar
						::EmployeeData:ListOfEmployee[nFunc]:Situacao			   := (cRD4Alias)->RA_SITFOLH
						::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + (cRD4Alias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRD4Alias)->RA_FILIAL))
						::EmployeeData:ListOfEmployee[nFunc]:CostId				:= (cRD4Alias)->RA_CC
						::EmployeeData:ListOfEmployee[nFunc]:Cost				    := Alltrim(Posicione('CTT',1,xFilial("CTT",(cRD4Alias)->RA_FILIAL)+(cRD4Alias)->RA_CC,'CTT->CTT_DESC01'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionId       	:= (cRD4Alias)->RA_CODFUNC
						::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc     	:= Alltrim(Posicione('SRJ',1,xFilial("SRJ", SRA->RA_FILIAL)+(cRD4Alias)->RA_CODFUNC,'SRJ->RJ_DESC'))
						::EmployeeData:ListOfEmployee[nFunc]:PositionId     	    := (cRD4Alias)->RA_CARGO
						::EmployeeData:ListOfEmployee[nFunc]:Position            := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+(cRD4Alias)->RA_CARGO,'SQ3->Q3_DESCSUM'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst       := .F.
						::EmployeeData:ListOfEmployee[nFunc]:Salary			    := (cRD4Alias)->RA_SALARIO
						::EmployeeData:ListOfEmployee[nFunc]:total               := 1
						::EmployeeData:ListOfEmployee[nFunc]:FilialDescr	        := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
						::EmployeeData:ListOfEmployee[nFunc]:CatFunc		        := (cRD4Alias)->RA_CATFUNC
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc	        := Alltrim(FDESC("SX5","28"+(cRD4Alias)->RA_CATFUNC,"X5DESCRI()"))
						::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic 	     := .F.
				    	::EmployeeData:ListOfEmployee[nFunc]:HoursMonth 			 := Transform((cRD4Alias)->ZE_MEDTOT,"@R 999." + Replicate('9',nArred))
				    	::EmployeeData:ListOfEmployee[nFunc]:Situacao	 			 := if(empty((cRD4Alias)->ZE_PENDENC),"X",(cRD4Alias)->ZE_PENDENC)

						//Verifica se o funcionario possui equipe
						If RD4->(dbseek(xFilial("RD4", aRet[3]) + cVision + (cRD4Alias)->RD4_ITEM ))
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .T.
						Else
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .F.
						EndIf
	
					EndIf

				EndIf
				(cRD4Alias)->( DbSkip() )
			EndDo
			
			(cRD4Alias)->( DbCloseArea() )

	Else
		lRetorno := .F.
		SetSoapFault("GetStructure3",PorEncode(STR0004))	 //"Participante nao encontrado no cadastro de funcionários."
	EndIf

	
RETURN .T.



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetPolicies         ³ Autor ³Marcelo Faria        ³Data ³05.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Metodo para buscar politica de avaliacao consolidada                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal GCH                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetPolicies WSRECEIVE Policy WSSEND PolicyData WSSERVICE RHAPDConsolidated
Local nP         := 1
Local nI         := 0
Local cWhere     := ""
Local cQuerySZC  := GetNextAlias()
Local cQuerySZD  := GetNextAlias()
Local cQueryRD6  := ''
Local aBoxTipo   := RetSx3Box( Posicione("SX3", 2, "RDU_TIPO", "X3CBox()" ),,, 1 )

DEFAULT Self:Policy := ""

    //Busca SZC (Cabeçalho da Politica)
    //*********************************
    cWhere := "%"
    cWhere += " AND ZC_STATUS <> '2'" //cancelado
    cWhere += " AND ZC_PORTAL = '1'"  //mostra no portal
    If !empty(Self:Policy)
       cWhere += " AND ZC_CODIGO = '" + Self:Policy  + "'"
    EndIf
    cWhere += "%"

    BeginSql alias cQuerySZC
        SELECT *
        FROM %table:SZC% SZC
        WHERE SZC.%notDel%               
              %exp:cWhere%
    EndSql 

    ::PolicyData               := WsClassNew('TPolicyData')
    ::PolicyData:ItemsTotal    := 0
    ::PolicyData:ItemsOfPolicy := {}

    While !(cQuerySZC)->(Eof())
         ::PolicyData:ItemsTotal  += 1

         aadd(::PolicyData:ItemsOfPolicy,WsClassNew('PolicyCabec'))
         ::PolicyData:ItemsOfPolicy[nP]:BranchPolicyID       := (cQuerySZC)->ZC_FILIAL
         ::PolicyData:ItemsOfPolicy[nP]:PolicyID             := (cQuerySZC)->ZC_CODIGO
         ::PolicyData:ItemsOfPolicy[nP]:PolicyDesc           := (cQuerySZC)->ZC_DESC
         ::PolicyData:ItemsOfPolicy[nP]:PercCompetence       := (cQuerySZC)->ZC_PERCOMP
         ::PolicyData:ItemsOfPolicy[nP]:PercGoal             := (cQuerySZC)->ZC_PERMETA
         ::PolicyData:ItemsOfPolicy[nP]:PercFormation        := (cQuerySZC)->ZC_PERFORM
         ::PolicyData:ItemsOfPolicy[nP]:RegID                := (cQuerySZC)->R_E_C_N_O_
         ::PolicyData:ItemsOfPolicy[nP]:ItemsTotalDetail     := 0
         ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail  := {}

         //Busca SZD (Detalhes da Politica)  
         //********************************
         cWhere := "%"
         cWhere += " AND ZD_FILIAL = '" + (cQuerySZC)->ZC_FILIAL  + "'"
         cWhere += " AND ZD_CODIGO = '" + (cQuerySZC)->ZC_CODIGO  + "'"
         cWhere += "%"

         BeginSql alias cQuerySZD
            SELECT *
            FROM %table:SZD% SZD
            WHERE SZD.%notDel%               
                 %exp:cWhere%
         EndSql 

         nI := 1
         While !(cQuerySZD)->(Eof())
            ::PolicyData:ItemsOfPolicy[nP]:ItemsTotalDetail += 1

            aadd(::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail,WsClassNew('PolicyDetail'))
            ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodID             := (cQuerySZD)->ZD_CODPER
			::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:Evaluations			:= ''  
            dbSelectArea("RDU")
            RDU->( dbSetOrder(1) )
            If RDU->( dbSeek(xFilial("RDU", (cQuerySZD)->ZD_FILIAL) + (cQuerySZD)->ZD_CODPER) )
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodDesc        := RDU->RDU_DESC
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodType        := RDU->RDU_TIPO
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodTypeDesc    := Alltrim(aBoxTipo[Ascan( aBoxTipo, { |aBox| aBox[2] = RDU->RDU_TIPO } )][3])
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodInitialDate := DToS(RDU->RDU_DATINI)
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodFinalDate   := DToS(RDU->RDU_DATFIM)
            	//Busca os codigos das avaliacoes de competencias
            	If RDU->RDU_TIPO == '4'
      				cQueryRD6  := GetNextAlias()      	
				    cWhere := "%"
			        cWhere += " AND RD6.RD6_CODPER = '" + (cQuerySZD)->ZD_CODPER  + "'"
				    cWhere += "%"
				
				    BeginSql alias cQueryRD6
				        SELECT RD6_CODIGO
				        FROM %table:RD6% RD6
				        WHERE RD6.%notDel%               
				              %exp:cWhere%
				    EndSql 
			        While !(cQueryRD6)->(Eof())
						::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:Evaluations   += (cQueryRD6)->RD6_CODIGO+"/"
            			(cQueryRD6)->(dbskip())
            		EndDo
            		(cQueryRD6)->(dbCloseArea())
            	EndIf
            Else 
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodDesc        := "Período não localizado!"
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodType        := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodTypeDesc    := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodInitialDate := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodFinalDate   := ""
            EndIf
            RDU->( DbCloseArea() )

			nI++    
            (cQuerySZD)->(dbSkip())
         EndDo
        (cQuerySZD)->(dbCloseArea())
            
        nP++
        (cQuerySZC)->(dbSkip())
    EndDo


   (cQuerySZC)->(dbCloseArea())

Return .T.

