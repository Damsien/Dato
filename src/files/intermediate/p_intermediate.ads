WITH p_liste;

package p_intermediate is

    TYPE T_String IS ACCESS String;

    FUNCTION TToString(el : T_String) RETURN String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;
    
    PROCEDURE Inserer_L(instruction : IN String);

    PROCEDURE Inserer(instruction : IN String);

    Procedure Modifier(instruction : IN String ; ligne : IN Integer);

    Function GetCP() : Integer;

    Function GetFile() : T_INTERMEDIAIRE;

PRIVATE

    TYPE T_INTERMEDIAIRE IS
    RECORD
        instructions: T_LISTE;
    END RECORD;

    CP : Integer := 0;
    intermediaire : T_INTERMEDIAIRE;


end p_intermediate;