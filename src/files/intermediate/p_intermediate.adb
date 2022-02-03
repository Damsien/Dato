with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with p_source; use p_source;
with op_string; use op_string;

package body p_intermediate is

    PROCEDURE Inserer_L(instruction : IN String) IS
    BEGIN
        Inserer(instruction);
        CP := CP + 1;
    END Inserer_L;

    PROCEDURE Inserer_Entete(instruction : IN String) IS
    BEGIN
        p_intermediate.Modifier(instruction,CP_ENTETE);
    END Inserer_Entete;

    PROCEDURE Inserer(instruction : IN String) IS
    existing : T_String;
    concat : T_String;
    tmp : Integer;
    BEGIN

        BEGIN
        existing := P_LISTE_CH_CHAR.obtenir(intermediaire.instructions,CP);
        EXCEPTION
            WHEN E : P_LISTE_CH_CHAR.NOT_FOUND =>       
                                    existing := StringToT("");
        END;
        

        IF TToString(existing)'length /= 0 THEN
            tmp := instruction'Length;
            concat := new String'(existing.All & instruction);
            tmp := concat'Length;
            p_intermediate.Modifier(concat.All,CP);     
        ELSE
            P_LISTE_CH_CHAR.ajouter(intermediaire.instructions,new String'(instruction));
        END IF;
    END Inserer;

    Procedure Modifier(instruction : IN String ; ligne : IN Integer) IS
        str : T_String;
        tmp : Integer;
    BEGIN
            tmp := instruction'Length;


            str := new String(1..instruction'Length);
            for i in 1..instruction'Length loop
                str.All(i) := instruction(i);
            end loop;
            P_LISTE_CH_CHAR.modifier(intermediaire.instructions,ligne,str);
            Put("");

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
        Put("");
        P_LISTE_CH_CHAR.afficherListe(intermediaire.instructions);
    END Afficher;

    PROCEDURE Ecrire(path : String) IS
        l : P_LISTE_CH_CHAR.T_LISTE := intermediaire.instructions;
        F : File_Type;
        s : String(1..path'Length);
    BEGIN
        s := path;
        s(s'Last-3..s'Last) := "toda";
        Create (F, 
        Out_File, 
        s);
        while P_LISTE_CH_CHAR.isNull(l) loop
            Put_Line (F, l.All.Element.All);
            l := l.All.Suivant;
        end loop;
    END Ecrire;


    PROCEDURE Ecrire IS
        l : P_LISTE_CH_CHAR.T_LISTE := intermediaire.instructions;
        F : File_Type;
    BEGIN
        Create (F, 
        Out_File, 
        filename.All);
        while P_LISTE_CH_CHAR.isNull(l) loop
            Put_Line (F, l.All.Element.All);
            l := l.All.Suivant;
        end loop;
    END Ecrire;

    Function Empty(s : String) RETURN String IS
    BEGIN
        RETURN "";
    END Empty;

    FUNCTION RecupererNom(s : String) RETURN String IS
    BEGIN
        -- Linux / Mac
        IF Index(s, "/") > 0 THEN
            RETURN RecupererNom(s(Index(s, "/")+1..s'Last));
        -- Windows
        ELSIF Index(s, "\") > 0 THEN
            RETURN RecupererNom(s(Index(s, "\")+1..s'Last));
        END IF;
        RETURN s;
    END;

    PROCEDURE setNom(fichier : String) IS
        s : String(1..fichier'Length);
    BEGIN
        s := fichier;
        p_intermediate.filename := new String'(s(s'First..s'Last-4)&"toda");
    END;



end p_intermediate;