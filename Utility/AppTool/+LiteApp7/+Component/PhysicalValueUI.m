classdef PhysicalValueUI < LiteApp7.Component.LiteAppComponentBase
  %% Composite UI component for simscape.Value with name, value, info, and unit UIs
  % This component supports using variables in the base workspace.
  %
  % Errors are reported inline in the UI component, rather than in a dialog window.
  % The inline error reporting allows the user to leave the error unaddressed and
  % do other operations in the app.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties (Dependent)
    % You can change the Name property only during component initialization.
    Name (1,1) string

    % Value property can be either numeric, simscape.Value, or expression.
    % Expression can contain workspace variables.
    % If you use simscape.Value, its unit must be commensurate with Unit property.
    Value (1,1) string

    Info (1,1) string

    % UnitItems property provides a group of commensurate units.
    % You can programatically define UnitItems property only during component initialization.
    % If UnitItems property has only one item, it is ignored and, instead, Unit property is used.
    UnitItems (1,:) string

    % You can change the Unit property only during component initialization.
    % If two or more items are defined in UnitItems property, Unit property must be one of the items.
    % To use only one unit, set one arbitrary unit item (such as "1") to UnitItems property, and
    % define the unit you want to use in Unit property.
    Unit (1,1) string

    % Use UnitAlias to display an arbitrary string in the unit UI.
    % Modifying UnitAlias sets the unit to "1".
    %
    % Assing zero-length string to UnitAlias (UnitAlias = "") to avoid showing any text in the unit UI.
    % (To hide the unit UI, assign "off" to HideUnit property.)
    %
    % Percent symbol must be preceded by a backslash: UnitAlias = "\%"
    % because latex interpreter is used for parsing the unit alias text.
    %
    % You can change UnitAlias property only during component initialization.
    UnitAlias (1,1) string

    % To hide Unit UI, set this to "on".
    % Hiding unit sets unit to "1" and alias to "".
    % This takes precedence over Unit and UnitAlias properties.
    % Explicitly setting HideUnit to "off" resets the unit to "1".
    HideUnit (1,1) matlab.lang.OnOffSwitchState

    SimscapeValue (1,:) simscape.Value

  end  % properties

  properties

    HasError (1,1) logical = false
    ErrorMessage (1,1) string = ""

    % To see outputs from class constructors, you must set Reporting to "on" here.
    % Setting Reporting to "on" in other ways do not enable reporting from constructors.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

    % Unit UI style is automatically determined in the first update.
    % When "hide" is selected, Unit is "1" and Unit alias is "".
    unit_ui_style (1,1) string {mustBeMember(unit_ui_style, ["label", "dropdown", "hide"])} = "label"

    % The user of this class can set actions to these callbacks.
    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []
    UnitChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    % NameInInfo is used within the text string in the Info UI. Avoid $ for the LaTeX text.
    % If NameInInfo is "", Name is used in the info text string.
    NameInInfo (1,1) string = ""

    NameUIWidth (1,1) double {mustBePositive} = LiteApp7.Constant.Width{"unitwidth"} * 14
    InfoUIWidth (1,1) double {mustBePositive} = LiteApp7.Constant.Width{"unitwidth"} * 10
    UnitUIWidth (1,1) double {mustBePositive} = LiteApp7.Constant.Width{"unitwidth"} * 10

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline++"}

  end  % properties

  % For testing purpose, these properties have to be public.
  % Do not access these properties for other purposes.
  properties
    % Parameter name.
    NameUI LiteApp7.Component.Label

    % Parameter value which users can edit.
    % This contains an expression which can be a number, a variable,
    % a struct field, a function call, or an arithmetic formula using them.
    ValueEditFieldUI LiteApp7.Component.EditField

    % Information to show as needed.
    % This is either the number representation of the parameter, or an error message.
    % This can show the result of evaluating the value in the ValueEditFieldUI component.
    % It can be a scalar, a vector, or a matrix.
    InfoUI LiteApp7.Component.EditField

    % Physical unit of the parameter.
    % Drop down is visible if the value UI is not simscape.Value.
    % Label is visible if the value UI is simscape.Value.
    % Their visibilities are mutually exclusive, i.e.,
    % they cannot be made visible at the same time.
    UnitDropDownUI LiteApp7.Component.DropDown
    UnitLabelUI LiteApp7.Component.Label

    RowContainer matlab.ui.container.GridLayout

    NameColumnContainer matlab.ui.container.GridLayout
    ValueColumnContainer matlab.ui.container.GridLayout
    InfoColumnContainer matlab.ui.container.GridLayout
    UnitColumnContainer matlab.ui.container.GridLayout

    ValueReadOnly (1,1) logical = false

    OnlyOneUnitItem (1,1) logical = true

  end  % properties

  properties

    initialized (1,1) logical = false

    % unit_specified is set to true when the user of this class specifically
    % sets the (physical) unit using one of the unit-related properties.
    % Default unit is "1", but once the user specifies unit,
    % the unit is fixed to it during the first update and
    % cannot be changed while the app is running.
    unit_specified (1,1) logical = false

    multiple_units (1,1) logical = false
    simscape_unit_string (1,1) string = "1"
    unit_alias (1,1) string = ""
    hide_unit_ui (1,1) logical = false

    current_simscape_value simscape.Value = simscape.Value(0)
    current_numeric_value double = 0

  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % PhysicalValueChanged event adds PhysicalValueChangedFcn property to this class.
    PhysicalValueChanged

    % PhysicalUnitChanged event adds PhysicalUnitChangedFcn property to this class.
    PhysicalUnitChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      % Visibilities of UI subcomponents are controlled by RowContainer's ColumnWidth.
      % Each subcomponent's ComponentWidth does not affect the visibility.
      % ValueUI's ComponentWidth must be always '1x'.

      component.RowContainer = uigridlayout(component.baseGridObject, [1 1]);
      component.RowContainer.Layout.Row = 1;
      component.RowContainer.Layout.Column = 1;
      component.RowContainer.Padding = [0 0 0 0];  % left bottom right top
      component.RowContainer.ColumnSpacing = 1;  % Give 1px space between the name, value, info, and unit columns.
      component.RowContainer.RowSpacing = 0;

      component.RowContainer.RowHeight = component.ComponentHeight;

      % Each column corresponds to Name, Value, Info, and Unit.
      component.RowContainer.ColumnWidth = {component.NameUIWidth, '1x', 0, 0};

      % ------------------------------------------------------------------------
      %  Name

      component.NameColumnContainer = uigridlayout(component.RowContainer, [1 1]);
      component.NameColumnContainer.Layout.Row = 1;
      component.NameColumnContainer.Layout.Column = 1;
      component.NameColumnContainer.Padding = [0 0 0 0];  % left bottom right top
      component.NameColumnContainer.RowHeight = {'1x', 'fit', '1x'};
      component.NameColumnContainer.RowSpacing = 0;
      % component.NameColumnContainer.ColumnWidth = component.NameUIWidth;
      component.NameColumnContainer.ColumnWidth = {'fit'};
      component.NameColumnContainer.ColumnSpacing = 0;

      component.NameUI = LiteApp7.Component.Label(component.NameColumnContainer);
      component.NameUI.Layout.Row = 2;  % middle cell
      component.NameUI.Layout.Column = 1;
      component.NameUI.ComponentHeight = component.ComponentHeight;
      component.NameUI.ComponentWidth = component.NameUIWidth;
      component.NameUI.Text = "Physical value";

      % ------------------------------------------------------------------------
      % Value

      component.ValueColumnContainer = uigridlayout(component.RowContainer, [1 1]);
      component.ValueColumnContainer.Layout.Row = 1;
      component.ValueColumnContainer.Layout.Column = 2;
      component.ValueColumnContainer.Padding = [0 0 0 0];  % left bottom right top
      component.ValueColumnContainer.RowHeight = {'1x', 'fit', '1x'};
      component.ValueColumnContainer.RowSpacing = 0;
      component.ValueColumnContainer.ColumnWidth = {'1x'};  % Expand the Value UI horizontally
      component.ValueColumnContainer.ColumnSpacing = 0;

      component.ValueEditFieldUI = LiteApp7.Component.EditField(component.ValueColumnContainer);
      component.ValueEditFieldUI.Layout.Row = 2;
      component.ValueEditFieldUI.Layout.Column = 1;
      % To avoid triggering callback, set initial value before setting callback
      component.ValueEditFieldUI.Value = "0";
      component.ValueEditFieldUI.ValueChangedCallback = @() valueUI_ValueChanged(component);

      % ------------------------------------------------------------------------
      % Info

      component.InfoColumnContainer = uigridlayout(component.RowContainer, [1 1]);
      component.InfoColumnContainer.Layout.Row = 1;
      component.InfoColumnContainer.Layout.Column = 3;
      component.InfoColumnContainer.Padding = [0 0 0 0];  % left bottom right top
      component.InfoColumnContainer.RowHeight = {'1x', 'fit', '1x'};
      component.InfoColumnContainer.RowSpacing = 0;
      component.InfoColumnContainer.ColumnWidth = {'fit'};
      component.InfoColumnContainer.ColumnSpacing = 0;

      component.InfoUI = LiteApp7.Component.EditField(component.InfoColumnContainer);
      component.InfoUI.Layout.Row = 2;
      component.InfoUI.Layout.Column = 1;
      component.InfoUI.ComponentWidth = component.InfoUIWidth;
      component.InfoUI.ReadOnly = "on";

      component.InfoUI.Value = "";

      % ------------------------------------------------------------------------
      % Unit

      component.UnitColumnContainer = uigridlayout(component.RowContainer, [1 1]);
      component.UnitColumnContainer.Layout.Row = 1;
      component.UnitColumnContainer.Layout.Column = 4;
      component.UnitColumnContainer.Padding = [0 0 0 0];
      component.UnitColumnContainer.RowHeight = {'1x', 'fit', 'fit', '1x'};  % create 4 rows
      component.UnitColumnContainer.RowSpacing = 0;
      component.UnitColumnContainer.ColumnWidth = {'fit'};
      component.UnitColumnContainer.ColumnSpacing = 0;

      component.UnitLabelUI = LiteApp7.Component.Label(component.UnitColumnContainer);
      component.UnitLabelUI.Layout.Row = 2;  % 2nd row
      component.UnitLabelUI.Layout.Column = 1;
      component.UnitLabelUI.ComponentWidth = component.UnitUIWidth;
      component.UnitLabelUI.Text = "1";

      component.UnitDropDownUI = LiteApp7.Component.DropDown(component.UnitColumnContainer);
      component.UnitDropDownUI.Layout.Row = 3;  % 3rd row
      component.UnitDropDownUI.Layout.Column = 1;
      component.UnitDropDownUI.ComponentWidth = component.UnitUIWidth;
      % To avoid triggering callback, set initial value before setting callback
      component.UnitDropDownUI.Items = "1";
      component.UnitDropDownUI.Value = "1";
      component.UnitDropDownUI.ValueChangedCallback = @() unitUI_ValueChanged(component);

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      if component.initialized
        regular_update(component)
        alertOnError(component)

        return

      end  % if

      first_update(component)
      alertOnError(component)

      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.NameInInfo == ""
        component.NameInInfo = component.Name;
      end  % if

      component.RowContainer.ColumnWidth = {component.NameUIWidth, '1x', 0, 0};

      if strlength(component.Info) > 0
        % Show the Info UI.
        component.RowContainer.ColumnWidth{3} = component.InfoUIWidth;
        component.InfoUI.ComponentWidth = component.InfoUIWidth;
        component.InfoUI.MainEditField.Tooltip = component.Info;

      else
        % Hide the Info UI.
        component.RowContainer.ColumnWidth{3} = 0;
        component.InfoUI.MainEditField.Tooltip = "";
      end  % if

      if not(component.hide_unit_ui)
        component.RowContainer.ColumnWidth{4} = component.UnitUIWidth;
        if component.unit_ui_style == "dropdown"
          component.UnitDropDownUI.ComponentWidth = component.UnitUIWidth;
        else  % label
          component.UnitLabelUI.ComponentWidth = component.UnitUIWidth;
        end  % if, drop-down or label
      end  % if

      if component.HighlightBackground
        component.baseGridObject.BackgroundColor = component.HighlightBackgroundColor;
        component.RowContainer.BackgroundColor = component.HighlightBackgroundColor;
        component.NameColumnContainer.BackgroundColor = component.HighlightBackgroundColor;
        component.NameUI.MainLabel.BackgroundColor = component.HighlightBackgroundColor;
        component.ValueColumnContainer.BackgroundColor = component.HighlightBackgroundColor;
        component.ValueEditFieldUI.MainEditField.BackgroundColor = component.HighlightBackgroundColor;
        component.InfoColumnContainer.BackgroundColor = component.HighlightBackgroundColor;
        component.InfoUI.MainEditField.BackgroundColor = component.HighlightBackgroundColor;
        component.UnitColumnContainer.BackgroundColor = component.HighlightBackgroundColor;
        if component.OnlyOneUnitItem
          component.UnitLabelUI.MainLabel.BackgroundColor = component.HighlightBackgroundColor;
        else
          component.UnitDropDownUI.MainDropDown.BackgroundColor = component.HighlightBackgroundColor;
        end  % if
      end  % if

    end  % function

    function first_update(component)
      %%
      % This method is called only once after the setup finished and
      % public properties have been updated with user specified values.
      % Use this method to 
      % - freeze property values based on user-specified values
      % - delete unused component objects

      if component.HasError

        error(component.ErrorMessage)  % !todo: app must stop running

      end  % if

      component.RowContainer.RowHeight = component.ComponentHeight;
      component.NameUI.ComponentHeight = component.ComponentHeight;

      component.NameUI.ComponentWidth = component.NameUIWidth;
      component.InfoUI.ComponentWidth = component.InfoUIWidth;

      if component.ValueReadOnly
        component.ValueEditFieldUI.ReadOnly = "on";
      end  % if

      % ------------------------------------------------------------------------
      % Setup unit UI.
      % Once having fixed the unit UI style here, do not allow changing it later.

      if component.hide_unit_ui
        component.unit_ui_style = "hide";
        component.unit_alias = "";
        component.multiple_units = false;
        component.OnlyOneUnitItem = true;
        component.RowContainer.ColumnWidth{4} = 0;
        component.simscape_unit_string = "1";

      elseif numel(component.UnitDropDownUI.Items) > 1
        component.unit_ui_style = "dropdown";
        component.unit_alias = "";
        component.multiple_units = true;
        component.OnlyOneUnitItem = false;
        component.UnitDropDownUI.ComponentWidth = component.UnitUIWidth;

      else  % label
        component.unit_ui_style = "label";
        component.multiple_units = false;
        component.OnlyOneUnitItem = true;
        component.UnitLabelUI.ComponentWidth = component.UnitUIWidth;
        if component.UnitAlias == ""
          % Use a string which is valid as simscape.Unit.
          component.unit_alias = "";
          component.simscape_unit_string = component.UnitLabelUI.Text;
        else
          % Show unit alias.
          component.unit_alias = component.UnitAlias;
          component.simscape_unit_string = "1";
        end  % if
      end  % if

      component.unit_specified = true;

      % ------------------------------------------------------------------------
      % Delete unused object.
      if component.hide_unit_ui

        delete(component.UnitLabelUI)
        component.UnitColumnContainer.RowHeight{2} = 0;

        delete(component.UnitDropDownUI)
        component.UnitColumnContainer.RowHeight{3} = 0;

      elseif component.multiple_units

        delete(component.UnitLabelUI)
        component.UnitColumnContainer.RowHeight{2} = 0;

      else

        delete(component.UnitDropDownUI)
        component.UnitColumnContainer.RowHeight{3} = 0;

      end  % if
    end  % function

  end  % methods

  methods

    function alertOnError(component)
      %%
      if not(component.HasError)

        return

      end  % if

      if not(startsWith(component.ErrorMessage, "Error:"))
        message = "Error: " + component.ErrorMessage;
      else
        message = component.ErrorMessage;
      end  % if

      component.RowContainer.ColumnWidth = {component.NameUIWidth, '1x', '2x', 0};

      component.InfoColumnContainer.ColumnWidth = {'1x'};

      component.InfoUI.ComponentWidth = "1x";
      component.InfoUI.Value = message;
      component.InfoUI.MainEditField.Tooltip = message;

    end  % function

    % --------------------------------------------------------------------------
    % Name

    function val = get.Name(component)
      %%
      arguments (Output)
        val string
      end
      val = component.NameUI.Text;
    end  % function

    function set.Name(component, val)
      %%
      arguments (Input)
        component
        val string
      end
      if component.initialized
        % Changing Name is not allowed after initialization.

        return

      else
        component.NameUI.Text = val;
      end  % if
    end  % function

    % --------------------------------------------------------------------------
    % Simscape value (name + unit)

    function x = get.SimscapeValue(component)
      %%
      % This returns a simscape.Value object which is constructed from
      % the current data in the Value UI and the Unit UI.
      arguments (Output)
        x simscape.Value
      end  % arguments

      % The Value UI can contain a workspace variable, and the workspace variable
      % can change at any point in time.
      % Thus, whenever returning a Simscape Value,
      % the state of the Value UI needs to be checked, and
      % the Info UI and the Unit UI may have to be updated.
      failed = buildSimscapeValueFromValueUIAndUnitUI(component);
      if failed
        % Something must be assigned to a return value.
        x = component.current_simscape_value;

        return

      end  % if

      x = component.current_simscape_value;

    end  % function

    function set.SimscapeValue(component, x)
      %%
      arguments (Input)
        component
        x (1,:) simscape.Value
      end  % arguments

      component.current_numeric_value = value(x);

      component.Value = CodeTool1.stringify(component.current_numeric_value);

      if component.unit_alias == ""
        component.Unit = string(unit(x));
      end  % if

      component.current_simscape_value = x;

    end  % function

    % --------------------------------------------------------------------------
    % Value

    function str = get.Value(component)
      %%
      % Value returns the content of the value UI.
      % It is a string representing a number, a simscape.Value, or an expression.
      arguments (Output)
        str string
      end  % arguments
      str = component.ValueEditFieldUI.Value;
    end  % function

    function set.Value(component, str)
      %%
      arguments (Input)
        component
        str string
      end  % arguments
      % RawSetValue(component, str)
      component.ValueEditFieldUI.Value = str;
      valueUI_ValueChanged(component)
    end  % function

    % --------------------------------------------------------------------------
    % Info

    function str = get.Info(component)
      arguments (Output)
        str string
      end  % arguments
      str = component.InfoUI.Value;
    end  % function

    function set.Info(component, str)
      arguments (Input)
        component
        str string
      end  % arguments
      component.InfoUI.Value = str;
      if str == ""
        % Hide the Info UI.
        component.RowContainer.ColumnWidth{3} = 0;
      else
        % Show the Info UI.
        component.RowContainer.ColumnWidth{3} = component.InfoUIWidth;
      end  % if
    end  % function

    % --------------------------------------------------------------------------
    % Unit drop down items

    function items = get.UnitItems(component)
      %%
      arguments (Output)
        items (1,:) string
      end  % arguments

      if not(component.unit_ui_style == "dropdown")
        component.HasError = true;
        component.ErrorMessage = "UnitItems are valid only when units are selectable from drop down list";

        return

      end  % if

      items = component.UnitDropDownUI.Items;

    end  % function

    function set.UnitItems(component, items)
      %%
      % When this runs after setup before first_update,
      % properties in this function are still default values.

      arguments (Input)

        component

        items (1,:) string {CodeTool1.mustBeAllCommensurateUnit}

      end  % arguments

      if component.unit_specified
        % After the first_update method, you can't change the unit specification.
        unit_str = component.simscape_unit_string;
        component.HasError = true;
        component.ErrorMessage = "UnitItems cannot be used because unit specification is already defined: " + unit_str;

        return  % managed-error

      end  % if

      if isscalar(items)

        return

      end  % if

      component.UnitDropDownUI.Items = items;
      component.UnitDropDownUI.Value = items(1);
      component.simscape_unit_string = items(1);

      component.current_simscape_value = simscape.Value(component.current_numeric_value, component.simscape_unit_string);

      component.unit_ui_style = "dropdown";
      component.unit_alias = "";
      component.multiple_units = true;
      component.OnlyOneUnitItem = false;

      component.unit_specified = true;

    end  % function

    % --------------------------------------------------------------------------
    % Unit

    function str = RawGetUnit(component)
      %%
      arguments (Output)
        str (1,1) string
      end  % arguments

      if not(component.unit_specified)
        str = "1";

      elseif component.multiple_units
        str = component.UnitDropDownUI.MainDropDown.Value;

      elseif component.hide_unit_ui
        str = "1";

      elseif component.unit_alias ~= ""
        % Must ignore unit alias because it is not valid for simscape.Unit.
        str = "1";

      else
        str = component.UnitLabelUI.Text;
        if str == ""
          str = "1";
        end  % if

      end  % if
    end  % function

    function txt = get.Unit(component)
      %%
      arguments (Output)
        txt (1,1) string
      end  % arguments
      txt = RawGetUnit(component);
    end  % function

    function set.Unit(component, UnitString)
      %%
      arguments (Input)
        component
        UnitString (1,1) string
      end  % arguments

      % set.Unit must continue to work after the first_update method because
      % set.Unit is used to select a unit from the drop down list.

      if component.unit_specified && (component.unit_alias ~= "")
        % Case 1: Unit alias is defined.

        if not(UnitString ~= "1")
          % Issue a managed error to inform the user that set.Unit does not work
          % when unit alias is defined.
          component.HasError = true;
          component.ErrorMessage = "Unit is fixed as ""1"" when unit alias is used";

          return  % managed-error

        end  % if

        % Recover from error if UnitString is "1".
        component.HasError = false;
        component.ErrorMessage = "";

        return  % success/error-recovery

      elseif component.unit_specified && not(component.multiple_units)
        % Case 2: Single unit is defined.
        % Allow changing the unit if it is commensurate.

        try
          simscape.mustBeCommensurateUnit(UnitString, component.Unit)
        catch exception
          component.HasError = true;
          component.ErrorMessage = exception.message;

          if not(component.initialized)
            % The app is not visible yet. Show the error message in Command Window.
            error(component.ErrorMessage)  % severe-error !todo: app must exit
          else

            return  % managed-error

          end  % if
        end  % try, catch

        component.UnitLabelUI.Text = UnitString;
        component.simscape_unit_string = UnitString;
        component.HasError = false;
        component.ErrorMessage = "";

        if component.initialized
          unitUI_ValueChanged(component)
        end  % if

        return  % success

      elseif component.unit_specified && component.multiple_units
        % Case 3: Multiple units are defined.
        % Allow selecting one from the defined units.

        unit_items = component.UnitDropDownUI.Items;
        % if not(ismember(UnitString, unit_items))
        if not(simscape.isCommensurateUnit(UnitString, unit_items{1}))
          unit_items_joined = join(unit_items, ", ");
          component.HasError = true;
          component.ErrorMessage = "Unit """ + UnitString + """ is not found in the defined units: " + unit_items_joined;
          if not(component.initialized)

            % The app is not visible yet. Show the error message in Command Window.
            error(component.ErrorMessage)  % severe-error !todo: app must exit

          else

            return  % managed-error

          end  % if
        end  % if

        % Assign to the raw value. Do not use any higher level values for assignment here
        % because they can have side effects, which can result in infinite recursive call.
        % Specifically, for example, avoid component.UnitDropDownUI.Value on the L.H.S.
        component.UnitDropDownUI.MainDropDown.Value = UnitString;
        component.simscape_unit_string = UnitString;

        component.HasError = false;
        component.ErrorMessage = "";

        if component.initialized

          unitUI_ValueChanged(component)

        end  % if

        return  % success

      else
        % Case 4: Unit is not specified yet.
        % Allow specifying one unit.
        % The execution of this branch can occur only after setup and before update.

        try
          % Validate the provided string.
          simscape.Unit(UnitString);
        catch exception
          % In case of an error, it is a severe error and the app must exit because
          % the app is still not visible and there is no way to show
          % the error message in the app.
          component.HasError = true;
          component.ErrorMessage = exception.message;

          error(exception.message)

          return  % severe-error !todo: app must exit

        end  % try, catch

        component.UnitLabelUI.Text = UnitString;
        component.simscape_unit_string = UnitString;
        component.HasError = false;
        component.ErrorMessage = "";

        component.unit_ui_style = "label";
        component.unit_alias = "";
        component.multiple_units = false;
        component.OnlyOneUnitItem = true;

        component.unit_specified = true;

        return  % success

      end  % if
    end  % function

    % --------------------------------------------------------------------------
    % Unit alias

    function txt = get.UnitAlias(component)
      %%
      arguments (Output)
        txt (1,1) string
      end  % arguments
      txt = component.unit_alias;
    end  % function

    function set.UnitAlias(component, AliasString)
      %%
      % Defining unit alias implies that the unit is "1".
      arguments (Input)
        component
        AliasString (1,1) string
      end

      component.UnitLabelUI.Text = AliasString;
      component.unit_alias = AliasString;

    end  % function

    % --------------------------------------------------------------------------
    % Hide unit UI

    function on_or_off = get.HideUnit(component)
      %%
      arguments (Output)
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end
      if component.hide_unit_ui
        on_or_off = "on";
      else
        on_or_off = "off";
      end  % if
    end  % function

    function set.HideUnit(component, hide_flag)
      %%
      % HideUnit is off by default.
      % Setting it to on sets the unit to 1.

      arguments (Input)
        component 
        hide_flag (1,1) matlab.lang.OnOffSwitchState
      end

      if component.unit_specified
        component.HasError = true;
        component.ErrorMessage = "HideUnits cannot be enabled because unit specification is already defined.";

        error(component.ErrorMessage)

        return

      end  % if

      component.hide_unit_ui = logical(hide_flag);

      if hide_flag
        component.unit_ui_style = "hide";
        component.RowContainer.ColumnWidth{4} = 0;

      else
        component.unit_ui_style = "label";
        component.RowContainer.ColumnWidth{4} = component.UnitUIWidth;

      end  % if

      component.OnlyOneUnitItem = true;
      component.UnitLabelUI.Text = "1";
      component.simscape_unit_string = "1";
      component.unit_alias = "";
      component.unit_specified = true;
    end  % function

  end  % methods

  methods (Access=private)

    function valueUI_ValueChanged(component)
      %%
      not_ok = buildSimscapeValueFromValueUIAndUnitUI(component);
      if not_ok

        return

      end  % if

      % UpdateLinkedPhysicalValue(component)

      if not(isempty(component.ValueChangedCallback)) ...
          && isa(component.ValueChangedCallback, 'function_handle')
        component.ValueChangedCallback()
      end

      notify(component, "PhysicalValueChanged")
      % Make sure to define PhysicalValueChanged event.

      component.HasError = false;
      component.ErrorMessage = "";
    end  % function

    function unitUI_ValueChanged(component)
      %%
      % - Called as a callback of the change in the unit drop down.
      % - Called from the set.Unit method.
      % - Called from the set.UnitAlias method.

      [result, not_ok] = getNumericValueFromValueUI(component);
      if not_ok

        return

      end  % if

      component.simscape_unit_string = component.Unit;
      component.current_simscape_value = simscape.Value(result.NumericValue, component.Unit);

      % UpdateLinkedPhysicalValue(component)

      % The UnitChangedCallback proeperty can be set by the user of this component.
      % User-defined callback must fire regardless of the change propagation state.
      if not(isempty(component.UnitChangedCallback)) ...
          && isa(component.UnitChangedCallback, 'function_handle')
        component.UnitChangedCallback() 
      end

      notify(component, "PhysicalUnitChanged")
      % Make sure to define PhysicalUnitChanged event.

      component.HasError = false;
      component.ErrorMessage = "";
    end  % function

    function failed = buildSimscapeValueFromValueUIAndUnitUI(component)
      %%
      % Build a simscape.Value from the current Value UI and the current Unit UI.
      % The result is kept in the current_simscape_value property.
      %
      % Note that the get.SimscapeValue method must call this because
      % the Value property of the Value UI may be a workspace variable and
      % the app cannot know when the workspace variable was modified.
      % As a result, if an app reads the SimscapeValue property of this component,
      % This must first check the Value of the Value UI and then return the latest data.

      [result, failed] = getNumericValueFromValueUI(component);
      if failed

        return

      end  % if

      if result.Type == "simscape.Value"

        if component.multiple_units
          component.UnitDropDownUI.MainDropDown.Value = result.PhysicalUnit;
          % Freeze the unit in the unit drop down to prevent inconsistency
          % between the simscape.Value in the value UI and the unit in the unit drop down.
          component.UnitDropDownUI.MainDropDown.Enable = "off";
        else
          component.UnitLabelUI.MainLabel.Text = result.PhysicalUnit;
        end  % if
        component.simscape_unit_string = result.PhysicalUnit;

      else
        % The result is of type double.
        % The evaluation result of the value UI string has no physical unit.
        % Use the current unit.
        component.simscape_unit_string = RawGetUnit(component);

        if component.multiple_units
          % The unit drop down may have been disabled in the other if-else branch.
          component.UnitDropDownUI.MainDropDown.Enable = "on";
        end  % if
      end  % if

      % Build and keep the latest Simscape Value.
      % This must be done after the value and the unit were validated.
      try
        % simscape.Value can throw an exception, for example, if the first argument is an imaginary number.
        component.current_simscape_value = simscape.Value(result.NumericValue, component.simscape_unit_string);
      catch exception
        component.HasError = true;
        component.ErrorMessage = exception.message;
        failed = true;

        return

      end  % try, catch

      component.current_numeric_value = result.NumericValue;

      failed = false;
      component.ErrorMessage = "";
      component.HasError = false;
    end  % function

    function [Result, NotOK] = getNumericValueFromValueUI(component)
      %%
      % This method returns a struct containing the data of Value UI including
      % value data in numeric form, that as a string, and unit string.
      % Evaluation is made for the Value property of Value UI if necessary.
      %
      % This method also shows or hides the Info UI according to the data type of Value UI.
      %
      % The returning structure can have the following fields.
      %
      %   NumericValue
      %
      %   - a scalar value
      %   - of type double or simscape.Value
      %
      %   Type
      %
      %   - a scalar string
      %   - "double" or "simscape.Value"
      %
      %   NumericString
      %
      %   - a scalar string
      %   - a simplified representation of NumericValue
      %   - If the NumericValue is a large array or a matrix,
      %     this field contains a string representing the size of the value, such as "1x2x3",
      %     rather than the string of the value itself.
      %
      %   PhysicalUnit
      %
      %   - This field exists only when the Type string is "simscape.Value".
      %   - a scalar string
      %   - basically, this is string(simscape.Unit(SIMSCAPE_VALUE)).

      arguments (Output)
        Result (1,1) struct
        NotOK (1,1) logical
      end  % arguments

      Result = struct;
      component.HasError = false;
      component.ErrorMessage = "";

      original_value_ui_string = component.ValueEditFieldUI.Value;
      if original_value_ui_string == ""
        component.HasError = true;
        component.ErrorMessage = "Value must be non-empty.";
        NotOK = true;

        return

      end  % if

      try
        % Evaluation of a MATLAB expression in the Value UI.
        % The value string is evaluated by MATLAB within the following line.
        Result = CodeTool1.getDoubleOrSimscapeValueFromString(original_value_ui_string);
      catch exception
        component.HasError = true;
        component.ErrorMessage = exception.message;
        NotOK = true;

        return

      end  % try, catch

      component.current_numeric_value = Result.NumericValue;

      if Result.Type == "simscape.Value"

        failed = checkUnitConsistency(component, Result);
        if failed
          NotOK = true;

          return

        end  % if error
      end  % if

      % -----------------------------------------------------------------------
      % Info UI - show or hide

      % Convert a string like "a,b,  c  ,d , ,,   e" to "a,b,c,d,e".
      pat = asManyOfPattern(whitespacePattern, 1) + optionalPattern(",");
      cleaned_value_ui_string = replace(original_value_ui_string, pat, ",");

      % Reduce consecutive commas into a single comma.
      pat = asManyOfPattern(",", 2);
      cleaned_value_ui_string = replace(cleaned_value_ui_string, pat, ",");

      if cleaned_value_ui_string == Result.NumericString
        % Hide the Info UI.
        component.InfoUI.Value = "";
        component.InfoUI.MainEditField.Tooltip = "";
        component.RowContainer.ColumnWidth{3} = 0;
      else
        % Show the evaluation result in the Info UI.
        component.InfoUI.Value = Result.NumericString;
        component.InfoUI.MainEditField.Tooltip = Result.NumericString;
        component.RowContainer.ColumnWidth{3} = component.InfoUIWidth;
      end  % if

      NotOK = false;
    end  % function

    function NotOK = checkUnitConsistency(component, result)
      %%
      % This checks that the unit of the new evaluation result in Value UI is
      % consistent with the existing unit states.
      % If an inconsistency is found, an error is returned.

      if component.OnlyOneUnitItem
        % Unit is fixed. User cannot change the unti (by design) unless it is commensurate.
        if result.PhysicalUnit ~= "1" && component.simscape_unit_string == "1"
          component.HasError = true;
          component.ErrorMessage = "Only ""1"" is accepted for the unit when the current unit is ""1"".";
          NotOK = true;

          return

        end  % if

        current_unit = simscape.Unit(component.simscape_unit_string);
        new_unit = simscape.Unit(result.PhysicalUnit);
        if not(simscape.isCommensurateUnit(current_unit, new_unit))
          component.HasError = true;
          component.ErrorMessage = ...
            "New unit (" + result.PhysicalUnit + ") must be commensurate with the current unit (" + ...
            component.simscape_unit_string + ").";
          NotOK = true;

          return

        end  % if

      else
        % User can change unit from the drop down list.
        % (List items are guaranteed to be commensurate.)
        if not(ismember(result.PhysicalUnit, component.UnitDropDownUI.Items))
          component.HasError = true;
          component.ErrorMessage = "New unit (" + result.PhysicalUnit + ") must exist in the list (" + ...
            join(component.UnitDropDownUI.Items, ", ") + ").";
          NotOK = true;

          return

        end  % if
      end  % if, component.OnlyOneUnitItem

      component.HasError = false;
      component.ErrorMessage = "";
      NotOK = false;
    end  % function

  end  % methods

end  % classdef
