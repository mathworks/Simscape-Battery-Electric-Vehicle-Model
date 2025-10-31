function App = MotorDriveUnitSimulationApp()
%% Motor drive unit app
% This is a uifigure-based app.

% Copyright 2025 The MathWorks, Inc.

app_setup.ErrorID = "MotorDriveUnitApp:";
app_setup.ComponentTopFolder = fullfile(currentProject().RootFolder, "Components", "MotorDriveUnit");
app_setup.ModelName = "HarnessModel_MotorDriveUnit";
app_setup.ModelSetupScript = "HarnessSetup_MotorDriveUnit";
app_setup.MainBlockPath = "HarnessModel_MotorDriveUnit/Motor Drive Unit";
app_setup.InputsBlockPath = "HarnessModel_MotorDriveUnit/Inputs";
app_setup.ScopePath = "HarnessModel_MotorDriveUnit/Measurement/Scope MDU Harness";

app_setup.MDUItems = ["Basic", "BasicThermal", "SystemThermal", "SystemTable"];
app_setup.MDUDisplayItems = [
  CodeTool1.i18n("Basic model")
  CodeTool1.i18n("Basic thermal model")
  CodeTool1.i18n("System-level thermal model")
  CodeTool1.i18n("System-level model with tabulated losses")];

% -----------------------------------------------------------------------------
% Setup before buidling app

disp(CodeTool1.i18n("Loading model: ") + app_setup.ModelName)
load_system(app_setup.ModelName)

% Get the currently selected refsub's name.
% Select it in the app's MDU block drop down later.
current_refsub = get_param(app_setup.MainBlockPath, "ReferencedSubsystem");
refsub_name = extractBetween(current_refsub, "MotorDriveUnit_", "_refsub");
logical_index = refsub_name == app_setup.MDUItems;
mdu_display_value = app_setup.MDUDisplayItems(logical_index);

% -----------------------------------------------------------------------------
% Build app UI

app_ui = build_app_ui(app_setup);

% -----------------------------------------------------------------------------
% Setup initial model and simulation case in the app.
% Do this after the app is built.

app_ui.TargetBlockDropDownUI.Value = mdu_display_value;
app_ui.InputsDropDownUI.Value = CodeTool1.i18n("Drive");

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
  CodeTool1.i18n("Constant inputs")
  CodeTool1.i18n("Drive")
  CodeTool1.i18n("Regenerative braking")];

input_case_items = ["Constant" "Drive" "RegenBrake", "Random"];

% -----------------------------------------------------------------------------

width_unit = LiteApp8.Constant.Width{"unitwidth"};
name_ui_width = width_unit * 17;
button_width = width_unit * 12;

oneline_height = LiteApp8.Constant.Height{"oneline"};

% =============================================================================

AppUIStruct.Window = LiteApp8.LiteAppWindow;

AppUIStruct.Window.HeaderUI.AppSourceName = mfilename;

AppUIStruct.Window.Name = CodeTool1.i18n("Motor Drive Unit App");

AppUIStruct.Window.Width = 550;

AppUIStruct.Window.Height = 680;
input_plot_panel_height = 460;

layout = AppUIStruct.Window.MainLayout;

% =============================================================================
area = NewArea(layout);

column = NewColumn(layout, area);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

target_file = "MotorDriveUnit_Description.html";
% Check that the file exists.
FileTool3.getFileFullPath(target_file);

AppUIStruct.DocLinkUI = LiteApp8.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
AppUIStruct.DocLinkUI.Text = "Description";
AppUIStruct.DocLinkUI.HyperlinkClickedCallback = @() web(target_file);
AppUIStruct.DocLinkUI.MainHyperlink.Tooltip = CodeTool1.i18n("Open the component description page.");
% Adjust the height and vertical alignment of the hyperlink component:
AppUIStruct.DocLinkUI.ComponentHeight = oneline_height + 4;
AppUIStruct.DocLinkUI.VerticalAlignment = "bottom";

AppUIStruct.OpenModelButtonUI = LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenModelButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenModelButtonUI.Text = CodeTool1.i18n("Open model");
AppUIStruct.OpenModelButtonUI.MainButton.Tooltip = CodeTool1.i18n("Open the harness model.");
AppUIStruct.OpenModelButtonUI.ButtonPushedCallback = @() dispAndOpenSystem(AppSetup.ModelName);

  function dispAndOpenSystem(modelName)
    disp(CodeTool1.i18n("Opening model: ") + modelName)
    open_system(modelName)
  end  % nested function

