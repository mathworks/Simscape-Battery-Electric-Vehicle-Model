function App = MotorDriveUnit_SystemThermalModelEfficiencyApp()
%% Motor drive unit efficiency app for the System MDU model
% This is a uifigure-based app.
%
% This app preloads the target subsystem reference model in the Model file drop down.

% Copyright 2025 The MathWorks, Inc.

app_setup.ParameterFile = "MotorDriveUnit_SystemThermal_params";

app_setup.ModelName = "MotorDriveUnit_SystemThermal_refsub";
% This must include the file extension.
model_file = app_setup.ModelName + ".mdl";

% -----------------------------------------------------------------------------
% Build app

disp(CodeUtil1.i18n("Opening app"))
disp(CodeUtil1.i18n("Loading parameters: ") + app_setup.ParameterFile)
disp(CodeUtil1.i18n("Loading model: ") + app_setup.ModelName)

app_ui = build_app_ui(app_setup);

% -----------------------------------------------------------------------------
% Steps after building app

% Load parameters that are used by the model.
evalin("base", app_setup.ParameterFile)

% Preload the model to the model drop down for convenience.
% This is allowed after BlockSelectorUI is fully built.
app_ui.SelectorUI.ModelFileFullPath = FileUtil1.getFileFullPath(model_file);

% Run this callback to update the edit fields with workspace variables.
app_ui.SelectorUI.GetParametersFromBlockCallback()

Show(app_ui.Window)
% -----------------------------------------------------------------------------
if nargout > 0
  App = app_ui;
end  % if
end  % function

function AppUIStruct = build_app_ui(AppSetup)
%%

arguments (Output)
  AppUIStruct (1,1) struct
end  % arguments

torque_units = ["N*m", "lbf*in"];
power_units = ["kW", "W"];
speed_units = ["rpm", "rev/s", "rad/s"];

% todo: Remove "N*m*s/rad" because "N*m/(rad/s)" must suffice for it.
% Currently both are necessary because they are treated as different texts.
friction_units = ["N*m/(rad/s)" "N*m*s/rad" "N*m/(rev/s)" "N*m/rpm" "lbf*in/(rad/s)" "lbf*in/(rev/s)" "lbf*in/rpm"];

% -----------------------------------------------------------------------------

width_unit = LiteApp8.Constant.Width{"unitwidth"};
name_ui_width = width_unit * 28;
button_width = width_unit * 12;
physical_unit_ui_width = width_unit * 12;

oneline_height = LiteApp8.Constant.Height{"oneline"};

% =============================================================================

AppUIStruct.Window = LiteApp8.LiteAppWindow;

AppUIStruct.Window.HeaderUI.AppSourceName = mfilename;

AppUIStruct.Window.Name = CodeUtil1.i18n("Motor Efficiency App for System Thermal MDU Model");

AppUIStruct.Window.Width = 1200;
right_pane_width = 500;

AppUIStruct.Window.Height = 570;
plot_panel_height = 380;

layout = AppUIStruct.Window.MainLayout;

% =============================================================================
area = NewArea(layout);

% =============================================================================
% Left side of app window
column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
label_ui.ComponentHeight = oneline_height * 4;
label_ui.Text = CodeUtil1.i18n( ...
join([
  "This app works with Motor & Drive (System Level) block from Simscape Electrical."
  "The app assumes that the block is configured as follows."
  "1) Electro-motive force is parameterized by maximum torque and power."
  "2) Electrical losses are parameterized by single efficiency measurement."
  "For more details, see the Description."
  ], " "));

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

target_file = CodeUtil1.i18n("MotorDriveUnit_Description.html");
% Check that the file exists. If not, this prevents the app from showing up.
FileUtil1.getFileFullPath(target_file);

AppUIStruct.DocLinkUI = LiteApp8.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
AppUIStruct.DocLinkUI.Text = "Description";
AppUIStruct.DocLinkUI.HyperlinkClickedCallback = @() web(target_file);
AppUIStruct.DocLinkUI.MainHyperlink.Tooltip = CodeUtil1.i18n("Open the component description page.");
% Adjust the height and vertical alignment of the hyperlink component:
AppUIStruct.DocLinkUI.ComponentHeight = oneline_height + 4;
AppUIStruct.DocLinkUI.VerticalAlignment = "bottom";

AppUIStruct.OpenModelButtonUI = LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenModelButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenModelButtonUI.Text = CodeUtil1.i18n("Open model");
AppUIStruct.OpenModelButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Open the loaded model.");
AppUIStruct.OpenModelButtonUI.ButtonPushedCallback = @() callbackOpenSystem(AppSetup.ModelName);

