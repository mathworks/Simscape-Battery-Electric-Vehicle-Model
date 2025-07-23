%% Motor Drive Electric Efficiency Data
% Use this as Electrical Losses parameters in Simplified PMSM Drive block
% in Simscape Electrical.
%
% Copyright 2020 The MathWorks, Inc.
%
% The data in this script were obtained from simulation performed in
% MotorDrive_calcElectricEfficiency Live Script.  The data is stored in a
% mat file by save command, but they are stored in this M file as plain text
% for your information too.
%
% Note that Electrical Losses in Simplified PMSM Drive block requires that
% the loss data is stored in a 2D matrix as Loss(SpeedVec, TorqueVec).

motorDrive.simplePmsmDrv_spdVec_rpm = [100, 450, 800, 1150, 1500];
motorDrive.simplePmsmDrv_trqVec_Nm = [10, 45, 80, 115, 150];
motorDrive.simplePmsmDrv_LossTbl_W = ...
[ 16.02, 251,   872.8, 2230, 4998; ...
  29.77, 262,   875.7, 2217, 4950; ...
  45.35, 281.2, 900,   2217, 4796; ...
  62.14, 299,   924.8, 2191, 4567; ...
  81.1,  320.9, 943.1, 2146, 4379];
