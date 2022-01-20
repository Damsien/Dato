with p_intermediate; use p_intermediate;
with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;

procedure test is

f1 : T_INTERMEDIAIRE;
f2 : T_INTERMEDIAIRE;
f3 : T_INTERMEDIAIRE;
f4 : T_INTERMEDIAIRE;

cp1 : Integer;
cp2 : Integer;
cp3 : Integer;
cp4 : Integer;


BEGIN

f1 := GetFile;
Inserer("Première ligne");
Inserer_L(" ||| Ajout en fin de ligne");
--Afficher;
cp1 := GetCP;
-- Put(cp1);

Inserer_L("Deuxième");
Afficher;
cp2 := GetCP;
-- Put(cp2);





end test;