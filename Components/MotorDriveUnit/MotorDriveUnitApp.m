function App = MotorDriveUnitApp()
%% Motor drive unit app
% This is a uifigure-based app.

% Copyright 2025 The MathWorks, Inc.

app_setup.ErrorID = "MotorDriveUnitApp:";
app_setup.ComponentTopFolder = fullfile(currentProject().RootFolder, "Components", "MotorDriveUnit");
app_setup.ModelName = "MotorDriveUnit_harness_model";
app_setup.HarnessSetupScript = "MotorDriveUnit_harness_setup";
app_setup.MainBlockPath = "MotorDriveUnit_harness_model/Motor Drive Unit";
app_setup.InputsBlockPath = "MotorDriveUnit_harness_model/Inputs";
app_setup.ScopePath = "MotorDriveUnit_harness_model/Measurement/Scope MDU Harness";

app_setup.MDUItems = ["Basic", "BasicThermal", "SystemThermal", "SystemTable"];
app_setup.MDUDisplayItems = [
  LiteApp5.Utility.i18n("Basic model")
  LiteApp5.Utility.i18n("Basic thermal model")
  LiteApp5.Utility.i18n("System-level thermal model")
  LiteApp5.Utility.i18n("System-level model with tabulated losses")];

% -----------------------------------------------------------------------------
% Setup before buidling app

disp(LiteApp5.Utility.i18n("Loading model: ") + app_setup.ModelName)
load_system(app_setup.ModelName)

% Get the currently selected refsub's name.
% Select it in the app's MDU block drop down later.
current_refsub = get_param(app_setup.MainBlockPath, "ReferencedSubsystem");
refsub_name = extractAfter(current_refsub, "MotorDriveUnit_refsub_");
logical_index = refsub_name == app_setup.MDUItems;
mdu_display_value = app_setup.MDUDisplayItems(logical_index);

% -----------------------------------------------------------------------------
% Build app UI

app_ui = build_app_ui(app_setup);

% -----------------------------------------------------------------------------
% Setup initial model and simulation case in the app.
% Do this after the app is built.

app_ui.TargetBlockDropDownUI.Value = mdu_display_value;
app_ui.SimulationCaseDropDownUI.Value = LiteApp5.Utility.i18n("Drive");

refreshInitialConditions(app_ui)

% -----------------------------------------------------------------------------
Show(app_ui.Window)
if nargout > 0
  App = app_ui;
end  % if
end  % function

function AppUIStruct = build_app_ui(AppSetup)
%%

arguments (Input)
  AppSetup (1,1) struct
end  % arguments

arguments (Output)
  AppUIStruct (1,1) struct
end  % arguments

% -----------------------------------------------------------------------------

mdu_display_items = AppSetup.MDUDisplayItems;
mdu_items = AppSetup.MDUItems;

simulation_case_display_items = [
  LiteApp5.Utility.i18n("Constant inputs")
  LiteApp5.Utility.i18n("Drive")
  LiteApp5.Utility.i18n("Regenerative braking")];

simulation_case_items = ["Constant" "Drive" "RegenBrake"];

% -----------------------------------------------------------------------------

width_unit = LiteApp5.Utility.Constant.Width{"unitwidth"};
name_ui_width = width_unit * 17;
button_width = width_unit * 12;

oneline_height = LiteApp5.Utility.Constant.Height{"oneline"};

% =============================================================================

AppUIStruct.Window = LiteApp5.LiteAppWindow;

AppUIStruct.Window.HeaderUI.AppSourceName = mfilename;

AppUIStruct.Window.Name = LiteApp5.Utility.i18n("Motor Drive Unit App");

AppUIStruct.Window.Width = 550;

AppUIStruct.Window.Height = 650;
input_plot_panel_height = 360;

layout = AppUIStruct.Window.MainLayout;

% =============================================================================
area = NewArea(layout);

column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

