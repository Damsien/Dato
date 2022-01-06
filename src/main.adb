WITH p_pile; 
WITH object; USE object;
with Ada.Text_IO; use Ada.Text_IO;


procedure main is

    type TQ is record
        Lx : Integer;
        Tx : Integer;
    end record;

    FUNCTION Image(element : IN TQ) RETURN String is
    begin
        return "L"&Integer'Image(element.Lx)&" , T"&Integer'Image(element.Tx);
    end Image;


    PACKAGE P_PILE_TQ IS NEW p_pile(T_ELEMENT => TQ, Image => Image);
    USE P_PILE_TQ;

    record1 : TQ := (1,2);
    pile_TQ : P_LISTE_ELEMENT.T_LISTE;

begin

    pile_TQ := initialisation;
    Empiler(pile_TQ,record1);
    Put(Image(sommet(pile_TQ)));


end main;