WITH p_liste;
WITH p_pile;

PACKAGE p_compilateur IS
    
    FUNCTION CreerLabel RETURN Integer;

    FUNCTION VerifierCondition(String condition) RETURN Integer;

    PROCEDURE ValiderOperation(String op);


    PROCEDURE TraiterInstructions(T_LISTE instructions);


    PROCEDURE TraduireAffectation(String line);

    PROCEDURE TraduireTantQue(String line);

    PROCEDURE TraduireFinTantQue;

    PROCEDURE TraduireSi(String line);

    PROCEDURE TraduireSinon;

    PROCEDURE TraduireFinSi;


    FUNCTION VToString(el : Variable) RETURN String;
    PACKAGE P_LISTE_VARIABLE IS NEW P_LISTE(T_ELEMENT => Variable, Image => VToString);
    USE P_LISTE_VARIABLE;

    FUNCTION TQToString(el : TQ) RETURN String;
    PACKAGE P_PILE_TQ IS NEW P_PILE(T_ELEMENT => TQ, Image => TQToString);
    USE P_PILE_TQ;

    PACKAGE P_PILE_INT IS NEW P_PILE(T_ELEMENT => Integer, Image => Integer'Image);
    USE P_PILE_INT;

PRIVATE

    TYPE T_COMPILATEUR IS
    RECORD
        CP: Integer;
        LABEL_USED: Integer;
        Declared_Variables: P_LISTE_VARIABLE;
        hasProgramStarded: Boolean;
        hasProgramDebuted: Boolean;
        TQ: P_PILE_TQ;
        CP_SI: P_PILE_INT;
    END RECORD;

END p_compilateur;