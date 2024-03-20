program CliSnakeGame;

uses
  crt;

const
  max_length = 45;
  max_height = 25;
  dot = #35;

type
  Tmove = record
    x: integer;
    y: integer;
  end;

  Tpath = record
    Oldx: array [1..500] of integer;
    Oldy: array [1..500] of integer;
  end;
  Tmuri = array [1..max_length, 1..max_height] of char;

  Tpoint = record
    x: integer;
    y: integer;
  end;
  T_file = file of integer;

var
  move: Tmove;
  Path: Tpath;
  muri: tmuri;
  point: Tpoint;
  ndal, ndal_1, ndal_2, eat: boolean;
  key: char;
  keyPres: char;
  i, shpejt, gjat, piket, best: integer;
  F: T_file;

  procedure Vizato_murin(muri: Tmuri);
  var
    i, j: integer;
  begin
    textbackground(15);
    for i := 1 to max_length do
      for j := 1 to max_height do
        muri[i, j] := ' ';
    for j := 1 to 3 do
    begin
      gotoxy(1, j);
      for i := 1 to max_length do
        Write(muri[i, 1]);
    end;
    gotoxy(1, max_height);
    for i := 1 to max_length do
      Write(muri[i, 1]);
    for i := 1 to max_height do
    begin
      gotoxy(1, i);
      Write(muri[1, i]);
    end;
    for i := 1 to max_height do
    begin
      gotoxy(max_length, i);
      Write(muri[1, i]);
    end;
  end;

  procedure Kreditet_Pike(piket: integer);
  begin
    gotoxy(60, 4);
    writeln('Punoi: Ameljo Gjoni');
    gotoxy(50, 6);
    writeln('Shtyp [6] per te vazhduar...');
    gotoxy(47, 8);
    Write('Shtypni:[6]-Djathtas, [4]-Majtas, ');
    gotoxy(47, 9);
    Write('[8]-Lart, [2]-Posht.');
    gotoxy(2, 2);
    textbackground(15);
    textcolor(0);
    Write('Piket: ', piket);
  end;

  procedure Vizato_Gjarprin(gjat: integer; var move: Tmove; var Path: Tpath);
  var
    i: integer;
  begin
    i := 1;
    move.x := 20;
    move.y := 15;
    while i < gjat do
    begin
      gotoxy(move.x, move.y);
      textcolor(15);
      textbackground(0);
      Write(dot);
      path.oldx[i] := move.x;
      path.oldy[i] := move.y;
      Inc(move.x);
      Inc(i);
    end;
    path.oldx[gjat] := move.x;
    path.oldy[gjat] := move.y;
  end;

  procedure Ndal_gjar(move: tmove; gjat: integer; path: tpath; var ndal, ndal1, ndal2: boolean);
  var
    j: integer;
  begin
    for j := 1 to gjat do
    begin
      ndal1 := (path.oldx[j] = move.x);
      ndal2 := (path.oldy[j] = move.y);
      if ndal1 and ndal2 then
        ndal := True;
    end;
    if move.x = 1 then
      ndal := True;
    if move.x = max_length then
      ndal := True;
    if move.y = 3 then
      ndal := True;
    if move.y = max_height then
      ndal := True;
  end;

  procedure Leviz_gjar(shpejt, gjat: integer; key: char; var move: tmove; var i: integer;
  var path: tpath; var ndal: boolean);
  begin
    case key of

      #77: begin
        gotoxy(move.x, move.y);
        textcolor(15);
        Write(dot);
        gotoxy(path.oldx[i], path.oldy[i]);
        textcolor(0);
        delay(shpejt);
        Write(' ');
        Inc(move.x);
        ndal_gjar(move, gjat, path, ndal, ndal_1, ndal_2);
        path.oldx[i] := move.x;
        path.oldy[i] := move.y;
        if i < gjat then
          Inc(i)
        else
          i := 1;
        end;
      #75: begin
        gotoxy(move.x, move.y);
        textcolor(15);
        Write(dot);
        gotoxy(path.oldx[i], path.oldy[i]);
        textcolor(0);
        delay(shpejt);
        Write(' ');
        Dec(move.x);
        ndal_gjar(move, gjat, path, ndal, ndal_1, ndal_2);
        path.oldx[i] := move.x;
        path.oldy[i] := move.y;
        if i < gjat then
          Inc(i)
        else
          i := 1;
        end;
      #80: begin
        gotoxy(move.x, move.y);
        textcolor(15);
        Write(dot);
        gotoxy(path.oldx[i], path.oldy[i]);
        textcolor(0);
        delay(shpejt);
        Write(' ');
        Inc(move.y);
        ndal_gjar(move, gjat, path, ndal, ndal_1, ndal_2);
        path.oldx[i] := move.x;
        path.oldy[i] := move.y;
        if i < gjat then
          Inc(i)
        else
          i := 1;
        end;
      #72: begin
        gotoxy(move.x, move.y);
        textcolor(15);
        Write(dot);
        gotoxy(path.oldx[i], path.oldy[i]);
        textcolor(0);
        delay(shpejt);
        Write(' ');
        Dec(move.y);
        ndal_gjar(move, gjat, path, ndal, ndal_1, ndal_2);
        path.oldx[i] := move.x;
        path.oldy[i] := move.y;
        if i < gjat then
          Inc(i)
        else
          i := 1;
        end;
    end;
  end;

  procedure Ushqimi(move: Tmove; path: Tpath; gjat: integer; var Point: Tpoint;
  var eat: boolean);
  var
    j: integer;
    vert1, vert2, Show: boolean;
  begin
    Show := True;
    eat := False;
    while Show do
    begin
      point.x := random(max_length - 2) + 2;
      point.y := random(max_height - 4) + 4;
      for j := 1 to gjat do
      begin
        vert1 := (path.oldx[j] <> point.x);
        vert2 := (path.oldy[j] <> point.y);
        if vert1 and vert2 then
          Show := False;
      end;
      if not Show then
      begin
        gotoxy(point.x, point.y);
        textcolor(15);
        Write('*');
      end;
    end;
  end;

  procedure Hanger(move: Tmove; point: Tpoint; var gjat, shpejt: integer;
  var eat: boolean; var piket: integer);
  var
    vert1, vert2: boolean;
  begin
    vert1 := (move.x = point.x);
    vert2 := (move.y = point.y);
    if vert1 and vert2 then
    begin
      Inc(gjat);
      eat := True;
      shpejt := shpejt - 10;
      Inc(piket);
      gotoxy(2, 2);
      textbackground(15);
      textcolor(0);
      Write('Piket: ', piket);
      textbackground(0);
    end;
  end;

  procedure Rekordi(piket: integer);
  begin

  end;

