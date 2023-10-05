#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/
*****************************************************************************************************
*** Funcao   : PTNA006  -   Autor: Vinicius Figueiredo   -   Data:31/08/16      				  ***
*** Descricao: 		Função para realizar o disparo dos emails de férias a partir dos parametros	  ***
*** 			informados pelo usuários  										                  ***
*****************************************************************************************************
/*/
User Function PTNA006()

Local aV := {}


cPerg := 'PTNA006'

PutSx1(cPerg, "01", "Centro de Custo De ?", "", "", "mv_ch1", "C", 010, 0, 0, "G", "", "CTT", "","", "mv_par01")
PutSx1(cPerg, "02", "Centro de Custo Ate?", "", "", "mv_ch2", "C", 010, 0, 0, "G", "", "CTT", "","", "mv_par02")
PutSx1(cPerg, "03", "Matricula De ?", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "SRA", "","", "mv_par03")
PutSx1(cPerg, "04", "Matricula Ate?", "", "", "mv_ch4", "C", 06, 0, 0, "G", "", "SRA", "","", "mv_par04")
PutSx1(cPerg, "05", "Data de Emissao De ?", "", "", "mv_ch5", "D", 008, 0, 0, "G", "", "", "","", "mv_par05")
PutSx1(cPerg, "06", "Data de Emissao Ate?", "", "", "mv_ch6", "D", 008, 0, 0, "G", "", "", "","", "mv_par06")

If !Pergunte(cPerg, .T.)
	Return
Else
	aAdd(aV,{MV_PAR03,MV_PAR04,MV_PAR01,MV_PAR02,DToS(MV_PAR05),DToS(MV_PAR06)})
	U_PTNE002(aV)
Endif

Return



User Function PTNA006J()

U_PTNE002({"",""})

Return