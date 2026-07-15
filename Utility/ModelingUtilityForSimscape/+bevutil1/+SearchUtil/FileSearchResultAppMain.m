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
    Window bevutil1.AppUtil.AppWindow
    NewSearchButtonUI bevutil1.AppUtil.Component.Button
    NumMatchesUI bevutil1.AppUtil.Component.EditField
    RefreshButtonUI bevutil1.AppUtil.Component.Button
    TableUI bevutil1.AppUtil.Component.Table
  end  % properties

  properties (Constant, Access=private)
    width_name_ui = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 18
    width_button = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
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

      App.Window = bevutil1.AppUtil.AppWindow(main_figure, SourceFile=which(meta_data.Name));
      App.Window.Name = bevutil1.CodeUtil.i18n("File search result");
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
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = "\textbf{" + bevutil1.CodeUtil.i18n("Search conditions") + "}";

      App.NewSearchButtonUI = bevutil1.AppUtil.Component.Button(addHorizontalGridLayout(horizontal_container));
      App.NewSearchButtonUI.ButtonWidth = App.width_button;
      App.NewSearchButtonUI.HorizontalAlignment = "right";
      App.NewSearchButtonUI.Text = bevutil1.CodeUtil.i18n("New search...");
      App.NewSearchButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Open the file search app.");
      App.NewSearchButtonUI.ButtonPushedCallback = @() react_NewSearch(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Searched file name");

      editfield_ui = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(horizontal_container));
      editfield_ui.ReadOnly = "on";
      editfield_ui.Value = App.SearchFileName;

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Top folder");

      target_folder = App.TopFolder;

      editfield_ui = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(horizontal_container));
      editfield_ui.ReadOnly = "on";
      if target_folder ~= ""
        editfield_ui.Value = replace(target_folder, ("/"|"\"), " > ");
      else
        editfield_ui.Value = "";
      end  % if

      % =======================================================================
      column_grid = addVerticalGridLayout(main_vertical_container);
      bevutil1.AppUtil.Component.HorizontalLine(column_grid);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      horizontal_container = bevutil1.AppUtil.HorizontalContainer(column_grid);

      label_ui = bevutil1.AppUtil.Component.Label(addHorizontalGridLayout(horizontal_container, Width="fit"));
      label_ui.ComponentWidth = App.width_name_ui;
      label_ui.Text = bevutil1.CodeUtil.i18n("Number of matches");

      App.NumMatchesUI = bevutil1.AppUtil.Component.EditField(addHorizontalGridLayout(horizontal_container, Width="1x"));
      App.NumMatchesUI.ReadOnly = "on";
      if App.SearchResult ~= ""
        App.NumMatchesUI.Value = string(numel(App.SearchResult));
      else
        App.NumMatchesUI.Value = "";
      end  % if

      App.RefreshButtonUI = bevutil1.AppUtil.Component.Button(addHorizontalGridLayout(horizontal_container, Width="fit"));
      App.RefreshButtonUI.ButtonWidth = App.width_button;
      App.RefreshButtonUI.Text = bevutil1.CodeUtil.i18n("Refresh");
      App.RefreshButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Rerun search and update the result table.");
      App.RefreshButtonUI.MainButton.Enable = "off";
      App.RefreshButtonUI.ButtonPushedCallback = @() react_RefreshButtonPushed(App);

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container);
      label_ui = bevutil1.AppUtil.Component.Label(column_grid);
      label_ui.Text = bevutil1.CodeUtil.i18n("Double-click a table row to open the file.");

      % -----------------------------------------------------------------------
      column_grid = addVerticalGridLayout(main_vertical_container, Height="1x");
      App.TableUI = bevutil1.AppUtil.Component.Table(column_grid);
      App.TableUI.ComponentHeight = "fit";
      if App.SearchResult ~= ""
        App.TableUI.MainTable.Data = table(App.SearchResult);
        App.TableUI.MainTable.ColumnName = bevutil1.CodeUtil.i18n("File path");
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
        App.TableUI.MainTable.ColumnName = bevutil1.CodeUtil.i18n("File path");
     end  % if

    end  % function

    function react_NewSearch(App)
      if App.TopFolder ~= "" && App.SearchFileName ~= ""
        bevutil1.SearchUtil.FileSearchAppMain(TopFolder=App.TopFolder, SearchFileName=App.SearchFileName)
      else
        bevutil1.SearchUtil.FileSearchAppMain
      end  % if
    end  % function

    function react_RefreshButtonPushed(App)
      FilePath = bevutil1.SearchUtil.searchFiles(App.SearchFileName, TopFolder=App.TopFolder);
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
