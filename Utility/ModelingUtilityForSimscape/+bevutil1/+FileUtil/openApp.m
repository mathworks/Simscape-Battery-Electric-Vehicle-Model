function openApp(TargetApp)

% Copyright 2026 The MathWorks, inc.

arguments (Input)
  TargetApp (1,1) string
end  % arguments

disp("Opening app: <a href=""matlab:" + TargetApp + """>" + TargetApp + "</a>")
feval(TargetApp);

end  % function
