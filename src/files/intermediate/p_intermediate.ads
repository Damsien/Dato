WITH p_liste;
WITH object; use object;

package p_intermediate is

    TYPE T_INTERMEDIAIRE IS
    RECORD
        instructions: P_LISTE_CH_CHAR.T_LISTE;
    END RECORD;
    
    PROCEDURE Inserer_L(instruction : IN String);

    PROCEDURE Inserer(instruction : IN String);

    PROCEDURE Inserer_Entete(instruction : IN String);

    Procedure Modifier(instruction : IN String ; ligne : IN Integer);

    Function GetCP RETURN Integer;

    Function GetFile RETURN T_INTERMEDIAIRE;

    Procedure Afficher;

    PROCEDURE Ecrire;

    FUNCTION RecupererNom(s : String) RETURN String;

    PROCEDURE setNom(fichier : String);

    CP_ENTETE : Integer := 0;


PRIVATE

    CP : Integer := 0;
    intermediaire : T_INTERMEDIAIRE;

    filename : access String;

end p_intermediate;
