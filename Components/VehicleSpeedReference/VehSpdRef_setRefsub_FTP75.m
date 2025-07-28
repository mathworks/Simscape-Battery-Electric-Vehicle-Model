function VehSpdRef_setRefsub_FTP75
%% Set the referenced subsystem to the model and load parameters.

% Copyright 2025 The MathWorks, Inc.

model_name = "VehSpdRef_TestModel";

load_system(model_name)

set_param(model_name, StopTime="2474")

VehSpdRef_setRefsub( ...
  ModelName = model_name, ...
  BlockPath = "/Vehicle speed reference", ...
  RefsubName    = "VehSpdRef_FTP75_refsub", ...
  ParamFileName = "" )

end  % function
