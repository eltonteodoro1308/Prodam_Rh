/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ±± Contabilização da Folha de Pagamento buscando as Contas ±±
  ±± Contábeis do Cadastro de Verbas                         ±±
  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ±± Autor : Anderson Casarotti                              ±±
  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ±± Data : 26/11/2015                                       ±±
  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/



/**********************************
 * Historico do Lançamento Padrao *
 **********************************/
User Function xHistPd()

    Local aOld := GETAREA()
    Local nSrvOrd := SRV->(IndexOrd())
    Local nSrvRec := SRV->(Recno())
    Local xHist
    
    dbSelectArea( "SRV" )
    dbSetOrder(1)
    dbSeek( xFilial("SRV")+SRZ->RZ_PD )

        xHIST := srz->rz_pd +" - "+ srv->rv_desc + " REF. " + SUBS(DTOC(DDATABASE),4,7)

    SRV->(dbSetOrder( nSrvOrd ))
    SRV->(dbGoTo( nSrvRec ))
    RESTAREA( aOld )    

Return (xHist)

