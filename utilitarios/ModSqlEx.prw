#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "FileIO.ch"

User Function ModSqlEx

Private oDlg
Private oGroup1
Private oGroup2
Private oGroup3
Private oMultiGet1
Private cMultiGet1 := "" 
Private cMultiGet2 := ""   
Private oCkScript
Private lCkScript  := .F.
Private cLabelCk   := "Executar Script SQL ( Separador # )"
Private cPerfil    := ""
Private oGetBD
Private oGetServ
Private oGetPort
Private cGetBD     := space(40)
Private cGetServ   := space(20)
Private cGetPort   := space(20)
  
//if ValidUsu()  
  
  DEFINE MSDIALOG oDlg TITLE "Query Explorer" FROM 000, 000  TO 470, 900 COLORS 0, 16777215 PIXEL

    @ 001, 003 GROUP oGroup1 TO 152, 447 PROMPT "SQL" OF oDlg COLOR 0, 16777215 PIXEL
    @ 152, 003 GROUP oGroup2 TO 206, 447 PROMPT "Status" OF oDlg COLOR 0, 16777215 PIXEL
    @ 205, 003 GROUP oGroup3 TO 232, 447 PROMPT "-" OF oDlg COLOR 0, 16777215 PIXEL
    @ 009, 006 GET oMultiGet1 VAR cMultiGet1 OF oDlg MULTILINE SIZE 436, 140 COLORS 0, 16777215 HSCROLL PIXEL
    @ 213, 008 BUTTON oButton1 PROMPT "Executar" SIZE 037, 012 OF oDlg PIXEL Action PrcConsSql(cMultiGet1)
    @ 213, 405 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDlg PIXEL Action oDlg:End()
    @ 215, 060 CHECKBOX oCkScript VAR lCkScript PROMPT cLabelCk SIZE 100, 008 OF oDlg COLORS 0, 16777215 PIXEL 
    
    @ 215, 170 SAY oSayBD PROMPT "Banco:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 215, 190 MSGET oGetBD VAR cGetBD SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 215, 255 SAY oSayServ PROMPT "Servidor:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 215, 280 MSGET oGetServ VAR cGetServ SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 215, 335 SAY oSayPort PROMPT "Porta:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 215, 350 MSGET oGetPort VAR cGetPort SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    
    @ 158, 006 GET oMultiGet2 VAR cMultiGet2 OF oDlg MULTILINE SIZE 436, 044 COLORS 0, 16777215 HSCROLL PIXEL
  
  ACTIVATE MSDIALOG oDlg

//endIf



Return

/*************************************************


*************************************************/
Static Function PrcConsSql(cSql)

Local cMsgErro 		:= ""
Local bError 		:= ErrorBlock({|e|BREAK(e)})
Local aSqlScript    := {}
Local aLogScript    := {}
Local nI            := 0
Local nCon          := 0
Local lContPrc      := .T.
Local lRetornaBD    := .F.
Local cArqCsvLog    := GetTempPath()+"MODSQL"+DTOS(Date())+StrTran(Time(),":","")+".csv"


Private cAliPrc 	:= "TPR"+Alltrim(Str(Randomize(1,200)))+DtoS(Date())+StrTRan(Time(),":","")
Private cUsrFull    := GetNewPar("MV_USRSQLF","000000")
Private cUsrCons    := GetNewPar("MV_USRSQLC","000000")
Private lEhProced   := .F.
Private aRetProced  := {}

if Empty(cSql)
 cMultiGet2 := "Script Invแlido."
 oDlg:refresh()
 Return(Nil)
endIf

if !Empty(cGetBD) .And. !Empty(cGetServ) .And. !Empty(cGetPort)
  TcConType("TCPIP")
  nCon := TCLink(ALLTRIM(cGetBD),ALLTRIM(cGetServ),VAL(cGetPort))
  /*
   banco = MSSQL7/RM_CKHH4G                        
   serv = 192.168.4.231  
   porta = 7800                         
  */
  lContPrc := nCon > 0
  if lContPrc 
    TcSetConn(nCon)
    lRetornaBD := .T.
  endIf  
endIf

