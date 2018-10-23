#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

WSSTRUCT aTabVAVR
	WSDATA Status As String    			// status 
	WSDATA CodVA As String    			// Codigo do Beneficio VA
	WSDATA DescVA As String    			// Descrição do Beneficio VA
	WSDATA DiasVA As String    			// Quantidade de dias do Beneficio VA		
	WSDATA CodVR As String    			// Codigo do Beneficio VR
	WSDATA DescVR As String    			// Descrição do Beneficio VR
	WSDATA DiasVR As String    			// Quantidade de dias do Beneficio VR		
ENDWSSTRUCT

WSSTRUCT aEstVAVR
	WSDATA FilialFun	AS String     		// Filial do funcionario
	WSDATA Matricula	AS String     		// Matricula do funcionario
	WSDATA Departamento As String     		// codigo do departamento
	WSDATA Nome As String        			// Nome do funcionario
	WSDATA DtAdmissao	As String   			// Admissao do funcionario
	WSDATA RecnoVA As String       			// RECNO VA
	WSDATA RecnoVR As String       			// RECNO VR
	WSDATA TabOpcoes As Array OF aTabVAVR 	// Codigo do Beneficio
	WSDATA DiaIni As String       			// Dia inicial de alteração
	WSDATA DiaFim As String       			// Dia final de alteração
ENDWSSTRUCT
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRTRVRVA
Troca VA e VR
@author  	Carlos Henrique 
@since     	29/06/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSSERVICE 	PRTRVRVA	DESCRIPTION "Serviço de alteração de beneficio VA e VR"
	WSDATA FilialFun AS String	//Filial do funcionario
	WSDATA Matricula AS String	// Matricula do funcionário
	WSDATA cMsgRet AS String		// Mensagem de retorno
	WSDATA RecnoVR AS String	// RECNO VR
	WSDATA CodVR AS String		// CODIGO VR
	WSDATA RecnoVA AS String	// RECNO VA
	WSDATA CodVA AS String		// CODIGO VA
	WSDATA cMsg AS String		// CODIGO VA
	WSDATA aVAVR As aEstVAVR		// Dados do VAVR
	WSMETHOD GETVAVR	DESCRIPTION "Busca os dias dos Beneficios."
	WSMETHOD PUTVAVR	DESCRIPTION "Grava os dias nos Beneficios"
ENDWSSERVICE
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GETVAVR
Consulta VA e VR
@author  	Carlos Henrique 
@since     	29/06/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD GETVAVR WSRECEIVE FilialFun,Matricula WSSEND aVAVR WSSERVICE PRTRVRVA
Local cTab			:= GetNextAlias()
Local cTU055		:= ""
Local aIniFimTR	:= {0,0}
Local nCnt			:= 0
Local nItx			:= 0
Local nCodUso		:= ""
Local cCodSindica	:= ""
Local cCodCategor	:= ""

BeginSql Alias cTab
	SELECT RA_FILIAL
			,RA_MAT
			,RA_NOME
			,RA_DEPTO
			,RA_ADMISSA
			,RA_SINDICA
			,RA_CATFUNC
			,R0_CODIGO
			,R0_TPVALE
			,SR0.R_E_C_N_O_ AS RECSR0
	FROM %TABLE:SR0% SR0
	INNER JOIN %TABLE:SRA% SRA ON RA_FILIAL=R0_FILIAL
		AND RA_MAT=R0_MAT
		AND SRA.D_E_L_E_T_=''
	WHERE R0_FILIAL=%exp:FilialFun% 
		AND R0_MAT=%exp:Matricula% 
		AND R0_TPVALE IN ('1','2') 
		AND SR0.D_E_L_E_T_=''
EndSql

TCSETFIELD(cTab,"RA_ADMISSA","D")

