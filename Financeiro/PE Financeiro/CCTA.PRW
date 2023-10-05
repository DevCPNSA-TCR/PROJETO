#INCLUDE "rwmake.ch"   
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "topconn.ch"

		/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCAKD    º Autor:Jalles Araújo º Data ³14/05/2013           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que traz a conta orçamentária correspondente à      º±±
±±º				verba que está sendo calculada.                           º±±                                
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                

User function CCTA()
Local cCusto
Local dData	:=dDatabase   
Local dData1	:=Lastday(SRT->RT_DATACAL,1) 
Local dData2	:=Lastday(SRT->RT_DATACAL) 
Local cMat
Local cQuery1:=""
Local lRet :=.T.
Local aArea := GetArea()        

cMat		:=SRT->RT_MAT      //Matricula do reg. corrente
cVerba		:=SRT->RT_VERBA    //Verba do reg. corrente

//Query para buscar as verbas utilizadas
cQuery1 := "SELECT * FROM " + RetSqlName("SRT")+(" SRT,")+RetSqlName("SRV")+(" SRV")
cQuery1 += " WHERE RT_MAT ="+cMat+" AND RT_VERBA ='"+cVerba+"'AND RV_COD=RT_VERBA AND " 
cQuery1 += "RT_DATACAL BETWEEN '"+ Dtos(dData1) + "' AND '" + Dtos(dData2)+ "' AND SRT.D_E_L_E_T_=' ' AND SRT.D_E_L_E_T_=' '" 
                                  
TcQuery cQuery1 Alias "SRTTMP2" New       

DbSelectArea("SRTTMP2")               
cCta:= ' ' 
While !SRTTMP2->(Eof()) .and. lRet=.T.	
	If (SRTTMP2->RT_MAT == cMat).AND.(SRTTMP2->RT_VERBA=='P33'.OR.SRTTMP2->RT_VERBA =='P36'.OR.SRTTMP2->RT_VERBA=='P38')
   		cCta:= '23210' // ADICIONAL --- PROVISAO -- 1/3	
		lret:=.F.
	
	ElseIf SRTTMP2->RT_VERBA=='P28'.OR. SRTTMP2->RT_VERBA=='P25'
		cCta:= '23211' //FERIAS		
		lret:=.F.	
	
	ElseIf SRTTMP2->RT_VERBA ==  'P35'
		cCta:= '23205' //INSS		
		lret:=.F.
	
	ElseIf SRTTMP2->RT_VERBA ==  'P26'
		cCta:= '23207' //FERIAS		
		lret:=.F.
	
	ElseIf SRTTMP2->RT_VERBA ==  'P27'
		cCta:= '23206' //FERIAS		
		lret:=.F.
			        
	Elseif SRTTMP2->RT_VERBA == 'P34'
	    cCta:= '23204' //FGTS
		lret:=.F.
	Endif
	dbskip()
Enddo
DbCloseArea("SRTTMP")
RestArea(aArea) 

Return(cCta)