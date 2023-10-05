/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: PTNAFIS01                 | AUTOR: Gabriel Rezende                   | DATA: 20/10/2016   |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Rotina responsavel por atualizar a tabela SFX com as informações fornecidas pelo usuário|
|           para atender ao SPED Fsical com o Convênio 115/03 do ICMS                               |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/                                                                   

#include "Protheus.ch"
#include "totvs.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#DEFINE CRLF Char(13)+Char(10)

User Function PTNAFIS01()


Local oDlgMsg
Local oFont10 := TFont():New("FW Microsiga",10,0,.F.,.F.,,,,.F.,.F.,,,,,,)

Local cTitulo := "Atualização de Complemento Fiscal"
Local cTexto := ""

Private cPerApur := Space(06)
Private cChv115 := Space(TamSX3("FX_CHV115")[1])
Private cVol115 := Space(TamSX3("FX_VOL115")[1])
Private cDocDe 	:= Space(TamSX3("F2_DOC")[1])
Private cDocAte := Replicate("Z",TamSX3("F2_DOC")[1])

	cTexto := "Esta rotina atualizará a tabela de Complemento Fiscal das Notas Fiscal de Telecomunicação,"
	cTexto += "conforme parâmetros definidos pelo usuário"
	
	DEFINE MSDIALOG oDlgMsg FROM 154,082 TO 305,528 TITLE cTitulo OF oDlgMsg PIXEL
	 @ 004,010 TO 052,216 LABEL "" OF oDlgMsg PIXEL
	 
	 @ 020,015 SAY OEMTOANSI(cTexto) OF oDlgMsg PIXEL SIZE 200,110 FONT oFont10 COLOR CLR_HBLUE
	 
	 @ 55,025 BUTTON "&Parametros" SIZE 036,012 ACTION fParSFX() OF oDlgMsg PIXEL
	 @ 55,096 BUTTON "C&onfrima"   SIZE 036,012 ACTION (fAtuSFX(),oDlgMsg:End()) OF oDlgMsg PIXEL
	 @ 55,167 BUTTON "C&ancela"    SIZE 036,012 ACTION oDlgMsg:End() OF oDlgMsg PIXEL
	 
	 ACTIVATE MSDIALOG oDlgMsg CENTERED

Return()

Static Function fParSFX()

Local oDlgPar, oBtnOk

	DEFINE MSDIALOG oDlgPar TITLE "Defina os Parâmetros" FROM 0,0 TO 220,355 PIXEL OF GetWndDefault()
	 @ 004,010 TO 088,170 LABEL "" OF oDlgPar PIXEL
	 
	 @ 010,015 SAY "Per. Apur." 	PIXEL OF oDlgPar 
	 @ 010,055 MSGET cPerApur		SIZE 032,010 PIXEL PICTURE "@R 99/9999" OF oDlgPar Valid fVldPar(1)

	 @ 025,015 SAY "Nota De"      	PIXEL OF oDlgPar 
	 @ 025,055 MSGET cDocDe		SIZE 010,010 PIXEL OF oDlgPar 

	 @ 040,015 SAY "Nota Até"      	PIXEL OF oDlgPar 
	 @ 040,055 MSGET cDocAte	SIZE 010,010 PIXEL OF oDlgPar Valid fVldPar(3)

	 @ 055,015 SAY "Vol 115"      	PIXEL OF oDlgPar
	 @ 055,055 MSGET cVol115	SIZE 050,010 PIXEL OF oDlgPar Valid fVldPar(4)

	 @ 070,015 SAY "Chave 115"     	PIXEL OF oDlgPar 
	 @ 070,055 MSGET cChv115	SIZE 105,010 PIXEL OF oDlgPar Valid fVldPar(5)

	 @ 090,130 BUTTON "C&ancela"  SIZE 036,012 ACTION oDlgPar:End() OF oDlgPar PIXEL
 	 @ 090,015 BUTTON "C&onfirma"  SIZE 036,012 ACTION oDlgPar:End() OF oDlgPar PIXEL
	 
	 ACTIVATE MSDIALOG oDlgPar CENTERED

Return()

Static Function fAtuSFX()

