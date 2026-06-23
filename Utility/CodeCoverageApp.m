function App = CodeCoverageApp(CodeCoverageFile)
% App to view code coverage and double-click to open the code file
%
% This app takes a code coverage XML file which the Build Tool generated.
% This function internally builds a table containing LineCoverage, Name, and
% FilePath columns using the getCodeCoverageTable function in the TestUtil
% and shows the table. Double-click a row in the table to open the code file.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  CodeCoverageFile (1,1) string = ""
end  % arguments

arguments (Output)
  App struct
end  % arguments

code_coverage_table = [];

main_figure = uifigure(Visible="off");

app_window = AppUtil1.AppWindow(main_figure, SourceFile=mfilename);
app_window.Width = 900;
app_window.Height = 450;
app_window.Name = CodeUtil1.i18n("Code coverage");

main_vertical_container = app_window.MainVerticalContainer;

% -----------------------------------------------------------------------
column_grid = addVerticalGridLayout(main_vertical_container);
horizontal_container = AppUtil1.HorizontalContainer(column_grid);

row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
label_ui = AppUtil1.Component.Label(row_grid);
label_ui.MainFigure = main_figure;
label_ui.Text = CodeUtil1.i18n("Code coverage file");

row_grid = addHorizontalGridLayout(horizontal_container);
button_ui = AppUtil1.Component.Button(row_grid);
button_ui.MainFigure = main_figure;
button_ui.ComponentWidth = 120;
button_ui.Text = CodeUtil1.i18n("Select...");
button_ui.ButtonPushedCallback = @() react_SelectButtonPushed();

% -----------------------------------------------------------------------
column_grid = addVerticalGridLayout(main_vertical_container);
horizontal_container = AppUtil1.HorizontalContainer(column_grid);

row_grid = addHorizontalGridLayout(horizontal_container);
link_ui = AppUtil1.Component.Hyperlink(row_grid);
link_ui.MainFigure = main_figure;
link_ui.Text = "";

% -----------------------------------------------------------------------
column_grid = addVerticalGridLayout(main_vertical_container);
horizontal_container = AppUtil1.HorizontalContainer(column_grid);

% ---
row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
label_ui = AppUtil1.Component.Label(row_grid);
label_ui.MainFigure = main_figure;
label_ui.Text = CodeUtil1.i18n("Omit coverage above:");

row_grid = addHorizontalGridLayout(horizontal_container);
cov_threshold_ui = AppUtil1.Component.Label(row_grid);
cov_threshold_ui.MainFigure = main_figure;
cov_threshold_ui.Text = "";

% ---
row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
label_ui = AppUtil1.Component.Label(row_grid);
label_ui.MainFigure = main_figure;
label_ui.Text = CodeUtil1.i18n("Overall line coverage:");

row_grid = addHorizontalGridLayout(horizontal_container);
line_coverage_ui = AppUtil1.Component.Label(row_grid);
line_coverage_ui.MainFigure = main_figure;
line_coverage_ui.Text = "";

% ---
row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
label_ui = AppUtil1.Component.Label(row_grid);
label_ui.MainFigure = main_figure;
label_ui.Text = CodeUtil1.i18n("Lines covered:");

row_grid = addHorizontalGridLayout(horizontal_container);
lines_covered_ui = AppUtil1.Component.Label(row_grid);
lines_covered_ui.MainFigure = main_figure;
lines_covered_ui.Text = "";

% ---
row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
label_ui = AppUtil1.Component.Label(row_grid);
label_ui.MainFigure = main_figure;
label_ui.Text = CodeUtil1.i18n("Lines valid:");

row_grid = addHorizontalGridLayout(horizontal_container);
lines_valid_ui = AppUtil1.Component.Label(row_grid);
lines_valid_ui.MainFigure = main_figure;
lines_valid_ui.Text = "";

