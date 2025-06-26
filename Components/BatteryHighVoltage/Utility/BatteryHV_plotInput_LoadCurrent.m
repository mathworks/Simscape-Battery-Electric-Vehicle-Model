function fig = BatteryHV_plotInput_LoadCurrent(nvpairs)
%% Plots input signal defined in a model
% This functions reads the block parameters of
% Continuous Multi-Step block and makes a plot.
% The model must be loaded for this function to work.

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName {mustBeText} = "BatteryHV_harness_model"
  nvpairs.BlockPath {mustBeText} = "/Inputs/Load current"
end

fullpathToBlock = nvpairs.ModelName + nvpairs.BlockPath;

% Collect mask workspace variables.
% They have been evaluated.
% See the documentation for Simulink.VariableUsage.
maskVars = get_param(fullpathToBlock, "MaskWSVariables");

varNames = string({maskVars.Name});
varValues = {maskVars.Value};

dataPoints = varValues{varNames == "dataPoints"};
deltaT = varValues{varNames == "deltaT"};

sig = SignalDesigner("ContinuousMultiStep");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;

fig = plotDataPoints(sig);

end  % function
