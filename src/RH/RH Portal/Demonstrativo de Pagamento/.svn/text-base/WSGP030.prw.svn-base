#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} WSGP030
Ponto de entrada durante a execução do método Get GetPaymentReceipt – Recibo de Pagamento Portal
@author  	Carlos Henrique
@since     	07/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function WSGP030() 
Local aSR7 		:= SR7->(GetArea())
Local aSA6 		:= SA6->(GetArea())
Local oObj 		:= ParamIXB //objeto com os campos
Local cBancFun	:= LEFT(SRA->RA_BCDEPSA,TAMSX3("A6_COD")[1])		
Local dDataRef	:= CTOD("01/" + AllTrim(Str(Month)) + "/" + AllTrim(Str(Year)))
Local dLastData	:= CTOD(AllTrim(Str(Last_Day( dDataRef )))+"/" + AllTrim(Str(Month)) + "/" + AllTrim(Str(Year)))
Local cDescCargo:= ""
Local cDescFunc	:= ""
Local cVbSalBas	:= "987"  //Verba de base gerada mensalmente com o valor do RA_SALARIO
Local cQuerySRC   := ''
Local cQuerySRD   := ''
Local cQry		    := ''

DBSELECTAREA("SR7")
SR7->(dbsetorder(2))
If SR7->(dbSeek(SRA->(RA_FILIAL+RA_MAT)))
	While SR7->(!EOF()) .and. MesAno(SR7->R7_DATA)	<= MesAno(dLastData) .AND.;
								SR7->R7_FILIAL 	== SRA->RA_FILIAL .AND. ;
								SR7->R7_MAT   	== SRA->RA_MAT
		If !empty(SR7->R7_DESCCAR)
			cDescCargo 	:= 	SR7->R7_DESCCAR									 //-- 20 Bytes 
		Else
			cDescCargo 	:= 	fDesc( "SQ3", SR7->R7_CARGO, "Q3_DESCSUM" )
		EndIf
		SR7->(dbSkip())
	EndDo
Else 
	cDescCargo	:=  LEFT(fDesc("SQ3",SRA->RA_CARGO,"Q3_DESCSUM" ),30)	
EndIf    

//oObj:FunctionDescription:= TRIM(oObj:FunctionDescription) +"|"+ TRIM(cDescCargo)
cDescFunc := fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC" )
oObj:FunctionDescription:= TRIM(cDescFunc) +"|"+ TRIM(cDescCargo)


oObj:BankName	:= POSICIONE("SA6",1,XFILIAL("SA6")+cBancFun,"A6_NOME")

//A partir de 10/2016 passa a buscar o Salario pela verba 987, uma vez que pode ter ocorrido aumento retroativo na SR3
//e o salario no recibo precisa ser o que foi considerado no calculo original
//varinfo("dDataRef",dDataRef)
If mesano(dDataRef) >= '201610'
	//varinfo("Entrou em 201610",dDataRef)
	cQuerySRC := GetNextAlias()
	cQry	 := "SELECT RC_VALOR from " + RetSqlTab("SRC") 
	cQry	 += "WHERE RC_FILIAL = '" + SRA->RA_FILIAL + "' AND "
	cQry	 += "      RC_MAT    = '" + SRA->RA_MAT    + "' AND "
	cQry	 += "      RC_PD = '" + cVbSalBas + "' AND "
	cQry	 += "      RC_PERIODO = '" + mesano(dDataRef) + "' AND "
	cQry	 += "      D_E_L_E_T_ = ''"
	cQry	 := ChangeQuery(cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cQuerySRC, .F., .T.)
	if !(cQuerySRC)->(Eof())
		oObj:FixedSalary := (cQuerySRC)->RC_VALOR
		//varinfo("oObj:FixedSalary SRC",oObj:FixedSalary)
		
	Else
		cQuerySRD := GetNextAlias()
		cQry	 := "SELECT RD_VALOR from " + RetSqlTab("SRD") 
		cQry	 += "WHERE RD_FILIAL = '" + SRA->RA_FILIAL + "' AND "
		cQry	 += "      RD_MAT    = '" + SRA->RA_MAT    + "' AND "
		cQry	 += "      RD_PD = '" + cVbSalBas + "' AND "
		cQry	 += "      RD_PERIODO = '" + mesano(dDataRef) + "' AND "
		cQry	 += "      D_E_L_E_T_ = ''"
		cQry	 := ChangeQuery(cQry)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cQuerySRD, .F., .T.)
		if !(cQuerySRD)->(Eof())
			oObj:FixedSalary := (cQuerySRD)->RD_VALOR
			//varinfo("oObj:FixedSalary SRD",oObj:FixedSalary)
		EndIf
		(cQuerySRD)->(dbCloseArea())
	EndIf
	(cQuerySRC)->(dbCloseArea())

//Ate 09/2016 busca pelo salario do mes anterior a consulta -> como esta disponibilizado na prodam a partir de julho/16
//esta pesquisa funcionara para os meses 07, 08 e 09/2016, sendo que a ultima alteracao salarial ocorream em 02/2016.
//Este tratamento foi realizado devido ao aumento retroativo ocorrido em 09/2016 e que deve mostrar o salario original
//do mes calculado, e nao ha nesses meses a verba 987.
Else 
	//varinfo("Entrou no Else",dDataRef)
	//varinfo("oObj:FixedSalary Antes",oObj:FixedSalary)
	oObj:FixedSalary := fBuscaSal(dDataRef-1)
	//varinfo("oObj:FixedSalary Depois",oObj:FixedSalary)
EndIf

RestArea(aSA6)
RestArea(aSR7)
Return oObj