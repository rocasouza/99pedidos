unit DataModule.Pedido;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDmPedido = class(TDataModule)
    qryConsPedido: TFDQuery;
  private
    { Private declarations }
  public
    procedure ListarPedidos(pagina: integer; busca: string);
    { Public declarations }
  end;

var
  DmPedido: TDmPedido;

Const
  QTD_REG_PAGINA = 15;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DataModule.Global;

{$R *.dfm}

// Lista e busca pedidos no banco de dados.
procedure TDmPedido.ListarPedidos(pagina: integer; busca: string);
begin
  qryConsPedido.Active := False;
  qryConsPedido.SQL.Clear;
  qryConsPedido.SQL.Add('Select p.*, c.nome');
  qryConsPedido.SQL.Add('From tab_pedido p');
  qryConsPedido.SQL.Add('Join tab_cliente c on c.cod_cliente_local = p.cod_cliente_local');
  qryConsPedido.SQL.Add('Where p.cod_pedido_local > 0 ');
  if busca <> '' then
  begin
     qryConsPedido.SQL.Add('and (c.nome like :nome or p.cod_pedido_local = :cod_pedido_local');
     qryConsPedido.SQL.Add('or p.cod_pedido_oficial = :cod_pedido_oficial)');
     qryConsPedido.ParamByName('nome').Value := '%' + busca + '%';
     try
       qryConsPedido.ParamByName('cod_pedido_local').Value := busca.ToInteger;
     except
       qryConsPedido.ParamByName('cod_pedido_local').Value := 0;
     end;
     try
       qryConsPedido.ParamByName('cod_pedido_oficial').Value := busca.ToInteger;;
     except
       qryConsPedido.ParamByName('cod_pedido_oficial').Value := 0;
     end;
  end;

  qryConsPedido.SQL.Add('Order By p.cod_pedido_local Desc ');

  if pagina > 0 then
  begin
     qryConsPedido.SQL.Add('Limit :pagina, :qtd_reg');
     qryConsPedido.ParamByName('pagina').Value  := (pagina - 1) * QTD_REG_PAGINA;
     qryConsPedido.ParamByName('qtd_reg').Value := QTD_REG_PAGINA;
  end;

  qryConsPedido.Active := True;
end;

end.
