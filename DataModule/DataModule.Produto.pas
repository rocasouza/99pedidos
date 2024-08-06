unit DataModule.Produto;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMProduto = class(TDataModule)
    qryConsProduto: TFDQuery;
  private
    { Private declarations }
  public
    procedure ListarProdutos(pagina: integer; busca: string);
    { Public declarations }
  end;

var
  DMProduto: TDMProduto;

const
  QTD_REG_PAGINA = 15;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DataModule.Global;

{$R *.dfm}

// Lista e busca clientes no banco de dados.
procedure TDMProduto.ListarProdutos(pagina: integer; busca: string);
begin
  qryConsProduto.Active := False;
  qryConsProduto.SQL.Clear;
  qryConsProduto.SQL.Add('Select p.*');
  qryConsProduto.SQL.Add('From tab_produto p');
  qryConsProduto.SQL.Add('Where p.cod_produto_local > 0 ');
  if busca <> '' then
  begin
     qryConsProduto.SQL.Add('and p.descricao like :descricao');
     qryConsProduto.ParamByName('descricao').Value := '%' + busca + '%';
  end;

  qryConsProduto.SQL.Add('Order By p.descricao');

  if pagina > 0 then
  begin
     qryConsProduto.SQL.Add('Limit :pagina, :qtd_reg');
     qryConsProduto.ParamByName('pagina').Value  := (pagina - 1) * QTD_REG_PAGINA;
     qryConsProduto.ParamByName('qtd_reg').Value := QTD_REG_PAGINA;
  end;

  qryConsProduto.Active := True;
end;
end.
