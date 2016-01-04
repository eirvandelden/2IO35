program board;

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, Math,
  IdTCPClient, inifiles;

type
  TDirection = (UP, DOWN, LEFT, RIGHT, NULL);
  TTiletype = (HOME1, HOME2, HINT, TRANSPORT, NORMAL);
  
  TPosition = record
    x, y: integer;
  end;
  
  TTile = record
    tiletype: TTiletype;
    endpoint: TPosition;
    directionPlayer1: TDirection;
    directionPlayer2: TDirection;
  end;
  
  TBoard = class(TObject)
    private
      boardsizeX: integer;
      boardsizeY: integer;
      board: array of array of TTile;
      player2direction: TDirection;
      player1pos: TPosition;
      player2pos: TPosition;

      socket: TIdTCPClient;
    public
      constructor create();
      procedure player1move(direction: TDirection);
      procedure player2move(steps: integer);
      procedure player2turn(direction: TDirection);
      procedure status();

      procedure connect(server: String; port: integer);
      procedure send(msg: string);
      procedure disconnect();
      procedure run();

end;

var
  FBoard: TBoard;
  FInifile: TIniFile;

constructor TBoard.create();
var
  i, j: integer;
  counter: integer;
  switchtile: integer;
  switchtiletype: TTile;
  validtile: boolean;
  hinttiles: integer;
  transporttiles: integer;
  poshome1: TPosition;
  poshome2: TPosition;
