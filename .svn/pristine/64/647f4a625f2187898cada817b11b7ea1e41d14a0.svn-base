unit server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, StdCtrls;

type
  TForm1 = class(TForm)
    TCPServer: TIdTCPServer;
    btStart: TButton;
    btStop: TButton;
    Memo1: TMemo;
    editBroadcast: TEdit;
    btnBroadcast: TButton;
    Label1: TLabel;
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure TCPServerConnect(AThread: TIdPeerThread);
    procedure TCPServerDisconnect(AThread: TIdPeerThread);
    procedure TCPServerNoCommandHandler(ASender: TIdTCPServer;
      const AData: String; AThread: TIdPeerThread);
    procedure TCPServerMessagesFromBoard(rec, msgtype: Char; msg: String);
    procedure FormCreate(Sender: TObject);
    procedure btnBroadcastClick(Sender: TObject);
    procedure debug(msg: String; id: cardinal);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DPlayerID,
  FPlayerID,
  DViewerId,
  FViewerID: Cardinal;
  PlayerID: Char;
  MSGType: String;
  // vars for testing purposes
  NoPlayers : Integer;

implementation

{$R *.dfm}

procedure TForm1.debug(msg: String; id: cardinal);
begin
  Memo1.Lines.Add('OUTGOING: ' + msg);
  Memo1.Lines.Add('TO: ' + inttostr(id));
  Memo1.Lines.Add(' ');
end;

function NotRegistered(id: Cardinal):Boolean;
begin
  if DPlayerID = id then result := False
  else if FPlayerID = id then result := False
  else if DViewerID = id then result := False
  else if FViewerID = id then result := False
  else result := True;
end;

function Join():Char;
begin
  if NoPlayers = 0 then begin result := 'F'; NoPlayers := NoPlayers + 1 end
  else if NoPlayers = 1 then begin result := 'D'; NoPlayers := NoPlayers + 1 end
  else begin result := 'R'; end
end;

function TryMove(PID: Char; a,b,c,d : Integer): Char;
begin
  result := 'F';
end;

function UpdateViews(): String;
begin
  result :=
'WLWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+
'WWWWWWWWWWWWWWWWWWWWWW';
end;

procedure TForm1.btStartClick(Sender: TObject);
begin
  TCPServer.Active := True;
  NoPlayers := 0;
end;

procedure TForm1.btStopClick(Sender: TObject);
begin
  TCPServer.Active := False;
end;

procedure TForm1.TCPServerConnect(AThread: TIdPeerThread);
begin
//  AThread.Connection.WriteLn('Connected to server!');
  Memo1.Lines.Add('CONNECTED: ' + inttostr(AThread.ThreadID));
  Memo1.Lines.Add('');
  end;

procedure TForm1.TCPServerDisconnect(AThread: TIdPeerThread);
begin
  Memo1.Lines.Add('DISCONNECTED: ' + inttostr(AThread.ThreadID));
  Memo1.Lines.Add('');
//  AThread.Connection.WriteLn('Disconnected from server! Have a nice life...');
end;

procedure TForm1.TCPServerNoCommandHandler(ASender: TIdTCPServer;
  const AData: String; AThread: TIdPeerThread);
var A : Array[0..3] of integer; // for getting coorindates in a trymove
    i,
    j : integer;
    tmp : string;
