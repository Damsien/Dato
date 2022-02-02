with object; use object;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;

PACKAGE BODY op_string IS


    FUNCTION removeSubString(s: String ; sToRm: String) RETURN String IS
        str: access String;
        j: Integer := s'First;
        pos: Integer;
        not_exists: Exception;
    BEGIN
        pos := Index(s, sToRm);
        str := new String'(s);
        pos := Index(s, sToRm);

        IF pos > 0 THEN
            str := new String(s'First..s'Last-sToRm'Length);
            FOR i in s'First..s'Last LOOP
                IF i >= pos AND i < pos+sToRm'Length THEN
                    j := j - 1;
                ELSE
                    str.All(j) := s(i);
                END IF;
                j := j + 1;
            END LOOP;
        ELSE
            RAISE not_exists;
        END IF;

        RETURN str.All;

    EXCEPTION
        WHEN not_exists =>
            Put_Line("The string you want to remove don't exists");
            RAISE not_exists;
            
    END removeSubString;


    FUNCTION Upper_Case (S : String) RETURN String IS

        SUBTYPE Lower_Case_Range IS Character RANGE 'a'..'z';

        Temp : String := S;
        Offset : CONSTANT := Character'Pos('A') - Character'Pos('a');

    BEGIN
        FOR Index IN Temp'Range LOOP
            IF Temp(Index) IN Lower_Case_Range THEN
                Temp(Index) := Character'Val (Character'Pos(Temp(Index)) + Offset);
            END IF;
        END LOOP;
        RETURN Temp;
    END Upper_Case;

    FUNCTION replaceString(s: String ; pattern_to_be_replaced: String ; replace_pattern: String) RETURN String IS
        new_str: access String;
        pos: Integer;
        l1: Integer := pattern_to_be_replaced'Length;
        l2: Integer := replace_pattern'Length;
        i: Integer := 1;
        j: Integer := 1;
    BEGIN
        new_str := new String(1..s'Length-l1+l2);
        pos := Index(s, pattern_to_be_replaced);
        IF pos > 0 THEN
            WHILE i <= new_str.All'Length LOOP
                IF i /= pos THEN
                    new_str.All(i) := s(j);
                ELSE
                    FOR k in 1..l2 LOOP
                        new_str.All(i-1+k) := replace_pattern(k);
                    END LOOP;
                    i := i-1+l2;
                    j := j-1+l1;
                END IF;
                i := i + 1;
                j := j + 1;
            END LOOP;
            RETURN replaceString(new_str.All, pattern_to_be_replaced, replace_pattern);
        ELSE
            -- pattern not found: do nothing
            RETURN s;
        END IF;

    END replaceString;


    FUNCTION removeSingleSpace(s: IN String ; l: IN Integer) RETURN String IS
        str : access String;
        j: Integer := 1;
        pos: Integer;
    BEGIN

        str := new String'(s);
        pos := Index(s, " ");
        IF pos > 0 THEN
            str := new String(1..l-1);
            FOR i in s'First..s'Last LOOP
                IF i /= pos THEN
                    str.All(j) := s(i);
                ELSE
                    j := j - 1;
                END IF;
                j := j + 1;
            END LOOP;
            RETURN removeSingleSpace(str.All, l-1);
        ELSE
            RETURN str.All;
        END IF;

    END removeSingleSpace;

    FUNCTION removeSpaces(s: IN String ; l: IN Integer) RETURN String IS
        str: String(s'First..s'Last);
        finalStr: T_String;
        pos: Integer;
        j: Integer := 1;
    BEGIN

        pos := Index(s, "  ");
        FOR i in s'First..s'Last LOOP
            IF i /= pos THEN
                str(j) := s(i);
            ELSE
                j := j - 1;
            END IF;
            j := j + 1;
        END LOOP;

        IF pos > 0 THEN
            RETURN removeSpaces(str, l-1);
        ELSE
            finalStr := new String(str'First..l);
            FOR i in str'First..l LOOP
                finalStr.All(i) := str(i);
            END LOOP;
            RETURN finalStr.All;
        END IF;
    END removeSpaces;

    FUNCTION clarifyString(s: IN String) RETURN String IS
        c: Character;
        index: Integer := 1;
        temp: T_String;
    BEGIN
        IF s'Last /= 0 THEN
            c := s(s'First);
            WHILE c = ' ' LOOP
                IF index = s'Length THEN
                    RETURN "";
                ELSE
                    index := index + 1;
                    c := s(index);
                END IF;
            END LOOP;
            temp := new String(1..s'Last-index+1);
            FOR i in 1..temp.All'Length LOOP
                temp.All(i) := s(i+index-1);
            END LOOP;
            RETURN removeSpaces(temp.All, temp.All'Length);
        ELSE
            RETURN "";
        END IF;
    END clarifyString;

    FUNCTION TrimI(e : Integer) RETURN String IS
    BEGIN
        IF e < 0 THEN
            RETURN Integer'Image(e)(1..Integer'Image(e)'Last);
        ELSE
            RETURN Integer'Image(e)(2..Integer'Image(e)'Last);
        END IF;
    END TrimI;

END op_string;