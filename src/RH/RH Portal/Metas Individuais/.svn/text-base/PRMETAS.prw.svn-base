#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"

//TODO - Adicionado um valor alto na variavel PAGE_LENGHT por que precisa ajustar a paginação
#DEFINE PAGE_LENGTH 1000      

WSSTRUCT EstPer
	WSDATA PerFilial AS String OPTIONAL		// Filial do periodo atual
	WSDATA CdPerAtu AS String OPTIONAL			// Codigo do periodo atual 
	WSDATA DsPerAtu AS String OPTIONAL    		// Descrição do periodo atual
	WSDATA IncMetas AS Boolean OPTIONAL		// Periodo de Inclusão de metas  
	WSDATA ResMetas AS Boolean OPTIONAL    	// Periodo de Inclusão de resultados
ENDWSSTRUCT

WSSTRUCT Itens
	WSDATA Filial AS String OPTIONAL			
	WSDATA Matric AS String OPTIONAL			 
	WSDATA Periodo AS String OPTIONAL    		
	WSDATA Sequencia AS String OPTIONAL		  
	WSDATA Peso AS Integer OPTIONAL
	WSDATA Meta AS String OPTIONAL
	WSDATA Status AS String OPTIONAL
	WSDATA PercReal AS Float OPTIONAL 
	WSDATA Justific AS String OPTIONAL
	WSDATA DtaCalc AS String OPTIONAL
	WSDATA Result AS Float OPTIONAL
	WSDATA Recno AS Integer OPTIONAL
	WSDATA Exclui AS Boolean OPTIONAL
ENDWSSTRUCT

WSSTRUCT DadosRet
	WSDATA OK AS Boolean OPTIONAL
	WSDATA MSG AS String OPTIONAL
ENDWSSTRUCT

WSSTRUCT TSTRUTDATA
	WSDATA ListOfEmployee AS Array Of StrutEMPLOYEE OPTIONAL
	WSDATA Periodo  As EstPer
	WSDATA PagesTotal AS Integer OPTIONAL
ENDWSSTRUCT

WSSTRUCT StrutEMPLOYEE
	WSDATA EmployeeEmp		As String 	OPTIONAL	//Empresa do funcionario
	WSDATA EmployeeFilial	As String				//Filial do funcionario
	WSDATA Registration		As String				//Codigo da matricula
	WSDATA ParticipantID		As String 	OPTIONAL	//Codigo do participante
	WSDATA Name				As String				//Nome do funcionario
	WSDATA AdmissionDate		As String			   	//Data de Admissao
	WSDATA Department			As String 	   			//Departamento do Funcionario
	WSDATA DescrDepartment  	AS String 	OPTIONAL 	//Departamento
	WSDATA Item				As String 	OPTIONAL	//Item
	WSDATA SupEmpresa    	As String 	OPTIONAL 	//Filial do superior
	WSDATA SupFilial    		As String 	OPTIONAL  	//Filial do superior
	WSDATA SupRegistration	As String 	OPTIONAL 	//Matricula do superior
	WSDATA NameSup			As String 	OPTIONAL	//Nome do superior
	WSDATA LevelSup 			As Integer	OPTIONAL	//Nivel hierarquico do superior
	WSDATA CatFuncSup       	As String	OPTIONAL 	//categoria da funcao do superior
	WSDATA CatFuncDescSup   	As String 	OPTIONAL  	//descricao da categoria da funcao do superior
	WSDATA KeyVision			As String	OPTIONAL	//Chave
	WSDATA LevelHierar		As Integer	OPTIONAL	//Nivel na hierarquia
	WSDATA TypeEmployee		As String	OPTIONAL	//Se é o proprio funcionário ("1") ou é um funcionario da equipe ("2")
	WSDATA email				As String	OPTIONAL	//email do funcionario
	WSDATA StatusEmployee 	As String	OPTIONAL	//Status do funcionario
	WSDATA PositionId	 		As String	OPTIONAL	//Codigo do cargo
	WSDATA Position		 	As String	OPTIONAL	//descricao do cargo
	WSDATA CostId 		 	As String	OPTIONAL	//Codigo do Centro de Custo
	WSDATA Cost 		 		As String	OPTIONAL	//Centro de Custo
	WSDATA FunctionId 	 	As String	OPTIONAL	//Codigo da funcao
	WSDATA FunctionDesc		As String	OPTIONAL	//Descricao Funcao
	WSDATA FunctionSubst    	As Boolean	OPTIONAL 	//Substituiacao para a Funcao
	WSDATA Salary				As Float	OPTIONAL	//Salario
	WSDATA Total            	As Integer	OPTIONAL 	//Total de registros para paginacao
	WSDATA Situacao         	As String	OPTIONAL 	//Codigo da Situacao do funcionario
	WSDATA DescSituacao     	As String 	OPTIONAL  	//Descricao da Situacao do funcionario
	WSDATA FilialDescr      	As String 	OPTIONAL 	//Descricao da Filial
	WSDATA CatFunc		   	As String 	OPTIONAL 	//categoria da funcao
	WSDATA CatFuncDesc      	As String 	OPTIONAL  	//descricao da categoria da funcao
	WSDATA HoursMonth	    	As String 	OPTIONAL  	//Horas mensais
	WSDATA PossuiSolic      	As Boolean	OPTIONAL  	//Possui Solicitacao para este funcionario
	WSDATA PossuiEquipe     	As Boolean	OPTIONAL 	//Esse funcionario possui equipe?
	WSDATA ParticipaMetas   As Boolean	OPTIONAL 	//Participa das metas
