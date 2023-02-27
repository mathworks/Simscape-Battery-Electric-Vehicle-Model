classdef BEVProject_UnitTest_MQC < matlab.unittest.TestCase
%% Class implementation of unit test

% Copyright 2023 The MathWorks, Inc.

methods (Test)

%% Utility > SignalDesigner folder

function MQC_SignalDesigner_1(~)
  close all
  bdclose all
  SignalDesignUtility.buildTrace
  close all
  bdclose all
end

function MQC_SignalDesigner_2(~)
  close all
  bdclose all
  SignalDesignUtility.buildXYData
  close all
  bdclose all
end

%{
% This passes locally but fails in CI.
function MQC_SignalDesigner_3(~)
  close all
  bdclose all
  mdl = "SignalSourceBlocks_example";
  load_system(mdl)
  SignalSourceBlockCallback.plotContinuous(mdl + "/Continuous")
  SignalSourceBlockCallback.plotContinuousMultiStep(mdl + "/Continuous Multi-Step")
  SignalSourceBlockCallback.plotPieceWiseConstant(mdl + "/Piece-Wise Constant")
  SignalSourceBlockCallback.plotTraceGenerator(mdl + "/Trace Generator")
  close all
  bdclose all
end
%}

function MQC_SignalDesigner_4(~)
  close all
  bdclose all
  SignalDesigner
  close all
  bdclose all
end

function MQC_SignalDesigner_5(~)
  close all
  bdclose all
  SignalDesigner_example
  close all
  bdclose all
end

%% Utility folder

function MQC_Utility_1(~)
  close all
  bdclose all
  AboutBEVProject
  close all
  bdclose all
end

function MQC_Utility_2(~)
  close all
  bdclose all
  atProjectStartUp
  close all
  bdclose all
end

function MQC_Utility_3(~)
  close all
  bdclose all
  generateHTML
  close all
  bdclose all
end

function MQC_Utility_4(~)
  close all
  bdclose all
  fig = figure;
  fig.Position(4) = 800;  % height
  plot(1:10, 10:-1:1)
  % Test target:
  fig.Position = adjustFigureHeightAndWindowYPosition(fig);
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
