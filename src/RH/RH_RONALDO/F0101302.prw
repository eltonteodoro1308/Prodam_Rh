#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"

//--------------------------------------------------------------------------
/*{Protheus.doc} F0101302
Responsavel por intermediar os dados na Camada 2 do web service
@owner      ademar.fernandes
@author     ademar.fernandes
@since      06/10/2015
@param
@return     lRet
@project    MAN00000011501_EF_013
@version    P 12.1.006
@obs        Observacoes
*/
//--------------------------------------------------------------------------
/*
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Descri��o � Web Function para Buscar os valores do VA e VR                     ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
*/
WebUser Function F0101302()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cHtml   	:= ""
Local oParam  	:= Nil
Local oObj

WEB EXTENDED INIT cHtml START "InSite"

	//HttpSession->cTypeRequest	:= "N"     //-Altera Beneficios
	//HttpGet->titulo				:= "Alteracao de Beneficios VA e VR"
	//HttpSession->aStructure		:= {}
	//HttpSession->cHierarquia	    := ""
	HttpSession->ResultF0101302 := "0"

	//-Retorna informacoes do menu
	fGetInfRotina("W_F0101302.APW")
	GetMat()                              //Pega a Matricula e a filial do participante logado
	VarInfo("aUser",HttpSession->aUser)

	oObj := WSPRODAMCHANGEVAVR():New()
	WsChgURL(@oObj,"PRODAMCHANGEVAVR.APW")

	oObj:cEMPLOYEEFIL      := HttpSession->aUser[02]
	oObj:cREGISTRATION     := HttpSession->aUser[03]

	If oObj:BuscaVAVR()
		HttpPost->ProdamFunc := oObj:oWSBUSCAVAVRRESULT
		//--VarInfo("ProdamFunc",HttpPost->ProdamFunc)
	EndIf

	cHtml := ExecInPage("F0101301")

WEB EXTENDED END
Return cHtml


/*
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Descri��o � Web Function para Gravar os valores do VA e VR                     ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
*/

/*{Protheus.doc} F010132b
Web Function para Gravar os valores do VA e VR
@owner      ademar.fernandes
@author     ademar.fernandes
@since      06/10/2015
@return     cHtml
@project    MAN00000011501_EF_013
@version    P 12.1.006
@obs        Observacoes
*/
WebUser Function F010132b()
Local cHtml := ""
Local oObj

WEB EXTENDED INIT cHtml START "InSite"

	oObj := WSPRODAMCHANGEVAVR():New()
	WsChgURL(@oObj,"PRODAMCHANGEVAVR.APW")

	oObj:cEMPLOYEEFIL              := HttpSession->aUser[2]
	oObj:cREGISTRATION             := HttpSession->aUser[3]
	oObj:cTpConsulta               := HttpPost->TpConsulta
    HttpSession->ResultF0101302    := "0"

	If oObj:GravaVAVR()
      //--HttpSession->ResultF0101302  := oObj:cGravaVAVRRESULT:cWsResult
      HttpSession->ResultF0101302  := oObj:cTpConsulta
      //--VarInfo("oObj ==>",oObj)
      //--VarInfo("oObj:cTpConsulta ==>",oObj:cTpConsulta)
      //--VarInfo("HttpSession->ResultF0101302 ==>",HttpSession->ResultF0101302)

	   If HttpSession->ResultF0101302 == "0"
			HttpSession->_HTMLERRO    := { "", "N�o foi poss�vel atualizar sua solicita��o!", "W_PWSA00C.APW" }
          Return ExecInPage("PWSAMSG")
       Else
          //--B_F0101302()
			//--HttpSession->_HTMLERRO    := { "Grava��o OK!", PWSGetWSError(), "W_PWSA00C.APW" }
			HttpSession->_HTMLERRO    := { "", "Grava��o OK!", "W_PWSA00C.APW" }
          Return ExecInPage("PWSAMSG")
       Endif
    Else
		HttpSession->_HTMLERRO      := { "", "N�o foi poss�vel executar o servi�o!", "W_PWSA00C.APW" }
       Return ExecInPage("PWSAMSG")
	EndIf

WEB EXTENDED END
Return cHtml
