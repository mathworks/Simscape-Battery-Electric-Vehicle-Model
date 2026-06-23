classdef FolderSearchAppMain < handle
  % App for searching a folder tree for the specified folder names.
  %
  % This is the main implementation of the app.

  % Copyright 2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "FolderSearchAppMain:"
  end  % properties

  properties

    SearchResult (:,1) string
    CommandText (1,1) string

    % -------------------------------------------------------------------------
    % GUI parts

    GUIReady (1,1) logical = false

    Window AppUtil1.AppWindow

    TopFolderUI AppUtil1.Component.DropDown
    SelectFolderUI AppUtil1.Component.Button

    SearchFolderNameUI AppUtil1.Component.DropDown

    CopyCommandButtonUI AppUtil1.Component.Button
    SearchButtonUI AppUtil1.Component.Button

  end  % properties

  properties (Constant, Access=private)
    width_button = AppUtil1.Constant.Width{"unitwidth"} * 12
  end  % properties

  methods

    function App = FolderSearchAppMain(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.SearchFolderName (1,1) string = ".buidltool"
        NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      meta_data = metaclass(App);

      main_figure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = AppUtil1.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = CodeUtil1.i18n("Folder search");
      App.Window.Height = 160;
      App.Window.Width = 600;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      target_folder = replace(NameValuePair.TopFolder, ("/"|"\"), " > ");
      App.TopFolderUI.Items = target_folder;
      App.TopFolderUI.Value = target_folder;

      App.SearchFolderNameUI.Items = NameValuePair.SearchFolderName;
      App.SearchFolderNameUI.Value = NameValuePair.SearchFolderName;

      App.GUIReady = true;

      update_SearcherStatesFromUIComponents(App)

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
      % FileName to search
      v_layout = addVerticalGridLayout(main_v_container);

      label_ui = AppUtil1.Component.Label(v_layout);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Folder name to search") + "}";

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);

      App.SearchFolderNameUI = AppUtil1.Component.DropDown(v_layout);
      App.SearchFolderNameUI.Editable = "on";
      App.SearchFolderNameUI.Items = [];
      App.SearchFolderNameUI.ValueChangedCallback = @() react_SearchFolderNameChanged(App);

      % =======================================================================
      % Top folder
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = AppUtil1.HorizontalContainer(v_layout);

      row_grid = addHorizontalGridLayout(h_container, Width="fit");
      label_ui = AppUtil1.Component.Label(row_grid);
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Top folder") + "}";

      row_grid = addHorizontalGridLayout(h_container, Width="fit");
      App.SelectFolderUI = AppUtil1.Component.Button(row_grid);
      App.SelectFolderUI.ButtonWidth = App.width_button;
      App.SelectFolderUI.Text = CodeUtil1.i18n("Select...");
      App.SelectFolderUI.MainButton.Tooltip = CodeUtil1.i18n("Select a target folder and add to the drop down.");
      App.SelectFolderUI.ButtonPushedCallback = @() react_SelectFolderButtonPushed(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);

      App.TopFolderUI = AppUtil1.Component.DropDown(v_layout);
      App.TopFolderUI.MainDropDown.Items = "";
      App.TopFolderUI.ValueChangedCallback = @() update_SearcherStatesFromUIComponents(App);

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      AppUtil1.Component.HorizontalLine(v_layout);

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = AppUtil1.HorizontalContainer(v_layout);

      App.CopyCommandButtonUI = AppUtil1.Component.Button(addHorizontalGridLayout(h_container));
      App.CopyCommandButtonUI.Text = CodeUtil1.i18n("Copy command");
      App.CopyCommandButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Copy the search command to clipboard.");
      App.CopyCommandButtonUI.ButtonWidth = App.width_button;
      App.CopyCommandButtonUI.HorizontalAlignment = "center";
      App.CopyCommandButtonUI.ButtonPushedCallback = @() react_CopyCommandButtonPushed(App);

      App.SearchButtonUI = AppUtil1.Component.Button(addHorizontalGridLayout(h_container));
      App.SearchButtonUI.Text = CodeUtil1.i18n("Search");
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
      if not(ismember(selected_folder, App.TopFolderUI.Items))
        selected_folder = replace(selected_folder, ("/"|"\"), " > ");
        App.TopFolderUI.Items = [App.TopFolderUI.Items; selected_folder];
      end  % if
      App.TopFolderUI.Value = selected_folder;
    end  % function

    function react_SearchFolderNameChanged(App)
      %%
      st = App.SearchFolderNameUI.Value;
      if st ~= "" && not(ismember(st, App.SearchFolderNameUI.Items))
        App.SearchFolderNameUI.Items = [App.SearchFolderNameUI.Items; st];
      end  % if
      update_SearcherStatesFromUIComponents(App)
    end  % function

    function update_SearcherStatesFromUIComponents(App)
      %%
      if not(App.GUIReady)

        return

      end  % if

      if App.SearchFolderNameUI.Value == ""
        % Search is not ready.
        App.CopyCommandButtonUI.MainButton.Enable = "off";
        App.SearchButtonUI.MainButton.Enable = "off";
        App.CommandText = "";
      else
        % Search is ready.
        App.CopyCommandButtonUI.MainButton.Enable = "on";
        App.SearchButtonUI.MainButton.Enable = "on";
        top_folder = replace(App.TopFolderUI.Value, " > ", filesep);
        App.CommandText = "SearchUtil1.searchFolders(""" + App.SearchFolderNameUI.Value + """, TopFolder=""" + top_folder + """)";
      end  % if
    end  % function

    function react_CopyCommandButtonPushed(App)
      %%
      clipboard("copy", App.CommandText)
    end  % function

    function react_SearchButtonPushed(App)
      %%
      if App.SearchFolderNameUI.Value == ""
        % Search is not ready.

        return

      end  % if

      top_folder = replace(App.TopFolderUI.Value, " > ", filesep);
      App.SearchResult = SearchUtil1.searchFolders(App.SearchFolderNameUI.Value, TopFolder=top_folder);

      if isempty(App.SearchResult)
        uialert(App.Window.MainFigure, CodeUtil1.i18n("Folder was not found."), CodeUtil1.i18n("Not found"))

        return

      end  % if

      SearchUtil1.FolderSearchResultAppMain( ...
        SearchResult = App.SearchResult, ...
        SearchFolderName = App.SearchFolderNameUI.Value, ...
        TopFolder = top_folder)

    end  % function

  end  % methods
end  % classdef
