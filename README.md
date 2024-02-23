# Multithreading (FireDAC)

Em uma aplicação multithread, uma boa prática é isolar os componentes de acesso ao banco de dados, a violação dessa prática pode gerar erros do tipo access violation entre outros erros por causo do compartilhamento desses componentes. Para ajudar a resolver esse problema, a [Embarcadero](https://www.embarcadero.com/br/) disponibilizou um componente, o **[FDManager](http://docwiki.embarcadero.com/Libraries/Rio/en/FireDAC.Comp.Client.TFDManager)**, que é responsável pelas definições de conexão e gerenciamento de conexões e é thread-safe(utilização segura em ambientes multithread).

**Fonte:** https://docwiki.embarcadero.com/RADStudio/Sydney/en/Multithreading_(FireDAC)

**Vantagens do uso do FDManager**

* Definição da biblioteca cliente de acesso ao banco de dados. [OPCIONAL]
  * Por exemplo:
      * Definição do local da biblioteca cliente(fbclient.dll) do Firebird 2.5;
      * Definição do local da biblioteca cliente do Firebird(fbclient.dll) 64Bits;

* Centralização das configurações de conexão com o banco de dados.
    * Por exemplo:
      * Definição das configurações de acesso ao banco de produção.
      * Definição das configurações de acesso ao banco de log.

* Centralização das parametrizações do componente TFDConnection. (Esta configuração se estende para todos os FDConnection usado na aplicação)
  * Por exemplo:
    * FetchOptions.Mode := TFDFetchMode.fmAll;
    * ResourceOptions.AutoConnect := False;


Além do uso do **FDManger** uma boa prática e o uso da técnica de otimização de conexão com o banco de dados, chamado de **pool de conexões**.

### O que é pool de conexões com Banco de Dados?

Quando precisamos realizar qualquer operação sobre um banco de dados é primeiramente necessário estabelecer uma conexão com ele, o estabelecimento dessa conexão costuma ocorrer através do protocolo **TCP/IP**, envolvendo custo para ser aberto e finalizado. Esses custos são particularmente significativos em **aplicações Web** onde você pode ter um fluxo de milhares de requisições constantes, e cada uma delas vai gerar a abertura e fechamento de uma nova conexão com o banco de dados. Uma técnica simples para evitar esse constante "abre-fecha" de conexões é manter um determinado número de conexões sempre aberta (um "pool" de conexões) e simplesmente reutilizar quando necessário, dessa forma você diminui tanto o gasto de recursos da máquina quanto o tempo de resposta da sua aplicação.


Este custo para estabelecer uma conexão com o banco de dados pode ser visto na imagem abaixo, utilizando a ferramenta *WireShark* podemos ver a quantidade de pacotes que é utlizado para executar um simples select.

![LogWireShark](https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/bd44b13e-11fe-46c5-8e83-2692942bc7ca)

### Configuração do pool de conexões

Para configurar um pool de conexões utilizaremos o FDManager, e as propriedades de pool.

| Parâmetro | Descrição | Exemplo |
|---|---|---|
|Pooled|Ativa o pool de conexões para uma definição de conexão. </br></br> Para usar um pool de conexões, a definição de conexão deve ser [persistente](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Defining_Connection_(FireDAC)#Creating_a_Persistent_Connection_Definition) ou [privada](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Defining_Connection_(FireDAC)#Creating_a_Private_Connection_Definition).|True|
|POOL_CleanupTimeout|O tempo em milissegundos até o FireDAC **remover** as conexões que não foram usadas até o tempo POOL_ExpireTimeout.</br></br>O valor padrão é 30000 ms (30 segundos).|15000 ms</br>15 s |
|POOL_ExpireTimeout|O tempo em milissegundos, após o qual a **conexão inativa** pode ser excluída do pool e destruída.</br></br>O valor padrão é 90000 ms (90 segundos).|60000 ms</br>60 s |
|POOL_MaximumItems|O número máximo de conexões no Pool.</br></br>Quando o aplicativo requer mais conexões, uma exceção é gerada. O valor padrão é 50.</br></br>**Quando se atinge o número total de conexões especificada nessa  propriedade, é gerado uma exceção:**</br></br>![image](https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/ad15ed9f-f02a-4a60-b3a1-c37df8b62316)|100|



Para usar o **FDManager** com outros bancos de dados, verificar o link: [Database Connectivity (FireDAC) #Driver Linkage](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Database_Connectivity_(FireDAC))

| Database | DriverID | TFDConnectionDefParams | Units |
|---|---|---|---|
| [Microsoft SQL Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Microsoft_SQL_Server_(FireDAC)) | MSSQL | TFDPhysMSSQLConnectionDefParams | FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL |
| [Oracle Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Oracle_Server_(FireDAC)) | Ora | TFDPhysOracleConnectionDefParams | FireDAC.Phys.OracleDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.Oracle |
| [PostgreSQL](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_PostgreSQL_(FireDAC)) | PG |TFDPhysPGConnectionDefParams | FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.PG; |
| [MySQL Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_MySQL_Server_(FireDAC)) | MySQL | TFDPhysMySQLConnectionDefParams | FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL |
| [IBM DB2 Server](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_IBM_DB2_Server_(FireDAC))) | DB2 | TFDPhysDB2ConnectionDefParams | FireDAC.Phys.DB2Def, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.DB2 |
| [Firebird](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_Firebird_(FireDAC)) | FB | TFDPhysFBConnectionDefParams | FireDAC.Phys.FBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.FB |
| [InterBase](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_InterBase_(FireDAC)) | IB | TFDPhysIBConnectionDefParams | FireDAC.Phys.IBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.IB |
| [SQLite](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_SQLite_database_(FireDAC)) | SQLite | TFDPhysSQLiteConnectionDefParams | FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.SQLite |
| [MongoDB](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_MongoDB_Database_(FireDAC)) | Mongo | TFDPhysMongoConnectionDefParams | FireDAC.Phys.MongoDBDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MongoDB |
| [ODBC](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Connect_to_ODBC_Data_Source_(FireDAC)) | ODBC | TFDPhysODBCConnectionDefParams | FireDAC.Phys.ODBCDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC |

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
