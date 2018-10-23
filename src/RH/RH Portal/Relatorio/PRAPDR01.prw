#INCLUDE "TOTVS.CH"  
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PRAPDR01
Acompanhamento de metas
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION PRAPDR01()
LOCAL cPerg		:= "PRAPDR01"
Private cTitulo	:= "Metas"
Private cPath		:= ""

PR53R01SX1(cPerg)
If Pergunte(cPerg,.T.)
	cPath:= TRIM(MV_PAR01)
	
	If !ExistDir(cPath)
		MSGALERT("Caminho não encontrado: "+cPath)
	ELSE		
		Processa( {|| PR53R01IMP() }, cTitulo ,"Processando, aguarde...", .T. )
	EndIf
ENDIF


RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01IMP
Rotina de impressão do relatório
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR53R01IMP()
Local cTab  	:= GetNextAlias()
Local aDados	:= {}
Local aPeriodo:= {}
Local aVrMetas:= {}
Local aDsMetas:= {}
Local nPos		:= 0
Local nCnta	:= 0
Local cArquivo:= ""
Local nHdlPla	:= 0
Local lRet	   	:= .T.
Local nTotMeta:= 0
Local nTotPeso:= 0
Local nTotLanc:= 0
Local cSeqMeta:= ""
Local nLimMeta:= supergetmv("MV_APDLIMM",,3)


ProcRegua(0)

BeginSql Alias cTab
	SELECT * FROM %TABLE:RDU% RDU
	WHERE RDU_FILIAL=%xfilial:RDU% 
	AND RDU_CODIGO BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
	AND RDU.D_E_L_E_T_=''
EndSql

//GETLastQuery()[2]

(cTab)->(dbSelectArea((cTab)))
(cTab)->(dbGoTop())
While (cTab)->(!EOF())
	aDsMetas:= {}
	AADD(aDsMetas,(cTab)->RDU_CODIGO)		
	AADD(aDsMetas,(cTab)->RDU_DESC)
	
	IF MV_PAR08==1 .OR. MV_PAR08==2
		AADD(aDsMetas,"Não")
		AADD(aDsMetas,"Sim")
		AADD(aDsMetas,"Total")
		AADD(aDsMetas,"Percentual")		
	ELSE	
		
		IF MV_PAR08!=5		
			AADD(aDsMetas,"TotDef")
		ENDIF
		
		cSeqMeta:= "01" 
		FOR nCnta:=1 to nLimMeta
			IF MV_PAR08==5
				AADD(aDsMetas,"Desc. Meta "+cSeqMeta)
			ENDIF
			
			AADD(aDsMetas,"% Meta "+cSeqMeta)

			IF MV_PAR08==5
				AADD(aDsMetas,"Just. Meta "+cSeqMeta)
			ENDIF

			cSeqMeta:= SOMA1(cSeqMeta)				
		NEXT				  
		cSeqMeta:= ""
		
		IF MV_PAR08!=5 			
			AADD(aDsMetas,"Peso Total")
			AADD(aDsMetas,"Percentual")
		ENDIF	
	ENDIF
	
	AADD(aPeriodo,aDsMetas)
	
(cTab)->(DBSKIP())
END
(cTab)->(DBCLOSEAREA())	

cTab := GetNextAlias()
BeginSql Alias cTab	
	SELECT RDE_XDEPTO AS CCUSTO 
		,RD4_DESC AS DESC01
		,RA_MAT AS MAT 
		,RA_NOME AS NOME 
		,COALESCE(RDU_CODIGO,'') AS CODPER 
		,COALESCE(RDU_DESC,'') AS DESCPER 
	FROM %TABLE:SRA% SRA 
	INNER JOIN %TABLE:RDU% RDU ON RDU_FILIAL=%xfilial:RDU%  
		AND RDU_CODIGO BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07% 
		AND RDU.D_E_L_E_T_=''
	INNER JOIN %TABLE:RDZ% RDZ ON RDZ_FILIAL=%xfilial:RDZ%
	  AND RDZ_CODENT = RA_FILIAL+RA_MAT
	  AND RDZ.D_E_L_E_T_='' 
	INNER JOIN %TABLE:RD0% RD0 ON RD0_FILIAL=%xfilial:RD0%
	   AND RD0_CODIGO = RDZ.RDZ_CODRD0
	   AND RD0.D_E_L_E_T_=''
	INNER JOIN %TABLE:RDE% RDE ON RDE_FILIAL=%xfilial:RDE% 
	 	AND RDE_CODVIS=RDU_XVISAO
	 	AND RDE_CODPAR=RD0_CODIGO
	 	AND RDE_XDEPTO BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
	 	AND RDE_STATUS='1'
	 	AND RDE.D_E_L_E_T_=''
	INNER JOIN %TABLE:RD4% RD4 ON RD4_FILIAL=%xfilial:RD4% 
		AND RD4_CODIGO=RDU_XVISAO
	 	AND RD4_ITEM=RDE_ITEVIS
	 	AND RD4.D_E_L_E_T_=''	
	WHERE RA_FILIAL=%xfilial:SRA%  
		AND RA_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND RA_XMETAS!='N' 		
		AND RA_CC!='' 		
		AND SRA.D_E_L_E_T_=''
	GROUP BY RDE_XDEPTO,RD4_DESC,RA_MAT,RA_NOME,RDU_CODIGO,RDU_DESC 
	ORDER BY RDE_XDEPTO,RA_MAT,RDU_CODIGO	
EndSql	

//GETLastQuery()[2]

