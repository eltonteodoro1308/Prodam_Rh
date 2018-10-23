#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "FWBROWSE.CH" 
#INCLUDE "FWMVCDEF.CH" 
#include "FONT.CH"
#include "COLORS.CH"
#INCLUDE "GPEA200.CH" 

#define Confirma 1
#define Redigita 2
#define Abandona 3
#define nColObg 8 
//Colunas utilizadas tanto para adicionais/obrigatorios = 
// 1- Legenda / 2- Campo / 3- Descricao / 4- Pos. Inicial / 5- Pos. Final / 6- Formula / 7- Ord. Gravacao do cpo / 8-Ordem do Log

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao       ³ RSP200  ³ Autor ³             	       ³ Data ³ 15/02/2016          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao    ³ Cadastro de Layout de Importacao          			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ RSP200                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³			      ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³ 	        ³          ³     	    	³                     						³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RSP200() 						                                  
Local	cFTerSZ4	:= ""  
Private oMBrowse
Private aRotina 	:= 	MenuDef()
	
	// OBSERVACAO IMPORTANTE
	// Na inclusao de novos alias, incluir campo no filtro
	// e variaveis conforme observacao na funcao RSP200Atu.
	cFTerSZ4    	:= "ALLTRIM(SZ4->Z4_CPO) $ 'QG_FILIAL*'"    
               	
	oMBrowse:= FWMBrowse():New()  
	oMBrowse:SetDescription(STR0080)	// "Layout de Importacao"  
	oMBrowse:SetAlias('SZ4')
   	oMBrowse:SetMenuDef( 'RSP200' )  
   	oMBrowse:SetFilterDefault(cFTerSZ4)  
   	oMBrowse:SetChgAll(.F.)		 		
	oMBrowse:Activate()		
					
Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ RSP200Atu ³ Autor ³ Equipe RH         ³Data  ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a manutencao no cadastro de layout de importacao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP200                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RSP200Atu( 	cAlias,;	// Alias do arquivo
					nReg,;		// Registro atual
					nOpc ;		// Opcao do menu
				  )
// Variaveis do tipo objetos  
Local oDlg			:= Nil			
Local oFont	 
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4           
Local oCodSZ4
Local oDescSZ4
Local oTbDest
Local oCondSZ4          
Local oBtnCar
// Variaveis para controle de coordenadas da janela 
Local aAdvSize			:= {}
Local aInfoAdvSize		:= {}
Local aObjSize			:= {}
Local aObjCoords		:= {}
Local aAdv1Size			:= {}
Local aInfo1AdvSize		:= {}
Local aObj1Coords 		:= {}
Local aObj1Size			:= {} 
Local aAdv2Size			:= {}
Local aInfo2AdvSize		:= {}
Local aObj2Size			:= {}	
Local aObj2Coords 		:= {}		
Local aAdv3Size			:= {}
Local aInfo3AdvSize		:= {}
Local aObj3Size			:= {}	
Local aObj3Coords 		:= {}
// Variaveis utilizadas na tela
Local aButtons  		:=  {	{"Rs200LEG",{||Rs200Leg()},OemtoAnsi(STR0074)}		}  
Local cCodSZ4		
Local cDescSZ4		      
Local cCondSZ4  
Local cCposAdi
Local cCposObg        
Local aCond 			:= { STR0063, STR0064}//"1=Sim" //"2=Nao"   
//Variaveis auxliares
Local nX				:= 0			

Private Txt		  		:= Repli("X",200)
Private aCposAdi        := {}
Private aCposAdiSv		:= {}
Private aCposObg	    := {}
Private aCposObgSv		:= {}    
Private aDelCpos		:= {}	
Private aHeader			:= {} 
Private aAlter   		:= {"M200INI","M200FIM","M200CON","M200ORL"}
Private aCols			:= {} 
Private cTbDest   
Private cTbDestSv 
Private oCposAdi
Private oCposObg            
Private oGetObg			:= {}    
// Variaveis sobre legenda
Private oBCpoUser		:= LoadBitmap( GetResources(), "BR_VERDE" )  // Campo determinado pelo usuario 


// OBSERVACAO IMPORTANTE
// Na inclusao de novos alias, incluir campo no filtro
// e variaveis conforme observacoes abaixo:
//Alias utilizados na rotina
Private aTbDest 		:= { "SQG"}        

//Para criacao de array com campos(aCps) configurados atraves
//do pergunte da rotina GPEA210, para novo alias utilizar
//nomenclatura abaixo 'aCps' + 'Alias'
Private aCpsSQG        	:= {}

