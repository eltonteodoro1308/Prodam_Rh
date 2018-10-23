#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRPONR01
Permite a visualização do Espelho do ponto pelo meno do ponto eletrônico
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function PRPONR01()
Local oExecView 	:= FWViewExec():New()
Private oTIBrowser  := NIL
Private cDirHtml	:= TRIM(SuperGetMv("PR_DIRPON",.F.,"C:\Ponto.html")) 

dbselectarea("SRA")
oExecView:setTitle("Relatório")
oExecView:setSource("PRPONR01")
oExecView:setModal(.F.)               
oExecView:setOperation(1)
oExecView:openView(.T.)

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Rotina de definição do menu
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" ACTION "AxPesqui" OPERATION 1	ACCESS 0 		
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.PRPONR01" OPERATION 2	ACCESS 0

Return(aRotina)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Rotina de definição do MODEL
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function ModelDef()
Local oStruZZA 	:= FWFormStruct(1, "SRA")
Local oModel   	:= MPFormModel():New( "P16R01MD", /*bPreValidacao*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ )

oModel:AddFields("SRAMASTER", /*cOwner*/, oStruZZA)
oModel:SetPrimaryKey({"RA_FILIAL","RA_MAT"})
oModel:SetDescription("Espelho do ponto")

Return oModel
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Rotina de definição do VIEW
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function ViewDef()
Local oView    := FWFormView():New()  
Local oModel   := FWLoadModel("PRPONR01") 
         	
oView:SetModel(oModel)         	
oView:AddOtherObject('PNL_SUP',{|OtherObj| P16R01OTH(1,OtherObj) },{|| },{||})
oView:AddOtherObject('PNL_INF',{|OtherObj| P16R01OTH(2,OtherObj) },{|| },{||})
oView:CreateHorizontalBox("SUPERIOR", 10)
oView:CreateHorizontalBox("INFERIOR", 90)
oView:CreateFolder( 'FOLDER_PL', 'INFERIOR')

oView:AddSheet('FOLDER_PL','VIEW_ESP','Espelho do ponto')
oView:CreateHorizontalBox( 'BOXFORM7', 100, /*owner*/, /*lUsePixel*/, 'FOLDER_PL', 'VIEW_ESP')
oView:SetOwnerView('PNL_INF','BOXFORM7')
oView:SetOwnerView("PNL_SUP", "SUPERIOR")

Return oView
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R01OTH
Monta relatório espelho do ponto
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P16R01OTH(nOpc,OtherObj)
local aPerApont	:= {}
local aSitApont	:= {} 
local cPerApont	:= ""
local cSitApont	:= ""
local cMatric	:= SPACE(TAMSX3("RA_MAT")[1])
local cNomeFun	:= ""
local oPerApont
local oSitApont
local oBut

IF nOpc == 1
	AADD(aSitApont,"SOLICITAÇÕES PENDENTES COM O GESTOR")
	AADD(aSitApont,"SOLICITAÇÕES PENDENTES COM A GFD")
	AADD(aSitApont,"SOLICITAÇÕES ATENDIDAS")
	AADD(aSitApont,"SOLICITAÇÕES REPROVADAS")
	AADD(aSitApont,"TODAS AS SOLICITAÇÕES")
	AADD(aSitApont,"FALTA MARCAÇÃO/AUSÊNCIAS")
	AADD(aSitApont,"TODAS AS MARCAÇÕES")
	
	cSitApont:= "TODAS AS MARCAÇÕES"
	aPerApont:= P16R01QUA(DDATABASE)
	
	IF !EMPTY(aPerApont)
		cPerApont:= aPerApont[1] 
		@002,010 SAY "Matricula:" OF OtherObj PIXEL
		@002,035 MSGET oGet VAR cMatric F3 "SRA" size 050,06 OF OtherObj PIXEL VALID P16R01VLD(cMatric,@cNomeFun) 
		@002,100 SAY "Nome:" OF OtherObj PIXEL
		@002,120 MSGET oGet VAR cNomeFun WHEN .F. size 150,06 OF OtherObj PIXEL 
		@015,010 SAY "Período:" OF OtherObj PIXEL
		@014,035 COMBOBOX oPerApont VAR cPerApont ITEMS aPerApont SIZE 100,10 OF OtherObj PIXEL
		@014,140 COMBOBOX oSitApont VAR cSitApont ITEMS aSitApont SIZE 100,10 OF OtherObj PIXEL
		@014,280 BUTTON oBut PROMPT "Gerar" action(P16R01HTM(SRA->RA_FILIAL,SRA->RA_MAT,;
			cPerApont,CVALTOCHAR(ASCAN(aSitApont,{|x| x==cSitApont}))))  OF OtherObj PIXEL
	ENDIF	
