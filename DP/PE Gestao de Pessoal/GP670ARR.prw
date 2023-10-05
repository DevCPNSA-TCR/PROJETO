#INCLUDE "rwmake.ch"
  
       
/********************************************************
Programa: GP670ARR 
Autor:  Roberto Lima      
Data:  29/05/2013   
Descricao:  Ponto de Entrada utilizado para alimentar o 
campo de Centro de Custo na integração dos títulos de GPE 
para o Financeiro     
Empresa:  Todas            
*********************************************************/

User Function GP670ARR ()

Local aCposUsr:= {}                   

 //aCposUsr:= {{'E2_CCD', RC1->RC1_CC, Nil}}    
 
 aCposUsr:= {{'E2_CCD', RC1->RC1_CC, Nil},;    
  		     {'E2_HIST', RC1->RC1_DESCRI, Nil}} 
                                               
Return(aCposUsr)