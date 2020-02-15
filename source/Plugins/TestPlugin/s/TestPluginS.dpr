library TestPluginS;


uses
  windows,
  sysutils,
  Winsock,
  classes;

var
  ConId : integer;
  PNombre : string;

procedure Start(id:integer;nombre:string)stdcall;
begin
  ConID := ID;
  PNombre := nombre;
end;


procedure RecData(data:string);stdcall;
var
  enviar : string;
begin
  MessageBoxa(0,pchar(data),pchar(data),0);

  //Para enviar información desde un plugin se envia en el siguiente formato:
  // PLUGINDATA|NOMBREPLUGIN|DATA#10
  enviar := 'PLUGINDATA|'+PNombre+'|'+data+#10;
  Send(ConID, Enviar[1], Length(Enviar), 0);
end;

exports Start, RecData;

end.
