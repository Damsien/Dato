with Ada.Text_IO; use Ada.Text_IO; 
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

PACKAGE BODY p_source IS

    TYPE N_STRING IS ACCESS String;
    source : T_SOURCE;

    FUNCTION TToString(el : T_String) RETURN String IS
        result : String(1..200);
        ch : Character;
    BEGIN
        for i IN 1..200 loop
            ch := el(i);
            result(i) := ch;
        end loop;
        RETURN result;
    END TToString;

    FUNCTION StringToT(el : String) RETURN T_String IS
        result : T_String;
        ch : Character;
    BEGIN
        for i IN 1..el'length loop
            ch := el(i);
            result(i) := ch;
        end loop;
        RETURN result;
    END StringToT;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String) IS
        Fichier: File_Type;
        instructionCourante: N_STRING;
    BEGIN
        source.instructions := creerListeVide;

        open(Fichier, In_File, Name => Nom_Fichier);
        WHILE End_Of_File(Fichier) = False LOOP
            instructionCourante := new String'(Get_Line(Fichier));
            Put(instructionCourante.All);
            ajouter(source.instructions, StringToT(instructionCourante.All));
        END LOOP;
        close(Fichier);

        --afficherListe(source.instructions);
    END chargerInstructions;


END p_source;