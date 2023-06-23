function [TR_Ohm, SOC_pct] = BatteryHV_buildTerminalResistanceData(Temperature_degC, TerminalResistanceData_Ohm, nvpairs)
%% Builds a SOC-by-TerminalResistance matrix for table-based battery block
% Given one or more pairs of temperature and data points representing
% terminal resistance (TR) as a function of state of charge (SOC),
% this function builds and returns a matrix which can be used as
% Terminal resistance R0(SOC,T) paramter of Tabled-Based Battery block
% in Simscape Electrical.
% The returned data are smoothly interpolated at the interval of 1 degree Selcius.
% This function also returns a vector of SOC in percent as a second return element.
%
% This function requires Signal Designer (SignalDesigner.m).
%
% SOC-TR data points for one temperature must be represented
% in an N-by-2 matrix where first column is the state of charge in %
% and second column is terminal resistance in Ohm.
%
% The following is an example of calling this function
% with three temperature points at 0, 25, and 60 degC.
%{
[TR_Ohm, SOC_pct] = ...
BatteryHV_buildTerminalResistanceData( ...
   0, [ 0 0.47 ; 5 0.45  ; 15 0.218 ; 40 0.101 ; 80 0.086 ; 100 0.1   ], ...
  25, [ 0 0.17 ; 5 0.12  ; 15 0.072 ; 40 0.053 ; 80 0.044 ; 100 0.033 ], ...
  60, [ 0 0.13 ; 5 0.005 ; 15 0.04  ; 40 0.037 ; 80 0.03  ; 100 0.024 ], ...
  MakePlot = true )
%}
% Note that the temperature points must be sorted in strictly increasing order.
%
% This function is used in the BatteryHV_TableBased_buildParameters script.
% Running the script serves as a test of this function too.

% Copyright 2023 The MathWorks, Inc.

arguments (Repeating)
  Temperature_degC (1,1) double {mustBeNonnegative}
  TerminalResistanceData_Ohm (:,2) double {mustBeNonnegative}
end

arguments
  nvpairs.MakePlot (1,1) logical = false
end
doPlot = nvpairs.MakePlot;

temperature_vec = [Temperature_degC{:}];
numCols = numel(temperature_vec);

assert(issorted(temperature_vec, "strictascend"), ...
  "Values for temperature arguments must be strictly increasing, " ...
  + "but passed values do not satisify the condition: " + join(string(temperature_vec), ", "))

if numCols >= 2
  dataLen = nan(1, numCols);
  for idx = 1 : numCols
    dataLen(idx) = height(TerminalResistanceData_Ohm{idx});
  end
  assert(all(diff(dataLen) == 0), ...
    "All terminal resistance data point matrices must have the same number of rows: " ...
    + join(string(dataLen), ", "))
end

sig = SignalDesigner("Continuous");

% interpolate at the interval of 1 degree Celsius
sig.DeltaX = 1;

sig.XYData = TerminalResistanceData_Ohm{1};
update(sig)
TR_Ohm = nan(numel(sig.Data.Y), numCols);
TR_Ohm(:, 1) = sig.Data.Y;

SOC_pct = sig.Data.X;

if numCols >= 2
  for idx = 2 : numCols
    sig.XYData = TerminalResistanceData_Ohm{idx};
    update(sig)
    TR_Ohm(:, idx) = sig.Data.Y;
  end  % for
end  % if-else

if doPlot
  fig = figure;
  fig.Position(3:4) = [600 300];
  hold on
  grid on
  % Plot in reverse order from high temperature to low temperature.
  for idx = numCols : -1 : 1
    plot(SOC_pct, TR_Ohm(:,idx), LineWidth=2)
  end  % for
  set(gca, xdir = "reverse")
  % Flip the temperature vector from high temperature to low temperature.
  legendStr = string(flip(temperature_vec)) + " degC";
  legend(legendStr, Location="best")
  xlabel("State of charge (%)")
  ylabel("(Ohm)")
  title("Terminal resistance")
end  % if

end  % function
