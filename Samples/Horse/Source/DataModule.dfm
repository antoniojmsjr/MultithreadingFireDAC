object dmDataModule: TdmDataModule
  OldCreateOrder = False
  Height = 150
  Width = 215
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\DELPHI\MultithreadingFireDAC\Samples\DB\Multithreadi' +
        'ngFireDAC.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=WIN1252'
      'DriverID=FB')
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtDateTimeStamp
        TargetDataType = dtDateTime
      end>
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    BeforeConnect = FDConnectionBeforeConnect
    Left = 32
    Top = 32
  end
  object FDQuery: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = FDConnection
    SQL.Strings = (
      'SELECT FIRST 5000 * FROM MULTITHREADING')
    Left = 112
    Top = 32
    object FDQueryUUID: TStringField
      FieldName = 'UUID'
      Origin = 'UUID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 50
    end
    object FDQueryDATETIME: TDateTimeField
      FieldName = 'DATETIME'
      Origin = 'DATETIME'
      Required = True
    end
  end
end
