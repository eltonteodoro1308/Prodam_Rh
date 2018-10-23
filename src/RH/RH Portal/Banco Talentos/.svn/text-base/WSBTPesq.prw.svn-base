#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "AP5MAIL.CH"
                              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSMEUCADFUNC ºAutor  ³Totvs           º Data ³  31/03/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WS que irá exibir os conhecimentos do funcionário no portalº±±
±±º          ³ de gestão de capital humano (APD)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PRODAM - Portal de Gestão de Capital Humano (SIGAAPD)      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/**************************************************************************
* Definicao da estruturas utilizadas                                      *
***************************************************************************/
User Function _YZYWWWY ; Return  // "dummy" function - Internal Use

WSSTRUCT SEARCHSTRU

	WSDATA NOME			AS String Optional
	WSDATA DEPART		AS String Optional
	WSDATA ATIVFUNC		AS String Optional
	WSDATA CURSOS		AS String Optional
	WSDATA CONHEC		AS String Optional
	WSDATA AREA			AS String Optional
	WSDATA CATEG		AS String Optional
	WSDATA NIVEL		AS String Optional
	WSDATA OPERADOR		AS String Optional
	WSDATA VISAO		AS String Optional

ENDWSSTRUCT 


/***************************************************************************
* Definicao do Web Service 							                      *
***************************************************************************/
WSSERVICE WS_BTPESQ DESCRIPTION "Pesquisa - Banco de Talentos"
	
   WSDATA SEARCH		AS SEARCHSTRU
   WSDATA FUNCIONARIOS	AS Array of String

   WSMETHOD SEARCHFUNC 			//Busca os funcionários com as caracteristicas informadas.

ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETFUNC ºAutor  ³Diego Santos   º Data ³  31/03/16        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os cursos, conhecimentos e atividades funcionais do  º±±
±±º          ³ funcionário da mesma forma que a rotina TRM002 presente no º±±
±±º			 ³ módulo de Treinamentos (SIGATRM)							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PRODAM - Portal de Gestão de Capital Humano (SIGAAPD)      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSMETHOD SEARCHFUNC WSRECEIVE SEARCH WSSEND FUNCIONARIOS WSSERVICE WS_BTPESQ

Local cQuery 	:= ""
Local cQuery2	:= ""
Local aAtivFunc := {} 
Local aCursos 	:= {} 
Local aArea 	:= {} 
Local aCateg	:= {}  
Local aConhec 	:= {} 
Local aNivel	:= {}

Local cAtivIN	:= ""
Local cCursoIN  := ""

Local cIniOp		:= " ( "
Local cFimOp		:= " ) "
Local cOp			:= ""

Local nX
Local nZ
Local nY
Local nK

Local aAuxAtv 	:= {}
Local aAuxCur 	:= {}			
Local aAuxArea 	:= {}
Local aAuxCat 	:= {}			
Local aAuxCon 	:= {}
Local aAuxNiv 	:= {}

Local cAlias1	
Local cAlias2  

Local cFilZ91		:= ""
Local cFilZ92		:= ""
Local cFil1Conhec	:= ""
Local cFil2Conhec	:= ""

Local aFiltro1		:= {}  			
Local aFiltro2		:= {}

Local cCodDep   := ""
Local cDescDep	:= ""
Local cNomeFun	:= ""
Local cKnow		:= ""

Local aFuncs		:= {}
Local cMatsResults 	:= ""
Local cMat			:= ""

Local cArea1Fil		:= ""
Local cArea2Fil		:= ""

Local cCat1Fil		:= ""
Local cCat2Fil		:= ""

Local cCon1Fil		:= ""
Local cCon2Fil		:= ""
 
Local cNiv1Fil		:= ""
Local cNiv2Fil		:= ""

Local cChave		:= ""

