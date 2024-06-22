unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox;

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
    EditEmail: TEdit;
    BTBuscarPedido: TSpeedButton;
    lvPedido: TListView;
    BTAddPedido: TSpeedButton;
    Image3: TImage;
    BTAddCliente: TSpeedButton;
    Image4: TImage;
    Rectangle5: TRectangle;
    Edit1: TEdit;
    BTBuscarCliente: TSpeedButton;
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
    procedure imgAbaDashboardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AbrirAba(img: TImage);
    procedure AddPedidoListView(pedido_local, pedido_oficial, cliente,
      dt_pedido, id_sicronizar: string; valor: double);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.AbrirAba(img : TImage);
begin
  imgAbaDashboard.Opacity   := 0.5;
  imgAbaPedido.Opacity      := 0.5;
  imgAbaCliente.Opacity     := 0.5;
  imgAbaNotificacao.Opacity := 0.5;
  imgAbaMais.Opacity        := 0.5;

  img.Opacity := 1;
  TabControl.GotoVisibleTab(img.Tag);
end;

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

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  AbrirAba(imgAbaDashboard);

  AddPedidoListView('321', '', '99 Coders', '22/06/2024', 'S', 325.12);
  AddPedidoListView('3231', '', 'Brazil Company Ltda.', '22/06/2024', 'S', 1125.50);
  AddPedidoListView('1341', '', 'Via Sat', '22/06/2024', 'S', 435.00);
  AddPedidoListView('671', '', 'Asta Brazil', '10/06/2024', 'N', 25.38);
end;

procedure TFrmPrincipal.imgAbaDashboardClick(Sender: TObject);
begin
  AbrirAba(TImage(Sender));
end;

end.