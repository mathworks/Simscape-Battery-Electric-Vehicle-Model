classdef PhysicalValueWithUnitDropDown < AppUtil1.Component.ComponentBase
  % UI component for simscape.Value with name, value, info, and drop-down UIs
  %
  % This component supports using a variable in the base workspace.

  % Copyright 2026 The MathWorks, Inc.

  properties

    physical_value CodeUtil1.PhysicalValue

    % To improve the searchability, use "*Text", such as "NameText", "ValueText", etc.,
    % rather than "Name", "Value", etc.
    NameText (1,1) string = "Physical value"
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

    UnitItems (1,:) string
    UnitText (1,1) string

    hasError (1,1) logical
  end  % properties
  properties (Dependent)
    SimscapeValue (1,:) simscape.Value
  end  % properties
  properties
    ComponentHeight (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = AppUtil1.Constant.Height{"oneline++"}

    NameUIWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = AppUtil1.Constant.Width{"unitwidth"} * 14
    AlertUIWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = 30
    ValueUIWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = "1x"
    InfoUIWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = AppUtil1.Constant.Width{"unitwidth"} * 10
    UnitUIWidth (1,:) {CodeUtil1.mustBeTextOrPositiveNumber} = AppUtil1.Constant.Width{"unitwidth"} * 10

    NameUI AppUtil1.Component.Label
    AlertUI AppUtil1.Graphics.Image
    ValueTextUI AppUtil1.Component.EditField
    InfoUI AppUtil1.Component.EditField
    UnitDropDownUI AppUtil1.Component.PhysicalUnitDropDown

    Editable (1,1) matlab.lang.OnOffSwitchState = "off"

    ValueChangedCallback {CodeUtil1.mustBeFunctionHandleOrEmpty} = []
    UnitChangedCallback {CodeUtil1.mustBeFunctionHandleOrEmpty} = []
  end  % properties
  properties

    main_h_container AppUtil1.HorizontalContainer

    name_layout matlab.ui.container.GridLayout
    alert_layout matlab.ui.container.GridLayout
    value_layout matlab.ui.container.GridLayout
    info_layout matlab.ui.container.GridLayout
    unit_layout matlab.ui.container.GridLayout

    initialized (1,1) logical = false

    % The Reporting property is for testing purpose only.
    %
    % To see outputs from the class constructor, set Reporting to "on" here.
    % Setting Reporting to "on" in other ways does not enable reporting in the constructor.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if

      setup@AppUtil1.Component.ComponentBase(component)

      component.physical_value = CodeUtil1.PhysicalValue;

      component.main_h_container = AppUtil1.HorizontalContainer(component.main_grid);

      % ------------------------------------------------------------------------
      %  Name

      component.name_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.NameUI = AppUtil1.Component.Label(component.name_layout);
      component.NameUI.ComponentHeight = component.ComponentHeight;
      component.NameUI.ComponentWidth = component.NameUIWidth;
      component.NameUI.Text = CodeUtil1.i18n("Physical value");

      % ------------------------------------------------------------------------
      %  Alert

      component.alert_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.AlertUI = AppUtil1.Graphics.Image(component.alert_layout);
      component.AlertUI.ComponentHeight = component.ComponentHeight;
      component.AlertUI.ComponentWidth = component.AlertUIWidth;

      % ------------------------------------------------------------------------
      % Value

      component.value_layout = addHorizontalGridLayout(component.main_h_container);

      component.ValueTextUI = AppUtil1.Component.EditField(component.value_layout);
      component.ValueTextUI.ComponentHeight = component.ComponentHeight;
      component.ValueTextUI.ValueChangedCallback = @() react_ValueTextUI_ValueChanged(component);

      % ------------------------------------------------------------------------
      % Info

      component.info_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.InfoUI = AppUtil1.Component.EditField(component.info_layout);
      component.InfoUI.ComponentWidth = component.InfoUIWidth;
      component.InfoUI.ComponentHeight = component.ComponentHeight;
      component.InfoUI.ReadOnly = "on";
      component.InfoUI.MainEditField.Value = "";

      % ------------------------------------------------------------------------
      % Unit

      component.unit_layout = addHorizontalGridLayout(component.main_h_container, Width="fit");

      component.UnitDropDownUI = AppUtil1.Component.PhysicalUnitDropDown(component.unit_layout);
      component.UnitDropDownUI.UnitChangedCallback = @() react_UnitUI_UnitChanged(component);

    end  % function

    function update(component)
      %%
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      update@AppUtil1.Component.ComponentBase(component)
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
        FileUtil1.displayTimeAndFileLocation("1")
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

      component.UnitDropDownUI.ComponentWidth = component.UnitUIWidth;
      component.UnitDropDownUI.ComponentHeight = component.ComponentHeight;

      if component.HighlightBackground
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("2")
        end  % if
        component.NameUI.HighlightBackground = "on";
        component.AlertUI.HighlightBackground = "on";
        component.ValueTextUI.HighlightBackground = "on";
        component.InfoUI.HighlightBackground = "on";
        component.UnitDropDownUI.HighlightBackground = "on";
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
        FileUtil1.displayTimeAndFileLocation
      end  % if

      component.UnitDropDownUI.Editable = component.Editable;

      if not(component.UnitDropDownUI.UnitSpecified)
        % If the app code did not specify the unit of this component,
        % fix it with the first element of UnitItems.
        component.UnitItems = "1";
        component.UnitText = "1";
      else
        % Sync the internal physical_value with the dropdown's current unit
        % so that subsequent unit changes pass the commensurability check.
        component.physical_value.initialized = false;
        component.physical_value.UnitText = component.UnitDropDownUI.UnitText;
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

      component.UnitDropDownUI.ComponentWidth = component.UnitUIWidth;

    end  % function

  end  % methods

  methods

    function react_UnitUI_UnitChanged(component)
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      unit_text = component.UnitDropDownUI.UnitText;
      component.physical_value.UnitText = unit_text;

      if not(isempty(component.UnitChangedCallback))
        component.UnitChangedCallback()
      end
    end  % function

    % --------------------------------------------------------------------------
    % get or set SimscapeValue

    function x = get.SimscapeValue(component)
      %%
      arguments (Output)
        x simscape.Value
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      try
        component.physical_value.ValueText = component.ValueText;
        component.physical_value.UnitText = component.UnitText;
        ssc_val = component.physical_value.SimscapeValue;
      catch exception

        rethrow(exception)

      end  % try, catch

      updateInfoAndUnitUIs(component)

      x = ssc_val;

    end  % function

    function set.SimscapeValue(component, x)
      %%
      arguments (Input)
        component
        x simscape.Value
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if

      try
        component.physical_value.SimscapeValue = x;
      catch exception

        rethrow(exception)

      end  % try, catch
      component.ValueText = CodeUtil1.stringify(value(x));
      component.UnitText = string(unit(x));
    end  % function

    % --------------------------------------------------------------------------
    % get hasError

    function true_or_false = get.hasError(component)
      %%
      arguments (Output)
        true_or_false (1,1) logical
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      true_or_false = logical(component.AlertUI.MainImage.Visible);
    end  % function

    % --------------------------------------------------------------------------
    % get or set ValueText

    function str = get.ValueText(component)
      %%
      % Return the content of the value UI.
      % It is a string representing a number, a simscape.Value, or an expression.
      arguments (Output)
        str string
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
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
        FileUtil1.displayTimeAndFileLocation
      end  % if

      try
        component.physical_value.ValueText = str;

      catch exception
        msg = exception.message;

        main_fig = ancestor(component, "figure");
        if isempty(main_fig)
          id = component.errorID + exception.identifier;

          throw(MException(id, msg))

        else
          component.AlertUI.MainImage.Visible = "on";
          component.AlertUI.MainImage.Tooltip = msg + CodeUtil1.i18n(" (Click the icon to copy the message to clipboard.)");
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

      updateInfoAndUnitUIs(component)
    end  % function

  end  % methods
  methods (Access=private)

    function react_ValueTextUI_ValueChanged(component)
      %%
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if

      current_value_text = component.ValueTextUI.MainEditField.Value;
      try
        component.physical_value.ValueText = current_value_text;

      catch exception
        msg = exception.message;

        main_fig = ancestor(component, "figure");
        if isempty(main_fig)
          id = component.errorID + exception.identifier;

          throw(MException(id, msg))

        else
          component.AlertUI.MainImage.Visible = "on";
          component.AlertUI.MainImage.Tooltip = msg + CodeUtil1.i18n(" (Click the icon to copy the message to clipboard.)");
          component.AlertUI.ImageClickedCallback = @() clipboard("copy", msg);

          return

        end  % if
      end  % try, catch
      component.AlertUI.MainImage.Visible = "off";
      component.AlertUI.MainImage.Tooltip = "";

      component.ValueTextUI.MainEditField.Tooltip = current_value_text;

      updateInfoAndUnitUIs(component)

      if not(isempty(component.ValueChangedCallback))
        % Call the user-specified callback.
        component.ValueChangedCallback()
      end
    end  % function

  end  % methods
  methods

    function updateInfoAndUnitUIs(component)
      %%
      % Update the InfoUI and the UnitLabelUI using the current physical_value.SimscapeValue.
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if

      sscval = component.physical_value.SimscapeValue;
      unit_text = string(unit(sscval));
      squashed_value_text = CodeUtil1.squashCodeText(CodeUtil1.stringify(value(sscval)));

      % InfoUI
      if component.physical_value.ValueTextIsSimscapeValue
        component.InfoText = squashed_value_text + " (" + unit_text + ")";
      else
        % The data in ValueTextUI is of type double.
        squashed_current_value_text = CodeUtil1.squashCodeText(component.ValueTextUI.MainEditField.Value);
        if squashed_value_text ~= squashed_current_value_text
          component.InfoText = squashed_value_text;
        else
          component.InfoText = "";
        end  % if
      end  % if

      % UnitDropDownUI
      if component.physical_value.ValueTextIsSimscapeValue
        % The data in ValueTextUI is of type simscape.Value.
        % In the unit UI, show the simscape.Value's unit, but gray it out.
        component.UnitText = unit_text;
        component.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "off";
      else
        % The data in ValueTextUI is of type double.
        % Render the unit UI normally.
        component.UnitDropDownUI.DropDownUI.MainDropDown.Enable = "on";
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
        FileUtil1.displayTimeAndFileLocation
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
        FileUtil1.displayTimeAndFileLocation
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

    % --------------------------------------------------------------------------
    % get and set for UnitItems

    function unit_items = get.UnitItems(component)
      %%
      arguments (Output)
        unit_items (1,:) string
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      unit_items = component.UnitDropDownUI.UnitItems;
    end  % function

    function set.UnitItems(component, NewUnitItems)
      %%
      arguments (Input)
        component
        NewUnitItems (1,:) string
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation("1")
      end  % if

      try
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("2:UnitDropDownUI.UnitItems")
        end  % if
        component.UnitDropDownUI.UnitItems = NewUnitItems;        
      catch exception
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("3:exception:" + exception.message)
        end  % if

        rethrow(exception)

      end  % try, catch

      % !todo: Update physical_value?

    end  % function

    % --------------------------------------------------------------------------
    % get or set UnitText

    function unit_text = get.UnitText(component)
      %%
      arguments (Output)
        unit_text (1,1) string
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      unit_text = component.UnitDropDownUI.UnitText;
    end  % function

    function set.UnitText(component, NewUnitText)
      %%
      arguments (Input)
        component
        NewUnitText (1,1) string
      end  % arguments
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation("1")
      end  % if
      if not(component.initialized)
        % Make component.physical_value initializable.
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("2:reset")
        end  % if
        component.physical_value.initialized = false;
      end  % if
      try
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("3:UnitDropDownUI.UnitText:" + NewUnitText)
        end  % if
        component.UnitDropDownUI.UnitText = NewUnitText;
      catch exception
        if component.Reporting
          FileUtil1.displayTimeAndFileLocation("5:exception:" + exception.message)
        end  % if

        rethrow(exception)

      end  % try, catch
      if component.Reporting
        FileUtil1.displayTimeAndFileLocation("6")
      end  % if
      component.AlertUI.MainImage.Visible = "off";
      component.AlertUI.MainImage.Tooltip = "";
      component.physical_value.UnitText = NewUnitText;
    end  % function

  end  % methods
end  % classdef
