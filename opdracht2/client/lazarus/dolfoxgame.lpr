program dolfoxgame;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, dolfox, LResources;

{$IFDEF WINDOWS}{$R dolfoxgame.rc}{$ENDIF}

begin
  {$I dolfoxgame.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

