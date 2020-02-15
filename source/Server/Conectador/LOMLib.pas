{-----------------------------------------------------------------------
  LOMLIB release 3.1

  Copyright - Use and abuse, but dont remove this header from code, and
              gimme a shoutout if you used it.

  Author: ~LOM~
  Website: www.lommage.co.uk
  Contact: mail@lommage.co.uk

  Updates:
  ~~~~~~~~

  TStrList[0.5]     :- Replacement for TStringList
  TIntList[0.1]     :- IntList (I use this for modifying and recording Socket ID's)
  TEditServer[0.1]  :- Quick edit server, based on TStrList Class, allows you
                       to create edit server code efficiently. (Also has
                       encryption).
  TBasicStream[0.1] :- Wrapper for Windows Readfile/Writefile routines.
  TMapStream[0.1]   :- Wrapper for Mapping a file

  21st October -
    Fixed a bug in Position (when reading / writing)

  15th September -
    Added some smaller functions from the sysutils pas

  13th September -
    Added TMapStream class

  12th September -
    Added class TBasicStream
    Added manipulation subroutines

  10th September -
    Added class TIntList
    Added class TEditServer

  -----------------------------------------------------------------------
}

unit LOMLib;

interface

uses Windows;

const
  MEM_USAGE = 65535;  { Array buffer, modify this if your storage will be > 65535 }
  CLRF      = #10#13; { works with just #13 for some files?!?!?! }
  SPLITDELIMITER = '£$%!'; { Used for settings splitting }
  CHUNKSIZE = 5120;   { Best chunk reading size for low stealth and drain on system }

  BACKSLASH = '\';

  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faAnyFile   = $0000003F;

type
  { Flag options for finding a string in a string }
  TfndFlags = (fndExact, fndIgnoreCase, fndPartial);

  { StrList Class }
  TStrList = class(TObject)
  private
    varCount: integer;
  public
    Strings: array [0..MEM_USAGE] of string;

    constructor Create;
    destructor Destroy;

    procedure SaveToFile(Filename: string);
    procedure LoadFromFile(Filename: string);

    procedure Add(Text: string);
    procedure Delete(Index: integer);
    procedure Clear;

    { Result Code = -1 if not found }
    function Find(TextFind: string; Flag: TfndFlags = fndExact): integer;

    { Subroutines for .Text }
    function TextRead: string;
    procedure TextModify(Input: string);

    property Count: integer Read varCount;
    property Text: string Read TextRead Write TextModify;
  end;

  { Create a virtual handler array for a TListView beta }
  TLOMVirtualListView = array [0..5] of TStrList;

  { IntList Class }
  TIntList = class(TObject)
  private
    varCount: integer;
  public
    Integers: array [0..MEM_USAGE] of integer;

    constructor Create;
    destructor Destroy;

    procedure Add(Number: integer);
    procedure Delete(Index: integer);
    procedure Clear;

    { Result Code = -1 if not found }
    function Find(NumberFind: integer): integer;

    property Count: integer Read varCount;
  end;

  { IEditServer Class }
  TEditServer = class(TObject)
  private
    function EncryptSettings(Str: string): string;
    function DecryptSettings(Str: string): string;
  public
    Settings: TStrList;
    Key:      string;

    constructor Create;
    destructor Destroy;

    function ReadSettings(InputFilename: string = ''): boolean;
    function WriteSettings(OutputFilename: string): boolean;
  end;

  { TBasicStream Class }
  TBasicStream = class(TObject)
  private
    FHandle:   THandle;
    FPosition: integer;

    procedure PositionSet(varPosition: integer);
  public
    constructor Create;
    destructor Destroy;

    function OpenFile(Filename: string; CreateFlag, Access: DWORD): boolean;
    procedure CloseFile;

    function ReadFile(var Buffer; Size: longint): longint;
    function WriteFile(var Buffer; Size: longint): longint;

    function ReadString: string;
    procedure WriteString(const Input: string);

    function GetFileSize: longint;

    { Important when writing data storages }
    property Position: integer Read FPosition Write PositionSet;
  end;

  { Modify this structure for global options }
  TMapStructure = record
    szInteger: integer;
    szDWORD:   DWORD;
    Instances: DWORD;
    szChars:   array [0..40960] of char;
  end;
  PMapStructure = ^TMapStructure;

  { TMapStream Class }
  TMapStream = class(TObject)
  private
    FHandle: THandle;
    FInstanceActive: boolean;
  public
    MapInformation: PMapStructure;
    ShareName:      string;

    constructor Create;
    destructor Destroy;

    function Start: boolean;
    procedure Stop;
  end;

  TFileName = type string;

  TSearchRec = record
    Time:     integer;
    Size:     integer;
    Attr:     integer;
    Name:     TFileName;
    ExcludeAttr: integer;
    FindHandle: THandle platform;
    FindData: TWin32FindData platform;
  end;

  LongRec = packed record
    case integer of
      0: (Lo, Hi: word);
      1: (Words: array [0..1] of word);
      2: (Bytes: array [0..3] of byte);
  end;

{ String manipulation }
function IntToStr(Value: integer): string;
function StrToInt(Value: string): integer;

function LowerCase(const S: string): string;
function Trim(const S: string): string;
function RandStr(Length: integer): string;
function StrPCopy(Dest: PChar; const Source: string): PChar;

function ExtractFileExtension(Delimiter, Input: string): string;
function ExtractFilePath(FileName: string): string;
function ExtractFileName(FileName: string): string;

function StrLen(const Str: PChar): cardinal; assembler;

{ File manipulation }
function FileExists(const FileName: string): boolean;
function DirectoryExists(const Name: string): boolean;

function FindFirst(const Path: string; Attr: integer; var F: TSearchRec): integer;
procedure FindClose(var F: TSearchRec);
function FindMatchingFile(var F: TSearchRec): integer;
function FindNext(var F: TSearchRec): integer;

{ Window manipulation }
procedure ShowMessage(Msg: string);
procedure ProcessMessages;
procedure Wait(MilliSec: integer);

{ StrList manipulation }
procedure StrToStrList(Str, Del: string; var List: TStrList; Len: integer);

{ System manipulation }
function GetDirectory(Index: integer): string;
function GetName(Index: integer): string;

function AllocMem(Size: cardinal): Pointer;

var
  Win32Platform: integer = 0;

implementation

procedure InitPlatformId;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
      Win32Platform := dwPlatformId;
      {Win32MajorVersion := dwMajorVersion;
      Win32MinorVersion := dwMinorVersion;
      Win32BuildNumber := dwBuildNumber;
      Win32CSDVersion := szCSDVersion;}
    end;
end;

procedure FindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindMatchingFile(var F: TSearchRec): integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;

    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, LongRec(Time).Lo);

    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;

  Result := 0;
