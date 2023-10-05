/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA280     ºAutor  ³Fabio Flores        º Data ³ 08/06/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Faturas informando o codigo de barras                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINANCEIRO - Faturas a Pagar                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºPe        ³ FA290() - EXECUTADO DURANTE A GRAVAÇÃO DA FATURA A PG.     º±±
±±ºPe        ³ FI290GE5- EXECUTADO ANTES DA  GRAVAÇÃO DA FATURA A PG.     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteração ³ Yttalo P. Martins - 07/10/2014                             º±±
±±º          ³ Validar centro de custo do grupo de materiais obras        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                

#INCLUDE "rwmake.ch"   
#INCLUDE "PROTHEUS.CH"
#define DS_MODALFRAME 128 
 
User function Fa290() 
//EXECBLOCK("CODBAR",.T.)   tamanho do campo se2->e2_CODBARR = 48 

Local oDlg, oGet1, oBtn1, oBtn2, nGet1:=SPACE(48), oSay, oGet2, nGet2:=SPACE(TAMSX3("CTT_CUSTO")[1]), oSay2
Local _aGrupo     := {}
Local _nX         := 1
Local _lGrpMatObr := .F.
Local _lOk        := .T.
Local _nOpc       := 0
Local _cGrupo     := ALLTRIM(GetNewPar("MV_XMTOBR",""))

*'Yttalo P. Martins-07/10/2014-INICIO-----------------------------------------------------'*
PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		_lGrpMatObr := .T.
	  		_lOk        := .F.
	  	EndIf
	Next _nX

EndIf
*'Yttalo P. Martins-07/10/2014-FIM--------------------------------------------------------'* 

DEFINE MSDIALOG oDlg FROM 0,0 TO 170,400 PIXEL TITLE 'Codigo de Barras - Fatura a Pagar' Style DS_MODALFRAME      //200,500    

oSay:= tSay():New(10,10,{||"Informe o Código de Barras..."},oDlg,,,,;
,,.T.,CLR_RED,CLR_WHITE,100,50)   

oGet1:= TGet():New(20,10,{|u| if(PCount()>0,nGet1:=u,nGet1)}, oDlg,;
170,10,,,,,,,,.T.,,,,,,,,,,'nGet1')

*'Yttalo P. Martins-07/10/2014-INICIO-----------------------------------------------------'*
//@ 70,10  BUTTON oBtn1 PROMPT "Confirmar" OF oDlg PIXEL ACTION GvCodBar(nGet1)
//@ 70,100 BUTTON oBtn2 PROMPT " Fechar  " OF oDlg PIXEL ACTION oDlg:End()

oSay2:= tSay():New(40,10,{||"Informe o Centro de Custos..."},oDlg,,,,;
,,.T.,CLR_RED,CLR_WHITE,100,50)

@ 50,10 MsGet oGet2 Var nGet2 Size 170,10 COLOR CLR_BLACK Picture "@!" F3 "CTT" PIXEL OF oDlg          

*'Yttalo P. Martins-07/10/2014-FIM--------------------------------------------------------'* 

@ 70,10  BUTTON oBtn1 PROMPT "Confirmar" OF oDlg PIXEL ACTION ( IIF(GvCodBar(nGet1,nGet2,_lGrpMatObr,@_lOk),oDlg:End(), )  )
@ 70,100 BUTTON oBtn2 PROMPT " Fechar  " OF oDlg PIXEL ACTION ( IIF(_lGrpMatObr==.F. .OR. (_lGrpMatObr==.T. .AND. _lOk==.T.),oDlg:End(),;
	msgalert("Usuário pertencente ao grupo: Materiais Obras. Preenchimento deste campo é obrigatório! ")) )  
ACTIVATE MSDIALOG oDlg CENTERED

//Incluido por Ricardo Ferreira em 22/09/2014
//Gravar o Codigo de retenção para titulos de IR gerados pela Folha
DbSelectArea("SE2")

Reclock("SE2",.F.)
If alltrim(SE2->E2_NATUREZ) $ cNat
	SE2->E2_CODRET	:=	posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_XCODRET")

Endif 
MsUnlock()

return (.T.)


//****************************
static function GvCodBar(pGet1,pGet2,_lGrpMatObr,_lOk)    
//****************************        

Local __aRet := {}
Local cNat		:= GETMV("MV_XIRFOL")
Local _lRet  := .T.
Local _aAreaSE2 := SE2->(GetArea()) 
    
DbSelectArea("SE2")

Reclock("SE2",.F.)

*'Yttalo P. Martins-07/10/2014-INICIO-----------------------------------------------------'* 
/*
if empty(pGet1) 
   msgalert("Ops! Código de Barras Vazio! ")
else                                  
   SE2->E2_CODBAR := ALLTRIM(pGet1) 
   msginfo("Código de Barras de N.:" + SE2->E2_CODBAR + " Registrado na Fatura de N.:" + SE2->E2_NUM)   
endif
*/
if empty(pGet2) .AND. _lGrpMatObr == .T. 
   msgalert("Usuário pertencente ao grupo: Materiais Obras. Preenchimento deste campo é obrigatório! ")
   _lOk        := .F.
else                                  
   _lOk        := .T. 
endif

If _lOk == .T. .OR. _lGrpMatObr == .F.

   If !EMPTY(pGet1)	
	   SE2->E2_CODBAR := ALLTRIM(pGet1) 
	   msginfo("Código de Barras de N.:" + SE2->E2_CODBAR + " Registrado na Fatura de N.:" + SE2->E2_NUM)   
   EndIf
   
   If _lGrpMatObr == .T. .AND. _lOk == .T.
        
   		_aAreaSE2 := SE2->(GetArea())
   
		dbSelectArea("CTT")
		dbSetorder(1)
		If dbSeek(xFilial("CTT")+pGet2)							
			If CTT->CTT_XMTOBR == "S"
				SE2->E2_CCD := pGet2
				_lOk := .T.
			Else
				_lOk := .F.							
			   msgalert("C.Custo escolhido não pertencente ao grupo: Materiais Obras! ")		
			EndIf
		EndIf
		
		RestArea(_aAreaSE2)
	
   EndIf
	
EndIf 

_lRet := _lOk

*'Yttalo P. Martins-07/10/2014-FIM--------------------------------------------------------'*

MsUnlock()

Return(_lRet) 