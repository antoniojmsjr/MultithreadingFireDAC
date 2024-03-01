unit Routers;

interface

uses
  Horse, System.Diagnostics;

type

  TRouters = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class procedure Register;
    class procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
    class procedure GetSelect(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
    class procedure GetSelectDataModule(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  end;

implementation

uses
  System.SysUtils, Utils.DB, FireDAC.Stan.Error, DataModule;

{ TRouters }

class procedure TRouters.GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Pong');
end;

class procedure TRouters.GetSelect(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  lSW: TStopwatch;
  lMsg: string;
begin

  lSW := TStopwatch.StartNew;
  try
    TCommand.Build('CONNECTION_DB_APP') //IDENTIFICAÇÃO DA CONEXÃO, USADO NO FDConnection.ConnectionDefName PARA RECUPERAR UMA CONEXÃO
      .Query
        .Open('SELECT FIRST 5000 * FROM MULTITHREADING');
  except
    on E: Exception do
    begin
      lSW.Stop;
      raise;
    end;
  end;

  lSW.Stop;
  lMsg := '{"execute_time": "' + FormatDateTime('hh:nn:ss.zzz', lsw.ElapsedMilliseconds/MSecsPerDay) + '"}';
  Res.Send(lMsg).Status(200).ContentType('application/json');
end;

class procedure TRouters.GetSelectDataModule(Req: THorseRequest;
  Res: THorseResponse; Next: TNextProc);
var
  lSW: TStopwatch;
  lMsg: string;
  ldmDataModule: TdmDataModule;
begin
  lSW := TStopwatch.StartNew;

  ldmDataModule := TdmDataModule.Create(nil);
  try
    try
      ldmDataModule.FDQuery.Open;
    except
      on E: Exception do
      begin
        lSW.Stop;
        raise;
      end;
    end;
  finally
    FreeAndNil(ldmDataModule);
  end;

  lSW.Stop;
  lMsg := '{"execute_time": "' + FormatDateTime('hh:nn:ss.zzz', lsw.ElapsedMilliseconds/MSecsPerDay) + '"}';
  Res.Send(lMsg).Status(200).ContentType('application/json');
end;

class procedure TRouters.Register;
begin
  THorse.Get('/ping', GetPing);
  THorse.Get('/select', GetSelect);
  THorse.Get('/select/datamodule', GetSelectDataModule);
end;

end.
