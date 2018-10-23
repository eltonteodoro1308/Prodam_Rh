
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PGCH000    ºAutor  ³ Marcos Pereira    º Data ³  07/01/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes chamadas como link referente customizacoes no      º±±
±±º          ³ Portal GCH                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

///////////////////////////////////////////////////////////
// Funcao chamada pelo Link das customizações no Portal  //
// cPar1 -> string com empresa+filial+usuario+senha      // 
// cPar2 -> string fixa passada por cada customizacao    //
// cPar3 -> Nome do arquivo texto contendo as matriculas //
//          da equipe do usuario logado, ou              //
//          Filial e Matricula do usuario logado
///////////////////////////////////////////////////////////
User Function PGCH(cPar1,cPar2,cPar3)

Local cRotina  := ''
Local lRet 	   := .f.
Local nTamFil  := 2

Private cArqTemp_ := cPar3  //Esta variavel sera utilizada pela U_FiltrEq()
Private cFilMDT_, cMatMDT_
Private cFilAPD_, cMatAPD_

If cPar2 == 'e8a97zb3'    			// Troca de Turno
	cRotina := 'PONA160()'
ElseIf cPar2 == '64fo2vy7'			// Autorização de Horas Extras
	cRotina := 'PONA300("PONA300")'
ElseIf cPar2 == 'u466w78i' 			// Consulta EPI (usuario logado)
	cPar3 		:= embaralha(cPar3,1)
	cPar3 		:= strtran(cPar3,"_"," ")
	cFilMDT_ 	:= substr(cPar3,11,nTamFil) 
	cMatMDT_ 	:= substr(cPar3,(11+nTamFil+10),6)
	cRotina := 'U_MDT001()'
ElseIf cPar2 == 'z649fg2u'			// Metas individuais da equipe para Avaliação
	cRotina := 'U_APD001("T")'
ElseIf cPar2 == 'z649fg2v' 			// Metas individuais (usuario logado)
	cPar3 		:= embaralha(cPar3,1)
	cPar3 		:= strtran(cPar3,"_"," ")
	cFilAPD_ 	:= substr(cPar3,11,nTamFil) 
	cMatAPD_ 	:= substr(cPar3,(11+nTamFil+10),6)
	cRotina := 'U_APD001("L")'
Else
	Alert("Tentativa de acesso não autorizado.")
	Return
EndIf

aParam := StrTokArr(Embaralha(cPar1,1),'|')
                    
RPCSetType(3) // sem consumo de licença
Processa({|| lRet := RpcSetEnv( aParam[1], aParam[2], aParam[3], aParam[4] )}, "", "Carregando Ambiente Protheus WEB", .f.)

__cInternet := Nil
	
If lRet                 
	oApp:cModname		:= "ERP-CORPORATIVO"
	oApp:bMainInit 		:= {|| &(cRotina) , __Quit() }
	oApp:lisblind		:= .F.
	oApp:cInternet 		:= ""
	oApp:cModDesc		:= "ERP-CORPORATIVO"
	oApp:activate()
	RpcClearEnv()
Else 
   MsgStop('Falha na Conexão com o Ambiente Protheus WEB','>>> ATENÇÃO <<<')
Endif   



Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao utilizada no cadastro de restricoes de acesso para filtrar as matriculas do browse da SRA de acordo  //
// com o conteudo do arquivo texto onde consta a equipe direta do usuario logado no portal                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FiltrEq()

Local nTamFil 	:= TamSx3("RA_FILIAL")[1]
Local nTamLin 	:= nTamFil + 6
Local cFilAnt_ 	:= "@@"
Local cCond 	:= ""
Local cFil_ 	:= cMat_ := ""
Local lFiltra	:= .T.

//Variavel criada pela U_PGCH() contendo o nome do arquivo txt com as matriculas da equipe
//Se a mesma nao existir, nao executa este filtro. 
If Type("cArqTemp_")   == "U" 
	Return("")
EndIf

//varinfo("FiltrEq -> cArqTemp_ -> ",cArqTemp_)

//Se nao encontrar o arquivo, retorna filtro invalido para nao permitir visualização de nenhuma matricula.
If  !(File("\temp\"+cArqTemp_))
	Return("(RA_FILIAL=='@@')") 
Else

	FT_FUSE("\temp\"+cArqTemp_)
	FT_FGOTOP()
	
	While !FT_FEOF()
		cLinha	:= FT_FREADLN()
		cFil_	:= Subst(cLinha,1,nTamFil)
		cMat_	:= Subst(cLinha,nTamFil+1,6)
		
		If SubStr(cOpcao,1,1) == "1" //Sem Metas
			If !U_FILEQ( cFil_, cMat_, cPeriodo, '1' )
				lFiltra := .F.
			EndIf
		ElseIf SubStr(cOpcao,1,1) == "2" //Sem Resultados
			If !U_FILEQ( cFil_, cMat_, cPeriodo, '2')
				lFiltra := .F. 
			EndIf
		EndIf
		
		If cFilAnt_ == '@@' .And. lFiltra
			cCond 		:= "( RA_SITFOLH <> 'D' .and. (( RA_FILIAL=='"+cFil_+"' .and. RA_MAT$'"+cMat_
			cFilAnt_ 	:= cFil_
		ElseIf cFil_ == cFilAnt_ .And. lFiltra
			cCond += "/"+cMat_
		ElseIf lFiltra
			cCond 		+= "').or.(RA_FILIAL=='"+cFil_+"' .and. RA_MAT$'"+cMat_
			cFilAnt_ 	:= cFil_
		EndIf	
		
		lFiltra := .T.
			
		FT_FSKIP()
	EndDo
	If len(cCond) > 0
		cCond += "')))"
	EndIf
	FT_FUSE()
EndIf
  
//varinfo("filtro:",cCond)
Return(cCond)
        


