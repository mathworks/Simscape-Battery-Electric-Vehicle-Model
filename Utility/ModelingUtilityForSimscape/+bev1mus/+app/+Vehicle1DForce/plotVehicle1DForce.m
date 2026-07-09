function fig = plotVehicle1DForce(NameValuePair)
% Make a plot of longitudinal vehicle driving/resisting force curves
%
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

% Copyright 2023-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % These are valid only when 1) MATLAB is R2025a or newer and 2) ParentAxes is not specified.
  NameValuePair.Theme {mustBeMember(NameValuePair.Theme, ["light", "dark"])} = "light"
  NameValuePair.ThemeMode {mustBeMember(NameValuePair.ThemeMode, ["auto", "manual"])} = "auto"

  % DataSet is ignored if DataSource is "direct".
  NameValuePair.DataSource (1,1) string {mustBeMember(NameValuePair.DataSource, ["direct", "dataset"])} = "direct"
  NameValuePair.DataSet bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet {mustBeScalarOrEmpty}

  % ===========================================================================
  % Options for the direct data source

  % ---------------------------------------------------------------------------
  % Parameters

  NameValuePair.VehicleMass (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.VehicleMass, "kg"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(1800, "kg")

  NameValuePair.TireRollingCoefficient (1,1) double { mustBePositive } = 0.0136

  NameValuePair.AirDragCoefficient (1,1) double { mustBePositive } = 0.31

  NameValuePair.FrontalArea (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.FrontalArea, "m^2"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(2.3, "m^2")

  NameValuePair.GravitationalAcceleration (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.GravitationalAcceleration, "m/s^2"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(9.81, "m/s^2")

  NameValuePair.DryAirDensity (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.DryAirDensity, "kg/m^3"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(1.184, "kg/m^3")

  NameValuePair.RoadLoadB (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.RoadLoadB, "N/(km/hr)"), bev1mus.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(0, "N/(km/hr)")

  NameValuePair.TopSpeed (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.TopSpeed, "km/hr"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(160, "km/hr")

  NameValuePair.MaxAcceleration (1,1) double { mustBePositive } = 0.4

  NameValuePair.MaxClimbGradePercent (1,1) double { mustBePositive } = 5

  % ---------------------------------------------------------------------------
  % Visualization parameters

  NameValuePair.PlotGrades (1,:) double { mustBeNonnegative } = [0 5 10 20 35]

  % Force curve with constant power
  NameValuePair.PlotPowers (1,:) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotPowers, "kW"), bev1mus.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value([10, 50, 100, 150], "kW")

  % Plot range upper bound for vehicle speed (X axis)
  NameValuePair.PlotSpeedUpperBound (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotSpeedUpperBound, "km/hr"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(180, "km/hr")

  % Plot range upper bound for vehicle force (Y axis)
  NameValuePair.PlotForceUpperBound (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePair.PlotForceUpperBound, "N"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(9000, "N")

  % Number of points in vehicle speed (x axis) to calculate force values (y axis)
  NameValuePair.NumSpeedPoints (1,1) { mustBePositive, mustBeInteger } = 200

end  % arguments

arguments (Output)
  % Return a figure object so that functions like exportgraphics can work with the plot.
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotVehicle1DForce:";

% -----------------------------------------------------------------------------
% Collect properties from the specified data source.

if NameValuePair.DataSource == "direct"
  % Direct data source.
  % All parameters are the fields of NameValuePair.

  C_roll = NameValuePair.TireRollingCoefficient;
  M_veh = NameValuePair.VehicleMass;
  g = NameValuePair.GravitationalAcceleration;
  A_rl = convert(C_roll * M_veh * g, "N");

  B_rl = NameValuePair.RoadLoadB;

  C_drag = NameValuePair.AirDragCoefficient;
  A_front = NameValuePair.FrontalArea;
  d_air = NameValuePair.DryAirDensity;
  C_rl = convert((1/2) * C_drag * A_front * d_air, "N/(m/s)^2");

  % Derive the maximum driving force.
  max_vehicle_accel = NameValuePair.MaxAcceleration;
  max_vehicle_force = max_vehicle_accel * M_veh * g;

  % Derive the maximum climb power.
  % First, derive the vehicle force at top speed and max climb grade.
  v_top = NameValuePair.TopSpeed;
  grade_max = NameValuePair.MaxClimbGradePercent;
  angle_max = simscape.Value(atan(grade_max/100), "rad");
  Force_top = (A_rl + B_rl*v_top)*cos(angle_max) + C_rl*v_top^2 + M_veh*g*sin(angle_max);
  Power_top = Force_top * v_top;
  val_P = ceil(value(Power_top, "kW"));
  max_climb_power = simscape.Value(val_P, "kW");

  grades_percent = NameValuePair.PlotGrades;
  road_angles = simscape.Value(atan(grades_percent/100), "rad");
  num_grades = numel(grades_percent);

  powers = NameValuePair.PlotPowers;
  num_powers = numel(powers);

  plot_speed_ub = NameValuePair.PlotSpeedUpperBound;
  plot_speed_unit = string(unit(plot_speed_ub));

  plot_force_ub = NameValuePair.PlotForceUpperBound;
  plot_force_unit = string(unit(plot_force_ub));

  num_X = NameValuePair.NumSpeedPoints;

  % X axis data points
  VehicleSpeed = transpose(linspace(simscape.Value(1, plot_speed_unit), plot_speed_ub, num_X));

  F_roll = A_rl + B_rl*VehicleSpeed;
  F_airdrag = C_rl*VehicleSpeed.^2;

  grade_str = strings(1, num_grades);
  angle_str = strings(1, num_grades);
  % Longitudinal vehicle force at constant grade
  F_vehicle = simscape.Value(zeros(num_X, num_grades), "N");
  for k = 1 : num_grades
    grade_str(k) = grades_percent(k) + " %";
    angle_str(k) = round(value(road_angles(k), "deg"), 1) + " deg";
    s = road_angles(k);
    F_vehicle(:, k) = (F_roll*cos(s) + F_airdrag) + M_veh*g*sin(s);
  end  % for

  % Longitudinal vehicle force at constant power
  F_const_power = simscape.Value(zeros(num_X, num_powers), "N");
  for k = 1 : num_powers
    F_const_power(:, k) = powers(k) ./ VehicleSpeed;
  end  % for

else
  % External data set.

  if isfield(NameValuePair, "DataSet")
    DataSet = NameValuePair.DataSet;
  else
    DataSet = bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet(Initialization=true);
  end  % if

  max_vehicle_force = DataSet.ModelParams.MaxForce;
  v_top = DataSet.ModelParams.TopSpeed;
  max_climb_power = DataSet.ModelParams.MaxClimbPower;

  grades_percent = DataSet.PlotGrades;
  road_angles = simscape.Value(atan(grades_percent/100), "rad");
  num_grades = numel(grades_percent);

  powers = DataSet.PlotPowers;
  num_powers = numel(powers);

  plot_speed_ub = DataSet.PlotSpeedUpperBound;
  plot_speed_unit = string(unit(plot_speed_ub));

  plot_force_ub = DataSet.PlotForceUpperBound;
  plot_force_unit = string(unit(plot_force_ub));

  num_X = DataSet.NumSpeedPoints;

  VehicleSpeed = DataSet.VehicleSpeedValues;

  grade_str = strings(1, num_grades);
  angle_str = strings(1, num_grades);
  for k = 1 : num_grades
    grade_str(k) = grades_percent(k) + " %";
    angle_str(k) = round(value(road_angles(k), "deg"), 1) + " deg";
  end  % for

  F_vehicle = DataSet.VehicleForceValues;
  F_const_power = DataSet.ForceValuesAtConstantPower;

end  %if

% -----------------------------------------------------------------------------
% Create a plot.

if isfield(NameValuePair, "ParentAxes")
  if class(NameValuePair.ParentAxes) == "matlab.graphics.axis.Axes"
    ax = NameValuePair.ParentAxes;
    target_fig = ax.Parent;
  else
    id = errorID + "InvalidParentAxes";
    msg = bev1mus.CodeUtil.i18n("ParentAxes must be of type matlab.graphics.axis.Axes.");

    throw(MException(id, msg))

  end  % if
else
  target_fig = figure;
  if not(isMATLABReleaseOlderThan("R2025a"))
    target_fig.ThemeMode = NameValuePair.ThemeMode;
    target_fig.Theme = NameValuePair.Theme;
  end  % if
  ax = axes(target_fig);
end  % if

%% Plot
cla(ax)

%------------------------------------------------------------------------------
% Vehicle force curves at constant road grades - solid curves

solid_line(1:num_grades) = matlab.graphics.chart.primitive.Line;

legend_str = strings(1, num_grades);

solid_line(1) = plot(ax, value(VehicleSpeed, plot_speed_unit), value(F_vehicle(:,1), plot_force_unit));
solid_line(1).LineWidth = 2;
legend_str(1) = grade_str(1) + " (" + angle_str(1) + ")";

hold(ax, "on")

if num_grades > 1
  for k = 2 : num_grades
    solid_line(k) = plot(ax, value(VehicleSpeed, plot_speed_unit), value(F_vehicle(:,k), plot_force_unit));
    solid_line(k).LineWidth = 2;
    legend_str(k) = grade_str(k) + " (" + angle_str(k) + ")";
  end  % for
end  % if

x_max = value(plot_speed_ub, plot_speed_unit);

xlim(ax, [0, x_max])

ylim(ax, [0, value(plot_force_ub, plot_force_unit)])

xlabel(ax, "Vehicle speed (" + plot_speed_unit + ")")

ylabel(ax, [
  "Longitudinal vehicle force, solid (" + plot_force_unit + ")"
  "Force at constant power, dashed (" + plot_force_unit + ")"
  ])

%------------------------------------------------------------------------------
% Vehicle force curves at constant powers - dashed curves

dashed_line(1:num_powers) = matlab.graphics.chart.primitive.Line;
for k = 1 : num_powers
  dashed_line(k) = plot(ax, value(VehicleSpeed, plot_speed_unit), value(F_const_power(:, k), plot_force_unit));
  dashed_line(k).LineWidth = 1;
  dashed_line(k).LineStyle = "--";  % Dashed line

  y = value(F_const_power(end, k), plot_force_unit);
  str = " " + value(powers(k), "kW");
  text(ax, x_max, y, str)
end  % for

y = value(F_const_power(end, num_powers), plot_force_unit);
str = " kW" + newline + " ";
text(ax, x_max, y, str, VerticalAlignment="bottom")

%------------------------------------------------------------------------------

% Top-right shade over the vehicle max power.
x_climb_inc = linspace(simscape.Value(1, plot_speed_unit), plot_speed_ub, num_X)';
x_climb_flip = flipud(x_climb_inc);
x_climb = [x_climb_inc; x_climb_flip];
F_climb_inc = convert(max_climb_power ./ x_climb_inc, plot_force_unit);
F_climb_flip = plot_force_ub * ones(numel(x_climb_flip), 1);
F_climb = [F_climb_inc; F_climb_flip];
power_shade = fill(ax, value(x_climb, plot_speed_unit), value(F_climb, plot_force_unit), "cyan");
power_shade.EdgeColor = "none";
power_shade.FaceColor = "#888";
power_shade.FaceAlpha = 0.3;

% Top shade above the vehicle max force.
force_shade = yregion(ax, value(max_vehicle_force, plot_force_unit), inf);
force_shade.EdgeColor = "none";
force_shade.FaceColor = "#888";
force_shade.FaceAlpha = 0.3;

% Right shade beyond the vehicle top speed.
speed_shade = xregion(ax, value(v_top, plot_speed_unit), inf);
speed_shade.EdgeColor = "none";
speed_shade.FaceColor = "#888";
speed_shade.FaceAlpha = 0.3;

% Specify the curves for the legend after plotting all curves.
% This prevents unspecified curves from being included in the legend.
leg = legend(ax, solid_line, legend_str);
leg.Direction = "reverse";
title(leg, "Road grade % (angle deg)")

grid(ax, "on")

if nargout > 0
  fig = target_fig;
end  % if
end  % function
