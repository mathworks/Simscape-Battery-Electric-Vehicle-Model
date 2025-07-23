function BatteryHV_setRefsub_Basic
%% Set a specified referenced subsystem to the model

% Copyright 2023-2025 The MathWorks, Inc.

model_name = "BatteryHV_TestModel";

if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

BatteryHV_setRefsub( ...
  ModelName = model_name, ...
  BlockPath = "/High Voltage Battery", ...
  RefsubName    = "BatteryHV_Basic_refsub", ...
  ParamFileName = "BatteryHV_Basic_params" )

end  % function
