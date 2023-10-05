
#Include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110FIL  ºAutor  ³Ricardo Ferreira	 º Data ³  16/12/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra as solicitações para serem visualizadas somente peloº±±
±±º          ³ proprio solicitante ou pelo seu comprador                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110FIL()

	Local cFiltro := ""
	Local lCompra	:= .f.
	Local cUser	:= UsrRetName(__cUserId)
	Local cFil		:= xFilial("SAJ")
	Local cGrupos	:= ""
	Local cCustos := ""
	Local lAprova := .f.

	If Select("TMPSAJ") > 0
		DbSelectArea("TMPSAJ")
		DbCloseArea()
	Endif

	BeginSql Alias "TMPSAJ"

	%noparser%

	SELECT AJ_GRCOM FROM %table:SAJ% SAJ 
	WHERE 	AJ_USER = %exp:__cUserId% AND 
	AJ_FILIAL = %exp:cFil% and
	SAJ.%notdel%

	EndSql

	While !TMPSAJ->(Eof())
		lCompra := .t.
		cGrupos += "|" + AJ_GRCOM 
		TMPSAJ->(Dbskip())
	Enddo


	If lCompra



		cFiltro := "EMPTY(SC1->C1_GRUPCOM) .OR. SC1->C1_GRUPCOM $ '" + cGrupos + "'"


	Else
		/* Verifica se o usuário logado é aprovador*/

		If Select("TMPSAL") > 0
			DbSelectArea("TMPSAL")
			DbCloseArea()
		Endif

		/*
		Alterado por Ricardo Ferreira em 30/06/2017	
		BeginSql Alias "TMPSAL"
		%noparser%
		SELECT CTT_CUSTO FROM %table:CTT% CTT
		WHERE CTT.%notdel% and EXISTS(SELECT 1 FROM %table:SAL% SAL WHERE AL_USER = %exp:__cUserID% AND CTT_XGPCMP = AL_COD AND SAL.%notdel%) 

		EndSql
		*/
		BeginSql Alias "TMPSAL"
		%noparser%
		SELECT DBL_CC FROM %table:DBL% DBL
		WHERE DBL.%notdel% and EXISTS(SELECT 1 FROM %table:SAL% SAL WHERE AL_USER = %exp:__cUserID% AND DBL_GRUPO = AL_COD AND SAL.%notdel%) 

		EndSql


		While !TMPSAL->(Eof())
			lAprova := .t.
			//cCustos +=	"|" + ALLTRIM(TMPSAL->CTT_CUSTO)
			cCustos +=	"|" + ALLTRIM(TMPSAL->DBL_CC)
			TMPSAL->(DbSkip())
		Enddo

		If lAprova //Se for aprovador

			cFiltro := "alltrim(SC1->C1_CC) $ '" + cCustos + "'"


		Else
			//******************************************************************
			/* VERIFICA SE O USUÁRIO É SOLICITANTE */   
			//******************************************************************

			// Fabio Flores Regueira - 28/09/2015

			If Select("TMPSAI") > 0
				DbSelectArea("TMPSAI")
				DbCloseArea()
			Endif

			BeginSql Alias "TMPSAI"
			%noparser%
			SELECT DISTINCT(AI_USER) FROM %table:SAI% SAI 
			WHERE 	AI_USER = %exp:__cUserId% AND 
			AI_FILIAL = %exp:cFil% and
			SAI.%notdel%
			EndSql

			While !TMPSAI->(Eof())
				lAprova := .t.
				TMPSAI->(DbSkip())
			Enddo

			If lAprova // é solicitante

				cFiltro := "SC1->C1_SOLICIT = '" + cUser + "'"

			endif 		



		Endif



	Endif



Return(cFiltro)
