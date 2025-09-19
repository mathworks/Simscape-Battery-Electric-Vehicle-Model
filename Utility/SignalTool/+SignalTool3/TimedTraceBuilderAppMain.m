classdef TimedTraceBuilderAppMain < handle
  % This app works with Simscape PS Lookup Table (1D) block to design
  % a signal trace using timed trace properties.

  % !todo: Currently this app is get-only, i.e., the app can get parameters from
  % the specified block but cannot set parameters to it.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TimedTraceBuilderAppMain:"
  end  % properties

  properties

    ModelFileFullPath (1,1) string = ""
    BlockPath (1,1) string = ""

    % -------------------------------------------------------------------------

    SignalDesignMatrixText (:,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow

    RandomSeedUI LiteApp7.Component.PhysicalValueUI

    DataUnitUI LiteApp7.Component.DropDown

    InitialDataValueUI LiteApp7.Component.PhysicalValueUI
    InitialConstantDurationUI LiteApp7.Component.PhysicalValueUI

    InitialTransitionDurationUI LiteApp7.Component.PhysicalValueUI

    NumberOfTransitionsUI LiteApp7.Component.PhysicalValueUI
    RangeOfTransitionDurationUI LiteApp7.Component.PhysicalValueUI
    RangeOfConstantDurationUI LiteApp7.Component.PhysicalValueUI
    RangeOfDataValueUI LiteApp7.Component.PhysicalValueUI

    FinalTransitionDurationUI LiteApp7.Component.PhysicalValueUI

    FinalDataValueUI LiteApp7.Component.PhysicalValueUI
    FinalConstantDurationUI LiteApp7.Component.PhysicalValueUI

    TableGridVectorUI LiteApp7.Component.PhysicalValueUI
    TableValuesUI LiteApp7.Component.PhysicalValueUI

    PlotButtonUI LiteApp7.Component.EnabledButton
    OpenInFigureWindowUI LiteApp7.Component.Hyperlink
    AxesUI LiteApp7.Graphics.Axes
    IntervalUI LiteApp7.Component.PhysicalValueUI

    SelectorUI LiteApp7.Component.BlockSelectorUI

  end  % properties

  properties (Constant, Access=private)

    data_value_units = ["m/s", "km/hr", "mph"]

    width_unit = LiteApp7.Constant.Width{"unitwidth"}
    name_ui_width = LiteApp7.Constant.Width{"unitwidth"} * 22
    unit_ui_width = LiteApp7.Constant.Width{"unitwidth"} * 8
    button_width = LiteApp7.Constant.Width{"unitwidth"} * 12

    oneline_height = LiteApp7.Constant.Height{"oneline"}

  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = TimedTraceBuilderAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      % Do not declare the output arguments for a class constructor.

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      if NameValuePair.BlockPath ~= ""
        model_name = extractBefore(NameValuePair.BlockPath, "/");
        App.ModelFileFullPath = FileTool3.getFileFullPath(model_name);
        App.BlockPath = NameValuePair.BlockPath;
      end  % if

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = "Timed Trace Builder App";
      App.Window.Height = 520;
      App.Window.Width = 1000;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      if NameValuePair.BlockPath ~= ""

        App.SelectorUI.ModelFileFullPath = App.ModelFileFullPath;
        App.SelectorUI.BlockPath = App.BlockPath;

% !todo: Support loading a target block on start up.
        % getParam(App)

% !todo: delete thse settings once getParam is available.
        App.RandomSeedUI.Value = "6";
        App.DataUnitUI.Value = "km/hr";
        App.InitialConstantDurationUI.Value = "10";
        App.InitialDataValueUI.Value = "0";
        App.InitialDataValueUI.Unit = App.DataUnitUI.Value;
        App.InitialTransitionDurationUI.Value = "10";
        App.NumberOfTransitionsUI.Value = "10";
        App.RangeOfTransitionDurationUI.Value = "[5, 10]";
        App.RangeOfConstantDurationUI.Value = "[5, 10]";
        App.RangeOfDataValueUI.Value = "[60, 100]";
        App.RangeOfDataValueUI.Unit = App.DataUnitUI.Value;
        App.FinalTransitionDurationUI.Value = "15";
        App.FinalConstantDurationUI.Value = "10";
        App.FinalDataValueUI.Value = "0";
        App.FinalDataValueUI.Unit = App.DataUnitUI.Value;

      else
        % Default settings of UI components.

        App.RandomSeedUI.Value = "6";

        App.DataUnitUI.Value = "km/hr";

        App.InitialConstantDurationUI.Value = "10";

        App.InitialDataValueUI.Value = "0";
        App.InitialDataValueUI.Unit = App.DataUnitUI.Value;

        App.InitialTransitionDurationUI.Value = "10";

        App.NumberOfTransitionsUI.Value = "10";

        App.RangeOfTransitionDurationUI.Value = "[5, 10]";

        App.RangeOfConstantDurationUI.Value = "[5, 10]";

        App.RangeOfDataValueUI.Value = "[60, 100]";
        App.RangeOfDataValueUI.Unit = App.DataUnitUI.Value;

        App.FinalTransitionDurationUI.Value = "15";

        App.FinalConstantDurationUI.Value = "10";

        App.FinalDataValueUI.Value = "0";
        App.FinalDataValueUI.Unit = App.DataUnitUI.Value;

      end  % if

      % -----------------------------------------------------------------------
      App.PlotButtonUI.ButtonDisable = "on";
      auto_update_plot(App)

      Show(App.Window)
    end  % function

    function build_app_gui(App)
      %%
      layout = App.Window.MainLayout;

      area = NewArea(layout);

      % =======================================================================
      % Left area
      % =======================================================================
      column = NewColumn(layout, area);

      % -----------------------------------------------------------------------

      % Use getFileFullPath to check that the file exists.
      % If it doesn't, an error is issued and the app doesn't start.
      html_file = "TimedTraceBuilderApp_Description.html";
      FileTool3.getFileFullPath(html_file);

      row = NewRow(layout, column);
      link_ui = LiteApp7.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Description";
      link_ui.HyperlinkClickedCallback =  @() web(html_file);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      % label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Parameters}";
      % label_ui.ComponentWidth = App.width_unit * 15;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.RandomSeedUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RandomSeedUI.Name = "Random seed";
      App.RandomSeedUI.UnitAlias = "";
      App.RandomSeedUI.NameUIWidth = App.name_ui_width;
      App.RandomSeedUI.UnitUIWidth = App.unit_ui_width;
      App.RandomSeedUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "Unit of data value";
      label_ui.ComponentWidth = App.name_ui_width;

      App.DataUnitUI = LiteApp7.Component.DropDown(NewSlot(layout, row));
      App.DataUnitUI.Items = App.data_value_units;
      App.DataUnitUI.ValueChangedCallback = @() auto_update_plot(App);

      space_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      space_ui.Text = "";
      space_ui.ComponentWidth = App.unit_ui_width;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.InitialDataValueUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.InitialDataValueUI.Name = "Initial data value, $f_1$";
      App.InitialDataValueUI.Unit = "m/s";
      App.InitialDataValueUI.NameUIWidth = App.name_ui_width;
      App.InitialDataValueUI.UnitUIWidth = App.unit_ui_width;
      App.InitialDataValueUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.InitialConstantDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.InitialConstantDurationUI.Name = "Initial constant duration, $\Delta t_{ic}$";
      App.InitialConstantDurationUI.Unit = "s";
      App.InitialConstantDurationUI.NameUIWidth = App.name_ui_width;
      App.InitialConstantDurationUI.UnitUIWidth = App.unit_ui_width;
      App.InitialConstantDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.InitialTransitionDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.InitialTransitionDurationUI.Name = "Initial transition duration, $\Delta t_{it}$";
      App.InitialTransitionDurationUI.Unit = "s";
      App.InitialTransitionDurationUI.NameUIWidth = App.name_ui_width;
      App.InitialTransitionDurationUI.UnitUIWidth = App.unit_ui_width;
      App.InitialTransitionDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.NumberOfTransitionsUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.NumberOfTransitionsUI.Name = "Number of transitions, $N_T$";
      App.NumberOfTransitionsUI.UnitAlias = "";
      App.NumberOfTransitionsUI.NameUIWidth = App.name_ui_width;
      App.NumberOfTransitionsUI.UnitUIWidth = App.unit_ui_width;
      App.NumberOfTransitionsUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.RangeOfTransitionDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RangeOfTransitionDurationUI.Name = "Range of transition duration, $R_T$";
      App.RangeOfTransitionDurationUI.Unit = "s";
      App.RangeOfTransitionDurationUI.NameUIWidth = App.name_ui_width;
      App.RangeOfTransitionDurationUI.UnitUIWidth = App.unit_ui_width;
      App.RangeOfTransitionDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.RangeOfConstantDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RangeOfConstantDurationUI.Name = "Range of constant duration, $R_C$";
      App.RangeOfConstantDurationUI.Unit = "s";
      App.RangeOfConstantDurationUI.NameUIWidth = App.name_ui_width;
      App.RangeOfConstantDurationUI.UnitUIWidth = App.unit_ui_width;
      App.RangeOfConstantDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.RangeOfDataValueUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.RangeOfDataValueUI.Name = "Range of data value, $R_f$";
      App.RangeOfDataValueUI.Unit = "m/s";
      App.RangeOfDataValueUI.NameUIWidth = App.name_ui_width;
      App.RangeOfDataValueUI.UnitUIWidth = App.unit_ui_width;
      App.RangeOfDataValueUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.FinalTransitionDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.FinalTransitionDurationUI.Name = "Final transition duration, $\Delta t_{ft}$";
      App.FinalTransitionDurationUI.Unit = "s";
      App.FinalTransitionDurationUI.NameUIWidth = App.name_ui_width;
      App.FinalTransitionDurationUI.UnitUIWidth = App.unit_ui_width;
      App.FinalTransitionDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.FinalDataValueUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.FinalDataValueUI.Name = "Final data value, $f_{f}$";
      App.FinalDataValueUI.Unit = "m/s";
      App.FinalDataValueUI.NameUIWidth = App.name_ui_width;
      App.FinalDataValueUI.UnitUIWidth = App.unit_ui_width;
      App.FinalDataValueUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.FinalConstantDurationUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.FinalConstantDurationUI.Name = "Final constant duration, $\Delta t_{fc}$";
      App.FinalConstantDurationUI.Unit = "s";
      App.FinalConstantDurationUI.NameUIWidth = App.name_ui_width;
      App.FinalConstantDurationUI.UnitUIWidth = App.unit_ui_width;
      App.FinalConstantDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Derived parameters}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TableGridVectorUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TableGridVectorUI.Name = "Table grid vector, $t$";
      App.TableGridVectorUI.Unit = "s";
      App.TableGridVectorUI.NameUIWidth = App.name_ui_width;
      App.TableGridVectorUI.UnitUIWidth = App.unit_ui_width;
      App.TableGridVectorUI.ValueEditFieldUI.ReadOnly = "on";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TableValuesUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TableValuesUI.Name = "Table values, $f(t)$";
      App.TableValuesUI.Unit = "km/hr";
      App.TableValuesUI.NameUIWidth = App.name_ui_width;
      App.TableValuesUI.UnitUIWidth = App.unit_ui_width;
      App.TableValuesUI.ValueEditFieldUI.ReadOnly = "on";

      % =======================================================================
      % Right area
      % =======================================================================
      column = NewColumn(layout, area);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.PlotButtonUI = LiteApp7.Component.EnabledButton(NewSlot(layout, row, Width="fit"));
      App.PlotButtonUI.HorizontalAlignment = "left";
      App.PlotButtonUI.ButtonUIWidth = App.button_width + App.width_unit;
      App.PlotButtonUI.ButtonWidth = App.button_width;
      App.PlotButtonUI.CheckBoxUIWidth = "fit";
      App.PlotButtonUI.CheckBoxWidth = "fit";
      App.PlotButtonUI.ButtonText = "Update";
      App.PlotButtonUI.ButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "tool_rotate_3d.png");
      App.PlotButtonUI.CheckBoxText = "Auto-update";
      App.PlotButtonUI.ButtonPushedCallback = @() update_plot(App);
      % Set false to auto-update and keep it until the entire app is ready.
      App.PlotButtonUI.ButtonEnable = "on";

      App.OpenInFigureWindowUI = LiteApp7.Component.Hyperlink(NewSlot(layout, row));
      App.OpenInFigureWindowUI.HyperlinkText = "Open in figure window";
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";
      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() update_plot(App, StandAloneFigure=true);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.AxesUI = LiteApp7.Graphics.Axes(NewSlot(layout, row));
      App.AxesUI.ComponentHeight = 300;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Visualization parameter}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.IntervalUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.IntervalUI.Name = "Interpolation interval, $dt$";
      App.IntervalUI.Unit = "s";
      App.IntervalUI.NameUIWidth = App.name_ui_width;
      App.IntervalUI.UnitUIWidth = App.unit_ui_width;
      App.IntervalUI.Value = "0.1";
      App.IntervalUI.ValueChangedCallback = @() auto_update_plot(App);

      % =======================================================================
      % Bottom area
      % =======================================================================
      area = NewArea(layout);
      column = NewColumn(layout, area);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      LiteApp7.Component.HorizontalLine(NewSlot(layout, row));

      % -----------------------------------------------------------------------
      % Configure the block selector UI to find Simscape PS Lookup Table (1D) block and
      % Simulink 1-D Lookup Table block.
      row = NewRow(layout, column);
      App.SelectorUI = LiteApp7.Component.BlockSelectorUI(NewSlot(layout, row));
      App.SelectorUI.MainFigure = App.Window.MainFigure;
      App.SelectorUI.TargetSimscapeBlockNames = "PS Lookup Table (1D)";
      App.SelectorUI.FindBlockCallback = @ModelTool2.findLookupTable1DBlocks;
      App.SelectorUI.GetParametersFromBlockCallback = @() disp("SelectorUI's GetParametersFromBlockCallback is undefined."); % getParam(App);
      App.SelectorUI.SetParametersToBlockCallback = @() setParam(App);

    end  % function

    %{
    function getParam(App)
      %%
      % Disable plot auto-update. Restore at the end of this function.
      previous_auto_plot_state = App.PlotButtonUI.CheckBoxUI.Value;
      App.PlotButtonUI.CheckBoxUI.Value = false;

      % -----------------------------------------------------------------------
      block_path = App.SelectorUI.BlockPath;

      % -----------------------------------------------------------------------
      % Get signal design matrix from the Description property.

      description_text = get_param(block_path, "Description");
      if isempty(description_text)
        % Restore the previous plot auto-update setting.
        App.PlotButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
        msg = block_path + newline + "Target block has no text in the Description property.";
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, msg, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % if

      extracted_text = extractBetween(description_text, "% SignalDesignMatrixStart" + newline, newline + "% SignalDesignMatrixEnd");
      if isempty(extracted_text) || extracted_text == ""
        % Restore the previous plot auto-update setting.
        App.PlotButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
        msg = block_path + newline + "Description in the Target block has no signal design matrix.";
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, msg, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % if

      % -----------------------------------------------------------------------
      try
        % Validate the signal design matrix in the Description property of the target block. This involves evaluation.
        SignalTool3.getSignalDesignMatrixFromBlockDescription(block_path);
      catch exception
        % Restore the previous plot auto-update setting.
        App.PlotButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, exception.message, window_title)
        else

          rethrow(exception)

        end  % if

      end  % try, catch
      App.MatrixTextUI.ValueString = string(extracted_text{:});

      is_Simscape_LookupTable = true;
      block_mask = Simulink.Mask.get(block_path);
      if isempty(block_mask)
        is_Simscape_LookupTable = false;  
      end  % if

      if is_Simscape_LookupTable

        % ---------------------------------------------------------------------
        % Get interpolation method.
        str = get_param(block_path, "interp_method");
        str = extractAfter(str, asManyOfPattern(wildcardPattern + "."));
        interp_method = [upper(str(1)), str(2:end)];  % Capitalize
        App.InterpUI.Value = interp_method;

        % ---------------------------------------------------------------------
        % Get extrapolation method.
        str = get_param(block_path, "extrap_method");
        str = extractAfter(str, asManyOfPattern(wildcardPattern + "."));
        extrap_method = [upper(str(1)), str(2:end)];  % Capitalize
        App.ExtrapUI.Value = extrap_method;

        % ---------------------------------------------------------------------
        % Get the unit of x.
        x_unit = get_param(block_path, "x_unit");
        % Use unit alias.
        App.TableGridVectorUI.UnitAlias = x_unit;
        App.IntervalUI.UnitAlias = x_unit;
        App.LowerUI.UnitAlias = x_unit;
        App.UpperUI.UnitAlias = x_unit;

        % ---------------------------------------------------------------------
        % Get the unit of f(x).
        f_unit = get_param(block_path, "f_unit");
        % Use unit alias.
        App.TableValuesUI.UnitAlias = f_unit;

      else
        % Simulink 1-D Lookup Table block supports many combinations for
        % interpolation and extrapolation methods whereas
        % this app supports only "Akima spline", "Linear point-slope", and "Flat"
        % for interpolation method. For Extrapolation method, this app uses "Nearest",
        % which is different from the block as follows.

        interp_method = get_param(block_path, "InterpMethod");
        if interp_method == "Akima spline"
          App.InterpUI.Value = "Smooth";

        elseif interp_method == "Linear point-slope"
          App.InterpUI.Value = "Linear";

        % elseif interp_method == "Flat"

        else
          % Restore the previous plot auto-update setting.
          App.PlotButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
          msg = "This app supports only ""Akima spline"", ""Linear point-slope"", and ""Flat"" for interpolation method.";
          if App.Window.MainFigure.Visible
            window_title = "Error";
            uialert(App.Window.MainFigure, msg, window_title)
          else
           disp(msg)
          end  % if

          return

        end  % if

        % Simulink 1-D Lookup Table supports the followings.
        % Interpolaiton method: Extrapolation method
        %   Akima spline: "Akima spline"
        %   Linear point-slope: "Clip", "Linear", "Cubic spline"
        %   Flat: "Clip"
        App.ExtrapUI.Value = "Nearest";

      end  % if

      % -----------------------------------------------------------------------
      % Set plot properties: x lower bound, x upper bound, and interpolation interval
      design_matrix_text = join(App.MatrixTextUI.ValueString, " ");
      design_matrix = evalin("base", design_matrix_text);  % !todo: Avoid evaluation.
      result = SignalTool3.getVectorsFromSignalDesignMatrix(design_matrix);
      x_data = result.X;
      x_min = min(x_data);
      x_max = max(x_data);
      App.LowerUI.Value = num2str(x_min);
      App.UpperUI.Value = num2str(x_max);
      dx = (x_max - x_min) / 200;  % Try 200 divisions as the first dx value.
      App.IntervalUI.Value = num2str(dx);

      % -----------------------------------------------------------------------
      % Restore the previous plot auto-update setting.
      App.PlotButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
      auto_update_plot(App)
    end  % function
    %}

    function setParam(App)
      %%
      % Transfer the settings of x, f(x), interpolation, and extrapolation to the block.
      % Physical unit is supported for Simscape PS Lookup Table (1D) block only.
 
      block_path = App.SelectorUI.BlockPath;

      % !todo: Add properties to the Description property of the target block
      % so that the app can read them from the block and load them to the app components.
      %{
      % design_matrix_text = join(App.MatrixTextUI.ValueString, newline);
      % description_text = join([
      %   "% This text was automatically inserted by Signal Tool."
      %   "% SignalDesignMatrixStart"
      %   design_matrix_text
      %   "% SignalDesignMatrixEnd"
      %   ], newline);
      % set_param(block_path, "Description", description_text)
      %}

      is_Simscape_LookupTable = true;
      block_mask = Simulink.Mask.get(block_path);
      if isempty(block_mask)
        is_Simscape_LookupTable = false;  
      end  % if

      % -----------------------------------------------------------------------
      if is_Simscape_LookupTable
        % Simscape PS Lookup Table (1D) block

        x = App.TableGridVectorUI.Value;
        set_param(block_path, "x", x)

        x_unit = App.TableGridVectorUI.Unit;
        set_param(block_path, "x_unit", x_unit);

        f = App.TableValuesUI.Value;
        set_param(block_path, "f", f)

        f_unit = App.TableValuesUI.Unit;
        set_param(block_path, "f_unit", f_unit);

        set_param(block_path, "interp_method", "simscape.enum.interpolation.smooth")
        set_param(block_path, "extrap_method", "simscape.enum.extrapolation.nearest")

      % -----------------------------------------------------------------------
      else
        % Simulink 1-D Lookup Table block
        % !warning: Physical unit setting is ignored.

        x = App.TableGridVectorUI.Value;
        set_param(block_path, "BreakpointsForDimension1", x)

        f = App.TableValuesUI.Value;
        set_param(block_path, "Table", f)

        set_param(block_path, "InterpMethod", "Akima spline")
        % Extrapolation method is automatically set to "Akima spline" by the block.

      end  % if Simscape or Simulink
    end  % function

    function auto_update_plot(App)
      %%
      if App.PlotButtonUI.CheckBoxUI.Value

        update_plot(App)

      end  % if
    end  % function

    function update_plot(App, NameValuePair)
      %%
      arguments (Input)
        App
        NameValuePair.StandAloneFigure (1,1) logical = false
      end  % arguments

      if NameValuePair.StandAloneFigure
        ax = axes(figure);
      else
        ax = App.AxesUI.MainAxes;
      end  % if

      data_table = get_signal_design_matrix_from_UI_components(App);

      t_data = data_table.X;
      f_data = data_table.F;

      App.TableGridVectorUI.Value = CodeTool1.stringify(t_data');

      data_value_unit = App.DataUnitUI.Value;

      App.InitialDataValueUI.Unit = data_value_unit;
      App.RangeOfDataValueUI.Unit = data_value_unit;
      App.FinalDataValueUI.Unit = data_value_unit;

      App.TableValuesUI.Value = CodeTool1.stringify(f_data');
      App.TableValuesUI.Unit = data_value_unit;

      dt_ssc = App.IntervalUI.SimscapeValue;
      dt = value(dt_ssc, "s");

      SignalTool3.plotLookupTable1D( ...
        t_data, f_data, ...
        Interpolation = "Smooth", ...
        Extrapolation = "Nearest", ...
        InterpolationInterval = dt, ...
        PlotXLowerBound = t_data(1), ...
        PlotXUpperBound = t_data(end), ...
        ParentAxes = ax, ...
        Title = App.BlockPath, ...
        XLabel = "Time", ...
        YLabel = "Data value", ...
        XUnitText = App.TableGridVectorUI.Unit, ...
        YUnitText = data_value_unit );

    end  % function

    function data_table = get_signal_design_matrix_from_UI_components(App)

      arguments (Input)
        App
      end  % arguments

      arguments (Output)
        data_table table
      end  % arguments

      result_random_seed = CodeTool1.getNumericValueFromString(App.RandomSeedUI.Value);
      random_seed = result_random_seed.NumericValue;

      ini_data_val = App.InitialDataValueUI.SimscapeValue;
      initial_data_value = value(ini_data_val);

      ini_const_du = App.InitialConstantDurationUI.SimscapeValue;
      initial_constant_duration = value(ini_const_du, "s");

      ini_trans_du = App.InitialTransitionDurationUI.SimscapeValue;
      initial_transition_duration = value(ini_trans_du, "s");

      result_num_trans = CodeTool1.getNumericValueFromString(App.NumberOfTransitionsUI.Value);
      num_trans = result_num_trans.NumericValue;

      trans_du_range = App.RangeOfTransitionDurationUI.Value;
      range_of_transition_duration = CodeTool1.getNumberArrayFromString(trans_du_range);

      const_dur_range = App.RangeOfConstantDurationUI.Value;
      range_of_constant_duration = CodeTool1.getNumberArrayFromString(const_dur_range);

      dat_val_range = App.RangeOfDataValueUI.Value;
      range_of_data_value = CodeTool1.getNumberArrayFromString(dat_val_range);

      fin_trans_du = App.FinalTransitionDurationUI.SimscapeValue;
      final_transition_duration = value(fin_trans_du, "s");

      fin_const_du = App.FinalConstantDurationUI.SimscapeValue;
      final_constant_duration = value(fin_const_du, "s");

      fin_dat_val = App.FinalDataValueUI.SimscapeValue;
      final_data_value = value(fin_dat_val);

      signal_design_matrix = SignalTool3.generateSignalDesignMatrixFromTraceProperties(...
        RandomSeed = random_seed, ...
        FInitialValue = initial_data_value, ...
        XInitialFlatLength = initial_constant_duration, ...
        XInitialTransitionLength = initial_transition_duration, ...
        NumTransitions = num_trans, ...
        TransitionXRange = range_of_transition_duration, ...
        FlatXRange = range_of_constant_duration, ...
        FRange = range_of_data_value, ...
        XFinalTransitionLength = final_transition_duration, ...
        XFinalFlatLength = final_constant_duration, ...
        FFinalValue = final_data_value );

      data_table = SignalTool3.getVectorsFromSignalDesignMatrix(signal_design_matrix);

    end  % function

  end  % methods

end  % classdef
