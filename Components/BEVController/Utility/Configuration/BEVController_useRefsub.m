function BEVController_useRefsub(nvpairs)
%% Sets a specified referenced subsystem to the model
% Model must be loaded before calling this function.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "BEVController_harness_model"
  nvpairs.BlockPath {mustBeTextScalar} = "/BEV Speed Tracking Controller"

  nvpairs.Name {mustBeTextScalar} = "Basic model"
  nvpairs.RefsubName {mustBeTextScalar}    = "BEVController_refsub_Basic"
  nvpairs.ParamFileName {mustBeTextScalar} = "BEVController_refsub_Basic_params"
end

mdl = nvpairs.ModelName;
blkpath = mdl + nvpairs.BlockPath;

name = nvpairs.Name;
refsub = nvpairs.RefsubName;
paramfile = nvpairs.ParamFileName;

disp("### Using " + name)

if not(bdIsLoaded(mdl))
  load_system(mdl)
end

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)
evalin("base", paramfile)
set_param( blkpath, ReferencedSubsystem = refsub );

end  % function
