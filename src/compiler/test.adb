with p_compilateur; use p_compilateur;
with p_intermediate; use p_intermediate;
with p_source; use p_source;
with Ada.Text_IO; use Ada.Text_IO;

procedure test IS
    source : T_SOURCE;
BEGIN

--Put(Character'Val(45));
source := p_source.source;
chargerInstructions("code.txt");
p_compilateur.TraiterInstructions(p_source.source);
p_intermediate.Afficher;

end test;