//Para criacao com array obrigatorio(aObg) para novo alias
//utilizar nomenclatura abaixo 'aObg' + 'Alias'	 
Private aObgSQG			:= {{"QG_FILIAL",TamSx3("QG_FILIAL")[1]},{"QG_CIC",TamSx3("QG_CIC")[1]},{"QG_CODFUN",TamSx3("QG_CODFUN")[1]},{"QG_XNOTAT",TamSx3("QG_XNOTAT")[1]},{"QG_XCLASSI",TamSx3("QG_XCLASSI")[1]},{"QG_XCOTA",TamSx3("QG_XCOTA")[1]}}

   	nOpcA	:= 0
   	              
 	AADD(aCposAdi, {oBCpoUser,"",""}) 
	aCposAdiSv 	:= aClone(aCposAdi)  
	     
	// Monta as Dimensoes dos Objetos.
	aAdvSize		:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 3 , 3 }					 
	aAdd( aObjCoords , { 000 , 025 , .T. , .F. } )		// 1-Cabecalho campos SZ4
	aAdd( aObjCoords , { 000 , 020 , .T. , .F. } )		// 2-Colunas de Selecao(titulos)   
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )		// 3-Colunas de Campos
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords ) 
		
	//Cabecalho
	aAdv1Size		:= aClone(aObjSize[1])
	aInfo1AdvSize	:= { aAdv1Size[2] , aAdv1Size[1] , aAdv1Size[4] , aAdv1Size[3] , 2 , 2 }
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 1-Codigo
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 2-Descricao
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 3-Tabela destino
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 4-Cond.Gravacao
	aObj1Size		:= MsObjSize( aInfo1AdvSize , aObj1Coords,,.T. )     
	
	aAdv2Size    	:= aClone(aObjSize[2])
	aInfo2AdvSize	:= { aAdv2Size[2] , aAdv2Size[1] , aAdv2Size[4] , aAdv2Size[3] , 2 , 2 }
	aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } ) // Campos adicionais
	aAdd( aObj2Coords , { 020 , 000 , .F. , .T. } )
	aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } ) // Campos obrigatorios
	aObj2Size := MsObjSize( aInfo2AdvSize , aObj2Coords,, .T. )  // Divisao em colunas
		
	aAdv3Size    	:= aClone(aObjSize[3]) 
	aInfo3AdvSize   := { aAdv3Size[2] , aAdv3Size[1] , aAdv3Size[4] , aAdv3Size[3] , 2 , 2 }
	aAdd( aObj3Coords , { 000 , 000 , .T. , .T. , .T. } )  // Coluna dos campos adicionais
	aAdd( aObj3Coords , { 020 , 000 , .F. , .T. } )
	aAdd( aObj3Coords , { 000 , 000 , .T. , .T. } )  // Coluna dos campos obrigatorios
	aObj3Size := MsObjSize( aInfo3AdvSize , aObj3Coords,, .T. ) // Divisao em colunas
    
	cCodSZ4		:= If(nOpc == 3, Space(TamSx3("Z4_CODIGO")[1]), SZ4->Z4_CODIGO)
	cDescSZ4	:= If(nOpc == 3, Space(TamSx3("Z4_DESC")[1]), SZ4->Z4_DESC)
	cTbDest		:= If(nOpc == 3, cTbDest, SZ4->Z4_TBDEST)
	cCondSZ4	:= If(nOpc == 3, Space(TamSx3("Z4_COND")[1]), SZ4->Z4_COND) 
    
    // Monta cols com os campos obrigatorios 
	Rs200MontaCols(nOpc,xFilial("SZ4"),cCodSZ4,cTbDest)

	// Define quadro de dialogo.												
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] Title OemToAnsi( STR0005 ) PIXEL	
	
	   	@ aObj1Size[1,1] 	, aObj1Size[1,2]	GROUP oGroup1 TO aObj1Size[1,3]+5, aObj1Size[1,4]  LABEL OemToAnsi(STR0060) OF oDlg PIXEL	//"Cod.Layt."
		@ aObj1Size[1,1]+10 , aObj1Size[1,2]+5 MSGET cCodSZ4 PICTURE "@!" WHEN nOpc == 3  VALID fValidCod(cCodSZ4) SIZE 45,10  OF oGroup1 PIXEL FONT oFont
	   	oGroup1:oFont:= oFont	 
	    
	   	@ aObj1Size[2,1] 	, aObj1Size[2,2]	GROUP oGroup2 	TO aObj1Size[2,3]+5, aObj1Size[2,4]  LABEL OemToAnsi(STR0061) OF oDlg PIXEL //"Desc.Layt."
		@ aObj1Size[2,1]+10 , aObj1Size[2,2]+5 MSGET  cDescSZ4   	PICTURE "@!"  WHEN nOpc == 3  SIZE 105,10  PIXEL FONT oFont
	  	oGroup2:oFont:= oFont	
		                       
	   	@ aObj1Size[3,1] 	 , aObj1Size[3,2]		GROUP oGroup3      TO  aObj1Size[3,3]+5, aObj1Size[3,4] LABEL OemToAnsi(STR0062) OF oDlg PIXEL	//"Tb.Dest."
	   	@ aObj1Size[3,1]+10 , aObj1Size[3,2]+5		MSCOMBOBOX cTbDest ITEMS aTbDest WHEN nOpc == 3 SIZE 45,10   PIXEL FONT oFont
	   	@ aObj1Size[3,1]+10	 , aObj1Size[3,2]+65	BUTTON oBtnCar Prompt OemToAnsi(STR0067) WHEN nOpc == 3	SIZE 45,10 PIXEL FONT oFont ACTION fLoadCpos(cTbDest)	//"Carregar"
		oGroup3:oFont:= oFont	
				
		@ aObj1Size[4,1] 	, aObj1Size[4,2]	GROUP oGroup4 	TO aObj1Size[4,3]+5, aObj1Size[4,4]  LABEL OemToAnsi(STR0014) OF oDlg PIXEL	//"Cond.Gravacao Registro"
		@ aObj1Size[4,1]+10 , aObj1Size[4,2]+5	MSGET cCondSZ4	PICTURE "@!" WHEN If(nOpc == 2 .Or. nOpc == 5,.F.,.T.)  SIZE 90,10  PIXEL FONT oFont
		oGroup4:oFont:= oFont       
				
		// Exibe quadros de colunas de selecao
		@ aObj2Size[1,1],aObj2Size[1,2] Group oGroup To aObj2Size[1,3],aObj2Size[1,4]  Of oDlg Pixel
		@ aObj2Size[1,1]+5,aObj2Size[1,2]+5 Say OemToAnsi(STR0065) Size 75,10 Pixel Font oFont  //"Campos adicionais:"
	   
		@ aObj2Size[3,1],aObj2Size[3,2] Group oGroup To aObj2Size[3,3],aObj2Size[3,4]	 Of oDlg Pixel		
		@ aObj2Size[3,1]+5,aObj2Size[3,2]+5 Say OemToAnsi(STR0066) Size 75,10 Pixel Font oFont //"Campos obrigatorios:" 
	
	   	@ aObj3Size[1,1],aObj3Size[1,2] ListBox oCposAdi Var cCposAdi;
					Fields	Header	 "",; 					//Legenda 
									 OemToAnsi(STR0006),; 	//"Campo" 
								     OemToAnsi(STR0012); 	//"Descricao"
							ColSizes GetTextWidth(0, Replicate("B", 1) ),;
									 GetTextWidth(0, Replicate("B", 6) ),;
									 GetTextWidth(0, Replicate("B", 25) );
					Size aObj3Size[1,3],aObj3Size[1,4] Of oDlg Pixel 
	   	oCposAdi:LHSCROLL := .F.   
	   	oCposAdi:SetArray(aCposAdi)		
		oCposAdi:bLine := { ||  {  oBCpoUser,;
									aCposAdi[oCposAdi:nAt,2],;
								   	aCposAdi[oCposAdi:nAt,3];
								 }; 
							}    
	   oGetObg 		:= MSGetDados():New(aObj3Size[3,1],aObj3Size[3,2] ,aObj3Size[3,3],aObj3Size[3,4],nOpc,"U_Rs200LOk()","U_Rs200TOk()","",.F.,aAlter,1,,Len(aCols))
	   aCposObgSv	:= aClone(aCols) 			
									     		                       
		// Exibe buttons de manipulacao apenas para inclusao/alteracao											 
		If nOpc != 2 .And. nOpc != 5
			@ aObj3Size[2,3]+5 ,(aObj3Size[2,2]*2)+10 	BtnBmp oNext    Resource 'NEXT'    Size 25,25 Design Action gpMvtCpos( 1, .T., oCposAdi:nAt, cTbDest, nOpc ) 			Of oDlg 
			@ aObj3Size[2,3]+35 ,(aObj3Size[2,2]*2)+10 BtnBmp oPgNext Resource 'PGNEXT'  Size 25,25 Design Action gpMvtCpos( 1, .F., oCposAdi:nAt, cTbDest, nOpc )  			Of oDlg
			@ aObj3Size[2,3]+65 ,(aObj3Size[2,2]*2)+10 BtnBmp oPrev   Resource 'PREV'    Size 25,25 Design Action gpMvtCpos( 2, .T., oGetObg:oBrowse:nAt, cTbDest , nOpc ) 	Of oDlg
			@ aObj3Size[2,3]+95,(aObj3Size[2,2]*2)+10 BtnBmp oPgPrev  Resource 'PGPREV'  Size 25,25 Design Action gpMvtCpos( 2, .F., oGetObg:oBrowse:nAt, cTbDest, nOpc ) 	Of oDlg
		EndIf 
				
		bSet15		:= {|| If ( U_Rs200TOk() .And. U_fRs200Ok(nOpc, cCodSZ4, cCondSZ4), (nOpcA := If(nOpc==5,2,1),oDlg:End() ),) }					
		bSet24		:= { ||oDlg:End() }
   
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bSet15 , bSet24 , Nil , aButtons ) CENTERED
	
 	If nOpc # 5  // Se for exclusao
        If nOpcA == 1 .And. nOpc # 2
            Begin Transaction
                // Gravacao
                Rs200Grava("SZ4",cCodSZ4,cDescSZ4,cTbDest,cCondSZ4)
            End Transaction
        EndIf
    // Se for Exclusao
    ElseIf nOpca = 2 
        Begin Transaction
            Rs200Dele(xFilial("SZ4"),cCodSZ4,cTbDest)
        End Transaction
    EndIf 
    
    oMBrowse:Refresh(.T.)						

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ fLoadCpos ³ Autor ³ Equipe RH         ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta array com cpos adicionais da tb. destino escolhida.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP200                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLoadCpos(cTab)
Local aArea		:= GetArea() 
Local aObgAux   := {}
Local cPosIni	:= ""
Local cPosFim	:= ""	
Local cFormSpc	:= Space(TamSx3("Z4_FORM")[1])
Local nX		:= 0 
Local nPosIni	:= 0
Local nPosFim	:= 0     
	
    
    If !fCompArray(aCols, aCposObgSv)  
    	If !MsgYesNo( OemToAnsi( STR0069 ) , OemToAnsi( STR0068 ) ) //"Aviso"###"Houve alteracoes na definicao do layout. Deseja mesmo alterar a tab. destino?" 	   	   	   						             
			cTbDest := cTbDestSv
			Return							
		EndIf  
    EndIf 
    
    cTbDestSv	:= cTbDest
        
	// Zero arrays
	aCposAdi 	:= {}
	aCposObg	:= {}  
	
	// 1- Legenda     	// 5- Pos. Final
	// 2- Campo			// 6- Formula
	// 3- Descricao		// 7- Ordem de gravacao
	// 4- Pos. Inicial  // 8- Ordem Log

	dbSelectArea("SX3")
	dbSetOrder(1) // X3_ARQUIVO+X3_ORIGEM   
	If SX3->(dbSeek(cTab))
		While SX3->(!Eof()) .And. X3_ARQUIVO == cTab
			// Campos virtuais nao entram 
			If SX3->X3_CONTEXT != "V"
				If aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(SX3->X3_CAMPO)}) == 0 .and. X3Uso(SX3->X3_USADO) .and. X3Obrigat(SX3->X3_CAMPO) 
					AADD(&("aObg"+cTab), { alltrim(SX3->X3_CAMPO),SX3->X3_TAMANHO } ) 
				EndIf 	 
				If aScan(&("aCps"+cTab), {|x| x == AllTrim(SX3->X3_CAMPO)}) == 0 .And. ;
					aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(SX3->X3_CAMPO)}) == 0 .And.;
					X3Uso(X3_USADO)	 // Campos nao usados nao entram		
					AADD(aCposAdi, {oBCpoUser, SX3->X3_CAMPO, SX3->X3_TITULO,0,0,cFormSpc,0,99} )
				EndIf  
				If aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(SX3->X3_CAMPO)}) > 0 				
					AADD(aCposObg, {"", SX3->X3_CAMPO,SX3->X3_TITULO,0,0,cFormSpc,0,99} ) 
				EndIf 	 
			EndIf   
			SX3->(dbSkip())
		End  
	EndIf  
	
	
	// Ordenar array para ficar na mesma ordem que o array aCposObg   
	aObgAux	:= Array(Len(aCposObg),nColObg) 
	For nX := 1 to Len(aCposObg)   		
		nPos := aScan(aCposObg, {|x| AllTrim(x[2]) == &("aObg"+cTab)[nX][1]}) 
		If nPos > 0 		
			aObgAux[nX][1] 	:= aCposObg[nPos][1]	// Legenda 
			aObgAux[nX][2] 	:= aCposObg[nPos][2]	// Campo    
			aObgAux[nX][3] 	:= aCposObg[nPos][3]	// Descricao   
			aObgAux[nX][4] 	:= nPosIni+1			// Pos. Inicial	 
			nPosFim			:= nPosIni + &("aObg"+cTab)[nX][2] 
			aObgAux[nX][5] 	:= nPosFim 				// Pos. Final			
			aObgAux[nX][6] 	:= aCposObg[nPos][6]	// Formula
			aObgAux[nX][7] 	:= aCposObg[nPos][7]	// Ordem de Gravacao
			aObgAux[nX][8] 	:= aCposObg[nPos][8]	// Ordem do Log
			nPosIni 			:= nPosFim		
		EndIf	
	Next nX
	aCposObg := aClone(aObgAux)
	   
	// Atualiza objetos ListBox 
	ASort(aCposAdi,,,{|x,y| x[3] < y[3]}) 	// Ordena pelo nome do campo
	oCposAdi:SetArray( aCposAdi ) 
   	oCposAdi:bLine := { ||  {  oBCpoUser,;
								aCposAdi[oCposAdi:nAt,2],;
							   	aCposAdi[oCposAdi:nAt,3];
							 }; 
						}    
   	aCols:= aClone( aCposObg )  
   	For nX := 1 to Len(aCols) 
   		aCols[nX][1] := "BR_VERMELHO"
   	Next nX
   	oGetObg:Refresh()  
						
	// Faz copia
	aCposAdiSv 	:= aClone(aCposAdi)
	aCposObgSv	:= aClone(aCols)      
	
	   	
