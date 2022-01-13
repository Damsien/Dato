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

    FUNCTION removeSpaces(s: IN String) RETURN STRING IS
        c: Character := s(s'First);
        str: String(s'First..s'Last);
        counter: Integer := 1;
    BEGIN
        FOR i in s'First..s'Last LOOP
            IF c = ' ' AND c = s(i) THEN
                NULL;
            ELSE
                str(i) := s(i);
                counter := counter + 1;
            END IF;
            c := str(i);
        END LOOP;
        New_Line;
        Put_Line(s);
        New_Line;
        Put(str'First);
        New_Line;
        Put(counter);
        RETURN str(str'First..counter);
    END removeSpaces;

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
            RETURN removeSpaces(s(index..s'Last));
        ELSE
            RETURN "";
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
            IF clarifyString(instructionCourante.All) /= "" THEN
                ajouter(
                    source.instructions, 
                    StringToT(clarifyString(instructionCourante.All))
                );
            ELSE
                NULL;
            END IF;
        END LOOP;
        close(Fichier);

        New_Line;
        afficherListe(source.instructions);
    END chargerInstructions;


END p_source;