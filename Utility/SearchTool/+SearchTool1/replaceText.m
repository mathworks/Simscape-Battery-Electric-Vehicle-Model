function NumLines = replaceText(FilePath, NameValuePair)
% Replace text in the specified file.
%
% This function takes a path to the target file, text pattern to search, and
% new text to replace. The function returns the number of lines that contains
% the search text.
%
% Required options ------------------------------------------------------------
%
% TextPattern
%
% - Pattern to search. See the documentation for details.
%   https://uk.mathworks.com/help/matlab/ref/pattern.html
%
% NewText
%
% - Text to replace the search text. This is ignored if DryRun is true.
%
% Additional options ----------------------------------------------------------
%
% DryRun
%
% - true or false. Set to true to avoid replacing operation.
%   The function still returns the number of lines that contains the search text.
%
% IgnoreCase, MatchWholeWord
%
% - true or false. These options are applied to TextPattern.
%   You can leave these options false and use TextPattern only.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  FilePath (:,1) string {mustBeFile}

  NameValuePair.DryRun (1,1) logical = false

  NameValuePair.TextPattern (:,1) pattern
  NameValuePair.IgnoreCase (1,1) logical = false
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.NewText (:,1) string

end  % arguments

arguments (Output)
  NumLines (1,1) {mustBeInteger, mustBeNonnegative}
end  % arguments

errorID = "replaceText:";

if not(isfield(NameValuePair, "TextPattern"))
  id = errorID + "InvalidTextPattern";
  msg = CodeTool1.i18n("Text pattern must be specified.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "NewText"))
  id = errorID + "InvalidNewText";
  msg = CodeTool1.i18n("New text must be specified.");

  throw(MException(id, msg))

end  % if

target_file = FilePath;

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
