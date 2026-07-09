function fig = plotRotationalFrictionTorque(NameValuePair)
% Make a plot of rotational friction torque model.
%
% To see what plot this function creates, run this function without any arguments.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % These are valid only when 1) MATLAB is R2025a or newer and 2) ParentAxes is not specified.
  NameValuePair.Theme {mustBeMember(NameValuePair.Theme, ["light", "dark"])} = "light"
  NameValuePair.ThemeMode {mustBeMember(NameValuePair.ThemeMode, ["auto", "manual"])} = "auto"

  NameValuePair.DataSource (1,1) string {mustBeMember(NameValuePair.DataSource, ["direct", "dataset"])} = "direct"

  % DataSet is ignored if DataSource is "direct".
  NameValuePair.DataSet bev1mus.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet {mustBeScalarOrEmpty}

  % ---------------------------------------------------------------------------
  % Options for the direct data source

  NameValuePair.BreakawayTorque (1,1) simscape.Value = simscape.Value(25, "N*m")
  NameValuePair.BreakawayVelocity (1,1) simscape.Value = simscape.Value(0.1, "rad/s")
  NameValuePair.CoulombTorque (1,1) simscape.Value = simscape.Value(20, "N*m")
  NameValuePair.ViscousCoefficient (1,1) simscape.Value = simscape.Value(0.001, "N*m/(rad/s)")

  NameValuePair.ShowStribeckTorque (1,1) logical = true
  NameValuePair.ShowCoulombTorque (1,1) logical = true
  NameValuePair.ShowViscousTorque (1,1) logical = true

  NameValuePair.PlotAngularVelocityUnit (1,1) simscape.Unit {simscape.mustBeCommensurateUnit(NameValuePair.PlotAngularVelocityUnit, "rad/s")} = "rad/s"
  NameValuePair.PlotTorqueUnit (1,1) simscape.Unit {simscape.mustBeCommensurateUnit(NameValuePair.PlotTorqueUnit, "N*m")} = "N*m"

  NameValuePair.NumVelocityValues (1,1) double {mustBeInteger, mustBePositive} = 200

end  % arguments

arguments (Output)
  % Return a figure object so that functions like exportgraphics can work with the plot.
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

% -----------------------------------------------------------------------------
% Collect properties from the specified data source.

if NameValuePair.DataSource == "direct"
  % Direct data source.
  % All parameters are the fields of NameValuePair.

  breakaway_torque = NameValuePair.BreakawayTorque;
  breakaway_velocity = NameValuePair.BreakawayVelocity;
  coulomb_torque = NameValuePair.CoulombTorque;
  viscous_coefficient = NameValuePair.ViscousCoefficient;

  show_stribeck_torque = NameValuePair.ShowStribeckTorque;
  show_coulomb_torque = NameValuePair.ShowCoulombTorque;
  show_viscous_torque = NameValuePair.ShowViscousTorque;

  plot_velocity_unit = NameValuePair.PlotAngularVelocityUnit;
  plot_torque_unit = NameValuePair.PlotTorqueUnit;

  num_velocity_values = NameValuePair.NumVelocityValues;

  % Derived parameters.
  stribeck_scaled_torque = sqrt(2 * exp(1)) * (breakaway_torque - coulomb_torque);
  stribeck_threshold_velocity = sqrt(2) * breakaway_velocity;
  coulomb_threshold_velocity = breakaway_velocity / 10;

  % Determine the plot range in x-axis (velocity) from the friction model.
  threshold_velocity = value(stribeck_threshold_velocity);
  velocity_hi = floor(5 * threshold_velocity);
  if velocity_hi < 1
    velocity_hi = 5 * threshold_velocity;
  end
  upper_bound = simscape.Value(velocity_hi, unit(stribeck_threshold_velocity));
  lower_bound = -upper_bound;
  velocity_values = transpose(linspace(lower_bound, upper_bound, num_velocity_values));

  velocity_min = lower_bound;
  velocity_max = upper_bound;

  coeff = viscous_coefficient;
  viscous_torque_values = coeff * velocity_values;  % !friction-model

  trq_c = coulomb_torque;
  th_c = coulomb_threshold_velocity;
  coulomb_torque_values = trq_c * tanh(velocity_values ./ th_c);  % !friction-model

  scale_s = stribeck_scaled_torque;
  th_s = stribeck_threshold_velocity;
  stribeck_torque_values = scale_s * (velocity_values ./ th_s .* exp(-(velocity_values ./ th_s).^2));  % !friction-model

  torque_values = stribeck_torque_values + coulomb_torque_values + viscous_torque_values;  % !friction-model

