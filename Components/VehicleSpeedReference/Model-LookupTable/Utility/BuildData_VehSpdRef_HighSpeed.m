function Data = BuildData_VehSpdRef_HighSpeed()

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Output)
  Data (:,2) table
end  % arguments

% -----------------------------------------------------------------------------
% Vehicle speed

% Generate data using a random number generator.
signal_design_matrix = bevutil1.SignalUtil.generateSignalDesignMatrixFromTraceProperties(...
  RandomSeed = 6, ... Random seed
  ...
  FInitialValue = 0, ... Initial data value
  XInitialFlatLength = 10, ... Initial constant duration
  XInitialTransitionLength = 10, ... Initial transition duration
  ...
  NumTransitions = 10, ... Number of transitions
  TransitionXRange = [5 10], ... Range of transition duration
  FlatXRange = [5 10], ... Range of constant duration
  FRange = [60 100], ... Range of data value
  ...
  XFinalTransitionLength = 15, ... Final transition duration
  FFinalValue = 0, ... Final data value
  XFinalFlatLength = 10 );  % Final constant duration

data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

t = data_table.X;
f = data_table.F;

% These data are used as the parameters of a lookup table block which requires at least three data points.
Time = simscape.Value(t, "s");
Speed = simscape.Value(f, "km/hr");

Data = table(Time, Speed);

end  % function
