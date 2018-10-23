#INCLUDE "TOTVS.CH"

/*/ {Protheus.doc} F0102109()

@Project     MAN00000011501_EF_021
@author      Jackson Capelato
@since       05/10/15
@version     P12.5
@Return      Funcao para importa豫o Co-Participa豫o
@Obs
@Menu    	 Importa豫o da Co-Participa豫o
/*/

USER Function F0102109()
IF Pergunte("FSW0102109",.T.)

	If Empty(MV_PAR01)
		Return .F.
	Endif

	Processa( {|| LeitCop() } , "Realizando a Importa豫o da Co-Participa豫o...Aguarde..." )

Endif
Return .t.

Static Function LeitCop()

local nLastRec
local nLinha
local aBuffer
local cBuffer
local lOK
Local nx      := 0
local aARQ
local aFIM
local cMATR
local cPLN  := ''
local cPER  := ''
local cCIC  := ''
local nSAL  := 0
local nGRT  := 0
local nPF   := 0
local nPE   := 0
local nPERCT:=0
LOCAL cDEP  := ''
LOCAL nVLR  := 0
LOCAL nQT   := 0
LOCAL aTOT
LOCAL nPOS  := 0
Local nSubs := 0

FT_FUSE(MV_PAR01)
FT_FGOTOP()
nLastRec := FT_FLASTREC()
nLinha:=0
aBuffer:={}
aARQ:={}
aTOT:={}
aFIM:={}
lOK:=.T.

ProcRegua(nLastRec)

DO While !FT_FEOF()
	nLinha := nLinha + 1
	IncProc("Importando linha:" + StrZero(nLinha,5) + "/" + StrZero(nLastRec,5))

	IF nLinha > 1
		cBuffer := FT_FREADLN()

		CBuffer := StrTran(cBuffer,";;","; ;")

		AADD(aBuffer,MyStr2Array(cBuffer,";"))
	Endif
	FT_FSKIP()

ENDDO

//cMATR := SUBSTR(aBuffer[01][01],3,6)
cMATR := Right("000000"+aBuffer[01][01],6)
nVLR  := 0
nCOP  := 0
cPLN  := ''
cPER  := ''
cCIC  := ''
cDEP  := ''
nQT	  := 0
dDT   := LASTDAY(dDATABASE,1)

FOR nX = 1 TO LEN(aBuffer)

	IF cMATR # (Right("000000"+aBuffer[nX][01],6))	//SUBSTR(aBuffer[nX][01],3,6)

		AADD(aTOT,{cMATR,nVLR,nQT})

		cMATR := Right("000000"+aBuffer[nX][01],6)	//SUBSTR(aBuffer[nX][01],3,6)
		nVLR  := VAL(aBuffer[nX][02])/100
		nCOP  := VAL(aBuffer[nX][02])/100
		cPLN  := SUBSTR(aBuffer[nX][07],1,AT(' ',aBuffer[nX][07])-1)
		cPER  := SUBSTR(DTOS(MV_PAR03),1,6)
		cCIC  := aBuffer[nX][06]
		cDEP  := aBuffer[nX][05]
		nQT   := 1
		dDT   := LASTDAY(dDATABASE,1)
	ELSE
		cMATR := Right("000000"+aBuffer[nX][01],6)	//SUBSTR(aBuffer[nX][01],3,6)
		nVLR  += VAL(aBuffer[nX][02])/100
		nCOP  := VAL(aBuffer[nX][02])/100
		cPLN  := SUBSTR(aBuffer[nX][07],1,AT(' ',aBuffer[nX][07])-1)
		cPER  := SUBSTR(DTOS(MV_PAR03),1,6)
		cCIC  := aBuffer[nX][06]
		cDEP  := aBuffer[nX][05]
		dDT   := dDT+1
		nQT   := nQt+1
	ENDIF
	AADD(aARQ,{cMATR,nVLR,cPLN,cPER,cCIC,cDEP,nCOP,nQT,dDT})

NEXT
AADD(aTOT,{cMATR,nVLR,nQT})
nLinha := 0
nVLR  := 0
nPF   := 0
nPE   := 0
nPERCT:=0
nFat := 0

