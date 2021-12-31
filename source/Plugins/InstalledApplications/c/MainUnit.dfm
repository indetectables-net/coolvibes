object FormMain: TFormMain
  Left = 311
  Top = 253
  BorderIcons = [biSystemMenu]
  ClientHeight = 503
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    556
    503)
  PixelsPerInch = 96
  TextHeight = 13
  object BtnEnviar: TSpeedButton
    Left = 480
    Top = 475
    Width = 68
    Height = 22
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    Caption = 'Refresh'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000000000000000
      0000000000000000000000009FC2A20000000000000000000000000000000000
      000000000000000000000000000000000000000000000000008BBC905E9D6300
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009BCBA066B06E61AA683D8B4437833E327B373D7F436496689EBC
      A0000000000000000000000000000000000000AAD8AF73BD7C96D19F94CF9C8F
      CD968ACA9185C78B7ABE8165AD6C4B925168976B000000000000000000000000
      000000A9DBAF79C4839ED7A79BD4A497D29F92CF9A8DCC9588CA907AC2827EC4
      855DA46369996C000000000000000000000000000000A4DAAB7BC78577C28154
      AB5E4EA357499B5163AC6B83C38B87C98F82C689509756A0BFA2000000000000
      0000000000000000009ED8A57BC7840000000000000000009BC9A05BA26286C6
      8E88C98F6FB376699D6DB8D7BBB6D4B9B4D1B6B2CEB4AFCBB1000000B4E2BA00
      0000000000000000000000A4CFA854A05B48954F408B47478B4E5DA9644C9C54
      48954F49904F97BE9B00000000000000000000000092B294000000BEDFC2BCDC
      BFBAD9BDB7D6BBB5D3B884C38B80C3898DCC9583C48A54995A90BA9400000000
      00000000004A814D739C76000000000000000000000000000000B7DEBB75BF7E
      98D2A194CF9C86C78D5EA765398640347E3A2E763349904F458B4A7EA5810000
      000000000000000000000000008ECD9685C98E9BD4A48FCE9892CF9A8DCC9588
      CA9083C68B7EC48579C17F478D4C87AC89000000000000000000000000000000
      90CF9779C38389CA9294D09C95D19E90CF998CCB9487C98F80C4874E95548FB3
      92000000000000000000000000000000000000B9E1BE89C99064B46C50A65A4B
      9E5345964D60A8685BA2628CB690000000000000000000000000000000000000
      00000000000000000000000000000000000000000067AB6E8BBC900000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000ACD4B0000000000000000000000000000000000000}
    OnClick = BtnEnviarClick
    ExplicitLeft = 490
    ExplicitTop = 485
  end
  object ListViewPlugin: TListView
    Left = 8
    Top = 3
    Width = 541
    Height = 466
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkSoft
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
        Caption = 'Program'
      end
      item
        Caption = 'Uninstall path'
        Width = 267
      end
      item
        Caption = 'Uninstall type'
        Width = 101
      end>
    FlatScrollBars = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenuPlugin
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitWidth = 551
    ExplicitHeight = 476
  end
  object PopupMenuPlugin: TPopupMenu
    Left = 504
    Top = 424
    object Uninstall: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000004A4CB31317A300000000000000000000000000000000000E4A53FF110F
        180000000000000000000000000000004547B380A3FF98BEFF1318A800000000
        00000000000000105D73FFA7D2FF5D6EFF110F190000000000000000001A1C80
        6B8CFF7996FF7692FE83A6FF1A23B40000000000145A75FF82A2FF728EFC88AC
        FF5E6FFF000000000000000000000000333FC5546CFF4D60FA4D60FB6B88FF10
        1BA3506AFF5D75FF4C5FFA4F62FC5971FF030219000000000000000000000000
        0000003543CF3445FF2F39F72D37F8536DFF3A4AFB2E38F72E38F84962FF0706
        1B0000000000000000000000000000000000000000003645CE1622FF1216F50F
        13F51015F51216F6364CFF0B0C1D000000000000000000000000000000000000
        0000000000000000082336FF2E34F7343EF7353EF7252DFF1828BB0000000000
        000000000000000000000000000000000000000105204053FF5563F95A6BFA60
        72F95F71FA5C6EFA5465FF2435DD000000000000000000000000000000000000
        0205204154FF5968F96074FA7185FA5169FF6F85FF6C80FA6476FA5A6BFF2335
        DE000000000000000000000000050A373D51FF5666F96276FA798EFA6881FF00
        0008394AD7829CFF778CFB667AFA5A6CFF2436E5000000000000000000202338
        5166FF6072F9778CFA6984FF0406200000000000003C4EDF86A1FF788CFA586D
        FF5867E70000000000000000000000001718206076FF6781FF04062000000000
        00000000000000003E4FDF708BFF5462E0000000000000000000000000000000
        0000001317380D113800000000000000000000000000000000000039439F0000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      Caption = 'Uninstall'
      OnClick = UninstallClick
    end
    object Refresh1: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000000000000000
        0000000000000000000000009FC2A20000000000000000000000000000000000
        000000000000000000000000000000000000000000000000008BBC905E9D6300
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000009BCBA066B06E61AA683D8B4437833E327B373D7F436496689EBC
        A0000000000000000000000000000000000000AAD8AF73BD7C96D19F94CF9C8F
        CD968ACA9185C78B7ABE8165AD6C4B925168976B000000000000000000000000
        000000A9DBAF79C4839ED7A79BD4A497D29F92CF9A8DCC9588CA907AC2827EC4
        855DA46369996C000000000000000000000000000000A4DAAB7BC78577C28154
        AB5E4EA357499B5163AC6B83C38B87C98F82C689509756A0BFA2000000000000
        0000000000000000009ED8A57BC7840000000000000000009BC9A05BA26286C6
        8E88C98F6FB376699D6DB8D7BBB6D4B9B4D1B6B2CEB4AFCBB1000000B4E2BA00
        0000000000000000000000A4CFA854A05B48954F408B47478B4E5DA9644C9C54
        48954F49904F97BE9B00000000000000000000000092B294000000BEDFC2BCDC
        BFBAD9BDB7D6BBB5D3B884C38B80C3898DCC9583C48A54995A90BA9400000000
        00000000004A814D739C76000000000000000000000000000000B7DEBB75BF7E
        98D2A194CF9C86C78D5EA765398640347E3A2E763349904F458B4A7EA5810000
        000000000000000000000000008ECD9685C98E9BD4A48FCE9892CF9A8DCC9588
        CA9083C68B7EC48579C17F478D4C87AC89000000000000000000000000000000
        90CF9779C38389CA9294D09C95D19E90CF998CCB9487C98F80C4874E95548FB3
        92000000000000000000000000000000000000B9E1BE89C99064B46C50A65A4B
        9E5345964D60A8685BA2628CB690000000000000000000000000000000000000
        00000000000000000000000000000000000000000067AB6E8BBC900000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000ACD4B0000000000000000000000000000000000000}
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
  end
end
