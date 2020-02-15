unit UnitPortScan;

interface
uses Windows,
  SysUtils;

function DumpTCP(list: Boolean; Cerrar: Boolean; CerrarS: string): string;
function DumpUDP(list: Boolean; Cerrar: Boolean; CerrarS: string): string;
implementation

uses ipHelp, Winsock;

function DumpTCP(list: Boolean; Cerrar: Boolean; CerrarS: string): string;
var
  TcpTable: PMIB_TCPTABLE;
  TcpExTable: PMIB_TCPTABLE_OWNER_MODULE;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size, i: DWORD;
  itm: MIB_TCPROW_OWNER_MODULE;
  tempStr: string;
begin
  if TcpExTableExists then
    begin
      GetMem(TcpExTable, SizeOf(MIB_TCPTABLE_OWNER_MODULE));
      Size := 0;
      if GetExtendedTcpTable(TcpExTable, Size, True, AF_INET, TCP_TABLE_OWNER_MODULE_ALL, 0) = ERROR_INSUFFICIENT_BUFFER then
        begin
          FreeMem(TcpExTable);
          GetMem(TcpExTable, Size);
        end;
      try
        if GetExtendedTcpTable(TcpExTable, Size, True, AF_INET,
          TCP_TABLE_OWNER_MODULE_ALL, 0) = NO_ERROR then
          for i := 0 to TcpExTable.dwNumEntries - 1 do
            if (TcpExTable.Table[i].dwState <> 2) or list then
              begin

                if Cerrar then //Matar una conexión
                  if (TcpExTable.Table[i].dwState <> 2) and (CerrarS = IPToStr(TcpExTable.Table[i].dwLocalAddr) + IntToStr(htons(TcpExTable.Table[i].dwLocalPort)) + IPToStr(TcpExTable.Table[i].dwRemoteAddr) + IntToStr(htons(TcpExTable.Table[i].dwRemotePort))) then
                    begin
                      itm := TcpExTable^.Table[i];
                      itm.dwState := 12;
                      SetTcpEntry(@itm);
                      break;
                    end;

                TempStr := tempStr + '|' + 'TCP' + '|' + IPToStr(TcpExTable.Table[i].dwLocalAddr) + '|' +
                  IntToStr(htons(TcpExTable.Table[i].dwLocalPort));

                if TcpExTable.Table[i].dwState <> 2 then
                  begin
                    tempStr := TempStr + '|' + IPToStr(TcpExTable.Table[i].dwRemoteAddr) + '|' +
                      IntToStr(htons(TcpExTable.Table[i].dwRemotePort))

                  end
                else
                  begin
                    tempStr := Tempstr + '|' + '-' + '|' + '-';

                  end;
                TempStr := Tempstr + '|' + StateToStr(TcpExTable.Table[i].dwState) + '|' +
                  IntToStr(TcpExTable.Table[i].dwOwningPid);

                GetMem(Info, SizeOf(MIB_TCPTABLE_OWNER_MODULE));
                Size := 0;
                if GetOwnerModuleFromTcpEntry(@TcpExTable.Table[i],
                  TCPIP_OWNER_MODULE_INFO_BASIC, Info, Size) = ERROR_INSUFFICIENT_BUFFER then
                  begin
                    FreeMem(Info);
                    GetMem(Info, Size);
                  end;
                try
                  if GetOwnerModuleFromTcpEntry(@TcpExTable.Table[i], TCPIP_OWNER_MODULE_INFO_BASIC, Info, Size) = NO_ERROR then
                    tempStr := Tempstr + '|' + (string(Info.pModuleName))
                  else
                    tempStr := TempStr + '_' + '|' + 'Desconocido';
                finally
                  FreeMem(Info);
                end;
              end;
      finally
        Result := tempStr;
        FreeMem(TcpExTable);
      end;
    end
  else if TcpTableExists then
    begin
      GetMem(TcpTable, SizeOf(MIB_TCPTABLE));
      Size := 0;
      if GetTcpTable(TcpTable, Size, True) = ERROR_INSUFFICIENT_BUFFER then
        begin
          FreeMem(TcpTable);
          GetMem(TcpTable, Size);
        end;
      try
        if (GetTcpTable(TcpTable, Size, True) = NO_ERROR) then
          for i := 0 to TcpTable.dwNumEntries - 1 do
            if (TcpTable.Table[i].dwState <> 2) or list then
              begin

                TempStr := TempStr + '|' + 'TCP' + '|' + IPToStr(TcpExTable.Table[i].dwLocalAddr) + '|' +
                  IntToStr(htons(TcpExTable.Table[i].dwLocalPort));
                if TcpTable.Table[i].dwState <> 2 then
                  begin
                    tempStr := TempStr + '|' + IPToStr(TcpExTable.Table[i].dwRemoteAddr) + '|' +
                      IntToStr(htons(TcpExTable.Table[i].dwRemotePort))
                  end
                else
                  begin
                    tempStr := Tempstr + '|' + '-' + '|' + '-';

                  end;
                TempStr := Tempstr + '|' + StateToStr(TcpExTable.Table[i].dwState);

              end;
      finally
        Result := tempStr;
        FreeMem(TcpTable);
      end;
    end;