FOR nX := 1 TO LEN(aARQ)

	DBSELECTAREA("SRA")
	SRA->(DBSETORDER(1))

	SRA->(DBSEEK(XFILIAL("SRA")+aARQ[nX][01]))

	IF !EOF()
		nSAL:=SRA->RA_SALARIO
		nGRT:= U_f0100204('P')
//		nSubs := U_f0100402('P')

		nLinha:= fPosTab("U053",ALLTRIM(aARQ[nX][03]),'=',5)

		nLinha:= IIF(nLinha=0,1,nLinha)

		nPERCT:= fTabela("U053",nLinha,13,,) / 100

		nVLR  := (nSAL+nGRT+nSubs)*nPERCT

		nPOS := ASCAN( aTOT,{|X| ALLTRIM(X[1]) = aARQ[nX][01] } )

		IF aTOT[nPOS][02] > nVLR .AND. MV_PAR04 = 1
			nFat := aTOT[nPOS][02] - nVLR
			nPC := aARQ[nX][07] / aTOT[nPOS][02]
			nPF := nVLR * nPC
			nPE := nFat * nPC
			
			//nPF := aARQ[nX][07]
			//nQT := aTOT[nPOS][02] - nVLR
			//nPC := aARQ[nX][07] / aTOT[nPOS][02]
			//nPE := nQT * nPC			
		ELSE
			nPF := aARQ[nX][07]
			nPE := 0
		ENDIF

		cQuery := "SELECT RB_COD SEQ, RB_NOME NOMED, RB_CIC CPFD FROM " + RetSqlName ("SRB") + " A "
		cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
		If Empty(aARQ[nX][5])
			cQuery += "AND RB_NOME = '" + aARQ[nX][6] + "' "
		Else
			cQuery += "AND RB_CIC = '" + aARQ[nX][05] + "' "
		EndIf
		cQuery += " AND RB_MAT = '" + aARQ[nX][1] + "' "
		Iif( Select("TRG1") > 0,TRG1->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRG1",.F.,.T.)

		dbSelectArea("TRG1")
		dbgotop()

		IF !EOF()
		   cSEQ :=TRG1->SEQ
		   cNOME:=TRG1->NOMED
		   cCIC :=TRG1->CPFD
		   fFAROL:=.T.
		ELSE
		   cSEQ :='00'
		   cNOME:=SRA->RA_NOME
		   cCIC :=SRA->RA_CIC
		   fFAROL:=.F.
		ENDIF

		DbSelectArea( "RHO" )
		RHO->( RecLock( "RHO" , .T. ) )
		RHO->RHO_FILIAL := XFILIAL("RHO")
		RHO->RHO_MAT	:= aARQ[nX][01]
		RHO->RHO_DTOCOR	:= aARQ[nX][09]
		RHO->RHO_ORIGEM := IIF(fFAROL,'2','1')
		RHO->RHO_TPFORN	:= '1'
		RHO->RHO_CODFOR	:= fTabela("U053",nLinha,16,,)
		RHO->RHO_CODIGO	:= cSEQ
		RHO->RHO_TPLAN	:= '1'
		RHO->RHO_PD  	:= MV_PAR02
		RHO->RHO_VLRFUN	:= nPF
		RHO->RHO_VLREMP	:= nPE
		RHO->RHO_COMPPG	:= aARQ[nX][04]
		RHO->RHO_OBSERV := TRG1->NOMED + ' - ' + TRG1->CPFD
		RHO->(MsUnlock())

	ENDIF

NEXT

Return

Static Function MyStr2Array(cTexto,cSepara)

Local aRetorno := {}
Local nx      := 0
Local cVar     := ""

Default cTexto := ""
Default cSepara:= ""

For nx := 1 to len(cTexto)
	If Substr(cTexto,nx,1) == cSepara
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴??
		//?aso venha arroba no campo, indica que o registro est?em branco?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴??
		If "@" $ cVar
			cVar := ""
		Endif

		aadd(aRetorno,AllTrim(cVar))
		cVar := ""
	Else
		cVar += Substr(cTexto,nx,1)
	Endif
Next

If !Empty(cVar)
	aadd(aRetorno,AllTrim(cVar))
Endif

Return aRetorno
