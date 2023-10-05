#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PNEncFin     ºAutor  ³Fabio Flores        º Data ³ 17/12/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor total do item da nota fiscal de saida      º±±
±±º          ³ de acordo com a conta contabil passada como parametro.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINANCEIRO/CONTABIL - Utilizado na contabilização da baixa º±±
±±º            do titulo de prefixo ACE-Aviso de Cobrança de Encargos.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º LP 520 E 527 - IF(SE1->E1_PREFIXO="ACE",u_PNEncFin("32202"),0)        º±±
±±º                                                                       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteração ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

User Function PNEncFin(pConta)
Local aarea := getarea()
Local cQuery := '' 
Local __ret := '' 

cAliasQry := GetNextAlias()

cQuery := "SELECT D2_ITEM, D2_COD, D2_TOTAL, B1_CONTA "
cQuery += "  FROM " + RetSqlName( "SD2" )+" SD2 ,"+RetSqlName( "SB1" )+" SB1 " 
cQuery += " WHERE D2_DOC = '"+SE1->E1_NUM+"' "  
cQuery += "   AND D2_SERIE = '" + SE1->E1_PREFIXO+"' "
cQuery += "   AND D2_CLIENTE = '"+SE1->E1_CLIENTE+"' "   
cQuery += "   AND D2_LOJA = '"+SE1->E1_LOJA+"' "   
cQuery += "   AND D2_COD = B1_COD "
cQuery += "   AND SD2.D_E_L_E_T_ = ' '"
cQuery += "   AND SB1.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

while (cAliasQry)->(!EoF())

   if alltrim((cAliasQry)->B1_CONTA) == alltrim(pConta) 
   
      __ret := (cAliasQry)->D2_TOTAL
   
   endif 
   
   dbskip() 
 
Enddo 

Return(__ret)

