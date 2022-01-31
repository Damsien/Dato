-- Module définissant une pile d'entiers et les opérateurs à partir du type T_LISTE

with Ada.Text_IO; use Ada.Text_IO; 

PACKAGE BODY p_pile IS

    FUNCTION initialisation RETURN T_LISTE IS
    BEGIN
        RETURN Null;
    END initialisation;

    PROCEDURE Empiler(pile : IN OUT T_LISTE ; element : IN T_ELEMENT) IS
    BEGIN
        insererEnTete(pile, element);
    END Empiler;

    FUNCTION Depiler(pile : IN OUT T_LISTE) RETURN T_ELEMENT IS
        temp : T_ELEMENT;
    BEGIN
        IF p_pile.estPileVide(pile) THEN
            RAISE PileVide;
        ELSE
            temp := sommet(pile);
            enlever(pile, temp);
            RETURN temp;
        END IF;
    END Depiler;

    FUNCTION estPileVide(pile : IN T_LISTE) RETURN Boolean IS
    BEGIN
        RETURN (pile = Null);
    END estPileVide;

    FUNCTION sommet(pile : IN T_LISTE) RETURN T_ELEMENT IS
    BEGIN
        IF p_pile.estPileVide(pile) THEN
            RAISE PileVide;
        ELSE
            RETURN pile.All.Element;
        END IF;
    END sommet;
END p_pile;