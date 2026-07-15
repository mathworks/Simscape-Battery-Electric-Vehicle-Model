classdef TextSearchResultAppMain < handle
  % App to view the result of text search
  %
  % This is the main implementation of the app.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchResultAppMain:"
  end  % properties

  properties
    TextSearcher (1,1) bevutil1.SearchUtil.TextSearcher
    SearchResult table
    SearchTextPattern (1,1) string = ""

    % -------------------------------------------------------------------------
    % GUI parts
    Window bevutil1.AppUtil.AppWindow
    NewSearchButtonUI bevutil1.AppUtil.Component.Button
    CopyReplaceCommandTextUI bevutil1.AppUtil.Component.Button
    NewTextUI bevutil1.AppUtil.Component.DropDown
    NumMatchesUI bevutil1.AppUtil.Component.EditField
    TableUI bevutil1.AppUtil.Component.Table
  end  % properties

  properties (Constant, Access=private)
    width_unit = bevutil1.AppUtil.Constant.Width{"unitwidth"}
    width_name_ui = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 18
    width_unit_ui = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 8
    width_button = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12

    height_oneline = bevutil1.AppUtil.Constant.Height{"oneline"}
  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = TextSearchResultAppMain(Searcher, NameValuePair)
      %%
      % Searcher's states must be properly set up for the viewer.
      % SearchResult can be optionally specified.
      % SearchResult must have columns called "FilePath", "LineNumber", and "LineText".
      % If SearchResult is not specified, search is run using the Searcher.
      arguments (Input)
        Searcher (1,1) bevutil1.SearchUtil.TextSearcher = bevutil1.SearchUtil.TextSearcher(Initialization="default")
        NameValuePair.SearchResult table
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      if not(ready(Searcher))
        id = App.errorID + "TextSearcherIsNotReady";
        msg = bevutil1.CodeUtil.i18n("TextSearcher must be initialized.");

        throw(MException(id, msg))

      end  % if
      App.TextSearcher = Searcher;

      if isfield(NameValuePair, "SearchResult")
        App.SearchResult = NameValuePair.SearchResult;
      else
        App.SearchResult = runSearch(App.TextSearcher);
      end  % if

      meta_data = metaclass(App);

      main_figure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = bevutil1.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bevutil1.CodeUtil.i18n("Text search result");
      App.Window.Height = 500;
      App.Window.Width = 800;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      % -----------------------------------------------------------------------
      movegui(main_figure, "center")
      main_figure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      main_v_container = App.Window.MainVerticalContainer;

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Search conditions") + "}";

      App.NewSearchButtonUI = bevutil1.AppUtil.Component.Button(addHorizontalGridLayout(h_container));
      App.NewSearchButtonUI.ButtonWidth = App.width_button;
      App.NewSearchButtonUI.HorizontalAlignment = "right";
      App.NewSearchButtonUI.Text = bevutil1.CodeUtil.i18n("New search");
      App.NewSearchButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Open the text search app.");
      App.NewSearchButtonUI.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Searched text");

      editfield_ui = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(h_container));
      editfield_ui.ReadOnly = "on";
      x = char(string(App.TextSearcher.States.SearchTextPattern));
      x = x(2:end-1);  % Remove double quotes...
      App.SearchTextPattern = x;
      editfield_ui.Value = x;

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      indent_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container));
      if App.TextSearcher.States.IgnoreCase
        label_ui.Text = bevutil1.CodeUtil.i18n("Case ignored");
      else
        label_ui.Text = bevutil1.CodeUtil.i18n("Case sensitive");
      end  % if

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      indent_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container));
      if App.TextSearcher.States.MatchWholeWord
        label_ui.Text = bevutil1.CodeUtil.i18n("Match whole word");
      else
        label_ui.Text = bevutil1.CodeUtil.i18n("Match anywhere");
      end  % if

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("File types");

      editfield_ui = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(h_container));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = join(App.TextSearcher.States.FileTypes, ", ");

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Folder");

      target_folder = App.TextSearcher.States.TargetFolder;

      editfield_ui = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(h_container));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      indent_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      indent_ui.ComponentWidth = App.width_name_ui;
      indent_ui.Text = "";

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container));
      if App.TextSearcher.States.IncludeSubfolders
        label_ui.Text = bevutil1.CodeUtil.i18n("Including subfolders");
      else
        label_ui.Text = bevutil1.CodeUtil.i18n("Excluding subfolders");
      end

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      bevutil1.AppUtil.Component.HorizontalLine(v_layout);

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Replace") + "}";

      App.CopyReplaceCommandTextUI = bevutil1.AppUtil.Component.Button(addHorizontalGridLayout(h_container));
      App.CopyReplaceCommandTextUI.ButtonWidth = App.width_button;
      App.CopyReplaceCommandTextUI.HorizontalAlignment = "right";
      App.CopyReplaceCommandTextUI.Text = bevutil1.CodeUtil.i18n("Copy command");
      App.CopyReplaceCommandTextUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Copy the replace command to clipboard.");
      App.CopyReplaceCommandTextUI.MainButton.Enable = "off";
      App.CopyReplaceCommandTextUI.ButtonPushedCallback = @() react_CopyReplaceCommandButtonPushed(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("New text");

      App.NewTextUI = bevutil1.AppUtil.Component.DropDown(addHorizontalGridLayout(h_container));
      App.NewTextUI.Editable = "on";
      App.NewTextUI.Items = "";
      App.NewTextUI.Value = "";
      App.NewTextUI.ValueChangedCallback = @() react_ReplaceDropDownChanged(App);

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      bevutil1.AppUtil.Component.HorizontalLine(v_layout);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bevutil1.AppUtil.HorizontalContainer(v_layout);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Number of matched lines");

      App.NumMatchesUI = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(h_container, Width="1x"));
      App.NumMatchesUI.ReadOnly = "on";
      App.NumMatchesUI.Value = string(height(App.SearchResult));

      button_ui = bevutil1.AppUtil.Component.Button(addHorizontalGridLayout(h_container, Width="fit"));
      button_ui.ButtonWidth = App.width_button;
      button_ui.Text = bevutil1.CodeUtil.i18n("Refresh");
      button_ui.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Rerun search and update the result table.");
      button_ui.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      label_ui = bevutil1.AppUtil.Component.Label(v_layout);
      label_ui.Text = bevutil1.CodeUtil.i18n("Double-click a table row to open the file.");

      % -----------------------------------------------------------------------

      % Expand the uitable vertically to fit the available height of the app window.
      v_layout = addVerticalGridLayout(main_v_container, Height="1x");  % !vertical-expansion

      App.TableUI = bevutil1.AppUtil.Component.Table(v_layout);

      % Expand the uitable vertically to fit the available height of the app window.
      App.TableUI.ComponentHeight = "1x";  % !vertical-expansion

      App.TableUI.MainTable.Data = App.SearchResult(:, ["FilePath", "LineNumber", "LineText"]);
      App.TableUI.MainTable.ColumnName = [bevutil1.CodeUtil.i18n("File path"), bevutil1.CodeUtil.i18n("Line number"), bevutil1.CodeUtil.i18n("Line text")];
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
      bevutil1.SearchUtil.TextSearchAppMain(StatesSource="external", SearchStates=App.TextSearcher.States)
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
      %   result = bevutil1.SearchUtil.replaceText(file_paths, DryRun=true, TextPattern="old", NewText="new");

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
      assert(iscolumn(file_paths), App.errorID+"InternalError", bevutil1.CodeUtil.i18n("Internal error"))
      assert(all(isfile(file_paths)), App.errorID+"InternalError", bevutil1.CodeUtil.i18n("Internal error"))

      code_lines = bevutil1.SearchUtil.buildReplaceCommandText( ...
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
