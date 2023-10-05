#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'AP5MAIL.CH'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo dos dados do cliente. Operação no Web Service         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT cliente
	WSData WsFilial	   As String
	WSData WsUsuario   As String
	WSData WsPassword  As String
	//WSData WsCodCher   As Float
	WSData WsCodCher   As String
	WSData WsRazao	   As String
	WSData WsFantasia  As String
	WSData WsEnd       As String
	WSData WsEstado    As String
	WSData WsMunic     As String
	WSData WsBairro    As String
	WSData WsCEP       As String
	WSData WsCnpj      As String
	WSData WsDDD       As String
	WSData WsTel       As String
	WSData WsInscEst   As String
	WSData WsInscMun   As String
	WSData WsEmail     As String
	WSData WsBacen     As String
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do tipo de dados de retonro de operação do Web Service        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WsService cherwellcliente DESCRIPTION "WebService Integra Cliente Cherwell x Protheus" NAMESPACE "http://187.94.60.7:8060/ws/cherwellcliente.apw" 
	Wsdata cliente     As cliente  
	Wsdata WsRetorno   As string

	WsMethod IntegraCherwell DESCRIPTION "Metodo de inclusao/alteracao dos dados dos clientes do Cherwell com o Protheus. Exige usuario e senha."
EndWsService

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³IntegraCherwell ³Autor  ³ Fagner O. da Silva     ³16.06.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de inclusao/alteracao de dados do cadasto de clientes.³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WsMethod integracherwell; 
  WsReceive cliente;
  WsSend    WsRetorno;
  WsService cherwellcliente

Local cQry     := ""
Local cMensagem:= ""
Local cTrb1    := ""
Local cFilSA1  := ""
Local cFilTrb  := ::cliente:wsFilial
Local cEmpTrb  := "01" //LEFT(::cliente:wsFilial,2)
Local cCodCli  := ""
Local cLojaCli := "01"
Local cCodCher := AllTrim(::cliente:wsCodCher) //StrZero(::cliente:wsCodCher,TAMSX3("A1_XXCHERW")[1])
Local cRazao   := AllTrim(::cliente:wsRazao)
Local cFantasia:= AllTrim(::cliente:wsFantasia)
Local cEnd     := AllTrim(::cliente:wsEnd)
Local cBairro  := AllTrim(::cliente:wsBairro)
Local cEstado  := AllTrim(::cliente:wsEstado)
Local cMunic   := AllTrim(::cliente:wsMunic)
Local cCEP     := AllTrim(::cliente:wsCEP)
Local cCnpj    := AllTrim(::cliente:wsCnpj)
Local cInscEst := AllTrim(::cliente:wsInscEst)
Local cInscMun := AllTrim(::cliente:wsInscMun)
Local cEmail   := AllTrim(::cliente:wsEmail)
Local cDDD     := AllTrim(::cliente:wsDDD)
Local cTel     := AllTrim(::cliente:wsTel)
Local cBacen   := AllTrim(::cliente:wsBacen)
Local cpath    := "\Log_erros\"
Local cLog     := ""
Local cBKPFil  := ""

Local aDados   := {}

Local nOpc     := 0

Private lMsErroAuto := .F.

cFilTrb  := PADR(ALLTRIM(cFilTrb),TAMSX3("A1_FILIAL")[1])


u_xConOut("Preparando empresa ...")
u_xConOut("")
u_xConOut("EMPRESA: " + cEmpTrb + SPACE(5) + "FILIAL: " + cFilTrb  + SPACE(5) + DTOS(DDATABASE))

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



dbSelectArea("SX6")

