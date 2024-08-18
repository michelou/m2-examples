(*
 * Written by Andrew Cadach
 *
 * Recursive (extremely uneficient:-) implementation of factorial
 *
 *                     n * (n-1)!, n <> 0
 * By definition, n! = 
 *                     1, n = 0
 *
 *)

MODULE bf;

IMPORT Terminal2;

VAR i, r: CARDINAL;

PROCEDURE f (n: CARDINAL): CARDINAL;
BEGIN
  IF n=0 THEN RETURN 1 END;
  RETURN n * f (n-1);
END f;

BEGIN
  i := 0;
  LOOP
    r := f(i);
    Terminal2.WriteString ("The factorial of ");
    Terminal2.WriteCard (i, 2);
    Terminal2.WriteString (" is ");
    Terminal2.WriteCard (r, 0);
    Terminal2.WriteLn;
    INC (i,5)
  END;
END bf.
