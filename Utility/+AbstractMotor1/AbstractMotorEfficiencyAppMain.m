classdef AbstractMotorEfficiencyAppMain < handle
  % App for visualizing the power conversion efficiency of the abstract motor model
  %
  % The app can optionally get parameters from or set parameters to the following blocks.
  %   "Motor & Drive" block (Simscape Driveline)
  %   "Motor & Drive (System Level)" block (Simscape Electrical.)

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "AbstractMotorEfficiencyAppMain:"
  end  % properties

  properties

    DataSet (1,1) AbstractMotor1.AbstractMotorDataSet ...
      = AbstractMotor1.AbstractMotorDataSet(Initialization = true)

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""
    ModelFileFullPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    WindowWidth (1,1) double {mustBeInteger, mustBePositive} = 1200
    RightSideWidth (1,1) double {mustBeInteger, mustBePositive} = 500

    WindowHeight (1,1) double {mustBeInteger, mustBePositive} = 600
    PlotUIHeight (1,1) double {mustBeInteger, mustBePositive} = 400

    MainFigure matlab.ui.Figure
    Window AppUtil1.AppWindow

    DescriptionLinkUI AppUtil1.Component.Hyperlink

    % === Editable parameters

    MaxAngularSpeedUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    MaxTorqueUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    MaxPowerUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    MeasuredEfficiencyPercentUI AppUtil1.Component.PhysicalValueWithUnitLabel
    MeasuredAngularSpeedUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    MeasuredTorqueUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    MeasuredIronLossUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    FixedLossUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    RotorDampingUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    % === Derived parameters

    % Nominal loss (rated loss) at efficiency measurement point
    MeasuredNominalLossUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    IronToNominalLossRatioPercentUI AppUtil1.Component.PhysicalValueWithUnitLabel

    MeasuredCopperLossUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    MeasuredIronLossCoefficientUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    MeasuredCopperLossCoefficientUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    % === Visualization

    PlotButtonUI AppUtil1.Component.EnabledButton
    OpenInFigureWindowUI AppUtil1.Component.Hyperlink

    AxesUI AppUtil1.Graphics.Axes

    ContoursUI AppUtil1.Component.PhysicalValueWithUnitLabel
    PlotAngularSpeedUpperBoundUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    PlotTorqueUpperBoundUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    % === Block selector
    AppBlockSelectorUI AppUtil1.Component.BlockSelectorUI

  end  % properties

  properties (Constant, Access=private)

    % The "Motor & Drive" block is from Simscape Driveline.
    % The "Motor & Drive (System Level)" block is from Simscape Electrical.
    TargetSimscapeBlockNames = ["Motor & Drive", "Motor & Drive"+newline+"(System Level)"]

    angular_speed_unit_items = ["rpm", "rad/s", "rev/s"]
    torque_unit_items = ["N*m", "lbf*ft"]
    power_unit_items = ["kW", "W"];
    friction_coefficient_unit_items = ["N*m/rpm", "N*m/(rad/s)", "N*m/(rev/s)", "lbf*ft/rpm"]

    width_unit = AppUtil1.Constant.Width{"unitwidth"}
    name_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 30
    name_ui_wide_width = AppUtil1.Constant.Width{"unitwidth"} * 34
    button_width = AppUtil1.Constant.Width{"unitwidth"} * 12
    physical_unit_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 12

    oneline_height = AppUtil1.Constant.Height{"oneline+"}
  end  % properties

  methods

    function App = AbstractMotorEfficiencyAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""

        % The list of mustBeMember cannot be a class property even if it is constant.
        NameValuePair.PlotTorqueUnit (1,1) string {mustBeMember(NameValuePair.PlotTorqueUnit, ["N*m", "lbf*ft"])} = "N*m"
        NameValuePair.PlotAngularSpeedUnit (1,1) string {mustBeMember(NameValuePair.PlotAngularSpeedUnit, ["rpm", "rad/s", "rev/s"])} = "rpm"
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      if (NameValuePair.ModelName ~= "") && (NameValuePair.BlockPath ~= "")
        id = App.errorID + "InvalidOption";
        msg = CodeUtil1.i18n("Only one of ModelName or BlockPath can be specified.");

        throw(MException(id, msg))

      end  % if

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
      App.Window.Name = CodeUtil1.i18n("Abstract Motor Efficiency App");
      App.Window.Width = App.WindowWidth;
      App.Window.Height = App.WindowHeight;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if App.BlockPath ~= ""
        App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end + 1) = replace(App.ModelFileFullPath, ("/"|"\"), " > ");
        try
          % Changing an item in the model drop down list starts searching the target block, which
          % may produce an error if the target block is not found.
          App.AppBlockSelectorUI.ModelFileDropDownUI.Value = App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end);
        catch exception

          rethrow(exception)

        end  % try, catch
        App.AppBlockSelectorUI.BlockPathDropDownUI.Value = replace(App.BlockPath, "/", " / ");
        callback_get_parameters(App)

      else
        % Default settings
        App.DataSet = AbstractMotor1.AbstractMotorDataSet(Initialization=true);

        App.MaxAngularSpeedUI.SimscapeValue = App.DataSet.MaxAngularSpeed;
        App.MaxTorqueUI.SimscapeValue = App.DataSet.ModelParams.MaxTorque;
        App.MaxPowerUI.SimscapeValue = App.DataSet.ModelParams.MaxPower;
        App.MeasuredEfficiencyPercentUI.SimscapeValue = App.DataSet.ModelParams.MeasuredEfficiencyPercent;
        App.MeasuredAngularSpeedUI.SimscapeValue = App.DataSet.ModelParams.MeasuredAngularSpeed;
        App.MeasuredTorqueUI.SimscapeValue = App.DataSet.ModelParams.MeasuredTorque;
        App.MeasuredIronLossUI.SimscapeValue = App.DataSet.ModelParams.MeasuredIronLoss;
        App.FixedLossUI.SimscapeValue = App.DataSet.ModelParams.FixedLoss;
        App.RotorDampingUI.SimscapeValue = App.DataSet.ModelParams.RotorDamping;
      end  % if

      App.MeasuredNominalLossUI.UnitText = "W";
      App.MeasuredCopperLossUI.UnitText = "W";
      App.MeasuredIronLossCoefficientUI.UnitText = "W/(" + NameValuePair.PlotAngularSpeedUnit + ")^2";
      App.MeasuredCopperLossCoefficientUI.UnitText = "W/(" + NameValuePair.PlotTorqueUnit + ")^2";

      App.PlotAngularSpeedUpperBoundUI.UnitText = NameValuePair.PlotAngularSpeedUnit;
      App.PlotTorqueUpperBoundUI.UnitText = NameValuePair.PlotTorqueUnit;

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

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = AppUtil1.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.DescriptionLinkUI = AppUtil1.Component.Hyperlink(h_layout);
      App.DescriptionLinkUI.Text = CodeUtil1.i18n("Description");
      App.DescriptionLinkUI.HyperlinkClickedCallback = @() web("AbstractMotor_Description.html");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      h_container = AppUtil1.HorizontalContainer(appleft_v_layout);

      h_gridlayout = addHorizontalGridLayout(h_container);
      label_ui = AppUtil1.Component.Label(h_gridlayout);
      label_ui.ComponentWidth = App.name_ui_width;
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Parameters") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxAngularSpeedUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxAngularSpeedUI.Editable = "on";
      App.MaxAngularSpeedUI.NameUIWidth = App.name_ui_width;
      App.MaxAngularSpeedUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxAngularSpeedUI.NameText = CodeUtil1.i18n("Continuous operation max speed, $\omega_{max}$");
      App.MaxAngularSpeedUI.UnitItems = App.angular_speed_unit_items;
      App.MaxAngularSpeedUI.UnitText = "rpm";
      App.MaxAngularSpeedUI.ValueText = "17000";

      App.DataSet.MaxAngularSpeed = App.MaxAngularSpeedUI.SimscapeValue;

      App.MaxAngularSpeedUI.ValueChangedCallback = @() updateMaxAngularSpeed;
      App.MaxAngularSpeedUI.UnitChangedCallback = @() updateMaxAngularSpeed;
      function updateMaxAngularSpeed
        App.DataSet.MaxAngularSpeed = App.MaxAngularSpeedUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxTorqueUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxTorqueUI.Editable = "on";
      App.MaxTorqueUI.NameUIWidth = App.name_ui_width;
      App.MaxTorqueUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxTorqueUI.NameText = CodeUtil1.i18n("Continuous operation max torque, $\tau_{max}$");
      App.MaxTorqueUI.UnitItems = App.torque_unit_items;
      App.MaxTorqueUI.UnitText = "N*m";
      App.MaxTorqueUI.ValueText = "163";

      App.DataSet.ModelParams.MaxTorque = App.MaxTorqueUI.SimscapeValue;

      App.MaxTorqueUI.ValueChangedCallback = @() updateMaxTorque;
      App.MaxTorqueUI.UnitChangedCallback = @() updateMaxTorque;
      function updateMaxTorque
        App.DataSet.ModelParams.MaxTorque = App.MaxTorqueUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxPowerUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxPowerUI.Editable = "on";
      App.MaxPowerUI.NameUIWidth = App.name_ui_width;
      App.MaxPowerUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxPowerUI.NameText = CodeUtil1.i18n("Continuous operation max power, $P_{max}$");
      App.MaxPowerUI.UnitItems = App.power_unit_items;
      App.MaxPowerUI.UnitText = "kW";
      App.MaxPowerUI.ValueText = "53";

      App.DataSet.ModelParams.MaxPower = App.MaxPowerUI.SimscapeValue;

      App.MaxPowerUI.ValueChangedCallback = @() updateMaxPower;
      App.MaxPowerUI.UnitChangedCallback = @() updateMaxPower;
      function updateMaxPower
        App.DataSet.ModelParams.MaxPower = App.MaxPowerUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredEfficiencyPercentUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.MeasuredEfficiencyPercentUI.NameUIWidth = App.name_ui_width;
      App.MeasuredEfficiencyPercentUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredEfficiencyPercentUI.NameText = CodeUtil1.i18n("Overall efficiency, $\eta(\omega_{m}, \tau_{m})$");
      App.MeasuredEfficiencyPercentUI.UnitAlias = "\%";
      App.MeasuredEfficiencyPercentUI.ValueText = "95";

      App.DataSet.ModelParams.MeasuredEfficiencyPercent = App.MeasuredEfficiencyPercentUI.SimscapeValue;

      App.MeasuredEfficiencyPercentUI.ValueChangedCallback = @() updateMeasuredEfficiency;
      function updateMeasuredEfficiency
        App.DataSet.ModelParams.MeasuredEfficiencyPercent = App.MeasuredEfficiencyPercentUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredAngularSpeedUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredAngularSpeedUI.Editable = "on";
      App.MeasuredAngularSpeedUI.NameUIWidth = App.name_ui_width;
      App.MeasuredAngularSpeedUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredAngularSpeedUI.NameText = CodeUtil1.i18n("Speed at which $\eta$ was measured, $\omega_{m}$");
      App.MeasuredAngularSpeedUI.UnitItems = App.angular_speed_unit_items;
      App.MeasuredAngularSpeedUI.UnitText = "rpm";
      App.MeasuredAngularSpeedUI.ValueText = "2000";

      App.DataSet.ModelParams.MeasuredAngularSpeed = App.MeasuredAngularSpeedUI.SimscapeValue;

      App.MeasuredAngularSpeedUI.ValueChangedCallback = @() updateMeasuredAngularSpeed;
      App.MeasuredAngularSpeedUI.UnitChangedCallback = @() updateMeasuredAngularSpeed;
      function updateMeasuredAngularSpeed
        App.DataSet.ModelParams.MeasuredAngularSpeed = App.MeasuredAngularSpeedUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredTorqueUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredTorqueUI.Editable = "on";
      App.MeasuredTorqueUI.NameUIWidth = App.name_ui_width;
      App.MeasuredTorqueUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredTorqueUI.NameText = CodeUtil1.i18n("Torque at which $\eta$ was measured, $\tau_{m}$");
      App.MeasuredTorqueUI.UnitItems = App.torque_unit_items;
      App.MeasuredTorqueUI.UnitText = "N*m";
      App.MeasuredTorqueUI.ValueText = "50";

      App.DataSet.ModelParams.MeasuredTorque = App.MeasuredTorqueUI.SimscapeValue;

      App.MeasuredTorqueUI.ValueChangedCallback = @() updateMeasuredTorque;
      App.MeasuredTorqueUI.UnitChangedCallback = @() updateMeasuredTorque;
      function updateMeasuredTorque
        App.DataSet.ModelParams.MeasuredTorque = App.MeasuredTorqueUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredIronLossUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredIronLossUI.Editable = "on";
      App.MeasuredIronLossUI.ComponentHeight = App.oneline_height;
      App.MeasuredIronLossUI.NameUIWidth = App.name_ui_width;
      App.MeasuredIronLossUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredIronLossUI.NameText = CodeUtil1.i18n("Iron loss at measurement point, $P_{iron,m}");
      App.MeasuredIronLossUI.UnitItems = App.power_unit_items;
      App.MeasuredIronLossUI.UnitText = "W";
      App.MeasuredIronLossUI.ValueText = "55";

      App.DataSet.ModelParams.MeasuredIronLoss = App.MeasuredIronLossUI.SimscapeValue;

      App.MeasuredIronLossUI.ValueChangedCallback = @() updateMeasuredIronLoss;
      App.MeasuredIronLossUI.UnitChangedCallback = @() updateMeasuredIronLoss;
      function updateMeasuredIronLoss
        P_nom_meas = App.MeasuredNominalLossUI.SimscapeValue;
        P_iron_meas = App.MeasuredIronLossUI.SimscapeValue;
        if P_iron_meas >= P_nom_meas
          App.MeasuredIronLossUI.has_error = true;
          App.MeasuredIronLossUI.error_message = CodeUtil1.i18n("Iron loss must be smaller than nominal loss.");

          return

        end  % if
        App.MeasuredIronLossUI.has_error = false;
        App.MeasuredIronLossUI.error_message = "";
        App.DataSet.ModelParams.MeasuredIronLoss = P_iron_meas;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.FixedLossUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.FixedLossUI.Editable = "on";
      App.FixedLossUI.NameUIWidth = App.name_ui_width;
      App.FixedLossUI.UnitUIWidth = App.physical_unit_ui_width;
      App.FixedLossUI.NameText = CodeUtil1.i18n("Fixed loss, $P_{fixed}$");
      App.FixedLossUI.UnitItems = App.power_unit_items;
      App.FixedLossUI.UnitText = "W";
      App.FixedLossUI.ValueText = "40";

      App.DataSet.ModelParams.FixedLoss = App.FixedLossUI.SimscapeValue;

      App.FixedLossUI.ValueChangedCallback = @() updateFixedLoss;
      App.FixedLossUI.UnitChangedCallback = @() updateFixedLoss;
      function updateFixedLoss
        App.DataSet.ModelParams.FixedLoss = App.FixedLossUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.RotorDampingUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.RotorDampingUI.Editable = "on";
      App.RotorDampingUI.NameUIWidth = App.name_ui_width;
      App.RotorDampingUI.UnitUIWidth = App.physical_unit_ui_width;
      App.RotorDampingUI.NameText = CodeUtil1.i18n("Rotor damping coefficient, $k_f$");
      App.RotorDampingUI.UnitItems = App.friction_coefficient_unit_items;
      App.RotorDampingUI.UnitText = "N*m/(rad/s)";
      App.RotorDampingUI.ValueText = "1e-05";

      App.DataSet.ModelParams.RotorDamping = App.RotorDampingUI.SimscapeValue;

      App.RotorDampingUI.ValueChangedCallback = @() updateRotorDamping;
      App.RotorDampingUI.UnitChangedCallback = @() updateRotorDamping;
      function updateRotorDamping
        App.DataSet.ModelParams.RotorDamping = App.RotorDampingUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      % -----------------------------------------------------------------------
      % Derived parameters

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Derived parameters") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredNominalLossUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredNominalLossUI.Editable = "on";
      App.MeasuredNominalLossUI.ComponentHeight = App.oneline_height * 2;
      App.MeasuredNominalLossUI.NameUIWidth = App.name_ui_wide_width;
      App.MeasuredNominalLossUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredNominalLossUI.NameText = CodeUtil1.i18n("Nominal loss at measurement point") ...
        + newline + CodeUtil1.i18n("$P_{nom,m} = \left( 100/\eta - 1  \right) \tau_{m} \cdot \omega_{m}$");
      App.MeasuredNominalLossUI.UnitItems = App.power_unit_items;
      App.MeasuredNominalLossUI.UnitText = "W";
      App.MeasuredNominalLossUI.ValueText = "550";
      App.MeasuredNominalLossUI.ReadOnlyValueText = true;
      App.MeasuredNominalLossUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredNominalLoss");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.IronToNominalLossRatioPercentUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.IronToNominalLossRatioPercentUI.NameUIWidth = App.name_ui_wide_width;
      App.IronToNominalLossRatioPercentUI.UnitUIWidth = App.physical_unit_ui_width;
      App.IronToNominalLossRatioPercentUI.NameText = CodeUtil1.i18n("Iron-to-nominal loss ratio");
      App.IronToNominalLossRatioPercentUI.UnitAlias = "\%";
      App.IronToNominalLossRatioPercentUI.ValueText = "10";
      App.IronToNominalLossRatioPercentUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredCopperLossUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredCopperLossUI.Editable = "on";
      App.MeasuredCopperLossUI.ComponentHeight = App.oneline_height * 2;
      App.MeasuredCopperLossUI.NameUIWidth = App.name_ui_wide_width;
      App.MeasuredCopperLossUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredCopperLossUI.NameText = CodeUtil1.i18n("Copper loss at measurement point") ...
        + newline + CodeUtil1.i18n("$P_{copper,m} = P_{nom,m} - P_{iron,m} - P_{fixed} = k_{copper} \cdot \tau_{m}^2$");
      App.MeasuredCopperLossUI.UnitItems = App.power_unit_items;
      App.MeasuredCopperLossUI.UnitText = "W";
      App.MeasuredCopperLossUI.ValueText = "495";
      App.MeasuredCopperLossUI.ReadOnlyValueText = true;
      App.MeasuredCopperLossUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredCopperLoss");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredIronLossCoefficientUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredIronLossCoefficientUI.Editable = "on";
      App.MeasuredIronLossCoefficientUI.NameUIWidth = App.name_ui_wide_width;
      App.MeasuredIronLossCoefficientUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredIronLossCoefficientUI.NameText = CodeUtil1.i18n("Iron loss coefficient, $k_{iron} = P_{iron,m} / \omega_{m}^2$");
      App.MeasuredIronLossCoefficientUI.UnitItems = ["W/rpm^2", "W/(rad/s)^2", "W/(rev/s)^2"];
      App.MeasuredIronLossCoefficientUI.UnitText = "W/rpm^2";
      App.MeasuredIronLossCoefficientUI.ValueText = "0";
      App.MeasuredIronLossCoefficientUI.ReadOnlyValueText = true;
      App.MeasuredIronLossCoefficientUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredIronLossCoefficient");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredCopperLossCoefficientUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredCopperLossCoefficientUI.Editable = "on";
      App.MeasuredCopperLossCoefficientUI.NameUIWidth = App.name_ui_wide_width;
      App.MeasuredCopperLossCoefficientUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredCopperLossCoefficientUI.NameText = CodeUtil1.i18n("Copper loss coefficient, $k_{copper} = P_{copper,m} / \tau_{m}^2$");
      App.MeasuredCopperLossCoefficientUI.UnitItems = ["W/(N*m)^2", "W/(lbf*ft)^2"];
      App.MeasuredCopperLossCoefficientUI.UnitText = "W/(N*m)^2";
      App.MeasuredCopperLossCoefficientUI.ValueText = "0";
      App.MeasuredCopperLossCoefficientUI.ReadOnlyValueText = true;
      App.MeasuredCopperLossCoefficientUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredCopperLossCoefficient");

      % =======================================================================
      % Right side of the app window
      % =======================================================================
      appright_h_layout = addHorizontalGridLayout(appmain_h_container, Width=App.RightSideWidth);
      appright_v_container = AppUtil1.VerticalContainer(appright_h_layout);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = AppUtil1.HorizontalContainer(appright_v_layout);

      h_gridlayout = addHorizontalGridLayout(h_container);
      App.PlotButtonUI = AppUtil1.Component.EnabledButton(h_gridlayout);
      App.PlotButtonUI.HorizontalAlignment = "left";
      App.PlotButtonUI.ButtonUIWidth = App.button_width + App.width_unit;
      App.PlotButtonUI.ButtonWidth = App.button_width;
      App.PlotButtonUI.CheckBoxUIWidth = "fit";
      App.PlotButtonUI.CheckBoxWidth = "fit";
      App.PlotButtonUI.ButtonText = CodeUtil1.i18n("Update");
      App.PlotButtonUI.ButtonUI.MainButton.Icon = which("mus-icon-rotation-arrow.svg");
      App.PlotButtonUI.CheckBoxText = CodeUtil1.i18n("Auto-update");
      App.PlotButtonUI.ButtonPushedCallback = @() UpdatePlot(App);
      % Set auto-update to false and keep it until the entire app is ready.
      App.PlotButtonUI.ButtonDisable = "on";

      h_gridlayout = addHorizontalGridLayout(h_container);
      App.OpenInFigureWindowUI = AppUtil1.Component.Hyperlink(h_gridlayout);
      App.OpenInFigureWindowUI.Text = CodeUtil1.i18n("Open in figure window");
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";

      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() open_in_figure_window();
      function open_in_figure_window
        syncVisualizationSettings(App)
        updateDataSet(App.DataSet)
        AbstractMotor1.plotAbstractMotorEfficiency( ...
          ParentAxes = axes(figure), ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % nested function

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.AxesUI = AppUtil1.Graphics.Axes(appright_v_layout);
      App.AxesUI.ComponentHeight = App.PlotUIHeight;

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.ContoursUI = AppUtil1.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.ContoursUI.NameUIWidth = App.width_unit * 20;
      App.ContoursUI.UnitUIWidth = App.physical_unit_ui_width;
      App.ContoursUI.NameText = CodeUtil1.i18n("Contour levels");
      App.ContoursUI.UnitAlias = "\%";
      App.ContoursUI.ValueText = "[1, 60, 80, 90, 92, 94, 96, 97, 98, 99]";

      App.ContoursUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotAngularSpeedUpperBoundUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotAngularSpeedUpperBoundUI.Editable = "on";
      App.PlotAngularSpeedUpperBoundUI.NameUIWidth = App.width_unit * 20;
      App.PlotAngularSpeedUpperBoundUI.UnitUIWidth = App.physical_unit_ui_width;
      App.PlotAngularSpeedUpperBoundUI.NameText = CodeUtil1.i18n("Plot speed upper bound");
      App.PlotAngularSpeedUpperBoundUI.UnitItems = App.angular_speed_unit_items;
      App.PlotAngularSpeedUpperBoundUI.UnitText = "rpm";
      App.PlotAngularSpeedUpperBoundUI.ValueText = "18000";

      App.PlotAngularSpeedUpperBoundUI.ValueChangedCallback = @() auto_update_plot(App);
      App.PlotAngularSpeedUpperBoundUI.UnitChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotTorqueUpperBoundUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotTorqueUpperBoundUI.Editable = "on";
      App.PlotTorqueUpperBoundUI.NameUIWidth = App.width_unit * 20;
      App.PlotTorqueUpperBoundUI.UnitUIWidth = App.physical_unit_ui_width;
      App.PlotTorqueUpperBoundUI.NameText = CodeUtil1.i18n("Plot torque upper bound");
      App.PlotTorqueUpperBoundUI.UnitItems = App.torque_unit_items;
      App.PlotTorqueUpperBoundUI.UnitText = "N*m";
      App.PlotTorqueUpperBoundUI.ValueText = "200";

      App.PlotTorqueUpperBoundUI.ValueChangedCallback = @() auto_update_plot(App);
      App.PlotTorqueUpperBoundUI.UnitChangedCallback = @() auto_update_plot(App);

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

    function callback_set_parameters(App)
      %%
      % This function reads parameters from the UI components and set them to the selected block.

      % This callback can run only when a valid block path is selected in the block path drop down UI.
      % Thus, accessing App.BlockPathDropDownUI.Value here is safe, i.e., no error check is necessary.
      block_path = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      App.BlockPath = block_path;

      load_system(block_path)

      set_param(block_path, "torque_max_unit", App.MaxTorqueUI.UnitText);
      set_param(block_path, "torque_max", App.MaxTorqueUI.ValueText);

      set_param(block_path, "power_max_unit", App.MaxPowerUI.UnitText);
      set_param(block_path, "power_max", App.MaxPowerUI.ValueText);

      % Efficiency parameter is of type double, i.e., it has no physical unit.
      set_param(block_path, "eff", App.MeasuredEfficiencyPercentUI.ValueText);

      set_param(block_path, "w_eff_unit", App.MeasuredAngularSpeedUI.UnitText);
      set_param(block_path, "w_eff", App.MeasuredAngularSpeedUI.ValueText);

      set_param(block_path, "T_eff_unit", App.MeasuredTorqueUI.UnitText);
      set_param(block_path, "T_eff", App.MeasuredTorqueUI.ValueText);

      mask_type = string(get_param(block_path, "MaskType"));
      if mask_type == ("Motor & Drive" + newline + "(System Level)")
        % "Motor & Drive (System Level)" block from Simscape Electrical.
        % Assume that the block is configured with...
        %   Electrical Torque: Parameterize by "Maximum torque and power"
        %   Electrical Losses: Parameterize losses by: "Single efficiency measurement"
        % If not, an error may occur, but this code does not handle it.

        set_param(block_path, "Piron_unit", App.MeasuredIronLossUI.UnitText);
        set_param(block_path, "Piron", App.MeasuredIronLossUI.ValueText);

        set_param(block_path, "Pbase_unit", App.FixedLossUI.UnitText);
        set_param(block_path, "Pbase", App.FixedLossUI.ValueText);

        set_param(block_path, "lam_unit", App.RotorDampingUI.UnitText);
        set_param(block_path, "lam", App.RotorDampingUI.ValueText);
      end  % if
    end  % function

    function callback_get_parameters(App)
      %%
      % This function gets parameters from the selected block and loads them to the app.

      App.BlockPath = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      block_path = App.BlockPath;

      load_system(block_path)

      mask_type = string(get_param(block_path, "MaskType"));
      if mask_type == "Motor & Drive"
        % "Motor & Drive" block from Simscape Driveline.
        motor_model_type = "Simplified";

      elseif mask_type == ("Motor & Drive" + newline + "(System Level)")
        % "Motor & Drive (System Level)" block from Simscape Electrical.
        motor_model_type = "Full";

      else
        % Error, but this branch must be unreachable because the Block Selector UI filters the blocks.
        msg = CodeUtil1.i18n("App internal error: callback_get_parameters failed.");
        if App.MainFigure.Visible
          title_word = CodeUtil1.i18n("Error");
          uialert(App.MainFigure, msg, title_word)

          return

        else
          id = App.errorID + "AppInternalError";

          throw(MException(id, msg))

        end  % if
      end  % if

      % Create a data set from the specified block path.
      % If block parameters refer to workspace variables, the workspace variables must be loaded upfront.
      % This updates the derived parameters too.
      try
        App.DataSet = AbstractMotor1.AbstractMotorDataSet(BlockPath=block_path);
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
      % Prevent the plot auto update while updating UI components.
      prev_value = App.PlotButtonUI.CheckBoxUI.Value;
      App.PlotButtonUI.CheckBoxUI.Value = false;

      value_text = get_param(block_path, "torque_max");
      unit_text = get_param(block_path, "torque_max_unit");
      App.MaxTorqueUI.ValueText = value_text;
      App.MaxTorqueUI.UnitText = unit_text;
      App.DataSet.ModelParams.MaxTorque = App.MaxTorqueUI.SimscapeValue;

      value_text = get_param(block_path, "power_max");
      unit_text = get_param(block_path, "power_max_unit");
      App.MaxPowerUI.ValueText = value_text;
      App.MaxPowerUI.UnitText = unit_text;
      App.DataSet.ModelParams.MaxPower = App.MaxPowerUI.SimscapeValue;

      value_text = get_param(block_path, "eff");
      App.MeasuredEfficiencyPercentUI.ValueText = value_text;
      App.DataSet.ModelParams.MeasuredEfficiencyPercent = App.MeasuredEfficiencyPercentUI.SimscapeValue;

      value_text = get_param(block_path, "w_eff");
      unit_text = get_param(block_path, "w_eff_unit");
      App.MeasuredAngularSpeedUI.ValueText = value_text;
      App.MeasuredAngularSpeedUI.UnitText = unit_text;
      App.DataSet.ModelParams.MeasuredAngularSpeed = App.MeasuredAngularSpeedUI.SimscapeValue;

      value_text = get_param(block_path, "T_eff");
      unit_text = get_param(block_path, "T_eff_unit");
      App.MeasuredTorqueUI.ValueText = value_text;
      App.MeasuredTorqueUI.UnitText = unit_text;
      App.DataSet.ModelParams.MeasuredTorque = App.MeasuredTorqueUI.SimscapeValue;

      if motor_model_type == "Simplified"
        App.MeasuredIronLossUI.SimscapeValue = simscape.Value(0, "W");
        App.FixedLossUI.SimscapeValue = simscape.Value(0, "W");
        App.RotorDampingUI.SimscapeValue = simscape.Value(0, "N*m/(rad/s)");

      else
        value_text = get_param(block_path, "Piron");
        unit_text = get_param(block_path, "Piron_unit");
        App.MeasuredIronLossUI.ValueText = value_text;
        App.MeasuredIronLossUI.UnitText = unit_text;
        App.DataSet.ModelParams.MeasuredIronLoss = App.MeasuredIronLossUI.SimscapeValue;

        value_text = get_param(block_path, "Pbase");
        unit_text = get_param(block_path, "Pbase_unit");
        App.FixedLossUI.ValueText = value_text;
        App.FixedLossUI.UnitText = unit_text;
        App.DataSet.ModelParams.FixedLoss = App.FixedLossUI.SimscapeValue;

        value_text = get_param(block_path, "Lam");
        unit_text = get_param(block_path, "Lam_unit");
        App.RotorDampingUI.ValueText = value_text;
        App.RotorDampingUI.UnitText = unit_text;
        App.DataSet.ModelParams.RotorDamping = App.RotorDampingUI.SimscapeValue;
      end  % if

      % Recover the plot auto update setting.
      App.PlotButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      react_UIChanged(App)
    end  % function

    function react_UIChanged(App)
      %%
      % All user-editable parameters are up to date.

      arguments (Input)
        App (1,1)
      end  % if

      updateDataSet(App.DataSet)

      update_DerivedParameterUI(App, "MeasuredNominalLoss")

      App.IronToNominalLossRatioPercentUI.ValueTextUI.MainEditField.Value = ...
        string(App.DataSet.ModelParams.IronToNominalLossRatioPercent);

      update_DerivedParameterUI(App, "MeasuredCopperLoss")
      update_DerivedParameterUI(App, "MeasuredIronLossCoefficient")
      update_DerivedParameterUI(App, "MeasuredCopperLossCoefficient")

      auto_update_plot(App)
    end  % function

    function update_DerivedParameterUI(App, ParamName)
      %%
      % For derived parameters, edit field is read-only while unit is selectable if it is drop-down UI.
      % When this function runs, there is no need to update the plot because
      % this function updates the display value of a derived parameter which
      % does not affect the plot.
      arguments (Input)
        App (1,1)
        ParamName (1,1) string
      end  % if
      current_unit = App.(ParamName + "UI").UnitDropDownUI.UnitText;
      current_simscape_value = App.DataSet.ModelParams.(ParamName);
      App.(ParamName + "UI").ValueTextUI.MainEditField.Value = string(value(current_simscape_value, current_unit));
    end  % function

    function auto_update_plot(App)
      %%
      if App.PlotButtonUI.CheckBoxUI.Value
        UpdatePlot(App)
      end  % if
    end  % function

    function syncVisualizationSettings(App)
      %%
      App.DataSet.ContourLevelsPercent = value(App.ContoursUI.SimscapeValue);
      App.DataSet.PlotAngularSpeedUpperBound = App.PlotAngularSpeedUpperBoundUI.SimscapeValue;
      App.DataSet.PlotTorqueUpperBound = App.PlotTorqueUpperBoundUI.SimscapeValue;
    end  % function

    function UpdatePlot(App)
      %%
      syncVisualizationSettings(App)
      updateDataSet(App.DataSet)

      cla(App.AxesUI.MainAxes)

      AbstractMotor1.plotAbstractMotorEfficiency( ...
        ParentAxes = App.AxesUI.MainAxes, ...
        DataSource="dataset", DataSet=App.DataSet)
    end  % function

  end  % methods
end  % classdef
