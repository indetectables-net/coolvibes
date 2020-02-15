object FormSplash: TFormSplash
  Left = 644
  Top = 395
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Splash'
  ClientHeight = 270
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageSplash: TImage
    Left = 0
    Top = 0
    Width = 498
    Height = 270
    Align = alClient
  end
  object TimerSplash: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerSplashTimer
    Left = 112
    Top = 112
  end
  object TimerTransparencia: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TimerTransparenciaTimer
    Left = 144
    Top = 112
  end
end
