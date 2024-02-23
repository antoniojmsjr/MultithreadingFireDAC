object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Multithreading (FireDAC)'
  ClientHeight = 561
  ClientWidth = 784
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 293
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
        0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000001C
        0000001C0802000000FD6F48C3000000017352474200AECE1CE9000000046741
        4D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA86400
        00017A49444154484BED93B14A03411086F37AF63636363616A9044B6DB54D2B
        04B6113BC1CAC2C6CEC246B010130F45D488A2F806FA997F588ED939EF224997
        611276F666BEFB6776AFF7BD00FB857ECDD5524A4BE882A19F9397E7E3A36A77
        EB7663F5666DC5F9A8BF7EBFBF33393DB1EC06F35058F8C3600FF4DBE545DD5F
        CFCF9E0E87BC0FFAE3C1C00A22F3500AA8B7A0C12082B620B2AED0F7EB2BB4A3
        146708EA4661991F4011C2642D9EE2A0B08F23D0B946CF3F742B08679AEBA14B
        D7DDF62668CB28ECA31A934989C5A15210192DAFAB088D0990664108E5945920
        8D546E0F4AFF3E6BAC058A469C4300472AC3E56252A01D37041A278757AACA76
        43A5FF764334B58F28E698CF172DECF0AF1D5D29ADF599F0B4054ABFF5360939
        3A0D3A3486A011595C422976B73287DAA19E267034BAA78628A13294EAFBD121
        889E8B9DD3478BD2D2C0214A6B1D77DDB54F7FB3417508BAADAC1D946E502ABD
        56D0058A310D882A76CECBE89D9759EAD43A4167B525B4C76FCE96D20F5DA29D
        26629F62600000000049454E44AE426082}
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitHeight = 39
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 40
    Width = 784
    Height = 250
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlMain'
    ShowCaption = False
    TabOrder = 1
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 3
      Top = 213
      Width = 778
      Height = 5
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 0
      ExplicitTop = 275
      ExplicitWidth = 534
    end
    object gbxConfiguracaoDB: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 778
      Height = 118
      Align = alTop
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
        Enabled = False
        TabOrder = 0
        Text = 'FB_CONNECTION_DATABASE'
      end
      object edtBancoDados: TEdit
        Left = 135
        Top = 49
        Width = 250
        Height = 21
        TabOrder = 1
        TextHint = 'Selecionar banco de dados...'
      end
      object edtServidor: TEdit
        Left = 135
        Top = 82
        Width = 250
        Height = 21
        TabOrder = 2
        Text = '127.0.0.1'
      end
    end
    object gbxPoolDB: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 127
      Width = 778
      Height = 80
      Align = alTop
      Caption = ' Pool de Conex'#227'o '
      TabOrder = 1
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
      Top = 222
      Width = 150
      Height = 25
      Caption = 'Configurar FDManager'
      TabOrder = 2
      OnClick = btnConfigFDManagerClick
    end
    object lblTestConnection: TLinkLabel
      Left = 15
      Top = 226
      Width = 112
      Height = 17
      Cursor = crHandPoint
      Caption = '<a href="">Testar configura'#231#227'o...</a>'
      Enabled = False
      TabOrder = 3
      OnLinkClick = lblTestConnectionLinkClick
    end
  end
  object pnlTeste: TPanel
    Left = 0
    Top = 301
    Width = 784
    Height = 260
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
      Height = 219
      Align = alClient
      Caption = ' Log '
      TabOrder = 1
      object mmoLog: TMemo
        Left = 2
        Top = 15
        Width = 780
        Height = 202
        Align = alClient
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object odlDataBase: TOpenDialog
    Filter = 'Firebird(*.fdb)|*.fdb'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Title = 'Selecionar Banco de Dados'
    Left = 480
    Top = 8
  end
end
