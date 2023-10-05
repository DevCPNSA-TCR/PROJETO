#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "colors.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#Define cEnt Chr(13)+Chr(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF050MDVC  บAutor  ณ Leonardo Freire  บ Data ณ 03/07/2015    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Alterar a data do vencimento dos titulos do imposto PCC.  บฑฑ
ฑฑบ          ณ para o dia 20 conforme legisla็ใo vigente.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CPNSA                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User function F050MDVC() 

Local dNextDay := ParamIxb[1] 
Local cIMposto := ParamIxb[2]
Local dEmissao := ParamIxb[3]
Local dEmis1   := ParamIxb[4]
Local dVencRea := ParamIxb[5]
Local nNextMes := Month(dVencRea)+1


If cImposto $ "PIS,CSLL,COFINS" 

dNextDay := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2)) 
dNextday := DataValida(dNextday,.F.)

EndIf 

Return dNextDay   

