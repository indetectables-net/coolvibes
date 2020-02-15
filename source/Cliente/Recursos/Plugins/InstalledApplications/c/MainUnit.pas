unit MainUnit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  Winsock,
  Buttons,
  ComCtrls,
  Controls, StdCtrls, Menus;

type
  TFormMain = class(TForm)
    ListViewPlugin: TListView;
    BtnEnviar: TSpeedButton;
    PopupMenuPlugin: TPopupMenu;
    Uninstall: TMenuItem;
    Refresh1: TMenuItem;
    procedure BtnEnviarClick(Sender: TObject);
    procedure UninstallClick(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
  private
  
  public
    ConID: integer;
    PID : integer;
    stoprequested:boolean;
    procedure RecData(Recibido:string);
    procedure Enviar(Texto:string);
  end;

  const    //Para permitir traducirlo facilmente en un futuro
    sepDos = '#2#';

implementation

{$R *.dfm}

procedure TFormMain.RecData(Recibido:string);
var
  Item: TListItem;
begin
  Delete(Recibido, 1, pos('|', Recibido));
  ListViewPlugin.Items.BeginUpdate;

  while pos(sepDos, Recibido) > 1 do
  begin
    Item := ListViewPlugin.Items.Add;
    //Item.ImageIndex := 320;

    //Programa
    Item.Caption := Copy(Recibido, 1, Pos(sepDos, Recibido) - 1);
    Delete(Recibido, 1, Pos(sepDos, Recibido) + 2);

    //Ruta desinstalador
    Item.SubItems.Add(Copy(Recibido, 1, Pos(sepDos, Recibido) - 1));
    Delete(Recibido, 1, Pos(sepDos, Recibido) + 2);

    //Tipo de desinstalador
    if Copy(Recibido, 1, Pos(sepDos, Recibido) - 1) = 'S' then
      Item.SubItems.Add('Silent')
    else if Copy(Recibido, 1, Pos(sepDos, Recibido) - 1) = 'N' then
      Item.SubItems.Add('Normal')
    else
      Item.SubItems.Add('');

    Delete(Recibido, 1, Pos(sepDos, Recibido) + 2);
    Delete(Recibido, 1, 2);
  end;

  ListViewPlugin.Items.EndUpdate;
  BtnEnviar.Enabled := true;
end;

procedure TFormMain.Refresh1Click(Sender: TObject);
begin
  BtnEnviar.Enabled := false;
  ListViewPlugin.Clear;
  Enviar('INSTALLEDAPPS');
end;

procedure TFormMain.UninstallClick(Sender: TObject);
begin
  Enviar('UNINSTALLME|' + ListViewPlugin.Selected.SubItems[0] + '|');
end;

procedure TFormMain.Enviar(Texto:string);
var
  Enviar: string;
begin
  Enviar := 'PLUGINDATA|InstalledApplications|' + Texto + #10; //siempre poner PluginName ahi!
  Send(self.ConID, Enviar[1], Length(Enviar), 0);
end;


procedure TFormMain.BtnEnviarClick(Sender: TObject);
begin
  BtnEnviar.Enabled := false;
  ListViewPlugin.Clear;
  Enviar('INSTALLEDAPPS');
end;

end.
