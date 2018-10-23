#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPORE01
Rotina de ajuste na descrição dos departamentos
@author  	Carlos Henrique 
@since     	11/07/2016
@version  	P.12.6     
@return   	Nenhum  
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION PRPORE01(cDescDepart)
Local cDescRet:= ""
Local nPos1	:= 0
Local nPos2	:= 0

//Checa o primeiro hifen
IF (nPos1:= AT("-",cDescDepart)) > 0
	cDescRet:= SUBSTR(cDescDepart,1,nPos1-1)
	cDescDepart:= SUBSTR(cDescDepart,nPos1+1,LEN(cDescDepart))
ENDIF

//Checa o segundo hifen
IF (nPos2:= AT("-",cDescDepart)) > 0
	cDescRet:= cDescRet+"-" + SUBSTR(cDescDepart,1,nPos2-1)
	cDescDepart:= SUBSTR(cDescDepart,nPos2+1,LEN(cDescDepart))
ENDIF

cDescDepart:= cDescRet

RETURN 