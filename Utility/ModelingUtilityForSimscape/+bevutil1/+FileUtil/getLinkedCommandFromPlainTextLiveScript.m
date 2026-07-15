function Links = getLinkedCommandFromPlainTextLiveScript(FileName)
% Get hyperlinked MATLAB commands from a plain-text Live Script.
%
% Plain-text Live Scripts can have hyperlinks that are MATLAB commands.
% An example is "command" in the text
%   "[some text](matlab:command)"
% or
%   "[some text](<matlab:command>)"
% where "some text" is rendered with a hyperlink "command" which
% is passed to MATLAB when the link is clicked.
%
% This function uses the getLinkedCommandFromText function, which
% has more descriptions.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  FileName (1,1) string {bevutil1.FileUtil.mustBePlainTextLiveScript}
end  % arguments

arguments (Output)
  Links (:,3) table
end  % arguments

script_lines = readlines(FileName);

logical_index = contains(script_lines, lineBoundary("start") + "%[appendix]");

assert(nnz(logical_index) == 1);

appendix_line = find(logical_index == 1);

% Remove the appendix.
script_lines = script_lines(1 : appendix_line-1);

text_line_index = contains(script_lines, lineBoundary("start") + "%[text]");

% Erase lines that are not starting with the %[text] directive.
% This operation erases line contents, i.e., it does not delete the line.
script_lines(~text_line_index) = "";

Links = bevutil1.FileUtil.getLinkedCommandFromText(script_lines);

end  % function
