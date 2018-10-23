#Include 'Protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RS150GV  � Autor � Marcos Pereira     � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado na atualizacao da SQG na agenda ���
���          � do candidato                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Alert("N�o foi atualizado o curr�culo. Essa forma o Status n�o refletir� a realidade do candidato no concurso. Execute novamente e confirme a atualiza��o.")
	EndIf

EndIf

Return

