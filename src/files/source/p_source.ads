WITH p_liste;
WITH object; use object;

PACKAGE p_source IS

    TYPE T_SOURCE IS
    RECORD
        instructions: P_LISTE_CH_CHAR.T_LISTE;
    END RECORD;

    PROCEDURE chargerInstructions(Nom_Fichier : IN String);

    source : T_SOURCE;


END p_source;