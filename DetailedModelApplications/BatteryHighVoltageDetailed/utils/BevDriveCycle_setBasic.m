% Set the reference model for the detailed battery pack
% reference BatteryHighVoltageBasic_refsub

% Copyright 2021 The MathWorks, Inc.

disp("Configuring the BEV model with all basic components...")

setRefSub("BevDriveCycle_system_model/High Voltage Battery", ...
  "BatteryHV_refsub_Basic");

setRefSub("BevDriveCycle_system_model/Motor Drive", ...
  "MotorDriveBasicRefSub");

setRefSub("BevDriveCycle_system_model/Driver & Environment", ...
  "DirectDriveCycleBasic_refsub");

function setRefSub(blkPath, refSubName)
set_param(blkPath, ReferencedSubsystem=refSubName);
set_param(blkPath, ZoomFactor='FitSystem')
set_param(blkPath, ZoomFactor='100')
end
