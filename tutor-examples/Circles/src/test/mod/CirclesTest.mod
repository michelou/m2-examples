MODULE CirclesTest;

FROM Circles   IMPORT AreaOfCircle, PerimeterOfCircle;
FROM Terminal2 IMPORT WriteString, WriteReal, WriteLn;

VAR Area, Perim, Radius : REAL;

BEGIN
    Radius := 5.0;

    AreaOfCircle(Radius, Area);
    WriteString("Area of circle: "); WriteReal(Area, 5); WriteLn;

    PerimeterOfCircle(Radius, Perim);
    WriteString("Perimeter of circle: "); WriteReal(Perim, 5); WriteLn;
END CirclesTest.
