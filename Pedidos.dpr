program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitInicial in 'UnitInicial.pas' {FrmInicial};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.Run;
end.
