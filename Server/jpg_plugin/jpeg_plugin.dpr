library jpeg_plugin;

uses
  FastShareMem,windows, jpeg, sysutils, classes, Graphics, lomlib;


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

procedure CreateThumbnail(InStream, OutStream: TStream);
var
  JpegImage: TJpegImage;
  Bitmap: TBitmap;
  Ratio: Double;
  ARect: TRect;
  AHeight, AHeightOffset: Integer;
  AWidth, AWidthOffset: Integer;
  newheight, newwidth : integer;
begin
  JpegImage:=TJpegImage.Create;
  try
//  Load the image
    JpegImage.LoadFromStream(InStream);
//begin get new size
    if JpegImage.Width <> JpegImage.height then begin
     if JpegImage.height > JpegImage.width then begin
        newheight := 128;
        newwidth := (newheight * JpegImage.width) div JpegImage.height;
     end
     else begin
        newwidth := 128;
        newheight := (newwidth * JpegImage.height) div JpegImage.width;
     end;
   end
   else begin
        newheight := 128;
        newwidth := 128;
   end;
//end GET NEW SIZE
// Create bitmap, and calculate parameters
    Bitmap:=TBitmap.Create;
    try
      Ratio:=JpegImage.Width/JpegImage.Height;
      if Ratio>1 then
      begin
        AHeight:=Round(newWidth/Ratio);
        AHeightOffset:=(newHeight-AHeight) div 2;
        AWidth:=newWidth;
        AWidthOffset:=0;
      end
      else
      begin
        AWidth:=Round(newHeight*Ratio);
        AWidthOffset:=(newWidth-AWidth) div 2;
        AHeight:=newHeight;
        AHeightOffset:=0;
      end;
      Bitmap.Width:=newWidth;
      Bitmap.Height:=newHeight;
      Bitmap.Canvas.Brush.Color:=clWhite;
      Bitmap.Canvas.FillRect(Rect(0,0,newWidth,newHeight));
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

procedure CreateBMPThumb(const InFileName, OutFileName: AnsiString);
var
  Bitmap, Bitmap2: TBitmap;
  Ratio: Double;
  ARect: TRect;
  AHeight, AHeightOffset: Integer;
  AWidth, AWidthOffset: Integer;
  newheight, newwidth : integer;
begin
Bitmap := TBitmap.Create;
Bitmap2 := TBitmap.Create;
Bitmap.LoadFromFile(InFileName);
if Bitmap.Width <> Bitmap.height then begin
     if Bitmap.height > Bitmap.width then begin
        newheight := 128;
        newwidth := (newheight * Bitmap.width) div Bitmap.height;
     end
     else begin
        newwidth := 128;
        newheight := (newwidth * Bitmap.height) div Bitmap.width;
     end;
   end
   else begin
        newheight := 128;
        newwidth := 128;
   end;

try
      Ratio:=Bitmap.Width/Bitmap.Height;
      if Ratio>1 then
      begin
        AHeight:=Round(newWidth/Ratio);
        AHeightOffset:=(newHeight-AHeight) div 2;
        AWidth:=newWidth;
        AWidthOffset:=0;
      end
      else
      begin
        AWidth:=Round(newHeight*Ratio);
        AWidthOffset:=(newWidth-AWidth) div 2;
        AHeight:=newHeight;
        AHeightOffset:=0;
      end;
      Bitmap2.Width:=newWidth;
      Bitmap2.Height:=newHeight;
      Bitmap2.Canvas.Brush.Color:=clWhite;
      Bitmap2.Canvas.FillRect(Rect(0,0,newWidth,newHeight));
// StretchDraw original image
      ARect:=Rect(AWidthOffset,AHeightOffset,AWidth+AWidthOffset,AHeight+AHeightOffset);
      Bitmap2.Canvas.StretchDraw(ARect,Bitmap);
// Assign back to the Jpeg, and save to the file
      Bitmap2.SaveToFile(OutFileName);
    finally
    Bitmap2.Free;
    Bitmap.Free;
    end;


end;


procedure CreateThumb(const InFileName, OutFileName: AnsiString);
var
  InStream, OutStream: TFileStream;
  ext:String;
begin
  ext := ExtractFileExt(inFileName);
  if LowerCase(ext) = '.bmp' then
  begin
    CreateBmpThumb(InFileName, OutFileName);
  end
  else
  begin
    InStream:=TFileStream.Create(InFileName,fmOpenRead);
    try
      OutStream:=TFileStream.Create(OutFileName,fmOpenWrite or fmCreate);
      try
        CreateThumbnail(InStream,OutStream);
      finally
        OutStream.Free;
      end;
    finally
      InStream.Free;
    end;
  end;
end;


function save(b: TBitmap; quality: integer; filename:String):Boolean;
var MyJpeg : TJPegImage;
begin
  Result := False;
 MyJPEG := TJPEGImage.Create;
 try
   with MyJPEG do
   begin
//
    Assign(b);
    MyJPEG.CompressionQuality:=quality;
    MyJPEG.Compress;
    SaveToFile(filename);
   end;
 Except
  Exit;
      end;
    MyJPEG.Free;
    b.Free;
    Result := True;

end;

function screenX:Integer;
var DC: HDC;
begin
  DC := GetDC(GetDesktopWindow);
  Result := GetDeviceCaps(DC, HORZRES);
end;

function screenY:Integer;
var DC: HDC;
begin
  DC := GetDC(GetDesktopWindow);
  Result := GetDeviceCaps(DC, VERTRES);
end;

function ScreenShot:TBitmap;
var
  c: TCanvas;
  r: TRect;
  Bild : TBitmap;
begin
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  try
  Bild := TBitmap.Create;
    r := Rect(0, 0, ScreenX, ScreenY);
    Bild.Width := ScreenX;
    Bild.Height := ScreenY;
    Bild.Canvas.CopyRect(r, c, r);
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
  Result := Bild;
end;

function capture_save(filename : AnsiString; quality:integer ):boolean;
var b : TBitmap;
begin
Result := false;
b := ScreenShot;
Result := save(b, quality, filename);
end;

function GetBitmapFromFile(BitmapPath: string): HBitmap;
begin
  Result := LoadImage(GetModuleHandle(nil), pchar(BitmapPath), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE);
end;

function save_hbitmap(input : Ansistring; filename: AnsiString; quality:integer):boolean;
var b : TBitmap;
h : HBITMAP;
var j : TJPegImage;
begin
if not fileExists(input) then
begin
Result := False;
Exit;
end;
h := GetBitmapFromFile(input);
b := TBitmap.Create;
b.Handle := h;
j := TJPegImage.Create;
try
j.CompressionQuality := quality;
j.Compress;
j.Assign(b);
j.SaveToFile(filename);
except
begin
Result := false;
end;
end;
Result := true;
j.Free;
b.Free;
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


exports
 capture_save, CreateThumb, save_hbitmap, comprimir_jpeg;


begin
end.
