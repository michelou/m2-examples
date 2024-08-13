MODULE merge;

FROM InOut IMPORT WriteString, WriteLn(*, WriteInt*), ReadInt;
FROM Storage IMPORT ALLOCATE; (* NEW *)

FROM Liste IMPORT ListenPtr, anhaengen, ausgabe, sortiertEinfuegen;

(* mergeSort

   Problem:
   Gegeben sind zwei sortierte Folgen aus INTEGER-Zahlen 

   gesucht ist eine dritte sortierte Folge, die aus einer Mischung der
   gegebenen beiden Folgen erzeugt werden soll
*)
PROCEDURE mergeSort(a, b: ListenPtr; VAR c: ListenPtr);
VAR cPtr, hilf: ListenPtr;
BEGIN
  (* Da c neu erzeugt werden soll, muss die Liste zuerest auf NIL
     gesetzt werden 
  *)
  c := NIL;

  (* Initialisieren des Pointers cPtr, der immer auf das letzte Element der
     zu erzeugenden Liste c zeigt. An ihn wird das neachstgroessere 
     Element angehaengt, dann wird er eins weitergesetzt, damit er
     wieder auf dem letzten Element steht. Da c ein VAR-Parameter ist,
     kann man nicht c selbst dafuer nehmen -- dann waere nach dem
     Anhaengend des 2. Elements der Anfang der Liste verloren. 
     Bei a und b ist es nicht noetig, solche "Laufpointer"
     einzusetzen, da die Aenderungen an a bzw. b waehrend dieser Prozedur
     im aufrufenden Programm nicht wirksam werden (Call by value-Parameter)
  *)
  cPtr := c;

  (* Falls eine der beiden Listen leer ist, wird die andere kopiert
     und zurueckgegeben *)
  WHILE a # NIL DO

     IF b = NIL THEN
        anhaengen(c, a);
        RETURN;
     ELSE
        (* Neues Element anlegen *)
        NEW(hilf);
        hilf^.next := NIL;
      
        (* Vergleich der beiden Kopfwerte und nach Kopieren des
           kleineren Weitersetzen des entsprechenden Listenzeigers *)
        IF a^.inhalt < b^.inhalt THEN
           hilf^.inhalt := a^.inhalt;
           a := a^.next;
        ELSE
           hilf^.inhalt := b^.inhalt;
           b := b^.next;
        END;
        
        (* Nur beim ersten Element: Falls c vorher leer war, 
           muss das neue Element als Anker dienen:
           c    --> NIL
           cPtr --> NIL

           hilf --> +---+
                    | x |
                    +---+
                    | --+--> NIL
                    +---+

           ==> hilf --> +---+
                 c  --> | x |
               cPtr --> +---+
                        | --+--> NIL
                        +---+
        *)

        IF c = NIL THEN
             c := hilf;
             cPtr := c;

        (* Ansonsten Element anhaengen und den Zeiger auf das letzte 
           Element (cPtr) dorthin setzen
             c  --> +---+      +-> +---+ <-- cPtr   hilf --> +---+
                    | x |      |   | y |                     | z |
                    +---+   ...    +---+                     +---+
                    | --+--        | --+--> NIL              | --+--> NIL
                    +---+          +---+                     +---+

        ==>  c  --> +---+      +-> +---+    (* 2 *) cPtr --> +---+ <--hilf
                    | x |      |   | y |                 +-> | z |
                    +---+   ...    +---+                 |   +---+
                    | --+--        | --+-----------------+   | --+--> NIL
                    +---+          +---+      (* 1 *)         +---+

        *)
        ELSE
             cPtr^.next := hilf; (* 1 *)
             cPtr:=cPtr^.next;   (* 2 *)
        END; 
   
     END;     
  END;

  (* Nach der While-Schleife steht in a nichts mehr drin - falls also
     in b noch etwas steht, wird das einfach an c angehaengt 
  *)
  IF b # NIL  THEN
     anhaengen(c, b);
  END;

END mergeSort;

(* Hauptprogramm 

   Erzeugt durch Benutzereingaben zwei Listen, die durch mergeSort zu
   einer dritten Listen sortiert werden. Alle Listen werden ausgegeben. 
*)
VAR schluessel : INTEGER;
    sortierteListe1,sortierteListe2, sortierteListe3 : ListenPtr;

BEGIN
    WriteString("Liste a "); WriteLn;
    REPEAT 
       WriteString("Bitte einzufuegende Zahl eingeben (0 fuer Abbruch): ");
       ReadInt(schluessel);
       IF schluessel # 0 THEN
           sortiertEinfuegen(sortierteListe1, schluessel);
       END;
    UNTIL schluessel = 0;

    WriteLn; WriteString("Liste b "); WriteLn;
    REPEAT 
        WriteString("Bitte einzufuegende Zahl eingeben (0 fuer Abbruch): ");
        ReadInt(schluessel);
        IF schluessel # 0 THEN
            sortiertEinfuegen(sortierteListe2, schluessel);
        END;
    UNTIL schluessel = 0;

    WriteString("          Liste a : ");
    ausgabe(sortierteListe1);
    WriteString("          Liste b : "); ausgabe(sortierteListe2);
    mergeSort(sortierteListe1, sortierteListe2, sortierteListe3);
    WriteString("gemischt: Liste c : "); ausgabe(sortierteListe3);
END merge. 
