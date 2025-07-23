classdef EnabledButton < LiteApp6.Component.LiteAppComponentBase
  %% Composite UI component for button with check box

  % Copyright 2024-2025 The MathWorks, Inc.

  properties (Dependent)

    ButtonText (1,1) string
    ButtonEnable (1,1) matlab.lang.OnOffSwitchState
    ButtonDisable (1,1) matlab.lang.OnOffSwitchState

    CheckBoxText (1,1) string
    CheckBoxTooltip (1,1) string

  end  % properties

  properties

    ButtonPushedCallback {LiteApp6.Utility.mustBeFunctionHandleOrEmpty} = []

    CheckBoxValueChangedCallback {LiteApp6.Utility.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = "1x"
    HorizontalAlignment (1,1) {mustBeMember(HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Height{"oneline++"}
    VerticalAlignment (1,1) {mustBeMember(VerticalAlignment, ["top", "center", "bottom"])} = "center"

    ButtonUIWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Width{"unitwidth"} * 11
    ButtonWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Width{"unitwidth"} * 10
    ButtonHeight (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Height{"oneline+"}

    CheckBoxUIWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Width{"unitwidth"} * 9
    CheckBoxWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Width{"unitwidth"} * 8
    % There is no CheckBoxHeight property.
    % The height of the main check box is fixed by uicheckbox.

    ButtonUI LiteApp6.Component.Button
    CheckBoxUI LiteApp6.Component.CheckBox {mustBeScalarOrEmpty}

    compositeGrid matlab.ui.container.GridLayout
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
      setup@LiteApp6.Component.LiteAppComponentBase(component)

      component.compositeGrid = uigridlayout(component.baseGridObject, [1 1]);
      component.compositeGrid.Layout.Row = 1;
      component.compositeGrid.Layout.Column = 1;
      component.compositeGrid.Padding = 0;  % Padding is set in LiteApp components below.
      component.compositeGrid.ColumnSpacing = component.CommonColumnSpacing * 2;
      component.compositeGrid.ColumnWidth = {'1x', 'fit', 'fit', '1x'};
      component.compositeGrid.RowSpacing = 0;

      % -----------------------------------------------------------------------
      % Button
      component.ButtonUI = LiteApp6.Component.Button(component.compositeGrid);
      component.ButtonUI.Layout.Row = 1;
      component.ButtonUI.Layout.Column = 2;
      component.ButtonUI.MainButton.ButtonPushedFcn = @(sourceObject, eventData) buttonPushed(component);
      component.ButtonUI.MainButton.Interpreter = "latex";

      % -----------------------------------------------------------------------
      % Check box
      component.CheckBoxUI = LiteApp6.Component.CheckBox(component.compositeGrid);
      component.CheckBoxUI.Layout.Row = 1;
      component.CheckBoxUI.Layout.Column = 3;
      component.CheckBoxUI.MainCheckBox.ValueChangedFcn = @(sourceObject, eventData) checkboxValueChanged(component);

      % -----------------------------------------------------------------------
      % Default settings

      component.ButtonUI.MainButton.Text = "Button 1";
      component.CheckBoxUI.MainCheckBox.Text = "Disable 2";
      component.CheckBoxUI.MainCheckBox.Tooltip = "";

      component.CheckBoxUI.Value = false;  % Must be off by default to avoid trigerring callback unexpectedly.

    end  % function

    function update(component)
      %%
      update@LiteApp6.Component.LiteAppComponentBase(component)

      % -----------------------------------------------------------------------
      % base grid

      component.baseGridObject.RowHeight = component.ComponentHeight;
      component.baseGridObject.ColumnWidth = component.ComponentWidth;

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
          component.compositeGrid.ColumnWidth = {0, 'fit', 'fit', '1x'};
        case "center"
          component.compositeGrid.ColumnWidth = {'1x', 'fit', 'fit', '1x'};
        case "right"
          component.compositeGrid.ColumnWidth = {'1x', 'fit', 'fit', 0};
      end  % switch

      if component.HighlightBackground
        component.compositeGrid.BackgroundColor = component.HighlightBackgroundColor;

        component.ButtonUI.HighlightBackground = "on";
        component.ButtonUI.BackgroundColor = component.HighlightBackgroundColor;

        component.CheckBoxUI.HighlightBackground = "on";
        component.CheckBoxUI.BackgroundColor = component.HighlightBackgroundColor;
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
    %%

    function buttonPushed(component)
      %%
      if not(isempty(component.ButtonPushedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ButtonPushedCallback()
      end  %if

      notify(component, "ButtonPushed")
      % Make sure to define ButtonPushed event.

    end  % function

    function checkboxValueChanged(component)
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
