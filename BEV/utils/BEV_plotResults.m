function fig = BEV_plotResults(logsout)
%% Creates plots of simulation results

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout (1,1) Simulink.SimulationData.Dataset
end

fig = figure;
fig.Position(3:4) = [700 500];  % width height

tl = tiledlayout(fig, 3, 2);
tl.TileSpacing = 'tight';
tl.Padding = 'tight';
tl.TileIndexing = 'columnmajor';

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Speed (km/hr)"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = getValuesFromLogsout(logsout.get("Reference Vehicle Speed (km/hr)"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
legend(ax, ["Actual", "Reference"], Location="best")
title(ax, "Vehicle Speeds (km/hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("G-Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.02);
xlabel("Time (s)")
title("G-Force (-)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Motor Torque Command"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel("Time (s)")
title("Motor Torque Command (N*m)")
hold off

% ax = nexttile(tl);
% vals = getValuesFromLogsout(logsout.get("Motor Temperature"));
% plot(ax, vals.Time, vals.Data, 'LineWidth',2)
% hold on;  grid on
% setMinimumYRange(ax, vals.Data, "dy_threshold",2);
% xlabel("Time (s)")
% title("Motor Temperature (K)")
% hold off

%---

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery SOC"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "Battery SOC (%)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Current"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Battery Current (A)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Battery Power (kW)")
hold off

% ax = nexttile(tl);
% vals = getValuesFromLogsout(logsout.get("HV Battery Temperature"));
% plot(ax, vals.Time, vals.Data, 'LineWidth',2)
% hold on;  grid on
% setMinimumYRange(ax, vals.Data, "dy_threshold",2);
% xlabel(ax, "Time (s)")
% title(ax, "Battery Temperature (K)")
% hold off

end  % function
