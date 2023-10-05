#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  GPE10MENU  บAutor  ณ  VICTOR TAVARES    บ Data ณ 20/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 	Adiciona ao menu do GPE a rotina que cria o funcionแrio como fornecedor   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑAltera็๕esณ                                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ Data      ณ Responsavel    ณ Descri็ใo das Altera็๕es ( GMUD: )        บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑ  13/12/2016 ณ Vinicius Figueiredo  ณ  Cria็ใo da Rotina para atualiza็ใo dos dados bancแrios do fornecedor com base no cadastro do funcionแrio  chamado 27656    บฑฑ
ฑฑ           ณ                ณ       บฑฑ
ฑฑ           ณ                ณ       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ Data      ณ Responsavel    ณ Descri็ใo das Altera็๕es ( GMUD: )        บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑ           ณ                ณ                                           บฑฑ
ฑฑ           ณ                ณ                                           บฑฑ
ฑฑ           ณ                ณ                                           บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPE10MENU()
aAdd(aRotina, { "Cria Forncec.", "u_SRAFornec", 0, 7, 0, Nil })
aAdd(aRotina, { "Atu Banco Forn", "u_SRAForSA6", 0, 7, 0, Nil })
Return(Nil)



//*************************************************************************
//*Descri็ใo: Rotina para atualiza็ใo dos dados bancแrios do fornecedor com base no cadastro do funcionแrio
//*Data: 13/12/2016
//*************************************************************************
User Function SRAForSA6()
Local aAreaAnt      := GetArea()

PRIVATE lMsErroAuto := .F.

cperg := "GPE10SA6"
PutSx1( cPerg,"01","Matricula de..............?" ,"","","mv_ch1" ,"C",TamSx3('RA_MAT')[1],0,0,"G","","SRA","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","" )
PutSx1( cPerg,"02","Matricula Ate.............?" ,"","","mv_ch2" ,"C",TamSx3('RA_MAT')[1],0,0,"G","","SRA","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","" )

If !Pergunte(cPerg,.T.)
	Return
Endif

Processa({|| atufor()  , "Aguarde atualizando registros! "})

RestArea(aAreaAnt)

Return


Static Function atufor()
Local cCodF         := ""
Local cCodNew       := ""
Local cTxt := "Fornecedores alterados: "+CRLF+" %caltfun% "+CRLF+CRLF+"Fornecedores incluํdos:"+CRLF+" %cincfun% "+CRLF+CRLF+"Fornecedores com erro:"+CRLF+" %cerrfun% "
Local cAltFun := ""
Local cIncFun := ""
Local cErrFun := ""

cQry := getnextalias()
cRet := ""

cSQL := " select * "
cSQL += " from "+RetSQLName("SRA")+" RA "
cSQL += " WHERE RA_FILIAL = '"+xFilial("SRA")+"' "
cSQL += " AND RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND  RA_XBCAGCO <> ' ' AND RA_XCTACOL <> ' '  AND RA_SITFOLH <> 'D'   "
cSQL += " AND RA.D_E_L_E_T_ = ' '  "

DbUseArea(.T., "TOPCONN", TCGENQRY(,, cSQL), cQry, .F., .T.)
dbSelectArea(cQry)
(cQry)->(dbGoTop())

While (cQry)->(!EoF())
	cCPF  := (cQry)->RA_CIC
	cRECN := ExistA2(cCPF,1)
	
	If !Empty(cRECN)
		Begin Transaction
		
		DbSelectArea("SA2")
		DbGoTo(cRECN)
		RecLock("SA2",.F.)
		SA2->A2_BANCO := Substr((cQry)->RA_XBCAGCO,1,3)
		SA2->A2_AGENCIA := Substr((cQry)->RA_XBCAGCO,4,5)
		cCta := ALlTRim((cQry)->RA_XCTACOL)
		//SA2->A2_NUMCON := SubSTR(cCta,1,Len(cCta)-1)
		//SA2->A2_XDIGCON := SubSTR(cCta,Len(cCta))
		SA2->A2_NUMCON := cCta
		SA2->A2_XDIGCON := ""
		SA2->(MsUnlock())
		
		End Transaction
		
		cAltFun += (cQry)->RA_MAT+" - "+AllTrim((cQry)->RA_NOME)+(CHR(13)+CHR(10))
		
	Else
		DbSelectArea("SRA")
		DbGoTo((cQry)->R_E_C_N_O_)
		If U_SRAFornec("DDD")
			cIncFun += SRA->RA_MAT+" - "+AllTrim(SRA->RA_NOME)+(CHR(13)+CHR(10))
		Else
			cErrFun += SRA->RA_MAT+" - "+AllTrim(SRA->RA_NOME)+(CHR(13)+CHR(10))
		Endif
	Endif
	(cQry)->(DbSkip())
EndDo

If !Empty(cAltFun) .OR. !Empty(cIncFun)
	cTxt := Replace(cTxt,"%caltfun%",caltfun)
	cTxt := Replace(cTxt,"%cincfun%",cincfun)
	cTxt := Replace(cTxt,"%cerrfun%",cerrfun)
	Tela(cTxt)
Endif
(cQry)->(DbCloseArea())

Return