target_file = "MotorDriveUnitDescription.html";
% Check that the file exists.
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
AppUIStruct.OpenModelButtonUI.MainButton.Tooltip = LiteApp5.Utility.i18n("Open the harness model.");
AppUIStruct.OpenModelButtonUI.ButtonPushedCallback = @() dispAndOpenSystem(AppSetup.ModelName);

  function dispAndOpenSystem(modelName)
    disp(LiteApp5.Utility.i18n("Opening model: ") + modelName)
    open_system(modelName)
  end  % nested function

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

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Configuration") + "}";

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = LiteApp5.Utility.i18n("MDU block");

AppUIStruct.TargetBlockDropDownUI = LiteApp5.Component.DropDown(NewSlot(layout, row));
AppUIStruct.TargetBlockDropDownUI.Items = mdu_display_items;
AppUIStruct.TargetBlockDropDownUI.HorizontalAlignment = "left";
AppUIStruct.TargetBlockDropDownUI.ValueChangedCallback = @() update_referenced_subsystem(AppUIStruct.TargetBlockDropDownUI.Value);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = LiteApp5.Utility.i18n("Simulation case");

AppUIStruct.SimulationCaseDropDownUI = LiteApp5.Component.DropDown(NewSlot(layout, row));
AppUIStruct.SimulationCaseDropDownUI.Items = simulation_case_display_items;
AppUIStruct.SimulationCaseDropDownUI.HorizontalAlignment = "left";
AppUIStruct.SimulationCaseDropDownUI.ValueChangedCallback = @() update_simulation_case(AppUIStruct.SimulationCaseDropDownUI.Value);

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Initial conditions") + "}";
label_ui.ComponentWidth = name_ui_width;

button_ui = LiteApp5.Component.Button(NewSlot(layout, row));
button_ui.ComponentWidth = button_width;
button_ui.HorizontalAlignment = "left";
button_ui.Text = LiteApp5.Utility.i18n("Refresh");
button_ui.MainButton.Tooltip = LiteApp5.Utility.i18n("Load workspace variables.");
button_ui.ButtonPushedCallback = @() refreshInitialConditions(AppUIStruct);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.LoadSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.LoadSpeedUI.Name = LiteApp5.Utility.i18n("Load speed");
AppUIStruct.LoadSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.LoadSpeedUI.Value = "initial.loadInertiaSpd_rpm";
AppUIStruct.LoadSpeedUI.Unit = "rpm";
AppUIStruct.LoadSpeedUI.ValueReadOnly = true;
AppUIStruct.LoadSpeedUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.LoadSpeedUI.Value);

  function str = buildTooltipText(value_text)
    str = value_text + newline + LiteApp5.Utility.i18n("(To modify, edit the setup script.)");
  end  % nested function

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MotorSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MotorSpeedUI.Name = LiteApp5.Utility.i18n("Motor speed");
AppUIStruct.MotorSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MotorSpeedUI.Value = "initial.motorSpd_rpm";
AppUIStruct.MotorSpeedUI.Unit = "rpm";
AppUIStruct.MotorSpeedUI.ValueReadOnly = true;
AppUIStruct.MotorSpeedUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.MotorSpeedUI.Value);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MotorTemperatureUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MotorTemperatureUI.Name = LiteApp5.Utility.i18n("Motor temperature");
AppUIStruct.MotorTemperatureUI.NameUIWidth = name_ui_width;
AppUIStruct.MotorTemperatureUI.Value = "initial.motorDriveUnit_Temperature_K";
AppUIStruct.MotorTemperatureUI.Unit = "K";
AppUIStruct.MotorTemperatureUI.ValueReadOnly = true;
AppUIStruct.MotorTemperatureUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.MotorTemperatureUI.Value);

