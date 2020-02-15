unit UnitPortScan;

interface
uses Windows,
     SysUtils;

  Function DumpTCP (list : Boolean;Cerrar:Boolean;CerrarS:string) : string;
  Function DumpUDP (list : Boolean;Cerrar:Boolean;CerrarS:string) : string;
implementation

uses ipHelp,Winsock;


Function DumpTCP (list : Boolean;Cerrar:Boolean;CerrarS:string) : string;
var
  TcpTable: PMIB_TCPTABLE;
  TcpExTable: PMIB_TCPTABLE_OWNER_MODULE;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size, i: DWORD;
  itm: MIB_TCPROW_OWNER_MODULE;
  tempStr : String;
begin
  if TcpExTableExists then
  begin
    GetMem(TcpExTable,sizeof(MIB_TCPTABLE_OWNER_MODULE));
    Size:= 0;
    if GetExtendedTcpTable(TcpExTable, Size, TRUE, AF_INET,TCP_TABLE_OWNER_MODULE_ALL,0) = ERROR_INSUFFICIENT_BUFFER then
    begin
      FreeMem(TcpExTable);
      GetMem(TcpExTable,Size);
    end;
    try
      if GetExtendedTcpTable(TcpExTable, Size, TRUE, AF_INET,
        TCP_TABLE_OWNER_MODULE_ALL,0) = NO_ERROR then
        for i:= 0 to TcpExTable.dwNumEntries - 1 do
          if (TcpExTable.table[i].dwState <> 2) or list  then
          begin

            if Cerrar then   //Matar una conexión
                if (TcpExTable.table[i].dwState <> 2) and (CerrarS = IPToStr(TcpExTable.table[i].dwLocalAddr)+IntToStr(htons(TcpExTable.table[i].dwLocalPort))+IPToStr(TcpExTable.table[i].dwRemoteAddr)+IntToStr(htons(TcpExTable.table[i].dwRemotePort))) then
                begin
                  itm :=TcpExTable^.table[i];
                  itm.dwState := 12;
                  SetTcpEntry(@itm);
                  break;
                end;
                
            TempStr:= tempStr+'|'+'TCP'+'|'+ IPToStr(TcpExTable.table[i].dwLocalAddr)+'|'+
             IntToStr(htons(TcpExTable.table[i].dwLocalPort));

            if TcpExTable.table[i].dwState <> 2 then
            begin
              tempStr:=TempStr+'|'+IPToStr(TcpExTable.table[i].dwRemoteAddr)+'|'+
                IntToStr( htons(TcpExTable.table[i].dwRemotePort))

            end else
            begin
              tempStr:=Tempstr+'|'+'-'+'|'+'-';

            end;
            TempStr:=Tempstr+'|'+StateToStr(TcpExTable.table[i].dwState)+'|'+
             IntTostr(TcpExTable.table[i].dwOwningPid);

            GetMem(Info,sizeof(MIB_TCPTABLE_OWNER_MODULE));
            Size:= 0;
            if GetOwnerModuleFromTcpEntry(@TcpExTable.table[i],
              TCPIP_OWNER_MODULE_INFO_BASIC,Info,Size) = ERROR_INSUFFICIENT_BUFFER then
            begin
              FreeMem(Info);
              GetMem(Info,Size);
            end;
            try
              if GetOwnerModuleFromTcpEntry(@TcpExTable.table[i],TCPIP_OWNER_MODULE_INFO_BASIC,Info,Size) = NO_ERROR then
                tempStr:=Tempstr+'|'+(String(Info.pModuleName))
                  else tempStr:=TempStr+'_'+'|'+'Desconocido';
            finally
              FreeMem(Info);
            end;
          end;
    finally
    result :=tempStr;
      FreeMem(TcpExTable);
    end;
  end else
  if TcpTableExists then
    begin
      GetMem(TcpTable,sizeof(MIB_TCPTABLE));
      Size:= 0;
      if GetTcpTable(TcpTable, Size, TRUE) = ERROR_INSUFFICIENT_BUFFER then
      begin
        FreeMem(TcpTable);
        GetMem(TcpTable,Size);
      end;
      try
        if (GetTcpTable(TcpTable, Size, TRUE) = NO_ERROR) then
          for i:= 0 to TcpTable.dwNumEntries - 1 do
            if (TcpTable.table[i].dwState <> 2) or list  then
              begin


               TempStr:= TempStr+'|'+'TCP'+'|'+ IPToStr(TcpExTable.table[i].dwLocalAddr)+'|'+
               IntToStr(htons(TcpExTable.table[i].dwLocalPort));
                 if TcpTable.table[i].dwState <> 2 then
                   begin
                 tempStr:=TempStr+'|'+IPToStr(TcpExTable.table[i].dwRemoteAddr)+'|'+
                  IntToStr( htons(TcpExTable.table[i].dwRemotePort))
                   end else
                       begin
                 tempStr:=Tempstr+'|'+'-'+'|'+'-';

              end;
               TempStr:=Tempstr+'|'+StateToStr(TcpExTable.table[i].dwState);


            end;
      finally
        result :=tempStr;
        FreeMem(TcpTable);
      end;
    end;
