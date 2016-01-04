unit player;

interface

uses
  IdTCPClient, Dialogs;

  procedure connect(I: string; P: integer; var success: boolean);
  procedure stop();
  procedure socketInput(msg: String);
  procedure TryMove(x1,y1,x2,y2: Integer);
  procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure PlayerClientConnected(Sender: TObject);


var
  TeamID: Char;
  PlayerClient: TIdTCPClient;

implementation

procedure connect(I: string; P: integer; var success: boolean);
begin
  PlayerClient.Host := I;
  PlayerClient.Port := P;
  PlayerClient.connect();
end;

procedure stop();
begin
  PlayerClient.Disconnect();
end;

procedure socketInput(msg: String);
begin
  case msg[3] of
    // types of incoming messages
    'N':  begin
          // your move message
            ShowMessage('Your move!')
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

procedure TryMove(x1, y1, x2, y2: Integer);
// composes and sends a message for a move
begin
  PlayerClient.WriteLn(TeamID + 'B' + 'M' + ' ' +
                      inttostr(x1) + ' ' + // old x coordinate
                      inttostr(y1) + ' ' + // old y coordinate
                      inttostr(x2) + ' ' + // new x coordinate
                      inttostr(y2)       // new y coordinate
                      );
end;


procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); // this is the somewhat changed click function.
begin
     Case Key of
          37 : EditKey.Text := 'left';
          38 : EditKey.Text := 'up';
          39 : EditKey.Text := 'right';
          40 : EditKey.Text := 'down';
     End;
     if (FBoard[FS.Y][FS.X].TileForeground = Fox) and (TeamID = 'F') or
        (FBoard[FS.Y][FS.X].TileForeground = Dolphin) and (TeamID = 'D') then
     begin
     Case Key of
          37 :
             // Left
             begin
                  if FS.X > 0 then begin
//                     FBoard[FS.Y][FS.X - 1].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
//                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
//                     FS.X := FS.X - 1;
                       TryMove(FS.Y, FS.X, FS.Y, FS.X - 1);
                  end;

             end;
          38 :
             // Up
             begin
                  if FS.Y > 0 then
//                     FBoard[FS.Y - 1][FS.X].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
//                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
//                     FS.Y := FS.Y - 1;
                       TryMove(FS.Y, FS.X, FS.Y - 1, FS.X);
             end;
          39 :
             // Right
             begin
                  if FS.X < 49 then
//                     FBoard[FS.Y][FS.X + 1].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
//                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
//                     FS.X := FS.X + 1;
                       TryMove(FS.Y, FS.X, FS.Y, FS.X + 1);
             end;
          40 :
             // Down
             begin
                  if FS.Y < 49 then
//                     FBoard[FS.Y + 1][FS.X].TileForeGround := FBoard[FS.Y][FS.X].TileForeGround;
//                     FBoard[FS.Y][FS.X].TileForeGround := Empty;
//                     FS.Y := FS.Y + 1;
                       TryMove(FS.Y, FS.X, FS.Y + 1, FS.X);
             end;
     End;
     end;
     DrawGrid1.Update;
     EditSelectionX.Text := IntToStr(FS.X);
     EditSelectionY.Text := IntToStr(FS.Y);

     case FBoard[FS.Y][FS.X].TileForeGround of
          Fox: EditOccupant.Text := 'Fox';
          Dolphin: EditOccupant.Text := 'Dolphin';
          Empty: EditOccupant.Text := 'Empty';
     end;

end;

procedure PlayerClientConnected(Sender: TObject);
begin
  // link initialize
  link := Thread.Create(False, PlayerClient);
  // send join message
  PlayerClient.WriteLn('PBJ');
end;

end.
