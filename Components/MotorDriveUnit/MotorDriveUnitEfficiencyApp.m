function App = MotorDriveUnitEfficiencyApp()
%% Motor drive unit efficiency app
% This is a uifigure-based app.

% This app works with
% - Motor & Drive block from Simscape Driveline
%
% This app preloads two models in the Model file drop down for convenience:
% - MotorDriveUnit_refsub_Basic.mdl
% - MotorDriveUnit_refsub_System.mdl
% The app assumes that Rotational Damper block is used in the Basic model to
% define Rotor damping parameter in the app. The System model defines
% the Rotor damping parameter in the Motor & Drive (System Level) block.

% Copyright 2025 The MathWorks, Inc.

app_ui = build_app_ui();

Show(app_ui.Window)
% -----------------------------------------------------------------------------
if nargout > 0
  App = app_ui;
end  % if
end  % function

function AppUIStruct = build_app_ui()
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
name_ui_width = width_unit * 18;
button_width = width_unit * 12;
physical_unit_ui_width = width_unit * 12;

% =============================================================================

AppUIStruct.Window = LiteApp5.LiteAppWindow;

AppUIStruct.Window.HeaderUI.AppSourceName = mfilename;

AppUIStruct.Window.Name = LiteApp5.Utility.i18n("Motor Efficiency App");

AppUIStruct.Window.Width = 1200;
right_pane_width = 500;

AppUIStruct.Window.Height = 530;
plot_panel_height = 380;

layout = AppUIStruct.Window.MainLayout;

% =============================================================================
area = NewArea(layout);

% =============================================================================
% Left pane
column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
%{
row = NewRow(layout, column);

AppUIStruct.DocLinkUI = LiteApp5.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
AppUIStruct.DocLinkUI.HyperlinkText = "Description";
AppUIStruct.DocLinkUI.HyperlinkClickedCallback = @() web(fullfile(AppSetup.ComponentTopFolder, LiteApp5.Utility.i18n("MotorDriveUnit_main_script.html")));
AppUIStruct.DocLinkUI.MainHyperlink.Tooltip = LiteApp5.Utility.i18n("Open the component description page.");
% Adjust the height and vertical alignment of the hyperlink component:
AppUIStruct.DocLinkUI.ComponentHeight = oneline_height + 4;
AppUIStruct.DocLinkUI.VerticalAlignment = "bottom";

AppUIStruct.OpenModelButtonUI = LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenModelButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenModelButtonUI.Text = LiteApp5.Utility.i18n("Open model");
AppUIStruct.OpenModelButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the harness model.");
AppUIStruct.OpenModelButtonUI.ButtonPushedCallback = @() callbackOpenSystem(AppSetup.ModelName);

AppUIStruct.OpenSetupButtonUI= LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenSetupButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenSetupButtonUI.Text = LiteApp5.Utility.i18n("Open setup");
AppUIStruct.OpenSetupButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the main setup script.");
AppUIStruct.OpenSetupButtonUI.ButtonPushedCallback = @() edit(AppSetup.HarnessSetupScript);

AppUIStruct.OpenScopeButtonUI= LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenScopeButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenScopeButtonUI.Text = LiteApp5.Utility.i18n("Open scope");
AppUIStruct.OpenScopeButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the main scope.");
AppUIStruct.OpenScopeButtonUI.ButtonPushedCallback = @() open_system(AppSetup.ScopePath);

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap
%}

%{
% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = LiteApp5.Utility.i18n("MDU model");

AppUIStruct.TargetBlockDropDownUI = LiteApp5.Component.DropDown(NewSlot(layout, row));
AppUIStruct.TargetBlockDropDownUI.Items = mdu_display_items;
AppUIStruct.TargetBlockDropDownUI.HorizontalAlignment = "left";
AppUIStruct.TargetBlockDropDownUI.ValueChangedCallback = @() update_referenced_subsystem(AppUIStruct.TargetBlockDropDownUI.Value);
%}

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Parameters") + "}";
label_ui.ComponentWidth = name_ui_width;

