#include "protheus.ch"
#include "topconn.ch"


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � GP010VALPE � Autor � Victor Tavares  � Data �      29.07.16 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para obrigar o preenchimento do campo      ���
���gestor quando o funcionario estiver ativo                    		   ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function GP010VALPE()                             

local aArea := getArea()
local lret := .t.
            
IF EMPTY(M->RA_XRESCC) .AND. M->RA_SITFOLH = " "
		lRet := .F.
		alert("O campo Gestor deve ser informado!")
end if

restArea(aArea) 

Return (lRet) 