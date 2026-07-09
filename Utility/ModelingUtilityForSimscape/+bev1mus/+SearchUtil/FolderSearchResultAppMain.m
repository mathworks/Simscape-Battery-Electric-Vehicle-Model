classdef FolderSearchResultAppMain < handle
  % App to view the result of folder search.
  %
  % This is the main implementation of the app.

  % Copyright 2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "FolderSearchResultAppMain:"
  end  % properties

  properties
    SearchFolderName string
    TopFolder string

    SearchResult (:,1) string

    % -------------------------------------------------------------------------
    % GUI parts
    Window bev1mus.AppUtil.AppWindow
    NewSearchButtonUI bev1mus.AppUtil.Component.Button
    NumMatchesUI bev1mus.AppUtil.Component.EditField
    RefreshButtonUI bev1mus.AppUtil.Component.Button
    TableUI bev1mus.AppUtil.Component.Table
  end  % properties

  properties (Constant, Access=private)
    width_name_ui = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 18
    width_button = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12
  end  % properties

  methods

    function App = FolderSearchResultAppMain(NameValuePair)
      %%
      % SearchResult can be optionally specified.
      % If SearchResult is not specified, search is run using the searchFolders command.
      arguments (Input)
        NameValuePair.SearchResult (:,1) string
        NameValuePair.SearchFolderName (1,1) string = ""
        NameValuePair.TopFolder (:,1) string {mustBeFolder}
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      if isfield(NameValuePair, "SearchResult")
        App.SearchResult = NameValuePair.SearchResult;
      else
        App.SearchResult = "";
      end  % if

      App.SearchFolderName = NameValuePair.SearchFolderName;

      if App.SearchFolderName ~= ""
        App.TopFolder = NameValuePair.TopFolder;
      else
        App.TopFolder = "";
      end  % if

      meta_data = metaclass(App);

      main_figure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = bev1mus.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bev1mus.CodeUtil.i18n("Folder search result");
      App.Window.Height = 400;
      App.Window.Width = 800;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if App.SearchFolderName ~= "" && App.TopFolder ~= ""
        App.RefreshButtonUI.MainButton.Enable = "on";
      end  % if

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
      h_container = bev1mus.AppUtil.HorizontalContainer(v_layout);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bev1mus.CodeUtil.i18n("Search conditions") + "}";

      App.NewSearchButtonUI = bev1mus.AppUtil.Component.Button(addHorizontalGridLayout(h_container));
      App.NewSearchButtonUI.ButtonWidth = App.width_button;
      App.NewSearchButtonUI.HorizontalAlignment = "right";
      App.NewSearchButtonUI.Text = bev1mus.CodeUtil.i18n("New search...");
      App.NewSearchButtonUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Open the folder search app.");
      App.NewSearchButtonUI.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bev1mus.AppUtil.HorizontalContainer(v_layout);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bev1mus.CodeUtil.i18n("Searched folder name");

      editfield_ui = bev1mus.AppUtil.Component.EditField(addHorizontalGridLayout(h_container));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = App.SearchFolderName;

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bev1mus.AppUtil.HorizontalContainer(v_layout);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bev1mus.CodeUtil.i18n("Top folder");

      target_folder = App.TopFolder;

      editfield_ui = bev1mus.AppUtil.Component.EditField(addHorizontalGridLayout(h_container));
      editfield_ui.ReadOnly = "on";
      if target_folder ~= ""
        editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");
      else
        editfield_ui.Value = "";
      end  % if

      % =======================================================================
      v_layout = addVerticalGridLayout(main_v_container);
      bev1mus.AppUtil.Component.HorizontalLine(v_layout);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      h_container = bev1mus.AppUtil.HorizontalContainer(v_layout);

      label_ui = bev1mus.AppUtil.Component.Label(addHorizontalGridLayout(h_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bev1mus.CodeUtil.i18n("Number of matches");

      App.NumMatchesUI = bev1mus.AppUtil.Component.EditField(addHorizontalGridLayout(h_container, Width="1x"));
      App.NumMatchesUI.ReadOnly = "on";
      if App.SearchResult ~= ""
        App.NumMatchesUI.Value = string(numel(App.SearchResult));
      else
        App.NumMatchesUI.Value = "";
      end  % if

      App.RefreshButtonUI = bev1mus.AppUtil.Component.Button(addHorizontalGridLayout(h_container, Width="fit"));
      App.RefreshButtonUI.ButtonWidth = App.width_button;
      App.RefreshButtonUI.Text = bev1mus.CodeUtil.i18n("Refresh");
      App.RefreshButtonUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Rerun search and update the result table.");
      App.RefreshButtonUI.MainButton.Enable = "off";
      App.RefreshButtonUI.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container);
      label_ui = bev1mus.AppUtil.Component.Label(v_layout);
      label_ui.Text = bev1mus.CodeUtil.i18n("Double-click a table row to change to the folder.");

      % -----------------------------------------------------------------------
      v_layout = addVerticalGridLayout(main_v_container, Height="1x");
      App.TableUI = bev1mus.AppUtil.Component.Table(v_layout);
      App.TableUI.ComponentHeight = "fit";
      if App.SearchResult ~= ""
        App.TableUI.MainTable.Data = table(App.SearchResult);
        App.TableUI.MainTable.ColumnName = bev1mus.CodeUtil.i18n("Folder path");
        App.TableUI.MainTable.ColumnWidth = '1x';
        App.TableUI.MainTable.ColumnSortable = true;
        App.TableUI.MainTable.SelectionType = "row";
        % uitable's DoubleClickedFcn callback is given a DoubleClickedData object as the second argument,
        % and the object provides information such as the clicked row via InteractionInformation.Row, etc.
        % Search "DoubleClickedData" or "InteractionInformation" in the documentation for details.
        % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table.html
        App.TableUI.MainTable.DoubleClickedFcn = @(~, DoubleClickedData) ...
          react_TableDoubleClicked(App, DoubleClickedData.InteractionInformation.Row);
     else
        App.TableUI.MainTable.Data = table.empty;
        App.TableUI.MainTable.ColumnName = bev1mus.CodeUtil.i18n("Folder path");
     end  % if

    end  % function

    function react_NewSearch(App)
      if App.TopFolder ~= "" && App.SearchFolderName ~= ""
        bev1mus.SearchUtil.FolderSearchAppMain(TopFolder=App.TopFolder, SearchFolderName=App.SearchFolderName)
      else
        bev1mus.SearchUtil.FolderSearchAppMain
      end  % if
    end  % function

    function react_RefreshButtonPushed(App)
      FolderPath = bev1mus.SearchUtil.searchFolders(App.SearchFolderName, TopFolder=App.TopFolder);
      App.SearchResult = FolderPath;
      App.TableUI.MainTable.Data = table(FolderPath);
      App.NumMatchesUI.Value = string(height(App.SearchResult));
    end  % function

    function react_TableDoubleClicked(App, row_number)
      folder_fullpath = App.SearchResult(row_number);
      cd(folder_fullpath)
    end  % function

  end  % methods
end  % classdef
