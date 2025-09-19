%[text] # Generate Electrical Efficiency/Losses Data for Synchronous Motor Drive System
%[text] The purpose of this script is to calculate **the total electrical efficiency/losses of synchronous motor drive system** using a detailed 3-phase AC system model.
%[text] The model consists of the detailed 3-phase synchronous motor, interver, and motor controller. This script runs the model in various operating conditions to collect AC steady-state data, and then computes electrical losses in the post process. The losses data produced in this script can be used in **Simplified PMSM Drive** block in Simscape Electrical for fast-running simulation purpose.
%[text] ## Set up
% Load parameters.
HarnessSetup_MotorDrive

% Open model and set up simulation
model_name = "HarnessModel_MotorDrive";
load_system(model_name)

set_param(model_name, ...
  "SimscapeLogOpenViewer", "off",...
  "EnablePacing", "off",...
  "SolverType", "Variable-step",...
  "Solver", "VariableStepAuto",...
  "SaveTime", "on",...
  "TimeSaveName", "tout",...
  "SignalLogging", "on",...
  "SignalLoggingName", "logsout",...
  "SimscapeLogType", "local",...
  "SimscapeLogSimulationStatistics", "off",...
  "SimscapeLogToSDI", "off",...
  "SimscapeLogName", "logsoutssc",...
  "SimscapeLogDecimation", 1,...
  "SimscapeLogLimitData", "off",...
  "ReturnWorkspaceOutputs", "on",...
  "ReturnWorkspaceOutputsName", "out");

set_param(model_name+"/Motor Drive/FEM-Parameterized PMSM", LogSimulationData="on")
  % necessary for electrical loss calculation after simulation

tMax = 0.2;  % Simulation time > 60/rpm0/N
set_param(model_name, StopTime=num2str(tMax))

set_param(model_name, FastRestart="on")
save_system(model_name)

project_root = currentProject().RootFolder;
topic_folder_path = fullfile(project_root, "FYI", "MotorDrivePmsmFem");
assert(isfolder(topic_folder_path))
%%
%[text] ## Run Simulations
%[text] Generate a simulation input data set in different operating conditions to collect physical signals in AC steady state.
%[text] #### Define torque and speed conditions
% The ranges specified below are rather narrow for electric vehicle motors.
% This is due to the lack of sufficient motor data for FEM-Parameterized PMSM block
% as well as to the limitation of the FOC controller used in the model.
SpeedVec = [100, 450, 800, 1150, 1500];  % rpm
TorqueVec = [10, 45, 80, 115, 150];  % N*m
%[text] #### **Build simulation input data set and run simulations**
nS = length(SpeedVec);
nT = length(TorqueVec);

clear in
in(1:nS, 1:nT) = Simulink.SimulationInput(model_name);
for i_spd = 1:nS
  for i_trq = 1:nT
    rpm0 = SpeedVec(i_spd);
    torque0 = TorqueVec(i_trq);

    % First two setBlockParameter calls are used by Simulation Manager"s
    % default Figure window to show the progress of simulations.
    % First one for horizontal, left to right.
    % Second one for vertical, bottom to top.
    in(i_spd,i_trq) = in(i_spd,i_trq).setBlockParameter(model_name+"/Constant Target Speed", "Value",num2str(rpm0));
    in(i_spd,i_trq) = in(i_spd,i_trq).setBlockParameter(model_name+"/Step Load Torque", "After",num2str(torque0));

    in(i_spd,i_trq) = in(i_spd,i_trq).setBlockParameter(model_name+"/Load inertia", "w",num2str(rpm0));
    in(i_spd,i_trq) = in(i_spd,i_trq).setBlockParameter(model_name+"/Motor Drive/FEM-Parameterized PMSM", ...
                "angular_velocity",num2str(rpm0));
    in(i_spd,i_trq) = in(i_spd,i_trq).setBlockParameter(model_name+"/Motor Drive/FEM-Parameterized PMSM", ...
                "angular_velocity_priority","High");
  end
