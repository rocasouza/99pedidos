unit UnitEdicao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit;

type
  TTipoCampo = (Edit, Data, Senha, Memo, Valor);

  TExecuteOnClose = procedure(Sender: TObject) of Object;

  TFrmEdicao = class(TForm)
    StyleBook1: TStyleBook;
    recToolbar: TRectangle;
    lblTitulo: TLabel;
    BTAddSalvar: TSpeedButton;
    Image4: TImage;
    BTVoltar: TSpeedButton;
    Image1: TImage;
    EditTexto: TEdit;
    procedure BTAddSalvarClick(Sender: TObject);
  private
    Objeto: TObject;
    ProcExecuteOnClose: TExecuteOnClose;
    Obrigatorio: Boolean;
    { Private declarations }
  public
    procedure Editar(Obj: TObject; TipoCampo: TTipoCampo; Titulo, TextPrompt, TextoPadrao: string;
                     Ind_Obrigatotio: Boolean; Tam_Maximo: integer; ExecuteOnClose: TExecuteOnClose = nil);
    { Public declarations }
  end;

var
  FrmEdicao: TFrmEdicao;

implementation

{$R *.fmx}

procedure TFrmEdicao.Editar(Obj: TObject; TipoCampo: TTipoCampo; Titulo, TextPrompt, TextoPadrao: string;
                     Ind_Obrigatotio: Boolean; Tam_Maximo: integer; ExecuteOnClose: TExecuteOnClose = nil);
begin
  lblTitulo.Text     := Titulo;
  objeto             := Obj;
  ProcExecuteOnClose := ExecuteOnClose;
  Obrigatorio        := Ind_Obrigatotio;

  if TipoCampo = TTipoCampo.Edit then
  begin
    EditTexto.TextPrompt := TextPrompt;
    EditTexto.MaxLength  := Tam_Maximo;
    EditTexto.Text       := TextoPadrao;
  end;

  FrmEdicao.Show;
end;


procedure TFrmEdicao.BTAddSalvarClick(Sender: TObject);
var
 ret: String;
begin
  if EditTexto.Visible then
     ret := EditTexto.Text;

  if (Obrigatorio) and (ret = '') then
  begin
    ShowMessage('Campo obrigatório!');
    Exit;
  end;

  if Objeto is TLabel then
     TLabel(Objeto).Text := ret;

  if Assigned(ProcExecuteOnClose) then
     ProcExecuteOnClose(Objeto);

  Close;
end;

end.
