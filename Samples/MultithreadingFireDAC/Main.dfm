object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Multithreading (FireDAC)'
  ClientHeight = 661
  ClientWidth = 784
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 288
    Width = 778
    Height = 5
    Align = alTop
    Shape = bsTopLine
    ExplicitLeft = -2
    ExplicitTop = 295
    ExplicitWidth = 528
  end
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Multithreading (FireDAC)'
    Color = 15561733
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object imgToolbar: TImage
      Left = 0
      Top = 0
      Width = 35
      Height = 40
      Align = alLeft
      Center = True
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D494844520000001C0000
        001C0802000000FD6F48C3000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
        124944415478DA63FCFFFF3F03B50123D0D08F1F3F52D1C40D1B368C1A4A6343
        FF7DFFF6FDF8C11F174EFF79FAE8DFB7AF68AA9985455965E439F44D382DED49
        30F465710A9064D733669555002264A5FFBE7E01DAF4F3E6D55FB7AF733B7AF0
        85C5136BE8F3CC48E1A23A36554D3C0EF9B46AE1EF270F81CA2835F4F7E30740
        07FEFFFE0DC8FE76FC209001F40D8B881890CBA6A685A61E8BA140AFF1F88632
        7172C18D7B3FB3EFEFDBD720FD189641829E898B9BDBC993C73B18679842E207
        A81F18274CDC3C4077012DE08FCB400B623800DAF775EFB6AFFB77484E5F8ED3
        A540B3FEBE7B831CF5BC3E2170576005C09079DBD784CF50C1F4220E0353A0AF
        FFFFF8FEF7CDABCF5BD772E819E3896BC286C29314BB9A16B388188B8CFCC785
        D37F5C3CC3696107140172910301E871A09F7E9C3FF5FDE4612057BC770E4E97
        32900B08781F9862804E00A67348FC729ADB021D080C1060F20439F0DD1BA002
        16693906481E935500C6E4874533F0190ACC85C068817BF3FD8C5EA0378122C0
        80C615FB9F562F0206114E4381B9FED39AC5C8A912E82E081722024C9210FBFE
        BC79050953B82C4E4321009E7F80F91D1809109F0245B0BA149804818180CFA5
        98009856807A04E233E1D18D2C0BF10DD07FC05C4782A1C092101809407339C0
        45173338BF2352E8AD6B401381110874AF487507B1864242036834D0FB90D847
        06584BD8A15B9D0C6E43172C5840451321000026B9F4C9E33265000000000049
        454E44AE426082}
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitHeight = 39
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 40
    Width = 784
    Height = 245
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlMain'
    ShowCaption = False
    TabOrder = 1
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 3
      Top = 209
      Width = 778
      Height = 5
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 0
      ExplicitTop = 275
      ExplicitWidth = 534
    end
    object gbxPoolDB: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 123
      Width = 778
      Height = 80
      Align = alTop
      Caption = ' Pool de Conex'#227'o '
      TabOrder = 0
      object Label4: TLabel
        Left = 177
        Top = 26
        Width = 104
        Height = 13
        Caption = 'POOL_MaximumItems'
      end
      object Label5: TLabel
        Left = 320
        Top = 26
        Width = 110
        Height = 13
        Caption = 'POOL_CleanupTimeout'
      end
      object Label6: TLabel
        Left = 471
        Top = 26
        Width = 101
        Height = 13
        Caption = 'POOL_ExpireTimeout'
      end
      object Label7: TLabel
        Left = 395
        Top = 53
        Width = 13
        Height = 13
        Caption = 'ms'
      end
      object Label8: TLabel
        Left = 544
        Top = 53
        Width = 13
        Height = 13
        Caption = 'ms'
      end
      object ckbPooled: TCheckBox
        Left = 12
        Top = 25
        Width = 133
        Height = 17
        Caption = 'Usar pool de conex'#245'es?'
        TabOrder = 0
      end
      object edtPOOL_MaximumItems: TEdit
        Left = 177
        Top = 45
        Width = 70
        Height = 21
        TabOrder = 1
        Text = '50'
      end
      object edtPOOL_CleanupTimeout: TEdit
        Left = 320
        Top = 45
        Width = 70
        Height = 21
        TabOrder = 2
        Text = '15000'
      end
      object edtPOOL_ExpireTimeout: TEdit
        Left = 468
        Top = 45
        Width = 70
        Height = 21
        TabOrder = 3
        Text = '60000'
      end
    end
    object btnConfigFDManager: TBitBtn
      Left = 612
      Top = 217
      Width = 150
      Height = 25
      Caption = 'Configurar FDManager'
      TabOrder = 1
      OnClick = btnConfigFDManagerClick
    end
    object lblTestConnection: TLinkLabel
      Left = 15
      Top = 221
      Width = 112
      Height = 17
      Cursor = crHandPoint
      Caption = '<a href="">Testar configura'#231#227'o...</a>'
      Enabled = False
      TabOrder = 2
      OnLinkClick = lblTestConnectionLinkClick
    end
    object pnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 120
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlHeader'
      ShowCaption = False
      TabOrder = 3
      object gbxConfiguracaoConnectionDB: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 420
        Height = 114
        Align = alLeft
        Caption = ' Configura'#231#227'o de Acesso '
        TabOrder = 0
        object Label1: TLabel
          Left = 12
          Top = 25
          Width = 112
          Height = 13
          Caption = 'Connection Def. Name:'
        end
        object Label2: TLabel
          Left = 12
          Top = 57
          Width = 81
          Height = 13
          Caption = 'Banco de Dados:'
        end
        object SpeedButton1: TSpeedButton
          Left = 392
          Top = 49
          Width = 23
          Height = 21
          Caption = '...'
          OnClick = SpeedButton1Click
        end
        object Label3: TLabel
          Left = 12
          Top = 90
          Width = 44
          Height = 13
          Caption = 'Servidor:'
        end
        object edtConnectionDefName: TEdit
          Left = 135
          Top = 17
          Width = 250
          Height = 21
          Hint = 
            'IDENTIFICA'#199#195'O DA CONEX'#195'O, USADO NO FDConnection.ConnectionDefNam' +
            'e PARA RECUPERAR UMA CONEX'#195'O'
          ReadOnly = True
          TabOrder = 0
          Text = 'FB_CONNECTION_DATABASE'
        end
        object edtConnectionDatabase: TEdit
          Left = 135
          Top = 49
          Width = 250
          Height = 21
          TabOrder = 1
          TextHint = 'Selecionar banco de dados...'
        end
        object edtConnectionServer: TEdit
          Left = 135
          Top = 82
          Width = 250
          Height = 21
          TabOrder = 2
          Text = '127.0.0.1'
        end
      end
      object gbxConfiguracaoDriverDB: TGroupBox
        AlignWithMargins = True
        Left = 429
        Top = 3
        Width = 352
        Height = 114
        Align = alClient
        Caption = ' Configura'#231#227'o do driver de comunica'#231#227'o '
        TabOrder = 1
        object Label11: TLabel
          Left = 12
          Top = 25
          Width = 87
          Height = 13
          Caption = 'Driver Def. Name:'
        end
        object Label12: TLabel
          Left = 12
          Top = 57
          Width = 68
          Height = 13
          Caption = 'Vendor Home:'
        end
        object Label13: TLabel
          Left = 12
          Top = 90
          Width = 54
          Height = 13
          Caption = 'Vendor Lib:'
        end
        object edtDriverDefName: TEdit
          Left = 119
          Top = 17
          Width = 225
          Height = 21
          Hint = 
            'IDENTIFICA'#199#195'O DO DRIVER, USADO NA CONFIGURA'#199#195'O DA CONEX'#195'O FDPhys' +
            'FBConnectionDefParams.DriverID'
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ReadOnly = True
          TabOrder = 0
          Text = 'DRIVER_FB_2.5'
        end
        object edtDriverVendorHome: TEdit
          Left = 119
          Top = 49
          Width = 225
          Height = 21
          TabOrder = 1
          Text = 'C:\Program Files (x86)\Firebird\Firebird_2_5'
        end
        object edtDriverVendorLib: TEdit
          Left = 119
          Top = 82
          Width = 225
          Height = 21
          TabOrder = 2
          Text = 'fbclient.dll'
        end
      end
    end
  end
  object pnlTeste: TPanel
    Left = 0
    Top = 296
    Width = 784
    Height = 365
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlTeste'
    ShowCaption = False
    TabOrder = 2
    object Bevel3: TBevel
      AlignWithMargins = True
      Left = 3
      Top = 33
      Width = 778
      Height = 5
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 0
      ExplicitTop = 47
      ExplicitWidth = 534
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object Label9: TLabel
        Left = 15
        Top = 6
        Width = 56
        Height = 13
        Caption = 'Intera'#231#245'es:'
      end
      object Label10: TLabel
        Left = 180
        Top = 6
        Width = 105
        Height = 13
        Caption = 'Quantidade registros:'
      end
      object btnExecuteQuery: TBitBtn
        Left = 612
        Top = 2
        Width = 150
        Height = 25
        Caption = 'Executar Consulta'
        Enabled = False
        TabOrder = 2
        OnClick = btnExecuteQueryClick
      end
      object edtQuantidadeRegistros: TSpinEdit
        Left = 295
        Top = 2
        Width = 70
        Height = 22
        MaxValue = 100000
        MinValue = 1
        TabOrder = 1
        Value = 1500
      end
      object edtInteracoes: TSpinEdit
        Left = 80
        Top = 2
        Width = 60
        Height = 22
        MaxValue = 70000
        MinValue = 1
        TabOrder = 0
        Value = 50
      end
      object pgbStatusExecute: TProgressBar
        Left = 410
        Top = 5
        Width = 150
        Height = 17
        Style = pbstMarquee
        TabOrder = 3
        Visible = False
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 41
      Width = 784
      Height = 324
      Align = alClient
      Caption = ' Log '
      TabOrder = 1
      object mmoLog: TMemo
        Left = 2
        Top = 15
        Width = 780
        Height = 307
        Align = alClient
        BorderStyle = bsNone
        PopupMenu = ppMain
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object odlDataBase: TOpenDialog
    Filter = 'Firebird(*.fdb)|*.fdb'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Title = 'Selecionar Banco de Dados'
    Left = 696
  end
  object ppMain: TPopupMenu
    Left = 736
    object ppiLimparLog: TMenuItem
      Caption = 'LIMPAR LOG'
      OnClick = ppiLimparLogClick
    end
  end
end
