unit untPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.TabControl, FMX.Layouts, FMX.MultiView, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Objects, FMX.Edit;

type
  TfrmPrincipal = class(TForm)
    ActionList: TActionList;
    actMain: TChangeTabAction;
    actLancamentos: TChangeTabAction;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Image2: TImage;
    Rectangle3: TRectangle;
    ScrollBox: TVertScrollBox;
    LyAll: TLayout;
    TabControl1: TTabControl;
    tabLogin: TTabItem;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Image1: TImage;
    Label1: TLabel;
    edt_email: TEdit;
    Label2: TLabel;
    edt_senha: TEdit;
    btnAcessar: TButton;
    StyleBook1: TStyleBook;
    tabMain: TTabItem;
    ToolBar3: TToolBar;
    btnMenu: TSpeedButton;
    Rectangle2: TRectangle;
    Label3: TLabel;
    Label4: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    Layout5: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    Layout6: TLayout;
    img_receita: TImage;
    img_despesa: TImage;
    tabLancamentos: TTabItem;
    ListBox2: TListBox;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    Rectangle5: TRectangle;
    Layout7: TLayout;
    Layout8: TLayout;
    Label11: TLabel;
    Label12: TLabel;
    Layout9: TLayout;
    Label13: TLabel;
    Label14: TLabel;
    ToolBar2: TToolBar;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    Rectangle4: TRectangle;
    Label10: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edt_emailKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    //Evita que o teclado virtual esconda o input
    FNeedOffSet: Boolean;
    FKBBounds : TRectF;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses System.Math;

{$R *.fmx}

procedure TfrmPrincipal.btnMenuClick(Sender: TObject);
begin
  actMain.ExecuteTarget(Self);
end;

procedure TfrmPrincipal.btnAcessarClick(Sender: TObject);
begin
  actMain.ExecuteTarget(Self);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  //Evita que o teclado virtual esconda o input
  VKAutoShowMode:= TVKAutoShowMode.Always;
  ScrollBox.OnCalcContentBounds:= CalcContentBoundsProc;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  TabControl1.ActiveTab := tabLogin;
  TabControl1.TabPosition := TTabPosition.None;
end;

procedure TfrmPrincipal.ListBoxItem1Click(Sender: TObject);
begin
  actMain.ExecuteTarget(Self);
  MultiView1.HideMaster;
end;

procedure TfrmPrincipal.ListBoxItem2Click(Sender: TObject);
begin
  actLancamentos.ExecuteTarget(Self);
  MultiView1.HideMaster;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  actMain.ExecuteTarget(Self);
end;

//Evita que o teclado virtual esconda o input
procedure TfrmPrincipal.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfrmPrincipal.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffSet and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,2* ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfrmPrincipal.edt_emailKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
end;

procedure TfrmPrincipal.RestorePosition;
begin
  ScrollBox.ViewportPosition:= PointF(ScrollBox.ViewportPosition.X,0);
  LyAll.Align:= TAlignLayout.Client;
  ScrollBox.RealignContent;
end;

procedure TfrmPrincipal.UpdateKBBounds;
  var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffSet:= False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(ScrollBox.ViewportPosition);
    if (LFocusRect.IntersectsWith(TREctF.Create(FKBBounds))) and (LFocusRect.Bottom > FKBBounds.Top)then
    begin
      FNeedOffSet := True;
      LyAll.Align:= TAlignLayout.Horizontal;
      ScrollBox.RealignContent;
      Application.ProcessMessages;
      ScrollBox.ViewportPosition :=
      PointF(ScrollBox.ViewportPosition.X, LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffSet then RestorePosition;
end;

procedure TfrmPrincipal.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0,0,0,0);
  FNeedOffSet := False;
  RestorePosition;
end;

procedure TfrmPrincipal.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft    := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight:= ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

end.
