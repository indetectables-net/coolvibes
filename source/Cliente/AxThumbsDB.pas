unit AxThumbsDB;

interface

uses
  Windows, Classes, SysUtils, JPEG, ActiveX,

  Storages;

type
  //info record for each item in Thumbs.db
  TAxThumbsDBFileInfo = class(TObject)
    dwFirstDummy:dword;      //don't what this value is used for
    dwIndex:dword;           //index of thumb in catalog
    dwFileDate:dword;        //this dword may be a file date (unknown)
    dwThumbDate:dword;       //this dword may be a file date (unknown)
    dwUnknown1:dword;        //unknown word in thumb item
    dwUnknown2:dword;        //unknown word in thumb item
    dwSizeOfJPGStream:dword; //stream size of JPEG stream
    jpgThumb:tjpegimage;     //holds the thumbnail loaded from thumbs.db
  end;

  //Object to read out data of Thumbs.db
  TAxThumbsDB = class(TObject)
  private
    FDirectory: string;       //open directory
    FCatalogSignatur:dword;   //unknown dword with value 00 07 00 10 hex
    FCatalogItemCount:dword;  //number of items in catalog
    FCatalogThumbSize:TSize;  //max. size of thumbnails
  protected
  public
    //list of all found thumbnails
    //each item is represented by it's filename (lowercase)
    //objects is filled with TAxThumbsDBFileInfo
    ThumbnailItems:tstringlist;
    //constructor to open thumbs.db in specified directory
    constructor Create(ADirectory:string);
    //destructor
    destructor Destroy; override;
    //read out opened directory
    function GetDirectory:string;
    //read number of found thumbnails
    function GetThumbnailCount:integer;
    //read out size of thumbnails (in pixels)
    function GetThumbSize:tsize;
    //read out JPEG image of thumbnail
    //thumbnail can be selected by file name or index
    procedure GetThumb(FileName:string; Thumb:TJPEGImage); overload;
    procedure GetThumb(Index:integer; Thumb:TJPEGImage); overload;
    procedure GetThumbInfo(FileName:string; var ThumbInfo:TAxThumbsDBFileInfo); overload;
    procedure GetThumbInfo(Index:integer; var ThumbInfo:TAxThumbsDBFileInfo); overload;
  end;

implementation

{ TAxThumbsDB }

constructor TAxThumbsDB.Create(ADirectory:string);
var ThumbsDBFile:TStorage;       //TStorage for thumbs.db file
    ThumbsDBCatalog:TStream;     //TStream for file catalog inside thumbs.db
    ThumbsDB_JPEG:tstream;       //stream for thumb image inside thumbs.db
    ThmInfo:TAxThumbsDBFileInfo; //info structure for each item in thumbs.db
    i,j:dword;                   //indexes
    Filename:string;             //Filename read from catalog
    WideChr:word;                //placeholder to read widechar filename
    dwIndex:dword;               //placeholder to calculate item names
    IndexStr:string;             //name of TStorage item for each catalog item
