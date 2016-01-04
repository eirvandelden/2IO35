program Input (Output);

uses
    Process;

var
    F: text;
    c: char;
    i: integer;
    mid: integer;

begin
    if (ParamCount <> 1) then begin
        WriteLn('Please specify an input file');
        Exit
    end;

    Assign (F, ParamStr (1));
    Reset (F);

    while not EOF (F) do begin
        Read (F, i);
        Read (F, c);
        Add (i);
    end;
    Sort ();
    mid := Median ();
    WriteLn(mid);


    Close (F);
end.
