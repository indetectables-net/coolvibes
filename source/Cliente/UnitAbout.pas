unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, ComCtrls, jpeg, ShellAPI, UnitVariables;

type
  TFormAbout = class(TForm)
    RichEdit1:  TRichEdit;
    Label1:     TLabel;
    Image1:     TImage;
    Label2:     TLabel;
    Image2:     TImage;
    Label3:     TLabel;
    Image3:     TImage;
    Label4:     TLabel;
    BtnCerrar:  TSpeedButton;
    ScrollBoxCreadores: TScrollBox;
    EdtHistorial: TRichEdit;
    ImgBanner:  TImage;
    Bevel1:     TBevel;
    GrpBoxHistorial: TGroupBox;
    GrpBoxInfo: TGroupBox;
    ScrollBoxBetaTesters: TScrollBox;
    Image5:     TImage;
    Label5:     TLabel;
    Label6:     TLabel;
    ScrollBox1: TScrollBox;
    Label7:     TLabel;
    Label8:     TLabel;
    Label9:     TLabel;
    Label10:    TLabel;
    Image4:     TImage;
    Label11:    TLabel;
    Image6:     TImage;
    Label12:    TLabel;
    procedure BtnCerrarClick(Sender: TObject);
    procedure ImgBannerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.BtnCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.ImgBannerClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.indetectables.net/', nil, nil, 0);
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  GrpBoxInfo.Caption := 'Coolvibes ' + VersionCool;
  FormAbout.Caption  := 'Acerca de Coolvibes ' + VersionCool;

  try
    EdtHistorial.Lines.LoadFromFile('..\Historial.txt');
  except
    begin
      EdtHistorial.Lines.Clear;
      EdtHistorial.Lines.Append('No se encontró el archivo ''Historial.txt''.');
    end;
  end;

end;

end.
