unit UnitFunciones;

interface

uses Windows, SysUtils, idHash, IdHashMessageDigest, classes, gnugettext;

function MD5(const fileName : string) : string;
function ObtenerMejorUnidad(bytes: int64): string;
function ObtenerMejorUnidadTiempo(segundos: int64): string;
function ObtenerMejorUnidadInv(Cadena: string): int64;
function MyGetFileSize(const strFileName: string): longint;

implementation

function MD5(const fileName : string) : string;  //obtiene el md5 de un archivo
 var
   idmd5 : TIdHashMessageDigest5;
   fs : TFileStream;
   hash : T4x4LongWordRecord;
 begin
   idmd5 := TIdHashMessageDigest5.Create;
   fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
   try
     result := idmd5.AsHex(idmd5.HashValue(fs)) ;
   finally
     fs.Free;
     idmd5.Free;
   end;
 end;
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

function ObtenerMejorUnidadTiempo(segundos: int64): string;
var
  dias : integer;
  horas : integer;
  minutos : integer;
begin
  dias := 0;
  horas := 0;
  minutos := 0;
  while (segundos > (86400)) do   //24*60*60
  begin
    dias := dias+1;
    segundos := segundos-(86400);
  end;
  if(dias >0) then
    Result := inttostr(dias)+_(' dias ');

  while (segundos > (3600)) do //60*60
  begin
    horas := horas+1;
    segundos := segundos-(3600);
  end;
  if(horas >0) then
    Result := Result+inttostr(horas)+_(' horas ');

  while segundos > 60 do
  begin
    minutos := minutos+1;
    segundos := segundos-60;
  end;
  if(minutos >0) then
    Result := Result+inttostr(minutos)+_(' minutos ');

  if(segundos > 0) then
    Result := Result+inttostr(segundos)+_(' segundos ');
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
