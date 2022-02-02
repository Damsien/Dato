package op_string is

    FUNCTION removeSubString(s: String ; sToRm: String) RETURN String;

    FUNCTION Upper_Case (S : String) RETURN String;

    FUNCTION replaceString(s: String ; pattern_to_be_replaced: String ; replace_pattern: String) RETURN String;

    FUNCTION removeSingleSpace(s: IN String ; l: IN Integer) RETURN String;

    FUNCTION removeSpaces(s: IN String ; l: IN Integer) RETURN String;

    FUNCTION clarifyString(s: IN String) RETURN String;

    FUNCTION TrimI(e : Integer) RETURN String;

end op_string;