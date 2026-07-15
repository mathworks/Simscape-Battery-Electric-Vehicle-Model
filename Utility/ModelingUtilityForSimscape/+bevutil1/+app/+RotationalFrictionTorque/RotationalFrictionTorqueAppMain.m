classdef RotationalFrictionTorqueAppMain < handle
  % App for visualizing the rotational friction torque model.
  %
  % This is an app for exploring the parameters of the rotational friction torque model,
  % which is used by the Rotational Friction block in Simscape.
  % The app is a standalone MATLAB program, i.e., it is independent of the block.
  %
  % Launching the app without options opens the app in stand alone mode, where
  % the app does not load a model and link to Rotational Friction blocks.
  %
  % To open the app with a Rotational Friction block in a model, use the BlockPath option.
  % To open the app with a model, use the ModelName option.
  % BlockPath is used if both BlockPath and ModelName options are specified.

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "RotationalFrictionTorqueAppMain:"
  end  % properties
  properties

    DataSet (1,1) bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet

    AppParameterStructName (1,1) string = ""

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""
    ModelFileFullPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    MainFigure matlab.ui.Figure
    Window bevutil1.AppUtil.AppWindow

    WindowWidth (1,1) double {mustBeInteger, mustBePositive} = 1060
    LeftSideWidth (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"
    RightSideWidth (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"

    WindowHeight (1,1) double {mustBeInteger, mustBePositive} = 640
    PlotUIHeight (1,1) double {mustBeInteger, mustBePositive} = 380

    DocLinkUI bevutil1.AppUtil.Component.Hyperlink

    BreakawayTorqueUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    BreakawayVelocityUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    CoulombTorqueUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    ViscousCoefficientUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    StribeckScaledTorqueUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    StribeckThresholdVelocityUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown
    CoulombThresholdVelocityUI bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown

    UpdateButtonUI bevutil1.AppUtil.Component.EnabledButton
    OpenInFigureWindowUI bevutil1.AppUtil.Component.Hyperlink
    AxesUI bevutil1.AppUtil.Graphics.Axes

    ShowStribeckTorqueUI bevutil1.AppUtil.Component.CheckBox
    ShowCoulombTorqueUI bevutil1.AppUtil.Component.CheckBox
    ShowViscousTorqueUI bevutil1.AppUtil.Component.CheckBox

    PlotAngularVelocityUnitUI bevutil1.AppUtil.Component.PhysicalUnitDropDown
    PlotTorqueUnitUI bevutil1.AppUtil.Component.PhysicalUnitDropDown

    StructParameterUI bevutil1.AppUtil.Component.BaseWorkspaceStructParameterUI
    AppBlockSelectorUI bevutil1.AppUtil.Component.BlockSelectorUI

  end  % properties
  properties (Constant, Access=private)

    TargetSimscapeBlockNames = "Rotational Friction"

    angular_speed_unit_items = ["rpm", "rad/s", "rev/s"]
    torque_unit_items = ["N*m", "lbf*ft"]
    fric_coeff_unit_items = ["N*m/rpm", "N*m/(rad/s)", "N*m/(rev/s)", "lbf*ft/rpm"]

    width_unit = bevutil1.AppUtil.Constant.Width{"unitwidth"}
    unit_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
    button_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12

  end  % properties

  methods

    function App = RotationalFrictionTorqueAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.AppParameterFileName (1,1) string = ""
        NameValuePair.AppParameterStructName (1,1) string = ""

        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      App.DataSet = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet(Initialization=true);

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
      App.Window.Name = bevutil1.CodeUtil.i18n("Rotational Friction Torque");
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
          msg = bevutil1.CodeUtil.i18n("AppParameterStructName is required when AppParameterFileName is specified.");

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

        if App.BlockPath ~= ""
          % Override the settings if the block path is specified.
          setupWithBlock()
        end  % if

      elseif (NameValuePair.AppParameterFileName == "") && (App.BlockPath ~= "")
        % Set up the app with the block settings.
        setupWithBlock()

      else
        % Default settings.

        App.BreakawayTorqueUI.SimscapeValue = App.DataSet.ModelParams.BreakawayTorque;
        App.BreakawayVelocityUI.SimscapeValue = App.DataSet.ModelParams.BreakawayVelocity;
        App.CoulombTorqueUI.SimscapeValue = App.DataSet.ModelParams.CoulombTorque;
        App.ViscousCoefficientUI.SimscapeValue = App.DataSet.ModelParams.ViscousCoefficient;

        App.ShowStribeckTorqueUI.Value = App.DataSet.ShowStribeckTorque;
        App.ShowCoulombTorqueUI.Value = App.DataSet.ShowCoulombTorque;
        App.ShowViscousTorqueUI.Value = App.DataSet.ShowViscousTorque;
        App.PlotAngularVelocityUnitUI.UnitText = App.DataSet.PlotAngularVelocityUnit;
        App.PlotTorqueUnitUI.UnitText = App.DataSet.PlotTorqueUnit;
      end  % if

      function setupWithBlock
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
      end  % nested function

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
      description_link_ui.HyperlinkClickedCallback = @() web("RotationalFrictionTorqueApp_Description_bevutil1.html");

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.ComponentHeight = bevutil1.AppUtil.Constant.Height{"oneline"} * 4;
      label_ui.Text = join([
        "The Rotational Friction block in Simscape represents friction in contact between rotating bodies."
        "The friction torque $T$ is simulated as a function of relative velocity $\omega$ and"
        "is assumed to be the sum of Stribeck, Coulomb, and viscous components."
        ], " ");
      label_ui.WordWrap = "on";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.ComponentHeight = bevutil1.AppUtil.Constant.Height{"oneline"} * 2 + 10;
      label_ui.Text = join( [
        "$"
        "T(\omega) = T_{S} \cdot \frac{\omega}{\omega_{S}}"
        "\cdot \exp \left( - \left( \frac{\omega}{\omega_{S}} \right)^2 \right)"
        "+ T_C \cdot \tanh \left( \frac{\omega}{\omega_{C}} \right) + f \cdot \omega"
        "$"
        ], " ");
      label_ui.HorizontalAlignment = "center";
      label_ui.WordWrap = "off";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.Text = bevutil1.CodeUtil.i18n("Rotational Friction block:");
      label_ui.ComponentWidth = App.width_unit * 19;

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.DocLinkUI = bevutil1.AppUtil.Component.Hyperlink(h_layout);
      App.DocLinkUI.Text = bevutil1.CodeUtil.i18n("Documentation");
      App.DocLinkUI.HyperlinkClickedCallback = @() web("https://www.mathworks.com/help/simscape/ref/rotationalfriction.html");

      h_layout = addHorizontalGridLayout(h_container);
      ssc_link_ui = bevutil1.AppUtil.Component.Hyperlink(h_layout);
      ssc_link_ui.Text = bevutil1.CodeUtil.i18n("Simscape source");
      ssc_link_ui.HyperlinkClickedCallback = @() ...
        open(string(matlabroot) + filesep + ...
        fullfile("toolbox", "physmod", "simscape", "library", "m") + filesep + ...
        fullfile("+foundation", "+mechanical", "+rotational", "friction.ssc"));

      %% ======================================================================
      % Parameters

      name_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 22;

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\bf{" + bevutil1.CodeUtil.i18n("Parameters") + "}";

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.BreakawayTorqueUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.BreakawayTorqueUI.Editable = "on";
      App.BreakawayTorqueUI.NameText = bevutil1.CodeUtil.i18n("Breakaway friction torque, $T_{B}$");
      App.BreakawayTorqueUI.NameUIWidth = name_ui_width;
      App.BreakawayTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.BreakawayTorqueUI.UnitItems = App.torque_unit_items;
      App.BreakawayTorqueUI.ValueChangedCallback = @() updateApp(App);
      App.BreakawayTorqueUI.UnitChangedCallback = @() updateApp(App);

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.BreakawayVelocityUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.BreakawayVelocityUI.Editable = "on";
      App.BreakawayVelocityUI.NameText = bevutil1.CodeUtil.i18n("Breakaway friction velocity, $\omega_{B}$");
      App.BreakawayVelocityUI.NameUIWidth = name_ui_width;
      App.BreakawayVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.BreakawayVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.BreakawayVelocityUI.ValueChangedCallback = @() updateApp(App);
      App.BreakawayVelocityUI.UnitChangedCallback = @() updateApp(App);

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.CoulombTorqueUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.CoulombTorqueUI.Editable = "on";
      App.CoulombTorqueUI.NameText = bevutil1.CodeUtil.i18n("Coulomb friction torque, $T_{C}$");
      App.CoulombTorqueUI.NameUIWidth = name_ui_width;
      App.CoulombTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.CoulombTorqueUI.UnitItems = App.torque_unit_items;
      App.CoulombTorqueUI.ValueChangedCallback = @() updateApp(App);
      App.CoulombTorqueUI.UnitChangedCallback = @() updateApp(App);

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.ViscousCoefficientUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.ViscousCoefficientUI.Editable = "on";
      App.ViscousCoefficientUI.NameText = bevutil1.CodeUtil.i18n("Viscous friction coefficient, $f$");
      App.ViscousCoefficientUI.NameUIWidth = name_ui_width;
      App.ViscousCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.ViscousCoefficientUI.UnitItems = App.fric_coeff_unit_items;
      App.ViscousCoefficientUI.ValueChangedCallback = @() updateApp(App);
      App.ViscousCoefficientUI.UnitChangedCallback = @() updateApp(App);

      %% ======================================================================
      % Derived parameters

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(appleft_v_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Derived parameters") + "}";

      component_height = bevutil1.AppUtil.Constant.Height{"oneline++"} * 2;

      name_ui_width = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 26;

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.StribeckScaledTorqueUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.StribeckScaledTorqueUI.Editable = "on";
      App.StribeckScaledTorqueUI.ComponentHeight = component_height;
      App.StribeckScaledTorqueUI.NameUIWidth = name_ui_width;
      App.StribeckScaledTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.StribeckScaledTorqueUI.UnitItems = App.torque_unit_items;
      App.StribeckScaledTorqueUI.ReadOnlyValueText = true;
      App.StribeckScaledTorqueUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "StribeckScaledTorque");
      App.StribeckScaledTorqueUI.NameText = ...
        bevutil1.CodeUtil.i18n("Scale factor for Stribeck torque") + newline + "$T_{S} = \sqrt{2e} (T_{B} - T_{C})$";

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.StribeckThresholdVelocityUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.StribeckThresholdVelocityUI.Editable = "on";
      App.StribeckThresholdVelocityUI.ComponentHeight = component_height;
      App.StribeckThresholdVelocityUI.NameUIWidth = name_ui_width;
      App.StribeckThresholdVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.StribeckThresholdVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.StribeckThresholdVelocityUI.ReadOnlyValueText = true;
      App.StribeckThresholdVelocityUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "StribeckThresholdVelocity");
      App.StribeckThresholdVelocityUI.NameText = ...
        bevutil1.CodeUtil.i18n("Velocity threshold for Stribeck torque") + newline + "$\omega_{S} = \omega_{B} \sqrt{2}$";

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.CoulombThresholdVelocityUI = bevutil1.AppUtil.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.CoulombThresholdVelocityUI.Editable = "on";
      App.CoulombThresholdVelocityUI.ComponentHeight = component_height;
      App.CoulombThresholdVelocityUI.NameUIWidth = name_ui_width;
      App.CoulombThresholdVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.CoulombThresholdVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.CoulombThresholdVelocityUI.ReadOnlyValueText = true;
      App.CoulombThresholdVelocityUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "CoulombThresholdVelocity");
      App.CoulombThresholdVelocityUI.NameText = ...
        bevutil1.CodeUtil.i18n("Velocity threshold for Coulomb torque") + newline + "$\omega_{C} = \omega_{B} / 10$";

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
      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() open_in_figure_window();
      function open_in_figure_window
        bevutil1.app.RotationalFrictionTorque.plotRotationalFrictionTorque( ...
          ParentAxes = axes(figure), ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % nested function

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container, Height="fit");

      App.AxesUI = bevutil1.AppUtil.Graphics.Axes(appright_v_layout);
      App.AxesUI.ComponentHeight = App.PlotUIHeight;

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appright_v_layout);

      % Torque components .....................................................

      h_layout = addHorizontalGridLayout(h_container, Width=(bevutil1.AppUtil.Constant.Width{"unitwidth"} * 18));
      label_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Torque components") + "}";
      label_ui.HorizontalAlignment = "center";

      h_layout = addHorizontalGridLayout(h_container);
      App.ShowStribeckTorqueUI = bevutil1.AppUtil.Component.CheckBox(h_layout);
      App.ShowStribeckTorqueUI.Text = bevutil1.CodeUtil.i18n("Stribeck");
      App.ShowStribeckTorqueUI.ValueChangedCallback = @() updateApp(App);

      h_layout = addHorizontalGridLayout(h_container);
      App.ShowCoulombTorqueUI = bevutil1.AppUtil.Component.CheckBox(h_layout);
      App.ShowCoulombTorqueUI.Text = bevutil1.CodeUtil.i18n("Coulomb");
      App.ShowCoulombTorqueUI.ValueChangedCallback = @() updateApp(App);

      h_layout = addHorizontalGridLayout(h_container);
      App.ShowViscousTorqueUI = bevutil1.AppUtil.Component.CheckBox(h_layout);
      App.ShowViscousTorqueUI.Text = bevutil1.CodeUtil.i18n("Viscous");
      App.ShowViscousTorqueUI.ValueChangedCallback = @() updateApp(App);

      % -----------------------------------------------------------------------
      % Plot unit

      % Angular speed (velocity) ..............................................
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appright_v_layout);

      % Give a small indent on the left side.
      addHorizontalGridLayout(h_container, Width=(bevutil1.AppUtil.Constant.Width{"unitwidth"} * 2));

      h_layout = addHorizontalGridLayout(h_container);
      label1_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label1_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Plot unit") + "}";
      label1_ui.ComponentWidth = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 7;
      label1_ui.HorizontalAlignment = "center";

      h_layout = addHorizontalGridLayout(h_container);
      label2_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label2_ui.Text = bevutil1.CodeUtil.i18n("Angular velocity");
      % label2_ui.ComponentWidth = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12;
      % label_ui.HorizontalAlignment = "right";

      h_layout = addHorizontalGridLayout(h_container);
      App.PlotAngularVelocityUnitUI = bevutil1.AppUtil.Component.PhysicalUnitDropDown(h_layout);
      App.PlotAngularVelocityUnitUI.Editable = "on";
      App.PlotAngularVelocityUnitUI.UnitItems = App.angular_speed_unit_items;
      App.PlotAngularVelocityUnitUI.ComponentWidth = App.unit_ui_width;
      App.PlotAngularVelocityUnitUI.UnitChangedCallback = @() updateApp(App);

      % Torque ................................................................
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(appright_v_layout);

      % Give a small indent on the left side.
      addHorizontalGridLayout(h_container, Width=(bevutil1.AppUtil.Constant.Width{"unitwidth"} * 2));

      h_layout = addHorizontalGridLayout(h_container);
      label1_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label1_ui.Text = "";
      label1_ui.ComponentWidth = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 7;

      h_layout = addHorizontalGridLayout(h_container);
      label2_ui = bevutil1.AppUtil.Component.Label(h_layout);
      label2_ui.Text = "Torque";
      % label2_ui.ComponentWidth = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 7;

      h_layout = addHorizontalGridLayout(h_container);
      App.PlotTorqueUnitUI = bevutil1.AppUtil.Component.PhysicalUnitDropDown(h_layout);
      App.PlotTorqueUnitUI.Editable = "on";
      App.PlotTorqueUnitUI.UnitItems = App.torque_unit_items;
      App.PlotTorqueUnitUI.ComponentWidth = App.unit_ui_width;
      App.PlotTorqueUnitUI.UnitChangedCallback = @() updateApp(App);

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

      % This callback can run only when a valid block path is selected in the block path drop down UI.
      % Thus, accessing App.BlockPathDropDownUI.Value here is safe, i.e., no error check is necessary.
      block_path = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");
      App.BlockPath = block_path;

      load_system(block_path)

      % If the UI component's ValueText contains a simscape.Value, use the unit
      % defined in it for transferring to the block parameter setting by appending
      % .value("<unit>") text. Also set up the block parameter's unit to be
      % the same as the simscape.Value's unit.

      set_param(block_path, "brkwy_trq_unit", App.BreakawayTorqueUI.UnitText);
      if App.BreakawayTorqueUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.BreakawayTorqueUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "brkwy_trq", App.BreakawayTorqueUI.ValueText + extra_text);

      set_param(block_path, "brkwy_vel_unit", App.BreakawayVelocityUI.UnitText);
      if App.BreakawayVelocityUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.BreakawayVelocityUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "brkwy_vel", App.BreakawayVelocityUI.ValueText + extra_text);

      set_param(block_path, "Col_trq_unit", App.CoulombTorqueUI.UnitText);
      if App.CoulombTorqueUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.CoulombTorqueUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "Col_trq", App.CoulombTorqueUI.ValueText + extra_text);

      set_param(block_path, "visc_coef_unit", App.ViscousCoefficientUI.UnitText);
      if App.ViscousCoefficientUI.ValueTextIsSimscapeValue
        extra_text = ".value(""" + App.ViscousCoefficientUI.UnitText + """)";
      else
        extra_text = "";
      end  % if
      set_param(block_path, "visc_coef", App.ViscousCoefficientUI.ValueText + extra_text);

    end  % function

    function callback_get_parameters(App)
      %%
      % This function gets parameters from the selected block and loads them to the app.

      App.BlockPath = replace(App.AppBlockSelectorUI.BlockPathDropDownUI.Value, " / ", "/");

      load_system(App.BlockPath)

      % Create a data object from the specified block path.
      % If block parameters refer to workspace variables,
      % the workspace variables must be loaded upfront.
      % This updates the derived parameters too.
      try
        App.DataSet = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet(BlockPath=App.BlockPath);
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

      block_path = App.BlockPath;

      App.BreakawayTorqueUI.UnitText = get_param(block_path, "brkwy_trq_unit");
      App.BreakawayTorqueUI.ValueText = get_param(block_path, "brkwy_trq");

      App.BreakawayVelocityUI.UnitText = get_param(block_path, "brkwy_vel_unit");
      App.BreakawayVelocityUI.ValueText = get_param(block_path, "brkwy_vel");

      App.CoulombTorqueUI.UnitText = get_param(block_path, "Col_trq_unit");
      App.CoulombTorqueUI.ValueText = get_param(block_path, "Col_trq");

      App.ViscousCoefficientUI.UnitText = get_param(block_path, "visc_coef_unit");
      App.ViscousCoefficientUI.ValueText = get_param(block_path, "visc_coef");

      if not(App.MainFigure.Visible)
        % Set up parameters that are not block parameters. (Use the default values.)
        data_set = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueDataSet(Initialization=true);

        App.ShowStribeckTorqueUI.Value = data_set.ShowStribeckTorque;
        App.ShowCoulombTorqueUI.Value = data_set.ShowCoulombTorque;
        App.ShowViscousTorqueUI.Value = data_set.ShowViscousTorque;

        App.PlotAngularVelocityUnitUI.UnitText = data_set.PlotAngularVelocityUnit;
        App.PlotTorqueUnitUI.UnitText = data_set.PlotTorqueUnit;

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

      App.AppParameterStructName = struct_name;
      % The specified struct must have the struct fields as coded below.

      % -----------------------------------------------------------------------
      % ModelParameters properties, only those used by this app.

      setupUI("BreakawayTorque", "ValueText")
      setupUI("BreakawayVelocity", "ValueText")
      setupUI("CoulombTorque", "ValueText")
      setupUI("ViscousCoefficient", "ValueText")

      % -----------------------------------------------------------------------
      % DataSet > Visualization parameters

      setupUI("ShowStribeckTorque", "Value")
      setupUI("ShowCoulombTorque", "Value")
      setupUI("ShowViscousTorque", "Value")

      setupUI("PlotAngularVelocityUnit", "UnitText")
      setupUI("PlotTorqueUnit", "UnitText")

      % -----------------------------------------------------------------------
      updateApp(App)

      function setupUI(target_name, property_name)
        % Property name:
        %   "ValueText" for PhysicalValueWithUnitDropDown
        %   "Value" for CheckBox
        %   "UnitText" for PhysicalUnitDropDown
        %
        % Calling setupUI("BreakawayTorque", "ValueText") yields the following.
        %   App.BreakawayTorqueUI.ValueText = struct_name + "." + "BreakawayTorque";

        previous_data = App.(target_name + "UI").(property_name);

        % Struct text is something like "Params.Friction2.ShowStribeckTorque".
        % It must exist in the base workspace.
        struct_text = struct_name + "." + target_name;
        try
          if property_name == "ValueText"
            % PhysicalValueWithUnitDropDown
            App.(target_name + "UI").(property_name) = struct_text;
          elseif property_name == "Value"
            % CheckBox
            App.(target_name + "UI").Value = matlab.lang.OnOffSwitchState(evalin("base", struct_text));
          else
            % PhysicalUnitDropDown
            App.(target_name + "UI").UnitText = evalin("base", struct_text);
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
      end  % if

      % .......................................................................
      % Transfer data from the UI components to the data set.

      safeupdate_DataSetModelParams_from_SimscapeValue("BreakawayTorque")
      safeupdate_DataSetModelParams_from_SimscapeValue("BreakawayVelocity")
      safeupdate_DataSetModelParams_from_SimscapeValue("CoulombTorque")
      safeupdate_DataSetModelParams_from_SimscapeValue("ViscousCoefficient")

      App.DataSet.ShowStribeckTorque = App.ShowStribeckTorqueUI.Value;
      App.DataSet.ShowCoulombTorque = App.ShowCoulombTorqueUI.Value;
      App.DataSet.ShowViscousTorque = App.ShowViscousTorqueUI.Value;

      App.DataSet.PlotAngularVelocityUnit = App.PlotAngularVelocityUnitUI.UnitText;
      App.DataSet.PlotTorqueUnit = App.PlotTorqueUnitUI.UnitText;

      function safeupdate_DataSetModelParams_from_SimscapeValue(target_name)
        try
          previous_data = App.DataSet.ModelParams.(target_name);
          App.DataSet.ModelParams.(target_name) = App.(target_name + "UI").SimscapeValue;
        catch exception
          App.(target_name + "UI").SimscapeValue = previous_data;
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
        App.BreakawayTorqueUI.SimscapeValue = App.DataSet.ModelParams.BreakawayTorque;
        App.BreakawayVelocityUI.SimscapeValue = App.DataSet.ModelParams.BreakawayVelocity;
        App.CoulombTorqueUI.SimscapeValue = App.DataSet.ModelParams.CoulombTorque;
        App.ViscousCoefficientUI.SimscapeValue = App.DataSet.ModelParams.ViscousCoefficient;
        App.ShowStribeckTorqueUI.Value = App.DataSet.ShowStribeckTorque;
        App.ShowCoulombTorqueUI.Value = App.DataSet.ShowCoulombTorque;
        App.ShowViscousTorqueUI.Value = App.DataSet.ShowViscousTorque;
        App.PlotAngularVelocityUnitUI.UnitText = App.DataSet.PlotAngularVelocityUnit;
        App.PlotTorqueUnitUI.UnitText = App.DataSet.PlotTorqueUnit;

        App.DataSet = updateDataSet(App.DataSet);
        updateApp(App, PlotMode="skip")

        msg = exception.message;
        window_title = bevutil1.CodeUtil.i18n("Error");
        uialert(App.MainFigure, msg, window_title)

        return

      end  % try, catch

      % .......................................................................
      % Update UI components for derived parameters

      update_DerivedParameterUI(App, "StribeckScaledTorque")
      update_DerivedParameterUI(App, "StribeckThresholdVelocity")
      update_DerivedParameterUI(App, "CoulombThresholdVelocity")

      % -----------------------------------------------------------------------
      if NameValuePair.PlotMode == "skip"

        return

      elseif NameValuePair.PlotMode == "force" ...
          || ((NameValuePair.PlotMode == "auto") && App.UpdateButtonUI.CheckBoxUI.Value)
        bevutil1.app.RotationalFrictionTorque.plotRotationalFrictionTorque( ...
          ParentAxes = App.AxesUI.MainAxes, ...
          DataSource="dataset", DataSet=App.DataSet)
      end  % if
    end  % function

    function update_DerivedParameterUI(App, ParamName)
      %%
      arguments (Input)
        App (1,1)
        ParamName (1,1) string
      end  % arguments
      current_unit = App.(ParamName + "UI").UnitDropDownUI.UnitText;
      current_simscape_value = App.DataSet.ModelParams.(ParamName);
      App.(ParamName + "UI").ValueText = string(value(current_simscape_value, current_unit));
    end  % function

  end  % methods
end  % classdef
