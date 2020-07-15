unit UnitLogin;

interface

uses
  u99Permissions,

  FMX.ActnList,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.MediaLibrary.Actions,
  FMX.Objects,
  FMX.Platform,
  FMX.StdActns,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Types,
  FMX.VirtualKeyboard,

  System.Actions,
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;


type
  TfrmLogin = class(TForm)
    Layout1: TLayout;
    imgLogo: TImage;
    Layout2: TLayout;
    RoundRect1: TRoundRect;
    edt_login_email: TEdit;
    StyleBook: TStyleBook;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edt_login_senha: TEdit;
    Layout4: TLayout;
    rect_login: TRoundRect;
    Label1: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    TabFoto: TTabItem;
    TabEscolher: TTabItem;
    Layout5: TLayout;
    Image1: TImage;
    Layout6: TLayout;
    RoundRect4: TRoundRect;
    edt_cad_nome: TEdit;
    Layout7: TLayout;
    RoundRect5: TRoundRect;
    edt_cad_senha: TEdit;
    Layout8: TLayout;
    rect_conta_proximo: TRoundRect;
    Label2: TLabel;
    Layout9: TLayout;
    RoundRect7: TRoundRect;
    edt_cad_email: TEdit;
    Layout10: TLayout;
    c_foto_editar: TCircle;
    Layout11: TLayout;
    RoundRect8: TRoundRect;
    Label3: TLabel;
    Layout12: TLayout;
    Label4: TLabel;
    img_foto: TImage;
    img_library: TImage;
    img_foto_voltar: TImage;
    Layout13: TLayout;
    Layout14: TLayout;
    img_escolher_voltar: TImage;
    Layout15: TLayout;
    Layout16: TLayout;
    lbl_login_tab: TLabel;
    lbl_login_conta: TLabel;
    Rectangle1: TRectangle;
    ActionList: TActionList;
    ActConta: TChangeTabAction;
    ActEscolher: TChangeTabAction;
    ActFoto: TChangeTabAction;
    ActLogin: TChangeTabAction;
    Layout17: TLayout;
    Layout18: TLayout;
    lbl_conta_login: TLabel;
    Label6: TLabel;
    Rectangle2: TRectangle;
    ActLibrary: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    procedure lbl_login_contaClick(Sender: TObject);
    procedure lbl_conta_loginClick(Sender: TObject);
    procedure rect_conta_proximoClick(Sender: TObject);
    procedure img_foto_voltarClick(Sender: TObject);
    procedure c_foto_editarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_fotoClick(Sender: TObject);
    procedure img_libraryClick(Sender: TObject);
    procedure img_escolher_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    permissao : T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  UnitPrincipal;


{$R *.fmx}

procedure TfrmLogin.ActCameraDidFinishTaking(Image: TBitmap);
begin
    c_foto_editar.Fill.Bitmap.Bitmap := Image;
    ActFoto.Execute;
end;

procedure TfrmLogin.ActLibraryDidFinishTaking(Image: TBitmap);
begin
    c_foto_editar.Fill.Bitmap.Bitmap := Image;
    ActFoto.Execute;
end;

procedure TfrmLogin.c_foto_editarClick(Sender: TObject);
begin
    ActEscolher.Execute;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action   := TCloseAction.caFree;
    frmLogin := nil;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TfrmLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}

begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                          IInterface(FService));

        if (FService <> nil) and
           (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado visivel...
            // (apenas fecha o teclado)
        end
        else
        begin
            // Botao back pressionado e teclado NAO visivel...
            Key := 0;

            if TabControl.ActiveTab = TabConta then
            begin
                ActLogin.Execute
            end
            else if TabControl.ActiveTab = TabFoto then
            begin
                ActConta.Execute
            end
            else if TabControl.ActiveTab = TabEscolher then
            begin
                ActFoto.Execute;
            end
            else if TabControl.ActiveTab = TabLogin then
            begin
                Close;
            end;
        end;
    end;
    {$ENDIF}
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
    TabControl.ActiveTab := TabLogin;
end;

procedure TfrmLogin.TrataErroPermissao(Sender: TObject);
begin
    ShowMessage('Voc� n�o possui permiss�o para acessar esse recurso!');
end;

procedure TfrmLogin.img_escolher_voltarClick(Sender: TObject);
begin
    ActFoto.Execute;
end;

procedure TfrmLogin.img_fotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    ActCamera.Execute;
    {$ELSE}
    permissao.Camera(ActCamera, TrataErroPermissao);
    {$ENDIF}
end;

procedure TfrmLogin.img_foto_voltarClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TfrmLogin.img_libraryClick(Sender: TObject);
begin
    permissao.PhotoLibrary(ActLibrary, TrataErroPermissao);
end;

procedure TfrmLogin.lbl_conta_loginClick(Sender: TObject);
begin
    ActLogin.Execute;
end;

procedure TfrmLogin.lbl_login_contaClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TfrmLogin.rect_conta_proximoClick(Sender: TObject);
begin
    ActFoto.Execute
end;

procedure TfrmLogin.rect_loginClick(Sender: TObject);
begin
    if not Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal,FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    frmLogin.Close;


end;

end.
