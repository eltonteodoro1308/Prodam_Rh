#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

WSSTRUCT MenuVisao        
	WSDATA Visao		     As String  OPTIONAL
	WSDATA NivelIni		 As Integer OPTIONAL
	WSDATA NivelAprov  	 As Integer OPTIONAL
ENDWSSTRUCT                            

WSSTRUCT topic
	WSDATA TitleHead      As String	OPTIONAL	//Título
	WSDATA Content        As String OPTIONAL	//Conteúdo
ENDWSSTRUCT

WSSTRUCT Others
	WSDATA AUTOEVALUATED			As String  OPTIONAL	
	WSDATA COACHNAME				As String  OPTIONAL	
	WSDATA COMPETENCE				As String  OPTIONAL	
	WSDATA COMPETENCEDESCRIPTION	As String  OPTIONAL	
	WSDATA COSTCENTERDESCRIPTION	As String  OPTIONAL	
	WSDATA DESCRIPTION				As String  OPTIONAL	
	WSDATA EVALUATEDID				As String  OPTIONAL	
	WSDATA EVALUATEDNAME			As String  OPTIONAL	
	WSDATA EVALUATEID				As String  OPTIONAL	
	WSDATA EVALUATESTATUS			As String  OPTIONAL	
	WSDATA EVALUATESTATUSDESCRIPTION	As String  OPTIONAL	
	WSDATA EVALUATETYPE				As String  OPTIONAL	
	WSDATA EVALUATORID				As String  OPTIONAL	
	WSDATA EVALUATORNAME			As String  OPTIONAL	
	WSDATA FUNCTIONDESCRIPTION		As String  OPTIONAL	
	WSDATA HIERARQLEVEL				As String  OPTIONAL	
	WSDATA LEVEL					As String  OPTIONAL	
	WSDATA MODEL					As String  OPTIONAL	
	WSDATA MODELDESCRIPTION			As String  OPTIONAL 	
	WSDATA NET						As String  OPTIONAL	
	WSDATA NETDESCRIPTION			As String  OPTIONAL	
	WSDATA OTHEREVALUATORNAME		As String  OPTIONAL	
	WSDATA PARTLEADER				As String  OPTIONAL	
	WSDATA PARTLEADERID				As String  OPTIONAL	
	WSDATA PROJECT					As String  OPTIONAL	
	WSDATA PROJECTDESCRIPTION		As String  OPTIONAL	
	WSDATA SELFEVALUATE				As String  OPTIONAL	
	WSDATA SELFEVALUATEDESCRIPTION	As String  OPTIONAL	
	WSDATA TYPEDESCRIPTION			As String  OPTIONAL	
	WSDATA TYPEEV					As String  OPTIONAL
	WSDATA VISION					As String  OPTIONAL
	WSDATA VISIONDESCRIPTION		As String  OPTIONAL	
	WSDATA ANSWERFINALDATE			As Date	
	WSDATA ANSWERINITIALDATE		As Date	
	WSDATA FINALDATE				As Date	
	WSDATA INITIALDATE				As Date	
ENDWSSTRUCT

WSSTRUCT TInputHeader
	WSDATA ListOfInput	 AS Array Of topic OPTIONAL
ENDWSSTRUCT

WSSTRUCT TInputOthers
	WSDATA ListOfOthers	 AS Array Of Others OPTIONAL
ENDWSSTRUCT

//WSSTRUCT TOutputHeader
//	WSDATA ListOfOutput	 AS Array Of Topic OPTIONAL
//ENDWSSTRUCT


WSSERVICE Menu DESCRIPTION "Acesso Menus"
	WSDATA DadosMenu        As MenuVisao
	WSDATA Portal		 	   As String
	WSDATA CodMenu		   As String

    WSDATA UserAval        AS String
    WSDATA ParamAval       AS String
    WSDATA ParamResult     AS String

    WSDATA TypeReq         AS String Optional
    WSDATA Branch          AS String Optional
    WSDATA HeadUser        AS String Optional
    WSDATA InputHeader     AS TInputHeader
	WSDATA ListOthers	   AS TInputOthers 

    //WSDATA OutputHeader    AS TOutputHeader

	WSDATA ListOfOutput	  AS Array Of topic OPTIONAL
