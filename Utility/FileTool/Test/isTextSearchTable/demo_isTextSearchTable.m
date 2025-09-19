%[text] # isTextSearchTable demo
%[text] The function checks if the passed table is a table created by the `newTextSearchTable` function. The function checks the size of the table, the properties, and the custom properties.
tst = FileTool3.newTextSearchTable;
disp(FileTool3.isTextSearchTable(tst)) %[output:0d0c1c95]
disp(FileTool3.isTextSearchTable(table)) %[output:561d378f]
disp(FileTool3.isTextSearchTable(table([], [], []))) %[output:302b59ce]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:0d0c1c95]
%   data: {"dataType":"text","outputData":{"text":"   1\n\n","truncated":false}}
%---
%[output:561d378f]
%   data: {"dataType":"text","outputData":{"text":"   0\n\n","truncated":false}}
%---
%[output:302b59ce]
%   data: {"dataType":"text","outputData":{"text":"   0\n\n","truncated":false}}
%---
