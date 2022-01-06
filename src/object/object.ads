package object is

    type TQ is record
        Lx : Integer;
        Tx : Integer;
    end record;

    type Variable is record
        intitule : Integer;
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

end object;