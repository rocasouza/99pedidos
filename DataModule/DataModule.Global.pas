unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  DataSet.Serialize.Config, System.IOUtils;

type
  TDmGlobal = class(TDataModule)
    Conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition      := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
  conn.Connected := True;
end;

procedure TDmGlobal.ConnBeforeConnect(Sender: TObject);
begin
  Conn.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
    Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\pedidos.db';
  {$ELSE}
    Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'pedidos.db');
  {$ENDIF}
end;

procedure TDmGlobal.ConnAfterConnect(Sender: TObject);
begin
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_USUARIO ( ' +
                            'COD_USUARIO    INTEGER NOT NULL PRIMARY KEY, ' +
                            'NOME           VARCHAR (100), ' +
                            'EMAIL          VARCHAR (100), ' +
                            'SENHA          VARCHAR (50), ' +
                            'TOKEN_PUSH     VARCHAR (200), ' +
                            'TOKEN_JWT      VARCHAR (1000), ' +
                            'IND_LOGIN      CHAR (1), ' +
                            'IND_ONBOARDING CHAR (1));'
                );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_CLIENTE (' +
                          'COD_CLIENTE_LOCAL   INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'CNPJ_CPF            VARCHAR (20), ' +
                          'NOME                VARCHAR (100), ' +
                          'FONE                VARCHAR (20), ' +
                          'EMAIL               VARCHAR (100), ' +
                          'ENDERECO            VARCHAR (500), ' +
                          'NUMERO              VARCHAR (50), ' +
                          'COMPLEMENTO         VARCHAR (50), ' +
                          'BAIRRO              VARCHAR (50), ' +
                          'CIDADE              VARCHAR (50), ' +
                          'UF                  VARCHAR (2), ' +
                          'CEP                 VARCHAR (10), ' +
                          'IND_SINCRONIZAR     CHAR (1), ' +
                          'LATITUDE            DECIMAL (5, 6), ' +
                          'LONGITUDE           DECIMAL (5, 6), ' +
                          'LIMITE_DISPONIVEL   DECIMAL (12, 2), ' +
                          'COD_CLIENTE_OFICIAL INTEGER);'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_PRODUTO ( ' +
                          'COD_PRODUTO_LOCAL   INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'DESCRICAO           VARCHAR (200), ' +
                          'VALOR               DECIMAL (12, 2), ' +
                          'FOTO                BLOB, ' +
                          'IND_SINCRONIZAR     CHAR (1), ' +
                          'QTD_ESTOQUE         DECIMAL (12, 2), ' +
                          'COD_PRODUTO_OFICIAL INTEGER);'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_COND_PAGTO ( ' +
                          'COD_COND_PAGTO INTEGER NOT NULL PRIMARY KEY, ' +
                          'COND_PAGTO     VARCHAR (100));'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_CONFIG ( ' +
                          'CAMPO VARCHAR (50)  PRIMARY KEY NOT NULL, ' +
                          'VALOR VARCHAR (200));'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_NOTIFICACAO ( ' +
                          'COD_NOTIFICACAO INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'DATA_NOTIFICACAO DATETIME, ' +
                          'TITULO          VARCHAR (100), ' +
                          'TEXTO           VARCHAR (500), ' +
                          'IND_LIDO        CHAR (1));'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_PEDIDO ( ' +
                          'COD_PEDIDO_LOCAL   INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'COD_CLIENTE_LOCAL  INTEGER, ' +
                          'COD_USUARIO        INTEGER, ' +
                          'TIPO_PEDIDO        CHAR (1), ' +
                          'DATA_PEDIDO        DATETIME, ' +
                          'CONTATO            VARCHAR (100), ' +
                          'OBS                VARCHAR (500), ' +
                          'COD_PEDIDO_OFICIAL INTEGER, ' +
                          'IND_SINCRONIZAR    CHAR (1), ' +
                          'VALOR_TOTAL        DECIMAL (12, 2), ' +
                          'COD_COND_PAGTO     INTEGER, ' +
                          'PRAZO_ENTREGA      VARCHAR (50), ' +
                          'DATA_ENTREGA       DATETIME, ' +

                          'FOREIGN KEY (COD_USUARIO) REFERENCES TAB_USUARIO(COD_USUARIO), ' +
                          'FOREIGN KEY (COD_CLIENTE_LOCAL) REFERENCES TAB_CLIENTE(COD_CLIENTE_LOCAL), ' +
                          'FOREIGN KEY (COD_COND_PAGTO) REFERENCES TAB_COND_PAGTO(COD_COND_PAGTO));'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_PEDIDO_ITEM ( ' +
                          'COD_ITEM         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'COD_PEDIDO_LOCAL INTEGER NOT NULL, ' +
                          'COD_PRODUTO_LOCAL INTEGER, ' +
                          'QTD              INTEGER, ' +
                          'VALOR_UNITARIO   DECIMAL (12, 2), ' +
                          'VALOR_TOTAL      DECIMAL (12, 2), ' +

                          'FOREIGN KEY (COD_PEDIDO_LOCAL) REFERENCES TAB_PEDIDO(COD_PEDIDO_LOCAL), ' +
                          'FOREIGN KEY (COD_PRODUTO_LOCAL) REFERENCES TAB_PRODUTO(COD_PRODUTO_LOCAL));'
              );

  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_PEDIDO_ITEM_TEMP ( ' +
                          'COD_ITEM         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
                          'COD_PEDIDO_LOCAL INTEGER NOT NULL, ' +
                          'COD_PRODUTO_LOCAL INTEGER, ' +
                          'QTD              INTEGER, ' +
                          'VALOR_UNITARIO   DECIMAL (12, 2), ' +
                          'VALOR_TOTAL      DECIMAL (12, 2));'
              );
end;

end.
