function openHTML(Filename)
% Open the specified HTML file in the MATLAB HTML Viewer.
% In locally installed MATLAB, both open and web commands use the HTML Viewer.
% In MATLAB Online, open uses the system web browser while web uses the HTML Viewer.
% The HTML Viewer supports hyperlinks to MATLAB commands (href="matlab:...")
% while the system browsers do not.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  Filename (1,1) string {mustBeFile}
end  % arguments

web(Filename)

end  % function
