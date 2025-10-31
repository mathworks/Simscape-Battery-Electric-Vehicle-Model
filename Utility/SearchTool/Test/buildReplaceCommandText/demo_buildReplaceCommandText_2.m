%[text] # buildReplaceCommandText demo
%[text] Use the `searchText` function to find files.
text_pattern = alphanumericBoundary + ("cat"|"night") + alphanumericBoundary;

search_session = SearchTool1.searchText( ...
  text_pattern, ...
  IgnoreCase = true, ...
  MatchWholeWord = false, ...
  FileTypes = "sample*.txt", ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true);

assert(not(isempty(search_session.Result)))

states = search_session.Searcher.States;

file_paths = search_session.Result.FilePath;

command_text = SearchTool1.buildReplaceCommandText( ...
  FilePaths = file_paths, ...
  TextPattern = text_pattern, ...
  IgnoreCase = states.IgnoreCase, ...
  MatchWholeWord = states.MatchWholeWord, ...
  NewText = "NewText");

disp(command_text) %[output:3d8387b4]
sp = optionalPattern(whitespacePattern);
assert(contains(command_text, "DryRun" +sp+ "=" +sp+ "true" +sp+ ","))
evalin("base", command_text) %[output:9e76a9af]
disp(result_table) %[output:9721286c]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:3d8387b4]
%   data: {"dataType":"text","outputData":{"text":"% Target files for text replacement\nfile_paths = [\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 1.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 22.txt\"\n  \"Utility\\SearchTool\\Test\\replaceText\\sample folder\\sample file 1.txt\"\n  \"Utility\\SearchTool\\Test\\replaceText\\sample folder\\subfolder 2\\samplefile 22.txt\"\n  \"Utility\\SearchTool\\Test\\searchAndReplaceText\\sample folder\\sample file 1.txt\"\n  \"Utility\\SearchTool\\Test\\searchAndReplaceText\\sample folder\\subfolder 2\\samplefile 22.txt\"\n  ];\n\n% By default, running the command below does not do text replacement due to the DryRun=true option, and\n% the returned table contains a list of potential replacement occurrences for each file.\n% Use DryRun=false for performing text replacement.\nresult_table = SearchTool1.replaceText( ...\n  file_paths, ...\n  DryRun = true, ...\n  TextPattern = (alphanumericBoundary + (\"cat\" | \"night\") + alphanumericBoundary), ...\n  IgnoreCase = true, ...\n  MatchWholeWord = false, ...\n  NewText = \"NewText\");\n\n","truncated":false}}
%---
%[output:9e76a9af]
%   data: {"dataType":"text","outputData":{"text":"replaceText: dry run\n","truncated":false}}
%---
%[output:9721286c]
%   data: {"dataType":"text","outputData":{"text":"                                              <strong>FilePaths<\/strong>                                              <strong>NumLines<\/strong>\n    <strong>_____________________________________________________________________________________________<\/strong>    <strong>________<\/strong>\n\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 1.txt\"                   1    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 22.txt\"       1    \n    \"Utility\\SearchTool\\Test\\replaceText\\sample folder\\sample file 1.txt\"                               1    \n    \"Utility\\SearchTool\\Test\\replaceText\\sample folder\\subfolder 2\\samplefile 22.txt\"                   1    \n    \"Utility\\SearchTool\\Test\\searchAndReplaceText\\sample folder\\sample file 1.txt\"                      1    \n    \"Utility\\SearchTool\\Test\\searchAndReplaceText\\sample folder\\subfolder 2\\samplefile 22.txt\"          1    \n\n","truncated":false}}
%---
