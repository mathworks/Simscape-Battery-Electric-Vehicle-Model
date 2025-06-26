function Vehicle1DPerformancePlot(NameValuePairs)
%% Makes plot of longitudinal vehicle driving/resisting force curves
% This function takes parameters that characterize the vehicle's longitudinal performance
% and makes a plot of driving/resisting force curves and constant power contours.
%
% You can run this function without any arguments, and the function makes
% a plot using default values for all parameters.
%
% You can use options for individual parameters to change their values.
%
% You can also use the ParameterSet option to specify all the parameters in one option.
% The data to pass to ParameterSet must be of type LongitudinalVehiclePerformanceParameters.
% If you use ParameterSet and individual parameter options together,
% individual parameter options are used.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)

  % Either axes, panel, tab, or TiledChartLayout
  NameValuePairs.Parent matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  NameValuePairs.ParameterSet LongitudinalVehiclePerformanceParameters {mustBeScalarOrEmpty}

  NameValuePairs.VehicleMass (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.VehicleMass, "kg")}

  NameValuePairs.RoadLoadA (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.RoadLoadA, "N")}

  NameValuePairs.RoadLoadB (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.RoadLoadB, "N/(km/hr)")}

  NameValuePairs.RoadLoadC (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.RoadLoadC, "N/(km/hr)^2")}

  NameValuePairs.GravitationalAcceleration (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.GravitationalAcceleration, "m/s^2")}

  NameValuePairs.PlotGrades (1,:) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotGrades, "1")}

  % Force curve with constant power
  NameValuePairs.PlotPowers (1,:) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotPowers, "kW")}

  % Maximum vehicle force (Y axis)
  NameValuePairs.MaximumAcceleration (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.MaximumAcceleration, "1")}

  % Maximum vehicle speed (X axis)
  NameValuePairs.TopSpeed (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.TopSpeed, "km/hr")}

  % Maximum climb power at top speed
  NameValuePairs.MaximumClimbPower(1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.MaximumClimbPower, "kW")}

  % Plot range upper bound for vehicle force (Y axis)
  NameValuePairs.PlotForceUpperBound (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotForceUpperBound, "kN")}

  % Plot range upper bound for vehicle speed (X axis)
  NameValuePairs.PlotSpeedUpperBound (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotSpeedUpperBound, "km/hr")}

  NameValuePairs.PlotForceUnit (1,1) string ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotForceUnit, "N")} = "N"

  NameValuePairs.PlotSpeedUnit (1,1) string ...
    {simscape.mustBeCommensurateUnit(NameValuePairs.PlotSpeedUnit, "m/s")} = "m/s"

  % Number of points in vehicle speed (x axis) to calculate force values (y axis)
  NameValuePairs.NumSpeedPoints (1,1) {mustBePositive, mustBeInteger} = 100

end  % arguments

M_e = setup_parameter("VehicleMass", simscape.Value(1800, "kg"));

A_rl = setup_parameter("RoadLoadA", simscape.Value(240.1, "N"));

B_rl = setup_parameter("RoadLoadB", simscape.Value(0, "N/(km/hr)"));

C_rl = setup_parameter("RoadLoadC", simscape.Value(0.4336, "N/(km/hr)^2"));

grav = setup_parameter("GravitationalAcceleration", simscape.Value(9.81, "m/s^2"));

grades_percent = setup_parameter("PlotGrades", simscape.Value([0 10 20 30], "1"));

powers = setup_parameter("PlotPowers", simscape.Value([50 100 200], "kW"));

max_vehicle_accel = setup_parameter("MaximumAcceleration", simscape.Value(0.4));

max_vehicle_speed = setup_parameter("TopSpeed", simscape.Value(160, "km/hr"));

max_climb_power = setup_parameter("MaximumClimbPower", simscape.Value(50, "kW"));

force_plot_upper = setup_parameter("PlotForceUpperBound", simscape.Value(15, "kN"));

speed_plot_upper = setup_parameter("PlotSpeedUpperBound", simscape.Value(200, "km/hr"));

  function x = setup_parameter(name_string, default_sscval)
    if string(unit(default_sscval)) == "1"
      % Percent and G-force values have the Simscape unit of "1".
      if isfield(NameValuePairs, name_string)
        x = value(NameValuePairs.(name_string), "1");
      elseif isfield(NameValuePairs, "ParameterSet")
        x = value(NameValuePairs.ParameterSet.(name_string), "1");
      else
        x = value(default_sscval, "1");
      end  % if

    else
      if isfield(NameValuePairs, name_string)
        x = NameValuePairs.(name_string);
      elseif isfield(NameValuePairs, "ParameterSet")
        x = NameValuePairs.ParameterSet.(name_string);
      else
        x = default_sscval;
      end  % if
    end  % if
  end  % function

