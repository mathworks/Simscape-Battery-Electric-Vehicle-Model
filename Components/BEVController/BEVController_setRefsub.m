function BEVController_setRefsub(NameValuePair)
%% Set referenced subsystem to model and load parameters

% Copyright 2023-2025 The MathWorks, Inc.

arguments
  NameValuePair.ModelName (1,1) string = "BEVController_TestModel"
  NameValuePair.BlockPath (1,1) string = "/BEV Speed Tracking Controller"

  NameValuePair.Name (1,1) string = "Basic model"
  NameValuePair.RefsubName (1,1) string    = "BEVController_Basic_refsub"
  NameValuePair.ParamFileName (1,1) string = "BEVController_Basic_params"
end

mdl = NameValuePair.ModelName;
blkpath = mdl + NameValuePair.BlockPath;

name = NameValuePair.Name;
refsub = NameValuePair.RefsubName;
paramfile = NameValuePair.ParamFileName;

disp("### Using " + name)

if not(bdIsLoaded(mdl))
  load_system(mdl)
end

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)

evalin("base", paramfile)

set_param(blkpath, ReferencedSubsystem = refsub);

end  % function
