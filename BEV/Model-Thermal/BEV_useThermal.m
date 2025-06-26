function BEV_useThermal(NameValuePair)
%% Use Thermal models if available
% Setup the BEV system model with Thermal components if available.

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

  function load_parameters(param_filename)
    if NameValuePair.DisplayMessage
      disp("Loading parameters: <a href=""matlab:edit('" + param_filename + ".m')"">" + param_filename + "</a>")
    end  % if
    evalin("base", param_filename)
  end  % nested function

set_param(model_name + "/Longitudinal Vehicle", ReferencedSubsystem = "Vehicle1D_refsub_Basic");
load_parameters("Vehicle1D_refsub_Basic_params")

set_param(model_name + "/High Voltage Battery", ReferencedSubsystem = "BatteryHV_refsub_SystemSimple");
load_parameters("BatteryHV_refsub_SystemSimple_params")

set_param(model_name + "/Motor Drive Unit", ReferencedSubsystem = "MotorDriveUnit_refsub_BasicThermal");
load_parameters("MotorDriveUnit_refsub_BasicThermal_params")

set_param(model_name + "/Reduction Gear", ReferencedSubsystem = "Reducer_refsub_Basic");
load_parameters("Reducer_refsub_Basic_params")

set_param(model_name + "/Controller & Environment/BEV Controller", ReferencedSubsystem = "BEVController_refsub_Basic");
load_parameters("BEVController_refsub_Basic_params")

end  % function
