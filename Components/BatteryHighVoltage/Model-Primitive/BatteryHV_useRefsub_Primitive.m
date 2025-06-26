function BatteryHV_useRefsub_Primitive
%% Set a specified referenced subsystem to the model

% Copyright 2023-2025 The MathWorks, Inc.

model_name = "BatteryHV_ComponentTestModel";

if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

BatteryHV_useRefsub( ...
  ModelName = model_name, ...
  BlockPath = "/High Voltage Battery", ...
  RefsubName    = "BatteryHV_Primitive_refsub", ...
  ParamFileName = "BatteryHV_Primitive_params" )

end  % function
