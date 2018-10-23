#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE CRLF ( chr(13)+chr(10) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSA001 ºAutor  ³ Marcos Pereira       º Data ³  19/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Quadro de Cargos em Excel - Especifico Prodam             º±±
±±º          ³                			                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Prodam                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSA001()

Local cCad_			:= ""
Local nOpc_			:= 0
Local aSay_			:= {}
Local aButt_		:= {}

Private cPerg       := "CSA001XX_" // Nome do arquivo de perguntas do SX1

//Processamento
cCad_		:= "Quadro de Cargos"

aAdd( aSay_, "Esta rotina tem como objetivo gerar uma planilha com o detalhamento" )
aAdd( aSay_, "da ocupação de cargos, conforme parâmetros escolhidos pelo usuário." )
aAdd( aSay_, "" )

aAdd( aButt_, { 5,.T.,{|| Pergunte(cPerg,.T.)    }})
aAdd( aButt_, { 1,.T.,{|| FechaBatch(),nOpc_ := 1 }})
aAdd( aButt_, { 2,.T.,{|| FechaBatch()            }})

//Verifica Perguntas
AjPerg(cPerg)
Pergunte(cPerg,.t.)

//Monta Tela Inicial
FormBatch( cCad_, aSay_, aButt_ )

If nOpc_ == 1
	Processa( {|| RunReport() }, "Processando..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunReport ³ Autor ³ 						 ³Data ³ 05.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Geracao da Planilha                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunReport()

Local aFunc  := {}
Local cCargo := '' 
local cDepto := ''
Local nX, nPos, nTipo, nY
Local aAux   := {}
Local aCargos:= {}
Local aGrupos:= {}

cString  := "SRA"
nLastKey := 0
aItensExcel := {}
aTotalExcel := {"","TOTAL",0,0,0,0,0,0}

If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif

If len(alltrim(MV_PAR01)) <> 6 .or. val(left(MV_PAR01,2)) < 1 .or. val(left(MV_PAR01,2)) > 12
	MsgAlert("A competência informada não é válida.")
	Return
EndIf

cAnoMes	:= substr(MV_PAR01,3,4) + left(MV_PAR01,2)
dDtBase 	:= stod( cAnoMes + '01' )
dDtBase 	:= stod( cAnoMes + strzero(f_ultdia(dDtBase),2) )
nTipo  	:= MV_PAR02
cSubGrupos	:= MV_PAR03
cCateg		:= MV_PAR04
cQryCateg 	:= "'" 
For nX := 1 to len(cCateg)
	cQryCateg += Substr(cCateg,nX,1) + "','"
Next nX
cQryCateg := left(cQryCateg,len(cQryCateg)-2) 

//Busca todos os Grupos e suas vagas para a competencia, de acordo com sub-grupos selecionados  pelo usuario
SZH->(dbsetorder(1))
SZG->(dbsetorder(1))
SZG->(dbgotop())
While SZG->(!eof())
	If SZG->ZG_SUBGRUP $ cSubGrupos
		nVagas := 0
		SZH->(dbseek(SZG->(ZG_FILIAL+ZG_GRUPO)))
		While SZH->(!eof()) .and. SZH->(ZH_FILIAL+ZH_GRUPO) == SZG->(ZG_FILIAL+ZG_GRUPO) .and. SZH->ZH_ANOMES <= cAnoMes
			nVagas 		:= SZH->ZH_VAGAS
			SZH->(dbskip())
		EndDo 
		aadd(aGrupos,{  SZG->ZG_GRUPO		,;	//1-Codigo do Grupo
						SZG->ZG_DESCRIC		,;	//2-Descricao do Grupo
						SZG->ZG_SUBGRUP		,;	//3-Sub-Grupo
						nVagas					 ;	//4-Vagas Autoriz.
					  } )
	EndIf
	SZG->(dbskip())
EndDo

//Comando principal, onde carrega todos funcionários
cQuery := " Select RA_FILIAL,RA_MAT,RA_CARGO,RA_DEPTO,RA_DEMISSA "
cQuery += " from " + RetSqlName("SRA") + " SRA "
cQuery += " where SRA.D_E_L_E_T_ <> '*' "
cQuery += " and RA_ADMISSA <= '" + dtos(dDtBase) + "' and (RA_DEMISSA > '" + cAnoMes+"01" + "' or RA_DEMISSA = '') "
cQuery += " and RA_CATFUNC IN (" + cQryCateg + ") "
//cQuery += " and RA_MAT = '008764' "

cQuery += " order by RA_DEPTO, RA_FILIAL, RA_MAT "

cQuery := ChangeQuery(cQuery)

If Select("AR0N") > 0
	DbSelectArea("AR0N")
	DbCloseArea("AR0N")
EndIf

dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

AR0N->(DbGotop())

//Buscar os codigos de afastamentos
RCM->(dbsetorder(1))
RCM->(dbgotop())
cTipoApos := ''
cTipoAfas := ''
While RCM->(!eof())
	If RCM->RCM_CODSEF == 'U3' 					//Aposentadoria por invalidez
		cTipoApos += RCM->RCM_TIPO + "/"
	ElseIf alltrim(RCM->RCM_CODSEF) $ "X*Y*" 	//Licenca sem Vencimentos e Outros
		cTipoAfas += RCM->RCM_TIPO + "/"
	EndIf
	RCM->(dbskip())
EndDo

SRA->(dbsetorder(1))
SR7->(dbsetorder(1))
SRE->(dbsetorder(2))
SR8->(dbsetorder(1))

ProcRegua(0)

While AR0N->(!eof())

	IncProc("Pesquisando departamento: " + AR0N->RA_DEPTO)

	//Busca o Cargo na SR7, se existir
	cCargo := AR0N->RA_CARGO
	If SR7->(dbseek(AR0N->(RA_FILIAL+RA_MAT)))
		While SR7->(!eof()) .and. SR7->(R7_FILIAL+R7_MAT) == AR0N->(RA_FILIAL+RA_MAT) .and. SR7->R7_DATA <= dDtBase
			cCargo := SR7->R7_CARGO
			SR7->(dbskip())
		EndDo
	EndIf
	
	//Verifica se o grupo no cadastro do cargo do funcionario esta dentro do aGrupos
	If aScan(aGrupos, {|x| x[1] == Posicione("SQ3",1,xFilial("SQ3")+cCargo,"Q3_XGRUPOQ") }) > 0

		//Busca o Depto na SRE, se existir
		cDepto := AR0N->RA_DEPTO
		If SRE->(dbseek(cEmpAnt+PADR(AR0N->RA_FILIAL,12)+AR0N->RA_MAT))
			While SRE->(!eof()) .and. SRE->(RE_EMPP+RE_FILIALP+RE_MATP) == (cEmpAnt+PADR(AR0N->RA_FILIAL,12)+AR0N->RA_MAT) .and. SRE->RE_DATA <= dDtBase
				If !empty(SRE->RE_DEPTOP)
					cDepto := SRE->RE_DEPTOP
				EndIf
				SRE->(dbskip())
			EndDo
		EndIf
	
		//Verifica os afastamentos 
		lAposent := .f.
		lAfast	 := .f.
		cTipoAfa := ''
		If SR8->(dbseek(AR0N->(RA_FILIAL+RA_MAT)))
			While SR8->(!eof()) .and. SR8->(R8_FILIAL+R8_MAT) == AR0N->(RA_FILIAL+RA_MAT)
				If SR8->R8_DATAINI <= dDtBase .and. (SR8->R8_DATAFIM >= dDtBase .or. empty(SR8->R8_DATAFIM))
					If SR8->R8_TIPOAFA $ cTipoApos
						lAposent := .t.
					ElseIf SR8->R8_TIPOAFA $ cTipoAfas
						lAfast := .t.
					EndIf
					cTipoAfa += SR8->R8_TIPOAFA + '/'
					exit
				EndIf
				SR8->(dbskip())
			EndDo
		EndIf
	
		//Verifica se tem demissao no mes
		lDemissa := .f.
		If !empty(AR0N->RA_DEMISSA) .and. left(AR0N->RA_DEMISSA,6) == cAnoMes
			lDemissa := .t.
		EndIf
	
		//Alimenta aFunc com query e informacoes historicas
		aadd(aFunc,{	cCargo				,; 	//1-Codigo Cargo
						cDepto				,;	//2-Codigo Depto
						AR0N->RA_FILIAL 	,;	//3-Filial
						AR0N->RA_MAT		,;	//4-Matricula
						lAposent			,;	//5-Aposentado por invalidez
						lAfast				,;	//6-Afastado
						cTipoAfa			,;	//7-Tipo Afastamento
						lDemissa			,;	//8-Demissao no mes
						SQ3->Q3_XGRUPOQ	 ;	//9-Cod.Grupo
						})

	EndIf
	
	AR0N->(dbskip())
	
EndDo
	
// Fecha Arquivo Temporario
If Select("AR0N") > 0
	DbSelectArea("AR0N")
	DbCloseArea("AR0N")
EndIf

If nTipo == 1 		//Sintetico (por codigo do grupo)
	ASORT( aFunc,,, {|x,y| x[9]+x[2]+x[3]+x[4] < y[9]+y[2]+y[3]+y[4] } ) //Cod.Grupo+Depto+Filial+Matricula
Else 	
	ASORT( aFunc,,, {|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] } ) //Cargo+Depto+Filial+Matricula