else
  % External data set.

  if isfield(NameValuePair, "DataSet")
    data_source = NameValuePair.DataSet;
  else
    data_source = bev1mus.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet( ...
      Initialization=true);
  end  % if

  stribeck_threshold_velocity = data_source.ModelParams.StribeckThresholdVelocity;
  coulomb_threshold_velocity = data_source.ModelParams.CoulombThresholdVelocity;

  plot_velocity_unit = data_source.PlotAngularVelocityUnit;
  plot_torque_unit = data_source.PlotTorqueUnit;

  show_stribeck_torque = data_source.ShowStribeckTorque;
  show_coulomb_torque = data_source.ShowCoulombTorque;
  show_viscous_torque = data_source.ShowViscousTorque;

  velocity_values = data_source.VelocityValues;
  velocity_min = data_source.VelocityMin;
  velocity_max = data_source.VelocityMax;

  torque_values = data_source.TorqueValues;
  stribeck_torque_values = data_source.StribeckTorqueValues;
  coulomb_torque_values = data_source.CoulombTorqueValues;
  viscous_torque_values = data_source.ViscousTorqueValues;

end  % if

% -----------------------------------------------------------------------------
% Create a plot.

if isfield(NameValuePair, "ParentAxes")
  % NameValuePair.ParentAxes is of type matlab.graphics.axis.Axes.
  ax = NameValuePair.ParentAxes;
  target_fig = ax.Parent;
else
  target_fig = figure;
  if not(isMATLABReleaseOlderThan("R2025a"))
    target_fig.ThemeMode = NameValuePair.ThemeMode;
    target_fig.Theme = NameValuePair.Theme;
  end  % if
  ax = axes(target_fig);
end  % if

cla(ax)

vel = value(velocity_values, plot_velocity_unit);
trq = value(torque_values, plot_torque_unit);

plot(ax, vel, trq, LineWidth=2.6, DisplayName="All")

hold(ax, "on")

if show_stribeck_torque
  y = value(stribeck_torque_values, plot_torque_unit);
  plot(ax, vel, y, LineWidth=2.1, LineStyle="--", DisplayName="Stribeck")
  x = value(stribeck_threshold_velocity, plot_velocity_unit);
  xregion(ax, -x, x, DisplayName="Stribeck threshold")
end  % if

if show_coulomb_torque
  y = value(coulomb_torque_values, plot_torque_unit);
  plot(ax, vel, y, LineWidth=1.6, LineStyle=":", DisplayName="Coulomb")
  x = value(coulomb_threshold_velocity, plot_velocity_unit);
  xregion(ax, -x, x, DisplayName="Coulomb threshold")
end  % if

if show_viscous_torque
  y = value(viscous_torque_values, plot_torque_unit);
  plot(ax, vel, y, LineWidth=1.1, LineStyle="-.", DisplayName="Viscous")
end  % if

grid(ax, "on")

xlabel(ax, "Angular velocity, $\omega$ (" + string(plot_velocity_unit) + ")", Interpreter="latex")
ylabel(ax, "Friction torque, $T$ (" + string(plot_torque_unit) + ")", Interpreter="latex")

x_lo = value(velocity_min, plot_velocity_unit);
x_hi = value(velocity_max, plot_velocity_unit);
xlim(ax, [x_lo, x_hi])

trq_hi = max(abs(value(torque_values, plot_torque_unit)));
ylim(ax, [-trq_hi, trq_hi])

if show_stribeck_torque || show_coulomb_torque || show_viscous_torque
  legend(ax, Location="best")
else
  legend(ax, "off")
end  % if

if nargout > 0
  fig = target_fig;
end  % if
end  % function
