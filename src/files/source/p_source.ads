WITH p_liste;

PACKAGE p_source IS

    --TYPE T_String IS NEW String;
    TYPE T_String IS ACCESS String;

    FUNCTION TToString(el : T_String) RETURN String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;
    
    FUNCTION removeSpaces (s: IN String ; l: IN Integer) RETURN String;

    FUNCTION clarifyString(s: IN String) RETURN String;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String);

PRIVATE

    TYPE T_SOURCE IS
    RECORD
        instructions: T_LISTE;
    END RECORD;

END p_source;