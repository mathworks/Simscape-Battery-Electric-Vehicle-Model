function VehSpdRef_setRefsub(NameValuePair)
%% Set the referenced subsystem to the model and load parameters.

% Copyright 2025 The MathWorks, Inc.

arguments
  NameValuePair.ModelName (1,1) string = "VehSpdRef_TestModel"
  NameValuePair.BlockPath (1,1) string = "/Vehicle speed reference"
  NameValuePair.RefsubName (1,1) string    = "VehSpdRef_Basic_refsub"
  NameValuePair.ParamFileName (1,1) string = ""
end

mdl = NameValuePair.ModelName;
blkpath = mdl + NameValuePair.BlockPath;
refsub = NameValuePair.RefsubName;
paramfile = NameValuePair.ParamFileName;

% evalin("base", "defineBus_HighVoltage")

load_system(mdl)

disp("Model: " + mdl)
disp("Setting up referenced subsystem: " + refsub)

if not(isempty(paramfile))
  evalin("base", paramfile)
end  % if

set_param(blkpath, ReferencedSubsystem = refsub);

end  % function
