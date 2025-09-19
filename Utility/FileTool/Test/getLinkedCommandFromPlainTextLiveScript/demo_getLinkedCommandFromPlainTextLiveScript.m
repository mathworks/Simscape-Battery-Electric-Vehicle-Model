%[text] # getLinkedCommandFromPlainTextLiveScript demo
fullpath = string( which("testscript_getLinkedCommandFromPlainTextLiveScript"));
links = FileTool3.getLinkedCommandFromPlainTextLiveScript(fullpath);
disp(links) %[output:3a8da3e1]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:3a8da3e1]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Line<\/strong>            <strong>LinkText<\/strong>                 <strong>Command<\/strong>     \n    <strong>____<\/strong>    <strong>_________________________<\/strong>    <strong>________________<\/strong>\n\n     2      \"linked text\"                \"disp(\"test 1\")\"\n     2      \"another link\"               \"disp(\"test 2\")\"\n     3      \"Yet another linked text\"    \"datetime\"      \n     3      \"This\"                       \"logo\"          \n\n","truncated":false}}
%---
