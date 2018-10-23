// Ponto de Entrada para alterar informações do cabeçalho
User Function pgchHeader()
LOCAL cRequest   := UPPER(PARAMIXB[1])
LOCAL cParam2    := PARAMIXB[2]
LOCAL cParam3    := PARAMIXB[3]
LOCAL aHeader    := PARAMIXB[4]
LOCAL aOthers    := if(len(PARAMIXB)>=5,PARAMIXB[5],{})
LOCAL aHeaderNew := {}
Local nX, cFil, cMat, cDepto

If len(aOthers)==0
	For nX := 1 to 36
		If nX <= 32 
			aadd(aOthers,"")
		Else
			aadd(aOthers,ctod("//"))
		EndIf
	Next nX
EndIf
/*
Tipos do cRequest:
	4				Solicitação de Transferência
	6				Solicitação de Desligamento
	7				Solicitação de Ação Salarial
	8				Solicitação de Justificativa Pré-abono
	A				Solicitação de Treinamento
	B				Solicitação de Férias
	C				Consulta Mapa de Treinamento
	E				Consulta Banco de Horas
	F				Consulta Listagem de Marcações
	G				Consulta Tabela de Horário
	I				Gap de Fatores
	J				Gap de Habilidades
	K				Consulta Dependentes
	L				Consulta Afastamentos
	V				Solicitação de Subsídio Acadêmico
	X				Consulta Histórico Salarial
	Z				Solicitação de Marcação de Ponto
	FERPROG			Consulta Férias Programadas
	AUTO-AVAL		Manutenção da Auto-avaliação
	IMP-AUTO-AVAL	Impressão da Auto-avaliação
	AVAL			Manutenção da Avaliação
	IMP-AVAL		Impressão da Avaliação
	CONSENSO		Manutenção do Consenso
	IMP-CONSENSO	Impressão do Consenso
	RADAR			Radar de Competências
	CONS-CAD		Consulta Dados Cadastrais

Composicao do aOthers:
	[01] = cAUTOEVALUATED
	[02] = cCOACHNAME
	[03] = cCOMPETENCE
	[04] = cCOMPETENCEDESCRIPTION
	[05] = cCOSTCENTERDESCRIPTION
	[06] = cDESCRIPTION
	[07] = cEVALUATEDID
	[08] = cEVALUATEDNAME
	[09] = cEVALUATEID
	[10] = cEVALUATESTATUS
	[11] = cEVALUATESTATUSDESCRIPTION
	[12] = cEVALUATETYPE
	[13] = cEVALUATORID
	[14] = cEVALUATORNAME
	[15] = cFUNCTIONDESCRIPTION
	[16] = cHIERARQLEVEL
	[17] = cLEVEL
	[18] = cMODEL
	[19] = cMODELDESCRIPTION
	[20] = cNET
	[21] = cNETDESCRIPTION
	[22] = cOTHEREVALUATORNAME
	[23] = cPARTLEADER
	[24] = cPARTLEADERID
	[25] = cPROJECT
	[26] = cPROJECTDESCRIPTION
	[27] = cSELFEVALUATE
	[28] = cSELFEVALUATEDESCRIPTION
	[29] = cTYPEDESCRIPTION
	[30] = cTYPEEV
	[31] = cVISION
	[32] = cVISIONDESCRIPTION
	[33] = dANSWERFINALDATE
	[34] = dANSWERINITIALDATE
	[35] = dFINALDATE
	[36] = dINITIALDATE
*/

For nX := 1 to len(aHeader)
	If "MENTOR" $ UPPER(aHeader[nX,1])
		//Retira Mentor e coloca o tipo da avaliacao
		aHeader[nX,1] := "TIPO DA AVALIAÇÃO"
		If ("*"+cRequest+"*") $ "*AUTO-AVAL*|*IMP-AUTO-AVAL*"
			aHeader[nX,2] := "Auto-Avaliação"
		ElseIf ("*"+cRequest+"*") $ "*CONSENSO*|*IMP-CONSENSO*" .or. aOthers[27,2] == '3'
			aHeader[nX,2] := "Consenso"
		ElseIf aOthers[27,2] <> '2' .and. aOthers[17,2] == '1'  //27=cSELFEVALUATE  17=cLEVEL
			aHeader[nX,2] := "Avaliação PAR"
		Else
			aHeader[nX,2] := "Avaliação "
		EndIf
	EndIf
Next nX 


