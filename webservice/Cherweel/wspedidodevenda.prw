#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'AP5MAIL.CH'
#Include "TopConn.Ch"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo dos dados do cabecalho do pedido de venda.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wsstruct cabecalho_pedidodevenda
	WSData WsFilial	   As String
	WSData WsUsuario   As String
	WSData WsCodref    As String
	WSData WsPassword  As String
	wsdata WsCodcli	   as String		//DESCRIPTION "Id Cherwell do cliente a ser informado no pedido de venda."
	wsdata WsEmissao   as string	//DESCRIPTION "Data de emissao do pedido de venda. Formato YYYMDD."
	wsdata WsVencto    as string
	wsdata WsDelin     as String		//DESCRIPTION "Numero da Delin no Cherwell."
	wsdata WsContrato  as String		//DESCRIPTION "Numero do contrato no Cherwell."
	wsdata WsPeriodo   as string	//DESCRIPTION "Descricao do periodo de referencia."
	wsdata WsMensagem  as string	//DESCRIPTION "Mensagem para exibicao na nota."
	wsdata WsNfori     as string	//DESCRIPTION "Notas de origem que geraram a nota de débito(nota de juros e multa)"
endwsstruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo dos dados dos itens do pedido de venda.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wsstruct item_pedidodevenda
	wsdata WsItem      as float		//DESCRIPTION "Numero do item."
	wsdata WsProduto   as string	//DESCRIPTION "Codigo do Produto Protheus."
	wsdata WsQuant     as float		//DESCRIPTION "Quantidade."
	//wsdata WsVlunit    as float		//DESCRIPTION "Valor Unitario."
	//wsdata WsTotal     as float		//DESCRIPTION "Valor Total."
	wsdata WsVlunit    as string		//DESCRIPTION "Valor Unitario."
	wsdata WsTotal     as string		//DESCRIPTION "Valor Total."

endwsstruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo dos dados dos itens do pedido de venda.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wsstruct pedido
	Wsdata cabecalho   as cabecalho_pedidodevenda
	Wsdata itens       as array of item_pedidodevenda
endwsstruct

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo de dados de retonro de operação do Web Service        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WsService cherwellpedven DESCRIPTION "WebService de integracao dos pedidos de venda do Cherwell" NAMESPACE "http://187.94.60.7:8060/ws/cherwellpedven.apw" 
	Wsdata WsPedido    as pedido
	Wsdata WsRetorno   as string

	WsMethod insere_pedven DESCRIPTION "Metodo de inclusao do pedido de venda do Cherwell. Exige usuario e senha."
EndWsService

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³insere_pedven   ³Autor  ³ Fagner O. da Silva     ³16.06.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de inclusao de dados do pedido de vendas.             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WsMethod insere_pedven; 
  WsReceive WsPedido;
  WsSend    WsRetorno;
  WsService cherwellpedven

Local cFilTrb  := ::WsPedido:cabecalho:wsFilial//SubSTR(::WsPedido:cabecalho:wsFilial,3)
Local cEmpTrb  := "01" //SubSTR(::WsPedido:cabecalho:wsFilial,1,2)
Local cCodCher := AllTrim(::WsPedido:cabecalho:wsCodCli)
Local cDelin   := AllTrim(::WsPedido:cabecalho:WsDelin)
Local cContrato:= AllTrim(::WsPedido:cabecalho:WsContrato)
Local cPeriodo := ::WsPedido:cabecalho:WsPeriodo
Local cMensNota:= ::WsPedido:cabecalho:WsMensagem
Local cNfOri   := AllTrim(::WsPedido:cabecalho:WsNfori)
Local cPedido  := ""
Local cCodCli  := ""
Local cLojaCli := ""
Local cTipoCli := ""
Local cCondPag := Alltrim(GetNewPar("MV_XCPAGWS" ,"129"))	//Verificar qual a condicao de pagamento a ser usada
Local cNaturez := "11"  //Verificar qual a natureza a ser usada
Local cProduto := ""
Local cItem    := ""
Local cpath    := "\Log_erros\"
Local cLog     := ""

Local dEmissao := STOD(AllTrim(::WsPedido:cabecalho:WsEmissao))
Local dVencto := STOD(AllTrim(::WsPedido:cabecalho:WsVencto))