//Pesquisa na visao a chave do depto selecionado, para buscar posteriormente os Departamentos Filhos/Netos
If !Empty(::SEARCH:DEPART) .and. !Empty(::SEARCH:VISAO)
	cChave := alltrim(Posicione("RD4",5,xFilial("RD4")+ ::SEARCH:VISAO + ::SEARCH:DEPART,"RD4_CHAVE"))
EndIf

If !Empty(::SEARCH:ATIVFUNC)
	If At("|",::SEARCH:ATIVFUNC) > 0
		aAtivFunc := Separa(::SEARCH:ATIVFUNC, "|" )
		For nK := 1 To Len(aAtivFunc)
			If Empty(aAtivFunc[nK])
				If Len(aAuxAtv) == 0
					aAuxAtv := {}
				EndIf
			Else
				aAdd( aAuxAtv, aAtivFunc[nK] ) 
			EndIf
		Next nK		
		
		aAtivFunc := aClone(aAuxAtv)
		
	Else
		aAdd( aAtivFunc, ::SEARCH:ATIVFUNC )	
	EndIf
EndIf

If !Empty(::SEARCH:CURSOS)
	If At("|",::SEARCH:CURSOS) > 0
		aCursos := Separa(::SEARCH:CURSOS, "|" )
		For nK := 1 To Len(aCursos)
			If Empty(aCursos[nK])
				If Len(aAuxCur) == 0
					aAuxCur := {}
				EndIf
			Else
				aAdd( aAuxCur, aCursos[nK] ) 
			EndIf
		Next nK		
		
		aCursos := aClone(aAuxCur)
		
	Else
		aAdd(aCursos, ::SEARCH:CURSOS )	
	EndIf
EndIf

If !Empty(::SEARCH:AREA)
	If At("|",::SEARCH:AREA) > 0
		aArea := Separa(::SEARCH:AREA, "|" )
		For nK := 1 To Len(aArea)
			If Empty(aArea[nK])
				If Len(aAuxArea) == 0
					aAuxArea := {}
				EndIf
			Else
				aAdd( aAuxArea, aArea[nK] ) 
			EndIf
		Next nK		
		
		aArea := aClone(aAuxArea)
		
	Else
		aAdd(aArea, ::SEARCH:AREA )
	EndIf
EndIf

If !Empty(::SEARCH:CATEG)
	If At("|",::SEARCH:CATEG) > 0
		aCateg := Separa(::SEARCH:CATEG, "|" )
		For nK := 1 To Len(aCateg)
			If Empty(aCateg[nK])
				If Len(aAuxCat) == 0
					//aAuxCat := {}
					aAdd(aAuxCat, "")
				EndIf
			Else
				aAdd( aAuxCat, aCateg[nK] ) 
			EndIf
		Next nK		
		
		aCateg := aClone(aAuxCat)
		
	Else
		aAdd(aCateg, ::SEARCH:CATEG )
	EndIf
EndIf

If !Empty(::SEARCH:CONHEC)
	If At("|",::SEARCH:CONHEC) > 0
		aConhec := Separa(::SEARCH:CONHEC, "|" )
		For nK := 1 To Len(aConhec)
			If Empty(aConhec[nK])
				If Len(aAuxCon) == 0
					aAdd(aAuxCon, "")
				EndIf
			Else
				aAdd( aAuxCon, aConhec[nK] ) 
			EndIf
		Next nK		
		
		aConhec := aClone(aAuxCon)
		
	Else
		aAdd(aConhec, ::SEARCH:CONHEC )
	EndIf
EndIf

If !Empty(::SEARCH:NIVEL)
	If At("|",::SEARCH:NIVEL) > 0
		aNivel := Separa(::SEARCH:NIVEL, "|" )
		For nK := 1 To Len(aNivel)
			If Empty(aNivel[nK])
				If Len(aAuxNiv) == 0
					aAuxNiv := {}
				EndIf
			Else
				aAdd( aAuxNiv, aNivel[nK] ) 
			EndIf
		Next nK		
		
		aNivel := aClone(aAuxNiv)
		
	Else
		aAdd(aNivel, ::SEARCH:NIVEL )
	EndIf
