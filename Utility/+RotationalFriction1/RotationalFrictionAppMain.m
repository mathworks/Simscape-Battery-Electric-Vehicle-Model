classdef RotationalFrictionAppMain < handle
  % Rotational friction app
  %
  % This is an app for exploring the model parameters of the rotational friction torque model,
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
    errorID (1,1) string = "RotationalFrictionAppMain:"
  end  % properties

  properties

    DataSet (1,1) RotationalFriction1.RotationalFrictionDataSet ...
      = RotationalFriction1.RotationalFrictionDataSet(Initialization = true)

    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""
    ModelFileFullPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    MainFigure matlab.ui.Figure
    Window AppUtil1.AppWindow

    DocLinkUI AppUtil1.Component.Hyperlink

    BreakawayTorqueUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    BreakawayVelocityUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    CoulombTorqueUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    ViscousCoefficientUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    StribeckScaledTorqueUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    StribeckThresholdVelocityUI AppUtil1.Component.PhysicalValueWithUnitDropDown
    CoulombThresholdVelocityUI AppUtil1.Component.PhysicalValueWithUnitDropDown

    PlotButtonUI AppUtil1.Component.EnabledButton
    OpenInFigureWindowUI AppUtil1.Component.Hyperlink
    AxesUI AppUtil1.Graphics.Axes

    ShowStribeckTorqueUI AppUtil1.Component.CheckBox
    ShowCoulombTorqueUI AppUtil1.Component.CheckBox
    ShowViscousTorqueUI AppUtil1.Component.CheckBox

    PlotTorqueUnitUI AppUtil1.Component.PhysicalUnitDropDown
    PlotVelocityUnitUI AppUtil1.Component.PhysicalUnitDropDown

    AppBlockSelectorUI AppUtil1.Component.BlockSelectorUI
  end  % properties

  properties (Constant, Access=private)

    TargetSimscapeBlockNames = "Rotational Friction"

    angular_speed_unit_items = ["rpm", "rad/s", "rev/s"]
    torque_unit_items = ["N*m", "lbf*ft"]
    fric_coeff_unit_items = ["N*m/rpm", "N*m/(rad/s)", "N*m/(rev/s)", "lbf*ft/rpm"]

    app_window_width = 1100
    right_pane_width = 550

    width_unit = AppUtil1.Constant.Width{"unitwidth"}
    name_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 28
    unit_ui_width = AppUtil1.Constant.Width{"unitwidth"} * 12
    button_width = AppUtil1.Constant.Width{"unitwidth"} * 12
  end  % properties

  methods

    function App = RotationalFrictionAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
        NameValuePair.ModelName (1,1) string = ""

        % The list of mustBeMember cannot be a class property even if it is constant.
        NameValuePair.PlotTorqueUnit (1,1) string = ""
        NameValuePair.PlotVelocityUnit (1,1) string = ""
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
      App.Window.Name = CodeUtil1.i18n("Rotational Friction");
      App.Window.Width = App.app_window_width;
      App.Window.Height = 560;

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
        App.DataSet = RotationalFriction1.RotationalFrictionDataSet(Initialization=true);

        App.BreakawayTorqueUI.SimscapeValue = App.DataSet.ModelParams.BreakawayTorque;
        App.BreakawayVelocityUI.SimscapeValue = App.DataSet.ModelParams.BreakawayVelocity;
        App.CoulombTorqueUI.SimscapeValue = App.DataSet.ModelParams.CoulombTorque;
        App.ViscousCoefficientUI.SimscapeValue = App.DataSet.ModelParams.ViscousCoefficient;
      end  % if

      if NameValuePair.PlotVelocityUnit == ""
        plot_veclocity_unit = App.angular_speed_unit_items(1);
      else
        plot_veclocity_unit = NameValuePair.PlotVelocityUnit;
      end  % if

      if NameValuePair.PlotTorqueUnit == ""
        plot_torque_unit = App.torque_unit_items(1);
      else
        plot_torque_unit = NameValuePair.PlotTorqueUnit;
      end  % if

      % For the derived parameters, use the same unit as the plot unit.
      App.StribeckScaledTorqueUI.UnitText = plot_torque_unit;
      App.StribeckThresholdVelocityUI.UnitText = plot_veclocity_unit;
      App.CoulombThresholdVelocityUI.UnitText = plot_veclocity_unit;

      % Show torque components in the plot by default.
      App.ShowStribeckTorqueUI.Value = true;
      App.ShowCoulombTorqueUI.Value = true;
      App.ShowViscousTorqueUI.Value = true;

      App.PlotTorqueUnitUI.UnitText = plot_torque_unit;
      % Looks like setting UnitText above overrides UnitItems.
      % !todo: (Re)assign torque_unit_items. This must be unnecessary.
      % App.PlotTorqueUnitUI.UnitItems = App.torque_unit_items;

      App.PlotVelocityUnitUI.UnitText = plot_veclocity_unit;
      % Looks like setting UnitText above overrides UnitItems.
      % !todo: (Re)assign torque_unit_items. This must be unnecessary.
      % App.PlotVelocityUnitUI.UnitItems = App.angular_speed_unit_items;

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

      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.ComponentHeight = AppUtil1.Constant.Height{"oneline"} * 4;
      label_ui.Text = join([
        "The Rotational Friction block in Simscape represents friction in contact between rotating bodies."
        "The friction torque $T$ is simulated as a function of relative velocity $\omega$ and"
        "is assumed to be the sum of Stribeck, Coulomb, and viscous components."
        ], " ");
      label_ui.WordWrap = "on";

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);

      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.ComponentHeight = AppUtil1.Constant.Height{"oneline"} * 2 + 10;
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
      h_container = AppUtil1.HorizontalContainer(appleft_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = AppUtil1.Component.Label(h_layout);
      label_ui.Text = CodeUtil1.i18n("Rotational Friction block:");
      label_ui.ComponentWidth = App.width_unit * 19;

      h_layout = addHorizontalGridLayout(h_container, Width="fit");
      App.DocLinkUI = AppUtil1.Component.Hyperlink(h_layout);
      App.DocLinkUI.Text = CodeUtil1.i18n("Documentation");
      App.DocLinkUI.HyperlinkClickedCallback = @() web("https://www.mathworks.com/help/simscape/ref/rotationalfriction.html");

      h_layout = addHorizontalGridLayout(h_container);
      ssc_link_ui = AppUtil1.Component.Hyperlink(h_layout);
      ssc_link_ui.Text = CodeUtil1.i18n("Simscape source");
      ssc_link_ui.HyperlinkClickedCallback = @() ...
        open(string(matlabroot) + filesep + ...
        fullfile("toolbox", "physmod", "simscape", "library", "m") + filesep + ...
        fullfile("+foundation", "+mechanical", "+rotational", "friction.ssc"));

      %% ======================================================================
      % Parameters

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.Text = "\bf{" + CodeUtil1.i18n("Parameters") + "}";

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.BreakawayTorqueUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.BreakawayTorqueUI.Editable = "on";
      App.BreakawayTorqueUI.NameText = CodeUtil1.i18n("Breakaway friction torque, $T_{B}$");
      App.BreakawayTorqueUI.NameUIWidth = App.name_ui_width;
      App.BreakawayTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.BreakawayTorqueUI.UnitItems = App.torque_unit_items;
      App.BreakawayTorqueUI.ValueChangedCallback = @() update_BreakawayTorque();
      App.BreakawayTorqueUI.UnitChangedCallback = @() update_BreakawayTorque();
      function update_BreakawayTorque
        App.DataSet.ModelParams.BreakawayTorque = App.BreakawayTorqueUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.BreakawayVelocityUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.BreakawayVelocityUI.Editable = "on";
      App.BreakawayVelocityUI.NameText = CodeUtil1.i18n("Breakaway friction velocity, $\omega_{B}$");
      App.BreakawayVelocityUI.NameUIWidth = App.name_ui_width;
      App.BreakawayVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.BreakawayVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.BreakawayVelocityUI.ValueChangedCallback = @() update_BreakawayVelocity();
      App.BreakawayVelocityUI.UnitChangedCallback = @() update_BreakawayVelocity();
      function update_BreakawayVelocity
        App.DataSet.ModelParams.BreakawayVelocity = App.BreakawayVelocityUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.CoulombTorqueUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.CoulombTorqueUI.Editable = "on";
      App.CoulombTorqueUI.NameText = CodeUtil1.i18n("Coulomb friction torque, $T_{C}$");
      App.CoulombTorqueUI.NameUIWidth = App.name_ui_width;
      App.CoulombTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.CoulombTorqueUI.UnitItems = App.torque_unit_items;
      App.CoulombTorqueUI.ValueChangedCallback = @() update_CoulombTorque();
      App.CoulombTorqueUI.UnitChangedCallback = @() update_CoulombTorque();
      function update_CoulombTorque
        App.DataSet.ModelParams.CoulombTorque = App.CoulombTorqueUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.ViscousCoefficientUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.ViscousCoefficientUI.Editable = "on";
      App.ViscousCoefficientUI.NameText = CodeUtil1.i18n("Viscous friction coefficient, $f$");
      App.ViscousCoefficientUI.NameUIWidth = App.name_ui_width;
      App.ViscousCoefficientUI.UnitUIWidth = App.unit_ui_width;
      App.ViscousCoefficientUI.UnitItems = App.fric_coeff_unit_items;
      App.ViscousCoefficientUI.ValueChangedCallback = @() update_ViscousCoefficient();
      App.ViscousCoefficientUI.UnitChangedCallback = @() update_ViscousCoefficient();
      function update_ViscousCoefficient
        App.DataSet.ModelParams.ViscousCoefficient = App.ViscousCoefficientUI.SimscapeValue;
        react_UIChanged(App)
      end  % nested function

      %% ======================================================================
      % Derived parameters

      % -----------------------------------------------------------------------
      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      label_ui = AppUtil1.Component.Label(appleft_v_layout);
      label_ui.ComponentWidth = App.name_ui_width;
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Derived parameters") + "}";

      component_height = AppUtil1.Constant.Height{"oneline++"} * 2;

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.StribeckScaledTorqueUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.StribeckScaledTorqueUI.Editable = "on";
      App.StribeckScaledTorqueUI.ComponentHeight = component_height;
      App.StribeckScaledTorqueUI.NameText = CodeUtil1.i18n("Scale factor for Stribeck torque") + newline + "$T_{S} = \sqrt{2e} (T_{B} - T_{C})$";
      App.StribeckScaledTorqueUI.NameUIWidth = App.name_ui_width;
      App.StribeckScaledTorqueUI.UnitUIWidth = App.unit_ui_width;
      App.StribeckScaledTorqueUI.UnitItems = App.torque_unit_items;
      App.StribeckScaledTorqueUI.ReadOnlyValueText = true;
      App.StribeckScaledTorqueUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "StribeckScaledTorque");

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.StribeckThresholdVelocityUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.StribeckThresholdVelocityUI.Editable = "on";
      App.StribeckThresholdVelocityUI.ComponentHeight = component_height;
      App.StribeckThresholdVelocityUI.NameText = CodeUtil1.i18n("Velocity threshold for Stribeck torque") + newline + "$\omega_{S} = \omega_{B} \sqrt{2}$";
      App.StribeckThresholdVelocityUI.NameUIWidth = App.name_ui_width;
      App.StribeckThresholdVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.StribeckThresholdVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.StribeckThresholdVelocityUI.ReadOnlyValueText = true;
      App.StribeckThresholdVelocityUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "StribeckThresholdVelocity");

      appleft_v_layout = addVerticalGridLayout(appleft_v_container);
      App.CoulombThresholdVelocityUI = AppUtil1.Component.PhysicalValueWithUnitDropDown(appleft_v_layout);
      App.CoulombThresholdVelocityUI.Editable = "on";
      App.CoulombThresholdVelocityUI.ComponentHeight = component_height;
      App.CoulombThresholdVelocityUI.NameText = CodeUtil1.i18n("Velocity threshold for Coulomb torque") + newline + "$\omega_{C} = \omega_{B} / 10$";
      App.CoulombThresholdVelocityUI.NameUIWidth = App.name_ui_width;
      App.CoulombThresholdVelocityUI.UnitUIWidth = App.unit_ui_width;
      App.CoulombThresholdVelocityUI.UnitItems = App.angular_speed_unit_items;
      App.CoulombThresholdVelocityUI.ReadOnlyValueText = true;
      App.CoulombThresholdVelocityUI.UnitChangedCallback = @() update_DerivedParameterUI(App, "CoulombThresholdVelocity");

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
      App.PlotButtonUI.ButtonPushedCallback = @() update_plot(App);
      % Set auto-update to false and keep it until the entire app is ready.
      App.PlotButtonUI.ButtonDisable = "on";

      h_layout = addHorizontalGridLayout(h_container);
      App.OpenInFigureWindowUI = AppUtil1.Component.Hyperlink(h_layout);
      App.OpenInFigureWindowUI.Text = CodeUtil1.i18n("Open in figure window");
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";
      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() update_plot(App, StandAloneFigure=true);

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container, Height="fit");

      App.AxesUI = AppUtil1.Graphics.Axes(appright_v_layout);
      App.AxesUI.ComponentHeight = 380;

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = AppUtil1.HorizontalContainer(appright_v_layout);

      h_layout = addHorizontalGridLayout(h_container, Width="3x");
      label_ui = AppUtil1.Component.Label(h_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Torque components") + "}";
      label_ui.HorizontalAlignment = "center";

      h_layout = addHorizontalGridLayout(h_container, Width="2x");
      App.ShowStribeckTorqueUI = AppUtil1.Component.CheckBox(h_layout);
      App.ShowStribeckTorqueUI.Text = CodeUtil1.i18n("Stribeck");
      App.ShowStribeckTorqueUI.ValueChangedCallback = @() react_ShowStribeckTorqueChanged();
      function react_ShowStribeckTorqueChanged
        App.DataSet.ShowStribeckTorque = App.ShowStribeckTorqueUI.Value;
        auto_update_plot(App, SkipDataUpdate=true);
      end  % nested function

      h_layout = addHorizontalGridLayout(h_container, Width="2x");
      App.ShowCoulombTorqueUI = AppUtil1.Component.CheckBox(h_layout);
      App.ShowCoulombTorqueUI.Text = CodeUtil1.i18n("Coulomb");
      App.ShowCoulombTorqueUI.ValueChangedCallback = @() react_ShowCoulombTorqueChanged();
      function react_ShowCoulombTorqueChanged
        App.DataSet.ShowCoulombTorque = App.ShowCoulombTorqueUI.Value;
        auto_update_plot(App, SkipDataUpdate=true);
      end  % nested function

      h_layout = addHorizontalGridLayout(h_container, Width="2x");
      App.ShowViscousTorqueUI = AppUtil1.Component.CheckBox(h_layout);
      App.ShowViscousTorqueUI.Text = CodeUtil1.i18n("Viscous");
      App.ShowViscousTorqueUI.ValueChangedCallback = @() react_ShowViscousTorqueChanged();
      function react_ShowViscousTorqueChanged
        App.DataSet.ShowViscousTorque = App.ShowViscousTorqueUI.Value;
        auto_update_plot(App, SkipDataUpdate=true);
      end  % nested function

      % -----------------------------------------------------------------------
      appright_v_layout = addVerticalGridLayout(appright_v_container);
      h_container = AppUtil1.HorizontalContainer(appright_v_layout);

      % Plot unit .............................................................
      h_layout = addHorizontalGridLayout(h_container, Width="1x");

      label_ui = AppUtil1.Component.Label(h_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Plot unit") + "}";
      label_ui.HorizontalAlignment = "center";

      name_width = AppUtil1.Constant.Width{"unitwidth"} * 7;

      % Torque drop down ......................................................
      h_layout = addHorizontalGridLayout(h_container, Width="2x");
      sub_h_container = AppUtil1.HorizontalContainer(h_layout);

      sub_h_layout = addHorizontalGridLayout(sub_h_container, Width="fit");
      label_ui = AppUtil1.Component.Label(sub_h_layout);
      label_ui.Text = "Torque";
      label_ui.ComponentWidth = name_width;
      label_ui.HorizontalAlignment = "right";

      sub_h_layout = addHorizontalGridLayout(sub_h_container);
      App.PlotTorqueUnitUI = AppUtil1.Component.PhysicalUnitDropDown(sub_h_layout);
      App.PlotTorqueUnitUI.Editable = "on";
      App.PlotTorqueUnitUI.UnitItems = App.torque_unit_items;
      App.PlotTorqueUnitUI.ComponentWidth = App.unit_ui_width;
      App.PlotTorqueUnitUI.UnitChangedCallback = @() react_PlotTorqueUnitChanged(App);
      function react_PlotTorqueUnitChanged(App)
        App.DataSet.PlotTorqueUnit = App.PlotTorqueUnitUI.UnitText;
        auto_update_plot(App, SkipDataUpdate=true);
      end  % nested function

      % Velocity drop down ....................................................
      h_layout = addHorizontalGridLayout(h_container, Width="2x");
      sub_h_container = AppUtil1.HorizontalContainer(h_layout);

      sub_h_layout = addHorizontalGridLayout(sub_h_container, Width="fit");
      label_ui = AppUtil1.Component.Label(sub_h_layout);
      label_ui.Text = "Velocity";
      label_ui.ComponentWidth = name_width;
      label_ui.HorizontalAlignment = "right";

      sub_h_layout = addHorizontalGridLayout(sub_h_container);
      App.PlotVelocityUnitUI = AppUtil1.Component.PhysicalUnitDropDown(sub_h_layout);
      App.PlotVelocityUnitUI.Editable = "on";
      App.PlotVelocityUnitUI.UnitItems = App.angular_speed_unit_items;
      App.PlotVelocityUnitUI.ComponentWidth = App.unit_ui_width;
      App.PlotVelocityUnitUI.UnitChangedCallback = @() react_VelocityPlotUnitChanged(App);
      function react_VelocityPlotUnitChanged(App)
        App.DataSet.PlotVelocityUnit = App.PlotVelocityUnitUI.UnitText;
        auto_update_plot(App, SkipDataUpdate=true);
      end  % nested function

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

      set_param(block_path, "brkwy_trq", App.BreakawayTorqueUI.Value);
      set_param(block_path, "brkwy_trq_unit", App.BreakawayTorqueUI.Unit);

      set_param(block_path, "brkwy_vel", App.BreakawayVelocityUI.Value);
      set_param(block_path, "brkwy_vel_unit", App.BreakawayVelocityUI.Unit);

      set_param(block_path, "Col_trq", App.CoulombTorqueUI.Value);
      set_param(block_path, "Col_trq_unit", App.CoulombTorqueUI.Unit);

      set_param(block_path, "visc_coef", App.ViscousCoefficientUI.Value);
      set_param(block_path, "visc_coef_unit", App.ViscousCoefficientUI.Unit);

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
        App.DataSet = RotationalFriction1.RotationalFrictionDataSet(BlockPath=App.BlockPath);
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

      block_path = App.BlockPath;

      value_text = get_param(block_path, "brkwy_trq");
      unit_text = get_param(block_path, "brkwy_trq_unit");
      App.BreakawayTorqueUI.ValueText = value_text;
      App.BreakawayTorqueUI.UnitText = unit_text;
      App.DataSet.ModelParams.BreakawayTorque = App.BreakawayTorqueUI.SimscapeValue;

      value_text = get_param(block_path, "brkwy_vel");
      unit_text = get_param(block_path, "brkwy_vel_unit");
      App.BreakawayVelocityUI.ValueText = value_text;
      App.BreakawayVelocityUI.UnitText = unit_text;
      App.DataSet.ModelParams.BreakawayVelocity = App.BreakawayVelocityUI.SimscapeValue;

      value_text = get_param(block_path, "Col_trq");
      unit_text = get_param(block_path, "Col_trq_unit");
      App.CoulombTorqueUI.ValueText = value_text;
      App.CoulombTorqueUI.UnitText = unit_text;
      App.DataSet.ModelParams.CoulombTorque = App.CoulombTorqueUI.SimscapeValue;

      value_text = get_param(block_path, "visc_coef");
      unit_text = get_param(block_path, "visc_coef_unit");
      App.ViscousCoefficientUI.ValueText = value_text;
      App.ViscousCoefficientUI.UnitText = unit_text;
      App.DataSet.ModelParams.ViscousCoefficient = App.ViscousCoefficientUI.SimscapeValue;

      % Recover the plot auto update setting.
      App.PlotButtonUI.CheckBoxUI.Value = prev_value;
      % -----------------------------------------------------------------------

      react_UIChanged(App)
    end  % function

    function react_UIChanged(App)
      %%
      arguments (Input)
        App (1,1)
      end  % if

      App.DataSet.ShowStribeckTorque = App.ShowStribeckTorqueUI.Value;
      App.DataSet.ShowCoulombTorque = App.ShowCoulombTorqueUI.Value;
      App.DataSet.ShowViscousTorque = App.ShowViscousTorqueUI.Value;

      updateDataSet(App.DataSet)

      update_DerivedParameterUI(App, "StribeckScaledTorque")
      update_DerivedParameterUI(App, "StribeckThresholdVelocity")
      update_DerivedParameterUI(App, "CoulombThresholdVelocity")

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

    function auto_update_plot(App, NameValuePair)
      %%
      arguments (Input)
        App
        NameValuePair.SkipDataUpdate (1,1) logical = false
      end  % arguments
      if App.PlotButtonUI.CheckBoxUI.Value

        update_plot(App, SkipDataUpdate=NameValuePair.SkipDataUpdate)

      end  % if
    end  % function

    function update_plot(App, NameValuePair)
      %%
      arguments (Input)
        App
        NameValuePair.StandAloneFigure (1,1) logical = false
        NameValuePair.SkipDataUpdate (1,1) logical = false
      end  % arguments

      if NameValuePair.StandAloneFigure
        ax = axes(figure);
      else
        ax = App.AxesUI.MainAxes;
        cla(ax)
      end  % if

      if not(NameValuePair.SkipDataUpdate)
        App.DataSet.ModelParams.BreakawayTorque = App.BreakawayTorqueUI.SimscapeValue;
        App.DataSet.ModelParams.BreakawayVelocity = App.BreakawayVelocityUI.SimscapeValue;
        App.DataSet.ModelParams.CoulombTorque = App.CoulombTorqueUI.SimscapeValue;
        App.DataSet.ModelParams.ViscousCoefficient = App.ViscousCoefficientUI.SimscapeValue;

        updateInfoAndUnitUIs(App.BreakawayTorqueUI)
        updateInfoAndUnitUIs(App.BreakawayVelocityUI)
        updateInfoAndUnitUIs(App.CoulombTorqueUI)
        updateInfoAndUnitUIs(App.ViscousCoefficientUI)

        updateDataSet(App.DataSet)

      end  % if

      RotationalFriction1.plotRotationalFrictionTorque(DataSource="dataset", DataSet=App.DataSet, ParentAxes=ax)

    end  % function

  end  % methods
end  % classdef
