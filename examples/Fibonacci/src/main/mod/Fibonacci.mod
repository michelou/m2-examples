MODULE Fibonacci;

FROM InOut IMPORT WriteCard, WriteLn, WriteString;

  (*
   * Time complexity: O(2^n)
   * Auxiliary space: O(n)
   *)
  PROCEDURE Fib(n: CARDINAL): CARDINAL;
  BEGIN
    IF n <= 1 THEN
      RETURN n; 
    END;

    RETURN Fib(n - 1) + Fib(n- 2);
  END Fib;

  (*
   * Time complexity : O(n)
   * Auxiliary space : O(n)
   *)
  PROCEDURE TailRecFib(n: CARDINAL): CARDINAL;
    PROCEDURE Helper(i: CARDINAL; a: CARDINAL; b: CARDINAL): CARDINAL;
    BEGIN
      IF i = 0 THEN
        RETURN a;
      ELSIF i = 1 THEN
        RETURN b;
      ELSE
        RETURN Helper(i - 1, b, a + b);
      END;
    END Helper;
  BEGIN
    RETURN Helper(n, 0, 1);
  END TailRecFib;

  (*
   * Time complexity : O(n)
   * Auxiliary space : O(1)
   *)
  PROCEDURE IterFib(n: CARDINAL): CARDINAL;
    VAR i, curr, prev1, prev2: CARDINAL;
  BEGIN
    IF n <= 1 THEN
      RETURN n;
    END;

    curr := 0;
    prev1 := 1;
    prev2 := 0;
    FOR i := 2 TO n DO
      curr := prev1 + prev2;
      prev2 := prev1;
      prev1 := curr;
    END;

    RETURN curr;
  END IterFib;

  (*
   * Time complexity : O(log(n))
   * Auxiliary space : O(log n)
   *)
  PROCEDURE MatrixFib(n: CARDINAL): CARDINAL;
    VAR mat1, mat2: ARRAY [0..1], [0..1] OF CARDINAL;

    (* Function to multiply two 2x2 matrices *)
    PROCEDURE Multiply(VAR mat1: ARRAY OF ARRAY OF CARDINAL;
                           mat2: ARRAY OF ARRAY OF CARDINAL);
      VAR w, x, y, z: CARDINAL;
    BEGIN
      (* Perform matrix multiplication *)
      x := mat1[0, 0] * mat2[0, 0] + mat1[0, 1] * mat2[1, 0];
      y := mat1[0, 0] * mat2[0, 1] + mat1[0, 1] * mat2[1, 1];
      z := mat1[1, 0] * mat2[0, 0] + mat1[1, 1] * mat2[1, 0];
      w := mat1[1, 0] * mat2[0, 1] + mat1[1, 1] * mat2[1, 1];

      (*  Update matrix mat1 with the result *)
      mat1[0, 0] := x;
      mat1[0, 1] := y;
      mat1[1, 0] := z;
      mat1[1, 1] := w;
    END Multiply;

    (* Function to perform matrix exponentiation *)
    PROCEDURE MatrixPower(VAR mat1: ARRAY OF ARRAY OF CARDINAL; n: CARDINAL);
    BEGIN
      (*  Base case for recursion *)
      IF (n = 0) OR (n = 1) THEN
        RETURN;
      END;

      (* Initialize a helper matrix *)
      mat2[0, 0] := 1; mat2[0, 1] := 1;
      mat2[1, 0] := 1; mat2[1, 1] := 0;

      MatrixPower(mat1, n DIV 2);

      (* Square the matrix mat1 *)
      Multiply(mat1, mat1);

      (* If n is odd, multiply by the helper matrix mat2 *)
      IF (n MOD 2) <> 0 THEN
        Multiply(mat1, mat2);
      END;
    END MatrixPower;

  BEGIN (* MatrixFib *)
    IF n <= 1 THEN
      RETURN n;
    END;

    (* Initialize the transformation matrix *)
    mat1[0, 0] := 1; mat1[0, 1] := 1;
    mat1[1, 0] := 1; mat1[1, 1] := 0;

    (* Raise the matrix mat1 to the power of (n - 1) *)
    MatrixPower(mat1, n - 1);

    (* The result is in the top-left cell of the matrix *)
    RETURN mat1[0, 0];
  END MatrixFib;

VAR
  i: CARDINAL;

BEGIN
  WriteString("Recursive Fibonacci function"); WriteLn;
  FOR i := 0 TO 8 DO 
    WriteCard(i, 3);
    WriteCard(Fib(i), 12);
    WriteLn
  END;
  WriteLn;

  (* See https://www.geeksforgeeks.org/tail-recursion-fibonacci/ *)
  WriteString("Tail recursive Fibonacci function"); WriteLn;
  FOR i := 0 TO 8 DO 
    WriteCard(i, 3);
    WriteCard(TailRecFib(i), 12);
    WriteLn
  END;
  WriteLn;

  (* See https://www.geeksforgeeks.org/program-for-nth-fibonacci-number/ *)
  WriteString("Iterative Fibonacci function"); WriteLn;
  FOR i := 0 TO 8 DO 
    WriteCard(i, 3);
    WriteCard(IterFib(i), 12);
    WriteLn
  END;
  WriteLn;

  (* See https://www.geeksforgeeks.org/program-for-nth-fibonacci-number/ *)
  WriteString("Matrix Fibonacci function"); WriteLn;
  FOR i := 0 TO 8 DO
    WriteCard(i, 3);
    WriteCard(MatrixFib(i), 12);
    WriteLn
  END
END Fibonacci.
