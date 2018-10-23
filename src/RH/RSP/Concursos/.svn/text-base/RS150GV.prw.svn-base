#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RS150GV  º Autor ³ Marcos Pereira     º Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado na atualizacao da SQG na agenda º±±
±±º          ³ do candidato                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RS150GV()

Local cChave

//Se alteracao de Curriculo vinculado a algum concurso
If !empty(SQG->QG_XCODCON) .and. SQG->QG_TPCURRI == '3' .and. !empty(SQG->QG_XCLASSI)

	//Se ultima etapa foi a convocacao ou desistencia
	If (SQG->QG_ULTETAP == 'Z0' .and. empty(SQG->QG_XDTCONV)) .or. ;
	   (SQG->QG_ULTETAP $ 'Z1/Z2' .and. empty(SQG->QG_XDTDESI)) 
		cChave := xFilial("SQD", SQG->QG_FILIAL)+SQG->(QG_ULTVAGA+QG_CURRIC)
		If SQD->(dbseek(cChave))
			While SQD->(!eof()) .and. SQD->(QD_FILIAL+QD_VAGA+QD_CURRIC)  == cChave
				If SQG->QG_ULTETAP == 'Z0' .and. SQD->QD_TPPROCE == 'Z0'
					SQG->QG_XDTCONV := SQD->QD_DATA		//Atualiza a data da convocacao
					exit
				ElseIf (SQG->QG_ULTETAP == 'Z1' .and. SQD->QD_TPPROCE == 'Z1') .or. (SQG->QG_ULTETAP == 'Z2' .and. SQD->QD_TPPROCE == 'Z2') 
					SQG->QG_XDTDESI := SQD->QD_DATA
					exit
				EndIf
				SQD->(dbskip())
			EndDo
		EndIf
	ElseIf empty(SQG->QG_ULTETAP)
		Alert("Não foi atualizado o currículo. Essa forma o Status não refletirá a realidade do candidato no concurso. Execute novamente e confirme a atualização.")
	EndIf

EndIf

Return

