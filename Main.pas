unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Firedac.DApt,
  FMX.Objects, FMX.Layouts, FMX.ListBox, FMX.StdCtrls, FireDAC.Stan.Pool,
  FMX.Edit, FMX.Filter.Effects, FMX.Effects, FMX.Controls.Presentation,
  FireDAC.Comp.Client, Firedac.Stan.Async;


const
  cURLGitHub = 'https://github.com/antoniojmsjr/MultithreadingFireDAC';

type
  TfrmMain = class(TForm)
    lytMain: TLayout;
    tbMain: TToolBar;
    rtgToolbar: TRectangle;
    seToolBar: TShadowEffect;
    sbInfo: TSpeedButton;
    FillRGBEffect3: TFillRGBEffect;
    lblMenuTitulo: TLabel;
    imgDB: TImage;
    lytFBSettingsCell: TLayout;
    gbFBSettings: TGroupBox;
    lytFBSettings: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    edtFBConnectionDefName: TEdit;
    edtFBDataBase: TEdit;
    Label3: TLabel;
    edtFBUser: TEdit;
    Label4: TLabel;
    edtFBPassword: TEdit;
    Label5: TLabel;
    edtFBServer: TEdit;
    Label10: TLabel;
    edtFBDriverDefName: TEdit;
    SpeedButton1: TSpeedButton;
    gbFBSettingsPool: TGroupBox;
    lytFBSettingsPool: TLayout;
    ckbFBPooled: TCheckBox;
    Label6: TLabel;
    edtFBPOOL_MaximumItems: TEdit;
    Label7: TLabel;
    edtFBPOOL_CleanupTimeout: TEdit;
    Label8: TLabel;
    edtFBPOOL_ExpireTimeout: TEdit;
    btnFBSettings: TButton;
    btnFBTestConnection: TButton;
    Line1: TLine;
    lytFBTestCell: TLayout;
    gbFBTestHeader: TGroupBox;
    lytFBTestHeader: TLayout;
    Label9: TLabel;
    edtFBTestInteraction: TEdit;
    btnFBTestSelect: TButton;
    gbFBTestResult: TGroupBox;
    lytFBTestResult: TLayout;
    lbFBTestResult: TListBox;
    txtFBStatusExecute: TText;
    odlDataBase: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnFBSettingsClick(Sender: TObject);
    procedure btnFBTestConnectionClick(Sender: TObject);
    procedure btnFBTestSelectClick(Sender: TObject);
    procedure sbInfoClick(Sender: TObject);
  private
    { Private declarations }
    function CreateItemListBox(pListBox: TListBox; const pText: string): TListBoxItem;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Generics.Collections, System.Threading, System.SyncObjs,
  System.Diagnostics, Winapi.ShellAPI, Winapi.Windows, FDManagerConfig,
  Global.Common.Strings;

{$R *.fmx}

threadvar
  gFBTotalElapsedMillisecondsDML: Int64;

procedure TfrmMain.FormCreate(Sender: TObject);
var
{$IFDEF MSWINDOWS}
  lRect: TRectF;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  lRect := TRectF.Create(Screen.WorkAreaRect.TopLeft, Screen.WorkAreaRect.Width,
                         Screen.WorkAreaRect.Height);
  SetBounds(Round(lRect.Left + (lRect.Width - Width) / 2),
            0,
            Width,
            Screen.WorkAreaRect.Height);
  {$ENDIF}

  //GERENCIADOR DE CONEXÃO
  FDManager.Close;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  for var I := 0 to Pred(lbFBTestResult.Items.Count) do
    if Assigned( lbFBTestResult.Items.Objects[I] ) then
      lbFBTestResult.Items.Objects[I].Free;
  lbFBTestResult.Clear;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if (Self.Width < 590) then
  begin
    Self.Width := 590;
    Abort;
  end;
  {$ENDIF}
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  if odlDataBase.Execute then
    edtFBDataBase.Text := odlDataBase.FileName;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDManager.Close;
end;

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

procedure TfrmMain.btnFBSettingsClick(Sender: TObject);
var
  lConnectionDefDriverParams: TConnectionDefDriverParams;
  lConnectionDefParams: TConnectionDefParams;
  lConnectionDefPoolParams: TConnectionDefPoolParams;
begin

  btnFBTestConnection.Enabled := False;
  btnFBTestSelect.Enabled := False;

  lConnectionDefDriverParams.DriverDefName := edtFBDriverDefName.Text;
//  UTILIZADO PARA DEFINIR O CAMINHO DA DLL DO CLIENT, USANDO MUITO QUANDO QUE DEFINIR 64 Bits
//  lConnectionDefDriverParams.VendorLib :=

  lConnectionDefParams.ConnectionDefName := edtFBConnectionDefName.Text;
  lConnectionDefParams.Server := edtFBServer.Text;
  lConnectionDefParams.Database := edtFBDataBase.Text;
  lConnectionDefParams.UserName := edtFBUser.Text;
  lConnectionDefParams.Password := edtFBPassword.Text;
  lConnectionDefParams.LocalConnection := True;

  lConnectionDefPoolParams.Pooled := ckbFBPooled.IsChecked;
  lConnectionDefPoolParams.PoolMaximumItems := edtFBPOOL_MaximumItems.Text.ToInteger();
  lConnectionDefPoolParams.PoolCleanupTimeout := edtFBPOOL_CleanupTimeout.Text.ToInteger();
  lConnectionDefPoolParams.PoolExpireTimeout := edtFBPOOL_ExpireTimeout.Text.ToInteger();

  ConfigFDManagerConnectionFirebird(lConnectionDefDriverParams,
                                    lConnectionDefParams,
                                    lConnectionDefPoolParams);

