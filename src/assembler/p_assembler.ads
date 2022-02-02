WITH p_liste;
WITH object; use object;
--with Ada.Text_IO; use Ada.Text_IO;

package p_assembler is

    PACKAGE P_LISTE_VARIABLE IS NEW P_LISTE(T_ELEMENT => Variable, Image => Image_Variable);
    USE P_LISTE_VARIABLE;

    PROCEDURE AfficherL(line : String);

    PROCEDURE TraiterInstructions(debug: Boolean);

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

    Declared_Variables: P_LISTE_VARIABLE.T_LISTE;

PRIVATE

    label_map: P_LISTE_CLEFVALEUR.T_LISTE;

END p_assembler;