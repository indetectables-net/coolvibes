object FormSeleccionarIdioma: TFormSeleccionarIdioma
  Left = 286
  Top = 330
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Select  Your Language'
  ClientHeight = 70
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    208
    70)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelAutor: TLabel
    Left = 3
    Top = 32
    Width = 4
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 80
    Top = 48
    Width = 49
    Height = 21
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object cmbLanguages: TComboBox
    Left = 4
    Top = 8
    Width = 194
    Height = 21
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = True
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 1
    OnChange = cmbLanguagesChange
  end
end
