unit UnitProdutoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, uActionSheet,
  u99Permissions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions;

type
  TFrmProdutoCad = class(TForm)
    recToolbar: TRectangle;
    lblTitulo: TLabel;
    BTAddSalvar: TSpeedButton;
    Image4: TImage;
    BTVoltar: TSpeedButton;
    Image1: TImage;
    Layout1: TLayout;
    ImageFoto: TImage;
    Label1: TLabel;
    recDescricao: TRectangle;
    Label2: TLabel;
    Image6: TImage;
    lblDescricao: TLabel;
    recValor: TRectangle;
    Label3: TLabel;
    Image2: TImage;
    lblValor: TLabel;
    recEstoque: TRectangle;
    Label4: TLabel;
    Image3: TImage;
    lblEstoque: TLabel;
    ActionList1: TActionList;
    ActGaleriaFotos: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    procedure BTVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageFotoClick(Sender: TObject);
    procedure ActGaleriaFotosDidFinishTaking(Image: TBitmap);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
  private
    Menu : TActionSheet;
    Permissao : T99Permissions;
    procedure OpenCamera(Sender: TObject);
    procedure OpenGallery(Sender: TObject);
    procedure ErroPermissaoFotos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProdutoCad: TFrmProdutoCad;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmProdutoCad.ActCameraDidFinishTaking(Image: TBitmap);
begin
  ImageFoto.Bitmap := Image;
end;

procedure TFrmProdutoCad.ActGaleriaFotosDidFinishTaking(Image: TBitmap);
begin
  ImageFoto.Bitmap := Image;
end;

procedure TFrmProdutoCad.BTVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmProdutoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action        := TCloseAction.caFree;
  FrmProdutoCad := nil;
end;

procedure TFrmProdutoCad.ErroPermissaoFotos(Sender: TObject);
begin
  ShowMessage('Você não possuiu permissão para acessar esse recurso!');
end;

procedure TFrmProdutoCad.OpenGallery(Sender: TObject);
begin
  Menu.HideMenu;

  Permissao.PhotoLibrary(ActGaleriaFotos, ErroPermissaoFotos);
end;

procedure TFrmProdutoCad.OpenCamera(Sender: TObject);
begin
  Menu.HideMenu;

  Permissao.Camera(ActCamera, ErroPermissaoFotos);
end;

procedure TFrmProdutoCad.FormCreate(Sender: TObject);
begin
  // Permissões Android
  Permissao := T99Permissions.Create;

  // Menu
  Menu := TActionSheet.Create(FrmProdutoCad);

  Menu.TitleMenuText  := 'Escolha uma opção';
  Menu.TitleFontSize  := 12;
  Menu.TitleFontColor := $FFA3A3A3;

  Menu.CancelMenuText  := 'Cancelar';
  Menu.CancelFontSize  := 16;
  Menu.CancelFontColor := $FFDA4F3F;

  Menu.BackgroundOpacity := 0.5;
  Menu.MenuColor         := $FFFFFFFF;

  Menu.AddItem('', 'Galeria', OpenGallery, $FF4162FF, 15);
  Menu.AddItem('', 'Câmera', OpenCamera, $FF4162FF, 15);
end;

procedure TFrmProdutoCad.FormDestroy(Sender: TObject);
begin
  Menu.DisposeOf;
end;

procedure TFrmProdutoCad.ImageFotoClick(Sender: TObject);
begin
  Menu.ShowMenu;
end;

end.
