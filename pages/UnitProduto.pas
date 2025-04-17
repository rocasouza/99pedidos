unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, Data.DB,
  uFunctions;

type
  TFrmProduto = class(TForm)
    recToolbar: TRectangle;
    lblTitulo: TLabel;
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
    procedure BTBuscaProdutoClick(Sender: TObject);
    procedure lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvProdutoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddProdutoListView(cod_produto_local, descricao: string; valor,
      estoque: double; foto: TStream);
    procedure ListarProdutos(pagina: integer; busca: string;
      ind_clear: boolean);
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure LayoutListViewProduto(AItem: TListViewItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

const
  QTD_REG_PAGINA_PRODUTO = 15;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Produto;

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
    LayoutListViewProduto(item);
  except on ex:Exception do
    ShowMessage('Erro ao inserir produto na lista: ' + ex.Message)
  end;
end;

procedure TFrmProduto.BTBuscaProdutoClick(Sender: TObject);
begin
  ListarProdutos(1, EditBuscaProduto.Text, True);
end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
  ListarProdutos(1,'', True);
end;

// Terminate da Thread dos Produtos.
procedure TFrmProduto.ThreadProdutosTerminate(Sender: TObject);
var
 foto: TStream;
begin
  // Não carregar mais dados.
  if DMProduto.qryConsProduto.RecordCount < QTD_REG_PAGINA_PRODUTO then
     lvProduto.Tag := -1;

  with DMProduto.qryConsProduto do
  begin
    while not Eof do
    begin
      if FieldByName('foto').AsString <> '' then
         foto := CreateBlobStream(FieldByName('foto'), TBlobStreamMode.bmRead)
      else
         foto := nil;

      AddProdutoListView(FieldByName('cod_produto_local').AsString,
                         FieldByName('descricao').AsString,
                         FieldByName('valor').AsFloat,
                         FieldByName('qtd_estoque').AsFloat,
                         foto);
      Next;
    end;
  end;

  // Finaliza update da ListView.
  lvProduto.EndUpdate;

  // Marcar que o processo terminou.
  lvProduto.TagString := '';

  // Exibe mensagem caso haja algum erro na thread.
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
      Exit;
    end;
  end;
end;

procedure TFrmProduto.ListarProdutos(pagina: integer; busca: string; ind_clear: boolean);
var
 t : TThread;
begin
  // Evitar processamento concorrente.
  if lvProduto.TagString = 'S' then
     Exit;

  // Em processamento.
  lvProduto.TagString := 'S';

  // Começa update da ListView.
  lvProduto.BeginUpdate;

  // Limpa a ListView...
  if ind_clear then
  begin
    pagina := 1;
    lvProduto.ScrollTo(0);
    lvProduto.Items.Clear;
  end;

  { Tag: contém a página atual solicitada ao servidor.
    >= 1 : faz o request para buscar mais dados
    -1   : indica que não tem mais dados
  }
  // Salva a página atual a ser exibida.
  lvProduto.Tag := pagina;

  // Requisição por mais dados.
  t := TThread.CreateAnonymousThread(procedure
  begin
    DMProduto.ListarProdutos(pagina, busca);
  end);
  t.OnTerminate := ThreadProdutosTerminate;
  t.Start;
end;

procedure TFrmProduto.LayoutListViewProduto(AItem: TListViewItem);
var
 txt : TListItemText;
 img : TListItemImage;
 posicao_y: Extended;
begin
  txt := TListItemText(AItem.Objects.FindDrawable('txtDescricao'));
  txt.Width  := lvProduto.Width - 90;
  txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 5;

  posicao_y := txt.PlaceOffset.Y + txt.Height;

  TListItemText(AItem.Objects.FindDrawable('txtValor')).PlaceOffset.Y         := posicao_y;
  TListItemText(AItem.Objects.FindDrawable('txtEstoque')).PlaceOffset.Y       := posicao_y;
  TListItemImage(AItem.Objects.FindDrawable('imgIconeValor')).PlaceOffset.Y   := posicao_y;
  TListItemImage(AItem.Objects.FindDrawable('imgIconeEstoque')).PlaceOffset.Y := posicao_y;

  AItem.Height := Trunc(posicao_y + 40);
end;

procedure TFrmProduto.lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  // Verifica se a rolagem atingiu o limite para uma nova carga.
  if (lvProduto.Items.Count >= QTD_REG_PAGINA_PRODUTO) and (lvProduto.Tag >= 0) then
     if lvProduto.GetItemRect(lvProduto.Items.Count - 5).Bottom <= lvProduto.Height then
        ListarProdutos(lvProduto.Tag + 1, EditBuscaProduto.Text, False);
end;

procedure TFrmProduto.lvProdutoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  LayoutListViewProduto(Aitem);
end;

end.