//	WSDATA EstGetPEvaluate AS Base64Binary 
	                                                                                                 
    WSMETHOD GetDadosMenu  DESCRIPTION "GetDadosMenu"
    WSMETHOD GetRHParam    DESCRIPTION "GetRHParam"
    WSMETHOD UpdHeader     DESCRIPTION "UpdHeader"
ENDWSSERVICE

WSMETHOD GetDadosMenu WSRECEIVE Portal, CodMenu WSSEND DadosMenu WSSERVICE Menu
		dbSelectArea("AI8")
		dbSetOrder(1) //AI8_FILIAL+AI8_PORTAL+AI8_CODMNU
		::DadosMenu	:= WsClassNew('MenuVisao')
		If dbSeek( xFilial("AI8") + ::Portal + ::CodMenu)
			::DadosMenu:Visao      := AI8->AI8_VISAPV
			::DadosMenu:NivelIni   := AI8->AI8_INIAPV
			::DadosMenu:NivelAprov := AI8->AI8_APRVLV
		Else
			::DadosMenu:Visao      := ""
			::DadosMenu:NivelIni   := 0
			::DadosMenu:NivelAprov := 99
		EndIf
RETURN .T.


WSMETHOD GetRHParam WSRECEIVE UserAval, ParamAval WSSEND ParamResult WSSERVICE Menu
Local aArea    := GetArea()
Local lRetorno := .T.
If PrtChkUser(::UserAval,"CFGDictionary","GetParam")
    //Se não existir retorna "#"
    ::ParamResult := SuperGetMv(::ParamAval,.F.,"#") 
Else
    lRetorno := .F.
EndIf

RestArea(aArea)
Return(lRetorno)


WSMETHOD UpdHeader WSRECEIVE TypeReq, Branch, HeadUser, InputHeader, ListOthers WSSEND ListOfOutput WSSERVICE Menu
Local aHeader           := {}
Local aRet              := {}
Local nX                := 0
Local aOthers			:= {}
//local cXml				:= decode64(EstGetPEvaluate)

