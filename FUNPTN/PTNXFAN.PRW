#Include "totvs.ch"
#include  "TOPCONN.CH"

/*/Protheus.doc xConout
// TODO

Esta funcao foi criada com o inuito de dar agilidade a grava??o de mensagens no console.log
devido a Totvs ter descontinuado a utilização do conout.
FwLogMsg(_cType, cTransactionId, _cNomeGrp, _cCat, _cStep, _cIDMsg, _cMsg, _nMeasure, (_nStart - Seconds()), _aMsg) // nStart Ã© declarada no inicio da funÃ§Ã£o
/*/
/*/{Protheus.doc} User Function xConOut
	(long_description)
	@type  Function
	@author Sergio (Criare Consulting)
	@since 26/04/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
	
Return return_var
User Function xConOut(_cMsg, _cType, _cTransID, _cNomeGrp, _cCat, _cStep, _cIDMsg, _nMeasure, _aMsg)

	//Local _nStart := Seconds()

    Default _cMsg     := ''
	Default _cType    := "INFO"
	Default _cTransID := "LAST"
	Default _cNomeGrp := "MEUGRUPO"
	Default _cCat     := FunName()
	Default _cStep    := ""
	Default _cIDMsg   := "01"
	Default _nMeasure := 0
	Default _aMsg     := {}

    LogMsg(Funname(),1,7,1,'','',_cMsg)
	
Return NiL


/*/{Protheus.doc} fType
description
@type function 
@author Sergio (Criare Consulting)
@since 26/04/2023
@param _xVal, variant, param_description
@return variant, return_description
/*/
User Function fType(_xVal)

Return (Type(('"' + _xVal + '"')))

/*/{Protheus.doc} fConType
description
@type function
@author Sergio (Criare Consulting)
@since 26/04/2023
@param _cCampo, variant, param_description
@param _xValor, variant, param_description
@return variant, return_description
/*/
User Function fConType(_cCampo,_xValor)

Local _xRet
Local _cTipo := GetSX3Cache(_cCampo,"X3_TIPO")

Do Case
	CASE _cTipo == "C"
		_xRet := UPPER(NoAcento(_xValor))
	CASE _cTipo == "D"
		_xRet :=  CtoD(_xValor,"DDMMYY")
	CASE _cTipo == "N"
		_xRet := val(_xValor)
EndCase

Return _xRet
