function Result = checkWebLocalHTMLInText(CodeText)
% Check that local HTML files used in the web command exist.
%
% This function takes text containing MATLAB code and checks if there are the web commands.
% If yes, the function checks if the URL passed to the web command is a local HTML file
% and it exists. The result is returned in a table.
%
% If there are no web commands found, the function returns an empty table.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  CodeText (:,1) string = ""
end  % arguments

arguments (Output)
  Result table
end  % arguments

CodeLine = strip(split(CodeText, newline));

% Replace comment lines with empty lines.
CodeLine = erase(CodeLine, lineBoundary("start") + "%" + wildcardPattern + lineBoundary("end"));

logical_index = matches(CodeLine, wildcardPattern + "web(""" + wildcardPattern + ".html"")" + wildcardPattern);

if not(any(logical_index))
  Result = table.empty;

  return

end  % if

LineNumber = find(logical_index);
num_files = numel(LineNumber);
CodeLine = CodeLine(logical_index);
URL = extractBetween(CodeLine, "web(""", """)");
IsLocal = false(num_files, 1);
for ii = 1 : num_files
  target_html = URL(ii);

  fullpath = string( which(target_html));
  if fullpath == ""
    IsLocal(ii) = false;
  else
    if startsWith(target_html, "http")
      IsLocal(ii) = false;
    else
      IsLocal(ii) = true;
    end  % if
  end  % if
end  % for
Result = table(LineNumber, URL, IsLocal, CodeLine);
end  % function