(cTab)->(dbSelectArea((cTab)))
(cTab)->(dbGoTop())
While (cTab)->(!EOF())		
	aVrMetas:= {}
	aDsMetas:= {}
	nTotPeso:= 0
	nTotLanc:= 0
	AADD(aVrMetas,(cTab)->CODPER)		
	AADD(aVrMetas,(cTab)->DESCPER)
	AADD(aDsMetas,(cTab)->CODPER)		
	AADD(aDsMetas,(cTab)->DESCPER)
		
	DBSELECTAREA("SZ0")
	SZ0->(DBSETORDER(1))
	SZ0->(DBGOTOP())
	IF SZ0->(DBSEEK(XFILIAL("SZ0")+(cTab)->MAT+(cTab)->CODPER))
		IF MV_PAR08==1 .OR. MV_PAR08==2
			AADD(aVrMetas,0)
			AADD(aVrMetas,1)
			AADD(aVrMetas,1)
			AADD(aVrMetas,100)
			AADD(aDsMetas,"Não")
			AADD(aDsMetas,"Sim")
			AADD(aDsMetas,"Total")
			AADD(aDsMetas,"Percentual")		
		ELSE		
			IF MV_PAR08!=5
				WHILE !SZ0->(EOF()) .AND. SZ0->(Z0_FILIAL+Z0_MAT+Z0_CODPER) == XFILIAL("SZ0")+(cTab)->MAT+(cTab)->CODPER
					IF SZ0->Z0_STATUS!="2"								
						nTotLanc++												
					ENDIF
				SZ0->(dbskip())
				END
				AADD(aVrMetas,nTotLanc)
				AADD(aDsMetas,"TotDef")
	
				DBSELECTAREA("SZ0")
				SZ0->(DBSETORDER(1))
				SZ0->(DBGOTOP())
				SZ0->(DBSEEK(XFILIAL("SZ0")+(cTab)->MAT+(cTab)->CODPER))
			ENDIF		
			
			nTotLanc:= 0				
			WHILE !SZ0->(EOF()) .AND. SZ0->(Z0_FILIAL+Z0_MAT+Z0_CODPER) == XFILIAL("SZ0")+(cTab)->MAT+(cTab)->CODPER
				IF SZ0->Z0_STATUS!="2"		
					IF MV_PAR08==5
						AADD(aVrMetas,PR53R01ESP(SZ0->Z0_META)+"&#10;")
						AADD(aDsMetas,"Desc. Meta "+SZ0->Z0_SEQ)
					ENDIF
					
					nTotPeso+= SZ0->Z0_PESO
									
					AADD(aVrMetas,{SZ0->Z0_PERC*SZ0->Z0_PESO,SZ0->Z0_PESO})
					AADD(aDsMetas,"Meta "+SZ0->Z0_SEQ)
					
					IF MV_PAR08==5
						AADD(aVrMetas,PR53R01ESP(SZ0->Z0_JUSTIF)+"&#10;")
						AADD(aDsMetas,"Just. Meta "+SZ0->Z0_SEQ)
					ENDIF
					nTotLanc++	
					
					//Adiciona apenas o valor do limite
					IF nTotLanc == nLimMeta
						EXIT
					ENDIF					
				ENDIF
			SZ0->(dbskip())
			END

			IF nTotLanc < nLimMeta  
				nTotLanc	:= nTotLanc+1
				cSeqMeta	:= STRZERO(nTotLanc,TAMSX3("Z0_SEQ")[1]) 
				
				FOR nCnta	:=nTotLanc to nLimMeta

					
					IF MV_PAR08==5
						AADD(aVrMetas,"")
						AADD(aDsMetas,"Desc. Meta "+cSeqMeta)
					ENDIF
					
					AADD(aVrMetas,{0,-1})  // Peso igual a -1 para tratamento futuro no fonte
					AADD(aDsMetas,"Meta "+cSeqMeta)
		
					IF MV_PAR08==5
						AADD(aVrMetas,"")
						AADD(aDsMetas,"Just. Meta "+cSeqMeta)
					ENDIF				
				
					cSeqMeta:= SOMA1(cSeqMeta)				
				NEXT				  
			ENDIF	
					
			IF MV_PAR08!=5
				AADD(aDsMetas,"Peso Total")
				AADD(aVrMetas,nTotPeso)
				AADD(aDsMetas,"Percentual")
				AADD(aVrMetas,0)
			ENDIF	
							
		ENDIF
	ELSE
		IF MV_PAR08==1 .OR. MV_PAR08==2
			AADD(aVrMetas,1)
			AADD(aVrMetas,0)
			AADD(aVrMetas,1)
			AADD(aVrMetas,0)
			AADD(aDsMetas,"Não")
			AADD(aDsMetas,"Sim")
			AADD(aDsMetas,"Total")
			AADD(aDsMetas,"Percentual")
		ELSE
			
			IF MV_PAR08!=5
				AADD(aVrMetas,0)
				AADD(aDsMetas,"TotDef")
			ENDIF	

			cSeqMeta:= STRZERO(1,TAMSX3("Z0_SEQ")[1]) 
			FOR nCnta:=1 to nLimMeta
			
				IF MV_PAR08==5
					AADD(aVrMetas,"")
					AADD(aDsMetas,"Desc. Meta "+cSeqMeta)
				ENDIF
				
				AADD(aVrMetas,{0,-1})  // Peso igual a -1 para tratamento futuro no fonte
				AADD(aDsMetas,"Meta "+cSeqMeta)
	
				IF MV_PAR08==5
					AADD(aVrMetas,"")
					AADD(aDsMetas,"Just. Meta "+cSeqMeta)
				ENDIF	
								
				cSeqMeta:= SOMA1(cSeqMeta)				
			NEXT

			IF MV_PAR08!=5
				AADD(aDsMetas,"Peso Total")
				AADD(aVrMetas,0)
				AADD(aDsMetas,"Percentual")
				AADD(aVrMetas,0)
			ENDIF	
							
		ENDIF				
	ENDIF	
	
	IF (nPos:= ASCAN(aDados,{|x| x[1]+x[2]=(cTab)->CCUSTO+(cTab)->MAT }))== 0
		AADD(aDados,{(cTab)->CCUSTO,(cTab)->MAT,(cTab)->NOME,{aVrMetas},(cTab)->DESC01})
	ELSE
		AADD(aDados[nPos][4],aVrMetas)
	ENDIF
	
	// Adiciona os Periodos encontradas
	IF !EMPTY((cTab)->CODPER)
		IF (nPos:= ASCAN(aPeriodo,{|x| x[1]==(cTab)->CODPER }))==0
			AADD(aPeriodo,aDsMetas)
		ELSE
			//Checa se no periodo tem mais metas e atualiza
			IF LEN(aPeriodo[nPos]) < LEN(aDsMetas)
				aPeriodo[nPos]:= ACLONE(aDsMetas)
			ENDIF	
		ENDIF
	ENDIF	
		
