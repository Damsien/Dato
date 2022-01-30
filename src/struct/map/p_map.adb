with Ada.Text_IO; use Ada.Text_IO; 
WITH Ada.integer_text_io; USE Ada.integer_text_io;

PACKAGE BODY p_map IS

   -- FONCTIONS
    FUNCTION creerMapVide RETURN T_MAP IS
        l : T_MAP;
    BEGIN
        l := Null;
        RETURN l;
    END creerMapVide;

    FUNCTION creerMap(clef: String ; valeur: P_LISTE_CH_CHAR.T_LISTE) RETURN T_MAP IS
        l : T_MAP;
    BEGIN
        l := creerMapVide;
        l := ajouterMap(l, clef, valeur);
        RETURN l;
    END creerMap;

    FUNCTION estVideMap(l : IN T_MAP) RETURN Boolean IS
    BEGIN
        RETURN l = Null;
    END estVideMap;

    PROCEDURE insererEnTeteMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR) IS
        copie : T_MAP;
    BEGIN
        copie := new T_MAP_CELLULE'(e,l);
        l := copie;
    END insererEnTeteMap;

    PROCEDURE afficherListeMap(l : IN T_MAP) IS
    BEGIN
        IF l /= Null THEN
            Put(Image(l.All.Element));
            Put_Line("");
            afficherListeMap(l.All.Suivant);
        ELSE
            Null;
        END IF;
    END afficherListeMap;

    FUNCTION rechercherMap(l : IN T_MAP ; s : IN String) RETURN T_MAP IS
        liste : T_MAP := l;
    BEGIN
        WHILE liste /= Null AND THEN liste.All.Element.Clef.All /= s LOOP
            liste := liste.All.Suivant;
        END LOOP;
        
        RETURN liste;
    END rechercherMap;

    PROCEDURE insererApresMap(l : IN T_MAP ; e : IN T_CLEFVALEUR ; data : IN T_CLEFVALEUR) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_MAP := l;
    BEGIN
        IF Not p_map.estVide(l) THEN
            WHILE copie /= Null AND THEN copie.All.Element /= data LOOP
                copie := copie.All.Suivant;
            END LOOP;
            
            IF p_map.estVide(copie) THEN
                raise DataNonPresent;
            ELSE
                copie.All.Suivant := new T_MAP_CELLULE'(e,copie.All.Suivant);
            END IF;                
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererApresMap;

    PROCEDURE insererApresLigneMap(l : IN T_MAP ; ligne : Integer ; data : IN T_CLEFVALEUR) IS
    BEGIN
    NULL;
    END insererApresLigneMap;

    PROCEDURE insererAvantMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR ; data : IN T_CLEFVALEUR) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_MAP := l;
    BEGIN
        IF Not p_map.estVideMap(l) THEN
            IF l.All.Element = data THEN
                insererEnTeteMap(l,e);
            ELSE
                WHILE copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element /= data LOOP
                    copie := copie.All.Suivant;
                END LOOP;
                
                IF p_map.estVideMap(copie.All.Suivant) THEN
                    raise DataNonPresent;
                ELSE
                    copie.All.Suivant := new T_MAP_CELLULE'(e,copie.All.Suivant);
                END IF;            
            END IF;    
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererAvantMap;

    PROCEDURE enleverMap(l : IN OUT T_MAP ; e : IN T_CLEFVALEUR) IS
        copie : T_MAP := l;
    BEGIN
        IF Not p_map.estVide(l) THEN
            IF l.All.Element = e THEN
                l := l.All.Suivant;
            ELSE
                WHILE copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element /= e LOOP
                    copie := copie.All.Suivant;
                END LOOP;
            END IF;
            
            IF copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element = e THEN
                copie.All.Suivant := copie.All.Suivant.All.Suivant;
            ELSE
                Null;
            END IF;
        ELSE
            Null;
        END IF;
    END enleverMap;


    PROCEDURE ajouterMap(l: IN OUT T_MAP ; clef: String ; valeur: P_LISTE_CH_CHAR.T_LISTE) IS
        listeCourante: T_MAP := l;
        e: T_CLEFVALEUR;
    BEGIN
        IF listeCourante = NULL THEN
            l := new T_MAP_CELLULE'((clef, valeur), creerMapVide);
        ELSE
            WHILE listeCourante.All.Suivant /= NULL LOOP
                listeCourante := listeCourante.All.Suivant;
            END LOOP;
            listeCourante.All.Suivant := new T_MAP_CELLULE'((clef, valeur), creerMapVide);
        END IF;
    END ajouterMap;

    FUNCTION obtenirMap(l: IN T_MAP ; i: IN Integer) RETURN T_CLEFVALEUR IS
        stop : Boolean := False;
        index : Integer := 0;
        e: T_CLEFVALEUR;
        listeSuivante: T_MAP := l;
    BEGIN

        IF i >= taille(listeSuivante) THEN
            RAISE not_found;
        END IF;

        WHILE listeSuivante /= NULL AND NOT stop LOOP

            IF index = i THEN
                e := listeSuivante.All.Element;
                stop := True;
            END IF;

            listeSuivante := listeSuivante.All.Suivant;

            index := index + 1;

        END LOOP;

        RETURN e;
    END obtenirMap;


    FUNCTION tailleMap(l: IN OUT T_MAP) RETURN Integer IS
        counter: Integer := 0;
        listeCourante: T_MAP := l;
    BEGIN
        WHILE listeCourante /= NULL LOOP
            counter := counter + 1;
            listeCourante := listeCourante.All.Suivant;
        END LOOP;
    
        RETURN counter;
    END tailleMap;

END p_map;