Begin Sequence
 
 cMultiGet2 := ""
 cMultiGet2 := "Query Executada Com Sucesso."
 
 if lContPrc
 
	 if (At("Delete",cSql) > 0) .Or. (At("delete",cSql) > 0) .Or. (At("DELETE",cSql) > 0) .Or. (At("Update",cSql) > 0) .Or. (At("update",cSql) > 0) .Or. (At("UPDATE",cSql) > 0) .Or. (At("CREATE",cSql) > 0) .Or. (At("Create",cSql) > 0) .Or. (At("create",cSql) > 0) .Or. (At("insert",cSql) > 0) .Or. (At("Insert",cSql) > 0) .Or. (At("INSERT",cSql) > 0) .Or. (At("DROP",cSql) > 0)
	 	
	 	if __cUserId $ cUsrFull
	 	
		 	conout("Usuแrio: "+LogUserName()+" Executou a Query "+Alltrim(cSql)+" em "+DTOC(Date())+" "+TIME() )
		 	
		 	if lCkScript
		 	  aSqlScript := strtokarr ( cSql , "#" )
		 	  
		 	  for nI:=1 to len(aSqlScript)
			 	  if TcSqlExec(aSqlScript[nI]) < 0
			        
			        cMultiGet2 := TCSQLError()
			        oDlg:refresh()
			        AADD(aLogScript,{aSqlScript[nI],cMultiGet2})
			    
			      endIf
		 	  next
		 	  
		 	  if Len(aLogScript) > 0
		 	  
		 	    GrvRel(cArqCsvLog,"Script;LOG")
		 	    GrvRel(cArqCsvLog,"")
		 	    for nI:=1 to len(aLogScript)
		 	      GrvRel(cArqCsvLog,aLogScript[nI][01]+";"+SubStr(aLogScript[nI][02],1,260))
		 	    next
		 	        
		 	    oExcelApp := MsExcel():New()
                oExcelApp:WorkBooks:Open(cArqCsvLog) // Abre uma planilha
                oExcelApp:SetVisible(.T.)

		 	  endIf  
		 	
		 	else
		 	  if TcSqlExec(cSql) < 0
		        cMultiGet2 := TCSQLError()
		      endIf
		    endIf  
	    
	    else
	       cMultiGet2 := "Usuแrio Nใo Tem Permissใo Para Executar Esse Tipo de Query"
	    endIf
	    
	    
	 elseIf (At("Execute",cSql) > 0) .Or. (At("execute",cSql) > 0) .Or. (At("EXECUTE",cSql) > 0)
	  	
	  	lEhProced  := .T.
	  	if __cUserId $ cUsrFull
	  	  aRetProced := TCSPExec("AUDCTBFINCPBRAMEX", '20141001', '20141031', '20140101' ,'20201231' ,'  ', 'ZZZ' ,'  ', 'ZZZZ' ,'A' )
	  	  processa({||GerExcel()},"Gerando Planilha...")
	  	else
		  cMultiGet2 := "Usuแrio Nใo Tem Permissใo Para Executar Esse Tipo de Query"
		endif
	 
	 
	 else
		  	if __cUserId $ cUsrCons
			  	TcQuery cSql New Alias cAliPrc
			  	//processa({|| GerTelCons() },"Gerando Consulta...")
			    processa({||GerExcel()},"Gerando Planilha...")
			else
			    cMultiGet2 := "Usuแrio Nใo Tem Permissใo Para Executar Esse Tipo de Query"
			endif    
	 
	 endIf
 
 else
    cMultiGet2 := "Nใo conseguiu conexใo com Banco De Dados:"+chr(10)+chr(10)
    cMultiGet2 += "Banco : "+cGetBD+chr(10)+chr(10)
    cMultiGet2 += "Servidor : "+cGetServ+chr(10)+chr(10)
    cMultiGet2 += "Porta : "+cGetPort+chr(10)+chr(10)
 endIf
 
 oDlg:refresh()
 
Recover
 cMultiGet2 := TcSqlError()
 oDlg:refresh()
 dbCloseArea(cAliPrc)
End Sequence

dbCloseArea(cAliPrc)
ErrorBlock( bError )

if lRetornaBD
  TcSetConn(0)
endIf  

Return(Nil)


/*************************************************



*************************************************/
Static Function GerTelCons

Private oDlgC
Private oButton1C
Private oButton2C
Private oGroup1C
Private oGroup3C 
Private oGetDB

  DEFINE MSDIALOG oDlgC TITLE "Consulta Gerada" FROM 000, 000  TO 470, 800 COLORS 0, 16777215 PIXEL

    @ 001, 003 GROUP oGroup1C TO 205, 396 PROMPT "-" OF oDlgC COLOR 0, 16777215 PIXEL
    @ 205, 003 GROUP oGroup3C TO 232, 396 PROMPT "-" OF oDlgC COLOR 0, 16777215 PIXEL
    
    oGetDB := MsGetDB():New(16, 06, 217, 243, 3, , , , .F., , 1, .F., , &cAliPrc, , , .F., oDlgC, .T., ,, )   
    
    @ 213, 008 BUTTON oButton1C PROMPT "Exp. Excel" SIZE 037, 012 OF oDlgC PIXEL Action processa({|| GerExcel() },"Gerando Planilha...")
    @ 213, 355 BUTTON oButton2C PROMPT "Sair" SIZE 037, 012 OF oDlgC PIXEL Action oDlgC:End()
  ACTIVATE MSDIALOG oDlgC


Return




/*************************************************


*************************************************/
Static Function GerExcel

Local nQtdFld 	:= 0
Local nQtdRec   := 0
Local nRegAtu   := 0
Local nI 		:= 0
Local cCab 		:= ""
Local cLinha	:= ""
Local cArqCsv   := GetTempPath()+"MODSQL"+DTOS(Date())+StrTran(Time(),":","")+".csv"
Local oExcelApp
Local cBlocCod := ""

