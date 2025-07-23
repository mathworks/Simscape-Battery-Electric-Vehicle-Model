classdef TextArea < LiteApp6.Component.LiteAppComponentBase
  %% Text area component
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % This component uses string for text content (Value).
  % uitextarea uses the cell array of char array.

  % [todo] Add context menu for copying and pasting text.
  % uicontextmenu needs to take an object of uifigure, but
  % Classes inheriting from ComponentContainer cannot access uifigure object.
  % -> Maybe possible with ancestor() or findobj()

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainTextArea matlab.ui.control.TextArea

    ValueChangedCallback {LiteApp6.Utility.mustBeFunctionHandleOrEmpty} = []

    UseMonospacedFont (1,1) matlab.lang.OnOffSwitchState = "off"

    ComponentWidth (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "fit"

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
      setup@LiteApp6.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight = {'fit'};
      component.baseGridObject.ColumnWidth = {'1x'};
      component.baseGridObject.Padding = [1 0 1 0];
      component.baseGridObject.ColumnSpacing = 1;
      component.baseGridObject.RowSpacing = 1;
      component.baseGridObject.Scrollable = "on";

      % The main element of this component.
      component.MainTextArea = uitextarea(component.baseGridObject);
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
      update@LiteApp6.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      if component.UseMonospacedFont
        component.MainTextArea.FontName = "Monospaced";
      else
        component.MainTextArea.FontName = "Arial";
      end  % if

      if component.HighlightBackground
        component.baseGridObject.BackgroundColor = component.HighlightBackgroundColor;
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
