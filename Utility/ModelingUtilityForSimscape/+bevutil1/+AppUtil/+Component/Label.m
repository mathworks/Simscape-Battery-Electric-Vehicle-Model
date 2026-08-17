classdef Label < bevutil1.AppUtil.Component.ComponentBase
  % Label component with the LaTeX interpreter "on" by default
  %
  % See the documentation for the supported LaTeX commands.
  % https://www.mathworks.com/help/matlab/matlab_prog/insert-equations.html#bvak56c-1

  % Copyright 2023-2026 The MathWorks, Inc.

  properties
    MainLabel (1,1) matlab.ui.control.Label

    ComponentWidth (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = "1x"
    ComponentHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline++"}
  end  % properties

  properties (Dependent)
    Text (1,1) string

    FontSize (1,1) {mustBeInteger, mustBePositive}

    % For detailed descriptions about interpreters, see the documentation.
    % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.label-properties.html
    Interpreter (1,1) {mustBeMember(Interpreter, ["latex", "none"])}

    WordWrap (1,1) matlab.lang.OnOffSwitchState

    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])}
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])}
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.Padding = [4 0 4 0];  % left bottom right top
      component.main_grid.ColumnSpacing = 0;
      component.main_grid.RowSpacing = 0;

      % The main element of this component.
      component.MainLabel = uilabel(component.main_grid);
      component.MainLabel.Layout.Row = 1;
      component.MainLabel.Layout.Column = 1;
      component.MainLabel.FontSize = component.CommonFontSize;

      % Default settings.
      component.ComponentWidth = "1x";
      component.ComponentHeight = bevutil1.AppUtil.Constant.Height{"oneline++"};
      component.VerticalAlignment = "center";
      component.HorizontalAlignment = "left";

      % Default settings of the dependent properties.
      component.WordWrap = "off";
      component.Interpreter = "latex";
      component.Text = "Label";
    end  % function

    function update(component)
      %%
      update@bevutil1.AppUtil.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;
    end  % function

  end  % methods

  methods

    function x = get.HorizontalAlignment(component)
      x = string(component.MainLabel.HorizontalAlignment);
    end  % function

    function set.HorizontalAlignment(component, x)
      arguments
        component
        x (1,1) {mustBeMember(x, ["left", "center", "right"])}
      end
      component.MainLabel.HorizontalAlignment = char(x);
    end  % function

    function x = get.VerticalAlignment(component)
      x = string(component.MainLabel.VerticalAlignment);
    end  % function

    function set.VerticalAlignment(component, x)
      arguments
        component
        x (1,1) {mustBeMember(x, ["top", "center", "bottom"])}
      end
      component.MainLabel.VerticalAlignment = char(x);
    end  % function

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