ENDWSSTRUCT

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRMETAS
Serviço de manutenção das metas
@author  	Carlos Henrique 
@since     	05/07/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSSERVICE 	PRMETAS DESCRIPTION "Serviço de manutenção das metas"
	WSDATA PerFiltro AS String OPTIONAL			// Codigo do Perido para filtro
	WSDATA FilialFun AS String OPTIONAL			// Filial do funcionario
	WSDATA Matricula AS String OPTIONAL			// Matricula do funcionario	
	WSDATA StatusMetas AS String OPTIONAL			// Status da meta
	WSDATA OK AS Boolean OPTIONAL					// Variavel logica de controle
	WSDATA Periodo As EstPer 						// Periodo
	WSDATA Metas As Array OF Itens OPTIONAL		// Array de metas
	WSDATA XmlMetas AS BASE64Binary OPTIONAL 		// Xml de metas
	WSDATA Ret as DadosRet OPTIONAL					// Array de dados das metas
	WSDATA ParticipantId	as String OPTIONAL		// Codigo do Participante
	WSDATA Period as String OPTIONAL				// Período
	WSDATA EmployeeFil as String OPTIONAL			// Filial do funcionario
	WSDATA Registration as String OPTIONAL			// Codigo da matricula
	WSDATA Page as Integer OPTIONAL					// Numero da Pagina, para paginacao
	WSDATA FilterField as String OPTIONAL			// Campo para filtro
	WSDATA FilterValue as String OPTIONAL			// Condicao de filtro das querys
	WSDATA EmployeeData as TSTRUTDATA				// Estrutura Organizacional
	
	WSMETHOD GETPERSTRUCT DESCRIPTION "Consulta estrutura de acordo com periodo"
	WSMETHOD GETMETAS	DESCRIPTION "Busca as metas do funcionario"
	WSMETHOD PUTMETAS	DESCRIPTION "Grava as metas do funcionario"	
ENDWSSERVICE
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GetPerStruct
Consulta estrutura
@author  	Carlos Henrique 
@since     	05/07/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD GETPERSTRUCT WSRECEIVE ParticipantID, Period, EmployeeFil, Registration, Page, FilterValue, FilterField,StatusMetas WSSEND EmployeeData WSSERVICE PRMETAS
Local lRetorno       := .T.
Local nFunc		   	:= 0
Local cParticipantId := ""
Local cRDEAlias      := GetNextAlias()
Local cRD4Alias      := GetNextAlias()
Local cAuxAlias      := GetNextAlias()
Local cAuxAlias1 	 	:= GetNextAlias()
Local cSupAlias 	 	:= GetNextAlias()
Local cVision			:= ""
Local cEmpSM0	     	:= SM0->M0_CODIGO
Local aRet           := {}
Local aSuperior      := {}
Local PageLen  		:= PAGE_LENGTH //20 
Local nX 			 	:= 0
Local nRecCount 	 	:= 0
Local cWhere    	 	:= ""
Local nTamEmpFil	 	:= TamSX3("RDZ_FILENT")[1]	//Tamanho do campo RDZ_FILENT
Local nTamRegist	 	:= TamSX3("RDZ_CODENT")[1]	//Tamanho do campo RDZ_CODENT
Local cRegist			:= ""
Local cCampo			:= ""
Local cFiltro			:= ""
Local dDatRef			:= DATE()	
DEFAULT Self:ParticipantID  := ""
DEFAULT Self:Period 	  		:= ""
DEFAULT Self:EmployeeFil		:= ""
DEFAULT Self:Registration	:= ""
DEFAULT Self:Page 			:= 1
DEFAULT Self:FilterField		:= ""
DEFAULT Self:FilterValue		:= ""

::EmployeeData:Periodo:PerFilial:= ""
::EmployeeData:Periodo:CdPerAtu := ""
::EmployeeData:Periodo:DsPerAtu := ""


DBSELECTAREA("RDU")
RDU->(DBGOTOP())
IF !EMPTY(::Period)
	IF RDU->(DBSEEK(XFILIAL("RDU")+::Period))
		::EmployeeData:Periodo:PerFilial:= RDU->RDU_FILIAL
		::EmployeeData:Periodo:CdPerAtu := RDU->RDU_CODIGO
		::EmployeeData:Periodo:DsPerAtu := RDU->RDU_DESC

		//Verifica as permissoes conforme as datas do cadastro de períodos RDU, o qual ja esta posicionado.
		IF dDatRef >= RDU->RDU_INIINC .and. dDatRef <= RDU->RDU_FIMINC
			::EmployeeData:Periodo:IncMetas := .T.
		ENDIF
		
		IF dDatRef >= RDU->RDU_INIRES .and. dDatRef <= RDU->RDU_FIMRES
			::EmployeeData:Periodo:ResMetas := .T.
		ENDIF
		
		cVision	:= RDU->RDU_XVISAO
					
	ENDIF
ELSE
	WHILE !RDU->(EOF())
		//Perido atual		
		IF dDatRef >= RDU->RDU_DATINI .and. dDatRef <= RDU->RDU_DATFIM .and. RDU->RDU_TIPO=="3"
			::EmployeeData:Periodo:PerFilial:= RDU->RDU_FILIAL
			::EmployeeData:Periodo:CdPerAtu := RDU->RDU_CODIGO
			::EmployeeData:Periodo:DsPerAtu := RDU->RDU_DESC
			::Period:= RDU->RDU_CODIGO
			//Verifica as permissoes conforme as datas do cadastro de períodos RDU, o qual ja esta posicionado.
			IF dDatRef >= RDU->RDU_INIINC .and. dDatRef <= RDU->RDU_FIMINC
				::EmployeeData:Periodo:IncMetas := .T.
			ENDIF
			
			IF dDatRef >= RDU->RDU_INIRES .and. dDatRef <= RDU->RDU_FIMRES
				::EmployeeData:Periodo:ResMetas := .T.
			ENDIF			
			
			cVision	:= RDU->RDU_XVISAO
				
		ENDIF	
	RDU->(DBSKIP())
	END	
