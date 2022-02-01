with p_compilateur; use p_compilateur;
with p_intermediate; use p_intermediate;
with p_source; use p_source;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure test2 IS
    source : T_SOURCE;
    file : access String;
    file_extension_exception: Exception;
BEGIN

source := p_source.source;


file := new String'("code.dato");
if Argument_Count >= 1 THEN
    file := new String'(Argument(1));
    IF Index(file.All, ".dato") /= file.All'Last-4 THEN
        RAISE file_extension_exception;
    END IF;
end if;

chargerInstructions(file.All);
p_compilateur.TraiterInstructions(p_source.source);
--p_intermediate.Afficher;
p_intermediate.TraiterInstructions;
EXCEPTION

WHEN file_extension_exception =>
    Put_Line("Le fichier doit avoir .dato comme extension");
    RAISE file_extension_exception;

WHEN E : others => 
                    New_Line;
                    Put_Line("----------");
                    --p_intermediate.Afficher;
                    raise;

end test2;