begin
  inherited Create();
  
  // chose random variables
  randomize();
  boardsizeX := random(100 - 15) + 15;
  boardsizeY := random(100 - 15) + 15;
  hinttiles := random(Math.max(boardsizeX, boardsizeY) - Math.min(boardsizeX, boardsizeY) + 1) + Math.min(boardsizeX, boardsizeY);
  transporttiles := random(Math.max(boardsizeX, boardsizeY) - Math.min(boardsizeX, boardsizeY) + 1) + Math.min(boardsizeX, boardsizeY);
  
  // set the board sizes
  setlength(board, boardsizeX, boardsizeY);
  
  // fill the board with the right number of tiles
  counter := 0;
  while counter < hinttiles do begin
    board[counter div boardsizeY][counter mod boardsizeY].tiletype := HINT;
    board[counter div boardsizeY][counter mod boardsizeY].directionPlayer1 := NULL;
    board[counter div boardsizeY][counter mod boardsizeY].directionPlayer2 := NULL;
    inc(counter);
  end;
  
  while counter < ( hinttiles + transporttiles ) do begin
    board[counter div boardsizeY][counter mod boardsizeY].tiletype := TRANSPORT;
    inc(counter);
  end;
  
  board[counter div boardsizeY][counter mod boardsizeY].tiletype := HOME1;
  inc(counter);
  
  board[counter div boardsizeY][counter mod boardsizeY].tiletype := HOME2;
  inc(counter);
  
  while counter < (boardsizeX * boardsizeY) do begin
    board[counter div boardsizeY][counter mod boardsizeY].tiletype := NORMAL;
    inc(counter);
  end;
  
  // randomize the board
  counter := 0;
  while counter < (boardsizeX * boardsizeY) do begin
    switchtile := random((boardsizeX * boardsizeY) - counter) + counter;
    switchtiletype := board[switchtile div boardsizeY][switchtile mod boardsizeY];
    board[switchtile div boardsizeY][switchtile mod boardsizeY] := board[counter div boardsizeY][counter mod boardsizeY];
    board[counter div boardsizeY][counter mod boardsizeY] := switchtiletype;
    inc(counter);
  end;
  
  // find the home tiles and randomize the start tiles
  counter := 0;
  while counter < (boardsizeX * boardsizeY) do begin
    if board[counter div boardsizeY][counter mod boardsizeY].tiletype = HOME1 then begin
      poshome1.x := counter div boardsizeY;
      poshome1.y := counter mod boardsizeY;
      while true do begin
        switchtile := random((boardsizeX * boardsizeY) - counter) + counter;
        if board[switchtile div boardsizeY][switchtile mod boardsizeY].tiletype = NORMAL then begin
          player1pos.x := switchtile div boardsizeY;
          player1pos.y := switchtile mod boardsizeY;
          break;
        end;
      end;
    end;
    if board[counter div boardsizeY][counter mod boardsizeY].tiletype = HOME2 then begin
      poshome2.x := counter div boardsizeY;
      poshome2.y := counter mod boardsizeY;
      while true do begin
        switchtile := random((boardsizeX * boardsizeY) - counter) + counter;
        if board[switchtile div boardsizeY][switchtile mod boardsizeY].tiletype = NORMAL then begin
          player2pos.x := switchtile div boardsizeY;
          player2pos.y := switchtile mod boardsizeY;
          break;
        end;
      end;
    end;
    inc(counter);
  end;
  
  // set the directions of the HINT tiles
  counter := 0;
  while counter < (boardsizeX * boardsizeY) do begin
    with board[counter div boardsizeY][counter mod boardsizeY] do begin
      if tiletype = HINT then begin
        if poshome1.x < (counter div boardsizeY) then begin
          directionPlayer1 := LEFT;
        end;
        if poshome1.x > (counter div boardsizeY) then begin
          directionPlayer1 := RIGHT;
        end;
        if poshome1.y < (counter mod boardsizeY) then begin
          if directionPlayer1 = NULL then begin
            if random(2) = 1 then begin
              directionPlayer1 := UP;
            end;
          end else begin
            directionPlayer1 := UP;
          end;
        end;
        if poshome1.y > (counter mod boardsizeY) then begin
          if directionPlayer1 = NULL then begin
            if random(2) = 1 then begin
              directionPlayer1 := DOWN;
            end;
          end else begin
            directionPlayer1 := DOWN;
          end;
        end;
      
        if poshome2.x < (counter div boardsizeY) then begin
          directionPlayer2 := LEFT;
        end;
        if poshome2.x > (counter div boardsizeY) then begin
          directionPlayer2 := RIGHT;
        end;
        if poshome2.y < (counter mod boardsizeY) then begin
          if directionPlayer2 = NULL then begin
            if random(2) = 1 then begin
              directionPlayer2 := UP;
            end;
          end else begin
            directionPlayer2 := UP;
          end;
        end;
        if poshome2.y > (counter mod boardsizeY) then begin
          if directionPlayer2 = NULL then begin
            if random(2) = 1 then begin
              directionPlayer2 := DOWN;
            end;
          end else begin
            directionPlayer2 := DOWN;
          end;
        end;
      end;
    end;
    inc(counter);
  end;
  
  // find endpoints for the TRANSPORT tiles
  counter := 0;
  while counter < (boardsizeX * boardsizeY) do begin
    with board[counter div boardsizeY][counter mod boardsizeY] do begin
      if tiletype = TRANSPORT then begin
        while true do begin
          switchtile := random(boardsizeX * boardsizeY);
          if (board[switchtile div boardsizeY][switchtile mod boardsizeY].tiletype = NORMAL)
          and not((switchtile div boardsizeY = 0) or (switchtile div boardsizeY = boardsizeX - 1))
          and not((switchtile mod boardsizeY = 0) or (switchtile mod boardsizeY = boardsizeY - 1)) then begin
            validtile := true;
            for i := -1 to 1 do begin
              for j := -1 to 1 do begin
                if board[(switchtile div boardsizeY) + i][(switchtile mod boardsizeY) + j].tiletype = TRANSPORT then begin
                 // validtile := false;
                end;
              end;
            end;
            if validtile then begin
              endpoint.x := switchtile div boardsizeY;
              endpoint.y := switchtile mod boardsizeY;
              break;
            end;
          end;
        end;
      end;
    end;
    inc(counter);
  end;
  
  
  // set the direction for player 2
  case random(4) of
    0: player2direction := LEFT;
    1: player2direction := RIGHT;
    2: player2direction := DOWN;
    3: player2direction := UP;
  end;
  
  
{  // dump the board for debugging output
  for i := 0 to boardsizeX - 1 do begin
    for j := 0 to boardsizeY - 1 do begin
      case board[i][j].tiletype of
        NORMAL: write(' ');
        HOME1: write('1');
        HOME2: write('2');
        HINT: write('H');
        TRANSPORT: write('T');
      end;
    end;
    writeln();
  end;}
