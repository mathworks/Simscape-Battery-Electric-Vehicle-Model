%[text] # checkWebLocalHTMLInText demo
% Code text in multiple lines.
code_text = [
  "% This line is ignored."
  "web(""http:dummy.com/index.html"")"
  "  callback1 = @() web(""https:dummy.com/index.html"");"
  "  txt = ""web(""""dummy.html"""")"";  % This line is ignored."
  "  callback2 = @() web(""testhtml_checkWebLocalHTMLInText.html"");"
  ];
result = CodeTool1.checkWebLocalHTMLInText(code_text);
disp(result) %[output:4545bc52]
%%
% Single line code text containing multiple newlines. 
code_text = join([
  "% This line is ignored."
  "web(""http:dummy.com/index.html"")"
  "  callback1 = @() web(""https:dummy.com/index.html"");"
  "  txt = ""web(""""dummy.html"""")"";  % This line is ignored."
  "  callback2 = @() web(""testhtml_checkWebLocalHTMLInText.html"");"
  ], newline);
result = CodeTool1.checkWebLocalHTMLInText(code_text);
disp(result) %[output:1298c7ee]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:4545bc52]
%   data: {"dataType":"text","outputData":{"text":"    <strong>LineNumber<\/strong>                      <strong>URL<\/strong>                      <strong>IsLocal<\/strong>                               <strong>CodeLine<\/strong>                            \n    <strong>__________<\/strong>    <strong>_______________________________________<\/strong>    <strong>_______<\/strong>    <strong>_______________________________________________________________<\/strong>\n\n        2         \"http:dummy.com\/index.html\"                 false     \"web(\"http:dummy.com\/index.html\")\"                             \n        3         \"https:dummy.com\/index.html\"                false     \"callback1 = @() web(\"https:dummy.com\/index.html\");\"           \n        5         \"testhtml_checkWebLocalHTMLInText.html\"     true      \"callback2 = @() web(\"testhtml_checkWebLocalHTMLInText.html\");\"\n\n","truncated":false}}
%---
%[output:1298c7ee]
%   data: {"dataType":"text","outputData":{"text":"    <strong>LineNumber<\/strong>                      <strong>URL<\/strong>                      <strong>IsLocal<\/strong>                               <strong>CodeLine<\/strong>                            \n    <strong>__________<\/strong>    <strong>_______________________________________<\/strong>    <strong>_______<\/strong>    <strong>_______________________________________________________________<\/strong>\n\n        2         \"http:dummy.com\/index.html\"                 false     \"web(\"http:dummy.com\/index.html\")\"                             \n        3         \"https:dummy.com\/index.html\"                false     \"callback1 = @() web(\"https:dummy.com\/index.html\");\"           \n        5         \"testhtml_checkWebLocalHTMLInText.html\"     true      \"callback2 = @() web(\"testhtml_checkWebLocalHTMLInText.html\");\"\n\n","truncated":false}}
%---