AppUIStruct.OpenSetupButtonUI= LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenSetupButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenSetupButtonUI.Text = CodeUtil1.i18n("Open setup");
AppUIStruct.OpenSetupButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Open the loaded parameter setup script.");
AppUIStruct.OpenSetupButtonUI.ButtonPushedCallback = @() edit(AppSetup.ParameterFile);

AppUIStruct.RefreshButtonUI = LiteApp8.Component.Button(NewSlot(layout, row));
AppUIStruct.RefreshButtonUI.ComponentWidth = button_width;
AppUIStruct.RefreshButtonUI.HorizontalAlignment = "left";
AppUIStruct.RefreshButtonUI.Text = CodeUtil1.i18n("Refresh");
AppUIStruct.RefreshButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Refresh the values. Use this button if edit fields are using workspace variables.");
AppUIStruct.RefreshButtonUI.ButtonPushedCallback = @() callbackReloadValues();

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=8);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.Text = "\textbf{" + CodeUtil1.i18n("Parameters") + "}";
label_ui.ComponentWidth = name_ui_width;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxSpeedUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxSpeedUI.Name = CodeUtil1.i18n("Continuous operation max speed");
AppUIStruct.MaxSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxSpeedUI.UnitItems = speed_units;
AppUIStruct.MaxSpeedUI.Unit = "rpm";
AppUIStruct.MaxSpeedUI.Value = "15000";
AppUIStruct.MaxSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxTorqueUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxTorqueUI.Name = CodeUtil1.i18n("Continuous operation max torque");
AppUIStruct.MaxTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxTorqueUI.UnitItems = torque_units;
AppUIStruct.MaxTorqueUI.Unit = "N*m";
AppUIStruct.MaxTorqueUI.Value = "420";
AppUIStruct.MaxTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxPowerUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxPowerUI.Name = CodeUtil1.i18n("Continuous operation max power");
AppUIStruct.MaxPowerUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxPowerUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxPowerUI.UnitItems = power_units;
AppUIStruct.MaxPowerUI.Unit = "kW";
AppUIStruct.MaxPowerUI.Value = "220";
AppUIStruct.MaxPowerUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.EfficiencyUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.EfficiencyUI.Name = CodeUtil1.i18n("Overall efficiency, $\eta_{meas}(\omega_{meas}, \tau_{meas})$");
AppUIStruct.EfficiencyUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.EfficiencyUI.NameUIWidth = name_ui_width;
AppUIStruct.EfficiencyUI.UnitAlias = "\%";
AppUIStruct.EfficiencyUI.Value = "95";
AppUIStruct.EfficiencyUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredSpeedUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredSpeedUI.Name = CodeUtil1.i18n("Speed at which $\eta_{meas}$ is measured, $\omega_{meas}$");
AppUIStruct.MeasuredSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitItems = speed_units;
AppUIStruct.MeasuredSpeedUI.Unit = "rpm";
AppUIStruct.MeasuredSpeedUI.Value = "2000";
AppUIStruct.MeasuredSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredTorqueUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredTorqueUI.Name = CodeUtil1.i18n("Torque at which $\eta_{meas}$ is measured, $\tau_{meas}$");
AppUIStruct.MeasuredTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitItems = torque_units;
AppUIStruct.MeasuredTorqueUI.Unit = "N*m";
AppUIStruct.MeasuredTorqueUI.Value = "50";
AppUIStruct.MeasuredTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.IronLossUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.IronLossUI.Name = CodeUtil1.i18n("Iron loss, $P_{iron}$, at $\eta_{meas}$ point");
AppUIStruct.IronLossUI.NameUIWidth = name_ui_width;
AppUIStruct.IronLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.IronLossUI.UnitItems = power_units;
AppUIStruct.IronLossUI.Unit = "W";
AppUIStruct.IronLossUI.Value = "55";
AppUIStruct.IronLossUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.FixedLossUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.FixedLossUI.Name = CodeUtil1.i18n("Fixed loss, $P_{fixed}$, at $\eta_{meas}$ point");
AppUIStruct.FixedLossUI.NameUIWidth = name_ui_width;
AppUIStruct.FixedLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.FixedLossUI.UnitItems = power_units;
AppUIStruct.FixedLossUI.Unit = "W";
AppUIStruct.FixedLossUI.Value = "40";
AppUIStruct.FixedLossUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.RotorDampingUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.RotorDampingUI.Name = CodeUtil1.i18n("Rotor damping, $k_f$");
AppUIStruct.RotorDampingUI.NameUIWidth = name_ui_width;
AppUIStruct.RotorDampingUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.RotorDampingUI.UnitItems = friction_units;
AppUIStruct.RotorDampingUI.Unit = "N*m/(rad/s)";
AppUIStruct.RotorDampingUI.Value = "1e-05";
AppUIStruct.RotorDampingUI.ValueChangedCallback = @() auto_update();

