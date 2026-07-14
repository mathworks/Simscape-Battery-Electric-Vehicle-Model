function ReturnFigure = BEV_plotResults(NameValuePair)
% Create plots of simulation results.
%
% To see what plots this function creates, simply run this function without arguments.

% Copyright 2022-2026 The MathWorks, Inc.

arguments (Input)
  % figure, uipanel, etc. If omitted, a new figure is created.
  NameValuePair.ParentContainer matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % TimedData takes data as timetable.
  % In the model, specify VariableNames used below to the signals for signal logging.
  % After simulation, create a timetable with extractTimetable.
  NameValuePair.TimedData timetable = timetable(seconds([0;10]), [0;0], [0;0], [0;0], [0;0], [0;0], [0;0], [0;0], [0;0], [0;0], ...
    VariableNames = [ ...
    "Vehicle Speed kph", ...
    "Reference Vehicle Speed kph", ...
    "G-Force", ...
    "Motor Torque Command", ...
    "Motor Temperature", ...
    "HV Battery SOC", ...
    "HV Battery Current", ...
    "HV Battery Power", ...
    "HV Battery Temperature"])

  % Set false to PlotTemperature to omit plots for Motor Temperature and HV Battery Temperature.
  NameValuePair.PlotTemperature logical = true

end  % arguments

arguments (Output)
  ReturnFigure matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

if isfield(NameValuePair, "ParentAxes") && (class(NameValuePair.ParentAxes) == "matlab.graphics.axis.Axes")
  parent = NameValuePair.ParentContainer;
else
  parent = figure;
  parent.Position(3:4) = [700 500];  % width height
end  % if

simData = NameValuePair.TimedData;

plotTemp = NameValuePair.PlotTemperature;

if plotTemp
  % Make 4-by-2 plots
  tl = tiledlayout(parent, 4, 2);
else
  % Make 3-by-2 plots
  tl = tiledlayout(parent, 3, 2);
end  % if

tl.TileSpacing = "tight";
tl.Padding = "tight";
tl.TileIndexing = "columnmajor";

ax = nexttile(tl);

plot(ax, simData, "Time", "Vehicle Speed kph", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
plot(ax, simData, "Time", "Reference Vehicle Speed kph", LineWidth=2)
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("Reference Vehicle Speed kph"), dy_threshold=2);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
legend(ax, ["Actual", "Reference"], Location="best")
title(ax, "Vehicle Speeds (km/hr)")
hold(ax, "off")

ax = nexttile(tl);

plot(ax, simData, "Time", "G-Force", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("G-Force"), dy_threshold=0.02);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
title(ax, "G-Force (-)")
hold(ax, "off")

ax = nexttile(tl);

plot(ax, simData, "Time", "Motor Torque Command", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("Motor Torque Command"), dy_threshold=2);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
title(ax, "Motor Torque Command (N*m)")
hold(ax, "off")

if plotTemp
  ax = nexttile(tl);

  plot(ax, simData, "Time", "Motor Temperature", LineWidth=2)
  hold(ax, "on")
  grid(ax, "on")
  bev1mus.SignalUtil.setMinimumYRange(ax, simData.("Motor Temperature"), dy_threshold=2);
  ylabel(ax, "")  % Hide variable name defined in the timetable.
  xlim(ax, "tight")
  xlabel(ax, "")
  title(ax, "Motor Temperature (degC)")
  hold(ax, "off")
end  % if

% Next column

ax = nexttile(tl);

plot(ax, simData, "Time", "HV Battery SOC", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("HV Battery SOC"), dy_threshold=0.2);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
title(ax, "Battery SOC (%)")
hold(ax, "off")

ax = nexttile(tl);

plot(ax, simData, "Time", "HV Battery Current", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("HV Battery Current"), dy_threshold=2);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
title(ax, "Battery Current (A)")
hold(ax, "off")

ax = nexttile(tl);

plot(ax, simData, "Time", "HV Battery Power", LineWidth=2)
hold(ax, "on")
grid(ax, "on")
bev1mus.SignalUtil.setMinimumYRange(ax, simData.("HV Battery Power"), dy_threshold=2);
ylabel(ax, "")  % Hide variable name defined in the timetable.
xlim(ax, "tight")
xlabel(ax, "")
title(ax, "Battery Power (kW)")
hold(ax, "off")

if plotTemp
  ax = nexttile(tl);

  plot(ax, simData, "Time", "HV Battery Temperature", LineWidth=2)
  hold(ax, "on")
  grid(ax, "on")
  bev1mus.SignalUtil.setMinimumYRange(ax, simData.("HV Battery Temperature"), dy_threshold=2);
  ylabel(ax, "")  % Hide variable name defined in the timetable.
  xlim(ax, "tight")
  xlabel(ax, "")
  title(ax, "Battery Temperature (degC)")
  hold(ax, "off")
end  % if

if nargout > 0
  ReturnFigure = parent;
end  % if
end  % function
