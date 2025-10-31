classdef TextSearchResultAppMain < handle
  % View the result of text search.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchResultAppMain:"
  end  % properties

  properties
    TextSearcher (1,1) SearchTool1.TextSearch
    SearchResult table
    TableUIHeight (1,1) {mustBePositive} = 100

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow
    TableUI LiteApp7.Component.Table
  end  % properties

  properties (Constant, Access=private)

    width_unit = LiteApp7.Constant.Width{"unitwidth"}
    width_name_ui = LiteApp7.Constant.Width{"unitwidth"} * 18
    width_unit_ui = LiteApp7.Constant.Width{"unitwidth"} * 8
    width_button = LiteApp7.Constant.Width{"unitwidth"} * 12

    height_oneline = LiteApp7.Constant.Height{"oneline"}

  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = TextSearchResultAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.TextSearcher (1,1) SearchTool1.TextSearch = SearchTool1.TextSearch
        NameValuePair.SearchResult (:,3) table = table([], [], [], 'VariableNames', ["FilePath", "LineNumber", "LineText"])
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      if not(ready(NameValuePair.TextSearcher))
        id = App.errorID + "TextSearcherIsNotReady";
        msg = CodeTool1.i18n("TextSearcher must be ready.");

        throw(MException(id, msg))

      end  % if
      App.TextSearcher = NameValuePair.TextSearcher;

      if isempty(NameValuePair.SearchResult)
        id = App.errorID + "SearchResultIsEmpty";
        msg = CodeTool1.i18n("SearchResult must be non-empty.");

        throw(MException(id, msg))

      end  % if
      App.SearchResult = NameValuePair.SearchResult;

      App.TableUIHeight = min(500, 40 + 30*height(App.SearchResult));

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp7.LiteAppWindow;
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

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      button_ui = LiteApp7.Component.Button(NewSlot(layout, row));
      button_ui.ButtonWidth = App.width_button;
      button_ui.HorizontalAlignment = "right";
      button_ui.Text = CodeTool1.i18n("New search");
      button_ui.MainButton.Tooltip = CodeTool1.i18n("Open the text search app.");
      button_ui.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("Target folder");

      target_folder = App.TextSearcher.States.TargetFolder;

      editfield_ui = LiteApp7.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp7.Component.Label(row);
      if App.TextSearcher.States.IncludeSubfolders
        label_ui.Text = CodeTool1.i18n("Including subfolders");
      else
        label_ui.Text = CodeTool1.i18n("Excluding subfolders");
      end

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("File types");

      editfield_ui = LiteApp7.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = join(App.TextSearcher.States.FileTypes, ", ");

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeTool1.i18n("Searched text");

      editfield_ui = LiteApp7.Component.EditField(NewSlot(layout, row));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = string(App.TextSearcher.States.SearchTextPattern);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(row);
      if App.TextSearcher.States.IgnoreCase
        label_ui.Text = CodeTool1.i18n("Case ignored");
      else
        label_ui.Text = CodeTool1.i18n("Case sensitive");
      end  % if

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp7.Component.Label(row);
      if App.TextSearcher.States.MatchWholeWord
        label_ui.Text = CodeTool1.i18n("Match whole word");
      else
        label_ui.Text = CodeTool1.i18n("Match anywhere");
      end  % if

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      LiteApp7.Component.HorizontalLine(row);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="1x"));
      label_ui.Text = CodeTool1.i18n("Number of matches: ") + height(App.SearchResult);

      button_ui = LiteApp7.Component.Button(NewSlot(layout, row, Width="fit"));
      button_ui.Text = CodeTool1.i18n("Refresh");
      button_ui.MainButton.Tooltip = CodeTool1.i18n("Rerun search and update the result table.");
      button_ui.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      label_ui.Text = CodeTool1.i18n("Double-click a table row to open the file.");

      % -----------------------------------------------------------------------
      App.TableUI = LiteApp7.Component.Table(NewRow(layout, column, Height="1x"));
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

    function react_NewSearch(~)
disp("wip")
      % SearchTool1.TextSearchAppMain( ...
      %   TargetFolder = App.TextSearcher.States.TargetFolder, ...
      %   IncludeSubfolders = App.TextSearcher.States.IncludeSubfolders, ...
      %   SelectMATLAB =  );
    end  % function

    function react_RefreshButtonPushed(~)
 disp("wip")
      % result = App.SearchResult;
      % App.SearchResult = SearchTool1.refreshTextSearchResult(result, DisplayInfo=false);
      % App.TableUI.MainTable.Data = App.SearchResult(:, ["FilePath", "LineNumber", "LineText"]);
    end  % function

    function react_TableDoubleClicked(App, row_number)
      target_folder = App.TextSearcher.States.TargetFolder;
      data = App.SearchResult(row_number, :);
      matlab.desktop.editor.openAndGoToLine(fullfile(target_folder, data.FilePath), data.LineNumber);
    end  % function

  end  % methods
end  % classdef
