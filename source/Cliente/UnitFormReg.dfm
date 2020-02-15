object FormReg: TFormReg
  Left = 319
  Top = 216
  Width = 315
  Height = 251
  Caption = 'A'#241'adiendo valor tipo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LabelNombre: TLabel
    Left = 8
    Top = 8
    Width = 83
    Height = 13
    Caption = 'Nombre del valor:'
  end
  object LabelInformacion: TLabel
    Left = 8
    Top = 56
    Width = 101
    Height = 13
    Caption = 'Informaci'#243'n del valor:'
  end
  object BtnAceptar: TSpeedButton
    Left = 136
    Top = 192
    Width = 81
    Height = 22
    Caption = 'Aceptar'
    Flat = True
    OnClick = BtnAceptarClick
  end
  object BtnCancelar: TSpeedButton
    Left = 224
    Top = 192
    Width = 81
    Height = 22
    Caption = 'Cancelar'
    Flat = True
    OnClick = BtnCancelarClick
  end
  object EditNombreValor: TEdit
    Left = 8
    Top = 24
    Width = 297
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object MemoInformacionValor: TMemo
    Left = 8
    Top = 72
    Width = 297
    Height = 113
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    WordWrap = False
    OnKeyPress = MemoInformacionValorKeyPress
  end
end
