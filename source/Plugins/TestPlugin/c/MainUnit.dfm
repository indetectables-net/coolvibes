object FormMain: TFormMain
  Left = 219
  Top = 291
  Width = 364
  Height = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 120
    Width = 305
    Height = 25
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 128
    Top = 48
    Width = 129
    Height = 33
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 32
    Top = 56
    Width = 81
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
end