ENDIF

cCampo		:= Self:FilterField
cFiltro	:= Self:FilterValue

//Verifica se possui visão informada no periodo                             
IF !EMPTY(::Period) .and. EMPTY(cVision)
	
	SetSoapFault("GetPerStruct",PorEncode("Visão não encontrada no período "+::Period))	 
	Return(.F.)

//Não monta estrutura caso o periodo não seja informado                             
ELSEIF EMPTY(::Period) 
	
	RETURN(lRetorno)
	
ENDIF

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
	
	BeginSQL ALIAS cRDEAlias
		SELECT RD4.RD4_EMPIDE,
			  SRA.RA_SITFOLH,
			  SRA.RA_FILIAL,
			  SRA.RA_MAT,
			  RD0.RD0_NOME,
			  RD0.RD0_CODIGO,
			  SRA.RA_NOME,
			  SRA.RA_NOMECMP,
			  SRA.RA_ADMISSA,
			  RDE.RDE_XDEPTO,
			  RD4.RD4_DESC,
			  RD4.RD4_ITEM,
			  RD4.RD4_TREE,
			  RD4.RD4_CHAVE,
			  RD4.RD4_EMPIDE,
			  SRA.RA_CC,
			  SRA.RA_CARGO,
			  SRA.RA_CODFUNC,
			  SRA.RA_SALARIO,
			  SRA.RA_CATFUNC,
			  SRA.RA_HRSMES  
		FROM %TABLE:RDE% RDE
		INNER JOIN %TABLE:RD0% RD0 ON RD0.RD0_FILIAL=%xfilial:RD0%
		  AND RD0.RD0_CODIGO = RDE.RDE_CODPAR
		  AND RD0.RD0_FILIAL = %xfilial:RD0%
		  AND RD0.%notDel%	
		INNER JOIN %TABLE:SRA% SRA
		  ON SRA.RA_MAT = RD0.RD0_MAT
		  AND SRA.RA_SITFOLH <> 'D'
		  AND SRA.%notDel%  	  
		INNER JOIN %TABLE:RD4% RD4 ON RD4_CODIGO=RDE.RDE_CODVIS
			AND RD4.RD4_ITEM=RDE.RDE_ITEVIS
			AND RD4.%notDel%
		WHERE RDE.RDE_FILIAL=%xfilial:RDE%
			AND RDE_CODPAR=%exp:cParticipantId%
			AND RDE_CODVIS=%exp:cVision%
			AND RDE_STATUS='1'
			AND RDE.%notDel%	
	EndSQL
	
	//GETLastQuery()[2]

	(cRDEAlias)->(dbSelectArea((cRDEAlias)))                    
	(cRDEAlias)->(dbGoTop())  	

	IF (cRDEAlias)->( !Eof() )

		::EmployeeData:ListOfEmployee := {}
		aadd(::EmployeeData:ListOfEmployee,WsClassNew('StrutEMPLOYEE'))
		nFunc++
		::EmployeeData:ListOfEmployee[nFunc]:EmployeeEmp	 		:= cEmpAnt
		::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial 		:= (cRDEAlias)->RA_FILIAL
		::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= (cRDEAlias)->RA_MAT
		::EmployeeData:ListOfEmployee[nFunc]:ParticipantID		:= cParticipantId
		::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim((cRDEAlias)->RA_NOME)
		::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(STOD((cRDEAlias)->RA_ADMISSA))
		::EmployeeData:ListOfEmployee[nFunc]:Department    		:= (cRDEAlias)->RDE_XDEPTO
		::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment		:= (cRDEAlias)->RD4_DESC 	

		//Ajusta descrição do Departamento
		U_PRPORE01(@::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment)
		
		::EmployeeData:ListOfEmployee[nFunc]:Item          		:= (cRDEAlias)->RD4_ITEM
		::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= (cRDEAlias)->RD4_CHAVE
		::EmployeeData:ListOfEmployee[nFunc]:LevelHierar			:= (len(Alltrim((cRDEAlias)->RD4_CHAVE))/3)-1
		::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "1"
		::EmployeeData:ListOfEmployee[nFunc]:Situacao				:= (cRDEAlias)->RA_SITFOLH
		::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + (cRDEAlias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRDEAlias)->RA_FILIAL))
		::EmployeeData:ListOfEmployee[nFunc]:FunctionId      	:= (cRDEAlias)->RA_CODFUNC
		::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc    	:= GetAnyDesc((cRDEAlias)->RD4_EMPIDE, (cRDEAlias)->RA_FILIAL, "SRJ", (cRDEAlias)->RA_CODFUNC)
		::EmployeeData:ListOfEmployee[nFunc]:CostId           	:= (cRDEAlias)->RA_CC
		::EmployeeData:ListOfEmployee[nFunc]:Cost             	:= Alltrim(Posicione('CTT',1,xFilial("CTT",(cRDEAlias)->RA_FILIAL)+(cRDEAlias)->RA_CC,'CTT->CTT_DESC01'))
		::EmployeeData:ListOfEmployee[nFunc]:PositionId			:= (cRDEAlias)->RA_CARGO
		::EmployeeData:ListOfEmployee[nFunc]:Position      		:= GetAnyDesc((cRDEAlias)->RD4_EMPIDE, (cRDEAlias)->RA_FILIAL, "SQ3", (cRDEAlias)->RA_CARGO)
		::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst    	:= .F.		
		::EmployeeData:ListOfEmployee[nFunc]:Salary				:= (cRDEAlias)->RA_SALARIO
		::EmployeeData:ListOfEmployee[nFunc]:FilialDescr			:= Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
		::EmployeeData:ListOfEmployee[nFunc]:CatFunc				:= (cRDEAlias)->RA_CATFUNC
		::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc			:= Alltrim(FDESC("SX5","28"+(cRDEAlias)->RA_CATFUNC,"X5DESCRI()"))
		::EmployeeData:ListOfEmployee[nFunc]:HoursMonth			:= Alltrim(Str((cRDEAlias)->RA_HRSMES))
		::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic 		:= .F.
		::EmployeeData:ListOfEmployee[nFunc]:ParticipaMetas		:= SITMETAS(	::Period,;
																						::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial,;
																						::EmployeeData:ListOfEmployee[nFunc]:Registration,;
																						::StatusMetas)

		//Busca Informações do superior de acordo com a visão
		BeginSQL ALIAS cSupAlias
			SELECT SRA.RA_FILIAL,
			       SRA.RA_MAT,
			  		SRA.RA_NOME,
			  		SRA.RA_CATFUNC,
			  		RD4.RD4_CHAVE
			FROM %TABLE:RD4% RD4				
			INNER JOIN %TABLE:RDE% RDE ON RDE.RDE_CODVIS=RD4_CODIGO
				AND RDE.RDE_ITEVIS=RD4.RD4_ITEM
				AND RDE_STATUS='1'
				AND RDE.%notDel%			
			INNER JOIN %TABLE:RD0% RD0 ON RD0.RD0_FILIAL=%xfilial:RD0%
			  AND RD0.RD0_CODIGO = RDE.RDE_CODPAR
			  AND RD0.RD0_FILIAL = %xfilial:RD0%
			  AND RD0.%notDel%	
			INNER JOIN %TABLE:SRA% SRA
			  ON SRA.RA_MAT = RD0.RD0_MAT
			  AND SRA.RA_SITFOLH <> 'D'
			  AND SRA.%notDel%  	  
			WHERE RD4.RD4_FILIAL=%xfilial:RD4%
				AND RD4_CODIGO=%exp:cVision%
				AND RD4_ITEM=%exp:(cRDEAlias)->RD4_TREE%			
				AND RD4.%notDel%				
		EndSQL
		
		//GETLastQuery()[2]
		
		(cSupAlias)->(dbSelectArea((cSupAlias)))                    
		(cSupAlias)->(dbGoTop())		
		
		If !(cSupAlias)->(Eof())
			::EmployeeData:ListOfEmployee[nFunc]:SupFilial      		:= (cSupAlias)->RA_FILIAL
			::EmployeeData:ListOfEmployee[nFunc]:SupRegistration		:= (cSupAlias)->RA_MAT
			::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= (cSupAlias)->RA_NOME
			::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= (len(Alltrim((cSupAlias)->RD4_CHAVE))/3)-1
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncSup      	:= If(!Empty((cSupAlias)->RA_NOME),(cSupAlias)->RA_CATFUNC,"")
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncDescSup  	:= ""
			::EmployeeData:ListOfEmployee[nFunc]:SupEmpresa      	:= ""		
		Else
			::EmployeeData:ListOfEmployee[nFunc]:SupFilial      		:= ""
			::EmployeeData:ListOfEmployee[nFunc]:SupRegistration		:= ""
			::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= ""
			::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= 99
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncSup      	:= ""
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncDescSup 		:= ""
			::EmployeeData:ListOfEmployee[nFunc]:SupEmpresa      	:= ""
		EndIf
		(cSupAlias)->(dbCloseArea())

		//Monta Filtro                                                              
		cWhere := "RD4_TREE='"+(cRDEAlias)->RD4_ITEM+"'"
		If !Empty(cFiltro) .AND. !Empty(cCampo)
			If(cCampo == "1")
				
				//Filtro por matricula                                                       
				cWhere += " AND SRA.RA_MAT LIKE '%" + Replace(cFiltro,"'","") + "%'"
								
			ElseIf(cCampo == "2")
				
				////Filtro por Nome                                                            
				cWhere += " AND SRA.RA_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
				
			EndIf
		EndIf		
		
		cWhere:= "%"+cWhere+"%"
		
		BeginSQL ALIAS cRD4Alias
			SELECT DISTINCT RD4.RD4_EMPIDE,
				  SRA.RA_SITFOLH,
				  SRA.RA_FILIAL,
				  SRA.RA_MAT,
				  RD0.RD0_NOME,
				  RD0.RD0_CODIGO,
				  SRA.RA_NOME,
				  SRA.RA_NOMECMP,
				  SRA.RA_ADMISSA,
				  RDE.RDE_XDEPTO, 
				  RD4.RD4_DESC,
				  RD4.RD4_ITEM,
				  RD4.RD4_TREE,
				  RD4.RD4_CHAVE,
				  RD4.RD4_EMPIDE,
				  SRA.RA_CC,
				  SRA.RA_CARGO,
				  SRA.RA_CODFUNC,
				  SRA.RA_SALARIO,
				  SRA.RA_CATFUNC,
				  SRA.RA_HRSMES  
			FROM %TABLE:RD4% RD4
			INNER JOIN %TABLE:RDE% RDE ON RDE.RDE_CODVIS=RD4_CODIGO
				AND RDE.RDE_ITEVIS=RD4.RD4_ITEM
				AND RDE_STATUS='1'
				AND RDE.%notDel%			
			INNER JOIN %TABLE:RD0% RD0 ON RD0.RD0_FILIAL=%xfilial:RD0%
			  AND RD0.RD0_CODIGO = RDE.RDE_CODPAR
			  AND RD0.RD0_FILIAL = %xfilial:RD0%
			  AND RD0.%notDel%	
			INNER JOIN %TABLE:SRA% SRA
			  ON SRA.RA_MAT = RD0.RD0_MAT
			  AND SRA.RA_SITFOLH <> 'D'
			  AND SRA.%notDel%  	  
			WHERE RD4.RD4_FILIAL=%xfilial:RD4%
				AND RD4_CODIGO=%exp:cVision%
				AND RD4_TREE=%exp:(cRDEAlias)->RD4_ITEM%
				AND %exp:cWhere% 				
				AND RD4.%notDel%
			ORDER BY RD4_ITEM			
		EndSQL
		
		//GETLastQuery()[2]	
		
		COUNT TO nRecCount
		
		(cRD4Alias)->(dbSelectArea((cRD4Alias)))                    
		(cRD4Alias)->(dbGoTop())	
		
		::EmployeeData:PagesTotal     := Ceiling(nRecCount / PAGE_LENGTH)
		If ::Page > 1
			(cRD4Alias)->(DBSkip((::Page-1) * PAGE_LENGTH))
		EndIf
		
		While (cRD4Alias)->( !Eof() ) .AND.	Len(::EmployeeData:ListOfEmployee) <= PAGE_LENGTH
			If (cRD4Alias)->RA_FILIAL + (cRD4Alias)->RA_MAT <> aRet[3] + aRet[1]
				If aScan( EmployeeData:ListOfEmployee, {|x| AllTrim( x:EmployeeFilial ) == AllTrim( (cRD4Alias)->RA_FILIAL ) .And. AllTrim( x:Registration ) == AllTrim( (cRD4Alias)->RA_MAT ) } ) == 0
					nX++
					If ::Page == 0 .Or. nX >= ::Page
						nFunc++
						aadd(::EmployeeData:ListOfEmployee,WsClassNew('StrutEMPLOYEE'))
						::EmployeeData:ListOfEmployee[nFunc]:EmployeeEmp	  		:= (cRD4Alias)->RD4_EMPIDE
						::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial  	:= (cRD4Alias)->RA_FILIAL
						::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= (cRD4Alias)->RA_MAT
						::EmployeeData:ListOfEmployee[nFunc]:ParticipantID  		:= (cRD4Alias)->RD0_CODIGO
						::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(substr(if(!Empty((cRD4Alias)->RD0_NOME),(cRD4Alias)->RD0_NOME,If(!Empty((cRD4Alias)->RA_NOME),(cRD4Alias)->RA_NOME,"")),1,28))
						::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(STOD((cRD4Alias)->RA_ADMISSA))
						::EmployeeData:ListOfEmployee[nFunc]:Department    		:= (cRD4Alias)->RDE_XDEPTO 
						::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment   	:= (cRD4Alias)->RD4_DESC 
						
						//Ajusta descrição do Departamento
						U_PRPORE01(@::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment)
						
						::EmployeeData:ListOfEmployee[nFunc]:Item          		:= (cRD4Alias)->RD4_ITEM
						::EmployeeData:ListOfEmployee[nFunc]:SupFilial      		:= ::EmployeeData:ListOfEmployee[1]:EmployeeFilial
						::EmployeeData:ListOfEmployee[nFunc]:SupRegistration		:= ::EmployeeData:ListOfEmployee[1]:Registration
						::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= aRet[2]
						::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= (cRD4Alias)->RD4_CHAVE
						::EmployeeData:ListOfEmployee[nFunc]:LevelHierar			:= (len(Alltrim((cRD4Alias)->RD4_CHAVE))/3)-1
						::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "2"
						::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= ::EmployeeData:ListOfEmployee[1]:LevelHierar
						::EmployeeData:ListOfEmployee[nFunc]:Situacao				:= (cRD4Alias)->RA_SITFOLH
						::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + (cRD4Alias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRD4Alias)->RA_FILIAL))
						::EmployeeData:ListOfEmployee[nFunc]:CostId				:= (cRD4Alias)->RA_CC
						::EmployeeData:ListOfEmployee[nFunc]:Cost					:= Alltrim(Posicione('CTT',1,xFilial("CTT",(cRD4Alias)->RA_FILIAL)+(cRD4Alias)->RA_CC,'CTT->CTT_DESC01'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionId       	:= (cRD4Alias)->RA_CODFUNC
						::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc     	:= GetAnyDesc((cRD4Alias)->RD4_EMPIDE, (cRD4Alias)->RA_FILIAL, "SRJ", (cRD4Alias)->RA_CODFUNC) 
						::EmployeeData:ListOfEmployee[nFunc]:PositionId     		:= (cRD4Alias)->RA_CARGO
						::EmployeeData:ListOfEmployee[nFunc]:Position         	:= GetAnyDesc((cRD4Alias)->RD4_EMPIDE, (cRD4Alias)->RA_FILIAL, "SQ3", (cRD4Alias)->RA_CARGO) //Alltrim(Posicione('SQ3',1,xFilial("SQ3")+(cRD4Alias)->RA_CARGO,'SQ3->Q3_DESCSUM'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst     	:= .F.
						::EmployeeData:ListOfEmployee[nFunc]:Salary				:= (cRD4Alias)->RA_SALARIO
						::EmployeeData:ListOfEmployee[nFunc]:total          		:= 1
						::EmployeeData:ListOfEmployee[nFunc]:FilialDescr			:= Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
						::EmployeeData:ListOfEmployee[nFunc]:CatFunc				:= (cRD4Alias)->RA_CATFUNC
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc			:= Alltrim(FDESC("SX5","28"+(cRD4Alias)->RA_CATFUNC,"X5DESCRI()"))
						::EmployeeData:ListOfEmployee[nFunc]:HoursMonth			:= Alltrim(Str((cRD4Alias)->RA_HRSMES))
						::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic 		:= .F.
						::EmployeeData:ListOfEmployee[nFunc]:ParticipaMetas		:= SITMETAS(	::Period,;
																										::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial,;
																										::EmployeeData:ListOfEmployee[nFunc]:Registration,;
																										::StatusMetas)					
									
						
						//Verifica se o participante possui equipe
						BeginSQL ALIAS cAuxAlias1
							SELECT RD4.RD4_ITEM
							FROM %TABLE:RD4% RD4
							WHERE RD4.RD4_FILIAL=%xfilial:RD4%
								AND RD4_CODIGO=%exp:cVision%
								AND RD4_TREE=%exp:(cRD4Alias)->RD4_ITEM%				
								AND RD4.%notDel%	
						EndSQL
						
						//GETLastQuery()[2]

						(cAuxAlias1)->(dbSelectArea((cAuxAlias1)))                    
						(cAuxAlias1)->(dbGoTop())							
						
						If !(cAuxAlias1)->(Eof())
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe 	:= .T.
						Else
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe 	:= .F.
						EndIf
						(cAuxAlias1)->(dbCloseArea())
						
						
						If(valtype(PageLen)) == "C"
							PageLen = val(PageLen)
						EndIf
						
						If len(::EmployeeData:ListOfEmployee) >= PageLen .And. PageLen <> 0
							Exit
						EndIf
					EndIf
				EndIf
			EndIf
			(cRD4Alias)->( DbSkip() )
		EndDo
		(cRD4Alias)->( DbCloseArea() )																															
	ENDIF	
	(cRDEAlias)->( dbCloseArea() )
Else
	lRetorno := .F.
	SetSoapFault("GetPerStruct",PorEncode("Participante não encontrado no cadastro de funcionários."))
EndIf
	
RETURN(lRetorno)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} SITMETAS
Valida a situação do funcionario para lançamento de metas
@author  	Carlos Henrique 
@since     	05/07/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION SITMETAS(cPerFiltro,cFilialFun,cMatFun,cStatusMetas)
Local lRet 	:= .T.
Local cQry		:= "" 
Local cTab 	:= ""
Local cCargo	:= ""

DBSELECTAREA("SRA")
DBSETORDER(1)
IF SRA->(DBSEEK(cFilialFun+cMatFun))
	cCargo	:= SRA->RA_CARGO
	//Verifica se participa da avaliação de metas
	IF SRA->RA_XMETAS == "N" 
		lRet := .F.
	ENDIF	
ELSE
	lRet := .F.	
ENDIF

// Verifica cadastro de gratificação
/*
IF lRet
	cTab:= GetNextAlias()
	cQry := " SELECT PA2_MAT FROM "+RetSqlName("PA2") + " PA2"
	cQry += " INNER JOIN "+RetSqlName("PA0") + " PA0 ON PA0_FILIAL='"+xfilial("PA0")+"'"
	cQry += "	AND PA0_GRUPO=PA2_GRUPO"
	cQry += "	AND PA0_MODAVA IN('  ','04','09','10','11','12','13')" 
	cQry += "	AND PA0.D_E_L_E_T_=''"
	cQry += " WHERE PA2_FILIAL='"+xfilial("PA2")+"'" 
	cQry += " AND PA2_MAT= '"+cMatFun+"'"
	cQry += " AND ( ('"+DTOS(DATE())+"' BETWEEN PA2_DATAIN AND PA2_DATFIM     ) or "
	cQry += "       ('"+DTOS(DATE())+"'    >=   PA2_DATAIN AND PA2_DATFIM = '') )  "
	cQry += " AND PA2_TIPO='1'"
	cQry += " AND PA2.D_E_L_E_T_=''"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTab, .F., .T.)
	
	(cTab)->(DbGoTop())
	If !(cTab)->(Eof()) //Se possuir registro não participa
		lRet := .F.
	EndIf
	(cTab)->(DbCloseArea())
EndIf
*/

// Devido a mudança da exibição do portal pelas alocação foi retirado este filtro
/*
//Checa cadastro de cargo 
IF lRet
	cTab:= GetNextAlias()
	cQry := " SELECT * FROM "+RetSqlName("SQ3") + " SQ3"
	cQry += " WHERE Q3_FILIAL='"+xfilial("SQ3")+"'" 
	cQry += " AND Q3_CARGO= '"+cCargo+"'"
	cQry += " AND Q3_XNRAVAL IN ('  ','04')"
	cQry += " AND SQ3.D_E_L_E_T_=''"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTab, .F., .T.)
	
	(cTab)->(DbGoTop())
	If !(cTab)->(Eof()) //Se possuir registro não participa
		lRet := .F.
	EndIf
	(cTab)->(DbCloseArea())
EndIf
*/

IF lRet .AND. cStatusMetas == "1" //Sem Metas
	
	cTab:= GetNextAlias()
	
	cQry := "SELECT * FROM "+RetSqlName("SZ0") + " SZ0 "
	cQry += "WHERE "
	cQry += "SZ0.Z0_FILIAL = '"+cFilialFun+"' AND "
	cQry += "SZ0.Z0_MAT	 = '"+cMatFun+"' AND "
	cQry += "SZ0.Z0_CODPER = '"+cPerFiltro+"' AND "
	cQry += "SZ0.Z0_STATUS = '1' AND "
	cQry += "SZ0.D_E_L_E_T_ = '' "
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTab, .F., .T.)
	
	(cTab)->(DbGoTop())
	
	If (cTab)->(Eof()) //Se não possui registro na tabela
		lRet := .T.
	Else
		lRet := .F.
	EndIf
	
	(cTab)->(DbCloseArea())

