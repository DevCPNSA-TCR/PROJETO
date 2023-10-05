#include "Rwmake.ch"
#Define cEnt	Chr(13) + Chr(10)    
**************************************************************************************
* Programa    : MT110VLD                                               Em : 15/08/14 *
* Objetivo    : Verifica se o usuário logado é solicitante. Somente quem estiver     *
*                cadastrado como solicitante poderá incluir, alterar ou excluir uma  *
*                SC.                                                                 *    		
* Autor       : Ricardo Ferreira                                                                *
**************************************************************************************    

************************
User Function MT110VLD()
************************
Local lRet := .f.
Local aArea := GetArea()

DbSelectArea("SAI")
DbSetOrder(2)
IF DbSeek(xFilial("SAI")+__cUserId)
	lRet := .t.
Else
	Aviso("Cadastro de Solicitantes","Seu usuário não está cadastrado como solicitante!" +cEnt+;
			"Somente solicitantes podem incluir solicitações de compras!" + cEnt+;
			"ENTRE EM CONTATO COM A EQUIPE DE SUPRIMENTOS!!!",{"Ok"})
Endif

RestArea(aArea)  
Return lRet  


**************************************************************************************
* Programa    : C1PRDVLD                                               Em : 18/08/11 *
* Objetivo    : Verifica se o usuário logado tem direito de solicitar o produto esco-*
*                lhido                                                               *
* Autor       : Ricardo Ferreira                                                     *
* Uso         : Validação do Campo C1_PRODUTO                                        *  
**************************************************************************************    

************************
User Function C1PRDVLD()
************************
Local lRet 	    := .t.
Local aArea 	:= GetArea()
Local cProd  	:= M->C1_PRODUTO 
Local cProdVld  := GetMV("MV_XPROD")
Local cGrupo	:= ""
//Pega o grupo do produto

DbSelectArea("SB1")
DbSetorder(1)
If DbSeek(xFilial("SB1")+cProd)
	cGrupo:= B1_GRUPO
Endif


If Select("TMPSAI") > 0
	DbSelectArea("TMPSAI")
	DbCloseArea()
Endif

BeginSql Alias "TMPSAI"
%noparser%
	SELECT COUNT(AI_USER) CONT FROM %table:SAI% SAI
	WHERE SAI.%notdel% and AI_USER = %exp:__cUserID% AND AI_GRUPO = %exp:cGrupo% AND AI_DOMINIO = "E" 

EndSql
 
If TMPSAI->(CONT) > 0
	
	Aviso("Cadastro de Solicitantes","Seu usuário não está habilitado a cadastrar produtos desse grupo!" +cEnt+;
			"ENTRE EM CONTATO COM A EQUIPE DE SUPRIMENTOS!!!",{"Ok"})
			
	lRet := .f.

Endif     

If cProd <= cProdVld  
	Aviso("Codigo de produtos","Não é possivel utilizar produtos com codigo " +cEnt+;
 			"inferior a " + cProdVld + " ! " + cEnt+;
  			"ENTRE EM CONTATO COM A EQUIPE DE SUPRIMENTOS!!!",{"Ok"})    

	lRet := .f.  
	
Endif

RestArea(aArea)
Return lRet


User Function AtuSAI()
Local aArea := GetArea()


	Processa({|| atuSaiA()},"Processando... " )
	
	Alert("Processo finalizado")
	
	RestArea(aArea)

Return

Static Function atuSaiA()
Local cUserTI 	:= "000131|000073|000244|000236|000226"
Local cUserEPI 	:= "000166|000199|000220|000228"
Local cUserADM 	:= "000046|000117|000176|000188"
Local aDados		:= {}
Local aGrupos		:= {"0009","0010","0015","0016","0011","0030"}
Local nCount		:= 0
local i :=0


If Select("TMPSAI") > 0
	DbSelectArea("TMPSAI")
	DbCloseArea()
Endif
BeginSql Alias "TMPSAI"
	%noparser%
	SELECT AI_FILIAL,AI_ITEM,AI_GRUPO,AI_PRODUTO,AI_DOMINIO,AI_GRUPCOM,AI_USER,AI_GRUSER,AI_QUANT
	FROM %table:SAI% SAI
	WHERE SAI.%notdel% AND SAI.AI_ITEM = '01'
	
EndSql

DbSelectArea("TMPSAI")
Count to nCount

ProcRegua(nCount)
TMPSAI->(DbGotop())

While !TMPSAI->(EOF())
	aDados := 	{TMPSAI->AI_FILIAL,TMPSAI->AI_ITEM,TMPSAI->AI_GRUPO,TMPSAI->AI_PRODUTO,TMPSAI->AI_DOMINIO,TMPSAI->AI_GRUPCOM,TMPSAI->AI_USER,TMPSAI->AI_GRUSER,TMPSAI->AI_QUANT}
	
	IncProc()
	
	DbSelectArea("SAI")
	nItem := 1
	For i:= 1 to Len(aGrupos) //quantidade de registros que serão incluidos por usuários

		

		IF TMPSAI->AI_USER $ cUserEPI .AND. i = 1
			Loop
		Endif	

		IF TMPSAI->AI_USER $ cUserADM .AND. i >= 2 .and. i<=4
			Loop
		Endif

		
		IF TMPSAI->AI_USER $ cUserTI .AND. i >= 5
			Loop
		Endif		
		
		nItem++
		DbSelectArea("SAI")
		RecLock("SAI",.t.)
		SAI->AI_FILIAL 	:= aDados[1]
		SAI->AI_ITEM		:= Strzero(nItem,2)
		SAI->AI_GRUPO		:= aGrupos[i]
		SAI->AI_PRODUTO	:= aDados[4]
		SAI->AI_DOMINIO	:= "E"
		SAI->AI_GRUPCOM	:= aDados[6]
		SAI->AI_USER		:= aDados[7]
		SAI->AI_GRUSER	:= aDados[8]
		SAI->AI_QUANT		:= aDados[9]
		MsUnLock()
		
	Next
	TMPSAI->(DbSkip())
Enddo


Return	
	




	
