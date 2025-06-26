function BatteryHV_useRefsub_Basic
%% Set a specified referenced subsystem to the model

% Copyright 2023-2025 The MathWorks, Inc.

model_name = "BatteryHV_harness_model";

if not(bdIsLoaded)
  load_system(model_name)
end  % if

BatteryHV_useRefsub( ...
  ModelName = model_name, ...
  BlockPath = "/High Voltage Battery", ...
  RefsubName    = "BatteryHV_Basic_refsub", ...
  ParamFileName = "BatteryHV_Basic_params" )

end  % function
