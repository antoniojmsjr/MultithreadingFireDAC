unit Utils.DB;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Stan.Pool;

Type
  IQuery = interface
    ['{9A5E7D0A-34FB-4FA3-83D7-D4CECD2C22D6}']
    function GetQuery: TFDQuery;
    property Query: TFDQuery read GetQuery;
  end;

  TCommand = class(TInterfacedObject, IQuery)
  private
    { private declarations }
    FFDConnection: TFDConnection;
    FQuery: TFDQuery;
    function GetQuery: TFDQuery;
    constructor Create(const pConnectionDefName: string);
  protected
    { protected declarations }
  public
    { public declarations }
    destructor Destroy; override;
    class function Build(const pConnectionDefName: string): IQuery;
  end;

implementation

{ TCommand }

class function TCommand.Build(const pConnectionDefName: string): IQuery;
begin
  Result := Self.Create(pConnectionDefName);
end;

constructor TCommand.Create(const pConnectionDefName: string);
begin
  FFDConnection := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(FFDConnection);
  FQuery.Connection := FFDConnection;

  FFDConnection.ConnectionDefName := pConnectionDefName;
end;

destructor TCommand.Destroy;
begin
  FQuery.Close;
  FFDConnection.Free;
  inherited Destroy;
end;

function TCommand.GetQuery: TFDQuery;
begin
  Result := FQuery;
end;

end.
