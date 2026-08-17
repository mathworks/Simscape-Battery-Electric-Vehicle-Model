function openModel(TargetScript)

% Copyright 2026 The MathWorks, inc.

arguments (Input)
  TargetScript (1,1) string
end  % arguments

disp("Opening model: <a href=""matlab:open_system('" + TargetScript + "')"">" + TargetScript + "</a>")
open_system(TargetScript);

end  % function
