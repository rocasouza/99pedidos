unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmProduto = class(TForm)
    recToolbar: TRectangle;
    Label2: TLabel;
    BTAddProduto: TSpeedButton;
    Image4: TImage;
    rectBusca: TRectangle;
    EditBuscaProduto: TEdit;
    BTBuscaProduto: TSpeedButton;
    BTVoltar: TSpeedButton;
    Image1: TImage;
    lvProduto: TListView;
    imgIconeEstoque: TImage;
    imgIconeValor: TImage;
    imgIconeCamera: TImage;
    procedure FormShow(Sender: TObject);
  private
    procedure AddProdutoListView(cod_produto_local, descricao: string; valor,
      estoque: double; foto: TStream);
    procedure ListarProdutos(pagina: integer; busca: string;
      ind_clear: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Produto;

// Adiciona Pedidos na lvPedido.
procedure TFrmProduto.AddProdutoListView(cod_produto_local, descricao: string; valor, estoque: double; foto: TStream);
var
 item : TListViewItem;
 txt  : TListItemText;
 img  : TListItemImage;
 bmp  : TBitmap;
begin
  try
    item := lvProduto.Items.Add;

    with item do
    begin
      Height    := 85;
      TagString := cod_produto_local;

      // Descrição...
      txt := TListItemText(Objects.FindDrawable('txtDescricao'));
      txt.Text := descricao;

      // Valor...
      txt := TListItemText(Objects.FindDrawable('txtValor'));
      txt.Text := FormatFloat('R$#,##0.00', valor);

      // Estoque...
      txt := TListItemText(Objects.FindDrawable('txtEstoque'));
      txt.Text := FormatFloat('#,##0.00', estoque);

      // Ícone Valor...
      img := TListItemImage(Objects.FindDrawable('imgIconeValor'));
      img.Bitmap := imgIconeValor.Bitmap;

      // Ícone Estoque...
      img := TListItemImage(Objects.FindDrawable('imgIconeEstoque'));
      img.Bitmap := imgIconeEstoque.Bitmap;

      // Foto...
      img := TListItemImage(Objects.FindDrawable('imgFoto'));
      if foto <> Nil then
      begin
        bmp := TBitmap.Create;
        bmp.LoadFromStream(foto);

        img.OwnsBitmap := True;
        img.Bitmap     := bmp;
      end
      else
        img.Bitmap := imgIconeCamera.Bitmap;
    end;
  except on ex:Exception do
    ShowMessage('Erro ao inserir produto na lista: ' + ex.Message)
  end;
end;

// Lista Pedidos na lvPedido.
procedure TFrmProduto.FormShow(Sender: TObject);
begin
  ListarProdutos(1,'', True);
end;

procedure TFrmProduto.ListarProdutos(pagina: integer; busca: string; ind_clear: boolean);
begin
  if ind_clear then
     lvProduto.Items.Clear;

  DMProduto.ListarProdutos(pagina, busca);

  with DMProduto.qryConsProduto do
  begin
    while not Eof do
    begin
      AddProdutoListView(FieldByName('cod_produto_local').AsString,
                         FieldByName('descricao').AsString,
                         FieldByName('valor').AsFloat,
                         FieldByName('qtd_estoque').AsFloat,
                         nil);
      Next;
    end;
  end;
end;
end.
