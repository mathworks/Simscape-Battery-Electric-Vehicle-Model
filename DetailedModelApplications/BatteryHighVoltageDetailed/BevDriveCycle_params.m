%% Model Parameters for BEV Drive Cycle Simulation
% This runs as a PostLoadFcn callback, which is automatically executed when
% the BEV system model is opened. Note that this needs to run after the model
% has been loaded because get_param requires the model to have been loaded.

% Copyright 2022 The MathWorks, Inc.

refSubName = get_param(gcs + "/High Voltage Battery", "ReferencedSubsystem");

switch refSubName

case 'BatteryHVDetailed_refsub_MultiModule'
  BevDriveCycle_params_DetailedMulti

case 'BatteryHVDetailed_refsub_SingleApprox'
  BevDriveCycle_params_DetailedSingle

case 'BatteryHV_refsub_Basic'
  BevDriveCycle_params_Basic

otherwise
  error("No valid referenced subsystem was found.")

end
