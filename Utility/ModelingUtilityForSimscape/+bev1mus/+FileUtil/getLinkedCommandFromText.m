function Result = getLinkedCommandFromText(TextLines, NameValuePair)
% Get hyperlinked MATLAB command from text.
%
% This function takes text and returns hyperlinked MATLAB commands found in the text.
% A hyplerlinked MATLAB command is a text string starting with "matlab:" in the Markdown style.
% An example is "command" in the following texts.
%   "[some text](matlab:command)"
%   "[some text](<matlab:command>)"
%
% This function returns an N-by-3 table containing the Line, LinkText, and Command columns.
% If no MATLAB command was found in the text, an empty table is returned.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  TextLines (:,1) string

  % This function errors out if there are more links than MaxLinks.
  NameValuePair.MaxLinks (1,1) {mustBeInteger, mustBePositive} = 100

end  % arguments

arguments (Output)
  Result (:,3) table
end  % arguments

errorID = "getLinkedCommandFromText:";

lines = strip( splitlines(TextLines));

% A hyperlink with matlab command
%   [some text](matlab:
%   [some text](<matlab:
link_start_pattern = "[" + wildcardPattern(Except="]") + "](" + optionalPattern("<") + "matlab:";

%   [some text](matlab:some_command)
%   [some text](<matlab:some_command>)
command_pattern_1 = link_start_pattern + alphanumericsPattern + optionalPattern(">") + ")";

%   [some text](matlab:some_command(some_argument))
%   [some text](<matlab:some_command(some_argument)>)
command_pattern_2 = link_start_pattern + alphanumericsPattern + "(" + wildcardPattern(Except=("("|")")) + ")" + optionalPattern(">") + ")";

max_links = NameValuePair.MaxLinks;

Line = nan(max_links, 1);
LinkText = strings(max_links, 1);
Command = strings(max_links, 1);

data_count = 0;
for line_number = 1 : numel(lines)
  target_line = lines(line_number);

  if contains(target_line, command_pattern_1 | command_pattern_2)
    commands_text = extract(target_line, command_pattern_1 | command_pattern_2);

    for jj = 1 : numel(commands_text)
      data_count = data_count + 1;
      Line(data_count) = line_number;
      LinkText(data_count) = extractBetween(commands_text(jj), lineBoundary("start")+"[", "](" + optionalPattern("<") + "matlab:");
      Command(data_count) = extractBetween(commands_text(jj), "](" + optionalPattern("<") + "matlab:", optionalPattern(">") + ")"+lineBoundary("end"));
    end  % for

  end  % if

  if data_count > max_links
    id = errorID + "TooManyLinks";
    msg = bev1mus.CodeUtil.i18n("There are too many links in the specified text.");

    throw(MException(id, msg))

  end  % if
end  % for

Line(data_count+1:end) = [];
LinkText(data_count+1:end) = [];
Command(data_count+1:end) = [];

Result = table(Line, LinkText, Command);
return  % function
