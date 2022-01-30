WITH p_liste;
WITH object; USE object;

PACKAGE p_map IS

    PACKAGE P_LISTE_VARIABLE IS NEW P_LISTE(T_ELEMENT => Variable, Image => Image_Variable);
    USE P_LISTE_VARIABLE;

   -- TYPES
   TYPE T_CLEFVALEUR IS RECORD
        Clef: access String;
        Valeur: P_LISTE_CH_CHAR.T_LISTE;
   END RECORD;
   TYPE T_MAP_CELLULE;
   TYPE T_MAP IS ACCESS T_MAP_CELLULE;
   TYPE T_MAP_CELLULE IS RECORD
        Element : T_CLEFVALEUR;
        Suivant : T_MAP;
   END RECORD;

   not_found: Exception;

   -- FONCTIONS
    FUNCTION creerMapVide RETURN T_MAP;

    FUNCTION creerMap(clef: String ; valeur: P_LISTE_CH_CHAR.T_LISTE) RETURN T_MAP;

    FUNCTION estVideMap(l : IN T_MAP) RETURN Boolean;

    PROCEDURE insererEnTeteMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR)

    PROCEDURE afficherListeMap(l : IN T_MAP);

    FUNCTION rechercherMap(l : IN T_MAP ; s : IN String) RETURN T_MAP;

    PROCEDURE insererApresMap(l : IN T_MAP ; e : IN T_CLEFVALEUR ; data : IN T_CLEFVALEUR)

    PROCEDURE insererAvantMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR ; data : IN T_CLEFVALEUR)

    PROCEDURE enleverMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR)

    PROCEDURE ajouterMap(l: IN OUT T_MAP ; clef: String ; valeur: P_LISTE_CH_CHAR.T_LISTE);

    FUNCTION obtenirMap(l: IN T_MAP ; i: IN Integer) RETURN T_CLEFVALEUR;

    FUNCTION tailleMap(l: IN OUT T_MAP) RETURN Integer;

    PROCEDURE insererApresLigneMap(l : IN T_MAP ; ligne : Integer ; data : IN T_CLEFVALEUR);

END p_map;