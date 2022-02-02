WITH p_source; USE p_source;
WITH op_string; Use op_string;
WITH p_liste;
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
        RETURN TrimI(el.Tx);
    END TQToString;

    PROCEDURE Traitement(instruction : String) IS
        pos: Integer;
        exist: Boolean := False;
        inst: String := Upper_Case(instruction);
        started_error: Exception;
        ended_error: Exception;
        debuted_error: Exception;
    BEGIN

        IF Not hasProgramStarded THEN
            IF hasProgramEnded THEN
                RAISE ended_error;  -- faut vraiment forcer pour arriver la : "FIN" avant "PROGRAMME EST"
            ELSE
                IF inst'Length = 0 THEN
                    --Put_Line("Ligne vide ==============");
                    NULL;
                ELSIF Index(inst, "--") > 0 THEN
                    --Put_Line("Commentaire ==============");
                    pos := Index(inst, "--");
                    Traitement(instruction(inst'First..pos-1));
                    RETURN;
                ELSIF clarifyString(inst) = "" THEN
                    --Put_Line("Ligne vide ==============");
                    NULL;
                ELSIF Index(inst, "PROGRAMME ") > 0 AND Index(inst, " EST")+3 = inst'Last THEN
                    IF Index(removeSingleSpace(inst, inst'Length), "EST") >= Index(removeSingleSpace(inst, inst'Length), "PROGRAMME")+9+1
                    AND inst(Index(inst, "PROGRAMME ")+10..Index(inst, " EST")-1)'Length = removeSingleSpace(inst(Index(inst, "PROGRAMME ")+10..Index(inst, " EST")-1), inst(Index(inst, "PROGRAMME ")+10..Index(inst, " EST")-1)'Length)'Length THEN
                        --Put_Line("Program start ==============");
                        hasProgramStarded := True;
                        Inserer_L(inst);
                        p_intermediate.CP_ENTETE := p_intermediate.GetCP;
                        Inserer_L("");
                    END IF;
                ELSE
                    RAISE started_error;
                END IF;
            END IF;
        ELSE
            IF hasProgramEnded THEN
                IF inst'Length = 0 THEN
                    NULL;
                ELSIF Index(inst, "--") > 0 THEN
                    --Put_Line("Commentaire ==============");
                    pos := Index(inst, "--");
                    Traitement(instruction(inst'First..pos-1));
                    RETURN;
                ELSIF clarifyString(inst) = "" THEN
                    --Put_Line("Ligne vide ==============");
                    NULL;
                ELSE
                    RAISE ended_error;
                END IF;
            ELSE
                IF Not hasProgramDebuted THEN
                    IF inst = "DEBUT" OR inst = "DéBUT" OR inst = "DEBUT " OR inst = "DéBUT " THEN
                        --Put_Line("Program Debut ==============");
                        hasProgramDebuted := True;
                        Inserer_L(inst);
                    ELSIF inst'Length = 0 THEN
                        --Put_Line("Ligne vide ==============");
                        NULL;
                    ELSIF Index(inst, "--") > 0 THEN
                        --Put_Line("Commentaire ==============");
                        pos := Index(inst, "--");
                        Traitement(instruction(inst'First..pos-1));
                        RETURN;
                    ELSIF clarifyString(inst) = "" THEN
                        --Put_Line("Program Debut ==============");
                        NULL;
                    ELSIF Index(inst, ":") > 0 THEN
                        --Put_Line("Declaration ==============");
                        TraduireDeclaration(inst);
                    ELSE
                        RAISE debuted_error;
                    END IF;
                ELSE

                    IF inst'Length = 0 THEN
                        NULL;
                    ELSIF Index(inst, "--") > 0 THEN
                        --Put_Line("Commentaire ==============");
                        pos := Index(inst, "--");
                        Traitement(instruction(inst'First..pos-1));
                        RETURN;
                    ELSIF clarifyString(inst) = "" THEN
                        --Put_Line("Ligne vide ==============");
                        NULL;
                    ELSIF inst = "FIN TANT QUE" THEN
                        --Put_Line("Fin Tant Que ==============");
                        TraduireFinTantQue;
                        exist := True;
                    ELSIF inst = "SINON" THEN
                        --Put_Line("Sinon ==============");
                        TraduireSinon;
                        exist := True;
                    ELSIF inst = "FIN SI" THEN
                        --Put_Line("Fin Si ==============");
                        TraduireFinSi;
                        exist := True;
                    ELSIF inst = "FIN" OR inst = "FIN " THEN
                        --Put_Line("Fin ==============");
                        hasProgramEnded := True;
                        Inserer_L(inst);
                        exist := True;
                    END IF;

                    IF inst'Length = 0 THEN
                        NULL;
                    ELSIF Index(inst, "--") > 0 THEN
                        --Put_Line("Commentaire ==============");
                        pos := Index(inst, "--");
                        Traitement(instruction(inst'First..pos-1));
                        RETURN;
                    ELSIF clarifyString(inst) = "" THEN
                        --Put_Line("Ligne vide ==============");
                        NULL;
                    ELSIF Index(inst, "<-") > 0 THEN
                        --Put_Line("Affectation ==============");
                        TraduireAffectation(inst);
                    ELSIF Index(inst, "TANT QUE") > 0 THEN
                        IF Index(inst, "FIN TANT QUE") = 0 THEN
                            --Put_Line("Tant Que ==============");
                            TraduireTantQue(inst);
                        END IF;
                    ELSIF Index(inst, "SI") > 0 AND Index(inst, "ALORS") > 0 THEN
                        IF inst /= "FIN SI" AND inst /= "SINON" THEN
                            --Put_Line("Si ==============");
                            TraduireSi(inst);
                        END IF;
                    ELSIF Index(inst, "AFFICHER(") > 0 THEN
                        --Put_Line("Afficher ==============");
                        Inserer_L(instruction);
                    ELSIF Index(inst, "RETOUR") > 0 THEN
                        --Put_Line("Retour ==============");
                        Inserer_L("RETOUR");
                    ELSE
                        IF Not exist THEN
                            RAISE NotCompile;
                        ELSE
                            NULL;
                        END IF;
                    END IF;
                END IF;

            END IF;
        END IF;

    EXCEPTION
        WHEN started_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le programme n'a pas encore commencé");
            New_Line;
            RAISE started_error;
        WHEN ended_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le programme est déjà terminé");
            New_Line;
            RAISE ended_error;
        WHEN debuted_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le programme n'a pas encore débuté");
            New_Line;
            RAISE debuted_error;
        WHEN NotCompile =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Erreur de compilation, veuillez vérifier la syntaxe");
            New_Line;
            RAISE NotCompile;
    END Traitement;


    PROCEDURE TraiterInstructions(instructions : T_SOURCE) IS
        inst: P_LISTE_CH_CHAR.T_LISTE;
    BEGIN
        inst := instructions.instructions;
        WHILE P_LISTE_CH_CHAR.isNull(inst) LOOP
            Traitement(inst.All.Element.All);
            CP_COMPIL := CP_COMPIL + 1;
            inst := inst.All.Suivant;
        END LOOP;

        DeclarerVariable;

    END TraiterInstructions;

    PROCEDURE DeclarerVariable IS
        l : P_LISTE_VARIABLE.T_LISTE;
        size: Integer := 1;
        max : Integer := 0;
        declared : access String;
        temp : access String;
        a : Integer;
        b : Integer;
        index : Integer := 1;
    BEGIN

        l := Declared_Variables;

        -- Liste des variables déclarées par un utilisateur
        IF L /= NULL THEN

            while l /= NULL loop
                max := max + l.All.Element.intitule'length + 2;
                l := l.All.Suivant;
            end loop;
            max := max - 2;

            declared := new String(1..max);

            l := Declared_Variables;

            -- - Premier élément
            IF l /= NULL THEN
                declared(size..l.All.Element.intitule'length) := l.All.Element.intitule.All;
                size := size + l.All.Element.intitule'length;
                l := l.All.Suivant;
            END IF;

            -- - Elements suivants
            while l /= NULL loop
                declared(size..size+l.All.Element.intitule'length+1) := ", "&l.All.Element.intitule.All;
                size := size + l.All.Element.intitule'length + 2;
                l := l.All.Suivant;
            end loop;

        ELSE

            declared := new String(1..1);
            declared(1) := Character'Val(0);

        END IF;
        

        -- Obtenir taille de tableau nécessaire
        index := 1;
        size := 4;
        while index * 10 < TEMP_USED loop
            size := size + (index * 10 - index) * (4 + index / 10) + 1; 
            index := index * 10;
        end loop;
        size := size + (TEMP_USED  - index) * (4 + index / 10);

        -- Liste des variables temporaires
        Put("");
        temp := new String(1..size);
        index := 1;
        for i in 1..TEMP_USED LOOP


            a := index;
            b := index + 3 + i/10;

            index := b+1;
            
            temp(a..b) := ", T"&TrimI(i);

        end loop;

        if b < size THEN
            Put("");
            temp := new String'(temp(1..b));
        end if;

        -- Concaténation et insertion
        IF TEMP_USED > 0 THEN
            Inserer_Entete(declared.All&temp.All&" : Entier");
        ELSE
            Inserer_Entete(declared.All&" : Entier");
        END IF;
        NULL;
    END DeclarerVariable;


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
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, ">=")-1),
                    condition(condition'First..Index(condition, ">=")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, ">=")+2..condition'Last),
                    condition(Index(condition, ">=")+2..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&value1.All&" > "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&value1.All&" = "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- T"&TrimI(Tx-2)&" OR T"&TrimI(Tx-1));
        ELSIF Index(condition, "<=") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, "<=")-1),
                    condition(condition'First..Index(condition, "<=")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, "<=")+2..condition'Last),
                    condition(Index(condition, "<=")+2..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&value1.All&" < "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&value1.All&" = "&value2.All);
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- T"&TrimI(Tx-2)&" OR T"&TrimI(Tx-1));
        ELSIF Index(condition, ">") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, ">")-1),
                    condition(condition'First..Index(condition, ">")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, ">")+1..condition'Last),
                    condition(Index(condition, ">")+1..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&condition);
        ELSIF Index(condition, "<") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, "<")-1),
                    condition(condition'First..Index(condition, "<")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, "<")+1..condition'Last),
                    condition(Index(condition, "<")+1..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&condition);
        ELSIF Index(condition, "==") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, "==")-1),
                    condition(condition'First..Index(condition, "==")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, "==")+2..condition'Last),
                    condition(Index(condition, "==")+2..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&condition);
        ELSIF Index(condition, "!=") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(condition'First..Index(condition, "!=")-1),
                    condition(condition'First..Index(condition, "!=")-1)'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    condition(Index(condition, "!=")+2..condition'Last),
                    condition(Index(condition, "!=")+2..condition'Last)'Length
                )));
            Tx := CreerVariableTemporaire;
            Inserer_L("T"&TrimI(Tx)&" <- "&condition);

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
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Seule une condition peut être réalisée par ligne");
            New_Line;
            RAISE condition_error;
    END VerifierCondition;


    PROCEDURE FormaliserOperation(op : IN String ;
     value1 : IN OUT T_String ; value2 : IN OUT T_String) IS
        operation_error: Exception;
        operation_type_error: Exception;
    BEGIN
        IF Index(op, "+") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    BoolToInt(op(op'First..Index(op, "+")-1)),
                    BoolToInt(op(op'First..Index(op, "+")-1))'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    BoolToInt(op(Index(op, "+")+1..op'Last)),
                    BoolToInt(op(Index(op, "+")+1..op'Last))'Length
                )));
            IF Index(value2.All, "+") > 0 OR Index(value2.All, "*") > 0
             OR Index(value2.All, "/") > 0 OR Index(value2.All, "-") > 0 THEN
                RAISE operation_error;
            ELSE
                NULL;
            END IF;
        ELSIF Index(op, "-") > 0 THEN
            IF Index(op, "-") = 1 THEN
                Put("");
                value1 := new String'("0");
            ELSE
                Put("");
                value1 := new String'(CheckVarExistence(
                    removeSingleSpace(
                        op(op'First..Index(op, "-")-1),
                        op(op'First..Index(op, "-")-1)'Length
                )));
            END IF;
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    op(Index(op, "-")+1..op'Last),
                    op(Index(op, "-")+1..op'Last)'Length
                )));
            IF Index(value2.All, "+") > 0 OR Index(value2.All, "*") > 0
             OR Index(value2.All, "/") > 0 OR Index(value2.All, "-") > 0 THEN
                RAISE operation_error;
            ELSE
                NULL;
            END IF;
        ELSIF Index(op, "*") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    BoolToInt(op(op'First..Index(op, "*")-1)),
                    BoolToInt(op(op'First..Index(op, "*")-1))'Length
                )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    BoolToInt(op(Index(op, "*")+1..op'Last)),
                    BoolToInt(op(Index(op, "*")+1..op'Last))'Length
                )));
            IF Index(value2.All, "+") > 0 OR Index(value2.All, "*") > 0
             OR Index(value2.All, "/") > 0 OR Index(value2.All, "-") > 0 THEN
                RAISE operation_error;
            ELSE
                NULL;
            END IF;
        ELSIF Index(op, "/") > 0 THEN
            Put("");
            value1 := new String'(CheckVarExistence(
                removeSingleSpace(
                    op(op'First..Index(op, "/")-1),
                    op(op'First..Index(op, "/")-1)'Length
            )));
            Put("");
            value2 := new String'(CheckVarExistence(
                removeSingleSpace(
                    op(Index(op, "/")+1..op'Last),
                    op(Index(op, "/")+1..op'Last)'Length
            )));
            IF Index(value2.All, "+") > 0 OR Index(value2.All, "*") > 0
             OR Index(value2.All, "/") > 0 OR Index(value2.All, "-") > 0 THEN
                RAISE operation_error;
            ELSE
                NULL;
            END IF;
        ELSE RAISE operation_type_error;

        END IF;

    EXCEPTION
        WHEN operation_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            put_line(" - Seulement une opération est permise par ligne");
            New_Line;
            RAISE operation_error;
        WHEN operation_type_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Seules les opérations suivantes sont autorisées : + * - /");
            New_Line;
            RAISE operation_error;
    END FormaliserOperation;

    
    FUNCTION ValiderOperation(op : String) RETURN Integer IS
        value1: T_String;
        value2: T_String;
    BEGIN
        IF Index(op, "+") > 0 THEN
            FormaliserOperation(op, value1, value2);
            RETURN VarToValue(value1.All)+VarToValue(value2.All);
        ELSIF Index(op, "-") > 0 THEN
            FormaliserOperation(op, value1, value2);
            RETURN VarToValue(value1.All)-VarToValue(value2.All);
        ELSIF Index(op, "*") > 0 THEN
            FormaliserOperation(op, value1, value2);
            RETURN VarToValue(value1.All)*VarToValue(value2.All);
        ELSIF Index(op, "/") > 0 THEN
            FormaliserOperation(op, value1, value2);
            RETURN VarToValue(value1.All)/VarToValue(value2.All);
        ELSE
            RETURN VarToValue(op);
        END IF;

    END ValiderOperation;


    FUNCTION VarToValue(value: String) RETURN Integer IS
        var_exist: P_LISTE_VARIABLE.T_LISTE;
    BEGIN
        var_exist := Declared_Variables;
        WHILE P_LISTE_VARIABLE.isNull(var_exist.All.Suivant) AND var_exist.All.Element.intitule.All /= value LOOP
            var_exist := var_exist.All.Suivant;
        END LOOP;

        IF var_exist.All.Element.intitule.All = value THEN
            RETURN var_exist.All.Element.value;
        ELSE
            RETURN Integer'Value(value);
        END IF;

    EXCEPTION
        WHEN others =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Un entier ne peut pas être une chaine de caractère. Obtenu : '"&value&"'");
            New_Line;
            RAISE WrongType;
    END VarToValue;


    FUNCTION IntToBool(val: String) RETURN String IS
    BEGIN
        IF(val = "1") THEN
            RETURN "VRAI";
        ELSIF(val = "0") THEN
            RETURN "FAUX";
        ELSE
            RETURN val;
        END IF;
    END IntToBool;


    FUNCTION BoolToInt(val: String) RETURN String IS
    BEGIN
        IF(val = "VRAI") THEN
            RETURN "1";
        ELSIF(val = "FAUX") THEN
            RETURN "0";
        ELSE
            RETURN val;
        END IF;
    END BoolToInt;


    FUNCTION CheckVarType(key : String; value : String) RETURN String IS
        var: P_LISTE_VARIABLE.T_LISTE;
        spaceVal: access String;
        temp: Integer;
        value1: T_String;
        value2: T_String;
        TypeNotFound: Exception;
        WrongType: Exception;
        operation_type_error: Exception;
    BEGIN
        Put("");
        spaceVal := new String'(removeSingleSpace(value(value'First..value'Last), value(value'First..value'Last)'Length));

        var := Declared_Variables;
        WHILE var.All.Suivant /= NULL AND var.All.Element.intitule.All /= key LOOP
            var := var.All.Suivant;
        END LOOP;

        -- Si c'est un booleen
        IF var.All.Element.typeV.All = "BOOLEEN" THEN
            Put("");
            spaceVal := new String'(replaceString(spaceVal.All, "VRAI", "1"));
            Put("");
            spaceVal := new String'(replaceString(spaceVal.All, "FAUX", "0"));
            Put("");
            spaceVal := new String'(replaceString(spaceVal.All, "OU", "+"));
            Put("");
            spaceVal := new String'(replaceString(spaceVal.All, "ET", "*"));
            temp := ValiderOperation(spaceVal.All);
            IF Index(spaceVal.All, "+") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                --IF (Integer'Value(value1.All) = 0 OR Integer'Value(value1.All) = 1)
                -- AND (Integer'Value(value2.All) = 0 OR Integer'Value(value2.All) = 1) THEN
                    var.All.Element.initialisation := True;
                    RETURN IntToBool(value1.All)&" OR "&IntToBool(value2.All);
                --ELSE
                --    RAISE WrongType;
                --END IF;
            ELSIF Index(spaceVal.All, "*") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                --IF (Integer'Value(value1.All) = 0 OR Integer'Value(value1.All) = 1)
                -- AND (Integer'Value(value2.All) = 0 OR Integer'Value(value2.All) = 1) THEN
                    var.All.Element.initialisation := True;
                    RETURN IntToBool(value1.All)&" AND "&IntToBool(value2.All);
                --ELSE
                --    RAISE WrongType;
                --END IF;
            ELSIF Index(value, "-") > 0 OR Index(value, "/") > 0 THEN
                RAISE operation_type_error;
            ELSE
                IF (Integer'Value(spaceVal.All) = 0 OR Integer'Value(spaceVal.All) = 1) THEN
                    var.All.Element.initialisation := True;
                    RETURN IntToBool(value);
                ELSE
                    RAISE WrongType;
                END IF;
            END IF;

        -- Si c'est un entier
        ELSIF var.All.Element.typeV.All = "ENTIER" THEN
            temp := ValiderOperation(spaceVal.All);
            var.All.Element.initialisation := True;
            IF Index(value, "+") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                RETURN value1.All&" + "&value2.All;
            ELSIF Index(value, "-") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                RETURN value1.All&" - "&value2.All;
            ELSIF Index(value, "*") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                RETURN value1.All&" * "&value2.All;
            ELSIF Index(value, "/") > 0 THEN
                FormaliserOperation(spaceVal.All, value1, value2);
                RETURN value1.All&" / "&value2.All;
            ELSE
                RETURN value;
            END IF;

        ELSE
            RAISE TypeNotFound;

        END IF;

    EXCEPTION
        WHEN operation_type_error =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - L'opérateur utilisé ne peux pas s'appliquer sur un type booleen. Les seuls possibles sont + et *");
            New_Line;
            RAISE operation_type_error;

        WHEN TypeNotFound =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le type '"&var.All.Element.typeV.All&"' n'est ni un entier, ni un booleen");
            New_Line;
            RAISE TypeNotFound;

        WHEN WrongType =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Un booleen ne peut prendre que 1, 0, VRAI ou FAUX. La variable '"&var.All.Element.intitule.All&"' est un "&var.All.Element.typeV.All&" et la valeur affectée est "&value);
            New_Line;
            RAISE WrongType;

    END CheckVarType;


    FUNCTION CheckVarExistence(val : String) RETURN String IS
        var_exist: P_LISTE_VARIABLE.T_LISTE;
        temp: Integer;
        VarNotInit: Exception;
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
        ELSIF Index(val, "0") > 0 OR Index(val, "1") > 0 THEN
            RETURN val;
        -- La variable n'a pas été trouvée : soit son nom est incorrect, soit c'est un entier
        ELSE
            temp := Integer'Value(val);
            RETURN val;
        END IF;

    EXCEPTION
        WHEN VarNotInit =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - La variable '"&val&"' n'a pas été initialisée");
            New_Line;
            RAISE VarNotInit;

        WHEN others =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le nom de la variable '"&val&"' est incorrect");
            New_Line;
            RAISE WrongType;
    End CheckVarExistence;


    PROCEDURE TraduireDeclaration(line : String) IS
        var: Variable;
        var_exist: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        intitule: access String;
        program_error: Exception;
        var_already_declared: Exception;
        bad_var_name : exception;
        wrongType : exception;
    BEGIN
        IF hasProgramStarded AND Not hasProgramDebuted THEN
            intitule := new String'(removeSingleSpace(line(line'First..Index(line, ":")-1), line(line'First..Index(line, ":")-1)'Length));
            IF Index(intitule.All, "?") > 0 OR Index(intitule.All, ":") > 0 OR Index(intitule.All, "-") > 0 OR
            Index(intitule.All, "<") > 0 OR Index(intitule.All, ">") > 0 OR Index(intitule.All, "=") > 0 OR
            Index(intitule.All, ".") > 0 OR Index(intitule.All, ";") > 0 OR Index(intitule.All, ",") > 0 OR
            Index(intitule.All, "!") > 0 OR Index(intitule.All, "/") > 0 OR Index(intitule.All, "\") > 0  THEN
                RAISE bad_var_name;
            ELSE NULL;
            END IF;
            var_exist := Declared_Variables;
            WHILE P_LISTE_VARIABLE.taille(var_exist) > 0 AND THEN var_exist.All.Suivant /= NULL AND THEN var_exist.All.Element.intitule.All /= intitule.All LOOP
                var_exist := var_exist.All.Suivant;
            END LOOP;
            IF P_LISTE_VARIABLE.taille(var_exist) > 0 AND THEN var_exist.All.Element.intitule.All = intitule.All THEN
                RAISE var_already_declared;
            ELSE
                IF removeSingleSpace(line(Index(line, ":")+1..line'Last), line(Index(line, ":")+1..line'Last)'Length) = "ENTIER" 
                OR removeSingleSpace(line(Index(line, ":")+1..line'Last), line(Index(line, ":")+1..line'Last)'Length) = "BOOLEEN" THEN
                var := (
                    new String'(removeSingleSpace(line(line'First..Index(line, ":")-1), line(line'First..Index(line, ":")-1)'Length)),
                    False,
                    0,
                    new String'(removeSingleSpace(line(Index(line, ":")+1..line'Last), line(Index(line, ":")+1..line'Last)'Length))
                );
                P_LISTE_VARIABLE.ajouter(Declared_Variables, var);
                ELSE
                    raise wrongType;
                END IF;
            END IF;
        ELSE
            RAISE program_error;
        END IF;
        EXCEPTION
            WHEN var_already_declared =>
                Put("Ligne ");
                Put(CP_COMPIL, 1);
                Put_Line(" - La variable "&intitule.All&" a déjà été déclarée");
                New_Line;
                RAISE program_error;
                
            WHEN program_error =>
                Put("Ligne ");
                Put(CP_COMPIL, 1);
                IF NOT hasProgramStarded THEN
                    Put_Line(" - Impossible de déclarer une variable : le programme n'a pas commencé");
                ELSE
                    Put_Line(" - Impossible de déclarer une nouvelle variale : le programme a déjà débuté");
                END IF;
                New_Line;
                RAISE program_error;

            WHEN bad_var_name =>
                Put("Ligne ");
                Put(CP_COMPIL, 1);
                Put_Line(" - Le nom de la variable contient des caractères spéciaux");
                New_Line;
                RAISE bad_var_name;

            WHEN wrongType =>
                Put("Ligne ");
                Put(CP_COMPIL, 1);
                Put_Line(" - Une variable ne peut être qu'un entier ou un booléen");
                New_Line;
                RAISE wrongType;
    END TraduireDeclaration;


    PROCEDURE TraduireAffectation(line : String) IS
        intitule: access String;
        value: access String;
        listeCourante: P_LISTE_VARIABLE.T_LISTE; 
        bad_var_name: Exception;
    BEGIN
        listeCourante := Declared_Variables;
        Put("");
        intitule := new String'(removeSingleSpace(line(line'First..Index(line, "<-")-1), line(line'First..Index(line, "<-")-1)'Length));
        Put("");
        value := new String'(removeSingleSpace(line(Index(line, "<-")+2..line'Last), line(Index(line, "<-")+2..Line'Last)'Length));


        IF Index(intitule.All, "?") > 0 OR Index(intitule.All, ":") > 0 OR Index(intitule.All, "-") > 0 OR
         Index(intitule.All, "<") > 0 OR Index(intitule.All, ">") > 0 OR Index(intitule.All, "=") > 0 OR
         Index(intitule.All, ".") > 0 OR Index(intitule.All, ";") > 0 OR Index(intitule.All, ",") > 0 OR
         Index(intitule.All, "!") > 0 OR Index(intitule.All, "/") > 0 OR Index(intitule.All, "\") > 0  THEN
            RAISE bad_var_name;
        ELSE NULL;
        END IF;


        IF Index(value.All, "+") > 0 OR Index(value.All, "-") > 0
         OR Index(value.All, "/") > 0 OR Index(value.All, "*") > 0 THEN 
            Put("");
            value := new String'(
                CheckVarType(
                    intitule.All,
                    line(Index(line, "<-")+2..line'Last)
                )
            );

        ELSIF Index(value.All, "<") > 0 OR Index(value.All, "<=") > 0
         OR Index(value.All, ">=") > 0 OR Index(value.All, ">") > 0 
         OR Index(value.All, "==") > 0 OR Index(value.All, "!=") > 0 THEN
            Put("");
            value := new String'(
                CheckVarType(
                    intitule.All,
                    line(Index(line, "<-")+2..line'Last)
                )
            );

        ELSE
            Put("");
            value := new String'(
                CheckVarType(
                    intitule.All,
                    removeSingleSpace(line(Index(line, "<-")+2..line'Last), line(Index(line, "<-")+2..line'Last)'Length)
                )
            );

        END IF;

        Inserer_L(""&intitule.All&" <- "&value.All);

    EXCEPTION
        WHEN bad_var_name =>
            Put("Ligne ");
            Put(CP_COMPIL, 1);
            Put_Line(" - Le nom de la variable contient des caractères spéciaux");
            New_Line;
            RAISE bad_var_name;

    END TraduireAffectation;


    PROCEDURE TraduireTantQue(line : String) IS
        Tx : Integer;
        Lx, Ly, Lz : Integer;
        temp : Integer := 5;
        object : TQ;
    BEGIN
        Tx := VerifierCondition(line(Index(line, "TANT QUE ")+9..Index(line, " FAIRE")-1));
        Lx := CreerLabel;
        Ly := CreerLabel;
        Lz := CreerLabel;
        Inserer_L("L"&TrimI(Lx)&" IF T"&TrimI(Tx)&" GOTO L"&TrimI(Lz));
        Inserer_L("GOTO L"&TrimI(Ly));
        Inserer("L"&TrimI(Lz)&" ");
        
        object := (Lx,Tx,new String'(line(Index(line, "TANT QUE ")+9..Index(line, " FAIRE")-1)));
        P_PILE_TQ.Empiler(Pile_TQ,object);
    END TraduireTantQue;


    PROCEDURE TraduireFinTantQue IS
        rec : TQ;
        temp : Integer;
    BEGIN
        rec := P_PILE_TQ.Depiler(Pile_TQ);
        temp := VerifierCondition(rec.line.All);
        Inserer_L("T"&TrimI(rec.Tx)&" <- T"&TrimI(temp));
        Inserer_L("GOTO L"&TrimI(rec.Lx));
        Inserer_L("L"&TrimI(rec.Lx + 1) & " NULL");
    END TraduireFinTantQue;


    PROCEDURE TraduireSi(line : String) IS
        Tx : Integer;
        Lx, Ly : Integer;
        object: SI;
    BEGIN
        Tx := VerifierCondition(line(Index(line, "SI ")+3..Index(line, " ALORS")-1));
        Lx := CreerLabel;
        Ly := CreerLabel;
        Put("");
        Inserer_L("IF T"&TrimI(Tx)(2..TrimI(Tx)'Last)&" GOTO L"&TrimI(Lx));
        Put("");
        object := (p_intermediate.GetCP,Ly);
        P_PILE_SI.Empiler(Pile_SI,object);
        Inserer_L("GOTO L"&TrimI(Ly));
        Put("");
        Inserer("L"&TrimI(Lx)&" ");
        Put("");
    END TraduireSi;


    PROCEDURE TraduireSinon IS
        el : SI;
        Lx : Integer;
    BEGIN
    
        el := P_Pile_SI.Depiler(Pile_SI);


        Lx := CreerLabel;
        p_intermediate.Modifier("GOTO L"&TrimI(Lx),el.CP);
        Inserer_L("GOTO L"&TrimI(el.Lx));
        Put("");
        Inserer("L"&TrimI(Lx)&" ");
        Put("");
        P_Pile_SI.Empiler(Pile_SI,el);
    END TraduireSinon;


    PROCEDURE TraduireFinSi IS
        el : SI;
    BEGIN
        el := P_Pile_SI.Depiler(Pile_SI);


        Inserer_L("L"&TrimI(el.Lx)&" NULL");
    END TraduireFinSi;


END p_compilateur;