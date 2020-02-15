library TestPluginS;


uses
  windows,
  Winsock;

var
  ConId : integer;
  PNombre : string;

{Esta funcion es llamada al iniciar coolserver, se realiza en un thread independiente}
{puede ser muy util por ejemplo para programar un keylogger u otros programas similares}
procedure CargaOffline();stdcall;
begin
  messageboxa(0,'CargaOffline!','CargaOffline!',0);
end;


{Esta función es llamada cuando se abre el plugin desde el cliente}
procedure Start(id:integer;nombre:string);stdcall;
begin
  ConID := ID; //Socket
  PNombre := nombre; //Nombre del plugin
end;

{Al recibir información desde el cliente}
procedure RecData(data:string);stdcall;
var
  enviar : string;
begin
  MessageBoxa(0,pchar(data),pchar(data),0);

  //Para enviar información desde un plugin se envia en el siguiente formato:
  // PLUGINDATA|NOMBREPLUGIN|DATA#10#15#80#66#77#1#72#87
  enviar := 'PLUGINDATA|'+PNombre+'|'+data+#10#15#80#66#77#1#72#87;
  Send(ConID, Enviar[1], Length(Enviar), 0);
end;

{Cuando se desconecta el servidor es llamada}
procedure Stop();Stdcall;
begin

end;

exports CargaOffline, Start, RecData, Stop;

end.
