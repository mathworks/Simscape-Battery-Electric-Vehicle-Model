% Set the reference model for the detailed battery pack
% reference BatteryHighGroupedRefSub

% Copyright 2021 The MathWorks, Inc.

disp("Configuring the BEV model with grouped-single-module battery...")

setRefSub("BevDriveCycle_system_model/High Voltage Battery", ...
  "BatteryHVDetailed_refsub_SingleApprox");

setRefSub("BevDriveCycle_system_model/Motor Drive", ...
  "MotorDriveBasicThermalRefSub");

setRefSub("BevDriveCycle_system_model/Driver & Environment", ...
  "DirectDriveCycle_refsub");

function setRefSub(blkPath, refSubName)
set_param(blkPath, ReferencedSubsystem=refSubName);
set_param(blkPath, ZoomFactor='FitSystem')
set_param(blkPath, ZoomFactor='100')
end