% =============================================================================
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = "\textbf{" + CodeUtil1.i18n("Derived parameters") + "}";

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

% Nominal loss (total loss) at efficiency measurement point
% nominal_loss_eff = (1/eff_norm - 1) * mechpow_eff;

AppUIStruct.NominalLossUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.NominalLossUI.Name = CodeUtil1.i18n("Nominal loss, $P_{nom}$, at $\eta_{meas}$ point");
AppUIStruct.NominalLossUI.NameUIWidth = name_ui_width;
AppUIStruct.NominalLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.NominalLossUI.UnitItems = power_units;
AppUIStruct.NominalLossUI.Unit = "W";
AppUIStruct.NominalLossUI.Value = "550";
AppUIStruct.NominalLossUI.ValueReadOnly = true;
AppUIStruct.NominalLossUI.UnitChangedCallback = @() update_nominal_loss_value();

% This is updated by update_derived_parameters function.
nominal_loss = AppUIStruct.NominalLossUI.SimscapeValue;

  function update_nominal_loss_value()
    new_unit = AppUIStruct.NominalLossUI.Unit;
    AppUIStruct.NominalLossUI.Value = value(nominal_loss, new_unit);
  end  % nested function

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.LossRatioUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.LossRatioUI.Name = CodeUtil1.i18n("Iron to nominal loss ratio, $P_{iron}/P_{nom}$");
AppUIStruct.LossRatioUI.NameUIWidth = name_ui_width;
AppUIStruct.LossRatioUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.LossRatioUI.UnitAlias = "\%";
AppUIStruct.LossRatioUI.Value = "10";
AppUIStruct.LossRatioUI.ValueReadOnly = true;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.CopperLossUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.CopperLossUI.Name = CodeUtil1.i18n("Copper loss, $P_{copper}$, at $\eta_{meas}$ point");
AppUIStruct.CopperLossUI.NameUIWidth = name_ui_width;
AppUIStruct.CopperLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.CopperLossUI.UnitItems = power_units;
AppUIStruct.CopperLossUI.Unit = "W";
AppUIStruct.CopperLossUI.Value = "500";
AppUIStruct.CopperLossUI.ValueReadOnly = true;
AppUIStruct.CopperLossUI.UnitChangedCallback = @() update_copper_loss_value();

% This is updated by update_derived_parameters function.
copper_loss = AppUIStruct.CopperLossUI.SimscapeValue;

  function update_copper_loss_value()
    new_unit = AppUIStruct.CopperLossUI.Unit;
    AppUIStruct.CopperLossUI.Value = value(copper_loss, new_unit);
  end  % nested function

% =============================================================================
% Right side of app window

column = NewColumn(layout, area, Width=right_pane_width);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.PlotButtonUI = LiteApp8.Component.EnabledButton(NewSlot(layout, row, Width="fit"));
AppUIStruct.PlotButtonUI.HorizontalAlignment = "left";
AppUIStruct.PlotButtonUI.ButtonUIWidth = button_width + width_unit;
AppUIStruct.PlotButtonUI.ButtonWidth = button_width;
AppUIStruct.PlotButtonUI.CheckBoxUIWidth = "fit";
AppUIStruct.PlotButtonUI.CheckBoxWidth = "fit";
AppUIStruct.PlotButtonUI.ButtonText = CodeUtil1.i18n("Update");
AppUIStruct.PlotButtonUI.ButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "tool_rotate_3d.png");
AppUIStruct.PlotButtonUI.CheckBoxText = CodeUtil1.i18n("Auto-update");
AppUIStruct.PlotButtonUI.ButtonPushedCallback = @() update_plot(AppUIStruct.AxesUI.MainAxes);
% Set false to auto-update and keep it until the entire app is ready.
AppUIStruct.PlotButtonUI.ButtonDisable = "on";

