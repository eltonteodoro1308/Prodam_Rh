#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} f0100801()
 
@Project     MAN00000011501_EF_008     
@author      Jackson Capelato
@since       17/09/2015
@version     P12.5
@Return      Atualização de campos
@Obs         Funcao chamada do ponto de entrada gpe020grv para atualizar os dependentes qto auxilio enxoval.
/*/

user function f0100801()

Local cMat
Local nSalario
Local lEleg
Local cGrauParent
Local cTipo
Local cTabela
Local cNivel
Local cFaini
Local cFafin
Local nX		 := 0
Local nBeneficio := 0
Local nPercet 	 := 0
Local nValin 	 := 0
Local nValfi 	 := 0
Local nTLines	 := 0

Local oModel := FWModelActive()

Local nOperacao  := oModel:GetOperation()
Local oGrid 	 := oModel:GetModel("GPEA020_SRB")
Local oStruct    := oGrid:GetStruct()
Local aCols		 := oStruct:GetFields()
Local nDepIr 	 := 0
Local nDepSf  	 := 0
Local aSaveLines := FWSaveRows( oModel )
Local aArea      := GetArea()
Local aAreaSRA	:= SRA->( GetArea() )
Local aAreaRB6	:= RB6->( GetArea() )

cMat        := SRA->RA_MAT

cTabela	    := ftabela("U051",01,05)
cNivel      := ftabela("U051",01,06)
cFaini      := ftabela("U051",01,07)
cFafin      := ftabela("U051",01,08)
nPercet     := ftabela("U051",01,09)

//-- Retirado. Deve ser considerado somente o teto.
//Dbselectarea("RB6")
//RB6->(Dbsetorder(1))
//RB6->(Dbseek(xfilial("RB6")+cTabela+cNivel+cFaini))
//
//nValin:=RB6->RB6_VALOR

Dbselectarea("RB6")
RB6->(Dbsetorder(1))
RB6->(Dbseek(xfilial("RB6")+cTabela+cNivel+cFafin))

nValfi:=RB6->RB6_VALOR

Dbselectarea("SRA")
SRA->(Dbseek(xfilial("SRA")+cMat))
nSalario := SRA->RA_SALARIO

nTLines	:= oGrid:Length()

oGrid:GoLine(1)  

For nX := 1 to nTLines
	
	oGrid:GoLine(nX)

	nLine := oGrid:GetLine()
	
	If !(oGrid:IsDeleted( nLine ))
		If oGrid:GetValue("RB_GRAUPAR", nLine ) == "F"  .and. (nSalario>=nValin .and. nSalario<=nValfi) .and. !(oGrid:GetValue("RB_XPAGENX",  nLine ) $ ('123'))
			nBeneficio  := nValfi*(nPercet/100)
			oGrid:SetValue("RB_XENXOV" ,nBeneficio)
			oGrid:SetValue("RB_XPAGENX",'3')
		ElseIf oGrid:GetValue("RB_GRAUPAR", nLine ) == "F"  .and. !(nSalario>=nValin .and. nSalario<=nValfi) .and. !(oGrid:GetValue("RB_XPAGENX",  nLine ) $ ('123'))
			oGrid:SetValue("RB_XPAGENX",'2')
		ElseIf oGrid:GetValue("RB_GRAUPAR", nLine ) # "F" 
			oGrid:SetValue("RB_XPAGENX",'2')
		Endif
	Endif
Next

oView := FwViewActive()
oView:Refresh()

RestArea( aArea	   )
RestArea( aAreaSRA )
RestArea( aAreaRB6 )

return