area_number = layout.A;
column_number = layout.C;
row_number_MotorTempUI = layout.R;
% disp("MotorTemperatureUI grid address: " + GridAddress(layout))

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.AmbientTemperatureUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.AmbientTemperatureUI.Name = LiteApp5.Utility.i18n("Ambient temperature");
AppUIStruct.AmbientTemperatureUI.NameUIWidth = name_ui_width;
AppUIStruct.AmbientTemperatureUI.Value = "initial.ambientTemp_K";
AppUIStruct.AmbientTemperatureUI.Unit = "K";
AppUIStruct.AmbientTemperatureUI.ValueReadOnly = true;
AppUIStruct.AmbientTemperatureUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.AmbientTemperatureUI.Value);

row_number_AmbTempUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = "\textbf{" + LiteApp5.Utility.i18n("Input signals") + "}";

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.InputSignalPlotPanel = LiteApp5.Graphics.Panel(NewSlot(layout, row));
AppUIStruct.InputSignalPlotPanel.ComponentHeight = input_plot_panel_height;

% ---------------------------------------------------------------------------
% callbacks

  function update_referenced_subsystem(SelectedItem)
    %%
    evalin("base", AppSetup.HarnessSetupScript)

    logical_index = SelectedItem == AppUIStruct.TargetBlockDropDownUI.Items;
    refsub_keyword = mdu_items(logical_index);

    name = "MotorDriveUnit_useRefsub_" + refsub_keyword;
    feval(name)

    % Create hyperlinks that run functions
    % https://www.mathworks.com/help/matlab/matlab_prog/create-hyperlinks-that-run-functions.html
    disp("# Running referenced subsystem setup script: <a href=""matlab:edit('" + name + "')"">" + name + "</a>")

    % Show or hide temperature-related UI components.
    if refsub_keyword ~= "BasicThermal" && refsub_keyword ~= "System"
      % Hide
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_MotorTempUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_AmbTempUI).Children.RowHeight = 0;

    else
      % Show
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_MotorTempUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_AmbTempUI).Children.RowHeight = "fit";

    end  % if

    update_simulation_case(AppUIStruct.SimulationCaseDropDownUI.Value)

  end  % nested function

  function update_simulation_case(sim_case_display_keyword)
    %%
    logical_index = sim_case_display_keyword == AppUIStruct.SimulationCaseDropDownUI.Items;
    sim_case_keyword = simulation_case_items(logical_index);

    sim_case_setup = "MotorDriveUnit_setSimCase_" + sim_case_keyword;

    % Create hyperlinks that run functions
    % https://www.mathworks.com/help/matlab/matlab_prog/create-hyperlinks-that-run-functions.html
    disp("# Running simulation case setup script: <a href=""matlab:edit('" + sim_case_setup + "')"">" + sim_case_setup + "</a>")

    feval(sim_case_setup)

    % Update input signal plots for the selected simulation case.
    logical_index = AppUIStruct.TargetBlockDropDownUI.Value == AppUIStruct.TargetBlockDropDownUI.Items;
    refsub_keyword = mdu_items(logical_index);
    updateInputSignalPlots(refsub_keyword, AppSetup.InputsBlockPath, AppUIStruct.InputSignalPlotPanel.MainPanel)

  end  % nested function

% ---------------------------------------------------------------------------
% Final step of building app UI

% Get the current subsystem reference name from the model, and update the app's refsub drop down UI.
current_refsub = string(get_param(AppSetup.ModelName + "/Motor Drive Unit", "ReferencedSubsystem"));
refsub_keyword = extractAfter(current_refsub, "MotorDriveUnit_refsub_");
logical_index = refsub_keyword == mdu_items;
AppUIStruct.TargetBlockDropDownUI.Value = mdu_display_items(logical_index);

refreshInitialConditions(AppUIStruct)
end  % function

%% ============================================================================
% Callbacks

function refreshInitialConditions(app_ui)
%%
app_ui.LoadSpeedUI.Value = "initial.loadInertiaSpd_rpm";
app_ui.MotorSpeedUI.Value = "initial.motorSpd_rpm";
app_ui.MotorTemperatureUI.Value = "initial.motorDriveUnit_Temperature_K";
app_ui.AmbientTemperatureUI.Value = "initial.ambientTemp_K";
end  % nested function

