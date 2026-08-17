classdef EditField < bevutil1.AppUtil.Component.ComponentBase
  %% Edit field component

  % Copyright 2023-2026 The MathWorks, Inc.

  properties

    MainEditField matlab.ui.control.EditField

    ValueChangedCallback {bevutil1.CodeUtil.mustBeFunctionHandleOrEmpty} = []

    ReadOnly (1,1) matlab.lang.OnOffSwitchState = "off"

    ComponentWidth (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = "1x"

    ComponentHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline++"}
    EditFieldHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline+"}
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    Value (1,1) string

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x'};
      component.main_grid.Padding = [1 0 1 0];  % left bottom right top
      component.main_grid.ColumnSpacing = 1;
      component.main_grid.RowSpacing = 0;

      % The main element of this component.
      component.MainEditField = uieditfield(component.main_grid);
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
      update@bevutil1.AppUtil.Component.ComponentBase(component)

      component.MainEditField.Editable = not(component.ReadOnly);

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.main_grid.RowHeight = {   0, component.EditFieldHeight, '1x'};
        case "center"
          component.main_grid.RowHeight = {'1x', component.EditFieldHeight, '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', component.EditFieldHeight,   0 };
      end  % switch
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

  methods (Access=private)

    function editfieldValueChanged(component)
      if not(isempty(component.ValueChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ValueChangedCallback()
      end  % if

      % notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods

  events (HasCallbackProperty, NotifyAccess=protected)

    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged

  end  % events

end  % classdef