(cTab)->(DBSKIP())
END
(cTab)->(DBCLOSEAREA())

IF !EMPTY(aDados) .and. !EMPTY(aPeriodo)
	//Ordena os Periodos
	ASORT(aPeriodo,,,{|x,y| x[1]<y[1] } )	

	cArquivo := CriaTrab(, .F.) + '.xls'
	nHdlPla  := FCreate(cPath + cArquivo)
	
	If nHdlPla == -1
		Msgalert("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		lRet:= .F.
	EndIf	
	
ELSE
	Msgalert("Não foram localizados dados com os parâmetros informados!")
	lRet:= .F.	
EndIf

IF lRet
	// Monta o cabeçalho do xml
	PR53R01CAB(nHdlPla)
	
	// Monta os estiilos da planilha
	PR53R01CSS(nHdlPla)
	
	PR53R01CPL(nHdlPla,aPeriodo)
	
	PR53R01BDY(nHdlPla,aDados,aPeriodo)
	
	// Monta o rodape do xml
	PR53R01ROD(nHdlPla)
	
	// Fecha arquivo texto.
	FClose(nHdlPla)
	
	// Verifica-se o excel esta instalado
	If !ApOleClient( 'MsExcel' )
		MSGINFO("MsExcel nao instalado"+CRLF+"Arquivo salvo no endereço: "+cPath+cArquivo)
	ELSE
		ShellExecute("open",cPath+cArquivo,"","",2)	
	EndIf
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01CAB
Define o cabeçalho xml
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function PR53R01CAB(nHdlPla)
Local cText:= ""

cText += '<?xml version="1.0" encoding="ISO-8859-1" ?><?mso-application progid="Excel.Sheet"?>'+CRLF
cText += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
cText += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CRLF
cText += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'+CRLF
cText += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
cText += 'xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF
cText += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cText += '<AllowPNG/>'+CRLF
cText += '</OfficeDocumentSettings>'+CRLF
cText += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cText += '<WindowHeight>8460</WindowHeight>'+CRLF
cText += '<WindowWidth>15180</WindowWidth>'+CRLF
cText += '<WindowTopX>120</WindowTopX>'+CRLF
cText += '<WindowTopY>165</WindowTopY>'+CRLF
cText += '<ProtectStructure>False</ProtectStructure>'+CRLF
cText += '<ProtectWindows>False</ProtectWindows>'+CRLF
cText += '</ExcelWorkbook>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01CPL
Monta o cabeçalho da planilha
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function PR53R01CPL(nHdlPla,aPeriodo)
Local cText		:= ""
Local nCnta		:= 0
Local nCntb		:= 0
Local nTotMrg		:= 0
Local nMarg		:= 0
Local nTotPer		:= 0

IF !EMPTY(aPeriodo)
	nMarg	:= LEN(aPeriodo[1]) 
ENDIF

cText += '<Row ss:AutoFitHeight="0" ss:Height="29.25">'+CRLF
cText += '<Cell ss:MergeAcross="1" ss:MergeDown="1" ss:StyleID="m65888296"><Data ss:Type="String">'+cTitulo+'</Data></Cell>'+CRLF
cText += '<Cell ss:StyleID="s187"><Data ss:Type="String">'+DTOC(DATE())+'</Data></Cell>'+CRLF

FOR nCnta:=1 TO LEN(aPeriodo)
	nTotMrg:= (LEN(aPeriodo[nCnta])-2) - 1 
	cText += '<Cell ss:MergeAcross="'+alltrim(str(nTotMrg))+'" ss:MergeDown="1" ss:StyleID="m190509008"><Data ss:Type="String">'+aPeriodo[nCnta][2]+'</Data></Cell>'+CRLF			
NEXT nCnta

cText += '</Row>'+CRLF

cText += '<Row ss:AutoFitHeight="0" ss:Height="31.5">'+CRLF
cText += '<Cell ss:Index="3" ss:StyleID="s190"><Data ss:Type="DateTime">1899-12-31T'+ TIME() +'.000</Data></Cell>'+CRLF
cText += '</Row>'+CRLF

cText += '<Row ss:AutoFitHeight="0" ss:StyleID="s71">'+CRLF

IF MV_PAR08==2 .OR. MV_PAR08==4	
	cText += ' <Cell ss:MergeDown="1" ss:StyleID="m65888396"><Data ss:Type="String">Departamento</Data></Cell>'+CRLF
	cText += ' <Cell ss:MergeDown="1" ss:StyleID="m65888376"><Data ss:Type="String">Matricula</Data></Cell>'+CRLF
	cText += ' <Cell ss:MergeDown="1" ss:StyleID="m65888356"><Data ss:Type="String">Nome</Data></Cell>'+CRLF
ELSE 
	cText += ' <Cell ss:MergeDown="1" ss:MergeAcross="2" ss:StyleID="m65888396"><Data ss:Type="String">Departamento</Data></Cell>'+CRLF
ENDIF

FOR nCnta:=1 TO LEN(aPeriodo)
	FOR nCntb:=3 TO LEN(aPeriodo[nCnta])
		IF "TOTDEF"$UPPER(aPeriodo[nCnta][nCntb])
			cText += ' <Cell ss:MergeDown="1" ss:MergeAcross="0" ss:StyleID="m65888356"><Data ss:Type="String">Total de metas</Data></Cell>'+CRLF
		ELSE
			cText += ' <Cell ss:MergeDown="1" ss:MergeAcross="0" ss:StyleID="m65888356"><Data ss:Type="String">'+aPeriodo[nCnta][nCntb]+'</Data></Cell>'+CRLF
		ENDIF	
	NEXT nCntb	
NEXT nCnta

cText += '</Row>'+CRLF

cText += '<Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="0.25">'+CRLF
cText += '		<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="m43403232"><Data ss:Type="String"></Data></Cell>'+CRLF
cText += '</Row>'+CRLF


FWrite(nHdlPla, cText)

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01BDY
Monta o corpo da planilha
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function PR53R01BDY(nHdlPla,aDados,aPeriodo)
Local nCnta		:= 0
Local nCntb		:= 0
Local nPeriodo	:= 0
Local nDetMarg	:= 0
Local aSubAux		:= ACLONE(aPeriodo)
Local cCCustoAtu	:= ""
Local cDescAtu	:= ""
Local nTotItens	:= 0
Private nTotItGeral:= 0
Private aSubCusto	:= {}
Private aTotGeral	:= {}

FOR nCnta:= 1 TO LEN(aSubAux)
	FOR nCntb:=3 TO LEN(aSubAux[nCnta]) 
		IF "% META"$UPPER(aSubAux[nCnta][nCntb])
			aSubAux[nCnta][nCntb]:= {0,0}
		ELSE
			aSubAux[nCnta][nCntb]:= 0
		ENDIF	
	NEXT nCntb	
NEXT nCnta

aSubCusto:= ACLONE(aSubAux)
aTotGeral:= ACLONE(aSubAux)	

FOR nCnta:= 1 TO LEN(aDados)
	IF nCnta == 1
		cCCustoAtu	:= aDados[nCnta][1]
		cDescAtu	:= aDados[nCnta][5]
		PR53R01ON(nHdlPla,0,cCCustoAtu+" - "+cDescAtu,nDetMarg,aSubCusto)	
	ENDIF
	
	IF cCCustoAtu!=aDados[nCnta][1]	
		IF MV_PAR08!=5
			PR53R01OFF(nHdlPla,0,cCCustoAtu+" - "+cDescAtu,nDetMarg,aPeriodo,aSubCusto,nTotItens,.T.)
		ENDIF	
		nTotItens	:= 0
		cCCustoAtu	:= aDados[nCnta][1]
		cDescAtu	:= aDados[nCnta][5]
		PR53R01ON(nHdlPla,0,cCCustoAtu+" - "+cDescAtu,nDetMarg,aSubCusto)
		aSubCusto:= ACLONE(aSubAux)
	ENDIF
	PR53R01ITE(nHdlPla,aDados[nCnta],aPeriodo,nDetMarg,cDescAtu)
	nTotItens++	
NEXT nCnta

IF MV_PAR08!=5
	PR53R01OFF(nHdlPla,0,cCCustoAtu+" - "+cDescAtu,nDetMarg,aPeriodo,aSubCusto,nTotItens,.T.)
	PR53R01OFF(nHdlPla,0,"Visão Geral",nDetMarg,aPeriodo,aTotGeral,nTotItGeral,.F.)
ENDIF

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01ON
Abri a tag
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR53R01ON(nHdlPla,nSpace,cValor,nMarg,aSubTotal)
Local cText		:= ""
Local nCnta		:= 0
Local nCntb		:= 0

//Apenas Analitico
IF MV_PAR08==2 .OR. MV_PAR08==4	 .OR. MV_PAR08==5	
	cText += '<Row ss:AutoFitHeight="0">'+CRLF
	cText += '<Cell ss:MergeAcross="2" ss:StyleID="m43403232"><Data ss:Type="String">'+space(nSpace)+cValor+'</Data></Cell>'+CRLF
	
	FOR nCnta:=1 TO len(aSubTotal)
		FOR nCntb:=3 TO len(aSubTotal[nCnta])
			cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="m43403232"/>'+CRLF
		NEXT nCntb
	NEXT nCnta
	
	cText += '</Row>'+CRLF
	
	IF !EMPTY(cText)
		FWrite(nHdlPla, cText)
		cText:= ''
	ENDIF
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01OFF
Monta a linha de subtotal
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR53R01OFF(nHdlPla,nSpace,cValor,nMarg,aPeriodo,aSubTotal,nTotItens,lSubTotal)
Local cText		:= ""
Local nCnta		:= 0
Local nCntb		:= 0
Local nPosPer		:= 0
Local nTotPerc	:= 0
Local nContPerc	:= 0

cText += '<Row ss:AutoFitHeight="0">'+CRLF
cText += '<Cell ss:MergeAcross="2" ss:StyleID="m43403108"><Data ss:Type="String">'+space(nSpace)+cValor+'</Data></Cell>'+CRLF


//aPeriodo e aSubTotal são iguais
FOR nCnta:=1 TO LEN(aPeriodo)
	//Acompanhamento por centro de custo
	IF MV_PAR08==1 .OR. MV_PAR08==2			
		FOR nCntb:=3 TO LEN(aPeriodo[nCnta])
			IF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s108"><Data ss:Type="Number">'+ALLTRIM(STR((aSubTotal[nCnta][nCntb]/100)/nTotItens))+'</Data></Cell>'+CRLF
				IF lSubTotal
					aTotGeral[nCnta][nCntb]+= aSubTotal[nCnta][nCntb]/nTotItens
				ENDIF													
			ELSE
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s107"><Data ss:Type="Number">'+ALLTRIM(STR(aSubTotal[nCnta][nCntb]))+'</Data></Cell>'+CRLF
				IF lSubTotal
					aTotGeral[nCnta][nCntb]+= aSubTotal[nCnta][nCntb]
				ENDIF					
			ENDIF	
		NEXT nCntb	
	ELSE
		FOR nCntb:=3 TO LEN(aPeriodo[nCnta])
			IF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s108"><Data ss:Type="Number">'+ALLTRIM(STR(aSubTotal[nCnta][nCntb]/nTotItens))+'</Data></Cell>'+CRLF
				IF lSubTotal
					aTotGeral[nCnta][nCntb]+= aSubTotal[nCnta][nCntb]/nTotItens
				ENDIF				
			ELSEIF "TOTAL"$UPPER(aPeriodo[nCnta][nCntb])	
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s107"><Data ss:Type="Number">'+ALLTRIM(STR(aSubTotal[nCnta][nCntb]))+'</Data></Cell>'+CRLF
				nContPerc:= aSubTotal[nCnta][nCntb]
			ELSEIF "DEF"$UPPER(aPeriodo[nCnta][nCntb])	
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s107"><Data ss:Type="Number">'+ALLTRIM(STR(aSubTotal[nCnta][nCntb]))+'</Data></Cell>'+CRLF
				IF lSubTotal
					aTotGeral[nCnta][nCntb]+= aSubTotal[nCnta][nCntb]
				ENDIF				
			ELSEIF "% META"$UPPER(aPeriodo[nCnta][nCntb])	
				nTotPerc:= (aSubTotal[nCnta][nCntb][1] / aSubTotal[nCnta][nCntb][2]) / 100
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s108"><Data ss:Type="Number">'+ALLTRIM(STR(nTotPerc))+'</Data></Cell>'+CRLF
				IF lSubTotal
					aTotGeral[nCnta][nCntb][1]+= aSubTotal[nCnta][nCntb][1] / aSubTotal[nCnta][nCntb][2]
					aTotGeral[nCnta][nCntb][2]+= 1
				ENDIF								
			ELSE
				nTotPerc+= (aSubTotal[nCnta][nCntb]/100)/nTotItens
				cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s108"><Data ss:Type="Number">'+ALLTRIM(STR((aSubTotal[nCnta][nCntb]/100)/nTotItens))+'</Data></Cell>'+CRLF
				
				IF lSubTotal
					aTotGeral[nCnta][nCntb]+= aSubTotal[nCnta][nCntb]
				ENDIF								
			ENDIF	
		NEXT nCntb		
	ENDIF					
NEXT nCnta

IF lSubTotal
	nTotItGeral+= 1
ENDIF

cText += '</Row>'+CRLF

IF !EMPTY(cText)
	FWrite(nHdlPla, cText)
	cText:= ''
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01ITE
Monta os items
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR53R01ITE(nHdlPla,aDados,aPeriodo,nMarg,cDescAtu)
Local cText		:= ""
Local nCnta		:= 0
Local nCntb		:= 0
Local nPosPer		:= 0
Local nTotPerc	:= 0
Local nContPerc	:= 0

cText += '<Row ss:AutoFitHeight="0">'+CRLF

//Ajusta descrição do Departamento
U_PRPORE01(@cDescAtu)
		
cText += '<Cell ss:StyleID="s95"><Data ss:Type="String">'+cDescAtu+'</Data></Cell>'+CRLF
cText += '<Cell ss:StyleID="s94"><Data ss:Type="String">'+aDados[2]+'</Data></Cell>'+CRLF
cText += '<Cell ss:StyleID="s95"><Data ss:Type="String">'+aDados[3]+'</Data></Cell>'+CRLF

FOR nCnta:=1 TO LEN(aPeriodo)
	IF (nPosPer:= ASCAN(aDados[4],{|x| x[1]==aPeriodo[nCnta][1] })) > 0
		//Acompanhamento por centro de custo
		IF MV_PAR08==1 .OR. MV_PAR08==2			
			FOR nCntb:=3 TO LEN(aDados[4][nPosPer])
				IF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb]/100))+'</Data></Cell>'+CRLF
				ELSE
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb]))+'</Data></Cell>'+CRLF
				ENDIF	
				aSubCusto[nCnta][nCntb]+= aDados[4][nPosPer][nCntb]
			NEXT nCntb	
		ELSE
			FOR nCntb:=3 TO LEN(aDados[4][nPosPer])
				IF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(nTotPerc/nContPerc))+'</Data></Cell>'+CRLF
					aSubCusto[nCnta][nCntb]+= nTotPerc/nContPerc
					nTotPerc:= 0
				ELSEIF "TOTAL"$UPPER(aPeriodo[nCnta][nCntb])	
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb]))+'</Data></Cell>'+CRLF
					nContPerc:= aDados[4][nPosPer][nCntb]					
				ELSEIF "DEF"$UPPER(aPeriodo[nCnta][nCntb])	
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb]))+'</Data></Cell>'+CRLF
					aSubCusto[nCnta][nCntb]+= aDados[4][nPosPer][nCntb]					
				ELSE
					IF MV_PAR08==5 
						IF "% META"$UPPER(aPeriodo[nCnta][nCntb])	 
							//Peso menor que zero não teve lançamento de meta							
							IF aDados[4][nPosPer][nCntb][2] < 0
								cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s100"><Data ss:Type="String"></Data></Cell>'+CRLF
							ELSE						
								nTotPerc+= aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]/100
								cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]/100))+'</Data></Cell>'+CRLF
								aSubCusto[nCnta][nCntb][1]+= aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]
								aSubCusto[nCnta][nCntb][2]+= 1
							ENDIF
						ELSEIF "DESC."$UPPER(aPeriodo[nCnta][nCntb]) .OR. "JUST."$UPPER(aPeriodo[nCnta][nCntb])
							cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s100"><Data ss:Type="String">'+ ALLTRIM(aDados[4][nPosPer][nCntb]) +'</Data></Cell>'+CRLF
						ELSE
							cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]/100))+'</Data></Cell>'+CRLF																					
							aSubCusto[nCnta][nCntb]+= aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]							
						ENDIF
					ELSE
						IF "% META"$UPPER(aPeriodo[nCnta][nCntb])							
							//Peso menor que zero não teve lançamento de meta							
							IF aDados[4][nPosPer][nCntb][2] < 0
								cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s100"><Data ss:Type="String"></Data></Cell>'+CRLF
							ELSE
								nTotPerc+= aDados[4][nPosPer][nCntb][1]/100
								cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]/100))+'</Data></Cell>'+CRLF
								aSubCusto[nCnta][nCntb][1]+= aDados[4][nPosPer][nCntb][1]/aDados[4][nPosPer][nCntb][2]
								aSubCusto[nCnta][nCntb][2]+= 1
							ENDIF	
						ELSE
							nTotPerc+= aDados[4][nPosPer][nCntb]/100
							cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(aDados[4][nPosPer][nCntb]/100))+'</Data></Cell>'+CRLF
							aSubCusto[nCnta][nCntb]+= aDados[4][nPosPer][nCntb]
						ENDIF
					ENDIF						
				ENDIF	
			NEXT nCntb		
		ENDIF
	ELSE
		//Acompanhamento por centro de custo
		IF MV_PAR08==1 .OR. MV_PAR08==2	
			FOR nCntb:=3 TO LEN(aPeriodo[nCnta])
				IF UPPER(aPeriodo[nCnta][nCntb])=="NÃO"
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">1</Data></Cell>'+CRLF
					aSubCusto[nCnta][nCntb]+= 1
				ELSEIF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"	
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">0</Data></Cell>'+CRLF
				ELSEIF "TOTAL"$UPPER(aPeriodo[nCnta][nCntb])
					IF "TOTAL"$UPPER(aPeriodo[nCnta][nCntb])
						aSubCusto[nCnta][nCntb]+= 1
					ENDIF					
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">1</Data></Cell>'+CRLF				
				ELSE				
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">0</Data></Cell>'+CRLF	
				ENDIF					
			NEXT nCntb	
		ELSE
			FOR nCntb:=3 TO LEN(aPeriodo[nCnta])
				IF UPPER(aPeriodo[nCnta][nCntb])=="PERCENTUAL"
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">'+ALLTRIM(STR(nTotPerc/nContPerc))+'</Data></Cell>'+CRLF
					nTotPerc:= 0
				ELSEIF "TOTAL"$UPPER(aPeriodo[nCnta][nCntb])					
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">0</Data></Cell>'+CRLF
				ELSEIF "DEF"$UPPER(aPeriodo[nCnta][nCntb])					
					cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s97"><Data ss:Type="Number">0</Data></Cell>'+CRLF
				ELSE
					nContPerc++
					IF MV_PAR08==5
						cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s100"><Data ss:Type="String"></Data></Cell>'+CRLF
					ELSE			
						cText += '<Cell ss:MergeAcross="'+alltrim(str(nMarg))+'" ss:StyleID="s99"><Data ss:Type="Number">0</Data></Cell>'+CRLF
					ENDIF	
				ENDIF							
			NEXT nCntb			
		ENDIF
	ENDIF					
