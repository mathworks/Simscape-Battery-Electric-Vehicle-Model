%[text] # mustBeSimscapeValueStrictAscend sample script
x = simscape.Value([1,2,3], "s");
CodeTool1.mustBeSimscapeValueStrictAscend(x)
%[text] 
x = simscape.Value(1, "s");
CodeTool1.mustBeSimscapeValueStrictAscend(x)
%[text] 
x = simscape.Value([3,2,1], "s");
try %[output:group:076a22cf]
  CodeTool1.mustBeSimscapeValueStrictAscend(x)
catch exception
  disp(exception.message) %[output:9f7f9754]
end  % try, catch %[output:group:076a22cf]
%[text] 
x = simscape.Value([4,3; 2,1], "s");
try %[output:group:925a85ff]
  CodeTool1.mustBeSimscapeValueStrictAscend(x)
catch exception
  disp(exception.message) %[output:0a88430d]
end  % try, catch %[output:group:925a85ff]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:9f7f9754]
%   data: {"dataType":"text","outputData":{"text":"Vector elements must be strictly ascending.\n","truncated":false}}
%---
%[output:0a88430d]
%   data: {"dataType":"text","outputData":{"text":"Vector elements must be strictly ascending.\n","truncated":false}}
%---
