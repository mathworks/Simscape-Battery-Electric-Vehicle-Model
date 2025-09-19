classdef FindReplaceAppMain < handle
  % App to find text and optionally replace in files.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "FindReplaceAppMain:"
  end  % properties

  properties

    TopFolder (1,1) string

    CommandText (1,1) string

    SearchResult table

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow

    TargetFolderUI LiteApp7.Component.EditField
    IncludeSubfoldersUI LiteApp7.Component.CheckBox
    FileTypeUI LiteApp7.Component.EditField
    SearchTextUI LiteApp7.Component.EditField
    IgnoreCaseUI LiteApp7.Component.CheckBox
    MatchWholeWordUI LiteApp7.Component.CheckBox
    SearchButtonUI LiteApp7.Component.Button

    % ResultTableUI LiteApp7.Component.Table

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

    function App = FindReplaceAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
      end  % arguments

      arguments (Output)
        App FileTool3.FindReplaceAppMain
      end  % arguments

      App.TopFolder = NameValuePair.TopFolder;

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Find Replace App");
      App.Window.Height = 400;
      App.Window.Width = 700;

      % -----------------------------------------------------------------------

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI



      % -----------------------------------------------------------------------
      Show(App.Window)
    end  % function

    function build_app_gui(App)
      %%
      layout = App.Window.MainLayout;

      area = NewArea(layout);

      column = NewColumn(layout, area);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Target folder");
      label_ui.ComponentWidth = App.name_ui_width;

      App.TargetFolderUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.TargetFolderUI.Value = "pwd";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IncludeSubfoldersUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.IncludeSubfoldersUI.Text = CodeTool1.i18n("Include subfolders");
      App.IncludeSubfoldersUI.Value = false;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("File type");
      label_ui.ComponentWidth = App.name_ui_width;

      App.FileTypeUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.FileTypeUI.Value = "*.m, *.mdl";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Text pattern");
      label_ui.ComponentWidth = App.name_ui_width;

      App.SearchTextUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.SearchTextUI.Value = "MathWorks";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IgnoreCaseUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.IgnoreCaseUI.Text = CodeTool1.i18n("Ignore case");
      App.IgnoreCaseUI.Value = true;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.MatchWholeWordUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.MatchWholeWordUI.Text = CodeTool1.i18n("Match whole word");
      App.MatchWholeWordUI.Value = false;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.SearchButtonUI = LiteApp7.Component.Button(NewSlot(layout, row));
      App.SearchButtonUI.Text = CodeTool1.i18n("Search");
      App.SearchButtonUI.ButtonWidth = App.button_width;
      App.SearchButtonUI.HorizontalAlignment = "right";
      App.SearchButtonUI.ButtonPushedCallback = @() run_search(App);

      % =======================================================================
      row = NewRow(layout, column);
      LiteApp7.Component.HorizontalLine(NewSlot(layout, row));

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("File path");
      label_ui.ComponentWidth = App.name_ui_width;

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Line");
      label_ui.ComponentWidth = App.name_ui_width;
      label_ui.HighlightBackground = "on";

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Text");
      label_ui.ComponentWidth = App.name_ui_width;

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("File path 1");
      label_ui.ComponentWidth = App.name_ui_width;

      link_ui = LiteApp8.Component.Hyperlink2(NewSlot(layout, row, Width="fit"));
      link_ui.Text = CodeTool1.i18n("123");
      link_ui.HyperlinkClickedCallback = @() disp("123");
      link_ui.ComponentWidth = App.name_ui_width;
      link_ui.HighlightBackground = "on";

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row));
      label_ui.Text = CodeTool1.i18n("Text text text");

    end  % function

    function run_search(App)

      target_folder_ui = App.TargetFolderUI.Value;
      if target_folder_ui == "pwd"
        target_folder = pwd;
      else
        target_folder = target_folder_ui;
      end  % if

      include_subfolders = logical(App.IncludeSubfoldersUI.Value);
      file_type = App.FileTypeUI.Value;
      search_text = App.SearchTextUI.Value;
      ignore_case = logical(App.IgnoreCaseUI.Value);
      match_whole_word = logical(App.MatchWholeWordUI.Value);

      App.CommandText = ...
        "FileTool3.findTextAndReplace(" + ...
        "DryRun=true, " + ...
        "TargetFolder=""" + target_folder + """, " + ...
        "IncludeSubfolders=" + include_subfolders + ", " + ...
        "FileType=""" + join(file_type, ",") + """, " + ...
        "IgnoreCase=" + ignore_case + ", " + ...
        "MatchWholeWord=" + match_whole_word + ", " + ...
        "TextPattern=""" + search_text + """)";

      disp(App.CommandText)

      App.SearchResult = FileTool3.findTextAndReplace( ...
        DryRun = true, ...
        TargetFolder = target_folder, ...
        IncludeSubfolders = include_subfolders, ...
        FileType = file_type, ...
        IgnoreCase = ignore_case, ...
        MatchWholeWord = match_whole_word, ...
        TextPattern = search_text );

      if isempty(App.SearchResult)
        disp("No match")

        return

      end  % if

      % disp(App.SearchResult.Properties.CustomProperties.TargetFolder)
      % disp(height(App.SearchResult))
      % disp(App.SearchResult)

      miniappSearchResult(App);

    end  % function

    function miniapp = miniappSearchResult(App)
      miniapp = LiteApp7.LiteAppWindow;
      miniapp.Name = CodeTool1.i18n("Search result");

      btn = LiteApp7.Component.Button(NewArea(miniapp.MainLayout));
      btn.Text = CodeTool1.i18n("Close");
      btn.HorizontalAlignment = "right";
      btn.ButtonPushedCallback = @() delete(miniapp);

      btn = LiteApp7.Component.Button(NewArea(miniapp.MainLayout));
      btn.Text = CodeTool1.i18n("Copy command");
      btn.HorizontalAlignment = "right";
      btn.ButtonPushedCallback = @() clipboard("copy", App.CommandText);

      lbl = LiteApp8.Component.Label2(NewArea(miniapp.MainLayout));
      lbl.Text = CodeTool1.i18n("Search command");

      cmd = LiteApp8.Component.Label2(NewArea(miniapp.MainLayout));
      cmd.ComponentHeight = LiteApp7.Constant.Height{"oneline+"} * 2;
      cmd.ComponentWidth = "fit";
      cmd.WordWrap = "on";
      cmd.VerticalAlignment = "top";
      cmd.MainLabel.Interpreter = "none";
      cmd.Text = App.CommandText;
      cmd.MainLabel.Tooltip = App.CommandText;

      tt = LiteApp7.Component.Table(NewArea(miniapp.MainLayout));
      tt.MainTable.Data = App.SearchResult;
      tt.MainTable.ColumnSortable = [true, true, true];
      tt.MainTable.SelectionType = "row";
      tt.MainTable.DoubleClickedFcn = @(tableuiObject, DoubleClickedData) ...
        react_tableRowDoubleClicked(tableuiObject, DoubleClickedData, App.SearchResult.Properties.CustomProperties.TargetFolder);

      Show(miniapp)
    end  % function

  end  % methods

end  % classdef

function react_tableRowDoubleClicked(tableuiObject, DoubleClickedData, target_folder)
row_num = DoubleClickedData.InteractionInformation.Row;
data = tableuiObject.Data(row_num, :);
matlab.desktop.editor.openAndGoToLine(fullfile(target_folder, data.FilePath), data.LineNumber);
end  % function
