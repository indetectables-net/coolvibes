unit IPHelp;

interface

uses Windows, Sysutils, Classes, WinSock;

const
  TCPIP_OWNING_MODULE_SIZE = 32;

type
  //TCP
  MIB_TCPROW = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
  end;
  PMIB_TCPROW = ^MIB_TCPROW;

  MIB_TCPTABLE = record
    dwNumEntries: DWORD;
    table: array[0..0] of MIB_TCPROW;
  end;
  PMIB_TCPTABLE = ^MIB_TCPTABLE;

 MIB_TCPROW_OWNER_MODULE = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    pOwningModuleInfo: array[1..TCPIP_OWNING_MODULE_SIZE] of Pointer;
  end;
  PMIB_TCPROW_OWNER_MODULE = ^MIB_TCPROW_OWNER_MODULE;

  MIB_TCPTABLE_OWNER_MODULE = record
    dwNumEntries: DWORD;
    table: array[0..0] of MIB_TCPROW_OWNER_MODULE;
  end;
  PMIB_TCPTABLE_OWNER_MODULE = ^MIB_TCPTABLE_OWNER_MODULE;

  TCPIP_OWNER_MODULE_BASIC_INFO = record
    pModuleName: PWCHAR;
    pModulePath: PWCHAR;
  end;
  PTCPIP_OWNER_MODULE_BASIC_INFO = ^TCPIP_OWNER_MODULE_BASIC_INFO;

  TCP_TABLE_CLASS =
  (
   TCP_TABLE_BASIC_LISTENER,
   TCP_TABLE_BASIC_CONNECTION,
   TCP_TABLE_BASIC_ALL,
   TCP_TABLE_OWNER_PID_LISTENER,
   TCP_TABLE_OWNER_PID_CONNECTIONS,
   TCP_TABLE_OWNER_PID_ALL,
   TCP_TABLE_OWNER_MODULE_LISTENER,
   TCP_TABLE_OWNER_MODULE_CONNECTIONS,
   TCP_TABLE_OWNER_MODULE_ALL
  );

  TCPIP_OWNER_MODULE_INFO_CLASS =
  (
   TCPIP_OWNER_MODULE_INFO_BASIC
  );


  // UDP
  MIB_UDPROW = record
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
  end;
  PMIB_UDPROW = ^MIB_UDPROW;

  MIB_UDPTABLE = record
    dwNumEntries: DWORD;
    table: array[0..0] of MIB_UDPROW;
  end;
  PMIB_UDPTABLE = ^MIB_UDPTABLE;

  UDP_TABLE_CLASS =
  (
   UDP_TABLE_BASIC,
   UDP_TABLE_OWNER_PID,
   UDP_TABLE_OWNER_MODULE
  );

  MIB_UDPROW_OWNER_MODULE = record
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwOwningPid: DWORD;
    liCreateTimestamp: LARGE_INTEGER;
    dwFlags: DWORD;
    pOwningModuleInfo: array[1..TCPIP_OWNING_MODULE_SIZE] of Pointer;
  end;
  PMIB_UDPROW_OWNER_MODULE = ^MIB_UDPROW_OWNER_MODULE;

  MIB_UDPTABLE_OWNER_MODULE = record
    dwNumEntries: DWORD;
    table: array[0..0] of MIB_UDPROW_OWNER_MODULE;
  end;
  PMIB_UDPTABLE_OWNER_MODULE = ^MIB_UDPTABLE_OWNER_MODULE;

