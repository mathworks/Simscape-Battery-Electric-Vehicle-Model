classdef TextSearchAppMain < handle
  % Search text in files.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchAppMain:"
  end  % properties

  properties

    SearchReady (1,1) logical = false

    TargetFolder (1,1) string
    IncludeSubfolders (1,1) logical

    SelectAll (1,1) logical
    SelectMATLAB (1,1) logical
    ExcludeLiveScript (1,1) logical
    ExcludeMATLABCodeFile (1,1) logical
    SelectMarkdown (1,1) logical
    SelectSimulink (1,1) logical
    SelectSimscape (1,1) logical
    SelectSVG (1,1) logical
    CustomFileTypes (1,:) string

    IgnoreCase (1,1) logical
    MatchWholeWord (1,1) logical
    SearchText (1,1) string

    CommandText (1,1) string

    SearchResult table

    % -------------------------------------------------------------------------
    % GUI parts

    GUIReady (1,1) logical = false

    Window LiteApp7.LiteAppWindow

    TargetFolderUI LiteApp7.Component.DropDown
    IncludeSubfoldersUI LiteApp7.Component.CheckBox
    SelectFolderUI LiteApp7.Component.Button

    SelectAllUI LiteApp7.Component.CheckBox
    FileType_m_UI LiteApp7.Component.CheckBox
    ExcludeLiveScriptUI LiteApp7.Component.CheckBox
    ExcludeMATLABCodeFileUI LiteApp7.Component.CheckBox
    FileType_md_UI LiteApp7.Component.CheckBox
    FileType_mdl_UI LiteApp7.Component.CheckBox
    FileType_ssc_UI LiteApp7.Component.CheckBox
    FileType_svg_UI LiteApp7.Component.CheckBox
    CustomFileTypesUI LiteApp7.Component.EditField

    % FileTypesUI is a read-only edit field UI.
    % This is used to maintain the specified file types in the app.
    FileTypesUI LiteApp7.Component.EditField

    IgnoreCaseUI LiteApp7.Component.CheckBox
    MatchWholeWordUI LiteApp7.Component.CheckBox
    SearchTextUI LiteApp8.Component.EditableDropDown

    CopyCommandButtonUI LiteApp7.Component.Button
    SearchButtonUI LiteApp7.Component.Button

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

    function App = TextSearchAppMain(NameValuePair)
      %%
      arguments (Input)

        NameValuePair.TargetFolder (1,1) string {mustBeFolder} = pwd
        NameValuePair.IncludeSubfolders (1,1) logical = false

        NameValuePair.SelectAll (1,1) logical = true
        NameValuePair.SelectMATLAB (1,1) logical = true
        NameValuePair.ExcludeLiveScript (1,1) logical = false
        NameValuePair.ExcludeMATLABCodeFile (1,1) logical = false
        NameValuePair.SelectMarkdown (1,1) logical = true
        NameValuePair.SelectSimulink (1,1) logical = true
        NameValuePair.SelectSimscape (1,1) logical = true
        NameValuePair.SelectSVG (1,1) logical = true
        NameValuePair.CustomFileTypes (1,:) string = ""

        NameValuePair.IgnoreCase (1,1) logical = true
        NameValuePair.MatchWholeWord (1,1) logical = false
        NameValuePair.SearchText (1,1) string = "Copyright"

      end  % arguments

      arguments (Output)
        App TextSearchTool1.TextSearchAppMain
      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp7.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Text search");
      App.Window.Height = 360;
      App.Window.Width = 600;

      meta_data = metaclass(App);
      App.Window.HeaderUI.AppSourceName = which(meta_data.Name);

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      App.IncludeSubfoldersUI.Value = NameValuePair.IncludeSubfolders;

      target_folder = replace(NameValuePair.TargetFolder, ("/"|"\"), " > ");
      App.TargetFolderUI.Items = target_folder;
      App.TargetFolderUI.Value = target_folder;

      App.FileType_m_UI.Value = NameValuePair.SelectMATLAB;
      App.ExcludeLiveScriptUI.Value = NameValuePair.ExcludeLiveScript;
      App.ExcludeMATLABCodeFileUI.Value = NameValuePair.ExcludeMATLABCodeFile;

      App.FileType_md_UI.Value = NameValuePair.SelectMarkdown;
      App.FileType_mdl_UI.Value = NameValuePair.SelectSimulink;
      App.FileType_ssc_UI.Value = NameValuePair.SelectSimscape;
      App.FileType_svg_UI.Value = NameValuePair.SelectSVG;
      App.CustomFileTypesUI.Value = NameValuePair.CustomFileTypes;
      update_file_types(App)

      App.IgnoreCaseUI.Value = NameValuePair.IgnoreCase;
      App.MatchWholeWordUI.Value = NameValuePair.MatchWholeWord;
      App.SearchTextUI.Value = NameValuePair.SearchText;

      App.GUIReady = true;

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

      % =======================================================================
      % Target folder
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Target folder") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.IncludeSubfoldersUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.IncludeSubfoldersUI.Text = CodeTool1.i18n("Include subfolders");
      App.IncludeSubfoldersUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      App.SelectFolderUI = LiteApp7.Component.Button(NewSlot(layout, row, Width="fit"));
      App.SelectFolderUI.ButtonWidth = App.width_button;
      App.SelectFolderUI.Text = CodeTool1.i18n("Select...");
      App.SelectFolderUI.MainButton.Tooltip = CodeTool1.i18n("Select a target folder and add to the drop down.");
      App.SelectFolderUI.ButtonPushedCallback = @() react_SelectFolderButton(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TargetFolderUI = LiteApp7.Component.DropDown(NewSlot(layout, row));
      App.TargetFolderUI.MainDropDown.Items = "";
      App.TargetFolderUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % =======================================================================
      % File type
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("File types") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.SelectAllUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.SelectAllUI.Text = CodeTool1.i18n("Select all");
      App.SelectAllUI.ValueChangedCallback = @() react_SelectAllFileTypes(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.FileType_m_UI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.FileType_m_UI.Text = CodeTool1.i18n("MATLAB (*.m)");
      App.FileType_m_UI.ValueChangedCallback = @() update_file_types(App);

      App.ExcludeLiveScriptUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.ExcludeLiveScriptUI.Text = CodeTool1.i18n("Exclude Live Script");
      App.ExcludeLiveScriptUI.MainCheckBox.Enable = "off";
      App.ExcludeLiveScriptUI.ValueChangedCallback = @() update_file_types(App);

      App.ExcludeMATLABCodeFileUI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.ExcludeMATLABCodeFileUI.Text = CodeTool1.i18n("Exclude MATLAB code");
      App.ExcludeMATLABCodeFileUI.MainCheckBox.Enable = "off";
      App.ExcludeMATLABCodeFileUI.ValueChangedCallback = @() update_file_types(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.FileType_md_UI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.FileType_md_UI.Text = CodeTool1.i18n("Markdown (*.md)");
      App.FileType_md_UI.ValueChangedCallback = @() update_file_types(App);

      App.FileType_mdl_UI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.FileType_mdl_UI.Text = CodeTool1.i18n("Simulink (*.mdl)");
      App.FileType_mdl_UI.ValueChangedCallback = @() update_file_types(App);

      App.FileType_ssc_UI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.FileType_ssc_UI.Text = CodeTool1.i18n("Simscape (*.ssc)");
      App.FileType_ssc_UI.ValueChangedCallback = @() update_file_types(App);

      App.FileType_svg_UI = LiteApp7.Component.CheckBox(NewSlot(layout, row));
      App.FileType_svg_UI.Text = CodeTool1.i18n("SVG (*.svg)");
      App.FileType_svg_UI.ValueChangedCallback = @() update_file_types(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Custom file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.CustomFileTypesUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.CustomFileTypesUI.MainEditField.Tooltip = CodeTool1.i18n("Specify a comma-separated list of file types. Example: demo*.m, *.txt");
      App.CustomFileTypesUI.ValueChangedCallback = @() update_file_types(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Specified file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.FileTypesUI = LiteApp7.Component.EditField(NewSlot(layout, row));
      App.FileTypesUI.ReadOnly = "on";
      App.FileTypesUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % =======================================================================
      % Text to search
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label2(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Text to search") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IgnoreCaseUI = LiteApp7.Component.CheckBox(NewSlot(layout, row, Width="fit"));
      App.IgnoreCaseUI.Text = CodeTool1.i18n("Ignore case");
      App.IgnoreCaseUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      App.MatchWholeWordUI = LiteApp7.Component.CheckBox(NewSlot(layout, row, Width="fit"));
      App.MatchWholeWordUI.Text = CodeTool1.i18n("Match whole word");
      App.MatchWholeWordUI.ValueChangedCallback = @() update_state_from_ui_components(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.SearchTextUI = LiteApp8.Component.EditableDropDown(NewSlot(layout, row));
      App.SearchTextUI.Items = [];
      App.SearchTextUI.ValueChangedCallback = @() update_text_to_search(App);

      % =======================================================================
      row = NewRow(layout, column);
      LiteApp7.Component.HorizontalLine(row);

      % =======================================================================
      row = NewRow(layout, column);

      App.CopyCommandButtonUI = LiteApp7.Component.Button(NewSlot(layout, row));
      App.CopyCommandButtonUI.Text = CodeTool1.i18n("Copy command");
      App.CopyCommandButtonUI.MainButton.Tooltip = CodeTool1.i18n("Copy the search command to clipboard.");
      App.CopyCommandButtonUI.ButtonWidth = App.width_button;
      App.CopyCommandButtonUI.HorizontalAlignment = "center";
      App.CopyCommandButtonUI.ButtonPushedCallback = @() clipboard("copy", App.CommandText);

      App.SearchButtonUI = LiteApp7.Component.Button(NewSlot(layout, row));
      App.SearchButtonUI.Text = CodeTool1.i18n("Search");
      App.SearchButtonUI.ButtonWidth = App.width_button;
      App.SearchButtonUI.HorizontalAlignment = "center";
      App.SearchButtonUI.ButtonPushedCallback = @() run_search(App);

    end  % function

    function react_SelectFolderButton(App)
      %%
      selected_folder = uigetdir(pwd);
      if selected_folder == 0
        % The user clicked Cancel or the close button.

        return

      end  % if

      if not(ismember(selected_folder, App.TargetFolderUI.Items))
        selected_folder = replace(selected_folder, ("/"|"\"), " > ");
        App.TargetFolderUI.Items = [App.TargetFolderUI.Items; selected_folder];
      end  % if

      App.TargetFolderUI.Value = selected_folder;
    end  % function

    function react_SelectAllFileTypes(App)
      %%
      if App.SelectAllUI.Value
        App.FileType_m_UI.Value = true;
        App.ExcludeLiveScriptUI.Value = false;
        App.ExcludeMATLABCodeFileUI.Value = false;
        App.FileType_md_UI.Value = true;
        App.FileType_mdl_UI.Value = true;
        App.FileType_ssc_UI.Value = true;
        App.FileType_svg_UI.Value = true;

      else
        App.FileType_m_UI.Value = false;
        App.ExcludeLiveScriptUI.Value = false;
        App.ExcludeMATLABCodeFileUI.Value = false;
        App.FileType_md_UI.Value = false;
        App.FileType_mdl_UI.Value = false;
        App.FileType_ssc_UI.Value = false;
        App.FileType_svg_UI.Value = false;

      end  % if

      update_file_types(App)

    end  % function

    function update_file_types(App)
      %%
      % Use main components' Value (e.g., SelectAllUI.MainCheckBox.Value) to modify the value.
      % Modifying the containing components's Value (e.g., SelectAllUI.Value) triggers
      % events which can cause recursive calls.

      if App.FileType_m_UI.Value
        filetypes = "*.m";
        App.ExcludeLiveScriptUI.MainCheckBox.Enable = "on";
        App.ExcludeMATLABCodeFileUI.MainCheckBox.Enable = "on";
      else
        filetypes = [];
        App.SelectAllUI.MainCheckBox.Value = false;
        App.ExcludeLiveScriptUI.MainCheckBox.Value = false;
        App.ExcludeLiveScriptUI.MainCheckBox.Enable = "off";
        App.ExcludeMATLABCodeFileUI.MainCheckBox.Value = false;
        App.ExcludeMATLABCodeFileUI.MainCheckBox.Enable = "off";
      end  % if

      if App.FileType_md_UI.Value
        filetypes = [filetypes, "*.md"];
      else
        App.SelectAllUI.MainCheckBox.Value = false;
      end  % if

      if App.FileType_mdl_UI.Value
        filetypes = [filetypes, "*.mdl"];
      else
        App.SelectAllUI.MainCheckBox.Value = false;
      end  % if

      if App.FileType_ssc_UI.Value
        filetypes = [filetypes, "*.ssc"];
      else
        App.SelectAllUI.MainCheckBox.Value = false;
      end  % if

      if App.FileType_svg_UI.Value
        filetypes = [filetypes, "*.svg"];
      else
        App.SelectAllUI.MainCheckBox.Value = false;
      end  % if

      if App.CustomFileTypesUI.Value ~= ""
        filetypes_custom = split(strip(App.CustomFileTypesUI.Value), "," + optionalPattern(whitespacePattern));
        filetypes = [filetypes, filetypes_custom];
      end  % if

      if isempty(filetypes) || (isscalar(filetypes) && filetypes == "")
        App.FileTypesUI.MainEditField.Value = "";
      else
        filetypes = unique(filetypes);
        App.FileTypesUI.MainEditField.Value = join(filetypes, ", ");
      end  % if

      update_state_from_ui_components(App)

    end  % function

    function update_text_to_search(App)
      %%
      st = App.SearchTextUI.Value;
      if st ~= "" && not(ismember(st, App.SearchTextUI.Items))
        App.SearchTextUI.Items = [App.SearchTextUI.Items; st];
      end  % if
      update_state_from_ui_components(App)
    end  % function

    function update_state_from_ui_components(App)
      %%
      if not(App.GUIReady)

        return

      end  % if

      App.SearchReady = true;

      App.IncludeSubfolders = logical(App.IncludeSubfoldersUI.Value);
      App.TargetFolder = replace(App.TargetFolderUI.Value, " > ", filesep);

      if App.FileTypesUI.Value == ""
        App.SearchReady = false;
      end  % if

      App.IgnoreCase = logical(App.IgnoreCaseUI.Value);
      App.MatchWholeWord = logical(App.MatchWholeWordUI.Value);

      if App.SearchTextUI.Value == ""
        App.SearchReady = false;
        App.SearchText = "";
      else
        App.SearchText = App.SearchTextUI.Value;
      end  % if

      if not(App.SearchReady)
        App.CopyCommandButtonUI.MainButton.Enable = "off";
        App.SearchButtonUI.MainButton.Enable = "off";
        App.CommandText = "";

        return

      else
        % Text search is ready.
        App.CopyCommandButtonUI.MainButton.Enable = "on";
        App.SearchButtonUI.MainButton.Enable = "on";
        App.CommandText = TextSearchTool1.buildSearchCommandText( ...
          BuildFrom = "SearchOptions", ...
          TargetFolder = App.TargetFolder, ...
          IncludeSubfolders = App.IncludeSubfolders, ...
          FileTypes = "", ...
          ExcludeLiveScript = App.ExcludeLiveScript, ...
          ExcludeMATLABCodeFile = App.ExcludeMATLABCodeFile, ...
          TextPattern = App.SearchText, ...
          IgnoreCase = App.IgnoreCase, ...
          MatchWholeWord = App.MatchWholeWord, ...
          IncludeStyledFilePath = true);
      end  % if
    end  % function

    function run_search(App)
      %%

      App.SearchResult = TextSearchTool1.searchText( ...
        TargetFolder = App.TargetFolder, ...
        IncludeSubfolders = App.IncludeSubfolders, ...
        FileTypes = "", ...
        SelectAll = App.SelectAll, ...
        SelectMATLAB = App.SelectMATLAB, ...
        ExcludeLiveScript = App.ExcludeLiveScript, ...
        ExcludeMATLABCodeFile = App.ExcludeMATLABCodeFile, ...
        SelectMarkdown = App.SelectMarkdown, ...
        SelectSimulink = App.SelectSimulink, ...
        SelectSimscape = App.SelectSimscape, ...
        SelectSVG = App.SelectSVG, ...
        CustomFileTypes = App.CustomFileTypes, ...
        IgnoreCase = App.IgnoreCase, ...
        MatchWholeWord = App.MatchWholeWord, ...
        SearchText = App.SearchText, ...
        IncludeStyledFilePath = true );

      if isempty(App.SearchResult)
        uialert(App.Window.MainFigure, CodeTool1.i18n("Nothing matched."), CodeTool1.i18n("No match"))

        return

      end  % if

      TextSearchTool1.TextSearchResultAppMain(SearchResult=App.SearchResult);

    end  % function

  end  % methods
end  % classdef
