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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³ Web Function para Buscar os valores do VA e VR                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
WebUser Function F0101302()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³ Web Function para Gravar os valores do VA e VR                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			HttpSession->_HTMLERRO    := { "", "Não foi possível atualizar sua solicitação!", "W_PWSA00C.APW" }
          Return ExecInPage("PWSAMSG")
       Else
          //--B_F0101302()
			//--HttpSession->_HTMLERRO    := { "Gravação OK!", PWSGetWSError(), "W_PWSA00C.APW" }
			HttpSession->_HTMLERRO    := { "", "Gravação OK!", "W_PWSA00C.APW" }
          Return ExecInPage("PWSAMSG")
       Endif
    Else
		HttpSession->_HTMLERRO      := { "", "Não foi possível executar o serviço!", "W_PWSA00C.APW" }
       Return ExecInPage("PWSAMSG")
	EndIf

WEB EXTENDED END
Return cHtml