end;

function DumpUDP(list: Boolean; Cerrar: Boolean; CerrarS: string): string;
var
  UdpTable: PMIB_UDPTABLE;
  UdpExTable: PMIB_UDPTABLE_OWNER_MODULE;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size, i: DWORD;
  TempStr: string;
begin
  if UdpExTableExists then
    begin
      GetMem(UdpExTable, SizeOf(MIB_UDPTABLE_OWNER_MODULE));
      Size := 0;
      if GetExtendedUdpTable(UdpExTable, Size, True, AF_INET,
        UDP_TABLE_OWNER_MODULE, 0) = ERROR_INSUFFICIENT_BUFFER then
        begin
          FreeMem(UdpExTable);
          GetMem(UdpExTable, Size);
        end;
      try
        if GetExtendedUdpTable(UdpExTable, Size, True, AF_INET,
          UDP_TABLE_OWNER_MODULE, 0) = NO_ERROR then
          for i := 0 to UdpExTable.dwNumEntries - 1 do
            begin

              TempStr := TempsTr + '|' + 'UDP' + '|' + IPToStr(UdpExTable.Table[i].dwLocalAddr) + '|' +
                IntToStr(htons(UdpExTable.Table[i].dwLocalPort)) + '|' + '-' + '|' + '-' + '|' + '-' + '|' +
                IntToStr(UdpExTable.Table[i].dwOwningPid);

              GetMem(Info, SizeOf(MIB_TCPTABLE_OWNER_MODULE));
              Size := 0;
              if GetOwnerModuleFromUdpEntry(@UdpExTable.Table[i],
                TCPIP_OWNER_MODULE_INFO_BASIC, Info, Size) = ERROR_INSUFFICIENT_BUFFER then
                begin
                  FreeMem(Info);
                  GetMem(Info, Size);
                end;
              try
                if GetOwnerModuleFromUdpEntry(@UdpExTable.Table[i],
                  TCPIP_OWNER_MODULE_INFO_BASIC, Info, Size) = NO_ERROR then
                  Tempstr := Tempstr + '|' + (string(Info.pModuleName))
                else
                  tempStr := TempStr + '_' + '|' + 'Desconocido';
              finally
                FreeMem(Info);
              end;
            end;
      finally
        Result := Tempstr;
        FreeMem(UdpExTable);
      end;
    end
  else if UdpTableExists then
    begin
      GetMem(UdpTable, SizeOf(MIB_TCPTABLE));
      Size := 0;
      if GetUdpTable(UdpTable, Size, True) = ERROR_INSUFFICIENT_BUFFER then
        begin
          FreeMem(UdpTable);
          GetMem(UdpTable, Size);
        end;
      try
        if (GetUdpTable(UdpTable, Size, True) = NO_ERROR) then
          for i := 0 to UdpTable.dwNumEntries - 1 do
            begin
              TempStr := TempsTr + '|' + 'UDP' + '|' + IPToStr(UdpExTable.Table[i].dwLocalAddr) + '|' +
                IntToStr(htons(UdpExTable.Table[i].dwLocalPort)) + '|' + '-' + '|' + '-' + '|' + '-';
            end;
      finally
        Result := tempStr;
        FreeMem(UdpTable);
      end;
    end;
end;

end.
