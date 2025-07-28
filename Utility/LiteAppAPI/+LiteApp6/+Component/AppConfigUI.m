classdef AppConfigUI < LiteApp6.Component.LiteAppComponentBase
  %% UI component to open, select, and save app config JSON files

  % To reload the already-opened JSON file, select the empty item in the drop down and
  % then select the JSON file in the drop down again.

  % In this class, reading an app config JSON file is done by readstruct.
  % The readstruct function reads a JSON file with the "lenient" mode, which
  % supports Inf, NaN, trailing comma, and comment, in addition to
  % the strict JSON format specification.
  % For more details, see the documentation, especially the ParsingMode option.
  % https://www.mathworks.com/help/releases/R2024b/matlab/ref/readstruct.html

  % Copyright 2025 The MathWorks, Inc.

  properties (Constant, Access=private)

    errorID (1,1) string = "AppConfigUI:"

    defaultConfigFilename (1,1) string = "untitled.json"
  end  % properties

  properties (Dependent)

    ConfigFilePath (1,1) string

  end  % properties

  properties

    % The class name of AppConfigObject property must end with "AppConfig".
    AppConfigObject (:,1)
    % {LiteApp6.Utility.mustBeAppConfigOrEmpty}  % !todo: This validator does not work. Fix it.

    % Called when changing an item in the drop down.
    LoadAppConfigToUIComponentsCallback (:,1) {LiteApp6.Utility.mustBeFunctionHandleOrEmpty}

    % Called before saving app-config to file.
    UpdateAppConfigFromUIComponentsCallback (:,1) {LiteApp6.Utility.mustBeFunctionHandleOrEmpty}

    % 
    ResetUIComponentsCallback (:,1 ) {LiteApp6.Utility.mustBeFunctionHandleOrEmpty}

    MainFigure (:,1) matlab.ui.Figure

    % To see outputs from the setup method, you must modify Reporting to "on" here:
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

    % -------------------------------------------------------------------------
    % GUI parts

    LabelUI LiteApp6.Component.Label
    ConfigFileDropDownUI LiteApp6.Component.DropDown
    OpenConfigButtonUI LiteApp6.Component.Button
    SaveButtonUI LiteApp6.Component.Button
    SaveAsButtonUI LiteApp6.Component.Button

  end  % properties

  properties (Constant, Access=private)
    common_ui_height = LiteApp6.Utility.Constant.Height{"oneline++"}

    unit_ui_width = LiteApp6.Utility.Constant.Width{"unitwidth"}
    button_width = LiteApp6.Utility.Constant.Width{"unitwidth"} * 12
  end  % properties

  properties (Access=private)

    current_configfile_fullpath (1,1) string = ""

    initialized (1,1) logical = false
  end  % properties

  methods

    function x = get.ConfigFilePath(component)
      %%
      % Returns a full-path string to the currently selected config file.

      arguments (Output)
        x (1,1) string
      end  % arguments

      % Folder path text in the drop down is a generic path, or a "display" path,
      % i.e., it uses " > " as the folder separator instead of "/" or "\".
      display_path = component.ConfigFileDropDownUI.Value;

      % Use "/" as folder separator. "/" works in MATLAB regardless of the OS.
      x = replace(display_path, " > ", "/");

    end  % function

    function set.ConfigFilePath(component, ConfigFileFullPath)
      %%
      % Adds the specified file to the drop down if it does not exist in the drop down items, and makes it current.

      arguments (Input)
        component
        ConfigFileFullPath (1,1) string = ""
      end  % arguments

      if ConfigFileFullPath == ""
        resetDropDown(component)

        return

      end  % if

      if not(isfile(ConfigFileFullPath))
        component.current_configfile_fullpath = "";
        id = component.errorID + "InvalidFile";
        msg = LiteApp6.Utility.i18n("Invalid config file: " + ConfigFileFullPath);

        throw(MException(id, msg))

      end  % if

      component.current_configfile_fullpath = ConfigFileFullPath;

      display_path = replace(ConfigFileFullPath, ("/"|"\"), " > ");

      if not(any(display_path == component.ConfigFileDropDownUI.Items))
        component.ConfigFileDropDownUI.Items(end + 1) = display_path;
      end  % if

      % This triggers ConfigFileDropDownUI's ValueChangedCallback function.
      component.ConfigFileDropDownUI.Value = display_path;

      if component.current_configfile_fullpath == ""
        component.SaveButtonUI.MainButton.Enable = "off";
      else
        component.SaveButtonUI.MainButton.Enable = "on";
      end  % if

    end  % function

    function callback_change_appconfig_dropdown(component)
      %%
      % This method makes the AppConfigObject property ready for loading in UI components.
      % After this method, AppConfigObject data can be loaded to UI Components.
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Start")
      end  % if

      selected_configfile_display_path = component.ConfigFileDropDownUI.Value;
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Selected: [" + selected_configfile_display_path + "]")
      end  % if
      if selected_configfile_display_path == ""
        resetDropDown(component)

        return

      end  % if

      component.current_configfile_fullpath = replace(selected_configfile_display_path, " > ", "/");

      try
        % readstruct can issue a parse error.
        new_app_config_struct = readstruct(component.current_configfile_fullpath);
      catch exception
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("caught exception")
        end  % if
        resetDropDown(component)

        % Remove the bad file from the drop down list.
        logical_index = component.ConfigFileDropDownUI.Items ~= selected_configfile_display_path;
        component.ConfigFileDropDownUI.Items = component.ConfigFileDropDownUI.Items(logical_index);

        msg = LiteApp6.Utility.i18n("Reading config file failed." + newline + exception.message);
        title_word = LiteApp6.Utility.i18n("Error");
        uialert(component.MainFigure, msg, title_word)

        return

      end  % try, catch

      component.ConfigFileDropDownUI.MainDropDown.Tooltip = selected_configfile_display_path;
      component.SaveButtonUI.MainButton.Enable = "on";

      if isempty(component.AppConfigObject)
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("AppConfigObject is empty.")
        end  % if

        return

      end  % if

      try
        % Config struct can be invalid as app config.
        % For example, required app config properties may be missing in the config struct fields.
        LiteApp6.Utility.setupAppConfigFromConfigStruct(component.AppConfigObject, new_app_config_struct)
      catch exception
        resetDropDown(component)

        % Remove the bad file from the drop down list.
        logical_index = component.ConfigFileDropDownUI.Items ~= selected_configfile_display_path;
        component.ConfigFileDropDownUI.Items = component.ConfigFileDropDownUI.Items(logical_index);

        msg = LiteApp6.Utility.i18n("App config could not be built." + newline + exception.message);
        title_word = LiteApp6.Utility.i18n("Error");
        uialert(component.MainFigure, msg, title_word)

        return

      end  % try, catch

      if not(isempty(component.LoadAppConfigToUIComponentsCallback))
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("calling LoadAppConfigToUIComponentsCallback")
        end  % if

        component.LoadAppConfigToUIComponentsCallback()
        component.ConfigFileDropDownUI.MainDropDown.Enable = "on";

      end  % if

      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("End")
      end  % if
    end  % function

    function resetDropDown(component)
      %%
      component.current_configfile_fullpath = "";
      component.ConfigFileDropDownUI.MainDropDown.Value = "";
      component.ConfigFileDropDownUI.MainDropDown.Tooltip = "";

      if isscalar(component.ConfigFileDropDownUI.Items)
        component.ConfigFileDropDownUI.MainDropDown.Enable = "off";
        component.SaveButtonUI.MainButton.Enable = "off";
      end  % if

      if not(isempty(component.ResetUIComponentsCallback))
        component.ResetUIComponentsCallback()
      end  % if
    end  % function

    function addConfigFile(component, ConfigFileFullPath)
      %%
      % Add the specified file to the drop down and make it current.

      arguments (Input)
        component
        ConfigFileFullPath (1,1) string = ""
      end  % arguments

      if ConfigFileFullPath == ""
        kwd = component.errorID + "ConfigFileUnspecified";
        msg = LiteApp6.Utility.i18n("Config file must be specified.");

        throw(MException(kwd, msg))

      end  % if

      component.current_configfile_fullpath = ConfigFileFullPath;
      if not(isfile(component.current_configfile_fullpath))
        component.current_configfile_fullpath = "";
        kwd = component.errorID + "InvalidFile";
        msg = LiteApp6.Utility.i18n("Invalid config file: " + ConfigFileFullPath);

        throw(MException(kwd, msg))

      end  % if

      display_path = replace(component.current_configfile_fullpath, ("/"|"\"), " > ");

      if not(ismember(display_path, component.ConfigFileDropDownUI.Items))
        component.ConfigFileDropDownUI.Items(end + 1) = display_path;
      end  % if

      % This triggers ValueChangedCallback function.
      component.ConfigFileDropDownUI.Value = display_path;

      component.SaveButtonUI.MainButton.Enable = "on";

    end  % function

    function callback_open_app_config_file(component)
      %%

      % Open a dialog window to interactively get model file name from the user.
      [file, location] = uigetfile({'*.json'});
      if isequal(file, 0)
        % User cancelled selecting file.

        return

      end  % if

      component.current_configfile_fullpath = fullfile(location, file);

      addConfigFile(component, component.current_configfile_fullpath)

    end  % function

    function callback_save_app_config_file(component)
      %%
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Save")
      end  % if

      % Save button is enabled only when the app config drop down has a valid item,
      % i.e., it is safe to assume that Value of ConfigFileUI is not "".
      configfile_fullpath = replace(component.ConfigFileDropDownUI.Value, " > ", filesep);

      if not(isfile(configfile_fullpath))
        kwd = LiteApp6.Utility.i18n("Error");
        msg = LiteApp6.Utility.i18n("File not found:" + newline + configfile_fullpath);

        uialert(component.MainFigure, msg, kwd)

        return

      end  % if

      saveAppConfigToFile(component, configfile_fullpath)

    end  % function

    function callback_save_app_config_file_as(component)
      %%
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Start")
      end  % if

      filename = LiteApp6.Utility.getUnusedFilename(component.defaultConfigFilename);
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Unused file name: " + filename)
      end  % if

      [file, location] = uiputfile(filename);
      if isequal(file,0) || isequal(location,0)
         % User clicked Cancel.

         return

      end  % if

      selectedfile_fullpath = fullfile(location, file);
      saveAppConfigToFile(component, selectedfile_fullpath)

      % Add the newly saved file to the drop down and make it current.
      addConfigFile(component, selectedfile_fullpath)

      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("End")
      end  % if
    end  % function

    function saveAppConfigToFile(component, filenameFullpath)
      %%
      arguments (Input)
        component
        filenameFullpath (1,1) string
      end  % arguments

      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Start")
      end  % if

      if isempty(component.AppConfigObject)
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("AppConfigObject is empty. Not saving.")
        end  % if

        return

      end  % if

      % Update AppConfigObject using the current UI component values before generating JSON text.
      if not(isempty(component.UpdateAppConfigFromUIComponentsCallback))
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("calling UpdateAppConfigFromUIComponentsCallback")
        end  % if

        component.UpdateAppConfigFromUIComponentsCallback()

      end  % if

      json_text = LiteApp6.Utility.buildJSONTextFromAppConfig(component.AppConfigObject);

      try
        if component.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("Writing to file.")
        end  % if

        writelines(json_text, filenameFullpath)

      catch exception
        title_word = LiteApp6.Utility.i18n("Error");
        msg = LiteApp6.Utility.i18n("Failed to save:") + newline + exception.message;

        uialert(component.MainFigure, msg, title_word)

      end  % try, catch

      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("End")
      end  % if
    end  % function

  end  % methods

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp6.Component.LiteAppComponentBase(component)

      if component.Reporting
        % This if-branch runs only when the default value of Reporting is "on".
        % Changing the value of Reporting via constructor name-value pair argument
        % or individual assignment takes effect after the setup method ends.
        LiteApp6.Utility.displayTimeAndFileLocation("Setup")
      end  % if

      label_width = component.unit_ui_width * 9;

      % Create one row.
      component.baseGridObject.RowHeight = {component.common_ui_height};

      % Create five columns.
      % The setting of each element is overridden in the update method.
      component.baseGridObject.ColumnWidth = {'fit', '1x', 'fit', 'fit', 'fit'};

      % -----------------------------------------------------------------------
 
      component.LabelUI = LiteApp6.Component.Label(component.baseGridObject);
      component.LabelUI.Layout.Row = 1;
      component.LabelUI.Layout.Column = 1;
      component.LabelUI.ComponentWidth = label_width;
      component.LabelUI.ComponentHeight = component.common_ui_height;
      component.LabelUI.Text = LiteApp6.Utility.i18n("App config");

      component.ConfigFileDropDownUI = LiteApp6.Component.DropDown(component.baseGridObject);
      component.ConfigFileDropDownUI.Layout.Row = 1;
      component.ConfigFileDropDownUI.Layout.Column = 2;
      component.ConfigFileDropDownUI.ComponentHeight = component.common_ui_height;
      component.ConfigFileDropDownUI.Items = "";
      component.ConfigFileDropDownUI.Value = "";
      component.ConfigFileDropDownUI.ValueChangedCallback = @() callback_change_appconfig_dropdown(component);
      component.ConfigFileDropDownUI.MainDropDown.Enable = "off";

      component.OpenConfigButtonUI = LiteApp6.Component.Button(component.baseGridObject);
      component.OpenConfigButtonUI.Layout.Row = 1;
      component.OpenConfigButtonUI.Layout.Column = 3;
      component.OpenConfigButtonUI.ComponentHeight = component.common_ui_height;
      component.OpenConfigButtonUI.ComponentWidth = component.button_width;
      component.OpenConfigButtonUI.ButtonWidth = component.button_width - 8;
      component.OpenConfigButtonUI.Text = LiteApp6.Utility.i18n("Open config");
      component.OpenConfigButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "file_open.png");
      component.OpenConfigButtonUI.MainButton.Tooltip = LiteApp6.Utility.i18n("Open and load app configuration.");
      component.OpenConfigButtonUI.ButtonPushedCallback = @() callback_open_app_config_file(component);

      component.SaveButtonUI = LiteApp6.Component.Button(component.baseGridObject);
      component.SaveButtonUI.Layout.Row = 1;
      component.SaveButtonUI.Layout.Column = 4;
      component.SaveButtonUI.ComponentHeight = component.common_ui_height;
      component.SaveButtonUI.ComponentWidth = component.button_width;
      component.SaveButtonUI.ButtonWidth = component.button_width - 8;
      component.SaveButtonUI.Text = LiteApp6.Utility.i18n("Save");
      component.SaveButtonUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "file_save.png");
      component.SaveButtonUI.MainButton.Tooltip = LiteApp6.Utility.i18n("Save app configuration to current config file.");
      component.SaveButtonUI.MainButton.Enable = "off";
      component.SaveButtonUI.ButtonPushedCallback = @() callback_save_app_config_file(component);

      component.SaveAsButtonUI = LiteApp6.Component.Button(component.baseGridObject);
      component.SaveAsButtonUI.Layout.Row = 1;
      component.SaveAsButtonUI.Layout.Column = 5;
      component.SaveAsButtonUI.ComponentHeight = component.common_ui_height;
      component.SaveAsButtonUI.ComponentWidth = component.button_width;
      component.SaveAsButtonUI.ButtonWidth = component.button_width - 8;
      component.SaveAsButtonUI.Text = LiteApp6.Utility.i18n("Save As...");
      component.SaveAsButtonUI.MainButton.Tooltip = LiteApp6.Utility.i18n("Select file to save app configuration.");
      component.SaveAsButtonUI.ButtonPushedCallback = @() callback_save_app_config_file_as(component);

    end  % function

    function update(component)
      %%
      update@LiteApp6.Component.LiteAppComponentBase(component)

      if component.initialized
        regular_update(component)

        return

      end  % if

      first_update(component)
      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("regular update")
      end  % if

      if component.ConfigFileDropDownUI.Value ~= ""
        component.ConfigFileDropDownUI.MainDropDown.Tooltip = component.ConfigFileDropDownUI.Value;
      end  % if
    end  % function

    function first_update(component)
      %%
      % This runs only once after the first call to the drawnow,
      % which takes place after the setup method and property assignments finished.
      % Use this function to fix UI settings based on user specified property values,
      % including the deletion of unecessary UI components.
      if component.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("first update")
      end  % if
    end  % function

  end  % methods

end  % classdef
