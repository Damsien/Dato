WITH p_source; USE p_source;

PACKAGE BODY p_compilateur IS

    FUNCTION VToString(el : Variable) RETURN String IS
    BEGIN
        RETURN el.Intitule;
    END TToString;

    FUNCTION TQToString(el : Variable) RETURN String IS
    BEGIN
        RETURN el.Tx;
    END TToString;



    PROCEDURE Traitement(String instruction) IS
    BEGIN
        
    END Traitement;


    PROCEDURE TraiterInstructions(P_LISTE_CH_CHAR instructions) IS
        inst: P_LISTE_CH_CHAR := l;
    BEGIN
        WHILE inst.All.Element /= NULL LOOP
            LOOP

                CASE inst.All.Element IS
                    WHEN "" => ;



                    
                END CASE;


            END LOOP;
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