unit UnitEdicao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Calendar,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TTipoCampo = (Edit, Data, Senha, Memo, Valor);

  TExecuteOnClose = procedure(Sender: TObject) of Object;

  TFrmEdicao = class(TForm)
    recToolbar: TRectangle;
    lblTitulo: TLabel;
    BTAddSalvar: TSpeedButton;
    Image4: TImage;
    BTVoltar: TSpeedButton;
    Image1: TImage;
    EditTexto: TEdit;
    Calendar: TCalendar;
    StyleBook1: TStyleBook;
    Memo: TMemo;
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
var
  dia, mes, ano: integer;
begin
  lblTitulo.Text     := Titulo;
  objeto             := Obj;
  ProcExecuteOnClose := ExecuteOnClose;
  Obrigatorio        := Ind_Obrigatotio;

  Calendar.Visible := TipoCampo = TTipoCampo.Data;
  Memo.Visible     := TipoCampo = TTipoCampo.Memo;

  // Edit
  if TipoCampo = TTipoCampo.Edit then
  begin
    EditTexto.TextPrompt := TextPrompt;
    EditTexto.MaxLength  := Tam_Maximo;
    EditTexto.Text       := TextoPadrao;
    EditTexto.Password   := False;
  end;

  // Senha
  if TipoCampo = TTipoCampo.Senha then
  begin
    EditTexto.TextPrompt := TextPrompt;
    EditTexto.MaxLength  := Tam_Maximo;
    EditTexto.Text       := TextoPadrao;
    EditTexto.Password   := True;
  end;

  // Data
  if TipoCampo = TTipoCampo.Data then
  begin
    if TextoPadrao <> '' then
    begin
      dia := Copy(TextoPadrao, 1, 2).ToInteger;
      mes := Copy(TextoPadrao, 4, 2).ToInteger;
      ano := Copy(TextoPadrao, 7, 4).ToInteger;
      Calendar.Date := EncodeDate(ano, mes, dia);
    end
    else
      Calendar.Date := Date;
  end;

  // Memo
  if TipoCampo = TTipoCampo.Memo then
  begin
    Memo.MaxLength := Tam_Maximo;
    Memo.Text      := TextoPadrao;
  end;
  FrmEdicao.Show;
end;


procedure TFrmEdicao.BTAddSalvarClick(Sender: TObject);
var
 ret: String;
begin
  if EditTexto.Visible then
     ret := EditTexto.Text
  else if Calendar.Visible then
     ret := FormatDateTime('dd/mm/yyyy', Calendar.Date)
  else if Memo.Visible then
     ret := Memo.Text;



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
