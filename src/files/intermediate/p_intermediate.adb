with p_liste; use p_liste;

package body p_intermediate is

    PROCEDURE Inserer_L(instruction : IN String) IS
        existing : String
    BEGIN
        Inserer(instruction);
        CP := CP + 1;
    END Inserer_L;

    PROCEDURE Inserer(instruction : IN String) IS
    existing : String
    BEGIN
        existing := "";
        IF T_SOURCE.instructions(CP) != NULL THEN
            existing := T_SOURCE.instructions(CP);
            Modifier(existing&instruction,CP);
        ELSE
            ajouter(T_SOURCE.instructions,instruction);
        END IF;
    END Inserer;

    Procedure Modifier(instruction : IN String ; ligne : IN Integer) IS
    BEGIN
            modifier(T_SOURCE.instructions,ligne;instruction);
    END Modifier;
    

end p_intermediate;