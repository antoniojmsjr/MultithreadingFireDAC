unit Utils.DB;

interface

procedure QueryOpen(const pConnectDefName: string; const pSQL: string);

implementation

uses
  FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Stan.Pool;

procedure QueryOpen(const pConnectDefName: string; const pSQL: string);
var
  lFDConnection: TFDConnection;
  lQuery: TFDQuery;
begin
  lFDConnection := TFDConnection.Create(nil);
  lQuery := TFDQuery.Create(lFDConnection);
  try
    lFDConnection.ConnectionDefName := pConnectDefName;
    lQuery.Connection := lFDConnection;
    lQuery.SQL.Text := pSQL;
    lQuery.Open();
  finally
    lFDConnection.Free;
  end;
end;

end.