force_unit_text = NameValuePairs.PlotForceUnit;

speed_unit_text = NameValuePairs.PlotSpeedUnit;

numX = NameValuePairs.NumSpeedPoints;

%% Prepare data

if isfield(NameValuePairs, "Parent")
  ax = NameValuePairs.Parent;
else
  ax = axes(figure);
end  % if

max_vehicle_force = max_vehicle_accel * M_e * grav;

angles = simscape.Value(atan(grades_percent/100), "rad");
num_grades = numel(grades_percent);
num_powers = numel(powers);

% X axis data points
VehicleSpeed = linspace(simscape.Value(1, speed_unit_text), speed_plot_upper, numX)';

F_roll = A_rl + B_rl*VehicleSpeed;
F_airdrag = C_rl*VehicleSpeed.^2;

grade_str = strings(1, num_grades);
angle_str = strings(1, num_grades);
% Longitudinal vehicle force at constant grade
F_const_grade = simscape.Value(zeros(numX, num_grades), "N");
for idx = 1 : num_grades
  grade_str(idx) = grades_percent(idx) + " %";
  angle_str(idx) = round(value(angles(idx), "deg"), 1) + " deg";
  s = angles(idx);
  F_const_grade(:, idx) = (F_roll*cos(s) + F_airdrag) + M_e*grav*sin(s);
end  % for

% Longitudinal vehicle force at constant power
F_const_power = simscape.Value(zeros(numX, num_powers), "N");
for idx = 1 : num_powers
  F_const_power(:, idx) = powers(idx) ./ VehicleSpeed;
end  % for

x_climb_inc = linspace(simscape.Value(1, speed_unit_text), speed_plot_upper, numX)';
F_climb_inc = convert(max_climb_power ./ x_climb_inc, force_unit_text);
x_climb_flip = flipud(x_climb_inc);
F_climb_flip = force_plot_upper * ones(numel(x_climb_flip), 1);
x_climb = [x_climb_inc; x_climb_flip];
F_climb = [F_climb_inc; F_climb_flip];

xmax = value(speed_plot_upper, speed_unit_text);

%% Plot
cla(ax)

xlim(ax, [0, xmax])
xlabel(ax, "Vehicle speed (" + speed_unit_text + ")")

%------------------------------------------------------------------------------
% Vehicle force curves at constant road grades - solid curves

hold(ax, "on")

solid_line(1:num_grades) = matlab.graphics.chart.primitive.Line;
legend_str = strings(1, num_grades);
for idx = 1 : num_grades
  solid_line(idx) = plot(ax, value(VehicleSpeed, speed_unit_text), value(F_const_grade(:,idx), force_unit_text));
  solid_line(idx).LineWidth = 2;
  solid_line(idx).Marker = "none";

  legend_str(idx) = grade_str(idx) + " (" + angle_str(idx) + ")";
end  % for

ylim(ax, [0, value(force_plot_upper, force_unit_text)])

ylabel(ax, [
  "Longitudinal vehicle force, solid (" + force_unit_text + ")"
  "Force at constant power, dashed (" + force_unit_text + ")"
  ])

%------------------------------------------------------------------------------
% Vehicle force curves at constant powers - dashed curves

dashed_line(1:num_powers) = matlab.graphics.chart.primitive.Line;
for idx = 1 : num_powers
  dashed_line(idx) = plot(ax, value(VehicleSpeed, speed_unit_text), value(F_const_power(:, idx), force_unit_text));
  dashed_line(idx).LineWidth = 1;
  dashed_line(idx).LineStyle = "--";  % Dashed line
  dashed_line(idx).Marker = "none";

  y = value(F_const_power(end, idx), force_unit_text);
  str = " " + value(powers(idx), "kW");
  text(ax, xmax, y, str)
end  % for

y = value(F_const_power(end, num_powers), force_unit_text);
str = " kW" + newline + " ";
text(ax, xmax, y, str, VerticalAlignment="bottom")

%------------------------------------------------------------------------------

shade = fill(ax, value(x_climb, speed_unit_text), value(F_climb, force_unit_text), "cyan");
shade.EdgeColor = "none";
shade.FaceColor = "#888";
shade.FaceAlpha = 0.3;

shade = yregion(ax, value(max_vehicle_force, force_unit_text), inf);
shade.EdgeColor = "none";
shade.FaceColor = "#888";
shade.FaceAlpha = 0.3;

shade = xregion(ax, value(max_vehicle_speed, speed_unit_text), inf);
shade.EdgeColor = "none";
shade.FaceColor = "#888";
shade.FaceAlpha = 0.3;

grid(ax, "on")

leg = legend(ax, solid_line, legend_str);
leg.Direction = "reverse";
title(leg, "Road grade % (angle deg)")

end  % function
