program mdm;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type

  ainteger = array of integer;

// READ FILE ===================================================
procedure ReadFile(var f: Text; var B: ainteger);
var
  n, i: integer;
begin
  i := 0;

  while not Eof(f) do begin
    while not Eoln(f) do begin
      read(f, n);
      setlength(B,i+2);
      B[i] := n;
      i := i + 1;
    end;
  end;
end;
// =============================================================

// ALGORITHM ===================================================
function middelste_derde_macht(A: array of Integer): Integer;
begin
  result := 3;
end;
// =============================================================

var
  A: ainteger;
  dm: Integer;
  inFile: Text;
  outFile: Text;

begin
  { TODO -oUser -cConsole Main : Insert code here }

  // Try to open the Test.txt file for writing to
  AssignFile(inFile, 'invoer.txt');
  AssignFile(outFile, 'uitvoer.txt');
  Rewrite(outFile);
  Reset(inFile);

  ReadFile(inFile, A);
  dm := middelste_derde_macht(A);

  write(dm);
  write(outFile, dm);

  CloseFile(inFile);
  CloseFile(outFile);
end.
 