EndIf

//DEPART, NOME e OPERADOR

cQuery := "SELECT DISTINCT "
cQuery += "SRA.RA_FILIAL, SRA.RA_MAT,"
cQuery += "SRA.RA_DEPTO, RA_NOME "
cQuery += "FROM "
cQuery += RetSqlName("SRA") + " SRA "
If !Empty(::SEARCH:CURSOS)
	cQuery += "LEFT JOIN "
	cQuery += RetSqlName("RA4") + " RA4 ON "
	cQuery += "SRA.RA_FILIAL  = RA4.RA4_FILIAL AND "
	cQuery += "SRA.RA_MAT     = RA4.RA4_MAT    AND " 
	cQuery += "SRA.D_E_L_E_T_ = RA4.D_E_L_E_T_ AND "
	cQuery += "SRA.D_E_L_E_T_ = '' "

	cQuery += "LEFT JOIN "
	cQuery += RetSqlName("RA1") + " RA1 ON "
	cQuery += "RA1.RA1_CURSO  = RA4.RA4_CURSO AND "
	cQuery += "RA4.D_E_L_E_T_ = RA1.D_E_L_E_T_  AND "
	cQuery += "RA4.D_E_L_E_T_ = '' "
EndIf

If !Empty(::SEARCH:ATIVFUNC)
	cQuery += "LEFT JOIN "
	cQuery += RetSqlName("RBN") + " RBN ON "
	cQuery += "SRA.RA_FILIAL  = RBN.RBN_FILIAL   AND "
	cQuery += "SRA.RA_MAT  	  = RBN.RBN_MAT   AND "
	cQuery += "SRA.D_E_L_E_T_ = RBN.D_E_L_E_T_  AND "
	cQuery += "RBN.D_E_L_E_T_ = '' "
EndIf	

If !Empty(::SEARCH:DEPART)
	cQuery += "LEFT JOIN "
	cQuery += RetSqlName("SQB") + " SQB ON "
	//cQuery += "SRA.RA_FILIAL  = SQB.QB_FILIAL   AND "
	cQuery += "SRA.RA_DEPTO   = SQB.QB_DEPTO    AND "
	cQuery += "SRA.D_E_L_E_T_ = SQB.D_E_L_E_T_  AND "
	cQuery += "SQB.D_E_L_E_T_ = '' "	
EndIf
	
cQuery += "WHERE "

If !Empty(::SEARCH:NOME) //Se Nome estiver preenchido não preciso dos outros filtros.
	cQuery += "(SRA.RA_NOME = '"+RTrim(::SEARCH:NOME)+"' OR SRA.RA_NOMECMP = '"+RTrim(::SEARCH:NOME)+"') AND "