ELSEIF lRet .AND. cStatusMetas == "2" //Sem Percentual de Atingimento
	
	cTab:= GetNextAlias()
	cQry := "SELECT * FROM "+RetSqlName("SZ0") + " SZ0 "
	cQry += "WHERE " 
	cQry += "SZ0.Z0_FILIAL  = '"+cFilialFun+"' AND "
	cQry += "SZ0.Z0_MAT	  = '"+cMatFun+"' AND "
	cQry += "SZ0.Z0_CODPER  = '"+cPerFiltro+"' AND "
	cQry += "SZ0.Z0_STATUS  = '1' AND "
	cQry += "SZ0.Z0_PERC    = 0   AND "
	cQry += "SZ0.D_E_L_E_T_ = '' "
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTab, .F., .T.)
	
	(cTab)->(DbGoTop())
	If (cTab)->(Eof()) //Se não possui registro na tabela sem percentual
		lRet := .T.
	Else
		lRet := .F.
	EndIf
	
	(cTab)->(DbCloseArea()) 	
ENDIF

Return lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GetAnyDesc
Retona a descrição de acordo com a tabela e chave
@author  	Totvs 
@since     	05/07/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC Function GetAnyDesc(cEmp, cFil, cTab, cChv)
Local aArea 		:= GetArea()
Local cAliasQry	:= GetNextAlias()
Local cDescr		:= ""
Local cTabela		:= ""
Local nPos			:= 0

