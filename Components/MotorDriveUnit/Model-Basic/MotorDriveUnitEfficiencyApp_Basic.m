function App = MotorDriveUnitEfficiencyApp_Basic()
%% Motor drive unit efficiency app for the Basic MDU model
% This is a uifigure-based app.
%
% This app preloads the target subsystem reference model in the Model file drop down.

% Copyright 2025 The MathWorks, Inc.

app_setup.ParameterFile = "MotorDriveUnit_refsub_Basic_params";

app_setup.ModelName = "MotorDriveUnit_refsub_Basic";
% This must include the file extension.
model_file = app_setup.ModelName + ".mdl";

% -----------------------------------------------------------------------------
% Build app

disp(LiteApp5.Utility.i18n("Opening app"))
disp(LiteApp5.Utility.i18n("Loading parameters: ") + app_setup.ParameterFile)
disp(LiteApp5.Utility.i18n("Loading model: ") + app_setup.ModelName)

app_ui = build_app_ui(app_setup);

% -----------------------------------------------------------------------------
% Steps after building app

% Load parameters that are used by the model.
evalin("base", app_setup.ParameterFile)

% Preload the model to the model drop down for convenience.
% This is allowed after BlockSelectorUI is fully built.
app_ui.SelectorUI.ModelFileFullPath = LiteApp5.Utility.getFileFullPath(model_file);

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

width_unit = LiteApp5.Utility.Constant.Width{"unitwidth"};
name_ui_width = width_unit * 28;
button_width = width_unit * 12;
physical_unit_ui_width = width_unit * 12;

oneline_height = LiteApp5.Utility.Constant.Height{"oneline"};

% =============================================================================

AppUIStruct.Window = LiteApp5.LiteAppWindow;

AppUIStruct.Window.HeaderUI.AppSourceName = mfilename;

AppUIStruct.Window.Name = LiteApp5.Utility.i18n("Motor Efficiency App for Basic MDU Model");

AppUIStruct.Window.Width = 1200;
right_pane_width = 500;

AppUIStruct.Window.Height = 540;
plot_panel_height = 380;

layout = AppUIStruct.Window.MainLayout;

% =============================================================================
area = NewArea(layout);

% =============================================================================
% Left side of app window
column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.ComponentHeight = oneline_height * 2;
label_ui.Text = LiteApp5.Utility.i18n( ...
join([
  "This app works with Motor & Drive block from Simscape Driveline and"
  "Rotational Damper block from Simscape."
  "For more details, see the Description."
  ], " "));

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

target_file = LiteApp5.Utility.i18n("MotorDriveUnitDescription.html");
% Check that the file exists. If not, this prevents the app from showing up.
LiteApp5.Utility.getFileFullPath(target_file);

AppUIStruct.DocLinkUI = LiteApp5.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
AppUIStruct.DocLinkUI.HyperlinkText = "Description";
AppUIStruct.DocLinkUI.HyperlinkClickedCallback = @() web(target_file);
AppUIStruct.DocLinkUI.MainHyperlink.Tooltip = LiteApp5.Utility.i18n("Open the component description page.");
% Adjust the height and vertical alignment of the hyperlink component:
AppUIStruct.DocLinkUI.ComponentHeight = oneline_height + 4;
AppUIStruct.DocLinkUI.VerticalAlignment = "bottom";

AppUIStruct.OpenModelButtonUI = LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenModelButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenModelButtonUI.Text = LiteApp5.Utility.i18n("Open model");
AppUIStruct.OpenModelButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the loaded model.");
AppUIStruct.OpenModelButtonUI.ButtonPushedCallback = @() callbackOpenSystem(AppSetup.ModelName);

AppUIStruct.OpenSetupButtonUI= LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenSetupButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenSetupButtonUI.Text = LiteApp5.Utility.i18n("Open setup");
AppUIStruct.OpenSetupButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the loaded parameter setup script.");
AppUIStruct.OpenSetupButtonUI.ButtonPushedCallback = @() edit(AppSetup.ParameterFile);

