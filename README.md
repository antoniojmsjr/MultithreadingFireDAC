# Multithreading (FireDAC)

Em uma aplicação multithread, uma boa prática é isolar os componentes de acesso ao banco de dados, a violação dessa prática pode gerar erros do tipo access violation entre outros erros. Para ajudar a resolver esse problema, a [Embarcadero](https://www.embarcadero.com/br/) disponibilizou um componente, **[FDManager](http://docwiki.embarcadero.com/Libraries/Rio/en/FireDAC.Comp.Client.TFDManager)**, que é responsável pelas *definições de conexão* e *gerenciamento de conexões* e é **thread-safe**(utilização segura em ambientes multithread).

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

Quando precisamos realizar qualquer operação sobre um banco de dados é primeiramente necessário estabelecer uma conexão com ele, o estabelecimento dessa conexão costuma ocorrer através do protocolo **TCP/IP**, envolvendo custo para ser **aberto** e **fechado**. Esse custo é particularmente significativo em *aplicações Web* onde você pode ter um fluxo de milhares de requisições constante, e cada uma delas vai gerar a abertura e fechamento de uma nova conexão com o banco de dados. Uma técnica simples para evitar esse constante "abre-fecha" de conexões é manter um determinado número de conexões sempre aberta (um **pool** de conexões) e simplesmente reutilizar quando necessário, dessa forma você diminui tanto o gasto de recurso da máquina quanto o tempo de resposta da sua aplicação.


Esse custo para estabelecer uma conexão com o banco de dados pode ser visto na imagem abaixo, utilizando a ferramenta *WireShark* podemos ver a quantidade de pacotes que é utlizado para executar um simples select.

![LogWireShark](https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/bd44b13e-11fe-46c5-8e83-2692942bc7ca)

Podemos ver na imagem abaixo o comportamento das consultas ao banco de dados usando pool de conexões:

* Do lado esquerdo o famoso "abre-fecha", um exemplo de consulta sem a utilização do pool de conexões.
* Do lado direito, um exemplo de consulta utilizando pool de conexões.
![image](https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/bfd548e1-87e9-4a55-b83e-e9a0f948c24d)


### Configuração do pool de conexões

Para configurar um pool de conexões utilizaremos o **FDManager**, e as propriedades de pool.

| Parâmetro | Descrição | Exemplo |
|---|---|---|
|Pooled|Ativa o pool de conexões para uma definição de conexão. </br></br> Para usar um pool de conexões, a definição de conexão deve ser [persistente](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Defining_Connection_(FireDAC)#Creating_a_Persistent_Connection_Definition) ou [privada](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Defining_Connection_(FireDAC)#Creating_a_Private_Connection_Definition).|True|
|POOL_CleanupTimeout|O tempo em milissegundos até o FireDAC **remover** as conexões que não foram usadas até o tempo POOL_ExpireTimeout.</br></br>O valor padrão é 30000 ms (30 segundos).|15000 ms</br>15 s |
|POOL_ExpireTimeout|O tempo em milissegundos, após o qual a **conexão inativa** pode ser excluída do pool e destruída.</br></br>O valor padrão é 90000 ms (90 segundos).|60000 ms</br>60 s |
|POOL_MaximumItems|O número máximo de conexões no Pool.</br></br>Quando o aplicativo requer mais conexões, uma exceção é gerada. O valor padrão é 50.</br></br>**Quando se atinge o número total de conexões especificada nessa  propriedade, é gerado uma exceção:**</br></br>![image](https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/ad15ed9f-f02a-4a60-b3a1-c37df8b62316)|100|

Em geral, o **FDManager** mantém um pool de conexões "física" aberta, quando: 
* Quando TFDConnection.Connected é definido como **True**, o FireDAC pega uma conexão "física" do pool e a usa.
* Quando TFDConnection.Connected é definido como **False**, a conexão "física" não é fechada, mas colocada de volta no pool.

### Configuração de acesso ao banco de dados

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

## Exemplos

Em anexo no projeto existem dois exemplos de uso de conexão com o banco de dados em ambientes multithread.

1º Exemplo usando conexões em ambiente multithreading para *desktop*.</br>
2º Exemplo usando conexões em ambiente multithreading para servidor web com [Horse](https://github.com/HashLoad/horse).
 * Teste de stress com [JMeter](https://jmeter.apache.org/)

Ambos os exemplo usam o banco de dados Firebird
* [Firebird 2.5](https://firebirdsql.org/en/firebird-2-5/)
* Banco MultithreadingFireDAC.FDB
  * Tabela MULTITHREADING com 100.000 mil registros. 

### Exemplo de consulta com pool de conexões ATIVADO:
* Tempo de execução: 00:00:16.193</br>

https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/94dea460-6932-4c9b-89a9-0db6ff67b4c7

### Exemplo de consulta com pool de conexões DESATIVADO:
* Tempo de execução: 00:01:00.929</br>

https://github.com/antoniojmsjr/MultithreadingFireDAC/assets/20980984/75e72a62-5c7d-44c1-86e9-ed0e47cbcac8
