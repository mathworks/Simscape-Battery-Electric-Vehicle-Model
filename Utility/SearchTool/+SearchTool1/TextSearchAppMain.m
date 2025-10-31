classdef TextSearchAppMain < handle
  % App to search text in files.
  %
  % This is the main implementation of the app.

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchAppMain:"
  end  % properties

  properties

    TextSearcher (1,1) SearchTool1.TextSearcher = SearchTool1.TextSearcher
    SearchResult table
    CommandText (1,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    GUIReady (1,1) logical = false

    Window LiteApp8.LiteAppWindow

    TargetFolderUI LiteApp8.Component.DropDown
    IncludeSubfoldersUI LiteApp8.Component.CheckBox
    SelectFolderUI LiteApp8.Component.Button

    SelectAllUI LiteApp8.Component.CheckBox
    Search_m_UI LiteApp8.Component.CheckBox
    Search_md_UI LiteApp8.Component.CheckBox
    Search_mdl_UI LiteApp8.Component.CheckBox
    Search_ssc_UI LiteApp8.Component.CheckBox
    Search_svg_UI LiteApp8.Component.CheckBox
    CustomFileTypesUI LiteApp8.Component.EditField

    % SpecifiedFileTypesUI is read-only.
    SpecifiedFileTypesUI LiteApp8.Component.EditField

    ExcludeLiveScriptUI LiteApp8.Component.CheckBox
    ExcludeMATLABCodeFileUI LiteApp8.Component.CheckBox

    IgnoreCaseUI LiteApp8.Component.CheckBox
    MatchWholeWordUI LiteApp8.Component.CheckBox
    SearchTextUI LiteApp8.Component.EditableDropDown

    CopyCommandButtonUI LiteApp8.Component.Button
    SearchButtonUI LiteApp8.Component.Button

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

    function App = TextSearchAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.StatesSource (1,1) string {mustBeMember(NameValuePair.StatesSource, ["options", "external"])} = "options"

        % ---------------------------------------------------------------------
        % StatesSource="options"

        NameValuePair.TargetFolder (1,1) string {mustBeFolder} = pwd
        NameValuePair.IncludeSubfolders (1,1) logical = false

        NameValuePair.SearchAll (1,1) logical = true
        NameValuePair.SearchMATLAB (1,1) logical = true
        NameValuePair.SearchMarkdown (1,1) logical = true
        NameValuePair.SearchSimulink (1,1) logical = true
        NameValuePair.SearchSimscape (1,1) logical = true
        NameValuePair.SearchSVG (1,1) logical = true
        NameValuePair.CustomFileTypes (1,:) string = ""

        NameValuePair.ExcludeLiveScript (1,1) logical = false
        NameValuePair.ExcludeMATLABCodeFile (1,1) logical = false

        NameValuePair.IgnoreCase (1,1) logical = true
        NameValuePair.MatchWholeWord (1,1) logical = false
        NameValuePair.SearchText (1,1) string = "Copyright"

        % ---------------------------------------------------------------------
        % StatesSource="external"
        NameValuePair.SearchStates (1,:) SearchTool1.TextSearchStates

      end  % arguments

      % -----------------------------------------------------------------------
      % Before buidling app GUI

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = LiteApp8.LiteAppWindow;
      App.Window.Name = CodeTool1.i18n("Text search");
      App.Window.Height = 340;
      App.Window.Width = 600;

      meta_data = metaclass(App);
      App.Window.HeaderUI.AppSourceName = which(meta_data.Name);

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After buidling app GUI

      switch NameValuePair.StatesSource

        case "options"

          App.IncludeSubfoldersUI.Value = NameValuePair.IncludeSubfolders;

          target_folder = replace(NameValuePair.TargetFolder, ("/"|"\"), " > ");
          App.TargetFolderUI.Items = target_folder;
          App.TargetFolderUI.Value = target_folder;

          App.SelectAllUI.Value = NameValuePair.SearchAll;

          App.Search_m_UI.Value = NameValuePair.SearchMATLAB;

          App.Search_md_UI.Value = NameValuePair.SearchMarkdown;
          App.Search_mdl_UI.Value = NameValuePair.SearchSimulink;
          App.Search_ssc_UI.Value = NameValuePair.SearchSimscape;
          App.Search_svg_UI.Value = NameValuePair.SearchSVG;
          App.CustomFileTypesUI.Value = NameValuePair.CustomFileTypes;
          update_FileTypes(App)

          App.ExcludeLiveScriptUI.Value = NameValuePair.ExcludeLiveScript;
          App.ExcludeMATLABCodeFileUI.Value = NameValuePair.ExcludeMATLABCodeFile;

          App.IgnoreCaseUI.Value = NameValuePair.IgnoreCase;
          App.MatchWholeWordUI.Value = NameValuePair.MatchWholeWord;
          App.SearchTextUI.Value = NameValuePair.SearchText;

        case "external"
          if not(isfield(NameValuePair, "SearchStates"))
            id = App.errorID + "InvalidSearchStates";
            msg = CodeTool1.i18n("For external initial states, SearchStates must be specified.");

            throw(MException(id, msg))

          end  % if

          states = NameValuePair.SearchStates;

          App.IncludeSubfoldersUI.Value = states.IncludeSubfolders;

          target_folder = replace(states.TargetFolder, ("/"|"\"), " > ");
          App.TargetFolderUI.Items = target_folder;
          App.TargetFolderUI.Value = target_folder;

          App.Search_m_UI.Value = states.SearchMATLAB;

          App.Search_md_UI.Value = states.SearchMarkdown;
          App.Search_mdl_UI.Value = states.SearchSimulink;
          App.Search_ssc_UI.Value = states.SearchSimscape;
          App.Search_svg_UI.Value = states.SearchSVG;
          App.CustomFileTypesUI.Value = states.CustomFileTypes;
          update_FileTypes(App)

          App.ExcludeLiveScriptUI.Value = states.ExcludeLiveScript;
          App.ExcludeMATLABCodeFileUI.Value = states.ExcludeMATLABCodeFile;

          App.IgnoreCaseUI.Value = states.IgnoreCase;
          App.MatchWholeWordUI.Value = states.MatchWholeWord;
          x = char(string(states.SearchTextPattern));
          x = x(2:end-1);  % Remove double quotes...
          App.SearchTextUI.Value = x;

      end  % switch

      App.GUIReady = true;

      update_SearcherStatesFromUIComponents(App)

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
      label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Target folder") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.IncludeSubfoldersUI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.IncludeSubfoldersUI.Text = CodeTool1.i18n("Include subfolders");
      App.IncludeSubfoldersUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      App.SelectFolderUI = LiteApp8.Component.Button(NewSlot(layout, row, Width="fit"));
      App.SelectFolderUI.ButtonWidth = App.width_button;
      App.SelectFolderUI.Text = CodeTool1.i18n("Select...");
      App.SelectFolderUI.MainButton.Tooltip = CodeTool1.i18n("Select a target folder and add to the drop down.");
      App.SelectFolderUI.ButtonPushedCallback = @() react_SelectFolderButtonPushed(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.TargetFolderUI = LiteApp8.Component.DropDown(NewSlot(layout, row));
      App.TargetFolderUI.MainDropDown.Items = "";
      App.TargetFolderUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % =======================================================================
      % File type
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("File types") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.SelectAllUI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.SelectAllUI.Text = CodeTool1.i18n("Select all");
      App.SelectAllUI.ValueChangedCallback = @() react_SearchAllFileTypesCheckBox(App);

      App.Search_m_UI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.Search_m_UI.Text = CodeTool1.i18n("*.m");
      App.Search_m_UI.MainCheckBox.Tooltip = CodeTool1.i18n("MATLAB files");
      App.Search_m_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_md_UI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.Search_md_UI.Text = CodeTool1.i18n("*.md");
      App.Search_md_UI.MainCheckBox.Tooltip = CodeTool1.i18n("Markdown files");
      App.Search_md_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_mdl_UI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.Search_mdl_UI.Text = CodeTool1.i18n("*.mdl");
      App.Search_mdl_UI.MainCheckBox.Tooltip = CodeTool1.i18n("Simulink model files");
      App.Search_mdl_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_ssc_UI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.Search_ssc_UI.Text = CodeTool1.i18n("*.ssc");
      App.Search_ssc_UI.MainCheckBox.Tooltip = CodeTool1.i18n("Simscape source files");
      App.Search_ssc_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_svg_UI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.Search_svg_UI.Text = CodeTool1.i18n("*.svg");
      App.Search_svg_UI.MainCheckBox.Tooltip = CodeTool1.i18n("Scalable vector graphics files");
      App.Search_svg_UI.ValueChangedCallback = @() update_FileTypes(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Custom file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.CustomFileTypesUI = LiteApp8.Component.EditField(NewSlot(layout, row));
      App.CustomFileTypesUI.MainEditField.Tooltip = CodeTool1.i18n("Specify a comma-separated list of file types. Example: demo*.m, *.txt");
      App.CustomFileTypesUI.ValueChangedCallback = @() update_FileTypes(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = CodeTool1.i18n("Specified file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.SpecifiedFileTypesUI = LiteApp8.Component.EditField(NewSlot(layout, row));
      App.SpecifiedFileTypesUI.ReadOnly = "on";
      App.SpecifiedFileTypesUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.ExcludeLiveScriptUI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.ExcludeLiveScriptUI.Text = CodeTool1.i18n("Exclude Live Script");
      App.ExcludeLiveScriptUI.ValueChangedCallback = @() update_FileTypes(App);

      App.ExcludeMATLABCodeFileUI = LiteApp8.Component.CheckBox(NewSlot(layout, row));
      App.ExcludeMATLABCodeFileUI.Text = CodeTool1.i18n("Exclude MATLAB code");
      App.ExcludeMATLABCodeFileUI.ValueChangedCallback = @() update_FileTypes(App);

      % =======================================================================
      % Text to search
      row = NewRow(layout, column);
      label_ui = LiteApp8.Component.Label(NewSlot(layout, row, Width="fit"));
      label_ui.Text = "\textbf{" + CodeTool1.i18n("Text to search") + "}";

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);

      App.IgnoreCaseUI = LiteApp8.Component.CheckBox(NewSlot(layout, row, Width="fit"));
      App.IgnoreCaseUI.Text = CodeTool1.i18n("Ignore case");
      App.IgnoreCaseUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      App.MatchWholeWordUI = LiteApp8.Component.CheckBox(NewSlot(layout, row, Width="fit"));
      App.MatchWholeWordUI.Text = CodeTool1.i18n("Match whole word");
      App.MatchWholeWordUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % -----------------------------------------------------------------------
      row = NewRow(layout, column);
      App.SearchTextUI = LiteApp8.Component.EditableDropDown(NewSlot(layout, row));
      App.SearchTextUI.Items = [];
      App.SearchTextUI.ValueChangedCallback = @() react_SearchTextChanged(App);

      % =======================================================================
      row = NewRow(layout, column);
      LiteApp8.Component.HorizontalLine(row);

      % =======================================================================
      row = NewRow(layout, column);

      App.CopyCommandButtonUI = LiteApp8.Component.Button(NewSlot(layout, row));
      App.CopyCommandButtonUI.Text = CodeTool1.i18n("Copy command");
      App.CopyCommandButtonUI.MainButton.Tooltip = CodeTool1.i18n("Copy the search command to clipboard.");
      App.CopyCommandButtonUI.ButtonWidth = App.width_button;
      App.CopyCommandButtonUI.HorizontalAlignment = "center";
      App.CopyCommandButtonUI.ButtonPushedCallback = @() react_CopyCommandButtonPushed(App);

      App.SearchButtonUI = LiteApp8.Component.Button(NewSlot(layout, row));
      App.SearchButtonUI.Text = CodeTool1.i18n("Search");
      App.SearchButtonUI.ButtonWidth = App.width_button;
      App.SearchButtonUI.HorizontalAlignment = "center";
      App.SearchButtonUI.ButtonPushedCallback = @() react_SearchButtonPushed(App);
    end  % function

    function react_SelectFolderButtonPushed(App)
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

    function react_SearchAllFileTypesCheckBox(App)
      %%
      if App.SelectAllUI.Value
        App.Search_m_UI.Value = true;
        App.Search_md_UI.Value = true;
        App.Search_mdl_UI.Value = true;
        App.Search_ssc_UI.Value = true;
        App.Search_svg_UI.Value = true;
      else
        App.Search_m_UI.Value = false;
        App.Search_md_UI.Value = false;
        App.Search_mdl_UI.Value = false;
        App.Search_ssc_UI.Value = false;
        App.Search_svg_UI.Value = false;
      end  % if
      update_FileTypes(App)
    end  % function

    function update_FileTypes(App)
      %%
      % Use main components' Value (e.g., SelectAllUI.MainCheckBox.Value) to modify the value.
      % Modifying the containing components's Value (e.g., SelectAllUI.Value) triggers
      % broader events which can cause recursive calls.

      file_types = [];

      if App.Search_m_UI.Value
        file_types = [file_types, "*.m"];
      end  % if

      if App.Search_md_UI.Value
        file_types = [file_types, "*.md"];
      end  % if

      if App.Search_mdl_UI.Value
        file_types = [file_types, "*.mdl"];
      end  % if

      if App.Search_ssc_UI.Value
        file_types = [file_types, "*.ssc"];
      end  % if

      if App.Search_svg_UI.Value
        file_types = [file_types, "*.svg"];
      end  % if

      if numel(file_types) ~= 5
        App.SelectAllUI.MainCheckBox.Value = false;
      end  % if

      if App.CustomFileTypesUI.Value ~= ""
        filetypes_custom = split(strip(App.CustomFileTypesUI.Value), "," + optionalPattern(whitespacePattern));
        file_types = [file_types, filetypes_custom];
      end  % if

      if isempty(file_types) || (isscalar(file_types) && file_types == "")
        App.SpecifiedFileTypesUI.MainEditField.Value = "";
      else
        file_types = unique(file_types);
        App.SpecifiedFileTypesUI.MainEditField.Value = join(file_types, ", ");
      end  % if

      update_SearcherStatesFromUIComponents(App)

    end  % function

    function react_SearchTextChanged(App)
      %%
      st = App.SearchTextUI.Value;
      if st ~= "" && not(ismember(st, App.SearchTextUI.Items))
        App.SearchTextUI.Items = [App.SearchTextUI.Items; st];
      end  % if
      update_SearcherStatesFromUIComponents(App)
    end  % function

    function update_SearcherStatesFromUIComponents(App)
      %%
      if not(App.GUIReady)

        return

      end  % if

      App.TextSearcher.States.SearchTextPattern = App.SearchTextUI.Value;

      App.TextSearcher.States.TargetFolder = replace(App.TargetFolderUI.Value, " > ", filesep);
      App.TextSearcher.States.IncludeSubfolders = logical(App.IncludeSubfoldersUI.Value);

      App.TextSearcher.States.FileTypes = split(App.SpecifiedFileTypesUI.Value, "," + optionalPattern(whitespacePattern));

      App.TextSearcher.States.SearchAll = logical(App.SelectAllUI.Value);
      App.TextSearcher.States.SearchMATLAB = logical(App.Search_m_UI.Value);
      App.TextSearcher.States.SearchMarkdown = logical(App.Search_md_UI.Value);
      App.TextSearcher.States.SearchSimulink = logical(App.Search_mdl_UI.Value);
      App.TextSearcher.States.SearchSimscape = logical(App.Search_ssc_UI.Value);
      App.TextSearcher.States.SearchSVG = logical(App.Search_svg_UI.Value);

      App.TextSearcher.States.CustomFileTypes = App.CustomFileTypesUI.Value;

      App.TextSearcher.States.ExcludeLiveScript = logical(App.ExcludeLiveScriptUI.Value);
      App.TextSearcher.States.ExcludeMATLABCodeFile = logical(App.ExcludeMATLABCodeFileUI.Value);

      App.TextSearcher.States.IgnoreCase = logical(App.IgnoreCaseUI.Value);
      App.TextSearcher.States.MatchWholeWord = logical(App.MatchWholeWordUI.Value);

      if not(ready(App.TextSearcher))
        App.CopyCommandButtonUI.MainButton.Enable = "off";
        App.SearchButtonUI.MainButton.Enable = "off";
        App.CommandText = "";
      else
        % Text search is ready.
        App.CopyCommandButtonUI.MainButton.Enable = "on";
        App.SearchButtonUI.MainButton.Enable = "on";
        App.CommandText = "SearchTool1.searchText(" + getCommandArgumentText(App.TextSearcher) + ")";
      end  % if
    end  % function

    function react_CopyCommandButtonPushed(App)
      %%
      clipboard("copy", App.CommandText)
    end  % function

    function react_SearchButtonPushed(App)
      %%
      App.SearchResult = runSearch(App.TextSearcher);

      if isempty(App.SearchResult)
        uialert(App.Window.MainFigure, CodeTool1.i18n("Nothing matched."), CodeTool1.i18n("No match"))

        return

      end  % if

      SearchTool1.TextSearchResultViewerAppMain(App.TextSearcher, SearchResult=App.SearchResult)

    end  % function

  end  % methods
end  % classdef
