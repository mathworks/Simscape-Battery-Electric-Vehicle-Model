classdef TextSearchAppMain < handle
  % App to search text files for the specified text in a folder
  %
  % This is the main implementation of the app.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearchAppMain:"
  end  % properties

  properties

    TextSearcher (1,1) bev1mus.SearchUtil.TextSearcher = bev1mus.SearchUtil.TextSearcher
    SearchResult table
    CommandText (1,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    GUIReady (1,1) logical = false

    MainFigure matlab.ui.Figure
    Window bev1mus.AppUtil.AppWindow

    SearchTextUI bev1mus.AppUtil.Component.DropDown
    IgnoreCaseUI bev1mus.AppUtil.Component.CheckBox
    MatchWholeWordUI bev1mus.AppUtil.Component.CheckBox

    TargetFolderUI bev1mus.AppUtil.Component.DropDown
    IncludeSubfoldersUI bev1mus.AppUtil.Component.CheckBox
    SelectFolderUI bev1mus.AppUtil.Component.Button

    SelectAllUI bev1mus.AppUtil.Component.CheckBox
    Search_m_UI bev1mus.AppUtil.Component.CheckBox
    Search_md_UI bev1mus.AppUtil.Component.CheckBox
    Search_mdl_UI bev1mus.AppUtil.Component.CheckBox
    Search_ssc_UI bev1mus.AppUtil.Component.CheckBox
    Search_svg_UI bev1mus.AppUtil.Component.CheckBox
    CustomFileTypesUI bev1mus.AppUtil.Component.EditField

    % SpecifiedFileTypesUI is read-only.
    SpecifiedFileTypesUI bev1mus.AppUtil.Component.EditField

    ExcludeLiveScriptUI bev1mus.AppUtil.Component.CheckBox
    ExcludeMATLABCodeFileUI bev1mus.AppUtil.Component.CheckBox

    CopyCommandButtonUI bev1mus.AppUtil.Component.Button
    SearchButtonUI bev1mus.AppUtil.Component.Button

  end  % properties

  properties (Constant, Access=private)

    width_unit = bev1mus.AppUtil.Constant.Width{"unitwidth"}
    width_name_ui = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 18
    width_unit_ui = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 8
    width_button = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12

    height_oneline = bev1mus.AppUtil.Constant.Height{"oneline"}

  end  % properties

  methods

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
        NameValuePair.SearchStates (1,:) bev1mus.SearchUtil.TextSearchStates

      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      meta_data = metaclass(App);

      App.MainFigure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = bev1mus.AppUtil.AppWindow(App.MainFigure, SourceFile=which(meta_data.Name));
      App.Window.Name = bev1mus.CodeUtil.i18n("Text search");
      App.Window.Height = 290;
      App.Window.Width = 600;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      switch NameValuePair.StatesSource

        case "options"

          App.SearchTextUI.Items = NameValuePair.SearchText;
          App.SearchTextUI.Value = NameValuePair.SearchText;
          App.IgnoreCaseUI.Value = NameValuePair.IgnoreCase;
          App.MatchWholeWordUI.Value = NameValuePair.MatchWholeWord;

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

        case "external"
          if not(isfield(NameValuePair, "SearchStates"))
            id = App.errorID + "InvalidSearchStates";
            msg = bev1mus.CodeUtil.i18n("For external initial states, SearchStates must be specified.");

            throw(MException(id, msg))

          end  % if

          states = NameValuePair.SearchStates;

          x = char(string(states.SearchTextPattern));
          x = x(2:end-1);  % Remove double quotes.
          App.SearchTextUI.Items = x;
          App.SearchTextUI.Value = x;

          App.IgnoreCaseUI.Value = states.IgnoreCase;
          App.MatchWholeWordUI.Value = states.MatchWholeWord;

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

      end  % switch

      App.GUIReady = true;

      update_SearcherStatesFromUIComponents(App)

      % -----------------------------------------------------------------------
      movegui(App.MainFigure, "center")
      App.MainFigure.Visible = "on";
      drawnow
      if nargout == 0
        clear App
      end  % if
    end  % function

    function build_app_gui(App)
      %%
      main_vertical_container = App.Window.MainVerticalContainer;

      % =======================================================================
      % Text to search
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bev1mus.AppUtil.Component.Label(row_grid);
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bev1mus.CodeUtil.i18n("Text to search") + "}";

      App.IgnoreCaseUI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.IgnoreCaseUI.Text = bev1mus.CodeUtil.i18n("Ignore case");
      App.IgnoreCaseUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      App.MatchWholeWordUI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.MatchWholeWordUI.Text = bev1mus.CodeUtil.i18n("Match whole word");
      App.MatchWholeWordUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);

      App.SearchTextUI = bev1mus.AppUtil.Component.DropDown(column_grid);
      App.SearchTextUI.Editable = "on";
      App.SearchTextUI.Items = [];
      App.SearchTextUI.ValueChangedCallback = @() react_SearchTextChanged(App);

      % =======================================================================
      % Target folder
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      label_ui = bev1mus.AppUtil.Component.Label(row_grid);
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bev1mus.CodeUtil.i18n("Target folder") + "}";

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.IncludeSubfoldersUI = bev1mus.AppUtil.Component.CheckBox(row_grid);
      App.IncludeSubfoldersUI.Text = bev1mus.CodeUtil.i18n("Include subfolders");
      App.IncludeSubfoldersUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      row_grid = addHorizontalGridLayout(horizontal_container, Width="fit");
      App.SelectFolderUI = bev1mus.AppUtil.Component.Button(row_grid);
      App.SelectFolderUI.ButtonWidth = App.width_button;
      App.SelectFolderUI.Text = bev1mus.CodeUtil.i18n("Select...");
      App.SelectFolderUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Select a target folder and add to the drop down.");
      App.SelectFolderUI.ButtonPushedCallback = @() react_SelectFolderButtonPushed(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);

      App.TargetFolderUI = bev1mus.AppUtil.Component.DropDown(column_grid);
      App.TargetFolderUI.MainDropDown.Items = "";
      App.TargetFolderUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % =======================================================================
      % File type
      column_grid = addVerticalGridLayout(main_vertical_container);

      label_ui = bev1mus.AppUtil.Component.Label(column_grid);
      label_ui.Text = "\textbf{" + bev1mus.CodeUtil.i18n("File types") + "}";

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      App.SelectAllUI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.SelectAllUI.Text = bev1mus.CodeUtil.i18n("Select all");
      App.SelectAllUI.ValueChangedCallback = @() react_SearchAllFileTypesCheckBox(App);

      App.Search_m_UI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.Search_m_UI.Text = bev1mus.CodeUtil.i18n("*.m");
      App.Search_m_UI.MainCheckBox.Tooltip = bev1mus.CodeUtil.i18n("MATLAB files");
      App.Search_m_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_md_UI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.Search_md_UI.Text = bev1mus.CodeUtil.i18n("*.md");
      App.Search_md_UI.MainCheckBox.Tooltip = bev1mus.CodeUtil.i18n("Markdown files");
      App.Search_md_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_mdl_UI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.Search_mdl_UI.Text = bev1mus.CodeUtil.i18n("*.mdl");
      App.Search_mdl_UI.MainCheckBox.Tooltip = bev1mus.CodeUtil.i18n("Simulink model files");
      App.Search_mdl_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_ssc_UI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.Search_ssc_UI.Text = bev1mus.CodeUtil.i18n("*.ssc");
      App.Search_ssc_UI.MainCheckBox.Tooltip = bev1mus.CodeUtil.i18n("Simscape source files");
      App.Search_ssc_UI.ValueChangedCallback = @() update_FileTypes(App);

      App.Search_svg_UI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container));
      App.Search_svg_UI.Text = bev1mus.CodeUtil.i18n("*.svg");
      App.Search_svg_UI.MainCheckBox.Tooltip = bev1mus.CodeUtil.i18n("Scalable vector graphics files");
      App.Search_svg_UI.ValueChangedCallback = @() update_FileTypes(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.Text = bev1mus.CodeUtil.i18n("Custom file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.CustomFileTypesUI = bev1mus.AppUtil.Component.EditField(addHorizontalGridLayout(horizontal_container));
      App.CustomFileTypesUI.MainEditField.Tooltip = bev1mus.CodeUtil.i18n("Specify a comma-separated list of file types. Example: demo*.m, *.txt");
      App.CustomFileTypesUI.ValueChangedCallback = @() update_FileTypes(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.Text = bev1mus.CodeUtil.i18n("Specified file types");
      label_ui.ComponentWidth = App.width_name_ui;

      App.SpecifiedFileTypesUI = bev1mus.AppUtil.Component.EditField(addHorizontalGridLayout(horizontal_container));
      App.SpecifiedFileTypesUI.ReadOnly = "on";
      App.SpecifiedFileTypesUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      App.ExcludeLiveScriptUI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.ExcludeLiveScriptUI.Text = bev1mus.CodeUtil.i18n("Exclude Live Script files from *.m");
      App.ExcludeLiveScriptUI.ValueChangedCallback = @() update_FileTypes(App);

      App.ExcludeMATLABCodeFileUI = bev1mus.AppUtil.Component.CheckBox(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.ExcludeMATLABCodeFileUI.Text = bev1mus.CodeUtil.i18n("Exclude MATLAB code files from *.m");
      App.ExcludeMATLABCodeFileUI.ValueChangedCallback = @() update_FileTypes(App);

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      bev1mus.AppUtil.Component.HorizontalLine(column_grid);

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bev1mus.AppUtil.HorizontalContainer(column_grid);

      App.CopyCommandButtonUI = bev1mus.AppUtil.Component.Button(addHorizontalGridLayout(horizontal_container));
      App.CopyCommandButtonUI.Text = bev1mus.CodeUtil.i18n("Copy command");
      App.CopyCommandButtonUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Copy the search command to clipboard.");
      App.CopyCommandButtonUI.ButtonWidth = App.width_button;
      App.CopyCommandButtonUI.HorizontalAlignment = "center";
      App.CopyCommandButtonUI.ButtonPushedCallback = @() react_CopyCommandButtonPushed(App);

      App.SearchButtonUI = bev1mus.AppUtil.Component.Button(addHorizontalGridLayout(horizontal_container));
      App.SearchButtonUI.Text = bev1mus.CodeUtil.i18n("Search");
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
        App.CommandText = "bev1mus.SearchUtil.searchText(" + getCommandArgumentText(App.TextSearcher) + ")";
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
        uialert(App.MainFigure, bev1mus.CodeUtil.i18n("Nothing matched."), bev1mus.CodeUtil.i18n("No match"))

        return

      end  % if

      bev1mus.SearchUtil.TextSearchResultAppMain(App.TextSearcher, SearchResult=App.SearchResult)

    end  % function

  end  % methods
end  % classdef
