
/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: CALCODP                   | AUTOR: Felipe do Nascimento              | DATA: 16/04/2016   |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Rotina responsavel pelo calculo de descontos da Odeprev. Inserida em formulas e roteiro |
|           de calculo.                                                                             |
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

user function calcODP(CCALCODP)   

   local aArea := getArea()
   local nValBase
   
   local _PercOde := SRA->RA_XODEP
   local _PercContraP := 0
   
   local nValDesc  := 0
   local nValPart  := 0 
      
   local aMatriz := {}
   local cCalculo :=  CCALCODP
   local cMV_XODEFOL := getMV("MV_XODEFOL",,"001,152,300,003,515,513,177,040")
   local cMV_XODERES := getMV("MV_XODERES",,"156,152,300,003,515,513,177,040") 
  
   if cCalculo == "RES"        // rescisões
      nValBase := fBuscaPD(cMV_XODERES)
   elseif cCalculo == "FOL"   // folha de pagamento
      nValBase := fBuscaPD(cMV_XODEFOL)
   endif
   
   if _PercOde >= 10
      _PercContraP := 0.50
      nValDesc  := nValBase * (SRA->RA_XODEP/100)  // valor desconto odeprev
      nValPart  := nValDesc * _PercContraP         // valor da contrapartida
   elseif _PercOde >= 5 .and. _PercOde <= 9 
           _PercContraP := 0.40
           nValDesc     := nValBase * (SRA->RA_XODEP/100)  // valor desconto odeprev
           nValPart     := nValDesc * _PercContraP         // valor da contrapartida
   elseif _PercOde >= 1 .and. _PercOde <= 4 
           _PercContraP := 0.30
           nValDesc     := nValBase * (SRA->RA_XODEP/100)  // valor desconto odeprev
           nValPart     := nValDesc * _PercContraP         // valor da contrapartida
   endIf                                         
   
   nValDesc := iif(nValDesc  < 0, 0, nValDesc) 
   nValPart := iif(nValPart < 0, 0, nValPart)           
   
   
   fGeraVerba("615",nValDesc,SRA->RA_XODEP,,,,,,,,,)  // Valor desconto 

   if cRot # "RES"
      fGeraVerba("O07",nValPart,_PercContraP*100,,,,,,)     // Valor Parcela A  
   endif
   
   If ddatabase >= SRA->RA_XDTSUSP .and. ddatabase <= SRA->RA_XDTFSUS 
   
      fGeraVerba("619",nValDesc,SRA->RA_XODEP,,,,,,,,,)  // Valor desconto 
     
   endif                          

   aAdd(aMatriz, { "615", nValDesc,  SRA->RA_XODEP })
   if cRot # "RES"
      aAdd(aMatriz, { "O07", nValPart, _PercContraP })
   endif
   aAdd(aMatriz, { "619", nValDesc,  SRA->RA_XODEP })
 
   /*
   aMatriz := {{ "615", nValDesc,  SRA->RA_XODEP },;
               { "O07", nValPart, _PercContraP },;
               { "619", nValDesc,  SRA->RA_XODEP }}
   */

   restArea(aArea)   
return(aMatriz)
