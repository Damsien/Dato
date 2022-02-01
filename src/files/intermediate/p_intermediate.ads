WITH p_liste;
WITH object; use object;

package p_intermediate is

    PACKAGE P_LISTE_VARIABLE IS NEW P_LISTE(T_ELEMENT => Variable, Image => Image_Variable);
    USE P_LISTE_VARIABLE;

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


    PROCEDURE AfficherL(line : String);


    PROCEDURE TraiterInstructions;

    PROCEDURE Traitement(inst: String ; line: P_LISTE_CH_CHAR.T_LISTE);

    PROCEDURE TraiterDeclarations(line : String);

    PROCEDURE TraiterAffectation(line : String);

    FUNCTION TraiterGOTO(listeCourante: P_LISTE_CH_CHAR.T_LISTE) RETURN P_LISTE_CH_CHAR.T_LISTE;

    FUNCTION VerifierCondition(condition: String) RETURN Boolean;

    PROCEDURE TraiterLabel(label: String ; line: P_LISTE_CH_CHAR.T_LISTE);

    FUNCTION AppliquerCondition(cond: String) RETURN Boolean;

    FUNCTION AppliquerOperation(op: String) RETURN Integer;

    FUNCTION IsVarExisting(val: String) RETURN P_LISTE_VARIABLE.T_LISTE;

    FUNCTION GetVarValue(val: String) RETURN Integer;

    

    CP_ENTETE : Integer := 0;

    Declared_Variables: P_LISTE_VARIABLE.T_LISTE;


PRIVATE

    CP : Integer := 0;
    intermediaire : T_INTERMEDIAIRE;

    label_map: P_LISTE_CLEFVALEUR.T_LISTE;

end p_intermediate;
