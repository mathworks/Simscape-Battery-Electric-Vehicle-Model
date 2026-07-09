function openInProject(TargetName)
% Open a file, an app, or a Simulink model in the current MATLAB project.
%
% Before opening the specified target, this function checks that a MATLAB project is open.
% If a MATLAB project is not open, this function issues an error and does not open the specified target.
% Use this function to make sure that project paths are loaded for the target to work.
% This function does not check what specific MATLAB project is open.
%
% This is a wrapper function for the open command to open a MATLAB code file,
% an app, or a Simulink model file.
%
% This function provides visual feedback with a hyperlink to the target on
% the Command Window.
%
% To open an HTML document, use the web command instead of this function because
% the web command uses the MATLAB Web Browser which supports the "matlab:" directive
% in hyperlinks. The open command opens an HTML file in the system browser which
% does not support the "matlab:" directive.

% Copyright 2021-2026 The MathWorks, inc.

arguments (Input)
  TargetName (1,1) string {mustBeNonzeroLengthText}
end  % arguments

errorID = "openInProject:";

if isempty(matlab.project.rootProject)
  id = errorID + "NoProjectIsOpen";
  msg = bev1mus.CodeUtil.i18n("A MATLAB project must be open.");

  throw(MException(id, msg))

end  % if

bev1mus.FileUtil.openWithLink(TargetName)

end  % function
