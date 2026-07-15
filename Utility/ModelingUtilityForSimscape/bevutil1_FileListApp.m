function App = bevutil1_FileListApp(FileList, NameValuePair)
% App to show a file list for click-to-open
%
% This is an app to open a file with double-click on a table row in the list of files.
%
%   FileListApp(<file_list>)
%
% This app takes <file_list> either as a string array or as a table.
% A string array must contain a list of file paths.
% A table must contain the "FilePath" column, and optionally the "LineNumber" column.
% If the table has the "LineNumber" column, double-clicking on a table row
% opens the selected file in the editor and the cursor jumps to the specified line number.
% If the table has no LineNumber column, the cursor jumps to the first line.
%
% Use the TopFolder option if the file path in the file list does not start from
% the current folder.
%
%   FileListApp(<file_list>, TopFolder=<path/to/folder>)
%
% If the file list is a table, the table must have at least two columns whose
% names are "FilePath" and "LineNumber".
%
% To customize the column names, use the ColumnName option.
% To customize the column width, use the ColumnWidth option.
% These options are directly passed to uitable.
% See the documentation about uitable for details.
% https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
%
% -----------------------------------------------------------------------------
% Notes about function-based app
%
% This is an app implemented as a function, which is simpler to implement
% compared to class-based apps. However, accessing the internal states of
% a function-based app is trickier than class-based apps.
%
% -----------------------------------------------------------------------------
% Example
%
% Use the result of the searchText command.
% First, do text search with searchText.
%
%{
% !example: With a proper TargetFolder, this command should run.
session = bevutil1.SearchUtil.searchText( ...
  "movegui", ...
  TargetFolder = "C:\local\modutil\repo\worktrees\R2024b-devel\Devel", ...
  IncludeSubfolders = true, ...
  FileTypes = "*.m" );
%}
%
% Then pass the search result to the FileListApp as follows.
%
%{
% !example: Run this command after running the above example command.
bevutil1_FileListApp(session.Result, TopFolder=session.Searcher.States.TargetFolder)
%}

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  FileList {mustBeA(FileList, ["string", "table"])} = "sample.m"
  NameValuePair.TopFolder {mustBeFolder} = pwd
  NameValuePair.ColumnName
  NameValuePair.ColumnWidth
end  % arguments

arguments (Output)
  App struct
end  % arguments

errorID = "FileListApp:";

if class(FileList) == "string"
  if isempty(FileList) || (isscalar(FileList) && FileList == "")
    id = errorID + "EmptyStringForFileList";
    msg = bevutil1.CodeUtil.i18n("FileList string must be non-empty.");

    throw(MException(id, msg))

  end  % if
  FilePath = replace(FileList(:), ("/"|"\"), " > ");
  FileList = table(FilePath);

else
  % FileList is a table.
  if isempty(FileList)
    id = errorID + "EmptyTableForFileList";
    msg = bevutil1.CodeUtil.i18n("FileList table must be non-empty.");

    throw(MException(id, msg))

  end  % if
  column_names = string(FileList.Properties.VariableNames);
  if not(ismember("FilePath", column_names))
    id = errorID + "MissingFilePathColumn";
    msg = bevutil1.CodeUtil.i18n("Table must have FilePath column.");

    throw(MException(id, msg))

  end  % if
end  % if

column_names = string(FileList.Properties.VariableNames);
if not(ismember("LineNumber", column_names))
  LineNumber = ones(height(FileList), 1);
  line_number_table = table(LineNumber);
  FileList = horzcat(FileList, line_number_table);
end  % if

main_figure = uifigure(Visible="off");

app_window = bevutil1.AppUtil.AppWindow(main_figure, SourceFile=mfilename);
app_window.Width = 800;
app_window.Height = 500;
app_window.Name = bevutil1.CodeUtil.i18n("File list");

app_v_container = app_window.MainVerticalContainer;

% -----------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
label_ui = bevutil1.AppUtil.Component.Label(v_layout);
label_ui.Text = bevutil1.CodeUtil.i18n("Folder");

% -----------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
folder_ui = bevutil1.AppUtil.Component.EditField(v_layout);
folder_ui.Value = replace(NameValuePair.TopFolder, ("/"|"\"), " > ");

% -----------------------------------------------------------------------
% To vertically expand the table in the app window, do the followings.
% 1. In the layout object, set Height to "1x" to vertically expand the table.
% 2. In the table object, set ComponentHeight to "1x".

v_layout = addVerticalGridLayout(app_v_container, Height="1x");  % !vertical-expansion

table_ui = bevutil1.AppUtil.Component.Table(v_layout);
table_ui.ComponentHeight = "1x";  % !vertical-expansion

table_ui.MainTable.Data = FileList;

if not(isfield(NameValuePair, "ColumnName"))
  if width(FileList) == 2
    % Default setting
    table_ui.MainTable.ColumnName = [bevutil1.CodeUtil.i18n("File path"), bevutil1.CodeUtil.i18n("Line number")];
  end

elseif isfield(NameValuePair, "ColumnName")
  if numel(NameValuePair.ColumnName) < 3
    id = errorID + "InvalidColumnName";
    msg = bevutil1.CodeUtil.i18n("ColumnName must have 3 or more elements.");

    throw(MException(id, msg))

  end  % if
  table_ui.MainTable.ColumnName = NameValuePair.ColumnName;
end  % if

if not(isfield(NameValuePair, "ColumnWidth"))
  if width(FileList) == 2
    % Default setting
    table_ui.MainTable.ColumnWidth = {'1x', 'fit'};
  end  % if

elseif isfield(NameValuePair, "ColumnWidth")
  if numel(NameValuePair.ColumnWidth) < 3
    id = errorID + "InvalidColumnWidth";
    msg = bevutil1.CodeUtil.i18n("ColumnWidth must have 3 or more elements.");

    throw(MException(id, msg))

  end  % if
  table_ui.MainTable.ColumnWidth = NameValuePair.ColumnWidth;
end  % if

table_ui.MainTable.ColumnSortable = true;
table_ui.MainTable.SelectionType = "row";

% uitable's DoubleClickedFcn callback is given a DoubleClickedData object as the second argument,
% and the object provides information such as the clicked row via InteractionInformation.Row, etc.
% Search "DoubleClickedData" or "InteractionInformation" in the documentation for details.
% https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
table_ui.MainTable.DoubleClickedFcn = @(~, DoubleClickedData) ...
  react_TableDoubleClicked(DoubleClickedData.InteractionInformation.Row);

% -----------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

default_message = bevutil1.CodeUtil.i18n("Double-click to open the file.");

message_ui = bevutil1.AppUtil.Component.Label(v_layout);
message_ui.Text = default_message;

% -----------------------------------------------------------------------
% Callback functions

  function react_TableDoubleClicked(row_number)
    target_row = FileList(row_number, :);
    target_filepath = replace(target_row.FilePath, " > ", filesep);
    file_fullpath = fullfile(NameValuePair.TopFolder, target_filepath);
    if not(isfile(file_fullpath))
      msg = bevutil1.CodeUtil.i18n("File not found:") + newline + replace(file_fullpath, ("/"|"\"), " > ");
      window_title = bevutil1.CodeUtil.i18n("Error");

      uialert(main_figure, msg, window_title)

      return

    end  % if
    matlab.desktop.editor.openAndGoToLine(file_fullpath, target_row.LineNumber);
  end  % nested function

% -----------------------------------------------------------------------
movegui(main_figure, "center")
main_figure.Visible = "on";
drawnow
if nargout > 0
  App = struct;
  App.Window = app_window;
  App.TableUI = table_ui;
end  % if
end  % function
