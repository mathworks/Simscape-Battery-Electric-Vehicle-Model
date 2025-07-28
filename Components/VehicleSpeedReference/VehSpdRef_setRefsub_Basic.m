function VehSpdRef_setRefsub_Basic
%% Set the referenced subsystem to the model and load parameters.

% Copyright 2025 The MathWorks, Inc.

model_name = "VehSpdRef_TestModel";

load_system(model_name)

set_param(model_name, StopTime="1000")

VehSpdRef_setRefsub( ...
  ModelName = model_name, ...
  BlockPath = "/Vehicle speed reference", ...
  RefsubName    = "VehSpdRef_Basic_refsub", ...
  ParamFileName = "" )

end  % function
