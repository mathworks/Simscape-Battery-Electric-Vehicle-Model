% Set the reference model for the detailed battery pack
% reference BatteryHighVoltageBasic_refsub

% Copyright 2021 The MathWorks, Inc.

disp("Configuring the BEV model with all basic components...")

batteryBlock=find_system('BevDriveCycleModel','Name', ...
    'High Voltage Battery');
set(getSimulinkBlockHandle(batteryBlock),'ReferencedSubsystem', ...
    'BatteryHighVoltageBasic_refsub');
set_param( [bdroot '/High Voltage Battery'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/High Voltage Battery'], 'ZoomFactor', '100' );

% reference MotorDriveBasicRefSub
motorBlock=find_system('BevDriveCycleModel','Name', ...
    'Motor Drive');
set(getSimulinkBlockHandle(motorBlock),'ReferencedSubsystem', ...
    'MotorDriveBasicRefSub');
set_param( [bdroot '/Motor Drive'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/Motor Drive'], 'ZoomFactor', '100' );

% reference DirectDriveCycleNoBrakeRefSub
controlBlock=find_system('BevDriveCycleModel','Name', ...
    'Driver & Environment');
set(getSimulinkBlockHandle(controlBlock),'ReferencedSubsystem', ...
    'DirectDriveCycleBasicRefSub');
set_param( [bdroot '/Driver & Environment'], 'ZoomFactor', 'FitSystem' );
set_param( [bdroot '/Driver & Environment'], 'ZoomFactor', '100' );


% Load the parameters for the model
BevDriveCycleBasic_params;