RestArea(aArea)
		                                       
Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Rs200MontaCols ³ Autor ³ Equipe RH        ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta aCols com campos obrigatorios.					          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP200 									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function Rs200MontaCols(nOpc,cFiLSZ4,cCodigo,cTabela)      
// Variaveis auxiliares	   
Local aArea		:= GetArea() 
Local aObgAux	:= {}    
Local cFormSpc	:= Space(TamSx3("Z4_FORM")[1])
Local lRetOK 	:= .T.        
Local nX		:= 0

	AADD(aHeader,{"" 	 	, "M200LEG"  , "@BMP"	, 2  , 0 ,  ""			, "" , "C" , ""  }) //Legenda
	AADD(aHeader,{STR0006	, "M200CAM"  , "@!"		, 1  , 0 ,  "! EMPTY()"	, "û", "C" , " " }) //"Campo"
	AADD(aHeader,{STR0012	, "M200DES"  , ""	  	, 12 , 0 ,  " "	     	, "û" ,"C" , " " }) //"Descricao"
	AADD(aHeader,{STR0007	, "M200INI"  , "@E 999"	, 03 , 0 ,  " "     	, "û", "N" , " " }) //"P.Inicio"
	AADD(aHeader,{STR0008	, "M200FIM"  , "@E 999"	, 03 , 0 ,  " "       	, "û", "N" , " " }) //"P.Final"
	AADD(aHeader,{STR0009	, "M200CON"  , "@!"   	, 58 , 0 ,  "A200FORM()", "û", "C" , " " }) //"Formula"
	AADD(aHeader,{"Ordem"	, "M200ORD"  , "@E 99" 	, 02 , 0 ,  " "	        , "û", "N" , " " }) //"Ordem"
	AADD(aHeader,{"Ordem Log","M200ORL"  , "@E 99" 	, 02 , 0 ,  " "	        , "û", "N" , " " }) //"Ordem Log"
	
	If nOpc != 3 // Alteracao, Visualizacao, Exclusao
		// Zero arrays
		aCposAdi := {}
		aCposObg	:= {}  
		 	
		// Carrega todos os campos gravados como obrigatorios
		dbSelectArea("SZ4")    
		If SZ4->(dbSeek(cFiLSZ4 + cCodigo + cTabela))
			While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == cFilSZ4 .And. SZ4->Z4_CODIGO == cCodigo 
			    // Carrega array auxiliar    
				AADD(aCposObg, {oBCpoUser, SZ4->Z4_CPO,fTitulo(AllTrim(SZ4->Z4_CPO)),SZ4->Z4_POSINI,SZ4->Z4_POSFIN,SZ4->Z4_FORM, Z4_ORDEM, Z4_ORDLOG } )						
				SZ4->(dbSkip())
			End 
		EndIf 
		
		// Ordena array de acordo com a ordem de gravacao
		ASort(aCposObg,,,{|x,y| x[7] < y[7]})  
				
		// Carrega campos adicionais que nao foram gravados
		dbSelectArea("SX3")
   		dbSetOrder(1) // X3_ARQUIVO+X3_ORIGEM   
		If SX3->(dbSeek(cTabela))
			While SX3->(!Eof()) .And. X3_ARQUIVO == cTabela   
				If X3Uso(X3_USADO) .And. SX3->X3_CONTEXT != "V" // Campos nao usados e virtuais nao entram			
					If aScan(&("aCps"+cTabela), {|x| AllTrim(x) == AllTrim(SX3->X3_CAMPO)}) == 0 .And. aScan(aCposObg, {|x| AllTrim(x[2]) == AllTrim(SX3->X3_CAMPO)}) == 0 			
						AADD(aCposAdi, {oBCpoUser, SX3->X3_CAMPO, SX3->X3_TITULO,0,0,cFormSpc,0,99} )
					EndIf   
				EndIf   
				SX3->(dbSkip())
			End  
		EndIf  
		
			
		// Caso seja um layout com todos os campos do alias
		If Len(aCposAdi) == 0		
			AADD( aCposAdi, {oBCpoUser,"","",0,0,cFormSpc,0,99 } ) 
	    Else
	    	// Ordena pelo nome do campo
	    	ASort(aCposAdi,,,{|x,y| x[3] < y[3]}) 
		EndIf                                          
		
		// Atualizo aCols com os campos de preenchimento 
		// obrigatorio de acordo com o array aObg+Alias
	   	aCols:= aClone( aCposObg )  
	   	For nX := 1 to Len(aCols)   	   	  
			If aScan(&("aObg"+cTabela), {|x| x[1] == AllTrim(aCols[nX][2])}) > 0 				
				aCols[nX][1] := "BR_VERMELHO" // Legenda para campos de preenchimento obrigatorio
			EndIf   		
	   	Next nX
  							
		// Faz copia
		aCposAdiSv 	:= aClone(aCposAdi)
		aCposObgSv	:= aClone(aCols)
		
	Else // Inclusao
		AADD(aCols,{"BR_VERMELHO", "","",0,0,"",0,99})
	EndIf
	
