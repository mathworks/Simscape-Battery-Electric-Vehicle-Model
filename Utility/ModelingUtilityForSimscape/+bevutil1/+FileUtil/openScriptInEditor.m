function openScriptInEditor(TargetScript)

% Copyright 2026 The MathWorks, inc.

arguments (Input)
  TargetScript (1,1) string
end  % arguments

disp("Opening script: <a href=""matlab:edit('" + TargetScript + "')"">" + TargetScript + "</a>")
edit(TargetScript);

end  % function
