function NumLines = replaceText(NameValuePair)
% Replace text in the specified file.
%
% Options
%
% DryRun
%
% - Set DryRun to true to avoid replacing operation.
%   This function returns the number of lines that contains the search text.
%
% FilePath
%
% - A path string to the target file.
%
% TextPattern
%
% - Pattern to search. See the documentation for details.
%   https://uk.mathworks.com/help/matlab/ref/pattern.html
%
% IgnoreCase, MatchWholeWord
%
% - true or false. These options are applied to TextPattern.
%   You can leave these options false and use TextPattern only.
%
% NewText
%
% - Text to replace the search text. This is ignored if DryRun is true.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  NameValuePair.DryRun (1,1) logical = true

  NameValuePair.FilePath (:,1) string {mustBeFile}

  NameValuePair.TextPattern (1,1) pattern = "Copyright"
  NameValuePair.IgnoreCase (1,1) logical = false
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.NewText (1,1) string = ""

end  % arguments

arguments (Output)
  NumLines (1,1) {mustBeInteger, mustBeNonnegative}
end  % arguments

target_file = NameValuePair.FilePath;

if NameValuePair.IgnoreCase
  pat = caseInsensitivePattern(NameValuePair.TextPattern);
else
  pat = caseSensitivePattern(NameValuePair.TextPattern);
end  % if

if NameValuePair.MatchWholeWord
  b = (lineBoundary|textBoundary|whitespaceBoundary);
  search_text = b + pat + b;
else
  search_text = pat;
end  % if

lines = readlines(target_file);

logical_index = contains(lines, search_text);
NumLines = nnz(logical_index);

if NameValuePair.DryRun

  return

end  % if

edited_lines = replace(lines, search_text, NameValuePair.NewText);

writelines(edited_lines, target_file)

end  % function
