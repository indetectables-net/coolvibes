object FormOpciones: TFormOpciones
  Left = 284
  Top = 247
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Opciones'
  ClientHeight = 352
  ClientWidth = 241
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
  object LabelPuerto: TLabel
    Left = 16
    Top = 13
    Width = 120
    Height = 13
    Caption = 'Puerto de escucha'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BtnGuardar: TSpeedButton
    Left = 153
    Top = 327
    Width = 81
    Height = 22
    Caption = 'Guardar'
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006D6D6D63585858BF515151BF5252
      5263007D21EB037B1EFF00791504FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF006F6F6F296A6A6A0E7A7A7A02818181EABDBDBDFFB2B2B2FF5B5B
      5BEA01832BEB43A15FFF037921D400791906FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008181819B6F6F6FFD646464E776767619229751FF1C914AFF168F44FF108B
      3BFF3A9F5EFF80C196FF46A362FF097724ED00791907FFFFFF00FFFFFF00A4A4
      A47BBCBCBCFFDEDEDEFFA6A6A6FF838383F4299B5BFF90CAA9FF8DC8A5FF8AC6
      A1FF88C59EFF6AB685FF82C297FF48A566FF077925EA00791B09FFFFFF00ABAB
      AB7DA6A6A6FED5D5D5FFC5C5C5FFCBCBCBFF319F63FF94CDADFF6FBA8EFF6BB8
      89FF66B685FF61B380FF67B582FF83C298FF3CA05CFF007F25F9FFFFFF00FFFF
      FF00ACACAC85C5C5C5FFC1C1C1FFC5C5C5FF37A36BFF96CEB0FF94CDADFF91CB
      AAFF90CBA8FF74BC90FF8AC7A1FF46A568FF078735FB01832D01A3A3A3CD8F8F
      8FE3A0A0A0EECFCFCFFFC6C6C6FFCCCCCCFF3DA56FFF37A36DFC33A167FC309D
      62FE55AF7CFF91CBAAFF4FAB74FF188E45FF585858E3535353CDBFBFBFFDE2E2
      E2FFD2D2D2FFC6C6C6FFCDCDCDFFB1B1B1FF93939344FFFFFF00FFFFFF009595
      95443AA068FF5AB381FF289857FFC0C0C0FFD2D2D2FF616161FDC4C4C4FDE9E9
      E9FFD6D6D6FFC9C9C9FFCECECEFFA5A5A5FF84848444FFFFFF00FFFFFF009A9A
      9A4440A470FF319F65FFBABABAFFC6C6C6FFDDDDDDFF6B6B6BFDC8C8C8CDC4C4
      C4E3C0C0C0EED8D8D8FFCDCDCDFFBCBCBCFF828282C6777777447E7E7E448F8F
      8FC6C3C3C3FFC2C2C2FFCDCDCDFF8C8C8CEE878787E3838383CDFFFFFF00FFFF
      FF00C5C5C585D4D4D4FFCCCCCCFFC9C9C9FFBABABAFF9C9C9CFFA1A1A1FFC2C2
      C2FFC6C6C6FFC1C1C1FFB7B7B7FF89898985FFFFFF00FFFFFF00FFFFFF00CACA
      CA7DC4C4C4FEDCDCDCFFD4D4D4FFD9D9D9FFDBDBDBFFD6D6D6FFD4D4D4FFD9D9
      D9FFD2D2D2FFCBCBCBFFC8C8C8FF797979FE7171717DFFFFFF00FFFFFF00D0D0
      D07BDCDCDCFFEDEDEDFFDBDBDBFFC2C2C2F4BEBEBEFED6D6D6FFD4D4D4FFB0B0
      B0FEACACACF4CBCBCBFFE7E7E7FFB7B7B7FF8B8B8B7BFFFFFF00FFFFFF00FFFF
      FF00D1D1D19BCECECEFDCACACAE7C6C6C619C2C2C2E7DEDEDEFFDDDDDDFFB2B2
      B2E7B1B1B119ACACACE7A7A7A7FDA3A3A39BFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D1D1D129CECECE0ECBCBCB02C7C7C7EAE5E5E5FFE4E4E4FFACAC
      ACEAB6B6B602B2B2B20EADADAD29FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBCBCB63C7C7C7BFC4C4C4BFBFBF
      BF63FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    OnClick = BtnGuardarClick
  end
  object EditPuerto: TEdit
    Left = 144
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 0
  end
  object GrpBoxAlSalir: TGroupBox
    Left = 8
    Top = 120
    Width = 225
    Height = 73
    Caption = 'Al salir...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clActiveCaption
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object LabelPreguntarAlSalir: TLabel
      Left = 32
      Top = 24
      Width = 4
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CheckBoxPreguntarAlSalir: TCheckBox
      Left = 8
      Top = 24
      Width = 169
      Height = 17
      Caption = 'Solicitar confirmaci'#243'n'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnClick = CheckBoxPreguntarAlSalirClick
    end
    object CheckBoxCloseToTray: TCheckBox
      Left = 8
      Top = 48
      Width = 161
      Height = 17
      Caption = 'Cerrar al tray'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      OnClick = CheckBoxCloseToTrayClick
    end
  end
  object GrpBoxServerDesconect: TGroupBox
    Left = 8
    Top = 40
    Width = 225
    Height = 73
    Caption = 'Server conectar/desconectar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clActiveCaption
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object CheckBoxNotiMsnDesc: TCheckBox
      Left = 8
      Top = 48
      Width = 169
      Height = 17
      Caption = 'Avisar al desconectar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object CheckBoxNotificacionMsn: TCheckBox
      Left = 8
      Top = 24
      Width = 209
      Height = 17
      Caption = 'Notificaci'#243'n MSN al conectar'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBoxConexion: TGroupBox
    Left = 8
    Top = 200
    Width = 225
    Height = 73
    Caption = 'Conexi'#243'n'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clActiveCaption
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 212
      Top = 24
      Width = 7
      Height = 13
      Caption = 's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CheckBoxEscucharAlIniciar: TCheckBox
      Left = 8
      Top = 48
      Width = 161
      Height = 17
      Caption = 'Escuchar al iniciar'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnClick = CheckBoxCloseToTrayClick
    end
    object CheckBoxMandarPingAuto: TCheckBox
      Left = 8
      Top = 24
      Width = 177
      Height = 17
      Caption = 'Mandar ping auto. cada'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object EditPingTimerInterval: TEdit
      Left = 184
      Top = 16
      Width = 25
      Height = 21
      TabOrder = 2
      Text = '30'
    end
  end
  object CheckBoxMinimizeToTray: TCheckBox
    Left = 16
    Top = 280
    Width = 129
    Height = 17
    Caption = 'Minimizar al tray'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
  end
  object CheckBoxAutoRefrescar: TCheckBox
    Left = 16
    Top = 304
    Width = 129
    Height = 17
    Caption = 'Auto-Refrescar'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
  end
end
