function Result = checkEditInCode(CodeText, NameValuePair)
% Check the argument of the edit command in code text.
%
% This function checks if the given text contains code using the edit commands
% in the following styles.
%
%   edit("<target_name>")
%   edit('<target_name>')
%
% This function returns a table with rows indicating if <target_name> is actually
% referring to an existing file.
%
% Notes
%
% - This function assumes that, if a code line contains the edit command,
%   the line starts with the command, and there is one edit command in one line.
%   (This function removes leading spaces from each line before checking.)
%
% - The argument passed to the edit command must be a straight forward quoted word,
%   like "<target_names>", as shown above.
%
% - Code text can contain multiple edit commands.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  CodeText (:,1) string
  NameValuePair.DisplayInfo (1,1) logical = false
  NameValuePair.MaxThreshold (1,1) {mustBeInteger, mustBePositive} = 100
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "checkEditInCode:";

max_threshold = NameValuePair.MaxThreshold;

ArgumentPassedToEdit = strings(max_threshold, 1);
Found = false(max_threshold, 1);

lines = CodeUtil1.cleanupCodeText(CodeText);
if isempty(lines)
  id = errorID + "EmptyCode";
  msg = CodeUtil1.i18n("Code must not be empty.");

  throw(MException(id, msg))

end  % if

logical_index = startsWith(lines, lineBoundary("start") + "edit(");

lines = lines(logical_index);
% At this point, all lines have the edit command.

num_lines = numel(lines);

ospace = optionalPattern(whitespacePattern);
target_names = extractBetween(lines, "edit("+ospace+(""""|"'"), (""""|"'")+ospace+")");

for ii = 1 : num_lines
  if ii > max_threshold
    id = errorID + "TooMany";
    msg = CodeUtil1.i18n("There are too many target code lines to process.");

    throw(MException(id, msg))

  end  % if

  if NameValuePair.DisplayInfo
    disp("Checking code [" + ii + "]: " + lines(ii))
  end  % if

  ArgumentPassedToEdit(ii) = target_names(ii);

  target_fullpath = string( which(target_names(ii)));

  if target_fullpath == ""
    Found(ii) = false;
  else
    Found(ii) = true;
  end  % if
end  % for

ArgumentPassedToEdit(num_lines+1 : end) = [];
Found(num_lines+1 : end) = [];

Result = table(ArgumentPassedToEdit, Found);

end  % function
