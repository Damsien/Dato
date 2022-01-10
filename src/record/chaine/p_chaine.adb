with Ada.Text_IO; use Ada.Text_IO;

PACKAGE BODY p_chaine IS
  
   -- FONCTIONS
    FUNCTION creerListeVide RETURN T_LISTE_CHCARAC IS
        l : T_LISTE_CHCARAC;
    BEGIN
        l := Null;
        RETURN l;
    END creerListeVide;

    FUNCTION estVide(l : IN OUT T_LISTE_CHCARAC) RETURN Boolean IS
    BEGIN
        RETURN l = Null;
    END estVide;

    PROCEDURE insererEnTete(l : IN OUT T_LISTE_CHCARAC ; e : IN String) IS
        copie : T_LISTE_CHCARAC;
    BEGIN
        copie := new T_CELLULE_CHCARAC'(e,l);
        l := copie;
    END insererEnTete;

    PROCEDURE ajouter(l: IN OUT T_LISTE_CHCARAC ; e: IN String) IS
        listeCourante: T_LISTE_CHCARAC;
    BEGIN
        listeCourante := l;
        WHILE listeCourante /= NULL LOOP
            listeCourante := listeCourante.All.Suivant;
        END LOOP;
        listeCourante.All.Suivant := creerListeVide;
        listeCourante.All.Suivant.All.Element := e;
    END ajouter;

    PROCEDURE afficherListe(l : IN T_LISTE_CHCARAC) IS
    BEGIN
        IF l /= Null THEN
            Put(l.All.Element);
            Put_Line("");
            afficherListe(l.All.Suivant);
        ELSE
            Null;
        END IF;
    END afficherListe;

    FUNCTION rechercher(l : IN T_LISTE_CHCARAC ; e : IN String) RETURN T_LISTE_CHCARAC IS
        liste : T_LISTE_CHCARAC := l;
    BEGIN
        WHILE liste /= Null AND THEN liste.All.Element /= e LOOP
            liste := liste.All.Suivant;
        END LOOP;
        
        RETURN liste;
    END rechercher;

    PROCEDURE insererApres(l : IN T_LISTE_CHCARAC ; e : IN String ; data : IN String) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_LISTE_CHCARAC := l;
    BEGIN
        IF Not estVide(copie) THEN
            WHILE copie /= Null AND THEN copie.All.Element /= data LOOP
                copie := copie.All.Suivant;
            END LOOP;
            
            IF estVide(copie) THEN
                raise DataNonPresent;
            ELSE
                copie.All.Suivant := new T_CELLULE_CHCARAC'(e,copie.All.Suivant);
            END IF;                
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererApres;

    PROCEDURE insererAvant(l : IN OUT T_LISTE_CHCARAC ; e : IN String ; data : IN String) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_LISTE_CHCARAC := l;
    BEGIN
        IF Not estVide(l) THEN
            IF l.All.Element = data THEN
                insererEnTete(l,e);
            ELSE
                WHILE copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element /= data LOOP
                    copie := copie.All.Suivant;
                END LOOP;
                
                IF estVide(copie.All.Suivant) THEN
                    raise DataNonPresent;
                ELSE
                    copie.All.Suivant := new T_CELLULE_CHCARAC'(e,copie.All.Suivant);
                END IF;            
            END IF;    
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererAvant;

    PROCEDURE enlever(l : IN OUT T_LISTE_CHCARAC ; e : IN String) IS
        copie : T_LISTE_CHCARAC := l;
    BEGIN
        IF Not estVide(l) THEN
            IF l.All.Element = e THEN
                l := l.All.Suivant;
            ELSE
                WHILE copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element /= e LOOP
                    copie := copie.All.Suivant;
                END LOOP;
            END IF;
            
            IF copie.All.Suivant.Element = e THEN
                copie.All.Suivant := copie.All.Suivant.All.Suivant;
            ELSE
                Null;
            END IF;
        ELSE
            Null;
        END IF;
    END;

    liste : T_LISTE_CHCARAC;
END p_chaine;