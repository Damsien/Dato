with Ada.Text_IO; use Ada.Text_IO; 
WITH Ada.integer_text_io; USE Ada.integer_text_io;

PACKAGE BODY p_liste IS

   -- FONCTIONS
    FUNCTION creerListeVide RETURN T_LISTE IS
        l : T_LISTE;
    BEGIN
        l := Null;
        RETURN l;
    END creerListeVide;

    FUNCTION estVide(l : IN T_LISTE) RETURN Boolean IS
    BEGIN
        RETURN l = Null;
    END estVide;

    PROCEDURE insererEnTete(l : IN OUT T_LISTE ; e : IN T_ELEMENT) IS
        copie : T_LISTE;
    BEGIN
        copie := new T_CELLULE'(e,l);
        l := copie;
    END insererEnTete;

    PROCEDURE afficherListe(l : IN T_LISTE) IS
    BEGIN
        IF l /= Null THEN
            Put(Image(l.All.Element));
            Put_Line("");
            afficherListe(l.All.Suivant);
        ELSE
            Null;
        END IF;
    END afficherListe;

    FUNCTION rechercher(l : IN T_LISTE ; e : IN T_ELEMENT) RETURN T_LISTE IS
        liste : T_LISTE := l;
    BEGIN
        WHILE liste /= Null AND THEN liste.All.Element /= e LOOP
            liste := liste.All.Suivant;
        END LOOP;
        
        RETURN liste;
    END rechercher;

    PROCEDURE insererApres(l : IN T_LISTE ; e : IN T_ELEMENT ; data : IN T_ELEMENT) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_LISTE := l;
    BEGIN
        IF Not p_liste.estVide(l) THEN
            WHILE copie /= Null AND THEN copie.All.Element /= data LOOP
                copie := copie.All.Suivant;
            END LOOP;
            
            IF p_liste.estVide(copie) THEN
                raise DataNonPresent;
            ELSE
                copie.All.Suivant := new T_CELLULE'(e,copie.All.Suivant);
            END IF;                
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererApres;

    PROCEDURE insererApresLigne(l : IN T_LISTE ; ligne : Integer ; data : IN T_ELEMENT) IS
    BEGIN
    NULL;
    END insererApresLigne;

    PROCEDURE insererAvant(l : IN OUT T_LISTE ; e : IN T_ELEMENT ; data : IN T_ELEMENT) IS
        ListeVide, DataNonPresent : Exception;
        copie : T_LISTE := l;
    BEGIN
        IF Not p_liste.estVide(l) THEN
            IF l.All.Element = data THEN
                insererEnTete(l,e);
            ELSE
                WHILE copie.All.Suivant /= Null AND THEN copie.All.Suivant.All.Element /= data LOOP
                    copie := copie.All.Suivant;
                END LOOP;
                
                IF p_liste.estVide(copie.All.Suivant) THEN
                    raise DataNonPresent;
                ELSE
                    copie.All.Suivant := new T_CELLULE'(e,copie.All.Suivant);
                END IF;            
            END IF;    
        ELSE
            raise ListeVide;
        END IF;
    EXCEPTION
        WHEN ListeVide => Put_Line("La liste vide");
        WHEN DataNonPresent => Put_Line("L'element recherche n'est pas present");
    END insererAvant;

    PROCEDURE enlever(l : IN OUT T_LISTE ; e : IN T_ELEMENT) IS
        copie : T_LISTE := l;
    BEGIN
        IF Not p_liste.estVide(l) THEN
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
    END;


    PROCEDURE ajouter(l: IN OUT T_LISTE ; e: IN T_ELEMENT) IS
        listeCourante: T_LISTE := l;
    BEGIN
        IF listeCourante = NULL THEN
            l := new T_CELLULE'(e, creerListeVide);
        ELSE
            WHILE listeCourante.All.Suivant /= NULL LOOP
                listeCourante := listeCourante.All.Suivant;
            END LOOP;
            listeCourante.All.Suivant := new T_CELLULE'(e, creerListeVide);
        END IF;
    END ajouter;

    FUNCTION obtenir(l: IN T_LISTE ; i: IN Integer) RETURN T_ELEMENT IS
        stop : Boolean := False;
        index : Integer := 0;
        e: T_ELEMENT;
        listeSuivante: T_LISTE := l;
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
    END obtenir;

    PROCEDURE modifier(l: IN OUT T_LISTE ; i: IN Integer ; new_e: IN T_ELEMENT) IS
        listeCourante : T_liste := l;
        listeSuivante: T_LISTE := l;
        test : access String := new String'("");
        index : Integer;
        stop : Boolean;
        tmp : String(1..Image(new_e)'length);
    BEGIN

        --Put_line("Ligne théorique bis : "&Image(new_e));
        tmp := Image(new_e);

        index := 0 ;

        IF i >= taille(listeSuivante) THEN
            RAISE not_found;
        END IF;

        IF I = 0 THEN
            l.All := (new_e,l.All.suivant);
            Put("");
        ELSE

            WHILE listeSuivante /= NULL AND NOT stop LOOP

            IF index = i THEN
                listeSuivante.All := (new_e,listeSuivante.All.Suivant);
                Put("");
                stop := True;
            END IF;

            listeCourante := listeSuivante;
            listeSuivante := listeSuivante.All.Suivant;

            index := index + 1;

        END LOOP;

        END IF;

        test := new String'(Image(listeCourante.All.Element));
        --Put_line("== Fin : "&Image(listeCourante.All.Element));


    END modifier;


    FUNCTION taille(l: IN T_LISTE) RETURN Integer IS
        counter: Integer := 0;
        listeCourante: T_LISTE := l;
    BEGIN
        WHILE listeCourante /= NULL LOOP
            counter := counter + 1;
            listeCourante := listeCourante.All.Suivant;
        END LOOP;
    
        RETURN counter;
    END taille;

    FUNCTION hasSuivant(l: IN T_LISTE) RETURN Boolean IS
    BEGIN
        RETURN (l.All.Suivant /= NULL);
    END;

    FUNCTION isNull(l: IN T_LISTE) RETURN Boolean IS
    BEGIN
        RETURN (l /= NULL);
    END;

    FUNCTION setEmpty(e : String) RETURN String IS
        s : String(1..1);
    BEGIN
        s(1) := ' ';
        RETURN s;
    END;

END p_liste;