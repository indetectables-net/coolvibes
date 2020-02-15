unit UnitTransfer;

interface

uses Windows, SysUtils, Dialogs, ComCtrls, IdTCPServer, UnitFunciones, gnugettext;

type
  TCallbackProcedure = procedure(Sender: TObject; FileName: string) of object;

type
  TDescargaHandler = class(TObject)
  public
    // ProgressBar: TProgressBar;
    ListView: TListView;
    AThread: TIdPeerThread;
    Item: TListItem; //Item de la descarga
    Descargado: Int64; //Datos descargados
    SizeFile: Int64;
    ultimoBajado: Int64;
    Origen, Destino: AnsiString;
    Transfering: Boolean;
    Finalizado: Boolean;
    Status: string;
    cancelado: Boolean;
    callback: TCallbackProcedure;
    es_descarga: Boolean;
    constructor Create(PThread: TIdPeerThread; fname: AnsiString;
      TSize: Integer; PDownloadPath: AnsiString; pListView: TListView;
      p_es_descarga: Boolean); overload;
    procedure addToView;
    procedure TransferFile;
    procedure ResumeTransfer;
    procedure CancelarDescarga;
    procedure UploadFile;
    procedure Update;
    procedure UpdateVelocidad;
  private

  end;

implementation

constructor TDescargaHandler.Create(PThread: TIdPeerThread; fname: AnsiString;
  TSize: Integer; PDownloadPath: AnsiString; pListView: TListView; p_es_descarga: Boolean);
begin
  Athread := pThread;
  Origen := fname;
  Destino := pDownloadPath;
  SizeFile := TSize;
  ListView := pListView;
  transfering := False;
  cancelado := False;
  finalizado := False;
  es_descarga := p_es_descarga;
  Descargado := 0;
  { ProgressBar := TProgressBar.Create(nil);

   if(TSize <> 0) then
     ProgressBar.Max := TSize;    }
  if Athread <> nil then
    AThread.Synchronize(Self.addToView)
  else
    Self.addToView;
end;

procedure TDescargaHandler.addToView;
var
  RectProg: TRect;
begin
  item := ListView.Items.Add;
  item.Caption := ExtractFileName(Origen);
  Item.SubItems.Add(_('En espera'));
  Item.SubItems.Add(ObtenerMejorUnidad(Self.SizeFile));
  Item.SubItems.Add('0 Kb');
  Item.SubItems.Add('');
  Item.SubItems.Add(_('En espera'));

  if es_descarga then
    Item.ImageIndex := 38
  else
    Item.ImageIndex := 36;

  Item.Data := Self; //apunta a un objeto tipo TDescargaHandler
  {
  RectProg      := Item.DisplayRect(drBounds);
  //Posicion izquierda de todo el item mas el ancho de la primera columna
  RectProg.Left := RectProg.Left + ListView.Columns[0].Width;
  //Posicion derecha de la progressbar mas el ancho de la columna donde está
  RectProg.Right := RectProg.Left + ListView.Columns[1].Width;
  //BoundsRect - Specifies the bounding rectangle of the control, expressed in the coordinate system of the parent control.
  ProgressBar.BoundsRect := RectProg;
  progressBar.Parent := ListView;  }
end;

procedure TDescargaHandler.TransferFile;
var
  Buffer: array[0..1023] of Byte;
  F: file;
  read, currRead: Integer;
  tickBefore, tickNow: Integer;
  seconds: Extended;
  buffSize: Integer;
  pri: string;
  error, asignado: Boolean;
begin
  transfering := True;
  status := _('Descargando');
  AssignFile(F, Destino);
  try
    Rewrite(F, 1);
  except
    error := True;
  end;
  asignado := not error;
  read := 0;
  currRead := 0;
  tickBefore := GetTickCount;
  tickNow := GetTickCount;
  UltimoBajado := 0;
  buffSize := SizeOf(Buffer);
  Pri := Trim(Athread.Connection.ReadLn);
  if (Pri = 'ERROR') then
    begin
      MessageDlg(_('Error al descargar archivo: ') + extractfilename(destino), mtWarning, [mbOK], 0);
      error := True;
    end;
  try
    while ((read < SizeFile) and Athread.Connection.Connected and not cancelado) do
      begin
        if error then break;
        if (SizeFile - read) >= buffSize then
          currRead := buffSize
        else
          currRead := (SizeFile - read);

        Athread.Connection.ReadBuffer(buffer, currRead);
        read := read + currRead;

        tickNow := GetTickCount;
        if (tickNow - TickBefore >= 500) then
          begin
            Athread.Synchronize(UpdateVelocidad);
            Athread.Synchronize(Update);
            tickBefore := tickNow;
            UltimoBajado := Descargado;
          end;

        BlockWrite(F, Buffer, currRead);
        currRead := 0;
        Descargado := read;
      end;
  finally
    if asignado then
      CloseFile(F);
    {   Athread.Data := nil;
       Athread.Connection.Disconnect;  }

    seconds := (GetTickCount - tickBefore) / 1000;
    transfering := False;
    if read <> SizeFile then
      begin
        status := _('Detenido');
        cancelado := True;
        Transfering := False;
      end
    else
      begin
        status := _('Finalizado');
        finalizado := True;
        transfering := False;
      end;
    Athread.Synchronize(Update);
    Athread.Connection.Disconnect;

    if @callback <> nil then
      callback(Self, destino);

  end; //end de finally
end;

