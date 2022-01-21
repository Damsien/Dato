WITH P_LISTE;

package object is

    type TQ is record
        Lx : Integer;
        Tx : Integer;
        line : access String;
    end record;

    type Variable is record
        intitule : access String;
        value : Integer;
        typeV : String(1..6);
    end record;

    type Label is record
        Lx : Integer;
        CP : Integer;
    end record;

    function Image_TQ(element : TQ) return String;

    function Image_Variable(element : Variable) return String;

    function Image_Label(element : Label) return String;


    TYPE T_String IS ACCESS String;

    FUNCTION TToString(el : T_String) RETURN String;

    FUNCTION StringToT(el : String) RETURN T_String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;

end object;