Local nQuant   := 0
Local nValUnit := 0
Local nValTot  := 0
Local nTotGer  := 0
Local nOpc     := 3

Local aCab     := {}
Local aItem    := {}
Local cFilSA1  := ""
Local cBKPFil  := ""
Local cX       := ""
Local cQry     := ""
local nI 	   :=0
Private lMsErroAuto := .F.

cFilTrb  := PADR(ALLTRIM(cFilTrb),TAMSX3("A1_FILIAL")[1])


u_xConOut("Preparando empresa ...")
u_xConOut("")

RpcSetType( 3 )
RpcSetEnv( cEmpTrb, cFilTrb )

u_xConOut("cFilant: " + cFilant )
cFilSA1 := xFilial("SA1")
u_xConOut("xFilial(SA1): " + cFilSA1 )

cBKPFil  := cFilant
cFilant  := cFilTrb

u_xConOut("cFilant: " + cFilant )
cFilSA1 := xFilial("SA1")
u_xConOut("xFilial(SA1): " + cFilSA1 )

dbSelectArea("SM0")
SM0->(dbGotop())
If SM0->(dbseek(cEmpTrb+cFilTrb))
	u_xConOut("Achou empresa: " + cEmpant +" Filial: "+cFilant )
Else
	u_xConOut("No Achou empresa: " + cEmpant +" Filial: "+cFilant )
EndIf

//cFilant := cFilTrb



