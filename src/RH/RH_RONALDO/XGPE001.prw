#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FwMVCDef.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXGPE001     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Roteiros de Calculo PRODAM                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfADIANT     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo de Adiantamento                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fADIANT()

	Local nPensao := nPensADI := nMes := nLinha := nLinha2 := 0
	Local cPensao := cPensADI := cMesPens := ""
	Local nDiasAdt := M_DIASADT
	Local nVb1 := nVb2 := nVb3 := nVb4 := nVb5 := nVb6 := 0
	Local cVb1 := cVb2 := cVb3 := cVb4 := cVb5 := cVb6 := ""

	cTab  := "U011"
	cTab2 := "U030"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cPensao := fTabela(cTab,nLinha,9)
		cPensADI := fTabela(cTab,nLinha,12)
		nMes := 1
	EndIf
	
	If (nLinha2 := fPosTab(cTab2,SRA->RA_SINDICA,"=",4)) > 0
		cMesPens := fTabela(cTab2,nLinha2,6)
	//	nDiasAdt := fTabela(cTab2,nLinha2,5)
	EndIf
	
	If Month2Str(dDataRef) $ cMesPens
		nMes := 35
	EndIf
	
	cVb1 := Substr(cPensao,1,3)
	cVb2 := Substr(cPensao,5,3)
	cVb3 := Substr(cPensao,9,3)
	cVb4 := Substr(cPensao,13,3)
	cVb5 := Substr(cPensao,17,3)
	cVb6 := Substr(cPensao,21,3)
	
	SRQ->(dbSetOrder( 1 ))
	SRQ->(dbSeek( SRA->(RA_FILIAL + RA_MAT) ))
	
	Do While !(SRQ->(Eof())) .And. SRQ->(RQ_FILIAL + RQ_MAT) == SRA->(RA_FILIAL + RA_MAT)
	If SRQ->RQ_VERBFOL <> ""
	nVb1 := FBUSCAACM(cVb1 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	nVb2 := FBUSCAACM(cVb2 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	nVb3 := FBUSCAACM(cVb3 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	nVb4 := FBUSCAACM(cVb4 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	nVb5 := FBUSCAACM(cVb5 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	nVb6 := FBUSCAACM(cVb6 , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
			
	nPensao := nVb1 + nVb2 + nVb3 + nVb4 + nVb5 + nVb6
	nPensADI := FBUSCAACM(cPensADI , ,(dDataRef - nMes), (dDataRef - nMes),"V") * -1
	Endif
	SRQ->(dbSkip())
	EndDo

	If nPensao > 0 .and. nPensADI = 0
		SALMES := SALMES - nPensao
		SALDIA := SALDIA - (nPensao / nDiasC)
		SALHORA := SALHORA - (nPensao / (P_QtDiaMes * SRA->RA_HRSDIA))
	EndIf
	
	If SRA->RA_SITFOLH == "A"
		If nDiasP == 31
			DiasTb := DiasTb - 1
		ElseIf nDiasP == 28
			DiasTb := DiasTb + 1
		ElseIf nDiasP == 29
			DiasTb := DiasTb + 2
		EndIf
		If DiasTb > 30
			DiasTb := 30
		EndIf
	EndIf
	
	If SRA->RA_SITFOLH == " "
		CALCULE := "S"
	ElseIf (Month(dDataBase) == Month(SRA->RA_ADMISSA) .and. Year(dDataBase) == Year(SRA->RA_ADMISSA))
		CALCULE := "N"
//	ElseIf	 SRA->RA_SITFOLH == "F" .and. (DIASTB + NDIASPG + NDIASSALM + NDPRGSALMA) < nDiasAdt
	ElseIf	 SRA->RA_SITFOLH == "F" .and. DIASTB < nDiasAdt
		CALCULE := "N"
	ElseIf SRA->RA_ADMISSA > dDataAte .or. SRA->RA_SITFOLH == "D"
		CALCULE := "N"
	ElseIf AnoMes(SRA->RA_ADMISSA) == cAnoMes .and. AnoMes(dDataAte) == cAnoMes
		CALCULE := "N"
	ElseIf SRA->RA_SITFOLH == "A"
		CALCULE := "S"
	ElseIf CALCULE == "S" .and. cAdtoPro == "S"
		DIASTB := DIASTB + NDIASPG
	ElseIf CALCULE # "N" .or. (cAdtoPro == "S" .And. DIASTB > 0) .And. SRA->RA_SITFOLH # "D" .And. MesAno(SRA->RA_ADMISSA) < MesAno(dDataAte)
		CALCULE := "S"
	Endif
	
	If (Month(dDataBase) == Month(SRA->RA_ADMISSA) .and. Year(dDataBase) == Year(SRA->RA_ADMISSA)) .or. (Month(dDataRef) == Month(SRA->RA_ADMISSA) .and. Year(dDataRef) == Year(SRA->RA_ADMISSA))
		CALCULE := "N"
	Endif
	If CALCULE == "N"
		NoPrcReg()
	Endif
	
	If CALCULE == "S"
		DiasTb := 30
//		SALMES := SRA->RA_SALARIO
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBENEF      บAutor  ณ Ronaldo Olivieira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo Vale Transporte                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fSUSPVT()
	
	If SRA->RA_XSUSPVT == "1"
		CALCULE := "N"
	Endif
	
	If CALCULE == "N"
		NoPrcReg()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfESTAG      บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo para Estagiarios                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fESTAG()

	Local lRet := .T.
	Local cVbVTEmp := aCodFol[210,1]
	Local cVbVTFunc := aCodFol[051,1]

	If SRA->RA_CATFUNC $ "E/G" .and. SRA->RA_SITFOLH <> "D"
		nVTEmp := fBuscaPd(cVbVTEmp,"V",cSemana)
		nVTFunc := fBuscaPd(cVbVTFunc,"V",cSemana) * -1
	
//		nVTEmp := nVTEmp + nVTFunc
	
		If nVTEmp > 0
			fDelPD(cVbVTFunc,,)
			FGERAVERBA(cVbVTEmp,(nVTEmp + nVTFunc),100.00,,,"V","C",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASSIST     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Contribuicao Assistencial                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fASSIST()

	Local cTab, nLinha
	Local lRet := .T.
	Local nPerc := nValAssit:= nValAssist := 0
	Local cVerba := aCodFol[069,1]
	cTab   := "U001"

	If SRA->RA_MENSIND == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nPerc := fTabela(cTab,nLinha,5)
		Endif
		
		If SRA->RA_SITFOLH <> 'D'
			nValAssist := (fBuscaPd(cVerba,"V",cSemana) * (nPerc /100)) * -1
		EndIf
		
		If nValAssist <> 0
			FGERAVERBA(cVerba,nValAssist,,,,"V","C",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSEGVIDA    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seguro de Vida                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fSEGVIDA()

	Local cTabela    	:= "U002"
	Local cVbEmp 		:= cVbFunc := ""
	Local nQtdSal 	:= nFator := nDivisor := nPercEmp := nPercFunc := nValSV := nSVEmp := nSVFunc :=0
	Local nSal		 	:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local nValAnuen 	:= 0
	Local nValGrat	:= 0
	Local lRet			:= .T.
	cTab   := "U002"

	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	
	If SRA->RA_XSEGURO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nQtdSal := fTabela(cTab,nLinha,6)
			nFator := fTabela(cTab,nLinha,7)
			nDivisor := fTabela(cTab,nLinha,8)
			nPercEmp := fTabela(cTab,nLinha,9)
			nPercFunc := fTabela(cTab,nLinha,10)
			cVbEmp := fTabela(cTab,nLinha,11)
			cVbaFunc := fTabela(cTab,nLinha,12)
			nValAnuen := fBuscaPD(aCodFol[001,1],"V",cSemana)
			nValGrat:= fBuscaPD(ftabela("U050",01,06),"V",cSemana)
			nSal := nSal + nValAnuen + nValGrat
		Endif
	Endif

	nValSV		:= ((nSal * nQtdSal) * nFator) / nDivisor
	nSVEmp		:= nValSV * (nPercEmp / 100)
	nSVFunc	:= nValSV * (nPercFunc / 100)

	If nSVEmp > 0 .and. Empty(fBuscaPD(cVbEmp,"V",cSemana))
		FGERAVERBA(cVbEmp,nSVEmp,,,,"V","C",,,,lRet,)
	Endif
	If nSVFunc > 0 .and. Empty(fBuscaPD(cVbFunc,"V",cSemana))
		FGERAVERBA(cVbFunc,nSVFunc,,,,"V","C",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAUXCRE     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auxilio Creche e Baba                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAUXCRE()

	Local nBusca, cTab, nLinha
	Local lRet			:= .T.
	Local dDtRef   	:= StoD( cAnoMes + "01" )
	Local nValBase	:= nLimId := nValCre := nQdeDep := nVlrBsCre := nVlrBsBab := nVlrReemb := nQtd := 0
	Local cVbReemb	:= cVbBsCre := cVbBsBab :=""
	
	Public _dxDtBh := dDataRef //Criado como publica pois ้ usado na fun็ใo fDescBH com a referencia certa, pois aqui ele muda a dataref para data base e faz errado no banco de horas
                   
	SRB->(dbSetOrder( 1 ))
	SRB->(dbSeek( SRA->(RA_FILIAL + RA_MAT) ))

	Do While !(SRB->(Eof())) .And. SRB->(RB_FILIAL + RB_MAT) == SRA->(RA_FILIAL + RA_MAT)

		If !(SRB->RB_XAUXCRE == "1")
			SRB->(dbSkip())
			Loop
		EndIf
	
		nBusca :=  DateDiffMonth( dDtRef , SRB->RB_DTNASC )
		cTab   := "U003"
		dDataRef	:= dDataBase //04/09/18 Comentado pois estava alterando a referencia para calculo desconto do banco de horas
			
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4,nBusca,"<=",5) ) > 0
			nValBase := fTabela(cTab,nLinha,6)
			cVbBsCre := fTabela(cTab,nLinha,7)
			cVbReemb := fTabela(cTab,nLinha,8)
			nLimId++
		EndIf

		If SRB->RB_XPERCRE == "2"
			nValBase := (nValBase / 2)
		Endif
		
		nValCre  += nValBase
		nQdeDep++
		SRB->(dbSkip())
	EndDo
	
//	nValCre := nValCre * nQdeDep
	nVlrBsCre := fBuscaPd(cVbBsCre,"V",cSemana)
	nQtd := fBuscaPd(cVbBsCre,"H",cSemana)
	nVlrReemb := nVlrBsCre
	
	If nQtd == 0
		nQtd := 1
	EndIf
	
	nValCre := nValCre * nQtd
	
	If nVlrReemb > nValCre
		nVlrReemb := nValCre
	Endif
	If nVlrReemb > 0  .and. Empty(fBuscaPD(cVbReemb,"V",cSemana))
		FGERAVERBA(cVbReemb,nVlrReemb,,,,"V","C",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAUXEXCEP   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auxilio Excepcional                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAUXEXCEP()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nValAux := nQdeDep := 0
	Local cVbAux		:= ""
                      
	SRB->(dbSetOrder( 1 ))
	SRB->(dbSeek( SRA->(RA_FILIAL + RA_MAT) ))

	Do While !(SRB->(Eof())) .And. SRB->(RB_FILIAL + RB_MAT) == SRA->(RA_FILIAL + RA_MAT)

		If !(SRB->RB_XEXCEPC == "1")
			SRB->(dbSkip())
			Loop
		EndIf
	
		cTab   := "U004"
			
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbAux := fTabela(cTab,nLinha,6)
			nValAux  += nValBase
			nQdeDep ++
		EndIf
		SRB->(dbSkip())
	EndDo
	If nValAux > 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
		FGERAVERBA(cVbAux,nValAux,nQdeDep,,,"V","C",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfESTUD      บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bolsa Estudo                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fESTUD()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U005"
		
	If SRA->RA_XESTUDO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbBsAux := fTabela(cTab,nLinha,6)
			cVbAux := fTabela(cTab,nLinha,7)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		
		If  nVlrBs <> 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
			FGERAVERBA(cVbAux,nVlrBs,,,,"V","C",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfATLET      บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bolsa Atleta                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fATLET()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := nHrs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U006"
		
	If SRA->RA_XATLETA == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbBsAux := fTabela(cTab,nLinha,6)
			cVbAux := fTabela(cTab,nLinha,7)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	nHrs := fBuscaPd(cVbBsAux,"H",cSemana)
		
	If nVlrBs > 0
		If nHrs == 0
			nHrs := 1
		EndIf
		nValBase := nValBase * nHrs
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		If  nVlrBs <> 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
			FGERAVERBA(cVbAux,nVlrBs,,,,"V","C",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfFUNERAL    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auxilio Funeral                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fFUNERAL()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U007"
		
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nValBase := fTabela(cTab,nLinha,5)
		cVbBsAux := fTabela(cTab,nLinha,6)
		cVbAux := fTabela(cTab,nLinha,7)
	EndIf

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		
		If nVlrBs <> 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
			FGERAVERBA(cVbAux,nVlrBs,,,,"V","C",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfINTERMUN   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auxilio Transporte Intermunicipal                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fINTERMUN()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nPerc		:= nMin:= nVlrBs := nReemb := nLim := 0
	Local cVbBsAux	:= cVbAux := ""
	Local cVbVTEmp := aCodFol[210,1]
	Local cVbVTFunc := aCodFol[051,1]
	Local nSal			:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	
	cTab   := "U008"
				
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif

	If SRA->RA_XTINTER == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nPerc := fTabela(cTab,nLinha,5)
			nMin := fTabela(cTab,nLinha,6)
			cVbBsAux := fTabela(cTab,nLinha,7)
			cVbAux := fTabela(cTab,nLinha,8)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	nVTEmp := fBuscaPd(cVbVTEmp,"V",cSemana)
	nVTFunc := fBuscaPd(cVbVTFunc,"V",cSemana) * -1
	nVlrBs := nVlrBs + nVTFunc + nVTEmp

	If nVlrBs > 0
		nDesc := nSal * (nPerc / 100)
		nReemb := nVlrBs - nDesc
		nLim := VAL_SALMIN * (nMin / 100)
		If nReemb > nLim
			nReemb := nLim
		Endif
	
		If nReemb <> 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
			FGERAVERBA(cVbAux,nReemb,,,,"V","C",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGREMIO     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensalidade Gremio                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGREMIO()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cPerc		:= ""
	Local cVbAux		:= ""
	Local nSal			:= SRA->RA_SALARIO
	Local nSal			:= SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local nSalProp	:= nDiasFer := nDiasSal := nDiasEstag := nDiasAfast := nDiasRes := 0
	Local cVbFER      := aCodFol[072,1]
	Local cVbSal      := aCodFol[031,1]
	Local cVbEstag    := aCodFol[219,1]
	Local cVbRes      := aCodFol[048,1]
	Local cVbAfast    := fTabela("U052", 1, 9, dDataRef )
	
	cTab   := "U009"
	
	If SRA->RA_XGREMIO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cPerc := fTabela(cTab,nLinha,5)
			cVbAux := fTabela(cTab,nLinha,6)
			nDiasFer := fBuscaPd(cVbFER,"H",cSemana)
			nDiasSal := fBuscaPd(cVbSal,"H",cSemana)
			nDiasEstag := fBuscaPd(cVbEstag,"H",cSemana)
			nDiasRes := fBuscaPd(cVbRes,"H",cSemana)
			
			If SRA->RA_CATFUNC == "H"
				nSal:= (nSal * nHrs)
			Endif
			
			If LDISSIDIO
				nSal := SRA->RA_ANTEAUM
				nDias_ := (FBUSCAACM(cVbAux , ,(dDataRef), (dDataRef ),"H") * -1)
				If nDias_ > 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
					FGERAVERBA(cVbAux,((nSal * (cPerc / 100)) / 30)*nDias_,nDias_,,,"V","C",,,,lRet,)
				EndIf

			Else

				nSalProp:= (nSal / 30) * (nDiasSal + nDiasEstag + nDiasFer + nDiasPg + nDiasRes)
				
				If (nSalProp * (cPerc / 100)) <> 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
					FGERAVERBA(cVbAux,(nSalProp * (cPerc / 100)),(nDiasSal + nDiasEstag + nDiasFer + nDiasPg + nDiasRes),,,"V","C",,,,lRet,)
				EndIf
			
			EndIf

		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCooper     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aporte Cooperativa                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fCooper()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nPerc		:= SRA->RA_XCOOPER
	Local nPerc2		:= SRA->RA_XCOOPE2
	Local cVbAux		:= cVbAux2 := ""
	Local nVlrAux		:= nVlrAux2 := 0
	Local nSal			:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	cTab   := "U010"
	
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	
	
	If (SRA->RA_XCOOPER > 0 .or. SRA->RA_XCOOPE2 > 0) .and. SRA->RA_SITFOLH <> "D"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVbAux := fTabela(cTab,nLinha,5)
			cVbAux2 := fTabela(cTab,nLinha,6)
				
			nVlrAux := nSal * (nPerc / 100)
			nVlrAux2 := nSal * (nPerc2 / 100)
			
			If nVlrAux > 0 .and. Empty(fBuscaPD(cVbAux,"V",cSemana))
				FGERAVERBA(cVbAux,(nSal * (nPerc / 100)),nPerc,,,"V","C",,,,lRet,)
			EndIf
			
			If nVlrAux2 > 0 .and. Empty(fBuscaPD(cVbAux2,"V",cSemana))
				FGERAVERBA(cVbAux2,(nSal * (nPerc2 / 100)),nPerc2,,,"V","C",,,,lRet,)
			EndIf		
		EndIf
	Endif
			If SRA->RA_SITFOLH = "D"
				fDelPD(cVbAux,,)
				fDelPD(cVbAux2,,)
			EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConsig     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Margem Emprestimo Consignado                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM      
                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fConsig()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbIR		:= aCodFol[066,1]
	Local cVbINSS	:= aCodFol[064,1]
	Local nSal := SRA->RA_SALARIO
	Local nValIR := nValINSS := nPercMarg := nPercPart := nPercSup := nPercMarg := nCoPart := 0
	Local nVlrPens:= nVlrConsig := nVlrCoPart := nMargem := nDesc := 0
	Local cPensao := cConsig := cCopart := cVbMargem := ""
	Local nSal := 0
	Local nSomaGrat := 0
	Local nVlrPens := 0
	Local nAssMed := 0
	Local nOdonto := 0
	Local nConsig := 0
	Local nCooper := 0
		
	cTab   := "U011"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPercMarg := fTabela(cTab,nLinha,5)
		nPercPart := fTabela(cTab,nLinha,6)
		nPercSup := fTabela(cTab,nLinha,7)
		cCoPart := fTabela(cTab,nLinha,8)
		cPensao := fTabela(cTab,nLinha,9)
		cConsig := fTabela(cTab,nLinha,10)
		cVbMargem := fTabela(cTab,nLinha,11)
	EndIf

	cVb1 := Substr(cPensao,1,3)
	cVb2 := Substr(cPensao,5,3)
	cVb3 := Substr(cPensao,9,3)
	cVb4 := Substr(cPensao,13,3)
	cVb5 := Substr(cPensao,17,3)
	cVb6 := Substr(cPensao,21,3)

	nVlrPens1 := fBuscaPd(cVb1,"V",cSemana)
	nVlrPens2 := fBuscaPd(cVb2,"V",cSemana)
	nVlrPens3 := fBuscaPd(cVb3,"V",cSemana)
	nVlrPens4 := fBuscaPd(cVb4,"V",cSemana)
	nVlrPens5 := fBuscaPd(cVb5,"V",cSemana)
	nVlrPens6 := fBuscaPd(cVb6,"V",cSemana)

	nVlrPens := nVlrPens1 + nVlrPens2 + nVlrPens3 + nVlrPens4 + nVlrPens5 + nVlrPens6
	nVlrConsig := fBuscaPd(cConsig,"V",cSemana)
	nVlrCoPart := fBuscaPd(cCopart,"V",cSemana)
//	nValIR := fBuscaPd(cVbIR,"V",cSemana)
//	nValINSS := fBuscaPd(cVbINSS,"V",cSemana)
//	Calc_Inss(aTInss,fBuscaPD(aCodFol[031,1],"V",cSemana) + fBuscaPD(aCodFol[001,1],"V",cSemana),@nValINSS,,,,) 
//	CALC_IR((fBuscaPD(aCodFol[031,1],"V",cSemana) + fBuscaPD(aCodFol[001,1],"V",cSemana) - nValINSS), @VAL_PEAL, @nValIR, @BASE_RED, @VAL_DEDDEP, @VAL_DEPEAL, aTabIr )

	//nSal := fBuscaPd("291","V",cSemana) + fBuscaPd("301","V",cSemana) + fBuscaPd("024","V",cSemana) + fBuscaPd("207","V",cSemana) + fBuscaPd("104","V",cSemana) + fBuscaPd("185","V",cSemana) + fBuscaPd("154","V",cSemana) + fBuscaPd("043","V",cSemana) + fBuscaPd("186","V",cSemana)
	//nSal := fBuscaPd("746","V",cSemana)
	nSal := SALMES - fBuscaPD(aCodFol[001,1]) - fBuscaPD(aCodFol[036,1]) - fBuscaPD(aCodFol[037,1]) - fBuscaPD(aCodFol[039,1]) - fBuscaPD(aCodFol[1288,1]) - fBuscaPd("960","V",cSemana) - fBuscaPd("700","V",cSemana)
	nSomaGrat := ((fBuscaPd("033","V",cSemana)/fBuscaPd("033","H",cSemana))*30) + fBuscaPd("038","V",cSemana) //+ fBuscaPd("036","V",cSemana)
	nVlrPens := (fBuscaPd("578","V",cSemana) + fBuscaPd("570","V",cSemana) + fBuscaPd("569","V",cSemana)) * -1
	nAssMed := (fBuscaPd("527","V",cSemana) + fBuscaPd("523","V",cSemana)) * -1
	nOdonto := (fBuscaPd("528","V",cSemana) + fBuscaPd("526","V",cSemana)) * -1
	nConsig := fBuscaPd("621","V",cSemana) + fBuscaPd("622","V",cSemana) + fBuscaPd("623","V",cSemana) + fBuscaPd("624","V",cSemana)
	nConsig := nConsig + fBuscaPd("625","V",cSemana) + fBuscaPd("626","V",cSemana) + fBuscaPd("601","V",cSemana) + fBuscaPd("602","V",cSemana)
	nConsig := nConsig + fBuscaPd("603","V",cSemana) + fBuscaPd("604","V",cSemana) + fBuscaPd("605","V",cSemana) + fBuscaPd("606","V",cSemana)
	nConsig := nConsig + fBuscaPd("671","V",cSemana) + fBuscaPd("672","V",cSemana) + fBuscaPd("673","V",cSemana) + fBuscaPd("674","V",cSemana)
	nConsig := nConsig + fBuscaPd("611","V",cSemana) + fBuscaPd("612","V",cSemana) + fBuscaPd("613","V",cSemana) + fBuscaPd("614","V",cSemana)
	nConsig := nConsig + fBuscaPd("615","V",cSemana) + fBuscaPd("616","V",cSemana) + fBuscaPd("591","V",cSemana) + fBuscaPd("592","V",cSemana)
	nConsig := nConsig + fBuscaPd("593","V",cSemana) + fBuscaPd("594","V",cSemana) + fBuscaPd("595","V",cSemana) + fBuscaPd("596","V",cSemana)
	nConsig := nConsig * -1	
	nCooper := (fBuscaPd("617","V",cSemana) + fBuscaPd("618","V",cSemana)) * -1

//	Calc_Inss(aTInss,fBuscaPD(aCodFol[031,1],"V",cSemana) + fBuscaPD(aCodFol[217,1],"V",cSemana) + fBuscaPD(aCodFol[001,1],"V",cSemana)- nVlrPens,@nValINSS,,,,) 
//	CALC_IR((fBuscaPD(aCodFol[031,1],"V",cSemana) + fBuscaPD(aCodFol[217,1],"V",cSemana) + fBuscaPD(aCodFol[001,1],"V",cSemana) - nValINSS - nVlrPens), @VAL_PEAL, @nValIR, @BASE_RED, @VAL_DEDDEP, @VAL_DEPEAL, aTabIr )
	Calc_Inss(aTInss,nSal - nVlrPens,@nValINSS,,,,) 
	CALC_IR(nSal - nValINSS - nVlrPens, @VAL_PEAL, @nValIR, @BASE_RED, @VAL_DEDDEP, @VAL_DEPEAL, aTabIr )

	Aeval( aPd ,{ |X|  SomaInc(X,2,@nValDesc, , , , , ,	,aCodFol) })
	
	nValDesc :=  nValDesc + fBuscaPd(cVbIR,"V",cSemana) + fBuscaPd(cVbINSS,"V",cSemana)
	nMargem := (nSal - nValIR - nValINSS - nVlrPens) * (nPercMarg / 100)
	nDesc := (nValDesc - nValIR - nValINSS - nVlrPens - nVlrCoPart) + (nSal * nPercPart / 100)
		
	If nDesc > nSal * (nPercSup / 100)
		nMargem := nMargem - nDesc
	Endif

	If nMargem > 0 .and. Empty(fBuscaPD(cVbMargem,"V",cSemana))
		FGERAVERBA(cVbMargem,nMargem,,,,"V","C",,,,lRet,)
	Endif

	FGERAVERBA("964",nSal,,,,"V","C",,,,lRet,)
	FGERAVERBA("965",nSomaGrat,,,,"V","C",,,,lRet,)
	FGERAVERBA("966",nVlrPens,,,,"V","C",,,,lRet,)
	FGERAVERBA("967",nAssMed,,,,"V","C",,,,lRet,)
	FGERAVERBA("968",nOdonto,,,,"V","C",,,,lRet,)
	FGERAVERBA("971",nConsig,,,,"V","C",,,,lRet,)
	FGERAVERBA("969",nValINSS,,,,"V","C",,,,lRet,)
	FGERAVERBA("970",nValIR,,,,"V","C",,,,lRet,)
	FGERAVERBA("972",nCooper,,,,"V","C",,,,lRet,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCALCFER    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo de Ferias                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fCALCFER()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nPerc := nDesc := nDiasCalc := cCalc := nDiasFer := nVbTot := 0
	Local nVb1 := nVb2 := nVb3 := nVb4 := nVb5 := nVb6 := nVb7 := nVb8 := nVb9 := nVb10 := nVb11 := nVb12 := 0
	Local cVerba := cCalc := ""
	Local cVb1 := cVb2 := cVb3 := cVb4 := cVb5 := cVb6 := cVb7 := cVb8 := cVb9 := cVb10 := cVb11 := cVb12 := 0
	cTab   := "U012"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nDiasFer := fTabela(cTab,nLinha,5)
		nPerc := fTabela(cTab,nLinha,6)
		cVerba := fTabela(cTab,nLinha,7)
		cCalc := fTabela(cTab,nLinha,9)
		
		nDiasCalc := fBuscaPd(aCodFol[72,1],"H",cSemana) + fBuscaPd(aCodFol[73,1],"H",cSemana)

		If nDiasCalc == nDiasFer

			cVb1 := Substr(cCalc,1,3)
			cVb2 := Substr(cCalc,5,3)
			cVb3 := Substr(cCalc,9,3)
			cVb4 := Substr(cCalc,13,3)
			cVb5 := Substr(cCalc,17,3)
			cVb6 := Substr(cCalc,21,3)
			cVb7 := Substr(cCalc,25,3)
			cVb8 := Substr(cCalc,29,3)
			cVb9 := Substr(cCalc,33,3)
			cVb10 := Substr(cCalc,37,3)
			cVb11 := Substr(cCalc,41,3)
			cVb12 := Substr(cCalc,45,3)
			cVb13 := Substr(cCalc,49,3)
			cVb14 := Substr(cCalc,53,3)
			cVb15 := Substr(cCalc,57,3)
			cVb16 := Substr(cCalc,61,3)
			cVb17 := Substr(cCalc,65,3)
			cVb18 := Substr(cCalc,69,3)
			cVb19 := Substr(cCalc,73,3)
			cVb20 := Substr(cCalc,77,3)							

			nVb1 := fBuscaPd(cVb1,"V",cSemana)
			nVb2 := fBuscaPd(cVb2,"V",cSemana)
			nVb3 := fBuscaPd(cVb3,"V",cSemana)
			nVb4 := fBuscaPd(cVb4,"V",cSemana)
			nVb5 := fBuscaPd(cVb5,"V",cSemana)
			nVb6 := fBuscaPd(cVb6,"V",cSemana)
			nVb7 := fBuscaPd(cVb7,"V",cSemana)
			nVb8 := fBuscaPd(cVb8,"V",cSemana)
			nVb9 := fBuscaPd(cVb9,"V",cSemana)
			nVb10 := fBuscaPd(cVb10,"V",cSemana)
			nVb11 := fBuscaPd(cVb11,"V",cSemana)
			nVb12 := fBuscaPd(cVb12,"V",cSemana)
			nVb13 := fBuscaPd(cVb13,"V",cSemana)
			nVb14 := fBuscaPd(cVb14,"V",cSemana)
			nVb15 := fBuscaPd(cVb15,"V",cSemana)
			nVb16 := fBuscaPd(cVb16,"V",cSemana)
			nVb17 := fBuscaPd(cVb17,"V",cSemana)
			nVb18 := fBuscaPd(cVb18,"V",cSemana)
			nVb19 := fBuscaPd(cVb19,"V",cSemana)
			nVb20 := fBuscaPd(cVb20,"V",cSemana)
																											
			nVbTot := nVb1 + nVb2 + nVb3 + nVb4 + nVb5 + nVb6 + nVb7 + nVb8 + nVb9 + nVb10 
			nVbTot := nVbTot + nVb11 + nVb12 + nVb13  + nVb14  + nVb15  + nVb16 + nVb17
			nVbTot := nVbTot  + nVb18  + nVb19 + nVb20
			
			nDesc := nVbTot * (nPerc / 100)

			If nDesc > 0 //.and. Empty(fBuscaPD(cVerba,"V",cSemana))
				FGERAVERBA(cVerba,nDesc,nPerc,,,"V","C",,,,lRet,)
			Endif
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCALCFER    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo de Ferias  na Folha                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fFERFOL()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVerba := cVerbaFol := ""
	Local nDescFer := nPerc := 0

If !LDISSIDIO
	cTab   := "U012"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVerba := fTabela(cTab,nLinha,7)
		cVerbaFol := fTabela(cTab,nLinha,8)

		nDescFer := fBuscaPd(cVerba,"V",cSemana) * -1

		If nDescFer > 0  .and. Empty(fBuscaPD(cVerbaFol,"V",cSemana))
			nPerc := fBuscaPd(cVerba,"H",cSemana) * -1
			FGERAVERBA(cVerbaFol,nDescFer,nPerc,,,"V","C",,,,lRet,)
		EndIf
	Endif
ENDIF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfINDCOMP    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Indenizacao Compensatoria                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fINDCOMP()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbIR := aCodFol[067,1]
	Local cVbINSS := aCodFol[065,1]
	Local cVbFER := aCodFol[072,1]
	Local cVbAvis := aCodFol[111,1]
	Local nAnosCasa	:= fAnosCasa( dDataDem , SRA->RA_ADMISSA )
	Local nSal := SRA->RA_SALARIO
	Local nHrs	 := SRA->RA_HRSMES
	Local nDias := nDiasFer := nDesc := nDiasCalc := nVlAvis := nVlr := nQtDias := nDesc := 0
	Local cVerba := ""

	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	EndIf
	
	cTab   := "U013"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nFx1Ini := fTabela(cTab,nLinha,5)
		nFx1Fim := fTabela(cTab,nLinha,6)
		nFx1Vlr := fTabela(cTab,nLinha,7)
		nFx2Fim := fTabela(cTab,nLinha,8)
		nFx2Vlr := fTabela(cTab,nLinha,9)
		nFx3Fim := fTabela(cTab,nLinha,10)
		nFx3Vlr := fTabela(cTab,nLinha,11)
		nFx4Fim := fTabela(cTab,nLinha,12)
		nFx4Vlr := fTabela(cTab,nLinha,13)
		cVerba := fTabela(cTab,nLinha,14)

		If NANOSCASA >= nFx1Ini .and. NANOSCASA < nFx1Fim
			nVlr := nSal * nFx1Vlr
		EndIf
		If NANOSCASA >= nFx1Fim .and. NANOSCASA < nFx2Fim
			nVlr := nSal * nFx2Vlr
		EndIf
		If NANOSCASA >= nFx2Fim .and. NANOSCASA < nFx3Fim
			nVlr := nSal * nFx3Vlr
		EndIf
		If NANOSCASA >= nFx3Fim .and. NANOSCASA < nFx4Fim
			nVlr := nSal * nFx4Vlr
		EndIf
		
		nVlAvis := fBuscaPd(cVbAvis,"V",cSemana)
		nQtDias := fBuscaPd(cVbAvis,"H",cSemana)
		nDesc := 30 * (nVlAvis / nQtDias)
		nVlAvis := nVlAvis - nDesc
		
		If nVlr > nVlAvis .and. CRESCRAIS = "11" .and. fBuscaPd(cVbAvis,"V",cSemana) > 0 //.and. Empty(fBuscaPD(cVerba,"V",cSemana))
			FGERAVERBA(cVerba,nVlr,NANOSCASA,,,"V","C",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDSRNOT     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ DSR Adicional Noturno                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDSRNOT()

	Local cTab, nLinha
	Local lRet := .T.
	Local cVbADNOT := cVbDSRNOT := ""
	Local nHrDSRNot := nVlrADNot := nDiasNTrab:= nDiasTrab:= nDiasDSR := 0
	Local nPerc	:= 0
	
	cTab   := "U014"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVbADNOT := fTabela(cTab,nLinha,5)
		cVbDSRNot := fTabela(cTab,nLinha,6)
		nPerc := fTabela(cTab,nLinha,7)
	EndIf
	
	fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)
		
	nDiasNTrab := aPeriodo[nPosSem,8]
	nDiasTrab := aPeriodo[nPosSem,6]
	nDiasDSR := aPeriodo[nPosSem,7]
		
	nHrDSRNot := fBuscaPd(cVbADNOT,"H",cSemana)
	nVlrADNot := (((nHrDSRNot / nDiasTrab) * (nDiasDSR + nDiasNTrab)) * SALHORA) * (nPerc /100)
		
	If nVlrADNot > 0 //.and. Empty(fBuscaPD(cVbDSRNOT,"V",cSemana))
		FGERAVERBA(cVbDSRNOT,nVlrADNot,(nDiasDSR + nDiasNTrab),,,"V","C",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPRORATA    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pro-Rata                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fPRORATA()

	Local cTab, nLinha
	Local lRet := .T.
	Local nSal		 	:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local nSalP1 := nSalP2 := nAvosPR := nBaseAvos := 0
	Local cMesP1 := cMesP2 := cVerbaP1 := cVerbaP2 := ""
	Local nFator := 1
	
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif

	cTab   := "U015"

	fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)

	If SRA->RA_XPRORAT == "1" .and. !(SRA->RA_SITFOLH $ "D/T")
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nSalP1 := fTabela(cTab,nLinha,5)
			cMesP1 := fTabela(cTab,nLinha,6)
			nSalP2 := fTabela(cTab,nLinha,7)
			cMesP2 := fTabela(cTab,nLinha,8)
			cVerbaP1 := fTabela(cTab,nLinha,9)
			cVerbaP2 := fTabela(cTab,nLinha,10)
		EndIf
				
		If Year(SRA->RA_ADMISSA) == Year(dDataRef)
			If Month2Str(SRA->RA_ADMISSA) <= cMesP1
				nAvosPR := DateDiffDay(SRA->RA_ADMISSA,CTOD(P_QtDiaMes+"/"+cMesP1+"/"+Year2Str(dDataRef))) + 1
				nBaseAvos := DateDiffDay(CTOD("01/01/"+Year2Str(dDataRef)),CTOD(P_QtDiaMes +"/"+cMesP1+"/"+Year2Str(dDataRef))) + 1
				nFator := nAvosPR * nAvosPR
			Else
				nAvosPR := DateDiffDay(SRA->RA_ADMISSA,CTOD(P_QtDiaMes+"/"+cMesP2+"/"+Year2Str(dDataRef))) + 1
				nBaseAvos := DateDiffDay(CTOD("01/"+ cMesP1+1 +"/"+Year2Str(dDataRef)),CTOD(P_QtDiaMes+"/"+cMesP1+"/"+Year2Str(dDataRef))) + 1
				nFator := nAvosPR * nAvosPR
			EndIf
		EndIf
				
		If Substr(cPeriodo,5,2) == cMesP1 .and. nSalP1 > 0 .and. Empty(fBuscaPD(cVerbaP1,"V",cSemana))
			FGERAVERBA(cVerbaP1,(nSal * (nSalP1 / 100)) * nFator,(nSalP1 / 100),,,"V","C",,,,lRet,)
		EndIf
		If Substr(cPeriodo,5,2) == cMesP2 .and. nSalP2 > 0 .and. Empty(fBuscaPD(cVerbaP2,"V",cSemana))
			FGERAVERBA(cVerbaP2,(nSal * (nSalP2 / 100))* nFator,(nSalP2 / 100),,,"V","C",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfADICTIT    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adicional de Titulacao                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fADICTIT()

	Local cTab, nLinha
	Local lRet := .T.
	Local nPercTit := nVlrBase := nVltTit := 0
	Local cTit := cTabRef := cVerba := ""
	
	cTab   := "U016"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,5)
			cTit := fTabela(cTab,nLinha,5)
			nPercTit := fTabela(cTab,nLinha,6)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,7)
			cTit := fTabela(cTab,nLinha,7)
			nPercTit := fTabela(cTab,nLinha,8)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,9)
			cTit := fTabela(cTab,nLinha,9)
			nPercTit := fTabela(cTab,nLinha,10)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,11)
			cTit := fTabela(cTab,nLinha,11)
			nPercTit := fTabela(cTab,nLinha,12)
		EndIf
		cTabRef := fTabela(cTab,nLinha,13)
		cVerba := fTabela(cTab,nLinha,14)
	EndIf

	dbSelectArea("RBR")
	dbSetOrder(1)
	If dbSeek( xFilial("RBR") + cTabRef)
		While !Eof()
			If RBR->RBR_TABELA == cTabRef
				nVlrBase	:= RBR->RBR_VLREF
			Endif
			dbSkip()
		Enddo
	Endif

	nVltTit := nVlrBase * (nPercTit / 100)

	If nVltTit > 0 .and. Empty(fBuscaPD(cVerba,"V",cSemana))
		FGERAVERBA(cVerba,nVltTit,nPercTit,,,"V","C",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTCFA040     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Botao de Aprovacao Bolsa Estudo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TCFA040()
	Local aParam := PARAMIXB
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	xRet := .T.

	If RH3->RH3_TIPO == "V" .and. cIdPonto == 'BUTTONBAR'
		xRet := { {'Aprov.Subsidio', 'SALVAR', { || u_fAprovEst() }, 'Aprovado' } }
	EndIf
Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAprovEst     บAutor  ณ Rondo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aprovacao da Bolsa Estudo                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAprovEst()
	DbSelectArea("SRA")
	DbSetOrder(1)
	If DbSeek(xFilial("SRA")+SRA->RA_MAT)
		RecLock("SRA",.F.)
		SRA->RA_XESTUDO  := "1"
		SRA->(MsUnLock())
	Endif
	SRA->(dbSkip())
	
	DbSelectArea("RH3")
	DbSetOrder(1)
	If DbSeek(xFilial("RH3")+RH3->RH3_CODIGO)
		RecLock("RH3",.F.)
		RH3->RH3_STATUS := "2"
		RH3->RH3_DTATEN := DDATABASE
		RH3->(MsUnLock())
	Endif
	RH3->(dbSkip())
	
	Alert("Solicitacao Aprovada")
Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDescVRVA   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desconto da Base Empresa de VR e VA                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDescVRVA()

	Local cTab, nLinha
	Local lRet		:= .T.
	Local cVbVR	:= aCodFol[212,1]
	Local cVbVA	:= P_PDVAEMP
	Local cDescVR := cDescVA := ""
	Local nPercVR := nPercVA := nVlrVR := nVlrVA := nDescVR := nDescVA := 0

	cTab   := "U017"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPercVR := fTabela(cTab,nLinha,5)
		nPercVA := fTabela(cTab,nLinha,6)
		cDescVR := fTabela(cTab,nLinha,7)
		cDescVA := fTabela(cTab,nLinha,8)
	EndIf

	nVlrVR := fBuscaPd(cVbVR,"V",cSemana)
	nVlrVA := fBuscaPd(cVbVA,"V",cSemana)

	nDescVR := 	nVlrVR * (nPercVR/100)
	nDescVA := 	nVlrVA * (nPercVA/100)
	
	fDelPD(cDescVR)
	fDelPD(cDescVA)
	fDelPD(cVbVR)
	fDelPD(cVbVA)
			
	If nDescVR > 0 //.and. Empty(fBuscaPD(cDescVR,"V",cSemana))
		FGERAVERBA(cDescVR,nDescVR,,,,"V","C",,,,lRet,)
		FGERAVERBA(cVbVR,(nVlrVR - nDescVR),,,,"V","C",,,,lRet,)
	Endif
	
	If nDescVA > 0 //.and. Empty(fBuscaPD(cDescVA,"V",cSemana))
		FGERAVERBA(cDescVA,nDescVA,,,,"V","C",,,,lRet,)
		FGERAVERBA(cVbVA,(nVlrVA - nDescVA),,,,"V","C",,,,lRet,)
	Endif
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTRM020DG    บAutor  ณ Lourival A. Nogu บ Data ณ 01/01/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na Confirmacao do Cargo pelo Cargos &     บฑฑ
ฑฑบ          ณ Salแrios                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TRM020DG()

	u_fGravaSRJ()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMDGPEA370   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada na Confirmacao do Cargo                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MDGPEA370()
	Local aParam := PARAMIXB
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	xRet := .T.

	If cIdPonto == 'MODELCOMMITTTS'
		u_fGravaSRJ()
	EndIf
Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGravaSRJ   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gravacao dos Dados do Cargo na Funcao                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGravaSRJ()
	DbSelectArea("SRJ")
	DbSetOrder(1)
	If SRJ->(dbSeek(xFilial("SQ3") + SQ3->Q3_CARGO ))
		RecLock("SRJ",.F.)
		SRJ->RJ_FILIAL := ALLTRIM(SQ3->Q3_FILIAL)
		SRJ->RJ_FUNCAO := ALLTRIM(SQ3->Q3_CARGO)
		//SRJ->RJ_DESC := SQ3->Q3_DESCSUM
		SRJ->RJ_DESC := SQ3->Q3_XESPECI
		SRJ->RJ_CODCBO := SQ3->Q3_XCODCBO
		SRJ->RJ_MAOBRA := SQ3->Q3_XMAOBRA
		SRJ->RJ_CARGO := SQ3->Q3_CARGO
		SRJ->RJ_SALARIO := SQ3->Q3_XSALARI
		SRJ->RJ_PPPIMP := SQ3->Q3_XPPPIMP
		SRJ->RJ_LIDER := SQ3->Q3_XLIDER
		SQ3->(MsUnLock())
	Else
		RecLock("SRJ",.T.)
		SRJ->RJ_FILIAL := ALLTRIM(SQ3->Q3_FILIAL)
		SRJ->RJ_FUNCAO := ALLTRIM(SQ3->Q3_CARGO)
		//SRJ->RJ_DESC := SQ3->Q3_DESCSUM
		SRJ->RJ_DESC := SQ3->Q3_XESPECI
		SRJ->RJ_CODCBO := ALLTRIM(SQ3->Q3_XCODCBO)
		SRJ->RJ_MAOBRA := SQ3->Q3_XMAOBRA
		SRJ->RJ_CARGO := SQ3->Q3_CARGO
		SRJ->RJ_SALARIO := SQ3->Q3_XSALARI
		SRJ->RJ_PPPIMP := SQ3->Q3_XPPPIMP
		SRJ->RJ_LIDER := SQ3->Q3_XLIDER
		SQ3->(MsUnLock())
	EndIf
	DbCloseArea()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRegProp    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Regime Proprio Previdencia Social                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fRegProp()

	Local cTab, nLinha
	Local lRet := .T.
	Local cVbFunc  := cVbEmp := cVbBase := ""
	Local nVlrBase := SRA->RA_XVLRCED
	Local nPerFunc := SRA-> RA_XCEDFUN
	Local nPercEmp := SRA-> RA_XCEDEMP
	Local nHrs		 := SRA->RA_HRSMES

	cTab   := "U020"
	
	If SRA->RA_CATFUNC == "H"
		nVlrBase:= (nVlrBase * nHrs)
	Endif

	If SRA->RA_XCEDIDO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVbFunc := fTabela(cTab,nLinha,5)
			cVbEmp := fTabela(cTab,nLinha,6)
			cVbBase := fTabela(cTab,nLinha,7)
		Endif
		
		nVlrFunc := nVlrBase * (nPerFunc / 100)
		nVlrEmp := nVlrBase * (nPercEmp / 100)
		
		If nVlrBase > 0 .and. Empty(fBuscaPD(cVbBase,"V",cSemana))
			FGERAVERBA(cVbBase,nVlrBase,100.00,,,"V","C",,,,lRet,)
		EndIf

		If nVlrFunc > 0 .and. Empty(fBuscaPD(cVbFunc,"V",cSemana))
			FGERAVERBA(cVbFunc,nVlrFunc,nPerFunc,,,"V","C",,,,lRet,)
		EndIf

		If nVlrEmp > 0 .and. Empty(fBuscaPD(cVbEmp,"V",cSemana))
			FGERAVERBA(cVbEmp,nVlrEmp,nPercEmp,,,"V","C",,,,lRet,)
		EndIf
	
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDescBH     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desconto Limite Banco de Horas                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDescBH()

	Local cTab, nLinha
	Local lRet		:= .T.
	Local nSal		:= SRA->RA_SALARIO
	Local nHrs		:= SRA->RA_HRSMES
	Local cVbDesc := cVbBase := cPerProj := cMesesCalc := ""
	Local nPerc 	:= nLim := nVlrBase := nVlrLim := nVlrParc := nVlrRest := nHrsBase := nSalHora := 0
	Local nParc	:= 1
	Local dDataProj := CtoD("//")

If cSemana = "01"

	cTab   := "U018"

	nSalHora:= SALMES / nHrs
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPerc := fTabela(cTab,nLinha,5)
		cVbDesc := fTabela(cTab,nLinha,6)
		cVbBase := fTabela(cTab,nLinha,7)
		cMesesCalc := fTabela(cTab,nLinha,8)
	EndIf

	nHrsBase := fBuscaPd(cVbBase,"H",cSemana)
	nVlrBase := nHrsBase * nSalHora
	_aArea := SRK->(GetArea())		
	//If Month2Str(dDataRef) $ cMesesCalc //Substituido a variavel dDataRef por dDataDH criado na fun็ใo fAUXCRE
	If Month2Str(_dxDtBh) $ cMesesCalc
		nLim := SALMES * (nPerc / 100)

		If nVlrBase > nLim
			nParc := int(nVlrBase/nLim)
			nVlrParc := nLim
			nVlrRest := nVlrBase - (nLim * nParc)
		Else
			nVlrParc := nVlrBase
		EndIf
		
		
		//DbSelectArea("SRK")
		SRK->(DbSetOrder(4))
		
		If nVlrParc > 0
			If SRK->(dbSeek(xFilial("SRA") + SRA->RA_MAT + cVbDesc + cPeriodo + cSemana  ))
				RecLock("SRK",.F.)
				SRK->RK_FILIAL := SRA->RA_FILIAL
				SRK->RK_PD := cVbDesc
				SRK->RK_MAT := SRA->RA_MAT
				SRK->RK_VALORTO := nVlrParc * nParc
				SRK->RK_PARCELA := nParc
				SRK->RK_VALORPA := nVlrParc
				SRK->RK_DTVENC := _dxDtBh//dDataRef
				SRK->RK_QUITAR := '2'
				SRK->RK_EMPCONS := '2'
				SRK->RK_VLSALDO := nVlrParc * nParc
				SRK->RK_CC := SRA->RA_CC
				SRK->RK_DTMOVI := _dxDtBh//dDataRef
				SRK->RK_PERINI := cPeriodo
				SRK->RK_NUMPAGO := cSemana
				SRK->RK_PROCES := SRA->RA_PROCES
				SRK->RK_STATUS := '2'
				SRK->RK_NUMID := "BH" + cPeriodo //+ Day2Str(dDataRef)
				SRK->RK_REGRADS := '1'
				SRK->RK_POSTO := SRA->RA_POSTO
				//SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
				SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(_dxDtBh),2)) + ALLTRIM(Month2Str(_dxDtBh))
				SRK->(MsUnLock())
			Else
				RecLock("SRK",.T.)
				SRK->RK_FILIAL := SRA->RA_FILIAL
				SRK->RK_PD := cVbDesc
				SRK->RK_MAT := SRA->RA_MAT
				SRK->RK_VALORTO := nVlrParc * nParc
				SRK->RK_PARCELA := nParc
				SRK->RK_VALORPA := nVlrParc
				SRK->RK_DTVENC := _dxDtBh//dDataRef
				SRK->RK_QUITAR := '2'
				SRK->RK_EMPCONS := '2'
				SRK->RK_VLSALDO := nVlrParc * nParc
				SRK->RK_CC := SRA->RA_CC
				SRK->RK_DTMOVI := _dxDtBh//dDataRef
				SRK->RK_PERINI := cPeriodo
				SRK->RK_NUMPAGO := cSemana
				SRK->RK_PROCES := SRA->RA_PROCES
				SRK->RK_STATUS := '2'
				SRK->RK_NUMID := "BH" + cPeriodo //+ Day2Str(dDataRef)
				SRK->RK_REGRADS := '1'
				SRK->RK_POSTO := SRA->RA_POSTO
				//SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
				SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(_dxDtBh),2)) + ALLTRIM(Month2Str(_dxDtBh))
				SRK->(MsUnLock())
			EndIf
		EndIf
		If nVlrRest > 0
			//dDataProj := DaySum(dDataRef,((nParc+1)*30))
			dDataProj := DaySum(_dxDtBh,((nParc+1)*30))
			cPerProj:= AllTrim(Str(Year(dDataProj))) + RIGHT("0" + AllTrim(Str(Month(dDataProj))),2)
			If SRK->(dbSeek(xFilial("SRA") + SRA->RA_MAT + cVbDesc + cPerProj + cSemana  ))
				RecLock("SRK",.F.)
				SRK->RK_FILIAL := SRA->RA_FILIAL
				SRK->RK_PD := cVbDesc
				SRK->RK_MAT := SRA->RA_MAT
				SRK->RK_DOCUMEN := cVbDesc+cPerProj
				SRK->RK_VALORTO := nVlrRest
				SRK->RK_PARCELA := 1
				SRK->RK_VALORPA := nVlrRest
				SRK->RK_DTVENC := DaySum(_dxDtBh,((nParc+1)*30))//DaySum(dDataRef,((nParc+1)*30))
				SRK->RK_QUITAR := '2'
				SRK->RK_EMPCONS := '2'
				SRK->RK_VLSALDO := nVlrRest
				SRK->RK_CC := SRA->RA_CC
				SRK->RK_DTMOVI := DaySum(_dxDtBh,((nParc+1)*30))//DaySum(dDataRef,((nParc+1)*30))
				SRK->RK_PERINI := cPerProj
				SRK->RK_NUMPAGO := cSemana
				SRK->RK_PROCES := SRA->RA_PROCES
				SRK->RK_STATUS := '2'
				SRK->RK_NUMID := "BP" + cPeriodo //+ Day2Str(dDataRef)
				SRK->RK_REGRADS := '1'
				SRK->RK_POSTO := SRA->RA_POSTO
				//SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))//_dxDtBh
				SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(_dxDtBh),2)) + ALLTRIM(Month2Str(_dxDtBh))
				SRK->(MsUnLock())
			Else
				RecLock("SRK",.T.)
				SRK->RK_FILIAL := SRA->RA_FILIAL
				SRK->RK_PD := cVbDesc
				SRK->RK_MAT := SRA->RA_MAT
				SRK->RK_VALORTO := nVlrRest
				SRK->RK_PARCELA := 1
				SRK->RK_VALORPA := nVlrRest
				SRK->RK_DTVENC := DaySum(_dxDtBh,((nParc+1)*30))//DaySum(dDataRef,((nParc+1)*30))
				SRK->RK_QUITAR := '2'
				SRK->RK_EMPCONS := '2'
				SRK->RK_VLSALDO := nVlrRest
				SRK->RK_CC := SRA->RA_CC
				SRK->RK_DTMOVI := DaySum(_dxDtBh,((nParc+1)*30))//DaySum(dDataRef,((nParc+1)*30))
				SRK->RK_PERINI := cPerProj
				SRK->RK_NUMPAGO := cSemana
				SRK->RK_PROCES := SRA->RA_PROCES
				SRK->RK_STATUS := '2'
				SRK->RK_NUMID := "BP" + cPeriodo //+ Day2Str(dDataRef)
				SRK->RK_REGRADS := '1'
				SRK->RK_POSTO := SRA->RA_POSTO
				//SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
				SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(_dxDtBh),2)) + ALLTRIM(Month2Str(_dxDtBh))
				SRK->(MsUnLock())
			EndIf
		EndIf
	Else
		FGERAVERBA(cVbDesc,nVlrBase,nHrsBase,,,"V","C",,,,lRet,)
	EndIf
	RestArea(_aArea)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalc131    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo 1a. Parcela 13o. Salario                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fCalc131()

	Local nCont	:= 0
	Local cVerba 	:= ""
	Private cPerg := "GPEM250B"

//	CriaPerg131()
//	Pergunte(cPerg,.T.)

	
	RCM->(dbSetOrder(1))
	RCM->(dbSeek(xFilial("RCM")))

	Do While !(RCM->(Eof())) .and. RCM->RCM_TIPOAF == "4"
	
		cVerba := RCM->RCM_PD
		SR8->(dbSetOrder(8))
		SR8->(dbSeek( SRA->(RA_FILIAL + RA_MAT)))

		Do While !(SR8->(Eof())) .and. SR8->(R8_FILIAL + R8_MAT) == SRA->(RA_FILIAL + RA_MAT)
			If SR8->R8_DATAINI >= MV_PAR09 .and. SR8->R8_DATAINI <= MV_PAR10 .and. SR8->R8_PD == cVerba
				nCont := nCont++
			EndIf
			SR8->(dbSkip())
		EndDo
		RCM->(dbSkip())
	EndDo
	If nCont == 0 .and. !Empty(MV_PAR09) .and. !Empty(MV_PAR10)
		NoPrcReg()
	Endif
Return

Static Function CriaPerg131()

	Local aRegs := {}

	aAdd(aRegs,{ cPerg,'01','Calcular em Ordem de    ?','','','mv_ch1','N',01,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','     ','' })
	aAdd(aRegs,{ cPerg,'02','Qual o Percentual       ?','','','mv_ch2','N',03,0,0,'G','Positivo() .AND. fValidPercent(M->MV_PAR02)','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'03','Calcula Medias          ?','','','mv_ch3','N',01,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','     ','' })
	aAdd(aRegs,{ cPerg,'04','Arredondamento          ?','','','mv_ch4','N',01,0,0,'G','           ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','     ','' })
	aAdd(aRegs,{ cPerg,'05','Complemento 1a Parcela  ?','','','mv_ch5','N',01,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'06','Data de Referencia      ?','','','mv_ch6','D',08,0,0,'G','NaoVazio() ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'07','Referencia para Media   ?','','','mv_ch7','D',08,0,0,'G','           ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'08','Considera mes atual     ?','','','mv_ch8','N',01,0,0,'G','           ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'09','Ferias De               ?','','','mv_ch9','D',08,0,0,'G','           ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'10','Ferias Ate              ?','','','mv_cha','D',08,0,0,'G','           ','mv_par10','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

	ValidPerg(aRegs,cPerg)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBase30     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo com Base de 30 Dias                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fBase30()

	CVRBAFAST := FTABELA("U052", 1, 9, DDATAREF )
	nDiasAux := fBuscaPd(CVRBAFAST,"H",cSemana)
	nDiasAf := fBuscaPd(aCodFol[041,1],"H",cSemana)

	If SRA->RA_SITFOLH $ "F"
		If nDiasP == 31 .and. DiasTrab + nDiasPg + nDiasAux > 30
			DiasTrab := DiasTrab - 1
		ElseIf nDiasP == 28 .and. DiasTrab + nDiasPg + nDiasAux == 28
			DiasTrab := DiasTrab + 2
		ElseIf nDiasP == 29 .and. DiasTrab + nDiasPg + nDiasAux == 29
			DiasTrab := DiasTrab +1
		EndIf
	EndIf
	
	If (nDiasP == 31 .and. (AnoMes(SRA->RA_ADMISSA) == cAnoMes .and. AnoMes(dDataAte) == cAnoMes) .and. Day(SRA->RA_ADMISSA) <> 01) //.or. (DiasTrab + nDiasPg + nDiasAux > 30))// .or. (nDiasAfas > 0 .and. nDiasAfas < 30) .or. (!Empty(aCodFol[072,1]) .and. aCodFol[072,1] < 30))
		DiasTrab := DiasTrab - 1
	ElseIf (nDiasP == 28 .and. (AnoMes(SRA->RA_ADMISSA) == cAnoMes .and. AnoMes(dDataAte) == cAnoMes) .and. Day(SRA->RA_ADMISSA) <> 01) //.or. (DiasTrab + nDiasPg + nDiasAux > 30))// .or. (nDiasAfas > 0 .and. nDiasAfas < 30) .or. (!Empty(aCodFol[072,1]) .and. aCodFol[072,1] < 30))
		DiasTrab := DiasTrab + 2
	ElseIf (nDiasP == 29 .and. (AnoMes(SRA->RA_ADMISSA) == cAnoMes .and. AnoMes(dDataAte) == cAnoMes) .and. Day(SRA->RA_ADMISSA) <> 01) //.or. (DiasTrab + nDiasPg + nDiasAux < 30))// .or. (nDiasAfas > 0 .and. nDiasAfas < 30) .or. (!Empty(aCodFol[072,1]) .and. aCodFol[072,1] < 30))
		DiasTrab := DiasTrab + 1
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP650CPO บ Autor ณ Ronaldo Oliveira   บ Data ณ 01/08/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava Matricula/Nome do Funcionario no Historico do Titulo. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP650CPO()
	_aArea := GetArea()
	dbSelectArea("SRA")
	dbSetOrder(1)
	If cAgrupa = "4"
		If(dbSeek(RC1->RC1_FILTIT+RC1->RC1_MAT))
			RC1->RC1_XNOMFU := SRA->RA_NOME
			RC1->RC1_XCPFFU := SRA->RA_CIC
			RC1->RC1_XBCOFU := "Bco/Ag: "+SRA->RA_BCDEPSA+" - Cta Dep Salแrio: "+SRA->RA_CTDEPSA
		EndIf
	EndIf
	RestArea( _aArea )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP670CPO บ Autor ณ Ronaldo Oliveira   บ Data ณ 01/08/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para gravacao da descricao dos titulos    บฑฑ
ฑฑบ          ณ gerados para o financeiro, em campos especํficos.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP670CPO
	RecLock("SE2",.F.,.F.)

	SE2->E2_XNOMFUN := RC1->RC1_XNOMFU
	SE2->E2_XCPFFUN := RC1->RC1_XCPFFU
	SE2->E2_XBCOFUN := RC1->RC1_XBCOFU
	SE2->E2_HIST 	:= RC1->RC1_DESCRI
	SE2->E2_CCD 	:= RC1->RC1_CC

	MsUnLock()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDELCOPART บ Autor ณ Ronaldo Oliveira  บ Data ณ 01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui Registros da Tabela de Co-Participacao (RHO)        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDelCoPart()

	Private cPerg := "XCOPART"

	CriaPergCP()
	Pergunte(cPerg,.T.)

	cQuery := " DELETE FROM " + RetSqlName ("RHO")
	cQuery += " WHERE RHO_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += " AND RHO_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND RHO_DTOCOR BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'"
	TCSQLExec(cQuery)
	cQuery := "COMMIT"
	TCSQLExec(cQuery)
	DbCloseArea()
	Alert("Exclusใo Efetuada com Sucesso")
Return()

Static Function CriaPergCP()

	Local aRegs := {}

	aAdd(aRegs,{ cPerg,'01','Filial De               ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'02','Filial Ate              ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'03','Matricula De            ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
	aAdd(aRegs,{ cPerg,'04','Matricula Ate           ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
	aAdd(aRegs,{ cPerg,'05','Data De                 ?','','','mv_ch5','D',08,0,0,'G','NaoVazio   ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'06','Data Ate                ?','','','mv_ch6','D',08,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

	ValidPerg(aRegs,cPerg)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCALCBH บ Autor ณ Ronaldo Oliveira  บ Data ณ    01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calculo Banco de Horas                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fCalcBH()

	Local cTab, nLinha
	Local lRet := .T.
	Local nHrsNeg := nHrsPos := 0
	Local cVbPos := cVbNeg := cVbPosC := cVbNegC := ""
	
	cTab   := "U022"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVbPos := fTabela(cTab,nLinha,5)
		cVbNeg := fTabela(cTab,nLinha,6)
		cVbPosC := fTabela(cTab,nLinha,7)
		cVbNegC := fTabela(cTab,nLinha,8)
	EndIf

	nHrsPos := fBuscaPd(cVbPos,"H",cSemana)
	nHrsNeg := fBuscaPd(cVbNeg,"H",cSemana)
		
	If !Empty(nHrsPos) .or. !Empty(nHrsNeg)
		nHrsPos := nHrsPos - nHrsNeg
		If nHrsPos > 0 .and. Empty(fBuscaPD(cVbPosC,"H",cSemana)) .and. Empty(fBuscaPD(cVbNegC,"H",cSemana))
			FGERAVERBA(cVbPosC,((SALMES/SRA->RA_HRSMES) * nHrsPos),nHrsPos,,,"H","C",,,,lRet,)
		ElseIf nHrsPos < 0 .and. Empty(fBuscaPD(cVbNegC,"H",cSemana)) .and. Empty(fBuscaPD(cVbPosC,"H",cSemana))
			FGERAVERBA(cVbNegC,((SALMES/SRA->RA_HRSMES) * (nHrsPos * -1)),(nHrsPos * -1),,,"H","C",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fESCBH บ Autor ณ Ronaldo Oliveira  บ Data ณ     01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Escalonamento Banco de Horas                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fESCBH()

	Local cTab, nLinha, cTab2
	Local lRet := .T.
	Local cVbPos := cVerba := cMesesCalc := ""
	Local nMin:= nLim:= nPerc:= nCont:= nAcum := nHrsPos:= nAux := nSalBase := 0
	
	cTab1   := "U022"
	cTab2   := "U023"

	If (nLinha := fPosTab(cTab1,SRA->RA_SINDICA,"=",4)) > 0
		cVbPos := fTabela(cTab1,nLinha,7)
	EndIf
			
	nHrsPos := fBuscaPd(cVbPos,"H",cSemana)
	nSalBase := SRA->RA_SALARIO + fBuscaPd(aCodFol[001,1],"V",cSemana)+fBuscaPd(aCodFol[036,1],"V",cSemana)+fBuscaPd(aCodFol[038,1],"V",cSemana)+fBuscaPd(ftabela("U050",01,06),"V",cSemana)
	
	If nHrsPos > 0
		RCC->(dbSetOrder( 1 ))
		RCC->(dbSeek( xFilial("RCC") + cTab2))
		nCont := FPOSTAB(cTab2, SRA->RA_SINDICA,"=",4, nHrsPos, "<=", 6)
		nAux:= 0
		For nX := 1 to nCont
			nAux:= nAux + 1
			nMin := fTabela(cTab2,nAux,5)
			nLim := fTabela(cTab2,nAux,6)
			nPerc := fTabela(cTab2,nAux,7)
			cVerba := fTabela(cTab2,nAux,8)
			cMesesCalc := fTabela(cTab2,nAux,9)
			
			If Month2Str(dDataRef) $ cMesesCalc
				If nHrsPos > nLim
					FGERAVERBA(cVerba,((nSalBase/SRA->RA_HRSMES) * ((nLim - nMin) * (1+(nPerc/100)))),(nLim - nMin),,,"V","C",,,,lRet,)
					nAcum := nAcum + (nLim - nMin)
				Else
					FGERAVERBA(cVerba,((nSalBase/SRA->RA_HRSMES) * ((nHrsPos - nAcum) * (1+(nPerc/100)))),(nHrsPos - nAcum),,,"V","C",,,,lRet,)
				EndIf
			EndIf
		Next
		("RCC")->(dbSkip())
		DbCloseArea()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fANUPROP  บ Autor ณ  Ronaldo Oliveira  บ Data ณ  1/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Proporcionalizacao de Anuenio                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAnuProp()

	Local lRet := .T.
	Local nValAnuen := nVlrAf := nDiasAnu := 0
	Local A12AFAST := {}

	If !(CTIPOROT $ "5*6")

		If fBuscaPd(aCodFol[001,1],"V",cSemana) > 0 .AND. DIASTRAB <> 30
		
			nValAnuen := fBuscaPd(aCodFol[001,1],"V",cSemana)
		//nDiasAf := fBuscaPd(aCodFol[041,1],"H",cSemana) + fBuscaPd(aCodFol[041,1],"H",cSemana)
			cVbFER := fBuscaPd(aCodFol[072,1],"H",cSemana)

			If nValAnuen > 0 .and. !LDISSIDIO .and. DIASTRAB <> 30
//				fDelPD(aCodFol[001,1],,)
//				FGERAVERBA(aCodFol[001,1],(nValAnuen / 30) * (DiasTrab + nDiasPg + cVbFER),(DiasTrab + nDiasPg + cVbFER),,,"V","C",,,,lRet,)
				FGERAVERBA(ftabela("U050",11,06),(nValAnuen / 30) * (30 - (DiasTrab + nDiasPg + cVbFER)), (30 - (DiasTrab + nDiasPg + cVbFER)),,,"V","C",,,,lRet,)
			EndIf
		EndIf

		If LDISSIDIO
			nVlrAf := FBUSCAACM("638" , ,(dDataRef), (dDataRef ),"V") * -1
			If nVlrAf > 0
				FGERAVERBA(ftabela("U050",11,06),nVlrAf,FBUSCAACM("638" , ,(dDataRef), (dDataRef ),"H") * -1,,,"V","C",,,,lRet,)
			EndIf
		EndIf


	Else
		nValAnuen := fBuscaPd(aCodFol[001,1],"V",cSemana)
		nDiasAnu := fBuscaPd(aCodFol[024,1],"H",cSemana)
		fDelPD(aCodFol[001,1],,)
		fGeraVerba(aCodFol[001,1],(nValAnuen/12)*nDiasAnu,nDiasAnu,,,"V","C",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGratMS  บ Autor ณ   Ronaldo Oliveira  บ Data ณ  1/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gratificacao Mes Seguinte                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGratMS()

	Local lRet := .T.
	Local cVerba := cVerbaFer := ""
	Local nMesSeg := nMesAnt := nFerPag := nDiasSeg := nValFer := cVbGratFer := 0
	
	If !lDISSIDIO
		
		cVerba := ftabela("U050",09,06)
		cVbGratFer := ftabela("U050",04,06)
		cVerbaFer := aCodFol[164,1]
		nMesSeg := FBUSCAACM(ftabela("U050",08,06) , ,(dDataRef - 30), (dDataRef - 1),"V")
		
		If nMesSeg > 0
			nDiasSeg:= FBUSCAACM(ftabela("U050",08,06) , ,(dDataRef - 30), (dDataRef - 1),"H")
			nFerPag := fBuscaPd(cVerbaFer,"V",cSemana) * -1
			nValFer := nFerPag + nMesSeg
			fDelPD(cVerbaFer,,)
			fDelPD(cVbGratFer,,)
			fGeraVerba(cVerba,nMesSeg,nDiasSeg,,,"V","C",,,,lRet,)
			fGeraVerba(cVerbaFer,nValFer,,,,"V","C",,,,lRet,)
		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAjustAP    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta Aviso Previo com Indenizacao Compensatoria          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAjustAP()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbAvis := aCodFol[111,1]
	Local nVlAvis := nDiasAvis := nVlrDiaAP := 0
	Local cVerba := ""

	cTab   := "U013"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVerba := fTabela(cTab,nLinha,14)
	EndIf
	
	If !Empty(fBuscaPd(cVerba,"V",cSemana)) .and. fBuscaPd(cVbAvis,"H",cSemana) > 30
		nVlAvis := fBuscaPd(cVbAvis,"V",cSemana)
		nDiasAvis := fBuscaPd(cVbAvis,"H",cSemana)
		nVlrDiaAP := nVlAvis / nDiasAvis
		fDelPD(cVbAvis,,)
		fGeraVerba(cVbAvis,(nVlrDiaAP * 30),30,,,"V","C",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDELCOPART บ Autor ณ Ronaldo Oliveira  บ Data ณ 01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Reajusta Verbas Retroativas                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDISSID()

	Private cPerg := "XDISSID"

	CriaPergDis()
	Pergunte(cPerg,.T.)

	PROCESSA({|| DISSID() },,"Processando...",.F.)

Return

Static Function DISSID()
 
	Local cTab, cTabMed
	Local nAcumula := nMeses:= nEmpr:= nLim := nComprov := nDif := nResult := nCont := nGratif := 0
	Local cVerba := cVerbaR := cVerbaE := cVerbaM := cTpPlan := cPeriod := cComprov := cCodForn := cAtiv := ""
	Private cPerg := "XDISSID"
	
	ProcRegua(0)
 	  		
	cTab   := "U028"
	cTabMed  := "U053"
	nMeses := Int((MV_PAR06 - MV_PAR05) / 30 )

	RCC->(dbSetOrder(RetOrder("RCC","RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN")))
	RHK->(DbSetOrder(1))
	SRC->(DbSetOrder(1))
	RHS->(DbSetOrder(1))
	SRA->(DbSetOrder(1))
	RGB->(DbSetOrder(1))
	SRV->(DbSetOrder(2))
	RHP->(DbSetOrder(1))
//	nCont := 1
	If SRV->(DbSeek(xFilial("SRV")+"0049"))
		cVerbaM:= SRV->RV_COD
	EndIf
	If SRV->(DbSeek(xFilial("SRV")+"0213"))
		cVerbaE:= SRV->RV_COD
	EndIf
	
	SRA->(DbSeek(MV_PAR01+MV_PAR03,.T.))
	
	Do While !(SRA->(Eof())) .and. SRA->(RA_FILIAL + RA_MAT) >= MV_PAR01 + MV_PAR03 .and. SRA->(RA_FILIAL + RA_MAT) <= MV_PAR02 + MV_PAR04 .and. SRA-> RA_SITFOLH # "D/T"
	If SRA->RA_XPERC > 0
		RCC->(dbSeek(xFilial("RCC")+cTab))
		While RCC->(!Eof()) .And.  RCC->RCC_FILIAL + RCC->RCC_CODIGO == xFilial("RCC")+cTab .and. Subs(RCC->RCC_CONTEU,1,2) == SRA->RA_SINDICA
			nRecRCC := RCC->(recno())
//			nRecSRA := SRA->(recno())
			cAtiv := Subs(RCC->RCC_CONTEU,26,1)
			cVerba := Subs(RCC->RCC_CONTEU,3,3)
			cVerbaR := Subs(RCC->RCC_CONTEU,6,3)
			nPerc := NoRound(Val(Subs(RCC->RCC_CONTEU,9,6)),2)
			nLim := NoRound(Val(Subs(RCC->RCC_CONTEU,15,8)),2)
			cComprov := Subs(RCC->RCC_CONTEU,23,3)
			nAcumula := 0
			nCoPFunc := 0
			nCoPEmp := 0
			nDif := 0
			nLimCoP := 0
			nSalBase := 0
			nCoPart := 0
			nAcumula := FBUSCAACM(cVerba , ,MV_PAR05, MV_PAR06,"V")
			nComprov := FBUSCAACM(cComprov , ,MV_PAR05, MV_PAR06,"V")
			nGratif := FBUSCAACM("033" , ,MV_PAR05, MV_PAR06,"V")
//			nCont := nCont+1
			If nAcumula < 0
				nAcumula := nAcumula * -1
			EndIf
			If Empty(nPerc)
				nPerc := SRA->RA_XPERC
			EndIf
			If nPerc > 0			
			If cVerba = "691"
				RHP->(dbSeek(xFilial("RHP")+SRA->RA_MAT+DTOS(MV_PAR05)))
				While RHP->(!Eof()) .And.  RHP->RHP_FILIAL + RHP->RHP_MAT == xFilial("SRA")+SRA->RA_MAT 
				If RHP->RHP_DTOCOR >= MV_PAR05 .AND. RHP->RHP_DTOCOR <= MV_PAR06
					nCoPFunc := nCoPFunc + RHP->RHP_VLRFUN
					nCoPEmp := nCoPEmp + RHP->RHP_VLREMP
				EndIf
				//Exit
				RHP->(dbSkip())
				EndDo
				nCoPart := nCoPFunc + nCoPEmp
				nSalBase := FBUSCAACM("301" , ,MV_PAR05, MV_PAR06,"V")+FBUSCAACM("291" , ,MV_PAR05, MV_PAR06,"V")+FBUSCAACM("024" , ,MV_PAR05, MV_PAR06,"V")
				nLimCoP :=  (nSalBase+(nSalBase) * (nPerc/100)) * 0.04
				If nAcumula < nLimCoP
					If nCoPart > nLimCoP
						nDif := nLimCoP
					Else
						nDif := nCoPart
					EndIf
					nAcumula := nDif - nAcumula
				EndIf
				If nCoPEmp = 0
					nAcumula := 0
				EndIf
			EndIf
		    
			If Empty(nPerc)
				nPerc := SRA->RA_XPERC
			EndIf
			If nAcumula < 0
				nAcumula := nAcumula * -1
			EndIf
			If cVerba == cVerbaM
				If RHK->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"1"))
					cTpPlan := RHK->RHK_PLANO
					cCodForn := RHK->RHK_CODFOR
				EndIf
				RCC->(dbSeek(xFilial("RCC")+cTabMed))
				While RCC->(!Eof()) .and. RCC->RCC_FILIAL + RCC->RCC_CODIGO == xFilial("RCC")+cTabMed
					If Subs(RCC->RCC_CONTEU,1,2) == cTpPlan
						nPercSal := NoRound(Val(Subs(RCC->RCC_CONTEU,24,6)),2)
						If nGratif == 0
							nAcumula := SRA->RA_SALARIO * (nPercSal/100)
						EndIf
						Exit
					EndIf
					RCC->(dbSkip())	
				EndDo
				nAcumula := nAcumula * nMeses
				If cVerba <> cVerbaE .and. cVerba <> cVerbaM 
					nLim := nLim * nMeses
					nDif := nComprov - nAcumula
					If !Empty(cComprov)
						If (nDif + nAcumula) > 0 .and. (nDif + nAcumula) > nLim
							nAcumula := nLim
						Else
							nAcumula := nDif
						EndIf
					EndIf
				EndIf
								
				RCC->(dbgoto(nRecRCC))
//				SRA->(dbgoto(nRecSRA))
			EndIf
			If Empty(AllTrim(cComprov)) .and. cVerba <> "691"
				nAcumula := (nAcumula * (nPerc/100))
			EndIf
			If cVerba == cVerbaE
				nEmpr := nAcumula
				nAcumula := 0
			EndIf
			cPeriod := DtoS(dDataBase)
			cPeriod := Substr(cPeriod,1,6)
			
			If nAcumula > 0 .AND. cAtiv = "S" .and. nGratif == 0
			nCont := nCont+1
			If nCont = 10
				nCont := 1
			EndIf
				If RGB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cVerbaR + cPeriod + "01" + cValtoChar(nCont)))
					RecLock("RGB",.F.)
					RGB->RGB_FILIAL := SRA->RA_FILIAL
					RGB->RGB_PROCES := SRA->RA_PROCES
					RGB->RGB_PERIOD := cPeriod
					RGB->RGB_SEMANA := "01"
					RGB->RGB_ROTEIR := "FOL"
					RGB->RGB_MAT := SRA->RA_MAT
					RGB->RGB_PD := cVerbaR
					RGB->RGB_TIPO1 := "V"
					RGB->RGB_HORAS := nMeses
					RGB->RGB_VALOR := nAcumula
					RGB->RGB_CC := SRA->RA_CC
					RGB->RGB_TIPO2 := "G"
					RGB->RGB_SEQ := cValtoChar(nCont)
					RGB->RGB_CODFUNC := SRA->RA_CODFUNC
					RGB->RGB_DEPTO := SRA->RA_DEPTO
					MsUnLock()
				Else
					RecLock("RGB",.T.)
					RGB->RGB_FILIAL := SRA->RA_FILIAL
					RGB->RGB_PROCES := SRA->RA_PROCES
					RGB->RGB_PERIOD := cPeriod
					RGB->RGB_SEMANA := "01"
					RGB->RGB_ROTEIR := "FOL"
					RGB->RGB_MAT := SRA->RA_MAT
					RGB->RGB_PD := cVerbaR
					RGB->RGB_TIPO1 := "V"
					RGB->RGB_HORAS := nMeses
					RGB->RGB_VALOR := nAcumula
					RGB->RGB_CC := SRA->RA_CC
					RGB->RGB_TIPO2 := "G"
					RGB->RGB_SEQ := cValtoChar(nCont)
					RGB->RGB_CODFUNC := SRA->RA_CODFUNC
					RGB->RGB_DEPTO := SRA->RA_DEPTO
					MsUnLock()
				EndIf
				If cVerba == cVerbaM .or. cVerba == cVerbaE
					If RHS->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cPeriod))
						RecLock("RHS",.F.)
						RHS->RHS_FILIAL := SRA->RA_FILIAL
						RHS->RHS_MAT:= SRA->RA_MAT
						RHS->RHS_DATA:= dDataBase
						RHS_ORIGEM:= "1"
						RHS->RHS_TPLAN:= "1"
						RHS->RHS_TPFORN := "1"
						RHS->RHS_CODFOR := cCodForn
						RHS->RHS_TPPLAN:= "1"
						RHS->RHS_PLANO:= cTpPlan
						RHS->RHS_PD:= cVerbaR
						RHS->RHS_VLRFUN:= nAcumula
						RHS->RHS_VLREMP:= nEmpr
						RHS->RHS_COMPPG:= cPeriod
						RHS->RHS_DATPGT:= dDataBase
						RHS->RHS_TIPO := "1"
						MsUnLock()
					Else
						RecLock("RHS",.T.)
						RHS->RHS_FILIAL := SRA->RA_FILIAL
						RHS->RHS_MAT:= SRA->RA_MAT
						RHS->RHS_DATA:= dDataBase
						RHS_ORIGEM:= "1"
						RHS->RHS_TPLAN:= "1"
						RHS->RHS_TPFORN := "1"
						RHS->RHS_CODFOR := cCodForn
						RHS->RHS_TPPLAN:= "1"
						RHS->RHS_PLANO:= cTpPlan
						RHS->RHS_PD:= cVerbaR
						RHS->RHS_VLRFUN:= nAcumula
						RHS->RHS_VLREMP:= nEmpr
						RHS->RHS_COMPPG:= cPeriod
						RHS->RHS_DATPGT:= dDataBase
						RHS->RHS_TIPO := "1"
						MsUnLock()
					EndIf
				EndIf
			EndIf
			EndIf
			RCC->(dbSkip())
		End
		EndIf
		SRA->(dbskip())
	EndDo       
Return()
 
Static Function CriaPergDis()
 
	Local aRegs := {}
 
	aAdd(aRegs,{ cPerg,'01','Filial De               ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'02','Filial Ate              ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'03','Matricula De            ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
	aAdd(aRegs,{ cPerg,'04','Matricula Ate           ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
	aAdd(aRegs,{ cPerg,'05','Data De                 ?','','','mv_ch5','D',08,0,0,'G','NaoVazio   ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
	aAdd(aRegs,{ cPerg,'06','Data Ate                ?','','','mv_ch6','D',08,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 
	ValidPerg(aRegs,cPerg)
Return()

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfADIFIXO    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adiantamento Fixo                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fADIFIXO()

	Local lRet := .T.
	Local nValADI := 0
	Local cVb := ""
	Local cTab := "U052"

	cVb := FTABELA(cTab,1, 9, DDATAREF )
	
		If cTipoRot = "2"
			cQuery := " SELECT RG1_VALOR FROM " + RetSqlName ("RG1") + " A "
			cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RG1_FILIAL = '"+SRA->RA_FILIAL+"' AND RG1_MAT = '"+SRA->RA_MAT+"' AND RG1_PD ='"+cVb+"' AND RG1_ROT = 'FOL'"
			Iif( Select("TRG") > 0,TRG->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG",.F.,.T.)	
			nValADI := TRG->(RG1_VALOR) * (SRA->RA_PERCADT / 100)
		EndIf
	
	If nValADI > 0
		fDelPD(aCodFol[006,1],,)
		fGeraVerba(aCodFol[006,1],nValADI,,,,"V","C",,,,lRet,)
	EndIf
Return

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMEDPROP    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Media de Ferias Proporcional na Rescisao                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fMEDPROP()
	
	Local lRet := .T.
	Local nAvosFer := nAvosInt := nAvosVal := nValFer := nAvos13 := nVal13 := nInd := 0

	nAvosFer := fBuscaPd(aCodFol[249,1],"H",cSemana)
	nAvos13 := fBuscaPd(aCodFol[251,1],"H",cSemana)
	nInd := fBuscaPd(aCodFol[114,1],"H",cSemana)
	
	If nAvosFer > 0
		nAvosInt := Int(nAvosFer)
		nAvosVal := fBuscaPd(aCodFol[249,1],"V",cSemana)
		nValFer := (nAvosVal / 12) * nAvosInt
		fDelPD(aCodFol[249,1],,)
		fGeraVerba(aCodFol[249,1],nValFer,nAvosFer,,,"V","C",,,,lRet,)
	EndIf
	
	If nAvos13 > 0
		//nAvosInt := Int(nAvos13)
		nAvosInt := Int(nInd)
		nAvosVal := fBuscaPd(aCodFol[253,1],"V",cSemana)
		nVal13 := (nAvosVal / 12) * nAvosInt
		fDelPD(aCodFol[253,1],,)
		//fGeraVerba(aCodFol[251,1],nVal13,nAvos13,,,"V","C",,,,lRet,)
		fGeraVerba(aCodFol[253,1],nVal13,nInd,,,"V","C",,,,lRet,)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMEDPROP    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avos de 13 Salario na Rescisao                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fMEDP13()
	
	Local lRet := .T.
	Local nAvos13 := nVal13 := nAvos := nInd := 0

	//nAvosFer := fBuscaPd(aCodFol[249,1],"H",cSemana)
	nAvos13 := fBuscaPd(aCodFol[251,1],"H",cSemana)
	nInd := fBuscaPd(aCodFol[114,1],"H",cSemana)
/*	
	If nAvosFer > 0
		nAvosInt := Int(nAvosFer)
		nAvosVal := fBuscaPd(aCodFol[249,1],"V",cSemana)
		nValFer := (nAvosVal / 12) * nAvosInt
		fDelPD(aCodFol[249,1],,)
		fGeraVerba(aCodFol[249,1],nValFer,nAvosFer,,,"V","C",,,,lRet,)
	EndIf
*/	
	If nAvos13 > 0
		//nAvosInt := Int(nAvos13)
		nAvosInt := Int(nInd)
		nAvosVal := fBuscaPd(aCodFol[251,1],"V",cSemana)
		nAvos := fBuscaPd(aCodFol[048,1],"H",cSemana)
		nAvos := int(nAvos)
//		If nAvos > nAvosInt
//			nAvosInt := nAvosInt + 1
//			nAvos13 := nAvos13 + 1
//		EndIf
		nVal13 := (nAvosVal / 12) * nAvosInt
		fDelPD(aCodFol[251,1],,)
		fGeraVerba(aCodFol[251,1],nVal13,nAvos13,,,"V","C",,,,lRet,)
	EndIf
Return

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDELODONT   บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apaga Assistencia Odontologica na Rescisao                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDELODONT()

	Local lRet := .T.
	Local cVbTit := cVbDep := cCodPlan := ""

	If cTipoRot == "4"
		DbSelectArea("RHK")
		RHK->(dbSetOrder( 1 ))
		RHK->(dbSeek( SRA->(RA_FILIAL + RA_MAT + "2") ))
		
		cVbTit := RHK->RHK_PD
		cVbEmp := RHK->RHK_PDDAGR
	
		If !Empty(fBuscaPd(cVbTit,"V",cSemana) * -1)
			fDelPD(cVbTit,,)
		EndIf
	
		If !Empty(fBuscaPd(cVbEmp,"V",cSemana) * -1)
			fDelPD(cVbEmp,,)
		Endif
		
		cQuery := " DELETE FROM " + RetSqlName ("RHR")
		cQuery += " WHERE RHR_FILIAL = '" +SRA->RA_FILIAL+ "' AND RHR_MAT = '" +SRA->RA_MAT+ "' AND RHR_COMPPG = '" +cAnoMes+"' AND RHR_TPFORN = 2"
		TCSQLExec(cQuery)
		cQuery := "COMMIT"
		TCSQLExec(cQuery)
		DbCloseArea()
	EndIf
Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfNCALEST     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Periodo de Calculo para Estagiarios                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fNCALEST()
	
	If SRA->RA_CATFUNC $ "E/G" 	.and. AnoMes(SRA->RA_ADMISSA) == cAnoMes .and. Day(SRA->RA_ADMISSA) >= M_DTESTAG
		Calcule := "N"
		NoPrcReg()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDescPen     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desconto Pensao Adiantamento na Folha                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDescPen()

	Local lRet := .T.
	Local cVbPensAdt := cTab := ""
	Local nVlrPenAdt := nValADI := 0
	
	cTab := "U011"
		
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVbPensAdt := fTabela(cTab,nLinha,12)
	EndIf
	
	nVlrPenAdt := FBUSCAACM(cVbPensAdt , ,dDataRef, dDataRef + P_QtDiaMes - 1,"V") * -1
//	nValADI := FBUSCAACM(aCodFol[006,1] , ,dDataRef, dDataRef + (P_QtDiaMes - 1),"V")
	
		nAdi := fBuscaPd(aCodFol[007,1],"V",cSemana) * -1
				
		If nVlrPenAdt > 0
			fDelPD(aCodFol[007,1],,)
			FGERAVERBA(aCodFol[007,1],(nAdi - nVlrPenAdt),,,,"V","C",,,,lRet,)
		EndIf
		If nVlrPenAdt > 0
			FGERAVERBA(cVbPensAdt,nVlrPenAdtlg,,,,"V","C",,,,lRet,)
		EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfABATAVOS    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abate Avos de Afastamento                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAbatAvos()

Local AAVAFAST := {}
Local nMeses := nCont := 0
Local cTpRais := ""

	FRETAFAS(CTOD("01/01/" + SUBSTR(DTOS(MV_PAR06),1,4)), MV_PAR06, , , , , @AAVAFAST)

	NX := 1
	While ( NX <= LEN(AAVAFAST) )
		DINIDATA := AAVAFAST[NX,03]
		DFIMDATA := AAVAFAST[NX,04]
		cTpRais := AAVAFAST[NX,06]
		If cTpRais = "70"
		
		If DINIDATA < CTOD("01/01/" + SUBSTR(DTOS(MV_PAR06),1,4))
			DINIDATA := CTOD("01/01/" + SUBSTR(DTOS(MV_PAR06),1,4))
		EndIf
		If Empty(DFIMDATA)
			DFIMDATA := MV_PAR06
		EndIf
			nMeses := DateDiffMonth(DINIDATA , DFIMDATA) + 1
		EndIf
		nCont	:= nCont + nMeses
		NX += 1
		nCont += 1
	EndDo

	nAvos := nAvos - nCont
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRescDSR     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Soma DSR em Rescisao Durante a Semana                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fRescDSR

Local lRet := .T.
Local := nAvos13 := nAvosInt := nMed13 := nDSaldo := nSaldo := nVlr := 0

	If M->RG_DSRTURN = "1"
		If DiasTrab <= 13
			nAvos13 := fBuscaPd(aCodFol[114,1],"H",cSemana)
			nAvosInt := int(nAvos13)
			nVal13 := fBuscaPd(aCodFol[114,1],"V",cSemana)
			nMed13 := (nVal13 / nAvosInt) * (nAvosInt + 1)
			//nMed13 := (SALMES / 12) * (nAvos13 + 1)
			fDelPD(aCodFol[114,1],,)
			FGERAVERBA(aCodFol[114,1],nMed13,(nAvos13 + 1),,,"V","C",,,,lRet,)
		EndIf
		DiasTrab := DiasTrab + 2
		nDSaldo := fBuscaPd(aCodFol[048,1],"H",cSemana)
		nSaldo := fBuscaPd(aCodFol[048,1],"V",cSemana)
		nVlr := (nSaldo / nDSaldo) * (nDSaldo + 2)
		fDelPD(aCodFol[048,1],,)
		FGERAVERBA(aCodFol[048,1],nVlr,(nDSaldo + 2),,,"V","C",,,,lRet,)
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesc1P      บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desconta Primeira Parcela 13 Salario na Rescisao           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDesc1P

Local lRet := .T.
Local := nVlr1P := nDias1P := nValCalc := 0

	If cTipoRot = "4"
		nVlr1P := FBUSCAACM(aCodFol[678,1] , ,dDataDem, "01/01/"+Year2Str(dDataDem),"V")
		nDias1P := FBUSCAACM(aCodFol[678,1] , ,dDataDem, "01/01/"+Year2Str(dDataDem),"H")
		nValCalc := fBuscaPd(aCodFol[116,1],"V",cSemana)
		If nVlr1P > 0 .and. nValCalc = 0
			FGERAVERBA(aCodFol[116,1],nDias1P,,,"V","C",,,,lRet,)
		EndIf
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGRATMAT     บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gratificacao com Auxilio Maternidade                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGRATMAT

Local lRet := .T.
Local := nValGrat := nDiasGrat := nValMat := nDiasMat := nGratProp := 0

	If fBuscaPd(aCodFol[040,1],"V",cSemana) > 0 .and. fBuscaPd(ftabela("U050",01,06),"V",cSemana) > 0
		nValGrat := fBuscaPd(ftabela("U050",01,06),"V",cSemana)
		nDiasGrat := fBuscaPd(ftabela("U050",01,06),"H",cSemana)
		nValMat := fBuscaPd(aCodFol[040,1],"V",cSemana)
		nDiasMat := fBuscaPd(aCodFol[040,1],"H",cSemana)
		nGratProp := nValGrat / nDiasGrat
		nValMat := nValMat + (nGratProp * nDiasMat)
		nValGrat := nGratProp * (nDiasGrat - nDiasMat)
		fDelPD(aCodFol[040,1],,)
		fDelPD(ftabela("U050",01,06),,)
		FGERAVERBA(aCodFol[040,1],nValMat,nDiasMat,,,"V","C",,,,lRet,)
		FGERAVERBA(ftabela("U050",01,06),nValGrat,(nDiasGrat - nDiasMat),,,"V","C",,,,lRet,)
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBASEINSS    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Base INSS Conselheiros e Cedidos                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fBASEINSS

	Local lRet := .T.

	If fBuscaPd(aCodFol[218,1],"V",cSemana) > 0
		FGERAVERBA(aCodFol[225,1],fBuscaPd(aCodFol[218,1],"V",cSemana),,,,"V","C",,,,lRet,)
	EndIf

	If SRA->RA_XCEDIDO == "1" .and. fBuscaPd(aCodFol[017,1],"V",cSemana) > 0
		FGERAVERBA(ftabela("U050",12,06),fBuscaPd(aCodFol[017,1],"V",cSemana),,,,"V","C",,,,lRet,)
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBusca131    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca 1a. Parcela de 13o. Salario Antecipada               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fBusca131

	Local lRet := .T.
	Local nVlr13 := 0
	
		nVlr13 := FBUSCAACM(aCodFol[022,1] , ,"01/01/"+Year2Str(dDataRef), dDataRef,"V")
		
		If nVlr13 > 0
			fDelPD(aCodFol[022,1],,)
		EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGeraSal    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Verba de Base com Salario do Cadastro                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGeraSal

	Local lRet := .T.
		FGERAVERBA("987",SRA->RA_SALARIO,30,,,"V","C",,,,lRet,)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTabSalIni    บAutor  ณ                  บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao executada por gatilho no RA_TABFAIX para atualizar   ฑฑ
ฑฑบ          ณ o campo RA_SALARIO conforme a tabela/nivel/faixa           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TabSalIni(cTabela,dData,lTabIni,cNivel,cFaixa)
	Local aArea     := GetArea()
	Local nValor := 0
	
	Default lTabIni := .T.
	Default cNivel  := ""
	Default cFaixa  := ""
	
	If empty(cTabela) .or. empty(cNivel) .or. empty(cFaixa)
		return(0)
	EndIf
	
	If Empty(dData)
		dData := dDataBase
	EndIf
	
	cQryTmp := " SELECT * FROM " + RETSQLNAME("RBR")
	cQryTmp += " WHERE RBR_TABELA = '"+cTabela+"' "
	cQryTmp += " AND RBR_DTREF <= '"+ dtos(dData)+"' "
	cQryTmp += " AND RBR_APLIC = '1' "
	cQryTmp += " AND D_E_L_E_T_ = ' ' "	
	cQryTmp += " ORDER BY RBR_DTREF DESC "

	//EXECUTA A SELECAO DE DADOS 		
	cQryTmp := ChangeQuery(cQryTmp)
	If Select("XRBR") > 0
		XRBR->(DbCloseArea())
	EndIf
	dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQryTmp), 'XRBR', .F., .T. )
	If !XRBR->(Eof())
		
		cTab    := XRBR->RBR_TABELA
		dDtRef  := XRBR->RBR_DTREF
		
		//VERIFICA O VALOR DA FAIXA
		cQryTmp := " SELECT * FROM " + RETSQLNAME("RB6")
		cQryTmp += " WHERE RB6_TABELA = '"+cTab+"' AND RB6_DTREF = '"+dDtRef+"' "
		//CASO SEJA PASSADO COMO PARAMETRO O NIVEL E FAIXA, DEVE FILTRAR
		If !Empty(cNivel) .AND. !Empty(cFaixa)
			cQryTmp += " AND RB6_NIVEL = '"+cNivel+"' AND RB6_FAIXA = '"+cFaixa+"' "
		EndIf
		cQryTmp += " AND D_E_L_E_T_ = ' ' ORDER BY RB6_NIVEL , RB6_FAIXA "
	
		//EXECUTA A SELECAO DE DADOS 		
		cQryTmp := ChangeQuery(cQryTmp)
		If Select("XRB6") > 0
			XRB6->(DbCloseArea())
		EndIf
		dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQryTmp), 'XRB6', .F., .T. )
		nValor := XRB6->RB6_VALOR
		XRB6->(DbCloseArea())
	EndIf	
	XRBR->(DbCloseArea())

	RestArea( aArea )
Return nValor 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfADNOTAFA    บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar o pagamento de Adicional Noturno       ฑฑ
ฑฑบ          ณ para afastados                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fADNOTAFA()

	Local LCALCULAR := .F.
	Local lRet := .T.
	Local A12AFAST := {}
	Local NX := nDias := nLinha := nHrsADNot := 0
	Local cVbADNOT := cTpRais := cVbAfast := cTab := CPRORROG := CTP2AFAST := ""
	Local DINIDATA := DFIMDATA := CTOD("//")
	
	cTab   := "U014"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVbADNOT := fTabela(cTab,nLinha,5)
	EndIf

	nHrsADNot := fBuscaPd(cVbADNOT,"H",cSemana)

	If nHrsADNot > 0

		FRETAFAS(DDATADE, DDATAATE, , , , , @A12AFAST)
		If !EMPTY(A12AFAST)
			LCALCULAR := .T.
		
		IF (LCALCULAR)
			NX := 1
			While ( NX <= LEN(A12AFAST) )
			DINIDATA := A12AFAST[NX,03]
			DFIMDATA := A12AFAST[NX,04]
			CTP2AFAST := A12AFAST[NX,13]
			CPRORROG:= POSICIONE("SR8",6,XFILIAL("SR8")+SRA->RA_MAT+DTOS(DINIDATA)+CTP2AFAST,"R8_XPGAUX")
				cTpRais := A12AFAST[NX,06]
				If cTpRais $ "10/20/30/40"
					cVbAfast := A12AFAST[NX,12]
					//nDias := nDias + A12AFAST[NX,2]
					nDias := nDias + SR8->R8_XDADNOT
				EndIf
				NX += 1
			EndDo
			aPD[ASCAN( aPD,{|X| ALLTRIM(X[1]) = cVbADNOT } ),4] := (nHrsADNot+(nDias*8))
		EndIf
	EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfINSSPR      บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar a tributacao do INSS do Pro Rata na    ฑฑ
ฑฑบ          ณ Folha de Pagamento                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fINSSPR()

	Local lRet := .T.
	Local nVlrP2 := nLinha := 0
	Local cVerbaP2, cVerbaPB := cVerbaPD := ""
	
	cTab   := "U015"

	If SRA->RA_XPRORAT == "1" .and. !(SRA->RA_SITFOLH $ "D/T")
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVerbaP2 := fTabela(cTab,nLinha,10)
			cVerbaPB := fTabela(cTab,nLinha,11)
			cVerbaPD := fTabela(cTab,nLinha,12)
			nVlrP2 := FBUSCAACM(cVerbaP2 , ,"01/01/"+Year2Str(dDataRef), dDataRef,"V")
		EndIf
	EndIf
			
	If nVlrP2 > 0
		fDelPD(cVerbaPB,,)
		fDelPD(cVerbaPD,,)
		FGERAVERBA(cVerbaPB,nVlrP2,,,,"V","C",,,,lRet,)
		FGERAVERBA(cVerbaPD,nVlrP2,,,,"V","C",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fZeraReaj บ Autor ณ Ronaldo Oliveira  บ  Data ณ 01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Zera reajuste cadastrado na tabela de funcionarios         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fZeraReaj()

	Private cPerg := "XREAJ"

	CriaPergR()
	Pergunte(cPerg,.T.)

	DbSelectArea("SRA")
	DbSetOrder(1)

	SRA->(DbSeek(MV_PAR01+MV_PAR03,.T.))
	
	Do While !(SRA->(Eof())) .and. SRA->(RA_FILIAL + RA_MAT) >= MV_PAR01 + MV_PAR03 .and. SRA->(RA_FILIAL + RA_MAT) <= MV_PAR02 + MV_PAR04 .and. SRA-> RA_SITFOLH # "D/T"
		If SRA->RA_XPERC > 0
			RecLock("SRA",.F.)
			SRA->RA_XPERC  := 0
			SRA->(MsUnLock())
		Endif
		SRA->(dbSkip())
	EndDo
	Alert("Execu็ใo Efetuada com Sucesso")
Return()

Static Function CriaPergR()

	Local aRegs := {}

	aAdd(aRegs,{ cPerg,'01','Filial De               ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'02','Filial Ate              ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
	aAdd(aRegs,{ cPerg,'03','Matricula De            ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
	aAdd(aRegs,{ cPerg,'04','Matricula Ate           ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })

	ValidPerg(aRegs,cPerg)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDIF13       บAutor  ณ Ronaldo Oliveira บ Data ณ 01/08/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar o calculo da diferenca de 13o. salario ฑฑ
ฑฑบ          ณ para a gratifica็ใo                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDIF13()

	Local lRet := .T.
	Local nVlrP2 := nLinha := 0
	Local cVerbaP2, cVerbaPB := ""
	
	cTab   := "U015"

	If SRA->RA_XPRORAT == "1" .and. !(SRA->RA_SITFOLH $ "D/T")
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVerbaP2 := fTabela(cTab,nLinha,10)
			cVerbaPB := fTabela(cTab,nLinha,11)
			nVlrP2 := FBUSCAACM(cVerbaP2 , ,"01/01/"+Year2Str(dDataRef), dDataRef,"V")
		EndIf
	EndIf
			
	If nVlrP2 > 0
		fDelPD(cVerbaPB,,)
		FGERAVERBA(cVerbaPB,nVlrP2,,,,"V","C",,,,lRet,)
	EndIf
Return


User Function fGratProp()

Local nDiasGrat := nDiasFer := nDiasNovo := nValGrat := nValNovo := 0
Local lRet := .T.

nDiasGrat := fBuscaPd("033","H",cSemana)
nDiasFer := fBuscaPd("036","H",cSemana)

If nDiasGrat = 30 .and. nDiasFer > 0
	nValGrat := fBuscaPd("033","V",cSemana) / 30
	nDiasNovo := nDiasGrat - nDiasFer
	nValNovo := nValGrat * nDiasNovo
	fDelPD("033",,)
	FGERAVERBA("033",nValNovo,nDiasNovo,,,"V","C",,,,lRet,)
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fANURES  บ Autor ณ  Ronaldo Oliveira  บ Data ณ  01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Proporcionalizacao de Anuenio na Rescisao                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAnuRes()

	Local lRet := .T.
	Local nValAnuen := nDiasRes := nAvos := nValProp := nVal13 := nAvosInd := 0

	nValAnuen := fBuscaPd(aCodFol[001,1],"V",cSemana)
	
	If nValAnuen > 0
		nDiasRes := fBuscaPd(aCodFol[048,1],"H",cSemana)
		nAvos := Int(fBuscaPd(aCodFol[114,1],"H",cSemana))
		nAvosInd := Int(fBuscaPd(aCodFol[115,1],"H",cSemana))
		nValProp := (nValAnuen / 30) * nDiasRes
		nVal13 := (nValAnuen / 12) * (nAvos + nAvosInd)
	EndIf

	If nValProp > 0
		fDelPD(aCodFol[001,1],,)
		fGeraVerba(aCodFol[001,1],nValProp,nDiasRes,,,"V","C",,,,lRet,)
	EndIf
	
	If nVal13 > 0
		fDelPD(aCodFol[1288,1],,)
		fGeraVerba(aCodFol[1288,1],nVal13,(nAvos + nAvosInd),,,"V","C",,,,lRet,)
	EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDTRECIB บ Autor ณ  Ronaldo Oliveira  บ Data ณ  01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera o conteudo do parametro MV_TCFDFOL                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDTRECIB()

Private cPerg := 'PERG001'

VldPerg01()

Pergunte(cPerg,.F.)
MV_PAR01 := GetMV("MV_TCFDFOL")

If !Pergunte(cPerg,.t.)
Return .f.
Endif

PutMV("MV_TCFDFOL",MV_PAR01)

Static Function VldPerg01()

	PutSX1(cPerg, "01", "Qtd dias somados ao ultimo dia do mes?","","","mv_ch1","C",3,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","",,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTETO    บ Autor ณ  Ronaldo Oliveira  บ Data ณ  01/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Teto Constitucional                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ V12 บPRODAM                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fTETO()

	Local lRet := .T.
	Local nLinha := nTeto := nGrat := nTot := 0
	Local cVerba := cTab := ""

	cTab := "U031"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nTeto := fTabela(cTab,nLinha,5)
		cVerba := fTabela(cTab,nLinha,6)
	EndIf
	
	nTot:= SALMES + ((fBuscaPd("033","V",cSemana)/fBuscaPd("033","H",cSemana))*30) + fBuscaPd("038","V",cSemana)
//	aEval(aPD,{|X| SomaInc(X,1,@nTot,00 ,"1" , , , , ,aCodFol})
		
	If nTot > 0
		If nTot > nTeto
			fDelPD(cVerba,,)
			fGeraVerba(cVerba,(nTot - nTeto),0,,,"V","C",,,,lRet,)
		EndIf
	EndIf	
Return


User Function FXSALDISS()
If LDISSIDIO
			cQuery := " SELECT RG1_VALOR FROM " + RetSqlName ("RG1") + " A "
			cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND RG1_FILIAL = '"+SRA->RA_FILIAL+"' AND RG1_MAT = '"+SRA->RA_MAT+"' AND RG1_PD ='132' AND RG1_ROT = 'FOL'"
			Iif( Select("TRG") > 0,TRG->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG",.F.,.T.)
//			SALMES := SALMES + TRG->(RG1_VALOR)	
			SALHORA := SALMES / SRA->RA_HRSMES
			SALDIA := SALMES / 30
//	SALMES := SALARIO := SALMES 
//	SALDIA := NSALD1 := NSALD2 := (SRA->RA_SALARIO / 30)
EndIf
Return