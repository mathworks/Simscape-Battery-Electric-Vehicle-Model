function fig = plotAbstractMotorEfficiency(NameValuePair)
% Make a contour plot of power conversion efficiency for the abstract motor model.
%
% To see a plot this function can create, run this function without arguments.
%
% This function can take arguments corresponding to the block parameters of
% the following blocks:
%
%   - Motor & Drive block, from Simscape Driveline
%   - Motor & Drive (System Level) block, from Simscape Electrical
%
% and makes a plot of electric-to-mechanical power conversion efficiency map
% as a function of motor speed and torque.
%
% You can run this function without arguments,
% and it will create a plot using default argument values.
%
% Note that Motor & Drive (System Level) block supports
% various ways to accept block parameters, but
% this function makes a plot for it assuming the following case:
%
%   Electrical Torque
%     - Parameterized by: Maximum torque and power
%   Electrical Losses
%     - Parameterize losses by: Single efficiency measurement
%
% To make an efficiency plot for other cases
% in Motor & Drive (System Level) block,
% use the "Plot efficiency map" link in the block Description.
%
%
% https://uk.mathworks.com/help/sps/ref/motordrivesystemlevel.html
%
% https://uk.mathworks.com/help/sdl/ref/motordrive.html
%
% This function can take plot settings from an external data source.
%{
% Example:
% Make a plot using the default dataset.
AbstractMotor1.plotAbstractMotorEfficiency( ...
  DataSource="dataset")
%}
%{
% Example:
% Make a plot using a custom data set.
ds = AbstractMotor1.AbstractMotorModelDataSet( ...
  Initialization=true);
% Modify ds here.
AbstractMotor1.plotAbstractMotorEfficiency( ...
  DataSource="dataset", DataSet=ds)
%}

