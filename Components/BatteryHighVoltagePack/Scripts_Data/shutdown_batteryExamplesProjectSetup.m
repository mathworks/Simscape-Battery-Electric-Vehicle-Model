% Shutdown script for Battery Examples
% Copyright 2020-2021 The MathWorks, Inc.

curr_proj = simulinkproject;
cd(curr_proj.RootFolder)
cd('Libraries')

bdclose('BevDriveCycleDetailedBatteryModel');

bdclose('BevDriveCycleBasicModel');
bdclose('BatteryHV_testHarness');

bdclose('batteryModule_lib');

% Build custom library
if(exist('+batteryModule','dir') && exist('batteryModule_lib.slx','file'))
    ssc_clean batteryModule
end

cd(curr_proj.RootFolder)
