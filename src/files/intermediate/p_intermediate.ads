WITH p_liste;


package p_intermediate is

    TYPE T_String IS ACCESS String;

    FUNCTION TToString(el : T_String) RETURN String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;

    TYPE T_INTERMEDIAIRE IS
    RECORD
        instructions: T_LISTE;
    END RECORD;

    FUNCTION StringToT(el : String) RETURN T_String;
    
    PROCEDURE Inserer_L(instruction : IN String);

    PROCEDURE Inserer(instruction : IN String);

    Procedure Modifier(instruction : IN String ; ligne : IN Integer);

    Function GetCP RETURN Integer;

    Function GetFile RETURN T_INTERMEDIAIRE;

    Procedure Afficher;


PRIVATE

    CP : Integer := 1;
    intermediaire : T_INTERMEDIAIRE;


end p_intermediate;