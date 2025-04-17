unit UnitProdutoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProdutoCad: TFrmProdutoCad;

implementation

{$R *.fmx}

uses UnitPrincipal;

end.
