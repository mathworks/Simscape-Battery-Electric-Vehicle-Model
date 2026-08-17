classdef DropDown < bevutil1.AppUtil.Component.ComponentBase
  % Drop down component
  %
  % Specify Items for the drop down list.
  % Specify Value to select one of the items.
  %
  % By default, the drop down list is not editable interactively, but
  % it can be modified programmatically.
  %
  % To make the drop down editable interactively, set Editable to "on" before making the app visible.
  % After the app is made visible, Editable cannot be modified.
  % If a new item is interactively added and if it does not exist in the existing items,
  % it is added to the end of the items.
  % (uidropdown does not automatically add a new item to the items.)

  % Copyright 2023-2026 The MathWorks, Inc.

  properties
    errorID = "DropDown:"
  end  % properties
  properties

    MainDropDown matlab.ui.control.DropDown

    % Editable can be specified only once before the app becomes visible.
    % Editable controls interactive editability only.
    % Drop down items can be added or removed programmatically regardless of Editable.
    Editable (1,1) matlab.lang.OnOffSwitchState

    ValueChangedCallback {bevutil1.CodeUtil.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = "1x"

    % The width of the main drop down component.
    % Make sure that this is the same as or smaller than ComponentWidth (no error check is done by design.)
    DropDownWidth (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = "1x"

    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline++"}

    % Make the drop down height slightly slim to make sure the whole height of the drop down is visible.
    DropDownHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline+"} - 2

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
  properties

    initialized (1,1) logical = false

    % To see outputs from class constructors, you must set Reporting to "on" here.
    % Setting Reporting to "on" in other ways do not enable reporting from constructors.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if

      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x', 'fit', '1x'};
      component.main_grid.Padding = [1 2 1 2];  % left bottom right top
      component.main_grid.ColumnSpacing = 1;
      component.main_grid.RowSpacing = 0;

      % The main element of this component.
      component.MainDropDown = uidropdown(component.main_grid);
      component.MainDropDown.Layout.Row = 2;
      component.MainDropDown.Layout.Column = 2;
      component.MainDropDown.FontSize = component.CommonFontSize;
      component.MainDropDown.ValueChangedFcn = @(sourceObject, eventData) dropdownValueChanged(component);

      % Default settings
      component.Items = ["Item 1" "Item 2"];
      component.Value = "Item 1";
    end  % function

    function update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if
      update@bevutil1.AppUtil.Component.ComponentBase(component)
      if component.initialized
        regular_update(component)

        return

      end  % if
      first_update(component)
      regular_update(component)
      component.initialized = true;
    end  % function

    function first_update(component)
      %%
      % This function is called only once after the setup finished and
      % public properties have been updated with the user-specified values.
      % Use this method to freeze property values based on the user-specified ones.
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if

      % Allow setting component.Editable only once.
      % Obviously, it is still possible to change component.MainDropDown.Editable.
      component.MainDropDown.Editable = component.Editable;

    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

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
    end  % function

  end  % methods

  methods

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

  end  % methods

  methods (Access=private)

    function dropdownValueChanged(component)
      if component.MainDropDown.Editable
        selected_value = strip(string(component.MainDropDown.Value));
        if not(ismember(selected_value, component.MainDropDown.Items))
          component.MainDropDown.Items = [component.MainDropDown.Items(:); selected_value];
        end  % if
      end  % if

      if not(isempty(component.ValueChangedCallback))
        % If not empty, the property validation guarantees that it is a function handle.
        component.ValueChangedCallback()
      end  % if

      notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods
end  % classdef
