%[text] # newTextSearchTable demo
%[text] The function returns an empty table which is configured to store the search text result.
tstable = TextSearchTool1.newTextSearchTable;
disp(tstable) %[output:1eb2c4ac]
%[text] The returned table has custom properties whose values are empty at first.
disp(tstable.Properties.CustomProperties) %[output:63ba3048]
%%
%[text] The function takes three arguments. The first and third arguments must be of type string. The second argument must be positive integer. They must have the same number of elements.
tstable = TextSearchTool1.newTextSearchTable(["path1"; "path2"], [2; 4], ["text1"; "text2"]);
disp(tstable) %[output:0d2164cc]
%[text] Custom properties are empty unless they are explicitly set up.
disp(tstable.Properties.CustomProperties) %[output:4350f795]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:1eb2c4ac]
%   data: {"dataType":"text","outputData":{"text":"    <strong>FilePath<\/strong>    <strong>LineNumber<\/strong>    <strong>LineText<\/strong>\n    <strong>________<\/strong>    <strong>__________<\/strong>    <strong>________<\/strong>\n\n\n","truncated":false}}
%---
%[output:63ba3048]
%   data: {"dataType":"text","outputData":{"text":"<a href=\"matlab:helpPopup('matlab.tabular.CustomProperties')\" style=\"font-weight:bold\">CustomProperties<\/a> with properties:\n\n         TargetFolder: \"\"\n    IncludeSubfolders: 0\n      FileTypesString: \"*.m, *.mdl\"\n    TextPatternString: \"Copyright\"\n           IgnoreCase: 1\n       MatchWholeWord: 0\n\n","truncated":false}}
%---
%[output:0d2164cc]
%   data: {"dataType":"text","outputData":{"text":"    <strong>FilePath<\/strong>    <strong>LineNumber<\/strong>    <strong>LineText<\/strong>\n    <strong>________<\/strong>    <strong>__________<\/strong>    <strong>________<\/strong>\n\n    \"path1\"         2         \"text1\" \n    \"path2\"         4         \"text2\" \n\n","truncated":false}}
%---
%[output:4350f795]
%   data: {"dataType":"text","outputData":{"text":"<a href=\"matlab:helpPopup('matlab.tabular.CustomProperties')\" style=\"font-weight:bold\">CustomProperties<\/a> with properties:\n\n         TargetFolder: \"\"\n    IncludeSubfolders: 0\n      FileTypesString: \"*.m, *.mdl\"\n    TextPatternString: \"Copyright\"\n           IgnoreCase: 1\n       MatchWholeWord: 0\n\n","truncated":false}}
%---
