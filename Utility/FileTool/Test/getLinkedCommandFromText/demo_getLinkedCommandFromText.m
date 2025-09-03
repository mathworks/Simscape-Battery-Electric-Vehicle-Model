%[text] # getLinkedCommandFromText demo
target_text = "Example: [text1](matlab:command1), [text2](matlab:command2(name=value))";
links = FileTool3.getLinkedCommandFromText(target_text);
disp(links) %[output:2d5cc921]
%%
target_text = [
  "Some text, followed by [linked text](matlab:command1), and the line continues."
  "Next line: [Another linked text](matlab:command2(arg))"
  ];
links = FileTool3.getLinkedCommandFromText(target_text);
disp(links) %[output:2aec3052]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:2d5cc921]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Line<\/strong>    <strong>LinkText<\/strong>           <strong>Command<\/strong>        \n    <strong>____<\/strong>    <strong>________<\/strong>    <strong>______________________<\/strong>\n\n     1      \"text1\"     \"command1\"            \n     1      \"text2\"     \"command2(name=value)\"\n\n","truncated":false}}
%---
%[output:2aec3052]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Line<\/strong>          <strong>LinkText<\/strong>               <strong>Command<\/strong>    \n    <strong>____<\/strong>    <strong>_____________________<\/strong>    <strong>_______________<\/strong>\n\n     1      \"linked text\"            \"command1\"     \n     2      \"Another linked text\"    \"command2(arg)\"\n\n","truncated":false}}
%---