RestArea(aArea)
	     
Return( lRetOK )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rs200LOk   ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Critica linha digitada.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Rs200LOk()
Local lRet 		:= .T.      
Local nPosCpo	:= GdFieldPos("M200CAM",aHeader) 
Local nLinha	:= oGetObg:oBrowse:nAt  
Local nLinAnt	:= nLinha - 1
	
	If aCols[nLinha,4] > aCols[nLinha,5]
		Help(" ",1,"A200POSIC") // "Posicao final deve ser maior que posicao inicial."
		lRet := .F.
	EndIf 
	
	If aCols[nLinha,4] # 0 .And. aCols[nLinha,5] # 0 .And. !Empty(aCols[nLinha,6]) 
		MsgInfo( OemToAnsi( STR0078 ) , "" ) // "A coluna ref. a Formula nao devera ser preenchida quando as colunas ref. as posicoes com conteudo preenchido." 
		lRet	:= .F.	
	EndIf

Return( lRet )     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rs200TOk   ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Critica todas as linhas digitadas.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Rs200TOk(o)
Local cResp 	:= ""
Local cMsg  	:= STR0032 + Chr(13) + STR0033 
	//STR0032 #Nao foi possivel a inclusao desta variavel, pois existem dados invalidos!
	//STR0033 #Conferir os dados digitados nas colunas: 'P.Inicio' e 'P.Final' ou 'Formula' no campo:
