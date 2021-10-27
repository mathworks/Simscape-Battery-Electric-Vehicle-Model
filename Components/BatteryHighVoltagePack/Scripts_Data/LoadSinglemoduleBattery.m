% Set the reference model for the detailed battery pack
% reference BatteryHighGroupedRefSub

% Copyright 2021 The MathWorks, Inc.

disp("Configuring the BEV model with grouped-single-module battery...")

batteryBlock=find_system('BevDriveCycleModel','Name', ...
    'High Voltage Battery');
set(getSimulinkBlockHandle(batteryBlock),'ReferencedSubsystem', ...
    'BatteryHighGroupedRefSub');
set_param( [bdroot '/High Voltage Battery'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/High Voltage Battery'], 'ZoomFactor', '100' );


% reference MotorDriveBasicThermalRefSub
motorBlock=find_system('BevDriveCycleModel','Name', ...
    'Motor Drive');
set(getSimulinkBlockHandle(motorBlock),'ReferencedSubsystem', ...
    'MotorDriveBasicThermalRefSub');
set_param( [bdroot '/Motor Drive'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/Motor Drive'], 'ZoomFactor', '100' );

% reference DirectDriveCycleRefSub
controlBlock=find_system('BevDriveCycleModel','Name', ...
    'Driver & Environment');
set(getSimulinkBlockHandle(controlBlock),'ReferencedSubsystem', ...
    'DirectDriveCycleRefSub');
set_param( [bdroot '/Driver & Environment'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/Driver & Environment'], 'ZoomFactor', '100' );


% Load the parameters for the model
BevDriveCycleModularBattery_params;