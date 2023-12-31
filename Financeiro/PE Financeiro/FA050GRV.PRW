#INCLUDE "rwmake.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��			FA050GRV  - 	GRAVACAO DADOS ADIC TITULOS A PAGAR (SE2)   	 ��
�� Ap�s confirma��o da grava��o de Titulo a Pagar (SE2)                      ��
�� Antes da Contabilizacao                         						     ��
���������������������������������������������������������������������������Ŀ��
���Ponto Entrada: FA050GRV.prw                                              ���
��� Objetivo    : Destinado a gravar, nos registros de Tit Pagar (SE2) o    ���
���             : campo de conta credota (SE2->E2_CREDIT) conforme regra    ���
���             : para tributos (tipo e cod retencao) e Adt e Normais- Fornc���
���             : Objetiva simplificar a elaboracao/apropria�ao contabil    ���
���             : - baixa Titulo e elaboracao Relatorio por conta (filtro)  ���
���           	:                                                           ���
���Observacoes	:                                                           ���
���������������������������������������������������������������������������Ĵ��
���Criado Por   : Roberto Lima - Doit Sistemas                              ���
���������������������������������������������������������������������������Ĵ��
���Por			:                                                           ���
���Alteracao	:                                                    		���          
���				:                                                           ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
// 
// Criar campo no Cadastro de Naturezas para o Codigo de retencao - ED_XCODRET - Reten��o IR somente
//	- Verificar necessidade de atribuir codigos distintos para Pessoa Fisica ou Juridica  (analisar !!!!!!!!!!!!!)

//
//
/*/
User Function FA050GRV
// 
 
U_GRVCTCE2()
//
Return
//
  
//
//
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��			GRVCTCE2  - 	GRAVACAO DADOS ADIC TITULOS A PAGAR (SE2)   	 ��
�� Rotina de usuario para processamento / gravacao de dados                  ��
�� comum aos P.E FA050GRV e MT100GE2               						     ��
���������������������������������������������������������������������������Ŀ��
���Autor		:                                                           ���
���           	:                                                           ���
���           	:                                                           ���
���Observacoes	:                                                           ���
���������������������������������������������������������������������������Ĵ��
���Alteracoes                                                               ���
���������������������������������������������������������������������������Ĵ��
���Por			:                                                           ���
���Alteracao	:                                                    		���          
���				:                                                           ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
// 
User Function GRVCTCE2		&& Gravar E2_DIRF
//
local cCalcIR := "" 

_mOldArea	:=	Alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()
//
DbSelectArea("SE2")
_mSE2Ind	:=	IndexOrd()
_mSE2Rec	:=	Recno()
//						           

//***********************************************************************************
// O codigo abaixo verifica se no cadastro do fornecedor o campo A2_CALCIRF 
// esta preenchido se n�o estiver o sistema ir� assumir que o fornecedor � 1-Normal.
//*********************************************************************************** 
// 1-Normal, 2-IRPF na Baixa, 3-Simples e 4-Empresa Individual 
//***********************************************************************************
DbSelectArea("SA2") 
DbSetOrder(1) 
if DbSeek(xfilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) 
   
   if SA2->A2_CALCIRF ="" 
      cCalcIR :="1"   // test
   else 
      cCalcIR := SA2->A2_CALCIRF 
   Endif 
      
Endif 
//***********************************************************************************


if !(cCalcIR $"3|4" )

	DbSelectArea("SE2")
	If SE2->(E2_IRRF + E2_PIS + E2_COFINS + E2_CSLL)  > 0
		RecLock("SE2",.F.)
		SE2->E2_DIRF	:=	"1"		&&  1 - Sim / 2 - Nao
		SE2->E2_CODRET	:=	Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_XCODRET") &&  Validar Pessoa Fisica/Juridica - campos distintos
		MsUnlock()
	Endif 

Endif 


//
DbSelectArea("SE2")
DbSetOrder(_mSE2Ind)
DbGoto(_mSE2Rec)  
//
DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)
//
Return
