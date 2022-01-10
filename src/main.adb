WITH p_pile; 
WITH object; USE object;
WITH p_source; USE p_source;
with Ada.Text_IO; use Ada.Text_IO;


procedure main is

    PACKAGE P_PILE_TQ IS NEW p_pile(T_ELEMENT => TQ, Image => Image_TQ);
    USE P_PILE_TQ;

    record1 : TQ := (1,2);
    pile_TQ : P_LISTE_ELEMENT.T_LISTE;

begin

    pile_TQ := initialisation;
    Empiler(pile_TQ,record1);
    Put(Image_TQ(sommet(pile_TQ)));

    chargerInstructions("code.txt");



end main;