AppUIStruct.OpenInFigureWindowUI = LiteApp8.Component.Hyperlink(NewSlot(layout, row));
AppUIStruct.OpenInFigureWindowUI.Text = CodeUtil1.i18n("Open in figure window");
AppUIStruct.OpenInFigureWindowUI.HorizontalAlignment = "right";
AppUIStruct.OpenInFigureWindowUI.HyperlinkClickedCallback = @() create_plot_window();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.AxesUI = LiteApp8.Graphics.Axes(NewSlot(layout, row));
AppUIStruct.AxesUI.ComponentHeight = plot_panel_height;

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % small vertical gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.ContoursUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.ContoursUI.Name = CodeUtil1.i18n("Contour levels");
AppUIStruct.ContoursUI.NameUIWidth = width_unit * 12;
AppUIStruct.ContoursUI.UnitUIWidth = width_unit * 5;
AppUIStruct.ContoursUI.UnitAlias = "\%";
AppUIStruct.ContoursUI.Value = "[1 60 80 90 92 94 96 97 98 99]";
AppUIStruct.ContoursUI.ValueEditFieldUI.MainEditField.Tooltip = CodeUtil1.i18n("Only a plain number array such as [1, 80, 90, 99] is allowed.");
AppUIStruct.ContoursUI.ValueChangedCallback = @() auto_update();

% =============================================================================
area = NewArea(layout);
column = NewColumn(layout, area);

NewRow(layout, column, Height=4);  % vertical small gap
% -----------------------------------------------------------------------------
row = NewRow(layout, column);
LiteApp8.Component.HorizontalLine(NewSlot(layout, row));
% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.SelectorUI = LiteApp8.Component.BlockSelectorUI(NewSlot(layout, row));
AppUIStruct.SelectorUI.MainFigure = AppUIStruct.Window.MainFigure;
AppUIStruct.SelectorUI.TargetSimscapeBlockNames = "Motor & Drive" + newline + "(System Level)";
AppUIStruct.SelectorUI.GetParametersFromBlockCallback = @() getParametersFromBlock();
AppUIStruct.SelectorUI.SetParametersToBlockCallback = @() setParametersToBlock();
AppUIStruct.SelectorUI.SetParametersToBlockUI.MainButton.Tooltip = CodeUtil1.i18n("Set button does nothing in this app.");

