unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TdmDataModule = class(TDataModule)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDQueryUUID: TStringField;
    FDQueryDATETIME: TDateTimeField;
    procedure FDConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmDataModule.FDConnectionBeforeConnect(Sender: TObject);
begin
  FDConnection.Close;
  FDConnection.Params.Clear;
  FDConnection.ConnectionDefName := 'CONNECTION_DB_APP';
end;

end.