Default cEmp := cEmpAnt 

cTabela	:= "%"+Retsqlname(cTab)+"%"

If cTab == "SQ3"
	BeginSQL alias cAliasQry
		SELECT SQ3.Q3_DESCSUM
		  FROM %exp:cTabela% SQ3
		 WHERE SQ3.Q3_FILIAL = %exp:xFilial("SQ3", cFil)% AND
		       SQ3.Q3_CARGO = %exp:cChv% AND
		       SQ3.%notDel%
	EndSQL
		
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->Q3_DESCSUM
	EndIf
ElseIf cTab == "SRJ"
	BeginSQL alias cAliasQry
		SELECT SRJ.RJ_DESC
		FROM %exp:cTabela% SRJ
		WHERE SRJ.RJ_FILIAL = %exp:xFilial("SRJ", cFil)% AND
		      SRJ.RJ_FUNCAO = %exp:cChv% AND
		      SRJ.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->RJ_DESC
	EndIf
ElseIf cTab == "SQB"
	BeginSQL alias cAliasQry
		SELECT SQB.QB_DESCRIC
		FROM %exp:cTabela% SQB
		WHERE SQB.QB_FILIAL = %exp:xFilial("SQB", cFil)% AND
		      SQB.QB_DEPTO = %exp:cChv% AND
		      SQB.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->QB_DESCRIC
	EndIf
