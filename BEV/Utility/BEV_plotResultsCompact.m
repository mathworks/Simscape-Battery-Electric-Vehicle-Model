function fig = BEV_plotResultsCompact(nvpairs)
%% Creates plots of simulation results

% Copyright 2022 The MathWorks, Inc.

arguments
  nvpairs.SimData timetable
  nvpairs.PlotTemperature logical = true
end

simData = nvpairs.SimData;
plotTemp = nvpairs.PlotTemperature;

fig = figure;
fig.Position(3:4) = [700 500];  % width height

if plotTemp
  % Make 4-by-2 plots
  tl = tiledlayout(fig, 4, 2);
else
  % Make 3-by-2 plots
  tl = tiledlayout(fig, 3, 2);
end

tl.TileSpacing = 'tight';
tl.Padding = 'tight';
tl.TileIndexing = 'columnmajor';

ax = nexttile(tl);

plot(simData, "Time", "Vehicle Speed (km/hr)", LineWidth=2)
hold on;  grid on
plot(simData, "Time", "Reference Vehicle Speed (km/hr)", LineWidth=2)
setMinimumYRange(ax, simData.("Reference Vehicle Speed (km/hr)"), dy_threshold=2);
xlabel(ax, "Time (s)")
legend(ax, ["Actual", "Reference"], Location="best")
title(ax, "Vehicle Speeds (km/hr)")
hold off

ax = nexttile(tl);

plot(simData, "Time", "G-Force", LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, simData.("G-Force"), dy_threshold=0.02);
xlabel("Time (s)")
title("G-Force (-)")
hold off

ax = nexttile(tl);

plot(simData, "Time", "Motor Torque Command", LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, simData.("Motor Torque Command"), dy_threshold=2);
xlabel("Time (s)")
title("Motor Torque Command (N*m)")
hold off

if plotTemp
  ax = nexttile(tl);

  plot(simData, "Time", "Motor Temperature", LineWidth=2)
  hold on;  grid on
  setMinimumYRange(ax, simData.("Motor Temperature"), dy_threshold=2);
  xlabel("Time (s)")
  title("Motor Temperature (K)")
  hold off
end

% Next column

ax = nexttile(tl);

plot(simData, "Time", "HV Battery SOC", LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, simData.("HV Battery SOC"), dy_threshold=0.2);
xlabel(ax, "Time (s)")
title(ax, "Battery SOC (%)")
hold off

ax = nexttile(tl);

plot(simData, "Time", "HV Battery Current", LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, simData.("HV Battery Current"), dy_threshold=2);
xlabel(ax, "Time (s)")
title(ax, "Battery Current (A)")
hold off

ax = nexttile(tl);

plot(simData, "Time", "HV Battery Power", LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, simData.("HV Battery Power"), dy_threshold=2);
xlabel(ax, "Time (s)")
title(ax, "Battery Power (kW)")
hold off

if plotTemp
  ax = nexttile(tl);

  plot(simData, "Time", "HV Battery Temperature", LineWidth=2)
  hold on;  grid on
  setMinimumYRange(ax, simData.("HV Battery Temperature"), dy_threshold=2);
  xlabel(ax, "Time (s)")
  title(ax, "Battery Temperature (K)")
  hold off
end

end  % function
