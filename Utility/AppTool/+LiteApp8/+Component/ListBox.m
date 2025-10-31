classdef ListBox < LiteApp8.Component.ComponentBase
  % List box component

  % Copyright 2023-2025 The MathWorks, Inc.

  properties
    MainListBox matlab.ui.control.ListBox

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"
    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "fit"
  end  % properties

  properties (Access=private)
    main_grid matlab.ui.container.GridLayout
  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)
    % ValueChanged event adds ValueChangedFcn property to this class.
    ValueChanged
  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.Padding = [1 0 1 0];
      component.main_grid.ColumnSpacing = 1;
      component.main_grid.RowSpacing = 1;
      component.main_grid.Scrollable = "on";

      % The main element of this component.
      component.MainListBox = uilistbox(component.main_grid);
      component.MainListBox.Layout.Row = 1;
      component.MainListBox.Layout.Column = 1;
      component.MainListBox.FontSize = component.CommonFontSize;
      component.MainListBox.ValueChangedFcn = @(sourceObject, eventData) react_ValueChanged(component);

      % Default settings
      component.MainListBox.Items = ["Item 1", "Item 2"];
      component.MainListBox.Multiselect = "off";
    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.main_grid.RowHeight{1} = component.ComponentHeight;
      component.main_grid.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.main_grid.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.main_grid.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods

  methods (Access=private)

    function react_ValueChanged(component)
      if not(isempty(component.ValueChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ValueChangedCallback()
      end  % if

      notify(component, "ValueChanged")
      % Make sure to define ValueChanged event.

    end  % function

  end  % methods
end  % classdef