EndIf

For nX := 1 to len(aFunc)

	//Posiciona SRA
	SRA->(dbseek(aFunc[nX,3]+aFunc[nX,4]))

	IncProc("Processando: " + SRA->RA_FILIAL + '  - ' + SRA->RA_MAT)

	If nTipo == 1 //Se Sintetico 
	
		If (nPos  := aScan(aItensExcel,{|x| x[1] == aFunc[nX,9] })) > 0 	//Se ja existe o codigo do grupo

			aItensExcel[nPos,4]  += if(aFunc[nX,5] .or. aFunc[nX,6] .or. aFunc[nX,8],0,1)	//Soma ativo (nao pode ser Aposent ou Afast ou Rescisao)
			aItensExcel[nPos,5]  += if(aFunc[nX,5],1,0)											//Soma Aposent
			aItensExcel[nPos,6]  += if(aFunc[nX,6],1,0)											//Soma Afast
			aItensExcel[nPos,8]  := 	aItensExcel[nPos,3]-aItensExcel[nPos,4]-;
										aItensExcel[nPos,5]-aItensExcel[nPos,6]-;
										aItensExcel[nPos,7]										   //Saldo (Autoriz-Ativ-Apos-Lic-Aprov-Aguard.Aprov)
			
		Else
		
			//Busca as informacoes das vagas abertas no RSP
			nAprov := fBuscaRSP(aFunc[nX,9]) //Passa o codigo do grupo
						
			nPos := aScan(aGrupos, {|x| x[1] == aFunc[nX,9] })
	
			aAdd( aItensExcel, { aFunc[nX,9]													,;	//1-Codigo do grupo
									aGrupos[nPos,2]												,;	//2-Descricao grupo
									aGrupos[nPos,4]												,;	//3-Autorizado
									if(aFunc[nX,5] .or. aFunc[nX,6] .or. aFunc[nX,8],0,1)	,;	//4-Ativos
									if(aFunc[nX,5],1,0)											,;	//5-Aposent.Invalidez
									if(aFunc[nX,6],1,0)	  										,;	//6-Licenca sem Remun
									nAprov															,;	//7-Aprovadas
									0															 	 ;	//8-Saldo
									} )

			nPos := len(aItensExcel)
								
			//Atualiza Aguard.Aprov e Saldo
			aItensExcel[nPos,8]  := 	aItensExcel[nPos,3]-aItensExcel[nPos,4]-;
										aItensExcel[nPos,5]-aItensExcel[nPos,6]-;
										aItensExcel[nPos,7]										   //Saldo (Autoriz-Ativ-Apos-Lic-Aprov-Aguard.Aprov)
								
		EndIf
		
	Else  //Se Analitico

		aAdd( aItensExcel, { aFunc[nX,1]														,;	//1-Codigo Cargo
								Posicione("SQ3",1,xFilial("SQ3")+aFunc[nX,1],"Q3_DESCSUM")	,;	//2-Descricao Cargo
								aFunc[nX,2]														,;	//3-Codigo Depto
								Posicione("SQB",1,xFilial("SQB")+aFunc[nX,2],"QB_DESCRIC")	,;	//4-Descricao Depto
								aFunc[nX,4]														,;	//5-Matricula
								SRA->RA_NOME														,;	//6-Nome do Funcionario
								SRA->RA_ADMISSA													,;	//7-Admissao
								if(aFunc[nX,8],SRA->RA_DEMISSA,'')								,;	//8-Demissao
								aFunc[nX,7]												 		 ;	//9-Afastamento
								} )

	EndIf
	
		
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera arquivo XLS com registros 				                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipo == 1 //Sintetico
	aCabec := {"Grupo","Descr.Grupo","Autorizado","Ativos", "Aposent.Invalidez", "Licença s/Remun.","Aprovadas","Saldo"}
	//Soma totais
	For nX := 1 to len(aItensExcel)
		For nY := 3 to 8
			aTotalExcel[nY] += aItensExcel[nX,nY]
		Next nY
	Next nX
	aadd(aItensExcel,aTotalExcel) 

