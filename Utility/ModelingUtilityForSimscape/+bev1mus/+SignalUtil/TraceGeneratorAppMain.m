classdef TraceGeneratorAppMain < handle
  % Generate smooth signal data for a 1-D lookup-table.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TraceGeneratorAppMain:"
  end  % properties

  properties
    ModelFileFullPath (1,1) string = ""
    BlockPath (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts

    Window bev1mus.AppUtil.AppWindow

    RandomSeedUI bev1mus.AppUtil.Component.DoubleValueUI

    InitialValueUI bev1mus.AppUtil.Component.DoubleValueUI
    InitialValueDurationUI bev1mus.AppUtil.Component.DoubleValueUI

    FirstTransitionDurationUI bev1mus.AppUtil.Component.DoubleValueUI

    NumberOfTransitionsUI bev1mus.AppUtil.Component.DoubleValueUI
    TransitionDurationRangeUI bev1mus.AppUtil.Component.DoubleValueUI
    ConstantDurationRangeUI bev1mus.AppUtil.Component.DoubleValueUI
    ValueRangeUI bev1mus.AppUtil.Component.DoubleValueUI

    FinalTransitionDurationUI bev1mus.AppUtil.Component.DoubleValueUI

    FinalValueUI bev1mus.AppUtil.Component.DoubleValueUI
    FinalValueDurationUI bev1mus.AppUtil.Component.DoubleValueUI

    TableGridVectorUI bev1mus.AppUtil.Component.DoubleValueUI
    TableValuesUI bev1mus.AppUtil.Component.DoubleValueUI

    UpdateButtonUI bev1mus.AppUtil.Component.EnabledButton
    OpenInFigureWindowUI bev1mus.AppUtil.Component.Hyperlink
    AxesUI bev1mus.AppUtil.Graphics.Axes
    IntervalUI bev1mus.AppUtil.Component.DoubleValueUI

    SelectorUI bev1mus.AppUtil.Component.BlockSelectorUI
  end  % properties

  properties (Constant, Access=private)
    width_unit = bev1mus.AppUtil.Constant.Width{"unitwidth"}
    name_ui_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 22
    button_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12

    oneline_height = bev1mus.AppUtil.Constant.Height{"oneline"}
  end  % properties

  methods

    function App = TraceGeneratorAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.BlockPath (1,1) string = ""

        NameValuePair.RandomSeed (1,1) string = "4";

        NameValuePair.InitialValue (1,1) string = "0"
        NameValuePair.InitialValueDuration (1,1) string = "10"

        NameValuePair.FirstTransitionDuration (1,1) string = "10"

        NameValuePair.ValueRange (1,1) string = "[20, 50]"
        NameValuePair.NumberOfTransitions (1,1) string = "2"
        NameValuePair.TransitionDurationRange (1,1) string = "[5, 10]"
        NameValuePair.ConstantDurationRange (1,1) string = "[5, 10]"

        NameValuePair.FinalTransitionDuration (1,1) string = "15"

        NameValuePair.FinalValue (1,1) string = "0"
        NameValuePair.FinalValueDuration (1,1) string = "10"
      end  % arguments

      % Do not declare the output arguments for a class constructor.

      % -----------------------------------------------------------------------
      % Before building app GUI

      if NameValuePair.BlockPath ~= ""
        model_name = extractBefore(NameValuePair.BlockPath, "/");
        App.ModelFileFullPath = bev1mus.FileUtil.getFileFullPath(model_name);
        App.BlockPath = NameValuePair.BlockPath;
      end  % if

      main_figure = uifigure(Visible="off");

      meta_data = metaclass(App);

      App.Window = bev1mus.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bev1mus.CodeUtil.i18n("Trace Generator App");
      App.Window.Height = 500;
      App.Window.Width = 900;

      % -----------------------------------------------------------------------
      build_app_gui(App)
      % -----------------------------------------------------------------------
      % After building app GUI

      if NameValuePair.BlockPath ~= ""
        App.SelectorUI.ModelFileFullPath = App.ModelFileFullPath;
        App.SelectorUI.BlockPath = App.BlockPath;
      end  % if

      App.RandomSeedUI.ValueText = NameValuePair.RandomSeed;

      App.InitialValueUI.ValueText = NameValuePair.InitialValue;
      App.InitialValueDurationUI.ValueText = NameValuePair.InitialValueDuration;

      App.FirstTransitionDurationUI.ValueText = NameValuePair.FirstTransitionDuration;

      App.ValueRangeUI.ValueText = NameValuePair.ValueRange;
      App.NumberOfTransitionsUI.ValueText = NameValuePair.NumberOfTransitions;
      App.TransitionDurationRangeUI.ValueText = NameValuePair.TransitionDurationRange;
      App.ConstantDurationRangeUI.ValueText = NameValuePair.ConstantDurationRange;

      App.FinalTransitionDurationUI.ValueText = NameValuePair.FinalTransitionDuration;

      App.FinalValueUI.ValueText = NameValuePair.FinalValue;
      App.FinalValueDurationUI.ValueText = NameValuePair.FinalValueDuration;

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
      html_file = bev1mus.CodeUtil.i18n("TraceGeneratorApp_Description_bev1mus.html");
      bev1mus.FileUtil.getFileFullPath(html_file);

      link_ui = bev1mus.AppUtil.Component.Hyperlink(left_column_grid);
      link_ui.Text = bev1mus.CodeUtil.i18n("Description");
      link_ui.HyperlinkClickedCallback =  @() web(html_file);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      label_ui = bev1mus.AppUtil.Component.Label(left_column_grid);
      label_ui.Text = bev1mus.CodeUtil.i18n("\textbf{Parameters}");

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.RandomSeedUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.RandomSeedUI.NameText = bev1mus.CodeUtil.i18n("Random seed");
      App.RandomSeedUI.NameUIWidth = App.name_ui_width;
      App.RandomSeedUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.InitialValueUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.InitialValueUI.NameText = bev1mus.CodeUtil.i18n("Initial value, $f_0$");
      App.InitialValueUI.NameUIWidth = App.name_ui_width;
      App.InitialValueUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.InitialValueDurationUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.InitialValueDurationUI.NameText = bev1mus.CodeUtil.i18n("Initial value duration, $d_0$");
      App.InitialValueDurationUI.NameUIWidth = App.name_ui_width;
      App.InitialValueDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.FirstTransitionDurationUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.FirstTransitionDurationUI.NameText = bev1mus.CodeUtil.i18n("Initial transition duration, $h_0$");
      App.FirstTransitionDurationUI.NameUIWidth = App.name_ui_width;
      App.FirstTransitionDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.ValueRangeUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.ValueRangeUI.NameText = bev1mus.CodeUtil.i18n("Value range, $V$");
      App.ValueRangeUI.NameUIWidth = App.name_ui_width;
      App.ValueRangeUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.NumberOfTransitionsUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.NumberOfTransitionsUI.NameText = bev1mus.CodeUtil.i18n("Number of transitions, $n$");
      App.NumberOfTransitionsUI.NameUIWidth = App.name_ui_width;
      App.NumberOfTransitionsUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.TransitionDurationRangeUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.TransitionDurationRangeUI.NameText = bev1mus.CodeUtil.i18n("Transition duration range, $T$");
      App.TransitionDurationRangeUI.NameUIWidth = App.name_ui_width;
      App.TransitionDurationRangeUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.ConstantDurationRangeUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.ConstantDurationRangeUI.NameText = bev1mus.CodeUtil.i18n("Constant duration range, $C$");
      App.ConstantDurationRangeUI.NameUIWidth = App.name_ui_width;
      App.ConstantDurationRangeUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.FinalTransitionDurationUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.FinalTransitionDurationUI.NameText = bev1mus.CodeUtil.i18n("Final transition duration, $h_f$");
      App.FinalTransitionDurationUI.NameUIWidth = App.name_ui_width;
      App.FinalTransitionDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.FinalValueUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.FinalValueUI.NameText = bev1mus.CodeUtil.i18n("Final value, $f_f$");
      App.FinalValueUI.NameUIWidth = App.name_ui_width;
      App.FinalValueUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.FinalValueDurationUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.FinalValueDurationUI.NameText = bev1mus.CodeUtil.i18n("Final value duration, $d_f$");
      App.FinalValueDurationUI.NameUIWidth = App.name_ui_width;
      App.FinalValueDurationUI.ValueChangedCallback = @() auto_update_plot(App);

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      label_ui = bev1mus.AppUtil.Component.Label(left_column_grid);
      label_ui.Text = bev1mus.CodeUtil.i18n("\textbf{Derived parameters}");

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.TableGridVectorUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.TableGridVectorUI.NameText = bev1mus.CodeUtil.i18n("Table grid vector, $x$");
      App.TableGridVectorUI.NameUIWidth = App.name_ui_width;
      App.TableGridVectorUI.ReadOnlyValueText = true;

      % -----------------------------------------------------------------------
      left_column_grid = addVerticalGridLayout(left_vertical_container);

      App.TableValuesUI = bev1mus.AppUtil.Component.DoubleValueUI(left_column_grid);
      App.TableValuesUI.NameText = bev1mus.CodeUtil.i18n("Table values, $f(x)$");
      App.TableValuesUI.NameUIWidth = App.name_ui_width;
      App.TableValuesUI.ReadOnlyValueText = true;

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
      App.OpenInFigureWindowUI.Text = bev1mus.CodeUtil.i18n("Open in figure window");
      App.OpenInFigureWindowUI.HorizontalAlignment = "right";
      App.OpenInFigureWindowUI.HyperlinkClickedCallback = @() update_plot(App, StandAloneFigure=true);

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);

      App.AxesUI = bev1mus.AppUtil.Graphics.Axes(right_column_grid);
      App.AxesUI.ComponentHeight = 326;

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);

      label_ui = bev1mus.AppUtil.Component.Label(right_column_grid);
      label_ui.Text = bev1mus.CodeUtil.i18n("\textbf{Visualization parameter}");

      % -----------------------------------------------------------------------
      right_column_grid = addVerticalGridLayout(right_vertical_container);

      App.IntervalUI = bev1mus.AppUtil.Component.DoubleValueUI(right_column_grid);
      App.IntervalUI.NameText = bev1mus.CodeUtil.i18n("Interpolation interval");
      App.IntervalUI.NameUIWidth = App.name_ui_width;
      App.IntervalUI.ValueText = "0.1";
      App.IntervalUI.ValueChangedCallback = @() auto_update_plot(App);

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
      App.SelectorUI.SetOnly = true;
      App.SelectorUI.SetParametersToBlockCallback = @() setParam(App);

    end  % function

    function setParam(App)
      %%
      % Transfer the settings of x, f(x), interpolation, and extrapolation to the block.
 
      block_path = App.SelectorUI.BlockPath;

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

        f = App.TableValuesUI.ValueText;
        set_param(block_path, "f", f)

        set_param(block_path, "interp_method", "simscape.enum.interpolation.smooth")
        set_param(block_path, "extrap_method", "simscape.enum.extrapolation.nearest")

      % -----------------------------------------------------------------------
      else
        % Simulink 1-D Lookup Table block

        x = App.TableGridVectorUI.ValueText;
        set_param(block_path, "BreakpointsForDimension1", x)

        f = App.TableValuesUI.ValueText;
        set_param(block_path, "Table", f)

        set_param(block_path, "InterpMethod", "Akima spline")
        % Extrapolation method is automatically set to "Akima spline" by the block.

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

      data_table = get_signal_design_matrix_from_UI_components(App);
      if isempty(data_table)

        return

      end  % if

      x_data = data_table.X;
      f_data = data_table.F;

      App.TableGridVectorUI.ValueText = bev1mus.CodeUtil.stringify(x_data');
      App.TableGridVectorUI.ValueTextUI.MainEditField.Tooltip = App.TableGridVectorUI.ValueText;

      App.TableValuesUI.ValueText = bev1mus.CodeUtil.stringify(f_data');
      App.TableValuesUI.ValueTextUI.MainEditField.Tooltip = App.TableValuesUI.ValueText;

      dx = bev1mus.CodeUtil.getNumericValueFromText(App.IntervalUI.ValueText);

      bev1mus.SignalUtil.plotLookupTable1D( ...
        x_data, f_data, ...
        Interpolation = "Smooth", ...
        Extrapolation = "Nearest", ...
        InterpolationInterval = dx, ...
        PlotXLowerBound = x_data(1), ...
        PlotXUpperBound = x_data(end), ...
        ParentAxes = ax, ...
        Title = App.BlockPath, ...
        XLabel = "Input $x$", ...
        YLabel = "Output $f$");

    end  % function

    function data_table = get_signal_design_matrix_from_UI_components(App)

      arguments (Input)
        App
      end  % arguments

      arguments (Output)
        data_table table
      end  % arguments

      try
        random_seed = bev1mus.CodeUtil.getNumericValueFromText(App.RandomSeedUI.ValueText);
        initial_value = bev1mus.CodeUtil.getNumericValueFromText(App.InitialValueUI.ValueText);
        initial_value_duration = bev1mus.CodeUtil.getNumericValueFromText(App.InitialValueDurationUI.ValueText);
        initial_transition_duration = bev1mus.CodeUtil.getNumericValueFromText(App.FirstTransitionDurationUI.ValueText);

        num_trans = bev1mus.CodeUtil.getNumericValueFromText(App.NumberOfTransitionsUI.ValueText);

        trans_du_range = App.TransitionDurationRangeUI.ValueText;

        range_of_transition_duration = bev1mus.CodeUtil.getNumberArrayFromText(trans_du_range);

        const_dur_range = App.ConstantDurationRangeUI.ValueText;

        range_of_constant_duration = bev1mus.CodeUtil.getNumberArrayFromText(const_dur_range);

        dat_val_range = App.ValueRangeUI.ValueText;

        range_of_data_value = bev1mus.CodeUtil.getNumberArrayFromText(dat_val_range);

        final_transition_duration = bev1mus.CodeUtil.getNumericValueFromText(App.FinalTransitionDurationUI.ValueText);

        final_value = bev1mus.CodeUtil.getNumericValueFromText(App.FinalValueUI.ValueText);

        final_value_duration = bev1mus.CodeUtil.getNumericValueFromText(App.FinalValueDurationUI.ValueText);

      catch exception

        rethrow(exception)

      end  % try, catch

      signal_design_matrix = bev1mus.SignalUtil.generateSignalDesignMatrixFromTraceProperties(...
        RandomSeed = random_seed, ...
        FInitialValue = initial_value, ...
        XInitialFlatLength = initial_value_duration, ...
        XInitialTransitionLength = initial_transition_duration, ...
        NumTransitions = num_trans, ...
        TransitionXRange = range_of_transition_duration, ...
        FlatXRange = range_of_constant_duration, ...
        FRange = range_of_data_value, ...
        XFinalTransitionLength = final_transition_duration, ...
        XFinalFlatLength = final_value_duration, ...
        FFinalValue = final_value );

      data_table = bev1mus.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

    end  % function

  end  % methods
end  % classdef
