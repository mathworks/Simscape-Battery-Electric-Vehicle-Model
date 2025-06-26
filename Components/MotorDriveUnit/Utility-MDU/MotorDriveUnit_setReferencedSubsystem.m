function MotorDriveUnit_setReferencedSubsystem(NameValuePair)

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ModelName {mustBeTextScalar} = "MotorDriveUnit_harness_model"
  NameValuePair.BlockPath {mustBeTextScalar} = "/Motor Drive Unit"
  NameValuePair.RefsubName {mustBeTextScalar} = "MotorDriveUnit_refsub_Basic"
  NameValuePair.ParamFileName {mustBeTextScalar} = "MotorDriveUnit_refsub_Basic_params"
end

mdl = NameValuePair.ModelName;
blkpath = mdl + NameValuePair.BlockPath;
refsub = NameValuePair.RefsubName;
paramfile = NameValuePair.ParamFileName;

if not(bdIsLoaded(mdl))
  load_system(mdl)
end  % if

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)
evalin("base", paramfile)
set_param( blkpath, ReferencedSubsystem = refsub );

end  % function
