classdef TextArea < AppUtil1.Component.ComponentBase
  % Text area component

  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % This component uses string for text content (Value).
  % uitextarea uses the cell array of char array.

  % !todo: Add context menu for copying and pasting text.
  % uicontextmenu needs to take an object of uifigure.

  % Copyright 2023-2026 The MathWorks, Inc.

  properties

    MainTextArea matlab.ui.control.TextArea

    ValueChangedCallback {CodeUtil1.mustBeFunctionHandleOrEmpty} = []

    UseMonospacedFont (1,1) matlab.lang.OnOffSwitchState = "off"

    ComponentWidth (1,1) {CodeUtil1.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {CodeUtil1.mustBeStringOrPositiveInteger} = "fit"

  end  % properties

  properties (Dependent)

    % Value property of the uitextarea is char or string.
    % ValueString property here provides string-only data.
    ValueString string

  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      setup@AppUtil1.Component.ComponentBase(component)

      component.base_grid.RowHeight = {'fit'};
      component.base_grid.ColumnWidth = {'1x'};
      component.base_grid.Padding = [1 0 1 0];
      component.base_grid.ColumnSpacing = 1;
      component.base_grid.RowSpacing = 1;
      component.base_grid.Scrollable = "on";

      % The main element of this component.
      component.MainTextArea = uitextarea(component.main_grid);
      component.MainTextArea.Layout.Row = 1;
      component.MainTextArea.Layout.Column = 1;
      component.MainTextArea.FontSize = component.CommonFontSize;
      component.MainTextArea.ValueChangedFcn = ...
        @(sourceObject, eventData) textareaValueChanged(component);
      component.MainTextArea.WordWrap = "on";
      component.MainTextArea.Editable = "on";
      component.MainTextArea.Placeholder = "Enter text.";

      % -----------------------------------------------------------------------
      % Default settings

      component.ValueString = "";

    end  % function

    function update(component)
      %%
      update@AppUtil1.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      if component.UseMonospacedFont
        component.MainTextArea.FontName = "Monospaced";
      else
        component.MainTextArea.FontName = "Arial";
      end  % if

      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.MainTextArea.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.MainTextArea.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods

  methods

    % =========================================================================
    % Text Area

    function x = get.ValueString(component)
      arguments (Output)
        x (:,1) string
      end  % arguments
      x = string(component.MainTextArea.Value);
    end  % function

    function set.ValueString(component, x)
      arguments
        component
        x (:,1) string
      end  % arguments
      component.MainTextArea.Value = x;

      % Also call this class' value-changed function.
      textareaValueChanged(component)
    end  % function

  end  % methods

  methods (Access=private)

    function textareaValueChanged(component)

      if not(isempty(component.ValueChangedCallback)) ...
          && isa(component.ValueChangedCallback, 'function_handle')
        component.ValueChangedCallback()
      end  % if

      notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods

end  % classdef
