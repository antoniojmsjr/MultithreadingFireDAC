unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Samples.Spin, System.Diagnostics, Vcl.ComCtrls,
  Vcl.Imaging.pngimage;

type
  TTypeLog = (tlERRO, tlTEMPO, tlINFO, tlLINE);
  TTypeLogHelper = record helper for TTypeLog
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function AsString: string;
    function AsInteger: Integer;
  end;

  TExecuteSelectLog = reference to procedure(const pTypeLog: TTypeLog; const pMessage: string);

  TExecuteSelect = class(TThread)
  private
    { private declarations }
    FConnectionDefName: string;
    FQuantidadeRegistros: Integer;
    FInteracoes: Integer;
    FExecuteSelectLog: TExecuteSelectLog;
    procedure Log(const pTypeLog: TTypeLog; const pMessage: string);
  protected
    { protected declarations }
    procedure Execute; override;
  public
    { public declarations }
    constructor Create(const pConnectionDefName: string;
                       const pInteracoes: Integer;
                       const pQuantidadeRegistros: Integer;
                       const pExecuteSelectLog: TExecuteSelectLog);
  end;

  TfrmMain = class(TForm)
    pnlToolbar: TPanel;
    imgToolbar: TImage;
    pnlMain: TPanel;
    gbxConfiguracaoDB: TGroupBox;
    Label1: TLabel;
    edtConnectionDefName: TEdit;
    Label2: TLabel;
    odlDataBase: TOpenDialog;
    edtBancoDados: TEdit;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    edtServidor: TEdit;
    gbxPoolDB: TGroupBox;
    ckbPooled: TCheckBox;
    Label4: TLabel;
    edtPOOL_MaximumItems: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtPOOL_CleanupTimeout: TEdit;
    edtPOOL_ExpireTimeout: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    btnConfigFDManager: TBitBtn;
    Bevel2: TBevel;
    lblTestConnection: TLinkLabel;
    pnlTeste: TPanel;
    Panel1: TPanel;
    Bevel3: TBevel;
    GroupBox1: TGroupBox;
    mmoLog: TMemo;
    Label9: TLabel;
    Label10: TLabel;
    btnExecuteQuery: TBitBtn;
    edtQuantidadeRegistros: TSpinEdit;
    edtInteracoes: TSpinEdit;
    pgbStatusExecute: TProgressBar;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnExecuteQueryClick(Sender: TObject);
    procedure btnConfigFDManagerClick(Sender: TObject);
    procedure lblTestConnectionLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
    FTotalElapsedMillisecondsDML: TStopwatch;
    procedure OnTerminateExecute(Sender: TObject);
    procedure Log(const pTypeLog: TTypeLog; const pMessage: string);
    procedure StatusExecucao(const pAtivar: Boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Threading, FDConnectionManager, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Utils.DB,

  //FIREBIRD
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Phys.IBWrapper;

{$R *.dfm}

procedure TfrmMain.btnConfigFDManagerClick(Sender: TObject);
begin
  btnExecuteQuery.Enabled := False;

  TFDConnectionManager.ConnectionConfig(
    edtConnectionDefName.Text, //NOME DA CONEXÃO COM O BANCO DE DADOS

    procedure(FDConnectionDefParams: TFDConnectionDefParams) //PARAMETRIZAÇÃO DA CONEXÃO COM O BANCO DE DADOS
    var
      lFDPhysFBConnectionDefParams: TFDPhysFBConnectionDefParams;
    begin
      lFDPhysFBConnectionDefParams := TFDPhysFBConnectionDefParams(FDConnectionDefParams);
      lFDPhysFBConnectionDefParams.DriverID := 'FB';
      lFDPhysFBConnectionDefParams.Database := edtBancoDados.Text;
      lFDPhysFBConnectionDefParams.UserName := 'SYSDBA';
      lFDPhysFBConnectionDefParams.Password := 'masterkey';
      lFDPhysFBConnectionDefParams.Server := edtServidor.Text;
      lFDPhysFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;

      lFDPhysFBConnectionDefParams.Pooled := ckbPooled.Checked;
      lFDPhysFBConnectionDefParams.PoolMaximumItems := StrToInt(edtPOOL_MaximumItems.Text);
      lFDPhysFBConnectionDefParams.PoolCleanupTimeout := StrToInt(edtPOOL_CleanupTimeout.Text);
      lFDPhysFBConnectionDefParams.PoolExpireTimeout := StrToInt(edtPOOL_ExpireTimeout.Text);
    end,

    procedure(FDConnection: TFDCustomConnection) //CONFIGURAÇÃO DO FDConnection
    begin
      FDConnection.FetchOptions.Mode := TFDFetchMode.fmAll;
      FDConnection.ResourceOptions.AutoConnect := False;

      with FDConnection.FormatOptions.MapRules.Add do
      begin
        SourceDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
        TargetDataType := dtDateTime; { TFDParam.DataType }
      end;
    end);

  lblTestConnection.Enabled := True;
end;

procedure TfrmMain.btnExecuteQueryClick(Sender: TObject);
var
  lExecuteSelect: TExecuteSelect;
begin
  btnConfigFDManager.Enabled := False;
  btnExecuteQuery.Enabled := False;
  Application.ProcessMessages;

  FTotalElapsedMillisecondsDML := TStopwatch.StartNew;

  lExecuteSelect := TExecuteSelect.Create(edtConnectionDefName.Text,
                                          edtInteracoes.Value,
                                          edtQuantidadeRegistros.Value,
                                          Log);

  lExecuteSelect.OnTerminate := OnTerminateExecute;
  lExecuteSelect.FreeOnTerminate := True;
  lExecuteSelect.Start;

  Log(tlINFO, Format('Usa Pool de conexões: %s -  Interações: %d - Quantidade de registros: %d', [
    BoolToStr(ckbPooled.Checked, True), edtInteracoes.Value, edtQuantidadeRegistros.Value]));

  StatusExecucao(True);
end;

procedure TfrmMain.lblTestConnectionLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
var
  lFDConnection: TFDConnection;
begin
  btnExecuteQuery.Enabled := False;

  lFDConnection := TFDConnection.Create(nil);
  try
    lFDConnection.ConnectionDefName := edtConnectionDefName.Text;
    lFDConnection.Connected := True;
    if lFDConnection.Connected then
      ShowMessage('Conectado...');
  finally
    lFDConnection.Free;
  end;

  btnExecuteQuery.Enabled := True;
end;

procedure TfrmMain.Log(const pTypeLog: TTypeLog; const pMessage: string);
begin
  if (pTypeLog = tlLINE) then
    mmoLog.Lines.Add(StringOfChar('=', 94))
  else
    mmoLog.Lines.Add(Format('%s: %s',[pTypeLog.AsString, pMessage]));
end;

procedure TfrmMain.OnTerminateExecute(Sender: TObject);
begin
  FTotalElapsedMillisecondsDML.Stop;
  btnConfigFDManager.Enabled := True;
  btnExecuteQuery.Enabled := True;
  StatusExecucao(False);

  Log(tlTEMPO, FormatDateTime('hh:nn:ss:zzz', FTotalElapsedMillisecondsDML.ElapsedMilliseconds/MSecsPerDay));
  Log(tlLINE, EmptyStr);
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  if odlDataBase.Execute then
    edtBancoDados.Text := odlDataBase.FileName;
end;

procedure TfrmMain.StatusExecucao(const pAtivar: Boolean);
begin
  pgbStatusExecute.Visible := pAtivar;
  pgbStatusExecute.Orientation := pbHorizontal;
  pgbStatusExecute.Style := pbstMarquee;
  pgbStatusExecute.MarqueeInterval := 20;
end;

{ TExecuteSelect }

constructor TExecuteSelect.Create(const pConnectionDefName: string;
  const pInteracoes: Integer;
  const pQuantidadeRegistros: Integer;
  const pExecuteSelectLog: TExecuteSelectLog);
begin
  FConnectionDefName := pConnectionDefName;
  FInteracoes := pInteracoes;
  FQuantidadeRegistros := pQuantidadeRegistros;
  FExecuteSelectLog := pExecuteSelectLog;
  inherited Create(True);
end;

procedure TExecuteSelect.Execute;
var
  lSQL: string;
begin
  lSQL := Format('SELECT FIRST %d * FROM MULTITHREADING', [FQuantidadeRegistros]);

  TParallel.&For(1, FInteracoes,
  procedure(AIndex: Integer)
  begin
    try
      QueryOpen(FConnectionDefName, lSQL);
    except
      on E: Exception do
      begin
        Log(tlERRO, E.Message);
      end;
    end;
  end);
end;

procedure TExecuteSelect.Log(const pTypeLog: TTypeLog; const pMessage: string);
begin
  //UPDATE UI IN MAIN THREAD
  TThread.Queue(TThread.Current,
  procedure
  begin
    if Assigned(FExecuteSelectLog) then
      FExecuteSelectLog(pTypeLog, pMessage);
  end);
end;

{ TTypeLogHelper }

function TTypeLogHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTypeLogHelper.AsString: string;
begin
  case Self of
    tlERRO: Result := 'ERRO';
    tlTEMPO: Result := 'TEMPO';
    tlINFO: Result := 'INFO';
  end;
end;

end.