NEXT nCnta
cText += '</Row>'+CRLF

//Apenas Analitico
IF MV_PAR08==2 .OR. MV_PAR08==4	 .OR. MV_PAR08==5	
	IF !EMPTY(cText)
		FWrite(nHdlPla, cText)
		cText:= ''
	ENDIF
ENDIF

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01ROD
Monta o rodape do xml
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function PR53R01ROD(nHdlPla)
Local cText:= ""

cText += '</Table>'+CRLF
cText += '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cText += '<PageSetup>'+CRLF
cText += '<Header x:Margin="0.31496062000000002"/>'+CRLF
cText += '<Footer x:Margin="0.31496062000000002"/>'+CRLF
cText += '<PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CRLF
cText += 'x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CRLF
cText += '</PageSetup>'+CRLF
cText += '<Unsynced/>'+CRLF
cText += '<Print>'+CRLF
cText += '<ValidPrinterInfo/>'+CRLF
cText += '<PaperSizeIndex>9</PaperSizeIndex>'+CRLF
cText += '<HorizontalResolution>600</HorizontalResolution>'+CRLF
cText += '<VerticalResolution>600</VerticalResolution>'+CRLF
cText += '</Print>'+CRLF
cText += '<Zoom>85</Zoom>'+CRLF
cText += '<Selected/>'+CRLF
cText += '<DoNotDisplayGridlines/>'+CRLF
cText += '<Panes>'+CRLF
cText += '<Pane>'+CRLF
cText += '<Number>3</Number>'+CRLF
cText += '<ActiveRow>2</ActiveRow>'+CRLF
cText += '<RangeSelection>R1C1:R2C2</RangeSelection>'+CRLF
cText += '</Pane>'+CRLF
cText += '</Panes>'+CRLF
cText += '<ProtectObjects>False</ProtectObjects>'+CRLF
cText += '<ProtectScenarios>False</ProtectScenarios>'+CRLF
cText += '</WorksheetOptions>'+CRLF
cText += '</Worksheet>'+CRLF
cText += '</Workbook>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01SX1
Atualiza parametros 
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION PR53R01SX1(cPerg)
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

