classdef Label < LiteApp8.Component.ComponentBase
  % Label component with the LaTeX interpreter "on" by default
  %
  % See the documentation for the supported LaTeX commands.
  % https://www.mathworks.com/help/matlab/matlab_prog/insert-equations.html#bvak56c-1
  %
  % The vertical and horizontal alignment of the main component (uilabel)
  % is handled by uigridlayout, rather than using uilabel's alignment properties.
  % This gives consistent alignment behavior with other components.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties
    MainLabel (1,1) matlab.ui.control.Label

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x"
    LabelWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit"
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "left"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Height{"oneline++"}
    LabelHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit"
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"
  end  % properties

  properties (Dependent)
    Text (1,1) string

    FontSize (1,1) {mustBeInteger, mustBePositive}

    % For detailed descriptions about interpreters, see the documentation.
    % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.label-properties.html
    Interpreter (1,1) {mustBeMember(Interpreter, ["latex", "none"])}

    WordWrap (1,1) matlab.lang.OnOffSwitchState
  end  % properties

  properties (Access=public)
    % The main grid is used to configure the width of the main component
    % while the base grid is used to configure the width of the whole component.
    main_grid (1,1) matlab.ui.container.GridLayout
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x', 'fit', '1x'};
      component.main_grid.Padding = component.CommonPadding;
      component.main_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.main_grid.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainLabel = uilabel(component.main_grid);
      component.MainLabel.Layout.Row = 2;
      component.MainLabel.Layout.Column = 2;
      component.MainLabel.FontSize = component.CommonFontSize;

      % Default settings of the dependent properties.
      component.WordWrap = "off";
      component.Interpreter = "latex";
      component.Text = "Label";
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
          component.main_grid.RowHeight = {'1x','fit', '1x'};
        case "bottom"
          component.main_grid.RowHeight = {'1x', 'fit', 0};
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.main_grid.ColumnWidth = {0,  component.LabelWidth, '1x'};
        case "center"
          component.main_grid.ColumnWidth = {'1x', component.LabelWidth, '1x'};
        case "right"
          component.main_grid.ColumnWidth = {'1x', component.LabelWidth, 0};
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

    function x = get.Text(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainLabel.Text);
    end  % function

    function set.Text(component, x)
      arguments (Input)
        component
        x (1,1) string
      end  % arguments
      component.MainLabel.Text = x;
    end  % function

    function x = get.FontSize(component)
      arguments (Output)
        x (1,1) {mustBeInteger, mustBePositive}
      end  % arguments
      x = component.MainLabel.FontSize;
    end  % function

    function set.FontSize(component, x)
      arguments (Input)
        component
        x (1,1) {mustBeInteger, mustBePositive}
      end  % arguments
      component.MainLabel.FontSize = x;
    end  % function

    function x = get.Interpreter(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainLabel.Interpreter);
    end  % function

    function set.Interpreter(component, x)
      arguments (Input)
        component
        x (1,1) {mustBeMember(x, ["latex", "none"])}
      end  % arguments
      component.MainLabel.Interpreter = x;
    end  % function

    function state = get.WordWrap(component)
      arguments (Output)
        state (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      state = component.MainLabel.WordWrap;
    end  % function

    function set.WordWrap(component, state)
      arguments (Input)
        component
        state (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      component.MainLabel.WordWrap = state;
    end  % function

  end  % methods
end  % classdef
