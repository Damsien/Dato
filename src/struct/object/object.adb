package body object is

    function Image_SI(element : SI) return String is
    begin
        return "CP"&Integer'Image(element.CP)&" , L"&Integer'Image(element.Lx); 
    end Image_SI;


    function Image_TQ(element : TQ) return String is
    begin
        return "L"&Integer'Image(element.Lx)&" , T"&Integer'Image(element.Tx); 
    end Image_TQ;

    function Image_Variable(element : Variable) return String is
    begin
        return element.intitule.All&" : "&element.typeV.All&" := "&Integer'Image(element.value); 
    end Image_Variable;

    function Image_Label(element : Label) return String is
    begin
        return "L"&Integer'Image(element.Lx)&" : CP "&Integer'Image(element.CP); 
    end Image_Label;

    FUNCTION TToString(el : T_String) RETURN String IS
    BEGIN
        RETURN el.All;
    END TToString;

    FUNCTION StringToT(el : String) RETURN T_String IS
        result : T_String;
    BEGIN
        result := new String'(el);
        RETURN result;
    END StringToT;

end object;