end;

function FindNext(var F: TSearchRec): integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F)
  else
    Result := GetLastError;
end;

function FindFirst(const Path: string; Attr: integer; var F: TSearchRec): integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle  := FindFirstFile(PChar(Path), F.FindData);

  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then
      FindClose(F);
  end
  else
    Result := GetLastError;
end;

function IntToStr(Value: integer): string;
begin
  Str(Value, Result);
end;

function StrToInt(Value: string): integer;
var
  ErrorAt: integer;
begin
  val(Value, Result, ErrorAt);
end;

{ Taken from SysUtils.pas }
function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: cardinal): PChar; assembler;
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EBX
         MOV     ESI,EAX
         MOV     EDI,EDX
         MOV     EBX,ECX
         XOR     AL,AL
         TEST    ECX,ECX
         JZ      @@1
         REPNE   SCASB
         JNE     @@1
         INC     ECX
         @@1:
         SUB     EBX,ECX
         MOV     EDI,ESI
         MOV     ESI,EDX
         MOV     EDX,EDI
         MOV     ECX,EBX
         SHR     ECX,2
         REP     MOVSD
         MOV     ECX,EBX
         AND     ECX,3
         REP     MOVSB
         STOSB
         MOV     EAX,EDX
         POP     EBX
         POP     ESI
         POP     EDI
end;

{ Taken from SysUtils.pas }
function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;

function StrLen(const Str: PChar): cardinal; assembler;
asm
         MOV     EDX,EDI
         MOV     EDI,EAX
         MOV     ECX,0FFFFFFFFH
         XOR     AL,AL
         REPNE   SCASB
         MOV     EAX,0FFFFFFFEH
         SUB     EAX,ECX
         MOV     EDI,EDX
end;

{ Taken from SysUtils.pas }
function LowerCase(const S: string): string;
var
  Ch: char;
  L:  integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest   := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then
      Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

{ Taken from Sysutils.pas }
function Trim(const S: string): string;
var
  I, L: integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do
    Inc(I);
  if I > L then
    Result := ''
  else
  begin
    while S[L] <= ' ' do
      Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function RandStr(Length: integer): string;
var
  i: integer;
begin
  Randomize;
  SetLength(Result, Length);
  for i := 1 to Length do
    Result[i] := Chr(Random(24) + 97);
end;

