#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100102()

@Project     MAN00000011501_EF_001
@author      Jackson Capelato
@since       21/09/2015
@version     P12.5
@Return      Cadastro tabela PA1
@obs         Cadastro de Referência de Gratificação de Função
@menu        Cadastro de Referência de Gratificação de Função
/*/

User function F0100102()
Local oBrwRB0

oBrwRB0:= FwmBrowse():New()
oBrwRB0:SetAlias( 'PA1' )
oBrwRB0:SetDescription( "Cadastro de Referência de Gratificação de Função" )

oBrwRB0:Activate()

Return NIL


Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.F0100102'	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"		ACTION 'VIEWDEF.F0100102'	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"		ACTION 'VIEWDEF.F0100102'	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"		ACTION 'VIEWDEF.F0100102'	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Reajuste"		ACTION 'u_F0100103()'     	OPERATION 2 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruRB0 	:= FWFormStruct( 1, 'PA1')
Local oModel

oModel := MPFormModel():New('M0100102')
oModel:AddFields( 'PA1MASTER',, oStruRB0)
oModel:SetDescription(  "Cadastro de Referência de Gratificação de Função" )
oModel:GetModel( 'PA1MASTER' ):SetDescription(  "Cadastro de Referência de Gratificação de Função" )
oModel:SetPrimaryKey( { } )

Return oModel


Static Function ViewDef()

Local oModel	:= FWLoadModel( 'F0100102' )
Local oStruRB0 	:= FWFormStruct( 2, 'PA1' )
Local oView

oView := FWFormView():New()
oView:SetModel( oModel )
oView:AddField( 'VIEW_PA1', oStruRB0, 'PA1MASTER' )
oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_PA1', 'TELA' )
oView:setCloseOnOk({|| .t.})

Return oView

/*/ {Protheus.doc} f0100103()
Realiza o Reajuste
@Project     MAN00000011501_EF_001
@author      Jackson Capelato
@since       21/09/2015
@version     P12.5
/*/

User Function F0100103()
Local oReport

Local aArea      := GetArea()
Local aAreaPA1	:= PA1->( GetArea() )

Pergunte("FSW0100102",.T.)

If mv_par02 = 1
	DbselectArea('PA1')
	PA1->(Dbsetorder(1))
	Dbgotop()

	Do While !eof()

		RecLock('PA1',.F.)
		PA1->PA1_VLNIV1 := PA1->PA1_VLNIV1*((mv_par01/100)+1)
		PA1->PA1_VLNIV2 := PA1->PA1_VLNIV2*((mv_par01/100)+1)
		PA1->PA1_VLMIN  := PA1->PA1_VLMIN *((mv_par01/100)+1)
		PA1->( MsUnLock() )

		PA1->(DBSKIP())

	Enddo
else
	oReport := ReportDef()
	oReport:PrintDialog()
endif


RestArea( aArea )
RestArea( aAreaPA1 )

Return

Static Function ReportDef()

Local oReport
Local oSection1

oReport:=TReport():New("F0100103",'Tabela de Gratificações de Funções',"",{|oReport| PrintReport(oReport)},'')
oReport:SetPortrait()

oSection1 := TRSection():New(oReport,'Gratificações',{"PA1"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderBreak(.T.)

TRCell():New(oSection1,"PA1_GRUPO"  ,"PA1","GRUPO"          ,"9999"       ,,,{|| PA1->PA1_GRUPO  })
TRCell():New(oSection1,"PA1_VLNIV1" ,"PA1","NIVEL 1"        ,"9999,999.99",,,{|| PA1->PA1_VLNIV1*((mv_par01/100)+1) })
TRCell():New(oSection1,"PA1_VLNIV2" ,"PA1","NIVEL 2"        ,"9999,999.99",,,{|| PA1->PA1_VLNIV2*((mv_par01/100)+1) })
TRCell():New(oSection1,"PA1_VLMIN"  ,"PA1","VALOR MINIMO"   ,"9999,999.99",,,{|| PA1->PA1_VLMIN *((mv_par01/100)+1) })
TRCell():New(oSection1,"PA1_PERNIV" ,"PA1","% ENTRE NIVEIS" ,"999.9999"   ,,,{|| PA1->PA1_PERNIV })
TRCell():New(oSection1,"PA1_PERFUN" ,"PA1","% ENTRE FUNCOES","999.9999"   ,,,{|| PA1->PA1_PERFUN })

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

Local nPos		:= 0

oReport:SetTitle('Reajuste Tabela de Gratificações de Funções')

dbSelectArea("PA1")
dbGotop()

DO While PA1->( !Eof() )

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:Init()
	oSection1:PrintLine()

	oreport:Thinline()
	oSection1:Finish()
	dbSelectArea("PA1")
	PA1->(dbSkip())
EndDo

Return
