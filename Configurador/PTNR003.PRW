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

User Function PTNR003()

Local cQuery	:= ""
Local oReport
Private cPerg 	:= Padr("PTNR003",10)

/*����������������������������������������������������������������������������ͻ
� Criacao dos parametros de usuario.                                           �
�                                                                             */
&& cGrupo, cOrdem, cPergunt, cPerSpa, cPerEng, cVar, cTipo ,nTamanho, nDecimal, nPresel, cGSC, cValid, cF3, cGrpSxg, cPyme, cVar01, cDef01, cDefSpa1, cDefEng1, cCnt01, cDef02, cDefSpa2, cDefEng2, cDef03, cDefSpa3, cDefEng3, cDef04, cDefSpa4, cDefEng4, cDef05, cDefSpa5, cDefEng5, aHelpPor, aHelpEng, aHelpSpa, cHelp
PutSx1( cPerg,"01","Mostrar Usuarios       ", "", "", "mv_ch1", "N",  01, 00, 00, "C","","","","",               "MV_PAR01","Bloqueados","Bloqueados","Bloqueados","Liberados","Liberados","Liberados","Todos","Todos","Todos",,,,,,,"Mostrar Registros")



IF Pergunte(cPerg,.t.)
	Processa({|| PTNR003A()},"Processando... " )
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


Static Function PTNR003A()
Local aCabExcel  	:= {"Codigo","Nome","Login","Cargo","Email","Situa��o","Modulo","Menu Habilitado"}
Local aDetalhe	:= {}
Local _aUsuarios	:= {}
Local _aUsers		:= {}
Local nI:= 0
Local nJ :=0

_aUsuarios := FWSFALLUSERS()
aUsers := {}

//Linha de Cabe�alho do detalhe
aAdd(aDetalhe,aCabExcel)

For nI:=1 to Len(_aUsuarios)
	If (_aUsuarios[nI][1][1] $ ('000000','000002'))
		loop
	Endif

	If MV_PAR01 = 1 .And. !(_aUsuarios[nI][1][17])
		Loop
	Elseif MV_PAR01 = 2 .And. (_aUsuarios[nI][1][17])
		Loop
	Endif

	For nJ := 1 To Len(_aUsuarios[nI][3])
	
 		If SubStr(_aUsuarios[nI][3][nJ],3,1) ="5"	   
 		
/*
 		 	_cImprime := Padr(Alltrim(aUsers[i][5]),6)                               + Space(10)           //Codigo Usuario    
 	_cImprime += Padr(Alltrim(aUsers[i][4]),30)                              + Space(10)           //Nome   Usuario
 	_cImprime += Padr(Alltrim(aUsers[i][2]),15)                              + Space(10)           //Login  Usuario
 	_cImprime += Padr(Alltrim(aUsers[i][6]),30)                              + Space(10)            //Cargo  Usuario
   	_cImprime += Padr(Alltrim(aUsers[i][2]),60)                              + Space(10)           //Email  Usuario
 	_cImprime += Padr(If(aUsers[i][1] == .F.,"Liberado","Bloqueado"),9)                                   //Status Usuario
*/ 	
     		Aadd(aDetalhe, {chr(160)+(_aUsuarios[nI][1][1]), (_aUsuarios[nI][1][4]), (_aUsuarios[nI][1][2]), (_aUsuarios[nI][1][13]),  (_aUsuarios[nI][1][14]),If(!(_aUsuarios[nI][1][17]),"Liberado","Bloqueado"),CHR(160)+Left(_aUsuarios[nI][3][nJ],2),_aUsuarios[nI][3][nJ]}) 
     		//Aadd(aDetalhe, {(_aUsuarios[nI][1][14]), (_aUsuarios[nI][1][2]), (_aUsuarios[nI][1][4]), (_aUsuarios[nI][1][1]),  (_aUsuarios[nI][1][13]),_aUsuarios[nI][3][nJ] },If(!(_aUsuarios[nI][1][17]),"Liberado","Bloqueado") )
     		
		Endif
	Next
Next



*********************************
* FIM - GERANDO O VETOR DETALHE *
*********************************


DlgToExcel({{"ARRAY","Cadastro de Usu�rios","",aDetalhe}})


Return



