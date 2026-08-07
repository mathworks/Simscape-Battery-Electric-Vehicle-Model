%% Load inputs for BatteryHV component - random current case

% Copyright 2026 The MathWorks, Inc.

tmp_result = buildInputs_BatteryHV_Random();

batteryHV.Input_LoadCurrent_TimePoints = tmp_result.Input_LoadCurrent_TimePoints;
batteryHV.Input_LoadCurrent_Data = tmp_result.Input_LoadCurrent_Data;

batteryHV.Input_HeatFlow_TimePoints = tmp_result.Input_HeatFlow_TimePoints;
batteryHV.Input_HeatFlow_Data = tmp_result.Input_HeatFlow_Data;

clear tmp_result
