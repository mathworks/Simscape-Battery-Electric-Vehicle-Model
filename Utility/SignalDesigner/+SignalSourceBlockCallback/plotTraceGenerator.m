function [fig, sig] = plotTraceGenerator(fullpathToBlock)
%% Plots signal defined in Trace Generator block in a model
%
% This function reads the block parameters of Trace Generator block
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

randomSeed = varValues{varNames == "randomSeed"};
tScale = varValues{varNames == "tScale"};
yScale = varValues{varNames == "yScale"};
interpolationStepSize = varValues{varNames == "interpolationStepSize"};
tInitialFlatLength = varValues{varNames == "tInitialFlatLength"};
yInitialValue = varValues{varNames == "yInitialValue"};
numTransitions  = varValues{varNames == "numTransitions"};
transitionRange = varValues{varNames == "transitionRange"};
flatRange = varValues{varNames == "flatRange"};
yRange = varValues{varNames == "yRange"};
tFinalTransitionDuration = varValues{varNames == "tFinalTransitionDuration"};
tFinalFlatDuration = varValues{varNames == "tFinalFlatDuration"};
yFinalValue = varValues{varNames == "yFinalValue"};

sig = SignalDesignUtility.buildTrace( ...
  RandomSeed = randomSeed, ...
  XScale = tScale, ...
  YScale = yScale, ...
  InterpolationStepSize = interpolationStepSize, ...
  XInitialFlatLength = tInitialFlatLength, ...
  YInitialValue = yInitialValue, ...
  NumTransitions  = numTransitions, ...
  TransitionRange = transitionRange, ...
  FlatRange = flatRange, ...
  YRange = yRange, ...
  XFinalTransitionLength = tFinalTransitionDuration, ...
  XFinalFlatLength = tFinalFlatDuration, ...
  YFinalValue = yFinalValue );

sig.XName = "Time";
sig.XUnit = "s";
sig.YName = "";
sig.Title = blockName;

update(sig)

fig = plotDataPoints(sig);

end  % function