//  CreateConnectionDefFromConnectionString(edtFBConnectionDefName.Text, 'E:\IntelliComm\IntelliShop\DataBase\DATASHOP.FDB;User_Name=sysdba;Password=masterkey;CharacterSet=WIN1252;DriverID=FB;Login Prompt=False;');

  btnFBTestConnection.Enabled := True;
  btnFBTestSelect.Enabled := True;
  btnFBTestSelect.Enabled := False;
end;

procedure TfrmMain.btnFBTestConnectionClick(Sender: TObject);
var
  lFDConnection: TFDConnection;
begin
  btnFBTestSelect.Enabled := False;

  lFDConnection := TFDConnection.Create(nil);
  try
    lFDConnection.ConnectionDefName := edtFBConnectionDefName.Text;
    lFDConnection.Connected := True;
    if lFDConnection.Connected then
      ShowMessage('Conectado...');
  finally
    lFDConnection.Free;
  end;

  btnFBTestSelect.Enabled := True;
end;

procedure TfrmMain.btnFBTestSelectClick(Sender: TObject);
const
  cScriptSQLSelect = 'SELECT * FROM MULTITHREADING';
var
  lInteraction: Integer;
  lMessageDB: string;
  lTask: ITask;
begin
  lMessageDB := EmptyStr;
  gFBTotalElapsedMillisecondsDML := 0;

  lbFBTestResult.BeginUpdate;
  try
    for var J := 0 to Pred(lbFBTestResult.Items.Count) do
      if Assigned( lbFBTestResult.Items.Objects[J] ) then
        lbFBTestResult.Items.Objects[J].Free;
    lbFBTestResult.Clear;
  finally
    lbFBTestResult.EndUpdate;
  end;

  Application.ProcessMessages;

  lInteraction := edtFBTestInteraction.Text.ToInteger();

  txtFBStatusExecute.Text := EmptyStr;

  lTask := TTask.Create(
  procedure
  var
    lSWElapsedMilliseconds: TStopwatch;
  begin
    lSWElapsedMilliseconds := TStopwatch.StartNew;
    TThread.Queue(TThread.Current,
    procedure
    begin
      btnFBTestSelect.Enabled := False;
    end);

    TParallel.&For(1, lInteraction,
    procedure(AIndex: Integer)
    var
      lListBoxItem: TListBoxItem;
      lText: string;
      lSW: TStopwatch;
    begin

      //UPDATE UI IN MAIN THREAD
      TThread.Queue(TThread.Current,
      procedure
      begin
//        Inc(gFBInc);
        lText := Format('%.2d - CONSULTANDO: %s', [AIndex, FormatDateTime('dd/mm/yyyy hh:mm:ss.zzz', Now)]);

        lbFBTestResult.BeginUpdate;
        try
          lListBoxItem := CreateItemListBox(lbFBTestResult, lText);
        finally
          lbFBTestResult.EndUpdate;
        end;
      end);

      try
        lSW := TStopwatch.StartNew;

        //OPEN
        QueryOpen(edtFBConnectionDefName.Text, cScriptSQLSelect);

        lSW.Stop;
      except
        on E: Exception do
        begin
          lSW.Stop;
          lMessageDB := E.Message;
        end;
      end;

      //UPDATE UI IN MAIN THREAD
      TThread.Queue(TThread.Current,
      procedure
      begin

        gFBTotalElapsedMillisecondsDML := (gFBTotalElapsedMillisecondsDML + lsw.ElapsedMilliseconds);

        lbFBTestResult.BeginUpdate;
        try
          lListBoxItem.Text := Format('%s - %s', [lText, FormatDateTime('hh:nn:ss:zzz', lsw.ElapsedMilliseconds/MSecsPerDay)]);

          if lMessageDB.IsEmpty then
            lListBoxItem.ItemData.Detail := 'OK...'
          else
            lListBoxItem.ItemData.Detail := lMessageDB;

          txtFBStatusExecute.Text := Format('DML: %s', [FormatDateTime('hh:nn:ss:zzz', gFBTotalElapsedMillisecondsDML/MSecsPerDay)]);
        finally
          lbFBTestResult.EndUpdate;
        end;
      end);

    end);

    lSWElapsedMilliseconds.Stop;
    TThread.Queue(TThread.Current,
      procedure
      begin
        btnFBTestSelect.Enabled := True;
        txtFBStatusExecute.Text := Format('%s - %s', [txtFBStatusExecute.Text, FormatDateTime('hh:nn:ss:zzz', lSWElapsedMilliseconds.ElapsedMilliseconds/MSecsPerDay)]);
      end);
  end);
  lTask.Start;
end;

function TfrmMain.CreateItemListBox(pListBox: TListBox;
  const pText: string): TListBoxItem;
begin
  pListBox.BeginUpdate;
  try
    Sleep(1);
    Result := TListBoxItem.Create(pListBox);
    Result.Name := TStringsUtils.GUIDToName('lbiItem_');
    Result.ItemData.Text := pText;
    Result.ItemData.Detail := 'Status...';
    Result.Parent := pListBox;
  finally
    pListBox.EndUpdate;
  end;
end;

procedure OpenURLWindows(const pURL: string);
begin
  ShellExecute(0, 'OPEN', PChar(pURL), '', '', SW_SHOWNORMAL);
end;

procedure TfrmMain.sbInfoClick(Sender: TObject);
begin
  OpenURLWindows(cURLGitHub);
end;

end.