//GETLastQuery()[2]

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())  
IF !(cTab)->(Eof())  

	DBSELECTAREA("RCA")
	RCA->(DBSETORDER(1))
	IF RCA->(DBSEEK(XFILIAL("RCA")+"M_INIFIMTR"))
		IF !EMPTY(RCA->RCA_CONTEU)
			aIniFimTR:= &(RCA->RCA_CONTEU)
		ENDIF
	ENDIF
     
	::aVAVR:FilialFun		:= (cTab)->RA_FILIAL
	::aVAVR:Matricula		:= (cTab)->RA_MAT
	::aVAVR:Departamento	:= (cTab)->RA_DEPTO
	::aVAVR:Nome			:= (cTab)->RA_NOME
	::aVAVR:DtAdmissao	:= IIF(!EMPTY((cTab)->RA_ADMISSA),Dtoc((cTab)->RA_ADMISSA),"")
	cCodSindica			:= (cTab)->RA_SINDICA
	cCodCategor			:= (cTab)->RA_CATFUNC   	
	WHILE (cTab)->(!EOF())
		IF (cTab)->R0_TPVALE=="1"
			nCodUso:= Trim((cTab)->R0_CODIGO)
			::aVAVR:RecnoVR		:= CVALTOCHAR((cTab)->RECSR0)		
		ELSEIF (cTab)->R0_TPVALE=="2"	
			::aVAVR:RecnoVA		:= CVALTOCHAR((cTab)->RECSR0)
		ENDIF	
	(cTab)->(DBSKIP())
	END 
	::aVAVR:DiaIni	:= CVALTOCHAR(aIniFimTR[1]) 
	::aVAVR:DiaFim	:= CVALTOCHAR(aIniFimTR[2])

	cTU055:= GetNextAlias()
	//Busca opções na tabela U055
	BeginSql Alias cTU055
		SELECT SUBSTRING(RCC_CONTEU,3,2) AS VR
				,SUBSTRING(RCC_CONTEU,5,2) AS VA
				,SUBSTRING(RCC_CONTEU,7,15) AS CATEG  
		FROM %TABLE:RCC% RCC
		WHERE RCC_CODIGO='U055'
			AND LEFT(RCC_CONTEU,2)=%exp:cCodSindica% 
			AND D_E_L_E_T_=''
		ORDER BY RCC_SEQUEN ASC	
	EndSql	
	
	//GETLastQuery()[2]
	
	(cTU055)->(dbSelectArea((cTU055)))                    
	(cTU055)->(dbGoTop()) 
	IF !(cTU055)->(Eof())
		WHILE (cTU055)->(!EOF())
			IF cCodCategor$(cTU055)->CATEG
				AADD(::aVAVR:TabOpcoes,WsClassNew('aTabVAVR'))
				nItx:= LEN(::aVAVR:TabOpcoes)
				IF TRIM((cTU055)->VR)==nCodUso
					::aVAVR:TabOpcoes[nItx]:Status	:= "S"
				ELSE
					::aVAVR:TabOpcoes[nItx]:Status	:= "N"	
				ENDIF	 	 	                 
				::aVAVR:TabOpcoes[nItx]:CodVR	:= (cTU055)->VR
				DBSELECTAREA("RFO")
				RFO->(DBSETORDER(1))
				IF RFO->(DBSEEK(XFILIAL("RFO")+"1"+(cTU055)->VR))
					::aVAVR:TabOpcoes[nItx]:DescVR	:= RFO->RFO_DESCR
					::aVAVR:TabOpcoes[nItx]:DiasVR	:= CVALTOCHAR(RFO->RFO_DIAFIX)			
				ELSE
					::aVAVR:TabOpcoes[nItx]:DescVR	:= ""
					::aVAVR:TabOpcoes[nItx]:DiasVR	:= ""
				ENDIF			
				::aVAVR:TabOpcoes[nItx]:CodVA	:= (cTU055)->VA
				
				DBSELECTAREA("RFO")
				RFO->(DBSETORDER(1))
				IF RFO->(DBSEEK(XFILIAL("RFO")+"2"+(cTU055)->VA))	
					::aVAVR:TabOpcoes[nItx]:DescVA	:= RFO->RFO_DESCR
					::aVAVR:TabOpcoes[nItx]:DiasVA	:= CVALTOCHAR(RFO->RFO_DIAFIX)	
				ELSE			
					::aVAVR:TabOpcoes[nItx]:DescVA	:= ""
					::aVAVR:TabOpcoes[nItx]:DiasVA	:= ""	
				ENDIF		
			ENDIF
		(cTU055)->(DBSKIP())
		END 				
	ELSE
		AADD(::aVAVR:TabOpcoes,WsClassNew('aTabVAVR'))
		nItx:= LEN(::aVAVR:TabOpcoes)
		::aVAVR:TabOpcoes[nItx]:CodVR	:= ""
		::aVAVR:TabOpcoes[nItx]:DescVR	:= ""
		::aVAVR:TabOpcoes[nItx]:DiasVR	:= ""
		::aVAVR:TabOpcoes[nItx]:CodVA	:= ""
		::aVAVR:TabOpcoes[nItx]:DescVA	:= ""
		::aVAVR:TabOpcoes[nItx]:DiasVA	:= ""
		::aVAVR:TabOpcoes[nItx]:Status	:= ""			
	ENDIF	
ELSE

	::aVAVR:FilialFun		:= ""
	::aVAVR:Matricula		:= ""
	::aVAVR:Departamento	:= ""
	::aVAVR:Nome			:= ""
	::aVAVR:DtAdmissao	:= ""
	::aVAVR:RecnoVR		:= "0"
	::aVAVR:RecnoVA		:= "0"	
	::aVAVR:DiaIni		:= 0
	::aVAVR:DiaFim		:= 0	

	AADD(::aVAVR:TabOpcoes,WsClassNew('aTabVAVR'))
	nItx:= LEN(::aVAVR:TabOpcoes)
	::aVAVR:TabOpcoes[nItx]:CodVR	:= ""
	::aVAVR:TabOpcoes[nItx]:DescVR	:= ""
	::aVAVR:TabOpcoes[nItx]:DiasVR	:= ""
	::aVAVR:TabOpcoes[nItx]:CodVA	:= ""
	::aVAVR:TabOpcoes[nItx]:DescVA	:= ""
	::aVAVR:TabOpcoes[nItx]:DiasVA	:= ""
	::aVAVR:TabOpcoes[nItx]:Status	:= ""
ENDIF
(cTab)->(dbCloseArea())

Return .T.
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PUTVAVR
Grava VA e VR
@author  	Carlos Henrique 
@since     	29/06/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
WSMETHOD PUTVAVR WSRECEIVE RecnoVR,CodVR,RecnoVA,CodVA WSSEND cMsg WSSERVICE PRTRVRVA

//Atualiza a quantidade de VR
DBSELECTAREA("SR0")
SR0->(DBGOTO(VAL(::RecnoVR)))
IF !SR0->(Eof())
	RECLOCK("SR0",.F.)
		SR0->R0_CODIGO	:= ::CodVR
		SR0->R0_XORIGEM	:= "P"
	MSUNLOCK()
ENDIF 

//Atualiza a quantidade de VA
DBSELECTAREA("SR0")
SR0->(DBGOTO(VAL(::RecnoVA)))
IF !SR0->(Eof())
	RECLOCK("SR0",.F.)
		SR0->R0_CODIGO	:= ::CodVA
		SR0->R0_XORIGEM	:= "P"
	MSUNLOCK()
ENDIF 

::cMsg:= "Atualização realizada com sucesso."

Return .T.