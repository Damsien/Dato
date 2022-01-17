with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;

package body p_intermediate is

    FUNCTION TToString(el : T_String) RETURN String IS
        result : T_String;
    BEGIN
        result := new String'(el.All);
        RETURN result.All;
    END TToString;

    FUNCTION StringToT(el : String) RETURN T_String IS
        result : T_String;
    BEGIN
        result := new String'(el);
        RETURN result;
    END StringToT;

    PROCEDURE Inserer_L(instruction : IN String) IS
    BEGIN
        Inserer(instruction);
        CP := CP + 1;
    END Inserer_L;

    PROCEDURE Inserer(instruction : IN String) IS
    existing : T_String;
    concat : T_String;
    BEGIN
        Put("CP : ");
        Put(CP);
        New_line;
        existing := obtenir(intermediaire.instructions,CP);
        Put("Line :");
        IF existing /= NULL THEN
            Put_line(TToString(existing));
            concat := new String'(existing.All & instruction);
            Modifier(concat.All,CP);
        ELSE
            Put_line(" <empty> ");
            ajouter(intermediaire.instructions,new String'(instruction));
        END IF;
    END Inserer;

    Procedure Modifier(instruction : IN String ; ligne : IN Integer) IS
    BEGIN
            modifier(intermediaire.instructions,ligne,new String'(instruction));
    END Modifier;

    Function GetCP RETURN Integer IS
    BEGIN
        return CP;
    END GetCP;

    Function GetFile RETURN T_INTERMEDIAIRE IS
    BEGIN
        return Intermediaire;
    END GetFile;

    Procedure Afficher IS
    BEGIN
        afficherListe(intermediaire.instructions);
    END Afficher;

end p_intermediate;