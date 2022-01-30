WITH P_LISTE;

package object is

    type TQ is record
        Lx : Integer;
        Tx : Integer;
        line : access String;
    end record;

    type SI is record
        CP : Integer;
        Lx : Integer;
    end record;

    type Variable is record
        intitule : access String;
        initialisation : Boolean := False;
        value : Integer;
        typeV : access String;
    end record;

    type Label is record
        Lx : Integer;
        CP : Integer;
    end record;

    function Image_SI(element: SI) return String;

    function Image_TQ(element : TQ) return String;

    function Image_Variable(element : Variable) return String;

    function Image_Label(element : Label) return String;

    TYPE T_String IS ACCESS String;

    FUNCTION TToString(el : T_String) RETURN String;

    FUNCTION StringToT(el : String) RETURN T_String;

    PACKAGE P_LISTE_CH_CHAR IS NEW P_LISTE(T_ELEMENT => T_String, Image => TToString);
    USE P_LISTE_CH_CHAR;

end object;