classdef FileSearchResultAppMain < handle
  % App to view the result of file search.
  %
  % This is the main implementation of the app.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "FileSearchResultAppMain:"
  end  % properties

  properties
    SearchFileName string
    TopFolder string

    SearchResult (:,1) string

    % -------------------------------------------------------------------------
    % GUI parts
    Window AppUtil1.AppWindow
    NewSearchButtonUI AppUtil1.Component.Button
    NumMatchesUI AppUtil1.Component.EditField
    RefreshButtonUI AppUtil1.Component.Button
    TableUI AppUtil1.Component.Table
  end  % properties

  properties (Constant, Access=private)
    width_name_ui = AppUtil1.Constant.Width{"unitwidth"} * 18
    width_button = AppUtil1.Constant.Width{"unitwidth"} * 12
  end  % properties

  methods

    function App = FileSearchResultAppMain(NameValuePair)
      %%
      % SearchResult can be optionally specified.
      % If SearchResult is not specified, search is run using the searchFiles command.
      arguments (Input)
        NameValuePair.SearchResult (:,1) string
        NameValuePair.SearchFileName (1,1) string = ""
        NameValuePair.TopFolder (:,1) string {mustBeFolder}
      end  % arguments

      % -----------------------------------------------------------------------
      % Before building app GUI

      if isfield(NameValuePair, "SearchResult")
        App.SearchResult = NameValuePair.SearchResult;
      else
        App.SearchResult = "";
      end  % if

      App.SearchFileName = NameValuePair.SearchFileName;

      if App.SearchFileName ~= ""
        App.TopFolder = NameValuePair.TopFolder;
      else
        App.TopFolder = "";
      end  % if

      meta_data = metaclass(App);

      main_figure = uifigure(Visible="off");

      % -----------------------------------------------------------------------
      % Build app GUI

      App.Window = AppUtil1.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = CodeUtil1.i18n("File search result");
      App.Window.Height = 400;
      App.Window.Width = 800;

      build_app_gui(App)

      % -----------------------------------------------------------------------
      % After building app GUI

      if App.SearchFileName ~= "" && App.TopFolder ~= ""
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
      main_vertical_container = App.Window.MainVerticalContainer;

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = AppUtil1.HorizontalContainer(column_grid);

      label_ui = AppUtil1.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + CodeUtil1.i18n("Search conditions") + "}";

      App.NewSearchButtonUI = AppUtil1.Component.Button(addHorizontalGridLayout(horizontal_container));
      App.NewSearchButtonUI.ButtonWidth = App.width_button;
      App.NewSearchButtonUI.HorizontalAlignment = "right";
      App.NewSearchButtonUI.Text = CodeUtil1.i18n("New search...");
      App.NewSearchButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Open the file search app.");
      App.NewSearchButtonUI.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = AppUtil1.HorizontalContainer(column_grid);

      label_ui = AppUtil1.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeUtil1.i18n("Searched file name");

      editfield_ui = AppUtil1.Component.EditField(addHorizontalGridLayout(horizontal_container));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = App.SearchFileName;

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = AppUtil1.HorizontalContainer(column_grid);

      label_ui = AppUtil1.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeUtil1.i18n("Top folder");

      target_folder = App.TopFolder;

      editfield_ui = AppUtil1.Component.EditField(addHorizontalGridLayout(horizontal_container));
      editfield_ui.ReadOnly = "on";
      if target_folder ~= ""
        editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");
      else
        editfield_ui.Value = "";
      end  % if

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      AppUtil1.Component.HorizontalLine(column_grid);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = AppUtil1.HorizontalContainer(column_grid);

      label_ui = AppUtil1.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = CodeUtil1.i18n("Number of matches");

      App.NumMatchesUI = AppUtil1.Component.EditField(addHorizontalGridLayout(horizontal_container, Width="1x"));
      App.NumMatchesUI.ReadOnly = "on";
      if App.SearchResult ~= ""
        App.NumMatchesUI.Value = string(numel(App.SearchResult));
      else
        App.NumMatchesUI.Value = "";
      end  % if

      App.RefreshButtonUI = AppUtil1.Component.Button(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.RefreshButtonUI.ButtonWidth = App.width_button;
      App.RefreshButtonUI.Text = CodeUtil1.i18n("Refresh");
      App.RefreshButtonUI.MainButton.Tooltip = CodeUtil1.i18n("Rerun search and update the result table.");
      App.RefreshButtonUI.MainButton.Enable = "off";
      App.RefreshButtonUI.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      label_ui = AppUtil1.Component.Label(column_grid);
      label_ui.Text = CodeUtil1.i18n("Double-click a table row to open the file.");

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container, Height="1x");
      App.TableUI = AppUtil1.Component.Table(column_grid);
      App.TableUI.ComponentHeight = "fit";
      if App.SearchResult ~= ""
        App.TableUI.MainTable.Data = table(App.SearchResult);
        App.TableUI.MainTable.ColumnName = CodeUtil1.i18n("File path");
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
        App.TableUI.MainTable.ColumnName = CodeUtil1.i18n("File path");
     end  % if

    end  % function

    function react_NewSearch(App)
      if App.TopFolder ~= "" && App.SearchFileName ~= ""
        SearchUtil1.FileSearchAppMain(TopFolder=App.TopFolder, SearchFileName=App.SearchFileName)
      else
        SearchUtil1.FileSearchAppMain
      end  % if
    end  % function

    function react_RefreshButtonPushed(App)
      FilePath = SearchUtil1.searchFiles(App.SearchFileName, TopFolder=App.TopFolder);
      App.SearchResult = FilePath;
      App.TableUI.MainTable.Data = table(FilePath);
      App.NumMatchesUI.Value = string(height(App.SearchResult));
    end  % function

    function react_TableDoubleClicked(App, row_number)
      file_fullpath = App.SearchResult(row_number);
      open(file_fullpath)
    end  % function

  end  % methods
end  % classdef
