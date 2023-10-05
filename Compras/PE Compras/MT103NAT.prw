User Function MT103NAT

Local cNat := PARAMIXB
Local lRet := .T.
Local ni   := 1
Local cNatPed  := ""
Local nPosPed  := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_PEDIDO"})
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())

For ni := 1 To Len(Acols)
	
	If Acols[ni][Len(Acols[ni])] == .F.
		
		If nPosPed > 0
			
			If !EMPTY(Acols[ni][nPosPed])
				
				dbSelectArea("SC7")
				dbSetOrder(1)
				If dbSeek(xFilial("SC7")+Acols[ni][nPosPed])
					cNatPed := SC7->C7_XNAT
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
Next ni

If !EMPTY(cNat) .AND. !EMPTY(cNatPed)
	
	If cNat <> cNatPed
	    
		//Variável criada, pois o PE é executado 3x, então ocorria repetição do aviso na tela.
		If ( Type("_NatPedAnt") == "U" )
			Public _NatPedAnt := ""
		EndIf
		
		If _NatPedAnt <> cNat
		
			If Aviso("Atenção!","Natureza informada diferente do pedido. Natureza Sugerida: " + alltrim(cNatPed) + ". Ignorar susgestão e continuar com natureza informada?",{"Sim","Nao"}) == 2
				lRet := .F.
			Endif
		
		EndIf
		
	EndIf
	
	_NatPedAnt := cNat
	
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return(lRet)
        	