If ::cliente:wsUsuario == "Cherwell" .And. ::cliente:wsPassword == "123456"

	u_xConOut("Senha validada com sucesso!")

	dbSelectArea("SA1")
	dbOrderNickName("CHERWELL")
	dbSeek(cFilSA1+cCodCher)
	If SA1->(!Eof())
		&&Encontrado o CodCherwell no Protheus. Então deverá alterar.
		nOpc := 4
		u_xConOut("Vai alterar o cliente de IdCherwell.: " + cCodCher)
		cCodCli := SA1->A1_COD
		cLojaCli := SA1->A1_LOJA
	Else
		&&Não encontrado o CodCherwell no Protheus. Então deverá incluir.
		nOpc := 3
		u_xConOut("Vai incluir o cliente de IdCherwell.: " + cCodCher)
		&& Gera o proximo sequencial do cliente.
		dbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		While SA1->(dbSeek(cFilSA1+cCodCli))
			ConfirmSX8()
			cCodCli := GetSxeNum("SA1","A1_COD")
		End
	EndIf

	dbSelectArea("SA1")
	dbSetOrder(3)
	If dbSeek(cFilSA1+cCNPJ)
		&&Encontrado o CodCherwell no Protheus. Então deverá alterar.
		nOpc := 4
		u_xConOut("Vai alterar o cliente de IdCherwell.: " + cCodCher)
		cCodCli := SA1->A1_COD
		cLojaCli := SA1->A1_LOJA
	Endif
	
	u_xConOut("---------------- Dados do Cliente --------------")
	u_xConOut("Cliente.: " + cCodCli+"-"+cLojaCli)
	u_xConOut("Razao...: " + cRazao)
	u_xConOut("Fantasia: " + cFantasia)
	u_xConOut("Endereco: " + cEnd)
	u_xConOut("Bairro..: " + cBairro)
	u_xConOut("Estado..: " + cEstado)
	u_xConOut("Municip.: " + cMunic)
	u_xConOut("Cep.....: " + cCEP)
	u_xConOut("Cnpj....: " + cCnpj)
	u_xConOut("Insc.Est: " + cInscEst)
	u_xConOut("Insc.Mun: " + cInscMun)
	u_xConOut("Email...: " + cEmail)
	u_xConOut("DDD.....: " + cDDD)
	u_xConOut("Tel.....: " + cTel)
	u_xConOut("Bacen...: " + cBacen)
	u_xConOut("Id.Cherw: " + cCodCher)
	u_xConOut("---------------- Dados do Cliente --------------")

	aDados := { 	{"A1_FILIAL", cFilSA1             ,Nil},;
					{"A1_COD" ,   cCodCli             ,Nil},;
					{"A1_LOJA",   cLojaCli            ,Nil},;
					{"A1_NOME",   cRazao              ,Nil},;
					{"A1_NREDUZ", cFantasia           ,Nil},;
					{"A1_END",    cEnd                ,Nil},;
					{"A1_BAIRRO", cBairro             ,Nil},;
					{"A1_EST",    cEstado             ,Nil},;
					{"A1_COD_MUN",    cMunic              ,Nil},;
					{"A1_CEP",    cCEP                ,Nil},;
					{"A1_PESSOA", "J"                 ,Nil},;
					{"A1_TIPO",   "F"                 ,Nil},;
					{"A1_CGC",    cCnpj               ,Nil},;
					{"A1_INSCR",  cInscEst            ,Nil},;
					{"A1_INSCRM", cInscMun            ,Nil},;
					{"A1_EMAIL",  cEmail              ,Nil},;
					{"A1_DDD",    cDDD                ,Nil},;
					{"A1_TEL",    cTel                ,Nil},;
					{"A1_MSBLQL", IIF(nOpc==3,"1","2"),Nil},;
					{"A1_CODPAIS",cBacen              ,Nil},;
					{"A1_XXCHERW",cCodCher            ,Nil}}
					/*,;										
               	    { "A1_RECCOFI"  , Alltrim("N")  ,NIL},;
               	    { "A1_RECCSLL"  , Alltrim("N")  ,NIL},;
               	    { "A1_RECPIS"  , Alltrim("N")  ,NIL},;   
               	    { "A1_REGESIM"  , Alltrim("N")  ,NIL},;   
               	    { "A1_TPDP"  , Alltrim("N")  ,NIL},;                	    
               	    { "A1_MINIRF"  , Alltrim("N")  ,NIL},;
               	    { "A1_B2B"  , Alltrim("N")  ,NIL},;
               	    { "A1_IRBAX"  , Alltrim("N")  ,NIL},;
               	    { "A1_TRIBFAV"  , Alltrim("N")  ,NIL},;
               	    { "A1_TPDP"  , Alltrim("N")  ,NIL},;
               	    { "A1_ABATIMP"  , Alltrim("1")  ,NIL}}
                    */

	lMsErroAuto := .F.
	MSExecAuto({|x,y| mata030(x,y)},aDados,nOpc)

	If lMsErroAuto

		If nOpc == 3
			cMensagem := "NOK|Erro ao incluir os dados do cliente no Protheus."
		Else
			cMensagem := "NOK|Erro ao alterar os dados do cliente no Protheus."
		EndIf

		cMensagem += Chr(13)+Chr(10)

		cFile := "cherwell_cliente_"+alltrim(cCodCher)+".log"   
		cLog  := MostraErro(cpath,cfile)

		&&buscar no TXT qual erro ocorreu e acrescentar ao cErr antes de enviar ao Log
		cMensagem += U_cherErr(cpath+cfile)
		//u_xConOut(cMensagem)

	Else

		cMensagem := "OK|" + cCodCli +"/"+ cLojaCli+". Registro "+ If(nOpc == 3, "incluído","alterado") +" com sucesso!"
		//u_xConOut(cMensagem)
		u_xConOut("")
		Envmail(nOpc, cCodCli, cRazao, cCodCher)

	EndIf

