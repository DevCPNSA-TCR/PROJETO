#Include "Protheus.ch"
#Include "TopConn.ch"
#Define cEnt	Chr(13) + Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PTNR002  �Autor  �Ricardo Ferreira    � Data � 26/11/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rela��o de pedidos aprovados por Aprovador.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PTNR002()

Local cQuery	:= ""
Local oReport
Private cPerg 	:= Padr("PTNR002",10)

PutSx1( cPerg,"01","Filial   De?"   		,"","","mv_ch1","C",02       	,0,0,"G","","   ","","","MV_PAR01")
PutSx1( cPerg,"02","Filial  At�?"   		,"","","mv_ch2","C",02       	,0,0,"G","","   ","","","MV_PAR02")
PutSx1( cPerg,"03","Data De?"   			,"","","mv_ch3","D",08       	,0,0,"G","","   ","","","MV_PAR03")
PutSx1( cPerg,"04","Data Ate?"   			,"","","mv_ch4","D",08       	,0,0,"G","","   ","","","MV_PAR04")



IF Pergunte(cPerg,.t.)
	Processa({|| PTNR002A()},"Processando... " )
Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Ricardo Ferreira    � Data �  23/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para montar as sessoes do relatorio                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PTNR001                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function PTNR002A()
Local aCabExcel  	:= {"Nome","Limite Minimo","Limite Maximo","Filial","Num. PC","Emissao PC","Data Libera��o","Valor Total"}
Local aDetalhe	:= {}


// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})


BeginSql Alias "APR"
	SELECT AK_NOME,AK_LIMMIN,AK_LIMMAX,CR_FILIAL,CR_NUM,
	(SUBSTRING(CR_EMISSAO,7,2) + '/' +  SUBSTRING(CR_EMISSAO,5,2) + '/' + SUBSTRING(CR_EMISSAO,1,4) ) EMISSAO,
	(SUBSTRING(CR_DATALIB,7,2) + '/' +  SUBSTRING(CR_DATALIB,5,2) + '/' + SUBSTRING(CR_DATALIB,1,4) )  DTLIBERACAO,
	CR_TOTAL
	FROM %table:SCR%  SCR
	INNER JOIN %table:SAK% SAK ON AK_COD = CR_APROV AND SAK.%notdel%
	WHERE CR_TIPO = 'PC' AND CR_DATALIB BETWEEN  %exp:MV_PAR03% AND  %exp:MV_PAR04% AND  CR_USER = CR_USERLIB AND SCR.%notdel%
	ORDER BY AK_NOME
EndSql


nTotReg := 0
APR->( dbEval( { || nTotReg++ },,{ || !Eof() } ) )
dbGoTop()

ProcRegua(nTotReg)
//Linha de Cabe�alho do detalhe
aAdd(aDetalhe,aCabExcel)

While !APR->(Eof()) 

	IncProc()
	aadd(aDetalhe,{APR->AK_NOME,TRANSFORM(APR->AK_LIMMIN,"@E 999,999,999.99") ,TRANSFORM(APR->AK_LIMMAX,"@E 999,999,999.99"),chr(160)+APR->CR_FILIAL,chr(160)+APR->CR_NUM,APR->EMISSAO,APR->DTLIBERACAO,TRANSFORM(APR->CR_TOTAL,"@E 999,999,999.99")})
	APR->(DbSkip())
Enddo

*********************************
* FIM - GERANDO O VETOR DETALHE *
*********************************


DlgToExcel({{"ARRAY","Pedidos Aprovados por Aprovador","",aDetalhe}})


Return



