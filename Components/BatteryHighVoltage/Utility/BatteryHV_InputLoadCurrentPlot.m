function fig = BatteryHV_InputLoadCurrentPlot(NameValuePair)
%% Plots input signal defined in a model
% This functions reads the block parameters of
% Continuous Multi-Step block and makes a plot.
% The model must be loaded for this function to work.

% Copyright 2022-2025 The MathWorks, Inc.

arguments
  NameValuePair.ModelName {mustBeText} = "BatteryHV_TestModel"
  NameValuePair.BlockPath {mustBeText} = "/Inputs/Load current"
end

model_name = NameValuePair.ModelName;
if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

block_path = model_name + NameValuePair.BlockPath;

% Collect mask workspace variables.
% They have been evaluated.
% See the documentation for Simulink.VariableUsage.
maskVars = get_param(block_path, "MaskWSVariables");

varNames = string({maskVars.Name});
varValues = {maskVars.Value};

dataPoints = varValues{varNames == "dataPoints"};
deltaT = varValues{varNames == "deltaT"};

sig = SignalDesigner("ContinuousMultiStep");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;

fig = plotDataPoints(sig);

end  % function