ElseIf cTab == "SRA"
	BeginSQL alias cAliasQry
		SELECT SRA.RA_NOME
		FROM %Exp:cTabela% SRA
		WHERE SRA.RA_FILIAL = %exp:cFil% AND
	      SRA.RA_MAT = %exp:cChv% AND
	      SRA.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=Alltrim((cAliasQry)->RA_NOME)
	EndIf
		
EndIf

(cAliasQry)->(dbCloseArea())
RestArea(aArea)
Return cDescr
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GETMETAS
Busca as metas do funcionario
@author  	Carlos Henrique 
@since     	29/06/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD GETMETAS WSRECEIVE PerFiltro,FilialFun,Matricula WSSEND Metas WSSERVICE PRMETAS
Local cTab		:= GetNextAlias()
Local nItx		:= 0
Local cPerPar	:= ::PerFiltro
Local cFilPar	:= ::FilialFun
Local cMatPar	:= ::Matricula

BeginSql Alias cTab
	SELECT COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),Z0_META )),'') AS META
		,COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),Z0_JUSTIF )),'') AS JUSTIF 
		,SZ0.*  
	FROM %TABLE:SZ0% SZ0
	WHERE Z0_FILIAL=%xfilial:SZ0%
	AND Z0_MAT=%exp:cMatPar%
	AND Z0_CODPER=%exp:cPerPar%
	AND SZ0.D_E_L_E_T_=''
	ORDER BY Z0_SEQ   
