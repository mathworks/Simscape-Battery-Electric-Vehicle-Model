% Open HTML file in the MATLAB HTML Viewer.
%
% In locally installed MATLAB, both open and web commands use the HTML Viewer.
% In MATLAB Online, open uses the system web browser while web uses the HTML Viewer.
% The HTML Viewer supports hyperlinks to MATLAB commands (href="matlab:...")
% while the system browsers do not.

% Copyright 2026 The MathWorks, Inc.

% !todo: Use web, ocne the issue is resolved.
% In MATLAB Online, the web command attempts to use the HTML Viewer, but
% the page can be empty there. For now, use the open command.
% The page opens in a new tab in the system web browser.
open("BEVProject_Description.html")
% web("BEVProject_Description.html")
