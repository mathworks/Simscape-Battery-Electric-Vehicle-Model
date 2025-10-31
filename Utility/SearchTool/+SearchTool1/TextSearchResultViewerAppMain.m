classdef TextSearchResultViewerAppMain < handle
  % App to view the result of text search.
  %
  % This is the main implementation of the app.
  % As a user, use the TextSearchResultViewerApp rather than this code.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchResultViewerAppMain:"
  end  % properties

  properties
    TextSearcher (1,1) SearchTool1.TextSearcher
    SearchResult table
    TableUIHeight (1,1) {mustBePositive} = 100
    SearchTextPattern (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts
    Window LiteApp8.LiteAppWindow
    CopyReplaceCommandTextUI LiteApp8.Component.Button
    NewTextUI LiteApp8.Component.EditableDropDown
    NumMatchesUI LiteApp8.Component.EditField
    TableUI LiteApp8.Component.Table
  end  % properties

  properties (Constant, Access=private)
    width_unit = LiteApp8.Constant.Width{"unitwidth"}
    width_name_ui = LiteApp8.Constant.Width{"unitwidth"} * 18
    width_unit_ui = LiteApp8.Constant.Width{"unitwidth"} * 8
    width_button = LiteApp8.Constant.Width{"unitwidth"} * 12

    height_oneline = LiteApp8.Constant.Height{"oneline"}
  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = TextSearchResultViewerAppMain(Searcher, NameValuePair)
      %%
      % Searcher's states must be properly set up for the viewer.
      % SearchResult can be optionally specified.
      % SearchResult must have columns called "FilePath", "LineNumber", and "LineText".
      % If SearchResult is not specified, search is run using the Searcher.
      arguments (Input)
        Searcher (1,1) SearchTool1.TextSearcher = SearchTool1.TextSearcher(Initialization="default")
        NameValuePair.SearchResult table
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      if not(ready(Searcher))
        id = App.errorID + "TextSearcherIsNotReady";
        msg = CodeTool1.i18n("TextSearcher must be initialized.");

        throw(MException(id, msg))

      end  % if
      App.TextSearcher = Searcher;

      if isfield(NameValuePair, "SearchResult")
        result_table = NameValuePair.SearchResult;
        column_names = result_table.Properties.VariableNames;
        if not(all(ismember(column_names, ["FilePath", "LineNumber", "LineText"])))

        end  % if
        App.SearchResult = result_table;
      else
        App.SearchResult = runSearch(App.TextSearcher);
      end  % if

      App.TableUIHeight = min(500, 40 + 30*height(App.SearchResult));

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp8.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Text search result");
      App.Window.Height = 500;
      App.Window.Width = 800;

      meta_data = metaclass(App);
      App.Window.HeaderUI.AppSourceName = which(meta_data.Name);

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      % -----------------------------------------------------------------------
      Show(App.Window)
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      layout = App.Window.MainLayout;
      area = NewArea(layout);
      column = NewColumn(layout, area);

      % =======================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Search conditions") + "}";

      button_ui = LiteApp8.Component.Button(NewSlot(layout, row));
      button_ui.ButtonWidth = App.width_button;
      button_ui.HorizontalAlignment = "right";
      button_ui.Text = CodeTool1.i18n("New search");
      button_ui.MainButton.Tooltip = CodeTool1.i18n("Open the text search app.");
      button_ui.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("Searched text");

      editfield_ui = LiteApp8.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      x = char(string(App.TextSearcher.States.SearchTextPattern));
      x = x(2:end-1);  % Remove double quotes...
      App.SearchTextPattern = x;
      editfield_ui.Value = x;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      indent_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
      if App.TextSearcher.States.IgnoreCase
        label_ui.Text = CodeTool1.i18n("Case ignored");
      else
        label_ui.Text = CodeTool1.i18n("Case sensitive");
      end  % if

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      indent_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
      if App.TextSearcher.States.MatchWholeWord
        label_ui.Text = CodeTool1.i18n("Match whole word");
      else
        label_ui.Text = CodeTool1.i18n("Match anywhere");
      end  % if

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("File types");

      editfield_ui = LiteApp8.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = join(App.TextSearcher.States.FileTypes, ", ");

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("Folder");

      target_folder = App.TextSearcher.States.TargetFolder;

      editfield_ui = LiteApp8.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      indent_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
      if App.TextSearcher.States.IncludeSubfolders
        label_ui.Text = CodeTool1.i18n("Including subfolders");
      else
        label_ui.Text = CodeTool1.i18n("Excluding subfolders");
      end

      % =======================================================================
      row = NewRow(layout, column);
      LiteApp8.Component.HorizontalLine(row);

      % =======================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Replace") + "}";

      App.CopyReplaceCommandTextUI = LiteApp8.Component.Button(NewSlot(layout, row));
      App.CopyReplaceCommandTextUI.ButtonWidth = App.width_button;
      App.CopyReplaceCommandTextUI.HorizontalAlignment = "right";
      App.CopyReplaceCommandTextUI.Text = CodeTool1.i18n("Copy command");
      App.CopyReplaceCommandTextUI.MainButton.Tooltip = CodeTool1.i18n("Copy the replace command to clipboard.");
      App.CopyReplaceCommandTextUI.MainButton.Enable = "off";
      App.CopyReplaceCommandTextUI.ButtonPushedCallback = @() react_CopyReplaceCommandButtonPushed(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("New text");

      App.NewTextUI = LiteApp8.Component.EditableDropDown(NewSlot(layout, row));
      App.NewTextUI.Items = "";
      App.NewTextUI.Value = "";
      App.NewTextUI.ValueChangedCallback = @() react_ReplaceDropDownChanged(App);

      % =======================================================================
      row = NewRow(layout, column);
      LiteApp8.Component.HorizontalLine(row);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("Number of matches");

      App.NumMatchesUI = LiteApp8.Component.EditField(NewSlot(layout, row, Width="1x"));
      App.NumMatchesUI.ReadOnly = "on";
      App.NumMatchesUI.Value = string(height(App.SearchResult));

      button_ui = LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
      button_ui.ButtonWidth = App.width_button;
      button_ui.Text = CodeTool1.i18n("Refresh");
      button_ui.MainButton.Tooltip = CodeTool1.i18n("Rerun search and update the result table.");
      button_ui.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label(row);
      label_ui.Text = CodeTool1.i18n("Double-click a table row to open the file.");

      % -----------------------------------------------------------------------
      row = NewRow(layout, column, Height="1x");
      App.TableUI = LiteApp8.Component.Table(row);
      App.TableUI.ComponentHeight = App.TableUIHeight;
      App.TableUI.MainTable.Data = App.SearchResult(:, ["FilePath", "LineNumber", "LineText"]);
      App.TableUI.MainTable.ColumnName = [CodeTool1.i18n("File path"), CodeTool1.i18n("Line number"), CodeTool1.i18n("Line text")];
      App.TableUI.MainTable.ColumnWidth = {'fit', 100, 'auto'};
      App.TableUI.MainTable.ColumnSortable = true;
      App.TableUI.MainTable.SelectionType = "row";
      % uitable's DoubleClickedFcn callback is given a DoubleClickedData object as the second argument,
      % and the object provides information such as the clicked row via InteractionInformation.Row, etc.
      % Search "DoubleClickedData" or "InteractionInformation" in the documentation for details.
      % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
      App.TableUI.MainTable.DoubleClickedFcn = @(~, DoubleClickedData) ...
        react_TableDoubleClicked(App, DoubleClickedData.InteractionInformation.Row);

    end  % function

    function react_NewSearch(App)
      SearchTool1.TextSearchAppMain(StatesSource="external", SearchStates=App.TextSearcher.States)
    end  % function

    function react_ReplaceDropDownChanged(App)
      current_value = App.NewTextUI.Value;
      if current_value ~= "" && not(ismember(current_value, App.NewTextUI.Items))
        App.NewTextUI.Items = [App.NewTextUI.Items; current_value];
      end  % if
      if current_value ~= ""
        App.CopyReplaceCommandTextUI.MainButton.Enable = "on";
      else
        App.CopyReplaceCommandTextUI.MainButton.Enable = "off";
      end  % if
    end  % function

    function react_CopyReplaceCommandButtonPushed(App)
      % Build commands like below and copy as text to the system clipboard.
      %   file_paths = ["/path/to/file1"; "/path/to/file2"; "/path/to/file3"];
      %   result = SearchTool1.replaceText(file_paths, DryRun=true, TextPattern="old", NewText="new");

      new_text = App.NewTextUI.Value;
      if isempty(new_text) || new_text == ""

        return

      end  % if

      target_folder = App.TextSearcher.States.TargetFolder;
      ignore_case = App.TextSearcher.States.IgnoreCase;
      match_whole_word = App.TextSearcher.States.MatchWholeWord;

      % target_folder is a scalar. FilePath is either a scalar or a column vector.
      % fullfile returns either a scalar or a column vector.
      file_paths = unique(fullfile(target_folder, App.SearchResult.FilePath));
      assert(iscolumn(file_paths), App.errorID+"InternalError", CodeTool1.i18n("Internal error"))
      assert(all(isfile(file_paths)), App.errorID+"InternalError", CodeTool1.i18n("Internal error"))

      code_lines = SearchTool1.buildReplaceCommandText( ...
        FilePaths = file_paths, ...
        TextPattern = App.TextSearcher.States.SearchTextPattern, ...
        IgnoreCase = ignore_case, ...
        MatchWholeWord = match_whole_word, ...
        NewText = new_text );

      clipboard("copy", join(code_lines, newline) + newline)
    end  % function

    function react_RefreshButtonPushed(App)
      App.SearchResult = runSearch(App.TextSearcher);
      App.TableUI.MainTable.Data = App.SearchResult(:, ["FilePath", "LineNumber", "LineText"]);
      App.NumMatchesUI.Value = string(height(App.SearchResult));
    end  % function

    function react_TableDoubleClicked(App, row_number)
      target_folder = App.TextSearcher.States.TargetFolder;
      data = App.SearchResult(row_number, :);
      matlab.desktop.editor.openAndGoToLine(fullfile(target_folder, data.FilePath), data.LineNumber);
    end  % function

  end  % methods
end  % classdef