ELSE	            
	oTIBrowser := TIBrowser():New(0,0,260,170, "",OtherObj)
	oTIBrowser:align:= CONTROL_ALIGN_ALLCLIENT
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R01VLD
Valida o campo matricula
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P16R01VLD(cMatric,cNomeFun)
LOCAL lRet:= .T.

DBSELECTAREA("SRA")
SRA->(DBSETORDER(1))
IF SRA->(DBSEEK(XFILIAL("SRA")+cMatric))
	cNomeFun	:= SRA->RA_NOME
ELSE
	MSGALERT("Matricula "+cMatric+" não localizada!")
	lRet		:= .F.
	cNomeFun	:= ""
ENDIF

RETURN lRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R01OTH
Monta demonstrativo
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P16R01HTM(cFilTerminal,cMatTerminal,cPerAponta,cSitApo)
Local  cTextHtml 		:= ""
Local  cLinkDetalhes	:= ""

cPerAponta:= DTOS(CTOD(LEFT(cPerAponta,10)))+DTOS(CTOD(RIGHT(cPerAponta,10)))


cTextHtml+='<?xml version="1.0" encoding="iso-8859-1"?>'+CRLF
cTextHtml+='<html>'+CRLF
cTextHtml+='	<head>'+CRLF
cTextHtml+='		<title></title>'+CRLF
cTextHtml+='		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'+CRLF	 	
cTextHtml+='		<style>'+CRLF
cTextHtml+='			.R01 {'+CRLF
cTextHtml+='				background:#ffffff;'+CRLF
cTextHtml+='				}'+CRLF
cTextHtml+='			.R02 {'+CRLF
cTextHtml+='				border-top: 1px solid black;'+CRLF
cTextHtml+='				border-left: 1px solid black;'+CRLF
cTextHtml+='				border-right: 1px solid black;'+CRLF
cTextHtml+='				border-bottom: 1px solid black;'+CRLF
cTextHtml+='				}'+CRLF
cTextHtml+='			.R03 {'+CRLF
cTextHtml+='				background:#c4c0b9;'+CRLF
cTextHtml+='				text-align: left;	'+CRLF
cTextHtml+='				}'+CRLF
cTextHtml+='			.B01 {'+CRLF
cTextHtml+='				background-color: #8c9cbf;'+CRLF
cTextHtml+='				border: 1px solid #172d6e;'+CRLF
cTextHtml+='				border-bottom: 1px solid #0e1d45;'+CRLF
cTextHtml+='				border-radius: 5px;'+CRLF
cTextHtml+='				box-shadow: inset 0 1px 0 0 #b1b9cb;'+CRLF
cTextHtml+='				color: #fff;'+CRLF
cTextHtml+='				font: bold 14px/1 "helvetica neue", helvetica, arial, sans-serif;'+CRLF
cTextHtml+='				padding: 7px 0 8px 0;'+CRLF
cTextHtml+='				text-decoration: none;'+CRLF
cTextHtml+='				text-align: center;'+CRLF
cTextHtml+='				text-shadow: 0 -1px 1px #000f4d;'+CRLF
cTextHtml+='				width: 100px;'+CRLF
cTextHtml+='				height:30px;'+CRLF
cTextHtml+='				margin: 3px;'+CRLF	
cTextHtml+='			}'+CRLF	
cTextHtml+='			.B02 {'+CRLF
cTextHtml+='				background-color: #8c9cbf;'+CRLF
cTextHtml+='				border: 1px solid #172d6e;'+CRLF
cTextHtml+='				border-bottom: 1px solid #0e1d45;'+CRLF
cTextHtml+='				border-radius: 5px;'+CRLF
cTextHtml+='				box-shadow: inset 0 1px 0 0 #b1b9cb;'+CRLF
cTextHtml+='				color: #fff;'+CRLF
cTextHtml+='				font: bold 14px/1 "helvetica neue", helvetica, arial, sans-serif;'+CRLF
cTextHtml+='				padding: 7px 0 8px 0;'+CRLF
cTextHtml+='				text-decoration: none;'+CRLF
cTextHtml+='				text-align: center;'+CRLF
cTextHtml+='				text-shadow: 0 -1px 1px #000f4d;'+CRLF
cTextHtml+='				width: 150px;'+CRLF
cTextHtml+='				height:30px;'+CRLF
cTextHtml+='				margin: 2px;'+CRLF	
cTextHtml+='			}'+CRLF	
cTextHtml+='			.B03 {'+CRLF  
cTextHtml+='				height:15px;'+CRLF
cTextHtml+='				width:15px;'+CRLF			
cTextHtml+='				margin: 4px;'+CRLF
cTextHtml+='			}'+CRLF	
cTextHtml+='	  		.LinkDetalhes{'+CRLF
cTextHtml+='				background:#c4c0b9;'+CRLF
cTextHtml+='				background-color: #c4c0b9;'+CRLF
cTextHtml+='				color: BLACK;'+CRLF
cTextHtml+='				text-decoration: none;'+CRLF
cTextHtml+='				display: inline-block;'+CRLF
cTextHtml+='				width: 100%;'+CRLF
cTextHtml+='			}'+CRLF						
cTextHtml+='	  		.MsgErro{'+CRLF
cTextHtml+='				color: #FF0000;'+CRLF
cTextHtml+='				text-decoration: none;'+CRLF
cTextHtml+='				text-align: left;'+CRLF 
cTextHtml+='				vertical-align: middle;'+CRLF
cTextHtml+='				font-weight: normal;'+CRLF
cTextHtml+='				background: #FFE4C4;'+CRLF
cTextHtml+='				display: block;'+CRLF
cTextHtml+='				border: thin dashed #000000;'+CRLF 
cTextHtml+='				padding: 20px;'+CRLF
cTextHtml+='				width: 100%;'+CRLF
cTextHtml+='				height:10px;'+CRLF
cTextHtml+='	  		}'+CRLF
cTextHtml+='		</style>'+CRLF
cTextHtml+='		<script language="Javascript">'+CRLF
cTextHtml+='			function ExpandirTodos(DetTotal) {'+CRLF
cTextHtml+='				var nTotalDetalhes	= parseInt(DetTotal)+1;'+CRLF
cTextHtml+='				for (i = 1; i < nTotalDetalhes; i++) {'+CRLF
cTextHtml+='    				Detalhes(i.toString(),true);'+CRLF	
cTextHtml+='				}'+CRLF
cTextHtml+='			}'+CRLF
cTextHtml+='			function Detalhes(IndDet,ExpandirTodos) {'+CRLF
cTextHtml+="				var LinkDetalhes='';"+CRLF
cTextHtml+='				if (ExpandirTodos){'+CRLF

