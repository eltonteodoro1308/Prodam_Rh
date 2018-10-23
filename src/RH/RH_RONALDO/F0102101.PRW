#INCLUDE "TOPCONN.ch"
#INCLUDE "Protheus.ch"

/*/ {Protheus.doc} F0102101()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       30/09/2015
@version     P12.5
@Return      Funcao para Consulta Padrao de Assistencia Medica U053
@Obs
/*/

USER Function F0102101()
Local cVar 		:= ReadVar()
Local cCons 	:= ""
Local cCpoRet 	:= ""
Local cConteud 	:= ""
Local cTpPlano	:= ""
Local cTpForn	:= ""
Local cCodFor 	:= ""
Local cCodPlano	:= ""
Local cFilter 	:= ""
Local cSvAlias	:= ""
Local cTip      :=  ""

Local nCPn := 0 // Variavel utilizada quando é aberta mais de uma getdados ao mesmo tempo
Local xRet
Local oModel
Local oStructRHK
Local oStructRHL
Local oStructRHM
Local oStructRHN
Local oStructRHO
Local oStructSJX
Local oStructSLE
Local oStructSL0
Local bFilterRCC := { || .T. }

If IsInCallStack('U_F0102102') .OR. IsInCallStack('U_F0102101')

	If FunName() = "GPER008"	//-- Relatório de Calculo do Plano de Saúde
		cCons := "S016"
		//-- "Fornecedor Odontologico De ?" e "Fornecedor Odontologico Ate ? "
		If cVar == "MV_PAR16" .Or. cVar == "MV_PAR17"
			cCons := "S017"
			//-- "Código Plano de ?" e "Código Plano até ?"
		ElseIf cVar == "MV_PAR20" .Or. cVar == "MV_PAR21"
			cCons := "FSU053"
		EndIf
		//	cCpoRet := "U53_CODPLA"
		cCpoRet := "Codigo"
	ElseIf cVar == "M->RB_CODAMED" .or. cVar == "SRB->RB_CODAMED" // DEPENDENTES ASSISTENCIA MEDICA
		IIf(cVar == "M->RB_CODAMED", cTip := GdFieldGet("RB_TIPAMED"), cTip := M->RB_TIPAMED)
		IIf(cTip == "2",	cCons := "S009", cCons := "FSU053")
		cCpoRet := "U53_CODPLA"
	ElseIf cVar == "M->RB_ASODONT" .or. cVar == "SRB->RB_ASODONT" // DEPENDENTES ASSISTENCIA ODONTOLOGICA
		IIf(cVar == "M->RB_ASODONT", cTip := GdFieldGet("RB_TPASODO"), cTip := M->RB_TPASODO)
		IIf(cTip == "2",	cCons := "S014", cCons := "S013")
		cCpoRet := "U53_CODPLA"
	ElseIf __READVAR == "M->CODFOR"  .OR.  __READVAR == "M->U53_CFOR"         //CONSULTA F3 A PARTIR DE UMA TABELA SNNN
		If cCodigo == "FSU053" .or. cCodigo == "S009"	.or. cCodigo == "S028" .or. cCodigo == "S029" .Or. cCodigo == "S059"  .Or. cCodigo == "U053"		// FORNECEDOR ASSISTENCIA MEDICA
			cCons := "S016"
			cCpoRet := "Codigo"
		ElseIf cCodigo == "S013" .or. cCodigo == "S014" .or. cCodigo == "S030" .or. cCodigo == "S031" .Or. cCodigo == "S060"		// FORNECEDOR ASSISTENCIA ODONTOLOGICA
			cCons := "S017"
			cCpoRet := "U53_CODPLA"
		EndIf
	ElseIf cVar $ "M->RHK_CODFOR*M->RHK_PLANO*M->RHL_PLANO*M->RHM_PLANO*M->RHN_CODFOR*M->RHN_PLANO*M->RHO_CODFOR*M->JX_CODFORN*M->JX_PLANO*M->L0_PLANO*M->LE_PLANO"
		oModel 		:= FWModelActive()

		If !(cVar $ "M->RHN_CODFOR*M->RHN_PLANO*M->RHO_CODFOR")
			If (cVar $ "M->JX_CODFORN*M->JX_PLANO*M->L0_PLANO*M->LE_PLANO")
				oStructSJX	:= oModel:GetModel("GPEA063_MSJX")
				cTpForn := oStructSJX:GetValue("JX_TPFORN")
			Else
				oStructRHK	:= oModel:GetModel( "M0102102_MRHK" )
				cTpForn		:= oStructRHK:GetValue("RHK_TPFORN")
			EndIf
		ElseIf cVar $ "M->RHN_CODFOR*M->RHN_PLANO"
			oStructRHN	:= oModel:GetModel( "GPEA002_MRHN" )
			cTpForn		:= oStructRHN:GetValue("RHN_TPFORN")
		ElseIf cVar $ "M->RHO_CODFOR*M->RHO_PLANO"
			oStructRHO	:= oModel:GetModel( "GPEA003_MRHO" )
			cTpForn		:= oStructRHO:GetValue("RHO_TPFORN")
		EndIf

		If cVar $ "M->RHK_CODFOR*M->RHN_CODFOR*M->RHO_CODFOR*M->JX_CODFORN"
			If cTpForn == "1"
				cCons := "S016"
				cCpoRet := "Codigo"
			Else
				cCons := "S017"
				cCpoRet := "Codigo"
			EndIf
			If cVar == "M->RHO_CODFOR"  // Filtrar somente os fornecedores vinculados ao funcionario
				If FunName() == "GPEA003"
					cSvAlias := Alias()
					DbSelectArea("RHK")
					RHK->(DbSetOrder( 1 ))
					RHK->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
					cCodFor := ""
					While !Eof() .and. RHK->RHK_FILIAL + RHK->RHK_MAT == SRA->RA_FILIAL + SRA->RA_MAT
						cCodFor += RHK->RHK_CODFOR + "*"
						RHK->(DbSkip())
					EndDo
					//Procurar Na RHN
					DbSelectArea("RHN")
					RHN->(DbSetOrder( 1 ))
					RHN->(DbSeek( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
					While !Eof() .and. RHN->RHN_FILIAL + RHN->RHN_MAT == SRA->RA_FILIAL + SRA->RA_MAT
						If (RHN->RHN_OPERAC + RHN->RHN_TPALT == "2" + "04") .AND. !(RHN->RHN_CODFOR $ cCodFor)
							cCodFor += RHN->RHN_CODFOR + "*"
						EndIf
						RHN->(DbSkip())
					EndDo
					DbSelectArea( cSvAlias )
					cFilter := "{ || Substr(RCC->RCC_CONTEU,1,3) $ '" + cCodFor + "' }"
					bFilterRCC := &cFilter

				EndIf
			EndIf

		ElseIf cVar $ "M->RHK_PLANO*M->RHL_PLANO*M->RHM_PLANO*M->RHN_PLANO*M->JX_PLANO*M->L0_PLANO*M->LE_PLANO"

			If !(cVar $ "M->RHN_PLANO")
				If(cVar $ "M->JX_PLANO*M->L0_PLANO*M->LE_PLANO")
					oStructSLE	:= oModel:GetModel( "GPEA063_MSLE" )
					oStructSL0	:= oModel:GetModel( "GPEA063_MSL0" )
					cCodPlano := oStructSJX:GetValue("JX_CODFORN")
				Else
					oStructRHL	:= oModel:GetModel( "M0102102_MRHL" )
					oStructRHM	:= oModel:GetModel( "M0102102_MRHM" )
					cCodPlano	:= oStructRHK:GetValue("RHK_CODFOR")
				EndIf
			Else
				cCodPlano	:= oStructRHN:GetValue("RHN_CODFOR")
			EndIf

			If cVar == "M->RHK_PLANO"
				cTpPlano 	:= oStructRHK:GetValue("RHK_TPPLAN")
			ElseIf cVar == "M->RHL_PLANO"
				cTpPlano 	:= oStructRHL:GetValue("RHL_TPPLAN")
			ElseIf cVar == "M->RHM_PLANO"
				cTpPlano 	:= oStructRHM:GetValue("RHM_TPPLAN")
			ElseIf cVar == "M->RHN_PLANO"
				cTpPlano 	:= oStructRHN:GetValue("RHN_TPPLAN")
			ElseIf cVar == "M->JX_PLANO"
				cTpPlano := oStructSJX:GetValue("JX_TPPLANO")
			ElseIf cVar == "M->L0_PLANO"
				cTpPlano := oStructSL0:GetValue("L0_TPPLANO")
			ElseIf cVar == "M->LE_PLANO"
				cTpPlano := oStructSLE:GetValue("LE_TPPLANO")
			EndIf

			If cTpForn == "1" .And. cTpPlano == "2"
				cCons := "S009"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,83,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "1" .And. cTpPlano == "1"
				cCons := "U053"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,123,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "1" .And. cTpPlano == "3"
				cCons := "S028"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,95,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "1" .And. cTpPlano == "4"
				cCons := "S029"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,123,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "1" .and. cTpPlano == "5"
				cCons := "S059"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,95,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			Elseif cTpForn == "2" .And. cTpPlano == "2"
				cCons := "S014"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,83,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "2" .And. cTpPlano == "1"
				cCons := "S013"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,92,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "2" .And. cTpPlano == "3"
				cCons := "S030"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,95,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "2" .And. cTpPlano == "4"
				cCons := "S031"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,110,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			ElseIf cTpForn == "2" .and. cTpPlano == "5"
				cCons := "S060"
				cFilter := "{ || Substr(RCC->RCC_CONTEU,95,3) ==  '" + cCodPlano + "' }"
				bFilterRCC := &cFilter
			EndIf
			if cTpForn = '1'
				cCpoRet := "U53_CODPLA"
			else
				cCpoRet := "CODIGO"
			endif
		EndIf
	EndIf

	// n - Variavel de posicionamento do objeto GetDados
	// O trecho abaixo controla para que não haja conflito entre 2 GetDados, caso seja
	// disparada uma consulta F3 entre 2 tabelas. Ex.: S008 faz consulta em S016
	If Type('n') =="N"
		nCpn := n
	EndIf

	xRet := Gp310SXB(cCons, cCpoRet, bFilterRCC )

	If ValType(xRet)<> "L" .or. (ValType(xRet)== "L"  .and. !xRet)
		VAR_IXB := &__READVAR
	EndIf

	If nCpn > 0
		n := nCpn
	EndIf

	If ValType(xRet) <> "L"
		xRet := .F.
	EndIf
ELSE
	xRet:=	ConPad1(,,,"S008")
ENDIF
Return( xRet )


USER Function F0102110(cCodTab)  //FornVld
Local lRet := .F.
Local nPosIni := 1
Local nLenCod
Local nOrdem
Local nX := 1

Local cVar		:= Alltrim(ReadVar())
Local cFOrigem := ""

Local oModel
Local oStructRHX
Local cTpForn
Local cCampo

If cVar == "M->RB_CODAMED" .or. cVar == "SRB->RB_CODAMED" // DEPENDENTES ASSISTENCIA MEDICA
	cFOrigem := xFilial("SRB")
ElseIf cVar == "M->RB_ASODONT" .or. cVar == "SRB->RB_ASODONT" // DEPENDENTES ASSISTENCIA ODONTOLOGICA
	cFOrigem := xFilial("SRB")
ElseIf __READVAR == "M->CODFOR"           //CONSULTA F3 A PARTIR DE UMA TABELA SNNN
	cFOrigem := aCols[n][1]

ElseIf cVar $ "M->RHK_CODFOR/M->RHL_CODFOR/M->RHM_CODFOR/M->RHN_CODFOR/M->RHO_CODFOR/M->JX_CODFORN"
	oModel 		:= FWModelActive()

	If cVar == "M->RHK_CODFOR"
		oStructRHX	:= oModel:GetModel( "M0102102_MRHK" )
		cTpForn		:= oStructRHX:GetValue("RHK_TPFORN")
	ElseIf cVar == "M->RHL_CODFOR"
		oStructRHX	:= oModel:GetModel( "M0102102_MRHL" )
		cTpForn		:= oStructRHX:GetValue("RHL_TPFORN")
	ElseIf cVar == "M->RHM_CODFOR"
		oStructRHX	:= oModel:GetModel( "M0102102_MRHM" )
		cTpForn		:= oStructRHX:GetValue("RHM_TPFORN")
	ElseIf cVar == "M->RHN_CODFOR"
		oStructRHX	:= oModel:GetModel( "GPEA002_MRHN" )
		cTpForn		:= oStructRHX:GetValue("RHN_TPFORN")
	ElseIf cVar == "M->RHO_CODFOR"
		oStructRHX	:= oModel:GetModel( "GPEA003_MRHO" )
		cTpForn		:= oStructRHX:GetValue("RHO_TPFORN")
	ElseIf cVar == "M->JX_CODFORN"
		oStructSJX	:= oModel:GetModel( "GPEA063_MSJX" )
		cTpForn := oStructSJX:GetValue("JX_TPFORN")
	EndIf

	If FunName() = "GPEA063"
		cFOrigem := xFilial("SJX")
	Else
		cFOrigem := xFilial("SRA")
	EndIf

	If cTpForn == "1"
		cCodTab := "S016"
	ElseIf cTpForn == "2"
		cCodTab := "S017"
	EndIf

	M->CODFOR := &(cVar)
EndIf

IF cCODTAB = 'U053'
	RCB->(dbSetOrder(3))
	RCB->(dbSeek(xFilial("RCB")+"U53_CODPLA"+cCodTab))
ELSE
	RCB->(dbSetOrder(3))
	RCB->(dbSeek(xFilial("RCB")+"CODIGO    "+cCodTab))
ENDIF
nLenCod := RCB->RCB_TAMAN
nOrdem := Val(RCB->RCB_ORDEM)

RCB->(dbSetOrder(1))
RCB->(dbSeek(xFilial("RCB")+cCodTab))

While nX < nOrdem .and. RCB->RCB_CODIGO == cCodTab

	If Val(RCB->RCB_ORDEM) < nOrdem
		nPosIni += RCB->RCB_TAMAN
		nX ++
	EndIf
	RCB->(DbSkip())
EndDo

RCC->(dbSetOrder(1))

If RCC->(dbSeek(xFilial("RCC")+cCodTab))
	While RCC->RCC_CODIGO == cCodTab .and. !lRet
		If M->CODFOR == SubStr(RCC->RCC_CONTEU,nPosIni,nLenCod) .and.;
			(Empty(RCC->RCC_FIL) .or. RCC->RCC_FIL == cFOrigem)
			lRet := .T.
		EndIf
		RCC->(DbSkip())
	EndDo
EndIf

Return lRet

USER Function F0102111()

Local cVar := Alltrim(ReadVar())
Local cTpForn
Local cCodFor
Local cTpPlano
Local cCodPlano

Local lRet := .T.

Local oModel
Local oStructRHK
Local oStructRHN

oModel 		:= FWModelActive()

If cVar <> "M->RHN_PLANO"
	oStructRHK	:= oModel:GetModel( "M0102102_MRHK" )
	cTpForn		:= oStructRHK:GetValue("RHK_TPFORN")
	cCodFor		:= oStructRHK:GetValue("RHK_CODFOR")
Else
	oStructRHN	:= oModel:GetModel( "GPEA002_MRHN" )
	cTpForn		:= oStructRHN:GetValue("RHN_TPFORN")
	cCodFor		:= oStructRHN:GetValue("RHN_CODFOR")
EndIf

If cVar == "M->RHK_PLANO"
	cTpPlano := oStructRHK:GetValue("RHK_TPPLAN")
	cCodPlano := oStructRHK:GetValue("RHK_PLANO")
ElseIf cVar == "M->RHL_PLANO"
	oStructRHL	:= oModel:GetModel( "M0102102_MRHL" )
	cTpPlano := oStructRHL:GetValue("RHL_TPPLAN")
	cCodPlano := oStructRHL:GetValue("RHL_PLANO")
ElseIf cVar == "M->RHM_PLANO"
	oStructRHM	:= oModel:GetModel( "M0102102_MRHM" )
	cTpPlano := oStructRHM:GetValue("RHM_TPPLAN")
	cCodPlano := oStructRHM:GetValue("RHM_PLANO")
ElseIf cVar == "M->RHN_PLANO"
	cTpPlano := oStructRHN:GetValue("RHN_TPPLAN")
	cCodPlano := oStructRHN:GetValue("RHN_PLANO")
EndIf

lRet := U_F0102112(cTpForn, cCodFor, cTpPlano, cCodPlano)

Return( lRet )


USER Function F0102112(cTpForn, cCodFor, cTpPlano, cCodPlano, lHelp)
Local cCodTab := ""

Local lRet 	  := .T.

Local nColFor := 0
Local nPosTab
Local lChange := .F.

DEFAULT lHelp	:= .T.

If Type("cEmpChg") == "U"
	cEmpChg := cEmpAnt
ElseIf ( cEmpChg != cEmpAnt )
	lChange := lChange
EndIf

If cTpForn == "1"
	If cTpPlano == "1"
		cCodTab := "U053"
		nColFor := 16
	ElseIf cTpPlano == "2"
		cCodTab := "S009"
		nColFor := 13
	ElseIf cTpPlano == "3"
		cCodTab := "S028"
		nColFor := 12
	ElseIf cTpPlano == "4"
		cCodTab := "S029"
		nColFor := 15
	ElseIf cTpPlano == "5"
		cCodTab := "S059"
		nColFor := 14
	EndIf
ElseIf cTpForn == "2"
	If cTpPlano == "1"
		nColFor := 13
		cCodTab := "S013"
	ElseIf cTpPlano == "2"
		cCodTab := "S014"
		nColFor := 13
	ElseIf cTpPlano == "3"
		cCodTab := "S030"
		nColFor := 12
	ElseIf cTpPlano == "4"
		cCodTab := "S031"
		nColFor := 15
	ElseIf cTpPlano == "5"
		cCodTab := "S060"
		nColFor := 14
	EndIf
EndIf

nPosTab := fPosTab( cCodTab,cCodFor,"=",nColFor,cCodPlano,"=",4,,,,lChange)

If nPosTab <= 0
	If lHelp
		Help(,,'HELP',,OemToAnsi('Codigo do Plano nao cadastrado!'),1,0)	//
	EndIf
	lRet := .F.
EndIf

Return( lRet )