DEFAULT Self:TypeReq    := ""
DEFAULT Self:Branch     := ""
DEFAULT Self:HeadUser   := ""

  //Realizar chamada ao ponto de entrada "pgchHeader" para validar a troca das informações 
  //do cabeçalho a ser liberado para o usuário logado no Portal Gestão do Capital Humano
  If ExistBlock("PGCHHEADER")

     aHeader := {}
     For nX := 1 To Len( Self:InputHeader:ListOfInput )
         aAdd( aHeader, { Self:InputHeader:ListOfInput[nX]:TITLEHEAD , Self:InputHeader:ListOfInput[nX]:CONTENT } )
     Next nX

	aOthers := {}
	aAdd( aOthers, { "cAUTOEVALUATED", 				Self:ListOthers:ListOfOthers[1]:AUTOEVALUATED } )
	aAdd( aOthers, { "cCOACHNAME", 					Self:ListOthers:ListOfOthers[1]:COACHNAME } )
	aAdd( aOthers, { "cCOMPETENCE", 				Self:ListOthers:ListOfOthers[1]:COMPETENCE } )
	aAdd( aOthers, { "cCOMPETENCEDESCRIPTION", 		Self:ListOthers:ListOfOthers[1]:COMPETENCEDESCRIPTION } )
	aAdd( aOthers, { "cCOSTCENTERDESCRIPTION", 		Self:ListOthers:ListOfOthers[1]:COSTCENTERDESCRIPTION } )
	aAdd( aOthers, { "cDESCRIPTION", 				Self:ListOthers:ListOfOthers[1]:DESCRIPTION } )
	aAdd( aOthers, { "cEVALUATEDID", 				Self:ListOthers:ListOfOthers[1]:EVALUATEDID } )
	aAdd( aOthers, { "cEVALUATEDNAME", 				Self:ListOthers:ListOfOthers[1]:EVALUATEDNAME } )
	aAdd( aOthers, { "cEVALUATEID", 				Self:ListOthers:ListOfOthers[1]:EVALUATEID } )
	aAdd( aOthers, { "cEVALUATESTATUS", 			Self:ListOthers:ListOfOthers[1]:EVALUATESTATUS } )
	aAdd( aOthers, { "cEVALUATESTATUSDESCRIPTION", 	Self:ListOthers:ListOfOthers[1]:EVALUATESTATUSDESCRIPTION } )
	aAdd( aOthers, { "cEVALUATETYPE", 				Self:ListOthers:ListOfOthers[1]:EVALUATETYPE } )
	aAdd( aOthers, { "cEVALUATORID", 				Self:ListOthers:ListOfOthers[1]:EVALUATORID } )
	aAdd( aOthers, { "cEVALUATORNAME", 				Self:ListOthers:ListOfOthers[1]:EVALUATORNAME } )
	aAdd( aOthers, { "cFUNCTIONDESCRIPTION", 		Self:ListOthers:ListOfOthers[1]:FUNCTIONDESCRIPTION } )
	aAdd( aOthers, { "cHIERARQLEVEL", 				Self:ListOthers:ListOfOthers[1]:HIERARQLEVEL } )
	aAdd( aOthers, { "cLEVEL", 						Self:ListOthers:ListOfOthers[1]:LEVEL } )
	aAdd( aOthers, { "cMODEL", 						Self:ListOthers:ListOfOthers[1]:MODEL } )
	aAdd( aOthers, { "cMODELDESCRIPTION", 			Self:ListOthers:ListOfOthers[1]:MODELDESCRIPTION } )
	aAdd( aOthers, { "cNET", 						Self:ListOthers:ListOfOthers[1]:NET } )
	aAdd( aOthers, { "cNETDESCRIPTION", 			Self:ListOthers:ListOfOthers[1]:NETDESCRIPTION } )
	aAdd( aOthers, { "cOTHEREVALUATORNAME", 		Self:ListOthers:ListOfOthers[1]:OTHEREVALUATORNAME } )
	aAdd( aOthers, { "cPARTLEADER", 				Self:ListOthers:ListOfOthers[1]:PARTLEADER } )
	aAdd( aOthers, { "cPARTLEADERID", 				Self:ListOthers:ListOfOthers[1]:PARTLEADERID } )
	aAdd( aOthers, { "cPROJECT", 					Self:ListOthers:ListOfOthers[1]:PROJECT } )
	aAdd( aOthers, { "cPROJECTDESCRIPTION", 		Self:ListOthers:ListOfOthers[1]:PROJECTDESCRIPTION } )
	aAdd( aOthers, { "cSELFEVALUATE", 				Self:ListOthers:ListOfOthers[1]:SELFEVALUATE } )
	aAdd( aOthers, { "cSELFEVALUATEDESCRIPTION", 	Self:ListOthers:ListOfOthers[1]:SELFEVALUATEDESCRIPTION } )
	aAdd( aOthers, { "cTYPEDESCRIPTION", 			Self:ListOthers:ListOfOthers[1]:TYPEDESCRIPTION } )
	aAdd( aOthers, { "cTYPEEV", 					Self:ListOthers:ListOfOthers[1]:TYPEEV } )
	aAdd( aOthers, { "cVISION", 					Self:ListOthers:ListOfOthers[1]:VISION } )
	aAdd( aOthers, { "cVISIONDESCRIPTION", 			Self:ListOthers:ListOfOthers[1]:VISIONDESCRIPTION } )
	aAdd( aOthers, { "dANSWERFINALDATE", 			Self:ListOthers:ListOfOthers[1]:ANSWERFINALDATE } )
	aAdd( aOthers, { "dANSWERINITIALDATE", 			Self:ListOthers:ListOfOthers[1]:ANSWERINITIALDATE } )
	aAdd( aOthers, { "dFINALDATE", 					Self:ListOthers:ListOfOthers[1]:FINALDATE } )
	aAdd( aOthers, { "dINITIALDATE", 				Self:ListOthers:ListOfOthers[1]:INITIALDATE } )

     If ( ValType( aRet := ExecBlock("PGCHHEADER", .F. , .F. ,{ Self:TypeReq,;
                                                                Self:Branch,;	 
       		                                                  	Self:HeadUser,;
                                                                aHeader,;
                                                                aOthers;
    		                                                    }) ) == "A" )

         For nX := 1 To Len( aRet )
            aAdd(::ListOfOutput, wsClassNew('topic')) 
          	  self:ListOfOutput[nX]:TitleHead := aRet[nX][1]
	         self:ListOfOutput[nX]:Content   := aRet[nX][2]
         Next nX
     EndIF

  EndIf

RETURN .T.


Function WSMENU
RETURN