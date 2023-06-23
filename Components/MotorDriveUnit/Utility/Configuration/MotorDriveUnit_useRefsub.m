function MotorDriveUnit_useRefsub(nvpairs)

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "MotorDriveUnit_harness_model"
  nvpairs.BlockPath {mustBeTextScalar} = "/Motor Drive Unit"
  nvpairs.RefsubName {mustBeTextScalar}    = "MotorDriveUnit_refsub_Basic"
  nvpairs.ParamFileName {mustBeTextScalar} = "MotorDriveUnit_refsub_Basic_params"
end

mdl = nvpairs.ModelName;
blkpath = mdl + nvpairs.BlockPath;
refsub = nvpairs.RefsubName;
paramfile = nvpairs.ParamFileName;

if not(bdIsLoaded(mdl))
  load_system(mdl)
end

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)
evalin("base", paramfile)
set_param( blkpath, ReferencedSubsystem = refsub );

end  % function
