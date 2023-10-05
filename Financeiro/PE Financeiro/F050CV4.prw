#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Programa : F050CV4 | Autor : Rafael Sacramento  | Data : 12/06/2017     北
北                     |      Criare Consulting     |                      北   
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Desc. : Ponto de entrada para gravar campos customizados na tabela CV4. 北
北                                                      				   北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Uso  : Concession醨ia Porto Novo / M骴ulo Financeiro                    北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/ 

User Function F050CV4

RecLock("CV4", .F. )

	CV4->CV4_XCO	:= TMP->CTJ_XCO
	
MsUnlock()

Return