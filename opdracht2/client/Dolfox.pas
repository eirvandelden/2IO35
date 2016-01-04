unit Dolfox;

{$MODE Delphi}

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, {GLPanel,} StdCtrls, Grids, LResources;

const
  // Upperbound boardsize
  MaxBoardSize = 50;

type
  // Types
  TCoordinate =
    record
      XCoordinate: 1..MaxBoardSize;
      YCoordinate: 1..MaxBoardSize;
    end;
  TBoardSize = 10..MaxBoardSize;
  TBoardTile =
    record
      TileBackground: (TileLand, TileWater);
      TileForeground: (TileFox, TileDolphin, TileEmpty);
    end;
  TAnimal = (AnimalFox, AnimalDolphin);
  TPlayerID = 1..2;

  TForm1 = class(TForm)
    GameBox: TGroupBox;
    LabelPlayerText: TLabel;
    LabelPlayerID: TLabel;
    LabelAnimalText: TLabel;
    LabelAnimalType: TLabel;
    LabelScoreText: TLabel;
    LabelScore: TLabel;
    BoardGrid: TStringGrid;
    LabelSizeText: TLabel;
    LabelSize: TLabel;
    OGO: TLabel;
    TUe: TLabel;
    ConnectionBox: TGroupBox;
    ButtonConnect: TButton;
    FieldIP: TEdit;
    LabelServerPort: TLabel;
    LabelServerIP: TLabel;
    FieldPort: TEdit;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LabelFoxCount: TLabel;
    LabelDolphinCount: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    // Global variables we use in the game
    FBoard: array of array of TBoardTile;
    FSelection: TCoordinate;
    FBoardSize: TBoardSize;
    FPlayerAnimal: TAnimal;
    FScore: Integer;
    FPlayerID: TPlayerID;


    // queries

    // commands
    procedure UpdateView;
    procedure Initialize;
  end;

var
  Form1: TForm1;

implementation


procedure TForm1.UpdateView;
var
  i,j: Integer;

begin
  for i := 1 to FBoardSize do begin
    for j := 1 to FBoardSize do begin
     {
      case FBoard[i,j].TileBackground of
        TileLand:
          BoardGrid.Canvas.Draw(i,j,VGraphic);
      }
    end;

  end;
end;

procedure TForm1.Initialize;
var
  nf,nd,i,j: Integer;
begin
  nf := Random((50*50) div 4);
  nd := nf;

  while nd >= 0 do begin
    for i := 1 to FBoardSize do begin
      for j := 1 to FBoardSize do begin
        with FBoard[i,j] do begin
          if (TileBackground <> TileLand) and (TileForeGround = TileEmpty) then begin
            FBoard[i,j].TileForeground := TileFox;
          end;
        end;
      end;
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Initialize;
end;

initialization
  {$i Dolfox.lrs}
  {$i Dolfox.lrs}
  {$i Dolfox.lrs}
  {$i Dolfox.lrs}

end.