AppUIStruct.RefreshButtonUI = LiteApp5.Component.Button(NewSlot(layout, row));
AppUIStruct.RefreshButtonUI.ComponentWidth = button_width;
AppUIStruct.RefreshButtonUI.HorizontalAlignment = "left";
AppUIStruct.RefreshButtonUI.Text = LiteApp5.Utility.i18n("Refresh");
AppUIStruct.RefreshButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Refresh the values. Use this button if edit fields are using workspace variables.");
AppUIStruct.RefreshButtonUI.ButtonPushedCallback = @() callbackReloadValues();

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=8);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Parameters") + "}";
label_ui.ComponentWidth = name_ui_width;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxSpeedUI.Name = LiteApp5.Utility.i18n("Maximum speed");
AppUIStruct.MaxSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxSpeedUI.UnitItems = speed_units;
AppUIStruct.MaxSpeedUI.Unit = "rpm";
AppUIStruct.MaxSpeedUI.Value = "15000";
AppUIStruct.MaxSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxTorqueUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxTorqueUI.Name = LiteApp5.Utility.i18n("Maximum torque");
AppUIStruct.MaxTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxTorqueUI.UnitItems = torque_units;
AppUIStruct.MaxTorqueUI.Unit = "N*m";
AppUIStruct.MaxTorqueUI.Value = "420";
AppUIStruct.MaxTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxPowerUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxPowerUI.Name = LiteApp5.Utility.i18n("Maximum power");
AppUIStruct.MaxPowerUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxPowerUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxPowerUI.UnitItems = power_units;
AppUIStruct.MaxPowerUI.Unit = "kW";
AppUIStruct.MaxPowerUI.Value = "220";
AppUIStruct.MaxPowerUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.EfficiencyUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.EfficiencyUI.Name = LiteApp5.Utility.i18n("Overall efficiency, $\eta_{meas}(\omega_{meas}, \tau_{meas})$");
AppUIStruct.EfficiencyUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.EfficiencyUI.NameUIWidth = name_ui_width;
AppUIStruct.EfficiencyUI.UnitAlias = "\%";
AppUIStruct.EfficiencyUI.Value = "95";
AppUIStruct.EfficiencyUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredSpeedUI.Name = LiteApp5.Utility.i18n("Speed at which $\eta_{meas}$ is measured, $\omega_{meas}$");
AppUIStruct.MeasuredSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitItems = speed_units;
AppUIStruct.MeasuredSpeedUI.Unit = "rpm";
AppUIStruct.MeasuredSpeedUI.Value = "2000";
AppUIStruct.MeasuredSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredTorqueUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredTorqueUI.Name = LiteApp5.Utility.i18n("Torque at which $\eta_{meas}$ is measured, $\tau_{meas}$");
AppUIStruct.MeasuredTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitItems = torque_units;
AppUIStruct.MeasuredTorqueUI.Unit = "N*m";
AppUIStruct.MeasuredTorqueUI.Value = "50";
AppUIStruct.MeasuredTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.RotorDampingUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.RotorDampingUI.Name = LiteApp5.Utility.i18n("Rotor damping, $k_f$, in Rotational Damper");
AppUIStruct.RotorDampingUI.NameUIWidth = name_ui_width;
AppUIStruct.RotorDampingUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.RotorDampingUI.UnitItems = friction_units;
AppUIStruct.RotorDampingUI.Unit = "N*m/(rad/s)";
AppUIStruct.RotorDampingUI.Value = "1e-05";
AppUIStruct.RotorDampingUI.ValueChangedCallback = @() auto_update();

% =============================================================================
% Right side of app window

column = NewColumn(layout, area, Width=right_pane_width);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.PlotButtonUI = LiteApp5.Component.EnabledButton(NewSlot(layout, row, Width="fit"));
AppUIStruct.PlotButtonUI.HorizontalAlignment = "left";
AppUIStruct.PlotButtonUI.ButtonUIWidth = button_width + width_unit;
AppUIStruct.PlotButtonUI.ButtonWidth = button_width;
AppUIStruct.PlotButtonUI.CheckBoxUIWidth = "fit";
AppUIStruct.PlotButtonUI.CheckBoxWidth = "fit";
AppUIStruct.PlotButtonUI.ButtonText = LiteApp5.Utility.i18n("Update");
AppUIStruct.PlotButtonUI.ButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "tool_rotate_3d.png");
AppUIStruct.PlotButtonUI.CheckBoxText = LiteApp5.Utility.i18n("Auto-update");
AppUIStruct.PlotButtonUI.ButtonPushedCallback = @() update_plot(AppUIStruct.AxesUI.MainAxes);
% Set false to auto-update and keep it until the entire app is ready.
AppUIStruct.PlotButtonUI.ButtonDisable = "on";

AppUIStruct.OpenInFigureWindowUI = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
AppUIStruct.OpenInFigureWindowUI.HyperlinkText = LiteApp5.Utility.i18n("Open in figure window");
AppUIStruct.OpenInFigureWindowUI.HorizontalAlignment = "right";
AppUIStruct.OpenInFigureWindowUI.HyperlinkClickedCallback = @() create_plot_window();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.AxesUI = LiteApp5.Graphics.Axes(NewSlot(layout, row));
AppUIStruct.AxesUI.ComponentHeight = plot_panel_height;

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % small vertical gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.ContoursUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.ContoursUI.Name = LiteApp5.Utility.i18n("Contour levels");
AppUIStruct.ContoursUI.NameUIWidth = width_unit * 12;
AppUIStruct.ContoursUI.UnitUIWidth = width_unit * 5;
AppUIStruct.ContoursUI.UnitAlias = "\%";
AppUIStruct.ContoursUI.Value = "[1 60 80 90 92 94 96 97 98 99]";
AppUIStruct.ContoursUI.ValueEditFieldUI.MainEditField.Tooltip = LiteApp5.Utility.i18n("Only a plain number array such as [1, 80, 90, 99] is allowed.");
AppUIStruct.ContoursUI.ValueChangedCallback = @() auto_update();

