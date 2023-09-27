classdef BEVProject_UnitTest_MQC < BEVTestCase
%% Class implementation of unit test

% Copyright 2023 The MathWorks, Inc.

methods (Test)

%% Utility > SignalDesigner folder

function MQC_SignalDesigner_1(~)
  SignalDesignUtility.buildTrace
end

function MQC_SignalDesigner_2(~)
  SignalDesignUtility.buildXYData
end

function MQC_SignalDesigner_3(~)
  mdl = "SignalSourceBlocks_example";
  load_system(mdl)
  SignalSourceBlockCallback.plotContinuous(mdl + "/Continuous")
  SignalSourceBlockCallback.plotContinuousMultiStep(mdl + "/Continuous Multi-Step")
  SignalSourceBlockCallback.plotPieceWiseConstant(mdl + "/Piece-Wise Constant")
  SignalSourceBlockCallback.plotTraceGenerator(mdl + "/Trace Generator")
end


function MQC_SignalDesigner_4(~)
  SignalDesigner
end

function MQC_SignalDesigner_5(~)
  SignalDesigner_example
end

%% Utility folder

function MQC_Utility_1(~)
  AboutBEVProject
end

function MQC_Utility_2(~)
  atProjectStartUp
end


% This passes locally but fails in CI.
function MQC_Utility_3(~)
  generateHTML
end


function MQC_Utility_4(~)
  fig = figure;
  fig.Position(4) = 800;  % height
  plot(1:10, 10:-1:1)
  % Test target:
  fig.Position = adjustFigureHeightAndWindowYPosition(fig);
end

end  % methods (Test)
end  % classdef