% Copyright 2021-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % ThemeMode and Theme are valid only when 1) MATLAB is R2025a or newer and 2) ParentAxes is not specified.
  % Theme is ignored if ThemeMode is "auto".
  % These options correspond to the figure's equivalent options.
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.figure.html
  NameValuePair.ThemeMode {mustBeMember(NameValuePair.ThemeMode, ["auto", "manual"])} = "auto"
  NameValuePair.Theme {mustBeMember(NameValuePair.Theme, ["light", "dark"])} = "light"

  % DataSet is ignored if DataSource is "direct".
  NameValuePair.DataSource (1,1) string {mustBeMember(NameValuePair.DataSource, ["direct", "dataset"])} = "direct"
  NameValuePair.DataSet AbstractMotor1.AbstractMotorDataSet {mustBeScalarOrEmpty}

  % ---------------------------------------------------------------------------
  % Options for direct data source

  NameValuePair.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  NameValuePair.ContourLevelsPercent (1,:) double ...
    {mustBeInRange(NameValuePair.ContourLevelsPercent, 0, 100, "exclude-lower")} ...
    = [1 60 80 90 92 94 96 97 98 99]  %#ok<MUSTINRANGE> mustBeBetween is not available in R2024b.

  NameValuePair.ShowContourText (1,1) matlab.lang.OnOffSwitchState = "on"

  NameValuePair.ShowTorqueEnvelope (1,1) matlab.lang.OnOffSwitchState = "on"

  % --- torque

  NameValuePair.AutoRangeTorque (1,1) logical = true

  NameValuePair.MaxTorque (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MaxTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(160, "N*m")

  NameValuePair.PlotTorqueUpperBound simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotTorqueUpperBound, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(200, "N*m")
    % FYI: 200 N*m = 147.5 lbf*ft

  % --- angular speed

  % If SpecifyMaxAngularSpeed is true, MaxAngularSpeed option is used.
  % If SpecifyMaxAngularSpeed is false, MaxAngularSpeed option is ignored, and the max motor speed is
  % automatically determined.
  NameValuePair.SpecifyMaxAngularSpeed (1,1) logical = false

  NameValuePair.AutoRangeAngularSpeed (1,1) logical = true

  % In the road vehicle applications, maximum motor speed is determined by vehicle top speed,
  % tire rolling radius, and reduction gear ratio.
  NameValuePair.MaxAngularSpeed (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MaxAngularSpeed, "rad/s"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(17000, "rpm")

  NameValuePair.PlotAngularSpeedUpperBound simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotAngularSpeedUpperBound, "rad/s"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(18000, "rpm")
    % FYI: 18000 rpm = 1885 rad/s

  % --- power and others

  NameValuePair.MaxPower (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(NameValuePair.MaxPower, "kW"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(55, "kW")

  NameValuePair.MeasuredEfficiencyPercent (1,1) double ...
    { mustBeInRange(NameValuePair.MeasuredEfficiencyPercent, 0, 100) } = 95  %#ok<MUSTINRANGE>

  NameValuePair.MeasuredAngularSpeed (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredAngularSpeed, "rpm"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(2000, "rpm")

  NameValuePair.MeasuredTorque (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(50, "N*m")

  NameValuePair.MeasuredIronLoss (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredIronLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(55, "W")

  NameValuePair.FixedLoss (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.FixedLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(40, "W")

  NameValuePair.RotorDamping (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(NameValuePair.RotorDamping, "N*m/rpm"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(0.05, "N*m/(rad/s)")

end  % arguments

arguments (Output)
  % Return a figure object so that functions like exportgraphics can work with the plot.
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotAbstractMotorEfficiency:";

% -----------------------------------------------------------------------------
% Collect properties from the specified data source.

if NameValuePair.DataSource == "direct"
  % Direct data source.
  % All parameters are the fields of NameValuePair.

  plot_resolution = NameValuePair.PlotResolution;

  % ---------------------------------------------------------------------------
  % power

  max_motor_power_W = value(NameValuePair.MaxPower, "W");

  % ---------------------------------------------------------------------------
  % torque

  show_torque_envelope = NameValuePair.ShowTorqueEnvelope;

  max_motor_torque_Nm = value(NameValuePair.MaxTorque, "N*m");
  max_motor_torque_in_plot_unit = value(NameValuePair.MaxTorque);

  if NameValuePair.AutoRangeTorque
    plot_torque_unit = string(unit(NameValuePair.MaxTorque));
    plot_torque_upper_bound = max_motor_torque_in_plot_unit;
  else
    plot_torque_unit = string(unit(NameValuePair.PlotTorqueUpperBound));
    plot_torque_upper_bound = value(NameValuePair.PlotTorqueUpperBound);
  end  % if

  torque_vector_in_plot_unit = linspace(0, max_motor_torque_in_plot_unit, plot_resolution);

  trq_Nm_vec = transpose(linspace(0, max_motor_torque_Nm, plot_resolution));

  % ---------------------------------------------------------------------------
  % angular speed

  if NameValuePair.SpecifyMaxAngularSpeed
    max_motor_speed_radps = value(NameValuePair.MaxAngularSpeed, "rad/s");
    max_motor_speed_in_plot_unit = value(NameValuePair.MaxAngularSpeed);
    if NameValuePair.AutoRangeAngularSpeed
      plot_speed_unit = string(unit(NameValuePair.MaxAngularSpeed));
      plot_speed_upper_bound = max_motor_speed_in_plot_unit;
    else
      plot_speed_unit = string(unit(NameValuePair.PlotAngularSpeedUpperBound));
      plot_speed_upper_bound = value(NameValuePair.PlotAngularSpeedUpperBound);
    end  % if
  else
    % MaxAngularSpeed is not specified, but it must be defined for visualization.
    % On the max power curve in the speed-vs-torque plot, find the speed at 15 % of max torque.
    % Use that speed as the max motor speed.
    max_motor_speed_radps = max_motor_power_W / (0.15 * max_motor_torque_Nm);
    if NameValuePair.AutoRangeAngularSpeed
      plot_speed_unit = "rpm";
      plot_speed_upper_bound = value(simscape.Value(max_motor_speed_radps, "rad/s"), plot_speed_unit);
    else
      plot_speed_unit = string(unit(NameValuePair.PlotAngularSpeedUpperBound));
      plot_speed_upper_bound = value(NameValuePair.PlotAngularSpeedUpperBound);
    end  % if
    max_motor_speed_in_plot_unit = plot_speed_upper_bound;
  end  % if

  % !attention: Speed should avoid zero because it is used in the denominator when calculating torque envelope.
  speed_vector_in_plot_unit = linspace(1, max_motor_speed_in_plot_unit, plot_resolution);

  w_radps_vec = linspace(1, max_motor_speed_radps, plot_resolution);

  % ---------------------------------------------------------------------------
  contour_levels = NameValuePair.ContourLevelsPercent;
  if numel(contour_levels) <= 2
    id = errorID + "NotEnoughElements";
    msg = CodeUtil1.i18n("Contour levels must have 3 or more elements.");

    throw(MException(id, msg))

  end  % if

  show_text = NameValuePair.ShowContourText;

  measured_efficiency_percent = NameValuePair.MeasuredEfficiencyPercent;
  normalized_measured_efficiency = measured_efficiency_percent / 100;

  measured_speed_in_plot_unit = value(NameValuePair.MeasuredAngularSpeed, plot_speed_unit);
  measured_speed_radps = value(NameValuePair.MeasuredAngularSpeed, "rad/s");

  measured_torque_in_plot_unit = value(NameValuePair.MeasuredTorque, plot_torque_unit);
  measured_torque_Nm = value(NameValuePair.MeasuredTorque, "N*m");

  % Iron loss at efficiency measurement point
  measured_iron_loss_W = value(NameValuePair.MeasuredIronLoss, "W");

  loss_const_W = value(NameValuePair.FixedLoss, "W");

  k_damp = value(NameValuePair.RotorDamping, "N*m/(rad/s)");

  % Mechanical power at efficiency measurement point
  measured_mechanical_power_W = measured_speed_radps * measured_torque_Nm;

  % Nominal (rated) loss at efficiency measurement point
  measured_nominal_loss_W = (1/normalized_measured_efficiency - 1) * measured_mechanical_power_W;

  % Copper loss at efficiency measurement point
  measured_copper_loss_W = measured_nominal_loss_W - measured_iron_loss_W;

  % Copper loss coefficient for copper loss model
  measured_copper_loss_coeff = measured_copper_loss_W/measured_torque_Nm^2;

  % Iron loss coefficient for iron loss model
  measured_iron_loss_coeff = measured_iron_loss_W/measured_speed_radps^2;

  % ---------------------------------------------------------------------------
  % Calculations below are done in x-y mesh.
  [w_radps_mat, trq_Nm_mat] = meshgrid(w_radps_vec, trq_Nm_vec);

  % Fixed electrical loss
  fixed_loss_mat = loss_const_W*ones(plot_resolution, plot_resolution);

  electrical_torque_mat = abs(trq_Nm_mat) - k_damp*w_radps_mat;  % Steady state
  copper_loss_mat = measured_copper_loss_coeff * electrical_torque_mat.^2;  % Copper loss model

  iron_loss_mat = measured_iron_loss_coeff * w_radps_mat.^2;  % Iron loss model

  % Total electrical losses
  electrical_losses_mat = fixed_loss_mat + copper_loss_mat + iron_loss_mat;

  mech_power_mat = trq_Nm_mat .* w_radps_mat;  % Mechanical power

  efficiency_percent_mat = 100 * abs(mech_power_mat) ./ (electrical_losses_mat + abs(mech_power_mat));

  torque_envelope_Nm_vec = min(max_motor_power_W ./ w_radps_vec, max_motor_torque_Nm);

  torque_envelope_vec_in_plot_unit = value(simscape.Value(torque_envelope_Nm_vec, "N*m"), plot_torque_unit);

  % A mask matrix with 1 for valid, 0 for invalid regions.
  % This is multiplied to the efficiency matrix to set regions over the maximum torque to 0.
  valid_torque_region_mask = trq_Nm_mat < torque_envelope_Nm_vec;

  valid_speed_region_mask = w_radps_mat < max_motor_speed_radps;

  % Apply the mask matrices.
  efficiency_percent_mat = valid_torque_region_mask .* efficiency_percent_mat;
  efficiency_percent_mat = valid_speed_region_mask .* efficiency_percent_mat;

else
  % External data set.
  % Some parameters such as MaxAngularSpeed are the fields of NameValuePair.DataSet.
  % Other parameters such as MaxTorque are the fields of NameValuePair.DataSet.ModelParams.

  if isfield(NameValuePair, "DataSet")
    DataSet = NameValuePair.DataSet;
  else
    DataSet = AbstractMotor1.AbstractMotorDataSet(Initialization=true);
  end  % if

  plot_speed_unit = string(unit(DataSet.PlotAngularSpeedUpperBound));
  plot_speed_upper_bound = value(DataSet.PlotAngularSpeedUpperBound);

  plot_torque_unit = string(unit(DataSet.PlotTorqueUpperBound));
  plot_torque_upper_bound = value(DataSet.PlotTorqueUpperBound);

  measured_efficiency_percent = DataSet.ModelParams.MeasuredEfficiencyPercent;
  measured_speed_in_plot_unit = value(DataSet.ModelParams.MeasuredAngularSpeed, plot_speed_unit);
  measured_torque_in_plot_unit = value(DataSet.ModelParams.MeasuredTorque, plot_torque_unit);

  contour_levels = DataSet.ContourLevelsPercent;
  show_text = DataSet.ShowContourText;
  show_torque_envelope = DataSet.ShowTorqueEnvelope;

  speed_vector_in_plot_unit = value(DataSet.AngularSpeedValues, plot_speed_unit);
  torque_vector_in_plot_unit = value(DataSet.TorqueValues, plot_torque_unit);

  torque_envelope_vec_in_plot_unit = value(DataSet.TorqueEnvelopeValues, plot_torque_unit);

  efficiency_percent_mat = DataSet.EfficiencyPercentMeshData;
end  % if

% -----------------------------------------------------------------------------
% Create a plot.

if isfield(NameValuePair, "ParentAxes")
  if class(NameValuePair.ParentAxes) == "matlab.graphics.axis.Axes"
    ax = NameValuePair.ParentAxes;
    target_fig = ax.Parent;
  else
    id = errorID + "InvalidParentAxes";
    msg = CodeUtil1.i18n("ParentAxes must be of type matlab.graphics.axis.Axes.");

    throw(MException(id, msg))

  end  % if
else
  target_fig = figure;
  if not(isMATLABReleaseOlderThan("R2025a"))
    target_fig.Theme = NameValuePair.Theme;
    target_fig.ThemeMode = NameValuePair.ThemeMode;
  end  % if
  ax = axes(target_fig);
end  % if

contourf(ax, speed_vector_in_plot_unit, torque_vector_in_plot_unit, efficiency_percent_mat, ...
  contour_levels, ShowText=show_text)

hold(ax, "on")
grid(ax, "on")

if show_torque_envelope
  % Draw torque envelope to hide the contour value text on the envelope.
  % The current way of showing the contour values on the envelope is not ideal because
  % the values are drawn on seemingly wrong locations, which could be misleading or confusing.
  % !todo: Ideally, delete the contour values that are drawn on the torque envelope curve.
  plot(ax, speed_vector_in_plot_unit, torque_envelope_vec_in_plot_unit, LineWidth=5)
end  % if

sct = scatter(ax, measured_speed_in_plot_unit, measured_torque_in_plot_unit);
sct.Marker = "x";
sct.LineWidth = 1;
sct.SizeData = 100;
sct.MarkerEdgeColor = "black";

xlim(ax, [0, plot_speed_upper_bound])
ylim(ax, [0, plot_torque_upper_bound])
xlabel(ax, CodeUtil1.i18n("Angular speed, $\omega$ (" + plot_speed_unit + ")"), Interpreter="latex")
ylabel(ax, CodeUtil1.i18n("Torque, $\tau$ (" + plot_torque_unit + ")"), Interpreter="latex")
title(ax, [
  CodeUtil1.i18n("Overall efficiency of abstract motor model (%)")
  CodeUtil1.i18n("Measured point (x): ") ...
  + measured_efficiency_percent + " %, " ...
  + measured_speed_in_plot_unit + " " + plot_speed_unit + ", " ...
  + measured_torque_in_plot_unit + " " + plot_torque_unit
  ])

if nargout > 0
  fig = target_fig;
end  % if
end  % function
