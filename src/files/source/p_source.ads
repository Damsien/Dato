WITH p_liste;
WITH object; use object;

PACKAGE p_source IS

    TYPE T_SOURCE IS
    RECORD
        instructions: P_LISTE_CH_CHAR.T_LISTE;
    END RECORD;
    
    FUNCTION removeSingleSpace(s: IN String) RETURN String;

    FUNCTION removeSpaces (s: IN String ; l: IN Integer) RETURN String;

    FUNCTION clarifyString(s: IN String) RETURN String;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String);


END p_source;