end

%out = sim(in, "ShowSimulationManager","on");
out = parsim(in, ShowSimulationManager="on");  % need Parallel Computing Toolbox
%%
%[text] ## **Visually Inspect Motor Speed Behavior**
clear result
result(1:nS,1:nT) = struct("spd",0, "trq",0, "log",timeseries); %#ok<check_timeseries>
for i_spd = 1:nS  % speed
  for i_trq = 1:nT  % torque
    spd = SpeedVec(i_spd);
    trq = TorqueVec(i_trq);
    result(i_spd,i_trq).spd = spd;
    result(i_spd,i_trq).trq = trq;
    result(i_spd,i_trq).log = out(i_spd,i_trq).logsout.get("<motorSpd>").Values;
  end
end

f = figure;
f.Position(3:4) = [800 600];
tl = tiledlayout(nT, nS);
tl.TileSpacing = "compact";
tl.Padding = "compact";
title(tl, "Motor speed for various load torques and target speeds")
for i_trq = 1:nT  % torque
  for i_spd = 1:nS  % speed
    nexttile
    irev_trq = nT - i_trq + 1;
    plot(result(i_spd,irev_trq).log.Time, result(i_spd,irev_trq).log.Data)
    title(num2str(result(i_spd,irev_trq).trq) + " N*m, " + num2str(result(i_spd,irev_trq).spd) + " rpm")
  end
end
%%
%[text] ## Obtain Electrical Losses
%[text] Use the [ee\_getPowerLossSummary](<matlab:web(fullfile(docroot, 'physmod/sps/ref/ee_getpowerlosssummary.html'))>) API from Simscape Electrical to obtain electrical losses in the motor. Make sure the signals in the motor block were logged during simulation.
Losses = zeros(nS,nT);
for i_spd = 1:nS
  for i_trq = 1:nT
    rpm0_abs = abs(SpeedVec(i_spd));
    % Time range for last full AC cycle
    tMin = tMax - 60/rpm0_abs/PmsmFem.NumPolePairs;
    assert(tMin < tMax)
    % Extract losses
    tabulatedLosses = ee_getPowerLossSummary(out(i_spd,i_trq).logsoutssc, tMin, tMax);
    Losses(i_spd,i_trq) = sum(tabulatedLosses.Power);
  end
end
%[text]  **Visualize**
SpeedVecLabels = cell(1,nS);
for idx = 1:nS
  SpeedVecLabels{idx} = num2str(SpeedVec(idx));
end

TorqueVecLabels = cell(1,nT);
for idx = 1:nT
  TorqueVecLabels{idx} = num2str(TorqueVec(idx));
end

figure
hmap = heatmap(SpeedVecLabels, TorqueVecLabels, Losses);
hmap.YDisplayData = flip(TorqueVecLabels);
hmap.Title = "Electrical Losses (W)";
hmap.XLabel = "Speed (rpm)";
hmap.YLabel = "Torque (N*m)";
%%
%[text] **Store the result for use by other models**
%[text] You can use the tabulated electrical losses in **Simplified PMSM Drive** block in Simscape Electrical.
% Make sure the losses data is stored in a 2D matrix as Losses(SpeedVec, TorqueVec).
motorDrive.simplePmsmDrv_spdVec_rpm = SpeedVec;
motorDrive.simplePmsmDrv_trqVec_Nm = TorqueVec;
motorDrive.simplePmsmDrv_LossTbl_W = Losses;

saveFileFullPath = fullfile(topic_folder_path, "MotorDriveElecLossParams.mat");
save(saveFileFullPath, "motorDrive");
% The file is saved in the current folder.
disp("Mat file was saved: " + pwd)
%[text] Save command stores the data in a mat file which is a binary file. For your information, a text version of the electrical losses parameter is provided in [MotorDriveElecLossParams\_text.m](<matlab:edit MotorDriveElecLossParams_text.m>) (but loss values are rounded for simplicity).
%[text] *Copyright 2020-2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":20.7}
%---
