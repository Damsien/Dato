with Ada.Text_IO; use Ada.Text_IO;
WITH Ada.integer_text_io; USE Ada.integer_text_io;

package body p_intermediate is

    FUNCTION TToString(el : T_String) RETURN String IS
        result : T_String;
    BEGIN
        result := new String'(el.All);
        RETURN result.All;
    END TToString;

    FUNCTION StringToT(el : String) RETURN T_String IS
        result : T_String;
    BEGIN
        result := new String'(el);
        RETURN result;
    END StringToT;

    PROCEDURE Inserer_L(instruction : IN String) IS
    BEGIN
        Inserer(instruction);
        CP := CP + 1;
    END Inserer_L;

    PROCEDURE Inserer_Entete(instruction : IN String) IS
    BEGIN
        Modifier(instruction,CP_ENTETE);
    END Inserer_Entete;

    PROCEDURE Inserer(instruction : IN String) IS
    existing : T_String;
    concat : T_String;
    BEGIN

        BEGIN
        existing := P_LISTE_CH_CHAR.obtenir(intermediaire.instructions,CP);
        EXCEPTION
            WHEN E : P_LISTE_CH_CHAR.NOT_FOUND =>       
                                    existing := StringToT("");
        END;
        
        IF TToString(existing)'length /= 0 THEN
            concat := new String'(existing.All & instruction);
            Modifier(concat.All,CP);
        ELSE
            P_LISTE_CH_CHAR.ajouter(intermediaire.instructions,new String'(instruction));
        END IF;
    END Inserer;

    Procedure Modifier(instruction : IN String ; ligne : IN Integer) IS
    BEGIN
            Put("");
            P_LISTE_CH_CHAR.modifier(intermediaire.instructions,ligne,new String'(instruction));
    END Modifier;

    Function GetCP RETURN Integer IS
    BEGIN
        return CP;
    END GetCP;

    Function GetFile RETURN T_INTERMEDIAIRE IS
    BEGIN
        return Intermediaire;
    END GetFile;

    Procedure Afficher IS
    BEGIN
        P_LISTE_CH_CHAR.afficherListe(intermediaire.instructions);
    END Afficher;




    PROCEDURE AfficherL(line : String) IS
        startQuote: Integer := 1;
        stopQuote: Integer := 0;
        startPlus: Integer := 1;
        stopPlus: Integer := 0;
        quoteClose: Boolean := True
        index: Integer := 1;
        var: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        tempVarName: access String;
        bad_usage: Exception;
    BEGIN
        New_Line;
        WHILE index < line'Last LOOP

            IF line[index] = '"' AND startQuote <= index AND stopQuote < startQuote AND Not quoteClose THEN
            -- Le string se termine
                stopQuote := index;
                quoteClose := True;
            ELSIF line[index] = '"' AND stopQuote <= index AND startQuote < stopQuote AND quoteClose THEN
            -- Le string commence
                startQuote := index;
                quoteClose := False;
            ELSIF index > startQuote AND stopQuote < startQuote THEN
            -- Le contenu du string
                Put(line[index]);


            IF line[index] = '+' AND startPlus <= index AND stopPlus < startPlus AND quoteClose THEN
            -- Concatenation se termine
                stopPlus := index;
                -- Transformation de la variable en valeur ou prise de la valeur brute
                var := IsVarExisting(tempVarName.All);
                -- Affichage de la valeur
                Put(Integer'Image(GetVarValue(var, tempVarName.All)));
            ELSIF line[index] = '+' AND stopPlus <= index AND startPlus < stopPlus AND quoteClose THEN
            -- Concatenation commence
                startPlus := index;
            ELSIF index > startPlus AND stopPlus < startPlus THEN
                -- Sauvegarde du caractère pour former le nom de la variable finale ou la valeur brute finale
                tempVarName = new String'(tempVarName.All&line[index]);

            ELSE
                RAISE bad_usage;

            END IF;

                
            index = index + 1;
        END LOOP;

    EXCEPTION
        WHEN bad_usage =>
            Put_Line("Mauvais usage de la fonction AFFICHER");
    END Afficher;



    PROCEDURE Traitement(inst: String ; line: P_LISTE_CH_CHAR.T_LISTE) IS
    BEGIN

        IF Index(inst, "L") = 1 THEN
        -- C'est soit un label, soit une affectation
            IF Index(inst(Index(inst, "L")+3..inst'Last), "<-") = 1 THEN
            -- C'est une affectation pour une variable dont le nom commence par 'L'
                TraduireAffectation(inst));
            ELSE
            -- C'est une création de label
                TraduireLabel(inst(inst'First..Index(inst, "L")+2), line);
                -- Le label est affecté à l'instruction, il faut maintenant executer l'instruction
                Traitement(inst(Index(inst, "L")+3..inst'Last));
            END IF;

        ELSIF Index(inst, ":") > 0 THEN
        -- Ce sont les déclarations
            TraiterDeclarations(inst);

        ELSIF Index(inst, "<-") > 0 THEN
        -- C'est une affectation
            TraiterAffectation(inst);

        ELSIF Index(inst, "AFFICHER(") > 0 THEN
        -- C'est un affichage
            AfficherL(inst(Index(inst, "AFFICHER(")+9..Index(inst, ")")-1));

        ELSIF Index(inst, "RETOUR_LIGNE") > 0 THEN
        -- C'est un retour à la ligne
            New_Line;

        ELSE
            NULL;

        END IF;


    END Traitement;

    PROCEDURE TraiterInstructions IS
        liste: P_LISTE_CH_CHAR.T_LISTE := intermediaire.instructions;
    BEGIN

        WHILE liste.All.Suivant /= NULL LOOP
            -- Check pour ce qui ne concerne pas le GOTO
            Traitement(liste.All.Element, liste);
            IF Index(liste.All.Element.All "GOTO") > 0 THEN
                liste := TraduireGOTO(liste);
            ELSE
                liste := liste.All.Suivant;
            END IF;
        END LOOP;
    
    END Traitement;



    PROCEDURE TraduireDeclarations(line : String) IS
        value1: access String;
        value2: access String;
        var: Variable;
    BEGIN
        IF Index(line, ", ") > 0 THEN
            value1 := new String'(line(line'First..Index(line, ", "-1)));
            value2 := new String'(line(Index(line, ", "+2)..line'Last));
            var := (
                new String'(value1.All),
                False,
                0,
                "Entier"
            );
            P_LISTE_VARIABLE.ajouter(Declared_Variables, var);
            WHILE Index(value2.All, ", ") > 0 LOOP
                var := (
                    new String'(value2.All(value2.All'First..Index(value2.All, ", ")-1)),
                    False,
                    0,
                    "Entier"
                );
                P_LISTE_VARIABLE.ajouter(Declared_Variables, var);
                value2.All := value2.All(Index(value2.All, ", "+2)..line'Last);
            END LOOP;
            var := (
                new String'(value2.All(value2.All'First..Index(line, " : Entier")-1)),
                False,
                0,
                "Entier"
            );
            P_LISTE_VARIABLE.ajouter(Declared_Variables, var);
        ELSE
            var := (
                new String'(line(line'First..Index(line, " : Entier")-1)),
                False,
                0,
                "Entier"
            );
            P_LISTE_VARIABLE.ajouter(Declared_Variables, var);
        END IF;
    END TraduireDeclarations;

    PROCEDURE TraduireAffectation(line : String) IS
        var: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        var_val_exist: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        val: Integer;
    BEGIN
        var := IsVarExisting(line(line'First..Index(line, " <-")-1));

        IF Index(line, "+") > 0 OR Index(line, "-") > 0 OR
         Index(line, "*") > 0 OR Index(line, "/") > 0 THEN
            val := AppliquerOperation(line(Index(line, "<- ")+3)..line'Last);
            var.All.Element.value := val;
        ELSIF Index(line, "=") OR Index(line, "!=") OR Index(line, ">") OR
         Index(line, "<") OR Index(line, ">=") OR Index(line, "<=")
         OR Index(line, "OR") OR Index(line, "AND") THEN
            IF AppliquerCondition(line(Index(line, "<- ")+3)..line'Last) THEN
                val := 1;
            ELSE
                val := 0;
            END IF;
            var.All.Element.value := val;
        ELSE
            var_val_exist := IsVarExisting(line(Index(line, "<- ")+3..line'Last));
            var.All.Element.value := GetVarValue(var_val_exist, line(Index(line, "<- ")+3..line'Last));
        END IF;

    END TraduireAffectation;

    FUNCTION TraduireGOTO(listeCourante: P_LISTE_CH_CHAR.T_LISTE) RETURN P_LISTE_CH_CHAR.T_LISTE IS
        line: P_LISTE_CH_CHAR.T_LISTE := listeCourante.All.Element;
    BEGIN
        IF Index(line, "IF") > 0 THEN
            IF VerifierCondition(line(Index(line, "IF ")+3..Index(line, " GOTO"))) THEN
                RETURN rechercherMap(intermediaire.instructions, Index(line, "GOTO ")+5).All.Element.Valeur;
            ELSE
                RETURN listeCourante;
            END IF;
        ELSE
            RETURN rechercherMap(intermediaire.instructions, Index(line, "GOTO ")+5).All.Element.Valeur;
        END IF;
    END TraduireGOTO;

    FUNCTION VerifierCondition(condition: String) RETURN Boolean IS
        var: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
    BEGIN
        var := IsVarExisting(condition);
        IF var.All.Element.value = 1 THEN
            RETURN True;
        ELSE
            RETURN False;
        END IF;
    END VerifierCondition;

    PROCEDURE TraduireLabel(label: String; line: P_LISTE_CH_CHAR.T_LISTE) IS
    BEGIN
        ajouterMap(label_map, label, line);
    END TraduireLabel;



    FUNCTION AppliquerCondition(cond: String) RETURN Boolean IS
        var1_exist: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        var2_exist: P_LISTE_VARIABLE.T_LISTE := Declared_Variables;
        value1: access String;
        value2: access String;
        valInt1: Integer;
        valInt2: Integer;
    BEGIN
        IF Index(op, " < ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " <")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "< ")+2..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 < valInt2);
        ELSIF Index(cond, " > ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " >")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "> ")+2..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 > valInt2);
        ELSIF Index(cond, " <= ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " <=")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "<= ")+3..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 <= valInt2);
        ELSIF Index(cond, " >= ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " >=")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, ">= ")+3..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 >= valInt2);
        ELSIF Index(cond, " = ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " =")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "= ")+3..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 = valInt2);
        ELSIF Index(cond, " != ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " !=")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "!= ")+..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN (valInt1 != valInt2);
        ELSIF Index(cond, " OR ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " OR")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "OR ")+3..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            IF valInt1 = 1 THEN
                IF valInt2 = 1 THEN
                    RETURN True;
                ELSE
                    RETURN True;
                END IF;
            ELSE
                IF valInt2 = 1 THEN
                    RETURN True;
                ELSE
                    RETURN False;
                END IF;
            END IF;
        ELSIF Index(cond, " AND ") > 0 THEN
            value1 := new String'(cond(cond'First..Index(cond, " AND")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(cond(Index(cond, "AND ")+..cond'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            IF valInt1 = 1 THEN
                IF valInt2 = 1 THEN
                    RETURN True;
                ELSE
                    RETURN False;
                END IF;
            ELSE
                IF valInt2 = 1 THEN
                    RETURN False;
                ELSE
                    RETURN False;
                END IF;
            END IF;
        ELSE
            NULL;
        END IF;
    END AppliquerCondition;

    FUNCTION AppliquerOperation(op: String) RETURN Integer IS
        var1_exist: P_LISTE_VARIABLE.T_LISTE;
        var2_exist: P_LISTE_VARIABLE.T_LISTE;
        value1: access String;
        value2: access String;
        valInt1: Integer;
        valInt2: Integer;
    BEGIN
        IF Index(op, "+") > 0 THEN
            value1 := new String'(op(op'First..Index(op, " +")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(op(Index(op, "+ ")+2..op'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN valInt1+valInt2;
        ELSIF Index(op, "-") > 0 THEN
            value1 := new String'(op(op'First..Index(op, " -")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(op(Index(op, "- ")+2..op'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN valInt1-valInt2;
        ELSIF Index(op, "*") > 0 THEN
            value1 := new String'(op(op'First..Index(op, " *")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(op(Index(op, "* ")+2..op'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN valInt1*valInt2;
        ELSIF Index(op, "/") > 0 THEN
            value1 := new String'(op(op'First..Index(op, " /")-1));
            var1_exist := IsVarExisting(value1);
            valInt1 := GetVarValue(var1_exist, value1);
            value2 := new String'(op(Index(op, "/ ")+2..op'Last));
            var2_exist := IsVarExisting(value2);
            valInt2 := GetVarValue(var2_exist, value2);
            RETURN valInt1/valInt2;
        ELSE
            NULL;
        END IF;
    END AppliquerOperation;


    FUNCTION GetVarValue(liste: P_LISTE_VARIABLE.T_LISTE; val: String) RETURN Integer IS
    BEGIN
        IF liste.All.Element.intitule.All = val THEN
            RETURN liste.All.Element.value;
        ELSE
            RETURN Integer'Value(val);
        END IF;
    END GetVarValue;


    FUNCTION IsVarExisting(val: String) RETURN P_LISTE_VARIABLE.T_LISTE IS
        var_exist: P_LISTE_VARIABLE.T_LISTE;
    BEGIN
        value1 := new String'(op(op'First..Index(op, " -")-1));
        WHILE var1_exist.All.Suivant /= NULL AND var1_exist.All.Element.intitule.All /= val LOOP
            var1_exist := var1_exist.All.Suivant;
        END LOOP;
    END IsVarExisting;

end p_intermediate;