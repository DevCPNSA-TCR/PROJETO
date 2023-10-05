#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CN130INC � Autor � TOTVS                 � Data � 28.08.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de entrada executado no momeno da inclusao das        ���
���          �medicoes de contrato.                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN130Inc()
Local nx

// Classifica��o Or�ament�ria
Local nPosCC	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'CNE_XCC'})
Local nPosCO	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'CNE_XCO'})

Local nPosItm   := aScan(aHeader,{|x| AllTrim(x[2]) == 'CNE_ITEM'})
Local cQuery    := ""
Local cAlias    := GetNextAlias()
Local nPos

//Filtra os itens da planilha
cQuery := "SELECT CNB.CNB_ITEM,CNB.CNB_XCC, CNB.CNB_XCO FROM " + RetSQLName("CNB") + " CNB WHERE " 
cQuery += "CNB.CNB_FILIAL = '" + xFilial("CNB") + "' AND "
cQuery += "CNB.CNB_CONTRA = '" + M->CND_CONTRA + "' AND "
cQuery += "CNB.CNB_REVISA = '" + M->CND_REVISA + "' AND "
cQuery += "CNB.CNB_NUMERO = '" + M->CND_NUMERO + "' AND "
cQuery += "CNB.D_E_L_E_T_ = '' "

//Executa query
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), cAlias, .F., .T. )

While !(cAlias)->(Eof())
   If (nPos := aScan(aCols,{|x| x[nPosItm] == (cAlias)->CNB_ITEM})) > 0
     aCols[nPos,nPosCC] := (cAlias)->CNB_XCC     
   EndIf  
   If (nPos := aScan(aCols,{|x| x[nPosItm] == (cAlias)->CNB_ITEM})) > 0
     aCols[nPos,nPosCO] := (cAlias)->CNB_XCO     
   EndIf
   (cAlias)->(dbSkip())
EndDo

Return
