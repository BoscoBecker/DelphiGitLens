unit GitLens.Utils.Git;

interface

uses ToolsAPI, System.SysUtils,Vcl.Graphics, dialogs;

type
  TGitLensIDEUtils = class
    public
      class function GetINTAServices: INTAServices;
      class function GetIOTAModuleServices: IOTAModuleServices;
      class function TGitLensCurrentProjectIsGitLensDPROJ: Boolean;
      class function CurrentProjectIsGitlens: Boolean;
      class function FileNameIsGItlensDPROJ(const AFileName: string): Boolean;
      class function GetCurrentProject: IOTAProject;
      class function GetCurrentProjectGroup: IOTAProjectGroup;
      class function AddImgIDEResourceName(AResourceName: string): Integer;
  end;

implementation

{ TGitLensIDEUtils }


class function TGitLensIDEUtils.AddImgIDEResourceName(AResourceName: string): Integer;
var
  LBitmap: TBitmap;
  LMaskColor: TColor;
begin
  Result := -1;
  if(FindResource(hInstance, PChar(AResourceName), '') <= 0)then  Exit;

  LBitmap := TBitmap.Create;
  try
    try
      LBitmap.LoadFromResourceName(hInstance, AResourceName);
      {$IF CompilerVersion = 35} //Alexandria
        LMaskColor := clLime;
      {$ELSE}
        LMaskColor := LBitmap.TransparentColor;
      {$ENDIF}
      Result := TGitLensIDEUtils.GetINTAServices.AddMasked(LBitmap, LMaskColor); //, AResourceName
    except
      on E: Exception do
      Showmessage('Erro: ' + E.Message);
    end;
  finally
    LBitmap.Free;
  end;
end;
class function TGitLensIDEUtils.CurrentProjectIsGitlens: Boolean;
var
  LIOTAProject: IOTAProject;
begin
  Result := False;
  LIOTAProject := Self.GetCurrentProject;
  if(LIOTAProject = nil)then Exit;
  Result := Self.FileNameIsGItlensDPROJ(LIOTAProject.FileName);
end;

class function TGitLensIDEUtils.FileNameIsGItlensDPROJ(const AFileName: string): Boolean;
begin
  Result := ExtractFileName(AFileName) = 'WvNGitLens.dproj';
end;

class function TGitLensIDEUtils.GetCurrentProject: IOTAProject;
var
  LIOTAProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  LIOTAProjectGroup := Self.GetCurrentProjectGroup;
  if(not Assigned(LIOTAProjectGroup))then
    Exit;
  try
    Result := LIOTAProjectGroup.ActiveProject;
  except
    ;
  end;
end;

class function TGitLensIDEUtils.GetCurrentProjectGroup: IOTAProjectGroup;
begin
  Result := Self.GetIOTAModuleServices.MainProjectGroup;
end;

class function TGitLensIDEUtils.GetINTAServices: INTAServices;
begin
  if(not Supports(BorlandIDEServices, INTAServices, Result))then
    raise Exception.Create('Interface not supported: INTAServices');
end;

class function TGitLensIDEUtils.GetIOTAModuleServices: IOTAModuleServices;
begin
  if(not Supports(BorlandIDEServices, IOTAModuleServices, Result))then
    raise Exception.Create('Interface not supported: IOTAModuleServices');
end;

class function TGitLensIDEUtils.TGitLensCurrentProjectIsGitLensDPROJ: Boolean;
var
  LIOTAProject: IOTAProject;
begin
  Result := False;
  LIOTAProject := Self.GetCurrentProject;
  if(LIOTAProject = nil)then Exit;
  Result := Self.FileNameIsGItlensDPROJ(LIOTAProject.FileName);
end;

end.
