classdef SignalDesignAppMain < handle
  % This app works with Simscape PS Lookup Table (1D) block to design
  % a signal trace using signal design matrix.
  %
  % This app treats the physical units used in the Table grid vector, x, and
  % the Table values, f(x), of the block as unit alias, rather than simscape.Unit.
  % This app does not modify the physical units in the block parameters.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "SignalDesignAppMain:"
  end  % properties

  properties

    ModelFileFullPath (1,1) string = ""
    BlockPath (1,1) string = ""

    % -------------------------------------------------------------------------

    SignalDesignMatrixText (:,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    Window bev1mus.AppUtil.AppWindow

    MatrixTextUI bev1mus.AppUtil.Component.TextArea
    InterpUI bev1mus.AppUtil.Component.DropDown
    ExtrapUI bev1mus.AppUtil.Component.DropDown

    TableGridVectorUI bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel
    TableValuesUI bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel

    UpdateButtonUI bev1mus.AppUtil.Component.EnabledButton
    OpenInFigureWindowUI bev1mus.AppUtil.Component.Hyperlink
    AxesUI bev1mus.AppUtil.Graphics.Axes
    IntervalUI bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel
    AutoRangeUI bev1mus.AppUtil.Component.CheckBox
    LowerUI bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel
    UpperUI bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel

    SelectorUI bev1mus.AppUtil.Component.BlockSelectorUI

  end  % properties

  properties (Access=private)
    IsValidMatrix (1,1) logical = true
  end  % properties

  properties (Constant, Access=private)

    width_unit = bev1mus.AppUtil.Constant.Width{"unitwidth"}
    name_ui_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 18
    unit_ui_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 8
    button_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12

    oneline_height = bev1mus.AppUtil.Constant.Height{"oneline"}

  end  % properties

  methods

    function App = SignalDesignAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      arguments (Output)
        App bev1mus.SignalUtil.SignalDesignAppMain
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      main_figure = uifigure(Visible="off");

      meta_data = metaclass(App);

      if NameValuePair.BlockPath ~= ""
        model_name = extractBefore(NameValuePair.BlockPath, "/");
        App.ModelFileFullPath = bev1mus.FileUtil.getFileFullPath(model_name);
        App.BlockPath = NameValuePair.BlockPath;
      end  % if

      App.Window = bev1mus.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bev1mus.CodeUtil.i18n("Signal Design App");
      App.Window.Height = 520;
      App.Window.Width = 860;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if NameValuePair.BlockPath ~= ""
        App.SelectorUI.ModelFileFullPath = App.ModelFileFullPath;
        App.SelectorUI.BlockPath = App.BlockPath;
        getParam(App)

      else
        App.MatrixTextUI.ValueString = "[0 2 0; 4 nan 4; 6 8 3]";

      end  % if

      % -----------------------------------------------------------------------
      App.UpdateButtonUI.ButtonDisable = "on";
      auto_update_plot(App)

      movegui(main_figure, "center")
      main_figure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      main_vertical_container = App.Window.MainVerticalContainer;
      main_column_grid = addVerticalGridLayout(main_vertical_container);
      main_horizontal_container = bev1mus.AppUtil.HorizontalContainer(main_column_grid);

      % =======================================================================
      % Left area
      % =======================================================================
      left_row_grid = addHorizontalGridLayout(main_horizontal_container);
      left_vertical_container = bev1mus.AppUtil.VerticalContainer(left_row_grid);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      % Use getFileFullPath to check that the file exists.
      % If it doesn't, an error is issued and the app doesn't start.
      html_file = "SignalDesignApp_Description_bev1mus.html";
      bev1mus.FileUtil.getFileFullPath(html_file);

      link_ui = bev1mus.AppUtil.Component.Hyperlink(left_column_grid);
      link_ui.Text = "Description";
      link_ui.HyperlinkClickedCallback =  @() web(html_file);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      label_ui = bev1mus.AppUtil.Component.Label(left_column_grid);
      label_ui.Text = "Signal design matrix";

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.MatrixTextUI = bev1mus.AppUtil.Component.TextArea(left_column_grid);
      App.MatrixTextUI.UseMonospacedFont = "on";
      App.MatrixTextUI.ComponentHeight = App.oneline_height * 10;
      App.MatrixTextUI.ValueChangedCallback = @() change_design_matrix(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(left_column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bev1mus.AppUtil.Component.Label(row_grid);
      label_ui.Text = "Interpolation method";
      label_ui.ComponentWidth = App.name_ui_width;

      row_grid = addHorizontalGridLayout(horizontal_container);
      App.InterpUI= bev1mus.AppUtil.Component.DropDown(row_grid);
      App.InterpUI.Items = ["Smooth", "Linear"];
      App.InterpUI.Value = "Smooth";
      App.InterpUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(left_column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bev1mus.AppUtil.Component.Label(row_grid);
      label_ui.Text = "Extrapolation method";
      label_ui.ComponentWidth = App.name_ui_width;

      row_grid = addHorizontalGridLayout(horizontal_container);
      App.ExtrapUI= bev1mus.AppUtil.Component.DropDown(row_grid);
      App.ExtrapUI.Items = ["Nearest", "Linear"];
      App.ExtrapUI.Value = "Nearest";
      App.ExtrapUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);
      label_ui = bev1mus.AppUtil.Component.Label(left_column_grid);
      label_ui.Text = "\textbf{Derived parameters}";

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);
      App.TableGridVectorUI = bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel(left_column_grid);
      App.TableGridVectorUI.NameText = "Table grid vector, $x$";
      App.TableGridVectorUI.UnitText = "1";
      App.TableGridVectorUI.NameUIWidth = App.name_ui_width;
      App.TableGridVectorUI.UnitUIWidth = App.unit_ui_width;
      App.TableGridVectorUI.ValueTextUI.ReadOnly = "on";

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);
      App.TableValuesUI = bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel(left_column_grid);
      App.TableValuesUI.NameText = "Table values, $f(x)$";
      App.TableValuesUI.UnitText = "1";
      App.TableValuesUI.NameUIWidth = App.name_ui_width;
      App.TableValuesUI.UnitUIWidth = App.unit_ui_width;
      App.TableValuesUI.ValueTextUI.ReadOnly = "on";

      % =======================================================================
      % Right area
      % =======================================================================
      right_row_grid = addHorizontalGridLayout(main_horizontal_container);
      right_vertical_container = bev1mus.AppUtil.VerticalContainer(right_row_grid);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(right_column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.UpdateButtonUI = bev1mus.AppUtil.Component.EnabledButton(row_grid);
      App.UpdateButtonUI.HorizontalAlignment = "left";
      App.UpdateButtonUI.ButtonUIWidth = App.button_width + App.width_unit;
      App.UpdateButtonUI.ButtonWidth = App.button_width;
      App.UpdateButtonUI.CheckBoxUIWidth = "fit";
      App.UpdateButtonUI.CheckBoxWidth = "fit";
      App.UpdateButtonUI.ButtonText = "Update";
      App.UpdateButtonUI.ButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "tool_rotate_3d.png");
      App.UpdateButtonUI.CheckBoxText = bev1mus.CodeUtil.i18n("Auto update");
      App.UpdateButtonUI.ButtonPushedCallback = @() update_plot(App);
      % Set false to auto-update and keep it until the entire app is ready.
      App.UpdateButtonUI.ButtonEnable = "on";

      row_grid = addHorizontalGridLayout(horizontal_container);
      App.OpenInFigureWindowUI = bev1mus.AppUtil.Component.Hyperlink(row_grid);
      App.OpenInFigureWindowUI.Text = "Open in figure window";
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";
      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() update_plot(App, StandAloneFigure=true);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);

      App.AxesUI = bev1mus.AppUtil.Graphics.Axes(right_column_grid);
      App.AxesUI.ComponentHeight = 300;

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);
      App.IntervalUI = bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel(right_column_grid);
      App.IntervalUI.NameText = "Interpolation interval, $dx$";
      App.IntervalUI.UnitText = "1";
      App.IntervalUI.NameUIWidth = App.name_ui_width;
      App.IntervalUI.UnitUIWidth = App.unit_ui_width;
      App.IntervalUI.ValueText = "0.1";
      App.IntervalUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);
      App.AutoRangeUI = bev1mus.AppUtil.Component.CheckBox(right_column_grid);
      App.AutoRangeUI.Text = "x auto range";
      App.AutoRangeUI.Value = true;
      App.AutoRangeUI.HorizontalAlignment = "left";
      App.AutoRangeUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);
      App.LowerUI = bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel(right_column_grid);
      App.LowerUI.NameText = "Plot x lower bound";
      App.LowerUI.UnitText = "1";
      App.LowerUI.NameUIWidth = App.name_ui_width;
      App.LowerUI.UnitUIWidth = App.unit_ui_width;
      App.LowerUI.ValueText = "0";
      App.LowerUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);
      App.UpperUI = bev1mus.AppUtil.Component.PhysicalValueWithUnitLabel(right_column_grid);
      App.UpperUI.NameText = "Plot x upper bound";
      App.UpperUI.UnitText = "1";
      App.UpperUI.NameUIWidth = App.name_ui_width;
      App.UpperUI.UnitUIWidth = App.unit_ui_width;
      App.UpperUI.ValueText = "10";
      App.UpperUI.ValueChangedCallback = @() auto_update_plot(App);

      % =======================================================================
      % Bottom area
      % =======================================================================
      main_column_grid = addVerticalGridLayout(main_vertical_container);
      bev1mus.AppUtil.Component.HorizontalLine(main_column_grid);

      % -----------------------------------------------------------------------
      % Configure the block selector UI to find Simscape PS Lookup Table (1D) block and
      % Simulink 1-D Lookup Table block.
      main_column_grid = addVerticalGridLayout(main_vertical_container);
      App.SelectorUI = bev1mus.AppUtil.Component.BlockSelectorUI(main_column_grid);
      App.SelectorUI.TargetSimscapeBlockNames = "PS Lookup Table (1D)";
      App.SelectorUI.FindBlockCallback = @bev1mus.ModelUtil.findLookupTable1DBlocks;
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

      result = bev1mus.SignalUtil.getVectorsFromSignalDesignMatrix(design_matrix);

      App.TableGridVectorUI.ValueText = bev1mus.CodeUtil.stringify(result.X');
      App.TableValuesUI.ValueText = bev1mus.CodeUtil.stringify(result.F');

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
        msg = exception.message;
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, msg, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % try, catch

      % Second check as a signal design matrix.
      result = bev1mus.SignalUtil.checkSignalDesignMatrix(design_matrix);
      if not(result.IsValid)
        App.IsValidMatrix = false;
        msg = result.Message;
        if App.Window.MainFigure.Visible
          window_title = "Error";
          uialert(App.Window.MainFigure, msg, window_title)
        else
          disp(msg)
        end  % if

        return

      end  % if

      App.IsValidMatrix = true;
    end  % function

    function getParam(App)
      %%
      % Disable plot auto-update. Restore it at the end of this function.
      % !attention: This logic is vulnerable if there is an error before
      % reaching the end of this function.
      previous_auto_plot_state = App.UpdateButtonUI.CheckBoxUI.Value;
      App.UpdateButtonUI.CheckBoxUI.Value = false;

      % -----------------------------------------------------------------------
      block_path = App.SelectorUI.BlockPath;

      % -----------------------------------------------------------------------
      % Get signal design matrix from the Description property.

      description_text = get_param(block_path, "Description");
      if isempty(description_text)
        % Restore the previous plot auto-update setting.
        App.UpdateButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
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
        App.UpdateButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
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
        bev1mus.SignalUtil.getSignalDesignMatrixFromBlockDescription(block_path);
      catch exception
        % Restore the previous plot auto-update setting.
        App.UpdateButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
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
        if x_unit == "1"
          x_unit = "";
        end  % if
        App.TableGridVectorUI.UnitAlias = x_unit;
        App.IntervalUI.UnitAlias = x_unit;
        App.LowerUI.UnitAlias = x_unit;
        App.UpperUI.UnitAlias = x_unit;

        % ---------------------------------------------------------------------
        % Get the unit of f(x).
        f_unit = get_param(block_path, "f_unit");
        % Use unit alias.
        if f_unit == "1"
          f_unit = "";
        end  % if
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
          App.UpdateButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
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
        % Interpolation method: Extrapolation method
        %   Akima spline: "Akima spline"
        %   Linear point-slope: "Clip", "Linear", "Cubic spline"
        %   Flat: "Clip"
        App.ExtrapUI.Value = "Nearest";

      end  % if

      % -----------------------------------------------------------------------
      % Set plot properties: x lower bound, x upper bound, and interpolation interval
      design_matrix_text = join(App.MatrixTextUI.ValueString, " ");
      design_matrix = evalin("base", design_matrix_text);  % !todo: Avoid evaluation.
      result = bev1mus.SignalUtil.getVectorsFromSignalDesignMatrix(design_matrix);
      x_data = result.X;
      x_min = min(x_data);
      x_max = max(x_data);
      App.LowerUI.ValueText = num2str(x_min);
      App.UpperUI.ValueText = num2str(x_max);
      dx = (x_max - x_min) / 200;  % Try 200 divisions as the first dx value.
      App.IntervalUI.ValueText = num2str(dx);

      % -----------------------------------------------------------------------
      % Restore the previous plot auto-update setting.
      App.UpdateButtonUI.CheckBoxUI.Value = previous_auto_plot_state;
      auto_update_plot(App)
    end  % function

    function setParam(App)
      %%
      % Transfer the settings of x, f(x), interpolation, and extrapolation to the block.
      % Physical unit is supported for Simscape PS Lookup Table (1D) block only.
 
      block_path = App.SelectorUI.BlockPath;

      design_matrix_text = join(App.MatrixTextUI.ValueString, newline);
      description_text = join([
        "% This text was automatically inserted by Signal Util."
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

        x = App.TableGridVectorUI.ValueText;
        set_param(block_path, "x", x)

        x_unit = App.TableGridVectorUI.UnitAlias;
        if x_unit ~= ""
          set_param(block_path, "x_unit", x_unit);
        end  % if

        f = App.TableValuesUI.ValueText;
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
      if App.UpdateButtonUI.CheckBoxUI.Value

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
      result = bev1mus.SignalUtil.getVectorsFromSignalDesignMatrix(design_matrix);
      x_data = result.X;
      y_data = result.F;

      interp_method = App.InterpUI.Value;
      extrap_method = App.ExtrapUI.Value;

      dx_ssc = App.IntervalUI.SimscapeValue;
      dx = value(dx_ssc);

      if App.AutoRangeUI.Value
        vec = bev1mus.CodeUtil.getNumberArrayFromText(App.TableGridVectorUI.ValueText);
        lb = vec(1);
        ub = vec(end);

        App.LowerUI.ValueTextUI.MainEditField.Enable = "off";
        App.UpperUI.ValueTextUI.MainEditField.Enable = "off";
        % 
        % App.LowerUI.UnitLabelUI.Visible = "off";
        % App.UpperUI.UnitLabelUI.Visible = "off";

      else
        App.LowerUI.ValueTextUI.MainEditField.Enable = "on";
        App.UpperUI.ValueTextUI.MainEditField.Enable = "on";
        % 
        % App.LowerUI.UnitLabelUI.Visible = "on";
        % App.UpperUI.UnitLabelUI.Visible = "on";

        lb_ssc = App.LowerUI.SimscapeValue;
        lb = value(lb_ssc);

        ub_ssc = App.UpperUI.SimscapeValue;
        ub = value(ub_ssc);

      end  % if

      bev1mus.SignalUtil.plotLookupTable1D( ...
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
