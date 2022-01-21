WITH p_liste;
GENERIC
   TYPE T_ELEMENT IS PRIVATE;
   WITH FUNCTION Image(element : IN T_ELEMENT) RETURN String;

-- Module spécifiant une pile d'entiers et les opérateurs à partir du type T_LISTE
PACKAGE p_pile IS
    PACKAGE P_LISTE_ELEMENT IS NEW P_LISTE(T_ELEMENT => T_ELEMENT, Image => Image);
    USE P_LISTE_ELEMENT;

    TYPE T_LISTE IS NEW P_LISTE_ELEMENT.T_LISTE;

    PileVide : EXCEPTION;
    
    -- nom : Initialisation
    -- sémantique : initialiser la pile afin de pouvoir l'utiliser
    -- pré-conditions : /
    -- post-conditions : estVide(pile)
    FUNCTION initialisation RETURN T_LISTE
        WITH Post => estVide(initialisation'Result);

    -- nom : Empiler
    -- sémantique : Ajouter un élément au sommet de la pile
    -- pré-conditions : /
    -- post-conditions : sommet(pile') = element
    PROCEDURE Empiler(pile : IN OUT T_LISTE ; element : IN T_ELEMENT)
        WITH Post => sommet(pile) = element;

    -- nom : Dépiler
    -- sémantique : Retirer l'élément au sommet de la pile
    -- pré-conditions : Not estVide(pile)
    -- post-conditions : /
    FUNCTION Depiler(pile : IN OUT T_LISTE) RETURN T_ELEMENT;

    -- nom : estVide
    -- sémantique : Renvoi un booléen indiquant si la pile est vide
    -- pré-conditions : /
    -- post-conditions : /
    FUNCTION estVide(pile : IN T_LISTE) RETURN Boolean;

    -- nom : sommet
    -- sémantique : Renvoi la valeur de l'élément au sommet de la pile
    -- pré-conditions : Not estVide(pile)
    -- post-conditions : /
    FUNCTION sommet(pile : IN T_LISTE) RETURN T_ELEMENT;
    
END p_pile;