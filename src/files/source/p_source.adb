with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with op_string; use op_string;

PACKAGE BODY p_source IS

    TYPE N_STRING IS ACCESS String;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String) IS
        Fichier: File_Type;
        instructionCourante: N_STRING;
    BEGIN
        source.instructions := P_LISTE_CH_CHAR.creerListeVide;

        open(Fichier, In_File, Name => Nom_Fichier);
        WHILE End_Of_File(Fichier) = False LOOP
            instructionCourante := new String'(Get_Line(Fichier));
            --IF clarifyString(instructionCourante.All) /= "" THEN
            P_LISTE_CH_CHAR.ajouter(
                source.instructions, 
                StringToT(clarifyString(instructionCourante.All))
            );
            --ELSE
            --    NULL;
            --END IF;
        END LOOP;
        close(Fichier);

        --New_Line;
        --P_LISTE_CH_CHAR.afficherListe(source.instructions);
    END chargerInstructions;


END p_source;