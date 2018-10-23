#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"          

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} APDFINAVAL
@Descri็ใo  PONTO DE ENTRADA NA FINALIZACAO DA AVALIACAO
@author     Marcos Pereira
@since     	20/03/2016
@version  	P.12      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|       		  | 
------------+-----------------+----------------------------------------------------------
/*/
//--------------------------------------------------------------------------------------- 
User Function APDFinaVal() 
Local aArea		:= getarea()
Local cTabAux	:= GetNextAlias()
Local cCodVis	:= ''
Local cItem		:= ''
Local cItemSup	:= ''
Local cSuperior	:= ''
Local lContinua	:= .f.
	
//Se finalizacao de Avaliacao
If RDC->RDC_TIPOAV == "1"

	//A avaliacao sendo finalizada pode ser de uma avaliador PAR. Nesse caso tem que desprezar.
	//Se encontrar na RDH o CODNET da RDC posicionada com parametricacao de mesmo nivel e sem autoavaliacao e consenso, 
	//significa que trata-se de avalia็ใo de PAR e entao nao continua.
	cQry:= " Select RDC_CODNET from " + RetSqlName("RDC") + CRLF
	cQry+= " Where RDC_ID = '"+ RDC->RDC_ID +"' " + CRLF
	cQry+= "   and D_E_L_E_T_ = '' " + CRLF
	cQry+= "   and RDC_CODNET NOT IN ( " + CRLF
	cQry+= "                          Select RDH_CODNET from " + RetSqlName("RDH") + CRLF
	cQry+= "                       		Where RDH_CODTIP = '"+ RDC->RDC_CODTIP +"' " + CRLF   
	cQry+= "                       		  and RDH_CODNET = '"+ RDC->RDC_CODNET +"' " + CRLF   
	cQry+= "                       		  and (RDH_NIVEL = 1 or RDH_NIVEL  = 3)" + CRLF   
	cQry+= "                       		  and RDH_AUTOAV = 2 " + CRLF   
	cQry+= "                       		  and RDH_FEEDBK = 2 " + CRLF   
	cQry+= "                              and D_E_L_E_T_ = '' )" + CRLF
	TcQuery cQry NEW ALIAS (cTabAux)	                                                   
	If (cTabAux)->(!EOF())
		lContinua := .t.
	EndIf
	(cTabAux)->(dbCloseArea())
	
	If lContinua	
	
		//Codigo da Visao utilizada
		cCodVis := RD6->RD6_CODVIS
		
		//Se utiliza Visao
		If !empty(cCodVis)
	
			//Busca na RDE o Item da Visao
			cTabAux	:= GetNextAlias()
			cQry:= " Select RDE_ITEVIS, RDE_XAPROV  From " + RetSqlName("RDE") + CRLF
			cQry+= " Where RDE_FILIAL = '"+ xFilial("RDE")+"' " + CRLF
			cQry+= "   and RDE_CODVIS = '"+ cCodVis +"' " + CRLF
			cQry+= "   and RDE_CODPAR = '"+ RDC->RDC_CODDOR +"' " + CRLF
			cQry+= "   and RDE_STATUS = '1' " + CRLF
			cQry+= "   and D_E_L_E_T_ = '' " + CRLF
			TcQuery cQry NEW ALIAS (cTabAux)	                                                   
			If (cTabAux)->(!EOF())
				If (cTabAux)->RDE_XAPROV == '2'
					cSuperior := 'NAO'
				Else
					cItem := (cTabAux)->RDE_ITEVIS
				EndIf
			EndIf
			(cTabAux)->(dbCloseArea())
			
			If cSuperior <> 'NAO'

				//Busca na RD4 o item superior
				If !empty(cItem)
		
					aRD4 := RD4->(getarea())
					cItemSup := Posicione("RD4",1,xFilial("RD4")+cCodVis+cItem,"RD4_TREE")
					RestArea(aRD4)
					
					//Busca na RDE o codigo do aprovador
					If !empty(cItemSup)
						cTabAux	:= GetNextAlias()
						cQry:= " Select RDE_CODPAR From " + RetSqlName("RDE") + CRLF
						cQry+= " Where RDE_FILIAL = '"+ xFilial("RDE")+"' " + CRLF
						cQry+= "   and RDE_CODVIS = '"+ cCodVis +"' " + CRLF
						cQry+= "   and RDE_ITEVIS = '"+ cItemSup +"' " + CRLF
						cQry+= "   and RDE_STATUS = '1' " + CRLF
						cQry+= "   and D_E_L_E_T_ = '' " + CRLF
						TcQuery cQry NEW ALIAS (cTabAux)	                                                   
						If (cTabAux)->(!EOF())
							cSuperior := (cTabAux)->RDE_CODPAR
						EndIf
						(cTabAux)->(dbCloseArea())
					EndIf
				EndIf
	
			EndIf
	
		//Se utiliza estrutura de Depto	
		Else 
		
			aRD0	:= RD0->(getarea())
			aRDZ	:= RDZ->(getarea())
			aSRA	:= SRA->(getarea())
			aSQB	:= SQB->(getarea())
			RDZ->(dbSetOrder( RetOrdem( "RDZ" , "RDZ_FILIAL+RDZ_CODRD0+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA" ) ))
			SRA->(dbsetorder(1))
			SQB->(dbsetorder(1))
			//Busca Filial e Matricula do funcionario
			If RDZ->(dbseek( xFilial("RDZ") + RD0->RD0_CODIGO )) .and. RDZ->RDZ_ENTIDA == 'SRA'
				//Busca o depto atual do funcionario
				If SRA->(dbseek(RDZ->RDZ_CODENT))
					//Busca a filial e matricula do Responsavel pelo Depto
					If SQB->(dbseek(xFilial("SQB",SRA->RA_FILIAL)+SRA->RA_DEPTO))
						//Busca o codigo na RD0 do responsavel
						If EntExisteRel( "SRA" , SQB->(QB_FILRESP+QB_MATRESP) , , , .t. )
							cSuperior := RD0->RD0_CODIGO
						EndIf
					EndIf
				EndIf
			EndIf
			RestArea(aSQB)				
			RestArea(aSRA)				
			RestArea(aRDZ)				
			RestArea(aRD0)				
		
		EndIf
		
		
		//Envia email ao aprovador
		If !empty(cSuperior)
	
			If cSuperior == 'NAO'

				//Grava na RDC que nao precisa de superior, porem com data de retorno da aprovacao para liberar consenso
				RecLock("RDC",.f.)
				RDC->RDC_CODAPR := cSuperior	//C๓digo do aprovador
				RDC->RDC_DTEMAP	:= date()		//Data de envio de email para o aprovador
				RDC->RDC_DTRETA	:= date()		//Data de retorno da aprovacao
				RDC->(MsUnLock())

				//Copia avalia็ใo
		       	U_APDCopyC(RDC->RDC_CODAVA, RDC->RDC_CODADO, RDC->RDC_CODDOR)

			Else

				U_MontaMail(2,RDC->RDC_CODADO,cSuperior)
		
				//Grava na RDC informacoes do email enviado
				RecLock("RDC",.f.)
				RDC->RDC_CODAPR := cSuperior	//C๓digo do aprovador
				RDC->RDC_DTEMAP	:= date()		//Data de envio de email para o aprovador
				RDC->RDC_DTRETA	:= ctod("//")	//Data de retorno da aprovacao
				RDC->(MsUnLock())
						
			Endif

		Else
			ConOut("### APD: Nao foi encontrado o aprovador para o colaborador "+RDC->RDC_CODADO)
		EndIf

	EndIf
	
EndIf

RestArea(aArea)	
Return


/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ MontaMail    บAutor  ณTotvs		       บ Data ณ12/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o e-mail para superior ao finalizar a avalia็ใo      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
User function MontaMail(nTipo,cCodFun,cCodDest,cObs)
Local cTabRd0	  := GetNextAlias()
Local cCodDor	  := ""
Local cQry		  := "" 
LOCAL lRet		  := .T.
Local cMensagem := ''
Local cDest     := ''
Local cSubject  := ''                        
Local cHTML     := ''                        

DEFAULT nTipo   := 0
DEFAULT cObs    := ''

If nTipo == 0
   return .F.
EndIf


cHTML := '<html>'
cHTML += '<head>'
cHTML += '<title>Avalia็ใo - Mudan็a de Status</title>'
cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
cHTML += '<style type="text/css">'
cHTML += '			.TituloMenor {'
cHTML += '				font-family: Arial, Helvetica, sans-serif;'
cHTML += '				font-size: 12px;'
cHTML += '				color: #49577E;'
cHTML += '				text-decoration: none;'
cHTML += '				font-weight: bold;'
cHTML += '				} '
cHTML += '			.Observ {'
cHTML += '				font-family: Arial, Helvetica, sans-serif;'
cHTML += '				font-size: 12px;'
cHTML += '				color: #00a9c7;'
cHTML += '				text-decoration: none;'
cHTML += '				} '
cHTML += '</style>'
cHTML += '</head>'
cHTML += '<body bgcolor="#FFFFFF" bgproperties="fixed">'
cHTML += '<form name="formMsg">'


cQry:= " Select RD0_NOME From " + RetSqlName("RD0")+CRLF
cQry+= " Where RD0_FILIAL = '"+ xFilial("RD0")+"'"+CRLF
cQry+= "   and RD0_CODIGO = '" + cCodFun + "'"+CRLF
cQry+= "   and D_E_L_E_T_ = ''"+CRLF

TcQuery cQry NEW ALIAS (cTabRd0)	                                                   
(cTabRd0)->(dbSelectArea((cTabRd0)))                    
(cTabRd0)->(dbGoTop())                               	
If (cTabRd0)->(!EOF())
	cSubject 	:= "Avaliacao - Mudanca de Status - "	 	
	DO CASE              
		CASE nTipo == 1
           cHTML += '<p class="TituloMenor"> A autoavalia็ใo de &nbsp;' +alltrim((cTabRd0)->RD0_NOME) +'&nbsp; foi finalizada. </p>'
           cHTML += '<p class="TituloMenor"> Favor realizar a etapa de avalia็ใo! </p>'
		   cSubject	+= "AVALIACAO"
		CASE nTipo == 2			
           cHTML += '<p class="TituloMenor"> A avalia็ใo de &nbsp;' +alltrim((cTabRd0)->RD0_NOME) +'&nbsp; foi finalizada. </p>'
           cHTML += '<p class="TituloMenor"> Favor realizar a etapa de aprova็ใo! </p>'
		   cSubject	+= "APROVACAO"
		CASE nTipo == 3
           cHTML += '<p class="TituloMenor"> A avalia็ใo de &nbsp;' +alltrim((cTabRd0)->RD0_NOME) +'&nbsp; foi aprovada. </p>'
           cHTML += '<p class="TituloMenor"> Favor realizar a etapa de consenso! </p>'
		   cSubject	+= "CONSENSO"
		CASE nTipo == 4
           cHTML += '<p class="TituloMenor"> A avalia็ใo de &nbsp;' +alltrim((cTabRd0)->RD0_NOME) +'&nbsp; foi reprovada. </p>'
           cHTML += '<p class="TituloMenor"> Favor revisar a avalia็ใo considerando a observa็ใo abaixo. </p>'
		   cSubject	+= "REVISAR"
	ENDCASE	

   If cObs != ''
      cHTML += '<p>&nbsp;</p>'
      cHTML += '<p class="TituloMenor"> Observa็๕es da movimenta็ใo: </p>'
      cHTML += '<p class="Observ">' +cObs +'</p>'
   EndIf

    cHTML += '<p>&nbsp;</p>'
    cHTML += '<p class="TituloMenor"> (Mensagem automแtica. Nใo responda a este e-mail) </p>'
    cHTML += '</form>'
    cHTML += '</body>'
    cHTML += '</html>'
	                              	
	cSubject  += " - " + alltrim((cTabRd0)->RD0_NOME)
	cDest     := alltrim(POSICIONE("RD0",1,XFILIAL("RD0")+cCodDest,"RD0_EMAIL"))			
	lRet      := U_EnvMail(cSubject,cHTML, cDest,,.f.)
	
EndIf  
(cTabRd0)->(dbCloseArea()) 
       
RETURN lRet

