unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ExtCtrls, Graphics, dialogs, winsock;




type
  TFormMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  
  public
    ConID: integer;
    PID : integer;
    stoprequested:boolean;
    procedure RecData(data:string);
    procedure Enviar(Texto:string);
  end;

implementation

{$R *.dfm}

procedure TFormMain.RecData(data:string);
begin
  //data será el texto recibido
  self.Caption := ('El servidor dice: '+data);
end;

procedure TFormMain.Enviar(Texto:string);
var
  Enviar: string;
begin
//Para enviar información desde un plugin se envia en el siguiente formato:
  // PLUGINDATA|NOMBREPLUGIN|DATA#10
  Enviar := 'PLUGINDATA|TestPlugin v1.0|'+Texto+#10;
  Send(self.ConID, Enviar[1], Length(Enviar), 0);
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  Enviar('Hola');
end;

end.