If !ApOleClient( 'MsExcel' )
  ApMsgInfo('MsExcel nao instalado')
  Return(.F.)
EndIf


if lEhProced
  nQtdRec := Len(aRetProced)
else 
	cAliPrc->(dbGoTop())
	while !cAliPrc->(Eof())
		nQtdRec++
		cAliPrc->(dbSkip())
	end
endIf

ProcRegua(nQtdRec)

nQtdFld := cAliPrc->(FCOUNT())
for nI:= 1 To nQtdFld
  cCab += cAliPrc->(FIELDNAME(nI))+";"
next

GrvRel(cArqCSV,cCab)
          
cAliPrc->(dbGoTop())
cBlocCod := ""

while !cAliPrc->(Eof())
 
 cLinha	:= ""
 nRegAtu++
 
 IncProc("Processando Reg.: "+Alltrim(Str(nRegAtu))+" De "+Alltrim(Str(nQtdRec)) )
 
 if Empty(cBlocCod)
 
 
	 for nI:= 1 To nQtdFld 
	   if Valtype(cAliPrc->&(FIELD(nI))) $ "C|D|N"
	     do case
	        case Valtype(cAliPrc->&(FIELD(nI))) == "N"
	          //cLinha += Alltrim( Transform( cAliPrc->&(FIELD(nI)),"@E 9,999,999,999,999.9999") ) +";"
	          cBlocCod += 'Alltrim( Transform( cAliPrc->&(FIELD('+Alltrim(Str(nI))+')),"@E 9,999,999,999,999.9999") ) +";" '
	        case Valtype(cAliPrc->&(FIELD(nI))) == "D"
	          //cLinha += DTOC(cAliPrc->&(FIELD(nI)))+";"
	          cBlocCod += 'DTOC(cAliPrc->&(FIELD('+Alltrim(Str(nI))+')))+";" '
	        otherWise
	          //cLinha += Alltrim(cAliPrc->&(FIELD(nI)))+";" 
	          cBlocCod += 'Alltrim(cAliPrc->&(FIELD('+Alltrim(Str(nI))+')))+";" '
	     endCase   
	   endIf
	   
	   if nI < nQtdFld
	     cBlocCod += ' + '
	   endIf
	                                                      
	 next
 
 endIf
 
 //cBlocCod := "{|| "+cBlocCod+&" }' 
 
 cLinha := &cBlocCod
 
 GrvRel(cArqCsv,cLinha)                              
 
 cAliPrc->(dbSkip())
end

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqCsv) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvRel(cArquivo,cTexto)

Local nHdl := 0

/***********************************
Verifica a Exist๊ncia do Arquivo
**********************************/

If !File( cArquivo )
	nHdl := FCreate( cArquivo )
Else
	nHdl := FOpen( cArquivo, 2 )
EndIf

/*********************************
Efetua Grava็ใo do Texto
********************************/

FSeek( nHdl, 0 , FS_END )
cTexto += chr(13)+chr(10)
FWrite( nHdl, cTexto, Len(cTexto) )
FClose( nHdl )

Return

/*******************************************


*******************************************/
Static Function ValidUsu

Local oDlgx
Local oButton1x
Local oButton2x
Local oGet1x
Local cGet1x := Space(30)
Local oGroup1x
Local oGroup2x
Local oSay1x
Local nOpc   := 0
Local lValid := .F.

  
while nOpc <> 2
  
  DEFINE MSDIALOG oDlgx TITLE "Autentica" FROM 000, 000  TO 150, 250 COLORS 0, 16777215 PIXEL

    @ 001, 002 GROUP oGroup1x TO 050, 122 PROMPT "Autentica็ใo Usuแrio:" OF oDlgx COLOR 0, 16777215 PIXEL
    @ 016, 026 MSGET oGet1x VAR cGet1x SIZE 060, 010 PASSWORD OF oDlgx COLORS 0, 16777215 PIXEL
    @ 018, 006 SAY oSay1 PROMPT "Senha:" SIZE 020, 007 OF oDlgx COLORS 0, 16777215 PIXEL
    @ 049, 002 GROUP oGroup2x TO 071, 122 PROMPT "-" OF oDlgx COLOR 0, 16777215 PIXEL
    @ 055, 040 BUTTON oButton1x PROMPT "&OK" SIZE 037, 012 OF oDlgx PIXEL Action {||nOpc := 1, oDlgx:end() }
    @ 055, 080 BUTTON oButton2x PROMPT "&Cancelar" SIZE 037, 012 OF oDlgx PIXEL  Action {||nOpc := 2 , oDlgx:end()}
  
  ACTIVATE MSDIALOG oDlgx
  
  if (nOpc == 1) 
    lValid := Alltrim(cGet1x) == "##trigo123"
    if !lValid 
      Aviso("Aten็ใo","Senha Incorreta!",{"OK"})
    else  
      nOpc := 2
    endIf
  endIf
  
end    

Return lValid

