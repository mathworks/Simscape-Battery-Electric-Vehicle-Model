classdef TestResultAppMain < handle
  % App for navigating a test result
  %
  % This is the main implementation of the app.

  % Copyright 2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TestResultAppMain:"
  end  % properties

  properties

    TestResultFile (1,1) string = ""
    TestResultTable table

    % -------------------------------------------------------------------------
    % GUI parts

    AppWindowHeight (1,1) {mustBeInteger, mustBePositive} = 500
    AppWindowWidth (1,1) {mustBeInteger, mustBePositive} = 900

    GUIReady (1,1) logical = false

    Window bevutil1.AppUtil.AppWindow

    SelectFileButtonUI bevutil1.AppUtil.Component.Button
    OpenInEditorButtonUI bevutil1.AppUtil.Component.Button
    TestResultFileDropDownUI bevutil1.AppUtil.Component.DropDown

    NumTestsUI bevutil1.AppUtil.Component.Label
    TotalTimeUI bevutil1.AppUtil.Component.Label
    MeanTimeUI bevutil1.AppUtil.Component.Label
    MedianTimeUI bevutil1.AppUtil.Component.Label

    NumErrorsUI bevutil1.AppUtil.Component.Label

    RefreshButtonUI bevutil1.AppUtil.Component.Button

    ResultTableUI bevutil1.AppUtil.Component.Table

    MessageUI bevutil1.AppUtil.Component.Label
  end  % properties

  properties (Constant, Access=private)
    width_button = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
    style_for_error = uistyle(BackgroundColor = "yellow")
    default_message = bevutil1.CodeUtil.i18n("Double-click a table row to open the file. (The file must exist.)")
  end  % properties

  properties (Access=private)
    deferred_message (1,1) timer = timer
  end  % properties

  methods

    function App = TestResultAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.TestResultFileName (1,1) string = ""
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      meta_data = metaclass(App);

      main_figure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = bevutil1.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bevutil1.CodeUtil.i18n("Test result");
      App.Window.Height = App.AppWindowHeight;
      App.Window.Width = App.AppWindowWidth;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if NameValuePair.TestResultFileName == ""
        % Do nothing

      elseif isfile(NameValuePair.TestResultFileName)
        styled_path = replace(NameValuePair.TestResultFileName, ("/"|"\"), " > ");
        App.TestResultFileDropDownUI.Items = styled_path;
        App.TestResultFileDropDownUI.Value = styled_path;

      else
        id = App.errorID + "InvalidFile";
        msg = bevutil1.CodeUtil.i18n("Invalid file: ") + NameValuePair.TestResultFileName;

        throw(MException(id, msg))

      end  % if

      App.deferred_message.StartDelay = 3;  % seconds
      App.deferred_message.TimerFcn = @(~,~) show_default_message(App);

      App.GUIReady = true;

      % -----------------------------------------------------------------------
      movegui(main_figure, "center")
      main_figure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function show_default_message(App)
      App.MessageUI.Text = App.default_message;
      drawnow
    end  % function

    function build_app_gui(App)
      %%
      main_vertical_container = App.Window.MainVerticalContainer;

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.ComponentWidth = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 14;
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Test result file") + "}";

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.SelectFileButtonUI = bevutil1.AppUtil.Component.Button(row_grid);
      App.SelectFileButtonUI.ButtonWidth = App.width_button;
      App.SelectFileButtonUI.Text = bevutil1.CodeUtil.i18n("Select...");
      App.SelectFileButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Select a test result file.");
      App.SelectFileButtonUI.ButtonPushedCallback = @() react_SelectResultFileButtonPushed(App);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.OpenInEditorButtonUI = bevutil1.AppUtil.Component.Button(row_grid);
      App.OpenInEditorButtonUI.ButtonWidth = App.width_button;
      App.OpenInEditorButtonUI.Text = bevutil1.CodeUtil.i18n("Open in editor");
      App.OpenInEditorButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Open the test result file in the editor.");
      App.OpenInEditorButtonUI.ButtonPushedCallback = @() react_OpenFileInEditorButtonPushed(App);
      App.OpenInEditorButtonUI.MainButton.Enable = "off";

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);

      App.TestResultFileDropDownUI = bevutil1.AppUtil.Component.DropDown(column_grid);
      App.TestResultFileDropDownUI.Items = [];
      App.TestResultFileDropDownUI.ValueChangedCallback = @() react_ResultFileNameDropDownChanged(App);

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Number of tests");
      row_grid = addHorizontalGridLayout(horizontal_container);
      App.NumTestsUI = bevutil1.AppUtil.Component.Label(row_grid);
      App.NumTestsUI.Text = "";

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Total test time (s)");
      row_grid = addHorizontalGridLayout(horizontal_container);
      App.TotalTimeUI = bevutil1.AppUtil.Component.Label(row_grid);
      App.TotalTimeUI.Text = "";

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Mean test time (s)");
      row_grid = addHorizontalGridLayout(horizontal_container);
      App.MeanTimeUI = bevutil1.AppUtil.Component.Label(row_grid);
      App.MeanTimeUI.Text = "";

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Median test time (s)");
      row_grid = addHorizontalGridLayout(horizontal_container);
      App.MedianTimeUI = bevutil1.AppUtil.Component.Label(row_grid);
      App.MedianTimeUI.Text = "";

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bevutil1.AppUtil.Component.Label(row_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Number of failures");
      row_grid = addHorizontalGridLayout(horizontal_container);
      App.NumErrorsUI = bevutil1.AppUtil.Component.Label(row_grid);
      App.NumErrorsUI.Text = "";

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      bevutil1.AppUtil.Component.HorizontalLine(column_grid);

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.RefreshButtonUI = bevutil1.AppUtil.Component.Button(row_grid);
      App.RefreshButtonUI.Text = bevutil1.CodeUtil.i18n("Refresh");
      App.RefreshButtonUI.ButtonWidth = App.width_button;
      App.RefreshButtonUI.HorizontalAlignment = "right";
      App.RefreshButtonUI.ButtonPushedCallback = @() update_ui(App);
      App.RefreshButtonUI.MainButton.Enable = "off";

      % =======================================================================

      % Expand the uitable vertically to fit the available height of the app window.
      column_grid = addVerticalGridLayout(main_vertical_container, Height="1x");  % !vertical-expansion

      App.ResultTableUI = bevutil1.AppUtil.Component.Table(column_grid);

      % Expand the uitable vertically to fit the available height of the app window.
      App.ResultTableUI.ComponentHeight = "1x";  % !vertical-expansion

      App.ResultTableUI.MainTable.Data = table.empty;
      % uitable's DoubleClickedFcn callback is given a DoubleClickedData object as the second argument,
      % and the object provides information such as the clicked row via InteractionInformation.Row, etc.
      % Search "DoubleClickedData" or "InteractionInformation" in the documentation for details.
      % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
      App.ResultTableUI.MainTable.DoubleClickedFcn = @(~, DoubleClickedData) ...
        react_TableRowDoubleClicked(App, DoubleClickedData.InteractionInformation.Row);

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);

      App.MessageUI = bevutil1.AppUtil.Component.Label(column_grid);
      App.MessageUI.Text = bevutil1.CodeUtil.i18n("Double-click a table row to open the file.");

    end  % function

    function react_SelectResultFileButtonPushed(App)
      % Open a dialog window to interactively get a test result file name from the user.
      [file, location] = uigetfile('*.xml');
      if not(isequal(file, 0))
        file_fullpath = fullfile(location, file);
        styled_path = replace(file_fullpath, ("/"|"\"), " > ");
        if isempty(App.TestResultFileDropDownUI.Items)
          App.TestResultFileDropDownUI.Items = styled_path;
        elseif not(ismember(styled_path, App.TestResultFileDropDownUI.Items))
          App.TestResultFileDropDownUI.Items(end + 1) = styled_path;
        end  % if
        App.TestResultFileDropDownUI.MainDropDown.Value = styled_path;
        App.TestResultFile = file_fullpath;
        update_ui(App)
      else
        % User cancelled selecting file.

        return

      end  % if
    end  % function

    function react_ResultFileNameDropDownChanged(App)
      new_styled_path = App.TestResultFileDropDownUI.Value;
      if new_styled_path == ""
        clear_ui(App)

        return

      else
        raw_path = replace(new_styled_path, " > ", filesep);
        if not(isfile(raw_path))
          msg = bevutil1.CodeUtil.i18n("Invalid file: " + raw_path);
          if App.GUIReady
            window_title = bevutil1.CodeUtil.i18n("Error");
            uialert(App.Window.MainFigure, msg, window_title)

            return

          else
            id = App.errorID + "InvalidFile";

            throw(MException(id, msg))

          end  % if
        end  % if
        if not(ismember(new_styled_path, App.TestResultFileDropDownUI.Items))
          App.TestResultFileDropDownUI.Items = [App.TestResultFileDropDownUI.Items; new_styled_path];
        end  % if
      end  % if
      raw_path = replace(new_styled_path, " > ", filesep);
      App.TestResultFile = raw_path;
      update_ui(App)
    end  % function

    function react_OpenFileInEditorButtonPushed(App)
      % Open the test result XML file.
      if isempty(App.TestResultFileDropDownUI.Items)

        return

      end  % if
      target_file = replace(App.TestResultFileDropDownUI.Value, " > ", filesep);
      edit(target_file);
    end  % function

    function react_TableRowDoubleClicked(App, row_number)
      % Open the test implementation file selected in the table.
      clicked_row = App.TestResultTable(row_number, :);

      targetfile_filename = clicked_row.TestClass + ".m";

      % targetfile_fullpath = fullfile(top_folder, clicked_row.TestClass + ".m");

      % The folder where the test result XML file is stored may not be the folder where
      % the target test implementation file is stored.
      % Find the file in MATLAB path.
      targetfile_fullpath = bevutil1.FileUtil.getFileFullPath(targetfile_filename, ReturnIfNotFound=true);

      if targetfile_fullpath == ""
        App.MessageUI.Text = bevutil1.CodeUtil.i18n("File not found.");
        start(App.deferred_message)

        return

      end  % if
      target_function = clicked_row.TestFunction;
      matlab.desktop.editor.openAndGoToFunction(targetfile_fullpath, target_function);
    end  % function

    function update_ui(App)
      result_table = bevutil1.TestUtil.getTestResultTable(App.TestResultFile);
      App.TestResultTable = result_table;

      % Update the impacted components.

      App.OpenInEditorButtonUI.MainButton.Enable = "on";

      App.NumTestsUI.Text = result_table.Properties.CustomProperties.NumberOfTests;
      App.TotalTimeUI.Text = result_table.Properties.CustomProperties.TotalTestTimeInSeconds;
      App.MeanTimeUI.Text = result_table.Properties.CustomProperties.MeanTestTimeInSeconds;
      App.MedianTimeUI.Text = result_table.Properties.CustomProperties.MedianTestTimeInSeconds;

      App.NumErrorsUI.Text = nnz(not(result_table.TestPassed));

      App.RefreshButtonUI.MainButton.Enable = "on";

      % -----------------------------------------------------------------------
      % ResultTableUI

      App.ResultTableUI.MainTable.Data = result_table;
      App.ResultTableUI.MainTable.SelectionType = "row";

      App.ResultTableUI.MainTable.RowName = "numbered";
      App.ResultTableUI.MainTable.ColumnSortable = true;
      App.ResultTableUI.MainTable.ColumnWidth = {'fit', '1x', '1x', 'fit'};

      removeStyle(App.ResultTableUI.MainTable)
      row = find(not(result_table.TestPassed));
      col = ones(numel(row), 1);
      addStyle(App.ResultTableUI.MainTable, App.style_for_error, "cell", [row,col])

    end  % function

    function clear_ui(App)
      App.TestResultTable = table.empty;
      App.OpenInEditorButtonUI.MainButton.Enable = "off";
      App.NumTestsUI.Text = "";
      App.TotalTimeUI.Text = "";
      App.MeanTimeUI.Text = "";
      App.MedianTimeUI.Text = "";
      App.NumErrorsUI.Text = "";
      App.RefreshButtonUI.MainButton.Enable = "off";
      App.ResultTableUI.MainTable.Data = table.empty;
    end  % function

  end  % methods
end  % classdef
