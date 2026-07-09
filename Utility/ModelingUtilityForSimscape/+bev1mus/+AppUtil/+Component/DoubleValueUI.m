classdef DoubleValueUI < bev1mus.AppUtil.Component.ComponentBase
  % UI component for a value of type double with name, value, info, and side note.
  %
  % This component supports using a variable in the base workspace.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties
    errorID (1,1) string = "DoubleValueUI:"

    double_value (1,:) bev1mus.CodeUtil.DoubleValue

    NameText (1,1) string = "Double value"
    NameInInfo (1,1) string = ""
  end  % properties
  properties (Dependent)
    ValueText (1,1) string = ""
  end  % properties
  properties
    ReadOnlyValueText (1,1) logical = false
  end  % properties
  properties (Dependent)
    InfoText (1,1) string

    hasError (1,1) logical
  end  % properties
  properties
    SideNote (1,1) string
  end  % properties
  properties (Dependent)
    MainDoubleValue (1,:) double
  end  % properties
  properties
    ComponentHeight (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Height{"oneline++"}

    NameUIWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 14
    AlertUIWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = 30
    ValueUIWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = "1x"
    InfoUIWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 10
    SideNoteUIWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = 1

    NameUI bev1mus.AppUtil.Component.Label
    AlertUI bev1mus.AppUtil.Graphics.Image
    ValueTextUI bev1mus.AppUtil.Component.EditField
    InfoUI bev1mus.AppUtil.Component.EditField
    SideNoteUI bev1mus.AppUtil.Component.Label

    ValueChangedCallback {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty} = []
  end  % properties
  properties

    main_h_container bev1mus.AppUtil.HorizontalContainer

    name_layout matlab.ui.container.GridLayout
    alert_layout matlab.ui.container.GridLayout
    value_layout matlab.ui.container.GridLayout
    info_layout matlab.ui.container.GridLayout
    sidenote_layout matlab.ui.container.GridLayout

    initialized (1,1) logical = false

    % The Reporting property is for testing purpose only.
    %
    % To see outputs from the class constructor, set Reporting to "on" here.
    % Setting Reporting to "on" in other ways does not enable reporting in the constructor.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)
    % DoubleValueChanged event adds DoubleValueChangedFcn property to this class.
    DoubleValueChanged
  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      setup@bev1mus.AppUtil.Component.ComponentBase(component)

      component.double_value = bev1mus.CodeUtil.DoubleValue;

      component.main_h_container = bev1mus.AppUtil.HorizontalContainer(component.main_grid);

      % ------------------------------------------------------------------------
      %  Name

      component.name_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.NameUI = bev1mus.AppUtil.Component.Label(component.name_layout);
      component.NameUI.ComponentHeight = component.ComponentHeight;
      component.NameUI.ComponentWidth = component.NameUIWidth;
      component.NameUI.Text = bev1mus.CodeUtil.i18n("Double value");

      % ------------------------------------------------------------------------
      %  Alert

      component.alert_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.AlertUI = bev1mus.AppUtil.Graphics.Image(component.alert_layout);
      component.AlertUI.ComponentHeight = component.ComponentHeight;
      component.AlertUI.ComponentWidth = component.AlertUIWidth;

      % ------------------------------------------------------------------------
      % Value

      component.value_layout = addHorizontalGridLayout(component.main_h_container);

      component.ValueTextUI = bev1mus.AppUtil.Component.EditField(component.value_layout);
      component.ValueTextUI.ComponentHeight = component.ComponentHeight;
      component.ValueTextUI.ValueChangedCallback = @() react_ValueTextUI_ValueChanged(component);

      % ------------------------------------------------------------------------
      % Info

      component.info_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.InfoUI = bev1mus.AppUtil.Component.EditField(component.info_layout);
      component.InfoUI.ComponentWidth = component.InfoUIWidth;
      component.InfoUI.ComponentHeight = component.ComponentHeight;
      component.InfoUI.ReadOnly = "on";
      component.InfoUI.MainEditField.Value = "";

      % ------------------------------------------------------------------------
      % SideNote

      component.sidenote_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.SideNoteUI = bev1mus.AppUtil.Component.Label(component.sidenote_layout);
      component.SideNoteUI.ComponentWidth = 10;  % Width gets updated later.
      component.SideNoteUI.Text = "";

    end  % function

    function update(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      update@bev1mus.AppUtil.Component.ComponentBase(component)
      if component.initialized
        regular_update(component)

        return

      end  % if
      first_update(component)
      regular_update(component)
      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      if component.NameInInfo == ""
        component.NameInInfo = component.NameText;
      end  % if

      if strlength(component.InfoText) > 0
        % Show the Info UI.
        component.info_layout.ColumnWidth{1} = component.InfoUIWidth;
        component.InfoUI.ComponentWidth = component.InfoUIWidth;
        component.InfoUI.MainEditField.Tooltip = component.InfoText;
      else
        % Hide the Info UI.
        component.info_layout.ColumnWidth{1} = 0;
        component.InfoUI.MainEditField.Tooltip = "";
      end  % if

      % Side-note UI
      if component.SideNoteUIWidth > 0
        % Show the side-note UI.
        component.sidenote_layout.ColumnWidth{1} = component.SideNoteUIWidth;
        component.SideNoteUI.ComponentWidth = component.SideNoteUIWidth;
      else
        % Hide the side-note UI.
        component.sidenote_layout.ColumnWidth{1} = 0;
      end  % if

      if component.HighlightBackground
        component.NameUI.HighlightBackground = "on";
        component.AlertUI.HighlightBackground = "on";
        component.ValueTextUI.HighlightBackground = "on";
        component.InfoUI.HighlightBackground = "on";
        component.SideNoteUI.HighlightBackground = "on";
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.main_h_container.BaseGridLayout.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.main_h_container.BaseGridLayout.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

    function first_update(component)
      %%
      % This function is called only once after the setup finished and
      % public properties have been updated with the user-specified values.
      % Use this method to freeze property values based on the user-specified values.
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      component.main_h_container.BaseGridLayout.RowHeight = component.ComponentHeight;

      component.NameUI.ComponentHeight = component.ComponentHeight;
      component.NameUI.ComponentWidth = component.NameUIWidth;
      component.NameUI.MainLabel.Text = component.NameText;

      component.AlertUI.ComponentHeight = component.ComponentHeight;

      component.ValueTextUI.ComponentHeight = component.ComponentHeight;
      if component.ReadOnlyValueText
        component.ValueTextUI.ReadOnly = "on";
      end  % if

      component.InfoUI.ComponentHeight = component.ComponentHeight;
      component.InfoUI.ComponentWidth = component.InfoUIWidth;

      component.SideNoteUI.ComponentHeight = component.ComponentHeight;
      component.SideNoteUI.ComponentWidth = component.SideNoteUIWidth;
    end  % function

  end  % methods

  methods

    % --------------------------------------------------------------------------
    % get or set MainDoubleValue

    function x = get.MainDoubleValue(component)
      arguments (Output)
        x double
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      x = component.double_value.MainDoubleValue;
      updateInfoUI(component)
    end  % function

    function set.MainDoubleValue(component, x)
      arguments (Input)
        component
        x (1,:) double
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      try
        component.double_value.MainDoubleValue = x;
      catch exception
        msg = exception.message;

        main_fig = ancestor(component, "figure");
        if isempty(main_fig)
          id = component.errorID + exception.identifier;

          throw(MException(id, msg))

        else
          component.AlertUI.MainImage.Visible = "on";
          component.AlertUI.MainImage.Tooltip = msg + bev1mus.CodeUtil.i18n(" (Click the icon to copy the message to clipboard.)");
          component.AlertUI.ImageClickedCallback = @() clipboard("copy", msg);

          return

        end  % if
      end  % try, catch
      component.AlertUI.MainImage.Visible = "off";
      component.AlertUI.MainImage.Tooltip = "";

      component.ValueText = x;
    end  % function

    % --------------------------------------------------------------------------
    % get hasError

    function true_or_false = get.hasError(component)
      %%
      arguments (Output)
        true_or_false (1,1) logical
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      true_or_false = logical(component.AlertUI.MainImage.Visible);
    end  % function

    % --------------------------------------------------------------------------
    % get or set ValueText

    function str = get.ValueText(component)
      %%
      % Return the content of the value UI.
      % It is a string representing a number or an expression.
      arguments (Output)
        str string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      str = component.ValueTextUI.MainEditField.Value;
    end  % function

    function set.ValueText(component, str)
      %%
      arguments (Input)
        component
        str string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      try
        component.double_value.ValueText = str;

      catch exception
        msg = exception.message;

        main_fig = ancestor(component, "figure");
        if isempty(main_fig)
          id = component.errorID + exception.identifier;

          throw(MException(id, msg))

        else
          component.AlertUI.MainImage.Visible = "on";
          component.AlertUI.MainImage.Tooltip = msg + bev1mus.CodeUtil.i18n(" (Click the icon to copy the message to clipboard.)");
          component.AlertUI.ImageClickedCallback = @() clipboard("copy", msg);

          return

        end  % if
      end  % try, catch
      component.AlertUI.MainImage.Visible = "off";
      component.AlertUI.MainImage.Tooltip = "";

      % This assignment avoids triggering the react_ValueTextUI_ValueChanged callback.
      component.ValueTextUI.MainEditField.Value = str;

      % Show the tooltip because the width of the ValueTextUI may be shorter than its content.
      component.ValueTextUI.MainEditField.Tooltip = str;

      updateInfoUI(component)
    end  % function

  end  % methods
  methods (Access=private)

    function react_ValueTextUI_ValueChanged(component)
      %%
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      current_value_text = component.ValueTextUI.MainEditField.Value;
      try
        component.double_value.ValueText = current_value_text;
      catch exception
        msg = exception.message;

        main_fig = ancestor(component, "figure");
        if isempty(main_fig)
          id = component.errorID + exception.identifier;

          throw(MException(id, msg))

        else
          component.AlertUI.MainImage.Visible = "on";
          component.AlertUI.MainImage.Tooltip = msg + bev1mus.CodeUtil.i18n(" (Click the icon to copy the message to clipboard.)");
          component.AlertUI.ImageClickedCallback = @() clipboard("copy", msg);

          return

        end  % if
      end  % try, catch
      component.AlertUI.MainImage.Visible = "off";
      component.AlertUI.MainImage.Tooltip = "";

      component.ValueTextUI.MainEditField.Tooltip = current_value_text;

      updateInfoUI(component)

      if not(isempty(component.ValueChangedCallback))
        % Call the user-specified callback.
        component.ValueChangedCallback()
      end

      notify(component, "DoubleValueChanged")
      % Make sure to define DoubleValueChanged event.

    end  % function

  end  % methods
  methods

    function updateInfoUI(component)
      %%
      % Update the InfoUI using the current double_value.DoubleValue.
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if

      dbl_val = component.double_value.MainDoubleValue;
      squashed_value_text = bev1mus.CodeUtil.squashCodeText(bev1mus.CodeUtil.stringify(dbl_val));

      % The data in ValueUI is of type double.
      squashed_current_value_text = bev1mus.CodeUtil.squashCodeText(component.ValueTextUI.MainEditField.Value);
      if squashed_value_text ~= squashed_current_value_text
        component.InfoText = squashed_value_text;
      else
        component.InfoText = "";
      end  % if
    end  % function

    % --------------------------------------------------------------------------
    % get or set InfoText

    function str = get.InfoText(component)
      %%
      arguments (Output)
        str string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      str = component.InfoUI.Value;
    end  % function

    function set.InfoText(component, NewInfoText)
      %%
      arguments (Input)
        component
        NewInfoText string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      component.InfoUI.Value = NewInfoText;
      if NewInfoText == ""
        % Hide the Info UI.
        component.info_layout.ColumnWidth{1} = 0;
      else
        % Show the Info UI.
        component.info_layout.ColumnWidth{1} = component.InfoUIWidth;
      end  % if
    end  % function

  end  % methods
end  % classdef
