with Ada.Text_IO; use Ada.Text_IO; 
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

PACKAGE BODY p_source IS

    source : T_SOURCE;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String) IS
        Fichier: File_Type;
        instructionCourante: Unbounded_String;
        instructionString: String(1..200);
        taille: Integer;
    BEGIN
        open(Fichier, In_File, Name => Nom_Fichier);
        source.instructions := creerListeVide;

        WHILE End_Of_File(Fichier) = False LOOP
            Get_Line(Fichier, instructionCourante, taille);
            instructionString := To_Strings(instructionCourante;
            ajouter(source.instructions, instructionString));
        END LOOP;

        close(Fichier);
    END chargerInstructions;


END p_source;