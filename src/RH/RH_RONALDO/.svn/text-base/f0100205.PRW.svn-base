#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*/ {Protheus.doc} f0100205()

@Project     MAN00000011501_EF_002
@author      Jackson Capelato        
@since       21/09/2015
@version     P12.5
@Return      Tela de lançamento de gratificações avulsas RGB
@Obs         Tela de lançamento de gratificações avulsas RGB
@menu        Tela de lançamento de gratificações avulsas RGB
/*/
User Function F0100205()

Local cFilSRV	:= xFilial("SRV")
Local aIndexSRV	:= {}  
Local cFiltraSRV:= "SRV->RV_COD = cVERBA "

Private aCRA		:= { "Confirma" , "Redigita" , "Abandona"}  
Private aColsAnt	:= {}
Private bFiltraBrw	:= {|| NIL }		
Private cDigLancam	:= Upper( AllTrim( GetMv("MV_DIGLANC") ) )
Private cDigHoras	:= Upper( AllTrim( GetMv("MV_HORASDE") ) )
Private cLancDemi	:= Upper( AllTrim( GetMv("MV_DEMISRC") ) )
Private lInclu		:= .F.
Private lSRCLock	:= .F.
Private aArray      := {}
Private cLancAlias  := "RGB"
Private aRotina := MenuDef() 					
Private cCadastro := OemToAnsi("Lancamentos Gratificações Avulsas")  
Private lSetF3		:= .F.	
Private cVERBA := 	ftabela('U050',02,06)					

If !ChkVazio("SRV")
	Return( NIL )
Endif

aArray := {"SRV","SRA", "RGB" }                                            
ffiltro("F0100205",aArray, 2)

ffiltro("F0100205",aArray, 1 /* Exec Filtro*/, 1 /*Inicio*/, 1/*Fim*/)
	
dbSelectArea("SRV") 
If (ValType(SRV->RV_LEEINC) != "U")
	bFiltraBrw 	:= {|| FilBrowse("SRV",@aIndexSRV,@cFiltraSRV) }
	Eval(bFiltraBrw)
EndIf

mBrowse( 6, 1,22,75,"SRV") 

dbSelectArea("RGB")
RGB->(dbSetOrder(1))

ffiltro("F0100205",aArray,0)	

Return
	         
Static Function MenuDef()
	Local aRotina :=  	{}
	 
	aAdd( aRotina, { "Pesquisar" , "PesqBrw" , 0 , 1} )  	//
	aAdd( aRotina, { "Visualizar" , "Gp100Mnt", 0 , 2} )  	//
	aAdd( aRotina, { "Atualizar" , "Gp100Mnt", 0, 4} )  	    //
	aAdd( aRotina, { "Excluir" , "Gp100Mnt", 0 , 5} )  	//

Return aRotina

