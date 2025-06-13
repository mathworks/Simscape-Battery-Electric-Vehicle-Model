classdef Vehicle1DPerformanceDesignAppMain < handle

  % Copyright 2024-2025 The MathWorks, Inc.

  properties (Access=private)
    errorID (1,1) string = "Vehicle1DPerformanceDesignAppMain:"
  end  % properties

  properties

    Parameters (1,1) Vehicle1DPerformanceParameters = Vehicle1DPerformanceParameters

    UseGUI (1,1) logical = true
    LoadDataInGUI (1,1) logical = true

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp5.LiteAppWindow

    InfoLinkUI LiteApp5.Component.Hyperlink

    % Vehicle
    VehicleMassUI LiteApp5.Component.PhysicalValueUI
    TireRollingCoefficientUI LiteApp5.Component.PhysicalValueUI
    AirDragCoefficientUI LiteApp5.Component.PhysicalValueUI
    FrontalAreaUI LiteApp5.Component.PhysicalValueUI

    % Environment
    GravitationalAccelerationUI LiteApp5.Component.PhysicalValueUI
    AirDensityUI LiteApp5.Component.PhysicalValueUI

    % Road-load
    RoadLoadAUI LiteApp5.Component.PhysicalValueUI
    RoadLoadBUI LiteApp5.Component.PhysicalValueUI
    RoadLoadCUI LiteApp5.Component.PhysicalValueUI

    % Performance
    TopSpeedUI LiteApp5.Component.PhysicalValueUI
    MaximumAccelerationUI LiteApp5.Component.PhysicalValueUI
    MaximumForceUI LiteApp5.Component.PhysicalValueUI
    MaximumClimbGradeUI LiteApp5.Component.PhysicalValueUI
    MaximumClimbPowerUI LiteApp5.Component.PhysicalValueUI

    % Preset
    PresetUI LiteApp5.Component.ListBox

    % Plot
    UpdateButtonUI LiteApp5.Component.Button
    AutoUpdateUI LiteApp5.Component.CheckBox
    OpenFigureWindowUI LiteApp5.Component.Hyperlink
    ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

    % Plot customization
    PlotGradesUI LiteApp5.Component.PhysicalValueUI
    PlotAnglesUI LiteApp5.Component.PhysicalValueUI
    PlotPowersUI LiteApp5.Component.PhysicalValueUI
    PlotForceUpperBoundUI LiteApp5.Component.PhysicalValueUI
    PlotSpeedUpperBoundUI LiteApp5.Component.PhysicalValueUI

    SelectorUI LiteApp5.Component.BlockSelectorUI

  end  % properties

  properties (Access=private)

    BlockIsReady (1,1) logical = false

    presets (1,1) Vehicle1DPerformanceParameterPresets = Vehicle1DPerformanceParameterPresets

    PlotGradesUI_previous_Value string
    PlotGrades_previous_SimscapeValue simscape.Value

    PlotAnglesUI_previous_Value string
    PlotAngles_previous_SimscapeValue simscape.Value

    PlotPowersUI_previous_Value string
    PlotPowers_previous_SimscapeValue simscape.Value

  end  % properties

  properties (Access=private, Constant)

    % The text of this string must be a member of the Preset property of the Vehicle1DPerformanceParameters class.
    default_preset (1,1) string = "Medium car"

    button_ui_component_width = LiteApp5.Utility.Constant.Width{"unitwidth"} * 10
    button_ui_button_width = LiteApp5.Utility.Constant.Width{"unitwidth"} * 9

  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = Vehicle1DPerformanceDesignAppMain(NameValuePairs)
      %%
      arguments (Input)
        NameValuePairs.BlockPath (1,1) string = ""
        NameValuePairs.UseGUI (1,1) logical = true
        NameValuePairs.LoadDataInGUI (1,1) logical = true
      end  % arguments

      App.BlockPath = NameValuePairs.BlockPath;
      App.UseGUI = NameValuePairs.UseGUI;
      App.LoadDataInGUI = NameValuePairs.LoadDataInGUI;

      if App.BlockPath ~= ""
        App.ModelName = extractBefore(App.BlockPath, "/");
        if App.ModelName == ""
          id = App.errorID + "InvalidModelName";
          msg = LiteApp5.Utility.i18n("Empty model name is not allowed.");

          % When this error happens, UI components are not created yet.
          throw(MException(id, msg))

        end  % if
      end  % if

      App.Parameters = setup_all_data(App);

      if not(App.UseGUI)

        return

      end  % if

      build_app(App)

      if App.BlockPath ~= "" && App.BlockIsReady
        % Find .mdl or .slx file for the specified model.
        % It is safe to assume that App.ModelName is valid because it was checked earlier.
        try
          modelfile_fullpath = LiteApp5.Utility.getFileFullPath(App.ModelName + ".mdl");
        catch exception
          modelfile_fullpath = LiteApp5.Utility.getFileFullPath(App.ModelName + ".slx");
        end  % try, catch
        App.SelectorUI.ModelFileFullPath = modelfile_fullpath;
        % Block path in the drop down uses " / " as the subsystem separator.
        App.SelectorUI.BlockPathDropDownUI.Value = replace(App.BlockPath, "/", " / ");

        App.SelectorUI.GetParametersFromBlockCallback()
      end  % if

      Show(App.Window)
    end  % function

    function AppParams = setup_all_data(App)
      %%
      % Setup variables that are necessary for making a plot.
      % These variables are independent of UI components.

      AppParams = App.presets.PresetDictionary(App.default_preset);

      if App.BlockPath ~= ""
        % Use parameters in the specified block.

        if App.ModelName ~= "" && not(bdIsLoaded(App.ModelName))
          load_system(App.ModelName);
        end  % if
        App.BlockIsReady = true;
        try
          AppParams = getParametersFromBlock(AppParams, App.BlockPath);
        catch exception
          % Do not issue an error.
          % Fallback data are loaded in case of an error.
          App.BlockIsReady = false;
          msg = exception.message;
          if App.UseGUI && isprop(App, "Window") && not(isempty(isprop(App.Window, "MainFigure"))) && App.Window.MainFigure.Visible
            uialert(App.Window.MainFigure, msg, LiteApp5.Utility.i18n("Alert"))
          else
            % App is not visible.
            id = App.errorID + "ErrorInGetParametersFromBlock";
            warning(id, "%s", msg);
          end  % if
        end  % try, catch
      end  % if, block path was specified

      AppParams = update_states(AppParams);

    end  % function

    function getParametersFromVehicleBlock(App)
      %%
      % This function collects parameters from the block in the model specified by
      % the block selector.
      % If a block parameter is a workspace variable, it must have been loaded
      % in the base workspace. If it's not loaded, the physical value UI component
      % shows an inline error.

      App.ModelName = App.SelectorUI.ModelName;
      App.BlockPath = App.SelectorUI.BlockPath;

      % Before updating UI components, turn off the plot auto-update because
      % all UI components whose value changes call auto-update,
      % which is unecessary and noticeably slows down the update.
      previous_auto_update_value = App.AutoUpdateUI.Value;
      App.AutoUpdateUI.Value = false;

      % Full enum name is returned, e.g., "sdl.enum.VehicleParameterizationType.Regular".
      full_enum_name = get_param(App.BlockPath, "vehParamType");
      % Get the last part, which is the enum element name, e.g. "Regular".
      enum_element_name = extractAfter(full_enum_name,  asManyOfPattern(wildcardPattern + "."));

      if enum_element_name ~= "Regular"
        id = App.errorID + ":InvalidBlockParameter";
        msg = LiteApp5.Utility.i18n("Only ""Regular"" Parameterization type for Longitudinal Vehicle block is supported.");

        throw(MException(id, msg))

      end  % if

      App.VehicleMassUI.ValueEditFieldUI.Value = get_param(App.BlockPath, "M_vehicle");
      App.VehicleMassUI.UnitDropDownUI.MainDropDown.Value = get_param(App.BlockPath, "M_vehicle_unit");

      % R_tireroll (tire rolling radius) is skipped because it is not used in the app.

      App.TireRollingCoefficientUI.Value = get_param(App.BlockPath, "C_tireroll");

      App.AirDragCoefficientUI.Value = get_param(App.BlockPath, "C_airdrag");

      App.FrontalAreaUI.Value = get_param(App.BlockPath, "A_front");
      App.FrontalAreaUI.Unit = get_param(App.BlockPath, "A_front_unit");

      App.GravitationalAccelerationUI.Value = get_param(App.BlockPath, "g");
      App.GravitationalAccelerationUI.Unit = get_param(App.BlockPath, "g_unit");

      % !todo: Air density should be public in Longitudinal Vehicle block.
      % App.AirDensityUI.Value = get_param(App.BlockPath, "air_density");
      % App.AirDensityUI.Unit = get_param(App.BlockPath, "air_density_unit");

      % Deselect the preset because parameters are read from the specified block.
      App.PresetUI.MainListBox.Value = {};

      % -----------------------------------------------------------------------

      % Synchronize the Parameters property based on the updated UI components
      % and update other UI components for the derived parameters.
      getParametersFromUIComponents(App)
      App.Parameters = update_states(App.Parameters);
      App.RoadLoadAUI.SimscapeValue = App.Parameters.RoadLoadA;
      App.RoadLoadCUI.SimscapeValue = App.Parameters.RoadLoadC;
      App.MaximumForceUI.SimscapeValue = App.Parameters.MaximumForce;
      App.MaximumClimbPowerUI.SimscapeValue = App.Parameters.MaximumClimbPower;

      % Recover the previous auto-update state for the plot button.
      App.AutoUpdateUI.Value = previous_auto_update_value;

      auto_update_plot(App)
    end  % function

    function setParametersToVehicleBlock(App)
      %%
      disp("BlockPath: " + App.SelectorUI.BlockPath)

      getParametersFromUIComponents(App)
      App.Parameters = update_states(App.Parameters);

      setParametersToBlock(App.Parameters, App.SelectorUI.BlockPath)

    end  % function

    function performancePlot(App, NameValuePair)
      %%
      arguments (Input)
        App 
        NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}
      end  % arguments

      if isfield(NameValuePair, "ParentAxes")
        parent_axes = NameValuePair.ParentAxes;
      else
        parent_axes = axes(figure(WindowStyle="normal"));
      end  % if

      if App.UseGUI
        % If a UI component contains workspace variables,
        % variables must be evaluated to get the latest values in the workspace.
        % getParametersFromUIComponents judges if evaluation is necessary.
        getParametersFromUIComponents(App)

        % !todo: show an error dialog if an error (or errors) occured in getParametersFromUIComponents.

      end  % if

      App.Parameters = update_states(App.Parameters);

      Vehicle1DPerformancePlot( ...
        Parent = parent_axes, ...
        VehicleMass = App.Parameters.VehicleMass, ...
        GravitationalAcceleration = App.Parameters.GravitationalAcceleration, ...
        RoadLoadA = App.Parameters.RoadLoadA, ...
        RoadLoadB = App.Parameters.RoadLoadB, ...
        RoadLoadC = App.Parameters.RoadLoadC, ...
        TopSpeed = App.Parameters.TopSpeed, ...
        MaximumAcceleration = App.Parameters.MaximumAcceleration, ...
        MaximumClimbPower = App.Parameters.MaximumClimbPower, ...
        PlotGrades = App.Parameters.PlotGrades, ...
        PlotPowers = App.Parameters.PlotPowers, ...
        PlotForceUpperBound = App.Parameters.PlotForceUpperBound, ...
        PlotForceUnit = App.Parameters.PlotForceUnit, ...
        PlotSpeedUpperBound = App.Parameters.PlotSpeedUpperBound, ...
        PlotSpeedUnit = App.Parameters.PlotSpeedUnit )
    end  % function

    function getParametersFromUIComponents(App)
      %%

      % Vehicle ---------------------------------------------------------------

      App.Parameters.VehicleMass = App.VehicleMassUI.SimscapeValue;
      App.Parameters.TireRollingCoefficient = App.TireRollingCoefficientUI.SimscapeValue;
      App.Parameters.AirDragCoefficient = App.AirDragCoefficientUI.SimscapeValue;
      App.Parameters.FrontalArea = App.FrontalAreaUI.SimscapeValue;

      % Environment -----------------------------------------------------------

      App.Parameters.GravitationalAcceleration = App.GravitationalAccelerationUI.SimscapeValue;
      App.Parameters.AirDensity = App.AirDensityUI.SimscapeValue;

      % Road-load -------------------------------------------------------------

      App.Parameters.RoadLoadA = App.RoadLoadAUI.SimscapeValue;
      App.Parameters.RoadLoadB = App.RoadLoadBUI.SimscapeValue;
      App.Parameters.RoadLoadC = App.RoadLoadCUI.SimscapeValue;

      % Performance -----------------------------------------------------------

      App.Parameters.TopSpeed = App.TopSpeedUI.SimscapeValue;
      App.Parameters.MaximumAcceleration = App.MaximumAccelerationUI.SimscapeValue;
      App.Parameters.MaximumForce = App.MaximumForceUI.SimscapeValue;
      App.Parameters.MaximumClimbGrade = App.MaximumClimbGradeUI.SimscapeValue;
      App.Parameters.MaximumClimbPower = App.MaximumClimbPowerUI.SimscapeValue;

      % Preset ----------------------------------------------------------------

      current_preset = App.PresetUI.MainListBox.Value;
      if isempty(current_preset)
        current_preset = App.default_preset;
      end
      App.Parameters.Preset = current_preset;

      % Plot customization ----------------------------------------------------

      % PlotGradesUI ..........................................................

      % App.PlotGradesUI.Value is a string and it may need to be evaluated
      % because what the string represents can be an array or workspace variables.

      if App.PlotGradesUI_previous_Value == App.PlotGradesUI.Value
        % No change in the Value. Reuse the previous result to avoid evaluation.
        App.Parameters.PlotGrades = App.PlotGrades_previous_SimscapeValue;

      else
        [Result, error_message] = LiteApp5.SimscapeUtility.AnalyzeValueString(App.PlotGradesUI.Value);
        if error_message ~= ""
          App.PlotGradesUI.HasError = true;
          App.PlotGradesUI.ErrorMessage = App.PlotGradesUI.NameInInfo + ": " + error_message;
          alertOnError(App.PlotGradesUI)

          % Do not return from here.
          % This method must continue to process all the UI components.
          % !todo: Errors occured in this method must be handled in one location
          % after this function finished.

        else
          App.PlotGradesUI.HasError = false;
          App.PlotGradesUI.ErrorMessage = "";

        end  % if
        % The unit of road grade is percent, which is "1" in Simscape.
        App.Parameters.PlotGrades = simscape.Value(Result.NumericValue, "1");

        % Keep the results for the next time.
        App.PlotGradesUI_previous_Value = App.PlotGradesUI.Value;
        App.PlotGrades_previous_SimscapeValue = App.Parameters.PlotGrades;
      end  % if

      % PlotAnglesUI ..........................................................

      if App.PlotAnglesUI_previous_Value == App.PlotAnglesUI.Value
        % No change in the Value. Reuse the previous result. Avoid evaluation.
        App.Parameters.PlotAngles = App.PlotAngles_previous_SimscapeValue;

      else
        [Result, error_message] = LiteApp5.SimscapeUtility.AnalyzeValueString(App.PlotAnglesUI.Value);
        if error_message ~= ""
          App.PlotAnglesUI.HasError = true;
          App.PlotAnglesUI.ErrorMessage = App.PlotAnglesUI.NameInInfo + ": " + error_message;
          alertOnError(App.PlotAnglesUI)
        else
          App.PlotAnglesUI.HasError = false;
          App.PlotAnglesUI.ErrorMessage = "";
        end  % if
        App.Parameters.PlotAngles = simscape.Value(Result.NumericValue, App.PlotAnglesUI.Unit);

        % Keep the results for the next time.
        App.PlotAnglesUI_previous_Value = App.PlotAnglesUI.Value;
        App.PlotAngles_previous_SimscapeValue = App.Parameters.PlotAngles;
      end  % if

      % PlotPowersUI ..........................................................

      if App.PlotPowersUI_previous_Value == App.PlotPowersUI.Value
        % No change in the Value. Reuse the previous result. Avoid evaluation.
        App.Parameters.PlotPowers = App.PlotPowers_previous_SimscapeValue;

      else
        [Result, error_message] = LiteApp5.SimscapeUtility.AnalyzeValueString(App.PlotPowersUI.Value);
        if error_message ~= ""
          App.PlotPowersUI.HasError = true;
          App.PlotPowersUI.ErrorMessage = App.PlotPowersUI.NameInInfo + ": " + error_message;
          alertOnError(App.PlotPowersUI)
        else
          App.PlotPowersUI.HasError = false;
          App.PlotPowersUI.ErrorMessage = "";
        end  % if
        App.Parameters.PlotPowers = simscape.Value(Result.NumericValue, App.PlotPowersUI.Unit);

        % Keep the results for the next time.
        App.PlotPowersUI_previous_Value = App.PlotPowersUI.Value;
        App.PlotPowers_previous_SimscapeValue = App.Parameters.PlotPowers;
      end  % if

      % Force upper bounds ....................................................

      App.Parameters.PlotForceUpperBound = App.PlotForceUpperBoundUI.SimscapeValue;
      App.Parameters.PlotForceUnit = App.PlotForceUpperBoundUI.Unit;

      % Speed upper bounds ....................................................

      App.Parameters.PlotSpeedUpperBound = App.PlotSpeedUpperBoundUI.SimscapeValue;
      App.Parameters.PlotSpeedUnit = App.PlotSpeedUpperBoundUI.Unit;

    end  % function
 
    %% ========================================================================
    % GUI

    function build_app(App)
      %%
      win = LiteApp5.LiteAppWindow;
      App.Window = win;

      win.Name = "Vehicle1D Performance Design App";
      win.Width = 1100;
      win.Height = 690;

      %% Start building an app

      width_unit = LiteApp5.Utility.Constant.Width{"unitwidth"};
      height_unit = LiteApp5.Utility.Constant.Height{"oneline+"};

      layout = win.MainLayout;

      area = NewArea(layout);

      %% Build left column
      column = NewColumn(layout, area);

      left_label_width_1 = width_unit*20;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.InfoLinkUI = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
      App.InfoLinkUI.HyperlinkText = "Description";
      App.InfoLinkUI.HyperlinkClickedCallback = @() web("Vehicle1D_Description.html");
      App.InfoLinkUI.ComponentHeight = height_unit;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Vehicle}";

      row = NewRow(layout, column);
      App.VehicleMassUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.VehicleMassUI.NameUIWidth = left_label_width_1;
      % App.VehicleMassUI.UnitUIWidth = unit_ui_width_1;
      App.VehicleMassUI.NameInInfo = "Vehicle mass";
      App.VehicleMassUI.Name = App.VehicleMassUI.NameInInfo + ", $M_v$";
      App.VehicleMassUI.UnitItems = ["kg" "lbm"];
      App.VehicleMassUI.ValueChangedCallback = @() callback_physical_value(App, Name="VehicleMass", UnitUIType="dropdown", Condition="positive");
      App.VehicleMassUI.UnitChangedCallback = @() callback_physical_value(App, Name="VehicleMass", UnitUIType="dropdown", Condition="positive");

      row = NewRow(layout, column);
      App.TireRollingCoefficientUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TireRollingCoefficientUI.NameUIWidth = left_label_width_1;
      % App.TireRollingCoefficientUI.UnitUIWidth = unit_ui_width_1;
      App.TireRollingCoefficientUI.NameInInfo = "Tire rolling coefficient";
      App.TireRollingCoefficientUI.Name =App.TireRollingCoefficientUI.NameInInfo + ", $C_{roll}$";
      App.TireRollingCoefficientUI.UnitAlias = "";
      App.TireRollingCoefficientUI.ValueChangedCallback = @() callback_physical_value(App, Name="TireRollingCoefficient", UnitUIType="1", Condition="positive");

      row = NewRow(layout, column);
      App.AirDragCoefficientUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.AirDragCoefficientUI.NameUIWidth = left_label_width_1;
      % App.AirDragCoefficientUI.UnitUIWidth = unit_ui_width_1;
      App.AirDragCoefficientUI.NameInInfo = "Air drag coefficient";
      App.AirDragCoefficientUI.Name = App.AirDragCoefficientUI.NameInInfo + ", $C_d$";
      App.AirDragCoefficientUI.UnitAlias = "";
      App.AirDragCoefficientUI.ValueChangedCallback = @() callback_physical_value(App, Name="AirDragCoefficient", UnitUIType="1", Condition="positive");

      row = NewRow(layout, column);
      App.FrontalAreaUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.FrontalAreaUI.NameUIWidth = left_label_width_1;
      % App.FrontalAreaUI.UnitUIWidth = unit_ui_width_1;
      App.FrontalAreaUI.NameInInfo = "Frontal area";
      App.FrontalAreaUI.Name = App.FrontalAreaUI.NameInInfo + ", $A_f$";
      App.FrontalAreaUI.Unit = "m^2";
      App.FrontalAreaUI.ValueChangedCallback = @() callback_physical_value(App, Name="FrontalArea", UnitUIType="label", Condition="positive");

      % -----------------------------------------------------------------------------
      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Environment}";

      row = NewRow(layout, column);
      App.GravitationalAccelerationUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.GravitationalAccelerationUI.NameUIWidth = left_label_width_1;
      % App.GravitationalAccelerationUI.UnitUIWidth = unit_ui_width_1;
      App.GravitationalAccelerationUI.NameInInfo = "Gravitational acceleration";
      App.GravitationalAccelerationUI.Name = App.GravitationalAccelerationUI.NameInInfo + ", $g$";
      App.GravitationalAccelerationUI.Unit = "m/s^2";
      App.GravitationalAccelerationUI.ValueChangedCallback = @() callback_physical_value(App, Name="GravitationalAcceleration", UnitUIType="label", Condition="positive");

      row = NewRow(layout, column);
      App.AirDensityUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.AirDensityUI.NameUIWidth = left_label_width_1;
      % App.AirDensityUI.UnitUIWidth = unit_ui_width_1;
      App.AirDensityUI.NameInInfo = "Air density";
      App.AirDensityUI.Name = App.AirDensityUI.NameInInfo + ", $\rho$";
      App.AirDensityUI.Unit = "kg/m^3";
      App.AirDensityUI.ValueChangedCallback = @() callback_physical_value(App, Name="AirDensity", UnitUIType="label", Condition="positive");

      % -----------------------------------------------------------------------------
      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Road-load}";

      row = NewRow(layout, column);
      App.RoadLoadAUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RoadLoadAUI.NameUIWidth = left_label_width_1;
      % App.RoadLoadAUI.UnitUIWidth = unit_ui_width_1;
      App.RoadLoadAUI.NameInInfo = "Road-load coefficient A";
      App.RoadLoadAUI.Name = "$A_{rl} = C_{roll} M_v g$";
      App.RoadLoadAUI.Unit = "N";
      App.RoadLoadAUI.ValueReadOnly = true;

      row = NewRow(layout, column);
      App.RoadLoadBUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RoadLoadBUI.NameUIWidth = left_label_width_1;
      % App.RoadLoadBUI.UnitUIWidth = unit_ui_width_1;
      App.RoadLoadBUI.NameInInfo = "Road-load coefficient B";
      App.RoadLoadBUI.Name = "$B_{rl}$";
      App.RoadLoadBUI.Unit = "N*s/m";
      App.RoadLoadBUI.ValueChangedCallback = @() callback_physical_value(App, Name="RoadLoadB", UnitUIType="label", Condition="non-negative");

      row = NewRow(layout, column);
      App.RoadLoadCUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RoadLoadCUI.NameUIWidth = left_label_width_1;
      % App.RoadLoadCUI.UnitUIWidth = unit_ui_width_1;
      App.RoadLoadCUI.NameInInfo = "Road-load coefficient C";
      App.RoadLoadCUI.Name = "$C_{rl} = (1/2) C_d A_f \rho$";
      App.RoadLoadCUI.Unit = "N*s^2/m^2";
      App.RoadLoadCUI.ValueReadOnly = true;

      % -----------------------------------------------------------------------------
      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Performance}";

      row = NewRow(layout, column);
      App.TopSpeedUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TopSpeedUI.NameUIWidth = left_label_width_1;
      % App.TopSpeedUI.UnitUIWidth = unit_ui_width_1;
      App.TopSpeedUI.NameInInfo = "Top speed";
      App.TopSpeedUI.Name = App.TopSpeedUI.NameInInfo + ", $V_{max}$";
      App.TopSpeedUI.UnitItems = ["km/hr", "mph", "m/s"];
      App.TopSpeedUI.ValueChangedCallback = @() callback_physical_value(App, Name="TopSpeed", UnitUIType="dropdown", Condition="positive");
      App.TopSpeedUI.UnitChangedCallback = @() callback_physical_value(App, Name="TopSpeed", UnitUIType="dropdown", Condition="positive");

      row = NewRow(layout, column);
      App.MaximumAccelerationUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.MaximumAccelerationUI.NameUIWidth = left_label_width_1;
      % App.MaximumAccelerationUI.UnitUIWidth = unit_ui_width_1;
      App.MaximumAccelerationUI.NameInInfo = "Max acceleration";
      App.MaximumAccelerationUI.Name = App.MaximumAccelerationUI.NameInInfo + ", $g_{max}$";
      App.MaximumAccelerationUI.UnitAlias = "G";
      App.MaximumAccelerationUI.ValueChangedCallback = @() callback_physical_value(App, Name="MaximumAcceleration", UnitUIType="1", Condition="positive");

      row = NewRow(layout, column);
      App.MaximumForceUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.MaximumForceUI.NameUIWidth = left_label_width_1;
      % App.MaximumForceUI.UnitUIWidth = unit_ui_width_1;
      App.MaximumForceUI.NameInInfo = "Max force";
      App.MaximumForceUI.Name = App.MaximumForceUI.NameInInfo + ", $F_{max} = g_{max} M_v g$";
      App.MaximumForceUI.Unit = "N";
      App.MaximumForceUI.ValueReadOnly = true;

      row = NewRow(layout, column);
      App.MaximumClimbGradeUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.MaximumClimbGradeUI.NameUIWidth = left_label_width_1;
      % App.MaximumClimbGradeUI.UnitUIWidth = unit_ui_width_1;
      App.MaximumClimbGradeUI.NameInInfo = "Max climb grade";
      App.MaximumClimbGradeUI.Name = App.MaximumClimbGradeUI.NameInInfo + ", $B_{max}$";
      App.MaximumClimbGradeUI.UnitAlias = "\%";
      App.MaximumClimbGradeUI.ValueChangedCallback = @() callback_physical_value(App, Name="MaximumClimbGrade", UnitUIType="1", Condition="positive");

      row = NewRow(layout, column);
      App.MaximumClimbPowerUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.MaximumClimbPowerUI.NameUIWidth = left_label_width_1;
      % App.MaximumClimbPowerUI.UnitUIWidth = unit_ui_width_1;
      App.MaximumClimbPowerUI.NameInInfo = "Max climb power";
      App.MaximumClimbPowerUI.Name = App.MaximumClimbPowerUI.NameInInfo + ", $P_{c}$";
      App.MaximumClimbPowerUI.Unit = "kW";
      App.MaximumClimbPowerUI.ValueReadOnly = true;

      % -----------------------------------------------------------------------
      LiteApp5.Component.HorizontalLine(NewRow(layout, column));

      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Preset}";

      row = NewRow(layout, column);
      App.PresetUI = LiteApp5.Component.ListBox(NewSlot(layout, row));
      App.PresetUI.ComponentHeight = height_unit * 4;
      App.PresetUI.MainListBox.Multiselect = "off";
      App.PresetUI.ValueChangedCallback = @() callback_Preset(App);

      %% Build right column
      column = NewColumn(layout, area, Width=560);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.UpdateButtonUI = LiteApp5.Component.Button(NewSlot(layout, row, Width="fit"));
      App.UpdateButtonUI.ComponentWidth = App.button_ui_component_width;
      App.UpdateButtonUI.ButtonWidth = App.button_ui_button_width;
      App.UpdateButtonUI.Text = "Update";
      App.UpdateButtonUI.HorizontalAlignment = "left";
      App.UpdateButtonUI.ButtonPushedCallback = @() callback_UpdateButton(App);
      % Disable update button at first.
      App.UpdateButtonUI.MainButton.Enable = "off";

      App.AutoUpdateUI = LiteApp5.Component.CheckBox(NewSlot(layout, row));
      App.AutoUpdateUI.Text = "Auto-update";
      App.AutoUpdateUI.ValueChangedCallback = @() callback_AutoUpdate(App);
      % Deselect Auto-update check box to avoid calling plot update during startup.
      % Select the check box after the app has been made visible.
      App.AutoUpdateUI.Value = false;

      App.OpenFigureWindowUI = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
      App.OpenFigureWindowUI.HyperlinkText = "Open in figure window";
      App.OpenFigureWindowUI.HorizontalAlignment = "right";
      App.OpenFigureWindowUI.HyperlinkClickedCallback = @() performancePlot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      panel_ui = LiteApp5.Graphics.Panel(NewSlot(layout, row));
      panel_ui.ComponentHeight = 400;
      panel_ui.BorderType = "none";

      % Use MainPanel as the parent of axes. MainPanel is a uipanel object.
      App.ParentAxes = axes(panel_ui.MainPanel);

      % -----------------------------------------------------------------------

      left_label_width_2 = width_unit*14;
      unit_ui_width_2 = width_unit*10;

      row = NewRow(layout, column);
      label_1 = LiteApp5.Component.Label(NewSlot(layout, row));
      label_1.Text = "\textbf{Plot customization}";
      label_1.ComponentWidth = left_label_width_2;

      row = NewRow(layout, column);
      App.PlotGradesUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.PlotGradesUI.NameUIWidth = left_label_width_2;
      App.PlotGradesUI.UnitUIWidth = unit_ui_width_2;
      App.PlotGradesUI.Name = "Road grade";
      App.PlotGradesUI.UnitAlias = "\%";
      App.PlotGradesUI.ValueChangedCallback = @() callback_physical_value(App, Name="PlotGrades", UnitUIType="1", Condition="non-negative");

      row = NewRow(layout, column);
      App.PlotAnglesUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.PlotAnglesUI.NameUIWidth = left_label_width_2;
      App.PlotAnglesUI.UnitUIWidth = unit_ui_width_2;
      App.PlotAnglesUI.Name = "Road angle";
      App.PlotAnglesUI.Unit = "deg";
      App.PlotAnglesUI.ValueReadOnly = true;

      row = NewRow(layout, column);
      App.PlotPowersUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.PlotPowersUI.NameUIWidth = left_label_width_2;
      App.PlotPowersUI.UnitUIWidth = unit_ui_width_2;
      App.PlotPowersUI.Name = "Power";
      App.PlotPowersUI.Unit = "kW";
      App.PlotPowersUI.ValueChangedCallback = @() callback_physical_value(App, Name="PlotPowers", UnitUIType="label", Condition="non-negative");

      row = NewRow(layout, column);
      App.PlotForceUpperBoundUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.PlotForceUpperBoundUI.NameUIWidth = left_label_width_2;
      App.PlotForceUpperBoundUI.UnitUIWidth = unit_ui_width_2;
      App.PlotForceUpperBoundUI.Name = "Force upper bound";
      App.PlotForceUpperBoundUI.UnitItems = ["N", "lbf"];
      App.PlotForceUpperBoundUI.ValueChangedCallback = @() callback_physical_value(App, Name="PlotForceUpperBound", UnitUIType="dropdown", Condition="positive");
      App.PlotForceUpperBoundUI.UnitChangedCallback = @() callback_physical_value(App, Name="PlotForceUpperBound", UnitUIType="dropdown", Condition="positive");

      row = NewRow(layout, column);
      App.PlotSpeedUpperBoundUI = LiteApp5.Component.PhysicalValueUI(NewSlot(layout, row));
      App.PlotSpeedUpperBoundUI.NameUIWidth = left_label_width_2;
      App.PlotSpeedUpperBoundUI.UnitUIWidth = unit_ui_width_2;
      App.PlotSpeedUpperBoundUI.Name = "Speed upper bound";
      App.PlotSpeedUpperBoundUI.UnitItems = ["km/hr", "mph", "m/s"];
      App.PlotSpeedUpperBoundUI.ValueChangedCallback = @() callback_physical_value(App, Name="PlotSpeedUpperBound", UnitUIType="dropdown", Condition="positive");
      App.PlotSpeedUpperBoundUI.UnitChangedCallback = @() callback_physical_value(App, Name="PlotSpeedUpperBound", UnitUIType="dropdown", Condition="positive");

      %% Bottom area
      area = NewArea(layout);
      column = NewColumn(layout, area);

      NewRow(layout, column, Height=4);  % vertical small gap
      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      LiteApp5.Component.HorizontalLine(NewSlot(layout, row));
      % -----------------------------------------------------------------------
      NewRow(layout, column, Height=4);  % vertical small gap

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.SelectorUI = LiteApp5.Component.BlockSelectorUI(NewSlot(layout, row));
      App.SelectorUI.MainFigure = App.Window.MainFigure;
      App.SelectorUI.TargetBlockNames = "Longitudinal Vehicle";
      App.SelectorUI.GetParametersFromBlockCallback = @() getParametersFromVehicleBlock(App);
      App.SelectorUI.SetParametersToBlockCallback = @() setParametersToVehicleBlock(App);

      if App.LoadDataInGUI
        setParametersToUIComponents(App)

        Vehicle1DPerformancePlot( ...
          Parent = App.ParentAxes, ...
          VehicleMass = App.Parameters.VehicleMass, ...
          GravitationalAcceleration = App.Parameters.GravitationalAcceleration, ...
          RoadLoadA = App.Parameters.RoadLoadA, ...
          RoadLoadB = App.Parameters.RoadLoadB, ...
          RoadLoadC = App.Parameters.RoadLoadC, ...
          TopSpeed = App.Parameters.TopSpeed, ...
          MaximumAcceleration = App.Parameters.MaximumAcceleration, ...
          MaximumClimbPower = App.Parameters.MaximumClimbPower, ...
          PlotGrades = App.Parameters.PlotGrades, ...
          PlotPowers = App.Parameters.PlotPowers, ...
          PlotForceUpperBound = App.Parameters.PlotForceUpperBound, ...
          PlotForceUnit = App.Parameters.PlotForceUnit, ...
          PlotSpeedUpperBound = App.Parameters.PlotSpeedUpperBound, ...
          PlotSpeedUnit = App.Parameters.PlotSpeedUnit )

        App.AutoUpdateUI.Value = true;

      end  % if
    end  % function

    function callback_Preset(App)
      %%
      car_name = App.PresetUI.MainListBox.Value;
      car_data = App.presets.PresetDictionary(car_name);

      App.Parameters.VehicleMass = car_data.VehicleMass;
      App.Parameters.TireRollingCoefficient = car_data.TireRollingCoefficient;
      App.Parameters.AirDragCoefficient = car_data.AirDragCoefficient;
      App.Parameters.FrontalArea = car_data.FrontalArea;

      App.Parameters.GravitationalAcceleration = car_data.GravitationalAcceleration;
      App.Parameters.AirDensity = car_data.AirDensity;

      App.Parameters.RoadLoadB = car_data.RoadLoadB;

      App.Parameters.TopSpeed = car_data.TopSpeed;
      App.Parameters.MaximumAcceleration = car_data.MaximumAcceleration;
      App.Parameters.MaximumClimbGrade = car_data.MaximumClimbGrade;

      App.Parameters = update_states(App.Parameters);

      setParametersToUIComponents(App, PresetCarName=car_name)

      % if App.AutoUpdateUI.Value
        auto_update_plot(App)
      % end  % if
    end  % funcition

    function auto_update_plot(App)
      if App.AutoUpdateUI.Value
        performancePlot(App, ParentAxes=App.ParentAxes)
      end  % if
    end  % function

    function callback_UpdateButton(App)
      performancePlot(App, ParentAxes=App.ParentAxes)
    end  % function

    function callback_AutoUpdate(App)
      if App.AutoUpdateUI.Value
        App.UpdateButtonUI.MainButton.Enable = "off";
      else
        App.UpdateButtonUI.MainButton.Enable = "on";
      end  % if
    end  % function
 
    function setParametersToUIComponents(App, NameValuePairs)
      %%
      arguments (Input)
        App (1,1)
        NameValuePairs.PresetCarName (1,1) string = App.default_preset
      end

      % Before updating UI components, turn off the plot auto-update because
      % all UI components whose value changes call auto-update,
      % which is unecessary and noticeably slows down the update.
      previous_auto_update_value = App.AutoUpdateUI.Value;
      App.AutoUpdateUI.Value = false;

      % Vehicle ---------------------------------------------------------------

      unit_str = string(unit(App.Parameters.VehicleMass));
      App.VehicleMassUI.ValueEditFieldUI.Value = value(App.Parameters.VehicleMass, unit_str);
      App.VehicleMassUI.UnitDropDownUI.MainDropDown.Value = unit_str;

      App.TireRollingCoefficientUI.Value = value(App.Parameters.TireRollingCoefficient, "1");

      App.AirDragCoefficientUI.Value = value(App.Parameters.AirDragCoefficient, "1");

      unit_str = string(unit(App.Parameters.FrontalArea));
      App.FrontalAreaUI.Value = value(App.Parameters.FrontalArea, unit_str);
      App.FrontalAreaUI.Unit = unit_str;

      % Environment -----------------------------------------------------------

      unit_str = string(unit(App.Parameters.GravitationalAcceleration));
      App.GravitationalAccelerationUI.Value = value(App.Parameters.GravitationalAcceleration, unit_str);
      App.GravitationalAccelerationUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.AirDensity));
      App.AirDensityUI.Value = value(App.Parameters.AirDensity, unit_str);
      App.AirDensityUI.Unit = unit_str;

      % Road-load -------------------------------------------------------------

      unit_str = string(unit(App.Parameters.RoadLoadA));
      App.RoadLoadAUI.Value = value(App.Parameters.RoadLoadA, unit_str);
      App.RoadLoadAUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.RoadLoadB));
      App.RoadLoadBUI.Value = value(App.Parameters.RoadLoadB, unit_str);
      App.RoadLoadBUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.RoadLoadC));
      App.RoadLoadCUI.Value = value(App.Parameters.RoadLoadC, unit_str);
      App.RoadLoadCUI.Unit = unit_str;

      % Performance -----------------------------------------------------------

      unit_str = string(unit(App.Parameters.TopSpeed));
      App.TopSpeedUI.Value = value(App.Parameters.TopSpeed, unit_str);
      App.TopSpeedUI.Unit = unit_str;

      App.MaximumAccelerationUI.Value = value(App.Parameters.MaximumAcceleration, "1");

      unit_str = string(unit(App.Parameters.MaximumForce));
      App.MaximumForceUI.Value = value(App.Parameters.MaximumForce, unit_str);
      App.MaximumForceUI.Unit = unit_str;

      App.MaximumClimbGradeUI.Value = value(App.Parameters.MaximumClimbGrade, "1");

      unit_str = string(unit(App.Parameters.MaximumClimbPower));
      App.MaximumClimbPowerUI.Value = value(App.Parameters.MaximumClimbPower, unit_str);
      App.MaximumClimbPowerUI.Unit = unit_str;

      % Plot customization ----------------------------------------------------

      % The unit of grade is %, which is 1 in Simscape.
      App.PlotGradesUI.Value = "[" + join(string(value(App.Parameters.PlotGrades, "1")), ", ") + "]";

      unit_str = string(unit(App.Parameters.PlotAngles));
      App.PlotAnglesUI.Value = "[" + join(string(value(App.Parameters.PlotAngles, unit_str)), ", ") + "]";
      App.PlotAnglesUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.PlotPowers));
      App.PlotPowersUI.Value = "[" + join(string(value(App.Parameters.PlotPowers, unit_str)), ", ") + "]";
      App.PlotPowersUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.PlotForceUpperBound));
      App.PlotForceUpperBoundUI.Value = value(App.Parameters.PlotForceUpperBound, unit_str);
      App.PlotForceUpperBoundUI.Unit = unit_str;

      unit_str = string(unit(App.Parameters.PlotSpeedUpperBound));
      App.PlotSpeedUpperBoundUI.Value = value(App.Parameters.PlotSpeedUpperBound, unit_str);
      App.PlotSpeedUpperBoundUI.Unit = unit_str;

      % Preset ----------------------------------------------------------------

      App.PresetUI.MainListBox.Items = keys(App.presets.PresetDictionary);

      if App.BlockPath == ""
        App.PresetUI.MainListBox.Value = NameValuePairs.PresetCarName;
      else
        App.PresetUI.MainListBox.Value = {};
      end  % if

      App.AutoUpdateUI.Value = previous_auto_update_value;
    end  % function

    function callback_physical_value(App, NameValuePair)
      %%

      arguments
        App (1,1)
        NameValuePair.Name string = "physical_value"
        NameValuePair.UnitUIType string {mustBeMember(NameValuePair.UnitUIType, ["", "1", "dropdown", "label"])} = "1"
        NameValuePair.Condition string {mustBeMember(NameValuePair.Condition, ["", "positive", "non-negative"])} = ""
      end  % arguments

      Name = NameValuePair.Name;
      UnitUIType = NameValuePair.UnitUIType;

      % Get the raw value to avoid side effects in the higher level accesses.
      target_value = string(App.(Name + "UI").ValueEditFieldUI.MainEditField.Value);

      if UnitUIType == "dropdown"
        current_unit = App.(Name + "UI").UnitDropDownUI.MainDropDown.Value;
      elseif UnitUIType == "label"
        if App.(Name + "UI").unit_alias == ""
          current_unit = App.(Name + "UI").UnitLabelUI.MainLabel.Text;
        else
          current_unit = "1";
        end  % if
      else
        % UnitUIType is either "" or "1".
        current_unit = "1";
      end  % if

      val = double(target_value);
      if not(isnan(val))
        % val is not a NaN, i.e., a valid scalar number.
        % If target_value is an array or a matrix, double() returns NaN. !todo: handle non-scalar case.
        if NameValuePair.Condition == "positive" && val <= 0
          App.(Name + "UI").HasError = true;
          message = "Value must be positive";
        elseif NameValuePair.Condition == "non-negative" && val < 0
          App.(Name + "UI").HasError = true;
          message = "Value must be non-negative";
        end  % if

        if App.(Name + "UI").HasError 
          App.(Name + "UI").ErrorMessage = App.(Name + "UI").NameInInfo + ": " + message;
          alertOnError(App.(Name + "UI"))

          return

        end  % if

      else
        % val is a NaN, i.e, it needs evaluation. Clear the error states here and move on.
        App.(Name + "UI").HasError = false;
        App.(Name + "UI").ErrorMessage = "";
      end  % if

      [Result, error_message] = LiteApp5.SimscapeUtility.AnalyzeValueString(target_value);
      if error_message ~= ""
        App.(Name + "UI").HasError = true;
        App.(Name + "UI").ErrorMessage = error_message;
        alertOnError(App.(Name + "UI"))

        return

      else
        App.(Name + "UI").HasError = false;
        App.(Name + "UI").ErrorMessage = "";

      end  % if

      App.Parameters.(Name) = simscape.Value(Result.NumericValue, current_unit);

      App.Parameters = update_states(App.Parameters);
      App.RoadLoadAUI.SimscapeValue = App.Parameters.RoadLoadA;
      App.RoadLoadCUI.SimscapeValue = App.Parameters.RoadLoadC;
      App.MaximumForceUI.SimscapeValue = App.Parameters.MaximumForce;
      App.MaximumClimbPowerUI.SimscapeValue = App.Parameters.MaximumClimbPower;
      App.PlotAnglesUI.SimscapeValue = App.Parameters.PlotAngles;

      if App.AutoUpdateUI.Value
        performancePlot(App, ParentAxes=App.ParentAxes)
      end  % if
    end  % function

  end  % methods

end  % classdef
