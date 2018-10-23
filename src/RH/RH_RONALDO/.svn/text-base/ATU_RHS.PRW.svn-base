#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATU_RHS   º Autor ³ Ronaldo Oliveira º Data ³    31/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Carga da tabela RHS.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Prodam                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ATU_RHS


Private _aCampos   := {}
Private _aConteudo := {}
Private _cDiaret   := DTOS(Date())

_cDiaret := Substr(_cDiaret,3,2)+Substr(_cDiaret,5,2)+Substr(_cDiaret,7,2)

If !Msgyesno("Efetua carga da tabela RHS ?")
   Return  
Endif

Aadd(_aCampos,"RHS_FILIAL")
Aadd(_aCampos,"RHS_MAT")   
Aadd(_aCampos,"RHS_DATA")  
Aadd(_aCampos,"RHS_ORIGEM")
Aadd(_aCampos,"RHS_CODIGO")
Aadd(_aCampos,"RHS_TPLAN")
Aadd(_aCampos,"RHS_TPFORN")
Aadd(_aCampos,"RHS_CODFOR")
Aadd(_aCampos,"RHS_TPPLAN")
Aadd(_aCampos,"RHS_PLANO") 
Aadd(_aCampos,"RHS_PD")    
Aadd(_aCampos,"RHS_VLRFUN")
Aadd(_aCampos,"RHS_VLREMP")
Aadd(_aCampos,"RHS_COMPPG")
Aadd(_aCampos,"RHS_DATPGT")
Aadd(_aCampos,"RHS_DTHRGR")

Processa({|| _CriaSql()},"Atualizando a Tabela RHS ...")

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para obter os dados no banco de dados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function _CriaSql

cQuery := "SELECT COUNT(*) AS TOTRECS" 
cQuery += " FROM "+RetSqlname("SRD")+" SRD, "+RetSqlname("SRA")+" SRA"
cQuery += " WHERE RD_FILIAL = RA_FILIAL"
cQuery += " AND RD_MAT = RA_MAT"
cQuery += " AND RD_DATARQ  >=  '201601'  AND  RD_DATARQ  <=  '201606'"
cQuery += " AND	(RD_PD  IN  ('527','528'))"
cQuery += " AND SRD.D_E_L_E_T_ = ' '"
cQuery += " AND SRA.D_E_L_E_T_ = ' '"
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
dbSelectarea("TRB")
TRB->(dbgotop())
_nTotrecs := TRB->TOTRECS
TRB->(dbclosearea())


cQuery := "SELECT RD_FILIAL, RD_MAT, RD_PD, RD_DATARQ, RD_DATPGT, RD_VALOR, RD_SEQ,"
cQuery += " CASE WHEN RD_PD IN('527','528','691') THEN '1' ELSE '2'  END AS ORIGEM"
cQuery += " FROM "+RetSqlname("SRD")+" SRD, "+RetSqlname("SRA")+" SRA"
cQuery += " WHERE RD_FILIAL = RA_FILIAL"
cQuery += " AND RD_MAT = RA_MAT"
cQuery += " AND RD_DATARQ  >=  '201601'  AND  RD_DATARQ  <=  '201606'"
cQuery += " AND	(RD_PD  IN  ('527','528','691'))"
cQuery += " AND SRD.D_E_L_E_T_ = ' '"
cQuery += " AND SRA.D_E_L_E_T_ = ' '"
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
dbSelectarea("TRB")
TRB->(dbgotop())

ProcRegua(_nTotrecs)

While !Eof()
   _nVlrfun := TRB->RD_VALOR 
   _nVlremp := 0
   _lGera   := .F.
   _aVerbas := {}
   _cFil    := TRB->RD_FILIAL
   _cMat    := TRB->RD_MAT
   _cDatpgt := TRB->RD_DATPGT
   _cOrigem := IIF(TRB->RD_PD $("527/528/691"),"1","2")
   _cPD     := TRB->RD_PD
   _cDatarq := TRB->RD_DATARQ
   _cVerba  := TRB->RD_PD
   _cTplan  := IIF (_cVerba $("527/528/691"),"1","2")
   _cTpforn := IIF(TRB->RD_PD $("527/691"),"1","2")
   _cCodforn:= "001"
   _cTpplan := "1"
   _cPlano  := "01"
   _cCodigo := ""
   If _cOrigem == "2" // Obter o codigo de dependente
      _cCodigo := "0" //_Vercod(_cFil,_cMat,_cPesq)
   Endif
   If _cOrigem == "1" .And. _cTplan == "1" .and. _cVerba = "527" .and. TRB->RD_SEQ = ' '
      AADD(_aVerbas,"527")
      AADD(_aVerbas,"691")
      _nVlrfun := _Sumverb(_cFil,_cMat,_cDatarq,_aVerbas)
     _lGera := .T.
   ElseIf _cOrigem == "1" .And. _cTpforn == "2" .and. TRB->RD_SEQ = ' '      
      AADD(_aVerbas,"528")
      _nVlrfun := _Sumverb(_cFil,_cMat,_cDatarq,_aVerbas)
      _lGera := .T. 
   Endif

   If _lGera
   		//Valor do Empregador
	    If _cTplan == "1"
     	   _aVerbas := {}
		   AADD(_aVerbas,"714")
           _nVlremp := 0 // _Sumverb(_cFil,_cMat,_cDatarq,_aVerbas)
        Endif
        _cHoraRet:=Left(Time(),2)+SubStr(Time(),4,2)
        _cDthrgr := _cDiaret+_cHoraRet
        AADD(_aConteudo,{_cFil,_cMat,_cDatpgt,_cOrigem,_cCodigo,_cTplan,_cTpforn,_cCodforn,_cTpplan,_cPlano,_cVerba,_nVlrfun,_nVlremp, _cDatarq,_cDatpgt,_cDthrgr})
        //Grava o Registro na tabela
        _AtuTAB()
        _aConteudo := {}
   Endif
   IncProc()
   dbSelectarea("TRB")
   TRB->(dbSkip())

Enddo
Return

//Função para totalizar os valores de verbas
Static Function _Sumverb(_cFil,_cMat,_cDatarq,_aVerbas)

_aAreaant:= Getarea()
_nValtot := 0

cQuery := "SELECT Sum(RD_VALOR) AS VALOR"
cQuery += " FROM "+RetSqlname("SRD")
cQuery += " WHERE RD_FILIAL = '"+_cFil+"'"
cQuery += " AND RD_MAT = '"+_cMat+"'"
cQuery += " AND RD_DATARQ = '"+_cDatarq+"'"
cQuery += " AND RD_PD IN ('"
For _z := 1 To Len(_aVerbas)
   If _z < Len(_aVerbas)
      cQuery += _aVerbas[_z]+"','"
   Else
      cQuery += _aVerbas[_z]+"')"   
   Endif   
Next _z
cQuery += " AND D_E_L_E_T_ = ' '
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TR2", .F., .T.)
dbSelectarea("TR2")
TR2->(dbgotop())

_nValtot := TR2->VALOR

TR2->(dbClosearea())

Restarea(_aAreaant)

Return(_nValtot)


//Função para inserir registros na tabela RHS
Static Function _AtuTAB()

_aArea:= Getarea()

dbSelectarea("RHS")

For _y := 1 To Len(_aConteudo)
    Reclock("RHS",.T.)
    For _zz := 1 To Len(_aCampos)
        FieldPut(Fieldpos(_aCampos[_zz]),_aConteudo[_y,_zz])
    Next _zz
    RHS->(Msunlock())
Next _y

Restarea(_aArea)

Return