var
  Modulo: HMODULE;

  // TCP
  GetTcpTable: function (
    pTcpTable: PMIB_TCPTABLE;
    var pdwSize: DWORD;
    bOrder: BOOL): DWORD; stdcall;

  GetExtendedTcpTable: function (
    pTcpTable: Pointer;
    var dwSize: DWORD;
    bOrder: BOOL;
    ulAf: ULONG;
    TableClass: TCP_TABLE_CLASS;
    Reserved: ULONG): DWORD; stdcall;

  GetOwnerModuleFromTcpEntry: function (
    pTcpEntry: PMIB_TCPROW_OWNER_MODULE;
    InfoClass: TCPIP_OWNER_MODULE_INFO_CLASS;
    Buffer: Pointer;
    var dwSize: DWORD): DWORD; stdcall;

  // UDP  
  GetUdpTable: function (
   pUdpTable: PMIB_UDPTABLE;
   var pdwSize: DWORD;
   bOrder: BOOL): DWORD; stdcall;

  GetExtendedUdpTable: function (
    pUdpTable: Pointer;
    var pdwSize: DWORD;
    bOrder: BOOL;
    ulAf: ULONG;
    TableClass: UDP_TABLE_CLASS;
    Reserved: ULONG): DWORD; stdcall;

  GetOwnerModuleFromUdpEntry: function (
    pUdpEntry: PMIB_UDPROW_OWNER_MODULE;
    InfoClass: TCPIP_OWNER_MODULE_INFO_CLASS;
    Buffer: Pointer;
    var pdwSize: DWORD): DWORD; stdcall;
    
  SetTcpEntry: function (pTCPRow: PMIB_TCPROW):DWORD;stdcall;

  // Si esta a TRUE se intenta averiguar el nombre que corresponde a cada Ip
  ResolveAddress: Boolean = FALSE;
  // Si esta a TRUE no se utiliza la cache
  NoCache: Boolean = FALSE;
  // Si esta a TRUE la Cache no se utiliza con los PIDs (Nombres de los modulos)
  NoCachePIDs: Boolean = FALSE;

// Devuelve TRUE si encuentra las funciones necesarias
function TcpTableExists: Boolean;
// Devuelve TRUE si encuentra las funciones necesarias (XP SP2 o superiores)
function TcpExTableExists: Boolean;
// Devuelve TRUE si encuentra las funciones necesarias
function UdpTableExists: Boolean;
// Devuelve TRUE si encuentra las funciones necesarias (XP SP2 o superiores)
function UdpExTableExists: Boolean;
// Borra la cache
procedure ClearCache;
// Devuleve el nombre que corresponde a la IP
function IPToStr(IP: DWORD): string;
// Devuelve el nombre del modulo al que pertenece la conexion
function GetOwnerModuleTCP(var TcpEntry: MIB_TCPROW_OWNER_MODULE): string;
// Devuelve el nombre del modulo al que pertenece la conexion
function GetOwnerModuleUDP(var UdpEntry: MIB_UDPROW_OWNER_MODULE): string;
// Devuelve un string que explica el estado de la conexion
function StateToStr(State: DWORD): string;

implementation

var
  Cache: TStringList;

function TcpTableExists: Boolean;
begin
  Result:= @GetTcpTable <> nil;
end;

function TcpExTableExists: Boolean;
begin
 Result:= (@GetExtendedTcpTable <> nil) and (@GetOwnerModuleFromTcpEntry <> nil);
end;

function UdpTableExists: Boolean;
begin
  Result:= @GetUdpTable <> nil;
end;

function UdpExTableExists: Boolean;
begin
 Result:= (@GetExtendedUdpTable <> nil) and (@GetOwnerModuleFromUdpEntry <> nil);
end;

// Esta funcion añade un nuevo valor a la cache
procedure AddToCache(Name, Value: string);
begin
  if NoCache then
    Exit;
  while Cache.Count > 1000 do
    Cache.Delete(0);
  Cache.Values[Name]:= Value;
end;

// Esta funcion añade un nuevo valor a la cache
procedure AddPIDToCache(Name, Value: string);
begin
  if NoCachePIDs then
    Exit;
  AddToCache(Name, Value);
end;

// Esta funcion devuelve un valor de la cache
function GetFromCache(Name: string): string;
begin
  if NoCache then
    Exit;
  Result:= Cache.Values[Name];
end;

procedure ClearCache;
begin
  Cache.Clear;
end;

function IPToStr(IP: DWORD): string;
var
  HostEnt: PHostEnt;
  Name: string;
begin
  Result:= Format('%d.%d.%d.%d',
      [IP and $FF,(IP shr 8) and $FF,(IP shr 16) and $FF,(IP shr 24) and $FF]);
  if ResolveAddress then
  begin
    Name:= 'IP' + IntToHex(IP,8);
    if GetFromCache(Name) <> EmptyStr then
      Result:= GetFromCache(Name)
    else begin
      HostEnt:= gethostbyaddr(@IP, SizeOf(IP), AF_INET);
      if HostEnt <> nil then
        Result:= Format('%s (%s)',[Result,HostEnt^.h_name]);
      AddToCache(Name,Result);
    end;
  end;
end;

