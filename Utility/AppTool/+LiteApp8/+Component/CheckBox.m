classdef CheckBox < LiteApp8.Component.ComponentBase
  % Check box component
  %
  % This component wraps uicheckbox.
  %
  % Use ComponentWidth and ComponentHeight to specify the size of this component.
  % Use CheckBoxWidth to specify the width of the button within this component.
  % ComponentHeight is the height of the check box.
  %
  % Use HorizontalAlignment and VerticalAlignment to position the check box within the component.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties
    MainCheckBox matlab.ui.control.CheckBox

    ValueChangedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    CheckBoxWidth (1,:) {CodeTool1.mustBeTextOrPositiveInteger} = "fit"
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "left"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Height{"oneline++"}
    % Check box height is not configurable, i.e., it is constant.
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

    % The main grid is used to configure the width of the main component
    % while the base grid is used to configure the width of the whole component.
    main_grid (1,1) matlab.ui.container.GridLayout
  end  % properties

  properties (Dependent)
    % True for checked. False for unchecked.
    Value (1,1) logical

    Text (1,1) string
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {0, 'fit', '1x'};
      component.main_grid.Padding = component.CommonPadding;
      component.main_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.main_grid.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainCheckBox = uicheckbox(component.main_grid);
      component.MainCheckBox.Layout.Row = 2;
      component.MainCheckBox.Layout.Column = 2;
      component.MainCheckBox.ValueChangedFcn = @(sourceObject, eventData) react_CheckboxValueChanged(component);
      component.MainCheckBox.FontSize = component.CommonFontSize;
      component.MainCheckBox.WordWrap = "off";

      % Default settings.
      component.Value = false;
      component.Text = "Check box";
    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.main_grid.RowHeight = {0, 'fit', '1x'};
        case "center"
          component.main_grid.RowHeight = {'1x', 'fit', '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', 'fit', 0};
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.main_grid.ColumnWidth = {0, component.CheckBoxWidth, '1x'};
        case "center"
          component.main_grid.ColumnWidth = {'1x', component.CheckBoxWidth, '1x'};
        case "right"
          component.main_grid.ColumnWidth = {'1x', component.CheckBoxWidth, 0};
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

    function on_off = get.Value(component)
      arguments (Output)
        on_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      on_off = component.MainCheckBox.Value;
    end  % function

    function set.Value(component, on_off)
      arguments (Input)
        component
        on_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      component.MainCheckBox.Value = on_off;
    end  % function

    function txt = get.Text(component)
      arguments (Output)
        txt (1,1) string
      end  % arguments
      txt = component.MainCheckBox.Text;
    end  % function

    function set.Text(component, txt)
      arguments (Input)
        component
        txt (1,1) string
      end  % arguments
      component.MainCheckBox.Text = txt;
    end  % function

  end  % methods

  methods (Access=private)

    function react_CheckboxValueChanged(component)
      if not(isempty(component.ValueChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ValueChangedCallback()
      end  % if
    end  % function

  end  % methods
end  % classdef
