package body object is

    function Image_TQ(element : TQ) return String is
    begin
        return "L"&Integer'Image(element.Lx)&" , T"&Integer'Image(element.Tx); 
    end Image_TQ;

    function Image_Variable(element : Variable) return String is
    begin
        return "T"&Integer'Image(element.intitule)&" : "&element.typeV&" := "&Integer'Image(element.value); 
    end Image_Variable;

    function Image_Label(element : Label) return String is
    begin
        return "L"&Integer'Image(element.Lx)&" : CP "&Integer'Image(element.CP); 
    end Image_Label;

end object;