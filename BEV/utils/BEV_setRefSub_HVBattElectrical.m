function BEV_setRefSub_HVBattElectrical(modelName)
%% Sets the High Voltage Battery referenced subsystem in BEV system model.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  modelName (1,:) {mustBeTextScalar} = "BEV_system_model"
end

blkpath = modelName + "/High Voltage Battery";
set_param(blkpath, ReferencedSubsystem = "BatteryHV_refsub_Electrical");
set_param(blkpath, ZoomFactor = "FitSystem");
set_param(blkpath, ZoomFactor = "100");

end  % function
