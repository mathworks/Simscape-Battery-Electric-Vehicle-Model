function BEV_useComponents_Thermal(nvpairs)
%% Use components with themal models enabled 
% Model must be loaded before calling this function.
%
% This sets up the BEV system model to use Motor Drive Unit and
% High Voltage Battery components for which thermal model is enabled.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "BEV_system_model"
  nvpairs.DisplayMessage logical = true
end

mdl = nvpairs.ModelName;

if nvpairs.DisplayMessage
  disp("Use thermal models for Motor Drive Unit and High Voltage Battery components.")
end

set_param(        mdl + "/Longitudinal Vehicle", ...
  ReferencedSubsystem = "Vehicle1D_refsub_Basic");
evalin(        "base" , "Vehicle1D_refsub_Basic_params")

set_param(        mdl + "/High Voltage Battery", ...
  ReferencedSubsystem = "BatteryHV_refsub_SystemSimple");
evalin(        "base" , "BatteryHV_refsub_SystemSimple_params")

set_param(        mdl + "/Motor Drive Unit", ...
  ReferencedSubsystem = "MotorDriveUnit_refsub_BasicThermal");
evalin(        "base" , "MotorDriveUnit_refsub_BasicThermal_params")

set_param(        mdl + "/Reduction Gear", ...
  ReferencedSubsystem = "Reducer_refsub_Basic");
evalin(        "base" , "Reducer_refsub_Basic_params")

%{
% This is to be added in future update.
set_param(        mdl + "/Controller & Environment/BEV Controller", ...
  ReferencedSubsystem = "BEVController_refsub_BasicThermal");
evalin(        "base" , "BEVController_refsub_BasicThermal_params")
%}

end  % function
