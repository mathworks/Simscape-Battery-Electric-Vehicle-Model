function BatteryHV_useRefsub(nvpairs)
%% Sets a specified referenced subsystem to the model
% Model must be loaded before calling this function.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "BatteryHV_harness_model"
  nvpairs.BlockPath {mustBeTextScalar} = "/High Voltage Battery"
  nvpairs.RefsubName {mustBeTextScalar}    = "BatteryHV_refsub_Basic"
  nvpairs.ParamFileName {mustBeTextScalar} = "BatteryHV_refsub_Basic_params"
end

mdl = nvpairs.ModelName;
blkpath = mdl + nvpairs.BlockPath;
refsub = nvpairs.RefsubName;
paramfile = nvpairs.ParamFileName;

evalin("base", "defineBus_HighVoltage")

if not(bdIsLoaded(mdl))
  load_system(mdl)
end

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)
evalin("base", paramfile)
set_param( blkpath, ReferencedSubsystem = refsub );

end  % function
