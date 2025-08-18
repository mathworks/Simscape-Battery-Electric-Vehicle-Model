classdef ListBox < LiteApp7.Component.LiteAppComponentBase
  %% List box component
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2023-2024 The MathWorks, Inc.

  properties

    MainListBox matlab.ui.control.ListBox

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "fit"

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject, [1 1]);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.Padding = [1 0 1 0];
      component.gridObj.ColumnSpacing = 1;
      component.gridObj.RowSpacing = 1;
      component.gridObj.Scrollable = "on";

      % The main element of this component.
      component.MainListBox = uilistbox(component.gridObj);
      component.MainListBox.Layout.Row = 1;
      component.MainListBox.Layout.Column = 1;
      component.MainListBox.FontSize = component.CommonFontSize;
      component.MainListBox.ValueChangedFcn = ...
        @(sourceObject, eventData) listboxValueChanged(component);

      % -----------------------------------------------------------------------
      % Default settings

      component.MainListBox.Items = ["Item 1", "Item 2"];
      component.MainListBox.Multiselect = "off";

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      component.gridObj.RowHeight{1} = component.ComponentHeight;
      component.gridObj.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        component.gridObj.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

  properties (Access=private, Transient, NonCopyable)
    gridObj matlab.ui.container.GridLayout
  end

  methods (Access=private)

    function listboxValueChanged(component)

      if not(isempty(component.ValueChangedCallback)) ...
          && isa(component.ValueChangedCallback, 'function_handle')
        component.ValueChangedCallback()
      end

      notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods

  events (HasCallbackProperty, NotifyAccess=protected)

    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged

  end  % events

end  % classdef
