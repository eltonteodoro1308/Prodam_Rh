#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} WSGP040
Ponto de entrada durante a execução do método Get GetPaymentReceipt – Recibo de Pagamento Portal
@author  	Carlos Henrique
@since     	07/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function WSGP040() 
Local aSRH 		:= SRH->(GetArea())
Local aSR7 		:= SR7->(GetArea())
Local oObj 		:= ParamIXB //objeto com os campos
Local dDataRef	:= CTOD("")
Local cDescCargo	:= ""
Local cDescFunc	:= ""

DBSelectArea("SRH")
DBSetOrder(1)	//RH_FILIAL,RH_MAT,RH_DATABAS,RH_DATAINI
If SRH->(DBSeek(xFilial("SRH", Branch) + Registration + DTOS(AcquisitiveStartDate) + DTOS(EnjoymentStartDate)))
	dDataRef:= SRH->RH_DTRECIB
	DBSELECTAREA("SR7")
	SR7->(dbsetorder(2))
	If SR7->(dbSeek(SRA->(RA_FILIAL+RA_MAT)))
		While SR7->(!EOF()) .and. SR7->R7_FILIAL 	== SRA->RA_FILIAL .AND. ;
									SR7->R7_MAT   == SRA->RA_MAT .AND.;
									SR7->R7_DATA	<= dDataRef						
			If !empty(SR7->R7_DESCCAR)
				cDescCargo 	:= 	SR7->R7_DESCCAR									 //-- 20 Bytes 
			Else
				cDescCargo 	:= 	fDesc( "SQ3", SR7->R7_CARGO, "Q3_DESCSUM" )
			EndIf
			
			SR7->(dbSkip())
		EndDo	
	EndIf	
EndIf

IF Empty(cDescCargo)
	cDescCargo	:=  LEFT(fDesc("SQ3",SRA->RA_CARGO,"Q3_DESCSUM" ),30)
ENDIF
    
//oObj:FunctionDescription:= TRIM(oObj:FunctionDescription) +"|"+ TRIM(cDescCargo)
cDescFunc := fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC" )
oObj:FunctionDescription:= TRIM(cDescFunc) +"|"+ TRIM(cDescCargo)

RestArea(aSRH)
RestArea(aSR7)
Return oObj