AppUIStruct.OpenSetupButtonUI= LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenSetupButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenSetupButtonUI.Text = CodeTool1.i18n("Open setup");
AppUIStruct.OpenSetupButtonUI.MainButton.Tooltip = CodeTool1.i18n("Open the main setup script.");
AppUIStruct.OpenSetupButtonUI.ButtonPushedCallback = @() edit(AppSetup.ModelSetupScript);

AppUIStruct.OpenScopeButtonUI= LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
AppUIStruct.OpenScopeButtonUI.ComponentWidth = button_width;
AppUIStruct.OpenScopeButtonUI.Text = CodeTool1.i18n("Open scope");
AppUIStruct.OpenScopeButtonUI.MainButton.Tooltip = CodeTool1.i18n("Open the main scope.");
AppUIStruct.OpenScopeButtonUI.ButtonPushedCallback = @() open_system(AppSetup.ScopePath);

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{" + CodeTool1.i18n("Configuration") + "}";

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = CodeTool1.i18n("MDU block");

AppUIStruct.TargetBlockDropDownUI = LiteApp8.Component.DropDown(NewSlot(layout, row));
AppUIStruct.TargetBlockDropDownUI.Items = mdu_display_items;
AppUIStruct.TargetBlockDropDownUI.HorizontalAlignment = "left";
AppUIStruct.TargetBlockDropDownUI.ValueChangedCallback = @() update_referenced_subsystem(AppUIStruct.TargetBlockDropDownUI.Value);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = CodeTool1.i18n("Inputs pattern");

AppUIStruct.InputsDropDownUI = LiteApp8.Component.DropDown(NewSlot(layout, row));
AppUIStruct.InputsDropDownUI.Items = simulation_case_display_items;
AppUIStruct.InputsDropDownUI.HorizontalAlignment = "left";
AppUIStruct.InputsDropDownUI.ValueChangedCallback = @() update_inputs(AppUIStruct.InputsDropDownUI.Value);

% -----------------------------------------------------------------------------
NewRow(layout, column, Height=4);  % vertical small gap

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.Text = "\textbf{" + CodeTool1.i18n("Initial conditions") + "}";
label_ui.ComponentWidth = name_ui_width;

button_ui = LiteApp8.Component.Button(NewSlot(layout, row));
button_ui.ComponentWidth = button_width;
button_ui.HorizontalAlignment = "left";
button_ui.Text = CodeTool1.i18n("Refresh");
button_ui.MainButton.Tooltip = CodeTool1.i18n("Load workspace variables.");
button_ui.ButtonPushedCallback = @() refreshInitialConditions(AppUIStruct);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.LoadSpeedUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.LoadSpeedUI.Name = CodeTool1.i18n("Load speed");
AppUIStruct.LoadSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.LoadSpeedUI.Value = "initial.LoadInertiaSpeed";
AppUIStruct.LoadSpeedUI.Unit = "rpm";
AppUIStruct.LoadSpeedUI.ValueReadOnly = true;
AppUIStruct.LoadSpeedUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.LoadSpeedUI.Value);

  function str = buildTooltipText(value_text)
    str = value_text + newline + CodeTool1.i18n("(To modify, edit the setup script.)");
  end  % nested function

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MotorSpeedUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MotorSpeedUI.Name = CodeTool1.i18n("Motor speed");
AppUIStruct.MotorSpeedUI.NameUIWidth = name_ui_width;
AppUIStruct.MotorSpeedUI.Value = "initial.motorDriveUnit_RotorSpd_rpm";
AppUIStruct.MotorSpeedUI.Unit = "rpm";
AppUIStruct.MotorSpeedUI.ValueReadOnly = true;
AppUIStruct.MotorSpeedUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.MotorSpeedUI.Value);

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.MotorTemperatureUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.MotorTemperatureUI.Name = CodeTool1.i18n("Motor temperature");
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

