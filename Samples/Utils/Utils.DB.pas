unit Utils.DB;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Stan.Pool;

Type
  ISQLCommand = interface
    ['{9A5E7D0A-34FB-4FA3-83D7-D4CECD2C22D6}']
    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
    property Connection: TFDConnection read GetConnection;
    property Query: TFDQuery read GetQuery;
  end;

  TSQLCommand = class(TInterfacedObject, ISQLCommand)
  private
    { private declarations }
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
    constructor Create(const pConnectionDefName: string);
  protected
    { protected declarations }
  public
    { public declarations }
    destructor Destroy; override;
    class function Build(const pConnectionDefName: string): ISQLCommand;
  end;

implementation

{ TSQLCommand }

class function TSQLCommand.Build(const pConnectionDefName: string): ISQLCommand;
begin
  Result := Self.Create(pConnectionDefName);
end;

constructor TSQLCommand.Create(const pConnectionDefName: string);
begin
  FConnection := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(FConnection);
  FQuery.Connection := FConnection;

  FConnection.ConnectionDefName := pConnectionDefName;
end;

destructor TSQLCommand.Destroy;
begin
  FQuery.Close;
  FConnection.Free;
  inherited Destroy;
end;

function TSQLCommand.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

function TSQLCommand.GetQuery: TFDQuery;
begin
  Result := FQuery;
end;

end.