% -----------------------------------------------------------------------
% column_grid = addVerticalGridLayout(main_vertical_container);
% AppUtil1.Component.HorizontalLine(column_grid);

% -----------------------------------------------------------------------
column_grid = addVerticalGridLayout(main_vertical_container, Height="1x");  % !vertical-expansion

table_ui = AppUtil1.Component.Table(column_grid);
table_ui.MainFigure = main_figure;
table_ui.ComponentHeight = "1x";  % !vertical-expansion
table_ui.MainTable.Data = table.empty;
% uitable's DoubleClickedFcn callback is given a DoubleClickedData object as the second argument,
% and the object provides information such as the clicked row via InteractionInformation.Row, etc.
% Search "DoubleClickedData" or "InteractionInformation" in the documentation for details.
% https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
table_ui.MainTable.DoubleClickedFcn = @(~, DoubleClickedData) ...
  react_TableDoubleClicked(DoubleClickedData.InteractionInformation.Row);

  function react_SelectButtonPushed
    % Open a dialog window to interactively get a code coverage file name from the user.
    [file, location] = uigetfile('*.xml');
    if not(isequal(file, 0))
      CodeCoverageFile = fullfile(location, file);
      update_ui()

    else
      % User cancelled selecting file.

      return

    end  % if
  end  % nested function

  function update_ui
    try
      code_coverage_table = TestUtil1.getCodeCoverageTable(CodeCoverageFile);
    catch exception
      window_title = CodeUtil1.i18n("Error");
      msg = CodeUtil1.i18n("There was an error in obtaining code coverage. Not updating the coverage information.");
      uialert(main_figure, msg, window_title)

      return

    end  % try, catch

    link_ui.Text = replace(CodeCoverageFile, "/"|"\", " > ");
    link_ui.HyperlinkClickedCallback = @() edit(CodeCoverageFile);
    link_ui.Tooltip = CodeUtil1.i18n("Open in the editor.");

    line_coverage_ui.Text = code_coverage_table.Properties.CustomProperties.LineCoverage;
    lines_covered_ui.Text = code_coverage_table.Properties.CustomProperties.LinesCovered;
    lines_valid_ui.Text = code_coverage_table.Properties.CustomProperties.LinesValid;
    cov_threshold_ui.Text = code_coverage_table.Properties.CustomProperties.OmitCoverageAbove;

    table_ui.MainTable.Data = code_coverage_table;
    table_ui.MainTable.ColumnWidth = {'fit', 'fit', '1x'};
    table_ui.MainTable.ColumnSortable = true;
    table_ui.MainTable.SelectionType = "row";
  end  % nested function

% -----------------------------------------------------------------------
column_grid = addVerticalGridLayout(main_vertical_container);

default_message = CodeUtil1.i18n("Double-click a table row to open the file. (The file must exist.)");

message_ui = AppUtil1.Component.Label(column_grid);
message_ui.MainFigure = main_figure;
message_ui.Text = default_message;

% -----------------------------------------------------------------------
% Callback functions

deferred_message = timer;
deferred_message.StartDelay = 3;  % seconds
deferred_message.TimerFcn = @(~,~) show_default_message();

  function react_TableDoubleClicked(row_number)
    clicked_row = code_coverage_table(row_number, :);

    target_filepath = which(clicked_row.FilePath);
    if not(isfile(target_filepath))
      message_ui.Text = CodeUtil1.i18n("File not found.");
      start(deferred_message)

      return

    end  % if

    target_name = clicked_row.Name;
    matlab.desktop.editor.openAndGoToFunction(target_filepath, target_name);
  end  % nested function

  function show_default_message
    message_ui.Text = default_message;
    drawnow
  end  % nested function

% -----------------------------------------------------------------------
if isfile(CodeCoverageFile)
  update_ui()
end  % if
movegui(main_figure, "center")
main_figure.Visible = "on";
drawnow
if nargout > 0
  App = struct;
  App.Window = app_window;
end  % if
end  % function
