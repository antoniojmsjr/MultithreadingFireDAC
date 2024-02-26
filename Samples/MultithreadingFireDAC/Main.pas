unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Samples.Spin, System.Diagnostics, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.Menus;

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
    odlDataBase: TOpenDialog;
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
    ppMain: TPopupMenu;
    ppiLimparLog: TMenuItem;
    pnlHeader: TPanel;
    gbxConfiguracaoConnectionDB: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    edtConnectionDefName: TEdit;
    edtConnectionDatabase: TEdit;
    edtConnectionServer: TEdit;
    gbxConfiguracaoDriverDB: TGroupBox;
    Label11: TLabel;
    edtDriverDefName: TEdit;
    Label12: TLabel;
    edtDriverVendorHome: TEdit;
    Label13: TLabel;
    edtDriverVendorLib: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnExecuteQueryClick(Sender: TObject);
    procedure btnConfigFDManagerClick(Sender: TObject);
    procedure lblTestConnectionLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure ppiLimparLogClick(Sender: TObject);
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
    edtConnectionDefName.Text, //NOME DA CONFIG DE CONEXÃO COM O BANCO DE DADOS - IDENTIFICAÇÃO DA CONEXÃO, USADO NO FDConnection.ConnectionDefName PARA RECUPERAR UMA CONEXÃO

    procedure(FDConnectionDefParams: TFDConnectionDefParams) //PARAMETRIZAÇÃO DA CONEXÃO COM O BANCO DE DADOS
    var
      lFDPhysFBConnectionDefParams: TFDPhysFBConnectionDefParams;
    begin
      // CLASSE RESPONSÁVEL PELAS CONFIG DE ACESSO AO BANCO DE DADOS FIREBIRD: TFDPhysFBConnectionDefParams  - https://github.com/antoniojmsjr/MultithreadingFireDAC?tab=readme-ov-file#configura%C3%A7%C3%A3o-de-acesso-ao-banco-de-dados
      lFDPhysFBConnectionDefParams := TFDPhysFBConnectionDefParams(FDConnectionDefParams);

      // IDENTIFICAÇÃO DO DRIVER PERSONALIZADO NA PROPRIEDADE FDStanDefinition - [OPCIONAL]
      lFDPhysFBConnectionDefParams.DriverID := edtDriverDefName.Text; //[OPCIONAL] OU lFDPhysFBConnectionDefParams.DriverID := 'FB'

      lFDPhysFBConnectionDefParams.Database := edtConnectionDatabase.Text;
      lFDPhysFBConnectionDefParams.UserName := 'SYSDBA';
      lFDPhysFBConnectionDefParams.Password := 'masterkey';
      lFDPhysFBConnectionDefParams.Server := edtConnectionServer.Text;
      lFDPhysFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;
      lFDPhysFBConnectionDefParams.CharacterSet := TIBCharacterSet.csWIN1252;

      lFDPhysFBConnectionDefParams.Pooled := ckbPooled.Checked;
      lFDPhysFBConnectionDefParams.PoolMaximumItems := StrToInt(edtPOOL_MaximumItems.Text);
      lFDPhysFBConnectionDefParams.PoolCleanupTimeout := StrToInt(edtPOOL_CleanupTimeout.Text);
      lFDPhysFBConnectionDefParams.PoolExpireTimeout := StrToInt(edtPOOL_ExpireTimeout.Text);
    end,
    edtDriverDefName.Text, //NOME DA CONFI DO DRIVER - [OPCIONAL] - IDENTIFICAÇÃO DO DRIVER, USADO NA CONFIGURAÇÃO DA CONEXÃO FDPhysFBConnectionDefParams.DriverID
    procedure(FDStanDefinition: IFDStanDefinition) //PARAMETRIZAÇÃO DO DRIVER COM O BANCO DE DADOS - [OPCIONAL]
    begin
      FDStanDefinition.AsString['BaseDriverID'] := 'FB'; //DRIVER BASE DO FIREDAC

      //DEFINE O LOCAL DA DLL CLIENT DO FIREBIRD.
      FDStanDefinition.AsString['VendorHome'] := edtDriverVendorHome.Text; //https://docwiki.embarcadero.com/Libraries/Sydney/en/FireDAC.Phys.TFDPhysDriverLink.VendorHome

      //DEFINE O NOME DA DLL CLIENT DO FIREBIRD.
      FDStanDefinition.AsString['VendorLib'] := edtDriverVendorLib.Text; //https://docwiki.embarcadero.com/Libraries/Sydney/en/FireDAC.Phys.TFDPhysDriverLink.VendorLib
    end,
    procedure(FDConnection: TFDCustomConnection) //CONFIGURAÇÃO DO FDConnection
    begin
      FDConnection.FetchOptions.Mode := TFDFetchMode.fmAll;
      FDConnection.ResourceOptions.AutoConnect := False;

      FDConnection.FormatOptions.MapRules.Clear;
      with FDConnection.FormatOptions.MapRules.Add do
      begin
        SourceDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
        TargetDataType := dtDateTime; { TFDParam.DataType }
      end;
      FDConnection.FormatOptions.OwnMapRules := True;
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

  Log(tlTEMPO, FormatDateTime('hh:nn:ss.zzz', FTotalElapsedMillisecondsDML.ElapsedMilliseconds/MSecsPerDay));
  Log(tlLINE, EmptyStr);
end;

procedure TfrmMain.ppiLimparLogClick(Sender: TObject);
begin
  mmoLog.Clear;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  if odlDataBase.Execute then
    edtConnectionDatabase.Text := odlDataBase.FileName;
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
