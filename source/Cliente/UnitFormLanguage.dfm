object FormSeleccionarIdioma: TFormSeleccionarIdioma
  Left = 286
  Top = 330
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Select  Your Language'
  ClientHeight = 82
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    272
    82)
  PixelsPerInch = 120
  TextHeight = 17
  object LabelAutor: TLabel
    Left = 4
    Top = 42
    Width = 5
    Height = 18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -15
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 105
    Top = 47
    Width = 64
    Height = 27
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object cmbLanguages: TComboBox
    Left = 5
    Top = 10
    Width = 254
    Height = 25
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = True
    ItemHeight = 17
    ParentCtl3D = False
    TabOrder = 1
    OnChange = cmbLanguagesChange
  end
end
