%% Model Parameters for BEV Drive Cycle with detailed battery module
% Data for the two battery packs HV1 and HV2 in parallel are the same.
% To run scenarios with different parameter values, run the script again.

% Copyright 2020-2022 The MathWorks, Inc.

BevDriveCycle_params_Common

batteryData = BatteryHVDetailed_getParamsCommon( ...
  NumParallelCellsInString = 4, ...
  NumSeriesStrings = 108 );

batteryHV_single = batteryData;

% Charge Discharge Constraint
bevControl.batteryCharge_Ahr = batteryData.batteryCharge_Ahr;
bevControl.cRate = batteryData.cRate;
bevControl.batteryTemp_LUT = batteryData.batteryTemp_LUT;
bevControl.batterySOC_LUT = batteryData.batterySOC_LUT;
