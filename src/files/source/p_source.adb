with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

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

    FUNCTION removeSpaces(s: IN String ; l: IN Integer) RETURN String IS
        c: Character := s(s'First);
        str: String(s'First..s'Last);
        finalStr: N_STRING;
        pos: Integer;
        j: Integer := 1;
    BEGIN

        pos := Index(s, "  ");
        FOR i in s'First..s'Last LOOP
            IF i /= pos THEN
                str(j) := s(i);
            ELSE
                j := j - 1;
            END IF;
            j := j + 1;
        END LOOP;

        IF pos > 0 THEN
            RETURN removeSpaces(str, l-1);
        ELSE
            finalStr := new String(str'First..l);
            FOR i in str'First..l LOOP
                finalStr.All(i) := str(i);
            END LOOP;
            RETURN finalStr.All;
        END IF;
    END removeSpaces;

    FUNCTION clarifyString(s: IN String) RETURN String IS
        c: Character;
        index: Integer := 1;
        temp: N_STRING;
    BEGIN
        IF s'Last /= 0 THEN
            c := s(s'First);
            WHILE c = ' ' LOOP
                IF index = s'Length THEN
                    RETURN "";
                ELSE
                    index := index + 1;
                    c := s(index);
                END IF;
            END LOOP;
            temp := new String(1..s'Last-index+1);
            FOR i in 1..temp.All'Length LOOP
                temp.All(i) := s(i+index-1);
            END LOOP;
            RETURN removeSpaces(temp.All, temp.All'Length);
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