function ExtractFileExtension(Delimiter, Input: string): string;
begin
  while Pos(Delimiter, Input) <> 0 do
    Delete(Input, 1, Pos(Delimiter, Input));
  Result := Input;
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure Wait(MilliSec: integer);
var
  DoneTime: integer;
begin
  DoneTime := GetTickCount + MilliSec;
  while (DoneTime > GetTickCount) do
    ProcessMessages;
end;

function GetDirectory(Index: integer): string;
var
  pDir: array [0..255] of char;
begin
  FillChar(pDir, 255, #0);
  case Index of
    0: GetWindowsDirectory(pDir, 255);
    1: GetSystemDirectory(pDir, 255);
    2: GetTempPath(255, pDir);
  end;
  Result := string(pDir) + '\';
end;

function GetName(Index: integer): string;
var
  pName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of char;
  Size:  cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  FillChar(pName, Size, #0);
  case Index of
    0: GetComputerName(pName, Size);
    1: GetUserName(pName, Size);
  end;
  Result := string(pName);
end;

procedure ShowMessage(Msg: string);
begin
  MessageBox(0, PChar(Msg), '', 0);
end;

function ExtractFilePath(FileName: string): string;
var
  Position: integer;
begin
  Result := '';
  while True do
  begin
    Position := Pos(BACKSLASH, FileName);
    if Position > 0 then
    begin
      Result := Result + Copy(FileName, 1, Position);
      Delete(FileName, 1, Position);
    end
    else
      Break;
  end;
end;

function ExtractFileName(FileName: string): string;
var
  Position: integer;
begin
  Result := '';
  while True do
  begin
    Position := Pos(BACKSLASH, FileName);
    if Position > 0 then
      Delete(FileName, 1, Position)
    else
      Break;
  end;
  Result := FileName;
end;

function FileExists(const FileName: string): boolean;
var
  lpFindFileData: TWin32FindData;
  hFile: cardinal;
begin
  Result := False;
  hFile  := FindFirstFile(PChar(FileName), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(hFile);
    Result := True;
  end;
end;

function DirectoryExists(const Name: string): boolean;
var
  Code: integer;
begin
  Code   := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

procedure StrToStrList(Str, Del: string; var List: TStrList; Len: integer);
var
  PosOfSlash: integer;
begin
  List.Clear;
  while Length(Str) > 0 do
  begin
    PosOfSlash := Pos(Del, Str);
    if PosOfSlash = 0 then
      PosOfSlash := length(Str) + 1;
    List.Add(Copy(Str, 1, PosOfSlash - 1));

    Str := Copy(Str, PosOfSlash + Len, Length(Str) - PosOfSlash);
  end;
end;

function AllocMem(Size: cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

{ TStrList Class }

constructor TStrList.Create;
begin
  varCount := 0; { Flag counter at 0 }
end;

destructor TStrList.Destroy;
begin
  Clear;
  varCount := 0;
end;

procedure TStrList.LoadFromFile(FileName: string);
var
  F:   TextFile;
  ReadContent: string;
  Len: longint;
begin
  Clear; { Clear the list then load }

  AssignFile(F, FileName);
  Reset(F);

  while not EOF(F) do
  begin
    Readln(F, ReadContent);
    Strings[varCount] := ReadContent;
    Inc(varCount);
  end;

  CloseFile(F);
end;

procedure TStrList.SaveToFile(Filename: string);
var
  F: TextFile;
  i: integer;
begin
  AssignFile(F, Filename);
  ReWrite(F);
  for i := 0 to varCount - 1 do
    WriteLn(F, Strings[i]);
  CloseFile(F);
end;

procedure TStrList.Add(Text: string);
begin
  Strings[varCount] := Text;
  Inc(varCount);
end;

procedure TStrList.Clear;
var
  i: integer;
begin
  for i := 0 to varCount - 1 do
    Strings[i] := '';
  varCount := 0;
end;

function TStrList.Find(TextFind: string; Flag: TfndFlags = fndExact): integer;
var
  i: integer;
begin
  Result := -1;

  case Flag of
    fndExact:
      for i := 0 to varCount - 1 do
        if Strings[i] = TextFind then
        begin
          Result := i;
          Break;
        end;

    fndIgnoreCase:
      for i := 0 to varCount - 1 do
        if lstrcmp(PChar(Strings[i]), PChar(TextFind)) = 0 then
        begin
          Result := i;
          Break;
        end;

    fndPartial:
      for i := 0 to varCount - 1 do
        if Pos(TextFind, Strings[i]) > 0 then
        begin
          Result := i;
          Break;
        end;
  end;
end;

procedure TStrList.Delete(Index: integer);
var
  TempArray:    array of string;
  i, Increment: integer;
begin
  if (Index < 0) or (Index >= varCount) or (varCount = 0) then
    Exit;

  Dec(varCount);
  SetLength(TempArray, varCount);
  Increment := 0;

  for i := 0 to varCount do
    if i <> Index then
    begin
      TempArray[Increment] := Strings[i];
      Inc(Increment);
    end;

  for i := 0 to varCount - 1 do
    Strings[i] := TempArray[i];
  TempArray := nil;
end;

function TStrList.TextRead: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to varCount - 1 do
    Result := Result + Strings[i] + CLRF;

  { Remove CLRF }
  Result := Copy(Result, 1, Length(Result) - Length(CLRF));
end;

procedure TStrList.TextModify(Input: string);
var
  i: integer;
begin
  Clear;
  repeat
    i := Pos(CLRF, Input);

    if i > 0 then
    begin
      Strings[varCount] := Copy(Input, 1, i - 1);
      System.Delete(Input, 1, i + 1);
    end
    else
      Strings[varCount] := Input;

    Inc(varCount);
  until i = 0;
end;

{ TIntList Class }

constructor TIntList.Create;
begin
  varCount := 0; { Flag counter at 0 }
end;

destructor TIntList.Destroy;
begin
  Clear;
  varCount := 0;
end;

procedure TIntList.Add(Number: integer);
begin
  Integers[varCount] := Number;
  Inc(varCount);
end;

procedure TIntList.Clear;
var
  i: integer;
begin
  for i := 0 to varCount - 1 do
    Integers[i] := 0;
  varCount := 0;
end;

function TIntList.Find(NumberFind: integer): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to varCount - 1 do
    if Integers[i] = NumberFind then
    begin
      Result := i;
      Break;
    end;
end;

procedure TIntList.Delete(Index: integer);
var
  TempArray:    array of integer;
  i, Increment: integer;
begin
  if (Index < 0) or (Index >= varCount) or (varCount = 0) then
    Exit;

  Dec(varCount);
  SetLength(TempArray, varCount);
  Increment := 0;

  for i := 0 to varCount do
    if i <> Index then
    begin
      TempArray[Increment] := Integers[i];
      Inc(Increment);
    end;

  for i := 0 to varCount - 1 do
    Integers[i] := TempArray[i];
  TempArray := nil;
end;

{ TEditServer Class }

constructor TEditServer.Create;
begin
  Settings := TStrList.Create;
  Key      := '8ytuerbvb4bhjkjthjfbgj43'; { Default Key if none is inputted }
end;

destructor TEditServer.Destroy;
begin
  Settings.Free;
end;

function TEditServer.EncryptSettings(Str: string): string;
var
  X, Y: integer;
  A:    byte;
begin
  Y := 1;
  for X := 1 to Length(Str) do
  begin
    A      := (Ord(Str[X]) and $0f) xor (Ord(Key[Y]) and $0f);
    Str[X] := char((Ord(Str[X]) and $f0) + A);
    Inc(Y);
    if Y > length(Key) then
      Y := 1;
  end;
  Result := Str;
end;

function TEditServer.DecryptSettings(Str: string): string;
var
  X, Y: integer;
  A:    byte;
begin
  Y := 1;
  for X := 1 to Length(Str) do
  begin
    A      := (Ord(Str[X]) and $0f) xor (Ord(Key[Y]) and $0f);
    Str[X] := char((Ord(Str[X]) and $f0) + A);
    Inc(Y);
    if Y > length(Key) then
      Y := 1;
  end;
  Result := Str;
end;

function TEditServer.ReadSettings(InputFilename: string = ''): boolean;
var
  Input:     THandle;
  SettingLength: longint;
  BytesRead: cardinal;
  TempSettings: string;
begin
  Result := False;
  if Length(InputFilename) = 0 then
    InputFilename := ParamStr(0);
  Input := CreateFile(PChar(InputFilename), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  if Input > 0 then
  begin
    SetFilePointer(Input, -SizeOf(longint), nil, FILE_END);
    ReadFile(Input, SettingLength, SizeOf(longint), BytesRead, nil);

    if (BytesRead > 0) and (SettingLength > 0) then
    begin
      SetFilePointer(Input, -Sizeof(longint) - SettingLength, nil, FILE_END);
      SetLength(TempSettings, SettingLength);

      if BytesRead > 0 then
      begin
        ReadFile(Input, TempSettings[1], SettingLength, BytesRead, nil);
        TempSettings := DecryptSettings(TempSettings);
        StrToStrList(TempSettings, SPLITDELIMITER, Settings, Length(SPLITDELIMITER));
        Result := True;
      end;
    end;

    CloseHandle(Input);
  end;
end;

function TEditServer.WriteSettings(OutputFilename: string): boolean;
var
  i: integer;
  TempSettings: string;

  Output: THandle;
  BytesWritten, BytesRead: cardinal;

  SettingsLength: longint;
begin
  Result := False;

  if FileExists(OutputFilename) then
  begin
    Output := CreateFile(PChar(OutputFilename), GENERIC_READ or
      GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    if Output > 0 then
    begin
      SetFilePointer(Output, -SizeOf(longint), nil, FILE_END);
      ReadFile(Output, SettingsLength, SizeOf(longint), BytesRead, nil);

      { Settings already exist? }
      if SettingsLength <= 0 then
      begin
        SetFilePointer(Output, -SizeOf(longint), nil, FILE_END);
        for i := 0 to Settings.Count - 1 do
          TempSettings := TempSettings + Settings.Strings[i] + SPLITDELIMITER;
        TempSettings := EncryptSettings(TempSettings);
        WriteFile(Output, PChar(TempSettings)^, Length(TempSettings), BytesWritten, nil);

        if BytesWritten > 0 then
        begin
          SettingsLength := Length(TempSettings);
          WriteFile(Output, SettingsLength, SizeOf(longint), BytesWritten, nil);
          Result := True;
        end;
      end;
      CloseHandle(Output);
    end;
  end;
end;

{ TBasicStream Class }

constructor TBasicStream.Create;
begin
  FHandle   := 0;
  FPosition := 0;
end;

destructor TBasicStream.Destroy;
begin
  CloseFile;
end;

function TBasicStream.OpenFile(Filename: string; CreateFlag, Access: DWORD): boolean;
begin
  Result  := False;
  FHandle := CreateFile(PChar(Filename), Access, FILE_SHARE_READ, nil,
    CreateFlag, FILE_ATTRIBUTE_NORMAL, 0);

  if FHandle > 0 then
  begin
    PositionSet(0);
    FPosition := 0;
    Result    := True;
  end;
end;

procedure TBasicStream.CloseFile;
begin
  if FHandle > 0 then
    CloseHandle(FHandle);
end;

function TBasicStream.ReadFile(var Buffer; Size: longint): longint;
var
  BytesRead: cardinal;
begin
  Windows.ReadFile(FHandle, Buffer, Size, BytesRead, nil);
  Result    := BytesRead;
  FPosition := FPosition + Result;
end;

function TBasicStream.WriteFile(var Buffer; Size: longint): longint;
var
  BytesWritten: cardinal;
begin
  Windows.WriteFile(FHandle, Buffer, Size, BytesWritten, nil);
  Result    := BytesWritten;
  FPosition := FPosition + Result;
end;

function TBasicStream.ReadString: string;
var
  Buffer: array [0..CHUNKSIZE] of char;
begin
  Result := '';
  PositionSet(0);
  SetLength(Result, GetFileSize);

  repeat
  until ReadFile(Result[1], CHUNKSIZE) <= CHUNKSIZE;
end;

procedure TBasicStream.WriteString(const Input: string);
begin
  WriteFile(PChar(Input)^, Length(Input));
end;

function TBasicStream.GetFileSize: longint;
begin
  Result := Windows.GetFileSize(FHandle, nil);
end;

procedure TBasicStream.PositionSet(varPosition: integer);
begin
  FPosition := varPosition;
  SetFilePointer(FHandle, FPosition, 0, FILE_BEGIN);
end;

{ TMapStream Class }

constructor TMapStream.Create;
begin
  FHandle := 0;
end;

destructor TMapStream.Destroy;
begin
  Stop;
  FHandle := 0;
end;

function TMapStream.Start: boolean;
begin
  Result := False;
  if Length(ShareName) = 0 then
    Exit;

  FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(ShareName));
  if FHandle = 0 then
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      SizeOf(TMapStructure), PChar(ShareName));

  if FHandle > 0 then
  begin
    MapInformation := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    Inc(MapInformation^.Instances);
    Result := True;
  end;

  FInstanceActive := Result;
end;

procedure TMapStream.Stop;
begin
  if FInstanceActive then
  begin
    Dec(MapInformation^.Instances);
    if MapInformation^.Instances = 0 then
    begin
      UnmapViewOfFile(MapInformation);
      CloseHandle(FHandle);
    end;
  end;
end;

initialization
  InitPlatformId;
end.
