#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFILTROAVAºAutor  ³Microsiga           º Data ³  06/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para filtrar a avaliacao no cadastro de             º±±
±±º          ³ no modulo APD.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION fFiltroAva()

Local cShCodAv := ""  
Local lShCargo := .F.
Local lShAchou := .F. 
Local cShGrupo := ""
Local cSHMatZ  := ""
Local cSHMatA  := ""  
Local cqueRDZ  := ""
Local cquePA2  := ""
Local cquePA0  := ""  
Local cqueSQ3  := ""

/*

// busco na rdz para achar a matricula
// cSHMatZ:= substr(Posicione("RDZ",2,xFilial("RDZ")+ RD0->RD0_CODIGO,"RDZ_CODENT"),3,6)

// Substituido por query 
cqueRDZ := "SELECT RDZ_CODENT  FROM " + RetSqlName("RDZ") + " RDZ "
	
cqueRDZ += " WHERE RDZ_CODRD0 = '"+RD0->RD0_CODIGO+ "'  "
cqueRDZ += " AND RDZ.D_E_L_E_T_ = ' ' "

If select("SRDZ") > 0
	SRDZ->(dbCloseArea())
Endif

//Abrir Tabela
dbUseArea(.T.,"TopConn",TcGenQry(,,cqueRDZ),"SRDZ",.T.,.T.)  

If Select("SRDZ") > 0
	cSHMatZ := Substr(SRDZ->RDZ_CODENT,1,8)
Endif

DBCloseArea("SRDZ")   

//Garante posicionamento do SRA
SRA->(dbsetorder(1))
If SRA->(dbseek(cSHMatZ))
*/	
	//cSHMatZ := Substr(cSHMatZ,2,6)
	cSHMatZ := SRA->RA_MAT

	If !Empty(cSHMatZ)
	
		//Verifico se é graticacao caso contrario busca o codigo que estiver no cargo do funcionario.
		cquePA2 := " SELECT * FROM " + RetSqlName("PA2") + " PA2 "		
		cquePA2 += " WHERE PA2_MAT = '"+cSHMatZ+ "'  "
		cquePA2 += " AND PA2_TIPO = '1' " 
		cquePA2 += " AND PA2.D_E_L_E_T_ = ' ' "
		
		If select("SPA2") > 0
			SPA2->(dbCloseArea())
		Endif
		
		//Abrir Tabela
		dbUseArea(.T.,"TopConn",TcGenQry(,,cquePA2),"SPA2",.T.,.T.)  
		
		// se nao encontrar nenhum registro busca  o codigo que estiver no cargo do funcionario.
		If Select("SPA2") > 0
	
				Do While !SPA2->(EOF())
		
					  If !(lShAchou )
					  
							If (SPA2->PA2_DATAIN <= dtos(DDATABASE) .And. SPA2->PA2_DATFIM >= dtos(DDATABASE))  .or. (SPA2->PA2_DATAIN <= dtos(DDATABASE) .And.  Empty(SPA2->PA2_DATFIM))
							 	lShAchou := .T.  
							 	cShGrupo := SPA2->PA2_GRUPO
							Endif	
			
					  Endif	
			
			        SPA2->(dbSkip())	
					
				Enddo  
				
				DBCloseArea("SPA2")			   
					
				If lShAchou  
					   
						cquePA0 := " SELECT * FROM " + RetSqlName("PA0") + " PA0 "		
	   				 	cquePA0 += " WHERE PA0_GRUPO = '"+cShGrupo+ "'  "
						cquePA0 += " AND PA0.D_E_L_E_T_ = ' ' "	     
						
						If select("SPA0") > 0
							SPA0->(dbCloseArea())
						Endif
											
						//Abrir Tabela
						dbUseArea(.T.,"TopConn",TcGenQry(,,cquePA0),"SPA0",.T.,.T.)  
						
						If Select("SPA0") > 0
						    cShCodAv:= SPA0->PA0_MODAVA
						Else  
							cqueSQ3 := "SELECT Q3_XNRAVAL  FROM " + RetSqlName("SQ3") + " SQ3 "
		
							cqueSQ3 += " WHERE Q3_CARGO = '"+SRA->RA_CARGO+ "'  "
							cqueSQ3 += "AND SQ3.D_E_L_E_T_ = ' ' " 
							
							If select("SSQ3") > 0
								SSQ3->(dbCloseArea())
							Endif
											
							//Abrir Tabela
							dbUseArea(.T.,"TopConn",TcGenQry(,,cqueSQ3),"SSQ3",.T.,.T.)   
							
							If Select("SSQ3") > 0
								cShCodAv := SSQ3->Q3_XNRAVAL 
							Else 
						    	cShCodAv:=""//	Alert("Matricula - " + sra->ra_mat + " Nome - " + sra->Ra_nome + " nao existe avaliacao vinculada ao cargo ('SQ3')")
						    Endif  
	
							DBCloseArea("SSQ3") 																	
							
						Endif
						
						DBCloseArea("SPA0")  					
										
				Else
				
						cqueSQ3 := "SELECT Q3_XNRAVAL  FROM " + RetSqlName("SQ3") + " SQ3 "
	
						cqueSQ3 += " WHERE Q3_CARGO = '"+SRA->RA_CARGO+ "'  "
						cqueSQ3 += "AND SQ3.D_E_L_E_T_ = ' ' " 
						
						If select("SSQ3") > 0
							SSQ3->(dbCloseArea())
						Endif
										
						//Abrir Tabela
						dbUseArea(.T.,"TopConn",TcGenQry(,,cqueSQ3),"SSQ3",.T.,.T.)   
						
						If Select("SSQ3") > 0
							cShCodAv := SSQ3->Q3_XNRAVAL 
						Else 
					    	cShCodAv:=""//	Alert("Matricula - " + sra->ra_mat + " Nome - " + sra->Ra_nome + " nao existe avaliacao vinculada ao cargo ('SQ3')")
					    Endif  
	
						DBCloseArea("SSQ3") 
				    
				Endif    
					                                                                           
	
		Else 
				cqueSQ3 := "SELECT Q3_XNRAVAL  FROM " + RetSqlName("SQ3") + " SQ3 "
	
				cqueSQ3 += " WHERE Q3_CARGO = '"+SRA->RA_CARGO+ "'  "
				cqueSQ3 += "AND SQ3.D_E_L_E_T_ = ' ' " 
				
				If select("SSQ3") > 0
					SSQ3->(dbCloseArea())
				Endif
								
				//Abrir Tabela
				dbUseArea(.T.,"TopConn",TcGenQry(,,cqueSQ3),"SSQ3",.T.,.T.)   
				
				If Select("SSQ3") > 0
					cShCodAv := SSQ3->Q3_XNRAVAL 
				Else
			    	cShCodAv:=""//	Alert("Matricula - " + sra->ra_mat + " Nome - " + sra->Ra_nome + " nao existe avaliacao vinculada ao cargo ('SQ3')")
			    Endif  
	
				DBCloseArea("SSQ3") 
		EndIf
		
	Endif  	                

//EndIf
	
RETURN( cShCodAv )