AppUIStruct.AmbientTemperatureUI = LiteApp8.Component.PhysicalValueUI(NewSlot(layout, row));
AppUIStruct.AmbientTemperatureUI.Name = CodeTool1.i18n("Ambient temperature");
AppUIStruct.AmbientTemperatureUI.NameUIWidth = name_ui_width;
AppUIStruct.AmbientTemperatureUI.Value = "initial.ambientTemp_K";
AppUIStruct.AmbientTemperatureUI.Unit = "K";
AppUIStruct.AmbientTemperatureUI.ValueReadOnly = true;
AppUIStruct.AmbientTemperatureUI.ValueEditFieldUI.MainEditField.Tooltip = buildTooltipText(AppUIStruct.AmbientTemperatureUI.Value);

row_number_AmbTempUI = layout.R;

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
label_ui.ComponentWidth = name_ui_width;
label_ui.Text = "\textbf{" + CodeTool1.i18n("Input signals") + "}";

% -----------------------------------------------------------------------------
row = NewRow(layout, column);

AppUIStruct.InputSignalPlotPanel = LiteApp8.Graphics.Panel(NewSlot(layout, row));
AppUIStruct.InputSignalPlotPanel.ComponentHeight = input_plot_panel_height;

% ---------------------------------------------------------------------------
% callbacks

  function update_referenced_subsystem(SelectedItem)
    %%
    evalin("base", AppSetup.ModelSetupScript)

    logical_index = SelectedItem == AppUIStruct.TargetBlockDropDownUI.Items;
    mdu_refsub_keyword = mdu_items(logical_index);

    refsub_name = "MotorDriveUnit_" + mdu_refsub_keyword + "_refsub";
    set_param(AppSetup.MainBlockPath, ReferencedSubsystem = refsub_name)

    % Show or hide temperature-related UI components.
    if mdu_refsub_keyword ~= "BasicThermal" && mdu_refsub_keyword ~= "System"
      % Hide
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_MotorTempUI).Children.RowHeight = 0;
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_AmbTempUI).Children.RowHeight = 0;

    else
      % Show
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_MotorTempUI).Children.RowHeight = "fit";
      layout.AreaGrid.Children(area_number).Children(column_number).Children(row_number_AmbTempUI).Children.RowHeight = "fit";

    end  % if

    update_inputs(AppUIStruct.InputsDropDownUI.Value)

  end  % nested function

  function update_inputs(input_case_display_keyword)
    %%
    logical_index = input_case_display_keyword == AppUIStruct.InputsDropDownUI.Items;
    input_case_keyword = input_case_items(logical_index);

    input_refsub_name = "Inputs_MotorDriveUnit_" + input_case_keyword + "_refsub";
    set_param(AppSetup.InputsBlockPath, ReferencedSubsystem = input_refsub_name)

    blocks = ["Axle speed switch" "Axle speed" "Axle torque" "Motor torque command" "Motor heat flow command"];
    ModelTool2.plotLookupTable1DBlocks(AppSetup.InputsBlockPath, ...
      Blocks=blocks, ...
      DivisionType = "InterpolationInterval", ...
      InterpolationInterval = 0.1, ...
      ParentType = "Panel", ...
      ParentPanel = AppUIStruct.InputSignalPlotPanel.MainPanel )

  end  % nested function

% ---------------------------------------------------------------------------
% Final step of building app UI

% Get the current subsystem reference name from the model, and update the app's refsub drop down UI.
current_refsub = string(get_param(AppSetup.ModelName + "/Motor Drive Unit", "ReferencedSubsystem"));
mdu_refsub_keyword = extractBetween(current_refsub, "MotorDriveUnit_", "_refsub");
logical_index = mdu_refsub_keyword == mdu_items;
AppUIStruct.TargetBlockDropDownUI.Value = mdu_display_items(logical_index);

refreshInitialConditions(AppUIStruct)
end  % function

%% ============================================================================
% Callbacks

function refreshInitialConditions(app_ui)
%%
app_ui.LoadSpeedUI.Value = "initial.LoadInertiaSpeed";
app_ui.MotorSpeedUI.Value = "initial.motorDriveUnit_RotorSpd_rpm";
app_ui.MotorTemperatureUI.Value = "initial.motorDriveUnit_Temperature_K";
app_ui.AmbientTemperatureUI.Value = "initial.ambientTemp_K";
end  % nested function
