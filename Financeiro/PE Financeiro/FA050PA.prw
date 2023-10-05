#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA050PA  บAutor  ณYttalo P. Martins   บ Data ณ  29/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณO ponto de entrada FA050PA serแ utilizado para valida็ใo de  ฑฑ 
ฑฑบ          ณdados da tela de pagamento antecipado do Contas a Pagar.     ฑฑ
ฑฑบ          ณLocalizado na fun็ใo Fa050DigPa, Tela com dados para a       ฑฑ
ฑฑบ          ณgera็ใo de PA com cheque.Este ponto de entrada serแ executadoฑฑ 
ฑฑบ          ณna confirma็ใo da tela de Pagamento Antecipado da fun็ใo     ฑฑ
ฑฑบ          ณFa050DigPa, sendo o seu objetivo validar o botใo Ok da tela  ฑฑ
ฑฑบ          ณde digita็ใo do pagamento antecipado.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFINA050                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA050PA()

LOCAL _lRet     := .T.
LOCAL _cBanco   := PARAMIXB[1]
LOCAL _cAgencia := PARAMIXB[2]
LOCAL _cConta   := PARAMIXB[3]

_aArea := GetArea()

//Aplica filtro por banco caso as condi็๕es sejam satisfeitas
_lRet := U_PNA100( ALLTRIM(FunName()),, )
_lRet := If(_lRet==nil, .T., _lRet)

RestArea(_aArea)

Return(_lRet)