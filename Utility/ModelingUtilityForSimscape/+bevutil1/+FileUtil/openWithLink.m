function openWithLink(TargetName)
% Open a file, an app, or a Simulink model with a hyperlink in Command Window.
%
% The target name must be a valid name for MATLAB as a file on the MATLAB path.
% This function provides visual feedback with a hyperlink to the target on
% the Command Window.
%
% This is a wrapper function for the open command to open a MATLAB code file,
% an app, or a Simulink model file.
% https://uk.mathworks.com/help/matlab/ref/open.html
%
% To open an HTML document, use the web command because web uses the MATLAB Web Browser
% which supports the "matlab:" directive in hyperlinks.
% The open command opens an HTML file in the system browser which does not support
% the "matlab:" directive.
% https://uk.mathworks.com/help/matlab/ref/web.html

% Copyright 2026 The MathWorks, inc.

arguments (Input)
  TargetName (1,1) string {mustBeNonzeroLengthText}
end  % arguments

% Proper error handling is done by the open command.
try
  open(TargetName);
catch exception

  rethrow(exception)

end  % try, catch

% Show the link only when there was no error in opening the target.
disp("Opened: <a href=""matlab:open('" + TargetName + "')"">" + TargetName + "</a>")

end  % function
