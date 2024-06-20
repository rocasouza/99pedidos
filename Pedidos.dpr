program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitInicial in 'UnitInicial.pas' {FrmInicial},
  UnitLogin in 'pages\UnitLogin.pas' {FrmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.Run;
end.
