function Vehicle1D_plotResults(logsout)
%% Creates plots of simulation results

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout (1,1) Simulink.SimulationData.Dataset
end

fig = figure;
fig.Position(3:4) = [500 400];

tl = tiledlayout(fig, 3, 1);
tl.TileSpacing = 'tight';
tl.Padding = 'tight';
tl.TileIndexing = 'columnmajor';

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Axle Torque"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "Axle Torque Input (N*m)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Brake Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Brake Force (N)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Road Grade %"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "Road Grade (%)")
hold off

fig = figure;
fig.Position(3:4) = [500 500];

tl = tiledlayout(fig, 2, 1);
tl.TileSpacing = 'tight';
tl.Padding = 'tight';
tl.TileIndexing = 'columnmajor';

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("G-Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.02);
xlabel("Time (s)")
title("G-Force (-)")
hold off

end  % function
