//---------------------------------------------------------------------------------------
/*/{Protheus.doc} WSGPESOL
Ponto de Entrada apos a gravacao das solicitacoes do Portal GCH que permite utilizar, as informações gravadas na RH3 e o departamento que o aprovador esta como responsável no momento, em campos customizados.
@author  	Marcos Pereira
@since     	30/10/2016
@version  	P.12.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function WSGPESOL()

Local cFilProxApr := PARAMIXB[1] // Filial do proximo aprovador
Local cMatProxApr := PARAMIXB[2] // Matricula do proximo aprovador
Local cDepto      := PARAMIXB[3] // Departamento que este aprovador estava como responsável.

RecLock("RH3",.f.)
RH3->RH3_XDEPAP := cDepto
RH3->(MsUnLock())

Return