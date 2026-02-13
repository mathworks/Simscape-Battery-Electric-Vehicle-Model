classdef StateButton < LiteApp8.Component.ComponentBase
  % State button component

  % Properties of state button
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.statebutton.html

  % Copyright 2025 The MathWorks, Inc.

  properties
    MainButton (1,1) matlab.ui.control.StateButton

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    ButtonWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Width{"unitwidth"} * 10
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Height{"oneline++"}
    ButtonHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Height{"oneline+"}
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"
  end  % properties

  properties (Dependent)
    Value (1,1) logical
    Enable (1,1) matlab.lang.OnOffSwitchState

    Text (1,1) string

    % Icon image to show in button. This property supports uibutton's predefined icons only.
    % For more information, see the documentation about Icon property of uibutton.
    Icon (1,1) string {mustBeMember(Icon, ["none", "question", "info", "success", "warning", "error"])}
  end  % properties

  properties (Access=private)
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

      % The main element of this component
      component.MainButton = uibutton(component.main_grid, "state");
      component.MainButton.Layout.Row = 2;
      component.MainButton.Layout.Column = 2;
      component.MainButton.ValueChangedFcn = @(sourceObject, eventData) react_ValueChanged(component);
      component.MainButton.FontSize = component.CommonFontSize;
      component.MainButton.Interpreter = "latex";

      % Default settings
      component.Enable = "on";
      component.Text = "State button";
      component.Icon = "none";
    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.main_grid.RowHeight = {0, component.ButtonHeight, '1x'};
        case "center"
          component.main_grid.RowHeight = {'1x', component.ButtonHeight, '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', component.ButtonHeight, 0};
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.main_grid.ColumnWidth = {  0,  component.ButtonWidth, '1x'};
        case "center"
          component.main_grid.ColumnWidth = {'1x', component.ButtonWidth, '1x'};
        case "right"
          component.main_grid.ColumnWidth = {'1x', component.ButtonWidth,   0 };
      end  % switch

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

  methods

    function x = get.Enable(component)
      arguments (Output)
        x (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      x = component.MainButton.Enable;
    end  % function

    function set.Enable(component, x)
      arguments (Input)
        component
        x (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      component.MainButton.Enable = x;
    end  % function

    function x = get.Value(component)
      arguments (Output)
        x (1,1) logical
      end  % arguments
      x = component.MainButton.Value;
    end  % function

    function set.Value(component, x)
      arguments (Input)
        component
        x (1,1) logical
      end  % arguments
      component.MainButton.Value = x;
    end  % function

    function x = get.Text(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainButton.Text);
    end  % function

    function set.Text(component, x)
      arguments (Input)
        component
        x (1,1) string
      end  % arguments
      component.MainButton.Text = x;
    end  % function

    function x = get.Icon(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      tmp = string(component.MainButton.Icon);
      if tmp == ""
        x = "none";
      else
        x = tmp;
      end  % if
    end  % function

    function set.Icon(component, x)
      arguments (Input)
        component
        x (1,1) string {mustBeMember(x, ["none", "question", "info", "success", "warning", "error"])}
      end  % arguments
      if x == "none"
        component.MainButton.Icon = "";
      else
        component.MainButton.Icon = x;
      end  % if
    end  % function

  end  % methods

  methods (Access=private)

    function react_ValueChanged(component)
      if not(isempty(component.ValueChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ValueChangedCallback()
      end  % if
    end  % function

  end  % methods
end  % classdef