Local lRet  	:= .T.
Local nI    	:= 0 
	
	For nI := 1 To Len (aCols)           
	    
	 	If aCols[nI,4] > aCols[nI,5]  // P. Final > Pos. Inicial. na mesma linha
			lRet := .F.
		EndIf   
		
		If aCols[nI,4] # 0 .And. aCols[nI,5] # 0 .And. !Empty(aCols[nI,6]) // Todas as colunas preenchidas 
			lRet	:= .F.	
		EndIf  
		
		If aCols[nI,4] == 0 .And. aCols[nI,5] == 0 .And. Empty(aCols[nI,6])  // Nenhuma coluna preenchida (validacao apenas no TudOk)
			lRet	:= .F.	
		EndIf
	
		If !lRet 
			cResp := aCols[nI][3] 		
			Exit
		EndIf 							
	Next nI              
	
	If !lRet
		MsgAlert(cMsg + Chr(13) + Chr(13) + cResp)
	EndIf

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fRs200Ok ³ Autor ³ Equipe RH             ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Valida campos da enchoice.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fRs200Ok(nOpc, cCodigo, cCond)
Local aArea	:= GetArea()  
Local lRet	:= .T.

Begin Sequence    
    If nOpc == 3 .Or. nOpc == 4 // Apenas para inclusao e alteracao
		// Codigo devera estar preenchido
		If Empty(cCodigo) 
			Help( ,, OemToAnsi(STR0086),, OemToAnsi(STR0076), 1, 0 ) //"Atenção" ## "Falha na carga de verbas"
			lRet := .F.
			Break
		EndIf 

		// Condicao devera estar preenchido
		If Empty(cCond) 
			Help( ,, OemToAnsi(STR0086),, OemToAnsi(STR0087), 1, 0 ) //"Atenção" ## "Informe a condição de gravação do registro."
			lRet := .F.
			Break
		EndIf 
		
		// Objetos tem que estar preenchidos e com conteudo			
		If ( Len( acPosAdi ) == 1 .And. Empty( aCposAdi[1,2] ) ) .And. ( Len( aCposObg ) == 0 )
			Help( ,, OemToAnsi(STR0086),, OemToAnsi(STR0075), 1, 0 ) //"Atenção" ## "Carregue os campos da tabela destino!"
			lRet := .F.
			Break
		EndIf    
	EndIf
