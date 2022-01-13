with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

PACKAGE BODY p_source IS

    TYPE N_STRING IS ACCESS String;
    source : T_SOURCE;

    FUNCTION TToString(el : T_String) RETURN String IS
        result : N_STRING;
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

    FUNCTION clarifyString(s: IN String) RETURN String IS
        c: Character;
        index: Integer := 1;
    BEGIN
        IF s'Last /= 0 THEN
            c := s(s'First);
            WHILE c = ' ' LOOP
                index := index + 1;
                c := s(index);
            END LOOP;
            RETURN s(index..s'Last);
        ELSE
            RETURN NULL;
        END IF;
    END clarifyString;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String) IS
        Fichier: File_Type;
        instructionCourante: N_STRING;
    BEGIN
        source.instructions := creerListeVide;

        open(Fichier, In_File, Name => Nom_Fichier);
        WHILE End_Of_File(Fichier) = False LOOP
            instructionCourante := new String'(Get_Line(Fichier));
            ajouter(
                source.instructions, 
                StringToT(clarifyString(instructionCourante.All))
            );
        END LOOP;
        close(Fichier);

        New_Line;
        afficherListe(source.instructions);
    END chargerInstructions;


END p_source;