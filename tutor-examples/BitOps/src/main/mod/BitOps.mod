IMPLEMENTATION MODULE BitOps;

(*            Coptright (c) 1987 - Coronado Enterprises            *)

(* The logical operations performed here are done by converting    *)
(* the input CARDINAL values into type BITSET and using the        *)
(* resulting properties of the BITSET type to perform the required *)
(* operations.                                                     *)

PROCEDURE LogicalAND(In1, In2 : CARDINAL) : CARDINAL;
VAR Set1, Set2, Result : BITSET;
BEGIN
   INCL(Set1, In1);
   INCL(Set2, In2);
   Result := Set1 * Set2;  (* Result := BITSET(In1) * BITSET(In2); *)
   RETURN VAL(CARDINAL, Result);
END LogicalAND;


PROCEDURE LogicalOR(In1, In2 : CARDINAL) : CARDINAL;
VAR Set1, Set2, Result : BITSET;
BEGIN
   INCL(Set1, In1);
   INCL(Set2, In2);
   Result := Set1 + Set2;  (* Result := BITSET(In1) + BITSET(In2); *)
   RETURN CARDINAL(Result);
END LogicalOR;


PROCEDURE LogicalXOR(In1, In2 : CARDINAL) : CARDINAL;
VAR Set1, Set2, Result : BITSET;
BEGIN
   INCL(Set1, In1);
   INCL(Set2, In2);
   Result := Set1 / Set2;  (* Result := BITSET(In1) / BITSET(In2); *)
   RETURN CARDINAL(Result);
END LogicalXOR;


PROCEDURE LogicalNOT(In1 : CARDINAL) : CARDINAL;
VAR Set1, Set2, Result : BITSET;
BEGIN
   INCL(Set1, In1);
   INCL(Set2, 0177777B);
   Result := Set1 / Set2;  (* Result := BITSET(In1) / BITSET(0177777B); *)
   RETURN CARDINAL(Result);
END LogicalNOT;

END BitOps.
