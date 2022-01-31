WITH p_liste;
WITH p_pile;
WITH p_source; USE p_source;
WITH object; USE object;

PACKAGE p_compilateur IS


    PACKAGE P_PILE_INT IS NEW P_PILE(T_ELEMENT => Integer, Image => Integer'Image);
    USE P_PILE_INT;

    PACKAGE P_PILE_SI IS NEW P_PILE(T_ELEMENT => SI, Image => Image_SI);
    USE P_PILE_SI;

    PACKAGE P_PILE_TQ IS NEW P_PILE(T_ELEMENT => TQ, Image => Image_TQ);
    USE P_PILE_TQ;

    PACKAGE P_LISTE_VARIABLE IS NEW P_LISTE(T_ELEMENT => Variable, Image => Image_Variable);
    USE P_LISTE_VARIABLE;

    FUNCTION CreerLabel RETURN Integer;

    FUNCTION VerifierCondition(condition : String) RETURN Integer;

    FUNCTION VarToValue(value: String) RETURN Integer;

    FUNCTION IntToBool(val: String) RETURN String;

    FUNCTION BoolToInt(val: String) RETURN String;

    FUNCTION CheckVarType(key : String ; value : String) RETURN String;

    FUNCTION CheckVarExistence(val : String) RETURN String;

    PROCEDURE FormaliserOperation(op : IN String ; value1 : IN OUT T_String ; value2 : IN OUT T_String);

    FUNCTION ValiderOperation(op : String) RETURN Integer;

    PROCEDURE Traitement(inst : String);

    PROCEDURE TraiterInstructions(instructions : T_SOURCE);

    PROCEDURE TraduireDeclaration(line : String);

    PROCEDURE TraduireAffectation(line : String);

    PROCEDURE TraduireTantQue(line : String);

    PROCEDURE TraduireFinTantQue;

    PROCEDURE TraduireSi(line : String);

    PROCEDURE TraduireSinon;

    PROCEDURE TraduireFinSi;

    FUNCTION VToString(el : Variable) RETURN String;

    FUNCTION TQToString(el : TQ) RETURN String;

    PROCEDURE DeclarerVariable;
    

   NotCompile: Exception;
   WrongType: Exception;


    CP_COMPIL: Integer := 1;
    LABEL_USED: Integer := 0;
    TEMP_USED: Integer := 0;
    Declared_Variables: P_LISTE_VARIABLE.T_LISTE;
    hasProgramStarded: Boolean := False;
    hasProgramEnded: Boolean := False;
    hasProgramDebuted: Boolean := False;
    Pile_TQ: P_PILE_TQ.T_LISTE;
    Pile_SI: P_PILE_SI.T_LISTE;

PRIVATE

    FUNCTION TrimI(e : Integer) RETURN String;

    --TYPE T_COMPILATEUR IS
    --RECORD
    --END RECORD;

END p_compilateur;