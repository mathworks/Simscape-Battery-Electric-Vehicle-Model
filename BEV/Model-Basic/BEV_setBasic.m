function BEV_setBasic(NameValuePair)
%% Use Basic models for all components
% Setup the BEV system model with all Basic components.
% This is the simplest setup of the BEV system model.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ModelName {mustBeTextScalar} = "BEV_system_model"
  NameValuePair.DisplayMessage logical = true
end  % arguments

model_name = NameValuePair.ModelName;

load_system(model_name)

if NameValuePair.DisplayMessage
  disp("Use Basic models for all components.")
end  % if

set_param(model_name + "/Longitudinal Vehicle", ReferencedSubsystem = "Vehicle1D_Basic_refsub");
evalMFile("Vehicle1D_Basic_params")

set_param(model_name + "/High Voltage Battery", ReferencedSubsystem = "BatteryHV_Basic_refsub");
evalMFile("BatteryHV_Basic_params")

set_param(model_name + "/Motor Drive Unit", ReferencedSubsystem = "MotorDriveUnit_Basic_refsub");
evalMFile("MotorDriveUnit_Basic_params")

set_param(model_name + "/Reduction Gear", ReferencedSubsystem = "Reducer_Basic_refsub");
evalMFile("Reducer_Basic_params")

set_param(model_name + "/Controller & Environment/BEV Controller", ReferencedSubsystem = "BEVController_Basic_refsub");
evalMFile("BEVController_Basic_params")

end  % function
