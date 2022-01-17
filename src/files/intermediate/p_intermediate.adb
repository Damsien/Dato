with p_liste;

package body p_intermediate is

    FUNCTION TToString(el : T_String) RETURN String IS
        result : T_String;
    BEGIN
        result := new String'(el.All);
        RETURN result.All;
    END TToString;

    PROCEDURE Inserer_L(instruction : IN String) IS
    BEGIN
        Inserer(instruction);
        CP := CP + 1;
    END Inserer_L;

    PROCEDURE Inserer(instruction : IN String) IS
    existing : T_String;
    concat : T_String;
    BEGIN
        existing := obtenir(intermediaire.instructions,CP);
        IF existing /= NULL THEN
            concat := new String'(existing.All & instruction);
            Modifier(concat.All,CP);
        ELSE
            ajouter(intermediaire.instructions,new String'(instruction));
        END IF;
    END Inserer;

    Procedure Modifier(instruction : IN String ; ligne : IN Integer) IS
    BEGIN
            modifier(intermediaire.instructions,ligne,new String'(instruction));
    END Modifier;

    Function GetCP : Integer IS
    BEGIN
        return CP;
    END GetCP;

    Function GetFile : T_INTERMEDIAIRE
    BEGIN
        return Intermediaire;
    END GetFile;
    

end p_intermediate;