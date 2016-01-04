program foxdol2;

uses
  Forms,
  main in 'main.pas' {Form1},
  player in 'player.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