end;

procedure TBoard.player1move(direction: TDirection);
var
  x, y: integer;
  oldplayerposx, oldplayerposy: integer;
begin
  x := 0;
  y := 0;
  case direction of
    LEFT: x := -1;
    RIGHT: x := 1;
    DOWN: y := -1;
    UP: y := 1
  end;
  
  if ((player1pos.x + x <= 0) or (player1pos.x + x >= boardsizeX)
   or (player1pos.y + y <= 0) or (player1pos.y + y >= boardsizeY)) then begin
    send('NOWAI');
  end else begin
    case board[player1pos.x + x][player1pos.y + y].tiletype of
      HOME1:
      begin
        player1pos.x := player1pos.x + x;
        player1pos.y := player1pos.y + y;
        send('K');
        send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
        send('KITTEH WINS');
      end;
      HOME2:
      begin
        player1pos.x := player1pos.x + x;
        player1pos.y := player1pos.y + y;
        send('K');
        send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
      end;
      NORMAL:
      begin
        player1pos.x := player1pos.x + x;
        player1pos.y := player1pos.y + y;
        send('K');
        send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
      end;
      HINT:
      begin
        player1pos.x := player1pos.x + x;
        player1pos.y := player1pos.y + y;
        case board[player1pos.x + x][player1pos.y + y].directionPlayer1 of
          LEFT: send('HINT LEFT');
          RIGHT: send('HINT RIGHT');
          DOWN: send('HINT DOWN');
          UP: send('HINT UP');
        end;
        send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
      end;
      TRANSPORT:
      begin
        oldplayerposx := player1pos.x;
        oldplayerposy := player1pos.y;
        player1pos.x := board[oldplayerposx + x][oldplayerposy + y].endpoint.x;
        player1pos.y := board[oldplayerposx + x][oldplayerposy + y].endpoint.y;
        send('K');
        send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
      end;
    end;
  end;
end;

procedure TBoard.player2move(steps: integer);
var
  x, y: integer;
begin
  x := 0;
  y := 0;
  case player2direction of
    LEFT: x := -steps;
    RIGHT: x := steps;
    DOWN: y := -steps;
    UP: y := steps
  end;
  if ((player2pos.x + x <= 0) or (player2pos.x + x >= boardsizeX)
   or (player2pos.y + y <= 0) or (player2pos.y + y >= boardsizeY)) then begin
    send('NOWAI');
  end else begin
    case board[player2pos.x + x][player2pos.y + y].tiletype of
      HOME1:
      begin
        player2pos.x := player2pos.x + x;
        player2pos.y := player2pos.y + y;
        send('K');
        send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
      end;
      HOME2:
      begin
        player2pos.x := player2pos.x + x;
        player2pos.y := player2pos.y + y;
        send('K');
        send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
        send('SUPERCAT WINS');
      end;
      NORMAL:
      begin
        player2pos.x := player2pos.x + x;
        player2pos.y := player2pos.y + y;
        send('K');
        send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
      end;
      HINT:
      begin
        player2pos.x := player2pos.x + x;
        player2pos.y := player2pos.y + y;
        case board[player2pos.x + x][player2pos.y + y].directionPlayer2 of
          LEFT: send('HINT LEFT');
          RIGHT: send('HINT RIGHT');
          DOWN: send('HINT DOWN');
          UP: send('HINT UP');
        end;
        send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
      end;
      TRANSPORT:
      begin
        player2pos.x := board[player2pos.x + x][player2pos.y + y].endpoint.x;
        player2pos.y := board[player2pos.x + x][player2pos.y + y].endpoint.y;
        send('K');
        send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
      end;
    end;
  end;
