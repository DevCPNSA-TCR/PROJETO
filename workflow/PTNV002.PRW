#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³PTNV002   ºAutor  ³Vinicius F.         º Data ³  18/02/14   º±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±
±±ºDesc.     ³ 	rotina de validação das opções escolhidas pelo usuario no  º±±
±±º				pergunte da rotina de atualização de cotação.			   º±±
±±º																		   º±±
±±ºDeverá ser ajustado o SX1 do grupo de perguntas MTA150 conforme abaixo: º±±
±±º																		   º±±
±±º		parametro 4 - MV_PAR04 - X1_VALID := U_PTNV002(MV_PAR04)           º±±
±±º																		   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PTNV002(cPar)
Private lRet := .T.

If cPar<>2
	ALERT("Apenas permitida a exclusão por cotação favor ajustar o parametro da rotina.")
	lRet := .F.
Endif                     

Return lRet