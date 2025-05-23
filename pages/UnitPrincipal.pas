unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, uFunctions, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    imgAbaDashboard: TImage;
    imgAbaPedido: TImage;
    imgAbaNotificacao: TImage;
    imgAbaCliente: TImage;
    imgAbaMais: TImage;
    TabControl: TTabControl;
    TabDashboard: TTabItem;
    TabPedido: TTabItem;
    TabCliente: TTabItem;
    TabNotificacao: TTabItem;
    TabMais: TTabItem;
    CircleNotificacao: TCircle;
    RectToobalDashboard: TRectangle;
    Label1: TLabel;
    Rectangle1: TRectangle;
    Pedidos: TLabel;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Rectangle4: TRectangle;
    Label4: TLabel;
    LayoutImgNotificacao: TLayout;
    Label5: TLabel;
    Layout1: TLayout;
    VertScrollBox1: TVertScrollBox;
    Label6: TLabel;
    Layout2: TLayout;
    Image1: TImage;
    Image2: TImage;
    RectBuscaPedido: TRectangle;
    StyleBook1: TStyleBook;
    EditBuscaPedido: TEdit;
    BTBuscaPedido: TSpeedButton;
    lvPedido: TListView;
    BTAddPedido: TSpeedButton;
    Image3: TImage;
    BTAddCliente: TSpeedButton;
    Image4: TImage;
    Rectangle5: TRectangle;
    EditBuscaCliente: TEdit;
    BTBuscaCliente: TSpeedButton;
    lvCliente: TListView;
    lvNotificacao: TListView;
    ListBox1: TListBox;
    lbiProdutos: TListBoxItem;
    lbiPerfil: TListBoxItem;
    lbiSenha: TListBoxItem;
    lbiSincronizar: TListBoxItem;
    lbiLogout: TListBoxItem;
    Image5: TImage;
    Label7: TLabel;
    Image6: TImage;
    Image7: TImage;
    Label8: TLabel;
    Image8: TImage;
    Image9: TImage;
    Label9: TLabel;
    Image10: TImage;
    Image11: TImage;
    Label10: TLabel;
    Image12: TImage;
    Image13: TImage;
    Label11: TLabel;
    Image14: TImage;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    imgIconeCliente: TImage;
    imgIconeData: TImage;
    imgIconeSincronizar: TImage;
    imgIconeEndereco: TImage;
    imgIconeFone: TImage;
    imgIconeMenu: TImage;
    procedure imgAbaDashboardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTBuscaPedidoClick(Sender: TObject);
    procedure lvPedidoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure BTBuscaClienteClick(Sender: TObject);
    procedure lvClientePaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvNotificacaoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lvNotificacaoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvClienteUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lbiProdutosClick(Sender: TObject);
  private
    procedure AbrirAba(img: TImage);
    procedure AddPedidoListView(pedido_local, pedido_oficial, cliente,
      dt_pedido, id_sicronizar: string; valor: double);
    procedure ListarPedidos(pagina: integer; busca: string; ind_clear: boolean);
    procedure ThreadPedidosTerminate(Sender: TObject);
    procedure AddClienteListView(cod_cliente_local, nome, endereco, numero,
      complemento, bairro, cidade, uf, fone, ind_sincronizar: string);
    procedure ListarClientes(pagina: integer; busca: string;
      ind_clear: boolean);
    procedure ThreadClientesTerminate(Sender: TObject);
    procedure AddNotificacaoListView(cod_notificacao, dt, titulo, texto, ind_lido: string);
    procedure ListarNotificacao(pagina: integer; ind_clear: boolean);
    procedure ThreadNotificacoesTerminate(Sender: TObject);
    procedure LayoutListViewNotificacao(AItem: TListViewItem);
    procedure LayoutListViewCliente(AItem: TListViewItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

Const
  QTD_REG_PAGINA_PEDIDO  = 15;
  QTD_REG_PAGINA_CLIENTE = 15;
  QTD_REG_PAGINA_NOTIFICACAO = 15;

implementation

uses
  DataModule.Pedido, DataModule.Cliente, DataModule.Notificacao, UnitProduto;

{$R *.fmx}

// Ao abrir o Form.
procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  AbrirAba(imgAbaDashboard);

  ListarPedidos(1, '', True);
end;

// Abas inferiores.
procedure TFrmPrincipal.AbrirAba(img : TImage);
begin
  imgAbaDashboard.Opacity   := 0.5;
  imgAbaPedido.Opacity      := 0.5;
  imgAbaCliente.Opacity     := 0.5;
  imgAbaNotificacao.Opacity := 0.5;
  imgAbaMais.Opacity        := 0.5;

  img.Opacity := 1;

  TabControl.GotoVisibleTab(img.Tag);

  if img.Name = 'imgAbaCliente' then
     ListarClientes(1, '', True);
  if img.Name = 'imgAbaNotificacao' then
     ListarNotificacao(1, True);
end;

procedure TFrmPrincipal.imgAbaDashboardClick(Sender: TObject);
begin
  AbrirAba(TImage(Sender));
end;

{$REGION 'Aba Pedidos'}
// Adiciona Pedidos na lvPedido.
procedure TFrmPrincipal.AddPedidoListView(pedido_local, pedido_oficial, cliente, dt_pedido, id_sicronizar: string; valor: double);
var
 item : TListViewItem;
 txt  : TListItemText;
 img  : TListItemImage;
begin
  try
    item := lvPedido.Items.Add;

    with item do
    begin
      TagString := pedido_local;

      // N�mero do pedido...
      txt := TListItemText(Objects.FindDrawable('txtPedido'));
      if pedido_oficial <> '' then
         txt.Text := 'Pedido #' + pedido_oficial
      else
         txt.Text := 'Or�amento #' + pedido_local;

      // Cliente...
      txt := TListItemText(Objects.FindDrawable('txtCliente'));
      txt.Text := cliente;

      // Data do pedido...
      txt := TListItemText(Objects.FindDrawable('txtData'));
      txt.Text := dt_pedido;

      // Valor do pedido...
      txt := TListItemText(Objects.FindDrawable('txtValor'));
      txt.Text := FormatFloat('R$#,##0.00', valor);

      // �cone cliente...
      img := TListItemImage(Objects.FindDrawable('imgCliente'));
      img.Bitmap := imgIconeCliente.Bitmap;

      // �cone data...
      img := TListItemImage(Objects.FindDrawable('imgData'));
      img.Bitmap := imgIconeData.Bitmap;

      // �cone sincronizar...
      if id_sicronizar = 'S' then
      begin
        img := TListItemImage(Objects.FindDrawable('imgSincronizar'));
        img.Bitmap := imgIconeSincronizar.Bitmap;
      end;
    end;
  except on ex:Exception do
    ShowMessage('Erro ao inserir pedido na lista: ' + ex.Message)
  end;
end;

// Terminate da Thread dos Pedidos.
procedure TFrmPrincipal.ThreadPedidosTerminate(Sender: TObject);
begin
  // N�o carregar mais dados.
  if DmPedido.qryConsPedido.RecordCount < QTD_REG_PAGINA_PEDIDO then
     lvPedido.Tag := -1;

  with DMPedido.qryConsPedido do
  begin
    while not(Eof) do
    begin
      AddPedidoListView(FieldByName('cod_pedido_local').AsString,
                        FieldByName('cod_pedido_oficial').AsString,
                        FieldByName('nome').AsString,
                        FormatDateTime('dd/mm/aaaa', FieldByName('data_pedido').AsDateTime),
                        FieldByName('ind_sincronizar').AsString,
                        FieldByName('valor_total').AsFloat);

      Next;
    end;
  end;

  // Finaliza update da ListView.
  lvPedido.EndUpdate;

  // Marcar que o processo terminou.
  lvPedido.TagString := '';

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

// Requisi��o para os dados dos pedidos.
procedure TFrmPrincipal.ListarPedidos(pagina: integer; busca: string; ind_clear: boolean);
var
 t : TThread;
begin
  // Evitar processamento concorrente.
  if lvPedido.TagString = 'S' then
     Exit;

  // Em processamento.
  lvPedido.TagString := 'S';

  // Come�a update da ListView.
  lvPedido.BeginUpdate;

  // Limpa a ListView...
  if ind_clear then
  begin
    pagina := 1;
    lvPedido.ScrollTo(0);
    lvPedido.Items.Clear;
  end;

  { Tag: cont�m a p�gina atual solicitada ao servidor.
    >= 1 : faz o request para buscar mais dados
    -1   : indica que n�o tem mais dados
  }
  // Salva a p�gina atual a ser exibida.
  lvPedido.Tag := pagina;

  // Requisi��o por mais dados.
  t := TThread.CreateAnonymousThread(procedure
  begin
    DmPedido.ListarPedidos(pagina, busca);

  end);
  t.OnTerminate := ThreadPedidosTerminate;
  t.Start;
end;

procedure TFrmPrincipal.BTBuscaPedidoClick(Sender: TObject);
begin
  ListarPedidos(1, EditBuscaPedido.Text, True)
end;

procedure TFrmPrincipal.lvPedidoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  // Verifica se a rolagem atingiu o limite para uma nova carga.
  if (lvPedido.Items.Count >= QTD_REG_PAGINA_PEDIDO) and (lvPedido.Tag >= 0) then
     if lvPedido.GetItemRect(lvPedido.Items.Count - 5).Bottom <= lvPedido.Height then
        ListarPedidos(lvPedido.Tag + 1, EditBuscaPedido.Text, False);
end;

{$ENDREGION}

{$REGION 'Aba Clientes'}
// Adiciona Pedidos na lvCliente.
procedure TFrmPrincipal.AddClienteListView(cod_cliente_local, nome, endereco, numero, complemento, bairro,
                                           cidade, uf, fone, ind_sincronizar: string);
var
 item : TListViewItem;
 txt  : TListItemText;
 img  : TListItemImage;
begin
  try
    item := lvCliente.Items.Add;

    with item do
    begin
      TagString := cod_cliente_local;

      // Nome.
      txt := TListItemText(Objects.FindDrawable('txtNome'));
      txt.Text := nome;

      // Endere�o completo.
      txt := TListItemText(Objects.FindDrawable('txtEndereco'));
      txt.Text := endereco;

      if numero <> '' then
         txt.Text := txt.Text + ', ' + numero;

      if complemento <> '' then
         txt.Text := txt.Text + ' - ' + complemento;

      if bairro <> '' then
         txt.Text := txt.Text + ' - ' + bairro;

      if cidade <> '' then
         txt.Text := txt.Text + ' - ' + cidade;

      if uf <> '' then
         txt.Text := txt.Text + ' - ' + uf;

      // Telefone.
      txt := TListItemText(Objects.FindDrawable('txtFone'));
      txt.Text := fone;

      // �cone enderec�o.
      img := TListItemImage(Objects.FindDrawable('imgEndereco'));
      img.Bitmap := imgIconeEndereco.Bitmap;

      // �cone fone.
      img := TListItemImage(Objects.FindDrawable('imgFone'));
      img.Bitmap := imgIconeFone.Bitmap;

      // �cone sincronizar.
      if ind_sincronizar = 'S' then
      begin
        img := TListItemImage(Objects.FindDrawable('imgSincronizar'));
        img.Bitmap := imgIconeSincronizar.Bitmap;
      end;
    end;
    LayoutListViewCliente(item);
  except on ex:Exception do
    ShowMessage('Erro ao inserir pedido na lista: ' + ex.Message)
  end;
end;

// Terminate da Thread dos Clientes.
procedure TFrmPrincipal.ThreadClientesTerminate(Sender: TObject);
begin
  // N�o carregar mais dados.
  if DmCliente.qryConsCliente.RecordCount < QTD_REG_PAGINA_CLIENTE then
     lvCliente.Tag := -1;

  with DmCliente.qryConsCliente do
  begin
    while not Eof do
    begin
      AddClienteListView(FieldByName('cod_cliente_local').AsString,
                         FieldByName('nome').AsString,
                         FieldByName('endereco').AsString,
                         FieldByName('numero').AsString,
                         FieldByName('complemento').AsString,
                         FieldByName('bairro').AsString,
                         FieldByName('cidade').AsString,
                         FieldByName('uf').AsString,
                         FieldByName('fone').AsString,
                         FieldByName('ind_sincronizar').AsString);
      Next;
    end;
  end;

  // Finaliza update da ListView.
  lvCliente.EndUpdate;

  // Marcar que o processo terminou.
  lvCliente.TagString := '';

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

// Requisi��o para os dados dos clientes.
procedure TFrmPrincipal.ListarClientes(pagina: integer; busca: string; ind_clear: boolean);
var
 t : TThread;
begin
  // Evitar processamento concorrente.
  if lvCliente.TagString = 'S' then
     Exit;

  // Em processamento.
  lvCliente.TagString := 'S';

  // Come�a update da ListView.
  lvCliente.BeginUpdate;

  // Limpa a ListView...
  if ind_clear then
  begin
    pagina := 1;
    lvCliente.ScrollTo(0);
    lvCliente.Items.Clear;
  end;

  { Tag: cont�m a p�gina atual solicitada ao servidor.
    >= 1 : faz o request para buscar mais dados
    -1   : indica que n�o tem mais dados
  }
  // Salva a p�gina atual a ser exibida.
  lvCliente.Tag := pagina;

  // Requisi��o por mais dados.
  t := TThread.CreateAnonymousThread(procedure
  begin
    DmCliente.ListarClientes(pagina, busca);
  end);
  t.OnTerminate := ThreadClientesTerminate;
  t.Start;
end;

procedure TFrmPrincipal.LayoutListViewCliente(AItem: TListViewItem);
var
 txt  : TListItemText;
begin
  txt := TListItemText(AItem.Objects.FindDrawable('txtEndereco'));
  txt.Width  := lvCliente.Width - 110 ;
  txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 5;

  AItem.Height := Trunc(txt.PlaceOffset.Y + txt.Height);
end;

procedure TFrmPrincipal.BTBuscaClienteClick(Sender: TObject);
begin
  ListarClientes(1, EditBuscaCliente.Text, True);
end;

procedure TFrmPrincipal.lvClientePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  // Verifica se a rolagem atingiu o limite para uma nova carga.
  if (lvCliente.Items.Count >= QTD_REG_PAGINA_PEDIDO) and (lvCliente.Tag >= 0) then
     if lvCliente.GetItemRect(lvCliente.Items.Count - 5).Bottom <= lvCliente.Height then
        ListarClientes(lvCliente.Tag + 1, EditBuscaCliente.Text, False);
end;

procedure TFrmPrincipal.lvClienteUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  LayoutListViewCliente(AItem);
end;

{$ENDREGION}

{$REGION 'Aba Notifica��o'}
// Adiciona Notifica��o na lvNotificacao.
procedure TFrmPrincipal.AddNotificacaoListView(cod_notificacao, dt, titulo, texto, ind_lido: string);
var
 item : TListViewItem;
 txt  : TListItemText;
 img  : TListItemImage;
begin
  try
    item := lvNotificacao.Items.Add;

    with item do
    begin
      TagString := cod_notificacao;

      // T�tulo.
      txt := TListItemText(Objects.FindDrawable('txtTitulo'));
      txt.Text := titulo;
      txt.TagString := ind_lido;

      // Data.
      txt := TListItemText(Objects.FindDrawable('txtData'));
      txt.Text := dt;

      // �cone Data.
      img := TListItemImage(Objects.FindDrawable('imgData'));
      img.Bitmap := imgIconeData.Bitmap;

      // Mensagem.
      txt := TListItemText(Objects.FindDrawable('txtMensagem'));
      txt.Text := texto;

      // �cone Menu.
      img := TListItemImage(Objects.FindDrawable('imgMenu'));
      img.Bitmap := imgIconeMenu.Bitmap;
    end;

    LayoutListViewNotificacao(item);
  except on ex:Exception do
    ShowMessage('Erro ao inserir pedido na lista: ' + ex.Message)
  end;
end;

// Terminate da Thread das Notifica��es.
procedure TFrmPrincipal.ThreadNotificacoesTerminate(Sender: TObject);
begin
  // N�o carregar mais dados.
  if DmNotificacao.qryConsNotificacao.RecordCount < QTD_REG_PAGINA_NOTIFICACAO then
     lvNotificacao.Tag := -1;

  with DmNotificacao.qryConsNotificacao do
  begin
    while not Eof do
    begin
      AddNotificacaoListView(FieldByName('cod_notificacao').AsString,
                             FormatDateTime('dd/mm/yy hh:nn', FieldByName('data_notificacao').AsDateTime),
                             FieldByName('titulo').AsString, FieldByName('texto').AsString,
                             FieldByName('ind_lido').AsString);
      Next;
    end;
  end;

  // Finaliza update da ListView.
  lvNotificacao.EndUpdate;

  // Marcar que o processo terminou.
  lvNotificacao.TagString := '';

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

// Requisi��o para os dados das notifica��es.
procedure TFrmPrincipal.ListarNotificacao(pagina: integer; ind_clear: boolean);
var
 t : TThread;
begin
  // Evitar processamento concorrente.
  if lvNotificacao.TagString = 'S' then
     Exit;

  // Em processamento.
  lvNotificacao.TagString := 'S';

  // Come�a update da ListView.
  lvNotificacao.BeginUpdate;

  // Limpa a ListView...
  if ind_clear then
  begin
    pagina := 1;
    lvNotificacao.ScrollTo(0);
    lvNotificacao.Items.Clear;
  end;

  { Tag: cont�m a p�gina atual solicitada ao servidor.
    >= 1 : faz o request para buscar mais dados
    -1   : indica que n�o tem mais dados
  }
  // Salva a p�gina atual a ser exibida.
  lvNotificacao.Tag := pagina;

  // Requisi��o por mais dados.
  t := TThread.CreateAnonymousThread(procedure
  begin
    DmNotificacao.ListarNotificacoes(pagina);
  end);
  t.OnTerminate := ThreadNotificacoesTerminate;
  t.Start;
end;

procedure TFrmPrincipal.LayoutListViewNotificacao(AItem: TListViewItem);
var
 txt  : TListItemText;
begin
  txt := TListItemText(AItem.Objects.FindDrawable('txtTitulo'));

  if txt.TagString = 'N' then // ind_lido
     txt.Font.Style := [TFontStyle.fsBold];

  txt := TListItemText(AItem.Objects.FindDrawable('txtMensagem'));
  txt.Width  := lvNotificacao.Width - 24;
  txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 5;

  AItem.Height := Trunc(txt.PlaceOffset.Y + txt.Height);
end;

procedure TFrmPrincipal.lbiProdutosClick(Sender: TObject);
begin
  if not Assigned(FrmProduto) then
     Application.CreateForm(TFrmProduto, FrmProduto);
  FrmProduto.Show
end;

procedure TFrmPrincipal.lvNotificacaoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  // Verifica se a rolagem atingiu o limite para uma nova carga.
  if (lvNotificacao.Items.Count >= QTD_REG_PAGINA_NOTIFICACAO) and (lvNotificacao.Tag >= 0) then
     if lvNotificacao.GetItemRect(lvNotificacao.Items.Count - 5).Bottom <= lvNotificacao.Height then
        ListarNotificacao(lvNotificacao.Tag + 1, False);
end;

procedure TFrmPrincipal.lvNotificacaoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  LayoutListViewNotificacao(AItem);
end;

{$ENDREGION}
end.
