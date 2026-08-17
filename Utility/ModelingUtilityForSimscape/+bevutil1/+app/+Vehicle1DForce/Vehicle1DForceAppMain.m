classdef Vehicle1DForceAppMain < handle
  % App for visualizing the longitudinal force of a road-vehicle.
  %
  % The app can optionally get parameters from or set parameters to
  % the "Longitudinal Vehicle" block in Simscape Driveline.

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "Vehicle1DForceAppMain:"
  end  % properties
  properties

    DataSet (1,1) bevutil1.app.Vehicle1DForce.Vehicle1DForceDataSet

    AppParameterStructName (1,1) string = ""

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""
    ModelFileFullPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    MainFigure matlab.ui.Figure
    Window bevutil1.AppUtil.AppWindow

    WindowWidth (1,1) double {mustBeInteger, mustBePositive} = 1100
    LeftSideWidth (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"
    RightSideWidth (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"

    WindowHeight (1,1) double {mustBeInteger, mustBePositive} = 730
    PlotUIHeight (1,1) double {mustBeInteger, mustBePositive} = 420

    % === Preset

    PresetDropDownUI bevutil1.AppUtil.Component.DropDown

    % === Vehicle

    VehicleMassUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    TireRollingCoefficientUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    AirDragCoefficientUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    FrontalAreaUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    % === Environment

    GravitationalAccelerationUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    DryAirDensityUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Road-load coefficient

    RoadLoadBUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Performance

    TopSpeedUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    MaxClimbGradePercentUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MaxAccelerationUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Derived parameters

    RoadLoadAUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    RoadLoadCUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MaxForceUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MaxClimbPowerUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MaxClimbPowerPSUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MaxClimbPowerBHPUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Visualization

    UpdateButtonUI bevutil1.AppUtil.Component.EnabledButton
    OpenInFigureWindowUI bevutil1.AppUtil.Component.Hyperlink

    AxesUI bevutil1.AppUtil.Graphics.Axes

    % === Plot customization

    PlotSpeedUpperBoundUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    PlotForceUpperBoundUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    PlotGradesUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    PlotPowersUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Struct parameter UI and block selector UI

    StructParameterUI bevutil1.AppUtil.Component.BaseWorkspaceStructParameterUI;
    AppBlockSelectorUI bevutil1.AppUtil.Component.BlockSelectorUI

  end  % properties
  properties (Constant, Access=private)

    TargetSimscapeBlockNames = "Longitudinal Vehicle"

    speed_unit_items = ["km/hr", "mph", "m/s"]
    force_unit_items = ["N", "lbf"]
    mass_unit_items = ["kg", "lbm"]

    width_unit = bevutil1.AppUtil.Constant.Width{"unitwidth"}
    name_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 20
    unit_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
    button_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12

    % !todo: Define alert ui width in a common resource file.
    alert_ui_width = 30

    oneline_height = bevutil1.AppUtil.Constant.Height{"oneline+"}

  end  % properties
  properties (Access=private)
    presets (1,1) bevutil1.app.Vehicle1DForce.Vehicle1DForcePresets
  end  % properties

  methods

    function App = Vehicle1DForceAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.AppParameterFileName (1,1) string = ""
        NameValuePair.AppParameterStructName (1,1) string = ""

        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      % Brake horsepower (imperial)
      pm_addunit("bhp", 745.7, "W")

      % Metric horsepower (Pferdestärke)
      pm_addunit("ps", 735.5, "W")

      App.presets = bevutil1.app.Vehicle1DForce.Vehicle1DForcePresets;
      App.DataSet = bevutil1.app.Vehicle1DForce.Vehicle1DForceDataSet(Initialization=true);

      % BlockPath takes precedence over ModelName.
      if NameValuePair.BlockPath ~= ""
        App.BlockPath = NameValuePair.BlockPath;
        App.ModelName = extractBefore(App.BlockPath, "/");
        if App.ModelName == ""
          id = App.errorID + "InvalidModelName";
          msg = bevutil1.CodeUtil.i18n("Empty model name is not allowed.");

          throw(MException(id, msg))

        end  % if
      elseif NameValuePair.ModelName ~= ""
        App.BlockPath = "";
        App.ModelName = NameValuePair.ModelName;

      else
        App.BlockPath = "";
        App.ModelName = "";
        App.ModelFileFullPath = "";
      end  % if

      if App.ModelName ~= ""
        try
          App.ModelFileFullPath = bevutil1.ModelUtil.getModelFileFullPath(App.ModelName);
        catch exception
          id = App.errorID + "InvalidModelName";
          msg = exception.message;

          throw(MException(id, msg))

        end  % try, catch

        % The target block must exist in the specified model.
        try
          result = bevutil1.ModelUtil.findSimscapeBlocks(App.ModelName, App.TargetSimscapeBlockNames);
        catch exception
          id = App.errorID + "SimscapeBlockWasNotFound";
          msg = exception.message;

          throw(MException(id, msg))

        end  % try, catch

        if App.BlockPath == ""
          % Use the first match.
          App.BlockPath = result(1);
        else
          if not(ismember(App.BlockPath, result))
            id = App.errorID + "InvalidBlockPath";
            msg = bevutil1.CodeUtil.i18n("The specified block was not found in the specified model.");

            throw(MException(id, msg))

          end  % if
        end  % if
      end  % if
      % At this point, BlockPath and ModelName are either both "" or both properly defined.

      App.MainFigure = uifigure(Visible="off");

      meta_data = metaclass(App);
      App.Window = bevutil1.AppUtil.AppWindow(App.MainFigure, SourceFile=which(meta_data.Name));
      App.Window.Name = bevutil1.CodeUtil.i18n("Vehicle 1D Force");
      App.Window.Width = App.WindowWidth;
      App.Window.Height = App.WindowHeight;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if NameValuePair.AppParameterFileName ~= ""
        if not(isfile(NameValuePair.AppParameterFileName))
          id = App.errorID + "InvalidAppParameterFileName";
          msg = bevutil1.CodeUtil.i18n("Invalid file was specified: " + NameValuePair.AppParameterFileName);

          throw(MException(id, msg))

        end  % if
        if NameValuePair.AppParameterStructName == ""
          id = App.errorID + "AppParameterStructNameIsRequired";
          msg = bevutil1.CodeUtil.i18n("AppParameterStructName is required when AppParameterFile is specified.");

          throw(MException(id, msg))

        end  % if
        % Set up the app with the parameter file.

        paramfile_fullpath = NameValuePair.AppParameterFileName;
        [~, paramfile_name, ~] = fileparts(paramfile_fullpath);
        disp("Evaluating: <a href=""matlab:edit('" + paramfile_fullpath + "')"">" + paramfile_name + "</a>")
        try
          evalin("base", paramfile_name + ";");
        catch exception

          rethrow(exception)

        end  % try, catch

        App.StructParameterUI.ParameterFileDropDownUI.Items(end+1) = NameValuePair.AppParameterFileName;
        App.StructParameterUI.ParameterFileDropDownUI.Value = NameValuePair.AppParameterFileName;

        App.AppParameterStructName = NameValuePair.AppParameterStructName;

        App.StructParameterUI.StructNameDropDownUI.Items(end+1) = NameValuePair.AppParameterStructName;
        App.StructParameterUI.StructNameDropDownUI.Value = NameValuePair.AppParameterStructName;

        loadParametersFromBaseWorkspace(App, StructName=NameValuePair.AppParameterStructName)

      elseif NameValuePair.AppParameterStructName ~= ""
        App.AppParameterStructName = NameValuePair.AppParameterStructName;

        App.StructParameterUI.StructNameDropDownUI.Items(end+1) = NameValuePair.AppParameterStructName;
        App.StructParameterUI.StructNameDropDownUI.Value = NameValuePair.AppParameterStructName;

        loadParametersFromBaseWorkspace(App, StructName=NameValuePair.AppParameterStructName)

      else
        % Default settings.

        App.VehicleMassUI.SimscapeValue = App.DataSet.ModelParams.VehicleMass;
        App.TireRollingCoefficientUI.SimscapeValue = App.DataSet.ModelParams.TireRollingCoefficient;
        App.AirDragCoefficientUI.SimscapeValue = App.DataSet.ModelParams.AirDragCoefficient;
        App.FrontalAreaUI.SimscapeValue = App.DataSet.ModelParams.FrontalArea;

        App.GravitationalAccelerationUI.SimscapeValue = App.DataSet.ModelParams.GravitationalAcceleration;
        App.DryAirDensityUI.SimscapeValue = App.DataSet.ModelParams.DryAirDensity;

        App.RoadLoadBUI.SimscapeValue = App.DataSet.ModelParams.RoadLoadB;

        App.TopSpeedUI.SimscapeValue = App.DataSet.ModelParams.TopSpeed;
        App.MaxAccelerationUI.SimscapeValue = App.DataSet.ModelParams.MaxAcceleration;
        App.MaxClimbGradePercentUI.SimscapeValue = App.DataSet.ModelParams.MaxClimbGradePercent;

        App.PlotSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotSpeedUpperBound;
        App.PlotForceUpperBoundUI.SimscapeValue = App.DataSet.PlotForceUpperBound;
        App.PlotGradesUI.SimscapeValue = App.DataSet.PlotGrades;
        App.PlotPowersUI.SimscapeValue = App.DataSet.PlotPowers;
      end  % if

      if App.BlockPath ~= ""
        App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end + 1) = replace(App.ModelFileFullPath, ("/"|"\"), " > ");
        try
          App.AppBlockSelectorUI.ModelFileDropDownUI.Value = App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end);
        catch exception

          rethrow(exception)

        end  % try, catch
        App.AppBlockSelectorUI.BlockPathDropDownUI.Value = replace(App.BlockPath, "/", " / ");

        callback_get_parameters(App)

        % .....................................................................
        % Set up non-block parameters with defaults.
        data_set = bevutil1.app.Vehicle1DForce.Vehicle1DForceDataSet(Initialization=true);

        % !todo: Remove this once the vehicle block starts providing dry air as a public parameter.
        App.DryAirDensityUI.SimscapeValue = data_set.ModelParams.DryAirDensity;

        App.RoadLoadBUI.SimscapeValue = data_set.ModelParams.RoadLoadB;
        App.TopSpeedUI.SimscapeValue = data_set.ModelParams.TopSpeed;
        App.MaxAccelerationUI.SimscapeValue = data_set.ModelParams.MaxAcceleration;
        App.MaxClimbGradePercentUI.SimscapeValue = data_set.ModelParams.MaxClimbGradePercent;

        App.PlotSpeedUpperBoundUI.SimscapeValue = data_set.PlotSpeedUpperBound;
        App.PlotForceUpperBoundUI.SimscapeValue = data_set.PlotForceUpperBound;
        App.PlotGradesUI.SimscapeValue = data_set.PlotGrades;
        App.PlotPowersUI.SimscapeValue = data_set.PlotPowers;

      end  % if

      % Enable plot auto-update.
      App.UpdateButtonUI.ButtonDisable = "on";

      updateApp(App)

      movegui(App.MainFigure, "center")
      App.MainFigure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      appmain_v_container = App.Window.MainVerticalContainer;
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);

      appmain_h_container = bevutil1.AppUtil.HorizontalContainer(appmain_v_layout);

      % =======================================================================
      % Left side of the app window
      % =======================================================================
      appleft_h_layout = addHorizontalGridLayout(appmain_h_container, Width=App.LeftSideWidth);
      appleft_v_container = bevutil1.AppUtil.VerticalContainer(appleft_h_layout);

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      description_link_ui = bevutil1.AppUtil.Component.Hyperlink(appleft_v_layout);
      description_link_ui.Text = bevutil1.CodeUtil.i18n("Description");
      description_link_ui.HyperlinkClickedCallback = @() web("Vehicle1DForceApp_Description_bevutil1.html");

      %% ======================================================================
      % Preset

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      % Add a horizontal space (alert_ui_width) between this label and the drop down created below.
      % This makes the left side of the drop down aligned with the edit fields of
      % PhysicalValueWithUnitDropDown components that are vertically placed beneath the drop down.
      label_ui.ComponentWidth = App.name_ui_width + App.alert_ui_width;
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Preset") + "}";

      h_layout = addHorizontalGridLayout(h_container);
      App.PresetDropDownUI = bevutil1.AppUtil.Component.DropDown(h_layout);
      App.PresetDropDownUI.Editable = "off";
      App.PresetDropDownUI.Items = [""; keys(App.presets.PresetDictionary)];
      App.PresetDropDownUI.MainDropDown.Value = "";
      App.PresetDropDownUI.ValueChangedCallback = @() react_PresetChanged(App);

      %% ======================================================================
      % Vehicle

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Vehicle") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.VehicleMassUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.VehicleMassUI.Editable = "on";
      App.VehicleMassUI.NameUIWidth = App.name_ui_width;
      App.VehicleMassUI.UnitUIWidth = App.unit_ui_width;
      App.VehicleMassUI.NameText = bevutil1.CodeUtil.i18n("Vehicle mass, $M_v$");
      App.VehicleMassUI.UnitItems = App.mass_unit_items;
      App.VehicleMassUI.UnitText = "kg";
      App.VehicleMassUI.ValueChangedCallback = @() updateApp(App);
      App.VehicleMassUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.TireRollingCoefficientUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.TireRollingCoefficientUI.NameUIWidth = App.name_ui_width;
      App.TireRollingCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.TireRollingCoefficientUI.NameText = bevutil1.CodeUtil.i18n("Tire rolling coefficient, $C_{roll}$");
      App.TireRollingCoefficientUI.UnitAlias = "";
      App.TireRollingCoefficientUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.AirDragCoefficientUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.AirDragCoefficientUI.NameUIWidth = App.name_ui_width;
      App.AirDragCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.AirDragCoefficientUI.NameText = bevutil1.CodeUtil.i18n("Air drag coefficient, $C_d$");
      App.AirDragCoefficientUI.UnitAlias = "";
      App.AirDragCoefficientUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.FrontalAreaUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.FrontalAreaUI.Editable = "on";
      App.FrontalAreaUI.NameUIWidth = App.name_ui_width;
      App.FrontalAreaUI.UnitUIWidth = App.unit_ui_width;
      App.FrontalAreaUI.NameText = bevutil1.CodeUtil.i18n("Frontal area, $A_f$");
      App.FrontalAreaUI.UnitItems = ["m^2", "ft^2"];
      App.FrontalAreaUI.UnitText = "m^2";
      App.FrontalAreaUI.ValueChangedCallback = @() updateApp(App);
      App.FrontalAreaUI.UnitChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Environment

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Environment") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.GravitationalAccelerationUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.GravitationalAccelerationUI.NameUIWidth = App.name_ui_width;
      App.GravitationalAccelerationUI.UnitUIWidth = App.unit_ui_width;
      App.GravitationalAccelerationUI.NameText = bevutil1.CodeUtil.i18n("Gravitational acceleration, $g$");
      App.GravitationalAccelerationUI.UnitText = "m/s^2";
      App.GravitationalAccelerationUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.DryAirDensityUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.DryAirDensityUI.NameUIWidth = App.name_ui_width;
      App.DryAirDensityUI.UnitUIWidth = App.unit_ui_width;
      App.DryAirDensityUI.NameText = bevutil1.CodeUtil.i18n("Dry air density, $\rho$");
      App.DryAirDensityUI.UnitText = "kg/m^3";
      App.DryAirDensityUI.ValueChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Road-load coefficient

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Road-load coefficient") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadBUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadBUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadBUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadBUI.NameText = bevutil1.CodeUtil.i18n("$B_{rl}$");
      App.RoadLoadBUI.UnitText = "N/(m/s)";
      App.RoadLoadBUI.ValueChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Performance

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Performance") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.TopSpeedUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.TopSpeedUI.Editable = "on";
      App.TopSpeedUI.NameUIWidth = App.name_ui_width;
      App.TopSpeedUI.UnitUIWidth = App.unit_ui_width;
      App.TopSpeedUI.NameText = bevutil1.CodeUtil.i18n("Top speed, $V_{max}$");
      App.TopSpeedUI.UnitItems = App.speed_unit_items;
      App.TopSpeedUI.UnitText = "km/hr";
      App.TopSpeedUI.ValueChangedCallback = @() updateApp(App);
      App.TopSpeedUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbGradePercentUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbGradePercentUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbGradePercentUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbGradePercentUI.NameText = bevutil1.CodeUtil.i18n("Max climb grade, $\beta_{max}$");
      App.MaxClimbGradePercentUI.UnitAlias = "\%";
      App.MaxClimbGradePercentUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxAccelerationUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxAccelerationUI.NameUIWidth = App.name_ui_width;
      App.MaxAccelerationUI.UnitUIWidth = App.unit_ui_width;
      App.MaxAccelerationUI.NameText = bevutil1.CodeUtil.i18n("Max acceleration, $g_{max}$");
      App.MaxAccelerationUI.UnitAlias = "G";
      App.MaxAccelerationUI.ValueChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Derived parameters

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Derived parameters") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbPowerUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbPowerUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbPowerUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbPowerUI.NameText = bevutil1.CodeUtil.i18n("Climb power, $P_c$, at $V_{max}, \beta_{max}$");
      App.MaxClimbPowerUI.UnitText = "kW";
      App.MaxClimbPowerUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbPowerBHPUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbPowerBHPUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbPowerBHPUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbPowerBHPUI.NameText = "$P_{c,bhp} =  P_c / 0.7457$";
      App.MaxClimbPowerBHPUI.UnitText = "bhp";
      App.MaxClimbPowerBHPUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbPowerPSUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbPowerPSUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbPowerPSUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbPowerPSUI.NameText = "$P_{c,ps} =  P_c / 0.7355$";
      App.MaxClimbPowerPSUI.UnitText = "ps";
      App.MaxClimbPowerPSUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxForceUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxForceUI.NameUIWidth = App.name_ui_width;
      App.MaxForceUI.UnitUIWidth = App.unit_ui_width;
      App.MaxForceUI.NameText = bevutil1.CodeUtil.i18n("Max force, $F_{max} = g_{max} M_v g$");
      App.MaxForceUI.UnitText = "N";
      App.MaxForceUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadAUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadAUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadAUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadAUI.NameText = bevutil1.CodeUtil.i18n("$A_{rl} = C_{roll} M_v g$");
      App.RoadLoadAUI.UnitText = "N";
      App.RoadLoadAUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadCUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadCUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadCUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadCUI.NameText = bevutil1.CodeUtil.i18n("$C_{rl} = (1/2) C_d A_f \rho$");
      App.RoadLoadCUI.UnitText = "N/(m/s)^2";
      App.RoadLoadCUI.ReadOnlyValueText = true;

      % =======================================================================
      % (invisible) center divider of the app window - this is a thin tall empty space.
      addHorizontalGridLayout(appmain_h_container, Width=20);

      % =======================================================================
      % Right side of the app window
      % =======================================================================
      appright_h_layout = addHorizontalGridLayout(appmain_h_container, Width=App.RightSideWidth);
      appright_v_container = bevutil1.AppUtil.VerticalContainer(appright_h_layout);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appright_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.UpdateButtonUI = bevutil1.AppUtil.Component.EnabledButton(h_layout);
      App.UpdateButtonUI.HorizontalAlignment = "left";
      App.UpdateButtonUI.ButtonUIWidth = App.button_width + App.width_unit;
      App.UpdateButtonUI.ButtonWidth = App.button_width;
      App.UpdateButtonUI.CheckBoxUIWidth = "fit";
      App.UpdateButtonUI.CheckBoxWidth = "fit";
      App.UpdateButtonUI.ButtonText = bevutil1.CodeUtil.i18n("Update");
      App.UpdateButtonUI.ButtonUI.MainButton.Icon = which("mus-icon-rotation-arrow.svg");
      App.UpdateButtonUI.CheckBoxText = bevutil1.CodeUtil.i18n("Auto update");
      App.UpdateButtonUI.ButtonPushedCallback = @() updateApp(App, PlotMode="force");
      % Set auto-update to false and keep it until the entire app is ready.
      App.UpdateButtonUI.ButtonDisable = "on";

      h_layout = addHorizontalGridLayout(h_container);
      App.OpenInFigureWindowUI = bevutil1.AppUtil.Component.Hyperlink(h_layout);
      App.OpenInFigureWindowUI.Text = bevutil1.CodeUtil.i18n("Open in figure window");
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";

      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @open_in_figure_window;
      function open_in_figure_window
        bevutil1.app.Vehicle1DForce.plotVehicle1DForce( ...
          ParentAxes = axes(figure(WindowStyle="normal")), ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % nested function

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.AxesUI = bevutil1.AppUtil.Graphics.Axes(appright_v_layout);
      App.AxesUI.ComponentHeight = App.PlotUIHeight;

      %% ======================================================================
      % Plot customization

      appright_v_layout = addVerticalGridLayout(appright_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appright_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Plot customization") + "}";

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotSpeedUpperBoundUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotSpeedUpperBoundUI.Editable = "on";
      App.PlotSpeedUpperBoundUI.NameUIWidth = App.name_ui_width;
      App.PlotSpeedUpperBoundUI.UnitUIWidth = App.unit_ui_width;
      App.PlotSpeedUpperBoundUI.NameText = bevutil1.CodeUtil.i18n("Speed upper bound");
      App.PlotSpeedUpperBoundUI.UnitItems = App.speed_unit_items;
      App.PlotSpeedUpperBoundUI.UnitText = "km/hr";
      App.PlotSpeedUpperBoundUI.ValueChangedCallback = @() updateApp(App);
      App.PlotSpeedUpperBoundUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotForceUpperBoundUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotForceUpperBoundUI.Editable = "on";
      App.PlotForceUpperBoundUI.NameUIWidth = App.name_ui_width;
      App.PlotForceUpperBoundUI.UnitUIWidth = App.unit_ui_width;
      App.PlotForceUpperBoundUI.NameText = bevutil1.CodeUtil.i18n("Force upper bound");
      App.PlotForceUpperBoundUI.UnitItems = App.force_unit_items;
      App.PlotForceUpperBoundUI.UnitText = "N";
      App.PlotForceUpperBoundUI.ValueChangedCallback = @() updateApp(App);
      App.PlotForceUpperBoundUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotGradesUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotGradesUI.NameUIWidth = App.name_ui_width;
      App.PlotGradesUI.UnitUIWidth = App.unit_ui_width;
      App.PlotGradesUI.NameText = bevutil1.CodeUtil.i18n("Road grades");
      App.PlotGradesUI.UnitAlias = "\%";
      App.PlotGradesUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotPowersUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotPowersUI.NameUIWidth = App.name_ui_width;
      App.PlotPowersUI.UnitUIWidth = App.unit_ui_width;
      App.PlotPowersUI.NameText = bevutil1.CodeUtil.i18n("Constant power curves");
      App.PlotPowersUI.UnitText = "kW";
      App.PlotPowersUI.ValueChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Bottom area

      % -----------------------------------------------------------------------
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);
      bevutil1.AppUtil.Component.HorizontalLine(appmain_v_layout);

      % -----------------------------------------------------------------------
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);
      App.StructParameterUI = bevutil1.AppUtil.Component.BaseWorkspaceStructParameterUI(appmain_v_layout);
      App.StructParameterUI.GetParametersFromBaseWorkspaceCallback = @() loadParametersFromBaseWorkspace(App);

      % -----------------------------------------------------------------------
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);
      bevutil1.AppUtil.Component.HorizontalLine(appmain_v_layout);

      % -----------------------------------------------------------------------
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);
      App.AppBlockSelectorUI = bevutil1.AppUtil.Component.BlockSelectorUI(appmain_v_layout);
      App.AppBlockSelectorUI.TargetSimscapeBlockNames = App.TargetSimscapeBlockNames;
      App.AppBlockSelectorUI.GetParametersFromBlockCallback = @() callback_get_parameters(App);
      App.AppBlockSelectorUI.SetParametersToBlockCallback = @() callback_set_parameters(App);

    end  % function

    function callback_set_parameters(App)
      %%
      % Read parameters from the UI components and set them to the selected block.
      %
      % If the UI component's ValueText contains a simscape.Value, use the unit
      % defined in it for transferring to the block parameter setting by appending
      % .value("<unit>") text. Also set up the block parameter's unit to be
      % the same as the simscape.Value's unit.

      % This callback can run only when a valid block path is selected in the block path drop down UI.
      % Thus, accessing App.BlockPathDropDownUI.Value here is safe.
      block_path = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      App.BlockPath = block_path;

      load_system(block_path)

      set_param(block_path, "M_vehicle_unit", App.VehicleMassUI.UnitText);
      if App.VehicleMassUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.VehicleMassUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "M_vehicle", App.VehicleMassUI.ValueText + extra_text);

      % This parameter has no physical unit.
      set_param(block_path, "C_tireroll", App.TireRollingCoefficientUI.ValueText);

      % This parameter has no physical unit.
      set_param(block_path, "C_airdrag", App.AirDragCoefficientUI.ValueText);

      set_param(block_path, "A_front_unit", App.FrontalAreaUI.UnitText);
      if App.FrontalAreaUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.FrontalAreaUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "A_front", App.FrontalAreaUI.ValueText + extra_text);

      set_param(block_path, "g_unit", App.GravitationalAccelerationUI.UnitText);
      if App.GravitationalAccelerationUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.GravitationalAccelerationUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "g", App.GravitationalAccelerationUI.ValueText + extra_text);

    end  % function

    function callback_get_parameters(App)
      %%
      % Get parameters from the selected block and load them to the app.

      App.BlockPath = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");

      load_system(App.BlockPath)

      % Create a data set object from the specified block path.
      % If block parameters refer to workspace variables, the workspace variables must be loaded upfront.
      % This updates the derived parameters too.
      try
        App.DataSet = bevutil1.app.Vehicle1DForce.Vehicle1DForceDataSet(BlockPath=App.BlockPath);
      catch exception
        if App.MainFigure.Visible
          msg = exception.message;
          window_title = bevutil1.CodeUtil.i18n("Error");
          uialert(App.MainFigure, msg, window_title)

          return

        else

          rethrow(exception)

        end  % if
      end  % try, catch

      % -----------------------------------------------------------------------
      % Prevent the plot auto update while updating multiple UI components.
      prev_value = App.UpdateButtonUI.CheckBoxUI.Value;
      App.UpdateButtonUI.CheckBoxUI.Value = false;
      % -----------------------------------------------------------------------

      App.VehicleMassUI.UnitText = get_param(App.BlockPath, "M_vehicle_unit");
      App.VehicleMassUI.ValueText = get_param(App.BlockPath, "M_vehicle");

      App.TireRollingCoefficientUI.ValueText = get_param(App.BlockPath, "C_tireroll");

      App.AirDragCoefficientUI.ValueText = get_param(App.BlockPath, "C_airdrag");

      App.FrontalAreaUI.UnitText = get_param(App.BlockPath, "A_front_unit");
      App.FrontalAreaUI.ValueText = get_param(App.BlockPath, "A_front");

      App.GravitationalAccelerationUI.UnitText = get_param(App.BlockPath, "g_unit");
      App.GravitationalAccelerationUI.ValueText = get_param(App.BlockPath, "g");

      % !todo: Get the dry air density if it is a public parameter of the vehicle block.

      % -----------------------------------------------------------------------
      % Recover the plot auto update setting.
      App.UpdateButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      updateApp(App)

    end  % function

    function loadParametersFromBaseWorkspace(App, NameValuePair)
      %%
      arguments (Input)
        App
        NameValuePair.StructName (1,1) string = ""
      end  % arguments

      if NameValuePair.StructName ~= ""
        struct_name = NameValuePair.StructName;
      else
        struct_name = App.StructParameterUI.StructNameDropDownUI.Value;
      end  % if

      if struct_name == ""

        return

      end  % if

      if contains(struct_name, ".")
        var_base_name = extractBefore(struct_name, ".");
      else
        var_base_name = struct_name;
      end  % if
      base_workspace_vars = evalin("base", "whos");
      var_names = string({base_workspace_vars.name}');
      if not(ismember(var_base_name, var_names))
        id = App.errorID + "StructNotFoundInBaseWorkspace";
        msg = bevutil1.CodeUtil.i18n("Specified struct was not found in the base workspace: ") + var_base_name;

        throw(MException(id, msg))

      end  % if

      App.AppParameterStructName = struct_name;
      % The specified struct must have the struct fields as coded below.

      % -----------------------------------------------------------------------
      % ModelParameters properties, only those used by this app.

      setupParameterUI("VehicleMass")
      setupParameterUI("TireRollingCoefficient")
      setupParameterUI("AirDragCoefficient")
      setupParameterUI("FrontalArea")

      setupParameterUI("GravitationalAcceleration")
      setupParameterUI("DryAirDensity")

      setupParameterUI("RoadLoadB")

      setupParameterUI("TopSpeed")
      setupParameterUI("MaxAcceleration")
      setupParameterUI("MaxClimbGradePercent")

      % -----------------------------------------------------------------------
      % DataSet > Visualization parameters

      setupParameterUI("PlotSpeedUpperBound")
      setupParameterUI("PlotForceUpperBound")
      setupParameterUI("PlotGrades")
      setupParameterUI("PlotPowers")

      % -----------------------------------------------------------------------
      updateApp(App)

      function setupParameterUI(target_name)
        % Calling setupParameterUI("VehicleMass") yields the following.
        %   App.VehicleMassUI.ValueText = struct_name + "." + "VehicleMass";

        try
          value_text = App.(target_name + "UI").ValueText;
        catch exception

          return

        end  % try, catch
        try
          App.(target_name + "UI").ValueText = struct_name + "." + target_name;
        catch exception
          App.(target_name + "UI").ValueText = value_text;
        end  % try, catch
      end  % nested function
    end  % function

    function react_PresetChanged(App)
      %%
      selected_value = App.PresetDropDownUI.MainDropDown.Value;

      if not(isKey(App.presets.PresetDictionary, selected_value))

        return

      end  % if

      preset_data = App.presets.PresetDictionary(selected_value);

      % -----------------------------------------------------------------------
      % Prevent the plot auto update while updating multiple UI components.
      prev_value = App.UpdateButtonUI.CheckBoxUI.Value;
      App.UpdateButtonUI.CheckBoxUI.Value = false;
      % -----------------------------------------------------------------------

      % Vehicle
      App.VehicleMassUI.SimscapeValue = preset_data.ModelParams.VehicleMass;
      App.TireRollingCoefficientUI.SimscapeValue = preset_data.ModelParams.TireRollingCoefficient;
      App.AirDragCoefficientUI.SimscapeValue = preset_data.ModelParams.AirDragCoefficient;
      App.FrontalAreaUI.SimscapeValue = preset_data.ModelParams.FrontalArea;

      % Environment
      App.GravitationalAccelerationUI.SimscapeValue = preset_data.ModelParams.GravitationalAcceleration;
      App.DryAirDensityUI.SimscapeValue = preset_data.ModelParams.DryAirDensity;

      % Road-load coefficient
      App.RoadLoadBUI.SimscapeValue = preset_data.ModelParams.RoadLoadB;

      % Performance
      App.TopSpeedUI.SimscapeValue = preset_data.ModelParams.TopSpeed;
      App.MaxAccelerationUI.SimscapeValue = preset_data.ModelParams.MaxAcceleration;
      App.MaxClimbGradePercentUI.SimscapeValue = preset_data.ModelParams.MaxClimbGradePercent;

      % Visualization parameters
      App.PlotSpeedUpperBoundUI.SimscapeValue = preset_data.PlotSpeedUpperBound;
      App.PlotForceUpperBoundUI.SimscapeValue = preset_data.PlotForceUpperBound;
      App.PlotGradesUI.SimscapeValue = preset_data.PlotGrades;
      App.PlotPowersUI.SimscapeValue = preset_data.PlotPowers;

      % -----------------------------------------------------------------------
      % Recover the plot auto update setting.
      App.UpdateButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      updateApp(App)

    end  % function

    function updateApp(App, NameValuePair)
      %%
      arguments (Input)
        App (1,1)

        NameValuePair.PlotMode (1,1) string ...
          { mustBeMember(NameValuePair.PlotMode, ["auto", "skip", "force"]) } = "auto"
      end  % if

      % .......................................................................
      % Transfer data from the UI components to the data set.

      safeupdate_DataSet_from_SimscapeValue("ModelParams", "VehicleMass", "VehicleMassUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "TireRollingCoefficient", "TireRollingCoefficientUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "AirDragCoefficient", "AirDragCoefficientUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "FrontalArea", "FrontalAreaUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "GravitationalAcceleration", "GravitationalAccelerationUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "DryAirDensity", "DryAirDensityUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "RoadLoadB", "RoadLoadBUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "TopSpeed", "TopSpeedUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MaxAcceleration", "MaxAccelerationUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MaxClimbGradePercent", "MaxClimbGradePercentUI")

      safeupdate_DataSet_from_SimscapeValue("PlotSpeedUpperBound", "PlotSpeedUpperBoundUI")
      safeupdate_DataSet_from_SimscapeValue("PlotForceUpperBound", "PlotForceUpperBoundUI")
      safeupdate_DataSet_from_SimscapeValue("PlotGrades", "PlotGradesUI")
      safeupdate_DataSet_from_SimscapeValue("PlotPowers", "PlotPowersUI")

      function safeupdate_DataSet_from_SimscapeValue(varargin)
        % This is specific to UI component's SimscapeValue.
        % Calls to this function such as
        %   safeUpdateDataSetFromSimscapeValue("ModelParams", "VehicleMass", "VehicleMassUI")
        % or
        %   safeUpdateDataSetFromSimscapeValue("PlotSpeedUpperBound", "PlotSpeedUpperBoundUI")
        % correspond to calls as follows
        %   App.DataSet.ModelParams.VehicleMass = App.VehicleMassUI.SimscapeValue;
        % or
        %   App.DataSet.PlotSpeedUpperBound = App.PlotSpeedUpperBoundUI.SimscapeValue;
        % respectively.
        try
          if nargin == 3
            previous_data = App.DataSet.(varargin{1}).(varargin{2});
            App.DataSet.(varargin{1}).(varargin{2}) = App.(varargin{3}).SimscapeValue;
          else
            % Assume nargin is 2.
            previous_data = App.DataSet.(varargin{1});
            App.DataSet.(varargin{1}) = App.(varargin{2}).SimscapeValue;
          end  % if
        catch exception
          if nargin == 3
            App.(varargin{3}).SimscapeValue = previous_data;
          else
            App.(varargin{2}).SimscapeValue = previous_data;
          end  % if
          if App.MainFigure.Visible
            msg = exception.message;
            window_title = bevutil1.CodeUtil.i18n("Error");
            uialert(App.MainFigure, msg, window_title, Interpreter="html")

            return

          else

            rethrow(exception)

          end  % if
        end  % try, catch
      end  % nested function

      % .......................................................................
      % Update the internal states (derived parameters) of the data set.

      previous_dataset = App.DataSet;
      try
        App.DataSet = updateDataSet(App.DataSet);
      catch exception
        App.DataSet = previous_dataset;
        App.VehicleMassUI.SimscapeValue = App.DataSet.ModelParams.VehicleMass;
        App.TireRollingCoefficientUI.SimscapeValue = App.DataSet.ModelParams.TireRollingCoefficient;
        App.AirDragCoefficientUI.SimscapeValue = App.DataSet.ModelParams.AirDragCoefficient;
        App.FrontalAreaUI.SimscapeValue = App.DataSet.ModelParams.FrontalArea;
        App.GravitationalAccelerationUI.SimscapeValue = App.DataSet.ModelParams.GravitationalAcceleration;
        App.DryAirDensityUI.SimscapeValue = App.DataSet.ModelParams.DryAirDensity;
        App.RoadLoadBUI.SimscapeValue = App.DataSet.ModelParams.RoadLoadB;
        App.TopSpeedUI.SimscapeValue = App.DataSet.ModelParams.TopSpeed;
        App.MaxAccelerationUI.SimscapeValue = App.DataSet.ModelParams.MaxAcceleration;
        App.MaxClimbGradePercentUI.SimscapeValue = App.DataSet.ModelParams.MaxClimbGradePercent;
        App.PlotSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotSpeedUpperBound;
        App.PlotForceUpperBoundUI.SimscapeValue = App.DataSet.PlotForceUpperBound;
        App.PlotGradesUI.SimscapeValue = App.DataSet.PlotGrades;
        App.PlotPowersUI.SimscapeValue = App.DataSet.PlotPowers;

        App.DataSet = updateDataSet(App.DataSet);
        updateApp(App, PlotMode="skip")

        msg = exception.message;
        window_title = bevutil1.CodeUtil.i18n("Error");
        uialert(App.MainFigure, msg, window_title)

        return

      end  % try, catch

      % .......................................................................
      % Update UI components for derived parameters

      App.MaxForceUI.ValueText = string(value(App.DataSet.ModelParams.MaxForce, "N"));

      App.MaxClimbPowerUI.ValueText = string(value(App.DataSet.ModelParams.MaxClimbPower, "kW"));
      App.MaxClimbPowerPSUI.ValueText = value(App.MaxClimbPowerUI.SimscapeValue, "ps");
      App.MaxClimbPowerBHPUI.ValueText = value(App.MaxClimbPowerUI.SimscapeValue, "bhp");

      App.RoadLoadAUI.ValueText = string(value(App.DataSet.ModelParams.RoadLoadA, "N"));
      App.RoadLoadCUI.ValueText = string(value(App.DataSet.ModelParams.RoadLoadC, "N/(m/s)^2"));

      % -----------------------------------------------------------------------
      if NameValuePair.PlotMode == "skip"

        return

      elseif NameValuePair.PlotMode == "force" ...
          || ((NameValuePair.PlotMode == "auto") && App.UpdateButtonUI.CheckBoxUI.Value)
        bevutil1.app.Vehicle1DForce.plotVehicle1DForce( ...
          ParentAxes = App.AxesUI.MainAxes, ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % if
    end  % function

  end  % methods
end  % classdef