button_ui = LiteApp5.Component.Button(NewSlot(layout, row));
button_ui.ComponentWidth = button_width;
button_ui.HorizontalAlignment = "left";
button_ui.Text = LiteApp5.Utility.i18n("Refresh");
button_ui.MainButton.Tooltip = LiteApp5.Utility.i18n("Refresh the values. Use this button if you want to reload workspace variables.");
button_ui.ButtonPushedCallback = @() callbackReloadValues();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxSpeedUI.Name = LiteApp5.Utility.i18n("Max speed");
AppUIStruct.MaxSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxSpeedUI.UnitItems = speed_units;
AppUIStruct.MaxSpeedUI.Unit = "rpm";
AppUIStruct.MaxSpeedUI.Value = "15000";
AppUIStruct.MaxSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxTorqueUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxTorqueUI.Name = LiteApp5.Utility.i18n("Max torque");
AppUIStruct.MaxTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxTorqueUI.UnitItems = torque_units;
AppUIStruct.MaxTorqueUI.Unit = "N*m";
AppUIStruct.MaxTorqueUI.Value = "420";
AppUIStruct.MaxTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MaxPowerUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MaxPowerUI.Name = LiteApp5.Utility.i18n("Max power");
AppUIStruct.MaxPowerUI.NameUIWidth = name_ui_width;
AppUIStruct.MaxPowerUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MaxPowerUI.UnitItems = power_units;
AppUIStruct.MaxPowerUI.Unit = "kW";
AppUIStruct.MaxPowerUI.Value = "220";
AppUIStruct.MaxPowerUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.EfficiencyUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.EfficiencyUI.Name = LiteApp5.Utility.i18n("Efficiency");
AppUIStruct.EfficiencyUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.EfficiencyUI.NameUIWidth = name_ui_width;
AppUIStruct.EfficiencyUI.UnitAlias = "\%";
AppUIStruct.EfficiencyUI.Value = "95";
AppUIStruct.EfficiencyUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredSpeedUI.Name = LiteApp5.Utility.i18n("Measured speed");
AppUIStruct.MeasuredSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredSpeedUI.UnitItems = speed_units;
AppUIStruct.MeasuredSpeedUI.Unit = "rpm";
AppUIStruct.MeasuredSpeedUI.Value = "2000";
AppUIStruct.MeasuredSpeedUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MeasuredTorqueUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MeasuredTorqueUI.Name = LiteApp5.Utility.i18n("Measured torque");
AppUIStruct.MeasuredTorqueUI.NameUIWidth = name_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.MeasuredTorqueUI.UnitItems = torque_units;
AppUIStruct.MeasuredTorqueUI.Unit = "N*m";
AppUIStruct.MeasuredTorqueUI.Value = "50";
AppUIStruct.MeasuredTorqueUI.ValueChangedCallback = @() auto_update();

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.IronLossUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.IronLossUI.Name = LiteApp5.Utility.i18n("Iron loss");
AppUIStruct.IronLossUI.NameUIWidth = name_ui_width;
AppUIStruct.IronLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.IronLossUI.UnitItems = power_units;
AppUIStruct.IronLossUI.Unit = "W";
AppUIStruct.IronLossUI.Value = "55";
AppUIStruct.IronLossUI.ValueChangedCallback = @() auto_update();

area_number = layout.A;
column_number = layout.C;
row_number_IronLossUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.FixedLossUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.FixedLossUI.Name = LiteApp5.Utility.i18n("Fixed loss");
AppUIStruct.FixedLossUI.NameUIWidth = name_ui_width;
AppUIStruct.FixedLossUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.FixedLossUI.UnitItems = power_units;
AppUIStruct.FixedLossUI.Unit = "W";
AppUIStruct.FixedLossUI.Value = "40";
AppUIStruct.FixedLossUI.ValueChangedCallback = @() auto_update();

row_number_FixedLossUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.RotorDampingUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.RotorDampingUI.Name = LiteApp5.Utility.i18n("Rotor damping");
AppUIStruct.RotorDampingUI.NameUIWidth = name_ui_width;
AppUIStruct.RotorDampingUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.RotorDampingUI.UnitItems = friction_units;
AppUIStruct.RotorDampingUI.Unit = "N*m/(rad/s)";
AppUIStruct.RotorDampingUI.Value = "1e-05";
AppUIStruct.RotorDampingUI.ValueChangedCallback = @() auto_update();

% =============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Derived parameters") + "}";

row_number_DerivedParametersLabel = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.NominalLossUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.NominalLossUI.Name = LiteApp5.Utility.i18n("Nominal loss");
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

row_number_NominalLossUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.LossRatioUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.LossRatioUI.Name = LiteApp5.Utility.i18n("Iron to nominal loss ratio");
AppUIStruct.LossRatioUI.NameUIWidth = name_ui_width;
AppUIStruct.LossRatioUI.UnitUIWidth = physical_unit_ui_width;
AppUIStruct.LossRatioUI.UnitAlias = "\%";
AppUIStruct.LossRatioUI.Value = "10";
AppUIStruct.LossRatioUI.ValueReadOnly = true;

row_number_LossRatioUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.CopperLossUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.CopperLossUI.Name = LiteApp5.Utility.i18n("Copper loss");
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

row_number_CopperLossUI = layout.R;

% =============================================================================
% Right side

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
LiteApp5.Component.HorizontalLine(NewArea(layout));
% =============================================================================
area = NewArea(layout);

column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

