function Data = BuildInputs_BatteryHV_Random()

% Copyright 2026 The MathWorks, Inc.

arguments (Output)
  Data (1,1) struct
end  % arguments

% -----------------------------------------------------------------------------
% Load current

% Generate data using a random number generator.
signal_design_matrix = bevutil1.SignalUtil.generateSignalDesignMatrixFromTraceProperties(...
  RandomSeed = 123, ... Random seed
  ...
  FInitialValue = 0, ... Initial data value
  XInitialFlatLength = 5, ... Initial constant duration
  XInitialTransitionLength = 5, ... Initial transition duration
  ...
  NumTransitions = 10, ... Number of transitions
  TransitionXRange = [10 30], ... Range of transition duration
  FlatXRange = [60 120], ... Range of constant duration
  FRange = [-10 30], ... Range of data value
  ...
  XFinalTransitionLength = 10, ... Final transition duration
  XFinalFlatLength = 10, ... Final data value
  FFinalValue = 0 );  % Final constant duration

data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

t = data_table.X';
f = data_table.F';

% These data are used as the parameters of a lookup table block which requires at least three data points.
Data.Input_LoadCurrent_TimePoints = simscape.Value(t, "s");
Data.Input_LoadCurrent_Data = simscape.Value(f, "A");

% -----------------------------------------------------------------------------
% Heat flow

% These data are used as the parameters of a lookup table block which requires at least three data points.
Data.Input_HeatFlow_TimePoints = simscape.Value([0, 1, 2], "s");
Data.Input_HeatFlow_Data = simscape.Value([0, 0, 0], "W");

end  % function
