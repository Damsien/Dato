WITH p_source; USE p_source;
WITH object; USE object;
with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
WITH p_intermediate; USE p_intermediate;

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
        Put_Line(inst);
        IF inst'Length = 0 THEN
            NULL;
        ELSIF Index(inst, "--") > 0 THEN
            pos := Index(inst, "--");
            Traitement(inst(inst'First..pos-1));
        ELSIF clarifyString(inst) = "" THEN
            NULL;
        ELSIF Index(inst, ":") > 0 THEN
            TraduireDeclaration(inst);
        ELSIF Index(inst, "<-") > 0 THEN
            TraduireAffectation(inst);
        ELSIF Index(inst, "Programme") > 0 THEN
            hasProgramStarded := True;
        ELSIF Index(inst, "Debut") > 0 THEN
            hasProgramDebuted := True;
        ELSIF Index(inst, "Fin") > 0 THEN
            IF Index(inst, "Fin si") = 0 OR Index(inst, "Fin tant que") = 0 THEN
                hasProgramStarded := False;
                hasProgramDebuted := False;
            END IF;
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
            New_Line;
            RAISE NotCompile;
    END Traitement;


    PROCEDURE TraiterInstructions(instructions : T_SOURCE) IS
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

    FUNCTION CreerVariableTemporaire RETURN Integer IS
    BEGIN
        TEMP_USED := TEMP_USED + 1;
        RETURN TEMP_USED;
    END CreerVariableTemporaire;


    FUNCTION VerifierCondition(condition : String) RETURN Integer IS
        value1: access String;
        value2: access String;
        condition_error: Exception;
        Tx : Integer;
    BEGIN
        Tx := TEMP_USED;
        IF Index(condition, ">=") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, ">=")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, ">=")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&value1.All&" > "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&value1.All&" = "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- T"&Integer'Image(Tx-2)&" OR T"&Integer'Image(Tx-1));
        ELSIF Index(condition, "<=") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, "<=")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, "<=")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&value1.All&" < "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&value1.All&" = "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- T"&Integer'Image(Tx-2)&" OR T"&Integer'Image(Tx-1));
        ELSIF Index(condition, ">") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, ">")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, ">")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&condition);
        ELSIF Index(condition, "<") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, "<")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, "<")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&condition);
        ELSIF Index(condition, "==") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, "==")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, "==")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&condition);
        ELSIF Index(condition, "!=") > 0 THEN
            value1 := new String'(CheckVarExistence(condition(condition'First..Index(condition, "!=")-1)));
            value2 := new String'(CheckVarExistence(condition(Index(condition, "!=")+1..condition'Last)));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&Integer'Image(Tx)&" <- "&condition);

        ELSE RETURN Tx;


        END IF;

        IF Index(value2.All, ">") > 0 OR Index(value2.All, ">=") > 0
         OR Index(value2.All, "<=") > 0 OR Index(value2.All, "<") > 0
         OR Index(value2.All, "==") > 0 OR Index(value2.All, "!=") > 0 THEN
            RAISE condition_error;
        ELSE
            RETURN Tx;
        END IF;

    EXCEPTION
        WHEN condition_error =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - This language can't handle more than one condition a line");
            New_Line;
            RAISE condition_error;
    END VerifierCondition;


    
    FUNCTION ValiderOperation(op : String) RETURN String IS
        value1: access String;
        value2: access String;
        operation_error: Exception;
    BEGIN
        IF Index(op, "+") > 0 THEN
            value1 := new String'(CheckVarExistence(op(op'First..Index(op, "+")-1)));
            value2 := new String'(CheckVarExistence(op(Index(op, "+")+1..op'Last)));
        ELSIF Index(op, "-") > 0 THEN
            value1 := new String'(CheckVarExistence(op(op'First..Index(op, "-")-1)));
            value2 := new String'(CheckVarExistence(op(Index(op, "-")+1..op'Last)));
        ELSIF Index(op, "*") > 0 THEN
            value1 := new String'(CheckVarExistence(op(op'First..Index(op, "*")-1)));
            value2 := new String'(CheckVarExistence(op(Index(op, "*")+1..op'Last)));
        ELSIF Index(op, "/") > 0 THEN
            value1 := new String'(CheckVarExistence(op(op'First..Index(op, "/")-1)));
            value2 := new String'(CheckVarExistence(op(Index(op, "/")+1..op'Last)));

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
            New_Line;
            RAISE operation_error;
    END ValiderOperation;


    FUNCTION CheckVarType(key : String; value : String) RETURN String IS
        var: P_LISTE_VARIABLE.T_LISTE;
        temp: Integer;
        TypeNotFound: Exception;
        WrongType: Exception;
    BEGIN
        var := Declared_Variables;
        WHILE var.All.Suivant /= NULL AND var.All.Element.intitule.All /= key LOOP
            var := var.All.Suivant;
        END LOOP;

        -- Si c'est un booleen
        IF var.All.Element.typeV = "Booleen" THEN
            IF Integer'Value(value) = 0 OR Integer'Value(value) = 1 THEN
                var.All.Element.initialisation := True;
                RETURN value;
            ELSE
                RAISE WrongType;
            END IF;

        -- Si c'est un entier
        ELSIF var.All.Element.typeV = "Entier" THEN
            temp := Integer'Value(value);
            var.All.Element.initialisation := True;
            RETURN value;

        ELSE
            RAISE TypeNotFound;

        END IF;

    EXCEPTION
        WHEN TypeNotFound =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Le type n'est ni un entier, ni un booleen");
            New_Line;
            RAISE WrongType;

        WHEN WrongType =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Un booleen ne peut prendre que 0 ou 1");
            New_Line;
            RAISE WrongType;

        WHEN others =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Un entier ou un booleen ne peut pas être une chaine de caractère");
            New_Line;
            RAISE WrongType;

    END CheckVarType;


    FUNCTION CheckVarExistence(val : String) RETURN String IS
        var_exist: P_LISTE_VARIABLE.T_LISTE;
        temp: Integer;
        VarNotInit: Exception;
        VarNotExist: Exception;
    BEGIN
        var_exist := Declared_Variables;
        WHILE var_exist.All.Suivant /= NULL AND var_exist.All.Element.intitule.All /= val LOOP
            var_exist := var_exist.All.Suivant;
        END LOOP;

        -- Si c'est un nom de variable et qu'elle existe
        IF var_exist.All.Element.intitule.All = val THEN
            -- Si la variable utilisée possède une valeur (est initialisée)
            IF var_exist.All.Element.initialisation = True THEN
                RETURN val;
            ELSE
                RAISE VarNotInit;
            END IF;
        -- La variable n'a pas été trouvée : soit son nom est incorrect, soit c'est un entier
        ELSE
            temp := Integer'Value(val);
            RETURN val;
        END IF;

    EXCEPTION
        WHEN WrongType =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Impossible d'affecter cette valeur a ce type de variable");
            New_Line;
            RAISE WrongType;

        WHEN others =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Le nom de la variable est incorect");
            New_Line;
            RAISE WrongType;
    End CheckVarExistence;


    PROCEDURE TraduireDeclaration(line : String) IS
        intitule: access String;
        typeV: access String;
        program_error: Exception;
    BEGIN
        IF hasProgramStarded AND Not hasProgramDebuted THEN
            intitule := new String'(removeSingleSpace(line(line'First..Index(line, ":")-1), line(line'First..Index(line, ":")-1)'Length));
            typeV := new String'(removeSingleSpace(line(Index(line, ":")+1..line'Last), line(Index(line, ":")+1..line'Last)'Length));
            ajouter(Declared_Variables, Variable'(intitule, False, 0, typeV.All));
        ELSE
            RAISE program_error;
        END IF;
        EXCEPTION
            WHEN program_error =>
                Put_Line("Ligne ");
                Put(CP_COMPIL, 1);
                Put(" - Le programme n'a pas commencé ou a déjà débuté");
                New_Line;
                RAISE program_error;
    END TraduireDeclaration;


    PROCEDURE TraduireAffectation(line : String) IS
        intitule: access String;
        value: access String;
        listeCourante: P_LISTE_VARIABLE.T_LISTE; 
    BEGIN
        listeCourante := Declared_Variables;
        intitule := new String'(removeSingleSpace(line(line'First..Index(line, "<-")-1), line'Length));
        
        IF Index(line, "+") > 0 OR Index(line, "-") > 0
         OR Index(line, "/") > 0 OR Index(line, "*") > 0 THEN
            value := new String'(
                CheckVarType(
                    intitule.All,
                    removeSingleSpace(line(Index(line, "<-")+1..line'Last), line'Length)
                )
            );

        ELSIF Index(line, "<") > 0 OR Index(line, "<=") > 0
         OR Index(line, ">=") > 0 OR Index(line, ">") > 0 
         OR Index(line, "==") > 0 OR Index(line, "!=") > 0 THEN
            value := new String'(
                CheckVarType(
                    intitule.All,
                    removeSingleSpace(line(Index(line, "<-")+1..line'Last), line'Length)
                )
            );

        ELSE
            value := new String'(
                CheckVarType(
                    intitule.All,
                    line(Index(line, "<-")+1..line'Last)
                )
            );

        END IF;

        Inserer_L(""&intitule.All&" <- "&value.All);


    EXCEPTION
        WHEN Constraint_Error =>
            Put_Line("Ligne ");
            Put(CP_COMPIL, 1);
            Put(" - Variable non déclarée");
            New_Line;
            RAISE Constraint_Error;
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
        Tx : Integer;
        Lx, Ly : Integer;
    BEGIN
        Tx := VerifierCondition(line);
        Lx := CreerLabel;
        Ly := CreerLabel;
        Inserer_L("IF T"&Integer'Image(Tx)&" GOTO L"&Integer'Image(Lx));
        Inserer_L("GOTO L"&Integer'Image(Ly));
        P_PILE_SI.Empiler(Pile_SI,SI'(p_intermediate.GetCP,Ly));
    END TraduireSi;


    PROCEDURE TraduireSinon IS
        el : SI;
        Lx : Integer;
    BEGIN
        el := P_Pile_SI.Depiler(Pile_SI);
        Lx := CreerLabel;
        p_intermediate.Modifier("GOTO L"&Integer'Image(Lx),el.CP);
        P_Pile_SI.Empiler(Pile_SI,el);
    END TraduireSinon;


    PROCEDURE TraduireFinSi IS
        el : SI;
    BEGIN
        el := P_Pile_SI.Depiler(Pile_SI);
        Inserer_L(""&Integer'Image(el.Lx)&" NULL");
    END TraduireFinSi;


END p_compilateur;