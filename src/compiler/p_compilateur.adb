WITH p_source; USE p_source;
WITH object; USE object;
with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
WITH p_intermediate; USE p_intermediate;
WITH object; USE object;

PACKAGE BODY p_compilateur IS

    FUNCTION VToString(el : Variable) RETURN String IS
    BEGIN
        RETURN el.Intitule.All;
    END VToString;

    FUNCTION TQToString(el : TQ) RETURN String IS
    BEGIN
        RETURN Integer'Image(el.Tx);
    END TQToString;



    PROCEDURE Traitement(inst : String) IS
        pos: Integer;
    BEGIN
        IF inst'Length = 0 THEN
            NULL;
        ELSIF Index(inst, "--") > 0 THEN
            pos := Index(inst, "--");
            Traitement(inst(inst'First..pos));
        ELSIF clarifyString(inst) = "" THEN
            NULL;
        ELSIF Index(inst, ":") > 0 THEN
            TraduireDeclaration(inst);
        ELSIF Index(inst, "<-") > 0 THEN
            TraduireAffectation(inst);
        ELSIF Index(inst, "Programe") > 0 THEN
            hasProgramStarded := True;
        ELSIF Index(inst, "Début") > 0 THEN
            hasProgramDebuted := True;
        ELSIF Index(inst, "Fin") > 0 THEN
            hasProgramStarded := False;
            hasProgramDebuted := False;
        ELSIF Index(inst, "Tant que") > 0 THEN
            TraduireTantQue(inst);
        ELSIF Index(inst, "Fin tant que") > 0 THEN
            TraduireFinTantQue;
        ELSIF Index(inst, "Si") > 0 THEN
            TraduireSi(inst);
        ELSIF Index(inst, "Sinon") > 0 THEN
            TraduireSinon;
        ELSIF Index(inst, "Fin si") > 0 THEN
            TraduireFinSi;
        ELSE
            RAISE NotCompile;
        END IF;
    EXCEPTION
        WHEN NotCompile =>
            Put_Line("Erreur de compilation a la ligne : ");
            Put(CP_COMPIL, 1);
    END Traitement;


    PROCEDURE TraiterInstructions(instructions : T_SOURCE ) IS
        inst: object.P_LISTE_CH_CHAR.T_LISTE;
    BEGIN
        inst := instructions.instructions;
        WHILE inst.All.Element /= NULL LOOP
            Traitement(inst.All.Element.All);
            CP_COMPIL := CP_COMPIL + 1;
            inst := inst.All.Suivant;
        END LOOP;

    END TraiterInstructions;



    FUNCTION CreerLabel RETURN Integer IS
    BEGIN
        LABEL_USED := LABEL_USED + 1;
        RETURN LABEL_USED;
    END CreerLabel;


    FUNCTION VerifierCondition(condition : String) RETURN Integer IS
    BEGIN
    RETURN 0;
    END VerifierCondition;


    FUNCTION CheckValue(val : String) RETURN String IS
        value: Integer;
        listeCourante: P_LISTE_VARIABLE.T_LISTE;
        variable_error: Exception;
    BEGIN
        value := Integer'Value(val);
        RETURN val;
    EXCEPTION
        WHEN others =>
            BEGIN
                listeCourante := Declared_Variables;
                WHILE listeCourante.All.Suivant /= NULL AND listeCourante.All.Element.intitule.All /= val LOOP
                    listeCourante := listeCourante.All.Suivant;
                END LOOP;
                IF val = listeCourante.All.Element.intitule.All THEN
                    RETURN val;
                ELSE
                    RAISE variable_error;
                END IF;
            EXCEPTION
                WHEN variable_error =>
                    Put_Line("Ligne ");
                    Put(CP_COMPIL, 1);
                    Put(" - La variable n'existe pas");
                    RETURN ""; -- TODO : Attention si tu handle une exception, c'est comme un try/catch... 
                              -- Tu dois retourner un élément (ou tu laisses la fonction au dessus la gérer)
            END;
    END CheckValue;

    
    FUNCTION ValiderOperation(op : String) RETURN String IS
        value1: access String;
        value2: access String;
        operation_error: Exception;
    BEGIN
        IF Index(op, "+") > 0 THEN
            value1 := new String'(CheckValue(op(op'First..Index(op, "+")-1)));
            value2 := new String'(CheckValue(op(Index(op, "+")+1..op'Last)));
        ELSIF Index(op, "-") > 0 THEN
            value1 := new String'(CheckValue(op(op'First..Index(op, "-")-1)));
            value2 := new String'(CheckValue(op(Index(op, "-")+1..op'Last)));
        ELSIF Index(op, "*") > 0 THEN
            value1 := new String'(CheckValue(op(op'First..Index(op, "*")-1)));
            value2 := new String'(CheckValue(op(Index(op, "*")+1..op'Last)));
        ELSIF Index(op, "/") > 0 THEN
            value1 := new String'(CheckValue(op(op'First..Index(op, "/")-1)));
            value2 := new String'(CheckValue(op(Index(op, "/")+1..op'Last)));

        ELSE RETURN op;

        END IF;

        IF Index(value2.All, "+") > 0 OR Index(value2.All, "-") > 0
         OR Index(value2.All, "/") > 0 OR Index(value2.All, "*") > 0 THEN
            RAISE operation_error;
        ELSE
            RETURN op;
        END IF;

    EXCEPTION
        WHEN operation_error =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - This language can't handle more than one operation a line");
            RETURN ""; -- TODO: Même problème que tout à l'heure..
    END ValiderOperation;


    PROCEDURE TraduireDeclaration(line : String) IS
        intitule: access String;
        typeV: access String;
        program_error: Exception;
    BEGIN
        IF hasProgramStarded AND Not hasProgramDebuted THEN
            intitule := new String'(removeSingleSpace(line(line'First..Index(line, ":")-1)));
            typeV := new String'(removeSingleSpace(line(Index(line, ":")+1..line'Last)));
            ajouter(Declared_Variables, Variable'(intitule, 0, typeV.All));
        ELSE
            RAISE program_error;
        END IF;
        EXCEPTION
            WHEN program_error =>
                Put_Line("Ligne ");
                Put(CP_COMPIL, 1);
                Put(" - Le programme n'a pas commencé ou a déjà débuté");
    END TraduireDeclaration;


    PROCEDURE TraduireAffectation(line : String) IS
        intitule: access String;
        value: Integer;
        listeCourante: P_LISTE_VARIABLE.T_LISTE; -- LISTE DE VARIABLES
    BEGIN
        listeCourante := Declared_Variables;
        intitule := new String'(removeSingleSpace(line'First..Index(line, "<-")-1));
        -- Inserer_L = ValiderOperation(removeSingleSpace(line(Index(line, "<-")+1..line'Last)));
        --value := ValiderOperation(removeSingleSpace(line(Index(line, "<-")+1..line'Last)));
        WHILE listeCourante.All.Element.intitule.All /= intitule.All LOOP
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
        WHEN Constraint_Error =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Variable non déclarée");
        WHEN WrongType =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Impossible d'affecter cette valeur a ce type de variable");
    END TraduireAffectation;


    PROCEDURE TraduireTantQue(line : String) IS
        Tx : Integer;
        Lx, Ly, Lz : Integer;
    BEGIN
        Tx := VerifierCondition(line);
        Lx := CreerLabel;
        Ly := CreerLabel;
        Lz := CreerLabel;
        Inserer_L("L"&Integer'Image(Lx)&" IF T"&Integer'Image(Tx)&" GOTO L"&Integer'Image(Lz));
        Inserer_L("GOTO L"&Integer'Image(Ly));
        Inserer("L"&Integer'Image(Lz));
        
        Empiler(Pile_TQ,TQ'(Lx,Tx,new String'(line)));
    END TraduireTantQue;


    PROCEDURE TraduireFinTantQue IS
        rec : TQ;
        temp : Integer;
    BEGIN
        rec := Depiler(Pile_TQ);
        temp := VerifierCondition(rec.line.All);
        Inserer_L("GOTO L"&Integer'Image(rec.Lx));
        Inserer_L(Integer'Image(rec.Lx + 1) & " NULL");
    END TraduireFinTantQue;


    PROCEDURE TraduireSi(line : String) IS
    BEGIN
        NULL;
    END TraduireSi;


    PROCEDURE TraduireSinon IS
    BEGIN
        NULL;
    END TraduireSinon;


    PROCEDURE TraduireFinSi IS
    BEGIN
        NULL;
    END TraduireFinSi;


END p_compilateur;