classdef DropDown < LiteApp6.Component.LiteAppComponentBase
  %% Drop down component
  % Drop down items must be programatically defined for this class.
  % The uidropdown supports editable list which users can interactively edit
  % while the app is running, but this class does not support it.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainDropDown matlab.ui.control.DropDown

    ValueChangedCallback {LiteApp6.Utility.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = "1x"
    DropDownWidth (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = "1x"
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Height{"oneline++"}
    DropDownHeight (1,:) {LiteApp6.Utility.mustBeTextOrPositiveNumber} = LiteApp6.Utility.Constant.Height{"oneline+"}
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
    gridObj matlab.ui.container.GridLayout
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp6.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.RowHeight = {'1x', 'fit', '1x'};
      component.gridObj.ColumnWidth = {'1x', 'fit', '1x'};
      component.gridObj.Padding = component.CommonPadding;
      component.gridObj.ColumnSpacing = component.CommonColumnSpacing;
      component.gridObj.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainDropDown = uidropdown(component.gridObj);
      component.MainDropDown.Layout.Row = 2;
      component.MainDropDown.Layout.Column = 2;
      component.MainDropDown.FontSize = component.CommonFontSize;
      component.MainDropDown.ValueChangedFcn = ...
        @(sourceObject, eventData) dropdownValueChanged(component);
      component.MainDropDown.Editable = "off";

      % -----------------------------------------------------------------------
      % Default settings

      component.Items = ["Item 1" "Item 2"];
      component.Value = "Item 1";

    end  % function

    function update(component)
      %%
      update@LiteApp6.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.gridObj.RowHeight = {   0, component.DropDownHeight, '1x'};
        case "center"
          component.gridObj.RowHeight = {'1x', component.DropDownHeight, '1x'};
        case "bottom"
          component.gridObj.RowHeight = {'1x', component.DropDownHeight,   0 };
      end  % switch

      if strcmp(component.DropDownWidth, '1x')
        component.gridObj.ColumnWidth = {'1x'};
        component.MainDropDown.Layout.Column = 1;
      else
        component.MainDropDown.Layout.Column = 2;
        switch component.HorizontalAlignment
          case "left"
            component.gridObj.ColumnWidth = {  0,  component.DropDownWidth, '1x'};
          case "center"
            component.gridObj.ColumnWidth = {'1x', component.DropDownWidth, '1x'};
          case "right"
            component.gridObj.ColumnWidth = {'1x', component.DropDownWidth,   0 };
        end  % switch
      end  % if

      if component.HighlightBackground
        component.gridObj.BackgroundColor = component.HighlightBackgroundColor;
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
      % This triggers dropdownObj's ValueChangedFcn.
      component.MainDropDown.Value = char(x);

      % Also call this class' value-changed function.
      dropdownValueChanged(component)
    end  % function

    % -------------------------------------------------------------------------

  end  % methods

  methods (Access=private)

    function dropdownValueChanged(component)
      % dispInfo(component)

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
