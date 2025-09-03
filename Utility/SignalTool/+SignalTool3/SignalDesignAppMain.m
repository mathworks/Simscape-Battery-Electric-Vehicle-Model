classdef SignalDesignAppMain < handle
  % This app works with Simscape PS Lookup Table (1D) block to design
  % a signal trace using signal design matrix.
  %
  % This app treats the physical untis used in the Table grid vector, x, and
  % the Table values, f(x), of the block as unit alias, rather than simscape.Unit.
  % This app does not modify the physical units in the block parameters.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private)
    errorID (1,1) string = "SignalDesignAppMain:"
  end  % properties

  properties

    ModelFileFullPath (1,1) string = ""
    BlockPath (1,1) string = ""

    % -------------------------------------------------------------------------

    SignalDesignMatrixText (:,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow

    MatrixTextUI LiteApp7.Component.TextArea
    InterpUI LiteApp7.Component.DropDown
    ExtrapUI LiteApp7.Component.DropDown

    TableGridVectorUI LiteApp7.Component.PhysicalValueUI
    TableValuesUI LiteApp7.Component.PhysicalValueUI

    PlotButtonUI LiteApp7.Component.EnabledButton
    OpenInFigureWindowUI LiteApp7.Component.Hyperlink
    AxesUI LiteApp7.Graphics.Axes
    IntervalUI LiteApp7.Component.PhysicalValueUI
    AutoRangeUI LiteApp7.Component.CheckBox
    LowerUI LiteApp7.Component.PhysicalValueUI
    UpperUI LiteApp7.Component.PhysicalValueUI

    SelectorUI LiteApp7.Component.BlockSelectorUI

  end  % properties

  properties (Access=private)
    IsValidMatrix (1,1) logical = true
  end  % properties

  properties (Constant, Access=private)

    width_unit = LiteApp7.Constant.Width{"unitwidth"}
    name_ui_width = LiteApp7.Constant.Width{"unitwidth"} * 18
    unit_ui_width = LiteApp7.Constant.Width{"unitwidth"} * 8
    button_width = LiteApp7.Constant.Width{"unitwidth"} * 12

    oneline_height = LiteApp7.Constant.Height{"oneline"}

  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = SignalDesignAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      arguments (Output)
        App SignalTool3.SignalDesignAppMain
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      if NameValuePair.BlockPath ~= ""
        model_name = extractBefore(NameValuePair.BlockPath, "/");
        App.ModelFileFullPath = FileTool3.getFileFullPath(model_name);
        App.BlockPath = NameValuePair.BlockPath;
      end  % if

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = "Signal Design App";
      App.Window.Height = 520;
      App.Window.Width = 860;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      if NameValuePair.BlockPath ~= ""
        App.SelectorUI.ModelFileFullPath = App.ModelFileFullPath;
        App.SelectorUI.BlockPath = App.BlockPath;
        getParam(App)

      else
        App.MatrixTextUI.ValueString = "[0 2 0; 4 nan 4; 6 8 3]";

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
      html_file = "SignalTool_Description.html";
      FileTool3.getFileFullPath(html_file);

      row = NewRow(layout, column);
      link_ui = LiteApp7.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Description";
      link_ui.HyperlinkClickedCallback =  @() web(html_file);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "Signal design matrix";
      label_ui.ComponentWidth = App.width_unit * 15;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.MatrixTextUI = LiteApp7.Component.TextArea(NewSlot(layout, row));
      App.MatrixTextUI.UseMonospacedFont = "on";
      App.MatrixTextUI.ComponentHeight = App.oneline_height * 10;
      App.MatrixTextUI.ValueChangedCallback = @() change_design_matrix(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "Interpolation method";
      label_ui.ComponentWidth = App.name_ui_width;

      App.InterpUI= LiteApp7.Component.DropDown(NewSlot(layout, row));
      App.InterpUI.Items = ["Smooth", "Linear"];
      App.InterpUI.Value = "Smooth";
      App.InterpUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "Extrapolation method";
      label_ui.ComponentWidth = App.name_ui_width;

      App.ExtrapUI= LiteApp7.Component.DropDown(NewSlot(layout, row));
      App.ExtrapUI.Items = ["Nearest", "Linear"];
      App.ExtrapUI.Value = "Nearest";
      App.ExtrapUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Derived parameters}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TableGridVectorUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TableGridVectorUI.Name = "Table grid vector, $x$";
      App.TableGridVectorUI.UnitItems = "1";
      App.TableGridVectorUI.NameUIWidth = App.name_ui_width;
      App.TableGridVectorUI.UnitUIWidth = App.unit_ui_width;
      App.TableGridVectorUI.ValueEditFieldUI.ReadOnly = "on";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TableValuesUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.TableValuesUI.Name = "Table values, $f(x)$";
      App.TableValuesUI.UnitItems = "1";
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
      App.IntervalUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.IntervalUI.Name = "Interpolation interval, $dx$";
      App.IntervalUI.UnitItems = "1";
      App.IntervalUI.NameUIWidth = App.name_ui_width;
      App.IntervalUI.UnitUIWidth = App.unit_ui_width;
      App.IntervalUI.Value = "0.1";
      App.IntervalUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.AutoRangeUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.AutoRangeUI.Text = "x auto range";
      App.AutoRangeUI.Value = true;
      App.AutoRangeUI.HorizontalAlignment = "left";
      App.AutoRangeUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.LowerUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.LowerUI.Name = "Plot x lower bound";
      App.LowerUI.UnitItems = "1";
      App.LowerUI.NameUIWidth = App.name_ui_width;
      App.LowerUI.UnitUIWidth = App.unit_ui_width;
      App.LowerUI.Value = "0";
      App.LowerUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.UpperUI = LiteApp7.Component.PhysicalValueUI(NewSlot(layout, row));
      App.UpperUI.Name = "Plot x upper bound";
      App.UpperUI.UnitItems = "1";
      App.UpperUI.NameUIWidth = App.name_ui_width;
      App.UpperUI.UnitUIWidth = App.unit_ui_width;
      App.UpperUI.Value = "10";
      App.UpperUI.ValueChangedCallback = @() auto_update_plot(App);

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
      App.SelectorUI.GetParametersFromBlockCallback = @() getParam(App);
      App.SelectorUI.SetParametersToBlockCallback = @() setParam(App);

    end  % function

    function change_design_matrix(App)
      %%

      check_design_matrix(App)
      if not(App.IsValidMatrix)

        return

      end  % if

      % This can contain newlines. Preserve them.
      App.SignalDesignMatrixText = App.MatrixTextUI.ValueString;

      % Make a single line text to evaluate.
      design_matrix_text = join(App.SignalDesignMatrixText, " ");
      design_matrix = evalin("base", design_matrix_text);  % !todo: Avoid evaluation.

      result = SignalTool3.getVectorsFromSignalDesignMatrix(design_matrix);

      App.TableGridVectorUI.Value = CodeTool1.stringify(result.X');
      App.TableValuesUI.Value = CodeTool1.stringify(result.F');

      auto_update_plot(App)

    end  % function

    function check_design_matrix(App)
      %%

      % Make a single line text to evaluate.
      design_matrix_text = join(App.MatrixTextUI.ValueString, " ");

      % First check as MATLAB code.
      try
        design_matrix = evalin("base", design_matrix_text);  % !todo: Avoid evaluation.
      catch exception
        App.IsValidMatrix = false;
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, exception.message, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % try, catch

      % Second check as a signal design matrix.
      result = SignalTool3.checkSignalDesignMatrix(design_matrix);
      if not(result.IsValid)
        App.IsValidMatrix = false;
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, result.Message, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % if

      App.IsValidMatrix = true;
    end  % function

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

    function setParam(App)
      %%
      % Transfer the settings of x, f(x), interpolation, and extrapolation to the block.
      % Physical unit is supported for Simscape PS Lookup Table (1D) block only.
 
      block_path = App.SelectorUI.BlockPath;

      design_matrix_text = join(App.MatrixTextUI.ValueString, newline);
      description_text = join([
        "% This text was automatically inserted by Signal Tool."
        "% SignalDesignMatrixStart"
        design_matrix_text
        "% SignalDesignMatrixEnd"
        ], newline);
      set_param(block_path, "Description", description_text)

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

        x_unit = App.TableGridVectorUI.UnitAlias;
        if x_unit ~= ""
          set_param(block_path, "x_unit", x_unit);
        end  % if

        f = App.TableValuesUI.Value;
        set_param(block_path, "f", f)

        f_unit = App.TableValuesUI.UnitAlias;
        if f_unit ~= ""
          set_param(block_path, "f_unit", f_unit);
        end  % if

        interp_method = "simscape.enum.interpolation." + lower(App.InterpUI.Value);
        set_param(block_path, "interp_method", interp_method)

        extrap_method = "simscape.enum.extrapolation." + lower(App.ExtrapUI.Value);
        set_param(block_path, "extrap_method", extrap_method)

      % -----------------------------------------------------------------------
      else
        % Simulink 1-D Lookup Table block
        % Physical unit setting is ignored.

        x = App.TableGridVectorUI.Value;
        set_param(block_path, "BreakpointsForDimension1", x)

        f = App.TableValuesUI.Value;
        set_param(block_path, "Table", f)

        interp_method = App.InterpUI.Value;
        if interp_method == "Smooth"
          set_param(block_path, "InterpMethod", "Akima spline")
          % Extrapolation method is automatically set to "Akima spline" by the block.

        else
          % Linear
          set_param(block_path, "InterpMethod", "Linear point-slope")
          % Linear point-slope interpolation supports "Clip", "Linear", or "Cubic spline" for extrapolation.
          % Use "Linear" here.
          set_param(block_path, "ExtrapMethod", "Linear")

        end  % if
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

      design_matrix_text = App.MatrixTextUI.ValueString;
      if design_matrix_text == ""
        % Signal design matrix is required to make a plot.

        return

      end  % if

      design_matrix_text = join(App.MatrixTextUI.ValueString, " ");
      design_matrix = evalin("base", design_matrix_text);  % !todo: Avoid evaluation.
      result = SignalTool3.getVectorsFromSignalDesignMatrix(design_matrix);
      x_data = result.X;
      y_data = result.F;

      interp_method = App.InterpUI.Value;
      extrap_method = App.ExtrapUI.Value;

      dx_ssc = App.IntervalUI.SimscapeValue;
      dx = value(dx_ssc);

      if App.AutoRangeUI.Value
        vec = CodeTool1.getNumberArrayFromString(App.TableGridVectorUI.Value);
        lb = vec(1);
        ub = vec(end);

        App.LowerUI.NameUI.Visible = "off";
        App.UpperUI.NameUI.Visible = "off";

        App.LowerUI.ValueEditFieldUI.Visible = "off";
        App.UpperUI.ValueEditFieldUI.Visible = "off";

        App.LowerUI.UnitLabelUI.Visible = "off";
        App.UpperUI.UnitLabelUI.Visible = "off";

      else
        App.LowerUI.NameUI.Visible = "on";
        App.UpperUI.NameUI.Visible = "on";

        App.LowerUI.ValueEditFieldUI.Visible = "on";
        App.UpperUI.ValueEditFieldUI.Visible = "on";

        App.LowerUI.UnitLabelUI.Visible = "on";
        App.UpperUI.UnitLabelUI.Visible = "on";

        lb_ssc = App.LowerUI.SimscapeValue;
        lb = value(lb_ssc);

        ub_ssc = App.UpperUI.SimscapeValue;
        ub = value(ub_ssc);

      end  % if

      SignalTool3.plotLookupTable1D( ...
        x_data, y_data, ...
        Interpolation = interp_method, ...
        Extrapolation = extrap_method, ...
        InterpolationInterval = dx, ...
        PlotXLowerBound = lb, ...
        PlotXUpperBound = ub, ...
        ParentAxes = ax, ...
        Title = App.BlockPath, ...
        XUnitText = App.TableGridVectorUI.UnitAlias, ...
        YUnitText = App.TableValuesUI.UnitAlias );

    end  % function

  end  % methods

end  % classdef