end;

procedure TBoard.player2turn(direction: TDirection);
begin
  player2direction := direction;
  send('K');
end;

procedure TBoard.status();
var
  counter: integer;
begin
  send('SIZE ' + inttostr(boardsizeX) + ',' + inttostr(boardsizeY));
  counter := 0;
  while counter < (boardsizeX * boardsizeY) do begin
    case board[counter div boardsizeY][counter mod boardsizeY].tiletype of
      HINT: send('HINT ' + inttostr(counter div boardsizeY) + ',' + inttostr(counter mod boardsizeY));
      TRANSPORT: send('TRANSPORT ' + inttostr(counter div boardsizeY) + ',' + inttostr(counter mod boardsizeY) + ' => ' + inttostr(board[counter div boardsizeY][counter mod boardsizeY].endpoint.x) + ',' + inttostr(board[counter div boardsizeY][counter mod boardsizeY].endpoint.y));
      HOME1: send('END1 ' + inttostr(counter div boardsizeY) + ',' + inttostr(counter mod boardsizeY));
      HOME2: send('END2 ' + inttostr(counter div boardsizeY) + ',' + inttostr(counter mod boardsizeY));
    end;
    inc(counter);
  end;
  send('KITTEH ' + inttostr(player1pos.x) + ',' + inttostr(player1pos.y));
  send('SUPERCAT ' + inttostr(player2pos.x) + ',' + inttostr(player2pos.y));
end;


procedure TBoard.connect(server: string; port: Integer);
begin
  socket := TIdTCPClient.create(nil);
  socket.host := server;
  socket.port := port;
  socket.connect();
end;

procedure TBoard.send(msg: string);
begin
  socket.writeln(msg);
//  socket.IOHandler.readln() <> ''
//  writeln(socket.getResponse());
end;

procedure TBoard.disconnect();
begin
  socket.disconnect();
  halt;
end;

procedure TBoard.Run;
var
  VMessage: String;
begin
  while true do begin
    if not Socket.Connected then begin
      exit;
    end;
    VMessage := socket.readln();
    if VMessage = 'HAI' then
      socket.writeln('ALL YOUR BASE ARE BELONG TO ME');

    // 'K': niks

    if VMessage = 'NOWAI' then
        disconnect();

    if VMessage = 'VISIBLE' then
        status();

    if VMessage = 'KITTEH WINS, GTFO' then
        disconnect();

    if VMessage = 'SUPERCAT WINS, GTFO' then
        disconnect();

    if VMessage = 'KITTEH WANT MOVE UP' then
        player1Move(UP);

    if VMessage = 'KITTEH WANT MOVE DOWN' then
        player1Move(DOWN);

    if VMessage = 'KITTEH WANT MOVE LEFT' then
        player1Move(LEFT);

    if VMessage = 'KITTEH WANT MOVE RIGHT' then
        player1Move(RIGHT);

    if VMessage = 'SUPERCAT WANT MOVE ONE' then
        player2Move(1);

    if VMessage = 'SUPERCAT WANT MOVE TWO' then
        player2Move(2);

    if VMessage = 'SUPERCAT WANT MOVE THREE' then
        player2Move(3);

    if VMessage = 'SUPERCAT WANT TURN UP' then
        player2Turn(UP);

    if VMessage = 'SUPERCAT WANT TURN DOWN' then
        player2Turn(DOWN);

    if VMessage = 'SUPERCAT WANT TURN LEFT' then
        player2Turn(LEFT);

    if VMessage = 'SUPERCAT WANT TURN RIGHT' then
        player2Turn(RIGHT);

  end;

end;

begin
  FInifile := TIniFile.create(ExtractFilePath(getModuleName(0)) + 'BORD.INI');
  
  FBoard := TBoard.create();
  FBoard.connect(FInifile.readString('spel', 'ip', ''), strtoint(FInifile.readString('spel', 'port', '0')));
  FBoard.run();
end.
