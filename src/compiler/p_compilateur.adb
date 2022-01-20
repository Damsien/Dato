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
    BEGIN
        CASE True IS
            WHEN inst.All.Element'Length = 0 => NULL;
            WHEN Index(inst.All.Element, "--") > 0 =>
                pos := Index(inst.All.Element, "--");
                Traitement(inst.All.Element(inst.All.Element'First..pos));
            WHEN clarifyString(inst.All.Element) = "" => NULL;
            WHEN Index(inst.All.Element, ":") => TraduireDeclaration(inst.All.Element);
            WHEN Index(inst.All.Element, "<-") => TraduireAffectation(inst.All.Element);
            WHEN Index(inst.All.Element, "Programe") => hasProgramStarded := True;
            WHEN Index(inst.All.Element, "Début") => hasProgramDebuted := True;
            WHEN Index(inst.All.Element, "Fin") =>
                hasProgramStarded := False;
                hasProgramDebuted := False;
            WHEN Index(inst.All.Element, "Tant que") => TraduireTantQue(inst.All.Element);
            WHEN Index(inst.All.Element, "Fin tant que") => TraduireFinTantQue;
            WHEN Index(inst.All.Element, "Si") => TraduireSi(inst.All.Element);
            WHEN Index(inst.All.Element, "Sinon") => TraduireSinon;
            WHEN Index(inst.All.Element, "Fin si") => TraduireFinSi;


            WHEN others => RAISE NotCompile;

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

    
    FUNCTION ValiderOperation(String op) RETURN Integer IS
        value1: String;
        value2: String;
        result: String;
        operation
    BEGIN
        CASE True IS
            WHEN Index(inst.All.Element, "+") > 0 =>
                value1 := op(op'First..Index(op, "+")-1);
                value2 := op(Index(op, "+")+1..op'Last);
                IF Index(value2, "+") > 0 OR Index(value2, "-") > 0
                 OR Index(value2, "/") > 0 OR Index(value2, "*") > 0 THEN

                ELSE

                END IF;



            WHEN others => RETURN op;

        END CASE;
    END ValiderOperation;


    PROCEDURE TraduireDeclaration(String line) IS
        intitule: String;
        typeV: String;
    BEGIN
        intitule := removeSingleSpace(line(line'First..IndexTraduireVariableCreation(line, ":")-1));
        typeV := removeSingleSpace(line(Index(line, ":")+1..line'Last));
        ajouter(Declared_Variables, new Variable'(intitule, NULL, typeV));
    END TraduireDeclaration;


    PROCEDURE TraduireAffectation(String line) IS
        intitule: String;
        value: Integer;
        listeCourante: P_LISTE_VARIABLE;
    BEGIN
        listeCourante := Declared_Variables;
        intitule := removeSingleSpaceline(line'First..Index(line, "<-")-1));
        value := ValiderOperation(removeSingleSpace(line(Index(line, "<-")+1..line'Last)));
        WHILE listeCourante.All.Element.intitule /= intitule LOOP
            listeCourante := listeCourante.All.Suivant;
        END LOOP;
        IF listeCourante.All.Element.typeV = "booleen"
         AND listeCourante.All.Element.value /= 1
         AND listeCourante.All.Element.value /= 0 THEN
            RAISE WrongType;
        ELSE
            listeCourante.All.Element.value := value;
        END IF;
    EXCEPTION
        WHEN Constraint_Error => Put_Line("Variable non déclarée");
        WHEN WrongType => Put_Line("Impossible d'affecter cette valeur a ce type de variable");
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