function updateInputSignalPlots(refsub_keyword, input_block_path, graphics_parent)
%%
layout = tiledlayout(graphics_parent, "vertical", TileSpacing="tight");

motor_torque_str = "Motor torque command";
axle_torque_str = "Axle torque";
axle_clutch_str = "Axle clutch switch";
axle_speed_str = "Axle speed";
heat_flow_str = "Heat flow command";

switch refsub_keyword
  case "Basic"
    motor_torque = buildTimetable(input_block_path, motor_torque_str);
    axle_torque = buildTimetable(input_block_path, axle_torque_str);
    data = synchronize(motor_torque, axle_torque, "regular", "linear", "TimeStep", seconds(1));

    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=motor_torque_str, SignalUnit="N*m", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_torque_str, SignalUnit="N*m")

  case "BasicThermal"
    motor_torque = buildTimetable(input_block_path, motor_torque_str);
    axle_torque = buildTimetable(input_block_path, axle_torque_str);
    axle_clutch = buildTimetable(input_block_path, axle_clutch_str);
    axle_speed = buildTimetable(input_block_path, axle_speed_str);
    heat_flow = buildTimetable(input_block_path, heat_flow_str);
    data = synchronize(motor_torque, axle_torque, axle_clutch, axle_speed, heat_flow, "regular", "linear", "TimeStep", seconds(1));

    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=motor_torque_str, SignalUnit="N*m", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_torque_str, SignalUnit="N*m", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_clutch_str, SignalUnit="", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_speed_str, SignalUnit="rpm", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=heat_flow_str, SignalUnit="W", XLabel="")

  case "SystemThermal"
    motor_torque = buildTimetable(input_block_path, motor_torque_str);
    axle_torque = buildTimetable(input_block_path, axle_torque_str);
    axle_clutch = buildTimetable(input_block_path, axle_clutch_str);
    axle_speed = buildTimetable(input_block_path, axle_speed_str);
    heat_flow = buildTimetable(input_block_path, heat_flow_str);
    data = synchronize(motor_torque, axle_torque, axle_clutch, axle_speed, heat_flow, "regular", "linear", "TimeStep", seconds(1));

    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=motor_torque_str, SignalUnit="N*m", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_torque_str, SignalUnit="N*m", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_clutch_str, SignalUnit="", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_speed_str, SignalUnit="rpm", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=heat_flow_str, SignalUnit="W", XLabel="")

  case "SystemTable"
    motor_torque = buildTimetable(input_block_path, motor_torque_str);
    axle_torque = buildTimetable(input_block_path, axle_torque_str);
    axle_clutch = buildTimetable(input_block_path, axle_clutch_str);
    axle_speed = buildTimetable(input_block_path, axle_speed_str);
    heat_flow = buildTimetable(input_block_path, heat_flow_str);
    data = synchronize(motor_torque, axle_torque, axle_clutch, axle_speed, heat_flow, "regular", "linear", "TimeStep", seconds(1));

    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=motor_torque_str, SignalUnit="N*m", XLabel="")
    TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_torque_str, SignalUnit="N*m", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_clutch_str, SignalUnit="", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=axle_speed_str, SignalUnit="rpm", XLabel="")
    % TimetableSingleSignalPlot(ParentAxes=nexttile(layout), Timetable=data, SignalName=heat_flow_str, SignalUnit="W", XLabel="")

end  % switch
end  %function

function tt = buildTimetable(input_block_path, signale_name)
%%
block_path = input_block_path + "/" + signale_name + "/1-D Lookup Table";

time_points_str = string(get_param(block_path, "BreakpointsForDimension1"));
Time = LiteApp5.Utility.getNumberArrayFromString(time_points_str);
Time = seconds(Time);

y_str = string(get_param(block_path, "Table"));
y = LiteApp5.Utility.getNumberArrayFromString(y_str);

tt = timetable(Time, y);
tt.Properties.VariableNames = signale_name;
end  % nested function
