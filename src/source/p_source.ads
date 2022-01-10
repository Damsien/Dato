WITH p_chaine; USE p_chaine;

PACKAGE p_source IS
    
    PROCEDURE chargerInstructions(Nom_Fichier : IN String);


PRIVATE

    TYPE T_SOURCE IS
    RECORD
        instructions: T_LISTE_CHCARAC;
    END RECORD;

END p_source;