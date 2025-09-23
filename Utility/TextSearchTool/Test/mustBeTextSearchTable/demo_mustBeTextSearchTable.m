%[text] # mustBeTextSearchTable demo
%[text] The "mustBe" functions are designed to be used as constraints in the Function Argument Validation. The way this script uses the function is not a typical way of using it.
%[text] Ok case
tst = TextSearchTool1.newTextSearchTable;
TextSearchTool1.mustBeTextSearchTable(tst)
%[text] Error case
try %[output:group:14e59a21]
  TextSearchTool1.mustBeTextSearchTable(table)
catch exception
  disp(exception.message) %[output:664311e0]
end  % end %[output:group:14e59a21]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:664311e0]
%   data: {"dataType":"text","outputData":{"text":"Table must be text search table.\n","truncated":false}}
%---
