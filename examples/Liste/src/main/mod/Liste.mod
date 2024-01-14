(* Einfuehrung von Pointern, Beispiel an Listenverarbeitung 

   Motivation: Bisher waren immer nur statische Variablen (ARRAYs) 
   moeglich, wo von vornherein die Zahl der Elemente feststehen muss.
   Im allgemeinen ist diese Zahl zur Compilezeit des Programms nicht
   bekannt (z.B. Listen von Studierenden), so dass eine Moeglichkeit
   gefunden werden muss, dynamische Strukturen zu verwalten =>
   Pointer und Listen/Baeume, die dynamisch wachsen

   Vortragsuebung 05.05.97, Informatik II (sowie Grundlage fuer das 5.
   Uebungsblatt)

   U. Masermann, IfIs

*)
IMPLEMENTATION MODULE Liste;

FROM InOut IMPORT WriteString, WriteLn, WriteInt; (*, ReadInt;*)
FROM Storage IMPORT ALLOCATE(*, DEALLOCATE*);

(* Datenstruktur der Liste (einfach verkettete Liste) *)
TYPE ListenPtr = POINTER TO Liste;
     Liste = RECORD
               inhalt: INTEGER;
               next:  ListenPtr; (* = POINTER TO Liste *)
             END;

PROCEDURE anhaengen(VAR nach: ListenPtr; von: ListenPtr);
VAR hilf, hilfNach: ListenPtr;
BEGIN
  IF von = NIL THEN
    RETURN;
  END;
  hilfNach := NIL;
  hilf := nach;
  WHILE hilf # NIL DO
    hilfNach := hilf;
    hilf := hilf^.next;
  END;
  (* Hier sind `hilf` and `von` nicht leer *)
  REPEAT
    NEW(hilf);
    hilf^.inhalt := von^.inhalt;
    hilf^.next := NIL;
    IF hilfNach # NIL THEN
      hilfNach^.next := hilf;
    END;
    hilfNach := hilf;
    von := von^.next;
  UNTIL von = NIL;
END anhaengen;

(* Ausgabe der Werte einer Liste, angefangen vom Kopf *)
PROCEDURE ausgabe(reihe: ListenPtr);    
BEGIN
  WHILE reihe # NIL DO
    WriteInt(reihe^.inhalt, 5); WriteString(" ");
    reihe := reihe^.next;
  END;
  WriteLn;
END ausgabe;

(* einfuegen: Fuegt den gegebenen Wert als neues Element an den Kopf der Liste
   "reihe" ein *)
PROCEDURE einfuegen(VAR reihe: ListenPtr; wert: INTEGER);
VAR hilf : ListenPtr;
BEGIN
  (* als erstes neuen Record erzeugen, der den Wert aufnimmt *)
  NEW(hilf);

  (* Belegen der einzelnen Komponenten *)
  hilf^.inhalt := wert;
  hilf^.next   := NIL;

  (* den Fall der leeren Liste behandeln - dann wird der Reihe einfach
     das neu erzeugte Element zugewiesen *)
  (* Anmerkung: Diese Fallunterscheidung ist gar nicht noetig!! Dient
     aber der Veranschaulichung *)
  IF reihe = NIL THEN
     reihe := hilf;
     RETURN;
  END;

  (* Ansonsten: Anhaengen an den Kopf der Liste, d.h. das neu erzeugte
     Element zeigt mit "next" auf "reihe" und wird dann zum neuen Kopf der 
     Reihe
  *)
  hilf^.next := reihe;
  reihe := hilf; 
END einfuegen;

PROCEDURE sortiertEinfuegen(VAR reihe: ListenPtr; wert: INTEGER);
VAR hilf, hilfReihe: ListenPtr;
BEGIN
  hilfReihe := NIL;
  hilf := reihe;
  WHILE (hilf # NIL) AND (hilf^.inhalt < wert) DO
    hilfReihe := hilf;
    hilf := hilf^.next;
  END;
  NEW(hilf);
  hilf^.inhalt := wert;
  hilf^.next := hilfReihe^.next;
  hilfReihe^.next := hilf;
END sortiertEinfuegen;

(* Hauptprogramm 
   Soll eine Liste erzeugen (unsortiert bzw. sortiert), und diese
   ausgeben 
*)
(*
VAR schluessel : INTEGER;
    meineListe : ListenPtr;
BEGIN
  (* Schleife laufen lassen, bis keine Werte fuer ein neues
     Listenelement mehr eingegeben werden (Abbruch mit 0, d.h der Wert 0
     kann nicht eingefuegt werden) 
  *)
  meineListe := NIL;
  REPEAT 
    WriteString("Bitte einzufuegende Zahl eingeben (0 fuer Abbruch): ");
    ReadInt(schluessel);
    IF schluessel # 0 THEN
      einfuegen(meineListe, schluessel);
      (*** 5. Uebungsblatt                                          ***)
      (*** Hier soll der Aufruf fuer das sortierte Einfuegen stehen ***)
      (*** entweder "einfuegen" ersetzen oder eine andere           ***)
      (*** Listenvariablen verwenden                                ***)
    END;
  UNTIL schluessel = 0;
  anhaengen(meineListe, meineListe);

  (* Und nun die vollstaendige Liste ausgeben lassen *)
  ausgabe(meineListe);
*)
END Liste.
