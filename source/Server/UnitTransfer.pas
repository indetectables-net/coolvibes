unit UnitTransfer;

interface

uses SysUtils, SocketUnit, Unitvariables;

type
  TThreadInfo = class(TObject)
  public
    host: string;
    port: Integer;
    SH: string;
    Action: string;
    FileName: AnsiString;
    Alias: AnsiString;
    RemoteFileName: AnsiString;
    ThreadId: Longword;
    Beginning: Integer;
    UploadSize: Int64;
    deleteAfterTransfer: Boolean;
    Hash: string;
    constructor Create(pHost: string; pPort: Integer; pSH, pFilename, pAction: AnsiString;
      pBeginning: Integer); overload;

  end;

procedure ThreadedTransfer(Parameter: Pointer);
procedure sendFile(MySock: TClientSocket; Path: AnsiString; Beginning: Int64);
procedure getFile(MySock: TClientSocket; localPath: AnsiString; filesize: Integer;DisconnectonFinish:boolean);
function leerLinea(MySock: TClientSocket): string;
function MyGetFileSize(path: string): Int64;


implementation

constructor TThreadInfo.Create(pHost: string; pPort: Integer;
  pSH, pFilename, pAction: AnsiString; pBeginning: Integer);
begin
  Host := pHost;
  Port := pPort;
  SH := pSH;
  FileName := pFileName;
  Alias := '';
  Action := pAction;
  Beginning := pBeginning;
end;

function leerLinea(MySock: TClientSocket): string;
var
  buf: char;
begin
  buf := ' ';
  while buf <> #10 do
    begin
      MySock.ReceiveBuffer(buf, 1);
      Result := Result + buf;
    end;
  Result := Trim(Result);
end;

procedure ThreadedTransfer(Parameter: Pointer);
var
  ThreadInfo: TThreadInfo;
  SocketTransf: TClientSocket;
  FileSize: Integer;
  aux: string;
begin
  ThreadInfo := TThreadInfo(Parameter);

  try

    SocketTransf := TClientSocket.Create;
    SocketTransf.Connect(ThreadInfo.host, ThreadInfo.port);

    if SocketTransf.Connected then
      begin
        //informamos a cual conexion principal pertenecemos
        SocketTransf.SendString('SH|' + ThreadInfo.SH + ENTER);
        FileSize := MyGetFileSize(ThreadInfo.FileName);
        if ThreadInfo.Action <> 'SENDFILE' then
          begin
            if trim(ThreadInfo.Alias) <> '' then
              SocketTransf.SendString(ThreadInfo.Action + '|' + ThreadInfo.Alias +
                '|' + IntToStr(FileSize) + ENTER)
            else
              SocketTransf.SendString(ThreadInfo.Action + '|' + ThreadInfo.FileName +
                '|' + IntToStr(FileSize) + ENTER);

            if fileexists(ThreadInfo.FileName) then //poco probable pero podría pasar
              SendFile(SocketTransf, ThreadInfo.FileName, ThreadInfo.Beginning);
          end
        else
          begin
            SocketTransf.SendString(ThreadInfo.Action + '|' + ThreadInfo.Hash + '|' + ThreadInfo.RemoteFileName + ENTER);
            leerLinea(SocketTransf); //la linea de maininfo que me m andan al conectarme
            getFile(SocketTransf, ThreadInfo.FileName, ThreadInfo.UploadSize, true);
          end;
        if ThreadInfo.deleteAfterTransfer then
          DeleteFile(PChar(ThreadInfo.FileName));
        //closeHandle(threadInfo.ThreadId);
      end;

  except

  end; //try-Except
end;

procedure sendFile(MySock: TClientSocket; Path: AnsiString; Beginning: Int64);
var
  myFile: file;
  byteArray: array[0..1023] of Byte;
  Count, filesize: Integer;
begin
  try
    filesize := MyGetFileSize(path);
    if not filesize > 0 then
      begin
        MySock.SendString('ERROR' + ENTER);
        Exit;
      end
    else
      FileMode := $0000; //read only
    AssignFile(myFile, path);
    try
      reset(MyFile, 1);
    except
      MySock.SendString('ERROR' + ENTER);
      Exit;
    end;
    MySock.SendString('START' + ENTER);

    seek(myFile, beginning);
    while not EOF(MyFile) and Mysock.Connected do
      begin
        BlockRead(myFile, byteArray, 1024, Count);
        Mysock.SendBuffer(bytearray, Count);
      end;
    closefile(myfile);
  except
    closefile(myfile);
  end;
end;

procedure getFile(MySock: TClientSocket; localPath: AnsiString; filesize: Integer;DisconnectonFinish:boolean);
var
  myFile: file;
  byteArray: array[0..1023] of Byte;
  TotalRead, currRead: Integer;
  CurrWritten: Integer;
  Excepcion: Boolean;
begin
  try
    Excepcion := False;
    AssignFile(MyFile, localPath);
    Rewrite(MyFile, 1);
    Totalread := 0;
    currRead := 0;
    while ((TotalRead < filesize) and mysock.Connected) do
      begin
        currRead := MySock.ReceiveBuffer(byteArray, SizeOf(bytearray));
        TotalRead := TotalRead + currRead;
        if mysock.Connected then
          BlockWrite(MyFile, bytearray, currRead, currwritten);
        currwritten := currread;
      end;
  except
    Excepcion := True;
    CloseFile(MyFile);
    if MySock.Connected then
      MySock.Disconnect;
    MySock.Free;
  end;
  if not Excepcion then
    begin
      CloseFile(MyFile);
      if DisconnectonFinish then
      begin
        if MySock.Connected then
          MySock.Disconnect;
        MySock.Free;
      end;
    end;
end;

function MyGetFileSize(path: string): Int64;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(path, faAnyFile, SearchRec) = 0 then // if found

    Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32) +
      // calculate the size
    Int64(SearchREc.FindData.nFileSizeLow)
  else
    Result := -1;
  findclose(SearchRec);
end;

end.
