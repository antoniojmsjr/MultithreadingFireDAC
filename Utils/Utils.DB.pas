unit Utils.DB;

interface

procedure QueryOpen(const pConnectDefName: string; const pSQL: string);

implementation

uses
  FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Stan.Pool;

procedure QueryOpen(const pConnectDefName: string; const pSQL: string);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := TFDConnection.Create(nil);
  lQuery.Connection.ConnectionDefName := pConnectDefName;
  try
    lQuery.SQL.Add(pSQL);
    lQuery.Open;
  finally
    lQuery.Close;
    lQuery.Connection.Free; //INTERNAL CLOSE
    lQuery.Free;
  end;
end;

end.
