WITH p_liste;
WITH object; use object;

PACKAGE p_source IS

    TYPE T_SOURCE IS
    RECORD
        instructions: P_LISTE_CH_CHAR.T_LISTE;
    END RECORD;

    FUNCTION Upper_Case (S : String) RETURN String;

    FUNCTION replaceString(s: String ; pattern_to_be_replaced: String ; replace_pattern: String) RETURN String;
    
    FUNCTION removeSingleSpace(s: IN String ; l: IN Integer) RETURN String;

    FUNCTION removeSpaces (s: IN String ; l: IN Integer) RETURN String;

    FUNCTION clarifyString(s: IN String) RETURN String;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String);

    source : T_SOURCE;


END p_source;