function GetOwnerModuleTCP(var TcpEntry: MIB_TCPROW_OWNER_MODULE): string;
var
  PID: string;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size: DWORD;
begin
  PID:= PID + IntToHex(TcpEntry.dwOwningPid,8);
  if GetFromCache(PID) <> EmptyStr then
      Result:= GetFromCache(PID)
  else begin
    Result:= '';
    GetMem(Info,sizeof(MIB_TCPTABLE_OWNER_MODULE));
    Size:= 0;
    if GetOwnerModuleFromTcpEntry(@TcpEntry, TCPIP_OWNER_MODULE_INFO_BASIC,
      Info,Size) = ERROR_INSUFFICIENT_BUFFER then
    begin
      FreeMem(Info);
      GetMem(Info,Size);
    end;
    if GetOwnerModuleFromTcpEntry(@TcpEntry, TCPIP_OWNER_MODULE_INFO_BASIC,
        Info,Size) = NO_ERROR then
      Result:= String(Info.pModuleName);
    FreeMem(Info);
    AddPIDToCache(PID,Result);
  end;
end;

function GetOwnerModuleUDP(var UdpEntry: MIB_UDPROW_OWNER_MODULE): string;
var
  PID: string;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size: DWORD;
begin
  PID:= PID + IntToHex(UdpEntry.dwOwningPid,8);
  if GetFromCache(PID) <> EmptyStr then
      Result:= GetFromCache(PID)
  else begin
    Result:= '';
    GetMem(Info,sizeof(MIB_TCPTABLE_OWNER_MODULE));
    Size:= 0;
    if GetOwnerModuleFromUdpEntry(@UdpEntry, TCPIP_OWNER_MODULE_INFO_BASIC,
      Info,Size) = ERROR_INSUFFICIENT_BUFFER then
    begin
      FreeMem(Info);
      GetMem(Info,Size);
    end;
    if GetOwnerModuleFromUdpEntry(@UdpEntry, TCPIP_OWNER_MODULE_INFO_BASIC,
        Info,Size) = NO_ERROR then
      Result:= String(Info.pModuleName);
    FreeMem(Info);
    AddPIDToCache(PID,Result);
  end;
end;

function StateToStr(State: DWORD): string;
begin
  case State of
    1:  Result:= 'CLOSED';
    2:  Result:= 'LISTENING';
    3:  Result:= 'SYN_SENT';
    4:  Result:= 'SYN_RCVD';
    5:  Result:= 'ESTABLISHED';
    6:  Result:= 'FIN_WAIT1';
	  7:  Result:= 'FIN_WAIT2';
    8:  Result:= 'CLOSE_WAIT';
    9:  Result:= 'CLOSING';
    10: Result:= 'LAST_ACK';
    11: Result:= 'TIME_WAIT';
    12: Result:= 'DELETE_TCB';
    else Result:= '?';
  end;
end;

initialization
  //  Inicializamos todas las funciones de la libreria iphlpapi.dll
  GetTcpTable:= nil;
  GetExtendedTcpTable:= nil;
  GetOwnerModuleFromTcpEntry:= nil;
  SetTcpEntry:= nil;
  
  Modulo:= LoadLibrary('iphlpapi.dll');
  if Modulo <> 0 then
  begin
    GetTcpTable:= GetProcAddress(Modulo,'GetTcpTable');
    GetExtendedTcpTable:= GetProcAddress(Modulo,'GetExtendedTcpTable');
    GetOwnerModuleFromTcpEntry:= GetProcAddress(Modulo,'GetOwnerModuleFromTcpEntry');
    GetUdpTable:= GetProcAddress(Modulo,'GetUdpTable');
    GetExtendedUdpTable:= GetProcAddress(Modulo,'GetExtendedUdpTable');
    GetOwnerModuleFromUdpEntry:= GetProcAddress(Modulo,'GetOwnerModuleFromUdpEntry');
    SetTcpEntry := GetProcAddress(Modulo, 'SetTcpEntry');
  end;
  Cache:= nil;
  // Creamos la cache
  Cache:= TStringList.Create;
finalization
  GetTcpTable:= nil;
  GetExtendedTcpTable:= nil;
  GetOwnerModuleFromTcpEntry:= nil;
  GetUdpTable:= nil;
  if Modulo <> 0 then
    FreeLibrary(Modulo);
  // Eliminamos la cache
  FreeAndNil(Cache);
end.
