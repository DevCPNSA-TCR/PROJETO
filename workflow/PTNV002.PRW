#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北篜rograma  砅TNV002   篈utor  砎inicius F.         � Data �  18/02/14   罕北
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡北
北篋esc.     � 	rotina de valida玢o das op珲es escolhidas pelo usuario no  罕�
北�				pergunte da rotina de atualiza玢o de cota玢o.			   罕�
北�																		   罕�
北篋ever� ser ajustado o SX1 do grupo de perguntas MTA150 conforme abaixo: 罕�
北�																		   罕�
北�		parametro 4 - MV_PAR04 - X1_VALID := U_PTNV002(MV_PAR04)           罕�
北�																		   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌*/

User Function PTNV002(cPar)
Private lRet := .T.

If cPar<>2
	ALERT("Apenas permitida a exclus鉶 por cota玢o favor ajustar o parametro da rotina.")
	lRet := .F.
Endif                     

Return lRet