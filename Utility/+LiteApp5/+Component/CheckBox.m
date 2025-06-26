classdef CheckBox < LiteApp5.Component.LiteAppComponentBase
  %% Check box component

  % Copyright 2023-2024 The MathWorks, Inc.

  properties

    MainCheckBox matlab.ui.control.CheckBox

    ValueChangedCallback {LiteApp5.Utility.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = "1x"
    CheckBoxWidth (1,:) {LiteApp5.Utility.mustBeTextOrPositiveInteger} = "fit"
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "left"

    ComponentHeight (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = LiteApp5.Utility.Constant.Height{"oneline++"}
    % Check box height is not configurable, i.e., it is constant.
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    % True for checked. False for unchecked.
    Value (1,1) logical

    Text (1,1) string

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp5.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.RowHeight = {'1x', 'fit', '1x'};
      component.gridObj.ColumnWidth = {0, 'fit', '1x'};
      component.gridObj.Padding = component.CommonPadding;
      component.gridObj.ColumnSpacing = component.CommonColumnSpacing;
      component.gridObj.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainCheckBox = uicheckbox(component.gridObj);
      component.MainCheckBox.Layout.Row = 2;
      component.MainCheckBox.Layout.Column = 2;
      component.MainCheckBox.FontSize = component.CommonFontSize;
      component.MainCheckBox.ValueChangedFcn = ...
        @(sourceObject, eventData) checkboxValueChanged(component);
      component.MainCheckBox.WordWrap = "off";

      % -----------------------------------------------------------------------
      % Default settings

      component.Value = false;
      component.Text = "Check box";

    end  % function

    function update(component)
      %%
      update@LiteApp5.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.gridObj.RowHeight = {0, 'fit', '1x'};
        case "center"
          component.gridObj.RowHeight = {'1x', 'fit', '1x'};
        case "bottom"
          component.gridObj.RowHeight = {'1x', 'fit', 0};
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.gridObj.ColumnWidth = {0, component.CheckBoxWidth, '1x'};
        case "center"
          component.gridObj.ColumnWidth = {'1x', component.CheckBoxWidth, '1x'};
        case "right"
          component.gridObj.ColumnWidth = {'1x', component.CheckBoxWidth, 0};
      end  % switch

      if component.HighlightBackground
        component.gridObj.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

  methods

    % -------------------------------------------------------------------------

    function on_off = get.Value(component)
      arguments (Output)
        on_off (1,1) matlab.lang.OnOffSwitchState
      end
      on_off = component.MainCheckBox.Value;
    end  % function

    function set.Value(component, on_off)
      arguments (Input)
        component
        on_off (1,1) matlab.lang.OnOffSwitchState
      end
      component.MainCheckBox.Value = on_off;
    end  % function

    % -------------------------------------------------------------------------

    function txt = get.Text(component)
      arguments (Output)
        txt (1,1) string
      end
      txt = component.MainCheckBox.Text;
    end  % function

    function set.Text(component, txt)
      arguments (Input)
        component
        txt (1,1) string
      end
      component.MainCheckBox.Text = txt;
    end  % function

  end  % methods

  properties (Access=private, Transient, NonCopyable)
    gridObj matlab.ui.container.GridLayout
  end  % properties

  methods (Access=private)

    function checkboxValueChanged(component)

      if not(isempty(component.ValueChangedCallback)) ...
          && isa(component.ValueChangedCallback, 'function_handle')
        component.ValueChangedCallback()
      end

      notify(component, "CheckBoxValueChanged")
      % Make sure to define CheckBoxValueChanged event.

    end  % function

  end  % methods

  events (HasCallbackProperty, NotifyAccess=protected)

    % CheckBoxValueChanged event adds CheckBoxValueChangedFcn property to this class.
    % This event is created when check box is either checked or unchecked.
    CheckBoxValueChanged

  end  % events

end  % classdef