Else //Analitico
	aCabec := {"Cod.Cargo","Descr.Cargo","Cod.Depto","Descr.Depto","Matricula", "Nome", "Admissão", "Demissão","Tipo Afastam."}

EndIf

MsgRun( "Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"ARRAY","Quadro de Cargos  - Posição de "+dtoc(dDtBase),aCabec,	aItensExcel}})} )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjPerg    ³ Autor ³                        ³Data ³ 05.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Verificacao de Perguntas                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjPerg()

Local i,j

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
aHelp :={" Informe a competencia desejada no ",;
		 " formato MMAAAA. "	}
aAdd(aRegs,{CPERG,'01','Competencia (MMAAAA)   ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','              ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Sintetico -> Resumo geral ",;
		 " Analitico -> Por funcionário" }
aAdd(aRegs,{CPERG,'02','Tipo                   ?','','','mv_ch2','N',01,0,0,'C','           ','mv_par02','Sintetico      ','','','','','Analitico     ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Informe os Tipos de Quadros desejados ",;
		 " para composição da planilha. Informe-os ",;
		 " sem separadores. Ex: 0123456789ABC"	}
aAdd(aRegs,{CPERG,'03','Tipos de Quadros       ?','','','mv_ch3','C',30,0,0,'G','           ','mv_par03','               ','','','','','              ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})
aHelp :={" Informe ou selecione as categorias para ",;
		 " composição da planilha, utilizando como ",;
		 " filtro no cadastro dos funcionários. "	}
aAdd(aRegs,{CPERG,'04','Categorias             ?','','','mv_ch4','C',12,0,0,'G','fCategoria ','mv_par04','               ','','','','','              ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',aHelp})

ValidPerg(aRegs,cPerg,.T.)

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return



Static Function fBuscaRSP(cGrupo)

Local cQuery
Local nRet := 0

cQuery := " select sum(QS_VAGAFEC) AS FECH, sum(QS_NRVAGA) AS VAGAS from " + RetSqlName("SQS") + " SQS "
cQuery += " inner join " + RetSqlName("SQ3") + " SQ3 on Q3_CARGO = QS_FUNCAO "
cQuery += " where SQS.D_E_L_E_T_ <> '*' and SQ3.D_E_L_E_T_ <> '*' "
cQuery += " and Q3_XGRUPOQ = '" + cGrupo + "' "
cQuery += " and QS_DTABERT <= '" + dtos(dDtBase) + "' "
cQuery += " and ((QS_DTFECH = '' and QS_VAGAFEC < QS_NRVAGA) or (QS_DTFECH > '" + dtos(dDtBase) + "' and QS_VAGAFEC = QS_NRVAGA)) "

cQuery := ChangeQuery(cQuery)

If Select("SQSXSQ3") > 0
	DbSelectArea("SQSXSQ3")
	DbCloseArea("SQSXSQ3")
EndIf

dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'SQSXSQ3', .T., .F. )

If SQSXSQ3->(!eof())
	nRet := SQSXSQ3->VAGAS - SQSXSQ3->FECH
EndIf
 
If Select("SQSXSQ3") > 0
	DbSelectArea("SQSXSQ3")
	DbCloseArea("SQSXSQ3")
EndIf

Return(nRet)