//****************************************************** *******************
//*Descri็ใo: Rotina para cria็ใo do Funcionario como Forncedor
//*Data: 20/07/2016
//*************************************************************************
User Function SRAFornec(lMostra)
Local aAreaAnt      := GetArea()
Local cCPF          := SRA->RA_CIC
Local cCodF         := ""
Local cCodNew       := ""

PRIVATE lMsErroAuto := .F.

If lMostra == "SRA"
	lMostra := .T.
Else
	lMostra := .F.
Endif

cCodF := ExistA2(cCPF)
lRet := .F.

If !Empty(cCodF)
	Alert("Funcionแrio jแ cadastrado como Fornecedor atraves do codigo:"+cCodF)
Else
	cCodNew := GetSXENum("SA2","A2_COD")
	
	Begin Transaction
	PARAMIXB1 := {}
	aadd(PARAMIXB1,{"A2_COD",    cCodNew,})
	aadd(PARAMIXB1,{"A2_LOJA",   "01",})
	aadd(PARAMIXB1,{"A2_TIPO",   "F",})
	aadd(PARAMIXB1,{"A2_CGC",    cCPF,})
	aadd(PARAMIXB1,{"A2_NOME",   SRA->RA_NOMECMP,})
	aadd(PARAMIXB1,{"A2_NREDUZ", SRA->RA_NOME,})
	aadd(PARAMIXB1,{"A2_END",    SRA->RA_ENDEREC,})
	aadd(PARAMIXB1,{"A2_EST",    SRA->RA_ESTADO,})
	aadd(PARAMIXB1,{"A2_MUN",    SRA->RA_MUNICIP,})
	aadd(PARAMIXB1,{"A2_CEP",    SRA->RA_CEP,})
	aadd(PARAMIXB1,{"A2_BAIRRO" ,SRA->RA_BAIRRO,})
	aadd(PARAMIXB1,{"A2_COD_MUN",SRA->RA_CODMUN,})
	aadd(PARAMIXB1,{"A2_COMPLEM",SRA->RA_COMPLEM,})
	aadd(PARAMIXB1,{"A2_INSCR"  ,"ISENTO",})
	aadd(PARAMIXB1,{"A2_INSCRM" ,"ISENTO",})
	aadd(PARAMIXB1,{"A2_PAIS"   ,"105",})
	aadd(PARAMIXB1,{"A2_BANCO"  ,Substr(SRA->RA_XBCAGCO,1,3),})
	aadd(PARAMIXB1,{"A2_AGENCIA",Substr(SRA->RA_XBCAGCO,4,5),})
	aadd(PARAMIXB1,{"A2_NUMCON" ,SRA->RA_XCTACOL,})
	aadd(PARAMIXB1,{"A2_CONTA"  ,"2130105",})
	aadd(PARAMIXB1,{"A2_CODPAIS","01058",})
	
	MSExecAuto({|x,y| mata020(x,y)},PARAMIXB1,3)
	
	If !lMsErroAuto
		lRet := .T.
		ConfirmSX8()
		If lMostra
			ALERT("Incluido com sucesso! "+cCodNew)
		Endif
	Else
		lRet := .F.      
		If lMostra
			mostraerro()
		Endif
		RollBackSX8()
		DisarmTransaction()
		lMsErroAuto := .F.                               
	EndIf
	
	End Transaction
	
end If

RestArea(aAreaAnt)

Return  lRet


//*************************************************************************
//*Descri็ใo: Verifica de Existe O Cadastro do Funcionario como Fornecedor
//*Data: 20/07/2016
//*************************************************************************

Static Function ExistA2(cCPF,nTp)

cQRYA2 := getnextalias()
cRet := ""

cSQL := " select A2_COD AS COD , R_E_C_N_O_ AS RECN "
cSQL += " from "+RetSQLName("SA2")+" A2 "
cSQL += " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
cSQL += " AND A2_CGC = '"+cCPF+"' "
cSQL += " AND A2.D_E_L_E_T_ = ' '  "

DbUseArea(.T., "TOPCONN", TCGENQRY(,, cSQL), cQRYA2, .F., .T.)
dbSelectArea(cQRYA2)
(cQRYA2)->(dbGoTop())

If (cQRYA2)->(!EoF())
	If nTp == NiL
		cRet := (cQRYA2)->COD
	Else
		cRet := (cQRYA2)->RECN
	Endif
Endif

(cQRYA2)->(DbCloseArea())

Return cRet



Static Function Tela(cMemo)
Local oDlg, oMemo
Local aObjects,aSize,aInfo,aPosObj

//Monta Tela
aObjects := {}
aSize := MsAdvSize(.t.)
aSize[3]:=aSize[3]*3/4
aSize[4]:=aSize[4]*3/4
aSize[5]:=aSize[5]*3/4
aSize[6]:=aSize[6]*3/4

AAdd(aObjects,{100,100,.T.,.T.,.T.})
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],10,10}
aPosObj := MsObjSize(aInfo,aObjects,.T.)


DEFINE MSDIALOG oDlg FROM aSize[1],aSize[2] TO aSize[6],aSize[5]  PIXEL TITLE "Aten็ใo"
oMemo:= tMultiget():New(aPosObj[1,1],aPosObj[1,2],{|u|if(Pcount()>0,cMemo:=u,cMemo)};
,oDlg,aPosObj[1,3],aPosObj[1,4],,,,,,(.T.))
@ 200,10 BUTTON oBtn PROMPT "Fecha" OF oDlg PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED


Return NIL
