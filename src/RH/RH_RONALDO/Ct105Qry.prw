#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT105QRY  �Autor  �Andreza Favero      � Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na funcao de contabilizacao do RH para     ���
���          �a Contabilidade, para adicionar campos na query             ���
���          �campos na query.                                            ���
���          �                                                            ���
���          �So funcionara se no lancamento padrao no campo origem       ���
���          �selecionar SRZ->RZ_PD                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Ct105Qry()

Local aArea		:= GetArea()                              
Local cQry		:= PARAMIXB[1]                            
Local lAglLcto	:= PARAMIXB[2]

If lAglLcto
	cQry:= StrTran(cQry,"CTK_TPSALD","CTK_TPSALD,CTK_ORIGEM")
EndIf		

RestArea(aArea)      

Return(cQry)