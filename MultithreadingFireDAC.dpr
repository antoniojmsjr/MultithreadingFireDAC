program MultithreadingFireDAC;

uses
  FMX.Forms,
  FDManagerConfig in 'FDManagerConfig.pas',
  Main in 'Main.pas' {frmMain},
  Global.Common.Strings in 'Global.Common.Strings.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.





