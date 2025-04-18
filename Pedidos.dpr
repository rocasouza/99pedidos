program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'pages\UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'pages\UnitPrincipal.pas' {FrmPrincipal},
  UnitInicial in 'pages\UnitInicial.pas' {FrmInicial},
  DataModule.Global in 'DataModule\DataModule.Global.pas' {DmGlobal: TDataModule},
  DataModule.Pedido in 'DataModule\DataModule.Pedido.pas' {DmPedido: TDataModule},
  DataModule.Cliente in 'DataModule\DataModule.Cliente.pas' {DmCliente: TDataModule},
  DataModule.Notificacao in 'DataModule\DataModule.Notificacao.pas' {DmNotificacao: TDataModule},
  uFunctions in 'Units\uFunctions.pas',
  UnitProduto in 'pages\UnitProduto.pas' {FrmProduto},
  DataModule.Produto in 'DataModule\DataModule.Produto.pas' {DMProduto: TDataModule},
  UnitProdutoCad in 'pages\UnitProdutoCad.pas' {FrmProdutoCad},
  uActionSheet in 'Units\uActionSheet.pas',
  u99Permissions in 'Units\u99Permissions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.CreateForm(TDmPedido, DmPedido);
  Application.CreateForm(TDmCliente, DmCliente);
  Application.CreateForm(TDmNotificacao, DmNotificacao);
  Application.CreateForm(TFrmProduto, FrmProduto);
  Application.CreateForm(TDMProduto, DMProduto);
  Application.CreateForm(TFrmProdutoCad, FrmProdutoCad);
  Application.Run;
end.