End Sequence

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ gpMvtCpos  ³ Autor ³ Equipe RH        ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua movimentacao de campos entre os listboxes.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP200                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function gpMvtCpos( 	nOrigem,;	// Indenticacao da movimentacao origem
							lUma,;		// Movimenta somente um campo?
							nPosicao,;	// Posicao atual do campo
							cTab	,;	// Tabela destino
							nOpc		)   
Local aOrigem 	:= If( nOrigem == 1, aCposAdi, aCols ) // Array origem da movimentacao
Local aDestino	:= If( nOrigem == 1, aCols, aCposAdi) 	// Array destino da movimentacao 
Local aCposAux	:= {}
Local cCampo	
Local nTamOri	:= Len( aOrigem )						// Tamanho da array de origem
Local nI												// Variavel para loop
	
	
	// Retorna caso esteja tentando mover de um objeto vazio				
	If ( Len( aOrigem ) == 1 .And. Empty( aOrigem[1,2] ) ) .Or. ( Len( aOrigem ) == 0 )
		Return .T.
	EndIf
	
	// Caso o objeto destino esteja vazio, exclui o elemento vazio
	If Len( aDestino ) == 1 .And. Empty( aDestino[1,1] )
		ADel( aDestino, 1 )
		ASize( aDestino, Len( aDestino ) - 1 )
	EndIf
	             
	// Caso objeto seja o dos campos obrigatorios e esteja
	// tentando mover campo obrigatorio, proibe
	cCampo	:= aOrigem[nPosicao,2]	// Campo a ser movida    
	If nOrigem == 2
		If aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(cCampo)}) > 0 .And. aOrigem[nPosicao,1] == "BR_VERMELHO"		
			MsgAlert( OemToAnsi( STR0070 ) , OemToAnsi( STR0068 ) )  // "Aviso"###"#"Nao e possivel mover campos obrigatorios determinados pelo sistema!"
			Return .T.
		EndIf  
	EndIf  
	  

	// Inclui na ListBox destino e exclui da origem	
	If lUma        
		aDestino	:= If(Empty(aDestino[1][2]), Eval({||ADel( aDestino, 1 ),ASize( aDestino, Len( aDestino ) - 1 )}), aDestino)
		
		/// Remocao de campos adicionais da estrutura original
		If nOpc  == 4 // Alterecao  
			If nOrigem == 2   
				// Guarda campo para exclusao
				AADD(aDelCpos , aOrigem[nPosicao][2] )
			EndIf
		EndIf 
		
		AADD( aDestino, aOrigem[nPosicao] )
		ADel( aOrigem, nPosicao )
		ASize( aOrigem, nTamOri - 1 )
	Else       
		If nOrigem == 1
			nQtde		:= 1
		Else         
			nQtde 	:= Len(&("aObg"+cTab))+1 
			If (nQtde > Len(aCols))
				Return .F.
			EndIf
		EndIf  
		aDestino	:= If(Empty(aDestino[1][2]), Eval({||ADel( aDestino, 1 ),ASize( aDestino, Len( aDestino ) - 1 )}), aDestino)	  
		For nI = nQtde To nTamOri
			AADD( aDestino, aOrigem[nI] )
		Next   
		If nOrigem == 1                                    
			aOrigem := {} 
		Else      
			For nI := nQtde To nTamOri  
				// Remocao de campos adicionais da estrutura original
			  	If nOpc  == 4 // Alterecao  
					If nOrigem == 2   
						// Guarda campo para exclusao
						AADD(aDelCpos ,aOrigem[nQtde][2] )
					EndIf
				EndIf 
				ADel( aOrigem, nQtde )
				ASize( aOrigem, Len(aOrigem) - 1 )
			Next 
		EndIf
	EndIf
	
	// Caso a ListBox origem tenha ficado vazia, inclui um elemento.			
	If Len( aOrigem ) == 0  
		AADD( aOrigem, {oBCpoUser,"","",0,0,"","1",99,.F. } ) 
	EndIf   
	
	If nOrigem <> 2  // Nao altera a ordem imposta nos campos obrigatorios
		ASort( aOrigem , , , { |x,y| x[3] < y[3] } )  
	EndIf
	
	// Posiciona o ListBox destino na verba movida a partir da orig.	
	If lUma
		If Len(aDestino) > 0
			If( nOrigem == 1, oGetObg:oBrowse:nAt := 1, oCposAdi:nAt := 1 )
		EndIf
	EndIf
	
	// Retorna o conteudo original da ListBox
	aCposAdi	:= If( nOrigem == 1, aOrigem, aDestino )  
	// Retoarna o conteudo original da GetDados
	aCposAux	:= If( nOrigem == 1, aDestino, aOrigem )
	
	// Atualiza ListBox						
	oCposAdi:AArray		:= aCposAdi
	// Atualiza GetDados
	aCols	:= aCposAux 
		