cLinkDetalhes:= "LinkDetalhes='<a href="
cLinkDetalhes+= '"javascript:Detalhes('
cLinkDetalhes+= "'+ IndDet +');"
cLinkDetalhes+= '"  class="LinkDetalhes">'
cLinkDetalhes+= "<b>Ocultar</b></a>';"

cTextHtml+='					'+cLinkDetalhes + CRLF

cTextHtml+='					document.getElementById("Detalhes"+IndDet).style.display = "block";'+CRLF
cTextHtml+='					document.getElementById("ButDet"+IndDet).innerHTML= LinkDetalhes;'+CRLF				
cTextHtml+='				}else{'+CRLF
cTextHtml+='					if (document.getElementById("Detalhes"+IndDet).style.display == "block"){'+CRLF

cLinkDetalhes:= "LinkDetalhes='<a href="
cLinkDetalhes+= '"javascript:Detalhes('
cLinkDetalhes+= "'+ IndDet +');"
cLinkDetalhes+= '"  class="LinkDetalhes">'
cLinkDetalhes+= "<b>Exibir</b></a>';"


cTextHtml+='					'+cLinkDetalhes + CRLF

cTextHtml+='						document.getElementById("Detalhes"+IndDet).style.display = "none";'+CRLF
cTextHtml+='						document.getElementById("ButDet"+IndDet).innerHTML= LinkDetalhes;'+CRLF
cTextHtml+='					}else{'+CRLF

