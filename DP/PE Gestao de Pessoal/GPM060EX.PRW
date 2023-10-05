
/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: GPM060EX                    | AUTOR: Felipe do Nascimento              | DATA: 26/02/2015 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: PE na exclusão do título integrado ao financeiro para tratamento no estorno da          |
|           contabilização. Uma vez que até o momento o Sistema não possuia como processo padrão.   |
|           O PE retorno true ou false para exclusão do titulo na RC1 e controle no PCO             |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/

#include "protheus.ch"

#DEFINE STR0017 "Atenção"
#DEFINE STR0018 "Título excluído com sucesso!"
#DEFINE STR0019 "Informação"
#DEFINE STR0020 "Confirmação"
#DEFINE STR0021 "O título"
#DEFINE STR0022 "nao pode ser excluido pois já foi baixado no Módulo Financeiro"
#DEFINE STR0023 "Contabilizar online?"
#DEFINE STR0024 "Mostrar lançamentos contábeis?"

user function GPM060EX()
   local aArray
   local aArea := getArea()
   local lExecAuto := .t.
   local lCtbOnLine, lShowLanc := .f.

   private lMsgErroAuto := .f.
   
   //Verifica se os titulos ja foram integrados e exclui do SIGAFIN
   dbSelectArea("SE2")
   SE2->(dbSetOrder(1))
   if SE2->(dbSeek(RC1->RC1_FILTIT+RC1->RC1_PREFIX+RC1->RC1_NUMTIT, .f.))

      /* Titulo Principal ou Titulo Filho ja baixado no SIGAFIN nao pode ser excluido
      */
      if ( !empty(SE2->E2_BAIXA) .and. (SE2->E2_VALOR # E2_SALDO)) .and. SE2->E2_ORIGEM == 'GPEM670'
         lExecAuto := .f.
         msgAlert( OemToAnsi( STR0021 +  " " + allTrim(RC1->RC1_PREFIX) + " - " + allTrim(RC1->RC1_NUMTIT) + " " + STR0022), OemToAnsi(STR0017) ) //"O título "##" nao pode ser excluido pois já foi baixado no Módulo Financeiro" ##"Atencao"
      endif
      
      if (! empty(SE2->E2_NUMBOR))  // verifica se o título já esta em bordero
         lExecAuto := .f.
         Help("",1,"FA050BORD")
      endif
      
      if lExecAuto
         
         /* alimenta a matriz contendo as chaves do título a ser excluído
         */  
         aArray := {}
      
         aAdd(aArray, {"E2_PREFIXO", RC1->RC1_PREFIX, NIL })
         aAdd(aArray, {"E2_NUM", RC1->RC1_NUMTIT, NIL})
                    
         lCtbOnLine := msgYesNo(OemToAnsi(STR0023),OemToAnsi(STR0020)) //"Contabilizar online?"###"Confirmação"
         lShowLac   := msgYesNo(OemToAnsi(STR0024),OemToAnsi(STR0020)) //"Mostrar lançamentos contábeis?"###"Confirmação"
      
         // executa a rotina padrão para exclusão do titulo no financeiro
         MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5 /* // 3 - Inclusao, 4 - Alteração, 5 - Exclusão*/,,,;
                                                             lShowLac   /*mostra lançamentos contábeis */,;
                                                             lCtbOnLine /*contabiliza online */)  
         
         lExecAuto := ! lMsgErroAuto
         
         if lMsgErroAuto
            mostraErro()
            
         else
            msgAlert(OemToAnsi(STR0018), OemToAnsi(STR0019)) // "Exclusão do Título com sucesso!"##"Informacao"
            
         endif      
         
      endif
      
   endif
   
   restArea(aArea)
   
return(lExecAuto)


