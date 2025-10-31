%[text] # buildReplaceCommandText demo
%[text] Build the list of files to pass to the `buildReplaceCommandText` function.
% Find paths to the "sample*.txt" files.
file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**", "sample*.txt")).paths';

% Remove paths that are out side of the "SearchTool > Test > buildReplaceCommandText" folder.
logical_index = contains(file_paths, ("/"|"\") + "SearchTool" + ("/"|"\") + "Test" + ("/"|"\") + "buildReplaceCommandText");
file_paths = file_paths(logical_index);

assert(numel(file_paths) > 0)

file_paths = extractAfter(file_paths, pwd + ("/"|"\"));

disp(file_paths) %[output:68dea77f]
% FYI
type(file_paths(1)) %[output:4a90ba9d]
%[text] Run the `buildReplaceCommandText` function. The `TextPattern` option can take a pattern to search and match text. (The corresponding apps can take normal text only, i.e., they do not suport pattern.)
command_text = SearchTool1.buildReplaceCommandText( ...
  FilePaths = file_paths, ...
  TextPattern = alphanumericBoundary + ("cat"|"night") + alphanumericBoundary, ...
  IgnoreCase = true, ...
  MatchWholeWord = false, ...
  NewText = "NewText");

disp(command_text) %[output:09a40ee6]
%[text] The generated command text can be evaluated to run it. In this demo, run it in the dry run mode to avoid actually performing text replacement.
sp = optionalPattern(whitespacePattern);
assert(contains(command_text, "DryRun" +sp+ "=" +sp+ "true" +sp+ ","))
evalin("base", command_text) %[output:7b592446]
disp(result_table) %[output:7332c9f3]
%[text] 0 in the `NumLines` column indicates that there were no lines containing the specified text pattern.
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:68dea77f]
%   data: {"dataType":"text","outputData":{"text":"    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 1.txt\"\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 2.txt\"\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 11.txt\"\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 12.txt\"\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 21.txt\"\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 22.txt\"\n\n","truncated":false}}
%---
%[output:4a90ba9d]
%   data: {"dataType":"text","outputData":{"text":"\nThis is a sample file for testing.\nThe contents of this file may be modified programmatically.\n\nrandom words... dog, cat, bird, fish\n","truncated":false}}
%---
%[output:09a40ee6]
%   data: {"dataType":"text","outputData":{"text":"% Target files for text replacement\nfile_paths = [\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 1.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 2.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 11.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 12.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 21.txt\"\n  \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 22.txt\"\n  ];\n\n% By default, running the command below does not do text replacement due to the DryRun=true option, and\n% the returned table contains a list of potential replacement occurrences for each file.\n% Use DryRun=false for performing text replacement.\nresult_table = SearchTool1.replaceText( ...\n  file_paths, ...\n  DryRun = true, ...\n  TextPattern = (alphanumericBoundary + (\"cat\" | \"night\") + alphanumericBoundary), ...\n  IgnoreCase = true, ...\n  MatchWholeWord = false, ...\n  NewText = \"NewText\");\n\n","truncated":false}}
%---
%[output:7b592446]
%   data: {"dataType":"text","outputData":{"text":"replaceText: dry run\n","truncated":false}}
%---
%[output:7332c9f3]
%   data: {"dataType":"text","outputData":{"text":"                                              <strong>FilePaths<\/strong>                                               <strong>NumLines<\/strong>\n    <strong>______________________________________________________________________________________________<\/strong>    <strong>________<\/strong>\n\n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 1.txt\"                    1    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\sample file 2.txt\"                    0    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 11.txt\"       0    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 1\\sample file 12.txt\"       0    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 21.txt\"        0    \n    \"Utility\\SearchTool\\Test\\buildReplaceCommandText\\sample folder\\subfolder 2\\samplefile 22.txt\"        1    \n\n","truncated":false}}
%---
