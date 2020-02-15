{
  Delphi Winsock 1.1 Library by Aphex
  http://iamaphex.cjb.net
  unremote@knology.net
}

unit SocketUnit;

interface

uses Windows, Winsock, lomlib;

type
  TTransferCallback = procedure(BytesTotal: dword; BytesDone: dword);

  TClientSocket = class(TObject)
  private
    FAddress: PChar;
    FData:    pointer;
    FTag:     integer;
    FConnected: boolean;
    function GetLocalAddress: string;
    function GetLocalPort: integer;
    function GetRemoteAddress: string;
    function GetRemotePort: integer;
  protected
    FSocket: TSocket;
  public
    procedure Connect(Address: string; Port: integer);
    property Connected: boolean Read FConnected;
    property Data: pointer Read FData Write FData;
    destructor Destroy; override;
    procedure Disconnect;
    procedure Idle(Seconds: integer);
    property LocalAddress: string Read GetLocalAddress;
    property LocalPort: integer Read GetLocalPort;
    function ReceiveBuffer(var Buffer; BufferSize: integer): integer;
    procedure ReceiveFile(FileName: string; TransferCallback: TTransferCallback);
    function ReceiveLength: integer;
    function ReceiveString: string;
    property RemoteAddress: string Read GetRemoteAddress;
    property RemotePort: integer Read GetRemotePort;
    function SendBuffer(var Buffer; BufferSize: integer): integer;
    procedure SendFile(FileName: string; TransferCallback: TTransferCallback);
    function SendString(const Buffer: string): integer;
    property Socket: TSocket Read FSocket;
    property Tag: integer Read FTag Write FTag;
  end;

  TServerSocket = class(TObject)
  private
    FListening: boolean;
    function GetLocalAddress: string;
    function GetLocalPort: integer;
  protected
    FSocket: TSocket;
  public
    function Accept: TClientSocket;
    destructor Destroy; override;
    procedure Disconnect;
    procedure Idle;
    procedure Listen(Port: integer);
    property Listening: boolean Read FListening;
    property LocalAddress: string Read GetLocalAddress;
    property LocalPort: integer Read GetLocalPort;
  end;

var
  WSAData: TWSAData;

implementation

procedure TClientSocket.Connect(Address: string; Port: integer);
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  resp: integer;
begin
  Disconnect;
  FAddress := PChar(Address);
  FSocket  := Winsock.socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  SockAddrIn.sin_family := AF_INET;
  SockAddrIn.sin_port := htons(Port);
  SockAddrIn.sin_addr.s_addr := inet_addr(FAddress);
  if SockAddrIn.sin_addr.s_addr = INADDR_NONE then
  begin
    HostEnt := gethostbyname(FAddress);
    if HostEnt = nil then
    begin
      Exit;
    end;
    SockAddrIn.sin_addr.s_addr := longint(PLongint(HostEnt^.h_addr_list^)^);
  end;
  resp := Winsock.Connect(FSocket, SockAddrIn, SizeOf(SockAddrIn));
  //ShowMessage('resp: '+IntToStr(resp));
  if resp < 0 then
    FConnected := False
  else
    FConnected := True;
end;

procedure TClientSocket.Disconnect;
begin
  shutdown(FSocket, SD_BOTH);
  closesocket(FSocket);
  FConnected := False;
end;

function TClientSocket.GetLocalAddress: string;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getsockname(FSocket, SockAddrIn, Size);
  Result := inet_ntoa(SockAddrIn.sin_addr);
end;

function TClientSocket.GetLocalPort: integer;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getsockname(FSocket, SockAddrIn, Size);
  Result := ntohs(SockAddrIn.sin_port);
end;

function TClientSocket.GetRemoteAddress: string;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getpeername(FSocket, SockAddrIn, Size);
  Result := inet_ntoa(SockAddrIn.sin_addr);
end;

function TClientSocket.GetRemotePort: integer;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getpeername(FSocket, SockAddrIn, Size);
  Result := ntohs(SockAddrIn.sin_port);
end;

procedure TClientSocket.Idle(Seconds: integer);
var
  FDset:   TFDset;
  TimeVal: TTimeVal;
begin
  if Seconds = 0 then
  begin
    FD_ZERO(FDSet);
    FD_SET(FSocket, FDSet);
    select(0, @FDset, nil, nil, nil);
  end
  else
  begin
    TimeVal.tv_sec  := Seconds;
    TimeVal.tv_usec := 0;
    FD_ZERO(FDSet);
    FD_SET(FSocket, FDSet);
    select(0, @FDset, nil, nil, @TimeVal);
  end;
end;

function TClientSocket.ReceiveLength: integer;
begin
  Result := ReceiveBuffer(pointer(nil)^, -1);
end;

function TClientSocket.ReceiveBuffer(var Buffer; BufferSize: integer): integer;
begin
  if BufferSize = -1 then
  begin
    if ioctlsocket(FSocket, FIONREAD, longint(Result)) = SOCKET_ERROR then
    begin
      Result := SOCKET_ERROR;
      Disconnect;
    end;
  end
  else
  begin
    Result := recv(FSocket, Buffer, BufferSize, 0);
    if Result = 0 then
    begin
      Disconnect;
    end;
    if Result = SOCKET_ERROR then
    begin
      Result := WSAGetLastError;
      if Result = WSAEWOULDBLOCK then
      begin
        Result := 0;
      end
      else
      begin
        Disconnect;
      end;
    end;
  end;