cLinkDetalhes:= "LinkDetalhes='<a href="
cLinkDetalhes+= '"javascript:Detalhes('
cLinkDetalhes+= "'+ IndDet +');"
cLinkDetalhes+= '"  class="LinkDetalhes">'
cLinkDetalhes+= "<b>Ocultar</b></a>';"

cTextHtml+='					'+cLinkDetalhes + CRLF

cTextHtml+='						document.getElementById("Detalhes"+IndDet).style.display = "block";'+CRLF
cTextHtml+='						document.getElementById("ButDet"+IndDet).innerHTML= LinkDetalhes;'+CRLF
cTextHtml+='					}'+CRLF
cTextHtml+='				}'+CRLF
cTextHtml+='			}'+CRLF
cTextHtml+='		</script>'+CRLF	 			
cTextHtml+='	</head>'+CRLF
cTextHtml+='<body>'+CRLF
cTextHtml+='	<form name="form" role="form">'+CRLF

oObj := WSPRESPPON():New()

MsgRun( "Gerando espelho do ponto, aguarde...", "Processando",; 
	{|| oObj:GETESPBH("1",cFilTerminal,cMatTerminal,cPerAponta,cSitApo) , cTextHtml += Decode64(oObj:CGETESPBHRESULT)  } )

//MsgRun( "Gerando espelho do ponto, aguarde...", "Processando",; 
//	{|| cTextHtml += STATICCALL(PRESPPON,P16R02RUN,"1",.T.,cFilTerminal,cMatTerminal,cPerAponta,cSitApo)  } )


cTextHtml+='	</form>'+CRLF	
cTextHtml+='</body>'+CRLF
cTextHtml+='</html>'+CRLF

MemoWrite( cDirHtml , cTextHtml )

IF FILE(cDirHtml)
	oTIBrowser:Navigate( cDirHtml )
ELSE
	ALERT("Problema para gerar o espelho do ponto, contate o administrador do sistema!")
ENDIF
	
RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R01IMP
Rotina de impressão do espelho do ponto
@author  	Carlos Henrique
@since     	27/01/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P16R01IMP()
Local cHtmlImp	:= ""

IF FILE(cDirHtml)
	cHtmlImp:= MemoRead(cDirHtml,.F.)	
	cHtmlImp+='<SCRIPT LANGUAGE="JavaScript">'
	cHtmlImp+='window.print()'
	cHtmlImp+='</SCRIPT>'
	
	MemoWrite( cDirHtml , cHtmlImp )
	
	IF FILE(cDirHtml)
		ShellExecute( "Open", cDirHtml , "", "C:\", 1 )
	ENDIF
ELSE
	msgalert("O demonstrativo não foi gerado, verifique!")
	return		
ENDIF	

Return NIL
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P16R01QUA
Monta os quadrimestres
@author  	Carlos Henrique 
@since     	06/05/2016
@version  	P.12.6     
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P16R01QUA(dDataAtu)
Local cPAPONTA:= TRIM(STRTRAN(SuperGetMV("MV_PAPONTA",,""),"/",""))
Local aRet		:= {}
local cDiaIni	:= LEFT(cPAPONTA,2)
local cDiaFim	:= RIGHT(cPAPONTA,2)
LOCAL nMes  	:= Month(dDataAtu)+1
LOCAL AnoAtu  := Year(dDataAtu)
LOCAL AnoAnt1 := AnoAtu-1
LOCAL AnoAnt2 := AnoAtu-2
LOCAL aAuxPer	:= {}
			
IF (nMes >= 1 .AND. nMes <= 4)

	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))  
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt2) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAnt1))

ELSEIF (nMes >= 5 .AND. nMes <= 8)

	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAnt1))	
					
ELSEIF (nMes >= 9 .AND. nMes <= 12)

	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAnt1))	
		
ELSEIF (nMes == 13)//Tratamento para o mes de dezembro
	
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAtu) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu+1)) 
	AADD(aRet,cDiaIni+'/08/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/12/'+ CVALTOCHAR(AnoAtu)) 
	AADD(aRet,cDiaIni+'/04/'+ CVALTOCHAR(AnoAtu)  +' -- '+cDiaFim+'/08/'+ CVALTOCHAR(AnoAtu))
	AADD(aRet,cDiaIni+'/12/'+ CVALTOCHAR(AnoAnt1) +' -- '+cDiaFim+'/04/'+ CVALTOCHAR(AnoAtu))	
	
ENDIF
			
RETURN aRet