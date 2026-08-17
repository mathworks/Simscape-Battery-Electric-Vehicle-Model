classdef AbstractMotorEfficiencyAppMain < handle
  % App for visualizing the power conversion efficiency of the abstract motor model.
  %
  % The app can optionally get parameters from or set parameters to the following blocks.
  %   "Motor & Drive" block (Simscape Driveline)
  %   "Motor & Drive (System Level)" block (Simscape Electrical.)
  %
  % ---------------------------------------------------------------------------
  % About plot range settings
  %
  % The app adjusts the plot ranges of both angular speed and torque if
  % both max angular speed and plot range are set to "auto".
  %
  % If max angular speed is "specify", it is used regardless of plot auto range setting.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "AbstractMotorEfficiencyAppMain:"
  end  % properties
  properties

    DataSet (1,1) bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet

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

    WindowHeight (1,1) double {mustBeInteger, mustBePositive} = 700
    PlotUIHeight (1,1) double {mustBeInteger, mustBePositive} = 370

    DescriptionLinkUI bevutil1.AppUtil.Component.Hyperlink

    % === Editable parameters

    MaxAngularSpeedModeUI bevutil1.AppUtil.Component.DropDown
    MaxAngularSpeedUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    MaxTorqueUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    MaxPowerUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    ElectricalEfficiencyPercentUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    MeasuredAngularSpeedUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    MeasuredTorqueUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    MeasuredIronLossesUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    FixedLossesUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    % === Derived parameters

    % Nominal loss (rated loss) at efficiency measurement point
    MeasuredNominalLossesUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    IronToNominalLossRatioPercentUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    MeasuredCopperLossesUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    MeasuredIronLossCoefficientUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    MeasuredCopperLossCoefficientUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    % === Visualization

    UpdateButtonUI bevutil1.AppUtil.Component.EnabledButton
    OpenInFigureWindowUI bevutil1.AppUtil.Component.Hyperlink

    AxesUI bevutil1.AppUtil.Graphics.Axes

    % === Plot customization

    PlotAutoRangeUI bevutil1.AppUtil.Component.CheckBox
    PlotAngularSpeedUpperBoundUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    PlotTorqueUpperBoundUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    PlotContourLevelsPercentUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel
    PlotPowersUI bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel

    % === Struct parameter UI and block selector UI

    StructParameterUI bevutil1.AppUtil.Component.BaseWorkspaceStructParameterUI;
    AppBlockSelectorUI bevutil1.AppUtil.Component.BlockSelectorUI

  end  % properties
  properties (Constant, Access=private)

    % The "Motor & Drive" block is from Simscape Driveline.
    % The "Motor & Drive (System Level)" block is from Simscape Electrical.
    TargetSimscapeBlockNames = ["Motor & Drive", "Motor & Drive"+newline+"(System Level)"]

    angular_speed_unit_items = ["rpm", "rad/s", "rev/s"]
    torque_unit_items = ["N*m", "lbf*ft"]
    power_unit_items = ["kW", "W"];

    width_unit = bevutil1.AppUtil.Constant.Width{"unitwidth"}
    name_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 27
    button_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
    physical_unit_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12

    % !todo: Define alert ui width in a common resource file.
    alert_ui_width = 30

    oneline_height = bevutil1.AppUtil.Constant.Height{"oneline+"}

  end  % properties

  methods

    function App = AbstractMotorEfficiencyAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.AppParameterFileName (1,1) string = ""
        NameValuePair.AppParameterStructName (1,1) string = ""

        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      App.DataSet = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet(Initialization=true);

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
      App.Window.Name = bevutil1.CodeUtil.i18n("Abstract Motor Efficiency");
      App.Window.Width = App.WindowWidth;
      App.Window.Height = App.WindowHeight;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % Load default UI settings.

      % Parameters ............................................................

      % Use MainDropDown's property to avoid triggering MaxAngularSpeedModeUI's callbacks.
      App.MaxAngularSpeedModeUI.MainDropDown.Value = "auto";
      App.MaxAngularSpeedUI.SimscapeValue = App.DataSet.MaxAngularSpeed;
      App.MaxAngularSpeedUI.ValueTextUI.MainEditField.Enable = "off";
      App.MaxAngularSpeedUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "off";

      App.MaxTorqueUI.SimscapeValue = App.DataSet.ModelParams.MaxTorque;
      App.MaxPowerUI.SimscapeValue = App.DataSet.ModelParams.MaxPower;
      App.ElectricalEfficiencyPercentUI.SimscapeValue = App.DataSet.ModelParams.ElectricalEfficiencyPercent;
      App.MeasuredAngularSpeedUI.SimscapeValue = App.DataSet.ModelParams.MeasuredAngularSpeed;
      App.MeasuredTorqueUI.SimscapeValue = App.DataSet.ModelParams.MeasuredTorque;
      App.MeasuredIronLossesUI.SimscapeValue = App.DataSet.ModelParams.MeasuredIronLosses;
      App.FixedLossesUI.SimscapeValue = App.DataSet.ModelParams.FixedLosses;

      % Derived parameters ....................................................
      App.MeasuredNominalLossesUI.UnitText = "W";
      App.MeasuredCopperLossesUI.UnitText = "W";
      App.MeasuredIronLossCoefficientUI.UnitText = "W/(" + string(unit(App.DataSet.PlotAngularSpeedUpperBound)) + ")^2";
      App.MeasuredCopperLossCoefficientUI.UnitText = "W/(" + string(unit(App.DataSet.PlotTorqueUpperBound)) + ")^2";

      % Visualization parameters ..............................................
      App.PlotAutoRangeUI.Value = App.DataSet.PlotAutoRange;
      App.PlotAngularSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotAngularSpeedUpperBound;
      App.PlotTorqueUpperBoundUI.SimscapeValue = App.DataSet.PlotTorqueUpperBound;
      App.PlotContourLevelsPercentUI.ValueText = bevutil1.CodeUtil.stringify(App.DataSet.PlotContourLevelsPercent);
      App.PlotPowersUI.SimscapeValue = App.DataSet.PlotPowers;

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
        evalin("base", paramfile_name + ";");

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

      end  % if

      if App.BlockPath ~= ""
        App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end + 1) = replace(App.ModelFileFullPath, ("/"|"\"), " > ");
        App.AppBlockSelectorUI.ModelFileDropDownUI.Value = App.AppBlockSelectorUI.ModelFileDropDownUI.Items(end);
        App.AppBlockSelectorUI.BlockPathDropDownUI.Value = replace(App.BlockPath, "/", " / ");

        callback_get_parameters(App)

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

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.DescriptionLinkUI = bevutil1.AppUtil.Component.Hyperlink(h_layout);
      App.DescriptionLinkUI.Text = bevutil1.CodeUtil.i18n("Description");
      App.DescriptionLinkUI.HyperlinkClickedCallback = @() web("AbstractMotorEfficiencyApp_Description_bevutil1.html");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Parameters") + "}";

      % -----------------------------------------------------------------------
      % Continuous max angular speed, 1/2 - auto/specify drop down
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      % Add a horizontal space (alert_ui_width) between this label and the drop down created below.
      % This makes the left side of the drop down aligned with the edit fields of
      % PhysicalValueWithUnitDropDown components that are vertically placed beneath the drop down.
      label_ui.ComponentWidth = App.name_ui_width + App.alert_ui_width;
      label_ui.Text = bevutil1.CodeUtil.i18n("Continuous max angular speed, $\omega_{max}$");

      h_layout = addHorizontalGridLayout(h_container);
      App.MaxAngularSpeedModeUI = bevutil1.AppUtil.Component.DropDown(h_layout);
      App.MaxAngularSpeedModeUI.Items = [bevutil1.CodeUtil.i18n("Auto"), bevutil1.CodeUtil.i18n("Specify")];
      App.MaxAngularSpeedModeUI.MainDropDown.ItemsData = ["auto", "specify"];
      App.MaxAngularSpeedModeUI.ValueChangedCallback = @() updateApp(App);

      % .......................................................................
      % Continuous max angular speed, 2/2 - physical value UI
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      % The above drop down is given the name. This component is given "" for the NameText.
      App.MaxAngularSpeedUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxAngularSpeedUI.Editable = "on";
      App.MaxAngularSpeedUI.NameUIWidth = App.name_ui_width;
      App.MaxAngularSpeedUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxAngularSpeedUI.UnitItems = App.angular_speed_unit_items;
      App.MaxAngularSpeedUI.UnitText = "rpm";
      App.MaxAngularSpeedUI.UnitChangedCallback = @() updateApp(App);
      App.MaxAngularSpeedUI.ValueChangedCallback = @() updateApp(App);
      App.MaxAngularSpeedUI.NameText = "";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxTorqueUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxTorqueUI.Editable = "on";
      App.MaxTorqueUI.NameUIWidth = App.name_ui_width;
      App.MaxTorqueUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxTorqueUI.NameText = bevutil1.CodeUtil.i18n("Continuous max torque, $\tau_{max}$");
      App.MaxTorqueUI.UnitItems = App.torque_unit_items;
      App.MaxTorqueUI.UnitText = "N*m";
      App.MaxTorqueUI.ValueChangedCallback = @() updateApp(App);
      App.MaxTorqueUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MaxPowerUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MaxPowerUI.Editable = "on";
      App.MaxPowerUI.NameUIWidth = App.name_ui_width;
      App.MaxPowerUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MaxPowerUI.NameText = bevutil1.CodeUtil.i18n("Continuous max power, $P_{max}$");
      App.MaxPowerUI.UnitItems = App.power_unit_items;
      App.MaxPowerUI.UnitText = "kW";
      App.MaxPowerUI.ValueChangedCallback = @() updateApp(App);
      App.MaxPowerUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.ElectricalEfficiencyPercentUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.ElectricalEfficiencyPercentUI.NameUIWidth = App.name_ui_width;
      App.ElectricalEfficiencyPercentUI.UnitUIWidth = App.physical_unit_ui_width;
      App.ElectricalEfficiencyPercentUI.NameText = bevutil1.CodeUtil.i18n("Overall electrical efficiency, $\eta(\omega_{m}, \tau_{m})$");
      App.ElectricalEfficiencyPercentUI.UnitAlias = "\%";
      App.ElectricalEfficiencyPercentUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredAngularSpeedUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredAngularSpeedUI.Editable = "on";
      App.MeasuredAngularSpeedUI.NameUIWidth = App.name_ui_width;
      App.MeasuredAngularSpeedUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredAngularSpeedUI.NameText = bevutil1.CodeUtil.i18n("Speed at measurement point, $\omega_{m}$");
      App.MeasuredAngularSpeedUI.UnitItems = App.angular_speed_unit_items;
      App.MeasuredAngularSpeedUI.UnitText = "rpm";
      App.MeasuredAngularSpeedUI.ValueChangedCallback = @() updateApp(App);
      App.MeasuredAngularSpeedUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredTorqueUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredTorqueUI.Editable = "on";
      App.MeasuredTorqueUI.NameUIWidth = App.name_ui_width;
      App.MeasuredTorqueUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredTorqueUI.NameText = bevutil1.CodeUtil.i18n("Torque at measurement point, $\tau_{m}$");
      App.MeasuredTorqueUI.UnitItems = App.torque_unit_items;
      App.MeasuredTorqueUI.UnitText = "N*m";
      App.MeasuredTorqueUI.ValueChangedCallback = @() updateApp(App);
      App.MeasuredTorqueUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredIronLossesUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredIronLossesUI.Editable = "on";
      App.MeasuredIronLossesUI.ComponentHeight = App.oneline_height;
      App.MeasuredIronLossesUI.NameUIWidth = App.name_ui_width;
      App.MeasuredIronLossesUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredIronLossesUI.NameText = bevutil1.CodeUtil.i18n("Iron losses at measurement point, $P_{iron,m}$");
      App.MeasuredIronLossesUI.UnitItems = App.power_unit_items;
      App.MeasuredIronLossesUI.UnitText = "W";
      App.MeasuredIronLossesUI.ValueChangedCallback = @() updateApp(App);
      App.MeasuredIronLossesUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.FixedLossesUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.FixedLossesUI.Editable = "on";
      App.FixedLossesUI.NameUIWidth = App.name_ui_width;
      App.FixedLossesUI.UnitUIWidth = App.physical_unit_ui_width;
      App.FixedLossesUI.NameText = bevutil1.CodeUtil.i18n("Fixed losses, $P_{fixed}$");
      App.FixedLossesUI.UnitItems = App.power_unit_items;
      App.FixedLossesUI.UnitText = "W";
      App.FixedLossesUI.ValueChangedCallback = @() updateApp(App);
      App.FixedLossesUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      % Derived parameters

      left_indent = 20;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Derived parameters") + "}";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredNominalLossesUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredNominalLossesUI.ComponentHeight = App.oneline_height;
      App.MeasuredNominalLossesUI.NameUIWidth = App.name_ui_width;
      App.MeasuredNominalLossesUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredNominalLossesUI.UnitItems = App.power_unit_items;
      App.MeasuredNominalLossesUI.UnitText = "W";
      App.MeasuredNominalLossesUI.ReadOnlyValueText = true;
      App.MeasuredNominalLossesUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredNominalLosses");
      App.MeasuredNominalLossesUI.NameText = bevutil1.CodeUtil.i18n("Nominal losses at measurement point");

      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);
      addHorizontalGridLayout(h_container, Width=left_indent);  % small left indent before an equation
      h_layout = addHorizontalGridLayout(h_container);
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.ComponentHeight = App.oneline_height;
      label_ui.Text = bevutil1.CodeUtil.i18n("$P_{nom,m} = \left( 100/\eta - 1  \right) \tau_{m} \cdot \omega_{m}$");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.IronToNominalLossRatioPercentUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appleft_v_layout);
      App.IronToNominalLossRatioPercentUI.NameUIWidth = App.name_ui_width;
      App.IronToNominalLossRatioPercentUI.UnitUIWidth = App.physical_unit_ui_width;
      App.IronToNominalLossRatioPercentUI.NameText = bevutil1.CodeUtil.i18n("Iron-to-nominal loss ratio");
      App.IronToNominalLossRatioPercentUI.UnitAlias = "\%";
      App.IronToNominalLossRatioPercentUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredCopperLossesUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredCopperLossesUI.ComponentHeight = App.oneline_height; 
      App.MeasuredCopperLossesUI.NameUIWidth = App.name_ui_width;
      App.MeasuredCopperLossesUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredCopperLossesUI.UnitItems = App.power_unit_items;
      App.MeasuredCopperLossesUI.UnitText = "W";
      App.MeasuredCopperLossesUI.ReadOnlyValueText = true;
      App.MeasuredCopperLossesUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredCopperLosses");
      App.MeasuredCopperLossesUI.NameText = bevutil1.CodeUtil.i18n("Copper losses at measurement point");

      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);
      addHorizontalGridLayout(h_container, Width=left_indent);  % small left indent before an equation
      h_layout = addHorizontalGridLayout(h_container);
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.ComponentHeight = App.oneline_height;
      label_ui.Text = bevutil1.CodeUtil.i18n("$P_{copper,m} = P_{nom,m} - P_{iron,m} - P_{fixed}$");

      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);
      addHorizontalGridLayout(h_container, Width=left_indent);  % small left indent before an equation
      h_layout = addHorizontalGridLayout(h_container);
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.ComponentHeight = App.oneline_height;
      label_ui.Text = bevutil1.CodeUtil.i18n("$ = k_{copper} \cdot \tau_{m}^2$");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredIronLossCoefficientUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredIronLossCoefficientUI.ComponentHeight = App.oneline_height;
      App.MeasuredIronLossCoefficientUI.NameUIWidth = App.name_ui_width;
      App.MeasuredIronLossCoefficientUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredIronLossCoefficientUI.UnitItems = ["W/rpm^2", "W/(rad/s)^2", "W/(rev/s)^2"];
      App.MeasuredIronLossCoefficientUI.UnitText = "W/rpm^2";
      App.MeasuredIronLossCoefficientUI.ReadOnlyValueText = true;
      App.MeasuredIronLossCoefficientUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredIronLossCoefficient");
      App.MeasuredIronLossCoefficientUI.NameText = bevutil1.CodeUtil.i18n("Iron loss coefficient");

      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);
      addHorizontalGridLayout(h_container, Width=left_indent);  % small left indent before an equation
      h_layout = addHorizontalGridLayout(h_container);
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.ComponentHeight = App.oneline_height;
      label_ui.Text = bevutil1.CodeUtil.i18n("$k_{iron} = P_{iron,m} / \omega_{m}^2$");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      App.MeasuredCopperLossCoefficientUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.MeasuredCopperLossCoefficientUI.ComponentHeight = App.oneline_height;
      App.MeasuredCopperLossCoefficientUI.NameUIWidth = App.name_ui_width;
      App.MeasuredCopperLossCoefficientUI.UnitUIWidth = App.physical_unit_ui_width;
      App.MeasuredCopperLossCoefficientUI.UnitItems = ["W/(N*m)^2", "W/(lbf*ft)^2"];
      App.MeasuredCopperLossCoefficientUI.UnitText = "W/(N*m)^2";
      App.MeasuredCopperLossCoefficientUI.ReadOnlyValueText = true;
      App.MeasuredCopperLossCoefficientUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "MeasuredCopperLossCoefficient");
      App.MeasuredCopperLossCoefficientUI.NameText = bevutil1.CodeUtil.i18n("Copper loss coefficient");

      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);
      addHorizontalGridLayout(h_container, Width=left_indent);  % small left indent before an equation
      h_layout = addHorizontalGridLayout(h_container);
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.ComponentHeight = App.oneline_height;
      label_ui.Text = bevutil1.CodeUtil.i18n("$k_{copper} = P_{copper,m} / \tau_{m}^2$");

      % =======================================================================
      % Small gap between left pane and right pane
      addHorizontalGridLayout(appmain_h_container, Width=10);

      % =======================================================================
      % Right side of the app window
      % =======================================================================
      appright_h_layout = addHorizontalGridLayout(appmain_h_container, Width=App.RightSideWidth);
      appright_v_container = bevutil1.AppUtil.VerticalContainer(appright_h_layout);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appright_v_layout);

      h_layout = addHorizontalGridLayout(h_container);
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

      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() open_in_figure_window();
      function open_in_figure_window
        bevutil1.app.AbstractMotorEfficiency.plotAbstractMotorEfficiency( ...
          ParentAxes = axes(figure), ...
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

      local_name_ui_width = App.width_unit * 20;

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotAutoRangeUI = bevutil1.AppUtil.Component.CheckBox(appright_v_layout);
      App.PlotAutoRangeUI.Text = bevutil1.CodeUtil.i18n("Auto range");
      App.PlotAutoRangeUI.Value = true;
      App.PlotAutoRangeUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotAngularSpeedUpperBoundUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotAngularSpeedUpperBoundUI.Editable = "on";
      App.PlotAngularSpeedUpperBoundUI.NameUIWidth = local_name_ui_width;
      App.PlotAngularSpeedUpperBoundUI.UnitUIWidth = App.physical_unit_ui_width;
      App.PlotAngularSpeedUpperBoundUI.NameText = bevutil1.CodeUtil.i18n("Angular speed upper bound");
      App.PlotAngularSpeedUpperBoundUI.UnitItems = App.angular_speed_unit_items;
      App.PlotAngularSpeedUpperBoundUI.UnitText = "rpm";
      App.PlotAngularSpeedUpperBoundUI.ValueChangedCallback = @() updateApp(App);
      App.PlotAngularSpeedUpperBoundUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotTorqueUpperBoundUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appright_v_layout);
      App.PlotTorqueUpperBoundUI.Editable = "on";
      App.PlotTorqueUpperBoundUI.NameUIWidth = local_name_ui_width;
      App.PlotTorqueUpperBoundUI.UnitUIWidth = App.physical_unit_ui_width;
      App.PlotTorqueUpperBoundUI.NameText = bevutil1.CodeUtil.i18n("Torque upper bound");
      App.PlotTorqueUpperBoundUI.UnitItems = App.torque_unit_items;
      App.PlotTorqueUpperBoundUI.UnitText = "N*m";
      App.PlotTorqueUpperBoundUI.ValueChangedCallback = @() updateApp(App);
      App.PlotTorqueUpperBoundUI.UnitChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotContourLevelsPercentUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotContourLevelsPercentUI.NameUIWidth = local_name_ui_width;
      App.PlotContourLevelsPercentUI.UnitUIWidth = App.physical_unit_ui_width;
      App.PlotContourLevelsPercentUI.NameText = bevutil1.CodeUtil.i18n("Contour levels");
      App.PlotContourLevelsPercentUI.UnitAlias = "\%";
      App.PlotContourLevelsPercentUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);

      App.PlotPowersUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitLabel(appright_v_layout);
      App.PlotPowersUI.NameUIWidth = local_name_ui_width;
      App.PlotPowersUI.UnitUIWidth = App.physical_unit_ui_width;
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
      % This function reads parameters from the UI components and set them to the selected block.
      %
      % If the UI component's ValueText contains a simscape.Value, use the unit
      % defined in it for transferring to the block parameter setting by appending
      % .value("<unit>") text. Also set up the block parameter's unit to be
      % the same as the simscape.Value's unit.

      % This callback can run only when a valid block path is selected in the block path drop down UI.
      % Thus, accessing App.BlockPathDropDownUI.Value here is safe, i.e., no error check is necessary.
      block_path = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      App.BlockPath = block_path;

      load_system(extractBefore(block_path, "/"))

      set_param(block_path, "torque_max_unit", App.MaxTorqueUI.UnitText);
      if App.MaxTorqueUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.MaxTorqueUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "torque_max", App.MaxTorqueUI.ValueText + extra_text);

      set_param(block_path, "power_max_unit", App.MaxPowerUI.UnitText);
      if App.MaxPowerUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.MaxPowerUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "power_max", App.MaxPowerUI.ValueText + extra_text);

      % This parameter has no physical unit.
      set_param(block_path, "eff", App.ElectricalEfficiencyPercentUI.ValueText);

      set_param(block_path, "w_eff_unit", App.MeasuredAngularSpeedUI.UnitText);
      if App.MeasuredAngularSpeedUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.MeasuredAngularSpeedUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "w_eff", App.MeasuredAngularSpeedUI.ValueText + extra_text);

      set_param(block_path, "T_eff_unit", App.MeasuredTorqueUI.UnitText);
      if App.MeasuredTorqueUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.MeasuredTorqueUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "T_eff", App.MeasuredTorqueUI.ValueText + extra_text);

      mask_type = string(get_param(block_path, "MaskType"));
      if mask_type == ("Motor & Drive" + newline + "(System Level)")
        % "Motor & Drive (System Level)" block from Simscape Electrical.
        % Assume that the block is configured with...
        %   Electrical Torque: Parameterize by "Maximum torque and power"
        %   Electrical Losses: Parameterize losses by: "Single efficiency measurement"
        % If not, an error may occur, but this code does not handle it.

        set_param(block_path, "Piron_unit", App.MeasuredIronLossesUI.UnitText);
        if App.MeasuredIronLossesUI.ValueTextIsSimscapeValue
          extra_text = ".value(""" + App.MeasuredIronLossesUI.UnitText + """)";
        else
          extra_text = "";
        end  % if
        set_param(block_path, "Piron", App.MeasuredIronLossesUI.ValueText + extra_text);

        set_param(block_path, "Pbase_unit", App.FixedLossesUI.UnitText);
        if App.FixedLossesUI.ValueTextIsSimscapeValue
          extra_text = ".value(""" + App.FixedLossesUI.UnitText + """)";
        else
          extra_text = "";
        end  % if
        set_param(block_path, "Pbase", App.FixedLossesUI.ValueText + extra_text);

      end  % if
    end  % function

    function callback_get_parameters(App)
      %%
      % Get parameters from the selected block and load them to the app.

      App.BlockPath = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      block_path = App.BlockPath;

      load_system(extractBefore(block_path, "/"))

      mask_type = string(get_param(block_path, "MaskType"));
      if mask_type == "Motor & Drive"
        % "Motor & Drive" block from Simscape Driveline.
        motor_model_type = "Simplified";

      else
        % Assume "Motor & Drive (System Level)" block from Simscape Electrical.
        motor_model_type = "Full";

      end  % if

      % Create a data set object from the specified block path.
      % If block parameters refer to workspace variables, the workspace variables must be loaded upfront.
      % This updates the derived parameters too.
      try
        App.DataSet = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet(BlockPath=block_path);
      catch exception
        if App.MainFigure.Visible
          msg = exception.message;
          title_word = bevutil1.CodeUtil.i18n("Error");
          uialert(App.MainFigure, msg, title_word)

          return

        else

          rethrow(exception)

        end  % if
      end  % try, catch

      % -----------------------------------------------------------------------
      % Prevent the plot auto update while updating UI components.
      prev_value = App.UpdateButtonUI.CheckBoxUI.Value;
      App.UpdateButtonUI.CheckBoxUI.Value = false;
      % -----------------------------------------------------------------------

      App.MaxTorqueUI.UnitText = get_param(block_path, "torque_max_unit");
      App.MaxTorqueUI.ValueText = get_param(block_path, "torque_max");

      App.MaxPowerUI.UnitText = get_param(block_path, "power_max_unit");
      App.MaxPowerUI.ValueText = get_param(block_path, "power_max");

      App.ElectricalEfficiencyPercentUI.ValueText = get_param(block_path, "eff");

      App.MeasuredAngularSpeedUI.UnitText = get_param(block_path, "w_eff_unit");
      App.MeasuredAngularSpeedUI.ValueText = get_param(block_path, "w_eff");

      App.MeasuredTorqueUI.UnitText = get_param(block_path, "T_eff_unit");
      App.MeasuredTorqueUI.ValueText = get_param(block_path, "T_eff");

      if motor_model_type == "Simplified"
        App.MeasuredIronLossesUI.SimscapeValue = simscape.Value(0, "W");
        App.FixedLossesUI.SimscapeValue = simscape.Value(0, "W");

      else
        App.MeasuredIronLossesUI.UnitText = get_param(block_path, "Piron_unit");
        App.MeasuredIronLossesUI.ValueText = get_param(block_path, "Piron");

        App.FixedLossesUI.UnitText = get_param(block_path, "Pbase_unit");
        App.FixedLossesUI.ValueText = get_param(block_path, "Pbase");

      end  % if

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
        % Get "a" from  "a.b", "a.b.c", etc.
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

      setupUI("MaxAngularSpeedMode")
      setupUI("MaxAngularSpeed")
      setupUI("MaxTorque")
      setupUI("MaxPower")

      setupUI("ElectricalEfficiencyPercent")
      setupUI("MeasuredAngularSpeed")
      setupUI("MeasuredTorque")

      setupUI("MeasuredIronLosses")
      setupUI("FixedLosses")

      setupUI("PlotAutoRange")
      setupUI("PlotAngularSpeedUpperBound")
      setupUI("PlotTorqueUpperBound")
      setupUI("PlotContourLevelsPercent")

      updateApp(App)

      function setupUI(target_name)
        % Calling setupUI("MaxTorque") yields the following.
        %   App.MaxTorqueUI.ValueText = struct_name + "." + "MaxTorque";
        component_type = string(class(App.(target_name + "UI")));
        if endsWith(component_type, "Component.PhysicalValueWithUnitDropDown") ...
            || endsWith(component_type, "Component.PhysicalValueWithUnitLabel")
          property_name = "ValueText";
        elseif endsWith(component_type, "Component.PhysicalUnitDropDown")
          property_name = "UnitText";
        elseif endsWith(component_type, "Component.CheckBox") ...
            || endsWith(component_type, "Component.DropDown")
          property_name = "Value";
        end  % if
        try
          previous_data = App.(target_name + "UI").(property_name);
        catch exception
          % Skip if the specified name has no corresponding ValueText. Do not throw an exception.
          disp(exception.message)

          return

        end  % try, catch
        % struct_text is something like "Params.Motor.MaxTorque".
        % It must exist in the base workspace.
        struct_text = struct_name + "." + target_name;
        try
          if endsWith(component_type, "Component.PhysicalValueWithUnitDropDown") ...
              || endsWith(component_type, "Component.PhysicalValueWithUnitLabel")
            App.(target_name + "UI").ValueText = struct_text;
          elseif endsWith(component_type, "Component.PhysicalUnitDropDown")
            App.(target_name + "UI").UnitText = struct_text;
          elseif endsWith(component_type, "Component.CheckBox")
            App.(target_name + "UI").Value = matlab.lang.OnOffSwitchState(evalin("base", struct_text + ";"));
          elseif endsWith(component_type, "Component.DropDown")
            App.(target_name + "UI").Value = evalin("base", struct_text + ";");
          end  % if
        catch exception
          % Recover the previous data if there was an error.
          % !todo: Report the error?
          App.(target_name + "UI").(property_name) = previous_data;
        end  % try, catch
      end  % nested function
    end  % function

    function updateApp(App, NameValuePair)
      %%
      arguments (Input)
        App (1,1)

        NameValuePair.PlotMode (1,1) string ...
          { mustBeMember(NameValuePair.PlotMode, ["auto", "skip", "force"]) } = "auto"
      end  % arguments

      % .......................................................................
      % Transfer data from the UI components to the data set.

      App.DataSet.MaxAngularSpeedMode = App.MaxAngularSpeedModeUI.MainDropDown.Value;

      safeupdate_DataSet_from_SimscapeValue("MaxAngularSpeed", "MaxAngularSpeedUI")

      if App.DataSet.MaxAngularSpeedMode == "auto"
        App.MaxAngularSpeedUI.ValueTextUI.MainEditField.Enable = "off";
        % Setting InfoText to "" hides the info UI.
        App.MaxAngularSpeedUI.InfoText = "";
        App.MaxAngularSpeedUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "off";
      else
        App.MaxAngularSpeedUI.ValueTextUI.MainEditField.Enable = "on";
        App.MaxAngularSpeedUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "on";
      end  % if

      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MaxTorque", "MaxTorqueUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MaxPower", "MaxPowerUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "ElectricalEfficiencyPercent", "ElectricalEfficiencyPercentUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MeasuredAngularSpeed", "MeasuredAngularSpeedUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MeasuredTorque", "MeasuredTorqueUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "FixedLosses", "FixedLossesUI")
      safeupdate_DataSet_from_SimscapeValue("ModelParams", "MeasuredIronLosses", "MeasuredIronLossesUI")

      App.DataSet.PlotAutoRange = App.PlotAutoRangeUI.Value;
      if App.PlotAutoRangeUI.Value
        % Plot auto range is on.
        % Make ValueTextUI and UnitDropDownUI read-only.

        App.PlotAngularSpeedUpperBoundUI.ValueTextUI.MainEditField.Enable = "off";
        % Setting InfoText to "" hides the info UI.
        App.PlotAngularSpeedUpperBoundUI.InfoText = "";
        App.PlotAngularSpeedUpperBoundUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "off";

        App.PlotTorqueUpperBoundUI.ValueTextUI.MainEditField.Enable = "off";
        % Setting InfoText to "" hides the info UI.
        App.PlotTorqueUpperBoundUI.InfoText = "";
        App.PlotTorqueUpperBoundUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "off";
      else
        % Plot auto range is off.

        App.PlotAngularSpeedUpperBoundUI.ValueTextUI.MainEditField.Enable = "on";
        App.PlotAngularSpeedUpperBoundUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "on";

        App.PlotTorqueUpperBoundUI.ValueTextUI.MainEditField.Enable = "on";
        App.PlotTorqueUpperBoundUI.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "on";

        safeupdate_DataSet_from_SimscapeValue("PlotAngularSpeedUpperBound", "PlotAngularSpeedUpperBoundUI")
        safeupdate_DataSet_from_SimscapeValue("PlotTorqueUpperBound", "PlotTorqueUpperBoundUI")

      end  % if

      safeupdate_DataSet_from_SimscapeValue("PlotContourLevelsPercent", "PlotContourLevelsPercentUI")
      safeupdate_DataSet_from_SimscapeValue("PlotPowers", "PlotPowersUI")

      function safeupdate_DataSet_from_SimscapeValue(varargin)
        % A 3-argument call to this function such as
        %   safeupdate_DataSet_from_SimscapeValue("ModelParams", "VehicleMass", "VehicleMassUI")
        % corresponds to
        %   App.DataSet.ModelParams.VehicleMass = App.VehicleMassUI.SimscapeValue;
        %
        % A 2-argument call to this function such as
        %   safeupdate_DataSet_from_SimscapeValue("PlotSpeedUpperBound", "PlotSpeedUpperBoundUI")
        % correspond to
        %   App.DataSet.PlotSpeedUpperBound = App.PlotSpeedUpperBoundUI.SimscapeValue;
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

      saved_dataset = App.DataSet;
      try
        App.DataSet = updateDataSet(App.DataSet);

        if App.PlotAutoRangeUI.Value
          App.PlotAngularSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotAngularSpeedUpperBound;
          App.PlotTorqueUpperBoundUI.SimscapeValue = App.DataSet.PlotTorqueUpperBound;
        end
      catch exception
        App.DataSet = rollbackUI(App, saved_dataset);
        updateApp(App, PlotMode="skip")

        msg = exception.message;
        window_title = bevutil1.CodeUtil.i18n("Error");
        uialert(App.MainFigure, msg, window_title)

        return

      end  % try, catch

      % .......................................................................
      % Update UI components for derived parameters

      update_DerivedParameterUI(App, "MeasuredNominalLosses")

      App.IronToNominalLossRatioPercentUI.ValueTextUI.MainEditField.Value = ...
        string(App.DataSet.ModelParams.IronToNominalLossRatioPercent);

      update_DerivedParameterUI(App, "MeasuredCopperLosses")
      update_DerivedParameterUI(App, "MeasuredIronLossCoefficient")
      update_DerivedParameterUI(App, "MeasuredCopperLossCoefficient")

      % -----------------------------------------------------------------------
      if NameValuePair.PlotMode == "skip"

        return

      elseif NameValuePair.PlotMode == "force" ...
          || ((NameValuePair.PlotMode == "auto") && App.UpdateButtonUI.CheckBoxUI.Value)
        bevutil1.app.AbstractMotorEfficiency.plotAbstractMotorEfficiency( ...
          ParentAxes = App.AxesUI.MainAxes, ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % if
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
      App.(ParamName + "UI").ValueText = string(value(current_simscape_value, current_unit));
    end  % function

    function dataset = rollbackUI(App, saved_dataset)
      %%
      App.DataSet = saved_dataset;

      App.MaxAngularSpeedModeUI.MainDropDown.Value = App.DataSet.MaxAngularSpeedMode;
      App.MaxAngularSpeedUI.SimscapeValue = App.DataSet.MaxAngularSpeed;
      App.MaxTorqueUI.SimscapeValue = App.DataSet.ModelParams.MaxTorque;
      App.MaxPowerUI.SimscapeValue = App.DataSet.ModelParams.MaxPower;
      App.ElectricalEfficiencyPercentUI.SimscapeValue = App.DataSet.ModelParams.ElectricalEfficiencyPercent;
      App.MeasuredAngularSpeedUI.SimscapeValue = App.DataSet.ModelParams.MeasuredAngularSpeed;
      App.MeasuredTorqueUI.SimscapeValue = App.DataSet.ModelParams.MeasuredTorque;
      App.FixedLossesUI.SimscapeValue = App.DataSet.ModelParams.FixedLosses;
      App.MeasuredIronLossesUI.SimscapeValue = App.DataSet.ModelParams.MeasuredIronLosses;
      App.PlotAutoRangeUI.Value = App.DataSet.PlotAutoRange;
      App.PlotAngularSpeedUpperBoundUI.SimscapeValue = App.DataSet.PlotAngularSpeedUpperBound;
      App.PlotTorqueUpperBoundUI.SimscapeValue = App.DataSet.PlotTorqueUpperBound;
      App.PlotPowersUI.SimscapeValue = App.DataSet.PlotPowers;

      dataset = updateDataSet(App.DataSet);

    end  % function

  end  % methods
end  % classdef
