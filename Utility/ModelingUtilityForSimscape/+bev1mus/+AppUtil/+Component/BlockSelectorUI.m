classdef BlockSelectorUI < bev1mus.AppUtil.Component.ComponentBase
  % UI component for opening model and selecting block

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Constant, Access=private)
    errorID (1,1) string = "BlockSelectorUI:"
  end  % properties
  properties

    % -------------------------------------------------------------------------
    % Essential properties
    % To use this component, these properties must be specified.

    % MainFigure is required to be specified. It is defined in the base class.

    % Use TargetSimscapeBlockNames to specify target Simscape blocks to add
    % to the block path drop down list.
    % TargetSimscapeBlockNames are the text of the MaskType block parameter
    % defined in Simscape blocks and Simscape Component blocks.
    % You can see the MaskType value by running get_param(gcb, "MaskType")
    % for a Simscape block.
    %
    % To add a Simscape block with specific block parameter values, or
    % to add Simulink blocks, use FindBlockCallback.
    %
    % If get_param(gcb, "MaskType") returns text containing a newline,
    % TargetSimscapeBlockNames needs the newline too.
    TargetSimscapeBlockNames (1,:) string = ""

    % Use FindBlockCallback to add blocks to the block path drop down list using
    % a function as a callback.
    %
    % In this component, FindBlockCallback is used as follows.
    %
    %   result = component.FindBlockCallback(component.ModelName);
    % 
    % FindBlockCallback function takes a model name, find intended block paths in the model,
    % and return the block paths as string in a column vector.
    %
    % bev1mus.AppUtil.Utility.find1DLookupTableBlocks function can be used for FindBlockCallback.
    % It adds Simulink 1-D Lookup Table blocks in the Block Path drop down.
    FindBlockCallback {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty}

    % In the SetParametersToBlockCallback function,
    % you can use BlockSelector's BlockPath property to access the block.
    % For example, if Param1UI is a UI component having Value property,
    % and if you want to set Param1UI.Value to the "param1" in the block,
    % use set_param as follows.
    %   set_param(selectorObj.BlockPath, "param1", Param1UI.Value);
    SetParametersToBlockCallback (:,1) {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty}

    GetParametersFromBlockCallback (:,1) {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty}

    % -------------------------------------------------------------------------
    % Optional properties

    % Set AutoGet to true to automatically trigger the Get callback when the "Block path" drop down item is changed.
    AutoGet (1,1) logical = false

    % Show the "Get" button and hide the "Set" button. (The Set button component is deleted from the object.)
    GetOnly (1,1) logical = false

    % Show the "Set" button and hide the "Get" button. (The Get button component is deleted from the object.)
    SetOnly (1,1) logical = false

    ModelName (1,1) string = ""

    HighlightedBlock (1,1) string = ""

    NameUIWidth (1,1) {mustBeInteger, mustBePositive} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 14

    ButtonUIWidth (1,1) {mustBeInteger, mustBePositive} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12
    MainButtonWidth (1,1) {mustBeInteger, mustBePositive} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 11

    % To see outputs from the setup method, you must modify Reporting to "on" here:
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

    % -------------------------------------------------------------------------
    % GUI parts

    % For the "Model file"
    ModelRow matlab.ui.container.GridLayout
    ModelFileTextUI bev1mus.AppUtil.Component.Label
    ModelFileDropDownUI bev1mus.AppUtil.Component.DropDown
    OpenModelUI bev1mus.AppUtil.Component.Button

    % For the "Block path"
    BlockRow matlab.ui.container.GridLayout
    BlockPathTextUI bev1mus.AppUtil.Component.Label
    BlockPathDropDownUI bev1mus.AppUtil.Component.DropDown
    HilitBlockUI bev1mus.AppUtil.Component.StateButton
    GetParametersFromBlockUI bev1mus.AppUtil.Component.Button
    SetParametersToBlockUI bev1mus.AppUtil.Component.Button

  end  % properties
  properties (Dependent)

    % Assign a full path to a model file to this property, and it adds
    % the specified model file to the "Model file" drop down and selects it.
    % If the specified model file already exists in the drop down items,
    % the existing item is selected.
    %
    % The target block is also selected. If the model has more than two blocks
    % that match TargetSimscapeBlockNames, the first match is selected.
    ModelFileFullPath (1,1) string

    % Assign a block path to this property, and it selects the Block path drop down.
    % The block path must exist in the drop down items.
    BlockPath (1,1) string

  end  % properties
  properties

    WorkingFolder (1,1) string

    % Callbacks may not work until components are initialized.
    Initialized (1,1) logical = false

  end  % properties
  properties (Constant, Access=private)

    common_ui_height = bev1mus.AppUtil.Constant.Height{"oneline++"}

    % unit_ui_width = bev1mus.AppUtil.Constant.Width{"unitwidth"}
    % button_width = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 12

  end  % properties
  properties (Access=private)

    current_modelfile_fullpath (1,1) string = ""

  end  % properties

  methods

    function x = get.ModelFileFullPath(component)
      % Model file path text in the drop down is a generic path, or a "display" path,
      % i.e., it uses " > " as the folder separator instead of "/" or "\".
      display_path = component.ModelFileDropDownUI.Value;
      x = replace(display_path, " > ", filesep);
    end  % function

    function set.ModelFileFullPath(component, ModelFilePath)
      %%
      % Add the specified model file to the drop down if it does not exist in the drop down items, and make it current.

      arguments (Input)
        component
        ModelFilePath (1,1) string = ""
      end  % arguments

      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation()
      end  % if

      if ModelFilePath == ""
        component.current_modelfile_fullpath = "";
        component.ModelFileDropDownUI.Value = "";

        return

      end  % if

      if not(isfile(ModelFilePath))
        component.current_modelfile_fullpath = "";
        id = component.errorID + "InvalidFile";
        msg = bev1mus.CodeUtil.i18n("Invalid model file: ") + ModelFilePath;

        throw(MException(id, msg))

      end  % if

      component.current_modelfile_fullpath = ModelFilePath;
      component.WorkingFolder = fileparts(ModelFilePath);

      display_path = replace(ModelFilePath, ("/"|"\"), " > ");

      if not(any(display_path == component.ModelFileDropDownUI.Items))
        component.ModelFileDropDownUI.Items(end + 1) = display_path;
      end  % if

      % This triggers ModelFileDropDownUI's ValueChangedCallback function, which is callback_change_modelfile_dropdown.
      component.ModelFileDropDownUI.Value = display_path;

    end  %  function

    function x= get.BlockPath(component)
      %%
      x = replace(component.BlockPathDropDownUI.Value, " / ", "/");
    end  % function

    function set.BlockPath(component, block_path)
      %%
      % Assignment like the following triggers this method.
      %   app_object.selector_object.BlockPath = "mysystem1/tagetblock"
      %
      % The above code sets the Block path drop down of the selector UI to the specified one.
      % The specified block path must already exist in the drop down items.

      styled_block_path = replace(block_path, "/", " / ");

      if not(any(component.BlockPathDropDownUI.Items == styled_block_path))
        title_word = bev1mus.CodeUtil.i18n("Error");
        msg = bev1mus.CodeUtil.i18n("Specified block path is not in the block path drop down items: ") + block_path;

        if component.MainFigure.Visible
          uialert(component.MainFigure, msg, title_word)

          return

        else
          id = component.errorID + "InvalidBlockPath";

          throw(MException(id, msg))

        end  % if
      end  % if

      component.BlockPathDropDownUI.Value = styled_block_path;

      [system_path, block_name, ~] = fileparts(block_path);
      % Select the (sub)system containing the target block.
      set_param(0, "CurrentSystem", system_path)
      % Select the target block.
      set_param(gcs, "CurrentBlock", block_name)
    end  % function

    function openSystemWithBlockHighlight(component)
      %%
      % Assuming that the model is loaded and the block is selected,
      % this function opens the model and highlights the target block.
      component.HilitBlockUI.Value = true;
      callback_hilit(component)
    end  % function

    function callback_change_modelfile_dropdown(component)
      %%
      selected_modelfile_dropdown_item = component.ModelFileDropDownUI.Value;
      if selected_modelfile_dropdown_item == ""
        component.ModelFileDropDownUI.MainDropDown.Tooltip = "";
        component.ModelName = "";
        component.BlockPathDropDownUI.MainDropDown.Enable = "off";
        component.BlockPathDropDownUI.Items = "";
        component.BlockPathDropDownUI.Value = "";
        component.BlockPathDropDownUI.MainDropDown.Tooltip = "";
        component.HilitBlockUI.MainButton.Enable = "off";
        component.GetParametersFromBlockUI.MainButton.Enable = "off";
        component.SetParametersToBlockUI.MainButton.Enable = "off";

        return

      end  % if

      modelfile_fullpath = replace(selected_modelfile_dropdown_item, " > ", filesep);
      [component.WorkingFolder, component.ModelName, ~] = fileparts(modelfile_fullpath);
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation(pwd)
      end  % if

      if component.TargetSimscapeBlockNames == ""
        block_paths = [];
      else
        % Find Simscape blocks in the selected model.
        try
          result_table = bev1mus.ModelUtil.findAllSimscapeBlocks(component.ModelName);
        catch exception
          if component.MainFigure.Visible
            msg = exception.message;
            title_word = bev1mus.CodeUtil.i18n("Error");
            uialert(component.MainFigure, msg, title_word)

            return

          else

            rethrow(exception)

          end  % if
        end  % try, catch

        if isempty(result_table)
          block_paths = [];
        else
          logical_index = false;
          for idx = 1 : numel(component.TargetSimscapeBlockNames)
            logical_index = logical_index | result_table.MaskType==component.TargetSimscapeBlockNames(idx);
          end  % for
          block_paths = [result_table{logical_index, "BlockPath"}];
        end  % if
      end  % if

      if not(isempty(component.FindBlockCallback)) && isa(component.FindBlockCallback, 'function_handle')
        % Find blocks using FindBlockCallback.
        block_paths_from_callback = component.FindBlockCallback(component.ModelName);
        if not(iscolumn(block_paths_from_callback) && class(block_paths_from_callback) == "string")
          msg = bev1mus.CodeUtil.i18n("FindBlockCallback must return a scalar or a column vector containing block paths as string.");
          if component.MainFigure.Visible
            title_word = bev1mus.CodeUtil.i18n("Error");
            uialert(component.MainFigure, msg, title_word)

            return

          else
            id = component.errorID + "InvalidReturnValue";

            throw(MException(id, msg))

          end  % if
        end  % if
        block_paths = [block_paths; block_paths_from_callback];
      end  % if

      block_paths = unique(block_paths);

      num_blocks = numel(block_paths);
      if num_blocks == 0
        msg = bev1mus.CodeUtil.i18n("Block was not found: ") + component.TargetSimscapeBlockNames;
        if component.MainFigure.Visible
          title_word = bev1mus.CodeUtil.i18n("Error");
          uialert(component.MainFigure, msg, title_word)

          return

        else
          id = component.errorID + "BlockNotFound";

          throw(MException(id, msg))

        end  % if
      end  % if

      component.ModelFileDropDownUI.MainDropDown.Enable = "on";
      component.BlockPathDropDownUI.MainDropDown.Enable = "on";

      % Fill the Block path drop-down list.
      styled_block_paths = replace(block_paths, "/", " / ");
      component.BlockPathDropDownUI.Items = [""; styled_block_paths];
      % Select the first block.
      component.BlockPathDropDownUI.Value = component.BlockPathDropDownUI.Items(2);

      if not(bdIsLoaded(component.ModelName))
        load_system(component.ModelName)
      end  % if

      component.HilitBlockUI.MainButton.Enable = "on";
      component.GetParametersFromBlockUI.MainButton.Enable = "on";
      component.SetParametersToBlockUI.MainButton.Enable = "on";
    end  % function

    function callback_get_parameters(component)
      %%
      if isempty(component.GetParametersFromBlockCallback)

        return

      else
        subcallback_make_block_path_ready(component)
        component.GetParametersFromBlockCallback()
      end  % if
    end  % function

    function callback_set_parameters(component)
      %%
      if isempty(component.SetParametersToBlockCallback)

        return

      else
        subcallback_make_block_path_ready(component)
        component.SetParametersToBlockCallback()
      end  % if
    end  % function

    function subcallback_make_block_path_ready(component)
      %%
      % This subcallback function selects the target block in the model in the specified block path
      % and sets BlockPath to the target block.

      if component.BlockPathDropDownUI.Value == ""

        msg = bev1mus.CodeUtil.i18n("BlockPath must be specified.");

        if not(component.MainFigure.Visible)
          % App window is not visible yet. Report error in Command Window.
          id = component.errorID + "InvalidBlockPath:";

          throw(MException(id, msg))

        else
          % App window is visible. Use dialog window to report error.
          title_word = bev1mus.CodeUtil.i18n("Error");
          uialert(component.MainFigure, msg, title_word)

          return

        end  % if
      end  % if

      block_path = replace(component.BlockPathDropDownUI.Value, " / ", "/");

      % The top level system or a subsystem block may be currently being selected.
      % Make sure the target block is selected.
      [system_path, block_name, ~] = fileparts(block_path);
      if contains(system_path, "/")
        model_name = extractBefore(system_path, "/");
      else
        model_name = system_path;
      end  % if
      if not(bdIsLoaded(model_name))
        load_system(model_name)
      end  % if
      set_param(0, "CurrentSystem", system_path)
      set_param(gcs, "CurrentBlock", block_name)  % Select the target block in the model.

    end  % function

    function callback_open_model(component, NameValuePair)
      %%
      % This method does not load the model. Instead, the model is loaded in
      % a callback for the model file drop down.

      arguments (Input)
        component
        NameValuePair.ModelFileFullPath (1,1) string = ""
      end  % arguments

      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation()
      end  % if

      if NameValuePair.ModelFileFullPath ~= ""
        % ModelFileFullPath option was specified.
        component.ModelFileFullPath = NameValuePair.ModelFileFullPath;
        component.WorkingFolder = fileparts(component.ModelFileFullPath);
        if not(isfile(component.ModelFileFullPath))
          kwd = component.errorID + "InvalidFile";
          msg = bev1mus.CodeUtil.i18n("Invalid file was specified: ") + NameValuePair.ModelFileFullPath;

          throw(MException(kwd, msg))

        end  % if

      else
        % Open a dialog window to interactively get model file name from the user.
        [file, location] = uigetfile({'*.mdl;*.slx'});
        if not(isequal(file, 0))
          component.ModelFileFullPath = fullfile(location, file);
          component.WorkingFolder = location;
        else
          % User cancelled selecting file.

          return

        end  % if
      end  % if

      component.ModelFileDropDownUI.MainDropDown.Enable = "on";

      modelfile_display_path = replace(component.ModelFileFullPath, ("/"|"\"), " > ");

      if not(ismember(modelfile_display_path, component.ModelFileDropDownUI.Items))
        component.ModelFileDropDownUI.Items(end + 1) = modelfile_display_path;
      end  % if

      % This triggers ModelFileDropDownUI's ValueChanged callback.
      component.ModelFileDropDownUI.Value = component.ModelFileDropDownUI.Items(end);

      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("ModelFileDropDownUI.Value: " + component.ModelFileDropDownUI.Value)
      end  % if
    end  % function

    function callback_change_blockpath_dropdown(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("Start")
      end  % if

      if component.ModelFileDropDownUI.Value == ""
        if component.Reporting
          bev1mus.FileUtil.displayTimeAndFileLocation("Selected empty model file.")
        end  % if

        return

      end  % if

      selected_block_display_path = component.BlockPathDropDownUI.Value;
      if selected_block_display_path == ""
        % Empty drop down item was selected.

        % Use MainDropDown.Value to avoid infinitely triggering the ValueChanged callback.
        component.BlockPathDropDownUI.MainDropDown.Value = "";

        component.BlockPathDropDownUI.MainDropDown.Tooltip = "";
        component.HilitBlockUI.MainButton.Enable = "off";
        component.GetParametersFromBlockUI.MainButton.Enable = "off";
        component.SetParametersToBlockUI.MainButton.Enable = "off";

        if component.HighlightedBlock ~= ""
          % Remove block highlight.
          hilite_system(component.HighlightedBlock, "none")
          component.HighlightedBlock = "";
        end  % if

        return

      end  % if

      component.HilitBlockUI.MainButton.Enable = "on";
      component.GetParametersFromBlockUI.MainButton.Enable = "on";
      component.SetParametersToBlockUI.MainButton.Enable = "on";

      block_path = component.BlockPath;
      model_name = extractBefore(block_path, "/");
      load_system(model_name)

      % The target block may not exist if the user removed the block from the model.
      if getSimulinkBlockHandle(block_path) <= 0
        msg = bev1mus.CodeUtil.i18n("Block was not found: " + block_path);
        title_word = bev1mus.CodeUtil.i18n("Error");
        uialert(component.MainFigure, msg, title_word)

        % This assignment triggers this callback again with component.BlockPathUI.Value=="" which
        % resets the block path drop down and exits. (Thus, there is no infinite recursive call.)
        component.BlockPathDropDownUI.Value = "";

        return

      end  % if

      if component.HilitBlockUI.Value
        if component.HighlightedBlock ~= ""
          % If highlight is on for a block, turn it off.
          hilite_system(component.HighlightedBlock, "none")
        end  % if
        callback_hilit(component)
      end  % if

      if component.AutoGet
        callback_get_parameters(component)
      end  % if

      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("End")
      end  % if
    end  % function

    function callback_hilit(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("Start")
      end  % if

      if component.ModelFileDropDownUI.Value == ""
        id = component.errorID + "InvalidModelFile";
        msg = bev1mus.CodeUtil.i18n("To highlight a block, model file must be non-empty.");

        throw(MException(id, msg))

      end  % if

      selected_block_display_path = component.BlockPathDropDownUI.Value;
      if selected_block_display_path == ""
        id = component.errorID + "InvalidBlockPath";
        msg = bev1mus.CodeUtil.i18n("To highlight a block, block path must be non-empty.");

        throw(MException(id, msg))

      end  % if

      block_path = replace(selected_block_display_path, " / ", "/");

      if component.HilitBlockUI.Value
        % Make the target system/subsystem visible with open_system, then
        % highlight the target block in that system with hilit_system.

        if component.Reporting
          bev1mus.FileUtil.displayTimeAndFileLocation("Hilit")
        end  % if

        % Calling open_system for the containing system rather than the target block
        % prevents the Block Parameters window from opening.
        open_system(block_path)

        if getSimulinkBlockHandle(block_path) <= 0
          id = component.errorID + "InvalidBlockHandle";
          msg = bev1mus.CodeUtil.i18n("Specified block is invalid: " + block_path);

          throw(MException(id, msg))

        end  % if

        hilite_system(block_path)

        % To keep the Get and Set buttons working,
        % set the selected block to gcb by calling load_system for the block.
        block_name = extractAfter(block_path, asManyOfPattern(wildcardPattern + "/"));
        set_param(gcs, "CurrentBlock", block_name)

        component.HighlightedBlock = block_path;

      else
        model_name = extractBefore(block_path, "/");
        if bdIsLoaded(model_name)
          % Model may be closed. Remove the highlight only when the model is open.
          hilite_system(block_path, "none")
        end  % if
        component.HighlightedBlock = "";
      end  % if

      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("End")
      end  % if
    end  % function

  end  % methods

  methods (Access=protected)

    function setup(component)
      %%
      setup@bev1mus.AppUtil.Component.ComponentBase(component)

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

      component.ModelRow = uigridlayout(component.base_grid, [1 1]);
      component.ModelRow.Layout.Row = 1;
      component.ModelRow.Layout.Column = 1;
      component.ModelRow.RowHeight = component.common_ui_height;
      component.ModelRow.ColumnWidth = {'fit', '1x', 'fit'};
      component.ModelRow.Padding = [0 0 0 0];
      component.ModelRow.ColumnSpacing = 0;
      component.ModelRow.RowSpacing = 0;
 
      component.ModelFileTextUI = bev1mus.AppUtil.Component.Label(component.ModelRow);
      component.ModelFileTextUI.Layout.Row = 1;
      component.ModelFileTextUI.Layout.Column = 1;
      component.ModelFileTextUI.Text = bev1mus.CodeUtil.i18n("Model file");
      component.ModelFileTextUI.ComponentWidth = component.NameUIWidth;

      component.ModelFileDropDownUI = bev1mus.AppUtil.Component.DropDown(component.ModelRow);
      component.ModelFileDropDownUI.Layout.Row = 1;
      component.ModelFileDropDownUI.Layout.Column = 2;
      component.ModelFileDropDownUI.Items = "";
      component.ModelFileDropDownUI.Value = "";
      component.ModelFileDropDownUI.ValueChangedCallback = @() callback_change_modelfile_dropdown(component);
      component.ModelFileDropDownUI.MainDropDown.Enable = "off";

      component.OpenModelUI = bev1mus.AppUtil.Component.Button(component.ModelRow);
      component.OpenModelUI.Layout.Row = 1;
      component.OpenModelUI.Layout.Column = 3;
      component.OpenModelUI.ComponentWidth = component.ButtonUIWidth;
      component.OpenModelUI.ButtonWidth = component.MainButtonWidth;
      component.OpenModelUI.Text = bev1mus.CodeUtil.i18n("Open model...");
      component.OpenModelUI.ButtonPushedCallback = @() callback_open_model(component);

      % -----------------------------------------------------------------------
      % Second row - vertical spacing
      % This is specified in the RowHeight property of the base grid.

      % -----------------------------------------------------------------------
      % Third row

      component.BlockRow = uigridlayout(component.base_grid, [1 1]);
      component.BlockRow.Layout.Row = 3;
      component.BlockRow.Layout.Column = 1;
      component.BlockRow.RowHeight = component.common_ui_height;
      component.BlockRow.ColumnWidth = {'fit', '1x', 'fit', 'fit', 'fit'};
      component.BlockRow.Padding = [0 0 0 0];
      component.BlockRow.ColumnSpacing = 0;
      component.BlockRow.RowSpacing = 0;

      component.BlockPathTextUI = bev1mus.AppUtil.Component.Label(component.BlockRow);
      component.BlockPathTextUI.Layout.Row = 1;
      component.BlockPathTextUI.Layout.Column = 1;
      component.BlockPathTextUI.ComponentWidth = component.NameUIWidth;
      component.BlockPathTextUI.ComponentHeight = component.common_ui_height;
      component.BlockPathTextUI.Text = bev1mus.CodeUtil.i18n("Block path");

      component.BlockPathDropDownUI = bev1mus.AppUtil.Component.DropDown(component.BlockRow);
      component.BlockPathDropDownUI.Layout.Row = 1;
      component.BlockPathDropDownUI.Layout.Column = 2;
      component.BlockPathDropDownUI.ComponentHeight = component.common_ui_height;
      component.BlockPathDropDownUI.Items = "";
      component.BlockPathDropDownUI.Value = "";
      component.BlockPathDropDownUI.ValueChangedCallback = @() callback_change_blockpath_dropdown(component);
      component.BlockPathDropDownUI.MainDropDown.Enable = "off";

      component.HilitBlockUI = bev1mus.AppUtil.Component.StateButton(component.BlockRow);
      component.HilitBlockUI.Layout.Row = 1;
      component.HilitBlockUI.Layout.Column = 3;
      component.HilitBlockUI.ComponentWidth = component.ButtonUIWidth;
      component.HilitBlockUI.ButtonWidth = component.MainButtonWidth;
      component.HilitBlockUI.Text = bev1mus.CodeUtil.i18n("Highlight");
      component.HilitBlockUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "demoicon.gif");
      component.HilitBlockUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Open the model, and highlight or dehighlight the selected block.");
      component.HilitBlockUI.MainButton.Enable = "off";
      component.HilitBlockUI.ValueChangedCallback = @() callback_hilit(component);

      component.GetParametersFromBlockUI = bev1mus.AppUtil.Component.Button(component.BlockRow);
      component.GetParametersFromBlockUI.Layout.Row = 1;
      component.GetParametersFromBlockUI.Layout.Column = 4;
      component.GetParametersFromBlockUI.ComponentWidth = component.ButtonUIWidth;
      component.GetParametersFromBlockUI.ButtonWidth = component.MainButtonWidth;
      component.GetParametersFromBlockUI.Text = bev1mus.CodeUtil.i18n("Get");
      component.GetParametersFromBlockUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "greencircleicon.gif");
      component.GetParametersFromBlockUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Get parameters from the selected block.");
      component.GetParametersFromBlockUI.MainButton.Enable = "off";
      component.GetParametersFromBlockUI.ButtonPushedCallback = @() callback_get_parameters(component);

      component.SetParametersToBlockUI = bev1mus.AppUtil.Component.Button(component.BlockRow);
      component.SetParametersToBlockUI.Layout.Row = 1;
      component.SetParametersToBlockUI.Layout.Column = 5;
      component.SetParametersToBlockUI.ComponentWidth = component.ButtonUIWidth;
      component.SetParametersToBlockUI.ButtonWidth = component.MainButtonWidth;
      component.SetParametersToBlockUI.Text = bev1mus.CodeUtil.i18n("Set");
      component.SetParametersToBlockUI.MainButton.Icon = fullfile(matlabroot, "toolbox", "matlab", "icons", "greenarrowicon.gif");
      component.SetParametersToBlockUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Set parameters to the selected block.");
      component.SetParametersToBlockUI.MainButton.Enable = "off";
      component.SetParametersToBlockUI.ButtonPushedCallback = @() callback_set_parameters(component);

    end  % function

    function update(component)
      %%
      update@bev1mus.AppUtil.Component.ComponentBase(component)

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
        bev1mus.FileUtil.displayTimeAndFileLocation("regular update")
      end  % if

      if component.ModelFileDropDownUI.Value ~= ""
        component.ModelFileDropDownUI.MainDropDown.Tooltip = component.ModelFileDropDownUI.Value;
      end  % if

      if component.BlockPathDropDownUI.Value ~= ""
        component.BlockPathDropDownUI.MainDropDown.Tooltip = component.BlockPathDropDownUI.Value;
      end  % if

      if component.AutoGet
        component.GetParametersFromBlockUI.MainButton.Enable = "off";
        component.GetParametersFromBlockUI.MainButton.Tooltip = bev1mus.CodeUtil.i18n("Auto-get is enabled.");
      end  % if
    end  % function

    function first_update(component)
      %%
      % This runs only once after the first call to the drawnow,
      % which takes place after the setup method and property assignments finished.
      % Use this function to fix UI settings based on user specified property values,
      % including the deletion of unnecessarily UI components.
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("first update")
      end  % if

      if component.GetOnly && component.SetOnly
        id = component.errorID + "InvalidButtonSetting";
        msg = bev1mus.CodeUtil.i18n("GetOnly and SetOnly options cannot be true at the same time.");

        throw(MException(id, msg))

      end  % if

      if component.GetOnly
        % Hide the "Set" button.
        component.BlockRow.ColumnWidth{5} = 0;
      end  % if
      if component.SetOnly
        % Hide the "Get" button.
        component.BlockRow.ColumnWidth{4} = 0;
      end  % if
    end  % function

  end  % methods
end  % classdef