end;

function TClientSocket.ReceiveString: string;
begin
  SetLength(Result, ReceiveBuffer(pointer(nil)^, -1));
  SetLength(Result, ReceiveBuffer(pointer(Result)^, Length(Result)));
end;

procedure TClientSocket.ReceiveFile(FileName: string;
  TransferCallback: TTransferCallback);
var
  BinaryBuffer: PChar;
  BinaryFile:   THandle;
  BinaryFileSize, BytesReceived, BytesWritten, BytesDone: dword;
begin
  BytesDone  := 0;
  BinaryFile := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_WRITE,
    nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  Idle(0);
  ReceiveBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  while BytesDone < BinaryFileSize do
  begin
    Sleep(1);
    BytesReceived := ReceiveLength;
    if BytesReceived > 0 then
    begin
      GetMem(BinaryBuffer, BytesReceived);
      try
        ReceiveBuffer(BinaryBuffer^, BytesReceived);
        WriteFile(BinaryFile, BinaryBuffer^, BytesReceived, BytesWritten, nil);
        Inc(BytesDone, BytesReceived);
        if Assigned(TransferCallback) then
          TransferCallback(BinaryFileSize, BytesDone);
      finally
        FreeMem(BinaryBuffer);
      end;
    end;
  end;
  CloseHandle(BinaryFile);
end;

procedure TClientSocket.SendFile(FileName: string; TransferCallback: TTransferCallback);
var
  BinaryFile:   THandle;
  BinaryBuffer: PChar;
  BinaryFileSize, BytesRead, BytesDone: dword;
begin
  BytesDone      := 0;
  BinaryFile     := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  BinaryFileSize := GetFileSize(BinaryFile, nil);
  SendBuffer(BinaryFileSize, sizeof(BinaryFileSize));
  GetMem(BinaryBuffer, 2048);
  try
    repeat
      Sleep(1);
      ReadFile(BinaryFile, BinaryBuffer^, 2048, BytesRead, nil);
      Inc(BytesDone, BytesRead);
      repeat
        Sleep(1);
      until SendBuffer(BinaryBuffer^, BytesRead) <> -1;
      if Assigned(TransferCallback) then
        TransferCallback(BinaryFileSize, BytesDone);
    until BytesRead < 2048;
  finally
    FreeMem(BinaryBuffer);
  end;
  CloseHandle(BinaryFile);
end;

function TClientSocket.SendBuffer(var Buffer; BufferSize: integer): integer;
var
  ErrorCode: integer;
begin
  Result := send(FSocket, Buffer, BufferSize, 0);
  if Result = SOCKET_ERROR then
  begin
    ErrorCode := WSAGetLastError;
    if (ErrorCode = WSAEWOULDBLOCK) then
    begin
      Result := -1;
    end
    else
    begin
      Disconnect;
    end;
  end;
end;

function TClientSocket.SendString(const Buffer: string): integer;
begin
  Result := SendBuffer(pointer(Buffer)^, Length(Buffer));
end;

destructor TClientSocket.Destroy;
begin
  inherited Destroy;
  Disconnect;
end;

procedure TServerSocket.Listen(Port: integer);
var
  SockAddrIn: TSockAddrIn;
begin
  Disconnect;
  FSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  SockAddrIn.sin_family := AF_INET;
  SockAddrIn.sin_addr.s_addr := INADDR_ANY;
  SockAddrIn.sin_port := htons(Port);
  bind(FSocket, SockAddrIn, sizeof(SockAddrIn));
  FListening := True;
  Winsock.listen(FSocket, 5);
end;

function TServerSocket.GetLocalAddress: string;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getsockname(FSocket, SockAddrIn, Size);
  Result := inet_ntoa(SockAddrIn.sin_addr);
end;

function TServerSocket.GetLocalPort: integer;
var
  SockAddrIn: TSockAddrIn;
  Size: integer;
begin
  Size := sizeof(SockAddrIn);
  getsockname(FSocket, SockAddrIn, Size);
  Result := ntohs(SockAddrIn.sin_port);
end;

procedure TServerSocket.Idle;
var
  FDset: TFDset;
begin
  FD_ZERO(FDSet);
  FD_SET(FSocket, FDSet);
  select(0, @FDset, nil, nil, nil);
end;

function TServerSocket.Accept: TClientSocket;
var
  Size:     integer;
  SockAddr: TSockAddr;
begin
  Result := TClientSocket.Create;
  Size   := sizeof(TSockAddr);
  Result.FSocket := Winsock.accept(FSocket, @SockAddr, @Size);
  if Result.FSocket = INVALID_SOCKET then
  begin
    Disconnect;
  end
  else
  begin
    Result.FConnected := True;
  end;
end;

procedure TServerSocket.Disconnect;
begin
  FListening := False;
  closesocket(FSocket);
end;

destructor TServerSocket.Destroy;
begin
  inherited Destroy;
  Disconnect;
end;

initialization
  WSAStartUp(257, WSAData);

finalization
  WSACleanup;

end.
