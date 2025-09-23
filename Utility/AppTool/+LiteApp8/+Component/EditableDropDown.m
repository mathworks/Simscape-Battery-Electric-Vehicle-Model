classdef EditableDropDown < LiteApp8.Component.ComponentBase
  % Editable drop down component
  %
  % This drop down component adds a value to the drop down items if the value
  % does not exist in the items.
  % The uidropdown with Editable="on" does not do so.

  % Copyright 2025 The MathWorks, Inc.

  properties

    MainDropDown matlab.ui.control.DropDown

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    DropDownWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline++"}
    DropDownHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline+"}
    % uidropdown has VerticalAlignment property, but it is for the alignment of icon and text within a drop down button.
    % The VerticalAlignment property of this class is for the alignment of the main element within its parent component.
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    % Items and Value of this class are aliases of uidropdown's Items and Value.
    % Difference is that they are a string array and a string respectively in this class
    % while they are a cell array of char array and a char array in uidropdown, respectively.
    Items (1,:) string
    Value (1,1) string

  end  % properties

  properties (Access=private, Transient, NonCopyable)
    main_grid matlab.ui.container.GridLayout
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x', 'fit', '1x'};
      component.main_grid.Padding = component.CommonPadding;
      component.main_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.main_grid.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainDropDown = uidropdown(component.main_grid);
      component.MainDropDown.Layout.Row = 2;
      component.MainDropDown.Layout.Column = 2;
      component.MainDropDown.FontSize = component.CommonFontSize;
      component.MainDropDown.ValueChangedFcn = @(sourceObject, eventData) dropdownValueChanged(component);
      component.MainDropDown.Editable = "on";

      % -----------------------------------------------------------------------
      % Default settings

      component.Items = ["Item 1" "Item 2"];
      component.Value = "Item 1";

    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.main_grid.RowHeight = {   0, component.DropDownHeight, '1x'};
        case "center"
          component.main_grid.RowHeight = {'1x', component.DropDownHeight, '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', component.DropDownHeight,   0 };
      end  % switch

      if strcmp(component.DropDownWidth, '1x')
        component.main_grid.ColumnWidth = {'1x'};
        component.MainDropDown.Layout.Column = 1;
      else
        component.MainDropDown.Layout.Column = 2;
        switch component.HorizontalAlignment
          case "left"
            component.main_grid.ColumnWidth = {  0,  component.DropDownWidth, '1x'};
          case "center"
            component.main_grid.ColumnWidth = {'1x', component.DropDownWidth, '1x'};
          case "right"
            component.main_grid.ColumnWidth = {'1x', component.DropDownWidth,   0 };
        end  % switch
      end  % if

      if component.HighlightBackground
        switch component.Theme
        case "light"
          component.main_grid.BackgroundColor = component.LightThemeBackGroundColor;
        case "dark"
          component.main_grid.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods

  methods

    % -------------------------------------------------------------------------

    function x = get.Items(component)
      arguments (Output)
        x (:,1) string
      end
      x = string(component.MainDropDown.Items);
    end  % function

    function set.Items(component, x)
      arguments
        component
        x (:,1) string
      end
      component.MainDropDown.Items = cellstr(x);
    end  % function

    % -------------------------------------------------------------------------

    function x = get.Value(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainDropDown.Value);
    end  % function

    function set.Value(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      % This triggers component's ValueChangedFcn.
      component.MainDropDown.Value = char(x);

      % Also call this class' value-changed function.
      dropdownValueChanged(component)
    end  % function

    % -------------------------------------------------------------------------

  end  % methods

  methods (Access=private)

    function dropdownValueChanged(component)
      % dispInfo(component)

      selected_value = strip(string(component.MainDropDown.Value));

      if not(ismember(selected_value, component.MainDropDown.Items))
        component.MainDropDown.Items = [component.MainDropDown.Items(:); selected_value];
      end  % if

      if not(isempty(component.ValueChangedCallback)) && isa(component.ValueChangedCallback, 'function_handle')
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
