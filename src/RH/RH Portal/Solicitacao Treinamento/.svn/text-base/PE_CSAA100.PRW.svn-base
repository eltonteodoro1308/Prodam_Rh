//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CSAA100
Ponto de Entrada na confirmacao do Cadastro de Departamentos
@author  	Marcos Pereira
@since     	30/10/2016
@version  	P.12.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CSAA100

Local cCmd

//Tratamento para gravar histotico do responsavel pelo departamento e
//troca do aprovador nas requisicoes ja existentes do Portal GCH pelo
//novo responsavel
If !empty(M->(QB_FILRESP+QB_MATRESP) ) .and. SQB->(QB_FILRESP+QB_MATRESP) <> M->(QB_FILRESP+QB_MATRESP)
 

	M->QB_KEYINI := SQB->QB_KEYINI

	//Grava registro de historico de responsaveis na SZX
	RecLock("SZX",.t.)
	SZX->ZX_FILIAL  := xFilial("SQB")
	SZX->ZX_DEPTO	:= if(Altera,SQB->QB_DEPTO,M->QB_DEPTO)
	SZX->ZX_FILDE	:= if(Altera,SQB->QB_FILRESP,"")
	SZX->ZX_MATDE	:= if(Altera,SQB->QB_MATRESP,"")
	SZX->ZX_FILPARA	:= M->QB_FILRESP
	SZX->ZX_MATPARA	:= M->QB_MATRESP
	SZX->ZX_USUARIO	:= __cUserID+" - "+cUserName
	SZX->ZX_DATAHOR	:= dtoc(date())+" "+time()
	SZX->(MsUnLock())

	If Altera
	
		//Troca na RH3 o aprovador antigo pelo novo reponsavel pelo depto,
		//buscando apenas os registros vinculados ao depto em alteracao
	    cCmd := "UPDATE " + RetSqlName( 'RH3' ) +;
		        " SET  RH3_FILAPR = '" + M->QB_FILRESP + "' ," +;
		        "      RH3_MATAPR = '" + M->QB_MATRESP + "'  " +;
		        " WHERE RH3_CODIGO IN (select RH3_CODIGO from " + RetSqlName( 'RH3' ) +;
		                               " where RH3_FILAPR = '" + SQB->QB_FILRESP + "' and " +; 
		                               "       RH3_MATAPR = '" + SQB->QB_MATRESP + "' and " +;
		                               "       (RH3_XDEPAP = '" + SQB->QB_DEPTO   + "' or  RH3_XDEPAP = '') and " +;
		                               "       D_E_L_E_T_ = '')"
	    TCSQLExec(cCmd) 

	EndIf

EndIf

Return
