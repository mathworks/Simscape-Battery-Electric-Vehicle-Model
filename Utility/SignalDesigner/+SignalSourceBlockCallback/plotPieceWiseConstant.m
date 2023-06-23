function [fig, sig] = plotPieceWiseConstant(fullpathToBlock)
%% Plots signal defined in Piece-Wise Constant block in a model
%
% This function reads the block parameters of Piece-Wise Constant block
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

sig = SignalDesigner("PieceWiseConstant");
sig.XYData = dataPoints;

sig.XName = "Time";
sig.XUnit = "s";
sig.YName = "";
sig.Title = blockName;

update(sig)

fig = plotDataPoints(sig);

end  % function
