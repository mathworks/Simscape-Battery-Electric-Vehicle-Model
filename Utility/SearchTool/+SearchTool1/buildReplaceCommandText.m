function CommandText = buildReplaceCommandText(NameValuePair)

% Build commands like below and copy as text to the system clipboard.
%   file_paths = [
%     "/path/to/file1"
%     "/path/to/file2"
%     ];
%   result = SearchTool1.replaceText( ...
%     file_paths, ...
%     DryRun = true, ...
%     TextPattern = "old",
%     IgnoreCase = true, ...
%     MatchWholeWord = false, ...
%     NewText = "new");
%   disp(result)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.FilePaths (:,1) string {mustBeFile}

  NameValuePair.TextPattern (1,1) pattern
  NameValuePair.IgnoreCase (1,1) logical
  NameValuePair.MatchWholeWord (1,1) logical

  NameValuePair.NewText (1,1) string

  NameValuePair.CommandName (1,1) string = "SearchTool1.replaceText"
end  % arguments

arguments (Output)
  CommandText (1,1) string
end  % arguments

errorID = "buildReplaceCommandText:";

if not(isfield(NameValuePair, "FilePaths"))
  id = errorID + "MissingFilePaths";
  msg = CodeTool1.i18n("FilePaths must be specified.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "TextPattern"))
  id = errorID + "MissingTextPattern";
  msg = CodeTool1.i18n("TextPattern must be specified.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "IgnoreCase"))
  id = errorID + "MissingIgnoreCase";
  msg = CodeTool1.i18n("IgnoreCase must be specified.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "MatchWholeWord"))
  id = errorID + "MissingMatchWholeWord";
  msg = CodeTool1.i18n("MatchWholeWord must be specified.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "NewText"))
  id = errorID + "MissingNewText";
  msg = CodeTool1.i18n("NewText must be specified.");

  throw(MException(id, msg))

end  % if

if isempty(which(NameValuePair.CommandName))
  id = errorID + "InvalidCommandName";
  msg = CodeTool1.i18n("The command specified for CommandName must be on MATLAB path: ") + NameValuePair.CommandName;

  throw(MException(id, msg))

end  % if

% -----------------------------------------------------------------------------

pat_str = string(NameValuePair.TextPattern);
if pat_str == ""
  id = errorID + "InvalidTextPattern";
  msg = CodeTool1.i18n("TextPattern must be non-empty.");

  throw(MException(id, msg))

end  % if

new_text = NameValuePair.NewText;
if new_text == ""
  id = errorID + "InvalidNewText";
  msg = CodeTool1.i18n("NewText must be non-empty.");

  throw(MException(id, msg))

end  % if

code_lines = [
  "% Target files for text replacement"
  "file_paths = ["
  "  """ + unique(NameValuePair.FilePaths) + """"
  "  ];"
  ""
  "% By default, running the command below does not do text replacement"
  "% because of the DryRun=true option."
  "% The returned table contains a list of potential replacements for each file."
  "% Use DryRun=false for performing text replacement."
  "result_table = " + NameValuePair.CommandName + "( ..."
  "  file_paths, ..."
  "  DryRun = true, ..."
  "  TextPattern = (" + pat_str + "), ..."
  "  IgnoreCase = " + NameValuePair.IgnoreCase + ", ..."
  "  MatchWholeWord = " + NameValuePair.MatchWholeWord + ", ..."
  "  NewText = """ + new_text + """);"
  ""
  "disp(result_table)"
  ];

CommandText = join(code_lines, newline);
end  % function
