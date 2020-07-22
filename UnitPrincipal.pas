unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    Circle1: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    Image4: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    lv_lancamento: TListView;
    img_categoria: TImage;
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    procedure AddLancamento(id_lancamento, descricao, categoria: string;
                                      valor : double; dt_lanc : TDateTime;
                                      foto: TStream);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.AddLancamento(id_lancamento, descricao, categoria: string;
                                      valor : double; dt_lanc : TDateTime;
                                      foto: TStream);
var
    bmp : TBitmap;
begin
    with lv_lancamento.Items.Add do
    begin
        TagString := id_lancamento;

        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtValor')).Text     := FormatFloat('#,##0.00',valor);
        TListItemText(Objects.FindDrawable('TxtData')).Text      := FormatDateTime('dd/mm',dt_lanc);

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap     := bmp;
            //não precisa destruir pq está dentro da listview;
        end;

    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    foto := TMemoryStream.Create;
    img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for x := 1 to 10 do
        AddLancamento('00001', 'Compra de Passagem teste 123456 aaaaa bbbbb cccccc ddddddddd', 'Transporte', -45, date, foto);

    foto.DisposeOf;
end;

procedure TFrmPrincipal.lv_lancamentoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  {
    if TListView(Sender).Selected <> nil then
    begin
        if ItemObject is TListItemImage then
        begin
            Image3.Bitmap := TListItemImage(ItemObject).Bitmap;
        end;

        if ItemObject is TListItemText then
        begin
            Label2.Text := TListItemText(ItemObject).Text;
        end;
    end;
    }
end;

procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if lv_lancamento.Width < 200 then
    begin
        TListItemImage(AItem.Objects.FindDrawable('ImgIcone')).Visible := false;
        TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).PlaceOffset.X := 22;
    end;

{    TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).Width := lv_lancamento.Width -
                TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).PlaceOffset.X -100;}
end;

end.
