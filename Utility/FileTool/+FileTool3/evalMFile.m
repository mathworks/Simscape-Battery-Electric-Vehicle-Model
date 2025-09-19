function evalMFile(TargetMFile, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TargetMFile (1,1) string
  NameValuePair.DisplayMessage (1,1) logical = true
end  % arguments

if NameValuePair.DisplayMessage
  disp("Loading in base workspace: <a href=""matlab:edit('" + TargetMFile + ".m')"">" + TargetMFile + "</a>")
end  % if

evalin("base", TargetMFile)

end  % function
