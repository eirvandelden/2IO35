unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,client, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    TCPClient: TIdTCPClient;
    ebIP: TEdit;
    ebPort: TEdit;
    btConnect: TButton;
    lblIP: TLabel;
    lblClient: TLabel;
    btDisconnect: TButton;
    ebCommand: TEdit;
    lblCommand: TLabel;
    messages: TMemo;
    btSend: TButton;
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btSendClick(Sender: TObject);
    procedure TCPClientDisconnected(Sender: TObject);
    procedure TCPClientConnected(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Thread = class(TThread)
  private
    TCPClient: TIdTCPClient;
  public
    constructor Create(ACreateSuspended: boolean; AIdTCPClient: TIdTCPClient);
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  link: Thread;

implementation

constructor Thread.Create(ACreateSuspended: boolean; AIdTCPClient: TIdTCPClient);
begin
  inherited Create(ACreateSuspended);
  TCPClient := AIdTCPClient;
  FreeOnTerminate := True;
end;

procedure Thread.Execute;
begin
  while true do
    if TCPClient.Connected then
    begin
      Form1.messages.Lines.Add(TCPClient.ReadLn());
      // lijkt mij de bedoeling dat er hier een parser wordt ingebouwd!
    end;
end;

{$R *.dfm}

procedure TForm1.btConnectClick(Sender: TObject);
begin
  TCPClient.Host := ebIP.Text;
  TCPClient.Port := strtoint(ebPort.Text);
  ebIP.Enabled := False;
  ebPort.Enabled := False;
  TCPClient.Connect();
  btDisconnect.Enabled := True;
  link := Thread.Create(False, TCPClient);
end;

procedure TForm1.btDisconnectClick(Sender: TObject);
begin
  link.Terminate;
  while TCPClient.Connected do
  begin
    TCPClient.Disconnect;
    TCPClient.DisconnectSocket;
  end;
  ebIP.Enabled := True;
  ebPort.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  messages.Clear;
end;

procedure TForm1.btSendClick(Sender: TObject);
begin
  if TCPClient.Connected then
  begin
    TCPClient.WriteLn(ebCommand.Text);
    messages.Lines.Add('> ' + ebCommand.Text);
    ebCommand.Text := '';
  end
  else ShowMessage('Not connected!');
end;

procedure TForm1.TCPClientDisconnected(Sender: TObject);
begin
  // on disconnect
end;


procedure TForm1.TCPClientConnected(Sender: TObject);
begin
  // while connect
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCPClient.OnDisconnected(Sender);
end;

end.