EndSql

TCSETFIELD(cTab,"Z0_DTCALC","D")

//GETLastQuery()[2]
::Metas := {}
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())  
WHILE !(cTab)->(Eof())  
	aadd(::Metas,WsClassNew('Itens'))
	nItx:= LEN(::Metas)
	::Metas[nItx]:Filial 	:= (cTab)->Z0_FILIAL			
	::Metas[nItx]:Matric 	:= (cTab)->Z0_MAT			 
	::Metas[nItx]:Periodo 	:= (cTab)->Z0_CODPER    		
	::Metas[nItx]:Sequencia	:= (cTab)->Z0_SEQ		  
	::Metas[nItx]:Peso 		:= (cTab)->Z0_PESO
	::Metas[nItx]:Meta 		:= TRIM((cTab)->META)
	::Metas[nItx]:Status 	:= (cTab)->Z0_STATUS
	::Metas[nItx]:PercReal 	:= (cTab)->Z0_PERC 
	::Metas[nItx]:Justific 	:= TRIM((cTab)->JUSTIF)
	::Metas[nItx]:DtaCalc 	:= DTOC((cTab)->Z0_DTCALC)
	::Metas[nItx]:Result 	:= (cTab)->Z0_RESULT
	::Metas[nItx]:Recno 		:= (cTab)->R_E_C_N_O_
	::Metas[nItx]:Exclui 	:= .F. // Controla excluidos
