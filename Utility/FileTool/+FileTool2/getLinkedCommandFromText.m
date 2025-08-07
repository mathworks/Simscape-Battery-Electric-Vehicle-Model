function Links = getLinkedCommandFromText(TextLines)
% Get hyperlinked MATLAB command from text lines.
%
% This function takes text lines and returns hyperlinked MATLAB commands found in the text.
% A hyplerlinked MATLAB command is a text string starting with "matlab:" in the Markdown hyperlink.
% An example is "command" in the text "[some text](matlab:command)".
%
% This function returns an N-by-2 table containing the Line and Command columns.
% If no command was found, an empty table is returned.
%
% To see what this function returns, just run this function without any arguments.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TextLines (:,1) string = "Default text. [Linked text 1](matlab:command1). Continue: [Linked text 2](matlab:command2('argument2'))."
end  % arguments

arguments (Output)
  Links (:,2) table
end  % arguments

errorID = "getLinkedCommandFromText:";

leftparen_quote_pattern = "(" + ("'"|"""");
quote_rightparen_pattern = ("'"|"""") + ")";
quote_within_parens_pattern = leftparen_quote_pattern + wildcardPattern(0,Inf, "Except",("'"|"""")) + quote_rightparen_pattern;

link_start_pattern = "[" + wildcardPattern(1,Inf, "Except","]") + "](matlab:";
link_end_pattern = ")" + wildcardPattern(1,Inf, "Except",")");

command_pattern = alphanumericsPattern + optionalPattern(quote_within_parens_pattern);

matlab_link_pattern = link_start_pattern + command_pattern + link_end_pattern;

link_line_index = contains(TextLines, matlab_link_pattern);

num_link_lines = nnz(link_line_index);

result = struct("Line",[], "Command",[]);

if num_link_lines == 0
  Links = struct2table(result);

  return

end  % if

link_line_numbers = find(link_line_index == 1);

link_lines = TextLines(link_line_index);

cnt = 1;
for idx = 1 : numel(link_line_numbers)
  target_line = link_lines(idx);

  % Lines containing the links may have different number of links.
  matches = extractBetween(target_line, link_start_pattern, link_end_pattern);

  num_matches = numel(matches);
  if num_matches == 0

    continue

  end  % if
  for j_match = 1 : num_matches
    result(cnt).Line = link_line_numbers(idx);
    result(cnt).Command = matches(j_match);
    cnt = cnt + 1;
  end  % for

  if cnt > 10000
    id = errorID + "TooManyLinkes";
    msg = "There are too many links.";

    throw(MException(id, msg))

  end  % if
end  % for

Links = struct2table(result);

end  % function