Else

	cMensagem := "NOK|Usuario/Senha incorreto!"
	//u_xConOut(cMensagem)

EndIf

::wsRetorno := cMensagem
U_CherLog("01", If(lMsErroAuto, If(nOpc==3,"",cCodCli + cLojaCli), cCodCli + cLojaCli ), dDatabase, If(!lMsErroAuto, "", cMensagem), AllTrim(cCodCher)  )

cFilant := cBKPFil

&& Não usar este comando com WebService. Atrapalha 
//RpcClearEnv()

u_xConOut("Mensagem de Retorno.: " + ::wsRetorno)

Return .T.

*-----------------------------------------------------*
Static Function Envmail(nOpc, cCodCli, cNome, cCodCher)
*-----------------------------------------------------*
Private aLista   := {}
Private aDados   := {}

Private cMSG     := ""
Private cError   := ""
Private cPass    := Trim(GetMV("MV_RELPSW"))  //"Ot2ygTLgBcHJ"
Private cAccount := Trim(GetMV("MV_RELACNT")) //""
Private cServer  := Trim(GetMV("MV_RELSERV")) //""
Private cFrom    := Trim(GetMV("MV_RELFROM")) //""
Private cPara    := Trim(Getmv("MV_XXWSTO1",.F.,"fabio.regueira@portonovosa.com"))

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
If nOpc == 3
	cMsg += '<title> Integracao Cherwell - Inclusao </title>' 
Else
	cMsg += '<title> Integracao Cherwell - Alteracao </title>' 
Endif
cMsg += '</head>' 
cMsg += '<b><font size="3" face="Arial" color="Black">Email Automático gerado pelo Webservice. Não responda este e-mail.</font></b>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Favor validar as informacoes do cliente.</font>'
cMsg += '</p>'
cMsg += '<font size="3" face="Arial" color="Black">Codigo do Cliente no Protheus.: ' + cCodCli  + '</font>'
cMsg += '</p>' 
cMsg += '<font size="3" face="Arial" color="Black">Nome do Cliente Protheus.: ' + cNome + '</font>' 
cMsg += '</p>' 
cMsg += '<font size="3" face="Arial" color="Black">Cod Cliente Cherwell.: ' + cCodCher + '</font>' 
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


//http://187.94.60.7:8035/ws/cherwellcliente.apw?wsdl   --homologação
//http://187.94.60.223:7008/ws/cherwellcliente.apw?wsdl --Teste

