function BEV_resetReferencedSubsystems(modelName)
%% Resets system model with default referenced subsystems
% Consider this function as a tool to "factory reset" the referenced subsystems.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  modelName (1,:) {mustBeTextScalar} = "BEV_system_model"
end

load_system(modelName)

blkpath = modelName + "/High Voltage Battery";
set_param(blkpath, ReferencedSubsystem = "BatteryHighVoltageBasic_refsub");
set_param(blkpath, ZoomFactor = "FitSystem");
set_param(blkpath, ZoomFactor = "100");

blkpath = modelName + "/Motor Drive Unit";
set_param(blkpath, ReferencedSubsystem = "MotorDriveBasic_refsub");
set_param(blkpath, ZoomFactor = "FitSystem");
set_param(blkpath, ZoomFactor = "100");

blkpath = modelName + "/Controller & Environment";
set_param(blkpath, ReferencedSubsystem = "DirectDriveCycleBasic_refsub");
set_param(blkpath, ZoomFactor = "FitSystem");
set_param(blkpath, ZoomFactor = "100");

blkpath = modelName + "/Longitudinal Vehicle";
set_param(blkpath, ReferencedSubsystem = "Vehicle1D_refsub_Driveline");
set_param(blkpath, ZoomFactor = "FitSystem");
set_param(blkpath, ZoomFactor = "100");

end  % function
