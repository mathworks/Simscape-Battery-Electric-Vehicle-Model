function BEV_setup_Thermal(NameValuePair)
% Use Thermal models if available, otherwise use Basic models.
%
% Set up the BEV system model with Thermal components if available.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ModelName {mustBeTextScalar} = "BEV_system_model"
  NameValuePair.DisplayMessage logical = true
end  % arguments

model_name = NameValuePair.ModelName;

if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

if NameValuePair.DisplayMessage
  disp("Use Thermal models if available.")
end  % if

set_param(model_name + "/Longitudinal Vehicle", ReferencedSubsystem = "Vehicle1D_Basic_refsub");
FileTool2.evalMFile("Vehicle1D_Basic_params")

set_param(model_name + "/High Voltage Battery", ReferencedSubsystem = "BatteryHV_SystemThermal_refsub");
FileTool2.evalMFile("BatteryHV_SystemThermal_params")

set_param(model_name + "/Motor Drive Unit", ReferencedSubsystem = "MotorDriveUnit_BasicThermal_refsub");
FileTool2.evalMFile("MotorDriveUnit_BasicThermal_params")

set_param(model_name + "/Reduction Gear", ReferencedSubsystem = "Reducer_Basic_refsub");
FileTool2.evalMFile("Reducer_Basic_params")

set_param(model_name + "/Controller and Environment/BEV Controller", ReferencedSubsystem = "BEVController_Basic_refsub");
FileTool2.evalMFile("BEVController_Basic_params")

end  % function
