
/*
-----------------------------------------------------------------------------------------------------
| FUN��O: GPM060EX                    | AUTOR: Felipe do Nascimento              | DATA: 26/02/2015 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: PE na exclus�o do t�tulo integrado ao financeiro para tratamento no estorno da          |
|           contabiliza��o. Uma vez que at� o momento o Sistema n�o possuia como processo padr�o.   |
|           O PE retorno true ou false para exclus�o do titulo na RC1 e controle no PCO             |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVIS�ES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/

#include "protheus.ch"

#DEFINE STR0017 "Aten��o"
#DEFINE STR0018 "T�tulo exclu�do com sucesso!"
#DEFINE STR0019 "Informa��o"
#DEFINE STR0020 "Confirma��o"
#DEFINE STR0021 "O t�tulo"
#DEFINE STR0022 "nao pode ser excluido pois j� foi baixado no M�dulo Financeiro"
#DEFINE STR0023 "Contabilizar online?"
#DEFINE STR0024 "Mostrar lan�amentos cont�beis?"

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
         msgAlert( OemToAnsi( STR0021 +  " " + allTrim(RC1->RC1_PREFIX) + " - " + allTrim(RC1->RC1_NUMTIT) + " " + STR0022), OemToAnsi(STR0017) ) //"O t�tulo "##" nao pode ser excluido pois j� foi baixado no M�dulo Financeiro" ##"Atencao"
      endif
      
      if (! empty(SE2->E2_NUMBOR))  // verifica se o t�tulo j� esta em bordero
         lExecAuto := .f.
         Help("",1,"FA050BORD")
      endif
      
      if lExecAuto
         
         /* alimenta a matriz contendo as chaves do t�tulo a ser exclu�do
         */  
         aArray := {}
      
         aAdd(aArray, {"E2_PREFIXO", RC1->RC1_PREFIX, NIL })
         aAdd(aArray, {"E2_NUM", RC1->RC1_NUMTIT, NIL})
                    
         lCtbOnLine := msgYesNo(OemToAnsi(STR0023),OemToAnsi(STR0020)) //"Contabilizar online?"###"Confirma��o"
         lShowLac   := msgYesNo(OemToAnsi(STR0024),OemToAnsi(STR0020)) //"Mostrar lan�amentos cont�beis?"###"Confirma��o"
      
         // executa a rotina padr�o para exclus�o do titulo no financeiro
         MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5 /* // 3 - Inclusao, 4 - Altera��o, 5 - Exclus�o*/,,,;
                                                             lShowLac   /*mostra lan�amentos cont�beis */,;
                                                             lCtbOnLine /*contabiliza online */)  
         
         lExecAuto := ! lMsgErroAuto
         
         if lMsgErroAuto
            mostraErro()
            
         else
            msgAlert(OemToAnsi(STR0018), OemToAnsi(STR0019)) // "Exclus�o do T�tulo com sucesso!"##"Informacao"
            
         endif      
         
      endif
      
   endif
   
   restArea(aArea)
   
return(lExecAuto)


