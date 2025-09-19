classdef TextSearchAppMain < handle
  % Search text in files.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchAppMain:"
  end  % properties

  properties

    TargetFolder (1,1) string
    IncludeSubfolders (1,1) logical
    FileTypes (1,:) string
    SearchText (1,1) string
    IgnoreCase (1,1) logical
    MatchWholeWord (1,1) logical
    DisplayCommand (1,1) logical

    CommandText (1,1) string

    SearchResult table

    % -------------------------------------------------------------------------
    % GUI parts

    Window LiteApp7.LiteAppWindow

    TargetFolderUI LiteApp7.Component.EditField
    IncludeSubfoldersUI LiteApp7.Component.CheckBox
    FileTypesUI LiteApp7.Component.EditField
    SearchTextUI LiteApp7.Component.EditField
    IgnoreCaseUI LiteApp7.Component.CheckBox
    MatchWholeWordUI LiteApp7.Component.CheckBox
    DisplayCommandUI LiteApp7.Component.CheckBox
    SearchButtonUI LiteApp7.Component.Button

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

    function App = TextSearchAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.TargetFolder (1,1) string {mustBeFolder} = pwd
        NameValuePair.IncludeSubfolders (1,1) logical = false
        NameValuePair.FileTypes (1,:) string = "*.m"
        NameValuePair.SearchText (1,1) string = "Copyright"
        NameValuePair.IgnoreCase (1,1) logical = true
        NameValuePair.MatchWholeWord (1,1) logical = false
        NameValuePair.DisplayCommand (1,1) logical = true
      end  % arguments

      arguments (Output)
        App FileTool3.TextSearchAppMain
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      App.TargetFolder = NameValuePair.TargetFolder;
      App.IncludeSubfolders = NameValuePair.IncludeSubfolders;
      App.FileTypes = NameValuePair.FileTypes;
      App.SearchText = NameValuePair.SearchText;
      App.IgnoreCase = NameValuePair.IgnoreCase;
      App.MatchWholeWord = NameValuePair.MatchWholeWord;
      App.DisplayCommand = NameValuePair.DisplayCommand;

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Text search app");
      App.Window.Height = 240;
      App.Window.Width = 500;

      meta_data = metaclass(App);
      App.Window.HeaderUI.AppSourceName = which(meta_data.Name);

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      App.TargetFolderUI.Value = App.TargetFolder;
      App.IncludeSubfoldersUI.Value = App.IncludeSubfolders;
      App.FileTypesUI.Value = join(App.FileTypes, ", ");
      App.SearchTextUI.Value = App.SearchText;
      App.IgnoreCaseUI.Value = App.IgnoreCase;
      App.MatchWholeWordUI.Value = App.MatchWholeWord;
      App.DisplayCommandUI.Value = App.DisplayCommand;

      update_state_from_ui_components(App)

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
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Target folder");
      label_ui.ComponentWidth = App.name_ui_width;

      App.TargetFolderUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.TargetFolderUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IncludeSubfoldersUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.IncludeSubfoldersUI.Text = CodeTool1.i18n("Include subfolders");
      App.IncludeSubfoldersUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("File type");
      label_ui.ComponentWidth = App.name_ui_width;

      App.FileTypesUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.FileTypesUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Text to search");
      label_ui.ComponentWidth = App.name_ui_width;

      App.SearchTextUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.SearchTextUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IgnoreCaseUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.IgnoreCaseUI.Text = CodeTool1.i18n("Ignore case");
      App.IgnoreCaseUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.MatchWholeWordUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.MatchWholeWordUI.Text = CodeTool1.i18n("Match whole word");
      App.MatchWholeWordUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      LiteApp7.Component.HorizontalLine(row);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.DisplayCommandUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.DisplayCommandUI.Text = CodeTool1.i18n("Display search command in Command Window");
      App.DisplayCommandUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.SearchButtonUI = LiteApp7.Component.Button(NewSlot(layout, row));
      App.SearchButtonUI.Text = CodeTool1.i18n("Search");
      App.SearchButtonUI.ButtonWidth = App.button_width;
      App.SearchButtonUI.HorizontalAlignment = "right";
      App.SearchButtonUI.ButtonPushedCallback = @() run_search(App);

    end  % function

    function update_state_from_ui_components(App)
      App.TargetFolder = App.TargetFolderUI.Value;
      App.IncludeSubfolders = logical(App.IncludeSubfoldersUI.Value);
      App.SearchText = App.SearchTextUI.Value;
      App.FileTypes = split(strip(App.FileTypesUI.Value), "," + optionalPattern(whitespacePattern))';
      App.IgnoreCase = logical(App.IgnoreCaseUI.Value);
      App.MatchWholeWord = logical(App.MatchWholeWordUI.Value);
      App.DisplayCommand = logical(App.DisplayCommandUI.Value);
    end  % function

    function run_search(App)

      App.CommandText = ...
        "FileTool3.searchText(" + ...
        "TargetFolder=""" + App.TargetFolder + """, " + ...
        "IncludeSubfolders=" + App.IncludeSubfolders + ", " + ...
        "FileTypes=[""" + join(App.FileTypes, """,""") + """], " + ...
        "TextPattern=""" + App.SearchText + """, " + ...
        "IgnoreCase=" + App.IgnoreCase + ", " + ...
        "MatchWholeWord=" + App.MatchWholeWord + ")";

      if App.DisplayCommand
        disp(App.CommandText)
      end  % if

      App.SearchResult = FileTool3.searchText( ...
        TargetFolder = App.TargetFolder, ...
        IncludeSubfolders = App.IncludeSubfolders, ...
        FileTypes = App.FileTypes, ...
        TextPattern = App.SearchText, ...
        IgnoreCase = App.IgnoreCase, ...
        MatchWholeWord = App.MatchWholeWord );

      if isempty(App.SearchResult)
        disp("No match")

        return

      end  % if

      FileTool3.TextSearchResultViewerAppMain(SearchResult=App.SearchResult);

    end  % function

  end  % methods
end  % classdef
