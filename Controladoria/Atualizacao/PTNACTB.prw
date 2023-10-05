/*/
===============================================================================
Autor.............: Peder Munksgaard (Do.it Sistemas
-------------------------------------------------------------------------------
Data..............: 16/03/2015
-------------------------------------------------------------------------------
Descrição.........: Fonte iniciado para armazenar funções chamadas pelos 
                    lançamentos padrozinados.
===============================================================================
/*/

#Include "Protheus.ch"

/*/
===============================================================================
Autor.............: Peder Munksgaard (Do.it Sistemas)
-------------------------------------------------------------------------------
Data..............: 16/03/2015
-------------------------------------------------------------------------------
Descrição.........: Função de usuário utilizada para retornar a conta débito
                    operacional a partir de uma natureza.
                    
                    LP Original 510/001:
                    IIF(!ALLTRIM(SE2->E2_PREFIXO) $ 'AGL|AGP',POSICIONE("SED",
                    1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_DEBITO"),IF(POSICIONE
                    ("CTT", 1, XFILIAL("CTT")+RTRIM(SE2->E2_CCD), "CTT_XOPERA")
                    ="S",4110502007,4220207))
                                        
-------------------------------------------------------------------------------
Alteração.........: (dd/mm/aaaa) - Motivo
-------------------------------------------------------------------------------
Partida...........: Lançamento Padrão (510) Seq: 001
-------------------------------------------------------------------------------
Função............: u_LP510001()
===============================================================================
/*/ 

User Function LP510001()
   
   Local _cRet   := ""   
   Local _aArea  := SaveArea1({"SED","CTT"})
   Local _lOpera := .F.     
   
   dbSelectArea("CTT")
   CTT->(dbSelectArea(1))
   CTT->(dbSeek(SE2->(E2_FILIAL+E2_CCD)))

   dbSelectArea("SED")
   SED->(dbSetOrder(1))
   SED->(dbSeek(SE2->(E2_FILIAL+E2_NATUREZ)))   
      
   _lOpera := Iif(CTT->CTT_XOPERA == "S", .T., .F.)          
   
   If _lOpera .And. SE2->E2_PREFIXO $ 'BEN'
   
      _cRet := Iif(!Empty(SED->ED_XOPDEB),SED->ED_XOPDEB,"4110502007")
                      
   Elseif !_lOpera .And. SE2->E2_PREFIXO $ 'BEN'

      _cRet := Iif(!Empty(SED->ED_DEBITO),SED->ED_DEBITO,"4220207")
      
   Else
   
      _cRet := SED->ED_DEBITO
      
   Endif   

   RestArea1(_aArea)
   
Return _cRet

/*/
===============================================================================
Autor.............: Peder Munksgaard (Do.it Sistemas)
-------------------------------------------------------------------------------
Data..............: 16/03/2015
-------------------------------------------------------------------------------
Descrição.........: Função de usuário utilizada para retornar a conta débito
                    operacional a partir de uma natureza.
                    
                    LP Original 515/001:
                    IIF(!ALLTRIM(SE2->E2_PREFIXO) $ 'AGL|AGP',POSICIONE("SED",
                    1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_DEBITO"),IF(POSICIONE
                    ("CTT", 1, XFILIAL("CTT")+RTRIM(SE2->E2_CCC), "CTT_XOPERA")
                    ="S",4110502007,4220207))
                                        
-------------------------------------------------------------------------------
Alteração.........: (dd/mm/aaaa) - Motivo
-------------------------------------------------------------------------------
Partida...........: Lançamento Padrão (515) Seq: 001
-------------------------------------------------------------------------------
Função............: u_LP515001()
===============================================================================
/*/ 

User Function LP515001()

   Local _cRet   := ""   
   Local _aArea  := SaveArea1({"SED","CTT"})
   Local _lOpera := .F.     
   
   dbSelectArea("CTT")
   CTT->(dbSelectArea(1))
   CTT->(dbSeek(SE2->(E2_FILIAL+E2_CCD))) // alterado 19/08/2015 - Fabio e Victor Tavares. 

   dbSelectArea("SED")
   SED->(dbSetOrder(1))
   SED->(dbSeek(SE2->(E2_FILIAL+E2_NATUREZ)))   
      
   _lOpera := Iif(CTT->CTT_XOPERA == "S", .T., .F.)          
   
   If _lOpera .And. SE2->E2_PREFIXO $ 'BEN'
   
      _cRet := Iif(!Empty(SED->ED_XOPDEB),SED->ED_XOPDEB,"4110502007")
   
   Elseif !_lOpera .And. SE2->E2_PREFIXO $ 'BEN'

      _cRet := Iif(!Empty(SED->ED_DEBITO),SED->ED_DEBITO,"4220207")
      
   Else
   
      _cRet := SED->ED_DEBITO
      
   Endif                

   RestArea1(_aArea)

Return _cRet