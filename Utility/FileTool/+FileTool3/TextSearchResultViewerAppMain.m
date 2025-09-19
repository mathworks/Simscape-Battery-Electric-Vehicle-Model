classdef TextSearchResultViewerAppMain < handle
  % View the result of text search.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchResultViewerAppMain:"
  end  % properties

  properties

    SearchResult table
    TableUIHeight (1,1) {mustBePositive} = 100

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow

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

    function App = TextSearchResultViewerAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.SearchResult table {FileTool3.mustBeTextSearchTable} = FileTool3.newTextSearchTable
      end  % arguments

      arguments (Output)
        App FileTool3.TextReplaceAppMain
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      App.SearchResult = NameValuePair.SearchResult;

      App.TableUIHeight = min(600, 40 + 30*height(App.SearchResult));

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Text search result viewer app");
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

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      label_ui.Text = CodeTool1.i18n("Target folder: ") + App.SearchResult.Properties.CustomProperties.TargetFolder;

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      if App.SearchResult.Properties.CustomProperties.IncludeSubfolders
        label_ui.Text = CodeTool1.i18n("Including subfolders");
      else
        label_ui.Text = CodeTool1.i18n("Excluding subfolders");
      end

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      label_ui.Text = CodeTool1.i18n("File type: ") + App.SearchResult.Properties.CustomProperties.FileTypesString;

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      label_ui.Text = CodeTool1.i18n("Searched text: ") + string(App.SearchResult.Properties.CustomProperties.TextPatternString);

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      if App.SearchResult.Properties.CustomProperties.IgnoreCase
        label_ui.Text = CodeTool1.i18n("Case ignored");
      else
        label_ui.Text = CodeTool1.i18n("Case sensitive");
      end  % if

      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      if App.SearchResult.Properties.CustomProperties.MatchWholeWord
        label_ui.Text = CodeTool1.i18n("Match whole word only");
      else
        label_ui.Text = CodeTool1.i18n("Match any matching text");
      end  % if

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp7.Component.Label(NewSlot(layout, row, Width="1x"));
      label_ui.Text = CodeTool1.i18n("Number of matches: ") + height(App.SearchResult);

      button_ui = LiteApp7.Component.Button(NewSlot(layout, row, Width="fit"));
      button_ui.Text = CodeTool1.i18n("Refresh");
      button_ui.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      tt = LiteApp7.Component.Table(NewRow(layout, column, Height="1x"));
      tt.MainTable.Data = App.SearchResult;
      tt.ComponentHeight = App.TableUIHeight;
      tt.MainTable.ColumnWidth = {'fit', 100, 'auto'};
      tt.MainTable.ColumnSortable = true;
      tt.MainTable.SelectionType = "row";
      tt.MainTable.DoubleClickedFcn = @(tableuiObject, DoubleClickedData) ...
        react_tableRowDoubleClicked(tableuiObject, DoubleClickedData, App.SearchResult.Properties.CustomProperties.TargetFolder);

      % -----------------------------------------------------------------------
      label_ui = LiteApp7.Component.Label(NewRow(layout, column));
      label_ui.Text = CodeTool1.i18n("Double-click to open the file.");

    end  % function

    function react_RefreshButtonPushed(~)
disp("react_RefreshButtonPushed - wip")
    end  % function

  end  % methods

end  % classdef

function react_tableRowDoubleClicked(tableuiObject, DoubleClickedData, target_folder)
row_num = DoubleClickedData.InteractionInformation.Row;
data = tableuiObject.Data(row_num, :);
matlab.desktop.editor.openAndGoToLine(fullfile(target_folder, data.FilePath), data.LineNumber);
end  % function