block_selector_ui = LiteApp5.Component.BlockSelectorUI(NewSlot(layout, row));
block_selector_ui.MainFigure = AppUIStruct.Window.MainFigure;
block_selector_ui.TargetBlockNames = [
  "Motor & Drive"
  "Motor & Drive" + newline + "(System Level)"
  ];
block_selector_ui.GetParametersFromBlockCallback = @() getParamFromBlock();
block_selector_ui.SetParametersToBlockCallback = @() setParamToBlock();

% Preload model files to the drop down for convenience.
% This is allowed after defining at least MainFigure and TargetBlockNames.
block_selector_ui.ModelFileFullPath = LiteApp5.Utility.getFileFullPath("MotorDriveUnit_refsub_Basic.mdl");
block_selector_ui.ModelFileFullPath = LiteApp5.Utility.getFileFullPath("MotorDriveUnit_refsub_System.mdl");
% Deselect models from the drop down as the initial state.
block_selector_ui.ModelFileFullPath = "";

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

    contour_levels = simscape.Value(transpose(LiteApp5.Utility.getNumberArrayFromString(AppUIStruct.ContoursUI.Value)), "1");

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

  function getParamFromBlock()
    %%
    % Use get_param to get the unevaluated text in the Block Parameters window.
    % Assignment to the Unit or Value of PhysicalValueUI takes care of the rest.

    % Preserve the current auto-update state and disable it.
    prev_auto_update = AppUIStruct.PlotButtonUI.CheckBoxUI.Value;
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = false;
    % -------------------------------------------------------------------------

    AppUIStruct.MaxTorqueUI.Unit = get_param(gcb, "torque_max_unit");
    AppUIStruct.MaxTorqueUI.Value = get_param(gcb, "torque_max");

    AppUIStruct.MaxPowerUI.Unit = get_param(gcb, "power_max_unit");
    AppUIStruct.MaxPowerUI.Value = get_param(gcb, "power_max");

    AppUIStruct.EfficiencyUI.Value = get_param(gcb, "eff");

    AppUIStruct.MeasuredSpeedUI.Unit = get_param(gcb, "w_eff_unit");
    AppUIStruct.MeasuredSpeedUI.Value = get_param(gcb, "w_eff");

    AppUIStruct.MeasuredTorqueUI.Unit = get_param(gcb, "T_eff_unit");
    AppUIStruct.MeasuredTorqueUI.Value = get_param(gcb, "T_eff");

    if startsWith(gcs, "MotorDriveUnit_refsub_Basic")
      % Hide unused parameters.
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_IronLossUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_FixedLossUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_DerivedParametersLabel).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_NominalLossUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_LossRatioUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_CopperLossUI).Children.RowHeight = 0;

      AppUIStruct.IronLossUI.Value = 0;
      AppUIStruct.FixedLossUI.Value = 0;

      % Assume that rotor damping is defined in the Rotational Damper block.
      block_path = "MotorDriveUnit_refsub_Basic/Rotor damper";
      AppUIStruct.RotorDampingUI.Unit = get_param(block_path, "D_unit");
      AppUIStruct.RotorDampingUI.Value = get_param(block_path, "D");

    else
      % Show parameters that were hidden for the other case.
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_IronLossUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_FixedLossUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_DerivedParametersLabel).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_NominalLossUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_LossRatioUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_CopperLossUI).Children.RowHeight = "fit";

      AppUIStruct.IronLossUI.Unit = get_param(gcb, "Piron_unit");
      AppUIStruct.IronLossUI.Value = get_param(gcb, "Piron");

      AppUIStruct.FixedLossUI.Unit = get_param(gcb, "Pbase_unit");
      AppUIStruct.FixedLossUI.Value = get_param(gcb, "Pbase");

      % Assume that rotor damping is defined in the Motor & Drive (System Level) block.
      AppUIStruct.RotorDampingUI.Unit = get_param(gcb, "lam_unit");
      AppUIStruct.RotorDampingUI.Value = get_param(gcb, "lam");

      update_derived_parameters()
    end  % if

    % -------------------------------------------------------------------------
    % Restore the previous auto-update state.
    AppUIStruct.PlotButtonUI.CheckBoxUI.Value = prev_auto_update;
    auto_update()
  end  % nested function

  function setParamToBlock()
    %%
    % !wip: The Set button only reports the currently active block path for testing pupsoe.
    disp("SetParametersToBlockCallback| BlockPath: " + block_selector_ui.BlockPath)




  end  % nested function




% -----------------------------------------------------------------------------
% Final step of building app UI
AppUIStruct.PlotButtonUI.CheckBoxUI.Value = true;
auto_update()
end  % function

%{
function callbackOpenSystem(modelName)
%%
disp(LiteApp5.Utility.i18n("Opening the model: ") + modelName)
open_system(modelName)
end  % function
%}