AADD(aDados,{cPerg,'01','Diretório ?','Diretório ?','Diretório ?','MV_CH1','C',80,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
AADD(aDados,{cPerg,'02','Departamento de ?','Departamento de ?','Departamento de ?','MV_CH2','C',TAMSX3("CTT_CUSTO")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','SQB','','','','',''} )
AADD(aDados,{cPerg,'03','Departamento até ?','Departamento até ?','Departamento até ?','MV_CH3','C',TAMSX3("CTT_CUSTO")[1],0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SQB','','','','',''} )
AADD(aDados,{cPerg,'04','Matricula de ?','Matricula de ?','Matricula de ?','MV_CH4','C',TAMSX3("RA_MAT")[1],0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','SRA','','','','',''} )
AADD(aDados,{cPerg,'05','Matricula até ?','Matricula até ?','Matricula até ?','MV_CH5','C',TAMSX3("RA_MAT")[1],0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','SRA','','','','',''} )
AADD(aDados,{cPerg,'06','Periodo de ?','Periodo de ?','Periodo de ?','MV_CH6','C',TAMSX3("RDU_CODIGO")[1],0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','RDU','','','','',''} )
AADD(aDados,{cPerg,'07','Periodo até ?','Periodo até ?','Periodo até ?','MV_CH7','C',TAMSX3("RDU_CODIGO")[1],0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','RDU','','','','',''} )
AADD(aDados,{cPerg,'08','Tipo de Relatório ?','Tipo de Relatório ?','Tipo de Relatório ?','MV_CH8','C',1,0,0,'C','','MV_PAR08','Ac. Depart.','Ac. Depart.','Ac. Depart.','','','Ac. Matricula','Ac. Matricula','Ac. Matricula','','','% Metas Depart.','% Metas Depart.','% Metas Depart.','','','% Metas Matric.','% Metas Matric.','% Metas Matric.','','','Desc. de metas','Desc. de metas','Desc. de metas','','','','','','',''} )

// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Informe o diretório.'},{''},{''}})
	AADD(aHelp, {'02',{'Informe o centro de custo inicial.'},{''},{''}}) 
	AADD(aHelp, {'03',{'Informe o centro de custo final.'},{''},{''}}) 
	AADD(aHelp, {'04',{'Informe a matricula inicial.'},{''},{''}}) 
	AADD(aHelp, {'05',{'Informe a matricula final.'},{''},{''}}) 
	AADD(aHelp, {'06',{'Informe o periodo inicial.'},{''},{''}}) 
	AADD(aHelp, {'07',{'Informe a periodo final.'},{''},{''}})
	AADD(aHelp, {'08',{'Informe a tipo de relatório.'},{''},{''}})
	//AADD(aHelp, {'09',{'Informe o status de movimento.'},{''},{''}}) 
	  	
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	
EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01CSS
Define os estilos do xml da planilha
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//--------------------------------------------------------------------------------------- 
Static Function PR53R01CSS(nHdlPla)
Local cText:= ""

cText += '<Styles>'+CRLF
cText += '<Style ss:ID="Default" ss:Name="Normal">'+CRLF
cText += '<Alignment ss:Vertical="Bottom"/>'+CRLF
cText += '<Borders/>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior/>'+CRLF
cText += '<NumberFormat/>'+CRLF
cText += '<Protection/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m65888296">'+CRLF
cText += '<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m65888316">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="m65888356">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#BDD7EE" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m65888376">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#BDD7EE" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m65888396">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#BDD7EE" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="m43403232">'+CRLF
cText += '<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m43403108">'+CRLF
cText += '<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
//cText += '<Interior ss:Color="#7F7F7F" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m43402904">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="m43402924">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s71">'+CRLF
cText += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="m190509008">'+CRLF
cText += ' <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CRLF
cText += ' <Borders>'+CRLF
cText += '  <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '  <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += ' </Borders>'+CRLF
cText += ' <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += '  ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="s94">'+CRLF
cText += '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'+CRLF
cText += '<NumberFormat ss:Format="@"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s95">'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'+CRLF
cText += '<NumberFormat/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="s97">'+CRLF
cText += '<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s98">'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
cText += 'ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s99">'+CRLF
cText += '<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'+CRLF
cText += '<NumberFormat ss:Format="Percent"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s100">'+CRLF
cText += '<Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cText += '<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'+CRLF
cText += '</Style>'+CRLF


cText += '<Style ss:ID="s107">'+CRLF
cText += '<Alignment ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s108">'+CRLF
cText += '<Alignment ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cText += '<NumberFormat ss:Format="Percent"/>'+CRLF
cText += '</Style>'+CRLF

cText += '<Style ss:ID="s109">'+CRLF
cText += '<Alignment ss:Vertical="Center"/>'+CRLF
cText += '<Borders>'+CRLF
cText += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '</Borders>'+CRLF
cText += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cText += '</Style>'+CRLF


cText += '<Style ss:ID="s187">'+CRLF
cText += '	<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CRLF
cText += '	<Borders>'+CRLF
cText += '		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '		<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '	</Borders>'+CRLF
cText += '	<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cText += '	<NumberFormat ss:Format="Short Date"/>'+CRLF
cText += '</Style>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

cText += '<Style ss:ID="s190">'+CRLF
cText += '	<Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CRLF
cText += '	<Borders>'+CRLF
cText += '		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CRLF
cText += '	</Borders>'+CRLF
cText += '	<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cText += '	<NumberFormat ss:Format="Short Time"/>'+CRLF
cText += '</Style>'+CRLF

cText += '</Styles>'+CRLF
// Inicia Worksheet e define os valores de lagura da ooluna
cText += '<Worksheet ss:Name="'+cTitulo+'">'+CRLF
cText += '<Table>'+CRLF
cText += '<Column ss:AutoFitWidth="0" ss:Width="180"/>'+CRLF
cText += '<Column ss:AutoFitWidth="0" ss:Width="69"/>'+CRLF
cText += '<Column ss:AutoFitWidth="0" ss:Width="246"/>'+CRLF

FWrite(nHdlPla, cText)
cText:= ''

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} PR53R01ESP
Altera caracter especial
@author  	Carlos Henrique
@since     	04/07/2016
@version  	P.12.6      
@return   	Nenhum 
/*/
//--------------------------------------------------------------------------------------- 
Static Function PR53R01ESP(cTexto)
Local aEsp:= {}

AADD(aEsp,{CHAR(10)," "})  	
AADD(aEsp,{'&','&amp;'})  	//ampersand
AADD(aEsp,{'<','&lt;'})  	//less-than
AADD(aEsp,{'>','&gt;'})  	//greater-than

/*
AADD(aEsp,{'"','&quot;'}) 	//quotation mark
AADD(aEsp,{"'",'&apos;'})  	//apostrophe 
AADD(aEsp,{'','&nbsp;'})  	//non-breaking space
AADD(aEsp,{'¡','&iexcl;'}) 	//inverted exclamation mark
AADD(aEsp,{'¢','&cent;'})  	//cent
AADD(aEsp,{'£','&pound;'}) 	//pound
AADD(aEsp,{'¤','&curren;'})	//currency
AADD(aEsp,{'¥','&yen;'})  	//yen
AADD(aEsp,{'¦','&brvbar;'})	//broken vertical bar
AADD(aEsp,{'§','&sect;'})  	//section
AADD(aEsp,{'¨','&uml;'})  	//spacing diaeresis
AADD(aEsp,{'©','&copy;'})  	//copyright
AADD(aEsp,{'ª','&ordf;'})  	//feminine ordinal indicator
AADD(aEsp,{'«','&laquo;'}) 	//angle quotation mark (left)
AADD(aEsp,{'¬','&not;'})  	//negation
AADD(aEsp,{'','&shy;'})  	//soft hyphen
AADD(aEsp,{'®','&reg;'})  	//registered trademark
AADD(aEsp,{'¯','&macr;'})  	//spacing macron
AADD(aEsp,{'°','&deg;'})  	//degree
AADD(aEsp,{'±','&plusmn;'})	//plus-or-minus 
AADD(aEsp,{'²','&sup2;'}) 	//superscript 2
AADD(aEsp,{'³','&sup3;'}) 	//superscript 3
AADD(aEsp,{'´','&acute;'})  //spacing acute
AADD(aEsp,{'µ','&micro;'})  //micro
AADD(aEsp,{'¶','&para;'})  	//paragraph
AADD(aEsp,{'·','&middot;'})	//middle dot
AADD(aEsp,{'¸','&cedil;'}) 	//spacing cedilla
AADD(aEsp,{'¹','&sup1;'}) 	//superscript 1
AADD(aEsp,{'º','&ordm;'})  	//masculine ordinal indicator
AADD(aEsp,{'»','&raquo;'}) 	//angle quotation mark (right)
AADD(aEsp,{'¼','&frac14;'})	//fraction 1/4
AADD(aEsp,{'½','&frac12;'})	//fraction 1/2
AADD(aEsp,{'¾','&frac34;'})	//fraction 3/4
AADD(aEsp,{'¿','&iquest;'})	//inverted question mark
AADD(aEsp,{'×','&times;'}) 	//multiplication
AADD(aEsp,{'÷','&divide;'})	//division
AADD(aEsp,{'À','&Agrave;'})	//capital a, grave accent
AADD(aEsp,{'Á','&Aacute;'})	//capital a, acute accent
AADD(aEsp,{'Â','&Acirc;'}) 	//capital a, circumflex accent
AADD(aEsp,{'Ã','&Atilde;'})	//capital a, tilde
AADD(aEsp,{'Ä','&Auml;'})  	//capital a, umlaut mark
AADD(aEsp,{'Å','&Aring;'}) 	//capital a, ring
AADD(aEsp,{'Æ','&AElig;'}) 	//capital ae
AADD(aEsp,{'Ç','&Ccedil;'})	//capital c, cedilla
AADD(aEsp,{'È','&Egrave;'})	//capital e, grave accent
AADD(aEsp,{'É','&Eacute;'})	//capital e, acute accent
AADD(aEsp,{'Ê','&Ecirc;'}) 	//capital e, circumflex accent
AADD(aEsp,{'Ë','&Euml;'})  	//capital e, umlaut mark
AADD(aEsp,{'Ì','&Igrave;'})	//capital i, grave accent
AADD(aEsp,{'Í','&Iacute;'})	//capital i, acute accent
AADD(aEsp,{'Î','&Icirc;'}) 	//capital i, circumflex accent
AADD(aEsp,{'Ï','&Iuml;'})  	//capital i, umlaut mark
AADD(aEsp,{'Ð','&ETH;'})  	//capital eth, Icelandic
AADD(aEsp,{'Ñ','&Ntilde;'})	//capital n, tilde
AADD(aEsp,{'Ò','&Ograve;'})	//capital o, grave accent
AADD(aEsp,{'Ó','&Oacute;'})	//capital o, acute accent
AADD(aEsp,{'Ô','&Ocirc;'}) 	//capital o, circumflex accent
AADD(aEsp,{'Õ','&Otilde;'})	//capital o, tilde
AADD(aEsp,{'Ö','&Ouml;'})  	//capital o, umlaut mark
AADD(aEsp,{'Ø','&Oslash;'})	//capital o, slash
AADD(aEsp,{'Ù','&Ugrave;'})	//capital u, grave accent
AADD(aEsp,{'Ú','&Uacute;'})	//capital u, acute accent
AADD(aEsp,{'Û','&Ucirc;'}) 	//capital u, circumflex accent
AADD(aEsp,{'Ü','&Uuml;'})  	//capital u, umlaut mark
AADD(aEsp,{'Ý','&Yacute;'})	//capital y, acute accent
AADD(aEsp,{'Þ','&THORN;'}) 	//capital THORN, Icelandic
AADD(aEsp,{'ß','&szlig;'}) 	//small sharp s, German
AADD(aEsp,{'à','&agrave;'})	//small a, grave accent
AADD(aEsp,{'á','&aacute;'})	//small a, acute accent
AADD(aEsp,{'â','&acirc;'}) 	//small a, circumflex accent
AADD(aEsp,{'ã','&atilde;'})	//small a, tilde
AADD(aEsp,{'ä','&auml;'})  	//small a, umlaut mark
AADD(aEsp,{'å','&aring;'}) 	//small a, ring
AADD(aEsp,{'æ','&aelig;'}) 	//small ae
AADD(aEsp,{'ç','&ccedil;'})	//small c, cedilla
AADD(aEsp,{'è','&egrave;'})	//small e, grave accent
AADD(aEsp,{'é','&eacute;'})	//small e, acute accent
AADD(aEsp,{'ê','&ecirc;'}) 	//small e, circumflex accent
AADD(aEsp,{'ë','&euml;'})  	//small e, umlaut mark
AADD(aEsp,{'ì','&igrave;'})	//small i, grave accent
AADD(aEsp,{'í','&iacute;'})	//small i, acute accent
AADD(aEsp,{'î','&icirc;'}) 	//small i, circumflex accent
AADD(aEsp,{'ï','&iuml;'})  	//small i, umlaut mark
AADD(aEsp,{'ð','&eth;'})  	//small eth, Icelandic
AADD(aEsp,{'ñ','&ntilde;'})	//small n, tilde
AADD(aEsp,{'ò','&ograve;'})	//small o, grave accent
AADD(aEsp,{'ó','&oacute;'})	//small o, acute accent
AADD(aEsp,{'ô','&ocirc;'}) 	//small o, circumflex accent
AADD(aEsp,{'õ','&otilde;'})	//small o, tilde
AADD(aEsp,{'ö','&ouml;'})  	//small o, umlaut mark
AADD(aEsp,{'ø','&oslash;'})	//small o, slash
AADD(aEsp,{'ù','&ugrave;'})	//small u, grave accent
AADD(aEsp,{'ú','&uacute;'})	//small u, acute accent
AADD(aEsp,{'û','&ucirc;'}) 	//small u, circumflex accent
AADD(aEsp,{'ü','&uuml;'})  	//small u, umlaut mark
AADD(aEsp,{'ý','&yacute;'})	//small y, acute accent
AADD(aEsp,{'þ','&thorn;'}) 	//small thorn, Icelandic
AADD(aEsp,{'ÿ','&yuml;'})  	//small y, umlaut mark
*/

//Realiza a substituição dos caracteres por entities
AEVAL(aEsp,{|x| cTexto:= strtran(cTexto,x[1],x[2]) })

cTexto:= ALLTRIM(cTexto)

RETURN cTexto