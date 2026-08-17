classdef BaseWorkspaceStructParameterUI < bevutil1.AppUtil.Component.ComponentBase
  % UI component for loading parameters in the base workspace.

  % Copyright 2026 The MathWorks, Inc.

  properties (Constant, Access=private)
    errorID (1,1) string = "BaseWorkspaceStructParameterUI:"
  end  % properties
  properties

    GetParametersFromBaseWorkspaceCallback (:,1) {bevutil1.CodeUtil.mustBeFunctionHandleOrEmpty}

    NameUIWidth (1,1) {mustBeInteger, mustBePositive} = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 14

    ButtonUIWidth (1,1) {mustBeInteger, mustBePositive} = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 12
    MainButtonWidth (1,1) {mustBeInteger, mustBePositive} = bevutil1.AppUtil.Constant.Width{"unitwidth"} * 11

    % -------------------------------------------------------------------------
    % GUI parts

    % For the "Parameter file" row
    ParameterFileRow matlab.ui.container.GridLayout
    ParameterFileTextUI bevutil1.AppUtil.Component.Label
    ParameterFileDropDownUI bevutil1.AppUtil.Component.DropDown
    SelecFileButtonUI bevutil1.AppUtil.Component.Button
    EditFileButtonUI bevutil1.AppUtil.Component.Button

    % For the "Variable name" row
    StructNameRow matlab.ui.container.GridLayout
    StructNameTextUI bevutil1.AppUtil.Component.Label
    StructNameDropDownUI bevutil1.AppUtil.Component.DropDown
    GetParametersFromBaseWorkspaceUI bevutil1.AppUtil.Component.Button
    OpenVariablesEditorButtonUI bevutil1.AppUtil.Component.Button

  end  % properties
  properties (Dependent)

    % Assign a full path to a parameter file to this property, and it adds
    % the specified parameter file to the "Parameter file" drop down and selects it.
    % If the specified parameter file already exists in the drop down items,
    % the existing item is selected.
    ParameterFileFullPath (1,1) string

  end  % properties
  properties

    WorkingFolder (1,1) string

    % Callbacks may not work until components are initialized.
    Initialized (1,1) logical = false

  end  % properties
  properties (Constant, Access=private)

    common_ui_height = bevutil1.AppUtil.Constant.Height{"oneline++"}

  end  % properties
  properties (Access=private)

    current_parameterfile_fullpath (1,1) string = ""

  end  % properties
  properties

    % To see outputs from the setup method, you must modify Reporting to "on" here:
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties

  methods

    function callback_select_and_load_parameter_file(component, NameValuePair)
      %%
      arguments (Input)
        component
        NameValuePair.ParameterFileFullPath (1,1) string = ""
      end  % arguments

      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation()
      end  % if

      if NameValuePair.ParameterFileFullPath ~= ""
        % ParameterFileFullPath option was specified.
        component.ParameterFileFullPath = NameValuePair.ParameterFileFullPath;
        component.WorkingFolder = fileparts(component.ParameterFileFullPath);
        if not(isfile(component.ParameterFileFullPath))
          kwd = component.errorID + "InvalidFile";
          msg = bevutil1.CodeUtil.i18n("Invalid file was specified: ") + NameValuePair.ParameterFileFullPath;

          throw(MException(kwd, msg))

        end  % if

      else
        % Open a dialog window to interactively get file name from the user.
        [file, location] = uigetfile({'*.m;*.mlx'});
        if not(isequal(file, 0))
          component.ParameterFileFullPath = fullfile(location, file);
          component.WorkingFolder = location;
        else
          % User cancelled selecting file.

          return

        end  % if
      end  % if

      component.ParameterFileDropDownUI.MainDropDown.Enable = "on";
      component.EditFileButtonUI.MainButton.Enable = "on";

      paramfile_display_path = replace(component.ParameterFileFullPath, ("/"|"\"), " > ");

      if not(ismember(paramfile_display_path, component.ParameterFileDropDownUI.Items))
        component.ParameterFileDropDownUI.Items(end + 1) = paramfile_display_path;
      end  % if

      % This triggers FileDropDownUI's ValueChanged callback.
      component.ParameterFileDropDownUI.Value = component.ParameterFileDropDownUI.Items(end);

      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("FileDropDownUI.Value: " + component.ParameterFileDropDownUI.Value)
      end  % if
    end  % function

    function x = get.ParameterFileFullPath(component)
      %%
      % Parameter file path text in the drop down is a generic path, or a "display" path,
      % i.e., it uses " > " as the folder separator instead of "/" or "\".
      display_path = component.ParameterFileDropDownUI.Value;
      x = replace(display_path, " > ", filesep);
    end  % function

    function set.ParameterFileFullPath(component, ParameterFilePath)
      %%
      % Add the specified parameter file to the drop down if it does not exist in the drop down items, and make it current.

      arguments (Input)
        component
        ParameterFilePath (1,1) string = ""
      end  % arguments

      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation()
      end  % if

      if ParameterFilePath == ""
        component.current_parameterfile_fullpath = "";
        component.ParameterFileDropDownUI.Value = "";

        return

      end  % if

      if not(isfile(ParameterFilePath))
        component.current_parameterfile_fullpath = "";
        id = component.errorID + "InvalidFile";
        msg = bevutil1.CodeUtil.i18n("Invalid parameter file: ") + ParameterFilePath;

        throw(MException(id, msg))

      end  % if

      component.current_parameterfile_fullpath = ParameterFilePath;
      component.WorkingFolder = fileparts(ParameterFilePath);

      display_path = replace(ParameterFilePath, ("/"|"\"), " > ");

      if not(any(display_path == component.ParameterFileDropDownUI.Items))
        component.ParameterFileDropDownUI.Items(end + 1) = display_path;
      end  % if

      % This triggers FileDropDownUI's ValueChangedCallback function, which is callback_change_file_dropdown.
      component.ParameterFileDropDownUI.Value = display_path;

    end  %  function

    function callback_change_file_dropdown(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation()
      end  % if

      selected_parameterfile_dropdown_item = component.ParameterFileDropDownUI.Value;
      if selected_parameterfile_dropdown_item == ""
        component.ParameterFileDropDownUI.MainDropDown.Tooltip = "";
        component.EditFileButtonUI.MainButton.Enable = "off";

        return

      end  % if

      parameterfile_fullpath = replace(selected_parameterfile_dropdown_item, " > ", filesep);
      [component.WorkingFolder, base_file_name, ~] = fileparts(parameterfile_fullpath);

      if isfolder(component.WorkingFolder)
        % Change the folder, evaluate, and return to the original folder.
        % (Following the run command's behavior.)
        previous_folder = pwd;
        cd(component.WorkingFolder)
        evalin("base", base_file_name + ";")
        cd(previous_folder)
      end  % if

      component.ParameterFileDropDownUI.MainDropDown.Enable = "on";
      component.EditFileButtonUI.MainButton.Enable = "on";

    end  % function

    function callback_get_parameters(component)
      %%
      if isempty(component.GetParametersFromBaseWorkspaceCallback)

        return

      end  % if
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation()
      end  % if

      component.GetParametersFromBaseWorkspaceCallback()

    end  % function

    function callback_change_structname_dropdown(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      selected_struct_name = component.StructNameDropDownUI.Value;
      if selected_struct_name == ""
        % Empty drop down item was selected.

        % Use MainDropDown.Value to avoid infinitely triggering the ValueChanged callback.
        component.StructNameDropDownUI.MainDropDown.Value = "";

        component.StructNameDropDownUI.MainDropDown.Tooltip = "";
        component.GetParametersFromBaseWorkspaceUI.MainButton.Enable = "off";
        component.OpenVariablesEditorButtonUI.MainButton.Enable = "off";

        return

      end  % if

      component.GetParametersFromBaseWorkspaceUI.MainButton.Enable = "on";
      component.OpenVariablesEditorButtonUI.MainButton.Enable = "on";

      if component.Reporting
        disp("Checking struct: " + selected_struct_name)
      end  % if
      try
        evalin("base", selected_struct_name + ";");
      catch exception
        id = component.errorID + "InvalidStructName";
        msg = bevutil1.CodeUtil.i18n("Evaluation failed: ") + selected_struct_name + newline + exception.message;

        throw(MException(id, msg))

      end  % try, catch

      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("2")
      end  % if
    end  % function

  end  % methods

  methods (Access=protected)

    function setup(component)
      %%
      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      % The setup method runs with default property values.
      % Name-value pair arguments that were passed to the constructor-like call are
      % processed after this method finished.
      % To access the user-specified property values, use the update method.

      % Create three rows.
      % The first and third rows contain UI components while the second row is a spacer.
      component.base_grid.RowHeight = {component.common_ui_height, 4, component.common_ui_height};

      % Create one column.
      component.base_grid.ColumnWidth = {'1x'};

      % -----------------------------------------------------------------------
      % First row

      component.ParameterFileRow = uigridlayout(component.base_grid, [1 1]);
      component.ParameterFileRow.Layout.Row = 1;
      component.ParameterFileRow.Layout.Column = 1;
      component.ParameterFileRow.RowHeight = component.common_ui_height;
      component.ParameterFileRow.ColumnWidth = {'fit', '1x', 'fit', 'fit'};
      component.ParameterFileRow.Padding = [0 0 0 0];
      component.ParameterFileRow.ColumnSpacing = 0;
      component.ParameterFileRow.RowSpacing = 0;
 
      component.ParameterFileTextUI = bevutil1.AppUtil.Component.Label(component.ParameterFileRow);
      component.ParameterFileTextUI.Layout.Row = 1;
      component.ParameterFileTextUI.Layout.Column = 1;
      component.ParameterFileTextUI.Text = bevutil1.CodeUtil.i18n("Parameter file");
      component.ParameterFileTextUI.ComponentWidth = component.NameUIWidth;

      component.ParameterFileDropDownUI = bevutil1.AppUtil.Component.DropDown(component.ParameterFileRow);
      component.ParameterFileDropDownUI.Layout.Row = 1;
      component.ParameterFileDropDownUI.Layout.Column = 2;
      component.ParameterFileDropDownUI.Items = "";
      component.ParameterFileDropDownUI.Value = "";
      component.ParameterFileDropDownUI.ValueChangedCallback = @() callback_change_file_dropdown(component);
      component.ParameterFileDropDownUI.MainDropDown.Enable = "off";

      component.SelecFileButtonUI = bevutil1.AppUtil.Component.Button(component.ParameterFileRow);
      component.SelecFileButtonUI.Layout.Row = 1;
      component.SelecFileButtonUI.Layout.Column = 3;
      component.SelecFileButtonUI.ComponentWidth = component.ButtonUIWidth;
      component.SelecFileButtonUI.ButtonWidth = component.MainButtonWidth;
      component.SelecFileButtonUI.Text = bevutil1.CodeUtil.i18n("Select file...");
      component.SelecFileButtonUI.ButtonPushedCallback = @() callback_select_and_load_parameter_file(component);
      component.SelecFileButtonUI.MainButton.Tooltip = ...
        bevutil1.CodeUtil.i18n("Select an M file containing parameters in a struct. The file is evaluated when selected.");

      component.EditFileButtonUI = bevutil1.AppUtil.Component.Button(component.ParameterFileRow);
      component.EditFileButtonUI.Layout.Row = 1;
      component.EditFileButtonUI.Layout.Column = 4;
      component.EditFileButtonUI.ComponentWidth = component.ButtonUIWidth;
      component.EditFileButtonUI.ButtonWidth = component.MainButtonWidth;
      component.EditFileButtonUI.Text = bevutil1.CodeUtil.i18n("Edit");
      component.EditFileButtonUI.MainButton.Enable = "off";
      component.EditFileButtonUI.ButtonPushedCallback = @() edit(replace(component.ParameterFileDropDownUI.Value, " > ", filesep));
      component.EditFileButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Edit the selected file.");

      % -----------------------------------------------------------------------
      % Second row - vertical spacing
      % This is specified in the RowHeight property of the base grid.

      % -----------------------------------------------------------------------
      % Third row

      component.StructNameRow = uigridlayout(component.base_grid, [1 1]);
      component.StructNameRow.Layout.Row = 3;
      component.StructNameRow.Layout.Column = 1;
      component.StructNameRow.RowHeight = component.common_ui_height;
      component.StructNameRow.ColumnWidth = {'fit', '1x', 'fit', 'fit', 'fit'};
      component.StructNameRow.Padding = [0 0 0 0];
      component.StructNameRow.ColumnSpacing = 0;
      component.StructNameRow.RowSpacing = 0;

      component.StructNameTextUI = bevutil1.AppUtil.Component.Label(component.StructNameRow);
      component.StructNameTextUI.Layout.Row = 1;
      component.StructNameTextUI.Layout.Column = 1;
      component.StructNameTextUI.ComponentWidth = component.NameUIWidth;
      component.StructNameTextUI.ComponentHeight = component.common_ui_height;
      component.StructNameTextUI.Text = bevutil1.CodeUtil.i18n("Variable name");

      component.StructNameDropDownUI = bevutil1.AppUtil.Component.DropDown(component.StructNameRow);
      component.StructNameDropDownUI.Layout.Row = 1;
      component.StructNameDropDownUI.Layout.Column = 2;
      component.StructNameDropDownUI.ComponentHeight = component.common_ui_height;
      component.StructNameDropDownUI.Items = "";
      component.StructNameDropDownUI.Value = "";
      component.StructNameDropDownUI.Editable = "on";
      component.StructNameDropDownUI.ValueChangedCallback = @() callback_change_structname_dropdown(component);
      component.StructNameDropDownUI.MainDropDown.Tooltip = ...
        bevutil1.CodeUtil.i18n("Specify a struct or a class object in the base workspace." + ...
        " To load a struct or a class object, the struct fields or the class properties must match the app's definitions.");

      component.GetParametersFromBaseWorkspaceUI = bevutil1.AppUtil.Component.Button(component.StructNameRow);
      component.GetParametersFromBaseWorkspaceUI.Layout.Row = 1;
      component.GetParametersFromBaseWorkspaceUI.Layout.Column = 4;
      component.GetParametersFromBaseWorkspaceUI.ComponentWidth = component.ButtonUIWidth;
      component.GetParametersFromBaseWorkspaceUI.ButtonWidth = component.MainButtonWidth;
      component.GetParametersFromBaseWorkspaceUI.Text = bevutil1.CodeUtil.i18n("Get");
      component.GetParametersFromBaseWorkspaceUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "greencircleicon.gif");
      component.GetParametersFromBaseWorkspaceUI.MainButton.Enable = "off";
      component.GetParametersFromBaseWorkspaceUI.ButtonPushedCallback = @() callback_get_parameters(component);
      component.GetParametersFromBaseWorkspaceUI.MainButton.Tooltip = ...
        bevutil1.CodeUtil.i18n("Get parameters from the specified struct in the base workspace and load to the app.");

      component.OpenVariablesEditorButtonUI = bevutil1.AppUtil.Component.Button(component.StructNameRow);
      component.OpenVariablesEditorButtonUI.Layout.Row = 1;
      component.OpenVariablesEditorButtonUI.Layout.Column = 5;
      component.OpenVariablesEditorButtonUI.ComponentWidth = component.ButtonUIWidth;
      component.OpenVariablesEditorButtonUI.ButtonWidth = component.MainButtonWidth;
      component.OpenVariablesEditorButtonUI.Text = bevutil1.CodeUtil.i18n("Open");
      component.OpenVariablesEditorButtonUI.MainButton.Enable = "off";
      component.OpenVariablesEditorButtonUI.ButtonPushedCallback = @() openvar(component.StructNameDropDownUI.Value);
      component.OpenVariablesEditorButtonUI.MainButton.Tooltip = bevutil1.CodeUtil.i18n("Open the Variables Editor.");

    end  % function

    function update(component)
      %%
      update@bevutil1.AppUtil.Component.ComponentBase(component)

      if component.Initialized
        regular_update(component)

        return

      end  % if

      first_update(component)
      component.Initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("regular update")
      end  % if

      if component.ParameterFileDropDownUI.Value ~= ""
        component.ParameterFileDropDownUI.MainDropDown.Tooltip = component.ParameterFileDropDownUI.Value;
      end  % if
    end  % function

    function first_update(component)
      %%
      % This runs only once after the first call to the drawnow,
      % which takes place after the setup method and property assignments finished.
      % Use this function to fix UI settings based on user specified property values,
      % including the deletion of unnecessarily UI components.
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("first update")
      end  % if
    end  % function

  end  % methods
end  % classdef