begin
  Randomize;
  repeat
    cursoroff;
    shpejt := 300;
    ndal := False;
    eat := False;
    gjat := 3;
    piket := 0;
    vizato_murin(muri);
    vizato_gjarprin(gjat, move, path);
    Kreditet_Pike(piket);
    textbackground(0);
    i := 1;
    ushqimi(move, path, gjat, point, eat);
    repeat
      key := readkey;
      if not Assigned(@keyPres) then
         keyPres:= key
      else if (key = #75) and (keyPres = #77) then
           key := keyPres
      else if (key = #77) and (keyPres = #75) then
           key := keyPres
      else if (key = #72) and (keyPres = #80) then
           key := keyPres
      else if (key = #80) and (keyPres = #72) then
           key := keyPres
      else if (key = #80) or (key = #72) or (key = #75) or (key = #77) then
           keyPres:= key;

      repeat
        leviz_gjar(shpejt, gjat, key, move, i, path, ndal);
        hanger(move, point, gjat, shpejt, eat, piket);
        if eat then
          ushqimi(move, path, gjat, point, eat);
      until keypressed or ndal;
    until ndal;
    delay(300);
    clrscr;
    textcolor(15);
    textbackground(0);
    Assign(F, 'best.txt');
    {$I-}
    ;
    reset(F);
    {$I+}
    ;
    if (IOResult <> 0) then
    begin
      rewrite(f);
      Write(f, piket);
      best := piket;
      Writeln('Ju Humbet!');
      writeln('Piket tuja jane: ', piket);
      writeln('Rekordi eshte: ', best);
      Close(f);
    end
    else
    begin
      Read(f, best);
      if piket > best then
      begin
        rewrite(F);
        Write(f, piket);
        Close(F);
        Writeln('Ju Humbet!');
        writeln('Piket tuja jane: ', piket);
        writeln('Ju thyet rekordin: ', best);
      end
      else
      begin
        Close(F);
        Writeln('Ju Humbet!');
        writeln('Piket tuja jane: ', piket);
        writeln('Rekordi eshte: ', best);
      end;
    end;
    Write('Shtypni [Enter] per te luajtur perseri!');
    readln;
    clrscr;
  until 2 < 1;
end.
