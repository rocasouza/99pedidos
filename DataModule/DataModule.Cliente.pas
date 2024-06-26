unit DataModule.Cliente;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDmCliente = class(TDataModule)
    qryConsCliente: TFDQuery;
  private
    { Private declarations }
  public
    procedure ListarClientes(pagina: integer; busca: string);
    { Public declarations }
  end;

var
  DmCliente: TDmCliente;

Const
  QTD_REG_PAGINA = 15;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DataModule.Global;

{$R *.dfm}

// Lista e busca clientes no banco de dados.
procedure TDmCliente.ListarClientes(pagina: integer; busca: string);
begin
  qryConsCliente.Active := False;
  qryConsCliente.SQL.Clear;
  qryConsCliente.SQL.Add('Select c.*');
  qryConsCliente.SQL.Add('From tab_cliente c');
  qryConsCliente.SQL.Add('Where c.cod_cliente_local > 0 ');
  if busca <> '' then
  begin
     qryConsCliente.SQL.Add('and c.nome like :nome');
     qryConsCliente.ParamByName('nome').Value := '%' + busca + '%';
  end;

  qryConsCliente.SQL.Add('Order By c.nome');

  if pagina > 0 then
  begin
     qryConsCliente.SQL.Add('Limit :pagina, :qtd_reg');
     qryConsCliente.ParamByName('pagina').Value  := (pagina - 1) * QTD_REG_PAGINA;
     qryConsCliente.ParamByName('qtd_reg').Value := QTD_REG_PAGINA;
  end;

  qryConsCliente.Active := True;
end;

end.
