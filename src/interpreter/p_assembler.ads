WITH p_liste;
WITH object; use object;

package p_assembler is

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

    FUNCTION RechercherMap(liste : P_LISTE_CLEFVALEUR.T_LISTE ; label : String) RETURN P_LISTE_CLEFVALEUR.T_LISTE;

PRIVATE

    label_map: P_LISTE_CLEFVALEUR.T_LISTE;

END assembler;