If cEmpAnt == cEmpTrb

	u_xConOut("EMPRESA: " + cEmpAnt + SPACE(5) + "FILIAL: " + cFilant  + SPACE(5) + DTOS(DDATABASE))
	
	If ::WsPedido:cabecalho:wsUsuario == "Cherwell" .And. ::WsPedido:cabecalho:wsPassword == "123456"
	
		u_xConOut("Senha validada com sucesso!")
		u_xConOut("")
		u_xConOut("Chave de pesquisa do cliente "+xFilial("SA1")+cCodCher)
		u_xConOut("")
	
		&&Pesquisa dados do Cliente
		dbSelectArea("SA1")
		dbOrderNickName("CHERWELL")
		If dbSeek(xFilial("SA1")+cCodCher)
	
			&&Encontrado o CodCherwell no Protheus.
			u_xConOut("Cliente encontrado no Protheus.")
	
			cCodCli  := SA1->A1_COD
			cLojaCli := SA1->A1_LOJA
			cTipoCli := SA1->A1_TIPO
	
			&& Gera o proximo sequencial do pedido de venda.
			/*
			dbSelectArea("SC5")
			dbSetOrder(1)
			cPedido := GetSxeNum("SC5","C5_NUM")
			While SC5->(dbSeek(xFilial("SC5")+cPedido))
				//ConfirmSX8()
				cPedido := GetSxeNum("SC5","C5_NUM")
			End
	        */
			cPedido := GetSxeNum("SC5","C5_NUM")
	
			u_xConOut("---------------- Cabecalho do Pedido --------------")
			u_xConOut("Pedido......: " + cPedido )
			u_xConOut("Tipo Pedido.: " + "N" )
			u_xConOut("Emissao.....: " + dtoc(dEmissao) )
			u_xConOut("Cliente.....: " + cCodCli+"-"+cLojaCli)
			u_xConOut("Tipo Cliente: " + cTipoCli)
			u_xConOut("Cond.Pagmto.: " + cCondPag)
			u_xConOut("Natureza....: " + cNaturez)
			u_xConOut("Periodo.....: " + cPeriodo)
			u_xConOut("Contrato....: " + cContrato)
			u_xConOut("Delin.......: " + cDelin)
			u_xConOut("Mensagem....: " + cMensNota)
			u_xConOut("NfOri.......: " + cNfOri)
			u_xConOut("---------------- Cabecalho do Pedido --------------")
	
	
			//----------------------------------------------------------------------------------
			//Traz natureza do cadastro de produto para utilização na integração - B1_XNATCWS
			//Yttalo P. Martins - 05/11/14------------------------------------------------------
			//INICIO----------------------------------------------------------------------------
			dbSelectArea("SB1")        
			If SB1->(FieldPos("B1_XNATCWS")) > 0
				
				If !Empty(AllTrim(::WsPedido:itens[1]:WsProduto))
					cProduto := AllTrim(::WsPedido:itens[1]:WsProduto)
				    
					dbSelectArea("SB1")
					dbSetOrder(1)
					If dbSeek(xFilial("SB1")+cProduto)
					
						If !EMPTY(SB1->B1_XNATCWS)
							cNaturez := SB1->B1_XNATCWS
						EndIf
				    
					EndIf
				
				EndIf	
			
			EndIf			
			//----------------------------------------------------------------------------------
			//Traz natureza do cadastro de produto para utilização na integração - B1_XNATCWS
			//Yttalo P. Martins - 05/11/14------------------------------------------------------
			//FIM----------------------------------------------------------------------------
	
			*------------------------------*
			* Dados do Cabecalho do Pedido *
			*------------------------------*
			//{"C5_VENCTO",dVencto         ,Nil},; // Contrato			
			aCab := {   {"C5_FILIAL" ,xFilial("SC5")    ,Nil},; // Filial 
						{"C5_NUM"    ,cPedido           ,Nil},; // Numero do pedido
						{"C5_EMISSAO",dEmissao          ,Nil},; // Emissao
						{"C5_TIPO"   ,"N"               ,Nil},; // Tipo de pedido
						{"C5_CLIENTE",cCodCli           ,Nil},; // Codigo do cliente
						{"C5_LOJACLI",cLojaCli          ,Nil},; // Loja do cliente
						{"C5_CLIENT ",cCodCli           ,Nil},; // Cliente entrega
						{"C5_LOJAENT",cLojaCli          ,Nil},; // Loja do cliente entrega
						{"C5_TIPOCLI",cTipoCli          ,Nil},; // Tipo de cliente
						{"C5_CONDPAG",cCondPag          ,Nil},; // Condicao de pagamanto
						{"C5_NATUREZ",cNaturez          ,Nil},; // Natureza  
						{"C5_PARC1"  ,100          	    ,Nil},; // 
						{"C5_DATA1"  ,dVencto          	,NiL},; //  
						{"C5_XPER"   ,cPeriodo          ,Nil},; // Periodo
						{"C5_XCONTRA",cContrato         ,Nil},; // Contrato
						{"C5_XDELIN" ,cDelin            ,Nil},; // delin
						{"C5_MENNOTA",cMensNota         ,Nil},; // Contrato						
						{"C5_XCHERWE",.T.               ,Nil}}  
			
			aItem := {}
	
			For nI := 1 TO Len(::WsPedido:itens)
				If !Empty(AllTrim(::WsPedido:itens[nI]:WsProduto))
					cItem    := StrZero(::WsPedido:itens[nI]:WsItem,2)
					cProduto := AllTrim(::WsPedido:itens[nI]:WsProduto)
					nQuant   := ::WsPedido:itens[nI]:WsQuant
					nValUnit := val(::WsPedido:itens[nI]:WsVlunit)
					nValTot  := val(::WsPedido:itens[nI]:WsTotal)
								
					
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+cProduto)
					
					If AllTrim(SB1->B1_COD) == AllTrim(cProduto)
		
						AAdd( aItem ,{  {"C6_FILIAL" , xFilial("SC6")       ,Nil},; // Filial
										{"C6_ITEM"   , cItem                ,Nil},; // Item do Pedido
										{"C6_PRODUTO", cProduto             ,Nil},; // Codigo do Produto
										{"C6_UM"     , SB1->B1_UM           ,Nil},; // Unidade Medida
										{"C6_QTDVEN" , nQuant               ,Nil},; // Quantidade Vendida 
										{"C6_QTDLIB" , nQuant               ,Nil},; // Quantidade Liberada
										{"C6_PRCVEN" , nValUnit             ,Nil},; // Preco Unitario Liquido
										{"C6_PRUNIT" , nValUnit             ,Nil},; // Preco Unitario Tabela
										{"C6_TES"    , SB1->B1_TS           ,Nil},; // Tipo de Entrada/Saida do Item SB1->B1_TS
										{"C6_LOCAL"  , SB1->B1_LOCPAD       ,Nil},; // Almoxarifado
										{"C6_CLI"    , cCodCli              ,Nil},; // Cliente
										{"C6_LOJA"   , cLojaCli             ,Nil},; // Loja do Cliente
										{"C6_ENTREG" , dDataBase            ,Nil},; // Data da Entrega
										{"C6_DESCRI" , SB1->B1_DESC         ,Nil}}) // Numero do Recibo
		              	cx:="TES "+SB1->B1_TS+SB1->B1_COD+cProduto+SB1->B1_DESC
					Else
		              	cx:=" Produto "+cProduto+" não encontrado!"	
						aItem := {}
		
						&&Não encontrado o produto no Protheus. O pedido não será incluído.
						cMensagem := "NOK|Produto nao encontrado no Prothes. O pedido nao sera incluido."
						u_xConOut(cMensagem)
		
						Exit
		
					EndIf
		
					u_xConOut("---------------- Itens do Pedido ------------------")
					u_xConOut("Item........: " + cItem)
					u_xConOut("Produto.....: " + cProduto)
					u_xConOut("Quantidade..: " + AllTrim(Str(nQuant)))
					u_xConOut("Valor Unit..: " + AllTrim(Str(nValUnit)))
					u_xConOut("Valor Total.: " + AllTrim(Str(nValTot)))
					nTotGer+=nValTot
				Endif	
			Next
	
			If Len(aItem) > 0
	
				Begin Transaction
	
				lMsErroAuto := .F.
				lMsHelpAuto := .F.
				MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItem,nOpc)
		
				If lMsErroAuto
		
					DisarmTransaction()
		
					cMensagem := "NOK|Erro ao incluir o PV no Protheus."
					cMensagem += Chr(13)+Chr(10)
			
					cFile := "cherwell_cliente_"+alltrim(cCodCher)+".log"
					cLog  := MostraErro(cpath,cfile)
			
					&&buscar no TXT qual erro ocorreu e acrescentar ao cErr antes de enviar ao Log
					cMensagem += U_cherErr(cpath+cfile)
					u_xConOut(cMensagem)
		
				Else
				    
					//grava as Nfs de origem referente à cobrança de encargos					
					/*
					RecLock("SC5",.F.)
					SC5->C5_XNFSORI := cNfOri
					MSUnlock()
	                */
	            	cQry := " UPDATE " + RetSQLName('SC5') + " "
					cQry += " SET C5_XNFSORI = '" + cNfOri + "' "
					cQry += " WHERE D_E_L_E_T_ = ' ' "
					cQry += " AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cQry += " AND C5_NUM = '" + cPedido + "' "
					
					If TcSQLExec(cQry) != 0 
						u_xConOut( "Erro ao atualizar campo C5_XNFSORI [WSPEDIDODEVENDA.PRW]." + TcSQLError() ) 
					EndIf
				
					ConfirmSX8()
						
					cMensagem := "OK|" + cPedido
					u_xConOut(cMensagem)
					u_xConOut("")
					
					Envmail(cPedido, DtoC(dEmissao), cCodCli, cLojaCli, cCondPag, cNaturez, cPeriodo, cDelin, cMensNota, AllTrim(transform(nTotGer,"@ER R$ 999,999,999.99")), cContrato)

				EndIf
	
				End Transaction
	
			EndIf
	
		Else
	
			&&Não encontrado o CodCherwell do cliente no Protheus. O pedido não será incluído.
			cMensagem := "NOK|Cliente nao encontrado no Protheus! O pedido nao sera incluido!"
			u_xConOut(cMensagem)
	
		EndIf
	
	Else
	
		cMensagem := "NOK|Usuario/Senha incorreto!"
		u_xConOut(cMensagem)
	
	EndIf

