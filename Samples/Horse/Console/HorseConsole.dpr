program HorseConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.HandleException,
  Horse.Jhonson,
  Routers in '..\Source\Routers.pas',
  ConnectionDBConfig in '..\Source\ConnectionDBConfig.pas',
  InternalHandleException in '..\Source\InternalHandleException.pas',
  DataModule in '..\Source\DataModule.pas' {dmDataModule: TDataModule};

begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse
    .Use(Jhonson)
    .Use(HandleException(InterceptException));

  TRouters.Register;

  THorse.MaxConnections := 1500;

  THorse.Listen(9000,
    procedure
    begin
      FDManagerConnection('D:\DELPHI\MultithreadingFireDAC\Samples\DB\MultithreadingFireDAC.FDB');

      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Readln;
    end);
end.