% =============================================================================
area = NewArea(layout);
column = NewColumn(layout, area);

NewRow(layout, column, Height=4);  % vertical small gap
% -----------------------------------------------------------------------------
row = NewRow(layout, column);
LiteApp5.Component.HorizontalLine(NewSlot(layout, row));
% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.SelectorUI = LiteApp5.Component.BlockSelectorUI(NewSlot(layout, row));
AppUIStruct.SelectorUI.MainFigure = AppUIStruct.Window.MainFigure;
AppUIStruct.SelectorUI.TargetBlockNames = "Motor & Drive";
AppUIStruct.SelectorUI.GetParametersFromBlockCallback = @() getParametersFromBlock();
AppUIStruct.SelectorUI.SetParametersToBlockCallback = @() setParametersToBlock();
AppUIStruct.SelectorUI.SetParametersToBlockUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Set button does nothing in this app.");

% ---------------------------------------------------------------------------
% callbacks

  function update_plot(parent)
    %%

    max_speed = AppUIStruct.MaxSpeedUI.SimscapeValue;
    max_torque = AppUIStruct.MaxTorqueUI.SimscapeValue;
    max_power = AppUIStruct.MaxPowerUI.SimscapeValue;
    efficiency_percent = AppUIStruct.EfficiencyUI.SimscapeValue;
    measured_speed = AppUIStruct.MeasuredSpeedUI.SimscapeValue;
    measured_torque = AppUIStruct.MeasuredTorqueUI.SimscapeValue;
    rotor_damping = AppUIStruct.RotorDampingUI.SimscapeValue;

    contour_levels = simscape.Value(transpose(LiteApp5.Utility.getNumberArrayFromString(AppUIStruct.ContoursUI.Value)), "1");

    MotorDriveUnit_EfficiencyPlot( ParentAxes=parent, ...
      MaxSpeed = max_speed, ...
      MaxTorque = max_torque, ...
      MaxPower = max_power, ...
      EfficiencyPercent = efficiency_percent, ...
      MeasuredSpeed = measured_speed, ...
      MeasuredTorque = measured_torque, ...
      IronToNominalLossRatioPercent = simscape.Value(0, "1"), ...
      FixedLoss = simscape.Value(0, "W"), ...
      RotorDamping = rotor_damping, ...
      ContourLevelsPercent = contour_levels, ...
      PlotResolution = 500 );

  end  % nested function

  function create_plot_window()
    %%
    parent = axes(figure);
    update_plot(parent)
  end  % nested function

  function auto_update()
    %%
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

    x = AppUIStruct.RotorDampingUI.Value;
    AppUIStruct.RotorDampingUI.Value = x;

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
    motor_drive_block_path = AppUIStruct.SelectorUI.BlockPath;
    rotor_damper_block_path = AppSetup.ModelName + "/Rotor damper";

    AppUIStruct.MaxTorqueUI.Unit = get_param(motor_drive_block_path, "torque_max_unit");
    AppUIStruct.MaxTorqueUI.Value = get_param(motor_drive_block_path, "torque_max");

    AppUIStruct.MaxPowerUI.Unit = get_param(motor_drive_block_path, "power_max_unit");
    AppUIStruct.MaxPowerUI.Value = get_param(motor_drive_block_path, "power_max");

    AppUIStruct.EfficiencyUI.Value = get_param(motor_drive_block_path, "eff");

    AppUIStruct.MeasuredSpeedUI.Unit = get_param(motor_drive_block_path, "w_eff_unit");
    AppUIStruct.MeasuredSpeedUI.Value = get_param(motor_drive_block_path, "w_eff");

    AppUIStruct.MeasuredTorqueUI.Unit = get_param(motor_drive_block_path, "T_eff_unit");
    AppUIStruct.MeasuredTorqueUI.Value = get_param(motor_drive_block_path, "T_eff");

    % Assume that rotor damping is defined in the Rotor Damper block.
    AppUIStruct.RotorDampingUI.Unit = get_param(rotor_damper_block_path, "D_unit");
    AppUIStruct.RotorDampingUI.Value = get_param(rotor_damper_block_path, "D");

    % -------------------------------------------------------------------------
    % Restore the previous auto-update state.
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = prev_auto_update;
    auto_update()
  end  % nested function

  function setParametersToBlock()
    %%
    msg = LiteApp5.Utility.i18n("In this app, the Set button does not set parameters to the block.");
    disp(msg)
  end  % nested function

% -----------------------------------------------------------------------------
% Final step of building app UI
AppUIStruct.PlotButtonUI.CheckBoxUI.Value = true;
auto_update()
end  % function

function callbackOpenSystem(modelName)
%%
disp(LiteApp5.Utility.i18n("Opening the model: ") + modelName)
open_system(modelName)
end  % function