Else

	If !Empty(::SEARCH:DEPART)
		If !Empty(cChave)
			cQuery += "SQB.QB_DEPTO IN ( SELECT RD4_CODIDE FROM " + RetSqlName("RD4") 
			cQuery += 				       "   WHERE D_E_L_E_T_ = '' AND RD4_CODIGO = '" + ::SEARCH:VISAO + "' "
			cQuery += 				       "         AND LEFT(RD4_CHAVE," + strzero(len(cChave)) + ") = '" + cChave + "') AND "
		Else			
			cQuery += "SQB.QB_DEPTO = '" + ::SEARCH:DEPART + "' AND "
		EndIf
	EndIf

	If Len(aAtivFunc) > 0		
		For nY := 1 To Len(aAtivFunc)			
			If !Empty(aAtivFunc[nY])
				If nY == 1 
					If nY == Len(aAtivFunc) //Primeiro e único
	 					cAtivIN := "( UPPER(RBN.RBN_PROJET) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR  UPPER(RBN.RBN_SUBPRO)  LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR UPPER(RBN.RBN_DEPTO) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' ) AND "
	 				Else
	 					cAtivIN := "( UPPER(RBN.RBN_PROJET) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR  UPPER(RBN.RBN_SUBPRO)  LIKE '%"+ Upper(aAtivFunc[nY]) + "%' OR UPPER(RBN.RBN_DEPTO) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' "
	 				EndIf	 				
	 			Else
	 				If nY == Len(aAtivFunc)
	 					cAtivIN += " OR UPPER(RBN.RBN_PROJET) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR  UPPER(RBN.RBN_SUBPRO)  LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR UPPER(RBN.RBN_DEPTO) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' ) AND "
	 				Else
	 					cAtivIN += " OR UPPER(RBN.RBN_PROJET) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR  UPPER(RBN.RBN_SUBPRO)  LIKE '%"+ Upper(aAtivFunc[nY]) +"%' OR UPPER(RBN.RBN_DEPTO) LIKE '%"+ Upper(aAtivFunc[nY]) +"%' "
	 				EndIf
	 			EndIf	 				
	 		EndIf
		Next nY
	EndIf
	
	If !Empty(cAtivIN)
		cQuery += cAtivIN
	EndIf
	
	If Len(aCursos) > 0		
		For nY := 1 To Len(aCursos)			
			If !Empty(aCursos[nY])
				If nY == 1 
					If nY == Len(aCursos) //Primeiro e único
	 					cCursoIN := "( UPPER(RA1.RA1_DESC) LIKE '%"+ Upper(aCursos[nY]) +"%' ) AND "
	 				Else
	 					cCursoIN := "( UPPER(RA1.RA1_DESC) LIKE  '%" + Upper(aCursos[nY]) +"%' "
	 				EndIf	 				
	 			Else
	 				If nY == Len(aCursos)
	 					cCursoIN += " OR UPPER(RA1.RA1_DESC) LIKE '%"+ Upper(aCursos[nY]) +"%' ) AND "
	 				Else
	 					cCursoIN += " OR UPPER(RA1.RA1_DESC) LIKE '%"+ Upper(aCursos[nY]) +"%' "
	 				EndIf
	 			EndIf	 				
	 		EndIf
		Next nY
	EndIf
		
	If !Empty(cCursoIN)
		cQuery += cCursoIN
	EndIf
	
		
EndIf

cQuery += " SRA.D_E_L_E_T_ = '' AND SRA.RA_SITFOLH <> 'D' "
cQuery += " order by RA_DEPTO, RA_NOME, RA_MAT "
//ConOut(cQuery)

cAlias1 := GetNextAlias()
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.T.,.T.)

While (cAlias1)->(!Eof()) //Adiciono os funcionários filtrados.	
	aAdd(aFuncs, { (cAlias1)->RA_FILIAL,(cAlias1)->RA_MAT,(cAlias1)->RA_DEPTO } )
	(cAlias1)->(DbSkip())
End

