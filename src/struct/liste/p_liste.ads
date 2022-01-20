GENERIC
   TYPE T_ELEMENT IS PRIVATE;
   WITH FUNCTION Image(element : IN T_ELEMENT) RETURN String;
   
PACKAGE p_liste IS
   -- TYPES
   TYPE T_CELLULE;
   TYPE T_LISTE IS ACCESS T_CELLULE;
   TYPE T_CELLULE IS RECORD
        Element : T_ELEMENT;
        Suivant : T_LISTE;
   END RECORD;

   not_found: Exception;

   -- FONCTIONS
    FUNCTION creerListeVide RETURN T_LISTE
        WITH Post => estVide(creerListeVide'Result);

    FUNCTION estVide(l : IN T_LISTE) RETURN Boolean;

    PROCEDURE insererEnTete(l : IN OUT T_LISTE ; e : IN T_ELEMENT)
        WITH Post => rechercher(l,e) /= Null;

    PROCEDURE afficherListe(l : IN T_LISTE);

    FUNCTION rechercher(l : IN T_LISTE ; e : IN T_ELEMENT) RETURN T_LISTE;

    PROCEDURE insererApres(l : IN T_LISTE ; e : IN T_ELEMENT ; data : IN T_ELEMENT)
        WITH Post => rechercher(l,e) /= Null;

    PROCEDURE insererAvant(l : IN OUT T_LISTE ; e : IN T_ELEMENT ; data : IN T_ELEMENT)
        WITH Post => rechercher(l,e) /= Null;

    PROCEDURE enlever(l : IN OUT T_LISTE ; e : IN T_ELEMENT)
        WITH Post => rechercher(l,e) = Null;   

    PROCEDURE ajouter(l: IN OUT T_LISTE ; e: IN T_ELEMENT);

    FUNCTION obtenir(l: IN T_LISTE ; i: IN Integer) RETURN T_ELEMENT;

    PROCEDURE modifier(l: IN OUT T_LISTE ; i: IN Integer ; new_e: IN T_ELEMENT);

    FUNCTION taille(l: IN OUT T_LISTE) RETURN Integer;

END p_liste;