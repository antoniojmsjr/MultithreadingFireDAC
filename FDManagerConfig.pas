unit FDManagerConfig;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,

  //FIREBIRD
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Phys.IBWrapper;

type
  TConnectionDefDriverParams = record
    DriverDefName: string;
    VendorLib: string;
  end;

  TConnectionDefParams = record
    ConnectionDefName: string;
    Server: string;
    Database: string;
    UserName: string;
    Password: string;
    LocalConnection: Boolean;
  end;

  TConnectionDefPoolParams = record
    Pooled: Boolean;
    PoolMaximumItems: Integer;
    PoolCleanupTimeout: Integer;
    PoolExpireTimeout: Integer;
  end;

procedure ConfigFDManagerConnectionFirebird(
            const pConnectionDefDriverParams: TConnectionDefDriverParams;
            const pConnectionDefParams: TConnectionDefParams;
            const pConnectionDefPoolParams: TConnectionDefPoolParams);

implementation

procedure ConfigFDManagerConnectionFirebird(
  const pConnectionDefDriverParams: TConnectionDefDriverParams;
  const pConnectionDefParams: TConnectionDefParams;
  const pConnectionDefPoolParams: TConnectionDefPoolParams);
var
  lConnection: TFDCustomConnection;
  lFBConnectionDefParams: TFDPhysFBConnectionDefParams; // FIREBIRD CONNECTION PARAMS
  lFDStanConnectionDef: IFDStanConnectionDef;
  lFDStanDefinition: IFDStanDefinition;
begin
  //PARA CRIAR OU ALTERAR É NECESSÁRIO FECHAR A O FDMANGER REFERENTE A ConnectionDefName
  FDManager.CloseConnectionDef(pConnectionDefParams.ConnectionDefName);

  FDManager.ActiveStoredUsage := [auRunTime];
  FDManager.ConnectionDefFileAutoLoad := False;
  FDManager.DriverDefFileAutoLoad := False;
  FDManager.SilentMode := True; //DESATIVA O CICLO DE MENSAGEM COM O WINDOWS PARA APRESENTAR A AMPULHETA DE PROCESSANDO.
//  FDManager.Open;

  //DRIVER
  lFDStanDefinition := FDManager.DriverDefs.FindDefinition(pConnectionDefDriverParams.DriverDefName);
  if not Assigned(FDManager.DriverDefs.FindDefinition(pConnectionDefDriverParams.DriverDefName)) then
  begin
    lFDStanDefinition := FDManager.DriverDefs.Add;
    lFDStanDefinition.Name := pConnectionDefDriverParams.DriverDefName;
  end;
  lFDStanDefinition.AsString['BaseDriverID'] := 'FB'; //DRIVER BASE
  if not pConnectionDefDriverParams.VendorLib.Trim.IsEmpty then
    lFDStanDefinition.AsString['VendorLib'] := pConnectionDefDriverParams.VendorLib; //DEFINE O CAMINHO DA DLL CLIENT DO FIREBIRD.

  //CONNECTION
  lFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(pConnectionDefParams.ConnectionDefName);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(pConnectionDefParams.ConnectionDefName)) then
  begin
    lFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    lFDStanConnectionDef.Name := pConnectionDefParams.ConnectionDefName;
  end;

  //DEFINIÇÃO DE CONEXÃO: PRIVADO :: https://docwiki.embarcadero.com/RADStudio/Sydney/en/Defining_Connection_(FireDAC)
  lFBConnectionDefParams := TFDPhysFBConnectionDefParams(lFDStanConnectionDef.Params);
  lFBConnectionDefParams.DriverID := pConnectionDefDriverParams.DriverDefName;
  lFBConnectionDefParams.Database := pConnectionDefParams.Database;
  lFBConnectionDefParams.UserName := pConnectionDefParams.UserName;
  lFBConnectionDefParams.Password := pConnectionDefParams.Password;
  lFBConnectionDefParams.Server := pConnectionDefParams.Server;
  lFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;
  if not pConnectionDefParams.LocalConnection then
    lFBConnectionDefParams.Protocol := TIBProtocol.ipTCPIP;

  lFBConnectionDefParams.Pooled := pConnectionDefPoolParams.Pooled;
  lFBConnectionDefParams.PoolMaximumItems := pConnectionDefPoolParams.PoolMaximumItems;
  lFBConnectionDefParams.PoolCleanupTimeout := pConnectionDefPoolParams.PoolCleanupTimeout;
  lFBConnectionDefParams.PoolExpireTimeout := pConnectionDefPoolParams.PoolExpireTimeout;

  //WriteOptions
  lConnection := TFDCustomConnection.Create(nil);
  try
    lConnection.FetchOptions.Mode := TFDFetchMode.fmAll; //fmAll
    lConnection.ResourceOptions.AutoConnect := False;
//    lConnection.ResourceOptions.AutoReconnect := True;  //PERDA DE PERFORMANCE COM THREAD

    with lConnection.FormatOptions.MapRules.Add do
    begin
      SourceDataType := dtDateTime; { TFDParam.DataType }
      TargetDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
    end;

    lFDStanConnectionDef.WriteOptions(lConnection.FormatOptions,
                                      lConnection.UpdateOptions,
                                      lConnection.FetchOptions,
                                      lConnection.ResourceOptions);
  finally
    lConnection.Free;
  end;

  if (FDManager.State <> TFDPhysManagerState.dmsActive) then
    FDManager.Open;
end;

end.
