function BEV_useComponents_Basic(nvpairs)
%% Use Basic models for all components
% Model must be loaded before calling this function.
%
% Setup the BEV system model with all Basic components.
% This is the simplest setup of the BEV system model.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "BEV_system_model"
  nvpairs.DisplayMessage logical = true
end

mdl = nvpairs.ModelName;

if nvpairs.DisplayMessage
  disp("Use Basic models for all components.")
end

set_param(        mdl + "/Longitudinal Vehicle", ...
  ReferencedSubsystem = "Vehicle1D_refsub_Basic");
evalin(        "base" , "Vehicle1D_refsub_Basic_params")

set_param(        mdl + "/High Voltage Battery", ...
  ReferencedSubsystem = "BatteryHV_refsub_Basic");
evalin(        "base" , "BatteryHV_refsub_Basic_params")

set_param(        mdl + "/Motor Drive Unit", ...
  ReferencedSubsystem = "MotorDriveUnit_refsub_Basic");
evalin(        "base" , "MotorDriveUnit_refsub_Basic_params")

set_param(        mdl + "/Reduction Gear", ...
  ReferencedSubsystem = "Reducer_refsub_Basic");
evalin(        "base" , "Reducer_refsub_Basic_params")

set_param(        mdl + "/Controller & Environment/BEV Controller", ...
  ReferencedSubsystem = "BEVController_refsub_Basic");
evalin(        "base" , "BEVController_refsub_Basic_params")

end  % function
