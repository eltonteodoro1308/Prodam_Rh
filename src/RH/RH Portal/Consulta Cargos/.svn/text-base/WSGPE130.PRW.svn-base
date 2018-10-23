#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

Function WSGPE130()
Return

WSSTRUCT TPostList
	WSDATA Cod					As String
	WSDATA Desc					As String
	WSDATA Esp					As String
	WSDATA DescDet				As String
	WSDATA Resp					As String
	WSDATA Skills				As String
	WSDATA Relac				As String
ENDWSSTRUCT

WSSTRUCT TPostBrowse
	WSDATA Itens				AS Array Of TPostList	OPTIONAL
	WSDATA PagesTotal			AS Integer 				OPTIONAL
ENDWSSTRUCT

WSSERVICE RHPost DESCRIPTION "Descritivo de Cargos"
	WSDATA WsNull   	   		As String	OPTIONAL

	WSDATA CurrentPage			As Integer
	WSDATA FilterField  		As String
	WSDATA FilterValue			As String
	
	WSDATA Cod					As String
	WSDATA Desc					As String
	WSDATA Esp					As String
	WSDATA DescDet				As String
	WSDATA Resp					As String
	WSDATA Skills				As String
	WSDATA Relac				As String
	
	WSDATA ContHtml				AS String	OPTIONAL
	
	WSDATA PostBrowse   		As TPostBrowse
	
	WSMETHOD BrowsePost		DESCRIPTION "Método de consulta do Descritivo de Cargos"
ENDWSSERVICE 


WSMETHOD BrowsePost;
WSRECEIVE CurrentPage, FilterField, FilterValue;
WSSEND PostBrowse;
WSSERVICE RHPost
	Local cFiltro
	Local cSQ3CountAlias	:= GetNextAlias()
	Local cSQ3Alias			:= GetNextAlias()
	Local nRegIni           := 1
	Local nRegFim			:= 0
	Local nReg				:= 0
	Local uRetBlock			:= ""
	
	cFiltro := " SQ3.Q3_FILIAL = '" + xFilial("SQ3") + "' AND ("
	cFiltro	+= " SQ3.Q3_DESCSUM LIKE '%" + FilterValue + "%' COLLATE LATIN1_GENERAL_CI_AI "
	cFiltro	+= " OR SQ3.Q3_XESPECI LIKE '%" + FilterValue + "%' COLLATE LATIN1_GENERAL_CI_AI)"
	
	Self:PostBrowse:= WSClassNew("TPostBrowse")	   
	::PostBrowse:Itens := {}
	
	If ExistBlock("WSGP130")
		uRetBlock := ExecBlock( "WSGP130", .F., .F. )
		If ( ValType( uRetBlock ) <> "C" )
			uRetBlock := "" //Esvazia para não ocorrer erro
		EndIf
	EndIf
	
	If !Empty(uRetBlock)
		cFiltro += " AND " + uRetBlock
	EndIf

	cFiltro := "% " + cFiltro + " %"
	
	BEGINSQL alias cSQ3CountAlias
			SELECT COUNT(*) AS REGISTROS
		      FROM %table:SQ3% SQ3
		     WHERE %exp:cFiltro% 
	           AND SQ3.%notDel%		
	ENDSQL
	
	If (cSQ3CountAlias)->REGISTROS > 0
	    // Seta a quantidade de paginas
		Self:PostBrowse:PagesTotal := Ceiling((cSQ3CountAlias)->REGISTROS / PAGE_LENGTH) 
		
		// Define qual a página inicial e final de acordo com a paginacao corrente		
		nRegFim	:= CurrentPage * PAGE_LENGTH
		If CurrentPage > 1
			nRegIni	:= (nRegFim - PAGE_LENGTH) + 1			
		EndIf
		
		BEGINSQL alias cSQ3Alias
				SELECT SQ3.Q3_CARGO, 
					   SQ3.Q3_DESCSUM,
			           SQ3.Q3_XESPECI,
			           SQ3.Q3_DESCDET,
			           SQ3.Q3_DRESP,
			           SQ3.Q3_DRELINT,
			           SQ3.Q3_DHABILI
			      FROM %table:SQ3% SQ3
			     WHERE %exp:cFiltro% 
		           AND SQ3.%notDel% 
			  ORDER BY Q3_DESCSUM 
		ENDSQL
		
		While (cSQ3Alias)->( !Eof())
		    nReg++
		    
	    	If nRegIni <= nReg .AND. nRegFim >=  nReg 
				oItem:= WSClassNew("TPostList")
				oItem:Cod		:= (cSQ3Alias)->Q3_CARGO
				oItem:Desc		:= (cSQ3Alias)->Q3_DESCSUM
				oItem:Esp		:= (cSQ3Alias)->Q3_XESPECI
				oItem:DescDet	:= MSMM((cSQ3Alias)->Q3_DESCDET)
				oItem:Resp		:= MSMM((cSQ3Alias)->Q3_DRESP)
				oItem:Skills	:= MSMM((cSQ3Alias)->Q3_DHABILI)
				oItem:Relac		:= MSMM((cSQ3Alias)->Q3_DRELINT)
				
				aAdd(::PostBrowse:Itens, oItem)
			EndIf
	
			(cSQ3Alias)->( dbSkip() )
		EndDo
	Else
		oItem:= WSClassNew("TPostList")
		oItem:Cod		:= ""
		oItem:Desc		:= ""
		oItem:Esp		:= ""
		oItem:DescDet	:= ""
		oItem:Resp		:= ""
		oItem:Skills	:= ""
		oItem:Relac		:= ""
		
		aAdd(::PostBrowse:Itens, oItem)
		Self:PostBrowse:PagesTotal	:= 0	
	EndIf
Return .T. 