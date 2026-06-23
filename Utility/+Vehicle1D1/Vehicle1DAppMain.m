classdef Vehicle1DAppMain < handle
  % App for visualizing the longitudinal force of a road-vehicle.
  %
  % The app can optionally get parameters from or set parameters to
  % the "Longitudinal Vehicle" block in Simscape Driveline.

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "Vehicle1DAppMain:"
  end  % properties
  properties

    DataSet (1,1) Vehicle1D1.Vehicle1DDataSet

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""
    ModelFileFullPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    MainFigure matlab.ui.Figure
    Window AppUtil1.AppWindow

    % === Preset

    PresetDropDownUI AppUtil1.Component.DropDown

    % === Editable parameters - Vehicle

    VehicleMassUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    TireRollingCoefficientUI AppUtil1.Component.PhysicalValueWithUnitLabel
    AirDragCoefficientUI AppUtil1.Component.PhysicalValueWithUnitLabel
    FrontalAreaUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    % === Editable parameters - Environment

    GravitationalAccelerationUI AppUtil1.Component.PhysicalValueWithUnitLabel
    AirDensityUI AppUtil1.Component.PhysicalValueWithUnitLabel

    % === Editable parameters - Road-load

    RoadLoadBUI AppUtil1.Component.PhysicalValueWithUnitLabel

    % === Editable parameters - Performance

    TopSpeedUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    MaxAccelerationUI AppUtil1.Component.PhysicalValueWithUnitLabel
    MaxClimbGradePercentUI AppUtil1.Component.PhysicalValueWithUnitLabel

    % === Derived parameters

    RoadLoadAUI AppUtil1.Component.PhysicalValueWithUnitLabel
    RoadLoadCUI AppUtil1.Component.PhysicalValueWithUnitLabel
    MaxForceUI AppUtil1.Component.PhysicalValueWithUnitLabel
    MaxClimbPowerUI AppUtil1.Component.PhysicalValueWithUnitLabel
    MaxPowerFyiUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    % === Visualization

    PlotButtonUI AppUtil1.Component.EnabledButton
    OpenInFigureWindowUI AppUtil1.Component.Hyperlink

    AxesUI AppUtil1.Graphics.Axes

    PlotSpeedUpperBoundUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    PlotForceUpperBoundUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    PlotGradesUI AppUtil1.Component.PhysicalValueWithUnitLabel
    PlotPowersUI AppUtil1.Component.PhysicalValueWithUnitLabel

    % === Block selector
    AppBlockSelectorUI AppUtil1.Component.BlockSelectorUI

  end  % properties
  properties (Constant, Access=private)

    TargetSimscapeBlockNames = "Longitudinal Vehicle"

    speed_unit_items = ["km/hr", "mph", "m/s"]
    force_unit_items = ["N", "lbf"]
    mass_unit_items = ["kg", "lbm"]

    width_unit = AppUtil1.Constant.Width{"unitwidth"}
    name_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 20
    unit_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 12
    button_width = AppUtil1.Constant.Width{"unitwidth"} * 12

    app_window_width = 1100
    right_pane_width = 550
    plot_height = 400

    app_window_height = 650

    oneline_height = AppUtil1.Constant.Height{"oneline+"}

  end  % properties
  properties (Access=private)
    presets (1,1) Vehicle1D1.Vehicle1DParameterPresets
  end  % properties

  methods

    function App = Vehicle1DAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      App.presets = Vehicle1D1.Vehicle1DParameterPresets;
      App.DataSet = Vehicle1D1.Vehicle1DDataSet(Initialization=true);

      % BlockPath takes precedence over ModelName.
      if NameValuePair.BlockPath ~= ""
        App.BlockPath = NameValuePair.BlockPath;
        App.ModelName = extractBefore(App.BlockPath, "/");
        if App.ModelName == ""
          id = App.errorID + "InvalidModelName";
          msg = CodeUtil1.i18n("Empty model name is not allowed.");

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
          App.ModelFileFullPath = ModelUtil1.getModelFileFullPath(App.ModelName);
        catch exception
          id = App.errorID + "InvalidModelName";
          msg = exception.message;

          throw(MException(id, msg))

        end  % try, catch

        % The target block must exist in the specified model.
        try
          result = ModelUtil1.findSimscapeBlocks(App.ModelName, App.TargetSimscapeBlockNames);
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
            msg = CodeUtil1.i18n("The specified block was not found in the specified model.");

            throw(MException(id, msg))

          end  % if
        end  % if
      end  % if
      % At this point, BlockPath and ModelName are either both "" or both properly defined.

      App.MainFigure = uifigure(Visible="off");

      meta_data = metaclass(App);
      App.Window = AppUtil1.AppWindow(App.MainFigure, SourceFile=which(meta_data.Name));
      App.Window.Name = CodeUtil1.i18n("Vehicle1D App");
      App.Window.Width = App.app_window_width;
      App.Window.Height = App.app_window_height;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if App.BlockPath ~= ""
        App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end + 1) = replace(App.ModelFileFullPath, ("/"|"\"), " > ");
        try
          App.AppBlockSelectorUI.ModelFileDropDownUI.Value = App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end);
        catch exception

          rethrow(exception)

        end  % try, catch
        App.AppBlockSelectorUI.BlockPathDropDownUI.Value = replace(App.BlockPath, "/", " / ");
        callback_get_parameters(App)

      else
        % Default settings
        App.VehicleMassUI.SimscapeValue = App.DataSet.ModelParams.VehicleMass;
        App.TireRollingCoefficientUI.SimscapeValue = App.DataSet.ModelParams.TireRollingCoefficient;
        App.AirDragCoefficientUI.SimscapeValue = App.DataSet.ModelParams.AirDragCoefficient;
        App.FrontalAreaUI.SimscapeValue = App.DataSet.ModelParams.FrontalArea;

        App.GravitationalAccelerationUI.SimscapeValue = App.DataSet.ModelParams.GravitationalAcceleration;
        App.AirDensityUI.SimscapeValue = App.DataSet.ModelParams.AirDensity;

        App.RoadLoadBUI.SimscapeValue = App.DataSet.ModelParams.RoadLoadB;

        App.TopSpeedUI.SimscapeValue = App.DataSet.ModelParams.TopSpeed;
        App.MaxAccelerationUI.SimscapeValue = App.DataSet.ModelParams.MaxAcceleration;
        App.MaxClimbGradePercentUI.SimscapeValue = App.DataSet.ModelParams.MaxClimbGradePercent;
      end  % if

      App.PlotGradesUI.SimscapeValue = App.DataSet.PlotGrades;
      App.PlotPowersUI.SimscapeValue = App.DataSet.PlotPowers;
      App.PlotSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotSpeedUpperBound;
      App.PlotForceUpperBoundUI.SimscapeValue = App.DataSet.PlotForceUpperBound;

      % Enable plot auto-update.
      App.PlotButtonUI.ButtonDisable = "on";

      react_UIChanged(App)

      movegui(App.Window.MainFigure, "center")
      App.Window.MainFigure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      appmain_v_container = App.Window.MainVerticalContainer;
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);

      appmain_h_container = AppUtil1.HorizontalContainer(appmain_v_layout);

      % =======================================================================
      % Left side of the app window
      % =======================================================================
      appleft_h_layout = addHorizontalGridLayout(appmain_h_container);
      appleft_v_container = AppUtil1.VerticalContainer(appleft_h_layout);

      %% ======================================================================
      % Preset

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = AppUtil1.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = AppUtil1.Component.Label(h_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Preset") + "}";
      label_ui.ComponentWidth = App.name_ui_width;

      h_layout = addHorizontalGridLayout(h_container);
      App.PresetDropDownUI = AppUtil1.Component.DropDown(h_layout);
      App.PresetDropDownUI.Editable = "off";
      App.PresetDropDownUI.Items = [""; keys(App.presets.PresetDictionary)];
      App.PresetDropDownUI.MainDropDown.Value = "";
      App.PresetDropDownUI.ValueChangedCallback = @() react_PresetChanged(App);

      %% ======================================================================
      % Vehicle

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Vehicle") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.VehicleMassUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.VehicleMassUI.Editable = "on";
      App.VehicleMassUI.NameUIWidth = App.name_ui_width;
      App.VehicleMassUI.UnitUIWidth = App.unit_ui_width;
      App.VehicleMassUI.NameText = CodeUtil1.i18n("Vehicle mass, $M_v$");
      App.VehicleMassUI.UnitItems = App.mass_unit_items;
      App.VehicleMassUI.UnitText = "kg";
      App.VehicleMassUI.ValueChangedCallback = @() react_UIChanged(App);
      App.VehicleMassUI.UnitChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.TireRollingCoefficientUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.TireRollingCoefficientUI.NameUIWidth = App.name_ui_width;
      App.TireRollingCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.TireRollingCoefficientUI.NameText = CodeUtil1.i18n("Tire rolling coefficient, $C_{roll}$");
      App.TireRollingCoefficientUI.UnitAlias = "";
      App.TireRollingCoefficientUI.ValueChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.AirDragCoefficientUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.AirDragCoefficientUI.NameUIWidth = App.name_ui_width;
      App.AirDragCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.AirDragCoefficientUI.NameText = CodeUtil1.i18n("Air drag coefficient, $C_d$");
      App.AirDragCoefficientUI.UnitAlias = "";
      App.AirDragCoefficientUI.ValueChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.FrontalAreaUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.FrontalAreaUI.Editable = "on";
      App.FrontalAreaUI.NameUIWidth = App.name_ui_width;
      App.FrontalAreaUI.UnitUIWidth = App.unit_ui_width;
      App.FrontalAreaUI.NameText = CodeUtil1.i18n("Frontal area, $A_f$");
      App.FrontalAreaUI.UnitItems = ["m^2", "ft^2"];
      App.FrontalAreaUI.UnitText = "m^2";
      App.FrontalAreaUI.ValueChangedCallback = @() react_UIChanged(App);
      App.FrontalAreaUI.UnitChangedCallback = @() react_UIChanged(App);

      %% ======================================================================
      % Environment

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Environment") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.GravitationalAccelerationUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.GravitationalAccelerationUI.NameUIWidth = App.name_ui_width;
      App.GravitationalAccelerationUI.UnitUIWidth = App.unit_ui_width;
      App.GravitationalAccelerationUI.NameText = CodeUtil1.i18n("Gravitational acceleration, $g$");
      App.GravitationalAccelerationUI.UnitText = "m/s^2";
      App.GravitationalAccelerationUI.ValueChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.AirDensityUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.AirDensityUI.NameUIWidth = App.name_ui_width;
      App.AirDensityUI.UnitUIWidth = App.unit_ui_width;
      App.AirDensityUI.NameText = CodeUtil1.i18n("Dry air density, $\rho$");
      App.AirDensityUI.UnitText = "kg/m^3";
      App.AirDensityUI.ValueChangedCallback = @() react_UIChanged(App);

      %% ======================================================================
      % Road-load coefficient

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Road-load coefficient") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadBUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadBUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadBUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadBUI.NameText = CodeUtil1.i18n("$B_{rl}$");
      App.RoadLoadBUI.UnitText = "N/(m/s)";
      App.RoadLoadBUI.ValueChangedCallback = @() react_UIChanged(App);

      %% ======================================================================
      % Performance

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Performance") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.TopSpeedUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.TopSpeedUI.Editable = "on";
      App.TopSpeedUI.NameUIWidth = App.name_ui_width;
      App.TopSpeedUI.UnitUIWidth = App.unit_ui_width;
      App.TopSpeedUI.NameText = CodeUtil1.i18n("Top speed, $V_{max}$");
      App.TopSpeedUI.UnitItems = App.speed_unit_items;
      App.TopSpeedUI.UnitText = "km/hr";
      App.TopSpeedUI.ValueChangedCallback = @() react_UIChanged(App);
      App.TopSpeedUI.UnitChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxAccelerationUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxAccelerationUI.NameUIWidth = App.name_ui_width;
      App.MaxAccelerationUI.UnitUIWidth = App.unit_ui_width;
      App.MaxAccelerationUI.NameText = CodeUtil1.i18n("Max acceleration, $g_{max}$");
      App.MaxAccelerationUI.UnitAlias = "G";
      App.MaxAccelerationUI.ValueChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbGradePercentUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbGradePercentUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbGradePercentUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbGradePercentUI.NameText = CodeUtil1.i18n("Max climb grade, $B_{max}$");
      App.MaxClimbGradePercentUI.UnitAlias = "\%";
      App.MaxClimbGradePercentUI.ValueChangedCallback = @() react_UIChanged(App);

      %% ======================================================================
      % Derived parameters

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Derived parameters") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadAUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadAUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadAUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadAUI.NameText = CodeUtil1.i18n("$A_{rl} = C_{roll} M_v g$");
      App.RoadLoadAUI.UnitText = "N";
      App.RoadLoadAUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RoadLoadCUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.RoadLoadCUI.NameUIWidth = App.name_ui_width;
      App.RoadLoadCUI.UnitUIWidth = App.unit_ui_width;
      App.RoadLoadCUI.NameText = CodeUtil1.i18n("$C_{rl} = (1/2) C_d A_f \rho$");
      App.RoadLoadCUI.UnitText = "N/(m/s)^2";
      App.RoadLoadCUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxForceUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxForceUI.NameUIWidth = App.name_ui_width;
      App.MaxForceUI.UnitUIWidth = App.unit_ui_width;
      App.MaxForceUI.NameText = CodeUtil1.i18n("Max force, $F_{max} = g_{max} M_v g$");
      App.MaxForceUI.UnitText = "N";
      App.MaxForceUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxClimbPowerUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MaxClimbPowerUI.NameUIWidth = App.name_ui_width;
      App.MaxClimbPowerUI.UnitUIWidth = App.unit_ui_width;
      App.MaxClimbPowerUI.NameText = CodeUtil1.i18n("Max power, $P_c$, at $V_{max}, B_{max}$");
      App.MaxClimbPowerUI.UnitText = "kW";
      App.MaxClimbPowerUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      pm_addunit("ps", 735.5, "W");  % Metric horsepower (Pferdestärke)
      pm_addunit("bhp", 745.7, "W");  % Brake horsepower (imperial)

      App.MaxPowerFyiUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxPowerFyiUI.NameUIWidth = App.name_ui_width;
      App.MaxPowerFyiUI.UnitUIWidth = App.unit_ui_width;
      App.MaxPowerFyiUI.NameText = "";
      App.MaxPowerFyiUI.UnitItems = ["ps", "bhp"];
      App.MaxPowerFyiUI.UnitText = "ps";
      App.MaxPowerFyiUI.ReadOnlyValueText = true;
      App.MaxPowerFyiUI.UnitChangedCallback = @() update_MaxPowerFYI(App);

      % =======================================================================
      % Center divider of the app window - empty space
      addHorizontalGridLayout(appmain_h_container, Width=20);

      % =======================================================================
      % Right side of the app window
      % =======================================================================
      appright_h_layout = addHorizontalGridLayout(appmain_h_container, Width=App.right_pane_width);
      appright_v_container = AppUtil1.VerticalContainer(appright_h_layout);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = AppUtil1.HorizontalContainer(appright_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.PlotButtonUI = AppUtil1.Component.EnabledButton(h_layout);
      App.PlotButtonUI.HorizontalAlignment = "left";
      App.PlotButtonUI.ButtonUIWidth = App.button_width + App.width_unit;
      App.PlotButtonUI.ButtonWidth = App.button_width;
      App.PlotButtonUI.CheckBoxUIWidth = "fit";
      App.PlotButtonUI.CheckBoxWidth = "fit";
      App.PlotButtonUI.ButtonText = CodeUtil1.i18n("Update");
      App.PlotButtonUI.ButtonUI.MainButton.Icon = which("mus-icon-rotation-arrow.svg");
      App.PlotButtonUI.CheckBoxText = CodeUtil1.i18n("Auto-update");
      App.PlotButtonUI.ButtonPushedCallback = @() react_UIChanged(App, ForcePlotUpdate=true);
      % Set auto-update to false and keep it until the entire app is ready.
      App.PlotButtonUI.ButtonDisable = "on";

      h_layout = addHorizontalGridLayout(h_container);
      App.OpenInFigureWindowUI = AppUtil1.Component.Hyperlink(h_layout);
      App.OpenInFigureWindowUI.Text = CodeUtil1.i18n("Open in figure window");
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";

      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @open_in_figure_window;
      function open_in_figure_window
        Vehicle1D1.plotVehicle1DPerformance( ...
          ParentAxes = axes(figure), ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % nested function

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.AxesUI = AppUtil1.Graphics.Axes(appright_v_layout);
      App.AxesUI.ComponentHeight = App.plot_height;

      %% ======================================================================
      % Plot customization

      appright_v_layout = addVerticalGridLayout(appright_v_container);
      label_ui = AppUtil1.Component.Label(appright_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Plot customization") + "}";

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotSpeedUpperBoundUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotSpeedUpperBoundUI.Editable = "on";
      App.PlotSpeedUpperBoundUI.NameUIWidth = App.name_ui_width;
      App.PlotSpeedUpperBoundUI.UnitUIWidth = App.unit_ui_width;
      App.PlotSpeedUpperBoundUI.NameText = CodeUtil1.i18n("Speed upper bound");
      App.PlotSpeedUpperBoundUI.UnitItems = App.speed_unit_items;
      App.PlotSpeedUpperBoundUI.UnitText = "km/hr";
      App.PlotSpeedUpperBoundUI.ValueChangedCallback = @() react_UIChanged(App);
      App.PlotSpeedUpperBoundUI.UnitChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotForceUpperBoundUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotForceUpperBoundUI.Editable = "on";
      App.PlotForceUpperBoundUI.NameUIWidth = App.name_ui_width;
      App.PlotForceUpperBoundUI.UnitUIWidth = App.unit_ui_width;
      App.PlotForceUpperBoundUI.NameText = CodeUtil1.i18n("Force upper bound");
      App.PlotForceUpperBoundUI.UnitItems = App.force_unit_items;
      App.PlotForceUpperBoundUI.UnitText = "N";
      App.PlotForceUpperBoundUI.ValueChangedCallback = @() react_UIChanged(App);
      App.PlotForceUpperBoundUI.UnitChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotGradesUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotGradesUI.NameUIWidth = App.name_ui_width;
      App.PlotGradesUI.UnitUIWidth = App.unit_ui_width;
      App.PlotGradesUI.NameText = CodeUtil1.i18n("Road grades");
      App.PlotGradesUI.UnitAlias = "\%";
      App.PlotGradesUI.ValueChangedCallback = @() react_UIChanged(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotPowersUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotPowersUI.NameUIWidth = App.name_ui_width;
      App.PlotPowersUI.UnitUIWidth = App.unit_ui_width;
      App.PlotPowersUI.NameText = CodeUtil1.i18n("Constant power curves");
      App.PlotPowersUI.UnitText = "kW";
      App.PlotPowersUI.ValueChangedCallback = @() react_UIChanged(App);

      %% ======================================================================
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);
      AppUtil1.Component.HorizontalLine(appmain_v_layout);

      %% ======================================================================
      % Bottom area
      appmain_v_layout = addVerticalGridLayout(appmain_v_container);

      App.AppBlockSelectorUI = AppUtil1.Component.BlockSelectorUI(appmain_v_layout);
      App.AppBlockSelectorUI.TargetSimscapeBlockNames = App.TargetSimscapeBlockNames;
      App.AppBlockSelectorUI.GetParametersFromBlockCallback = @() callback_get_parameters(App);
      App.AppBlockSelectorUI.SetParametersToBlockCallback = @() callback_set_parameters(App);

    end  % function

    function update_MaxPowerFYI(App)
      x_kW = value(App.MaxClimbPowerUI.SimscapeValue, "kW");
      if App.MaxPowerFyiUI.UnitText == "ps"
        App.MaxPowerFyiUI.ValueText = 0.7355 * x_kW;
        App.MaxPowerFyiUI.UnitDropDownUI.DropDownUI.MainDropDown.Tooltip = CodeUtil1.i18n("Metric horsepower (Pferdestärke)");
      else  % bhp
        App.MaxPowerFyiUI.ValueText = 0.7457 * x_kW;
        App.MaxPowerFyiUI.UnitDropDownUI.DropDownUI.MainDropDown.Tooltip = CodeUtil1.i18n("Brake horsepower (imperial)");
      end  % if
    end  % function

    function callback_set_parameters(App)
      %%
      block_path = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      App.BlockPath = block_path;

      load_system(block_path)

      set_param(block_path, "M_vehicle", App.VehicleMassUI.ValueText);
      set_param(block_path, "M_vehicle_unit", App.VehicleMassUI.UnitText);

      set_param(block_path, "C_tireroll", App.TireRollingCoefficientUI.ValueText);

      set_param(block_path, "C_airdrag", App.AirDragCoefficientUI.ValueText);

      set_param(block_path, "A_front", App.FrontalAreaUI.ValueText);
      set_param(block_path, "A_front_unit", App.FrontalAreaUI.UnitText);

      set_param(block_path, "g", App.GravitationalAccelerationUI.ValueText);
      set_param(block_path, "g_unit", App.GravitationalAccelerationUI.UnitText);

    end  % function

    function callback_get_parameters(App)
      %%
      App.BlockPath = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");

      load_system(App.BlockPath)

      try
        App.DataSet = Vehicle1D1.Vehicle1DDataSet(BlockPath=App.BlockPath);
      catch exception
        if App.MainFigure.Visible
          msg = exception.message;
          title_word = CodeUtil1.i18n("Error");
          uialert(App.MainFigure, msg, title_word)

          return

        else

          rethrow(exception)

        end  % if
      end  % try, catch

      % -----------------------------------------------------------------------
      % Prevent the plot auto update while updating multiple UI components.
      prev_value = App.PlotButtonUI.CheckBoxUI.Value;
      App.PlotButtonUI.CheckBoxUI.Value = false;
      % -----------------------------------------------------------------------

      App.VehicleMassUI.ValueText = get_param(App.BlockPath, "M_vehicle");
      App.VehicleMassUI.UnitText = get_param(App.BlockPath, "M_vehicle_unit");

      App.TireRollingCoefficientUI.ValueText = get_param(App.BlockPath, "C_tireroll");

      App.AirDragCoefficientUI.ValueText = get_param(App.BlockPath, "C_airdrag");

      App.FrontalAreaUI.ValueText = get_param(App.BlockPath, "A_front");
      App.FrontalAreaUI.UnitText = get_param(App.BlockPath, "A_front_unit");

      App.GravitationalAccelerationUI.ValueText = get_param(App.BlockPath, "g");
      App.GravitationalAccelerationUI.UnitText = get_param(App.BlockPath, "g_unit");

      % !todo: Get the dry air density if it is a public parameter of the vehicle block.

      if not(App.MainFigure.Visible)
        % Set up parameters that are not block parameters. (Use the default values.)
        data_set = Vehicle1D1.Vehicle1DDataSet(Initialization=true);

        % !todo: Remove this once the vehicle block starts providing dry air as a public parameter.
        App.AirDensityUI.SimscapeValue = data_set.ModelParams.AirDensity;

        App.RoadLoadBUI.SimscapeValue = data_set.ModelParams.RoadLoadB;
        App.TopSpeedUI.SimscapeValue = data_set.ModelParams.TopSpeed;
        App.MaxAccelerationUI.SimscapeValue = data_set.ModelParams.MaxAcceleration;
        App.MaxClimbGradePercentUI.SimscapeValue = data_set.ModelParams.MaxClimbGradePercent;

        App.PlotGradesUI.SimscapeValue = data_set.PlotGrades;
        App.PlotPowersUI.SimscapeValue = data_set.PlotPowers;
        App.PlotSpeedUpperBoundUI.SimscapeValue = data_set.PlotSpeedUpperBound;
        App.PlotForceUpperBoundUI.SimscapeValue = data_set.PlotForceUpperBound;

      end  % if

      % -----------------------------------------------------------------------
      % Recover the plot auto update setting.
      App.PlotButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      react_UIChanged(App)

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
      prev_value = App.PlotButtonUI.CheckBoxUI.Value;
      App.PlotButtonUI.CheckBoxUI.Value = false;
      % -----------------------------------------------------------------------

      % Vehicle
      App.VehicleMassUI.SimscapeValue = preset_data.VehicleMass;
      App.TireRollingCoefficientUI.SimscapeValue = preset_data.TireRollingCoefficient;
      App.AirDragCoefficientUI.SimscapeValue = preset_data.AirDragCoefficient;
      App.FrontalAreaUI.SimscapeValue = preset_data.FrontalArea;

      % Environment
      App.GravitationalAccelerationUI.SimscapeValue = preset_data.GravitationalAcceleration;
      App.AirDensityUI.SimscapeValue = preset_data.AirDensity;

      % Road-load coefficient
      App.RoadLoadBUI.SimscapeValue = preset_data.RoadLoadB;

      % Performance
      App.TopSpeedUI.SimscapeValue = preset_data.TopSpeed;
      App.MaxAccelerationUI.SimscapeValue = preset_data.MaxAcceleration;
      App.MaxClimbGradePercentUI.SimscapeValue = preset_data.MaxClimbGradePercent;

      % -----------------------------------------------------------------------
      % Recover the plot auto update setting.
      App.PlotButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      react_UIChanged(App)

    end  % function

    function react_UIChanged(App, NameValuePair)
      %%
      arguments (Input)
        App (1,1)
        NameValuePair.ForcePlotUpdate (1,1) logical = false
      end  % if

      % Collect data from the UI components and update the DataSet.
      % Then update the derived parameter UI components.
      % Finally, update the plot if necessary.

      App.DataSet.ModelParams.VehicleMass = App.VehicleMassUI.SimscapeValue;
      App.DataSet.ModelParams.TireRollingCoefficient = App.TireRollingCoefficientUI.SimscapeValue;
      App.DataSet.ModelParams.AirDragCoefficient = App.AirDragCoefficientUI.SimscapeValue;
      App.DataSet.ModelParams.FrontalArea = App.FrontalAreaUI.SimscapeValue;
      App.DataSet.ModelParams.GravitationalAcceleration = App.GravitationalAccelerationUI.SimscapeValue;
      App.DataSet.ModelParams.AirDensity = App.AirDensityUI.SimscapeValue;
      App.DataSet.ModelParams.RoadLoadB = App.RoadLoadBUI.SimscapeValue;
      App.DataSet.ModelParams.TopSpeed = App.TopSpeedUI.SimscapeValue;
      App.DataSet.ModelParams.MaxAcceleration = App.MaxAccelerationUI.SimscapeValue;
      App.DataSet.ModelParams.MaxClimbGradePercent = App.MaxClimbGradePercentUI.SimscapeValue;
      App.DataSet.PlotGrades = App.PlotGradesUI.SimscapeValue;
      App.DataSet.PlotPowers = App.PlotPowersUI.SimscapeValue;
      App.DataSet.PlotSpeedUpperBound = App.PlotSpeedUpperBoundUI.SimscapeValue;
      App.DataSet.PlotForceUpperBound = App.PlotForceUpperBoundUI.SimscapeValue;
      updateDataSet(App.DataSet)

      App.RoadLoadAUI.ValueTextUI.MainEditField.Value = string(value(App.DataSet.ModelParams.RoadLoadA, "N"));
      App.RoadLoadCUI.ValueTextUI.MainEditField.Value = string(value(App.DataSet.ModelParams.RoadLoadC, "N/(m/s)^2"));
      App.MaxForceUI.ValueTextUI.MainEditField.Value = string(value(App.DataSet.ModelParams.MaxForce, "N"));
      App.MaxClimbPowerUI.ValueTextUI.MainEditField.Value = string(value(App.DataSet.ModelParams.MaxClimbPower, "kW"));
      update_MaxPowerFYI(App)

      if App.PlotButtonUI.CheckBoxUI.Value || NameValuePair.ForcePlotUpdate
        Vehicle1D1.plotVehicle1DPerformance( ...
          ParentAxes = App.AxesUI.MainAxes, ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % if
    end  % function

  end  % methods
end  % classdef
