unit GitLens.IDE.Toolbars.ViewCommits;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Threading,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.ToolWin,
  Vcl.Graphics,
  ToolsAPI;

type
  TGitLensIDEToolBarsViewCommits = class
  private
    FINTAServices: INTAServices;
    FToolBarGitLens: TToolBar;
    FToolButton: TToolButton;
    FLabel: TLabel;
    procedure NewToolBarGitLens;
    procedure RemoveToolBarGitLens;
    procedure AddButtonRefreshGitLens;
    procedure OnGitLensToolButtonCommitsClick(Sender: TObject);
    function GetReferenceToolBar: string;
  protected
  public
    Constructor Create;
    destructor Destroy; override;
  end;

  var GitLensIDEToolBarsViewCommits: TGitLensIDEToolBarsViewCommits;

implementation

uses GitLens.Utils.Git, GitLens.IDE.Toolbars.ImageList, WvN.GitLens;

procedure RegisterSelf;
begin
  if(not Assigned(GitLensIDEToolBarsViewCommits))then
    GitLensIDEToolBarsViewCommits := TGitLensIDEToolBarsViewCommits.Create;
  //GitLensIDEToolBarsViewCommits.ProcessRefreshCaptionLabel;
end;

{ TGitLensIDEToolBarsViewCommits }

procedure TGitLensIDEToolBarsViewCommits.AddButtonRefreshGitLens;
begin
  FToolButton := TToolButton(FToolBarGitLens.FindComponent('GitLens'));
  if(FToolButton <> nil)then
    FToolButton.Free;
  FToolButton := TToolButton.Create(FToolBarGitLens);
  FToolButton.Parent := FToolBarGitLens;
  FToolButton.Caption := 'View Commits';
  FToolButton.Hint := FToolButton.Caption;
  FToolButton.ShowHint := True;
  FToolButton.Name := 'GitLens';
  FToolButton.Style := tbsButton;
  FToolButton.ImageIndex:=  0;
  FToolButton.ImageIndex := TGitLensIDEToolBarsImageList.GetInstance.ImgIndexGitLens;
  FToolButton.Visible := True;
  FToolButton.Left := 0;
  FToolButton.OnClick := OnGitLensToolButtonCommitsClick;
  FToolButton.AutoSize := True;
end;

constructor TGitLensIDEToolBarsViewCommits.Create;
begin
  FINTAServices := TGitLensIDEUtils.GetINTAServices;
  Self.NewToolBarGitLens;
  //Self.ProcessRefreshCaptionLabel;
end;

destructor TGitLensIDEToolBarsViewCommits.Destroy;
begin
  Self.RemoveToolBarGitLens;
  inherited;
end;

function TGitLensIDEToolBarsViewCommits.GetReferenceToolBar: string;
var
  LStandardToolBar: TToolBar;
  LControlBar: TControlBar;
  LControl: TControl;
  i: Integer;
  LBiggerLeft: Integer;
begin
  Result := sBrowserToolbar;
  LStandardToolBar := FINTAServices.ToolBar[sStandardToolBar];
  if(not Assigned(LStandardToolBar))then
    Exit;
  LControlBar := LStandardToolBar.Parent as TControlBar;
  LBiggerLeft := 0;
  for i := 0 to Pred(LControlBar.ControlCount) do
  begin
    LControl := LControlBar.Controls[i];
    if(LControl.Visible)and(LControl.Left > LBiggerLeft)then
    begin
      Result := LControl.Name;
      LBiggerLeft := LControl.Left;
    end;
  end;
end;

procedure TGitLensIDEToolBarsViewCommits.NewToolBarGitLens;
begin
  Self.RemoveToolBarGitLens;
  FToolBarGitLens:= FINTAServices.NewToolbar('GitLens', 'GitLens4Delphi',
                                  Self.GetReferenceToolBar,True);
  FToolBarGitLens.Visible := False;
  FToolBarGitLens.EdgeInner := esNone;
  FToolBarGitLens.EdgeOuter := esNone;
  FToolBarGitLens.Flat := True;
  FToolBarGitLens.Images := TGitLensIDEUtils.GetINTAServices.ImageList;
  FToolBarGitLens.ShowCaptions := True;
  FToolBarGitLens.AutoSize := True;
  FToolBarGitLens.Caption:= 'Git Lens';
  Self.AddButtonRefreshGitLens;
  //Self.AddLabelBranch;
  FToolBarGitLens.Visible := True;//Self.GetVisibleInINI;
end;

procedure TGitLensIDEToolBarsViewCommits.OnGitLensToolButtonCommitsClick(
  Sender: TObject);
begin

  register;
//  FLabel.Caption := '...';
//  FLabel.Repaint;
//  Sleep(200);
  //Self.ProcessRefreshCaptionLabel;
end;

procedure TGitLensIDEToolBarsViewCommits.RemoveToolBarGitLens;

begin
  FToolBarGitLens := FINTAServices.ToolBar['GitLens'];
  if(Assigned(FToolBarGitLens))then
  begin
    for var i := Pred(FToolBarGitLens.ButtonCount) DownTo 0 do
      FToolBarGitLens.Buttons[i].Free;
    FToolBarGitLens.Visible := False;
    if(not TGitLensIDEUtils.CurrentProjectIsGitLens)then
      FreeAndNil(FToolBarGitLens);
  end;
end;

Initialization
  RegisterSelf;

Finalization
  if(Assigned(GitLensIDEToolBarsViewCommits))then
    FreeAndNil(GitLensIDEToolBarsViewCommits);
end.
