function fig = Vehicle1D_plotProperties_Basic(nvpairs)
%% Plots vehicle properties specified in block parameters.
% This function reads block parameters of Longitudinal Vehicle block
% and makes the plots of the Road-Load curve (i.e., resistin gforce) and
% corresponding power curve as a function of vehicle speed.
%
% Model must be loaded and target subsystem must be opened
% before calling this function.

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeTextScalar} = "Vehicle1D_harness_model"
  nvpairs.BlockPathToTargetSubsystem {mustBeTextScalar} = "/Longitudinal Vehicle"
  nvpairs.TargetBlockName {mustBeTextScalar} = "Longitudinal Vehicle"
end

mdl = nvpairs.ModelName;
sybsys_fullpath = mdl + nvpairs.BlockPathToTargetSubsystem;

blockPaths = getfullname(Simulink.findBlocksOfType( sybsys_fullpath, ...
  "SimscapeBlock", ...
  Simulink.FindOptions( SearchDepth = 1 )));

targetBlockName = nvpairs.TargetBlockName;

% logical index
lix = endsWith(blockPaths, targetBlockName);

% Block name in a subsystem is guaranteed to be unique.
% Target block should be found, and the number of match is required to be 1.
assert(nnz(lix) == 1, ...
  "Block was not found: " + targetBlockName)

% block_info = sdlUtility.getLongitudinalVehicleInfo(block_handle);
block_info = Vehicle1D_getLongitudinalVehicleInfo(targetBlockName);

plotSpeedUnit = "km/hr";
plotSpeedUpperBound_kph = 160;

fig = sdlUtility.plotLongitudinalVehicleResistance( ...
  VehicleMass = block_info.VehicleMass, ...
  RoadLoadA = block_info.RoadLoadA, ...
  RoadLoadB = block_info.RoadLoadB, ...
  RoadLoadC = block_info.RoadLoadC, ...
  GravitationalAcceleration = block_info.GravitationalAcceleration, ...
  VehicleSpeedVector = simscape.Value(0:160, "km/hr")', ...
  RoadGradeVector = [30, 15, 0], ...
  VehicleSpeedPlotUnit = plotSpeedUnit );

allLegends = findall(fig, type="legend");
% Legends are stored in the reverse order.
% The legend property of the first plot of the two is at the second element.
allLegends(2).Location = "northwest";

allAxes = findall(fig, type="axes");
linkaxes(allAxes, "x")
xlim(gca, [0 plotSpeedUpperBound_kph])

% Lower the position of the plot window
% because the top part of the plot window goes outside of the screen.
fig.Position(2) = fig.Position(2) - 100;

end  % function
