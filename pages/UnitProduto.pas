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
    imgIconeProduto: TImage;
    imgIconeValor: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal;

end.
