unit GitLens.IDE.Toolbars.ImageList;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  ToolsAPI;

type
  TGitLensIDEToolBarsImageList = class
  private
    FImgIndexGitLens: Integer;
    constructor Create;
  public

    class function GetInstance: TGitLensIDEToolBarsImageList;
    property ImgIndexGitLens: Integer read FImgIndexGitLens;
  end;

  var Instance: TGitLensIDEToolBarsImageList;

implementation

uses GitLens.Utils.Git;

{ TGitLensIDEToolBarsImageList }

constructor TGitLensIDEToolBarsImageList.Create;
begin
  FImgIndexGitLens := TGitLensIDEUtils.AddImgIDEResourceName('GitLens1');
end;

class function TGitLensIDEToolBarsImageList.GetInstance: TGitLensIDEToolBarsImageList;
begin
  if(not Assigned(Instance))then
    Instance := Self.Create;
  Result := Instance;
end;

end.
