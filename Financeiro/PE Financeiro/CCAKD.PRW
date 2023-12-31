#INCLUDE "rwmake.ch"   
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "topconn.ch"

		/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCAKD    � Autor:Jalles Ara�jo � Data �14/05/2013           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que busca o centro de custo de destino do           ���
���            colaborador.                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                


User function CCAKD() 

Local cCusto
Local dData	:=dDatabase   
Local dData1	:=Lastday(SRT->RT_DATACAL,1) 
Local dData2	:=Lastday(SRT->RT_DATACAL) 
Local cMat	
Local lRet	:=.T.   	
Local cQuery:=""
Local aArea := GetArea()        
dbselectarea("SRT")
dbsetorder(1)

cMat		:=SRT->RT_MAT 
cVerba		:=SRT->RT_VERBA

cQuery := "SELECT RT_TIPMOVI,RT_VERBA, RT_MAT, RT_CC FROM " + RetSqlName("SRT")+(" SRT")
cQuery += "	WHERE RT_TIPMOVI='6' AND "     //Movimento de transfer�ncia
cQuery += "	RT_DATACAL BETWEEN '"+ Dtos(dData1) + "' AND '" + Dtos(dData2)+ "' AND SRT.D_E_L_E_T_=' '" 
                                  
TcQuery cQuery Alias "SRTTMP" New                                                                                                                                                                                                              

DbSelectArea("SRTTMP")
While !SRTTMP->(Eof()) .and. lRet=.T.
	If SRTTMP->RT_MAT == cMat  //compara a Matricula da consulta com o registro corrente
		cCusto := SRTTMP->RT_CC 
		lret:=.F.
	Endif
	dbskip()
Enddo


DbCloseArea("SRTTMP")
RestArea(aArea) 

Return(cCusto)                               