Local lRet	 := .F.
Local cQrySql := ""
Local cQryUpd := ""
Local nTotReg:= 0
Local cAlias := GetNextAlias()

	lRet := ApMsgYesNo("Confirma a atualização dos dados?")

	If !lRet
		Alert("Atualização não realizada")
	Else

		cQrySel := "SELECT COUNT(*) AS TOTREG FROM " +RetSQLName("SFX")
		cQrySel += " WHERE "
		cQrySel += " D_E_L_E_T_ = ' ' "
		cQrySel += " AND FX_FILIAL = '" +xFilial("SFX") +"'"
		cQrySel += " AND FX_PERFIS = '" +AllTrim(cPerApur)+"' "
		cQrySel += " AND FX_DOC BETWEEN '" +AllTrim(cDocDe)+ "' AND '" +AllTrim(cDocAte)+ "'"

		cQrySel := ChangeQuery(cQrySel)

		If Select(cAlias) > 0
			DbSelectArea(cAlias)
			(cAlias)->(DbCloseArea())
		Else
		    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySel),cAlias,.T.,.T.)
			nTotReg := (cAlias)->TOTREG
			(cAlias)->(DbCloseArea())
		EndIf


		If nTotReg > 0
			cQryUpd := "UPDATE " +RetSQLName("SFX")+ " SET "
			cQryUpd += " FX_VOL115 = '" +AllTrim(cVol115)+ "', "
			cQryUpd += " FX_CHV115 = '" +AllTrim(cChv115)+ "' "
			cQryUpd += " WHERE "
			cQryUpd += " D_E_L_E_T_ = ' ' "
			cQryUpd += " AND FX_FILIAL = '" +xFilial("SFX") +"'"
			cQryUpd += " AND FX_PERFIS = '" +AllTrim(cPerApur)+"' "
			cQryUpd += " AND FX_DOC BETWEEN '" +AllTrim(cDocDe)+ "' AND '" +AllTrim(cDocAte)+ "'"

			Begin Transaction		
				If TcSQLExec(cQryUpd) < 0 
					Alert("Erro na atualização do banco de dados!")
					Alert(TcSQLError())
					DisarmTransaction()		
				Else
					TCRefresh(RetSQLName("SFX"))
					ApMsgInfo("Atualização realizada com sucesso!"+CRLF+"Foram atualizados "+AllTrim(Str(nTotReg))+ " registros!")
				EndIf
			End Transaction

		Else
			Alert("Nenhum registro a ser atualizado com os parâmetros informados")
		EndIf

	EndIf

Return

Static Function fVldPar(nPar)

Local lRet := .F.

	Do Case
		Case nPar = 1
			If Len(AllTrim(cPerApur)) < 6
				Alert("Informe data com 4 dígitos no ano. Formato: MMAAAA")
			Else
				lRet := .T.
			EndIf
		Case nPar = 3
			If cDocDe > cDocAte .Or. Empty(cDocAte)
				Alert("Documento final deve ser informado e deve ser maior do que documento inicial")
			Else
				lRet := .T.
			EndIf
		Case nPar = 4
			If Len(AllTrim(cVol115)) < TamSX3("FX_VOL115")[1]
				Alert("Volume do arquivo deve ser informado no formato: UFSSSAAMMST.VVV"+CRLF+"Onde:"+CRLF+;
																"UF  = Onde se encontra estabelecido o contribuinte;"+CRLF+;
																"SSS = Série dos documentos fiscais;"+CRLF+;
																"AA  = Ano do período de apuração;"+CRLF+;
																"MM  = Mês do período de apuração;"+CRLF+;
																"S   = Indica de o arquivo é normal ou substituto;"+CRLF+;
																"T   = Indica o tipo de arquivo magnético;"+CRLF+;
																"VVV = Extensão do arquivo gerado, indicada pelo número de volumes gerados")
			Else
				lRet := .T.
			EndIf
		Case nPar = 5
			If Len(AllTrim(cChv115)) < TamSX3("FX_CHV115")[1]
				Alert("Código da Chave do volume deve ser informada"+CRLF+"Tamanho da chave: "+AllTrim(Str(TamSX3("FX_CHV115")[1]))+" caracteres")
			Else
				lRet := .T.
			EndIf
	EndCase
Return lRet