procedure TDescargaHandler.ResumeTransfer;
var
  Buffer: array[0..1024] of Byte;
  F: file;
  read, currRead: Integer;
  tickBefore, tickNow: Integer;
  seconds: Extended;
  buffSize: Integer;
  Pri: string;
  error, asignado: Boolean;
begin
  transfering := True;
  cancelado := False;
  status := _('Descargando');
  tickBefore := GetTickCount;
  if (mygetfilesize(destino) = sizefile) then
    begin
      error := True;
      read := sizefile;
    end;

  if not error then
    if FileExists(destino) then
      begin
        asignado := True;
        AssignFile(F, Destino);
        reset(F, 1);
        seek(f, Descargado);
      end
    else
      begin
        AssignFile(F, Destino);
        Rewrite(F, 1);
        asignado := True;
      end;

  read := Descargado;
  currRead := 0;

  tickBefore := GetTickCount;
  tickNow := GetTickCount;
  UltimoBajado := 0;
  buffSize := SizeOf(Buffer);
  Pri := Trim(Athread.Connection.ReadLn);

  if (Pri = 'ERROR') then
    begin
      MessageDlg(_('Error al descargar archivo: ') + extractfilename(destino), mtWarning, [mbOK], 0);
      error := True;
    end;

  try
    while ((read < SizeFile) and Athread.Connection.Connected and not cancelado) do
      begin
        if error then break;
        if (SizeFile - read) >= buffSize then
          currRead := buffSize
        else
          currRead := (SizeFile - read);

        Athread.Connection.ReadBuffer(buffer, currRead);
        read := read + currRead;

        tickNow := GetTickCount;
        if (tickNow - TickBefore >= 500) then
          begin
            Athread.Synchronize(UpdateVelocidad);
            Athread.Synchronize(Update);
            tickBefore := tickNow;
            UltimoBajado := Descargado;
          end;

        BlockWrite(F, Buffer, currRead);
        Descargado := read;

      end;
  finally
    if asignado then
      CloseFile(F);
    { Athread.Connection.DisconnectSocket;
     Athread.Connection.Disconnect;
         Athread.Data := nil;     }

    seconds := (GetTickCount - tickBefore) / 1000;
    transfering := False;
    if read <> SizeFile then
      begin
        status := _('Detenido');
        cancelado := True;
        Transfering := False;
      end
    else
      begin
        status := _('Finalizado');
        finalizado := True;
        transfering := False;
      end;
    Athread.Synchronize(Update);
    if @callback <> nil then
      callback(Self, destino);

    Athread.Connection.Disconnect;
  end; //end de finally
end;

procedure TDescargaHandler.UploadFile;
var
  myFile: file;
  byteArray: array[0..1023] of Byte;
  Count, sent, filesize: Integer;
  tickBefore, tickNow: Integer;
  asignado: Boolean;
begin
  filesize := MyGetFileSize(Origen);
  if not filesize > 0 then
    begin
      MessageDlg(_('No se pudo acceder al archivo, puede que esté en uso por otra aplicación'),
        mtWarning, [mbOK], 0);
      AThread.Connection.Disconnect;
      Exit;
    end;
  transfering := True;
  cancelado := False;
  status := _('Subiendo');
  try
    FileMode := $0000;
    asignado := True;
    AssignFile(myFile, Origen);
    try
      reset(MyFile, 1);
    except
      MessageDlg(_('No se pudo acceder al archivo, puede que esté en uso por otra aplicación'),
        mtWarning, [mbOK], 0);
      AThread.Connection.Disconnect;
      asignado := False;
      Exit;
    end;
    sent := 0;
    tickBefore := GetTickCount;
    UltimoBajado := 0;
    while not EOF(MyFile) and AThread.Connection.Connected and not cancelado do
      begin
        BlockRead(myFile, bytearray, 1024, Count);
        sent := sent + AThread.Connection.Socket.Send(bytearray, Count);
        tickNow := GetTickCount;
        if (tickNow - TickBefore >= 500) then
          begin
            Athread.Synchronize(UpdateVelocidad);
            tickBefore := tickNow;
            UltimoBajado := Descargado;
          end;
        //aunque originalmente indicaba cuando se habia descargado tambien
        //nos servira para llevar la cuenta de cuanto hemos subido
        Descargado := sent;
        Athread.Synchronize(Update);
      end;
  finally
    if asignado then
      closefile(myfile);
    if sent <> filesize then
      begin
        cancelado := True;
        transfering := False;
        finalizado := False;
        Status := _('Detenido');
      end
    else
      begin
        cancelado := False;
        transfering := False;
        finalizado := True;
        Status := _('Finalizado');
      end;
    Athread.Synchronize(Update);
  end;
end;

procedure TDescargaHandler.CancelarDescarga;
begin
  cancelado := True;
  transfering := False;
  Finalizado := False;
end;

procedure TDescargaHandler.Update;
begin
  // ProgressBar.Position := self.Descargado;
  if (SizeFile <> 0) then
    item.SubItems[0] := IntToStr(Descargado * 100 div SizeFile) + '%';
  if Item.SubItems[4] <> Status then
    Item.SubItems[4] := Status;
  Item.SubItems[2] := ObtenerMejorUnidad(Descargado);
end;

procedure TDescargaHandler.UpdateVelocidad;
begin
  Item.SubItems[3] := ObtenerMejorUnidad(2 * (Descargado - UltimoBajado)) + '/s';
end;

end.
