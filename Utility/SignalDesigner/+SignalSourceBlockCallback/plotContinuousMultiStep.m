function [fig, sig] = plotContinuousMultiStep(fullpathToBlock)
%% Plots signal defined in Continuous Multi-Step block in a model
%
% This functions reads the block parameters of Continuous Multi-Step block
% and makes the plot of a signal trace.
% The model must be loaded for this function to work.
%
% This function returns the figure object and the Signal Designer object.

% Copyright 2023 The MathWorks, Inc.

arguments
  fullpathToBlock {mustBeText} = gcb
end

blockName = extractAfter(fullpathToBlock, asManyOfPattern(wildcardPattern + "/"));

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

sig.XName = "Time";
sig.XUnit = "s";
sig.YName = "";
sig.Title = blockName;

update(sig)

fig = plotDataPoints(sig);

end  % function
