function [fig, ComputedData] = plotAbstractMotorEfficiency(NameValuePair)
% Make a contour plot of power conversion efficiency for the abstract motor model.
%
% To see a plot this function can create, run this function without arguments.
%
% This function can take arguments corresponding to the block parameters of
% the following blocks:
%
%   - Motor & Drive block, from Simscape Driveline
%     https://uk.mathworks.com/help/sdl/ref/motordrive.html
%
%   - Motor & Drive (System Level) block, from Simscape Electrical
%     https://uk.mathworks.com/help/sps/ref/motordrivesystemlevel.html
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
  NameValuePair.DataSet bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet {mustBeScalarOrEmpty}

  % ---------------------------------------------------------------------------
  % Options for direct data source

  NameValuePair.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500

  NameValuePair.PlotAutoRange (1,1) matlab.lang.OnOffSwitchState = "on"

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  NameValuePair.PlotContourLevelsPercent (1,:) double ...
    {mustBeInRange(NameValuePair.PlotContourLevelsPercent, 0, 100, "exclude-lower")} ...
    = [1 60 80 90 92 94 96 97 98 99]  %#ok<MUSTINRANGE> mustBeBetween is not available in R2024b.

  NameValuePair.ShowContourText (1,1) matlab.lang.OnOffSwitchState = "on"

  NameValuePair.ShowTorqueEnvelope (1,1) matlab.lang.OnOffSwitchState = "on"

  % --- torque

  NameValuePair.MaxTorque (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MaxTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(160, "N*m")

  NameValuePair.PlotTorqueUpperBound simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotTorqueUpperBound, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(200, "N*m")

  % --- angular speed

  NameValuePair.MaxAngularSpeedMode (1,1) string { mustBeMember(NameValuePair.MaxAngularSpeedMode, ["auto", "specify"]) } = "auto"

  % MaxAngularSpeedRate is ignored if MaxAngularSpeedMode is "specify".
  % MaxAngularSpeedRate is used to determine the maximum angular speed if MaxAngularSpeedMode is "auto".
  %
  % The maximum power P is divided by a value of the max motor torque T multiplied by this rate k,
  % which yields the maximum angular speed w; w = P/(k*T).
  % For example, if k=0.25, the max speed is a speed at 25 % of the max torque on the max power curve.
  NameValuePair.MaxAngularSpeedRate (1,1) double { mustBeInRange(NameValuePair.MaxAngularSpeedRate, 0, 1) } = 0.25  %#ok<MUSTINRANGE>

  % MaxAngularSpeed is ignored if MaxAngularSpeedMode is "auto".
  % MaxAngularSpeed is used if MaxAngularSpeedMode is "specify".
  %
  % In the road vehicle applications, maximum motor speed is determined by vehicle top speed,
  % tire rolling radius, and reduction gear ratio.
  NameValuePair.MaxAngularSpeed (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MaxAngularSpeed, "rad/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(17000, "rpm")

  % PlotAngularSpeedUpperBound is ignored if PlotRangeAngularSpeedMode is "auto".
  NameValuePair.PlotAngularSpeedUpperBound simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotAngularSpeedUpperBound, "rad/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(18000, "rpm")

  % --- power and others

  NameValuePair.MaxPower (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MaxPower, "kW"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(55, "kW")

  % ---------------------------------------------------------------------------
  % Electrical losses parameters

  NameValuePair.ElectricalEfficiencyPercent (1,1) double ...
    { mustBeInRange(NameValuePair.ElectricalEfficiencyPercent, 0, 100) } = 95  %#ok<MUSTINRANGE>

  NameValuePair.IdealMotorThresholdPercent (1,1) double ...
    { mustBeInRange(NameValuePair.IdealMotorThresholdPercent, 0, 100) } = 99.8  %#ok<MUSTINRANGE>

  NameValuePair.MeasuredAngularSpeed (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredAngularSpeed, "rpm"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(2000, "rpm")

  NameValuePair.MeasuredTorque (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
    = simscape.Value(50, "N*m")

  NameValuePair.MeasuredIronLosses (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.MeasuredIronLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(55, "W")

  NameValuePair.FixedLosses (1,1) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.FixedLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value(40, "W")

  % ---------------------------------------------------------------------------
  % Additional parameters

  % Force curve with constant power
  NameValuePair.PlotPowers (1,:) simscape.Value ...
    { simscape.mustBeCommensurateUnit(NameValuePair.PlotPowers, "kW"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
    = simscape.Value([10, 50, 100], "kW")

end  % arguments

arguments (Output)
  % Return a figure object so that functions like exportgraphics can work with the plot.
  fig matlab.ui.Figure {mustBeScalarOrEmpty}

  ComputedData struct {mustBeScalarOrEmpty}
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

  max_motor_torque_value_in_Nm = value(NameValuePair.MaxTorque, "N*m");
  max_motor_torque_value_in_plot_unit = value(NameValuePair.MaxTorque);

  if NameValuePair.PlotAutoRange
    plot_torque_unit_text = string(unit(NameValuePair.MaxTorque));
    plot_torque_upper_bound_value_in_plot_unit = max_motor_torque_value_in_plot_unit;
  else
    % PlotAutoRange is "off".
    plot_torque_unit_text = string(unit(NameValuePair.PlotTorqueUpperBound));
    plot_torque_upper_bound_value_in_plot_unit = value(NameValuePair.PlotTorqueUpperBound);
  end  % if

  torque_vector_in_plot_unit = linspace(0, max_motor_torque_value_in_plot_unit, plot_resolution);

  trq_Nm_vec = transpose(linspace(0, max_motor_torque_value_in_Nm, plot_resolution));
  computed_data.TorqueValues = simscape.Value(trq_Nm_vec, "N*m");

  % ---------------------------------------------------------------------------
  % angular speed

  if NameValuePair.MaxAngularSpeedMode == "auto"
    max_motor_speed_value_in_radps = max_motor_power_W / (NameValuePair.MaxAngularSpeedRate * max_motor_torque_value_in_Nm);
    plot_speed_unit_text = "rpm";
    plot_speed_upper_bound_value_in_plot_unit = value(simscape.Value(max_motor_speed_value_in_radps, "rad/s"), plot_speed_unit_text);
    max_motor_speed_value_in_plot_unit = plot_speed_upper_bound_value_in_plot_unit;

  else
    % MaxAngularSpeedMode is "specify".
    % Max angular speed is not a model parameter.
    max_motor_speed_value_in_plot_unit = value(NameValuePair.MaxAngularSpeed);
    max_motor_speed_value_in_radps = value(NameValuePair.MaxAngularSpeed, "rad/s");

    plot_speed_unit_text = string(unit(NameValuePair.PlotAngularSpeedUpperBound));
    plot_speed_upper_bound_value_in_plot_unit = value(NameValuePair.PlotAngularSpeedUpperBound);

  end  % if

  % !attention: Speed should avoid zero because it is used in the denominator when calculating torque envelope.
  speed_vector_in_plot_unit = linspace(1, max_motor_speed_value_in_plot_unit, plot_resolution);

  w_radps_vec = linspace(1, max_motor_speed_value_in_radps, plot_resolution);
  computed_data.AngularSpeedValues = transpose(simscape.Value(w_radps_vec, "rad/s"));

  speed_vector_for_const_power_in_plot_unit = linspace(1, plot_speed_upper_bound_value_in_plot_unit, plot_resolution);

  % ---------------------------------------------------------------------------
  contour_levels = NameValuePair.PlotContourLevelsPercent;
  if numel(contour_levels) <= 2
    id = errorID + "NotEnoughElements";
    msg = bevutil1.CodeUtil.i18n("Contour levels must have 3 or more elements.");

    throw(MException(id, msg))

  end  % if

  show_text = NameValuePair.ShowContourText;

  measured_electrical_efficiency_percent = NameValuePair.ElectricalEfficiencyPercent;

  is_ideal_motor = false;
  if NameValuePair.ElectricalEfficiencyPercent > NameValuePair.IdealMotorThresholdPercent
    % Treat the motor as an ideal motor, i.e., a motor without electrical losses.
    is_ideal_motor = true;
    show_text = false;
    show_torque_envelope = false;
    measured_copper_loss_coeff = 0;
    measured_iron_loss_coeff = 0;

  else
    % A non-ideal motor, i.e., a normal motor involving electrical losses.

    measured_speed_in_plot_unit = value(NameValuePair.MeasuredAngularSpeed, plot_speed_unit_text);
    measured_speed_in_radps = value(NameValuePair.MeasuredAngularSpeed, "rad/s");

    measured_torque_in_plot_unit = value(NameValuePair.MeasuredTorque, plot_torque_unit_text);
    measured_torque_in_Nm = value(NameValuePair.MeasuredTorque, "N*m");

    % Iron losses at electrical efficiency measurement point
    measured_iron_losses_W = value(NameValuePair.MeasuredIronLosses, "W");

    loss_const_W = value(NameValuePair.FixedLosses, "W");

    % Electrical power at electrical efficiency measurement point
    measured_electrical_power_W = measured_speed_in_radps * measured_torque_in_Nm;

    % Nominal (rated) power losses at electrical efficiency measurement point
    normalized_measured_electrical_efficiency = measured_electrical_efficiency_percent / 100;
    measured_nominal_losses_W = (1/normalized_measured_electrical_efficiency - 1) * measured_electrical_power_W;

    % Copper losses at electrical efficiency measurement point
    measured_copper_losses_W = measured_nominal_losses_W - measured_iron_losses_W - loss_const_W;

    if measured_copper_losses_W < 0
      id = errorID + "InvalidIronAndFixedLosses";
      msg = bevutil1.CodeUtil.i18n("The sum of iron losses and fixed losses cannot be greater than nominal losses.");
      throw(MException(id, msg))
    end

    % Copper loss coefficient for copper loss model
    measured_copper_loss_coeff = measured_copper_losses_W/measured_torque_in_Nm^2;

    % Iron loss coefficient for iron loss model
    measured_iron_loss_coeff = measured_iron_losses_W/measured_speed_in_radps^2;

  end  % if

  % ---------------------------------------------------------------------------
  % Calculations below are done in x-y mesh.

  torque_envelope_vec_in_Nm = min(max_motor_power_W ./ w_radps_vec, max_motor_torque_value_in_Nm);
  % !todo: Remove transpose when the "must be a vector" error is fixed.
  computed_data.TorqueEnvelopeValues = transpose(simscape.Value(torque_envelope_vec_in_Nm, "N*m"));

  torque_envelope_vec_in_plot_unit = value(simscape.Value(torque_envelope_vec_in_Nm, "N*m"), plot_torque_unit_text);

  [w_radps_mat, trq_Nm_mat] = meshgrid(w_radps_vec, trq_Nm_vec);

  % A mask matrix with 1 for valid, 0 for invalid regions.
  % This is multiplied to the efficiency matrix to set regions over the maximum torque to 0.
  valid_torque_region_mask = trq_Nm_mat <= torque_envelope_vec_in_Nm;

  valid_speed_region_mask = w_radps_mat <= max_motor_speed_value_in_radps;

  if is_ideal_motor
    efficiency_percent_mat = 100 * ones([numel(w_radps_vec), numel(trq_Nm_vec)]);

  else
    % Fixed electrical losses
    fixed_losses_mat = loss_const_W*ones(plot_resolution, plot_resolution);

    copper_losses_mat = measured_copper_loss_coeff * trq_Nm_mat.^2;  % Copper loss model

    iron_losses_mat = measured_iron_loss_coeff * w_radps_mat.^2;  % Iron loss model

    % Total electrical losses
    electrical_losses_mat = fixed_losses_mat + copper_losses_mat + iron_losses_mat;

    mech_power_mat = trq_Nm_mat .* w_radps_mat;  % Mechanical power

    efficiency_percent_mat = 100 * abs(mech_power_mat) ./ (electrical_losses_mat + abs(mech_power_mat));

  end  % if

  % Apply the mask matrices.
  efficiency_percent_mat = valid_torque_region_mask .* efficiency_percent_mat;
  efficiency_percent_mat = valid_speed_region_mask .* efficiency_percent_mat;

  computed_data.EfficiencyPercentMeshData = efficiency_percent_mat;

  % ---------------------------------------------------------------------------
  % Torque curves for constant power values
  powers = NameValuePair.PlotPowers;
  num_powers = numel(powers);
  Torque_const_power = simscape.Value(zeros(plot_resolution, num_powers), "N*m");
  for k = 1 : num_powers
    Torque_const_power(:, k) = powers(k) ./ transpose(simscape.Value(speed_vector_for_const_power_in_plot_unit, plot_speed_unit_text));
  end  % for

else
  % External data set.
  % Some parameters such as MaxAngularSpeed are the fields of NameValuePair.DataSet.
  % Other parameters such as MaxTorque are the fields of NameValuePair.DataSet.ModelParams.

  if isfield(NameValuePair, "DataSet")
    DataSet = NameValuePair.DataSet;
  else
    DataSet = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet(Initialization=true);
  end  % if

  powers = DataSet.PlotPowers;
  num_powers = numel(powers);

  % ---------------------------------------------------------------------------
  % power

  max_motor_power_W = value(DataSet.ModelParams.MaxPower, "W");

  % ---------------------------------------------------------------------------
  % torque

  show_torque_envelope = DataSet.ShowTorqueEnvelope;

  if DataSet.PlotAutoRange
    plot_torque_unit_text = string(unit(DataSet.ModelParams.MaxTorque));
    plot_torque_upper_bound_value_in_plot_unit = value(DataSet.ModelParams.MaxTorque);
  else
    % PlotAutoRange is "off".
    plot_torque_unit_text = string(unit(DataSet.PlotTorqueUpperBound));
    plot_torque_upper_bound_value_in_plot_unit = value(DataSet.PlotTorqueUpperBound);
  end  % if

  torque_vector_in_plot_unit = value(DataSet.TorqueValues, plot_torque_unit_text);

  % ---------------------------------------------------------------------------
  % angular speed

  if DataSet.PlotAutoRange
    if DataSet.MaxAngularSpeedMode == "auto"
      max_motor_torque_value_in_Nm = value(DataSet.ModelParams.MaxTorque, "N*m");
      max_motor_speed_value_in_radps = max_motor_power_W / (DataSet.MaxAngularSpeedRate * max_motor_torque_value_in_Nm);
      plot_speed_unit_text = "rpm";
      plot_speed_upper_bound_value_in_plot_unit = value(simscape.Value(max_motor_speed_value_in_radps, "rad/s"), plot_speed_unit_text);
    else
      % MaxAngularSpeedMode is "specify".
      plot_speed_unit_text = string(unit(DataSet.MaxAngularSpeed));
      plot_speed_upper_bound_value_in_plot_unit = value(DataSet.MaxAngularSpeed);
    end  % if
  else
    % PlotAutoRange is OFF: use the user-specified bound and unit.
    plot_speed_unit_text = string(unit(DataSet.PlotAngularSpeedUpperBound));
    plot_speed_upper_bound_value_in_plot_unit = value(DataSet.PlotAngularSpeedUpperBound);
  end  % if

  speed_vector_in_plot_unit = value(DataSet.AngularSpeedValues, plot_speed_unit_text);

  % ---------------------------------------------------------------------------
  contour_levels = DataSet.PlotContourLevelsPercent;

  show_text = DataSet.ShowContourText;

  measured_electrical_efficiency_percent = DataSet.ModelParams.ElectricalEfficiencyPercent;
  is_ideal_motor = measured_electrical_efficiency_percent > DataSet.ModelParams.IdealMotorThresholdPercent;

  if not(is_ideal_motor)
    measured_speed_in_plot_unit = value(DataSet.ModelParams.MeasuredAngularSpeed, plot_speed_unit_text);
    measured_torque_in_plot_unit = value(DataSet.ModelParams.MeasuredTorque, plot_torque_unit_text);
  end

  % ---------------------------------------------------------------------------

  efficiency_percent_mat = DataSet.EfficiencyPercentMeshData;

  torque_envelope_vec_in_plot_unit = value(DataSet.TorqueEnvelopeValues, plot_torque_unit_text);

  computed_data.TorqueValues = DataSet.TorqueValues;
  computed_data.AngularSpeedValues = DataSet.AngularSpeedValues;
  computed_data.TorqueEnvelopeValues = DataSet.TorqueEnvelopeValues;
  computed_data.EfficiencyPercentMeshData = DataSet.EfficiencyPercentMeshData;

  Torque_const_power = DataSet.TorqueValuesAtConstantPower;
  speed_vector_for_const_power_in_plot_unit = value(DataSet.AngularSpeedValuesForConstantPower, plot_speed_unit_text);

end  % if

% -----------------------------------------------------------------------------
% Create a plot.

if isfield(NameValuePair, "ParentAxes")
  % NameValuePair.ParentAxes is guaranteed to be of type matlab.graphics.axis.Axes.
  ax = NameValuePair.ParentAxes;
  target_fig = ax.Parent;
else
  target_fig = figure;
  if not(isMATLABReleaseOlderThan("R2025a"))
    target_fig.Theme = NameValuePair.Theme;
    target_fig.ThemeMode = NameValuePair.ThemeMode;
  end  % if
  ax = axes(target_fig);
end  % if

%% Plot
cla(ax)

contourf(ax, speed_vector_in_plot_unit, torque_vector_in_plot_unit, efficiency_percent_mat, ...
  contour_levels, ShowText=show_text)

hold(ax, "on")
grid(ax, "on")

if show_torque_envelope
  % Draw torque envelope to hide the contour value texts on the envelope curve.
  % The current way of showing the contour values on the envelope is not ideal because
  % the values are drawn on seemingly wrong locations, which could be confusing.
  % !todo: Ideally, delete the contour values that are drawn on the torque envelope curve.
  plot(ax, speed_vector_in_plot_unit, torque_envelope_vec_in_plot_unit, LineWidth=5)
end  % if

if is_ideal_motor
  ylabel(ax, bevutil1.CodeUtil.i18n("Torque, \tau, (" + plot_torque_unit_text + ")"), Interpreter="tex")
  title_text = bevutil1.CodeUtil.i18n("Motor operating region");
  title(ax, title_text, Interpreter="none")

else

  sct = scatter(ax, measured_speed_in_plot_unit, measured_torque_in_plot_unit);
  sct.Marker = "x";
  sct.LineWidth = 1;
  sct.SizeData = 100;
  sct.MarkerEdgeColor = "black";

  ylabel(ax, bevutil1.CodeUtil.i18n("Electrical torque, \tau, (" + plot_torque_unit_text + ")"), Interpreter="tex")

  title_text = bevutil1.CodeUtil.i18n("Electrical efficiency (%)");

  second_line_text = bevutil1.CodeUtil.i18n("Measurement point (X): ") ...
    + measured_electrical_efficiency_percent + " %, " ...
    + measured_speed_in_plot_unit + " " + plot_speed_unit_text + ", " ...
    + measured_torque_in_plot_unit + " " + plot_torque_unit_text;

  title(ax, [title_text; second_line_text], Interpreter="none")

end  % if

%------------------------------------------------------------------------------
% Torque curves at constant powers - dashed curves

dashed_line(1:num_powers) = matlab.graphics.chart.primitive.Line;
for k = 1 : num_powers
  dashed_line(k) = plot(ax, speed_vector_for_const_power_in_plot_unit, value(Torque_const_power(:, k), plot_torque_unit_text));
  dashed_line(k).LineWidth = 1;
  dashed_line(k).LineStyle = "--";  % Dashed line

  y = value(Torque_const_power(end, k), plot_torque_unit_text);
  str = "  " + value(powers(k), "kW");
  text(ax, plot_speed_upper_bound_value_in_plot_unit, y, str)
end  % for

y = value(Torque_const_power(end, num_powers), plot_torque_unit_text);
str = " kW" + newline + " ";
text(ax, plot_speed_upper_bound_value_in_plot_unit, y, str, VerticalAlignment="bottom")

%------------------------------------------------------------------------------

xlim(ax, [0, plot_speed_upper_bound_value_in_plot_unit])
xlabel(ax, bevutil1.CodeUtil.i18n("Angular speed, \omega (" + plot_speed_unit_text + ")"), Interpreter="tex")

ylim(ax, [0, plot_torque_upper_bound_value_in_plot_unit])

%------------------------------------------------------------------------------
if nargout > 0
  fig = target_fig;
  ComputedData = computed_data;
end  % if
end  % function
