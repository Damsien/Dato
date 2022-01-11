WITH p_liste;

PACKAGE p_source IS

    type T_String is new String(1..200);

    FUNCTION TToString(el : T_String) RETURN String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;
    
    PROCEDURE chargerInstructions(Nom_Fichier : IN String);

PRIVATE

    TYPE T_SOURCE IS
    RECORD
        instructions: T_LISTE;
    END RECORD;

END p_source;