begin
  FDirectory := IncludeTrailingPathDelimiter(ADirectory);
  //create list to hold thumbs data
  ThumbnailItems := TStringList.Create;

  //open thumbs.db file
  if not fileexists(FDirectory + 'thumbs.db') then exit;
  ThumbsDBFile := TStgFile.OpenFile( FDirectory + 'thumbs.db', STGM_READ or STGM_SHARE_EXCLUSIVE );
  try
    //open catalog of files inside thumbs.db
    ThumbsDBCatalog := ThumbsDBFile.OpenStream( 'Catalog', STGM_READ or STGM_SHARE_EXCLUSIVE );
    try
      //read catalog
      //first dword = ??? always 00070010 hex
      ThumbsDBCatalog.Read(FCatalogSignatur,4);
      //second dword = number of items
      ThumbsDBCatalog.Read(FCatalogItemCount,4);
      //dword 3+4 = size of thumbs, not used
      ThumbsDBCatalog.Read(FCatalogThumbSize,8);

      for i := 0 to FCatalogItemCount - 1 do
      begin
        ThmInfo := TAxThumbsDBFileInfo.Create;

        //first dword = ??? always 2x000000 hex
        ThumbsDBCatalog.Read(ThmInfo.dwFirstDummy,4);
        //second dword = index of item
        ThumbsDBCatalog.Read(ThmInfo.dwIndex,4);
        //dword 3+4 date and time ???
        ThumbsDBCatalog.Read(ThmInfo.dwFileDate,4);
        //second dword = index of item
        ThumbsDBCatalog.Read(ThmInfo.dwThumbDate,4);

        //read filename as widechar and convert to string
        Filename := '';
        repeat
          ThumbsDBCatalog.Read(WideChr,2);
          if WideChr <> 0 then
          begin
            Filename := Filename + char(WideChr);
          end;
        until WideChr = 0;
        //additional 00 00 word at each item end
        ThumbsDBCatalog.Read(WideChr,2);

        //calculate name of item from catalog index
        //for any unknown reason, the name is calculated from index as
        // inttostr(1. digit) + inttostr(2. digit) + ... (reverse order)
        IndexStr := '';
        dwIndex := ThmInfo.dwIndex;
        while dwIndex > 0 do
        begin
          j := dwIndex mod 10;
          IndexStr := IndexStr + IntToStr(j);
          dwIndex := dwIndex div 10;
        end;

        //read thumbnail as JPEG file
        ThmInfo.jpgThumb := TJPEGImage.Create;
        ThumbsDB_JPEG := ThumbsDBFile.OpenStream(IndexStr, STGM_READ or STGM_SHARE_EXCLUSIVE );
        try
          //12 bytes in from of JPEG stream
          ThumbsDB_JPEG.Read(ThmInfo.dwUnknown1,4);
          ThumbsDB_JPEG.Read(ThmInfo.dwUnknown1,4);
          ThumbsDB_JPEG.Read(ThmInfo.dwSizeOfJPGStream,4);

          //read stream as JPEG and store in thumb info structure
          try
            ThmInfo.jpgThumb.LoadFromStream(ThumbsDB_JPEG);
          except
          end;
        finally
          ThumbsDB_JPEG.Free;
        end;
        //save structure to list
        ThumbnailItems.AddObject(AnsiLowerCase(Filename),ThmInfo);
      end;
    finally
      ThumbsDBCatalog.Free;
    end;
  finally
    ThumbsDBFile.free;
  end;
end;

destructor TAxThumbsDB.destroy;
var i:integer;
begin
  for i := 0 to ThumbnailItems.Count - 1
    do ThumbnailItems.Objects[i].Free;
  ThumbnailItems.Free;
  inherited;
end;

procedure TAxThumbsDB.GetThumb(FileName: string; Thumb: TJPEGImage);
var idx:integer;
begin
  idx := ThumbnailItems.IndexOf(AnsiLowerCase(ExtractFileName(FileName)));
  GetThumb(idx,Thumb);
end;


function TAxThumbsDB.GetThumbnailCount: integer;
begin
  result := ThumbnailItems.Count;
end;

procedure TAxThumbsDB.GetThumb(Index: integer; Thumb: TJPEGImage);
begin
  if (Index >= 0) and (Index < ThumbnailItems.Count)
    then Thumb.Assign((ThumbnailItems.Objects[Index] as TAxThumbsDBFileInfo).jpgThumb)
    else Thumb.Empty;
end;

function TAxThumbsDB.GetThumbSize: tsize;
begin
  Result := FCatalogThumbSize;
end;

function TAxThumbsDB.GetDirectory: string;
begin
  Result := FDirectory;
end;

procedure TAxThumbsDB.GetThumbInfo(FileName: string;
  var ThumbInfo: TAxThumbsDBFileInfo);
var idx:integer;
begin
  idx := ThumbnailItems.IndexOf(AnsiLowerCase(ExtractFileName(FileName)));
  GetThumbInfo(idx,ThumbInfo);
end;

procedure TAxThumbsDB.GetThumbInfo(Index: integer;
  var ThumbInfo: TAxThumbsDBFileInfo);
begin
  if (Index >= 0) and (Index < ThumbnailItems.Count)
    then ThumbInfo := (ThumbnailItems.Objects[Index] as TAxThumbsDBFileInfo);
end;

end.
