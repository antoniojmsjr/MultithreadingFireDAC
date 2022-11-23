# Multithreading (FireDAC)

Programa de exemplo usando multithreading com Firedac.

Foi utilizado o componente **FDManager** para gerenciar as conexões e o pool.

https://docwiki.embarcadero.com/RADStudio/Sydney/en/Multithreading_(FireDAC)


* Banco de Dados: Firebird (DB\MultithreadingFireDAC.FDB)
* Firebird: 2.5.7 [Donwload](http://sourceforge.net/projects/firebird/files/firebird-win32/2.5.7-Release/Firebird-2.5.7.27050_0_Win32.exe/download)

Para usar o **FDManager** com outros bancos de dados, verificar o link: [Database Connectivity (FireDAC) #Driver Linkage](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Database_Connectivity_(FireDAC))

| Database | TFDConnectionDefParams | Units |
|---|---|---|
| [Microsoft SQL Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Microsoft_SQL_Server_(FireDAC)) | TFDPhysMSSQLConnectionDefParams | FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL |
| [Oracle Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Oracle_Server_(FireDAC)) | TFDPhysOracleConnectionDefParams | FireDAC.Phys.OracleDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.Oracle |
| [PostgreSQL](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_PostgreSQL_(FireDAC)) | TFDPhysPGConnectionDefParams | FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.PG; |
| [MySQL Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_MySQL_Server_(FireDAC)) | TFDPhysMySQLConnectionDefParams | FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL |
| [IBM DB2 Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_IBM_DB2_Server_(FireDAC))) | TFDPhysDB2ConnectionDefParams | FireDAC.Phys.DB2Def, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.DB2 |
| [Firebird](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Firebird_(FireDAC)) | TFDPhysFBConnectionDefParams | FireDAC.Phys.FBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.FB |
| [InterBase](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_InterBase_(FireDAC)) | TFDPhysIBConnectionDefParams | FireDAC.Phys.IBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.IB |
| [SQLite](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_SQLite_database_(FireDAC)) | TFDPhysSQLiteConnectionDefParams | FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.SQLite |
| [MongoDB](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_MongoDB_Database_(FireDAC)) | TFDPhysMongoConnectionDefParams | FireDAC.Phys.MongoDBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MongoDB |
| [ODBC](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_ODBC_Data_Source_(FireDAC)) | TFDPhysODBCConnectionDefParams | FireDAC.Phys.ODBCDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC |

* FireDAC databases supported by RAD Studio: [FireDAC Database Support](https://docwiki.embarcadero.com/Status/en/FireDAC_Database_Support)

## Uso

### Configuração da Conexão

```delphi
uses
  FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Comp.Client, FireDAC.Comp.DataSet,

  //FIREBIRD
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.IBWrapper;
```

```delphi
const
  CONNECTION_DB_NAME = 'CONNECTION_APP_DATABASE';
  DRIVER_NAME = 'FB_2.5';

var
  lConnection: TFDCustomConnection;
  lFBConnectionDefParams: TFDPhysFBConnectionDefParams; // FIREBIRD CONNECTION PARAMS
  lFDStanConnectionDef: IFDStanConnectionDef;
  lFDStanDefinition: IFDStanDefinition;
begin
  //PARA CRIAR OU ALTERAR É NECESSÁRIO FECHAR A O FDMANGER REFERENTE A ConnectionDefName
  FDManager.CloseConnectionDef(CONNECTION_DB_NAME);

  FDManager.ActiveStoredUsage := [auRunTime];
  FDManager.ConnectionDefFileAutoLoad := False;
  FDManager.DriverDefFileAutoLoad := False;
  FDManager.SilentMode := True; //DESATIVA O CICLO DE MENSAGEM COM O WINDOWS PARA APRESENTAR A AMPULHETA DE PROCESSANDO.

  //DRIVER
  lFDStanDefinition := FDManager.DriverDefs.FindDefinition(DRIVER_NAME);
  if not Assigned(FDManager.DriverDefs.FindDefinition(DRIVER_NAME)) then
  begin
    lFDStanDefinition := FDManager.DriverDefs.Add;
    lFDStanDefinition.Name := DRIVER_NAME;
  end;
  lFDStanDefinition.AsString['BaseDriverID'] := 'FB'; //DRIVER BASE
  lFDStanDefinition.AsString['VendorLib'] := 'fbclient.dll'; //DEFINE O CAMINHO DA DLL CLIENT DO FIREBIRD. [OPCIONAL]

  //CONNECTION
  lFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(CONNECTION_DB_NAME);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(CONNECTION_DB_NAME)) then
  begin
    lFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    lFDStanConnectionDef.Name := CONNECTION_DB_NAME;
  end;

  //DEFINIÇÃO DE CONEXÃO: PRIVADO :: https://docwiki.embarcadero.com/RADStudio/Sydney/en/Defining_Connection_(FireDAC)
  lFBConnectionDefParams := TFDPhysFBConnectionDefParams(lFDStanConnectionDef.Params);
  lFBConnectionDefParams.DriverID := DRIVER_NAME;
  lFBConnectionDefParams.Database := 'C:\App\Database\AppDB.fdb';
  lFBConnectionDefParams.UserName := 'SYSDBA';
  lFBConnectionDefParams.Password := 'masterkey';
  lFBConnectionDefParams.Server := '127.0.0.1';
  lFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;

  lFBConnectionDefParams.Pooled := True;
  lFBConnectionDefParams.PoolMaximumItems := 100; //100 CONEXÕES EM POOL
  lFBConnectionDefParams.PoolCleanupTimeout := 30000; //O tempo (ms) até o FireDAC **remover** as conexões que não foram usadas até o tempo POOL_ExpireTimeout. O valor padrão é 30000 ms (30 segundos).
  lFBConnectionDefParams.PoolExpireTimeout := 90000; //O tempo (ms), após o qual a **conexão inativa** pode ser excluída do pool e destruída. O valor padrão é 90000 ms (90 segundos).

  //CONFIGURAÇÃO DO FDCONNECTION
  lConnection := TFDCustomConnection.Create(nil);
  try
    lConnection.FetchOptions.Mode := TFDFetchMode.fmAll; //fmAll
    lConnection.ResourceOptions.AutoConnect := False;
//    lConnection.ResourceOptions.AutoReconnect := True;  //PERDA DE PERFORMANCE COM THREAD

    with lConnection.FormatOptions.MapRules.Add do
    begin
      SourceDataType := dtDateTime; { TFDParam.DataType }
      TargetDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
    end;

    lFDStanConnectionDef.WriteOptions(lConnection.FormatOptions,
                                      lConnection.UpdateOptions,
                                      lConnection.FetchOptions,
                                      lConnection.ResourceOptions);
  finally
    lConnection.Free;
  end;

  if (FDManager.State <> TFDPhysManagerState.dmsActive) then
    FDManager.Open;
```

### Usando a configuração criada

```delphi
uses
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI;
```

```delphi
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

QueryOpen(CONNECTION_DB_NAME, 'SELECT * FROM TABLE');
```

## Exemplo de consulta utilizando pool de conexão:

https://user-images.githubusercontent.com/20980984/155869390-dc2e16c3-c4d0-4cfa-bede-c9442a562dab.mp4

## Exemplo de consulta sem utilizar pool de conexão:

https://user-images.githubusercontent.com/20980984/155869410-176aeacd-2c37-41e9-abd5-55b1d42d0eda.mp4
