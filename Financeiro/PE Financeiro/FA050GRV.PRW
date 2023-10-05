#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			FA050GRV  - 	GRAVACAO DADOS ADIC TITULOS A PAGAR (SE2)   	 ±±
±± Após confirmação da gravação de Titulo a Pagar (SE2)                      ±±
±± Antes da Contabilizacao                         						     ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto Entrada: FA050GRV.prw                                              ³±±
±±º Objetivo    : Destinado a gravar, nos registros de Tit Pagar (SE2) o    º±±
±±º             : campo de conta credota (SE2->E2_CREDIT) conforme regra    º±±
±±º             : para tributos (tipo e cod retencao) e Adt e Normais- Forncº±±
±±º             : Objetiva simplificar a elaboracao/apropriaçao contabil    º±±
±±º             : - baixa Titulo e elaboracao Relatorio por conta (filtro)  º±±
±±³           	:                                                           ³±±
±±³Observacoes	:                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Criado Por   : Roberto Lima - Doit Sistemas                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Por			:                                                           ³±±
±±³Alteracao	:                                                    		³±±          
±±³				:                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// 
// Criar campo no Cadastro de Naturezas para o Codigo de retencao - ED_XCODRET - Retenção IR somente
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			GRVCTCE2  - 	GRAVACAO DADOS ADIC TITULOS A PAGAR (SE2)   	 ±±
±± Rotina de usuario para processamento / gravacao de dados                  ±±
±± comum aos P.E FA050GRV e MT100GE2               						     ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Autor		:                                                           ³±±
±±³           	:                                                           ³±±
±±³           	:                                                           ³±±
±±³Observacoes	:                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Por			:                                                           ³±±
±±³Alteracao	:                                                    		³±±          
±±³				:                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
// esta preenchido se não estiver o sistema irá assumir que o fornecedor é 1-Normal.
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
