#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zX3ToArr
Fun��o que exporta a SX3 adicionando uma linha no array
@type  Function
@author Criare Consultig
@since 02/02/2023
@version version
@param aArray, Array, Vari�vel do Array que ter� o conte�do adicionado (deve ser passado com @)
@param cCampo, Caractere, Nome do campo a ser verificado na SX3
@param nTipo, Numeric, Tipo do array
@param cTituloDef, Caractere, T�tulo default da coluna a ser considerado no lugar do X3_TITULO
@param cCampoDef, Caractere, Nome do campo que ser� usado no array (para MsNewGetDados)
@param cBlocoDef, Caractere, Texto do bloco de c�digo que ser� adicionado no array (para FWBrwColumn)
@param cAliasDef, Caractere, Alias Default usado em FWMarkBrowse no m�todo SetFields
@obs Tipos do nTipo:
    1 = Campos para FWTemporaryTable
    2 = Campos para um aHeader de um FWMarkBrowse
    3 = Campos para aSeek FWMarkBrowse
    4 = Campos para um aHeader de um MsNewGetDados
    5 = Campos para um aHeader composto de FWBrwColumn, por�m para usar em um FWFormBrowse
    6 = Campos para filtro de SetFieldFilter em um FWFormBrowse
    7 = Campos para defini��o de um FWMarkBrowse (m�todo SetFields)
/*/

User Function zX3ToArr(aArray, cCampo, nTipo, cTituloDef, cCampoDef, cBlocoDef, cAliasDef)
    Local aArea        := GetArea()
    Local cFieldX3     := ""
    Local cTipoX3      := ""
    Local cTitX3       := ""
    Local cPictX3      := ""
    Local cCBoxX3      := ""
    Local cF3X3        := ""
    Local cValidX3     := ""
    Local cUsadoX3     := ""
    Local cRelacaoX3   := ""
    Local aTamX3       := {}
    Local nTamArr      := 0
    Local cAliasTab    := ""
    Default aArray     := {}
    Default cCampo     := ""
    Default nTipo      := 0
    Default cTituloDef := ""
    Default cCampoDef  := ""
    Default cBlocoDef  := ""
    Default cAliasDef  := ""
 
    //Se tiver campo preenchido
    If ! Empty(cCampo)
        cFieldX3 := GetSX3Cache(cCampo, "X3_CAMPO")
 
        //Se o campo for encontrado na SX3
        If ! Empty(cFieldX3)
            nTamArr    := Len(aArray) + 1
            cAliasTab  := AliasCPO(cFieldX3)
            cTipoX3    := GetSX3Cache(cFieldX3, "X3_TIPO")
            aTamX3     := TamSX3(cFieldX3)
            cTitX3     := Iif(Empty(cTituloDef), GetSX3Cache(cFieldX3, "X3_TITULO"), cTituloDef)
            cPictX3    := PesqPict(cAliasTab, cFieldX3)
            cCBoxX3    := GetSX3Cache(cFieldX3, "X3_CBOX")
            cF3X3      := GetSX3Cache(cFieldX3, "X3_F3")
            cValidX3   := GetSX3Cache(cFieldX3, "X3_VALID")
            cUsadoX3   := GetSX3Cache(cFieldX3, "X3_USADO")
            cRelacaoX3 := GetSX3Cache(cFieldX3, "X3_RELACAO")
 
            //Para montar a Struct de uma FWTemporaryTable
            If nTipo == 1
                aAdd(aArray, {;
                    Iif(Empty(cCampoDef), cCampo, cCampoDef),;
                    cTipoX3,;
                    aTamX3[1],;
                    aTamX3[2];
                })
 
            //Para montar o aHeader de telas com Browse (FWMarkBrowse)
            ElseIf nTipo == 2
                aAdd(aArray, {;
                    Iif(Empty(cCampoDef), cCampo, cCampoDef),; 
                    cTitX3,;
                    nTamArr,;
                    cPictX3,;
                    1,;
                    aTamX3[1],;
                    aTamX3[2],;
                    cCBoxX3;
                })
 
            //Para montar o aSeek em telas com Pesquisa no Browse
            ElseIf nTipo == 3
                aAdd(aArray, { cTitX3, ;
                    { { "",;
                        cTipoX3,;
                        aTamX3[1],;
                        aTamX3[2],;
                        cTitX3,;
                        cPictX3;
                    } };
                })
 
            //Para montar o aHeader de telas com Browse (MsNewGetDados)
            ElseIf nTipo == 4
                aAdd(aArray, {;
                    cTitX3,;
                    Iif(Empty(cCampoDef), cCampo, cCampoDef),;
                    cPictX3,;
                    aTamX3[1],;
                    aTamX3[2],;
                    cValidX3,;
                    cUsadoX3,;
                    cTipoX3,;
                    cF3X3,;
                    cRelacaoX3,;
                    cCBoxX3;
                })
 
            //Para montar o aHeader de telas com FWBrwColumn (FWFormBrowse)
            ElseIf nTipo == 5
                aAdd(aArray, FWBrwColumn():New())
                nTamArr := Len(aArray)
 
                aArray[nTamArr]:SetType(cTipoX3)
                aArray[nTamArr]:SetTitle(cTitX3)
                aArray[nTamArr]:SetSize(aTamX3[1])
                aArray[nTamArr]:SetPicture(cPictX3)
                aArray[nTamArr]:SetDecimal(aTamX3[2])
                aArray[nTamArr]:SetData(&(cBlocoDef))
 
            //Para utilizar o m�todo SetFieldFilter (FWFormBrowse)
            ElseIf nTipo == 6
                aAdd(aArray, {;
                    cCampo,;
                    cTitX3,;
                    cTipoX3,;
                    aTamX3[1],;
                    aTamX3[2],;
                    cPictX3;
                })
 
            //Para utilizar o m�todo SetFields (FWMarkBrowse)
            ElseIf nTipo == 7
                aAdd(aArray, {;
                    cTitX3,;
                    &("{|| " + Iif(! Empty(cAliasDef), "(" + cAliasDef + ")->", "") + cCampo + "}"),;
                    cTipoX3,;
                    cPictX3,;
                    1,;
                    aTamX3[1],;
                    aTamX3[2],;
                    .F.,;
                    ,;
                    ,;
                    ,;
                    ,;
                    ,;
                    ,;
                    ,;
                    1;
                })
            EndIf
 
        EndIf
    EndIf
 
    RestArea(aArea)
Return
