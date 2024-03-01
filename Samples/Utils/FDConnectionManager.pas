unit FDConnectionManager;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TConnectionDefParams = reference to procedure(FDConnectionDefParams: TFDConnectionDefParams);
  TDriverDefParams = reference to procedure(FDStanDefinition: IFDStanDefinition);
  TConnectionConfig = reference to procedure(FDConnection: TFDCustomConnection);

  TFDConnectionManager = class(Tobject)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class constructor Create;
    class destructor Destroy;
    class procedure ConnectionSetup(const ConnectionDefName: string;
                                    const ConnectionDefParams: TConnectionDefParams;
                                    const DriverDefName: string;
                                    const DriverDefParams: TDriverDefParams;
                                    const ConnectionConfig: TConnectionConfig); overload;
    class procedure ConnectionSetup(const ConnectionDefName: string;
                                    const ConnectionDefParams: TConnectionDefParams;
                                    const ConnectionConfig: TConnectionConfig); overload;
  end;

implementation

{ TFDConnectionManager }

class constructor TFDConnectionManager.Create;
begin
  if FDManager.Active then
    FDManager.Close;
  FDManager.ActiveStoredUsage := [auRunTime];
  FDManager.ConnectionDefFileAutoLoad := False;
  FDManager.DriverDefFileAutoLoad := False;
end;

class destructor TFDConnectionManager.Destroy;
begin
  if FDManager.Active then
    FDManager.Close;

  Sleep(10);
end;

class procedure TFDConnectionManager.ConnectionSetup(
  const ConnectionDefName: string;
  const ConnectionDefParams: TConnectionDefParams;
  const ConnectionConfig: TConnectionConfig);
var
  lFDStanConnectionDef: IFDStanConnectionDef;
  lFDConnection: TFDCustomConnection;
begin
  if not FDManager.SilentMode then
    FDManager.SilentMode := True;

  FDManager.CloseConnectionDef(ConnectionDefName);

  //CONNECTION
  lFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(ConnectionDefName);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(ConnectionDefName)) then
  begin
    lFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    lFDStanConnectionDef.Name := ConnectionDefName;
  end;

  if Assigned(ConnectionDefParams) then
    ConnectionDefParams(lFDStanConnectionDef.Params);

  //CONNECTION CONFIG
  if Assigned(ConnectionConfig) then
  begin
    lFDConnection := nil;
    try
      lFDConnection := TFDCustomConnection.Create(nil);

      ConnectionConfig(lFDConnection);

      lFDStanConnectionDef.WriteOptions(lFDConnection.FormatOptions,
                                        lFDConnection.UpdateOptions,
                                        lFDConnection.FetchOptions,
                                        lFDConnection.ResourceOptions);
    finally
      lFDConnection.Free;
    end;
  end;

  if (FDManager.State <> TFDPhysManagerState.dmsActive) then
    FDManager.Open;
end;

class procedure TFDConnectionManager.ConnectionSetup(
  const ConnectionDefName: string; const ConnectionDefParams: TConnectionDefParams;
  const DriverDefName: string; const DriverDefParams: TDriverDefParams;
  const ConnectionConfig: TConnectionConfig);
var
  lFDStanConnectionDef: IFDStanConnectionDef;
  lFDStanDefinition: IFDStanDefinition;
  lFDConnection: TFDCustomConnection;
begin
  if not FDManager.SilentMode then
    FDManager.SilentMode := True;

  FDManager.CloseConnectionDef(ConnectionDefName);

  //DRIVER
  lFDStanDefinition := FDManager.DriverDefs.FindDefinition(DriverDefName);
  if not Assigned(FDManager.DriverDefs.FindDefinition(DriverDefName)) then
  begin
    lFDStanDefinition := FDManager.DriverDefs.Add;
    lFDStanDefinition.Name := DriverDefName;
  end;

  if Assigned(DriverDefParams) then
    DriverDefParams(lFDStanDefinition);

  //CONNECTION
  lFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(ConnectionDefName);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(ConnectionDefName)) then
  begin
    lFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    lFDStanConnectionDef.Name := ConnectionDefName;
  end;

  if Assigned(ConnectionDefParams) then
    ConnectionDefParams(lFDStanConnectionDef.Params);

  //CONNECTION CONFIG
  if Assigned(ConnectionConfig) then
  begin
    lFDConnection := nil;
    try
      lFDConnection := TFDCustomConnection.Create(nil);

      ConnectionConfig(lFDConnection);

      lFDStanConnectionDef.WriteOptions(lFDConnection.FormatOptions,
                                        lFDConnection.UpdateOptions,
                                        lFDConnection.FetchOptions,
                                        lFDConnection.ResourceOptions);
    finally
      lFDConnection.Free;
    end;
  end;
end;


end.
