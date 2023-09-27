function [OCV_V, SOC_pct] = BatteryHV_buildOpenCircuitVoltageData(Temperature_degC, OCVDataPoints_V, nvpairs)
%% Builds a SOC-by-OCV matrix for table-based battery block
% Given one or more pairs of temperature and data points representing
% open-circuit voltage (OCV) as a function of state of charge (SOC),
% this function builds and returns a matrix which can be used as
% Open-circuit voltage V0(SOC,T) paramter of Tabled-Based Battery block
% in Simscape Electrical.
% The returned data are smoothly interpolated at the interval of 1 degree Celsius.
% This function also returns a vector of SOC as a second return element.
%
% This function requires Signal Designer (SignalDesigner.m).
%
% SOC-OCV data points for one temperature must be represented
% in an N-by-2 matrix where first column is the state of charge in %
% and second column is open-circuit voltage in Volts.
%
% For example, a 2-by-2 matrix [15 3.1; 25 3.3] represents that
% - 1st row: OCV 3.1 V at 15 % SOC
% - 2nd row: OCV 3.3 V at 25 % SOC
%
% The following is an example of calling this function
% with three temperature points at 0, 25, and 60 degC.
%{
[OCV_V, SOC_pct] = ...
BatteryHV_buildOpenCircuitVoltageData( ...
   0, [ 0 2.8; 10 3.0; 15 3.1; 25 3.3; 75 3.4; 90 3.5; 100 3.6 ], ...
  25, [ 0 2.9; 10 3.1; 15 3.2; 25 3.4; 75 3.5; 90 3.6; 100 3.9 ], ...
  60, [ 0 3.0; 10 3.3; 15 3.4; 25 3.6; 75 3.7; 90 3.8; 100 4.15 ], ...
  MakePlot = true )
%}
% Note that the temperature points must be sorted in strictly increasing order.
%
% This function is used in the BatteryHV_TableBased_buildParameters script.
% Running the script serves as a test of this function too.

% Copyright 2023 The MathWorks, Inc.

arguments (Repeating)
  Temperature_degC (1,1) double {mustBeNonnegative}
  OCVDataPoints_V (:,2) double {mustBeNonnegative}
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
    dataLen(idx) = height(OCVDataPoints_V{idx});
  end
  assert(all(diff(dataLen) == 0), ...
    "All OCV data point matrices must have the same number of rows: " ...
    + join(string(dataLen), ", "))
end

sig = SignalDesigner("Continuous");

% interpolate at the interval of 1 degree Celsius
sig.DeltaX = 1;

sig.XYData = OCVDataPoints_V{1};
update(sig)
OCV_V = nan(numel(sig.Data.Y), numCols);
OCV_V(:, 1) = sig.Data.Y;

SOC_pct = sig.Data.X;

if numCols >= 2
  for idx = 2 : numCols
    sig.XYData = OCVDataPoints_V{idx};
    update(sig)
    OCV_V(:, idx) = sig.Data.Y;
  end  % for
end  % if

if doPlot
  fig = figure;
  fig.Position(3:4) = [600 300];
  hold on
  grid on
  % Plot in reverse order from high temperature to low temperature.
  for idx = numCols : -1 : 1
    plot(SOC_pct, OCV_V(:,idx), LineWidth=2)
  end  % for
  set(gca, xdir = "reverse")
  % Flip the temperature vector from high temperature to low temperature.
  legendStr = string(flip(temperature_vec)) + " degC";
  legend(legendStr, Location="best")
  xlabel("State of charge (%)")
  ylabel("(V)")
  title("Open-circuit voltage")
end  % if

end  % function
