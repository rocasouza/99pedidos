unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects;

type
  TFrmInicial = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Layout: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Layout1: TLayout;
    BTProximo1: TSpeedButton;
    StyleBook1: TStyleBook;
    Layout2: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout3: TLayout;
    BTVoltar2: TSpeedButton;
    BTProximo2: TSpeedButton;
    Layout4: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Layout5: TLayout;
    BTVoltar3: TSpeedButton;
    BTProximo3: TSpeedButton;
    Layout6: TLayout;
    Image4: TImage;
    Label7: TLabel;
    Layout7: TLayout;
    BTAcessar: TSpeedButton;
    BTCriar: TSpeedButton;
    procedure BTProximo1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTAcessarClick(Sender: TObject);
    procedure BTCriarClick(Sender: TObject);
  private
    procedure AbrirAba(index: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInicial: TFrmInicial;

implementation

uses
  UnitLogin;

{$R *.fmx}

procedure TFrmInicial.AbrirAba(index : integer);
begin
  TabControl.GotoVisibleTab(index);
end;

procedure TFrmInicial.BTAcessarClick(Sender: TObject);
begin
  if not Assigned(FrmLogin) then
     Application.CreateForm(TFrmLogin, FrmLogin);

  FrmLogin.TabControl.ActiveTab := FrmLogin.TabLogin;
  FrmLogin.Show;
end;

procedure TFrmInicial.BTCriarClick(Sender: TObject);
begin
  if not Assigned(FrmLogin) then
     Application.CreateForm(TFrmLogin, FrmLogin);

  FrmLogin.TabControl.ActiveTab := FrmLogin.TabCriarConta;
  FrmLogin.Show;
end;

procedure TFrmInicial.BTProximo1Click(Sender: TObject);
begin
  AbrirAba(TSpeedButton(Sender).Tag);
end;

procedure TFrmInicial.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab := TabItem1;
end;

end.

