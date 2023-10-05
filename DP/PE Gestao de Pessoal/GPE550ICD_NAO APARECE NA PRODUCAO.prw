

/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: GPE550ICD                   | AUTOR: Felipe do Nascimento              | DATA: 08/12/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: PE para alteração da descrição das informações complementares do informe de rendimento  |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
#Include 'protheus.ch'

user function GPE550ICD()

   local _aBenef := aClone(paramIxb[1])   
   local aVerbas := {}  // verbas que deverão ser substituídas a descrição na RCS
   local nPos, x
   local cDesc, cNomeForn
      
   // VERBA, CNPJ, TABELA
   aAdd(aVerbas, {"613", "01685053000156", "S016"})  // coparticipacao
   aAdd(aVerbas, {"530", "01685053000156", "S016"})  // assistência médica
   aAdd(aVerbas, {"616", "29309127000179", "S017"})  // assistência odontólogica
   
   if len(_aBenef) > 0   
      
      for x := 1 to len(_aBenef)
         nPos := ascan(aVerbas, { |y| y[1] == _aBenef[x, 10] })   // busca posição da verba em aVerbas
         
         if nPos <> 0
            
            cNomeForn := allTrim( fPosTab( aVerbas[nPos, 3],aVerbas[nPos, 2],"=",6,,,,5 ) )
                      
            cDesc := ""
            cDesc += posicione("SRV", 1, xFilial("SRV")+aVerbas[nPos, 1], "allTrim(RV_DESC)")
            cDesc += " - " 
            cDesc += cNomeForn + " - CNPJ: " + Transform(aVerbas[nPos, 2], "@R ##.###.###/####-##")
            
            _aBenef[x, 1] := cDesc
            _aBenef[x, 2] := aVerbas[nPos, 2]
            
         endif
         
      next x
      
   endif

return(aClone(_aBenef))