For nX := 1 to len(aHeader)

	//Troca Funcao por Especializacao
	If "Fun&ccedil;&atilde;o" $ aHeader[nX,1]
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "Fun&ccedil;&atilde;o" , "Especialização" ) 
	ElseIf "FUN&Ccedil;&Atilde;O" $ aHeader[nX,1]
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "FUN&Ccedil;&Atilde;O" , "ESPECIALIZAÇÃO" ) 
	ElseIf alltrim(aHeader[nX,1]) == "Funcao"
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "Funcao" , "Especializacao" ) 
	ElseIf alltrim(aHeader[nX,1]) == "FUNCAO"
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "FUNCAO" , "ESPECIALIZACAO" ) 
	ElseIf alltrim(aHeader[nX,1]) == "Função"
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "Função" , "Especialização" ) 
	ElseIf alltrim(aHeader[nX,1]) == "FUNÇÃO"
		aHeader[nX,1] := StrTran( aHeader[nX,1] , "FUNÇÃO" , "ESPECIALIZAÇÃO" ) 
	ElseIf upper(alltrim(aHeader[nX,1])) == "CENTRO DE CUSTO"
		aHeader[nX,1] := "ÁREA" 
	EndIf

	//Troca Nivel de Carreira nas avaliacoes por Cargo+Especializacao
	If ("*"+cRequest+"*") $ "*AUTO-AVAL*|*AVAL*|*CONSENSO*|*IMP-AUTO-AVAL*|*IMP-AVAL*|*IMP-CONSENSO*"
		If "DE CARREIRA" $ UPPER(aHeader[nX,1])
			If cParam2 <> '@@'
				cFil := cParam2
				cMat := cParam3
			Else
				//Busca a Filial e Matricula na RDZ quando recebe codigo RD0
				U_fBuscMat(cParam3,@cFil,@cMat,@cDepto)
			EndIf
			If SRA->(dbseek(cFil+cMat))
				cFuncao := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
				cCargo  := Posicione("SQ3",1,xFilial("SQ3")+SRA->RA_CARGO,"Q3_DESCSUM")
				aHeader[nX,1] := "CARGO / ESPECIALIZAÇÃO"
				aHeader[nX,2] := Alltrim(cCargo) + " / " + Alltrim(cFuncao)
			EndIf
		EndIf

		//Ajusta o Nome do Avaliador
		If "NOME DO AVALIADOR" $ UPPER(aHeader[nX,1])
			If ("*"+cRequest+"*") $ "*AUTO-AVAL*|*IMP-AUTO-AVAL*|
				aHeader[nX,2] := aOthers[8,2]
			Else
				aHeader[nX,2] := aOthers[14,2]
			EndIf
		EndIf

	EndIf

	//Tratamento especial para o tipo de Consulta dos Dados Cadastrais
	If cRequest == "CONS-CAD"

       //retira campos não desejados, no exemplo, não mostrar o campo 'Aposentado' no resultado
       If Alltrim(aHeader[nX,1]) != 'Aposentado'
			If "Reg. Civil" $ Alltrim(aHeader[nX,1])
				aHeader[nX,1] := "REGISTRO CIVIL"
				aHeader[nX,2] := "* cont. reg civil *"
	       EndIf
			If "Cat. Func." $ Alltrim(aHeader[nX,1])
				aHeader[nX,1] := "CATEGORIA"
	       EndIf
			If "R.G." $ Alltrim(aHeader[nX,1])
				aHeader[nX,1] := "IDENTIDADE"
	       EndIf

          //cria registro no novo header
		  	aAdd( aHeaderNew, { aHeader[nX,1] , aHeader[nX,2] } )

			//Inclui novo campo no grupo "03-Dados Funcionais" após o campo "NOME"
			If "Nome" $ Alltrim(aHeader[nX,1])
			  	aAdd( aHeaderNew, { 'Filiação' , 'Nome do Pai e Nome da Mãe' } )
			EndIf
		EndIf

    EndIf

Next nX

//Atualiza o aHeader para o retorno com a nova estrutura criada
If cRequest == "CONS-CAD"
   aHeader := aClone(aHeaderNew)
EndIf

//Retira "Lider Hierárquico" e na Auto-Avalicao retira o avaliador
aHeaderNew := {}
For nX := 1 to len(aHeader)
	If !("HIER" $ upper(aHeader[nX,1])) .and. !("NOME DO AVALIADOR" $ UPPER(aHeader[nX,1]) .and. "AUTO-AVAL" $ Upper(cRequest))
	  	aAdd( aHeaderNew, { aHeader[nX,1] , aHeader[nX,2] } )
	EndIf
Next nX
aHeader := aClone(aHeaderNew)


/*
//Se processando algum tipo de avaliacao
If ("*"+cRequest+"*") $ "*IMP-AUTO-AVAL*|*IMP-AVAL*|*IMP-CONSENSO*"

	//Adiciona uma linha em branco e linhas para assinatura
  	aAdd( aHeader, { '' , '' } )
  	aAdd( aHeader, { 'Assinatura do Avaliado:' , '___________________________________________________' } )
  	aAdd( aHeader, { '' , '' } )
  	aAdd( aHeader, { 'Assinatura do Avaliador:' , '___________________________________________________' } )
  	aAdd( aHeader, { '' , '' } )
  	aAdd( aHeader, { 'Assinatura do Gestor:' , '___________________________________________________' } )

EndIf
*/

Return(aHeader)



/*/{Protheus.doc} fBuscaMat

@type function
@author 
@since 07/04/2016
@version 1.0
@description Busca Filial e Matricula de registro ativo no SRA a partir do codigo da RD0

/*/
User Function fBuscMat(cCodAdo,cFil,cMat,cDepto)

Local aArea:= GetArea()
Local lAchou := .f.

SRA->(dbsetorder(1))
RDZ->(dbsetorder(2))

If RDZ->(dbseek(xFilial("RDZ")+cCodAdo+cEmpAnt))
	While RDZ->(!eof()) .and. RDZ->RDZ_CODRD0 == cCodAdo .and. RDZ->RDZ_EMPENT == cEmpAnt
		If SRA->(dbseek(RDZ->RDZ_CODENT)) .and. empty(SRA->RA_DEMISSA)
			cFil 	:= SRA->RA_FILIAL
			cMat 	:= SRA->RA_MAT
			cDepto 	:= SRA->RA_DEPTO
			lAchou 	:= .t.
			Exit
		EndIf
		RDZ->(dbskip())
	EndDo
EndIf

RestArea(aArea)

Return(lAchou)