Else

	cMensagem := "NOK|Erro ao inicializar a empresa/filial no Protheus!"
	u_xConOut(cMensagem)

EndIf

&& Retorno do webService
::wsRetorno := cMensagem //+" empresa recebida "+cEmpTrb+cFilTrb+" empresa preparada "+cEmpAnt+cFilAnt+cX

&& Grava tabela customizada de Log no Protheus
//U_CherLog("01", If(lMsErroAuto, If(nOpc==3,"",cCodCli + cLojaCli), cCodCli + cLojaCli ), dDatabase, If(!lMsErroAuto, "", cMensagem), AllTrim(cCodCher)  )
U_CherLog("04", If(lMsErroAuto, If(nOpc==3,"",cCodCli + cLojaCli), cCodCli + cLojaCli ) , dDatabase, If(!lMsErroAuto, "", cMensagem), AllTrim(cDelin)  )

cFilant := cBKPFil
&& Não usar este comando com WebService. Atrapalha 
//RpcClearEnv()

u_xConOut("Mensagem de Retorno.: " + ::wsRetorno)

Return .T.           


*--------------------------------------------------------------------------------------------------------------------------------*
Static Function Envmail(cPedido, cEmissao, cCodCli, cLojaCli, cCondPag, cNatureza, cPeriodo, cDelin, cMensNota, cTotal, cContrato)
*--------------------------------------------------------------------------------------------------------------------------------*
Private aLista   := {}
Private aDados   := {}

