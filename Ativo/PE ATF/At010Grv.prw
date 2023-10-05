/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �At010GRV �Autor  �Fabio Flores Regueira  � Data �  06/08/2014 ���
��������������������������������������������������������������������������  ���
���Desc.     � Grava inclus�o de ativo - Por item da nota fiscal            ���
���          � O ponto de entrada AT010GRV � disponibilizado na grava��o da ���
���          � inclus�o ou altera��o de um ativo                            ���
-------------------------------------------------------------------------------
Altera��o....: 23/03/2015 - Peder Munksgaard (Do.it Sistemas)

               Alterado o c�lculo do valor total do ativo, utilizando para 
               tal o par�metro padr�o MV_VLRATF.
               
-------------------------------------------------------------------------------               
���������������������������������������������������������������������������͹��
���Uso       � Integra��o da nta fiscal de entrada com o ativo fixo         ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"

User Function At010Grv()
 
Local lClass := Paramixb[1]
Local __F4_BENSATF := "2" 
Local __F4_PISCOF  := ""
Local cquery 	:= " "
Local cUpd		:= " "
Local nUfir	:= GetMV("MV_XTXUFIR")

Local __N1_VLAQUIS  := 0 
Local __N1_VLPISCOF := 0 
Local __N3_VORIG1   := 0
Local __N3_VORIG3   := 0

// Inclus�o Peder Munksgaard (Do.it Sistemas) - 23/03/2015
Local _nVlrAtf := &(GetMv("MV_VLRATF")) 
//

dbselectarea("SF4") 
dbsetorder(1) 
if dbseek(xfilial("SD1")+SD1->D1_TES)
   __F4_BENSATF := SF4->F4_BENSATF   
   __F4_PISCOF  := SF4->F4_PISCOF 
endif 

if ( __F4_BENSATF = "1" ) // DESMEMBRA O BEM NO ATIVO FIXO 
   
   // Altera��o por Peder Munksgaard (Do.it Sistemas) - 23/03/2015
   //__N1_VLAQUIS := (((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM)-SD1->D1_VALDESC)/SD1->D1_QUANT)
   __N1_VLAQUIS := (_nVlrAtf/SD1->D1_QUANT)
   //
   
   if ( __F4_PISCOF $ "1,2,3" ) 
   
	    __N1_VLPISCOF := (((__N1_VLAQUIS *(SF4->F4_BCRDCOF+SF4->F4_BCRDPIS) )/100))
	    //__N1_VLAQUIS := __N1_VLAQUIS + __N1_VLPISCOF
       __N1_VLAQUIS := __N1_VLAQUIS - __N1_VLPISCOF      // O PIS/COFINS DEVE SER SUBTRAIDO DO BEM ( Joyce Rosa/Controladoria 18/08/2014 ) 
       
   endif 

   __N3_VORIG1  := __N1_VLAQUIS 

   //__N3_VORIG3  := ((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM)-SD1->D1_VALDESC) - Alterado por Rafael Sacramento (Criare Consulting) em  11/11/2015
   __N3_VORIG3  := ((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM+IF(SF1->F1_EST != 'RJ',SD1->D1_BASEICM/100,0))-SD1->D1_VALDESC)
   __N3_VORIG3  := ((__N3_VORIG3 * nUfir )/SD1->D1_QUANT)  

   
else  // N�O DESMENBRA O BEM NO ATIVO

    // Altera��o por Peder Munksgaard (Do.it Sistemas) - 23/03/2015
    //__N1_VLAQUIS := ((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM)-SD1->D1_VALDESC)
    __N1_VLAQUIS := _nVlrAtf
    //
    
   if ( __F4_PISCOF $ "1,2,3" )  
	
	    __N1_VLPISCOF := (((__N1_VLAQUIS *(SF4->F4_BCRDCOF+SF4->F4_BCRDPIS) )/100))
	    //__N1_VLAQUIS  := __N1_VLAQUIS + __N1_VLPISCOF  
	    __N1_VLAQUIS  := __N1_VLAQUIS - __N1_VLPISCOF     // O PIS/COFINS DEVE SER SUBTRAIDO DO BEM  ( Joyce Rosa/Controladoria 18/08/2014 ) 
	    
   endif 

   __N3_VORIG1  := __N1_VLAQUIS 
          
   //__N3_VORIG3  := ((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM)-SD1->D1_VALDESC) - Alterado por Rafael Sacramento (Criare Consulting) em  11/11/2015
   __N3_VORIG3  := ((SD1->D1_TOTAL+SD1->D1_VALFRE+SD1->D1_ICMSCOM+IF(SF1->F1_EST != 'RJ',SD1->D1_BASEICM/100,0))-SD1->D1_VALDESC)
   __N3_VORIG3  := ((__N3_VORIG3 * nUfir ))
   
endif 

If ALLTRIM(UPPER(FUNNAME()))== "MATA103" // SOMENTE UTILIZA OS CALCULO SE FOR POR INTEGRA��O COMPRAS X ATIVO. 

dbSelectArea("SN1")
RecLock("SN1",.F.)				
SN1->N1_VLAQUIS := __N1_VLAQUIS
MSUnLock()                 

dbSelectArea("SN3")
RecLock("SN3",.F.)				
SN3->N3_TIPO = '' 
SN3->N3_HISTOR  := POSICIONE("SB1",1,XFILIAL("SB1")+SN1->N1_PRODUTO,"B1_DESC")  // N1_DESCRIC
SN3->N3_CUSTBEM := SD1->D1_CC
SN3->N3_CCDESP  := SD1->D1_CC
//SN3->N3_VORIG1 := __N3_VORIG1
SN3->N3_VORIG1 := __N1_VLAQUIS
SN3->N3_VORIG3 := __N3_VORIG3
MSUnLock()                 

ENDIF 

Return NiL