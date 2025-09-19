classdef EditField < LiteApp7.Component.LiteAppComponentBase
  %% Edit field component

  % Copyright 2023-2024 The MathWorks, Inc.

  properties

    MainEditField matlab.ui.control.EditField

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ReadOnly (1,1) matlab.lang.OnOffSwitchState = "off"

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline++"}
    EditFieldHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline+"}
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    Value (1,1) string

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject, [1 1]);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.RowHeight = {'1x', 'fit', '1x'};
      component.gridObj.ColumnWidth = {'1x'};
      component.gridObj.Padding = [1 0 1 0];  % left bottom right top
      component.gridObj.ColumnSpacing = 1;
      component.gridObj.RowSpacing = 0;

      % The main element of this component.
      component.MainEditField = uieditfield(component.gridObj);
      component.MainEditField.Layout.Row = 2;
      component.MainEditField.Layout.Column = 1;
      component.MainEditField.FontSize = component.CommonFontSize;
      component.MainEditField.ValueChangedFcn = ...
        @(sourceObject, eventData) editfieldValueChanged(component);
      component.MainEditField.CharacterLimits = component.CommonCharacterLimits;

      % -----------------------------------------------------------------------
      % Default settings

      component.Value = "";

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      component.MainEditField.Editable = not(component.ReadOnly);

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.gridObj.RowHeight = {   0, component.EditFieldHeight, '1x'};
        case "center"
          component.gridObj.RowHeight = {'1x', component.EditFieldHeight, '1x'};
        case "bottom"
          component.gridObj.RowHeight = {'1x', component.EditFieldHeight,   0 };
      end  % switch

      if component.HighlightBackground
        component.gridObj.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

  methods

    % -------------------------------------------------------------------------

    function x = get.Value(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainEditField.Value);
    end  % function

    function set.Value(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      component.MainEditField.Value = x;
    end  % function

    % -------------------------------------------------------------------------

  end  % methods

  properties (Access=private, Transient, NonCopyable)
    gridObj matlab.ui.container.GridLayout
  end  % properties

  methods (Access=private)

    function editfieldValueChanged(component)
      if not(isempty(component.ValueChangedCallback)) ...
          && isa(component.ValueChangedCallback, 'function_handle')
        component.ValueChangedCallback()
      end  % if

      notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods

  events (HasCallbackProperty, NotifyAccess=protected)

    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged

  end  % events

end  % classdef
