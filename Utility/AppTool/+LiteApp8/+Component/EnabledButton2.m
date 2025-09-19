classdef EnabledButton2 < LiteApp8.Component.ComponentBase
  % Composite UI component for button with check box, version 2
  %
  % New in this verison
  % - Simplified the way the check box width is handled.
  % - Improved alignment and spacing.
  % - Supports dark/light themes.

  % Copyright 2024-2025 The MathWorks, Inc.

  properties (Dependent)

    ButtonText (1,1) string
    ButtonEnable (1,1) matlab.lang.OnOffSwitchState
    ButtonDisable (1,1) matlab.lang.OnOffSwitchState

    CheckBoxText (1,1) string
    CheckBoxTooltip (1,1) string

  end  % properties

  properties

    ButtonPushedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    CheckBoxValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    HorizontalAlignment (1,1) {mustBeMember(HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline++"}
    VerticalAlignment (1,1) {mustBeMember(VerticalAlignment, ["top", "center", "bottom"])} = "center"

    ButtonUIWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Width{"unitwidth"} * 11
    ButtonWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Width{"unitwidth"} * 10
    ButtonHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline+"}

    CheckBoxUIWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit"
    CheckBoxWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit"
    % There is no CheckBoxHeight property.
    % The height of the main check box is fixed by uicheckbox.

    ButtonUI LiteApp7.Component.Button
    CheckBoxUI LiteApp7.Component.CheckBox {mustBeScalarOrEmpty}

    composite_grid matlab.ui.container.GridLayout

  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % ButtonPushed event adds ButtonPushedFcn property to this class.
    % This event is created when button is pushed.
    ButtonPushed

    % CheckBoxValueChanged event adds CheckBoxValueChangedFcn property to this class.
    % This event is created when check box is either checked or unchecked.
    CheckBoxValueChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.composite_grid = uigridlayout(component.base_grid, [1 1]);
      component.composite_grid.Layout.Row = 1;
      component.composite_grid.Layout.Column = 1;
      component.composite_grid.Padding = [0 0 0 0];  % Padding is set by LiteApp components below.
      component.composite_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.composite_grid.ColumnWidth = {'1x', 'fit', 'fit', '1x'};
      component.composite_grid.RowSpacing = 0;

      % -----------------------------------------------------------------------
      % Button
      component.ButtonUI = LiteApp7.Component.Button(component.composite_grid);
      component.ButtonUI.Layout.Row = 1;
      component.ButtonUI.Layout.Column = 2;
      component.ButtonUI.MainButton.ButtonPushedFcn = @(sourceObject, eventData) react_ButtonPushed(component);
      component.ButtonUI.MainButton.Interpreter = "latex";

      % -----------------------------------------------------------------------
      % Check box
      component.CheckBoxUI = LiteApp7.Component.CheckBox(component.composite_grid);
      component.CheckBoxUI.Layout.Row = 1;
      component.CheckBoxUI.Layout.Column = 3;
      component.CheckBoxUI.MainCheckBox.ValueChangedFcn = @(sourceObject, eventData) react_CheckboxValueChanged(component);

      % -----------------------------------------------------------------------
      % Default settings

      component.ButtonUI.MainButton.Text = "Button";
      component.CheckBoxUI.MainCheckBox.Text = "Disable button";
      component.CheckBoxUI.MainCheckBox.Tooltip = "";

      component.CheckBoxUI.Value = false;  % Must be off in the setup to avoid trigerring callback.

    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      % -----------------------------------------------------------------------
      % base grid

      component.base_grid.RowHeight = component.ComponentHeight;
      component.base_grid.ColumnWidth = component.ComponentWidth;

      % -----------------------------------------------------------------------
      % button

      component.ButtonUI.ComponentHeight = component.ComponentHeight;  % same height as base grid
      component.ButtonUI.ComponentWidth = component.ButtonUIWidth;

      % core button size
      component.ButtonUI.ButtonWidth = component.ButtonWidth;
      component.ButtonUI.ButtonHeight = component.ButtonHeight;

      % -----------------------------------------------------------------------
      % check box

      component.CheckBoxUI.ComponentHeight = component.ComponentHeight;  % same height as base grid
      component.CheckBoxUI.ComponentWidth = component.CheckBoxUIWidth;

      % There is no CheckBoxHeight property.
      % The height of the main/core check box is fixed by uicheckbox.
      component.CheckBoxUI.CheckBoxWidth = component.CheckBoxWidth;

      % -----------------------------------------------------------------------
      % alignment

      % vertical alignment
      component.ButtonUI.VerticalAlignment = component.VerticalAlignment;
      component.CheckBoxUI.VerticalAlignment = component.VerticalAlignment;

      % horizontal alignment
      switch component.HorizontalAlignment
        case "left"
          component.composite_grid.ColumnWidth = {0, 'fit', 'fit', '1x'};
        case "center"
          component.composite_grid.ColumnWidth = {'1x', 'fit', 'fit', '1x'};
        case "right"
          component.composite_grid.ColumnWidth = {'1x', 'fit', 'fit', 0};
      end  % switch

      if component.HighlightBackground
        component.ButtonUI.HighlightBackground = "on";
        component.CheckBoxUI.HighlightBackground = "on";
        % Use gray for the highlighted background of composite grid regardless of
        % the dark/light theme.
        component.composite_grid.BackgroundColor = "#777777";
      else
        component.ButtonUI.HighlightBackground = "off";
        component.CheckBoxUI.HighlightBackground = "off";
      end  % if
    end  % function

  end  % methods

  methods

    % --------------------------------------------------------------------------
    % ButtonText

    function str = get.ButtonText(component)
      %%
      arguments (Output)
        str (1,1) string
      end
      str = component.ButtonUI.Text;
    end  % function

    function set.ButtonText(component, str)
      %%
      arguments (Input)
        component
        str (1,1) string
      end
      component.ButtonUI.Text = str;
    end  % function

    % --------------------------------------------------------------------------
    % CheckBoxText

    function str = get.CheckBoxText(component)
      %%
      arguments (Output)
        str (1,1) string
      end
      str = component.CheckBoxUI.Text;
    end  % function

    function set.CheckBoxText(component, str)
      %%
      arguments (Input)
        component
        str (1,1) string
      end
      component.CheckBoxUI.Text = str;
    end  % function

    % --------------------------------------------------------------------------
    % CheckBoxTooltip

    function str = get.CheckBoxTooltip(component)
      %%
      arguments (Output)
        str (1,1) string
      end
      str = component.CheckBoxUI.Tooltip;
    end  % function

    function set.CheckBoxTooltip(component, str)
      %%
      arguments (Input)
        component
        str (1,1) string
      end
      component.CheckBoxUI.Tooltip = str;
    end  % function

    % --------------------------------------------------------------------------
    % ButtonEnable

    function val = get.ButtonEnable(component)
      %%
      arguments (Output)
        val (1,1) matlab.lang.OnOffSwitchState
      end
      val = not(component.CheckBoxUI.Value);
    end  % function

    function set.ButtonEnable(component, val)
      %%
      arguments (Input)
        component
        val (1,1) matlab.lang.OnOffSwitchState
      end
      component.CheckBoxUI.Value = not(val);
      component.ButtonUI.MainButton.Enable = val;
    end  % function

    % --------------------------------------------------------------------------
    % ButtonDisabled

    function val = get.ButtonDisable(component)
      %%
      arguments (Output)
        val (1,1) matlab.lang.OnOffSwitchState
      end
      val = component.CheckBoxUI.Value;
    end  % function

    function set.ButtonDisable(component, val)
      %%
      arguments (Input)
        component
        val (1,1) matlab.lang.OnOffSwitchState
      end
      component.CheckBoxUI.Value = val;
      component.ButtonUI.MainButton.Enable = not(val);
    end  % function

  end  % methods

  methods (Access=private)
    %% Reactions

    function react_ButtonPushed(component)
      %%
      if not(isempty(component.ButtonPushedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ButtonPushedCallback()
      end  %if

      notify(component, "ButtonPushed")
      % Make sure to define ButtonPushed event.

    end  % function

    function react_CheckboxValueChanged(component)
      %%
      if component.CheckBoxUI.Value
        component.ButtonUI.MainButton.Enable = "off";
      else
        component.ButtonUI.MainButton.Enable = "on";
      end  % if

      if not(isempty(component.CheckBoxValueChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.CheckBoxValueChangedCallback()
      end  % if

      notify(component, "CheckBoxValueChanged")
      % Make sure to define CheckBoxValueChanged event.

    end  % function

  end  % methods

end  % classdef
