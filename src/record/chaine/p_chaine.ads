PACKAGE p_chaine IS

    TYPE T_LISTE_CHCARAC IS PRIVATE;

    FUNCTION creerListeVide RETURN T_LISTE_CHCARAC;

    FUNCTION estVide(l: IN OUT T_LISTE_CHCARAC) RETURN Boolean;

    PROCEDURE insererEnTete(l: IN OUT T_LISTE_CHCARAC; e: IN String);

    PROCEDURE ajouter(l: IN OUT T_LISTE_CHCARAC ; e: IN String);

    PROCEDURE afficherListe(l: IN T_LISTE_CHCARAC);

    FUNCTION rechercher(l: IN T_LISTE_CHCARAC ; e: IN String) RETURN T_LISTE_CHCARAC;

    PROCEDURE insererApres(l: IN T_LISTE_CHCARAC ; e: IN String ; data: IN String);

    PROCEDURE insererAvant(l: IN OUT T_LISTE_CHCARAC ; e: IN String ; data: IN String);

    PROCEDURE enlever(l: IN OUT T_LISTE_CHCARAC ; e: IN String);

PRIVATE
    TYPE T_CELLULE_CHCARAC;
    TYPE T_LISTE_CHCARAC IS ACCESS T_CELLULE_CHCARAC;
    TYPE T_CELLULE_CHCARAC IS RECORD
        Element : String(1..100);
        Suivant : T_LISTE_CHCARAC;
    END RECORD;
END p_chaine;