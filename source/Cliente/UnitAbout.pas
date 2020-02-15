unit UnitAbout;

interface

uses
  Classes, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, ShellAPI, UnitVariables, gnugettext,
  Graphics;

type
  TFormAbout = class(TForm)
    RichEdit1: TRichEdit;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Image3: TImage;
    Label4: TLabel;
    ScrollBoxCreadores: TScrollBox;
    EdtHistorial: TRichEdit;
    ImgBanner: TImage;
    GrpBoxHistorial: TGroupBox;
    GrpBoxInfo: TGroupBox;
    ScrollBoxBetaTesters: TScrollBox;
    Image5: TImage;
    Label5: TLabel;
    Label6: TLabel;
    ScrollBox1: TScrollBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Image4: TImage;
    Label11: TLabel;
    Image6: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label15: TLabel;
    Label16: TLabel;
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
  FormAbout.Caption := _('Acerca de Coolvibes ') + VersionCool;

  try
    EdtHistorial.Lines.LoadFromFile('..\Historial.txt');
  except
    begin
      EdtHistorial.Lines.Clear;
      EdtHistorial.Lines.Append(_('No se encontró el archivo') + '''Historial.txt''.');
    end;
  end;

end;

end.
