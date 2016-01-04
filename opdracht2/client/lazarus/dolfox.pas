unit dolfox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    EditOccupant: TEdit;
    EditSelectionX: TEdit;
    EditKey: TEdit;
    EditMouse: TEdit;
    EditSelectionY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Occupant: TLabel;
    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;
    // Types
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
  FPlayer: TPlayer;
  FS: TCoordinate;
  Form1: TForm1;
  FBoard: array [0..49,0..49] of TBoardTile;
  bmpland, bmpwater, bmpfoxland, bmpfoxwater, bmpdolphinland, bmpdolphinwater: TBitmap;

implementation

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
 aRect: TRect;
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
         for j := 0 to 49 do begin
             with FBoard[i][i] do begin
                  TileBackground := Water;
                  TileForeground := Empty;
             end;
         end;
     FBoard[20][30].TileForeGround := Dolphin;
     FBoard[20][20].TileForeGround := Dolphin;
     FBoard[21][21].TileForeGround := Fox;

     EditSelectionX.Caption := IntToStr(DrawGrid1.Col);
     EditSelectionY.Caption := IntToStr(DrawGrid1.Row);
     FS.X := DrawGrid1.Col;
     FS.Y := DrawGrid1.Row;
     FPlayer := FoxPlayer;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     Case Key of
          37 : EditKey.Caption := 'left';
          38 : EditKey.Caption := 'up';
          39 : EditKey.Caption := 'right';
          40 : EditKey.Caption := 'down';
     End;
     Case Key of
          37 :
             // Left
             begin
                  if FS.X > 0 then begin
                     FBoard[FS.Y][FS.X - 1].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
                     FS.X := FS.X - 1;
                  end;

             end;
          38 :
             // Up
             begin
                  if FS.Y > 0 then
                     FBoard[FS.Y - 1][FS.X].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
                     FS.Y := FS.Y - 1;
             end;
          39 :
             // Right
             begin
                  if FS.X < 49 then
                     FBoard[FS.Y][FS.X + 1].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
                     FS.X := FS.X + 1;
             end;
          40 :
             // Down
             begin
                  if FS.Y < 49 then
                     FBoard[FS.Y + 1][FS.X].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
                     FS.Y := FS.Y + 1;
             end;
     End;
     DrawGrid1.Update;
     EditSelectionX.Caption := IntToStr(FS.X);
     EditSelectionY.Caption := IntToStr(FS.Y);

     case FBoard[FS.Y][FS.X].TileForeGround of
          Fox: EditOccupant.Caption := 'Fox';
          Dolphin: EditOccupant.Caption := 'Dolphin';
          Empty: EditOccupant.Caption := 'Empty';
     end;

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

   EditSelectionX.Caption := IntToStr(FS.X);
   EditSelectionY.Caption := IntToStr(FS.Y);

   case FBoard[FS.Y][FS.X].TileForeGround of
        Fox: EditOccupant.Caption := 'Fox';
        Dolphin: EditOccupant.Caption := 'Dolphin';
        Empty: EditOccupant.Caption := 'Empty';
   end;
end;

initialization
  {$I dolfox.lrs}

end.

