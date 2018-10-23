
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RH_CONTAB ³ Autor ³ Equipe TOTVS          ³ Data ³ 99.99.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para busca de Contas Contabeis a partir do cadastro ³±±
±±³          ³ de Verbas.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//***********
//* Debito  *
//***********
User Function deb_rh_contabil()

	cGrupo := ""
	cConta := space(10)  
	
	If SRA->RA_PROCES = "00001"	.or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBITO")
	EndIf
	If SRA->RA_PROCES = "00005"	
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT5")
	EndIf
	If SRA->RA_PROCES = "00006"	
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT6")
	EndIf
	If SRA->RA_PROCES = "00007"	
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
	
return(cConta)    


//***********
//* Credito *
//***********
User Function cre_rh_contabil()

	cGrupo := ""
	cConta := space(10)

	If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDIT")
	EndIf
	If SRA->RA_PROCES = "00005"	  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI5")
	EndIf
	If SRA->RA_PROCES = "00006"	  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI6")
	EndIf
	If SRA->RA_PROCES = "00007"	  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      	
 
return(cConta)  


//***************************
//* Centro de Custo Debito  *
//***************************
User Function cc_deb_rh_contabil()

cCC := space(10)
crecebCC := space(10)
cConta := space(10)                       

	cGrupo := ""
	cConta := space(10)
  
   If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBITO")
	EndIf
   If SRA->RA_PROCES = "00005"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT5")
	EndIf
   If SRA->RA_PROCES = "00006"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT6")
	EndIf
   If SRA->RA_PROCES = "00007"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
		
     	cCC:= SRZ->RZ_CC  
  	
return(cCC)    

//*****************************
//* * Centro de Custo Credito *
//*****************************
User Function cc_cre_rh_contabil()

cCC := space(10)
crecebCC := space(10)
cConta := space(10)

	cGrupo := ""
	cConta := space(10)
  
   If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDIT")
	EndIf
	If SRA->RA_PROCES = "00005"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI5")
	EndIf
	If SRA->RA_PROCES = "00006"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI6")
	EndIf
	If SRA->RA_PROCES = "00007"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
			
    	cCC:= SRZ->RZ_CC  

return(cCC)  



//***************************
//* Item de Custo Debito    *
//***************************
User Function Item_deb()

cItem_ := space(10)
crecebCC := space(10)
cConta := space(10)                       

	cGrupo := ""
	cConta := space(10)
  
   If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBITO")
	EndIf
   If SRA->RA_PROCES = "00005"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT5")
	EndIf
   If SRA->RA_PROCES = "00006"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT6")
	EndIf
   If SRA->RA_PROCES = "00007"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
		
       	cItem_:= SRZ->RZ_ITEM
	
return(cItem_)    

//***************************
//* Item de Custo Credito   *
//***************************
User Function Item_cre()

cItem_ := space(10)
crecebCC := space(10)
cConta := space(10)                       

	cGrupo := ""
	cConta := space(10)
  
	If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDIT")
	EndIf
		If SRA->RA_PROCES = "00005"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI5")
	EndIf
		If SRA->RA_PROCES = "00006"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI6")
	EndIf
		If SRA->RA_PROCES = "00007"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI7")
	EndIf

//		if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
		
       	cItem_:= SRZ->RZ_ITEM
	
return(cItem_)   

//***************************************
//* Classe de Valor de Custo Credito    *
//***************************************
User Function CLVL_Cre()

cCLVL_ := space(10)
crecebCC := space(10)
cConta := space(10)                       

	cGrupo := ""
	cConta := space(10)
  
   If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDIT")
	EndIf
   If SRA->RA_PROCES = "00005"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI5")
	EndIf
   If SRA->RA_PROCES = "00006"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI6")
	EndIf
   If SRA->RA_PROCES = "00007"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XCREDI7")
	EndIf
	
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
		    
       	cCLVL_:= SRZ->RZ_CLVL
	
return(cCLVL_)  

//***********************************
//* Classe de Valor de Custo Debito *
//***********************************
User Function CLVL_Deb()

cCLVL_ := space(10)
crecebCC := space(10)
cConta := space(10)                       

	cGrupo := ""
	cConta := space(10)

   If SRA->RA_PROCES = "00001" .or. SRA->RA_PROCES = "00008"
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBITO")
	EndIf
   If SRA->RA_PROCES = "00005"  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT5")
	EndIf
   If SRA->RA_PROCES = "00006"  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT6")
	EndIf
   If SRA->RA_PROCES = "00007"  
		cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_XDEBIT7")
	EndIf
			
//	if trim(cConta) = ""
//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
//	endif  	      
		
       	cCLVL_:= SRZ->RZ_CLVL
	
return(cCLVL_)

User Function GerCtbFol()    

cQuery_:= ""

cQuery_:= "DELETE " + RETSQLNAME("SRZ") 
TcSqlExec(cQuery_)                      

GPEM110() //Chama a rotina padrao do sistema

Return