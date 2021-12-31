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
  Item.SubItems.Add('3');
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
  ChunkSize: Integer;
  SavedFile: file;
  LocalSavedFileSize: Integer;
  StartTick: Integer;
  LastTick: Integer;
  NowTick: Integer;
  Seconds: Extended;
  StartSocketStatus: string;
  Error: Boolean;
begin
  Transfering := True;
  Status := _('Descargando');
  StartTick := GetTickCount;
  LastTick := StartTick;
  LocalSavedFileSize := 0;
  UltimoBajado := 0;

  try
    AssignFile(SavedFile, Destino);
    Rewrite(SavedFile, 1);

    StartSocketStatus := Trim(ConnectionReadLn(Athread, #10#15#80#66#77#1#72#87));
    if (StartSocketStatus = 'ERROR') then
    begin
      MessageDlg(_('Error al descargar archivo: ') + extractfilename(destino), mtWarning, [mbOK], 0);
      Exit;
    end;

    while ((LocalSavedFileSize < SizeFile) and
      Athread.Connection.Connected and
      not Cancelado) do
      begin
        // esta es una trampa para saber de cuanto va a ser el ChunkSize enviado
        // ya que en realidad el que manda deberia decir de cuanto es cada chunk
        ChunkSize := 1024;
        if (SizeFile - LocalSavedFileSize) < 1024 then
          ChunkSize := SizeFile - LocalSavedFileSize;

        Athread.Connection.ReadBuffer(Buffer, ChunkSize);
        //LocalSavedFileSize := LocalSavedFileSize + Length(Buffer);
        LocalSavedFileSize := LocalSavedFileSize + ChunkSize;

        NowTick := GetTickCount;
        if (NowTick - LastTick >= 500) then
        begin
          Athread.Synchronize(UpdateVelocidad);
          Athread.Synchronize(Update);
          LastTick := NowTick;
          UltimoBajado := Descargado;
        end;

        // creo que el valor de count de aca tendria que ser un ternario
        BlockWrite(SavedFile, Buffer, ChunkSize);
        Descargado := LocalSavedFileSize;
      end;
  except
    on ExcepData: Exception do begin
      Error := True;
      Status := _('Error');
      ShowMessage(ExcepData.ClassName + ' error raised, with message : ' + ExcepData.Message);
    end;
  end;

  if LocalSavedFileSize = SizeFile then
  begin
    Status := _('Finalizado');
    Finalizado := True;
  end;

  CloseFile(SavedFile);
  Transfering := False;
  Seconds := (LastTick - StartTick) / 1000;
  Athread.Synchronize(Update);
  Athread.Connection.Disconnect;

  // TODO agregar al callback Error, Finalizado y Cancelado
  if @callback <> nil then
    callback(Self, destino);
end;

// TODO
// 1. ver de unificar esto con lo func anterior
// 2. en realidad ni esta func ni la original me funcionaban
procedure TDescargaHandler.ResumeTransfer;
var
  Buffer: array[0..1023] of Byte;
  ChunkSize: Integer;
  SavedFile: file;
  LocalSavedFileSize: Integer;
  StartTick: Integer;
  LastTick: Integer;
  NowTick: Integer;
  Seconds: Extended;
  StartSocketStatus: string;
  Error: Boolean;
begin
  Transfering := True;
  Cancelado := False;
  Status := _('Descargando');
  StartTick := GetTickCount;
  LastTick := StartTick;
  LocalSavedFileSize := Descargado;
  UltimoBajado := 0;

  try
    if (MyGetFileSize(Destino) = SizeFile) then
      Exit;

    AssignFile(SavedFile, Destino);
    if FileExists(Destino) then
    begin
      reset(SavedFile, 1);
      seek(SavedFile, Descargado);
    end
    else
      Rewrite(SavedFile, 1);

    StartSocketStatus := Trim(ConnectionReadLn(Athread, #10#15#80#66#77#1#72#87));
    if (StartSocketStatus = 'ERROR') then
    begin
      MessageDlg(_('Error al descargar archivo: ') + extractfilename(destino), mtWarning, [mbOK], 0);
      Exit;
    end;

    while ((LocalSavedFileSize < SizeFile) and
      Athread.Connection.Connected and
      not Cancelado) do
      begin
        // esta es una trampa para saber de cuanto va a ser el ChunkSize enviado
        // ya que en realidad el que manda deberia decir de cuanto es cada chunk
        ChunkSize := 1024;
        if (SizeFile - LocalSavedFileSize) < 1024 then
          ChunkSize := SizeFile - LocalSavedFileSize;

        Athread.Connection.ReadBuffer(Buffer, ChunkSize);
        //LocalSavedFileSize := LocalSavedFileSize + Length(Buffer);
        LocalSavedFileSize := LocalSavedFileSize + ChunkSize;

        NowTick := GetTickCount;
        if (NowTick - LastTick >= 500) then
        begin
          Athread.Synchronize(UpdateVelocidad);
          Athread.Synchronize(Update);
          LastTick := NowTick;
          UltimoBajado := Descargado;
        end;

        // creo que el valor de count de aca tendria que ser un ternario
        BlockWrite(SavedFile, Buffer, ChunkSize);
        Descargado := LocalSavedFileSize;
      end;
  except
    on ExcepData: Exception do begin
      Error := True;
      Status := _('Error');
      ShowMessage(ExcepData.ClassName + ' error raised, with message : ' + ExcepData.Message);
    end;
  end;

  if LocalSavedFileSize = SizeFile then
  begin
    Status := _('Finalizado');
    Finalizado := True;
  end;

  CloseFile(SavedFile);
  Transfering := False;
  Seconds := (LastTick - StartTick) / 1000;
  Athread.Synchronize(Update);
  Athread.Connection.Disconnect;

  // TODO agregar al callback Error, Finalizado y Cancelado
  if @callback <> nil then
    callback(Self, destino);
end;

procedure TDescargaHandler.UploadFile;
var
  ReadFile: file;
  ReadBuffer: array[0..1023] of Byte;
  SendBuffer: TBytes;
  BlockSize, SendSize, FileSize: Integer;
  StartTick, LastTick, NowTick: Integer;
  Seconds: Extended;
  Error: Boolean;
begin
  Transfering := True;
  Cancelado := False;
  Status := _('Subiendo');
  StartTick := GetTickCount;
  LastTick := StartTick;
  SendSize := 0;
  UltimoBajado := 0;

  try
    FileSize := MyGetFileSize(Origen);
    if not FileSize > 0 then
      begin
        MessageDlg(
          _('No se pudo acceder al archivo, puede que esté en uso por otra aplicación'),
          mtWarning,
          [mbOK],
          0
        );
        Exit;
      end;

    FileMode := $0000;
    AssignFile(ReadFile, Origen);
    Reset(ReadFile, 1);

    while (not EOF(ReadFile) and
      AThread.Connection.Connected and
      not Cancelado) do
      begin
        BlockRead(ReadFile, ReadBuffer, 1024, BlockSize);
        AThread.Connection.Socket.Send(ReadBuffer, BlockSize);
        SendSize := SendSize + BlockSize;

        NowTick := GetTickCount;
        if (NowTick - LastTick >= 500) then
        begin
          Athread.Synchronize(UpdateVelocidad);
          Athread.Synchronize(Update);
          LastTick := NowTick;
          UltimoBajado := Descargado;
        end;

        //aunque originalmente indicaba cuando se habia descargado tambien
        //nos servira para llevar la cuenta de cuanto hemos subido
        //(entonces renombralo a transfered capo)
        Descargado := SendSize;
      end;
  except
    on ExcepData: Exception do begin
      Error := True;
      Status := _('Error');
      MessageDlg(
        ExcepData.ClassName + ' error raised, with message : ' + ExcepData.Message,
        mtWarning,
        [mbOK],
        0
      );
    end;
  end;

  if SendSize = FileSize then
  begin
    Status := _('Finalizado');
    Finalizado := True;
  end;

  CloseFile(ReadFile);
  Transfering := False;
  Seconds := (LastTick - StartTick) / 1000;
  Athread.Synchronize(Update);
  Athread.Connection.Disconnect;

  // TODO agregar al callback Error, Finalizado y Cancelado
  if @callback <> nil then
    callback(Self, destino);
end;

procedure TDescargaHandler.CancelarDescarga;
begin
  Status := _('Detenido');
  Cancelado := True;
  Transfering := False;
  Finalizado := False;
end;

procedure TDescargaHandler.Update;
begin
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