begin
  // debugging in memo ^_^
  Memo1.Lines.Add('INCOMING: ' + AData);
  Memo1.Lines.Add('FROM: ' + inttostr(AThread.ThreadID));
  Memo1.Lines.Add(' ');

  // message type is determinded by the first three characters
  MSGType := AData[1] + AData[2] + AData[3];

  // incoming message from P, D or F
  case AData[1] of

  // new player join request
  'P' : begin
          if (AData = 'PBJ') and NotRegistered(AThread.ThreadID) then
          begin
            PlayerID := Join();
            Case PlayerID of
              'F' : begin
                      FPlayerID := AThread.ThreadID;
                      // For testing purposes, the message for viewer joining
                      // weren't properly specified:
                      FViewerID := Athread.ThreadID;
                      debug('BPT F', AThread.ThreadID);
                      AThread.Connection.WriteLn('BPT F');
                    end;
              'D' : begin
                      DPlayerID := AThread.ThreadID;
                      // For testing purposes, the message for viewer joining
                      // weren't properly specified:
                      DViewerID := Athread.ThreadID;
                      debug('BPT D', AThread.ThreadID);
                      AThread.Connection.WriteLn('BPT D');
                    end;
              'R' : begin
                      debug('BPT R', AThread.ThreadID);
                      AThread.Connection.WriteLn('BPT R');
                    end;
            end;
          end;
        end; // end new player messages

  // messages from Dolphin player
  'D' : begin
          if AThread.ThreadID = DPlayerID then
          begin
            if MSGType = 'DBM' then
            begin
              // TODO: een coordinaat kan ook uit meerdere cijfers bestaan,
              //       dus wat hieronder staat klopt niet. We moeten de 4
              //       integers die deze string bevatten eruithalen...
              TryMove('D', strtoint(AData[5]), strtoint(AData[7]),
                          strtoint(AData[9]), strtoint(AData[11]));
              TCPServerMessagesFromBoard('E', 'B', UpdateViews);
            end
            else if MSGType = 'DBR' then
            begin
              TCPServerMessagesFromBoard('E', 'B', UpdateViews);
              //AThread.Connection.WriteLn(UpdateViews);   // might not go as planned? needs to go to E or G?
            end
          end;
        end; // end messages from D

  // messages from Fox player (almost identical to dolphin player)
  'F' : begin
          if AThread.ThreadID = FPlayerID then
          begin
            if MSGType = 'FBM' then
            begin
              // TODO: een coordinaat kan ook uit meerdere cijfers bestaan,
              //       dus wat hieronder staat klopt niet. We moeten de 4
              //       integers die deze string bevatten eruithalen...
              TryMove('F', strtoint(AData[5]), strtoint(AData[7]),
                          strtoint(AData[9]), strtoint(AData[11]));
              TCPServerMessagesFromBoard('G', 'B', UpdateViews);
            end
            else if MSGType = 'FBR' then
            begin
              TCPServerMessagesFromBoard('G', 'B', UpdateViews);
              //AThread.Connection.WriteLn(UpdateViews);  // might not go as planned? needs to go to E or G?
            end
          end;
        end; // end messages from F
  end; // end case
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
end;


procedure TForm1.TCPServerMessagesFromBoard(rec, msgtype: Char; msg: String);
var clients: TList;
    i: Integer;
    recID: Cardinal;
begin
    // built list with all connected clients
    clients:=TCPServer.Threads.LockList;

    // check which client we need to contact
    case rec of
      'D' : recid := DPlayerID;
      'E' : recid := DViewerID;
      'F' : recid := FPlayerID;
      'G' : recid := FViewerID
    end;

    // now find the threadid belonging to that client
    for i:=0 to clients.Count - 1 do
    begin
      if TIDPeerThread(clients[i]).ThreadID = recid then
      begin
        case msgtype of
          // and send what we want to sent,
          // only messages of type B and S need extra information
          'B' : TIdPeerThread(clients[i]).Connection.WriteLn('B' + rec + 'B' + msg);
          'F' : TIdPeerThread(clients[i]).Connection.WriteLn('B' + rec + 'F');
          'N' : TIdPeerThread(clients[i]).Connection.WriteLn('B' + rec + 'N');
          'S' : TIdPeerThread(clients[i]).Connection.WriteLn('B' + rec + 'S' + msg);
        end;
      end;
    end;
    // needs to be done apparently
    TCPServer.Threads.UnlockList;
end;

procedure TForm1.btnBroadcastClick(Sender: TObject);
var clients: TList;
    i: integer;
begin
  clients :=  TCPServer.Threads.LockList;
  for i:= 0 to clients.Count - 1 do
  begin
    TidPeerThread(clients[i]).Connection.WriteLn(editBroadcast.Text);
  end;
  editBroadCast.Text := '';
end;

procedure getCoords(inp: string);
var tmp2: string;
    i,
    j : integer;
begin
  i := 1;
  while i <= length(inp) do
  begin
    if inp[i] in ['0'..'9'] then
    begin
      j := i;
      tmp2 := '';
      while (inp[j] in ['0'..'9']) and (j <= length(inp)) do
      begin
        i := j;
        tmp2 := tmp2 + inp[j];
        j := j + 1;
      end;
      Memo1.Lines.Add(tmp2);
    end;
    i := i + 1;
  end;

end.
