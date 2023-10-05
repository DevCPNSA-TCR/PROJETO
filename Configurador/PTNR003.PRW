#Include "Protheus.ch"
#Include "TopConn.ch"
#Define cEnt	Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPTNR002  บAutor  ณRicardo Ferreira    บ Data ณ 26/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de pedidos aprovados por Aprovador.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estoque                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PTNR003()

Local cQuery	:= ""
Local oReport
Private cPerg 	:= Padr("PTNR003",10)

/*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Criacao dos parametros de usuario.                                           บ
บ                                                                             */
&& cGrupo, cOrdem, cPergunt, cPerSpa, cPerEng, cVar, cTipo ,nTamanho, nDecimal, nPresel, cGSC, cValid, cF3, cGrpSxg, cPyme, cVar01, cDef01, cDefSpa1, cDefEng1, cCnt01, cDef02, cDefSpa2, cDefEng2, cDef03, cDefSpa3, cDefEng3, cDef04, cDefSpa4, cDefEng4, cDef05, cDefSpa5, cDefEng5, aHelpPor, aHelpEng, aHelpSpa, cHelp
PutSx1( cPerg,"01","Mostrar Usuarios       ", "", "", "mv_ch1", "N",  01, 00, 00, "C","","","","",               "MV_PAR01","Bloqueados","Bloqueados","Bloqueados","Liberados","Liberados","Liberados","Todos","Todos","Todos",,,,,,,"Mostrar Registros")



IF Pergunte(cPerg,.t.)
	Processa({|| PTNR003A()},"Processando... " )
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณRicardo Ferreira    บ Data ณ  23/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para montar as sessoes do relatorio                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PTNR001                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PTNR003A()
Local aCabExcel  	:= {"Codigo","Nome","Login","Cargo","Email","Situa็ใo","Modulo","Menu Habilitado"}
Local aDetalhe	:= {}
Local _aUsuarios	:= {}
Local _aUsers		:= {}
Local nI:= 0
Local nJ :=0

_aUsuarios := FWSFALLUSERS()
aUsers := {}

//Linha de Cabe็alho do detalhe
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


DlgToExcel({{"ARRAY","Cadastro de Usuแrios","",aDetalhe}})


Return



