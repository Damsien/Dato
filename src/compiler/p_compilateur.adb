WITH struct.pile;

procedure p_compilateur is

    type TQ is record
        Lx : String(1..4);
        Tx : String(1..4);
    end record;

    PACKAGE P_PILE_TQ IS NEW p_pile(T_ELEMENT => TQ, Image => Image);
    USE P_PILE_TQ;

    record1 : TQ := new TQ'("L1","T2");

begin


    Empiler(record1);


end p_compilateur;