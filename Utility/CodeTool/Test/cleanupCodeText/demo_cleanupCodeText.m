%[text] # cleanupCodeText demo
%[text] Code text as a scalar string.
code_text = "% comment" + newline + "" + newline + "code line";
disp(code_text) %[output:662989de]
result = CodeTool1.cleanupCodeText(code_text);
disp(result) %[output:7e191209]
%%
%[text] Code text as a vector of code lines.
code_text = [
  "% comment"
  ""
  "code line"
  ];
result = CodeTool1.cleanupCodeText(code_text);
disp(result) %[output:7fead28f]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:662989de]
%   data: {"dataType":"text","outputData":{"text":"% comment\n\ncode line\n","truncated":false}}
%---
%[output:7e191209]
%   data: {"dataType":"text","outputData":{"text":"code line\n","truncated":false}}
%---
%[output:7fead28f]
%   data: {"dataType":"text","outputData":{"text":"code line\n","truncated":false}}
%---
