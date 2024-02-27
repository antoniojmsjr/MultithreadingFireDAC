unit ConnectionDBConfig;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.Stan.Pool,

  //FireDAC.UI.Intf

  //FIREBIRD
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Phys.IBWrapper;

procedure FDManagerConnection(const pDataBase: string);

implementation

uses
  FDConnectionManager;

procedure FDManagerConnection(const pDataBase: string);
begin

  TFDConnectionManager.ConnectionSetup(
    'CONNECTION_DB_APP', //NOME DA CONEXÃO COM O BANCO DE DADOS - IDENTIFICAÇÃO DA CONEXÃO, USADO NO FDConnection.ConnectionDefName PARA RECUPERAR UMA CONEXÃO

    procedure(FDConnectionDefParams: TFDConnectionDefParams) //PARAMETRIZAÇÃO DA CONEXÃO COM O BANCO DE DADOS
    var
      lFDPhysFBConnectionDefParams: TFDPhysFBConnectionDefParams;
    begin
      lFDPhysFBConnectionDefParams := TFDPhysFBConnectionDefParams(FDConnectionDefParams);
      lFDPhysFBConnectionDefParams.DriverID := 'FB';
      lFDPhysFBConnectionDefParams.Database := pDataBase;
      lFDPhysFBConnectionDefParams.UserName := 'SYSDBA';
      lFDPhysFBConnectionDefParams.Password := 'masterkey';
      lFDPhysFBConnectionDefParams.Server := '127.0.0.1';
      lFDPhysFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;
      lFDPhysFBConnectionDefParams.CharacterSet := TIBCharacterSet.csWIN1252;

      lFDPhysFBConnectionDefParams.Pooled := False;
      lFDPhysFBConnectionDefParams.PoolMaximumItems := 100;
      lFDPhysFBConnectionDefParams.PoolCleanupTimeout := 15000;
      lFDPhysFBConnectionDefParams.PoolExpireTimeout := 60000;
    end,

    procedure(FDConnection: TFDCustomConnection) //CONFIGURAÇÃO DO FDConnection
    begin
      FDConnection.FetchOptions.Mode := TFDFetchMode.fmAll;
      FDConnection.ResourceOptions.AutoConnect := True;

      FDConnection.FormatOptions.MapRules.Clear;
      with FDConnection.FormatOptions.MapRules.Add do
      begin
        SourceDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
        TargetDataType := dtDateTime; { TFDParam.DataType }
      end;
      FDConnection.FormatOptions.OwnMapRules := True;
    end);
end;

end.
