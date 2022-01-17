WITH p_source; USE p_source;

PACKAGE BODY p_compilateur IS

    CP_COMPIL := 0;
    hasProgramStarded := False;
    hasProgramDebuted := False;

    FUNCTION VToString(el : Variable) RETURN String IS
    BEGIN
        RETURN el.Intitule;
    END TToString;

    FUNCTION TQToString(el : Variable) RETURN String IS
    BEGIN
        RETURN el.Tx;
    END TToString;



    PROCEDURE Traitement(String instruction) IS
        pos: Integer;
        NotCompile : Exception;
    BEGIN
        CASE True IS
            WHEN Index(inst.All.Element, "--") > 0 =>
                pos := Index(inst.All.Element, "--");
                Traitement(inst.All.Element(inst.All.Element'First..pos));
            WHEN clarifyString(inst.All.Element) = "" => NULL;
            WHEN Index(inst.All.Element, "<-") => TraduireAffectation(inst.All.Element);
            WHEN Index(inst.All.Element, "Programe") => hasProgramStarded := True;
            WHEN Index(inst.All.Element, "Début") => hasProgramDebuted := True;
            WHEN Index(inst.All.Element, "Fin") =>
                hasProgramStarded := False;
                hasProgramDebuted := False;


            WHEN others => NotCompile;

        END CASE;
    EXCEPTION
        WHEN NotCompile =>
            Put_Line("Erreur de compilation a la ligne : ");
            Put(CP_COMPIL, 1);
    END Traitement;


    PROCEDURE TraiterInstructions(P_LISTE_CH_CHAR instructions) IS
        inst: P_LISTE_CH_CHAR := l;
    BEGIN
        WHILE inst.All.Element /= NULL LOOP
            Traitement(inst.All.Element);
            CP_COMPIL := CP_COMPIL + 1;
            inst.All.Element := inst.All.Suivant;
        END LOOP;

    END TraiterInstructions;



    FUNCTION CreerLabel RETURN Integer IS
    BEGIN

    END CreerLabel;


    FUNCTION VerifierCondition(String condition) RETURN Integer IS
    BEGIN

    END VerifierCondition;

    
    PROCEDURE ValiderOperation(String op) IS
    BEGIN

    END ValiderOperation;


    PROCEDURE TraduireAffectation(String line) IS
    BEGIN

    END TraduireAffectation;


    PROCEDURE TraduireTantQue(String line) IS
    BEGIN

    END TraduireTantQue;


    PROCEDURE TraduireFinTantQue IS
    BEGIN

    END TraduireTantQue;


    PROCEDURE TraduireSi(String line) IS
    BEGIN

    END TraduireSi;


    PROCEDURE TraduireSinon IS
    BEGIN

    END TraduireSinon;


    PROCEDURE TraduireFinSi IS
    BEGIN

    END TraduireFinSi;


END p_compilateur;