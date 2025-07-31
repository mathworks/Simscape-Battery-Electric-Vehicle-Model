function Links = getLinkedCommandFromPlainTextLiveScript(FileName)
%% Get hyperlinked MATLAB command from a plain-text Live Script.

arguments (Input)
  FileName (1,1) string {FileTool1.mustBePlainTextLiveScript}
end  % arguments

arguments (Output)
  Links (:,2) table
end  % arguments

script_lines = readlines(FileName);

logical_index = contains(script_lines, lineBoundary("start") + "%[appendix]");

assert(nnz(logical_index) == 1);

appendix_line = find(logical_index == 1);

% disp("Appendix starts at line " + appendix_line)

% Remove the appendix.
script_lines = script_lines(1 : appendix_line-1);

text_line_index = contains(script_lines, lineBoundary("start") + "%[text]");

% Erase lines that are not starting with the %[text] directive.
script_lines(~text_line_index) = "";

Links = FileTool1.getLinkedCommandFromText(script_lines);

end  % function
