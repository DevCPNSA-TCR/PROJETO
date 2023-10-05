#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050PA  �Autor  �Yttalo P. Martins   � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada FA050PA ser� utilizado para valida��o de  �� 
���          �dados da tela de pagamento antecipado do Contas a Pagar.     ��
���          �Localizado na fun��o Fa050DigPa, Tela com dados para a       ��
���          �gera��o de PA com cheque.Este ponto de entrada ser� executado�� 
���          �na confirma��o da tela de Pagamento Antecipado da fun��o     ��
���          �Fa050DigPa, sendo o seu objetivo validar o bot�o Ok da tela  ��
���          �de digita��o do pagamento antecipado.                       ���
�������������������������������������������������������������������������͹��
���Uso       �FINA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050PA()

LOCAL _lRet     := .T.
LOCAL _cBanco   := PARAMIXB[1]
LOCAL _cAgencia := PARAMIXB[2]
LOCAL _cConta   := PARAMIXB[3]

_aArea := GetArea()

//Aplica filtro por banco caso as condi��es sejam satisfeitas
_lRet := U_PNA100( ALLTRIM(FunName()),, )
_lRet := If(_lRet==nil, .T., _lRet)

RestArea(_aArea)

Return(_lRet)