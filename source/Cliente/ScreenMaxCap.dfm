object ScreenMax: TScreenMax
  Left = -58
  Top = 44
  Width = 879
  Height = 640
  Caption = 'Capturador de Pantalla ::Coolvibes::'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object ImgCapturaGrande: TImage
    Left = 0
    Top = 0
    Width = 871
    Height = 613
    Align = alClient
    Stretch = True
    OnMouseDown = ImgCapturaGrandeMouseDown
  end
end
