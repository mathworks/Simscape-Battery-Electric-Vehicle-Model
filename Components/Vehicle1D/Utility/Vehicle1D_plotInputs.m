function fig = Vehicle1D_plotInputs(nvpairs)
%% Plots input signals from lookup tables in the model
% This function reads input signal data from 1-D Lookup Table blocks
% and makes plots of them.
%
% Model must be loaded before calling this function.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "Vehicle1D_harness_model"
  nvpairs.BlockPathToInputSubsystem {mustBeTextScalar} = "/Inputs"
  nvpairs.BlockName_BrakeForce {mustBeTextScalar} = "Brake force"
  nvpairs.BlockName_RoadGrade {mustBeTextScalar} = "Road grade"
  nvpairs.BlockName_AxleTorque {mustBeTextScalar} = "Axle torque"

  nvpairs.PlotWindowName {mustBeTextScalar} = "Vehicle1D Inputs"
  nvpairs.Width {mustBePositive, mustBeInteger} = 400
  nvpairs.Height {mustBePositive, mustBeInteger} = 500
  nvpairs.Visible (1,1) matlab.lang.OnOffSwitchState = "on"
end

mdl = nvpairs.ModelName;
subsys_path = nvpairs.BlockPathToInputSubsystem;

blkpath = mdl + subsys_path + "/" + nvpairs.BlockName_BrakeForce;
brakeForceData = getData(blkpath);

blkpath = mdl + subsys_path + "/" + nvpairs.BlockName_RoadGrade;
roadGradeData = getData(blkpath);

blkpath = mdl + subsys_path + "/" + nvpairs.BlockName_AxleTorque;
axleTorqueData = getData(blkpath);

tMax = max([
  brakeForceData.t(end)
  roadGradeData.t(end)
  axleTorqueData.t(end)
  ]);

brakeForceData = extendDataRange(brakeForceData, tMax);
roadGradeData = extendDataRange(roadGradeData, tMax);
axleTorqueData = extendDataRange(axleTorqueData, tMax);

if nvpairs.Visible
  fig = figure;
else
  fig = figure(Visible="off");
end

if nvpairs.PlotWindowName ~= ""
  fig.Name = nvpairs.PlotWindowName;
end

% Adjust the figure position in the screen.
pos = fig.Position;
origHeight = pos(4);
figWidth = nvpairs.Width;
figHeight = nvpairs.Height;
fig.Position = [pos(1), pos(2)-(figHeight-origHeight), figWidth, figHeight];

tlayout = tiledlayout(3, 1);
tlayout.TileSpacing = "compact";
tlayout.Padding = "compact";
tlayout.TileIndexing = "columnmajor";

tl_1 = nexttile;
makePlot("Brake force", brakeForceData, 2)

tl_2 = nexttile;
makePlot("Road grade", roadGradeData, 2)

tl_3 = nexttile;
makePlot("Axle torque", axleTorqueData, 2)

linkaxes([tl_1 tl_2 tl_3], "x")

end  % function


function data = getData(block_path)
% This assumes that the name of the lookup table block is "1-D Lookup Table"
% and the the name of the Signal Specification block is
% th name of the signal followed by " unit".
data.y = get_param(block_path + "/1-D Lookup Table", "Table");
data.y = eval(data.y);
data.t = get_param(block_path + "/1-D Lookup Table", "BreakpointsForDimension1");
data.t = eval(data.t);
data.Unit = get_param(block_path + " unit", "Unit");
end


function data = extendDataRange(data, tMax)
% Adds a new element at the end of the data.
% Y data of the last element is copied,
% i.e., this extension is piece-wise constant.
if data.t(end) < tMax
  data.t(end + 1) = tMax;
  data.y(end + 1) = data.y(end);
end
end


function makePlot(varName, data, threshold_value)
unitStr = "(" + data.Unit + ")";
plot(data.t, data.y, LineWidth=2)
hold on
grid on
axis padded
xlim([data.t(1), data.t(end)])
setMinimumYRange( ...
  gca, ...
  data.y, ...
  dy_threshold = threshold_value );
ylabel(unitStr)
title(varName, Interpreter="none")
end  % function