If Len(aArea) > 0 .and. len(aFuncs) > 0

	For nK := 1 To Len(aFuncs)
		If nK != Len(aFuncs)
			cMatsResults += "'"+aFuncs[nK][2]+"', "
		Else
			cMatsResults += "'"+aFuncs[nK][2]+"' "
		EndIf
	Next nK

	cQuery2 := " SELECT " 
	cQuery2 += " SZ9.Z9_MAT, 
	cQuery2 += " SZ9.Z9_AREA, 
	cQuery2 += " SZ6.Z6_DESCRI, 
	cQuery2 += " SZ9.Z9_CATEG, 
	cQuery2 += " SZ7.Z7_DESCRI, 
	cQuery2 += " SZ9.Z9_CONHEC, 
	cQuery2 += " SZ8.Z8_DESCRI,
	cQuery2 += " SZ9.Z9_NIVEL
	cQuery2 += " FROM "+RetSqlName("SZ9") + " SZ9 "
	cQuery2 += " LEFT JOIN "+RetSqlName("SZ6") + " SZ6 ON " 
	cQuery2 += " SZ9.Z9_FILIAL = SZ6.Z6_FILIAL AND
	cQuery2 += " SZ9.Z9_AREA   = SZ6.Z6_CODIGO AND
	cQuery2 += " SZ9.D_E_L_E_T_ = SZ6.D_E_L_E_T_ AND
	cQuery2 += " SZ9.D_E_L_E_T_ = ''
	cQuery2 += " LEFT JOIN "+RetSqlName("SZ7") + " SZ7 ON "
	cQuery2 += " SZ9.Z9_FILIAL = SZ7.Z7_FILIAL 	AND
	cQuery2 += " SZ9.Z9_AREA = SZ7.Z7_AREA 		AND
	cQuery2 += " SZ9.Z9_CATEG = SZ7.Z7_CODIGO 	AND
	cQuery2 += " SZ9.D_E_L_E_T_ = SZ7.D_E_L_E_T_ AND
	cQuery2 += " SZ9.D_E_L_E_T_ = ''
	cQuery2 += " LEFT JOIN "+RetSqlName("SZ8") + " SZ8 ON "
	cQuery2 += " SZ9.Z9_FILIAL = SZ8.Z8_FILIAL 	AND
	cQuery2 += " SZ9.Z9_AREA   = SZ8.Z8_AREA 	AND
	cQuery2 += " SZ9.Z9_CATEG  = SZ8.Z8_CATEG 	AND 
	cQuery2 += " SZ9.Z9_CONHEC = SZ8.Z8_CODIGO   AND
	cQuery2 += " SZ9.D_E_L_E_T_ = SZ8.D_E_L_E_T_ AND
	cQuery2 += " SZ9.D_E_L_E_T_ = ''
	cQuery2 += " WHERE "
	cQuery2 += " SZ9.Z9_MAT IN ("+cMatsResult+") AND "
		
	For nX := 1 To Len(aArea)
		If nX == 1 
			cFilZ91 := aArea[nX] + "|"  
		Else
			cFilZ92 := aArea[nX] + "|"
		EndIf
	Next nX

	For nX := 1 To Len(aCateg)
		If nX == 1 
			cFilZ91 += aCateg[nX] + "|"
		Else
			cFilZ92 += aCateg[nX] + "|"
		EndIf
	Next nX
	
	For nX := 1 To Len(aConhec)
		If nX == 1 
			cFilZ91 += aConhec[nX] + "|"
		Else
			cFilZ92 += aConhec[nX] + "|"
		EndIf
	Next nX
		
	For nX := 1 To Len(aNivel)
		If nX == 1 
			cFilZ91 += aNivel[nX] + "|"
		Else
			cFilZ92 += aNivel[nX] + "|"
		EndIf
	Next nX

	If !Empty(cFilZ91)
	
		aFiltro1 := Separa(cFilZ91, "|")
		For nX := 1 To Len(aFiltro1)
			If nX == 1 //Area
				cFil1Conhec := " SZ9.Z9_AREA = '"+aFiltro1[nX]+"' "
				cArea1Fil	:= aFiltro1[nX]
			Else
				If !Empty(aFiltro1[nX]) .And. nX == 2 //Categoria 
					cFil1Conhec += " AND SZ9.Z9_CATEG = '"+aFiltro1[nX]+"' "
					cCat1Fil	:= aFiltro1[nX]
				ElseIf !Empty(aFiltro1[nX]) .And. nX == 3 //Conhecimento
					cFil1Conhec += " AND SZ9.Z9_CONHEC = '"+aFiltro1[nX]+"' "
					cCon1Fil	:= aFiltro1[nX]
				ElseIf !Empty(aFiltro1[nX]) .And. nX == 4 //Nivel
					cFil1Conhec += " AND SZ9.Z9_NIVEL = '"+aFiltro1[nX]+"' "
					cNiv1Fil	:= aFiltro1[nX]
				EndIf
			EndIf		
		Next nX
		
	EndIf

	/*
	Se o operador não estiver vazio eu considero o filtro na pesquisa.
	*/ 
	
	If !Empty(::SEARCH:OPERADOR) 
	
		If !Empty(cFilZ92)
	
			aFiltro2 := Separa(cFilZ92, "|")
			For nX := 1 To Len(aFiltro2)
				If nX == 1 //Area
					cFil2Conhec := " SZ9.Z9_AREA = '"+aFiltro2[nX]+"' "
					cArea2Fil	:= aFiltro2[nX]
				Else
					If !Empty(aFiltro2[nX]) .And. nX == 2 //Categoria 
						cFil2Conhec += " AND SZ9.Z9_CATEG = '"+aFiltro2[nX]+"' "
						cCat2Fil	:= aFiltro2[nX]
					ElseIf !Empty(aFiltro2[nX]) .And. nX == 3 //Conhecimento
						cFil2Conhec += " AND SZ9.Z9_CONHEC = '"+aFiltro2[nX]+"' "
						cCon2Fil	:= aFiltro2[nX]
					ElseIf !Empty(aFiltro2[nX]) .And. nX == 4 //Nivel
						cFil2Conhec += " AND SZ9.Z9_NIVEL = '"+aFiltro2[nX]+"' "
						cNiv2Fil	:= aFiltro2[nX]
					EndIf
				EndIf		
			Next nX
			
		EndIf
	
	EndIf
	
	/*
	Se o operador não estiver preenchido, 
	mesmo que o usuario tenha informado os conhecimentos na linha abaixo do form, 
	a busca será realizada considerando apenas o primeiro conhecimento preenchido.
	*/
							
	If !Empty(cFil1Conhec)
		cQuery2 += " ( " + cIniOp + cFil1Conhec + cFimOp + " "
	EndIf
		
	If !Empty(cFil2Conhec)
		cQuery2 += " OR "
		cQuery2 += cIniOp + cFil2Conhec + cFimOp + " ) AND "
	Else
		cQuery2 += " ) AND " 
	EndIf		
		
	cQuery2 += " SZ9.D_E_L_E_T_ = '' "	
	cQuery2 += " ORDER BY SZ9.Z9_FILIAL, SZ9.Z9_MAT, SZ9.Z9_AREA, SZ9.Z9_CATEG, SZ9.Z9_CONHEC "
	
	cAlias2 := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)
	
	//cArea1Fil+cCat1Fil+cCon1Fil+cNiv1Fil
	//cArea2Fil+cCat2Fil+cCon2Fil+cNiv2Fil
	
	While (cAlias2)->(!Eof())
			
		If Empty(cMat)
			
			cMat := (cAlias2)->Z9_MAT
			If ::SEARCH:OPERADOR == "1" //E
				SZ9->(DbSetOrder(2))
				If ( SZ9->(DbSeek(xFilial("SZ9")+(cAlias2)->Z9_MAT+cArea1Fil+cCat1Fil+cCon1Fil+cNiv1Fil) ) .And. ;
					 SZ9->(DbSeek(xFilial("SZ9")+(cAlias2)->Z9_MAT+cArea2Fil+cCat2Fil+cCon2Fil+cNiv2Fil) ) )
					 
					cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
					If !Empty(cCodDep)
						cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
					Else
						cDescDep	:= ""
					EndIf				
					cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
					cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
					 
					//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
					aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
							 
				EndIf 
			ElseIf ::SEARCH:OPERADOR == "2" //OU
				
				cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
				If !Empty(cCodDep)
					cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
				Else
					cDescDep	:= ""
				EndIf				
				cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
				cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
				 
				//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
				aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
			
			Else
			
				cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
				If !Empty(cCodDep)
					cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
				Else
					cDescDep	:= ""
				EndIf				
				cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
				cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
				 
				//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
				aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
			
			EndIf
				
		ElseIf cMat != (cAlias2)->Z9_MAT
			
			If ::SEARCH:OPERADOR == "1" //E
				SZ9->(DbSetOrder(2))
				If ( SZ9->(DbSeek(xFilial("SZ9")+(cAlias2)->Z9_MAT+cArea1Fil+cCat1Fil+cCon1Fil+cNiv1Fil) ) .And. ;
					 SZ9->(DbSeek(xFilial("SZ9")+(cAlias2)->Z9_MAT+cArea2Fil+cCat2Fil+cCon2Fil+cNiv2Fil) ) )
					 					 
					cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
					If !Empty(cCodDep)
						cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
					Else
						cDescDep	:= ""
					EndIf				
					cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
					cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
					 
					//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
					aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
							 
				EndIf 
			ElseIf ::SEARCH:OPERADOR == "2" //OU
				
				cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
				If !Empty(cCodDep)
					cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
				Else
					cDescDep	:= ""
				EndIf
				cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
				cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
				
				//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
				aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
						
			Else
				
				cCodDep  	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_DEPTO"))
				If !Empty(cCodDep)
					cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
				Else
					cDescDep	:= ""
				EndIf
				cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+(cAlias2)->Z9_MAT, "RA_NOME"))
				cKnow		:= GetKnowZ9( (cAlias2)->Z9_MAT )
				 
				//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
				aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + (cAlias2)->Z9_MAT )
										
			EndIf
		EndIf
				
		cMat := (cAlias2)->Z9_MAT	
		(cAlias2)->(DbSkip())
		
	End

