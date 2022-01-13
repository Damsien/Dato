WITH p_liste;

package intermediate is

    type T_String is new String(1..200);

    FUNCTION TToString(el : T_String) RETURN String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;
    
    PROCEDURE Inserer_L(instruction : IN String);

    PROCEDURE Inserer(instruction : IN String);

    Procedure Modifier(instruction : IN String ; ligne : IN Integer);

PRIVATE

    TYPE T_SOURCE IS
    RECORD
        instructions: T_LISTE;
    END RECORD;

    CP : Integer := 0;


end intermediate;