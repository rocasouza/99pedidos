program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'pages\UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'pages\UnitPrincipal.pas' {FrmPrincipal},
  UnitInicial in 'pages\UnitInicial.pas' {FrmInicial},
  DataModule.Global in 'DataModule\DataModule.Global.pas' {DmGlobal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.Run;
end.