ElseIf len(aArea) == 0

	For nX := 1 To Len(aFuncs)
		
		cCodDep  	:= RTrim(aFuncs[nX][3])
		If !Empty(cCodDep)
			cDescDep	:= RTrim(Posicione("SQB",1, xFilial("SQB")+cCodDep, "QB_DESCRIC"))
		Else
			cDescDep	:= ""
		EndIf
		cNomeFun	:= RTrim(Posicione("SRA",1, xFilial("SRA")+aFuncs[nX][2], "RA_NOME"))
		cKnow		:= GetKnowZ9( aFuncs[nX][2] )
	
		//aADD( ::FUNCIONARIOS, cCodDep+" - "+cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + aFuncs[nX][2] )
		aADD( ::FUNCIONARIOS, cDescDep+"|"+cNomeFun+"|"+cKnow + "|" + aFuncs[nX][2] )
		
	Next nX
EndIf	
	
Return .T.

 
Static Function GetKnowZ9( cMatricula )

Local cQryZ9Z8 := ""
Local cAliZ9Z8 := GetNextAlias()
Local cResult  := ""

cQryZ9Z8 := " SELECT SZ9.Z9_MAT, SZ9.Z9_CONHEC, "
cQryZ9Z8 += " SZ8.Z8_DESCRI "
cQryZ9Z8 += " FROM " +RetSqlName("SZ9") + " SZ9 "
cQryZ9Z8 += " LEFT JOIN "+RetSqlName("SZ8")+ " SZ8 ON "
cQryZ9Z8 += " SZ9.Z9_AREA =   SZ8.Z8_AREA AND "
cQryZ9Z8 += " SZ9.Z9_CATEG =   SZ8.Z8_CATEG AND "
cQryZ9Z8 += " SZ9.Z9_CONHEC = SZ8.Z8_CODIGO AND "
cQryZ9Z8 += " SZ9.D_E_L_E_T_  = SZ8.D_E_L_E_T_ "
cQryZ9Z8 += " WHERE "
cQryZ9Z8 += " SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' AND "
cQryZ9Z8 += " SZ9.Z9_MAT = '"+cMatricula+"' AND "
cQryZ9Z8 += " SZ9.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ9Z8),cAliZ9Z8,.T.,.T.)

While (cAliZ9Z8)->(!Eof())
	cResult += RTrim((cAliZ9Z8)->Z8_DESCRI) + ", " 
	(cAliZ9Z8)->(DbSkip())
End

cResult := SubStr(cResult,1,Len(cResult)-1) //Retira ultima virgula

Return cResult