% ---------------------------------------------------------------------------
% callbacks

  function update_derived_parameters()
    %%
    measured_speed = AppUIStruct.MeasuredSpeedUI.SimscapeValue;
    measured_torque = AppUIStruct.MeasuredTorqueUI.SimscapeValue;
    efficiency_percent = AppUIStruct.EfficiencyUI.SimscapeValue;
    iron_loss = AppUIStruct.IronLossUI.SimscapeValue;

    mechanical_power = measured_speed * measured_torque;
    normalized_efficiency = efficiency_percent / 100;

    % Nominal loss (total loss) at efficiency measurement point
    nominal_loss = (1/normalized_efficiency - 1) * mechanical_power;
    nominal_loss_unit = AppUIStruct.NominalLossUI.Unit;  % Use currently selected unit
    AppUIStruct.NominalLossUI.Value = value(nominal_loss, nominal_loss_unit);

    iron_to_nominal_loss_ratio_percent = iron_loss / nominal_loss * 100;
    AppUIStruct.LossRatioUI.Value = value(iron_to_nominal_loss_ratio_percent, "1");

    % Copper loss at efficiency measurement point
    copper_loss = nominal_loss - iron_loss;
    copper_loss_unit = AppUIStruct.CopperLossUI.Unit;  % Use currently selected unit
    AppUIStruct.CopperLossUI.Value = value(copper_loss, copper_loss_unit);

  end  % function

  function update_plot(parent)
    %%

    max_speed = AppUIStruct.MaxSpeedUI.SimscapeValue;
    max_torque = AppUIStruct.MaxTorqueUI.SimscapeValue;
    max_power = AppUIStruct.MaxPowerUI.SimscapeValue;
    efficiency_percent = AppUIStruct.EfficiencyUI.SimscapeValue;
    measured_speed = AppUIStruct.MeasuredSpeedUI.SimscapeValue;
    measured_torque = AppUIStruct.MeasuredTorqueUI.SimscapeValue;
    loss_ratio = AppUIStruct.LossRatioUI.SimscapeValue;
    fixed_loss = AppUIStruct.FixedLossUI.SimscapeValue;
    rotor_damping = AppUIStruct.RotorDampingUI.SimscapeValue;

    contour_levels = simscape.Value(transpose(CodeUtil1.getNumberArrayFromString(AppUIStruct.ContoursUI.Value)), "1");

    MotorDriveUnit_EfficiencyPlot( ParentAxes=parent, ...
      MaxSpeed = max_speed, ...
      MaxTorque = max_torque, ...
      MaxPower = max_power, ...
      EfficiencyPercent = efficiency_percent, ...
      MeasuredSpeed = measured_speed, ...
      MeasuredTorque = measured_torque, ...
      IronToNominalLossRatioPercent = loss_ratio, ...
      FixedLoss = fixed_loss, ...
      RotorDamping = rotor_damping, ...
      ContourLevelsPercent = contour_levels, ...
      PlotResolution = 500 );

  end  % nested function

  function create_plot_window()
    %%
    update_derived_parameters()
    parent = axes(figure);
    update_plot(parent)
  end  % nested function

  function auto_update()
    %%
    update_derived_parameters()
    if AppUIStruct.PlotButtonUI.CheckBoxUI.Value
      update_plot(AppUIStruct.AxesUI.MainAxes)
    end  % if
  end  % nested function

  function callbackReloadValues()
    %%
    % Preserve the current auto-update state and disable it.
    prev_auto_update = AppUIStruct.PlotButtonUI.CheckBoxUI.Value;
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = false;
    % ---------------------------------------------------------------------------
    % Assignment triggers updates.

    x = AppUIStruct.MaxTorqueUI.Value;
    AppUIStruct.MaxTorqueUI.Value = x;

    x = AppUIStruct.MaxPowerUI.Value;
    AppUIStruct.MaxPowerUI.Value = x;

    x = AppUIStruct.EfficiencyUI.Value;
    AppUIStruct.EfficiencyUI.Value = x;

    x = AppUIStruct.MeasuredSpeedUI.Value;
    AppUIStruct.MeasuredSpeedUI.Value = x;

    x = AppUIStruct.MeasuredTorqueUI.Value;
    AppUIStruct.MeasuredTorqueUI.Value = x;

    x = AppUIStruct.IronLossUI.Value;
    AppUIStruct.IronLossUI.Value = x;

    x = AppUIStruct.FixedLossUI.Value;
    AppUIStruct.FixedLossUI.Value = x;

    x = AppUIStruct.RotorDampingUI.Value;
    AppUIStruct.RotorDampingUI.Value = x;

    update_derived_parameters()

    % ---------------------------------------------------------------------------
    % Restore the previous state.
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = prev_auto_update;
    auto_update()
  end  % nested function

  function getParametersFromBlock()
    %%
    % Use get_param to get the unevaluated text in the Block Parameters window.
    % Assignment to the Unit or Value of PhysicalValueUI takes care of the rest.

    % Preserve the current auto-update state and disable it.
    prev_auto_update = AppUIStruct.PlotButtonUI.CheckBoxUI.Value;
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = false;
    % -------------------------------------------------------------------------

    % This callback is for the block selector UI, thus it is safe to access its BlockPath.
    block_path = AppUIStruct.SelectorUI.BlockPath;

    AppUIStruct.MaxTorqueUI.Unit = get_param(block_path, "torque_max_unit");
    AppUIStruct.MaxTorqueUI.Value = get_param(block_path, "torque_max");

    AppUIStruct.MaxPowerUI.Unit = get_param(block_path, "power_max_unit");
    AppUIStruct.MaxPowerUI.Value = get_param(block_path, "power_max");

    AppUIStruct.EfficiencyUI.Value = get_param(block_path, "eff");

    AppUIStruct.MeasuredSpeedUI.Unit = get_param(block_path, "w_eff_unit");
    AppUIStruct.MeasuredSpeedUI.Value = get_param(block_path, "w_eff");

    AppUIStruct.MeasuredTorqueUI.Unit = get_param(block_path, "T_eff_unit");
    AppUIStruct.MeasuredTorqueUI.Value = get_param(block_path, "T_eff");

    AppUIStruct.IronLossUI.Unit = get_param(block_path, "Piron_unit");
    AppUIStruct.IronLossUI.Value = get_param(block_path, "Piron");

    AppUIStruct.FixedLossUI.Unit = get_param(block_path, "Pbase_unit");
    AppUIStruct.FixedLossUI.Value = get_param(block_path, "Pbase");

    % Assume that rotor damping is defined in the Motor & Drive (System Level) block.
    AppUIStruct.RotorDampingUI.Unit = get_param(block_path, "lam_unit");
    AppUIStruct.RotorDampingUI.Value = get_param(block_path, "lam");

    update_derived_parameters()

    % -------------------------------------------------------------------------
    % Restore the previous auto-update state.
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = prev_auto_update;
    auto_update()
  end  % nested function

  function setParametersToBlock()
    %%
    msg = CodeUtil1.i18n("In this app, the Set button does not set parameters to the block.");
    disp(msg)
  end  % nested function

% -----------------------------------------------------------------------------
% Final step of building app UI
AppUIStruct.PlotButtonUI.CheckBoxUI.Value = true;
auto_update()
end  % function

function callbackOpenSystem(modelName)
%%
disp(CodeUtil1.i18n("Opening the model: ") + modelName)
open_system(modelName)
end  % function