(cTab)->(dbskip())
END
(cTab)->(dbCloseArea())

Return .T.
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PUTMETAS
Grava as metas do funcionario
@author  	Carlos Henrique 
@since     	29/06/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD PUTMETAS WSRECEIVE XmlMetas WSSEND Ret WSSERVICE PRMETAS
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
Local lNovo		:= .F.
Local cXml			:= Decode64(XmlMetas)
Local lExcluir	:= .F.
Local lNovo		:= .F.
Local nRecSz0		:= 0
Local nTotMetas	:= 0
Local nCnt			:= 0

oXml := XmlParser(EncodeUTF8(cXML), cDelimit, @cError, @cWarning)

IF !(Empty(cError) .and. Empty(cWarning))
	if !Empty(cError)
		::Ret:OK	:= .F.
		::Ret:MSG	:= "Erro na estrutura do xml"
    endif

	if !Empty(cWarning)   
		::Ret:OK	:= .F.
		::Ret:MSG	:= cWarning	
	endif 
ELSE
	nTotMetas 	:= IIF(Type("oXml:_ITEMS:_ITEM") == "A",Len(&("oXml:_ITEMS:_ITEM")),1)
	For nCnt := 1 to nTotMetas
		lExcluir	:= "S"$IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_EXCLUI:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_EXCLUI:TEXT) 
		nRecSz0	:= VAL(IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_RECNO:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_RECNO:TEXT))	
		
		IF !EMPTY(nRecSz0)
			DBSELECTAREA("SZ0")
			SZ0->(DBGOTO(nRecSz0))
			IF !SZ0->(Eof())
				RECLOCK("SZ0",.F.)
					IF lExcluir
						SZ0->(DBDELETE())
					ELSE
						SZ0->Z0_FILIAL:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_FILIAL:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_FILIAL:TEXT) 				
						SZ0->Z0_MAT	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_MAT:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_MAT:TEXT)  			 
						SZ0->Z0_CODPER:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_CODPER:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_CODPER:TEXT)  	    		
						SZ0->Z0_SEQ	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_SEQ:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_SEQ:TEXT) 		  
						SZ0->Z0_PESO	:= VAL(IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_PESO:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_PESO:TEXT))  		
						SZ0->Z0_META	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_META:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_META:TEXT)  		
						SZ0->Z0_STATUS:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_STATUS:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_STATUS:TEXT)  	
						SZ0->Z0_PERC 	:= VAL(IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_PERC:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_PERC:TEXT)) 
						SZ0->Z0_JUSTIF:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_JUSTIF:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_JUSTIF:TEXT) 	
					ENDIF	
				MSUNLOCK()
			ELSE
				lNovo:= .T.		
			ENDIF
		ELSEIF !lExcluir
			lNovo:= .T. 
		ENDIF
		
		IF lNovo
			DBSELECTAREA("SZ0")
			RECLOCK("SZ0",.T.)
				SZ0->Z0_FILIAL:= XFILIAL("SZ0") //IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_FILIAL:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_FILIAL:TEXT) 				
				SZ0->Z0_MAT	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_MAT:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_MAT:TEXT)  			 
				SZ0->Z0_CODPER:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_CODPER:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_CODPER:TEXT)  	    		
				SZ0->Z0_SEQ	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_SEQ:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_SEQ:TEXT) 		  
				SZ0->Z0_PESO	:= VAL(IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_PESO:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_PESO:TEXT))  		
				SZ0->Z0_META	:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_META:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_META:TEXT)  		
				SZ0->Z0_STATUS:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_STATUS:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_STATUS:TEXT)  	
				SZ0->Z0_PERC 	:= VAL(IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_PERC:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_PERC:TEXT)) 
				SZ0->Z0_JUSTIF:= IIF(nTotMetas==1,oXml:_ITEMS:_ITEM:_JUSTIF:TEXT,oXml:_ITEMS:_ITEM[nCnt]:_JUSTIF:TEXT)
				SZ0->Z0_DTCALC:= CTOD("")
				SZ0->Z0_RESULT:= 0	
			SZ0->(MSUNLOCK())	
		ENDIF
	Next nCnt 

	::Ret:OK:= .T.
	::Ret:MSG:= "Gravação realizada com sucesso."		 	

ENDIF 

Return .T.