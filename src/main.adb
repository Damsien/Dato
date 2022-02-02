-- Main program
with p_compilateur; use p_compilateur;
with p_assembler; use p_assembler;

-- Files
with p_intermediate; use p_intermediate;
with p_source; use p_source;

-- Record
with object; use object;

-- String Operation
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Main IS
    source : T_SOURCE;
    file : access String;
    filename : access String;
    file_extension_exception: Exception;
    ecrireIntermediaire : Boolean := false;
    afficherDebug : Boolean := false;
    findExisting : Boolean := false;
    too_much_argument: Exception;
BEGIN

source := p_source.source;


file := new String'("code.dato");
if Argument_Count >= 1 THEN

    for i in 1..Argument_Count LOOP

        IF Argument(i) = "-I" THEN
            ecrireIntermediaire := True;
        ELSIF Argument(i) = "-D" THEN
            afficherDebug := True;
        ELSE
            IF NOT findExisting THEN
                file := new String'(Argument(i));
                findExisting := True;
                IF Index(file.All, ".dato") /= file.All'Last-4 THEN
                    RAISE file_extension_exception;
                END IF;
            ELSE
                RAISE too_much_argument;
            END IF;

        END IF;

    END LOOP;
    
end if;

chargerInstructions(file.All);
p_compilateur.TraiterInstructions(p_source.source);

IF ecrireIntermediaire THEN
    filename := new String'(p_intermediate.RecupererNom(file.All));
    p_intermediate.setNom(filename.All);
    p_intermediate.Ecrire;
END IF;

p_assembler.TraiterInstructions(afficherDebug);

EXCEPTION

    WHEN too_much_argument =>
        Put_Line("La commande contient trop d'arguments");
        RAISE too_much_argument;

    WHEN file_extension_exception =>
        Put_Line("Le fichier doit avoir .dato comme extension");
        RAISE file_extension_exception;

    WHEN E : others => 
        raise;

end Main;