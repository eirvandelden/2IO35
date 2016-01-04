unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,
  player;

type
  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    EditKey: TEdit;
    EditSelectionX: TEdit;
    EditSelectionY: TEdit;
    EditOccupant: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditIP: TEdit;
    EditPort: TEdit;
    ButtonConnect: TButton;
    ViewerClient: TIdTCPClient;
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure  DrawGrid1SelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ViewerClientConnected(Sender: TObject);
    procedure viewerSocketInput(msg: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Thread = class(TThread)
  private
    FIdTCPClient: TIdTCPClient;
  public
    constructor Create(ACreateSuspended: boolean; AIdTCPClient: TIdTCPClient);
    procedure Execute; override;
  end;

  TCoordinate =
    record
      X: 0..49;
      Y: 0..49;
    end;
  TBoardSize = 10..50;
  TBoardTile =
    record
      TileBackground: (Land, Water);
      TileForeground: (Fox, Dolphin, Empty);
    end;
  TPlayer = (FoxPlayer, DolphinPlayer);

var
  Form1: TForm1;
  FPlayer: TPlayer;
  FS: TCoordinate;
  FBoard: array [0..49,0..49] of TBoardTile;
  bmpland, bmpwater, bmpfoxland, bmpfoxwater, bmpdolphinland, bmpdolphinwater: TBitmap;
  link : Thread;

implementation

{$R *.dfm}

constructor Thread.Create(ACreateSuspended: boolean;
                                  AIdTCPClient: TIdTCPClient);
begin
  inherited Create(ACreateSuspended);
  FIdTCPClient := AIdTCPClient;
  FreeOnTerminate := True;
end;

procedure Thread.Execute;
begin
  while True do
    if FIdTCPClient.Connected then
    socketInput(FidTCPClient.ReadLn(''));
end;

procedure TForm1.viewerSocketInput(msg: String);
begin
  case msg[3] of
    // types of incoming messages
    'B':  begin
            // TODO: procedure to draw a new board!
            //       this belongs in the unit main but needs to be called
            //       here where we process only messages, strange?
            ShowMessage('A board is received!');
          end;
    'F':  begin
          // failed move message?
            ShowMessage('Failed to process your last move!')
          end;
    'S':  begin
          // team won message
            if msg[5] = TeamId then ShowMessage('You won!')
            else ShowMessage('You lost!');
          end;
    'T':  begin
          // team announce message
            case msg[5] of
              'F':  begin
                      ShowMessage('You are leader of the foxes!');
                      TeamID := msg[5];
                    end;
              'D':  begin
                      ShowMessage('You are leader of the dolphins!');
                      TeamID := msg[5];
                    end;
              'R':  begin
                      ShowMessage('Game was already full!');
                    end;
            end;
          end;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
// aRect: TRect;
 i,j: Integer;
begin
  bmpwater := TBitmap.Create;
  bmpland := TBitmap.Create;
  bmpfoxland := TBitmap.Create;
  bmpfoxwater := TBitmap.Create;
  bmpdolphinland := TBitmap.Create;
  bmpdolphinwater := TBitmap.Create;
  bmpwater.LoadFromFile('images/water.bmp');
  bmpland.LoadFromFile('images/land.bmp');
  bmpfoxland.LoadFromFile('images/fox_land.bmp');
  bmpfoxwater.LoadFromFile('images/fox_water.bmp');
  bmpdolphinland.LoadFromFile('images/dolphin_land.bmp');
  bmpdolphinwater.LoadFromFile('images/dolphin_water.bmp');

     for i := 0 to 49 do begin
         for j := 0 to 49 do begin
             with FBoard[i][j] do begin

                  if i < j then
                     TileBackground := Water
                  else
                     TileBackground := Land;

                  TileForeground := Empty;
             end;
         end;
     end;
         for i := 0 to 49 do begin
                FBoard[i][i].TileBackground := Water;
                FBoard[i][i].TileForeground := Empty;
         end;
     FBoard[20][30].TileForeGround := Dolphin;
     FBoard[20][20].TileForeGround := Dolphin;
     FBoard[21][21].TileForeGround := Fox;

     EditSelectionX.Text := IntToStr(DrawGrid1.Col);
     EditSelectionY.Text := IntToStr(DrawGrid1.Row);
     FS.X := DrawGrid1.Col;
     FS.Y := DrawGrid1.Row;
     FPlayer := FoxPlayer;
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var //jpg : TJPEGImage;
    rectt: TRect;
begin

  with FBoard[aRow][aCol] do begin
       rectt := DrawGrid1.CellRect(aCol, aRow);
       with DrawGrid1.Canvas do begin
            if TileForeGround = Empty then begin
               if TileBackground = Water then
                  StretchDraw(rectt, bmpwater)
               else
                  StretchDraw(rectt, bmpland);
            end
            else begin
                 if TileBackground = Water then begin
                    if TileForeGround = Dolphin then
                       StretchDraw(rectt, bmpdolphinwater);
                    if TileForeGround = Fox then
                       StretchDraw(rectt, bmpfoxwater);
                 end
                 else begin
                    if TileForeGround = Dolphin then
                       StretchDraw(rectt, bmpdolphinland);
                    if TileForeGround = Fox then
                       StretchDraw(rectt, bmpfoxland);
                 end;
            end;
       end;
  end;

end;

procedure TForm1.DrawGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
   FS.X := aCol;
   FS.Y := aRow;

   EditSelectionX.Text := IntToStr(FS.X);
   EditSelectionY.Text := IntToStr(FS.Y);

   case FBoard[FS.Y][FS.X].TileForeGround of
        Fox: EditOccupant.Text := 'Fox';
        Dolphin: EditOccupant.Text := 'Dolphin';
        Empty: EditOccupant.Text := 'Empty';
   end;
end;

procedure TForm1.ButtonConnectClick(Sender: TObject);
var
  success: boolean;
begin
  ViewerClient.Host := EditIP.Text;
  ViewerClient.Port := strtoint(EditPort.Text);
  while not(PlayerClient.Connected) do viewerClient.Connect();
  //  * send message a viewer wants to join <- done in PlayerClientConnected
  //  * function call to let the player join <- not possible due to specification fault
  connect(EditIP.Text, strtoint(EditPort.Text), success);
end;


procedure TForm1.ViewerClientConnected(Sender: TObject);
begin
  // link initialize
  link := Thread.Create(False, ViewerClient);
  // send join message
  ViewerClient.WriteLn('QBJ');
end;

end.
