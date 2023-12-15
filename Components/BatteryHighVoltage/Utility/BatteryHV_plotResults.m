function BatteryHV_plotResults(logsout)
%% Creates plots of simulation results

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout timetable
end

t = logsout.Time;

%%
fig = figure;
fig.Position(3:4) = [700 600];  % width height

tl = tiledlayout(fig, 3, 3);
tl.TileSpacing = "tight";
tl.Padding = "tight";
tl.TileIndexing = "columnmajor";

%---

ax = nexttile(tl);
vals = logsout.("HV Battery Temperature");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
vals = logsout.("HV Battery Ambient Temperature");
plot(ax, t, vals, LineWidth=2, LineStyle="--")
setMinimumYRange(ax, vals, dy_threshold=0.2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Temperatures (degC)")
legend(["Battery", "Ambient"], Location="northeast")
hold off

ax = nexttile(tl);
vals = logsout.("HV Battery Charge");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Battery Charge (A*hr)")
hold off

ax = nexttile(tl);
vals = logsout.("HV Battery SOC");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Battery SOC (%)")
hold off

%---

ax = nexttile(tl);
vals = logsout.("HV Battery Current");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
vals = logsout.("Load Current");
plot(ax, t, vals, LineWidth=2, LineStyle="--")
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Currents (A)")
legend(["Battery", "Load"], Location="northeast")
hold off

ax = nexttile(tl);
vals = logsout.("HV Battery Voltage");
plot(ax, t, vals, LineWidth=2)
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Battery Voltage (V)")
hold off

ax = nexttile(tl);
vals = logsout.("HV Battery Power");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Battery Power (kW)")
hold off

%---

ax = nexttile(tl);
vals = logsout.("Input Heat Flow");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Input Heat Flow (kW)")
hold off

ax = nexttile(tl);
vals = logsout.("Load Voltage");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=2);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Load Voltage (V)")
hold off

ax = nexttile(tl);
vals = logsout.("Load Power");
plot(ax, t, vals, LineWidth=2)
hold on;  grid on
setMinimumYRange(ax, vals, dy_threshold=0.02);
xlim([t(1) t(end)])
xlabel(ax, "Time (s)")
title(ax, "Load Power (kW)")
hold off

end  % function
