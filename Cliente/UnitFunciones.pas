unit UnitFunciones;

interface

uses Windows, SysUtils;

function ObtenerMejorUnidad(bytes: int64): string;
function ObtenerMejorUnidadInv(Cadena: string): int64;
function MyGetFileSize(const strFileName: string): longint;

implementation

function ObtenerMejorUnidad(bytes: int64): string;
begin
  if bytes < 1024 then
    Result := IntToStr(bytes) + ' B'
  else if bytes < 1048576 then
    Result := FloatToStrF(bytes / 1024, ffFixed, 10, 1) + ' Kb'
  else if bytes < 1073741824 then
    Result := FloatToStrF(bytes / 1048576, ffFixed, 10, 1) + ' Mb'
  else if bytes > 1073741824 then
    Result := FloatToStrF(bytes / 1073741824, ffFixed, 10, 1) + ' Gb';
end;

//Dada una cadena del tipo 44,7 Mb nos devuelve el numero de bytes equivalentes
function ObtenerMejorUnidadInv(Cadena: string): int64;
var
  Unidad:   string;
  Cantidad: extended;
begin
  Result := -1;
  if Cadena = '' then
    exit;
  Unidad   := Copy(Cadena, Pos(' ', cadena) + 1, Length(Cadena));
  Cantidad := StrToFloat(Copy(Cadena, 1, Pos(' ', cadena) - 1));
  if Unidad = 'B' then
    Result := Round(Cantidad);
  if Unidad = 'Kb' then
    Result := Round(Cantidad * 1024);
  if Unidad = 'Mb' then
    Result := Round(Cantidad * 1048576);
  if Unidad = 'Gb' then
    Result := Round(Cantidad * 1073741824);
end;

function MyGetFileSize(const strFileName: string): longint;
var
  WFD:   TWin32FindData;
  hFile: THandle;
begin
  hFile  := FindFirstFileA(PChar(strFileName), WFD);
  Result := WFD.nFileSizeLow;
  Windows.FindClose(hFile);
end;

end.
