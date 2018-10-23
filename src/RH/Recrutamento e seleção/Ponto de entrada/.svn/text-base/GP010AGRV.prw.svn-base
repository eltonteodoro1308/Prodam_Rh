#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GP010AGRV
Ponto de Entrada apos a gravacao do funcionario
@author  	Carlos Henrique
@since     	14/09/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function GP010AGRV()
	Local nOpc		:= PARAMIXB[1]
	Local lGrava	:= PARAMIXB[2]
	Local lViaRSP	:= ISINCALLSTACK("RSPM001")

	//Quando chamado pela admissao pelo RSP, atualiza Filial e Matricula no curriculo
	If IsInCallStack("RSPM001")
		SQG->QG_FILMAT 	:= SRA->RA_FILIAL
		SQG->QG_MAT 	:= SRA->RA_MAT
	EndIf

	// Verifica se o registro de funcionário é de origem do módulo de recutamento e seleção
	IF nOpc == 3 .AND. lGrava .AND. lViaRSP
		//Verifica se a vaga é de origem da rotina de requisição de pessoal
		IF !EMPTY(SQS->QS_XNUMREQ)
			DBSELECTAREA("ZZJ")
			ZZJ->(DBSETORDER(1))
			IF ZZJ->(DBSEEK(XFILIAL("ZZJ")+SQS->QS_XNUMREQ))
				RecLock( "ZZJ", .F. )
				ZZJ->ZZJ_NOMCAN:=  SRA->RA_NOME
				ZZJ->( MsUnlock() )
			ENDIF
		ENDIF
	ENDIF

Return

