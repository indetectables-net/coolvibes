unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ExtCtrls, Graphics, dialogs, winsock;




type
  TFormMain = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
  
  public
    ConID: integer;
    PID : integer;
    stoprequested:boolean;
    procedure RecData(data:string);
  end;



implementation

{$R *.dfm}

procedure TFormMain.RecData(data:string);
begin
  label1.Caption := data; 
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  Enviar : string;
begin
  //Para enviar información desde un plugin se envia en el siguiente formato:
  // PLUGINDATA|NOMBREPLUGIN|DATA#10
  Enviar := 'PLUGINDATA|TestPlugin v1.0|'+edit1.Text+#10;
  Send(self.ConID, Enviar[1], Length(Enviar), 0);
end;

end.