Private cMSG     := ""
Private cError   := ""
Private cPass    := Trim(GetMV("MV_RELPSW"))  //"Ot2ygTLgBcHJ"
Private cAccount := Trim(GetMV("MV_RELACNT")) //""
Private cServer  := Trim(GetMV("MV_RELSERV")) //""
Private cFrom    := Trim(GetMV("MV_RELFROM")) //""
Private cPara    := Trim(Getmv("MV_XXWSTO2",.F.,"fabio.regueira@portonovosa.com"))

Private lResult

dbSelectArea("SX6")

u_xConOut("----------- Dados do envio de email ------------" )
u_xConOut("Servidor.: " + cServer)
u_xConOut("Conta....: " + cAccount)
u_xConOut("Senha....: " + cPass)
u_xConOut("De.......: " + cFrom)
u_xConOut("Para.....: " + cPara)
u_xConOut("----------- Dados do envio de email ------------" )

cMsg += '<html>'
cMsg += '<head>'
cMsg += '<title> Integracao Cherwell - Inclusao de Pedido de Venda </title>' 
cMsg += '</head>' 
cMsg += '<b><font size="3" face="Arial" color="Black">Email Automático gerado por Webservice. Não responda este e-mail.</font></b>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Favor validar as informacoes do pedido.</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Pedido de Venda.: ' + cPedido + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Emissao.: ' + cEmissao + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Cliente.: ' + cCodCli+"-"+cLojaCli + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Razao.: ' + Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME") + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Condicao.: ' + cCondPag + " - " + Posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_DESCRI") + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Natureza.: ' + cNatureza + " - " + Posicione("SED",1,xFilial("SED")+cNatureza,"ED_DESCRIC") + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Periodo.: ' + cPeriodo + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Contrato.: ' + cContrato + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Delin.: ' + cDelin + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Mensagem.: ' + cMensNota + '</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Valor Total da Mercadoria .: ' + cTotal + '</font>'
cMsg += '<br></br>' 
cMsg += '<br></br>' 
cMsg += '<font size="3" face="Arial" color="Black">Atenciosamente,</font>' 
cMsg += '<br></br>' 
cMsg += '<img alt="" src="http://www.portonovosa.com/sites/all/themes/portonovo/images/concessionaria-porto-novo.jpg" />'
//Não apagar essa linha, pois virá a ser utilizada.
//cMsg += '<img alt="" src="http://www.portonovosa.com/sites/all/themes/portonovo/images/PTN_Logo'+cFilAnt+'.jpg" />'
cMsg += '</body>' 
cMsg += '</html>' 

&& conecta no servidor
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If !lResult
	GET MAIL ERROR cError
	u_xConOut("Erro ao conectar no servidor: " + cError)
Else
	&& envia e-mail
	SEND MAIL FROM cFrom TO cPara SUBJECT 'Webservice integracao cherwell ' BODY cMsg RESULT lResult
	If !lResult
		GET MAIL ERROR cError
		u_xConOut("Erro ao enviar e-mail: " + cError)
	Else
		u_xConOut("Email enviado - Conta: " + cPara)
	Endif
Endif

DISCONNECT SMTP SERVER RESULT lResult

If lResult
	u_xConOut("Desconectado com sucesso do servidor de E-Mail - " + cServer)
Else
	GET MAIL ERROR cError
	u_xConOut("Erro ao desconectar-se do servidor de E-Mail - " + cError)
EndIf

Return


//http://187.94.60.7:8035/ws/cherwellpedven.apw?wsdl - homologação
//http://187.94.60.7:8060/ws/cherwellpedven.apw?wsdl - produção
//http://187.94.60.223:7008/ws/cherwellpedven.apw?wsdl - TESTE
