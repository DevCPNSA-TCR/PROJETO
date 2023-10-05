#INCLUDE "PROTHEUS.CH"   
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH" 


user function BlqSB1()

/*
cQry := ""
cQry += "update " + retSQLName("SB1") + " set B1_MSBLQL = '2' "
cQry += " from " + retSQLName("SB1" ) + " SB1 "
cQry += " inner join " + retSQLName("SB2") + " SB2 ON SB1.B1_COD = SB2.B2_COD and SB1.D_E_L_E_T_ = SB2.D_E_L_E_T_ "
cQry += " WHERE SB1.D_E_L_E_T_ = '' "
cQry += " AND SB1.B1_MSBLQL = '1' AND SB2.B2_QATU <> 0 AND SB2.B2_LOCAL = 01 "
*/ 


// Produtos com saldo 0 em estoque e que estão desbloqueado
// ação: Bloquear produtos sem saldos no armazem 01.

cQry := ""
cQry += "update " + retSQLName("SB1") + " set B1_MSBLQL = '1' "
cQry += " FROM " + retSQLName("SB1") + " SB1 "  
cQry += " INNER JOIN " +  retSqlName("SB2") + " SB2  ON SB1.B1_COD = SB2.B2_COD "  
cQry += " WHERE SB1.D_E_L_E_T_ = '' " 
cQry += " AND ( SB1.B1_MSBLQL = '2'  OR SB1.B1_MSBLQL ='' ) "
cQry += " AND SB1.B1_CODISS = '' AND SB2.B2_LOCAL ='01'  AND SB2.B2_QATU = 0  "

//SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_LOCPAD,  B2_LOCAL, B2_LOCALIZ, B2_QATU, B1_MSBLQL
//FROM SB1010  AS SB1  INNER JOIN SB2010 AS SB2 ON SB1.B1_COD = SB2.B2_COD  
//WHERE SB1.D_E_L_E_T_ = '' 
//AND ( SB1.B1_MSBLQL = '2'  OR SB1.B1_MSBLQL ='' )
//AND SB1.B1_CODISS = '' 
//AND SB2.B2_LOCAL ='01' 
//AND SB2.B2_QATU = 0 
//ORDER BY B1_COD 


If TcSqlExec( cQry ) = 0
   alert('Okay')
endif

return