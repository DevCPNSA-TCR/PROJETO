

/*
-----------------------------------------------------------------------------------------------------
| FUN��O: GPE550ICD                   | AUTOR: Felipe do Nascimento              | DATA: 08/12/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: PE para altera��o da descri��o das informa��es complementares do informe de rendimento  |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVIS�ES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
#Include 'protheus.ch'

user function GPE550ICD()

   local _aBenef := aClone(paramIxb[1])   
   local aVerbas := {}  // verbas que dever�o ser substitu�das a descri��o na RCS
   local nPos, x
   local cDesc, cNomeForn
      
   // VERBA, CNPJ, TABELA
   aAdd(aVerbas, {"613", "01685053000156", "S016"})  // coparticipacao
   aAdd(aVerbas, {"530", "01685053000156", "S016"})  // assist�ncia m�dica
   aAdd(aVerbas, {"616", "29309127000179", "S017"})  // assist�ncia odont�logica
   
   if len(_aBenef) > 0   
      
      for x := 1 to len(_aBenef)
         nPos := ascan(aVerbas, { |y| y[1] == _aBenef[x, 10] })   // busca posi��o da verba em aVerbas
         
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
