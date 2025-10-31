function Result = replaceText(FilePaths, NameValuePair)
% Replace text in the specified file.
%
% This function takes paths to the target files, a text pattern to search, and
% a new text to replace. The function returns a table containing file paths
% and the number of lines containing the searched text.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  FilePaths (:,1) string {mustBeFile}

  % DryRun=true prevents this function from actually replacing the text.
  NameValuePair.DryRun (1,1) logical = true

  % Pattern to search. See the documentation for details.
  % https://uk.mathworks.com/help/matlab/ref/pattern.html
  NameValuePair.TextPattern (:,1) pattern
  NameValuePair.IgnoreCase (1,1) logical = false
  NameValuePair.MatchWholeWord (1,1) logical = false

  % Text to replace the search text. This is ignored if DryRun is true.
  NameValuePair.NewText (:,1) string
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "replaceText:";

if NameValuePair.DryRun
  disp(errorID + " dry run")
end  % if

num_files = numel(FilePaths);
if num_files == 0
  id = errorID + "InvalidFilePaths";
  msg = CodeTool1.i18n("One or more files must be specified.");

  throw(MException(id, msg))

end  % if

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

NumLines = nan(num_files, 1);
for ii = 1 : num_files
  target_file = FilePaths(ii);
  lines = readlines(target_file);
  logical_index = contains(lines, search_text);
  NumLines(ii) = nnz(logical_index);
  if NameValuePair.DryRun

    continue

  end  % if
  edited_lines = replace(lines, search_text, NameValuePair.NewText);
  writelines(edited_lines, target_file)
end  % for
Result = table(FilePaths, NumLines);
end  % function