Return ( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rs200Leg    ³ Autor ³ Equipe RH          ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda de selecao de campo.			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Rs200Leg() 
Local aArea := GetArea()
           //"Importacao de Variaveis" //"Definicao dos campos:"
BrwLegenda(STR0005,STR0073, {	{"BR_VERDE"		, OemToAnsi(STR0072)},; //"Campos obrigatorios definidos pela rotina."
								{"BR_VERMELHO"	, OemToAnsi(STR0071)}}) //"Campos adicionais definidos pela rotina."
									
RestArea(aArea)
									
Return()


/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rs200Grava ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava layout de importacao de variaveis.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Rs200Grava(cAlias,cCodigo,cDesc,cTab,cCond) 
Local aArea		:= GetArea()
Local nX 		:= 0
  	
	Begin Transaction
		dbSelectArea("SZ4") 
		SZ4->( dbSetOrder( 1 ) )  // Z4_FILIAL + Z4_CODIGO + Z4_TBDEST + Z4_CPO
		
		For nX := 1 to Len(aCols)
		
			If !(dbSeek( xFilial("SZ4")+cCodigo+cTab+aCols[nX][2] )) 
				RecLock(cAlias,.T.,.T.)  // Inclui 	
			Else
				RecLock(cAlias,.F.,.T.)  // Altera
			EndIf
					
			SZ4->Z4_FILIAL :=	xFilial("SZ4")
			SZ4->Z4_CODIGO :=	cCodigo
			SZ4->Z4_DESC 	:=	cDesc
			SZ4->Z4_TBDEST :=	cTab
			SZ4->Z4_COND 	:=	cCond
			
			SZ4->Z4_CPO    := aCols[nX][2]  // Campo
			SZ4->Z4_POSINI := aCols[nX][4]  // Formula
			SZ4->Z4_POSFIN := aCols[nX][5]  // Pos. Inicial
			SZ4->Z4_FORM   := aCols[nX][6]  // Pos. Final  
			SZ4->Z4_ORDEM  := nX
			SZ4->Z4_ORDLOG := aCols[nX][8]  // Ordem Log
			
			MsUnlock()
			           
		Next nX    
		
		// Deleta itens
		For nX := 1 to Len(aDelCpos)  
			If dbSeek( xFilial("SZ4")+cCodigo+cTab+aDelCpos[nX] )   
				RecLock("SZ4",.F.,.T.)
				dbDelete()
				MsUnlock() 	
			EndIf
		Next nX
		
	End Transaction 
	
	RestArea(aArea)
	
Return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rs200Dele ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Deleta os registros de Import.Variaveis.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Rs200Dele(cFiLSZ4,cCodigo,cTabela)
Local aArea	:= GetArea()   

	Begin Transaction
		dbSelectArea("SZ4") 
		SZ4->( dbSetOrder( 1 ) )  // Z4_FILIAL + Z4_CODIGO + Z4_TBDEST + Z4_CPO 
		If SZ4->(dbSeek(cFiLSZ4 + cCodigo + cTabela))
			While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == cFilSZ4 .And. SZ4->Z4_CODIGO == cCodigo .And. SZ4->Z4_TBDEST == cTabela
				RecLock("SZ4",.F.,.T.)
				dbDelete()
				MsUnlock() 			    			
				SZ4->(dbSkip())
			End 
		EndIf 
				
		WriteSx2(cTabela) 
		   
	End Transaction   

RestArea(aArea)

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fValidCod ³ Autor ³ Equipe RH            ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida se codigo ja foi cadastrado.		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RSP200                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fValidCod(cCodigo)
Local aArea		:= GetArea()
Local lRet 		:= .T.

		dbSelectArea("SZ4") 
		SZ4->( dbSetOrder( 1 ) )  // Z4_FILIAL + Z4_CODIGO + Z4_TBDEST + Z4_CPO  
		If SZ4->(dbSeek(xFilial("SZ4") + cCodigo))
			While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == xFilial("SZ4") .And. SZ4->Z4_CODIGO == cCodigo 
				lRet := .F.
				Exit		    			
				SZ4->(dbSkip())
			End 
		EndIf 
	
	If !lRet	
   		MsgAlert( OemToAnsi( STR0003 ) , OemToAnsi( STR0068 ) )  // "Aviso"###"#"Codigo ja cadastrado"   
 	EndIf

RestArea(aArea)

Return( lRet )   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ MenuDef  ³Autor  ³ Equipe RH          ³Data  ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Isola opcoes de menu para que as opcoes da rotina possam   º±±
±±º          ³ ser lidas pelas bibliotecas Framework da Versao 9.12.      º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRotina                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP200                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function MenuDef()	 
							
	Local aRotina :=  { 	{ STR0058, 'PesqBrw'    , 0, 1 , ,.F. },;	// Pesquisar 
						    { STR0059, 'U_RSP200Atu', 0, 2 },;			// Visualizar
							{ STR0036, 'U_RSP200Atu', 0, 3 },;			// Incluir   
							{ STR0037, 'U_RSP200Atu', 0, 4 },;			// Alterar						
							{ STR0038, 'U_RSP200Atu', 0, 5 };	 		// Excluir
						 } 	

Return aRotina