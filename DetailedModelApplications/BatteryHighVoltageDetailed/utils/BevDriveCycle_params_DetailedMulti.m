%% Model Parameters for BEV Drive Cycle with Detailed Multi-Module Battery
% In this script, the same are used for the two parallel battery packs HV1 and HV2.

% Copyright 2020-2022 The MathWorks, Inc.

BevDriveCycle_params_Common

batteryHV_alldata = BatteryHVDetailed_getParamsMultiModule( ...
  NumParallelCellsInStringPerPack = 4, ...
  NumSeriesStringsPerPack = 108 );

batteryHV_multi_pack1 = batteryHV_alldata.pack1;
batteryHV_multi_pack2 = batteryHV_alldata.pack2;
batteryHV_multi_other = batteryHV_alldata.other;

% Charge Discharge Constraint
bevControl.batteryCharge_Ahr = batteryHV_alldata.bevControl.batteryCharge_Ahr;
bevControl.cRate = batteryHV_alldata.bevControl.cRate;
bevControl.batteryTemp_LUT = batteryHV_alldata.bevControl.batteryTemp_LUT;
bevControl.batterySOC_LUT = batteryHV_alldata.bevControl.batterySOC_LUT;
