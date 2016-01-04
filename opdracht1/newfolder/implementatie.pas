unit implementatie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  A: array of integer;

implementation

procedure Add(var n: Integer);
var
  i : Integer;
begin
  i := 0;
  while ( Power(i,3) < abs(n) ) do i := i + 1;
  if (Power(i,3) = abs(n)) then begin
    i := 0;
    while ( i < length(A)) and ( A[i] <> n ) do i := i + 1;
    if (i = length(A)) then
    begin
      setlength(A, length(A)+1);
      A[length(A)-1] := n;
    end;
  end;
end;

procedure Sort;
  var i,
      j,
      key: Integer;
begin
  for j:= 1 to length(A)-1 do
  begin
    key := A[j];
    i := j - 1;
    while  (i>=0) and (A[i] > key) do
    begin
      A[i+1] := A[i];
      i := i - 1;
    end;
    A[i+1] := key;
  end;
end;

function Median(): Integer;
begin
  if (length(A)=0) then result := -1
  else result := A[floor(length(A)/2)];
end;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  setlength(A, 2);
  A[0] := 3;
  A[1] := 1;
  label1.Caption := inttostr(Median);
end;

end.