end;

Function DumpUDP (list : Boolean;Cerrar:Boolean;CerrarS:string) : string;
var
  UdpTable: PMIB_UDPTABLE;
  UdpExTable: PMIB_UDPTABLE_OWNER_MODULE;
  Info: PTCPIP_OWNER_MODULE_BASIC_INFO;
  Size, i: DWORD;
  TempStr : string;
begin
  if UdpExTableExists then
  begin
    GetMem(UdpExTable,sizeof(MIB_UDPTABLE_OWNER_MODULE));
    Size:= 0;
    if GetExtendedUdpTable(UdpExTable, Size, TRUE, AF_INET,
      UDP_TABLE_OWNER_MODULE,0) = ERROR_INSUFFICIENT_BUFFER then
    begin
      FreeMem(UdpExTable);
      GetMem(UdpExTable,Size);
    end;
    try
      if GetExtendedUdpTable(UdpExTable, Size, TRUE, AF_INET,
        UDP_TABLE_OWNER_MODULE,0) = NO_ERROR then
        for i:= 0 to UdpExTable.dwNumEntries - 1 do
        begin

          TempStr:=TempsTr+'|'+'UDP'+'|'+ IPToStr(UdpExTable.table[i].dwLocalAddr)+'|'+
            IntToStr(htons(UdpExTable.table[i].dwLocalPort))+'|'+'-'+'|'+'-'+'|'+'-'+'|'+
             IntTostr(UdpExTable.table[i].dwOwningPid);
         
          GetMem(Info,sizeof(MIB_TCPTABLE_OWNER_MODULE));
          Size:= 0;
          if GetOwnerModuleFromUdpEntry(@UdpExTable.table[i],
            TCPIP_OWNER_MODULE_INFO_BASIC,Info,Size) = ERROR_INSUFFICIENT_BUFFER then
          begin
            FreeMem(Info);
            GetMem(Info,Size);
          end;
          try
            if GetOwnerModuleFromUdpEntry(@UdpExTable.table[i],
              TCPIP_OWNER_MODULE_INFO_BASIC,Info,Size) = NO_ERROR then
              Tempstr:=Tempstr+'|'+(String(Info.pModuleName))
               else tempStr:=TempStr+'_'+'|'+'Desconocido';
          finally
            FreeMem(Info);
          end;
        end; 
    finally
      Result:=Tempstr;
      FreeMem(UdpExTable);
    end;
  end else
  if UdpTableExists then
    begin
      GetMem(UdpTable,sizeof(MIB_TCPTABLE));
      Size:= 0;
      if GetUdpTable(UdpTable, Size, TRUE) = ERROR_INSUFFICIENT_BUFFER then
      begin
        FreeMem(UdpTable);
        GetMem(UdpTable,Size);
      end;
      try
        if (GetUdpTable(UdpTable, Size, TRUE) = NO_ERROR) then
          for i:= 0 to UdpTable.dwNumEntries - 1 do
          begin
          TempStr:=TempsTr+'|'+'UDP'+'|'+ IPToStr(UdpExTable.table[i].dwLocalAddr)+'|'+
            IntToStr(htons(UdpExTable.table[i].dwLocalPort))+'|'+'-'+'|'+'-'+'|'+'-';
           end;
      finally
      Result:=tempStr;
        FreeMem(UdpTable);
      end;
    end;
end;

end.