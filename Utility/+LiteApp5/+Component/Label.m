classdef Label < LiteApp5.Component.LiteAppComponentBase
  %% Label component
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % See supported LaTeX commands
  % https://www.mathworks.com/help/matlab/matlab_prog/insert-equations.html#bvak56c-1

  % Copyright 2023-2024 The MathWorks, Inc.

  properties

    MainLabel matlab.ui.control.Label

    ComponentWidth (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = "1x"

    ComponentHeight (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = LiteApp5.Utility.Constant.Height{"oneline++"}

    TopPadding    (1,1) {mustBeInteger, mustBeNonnegative}
    BottomPadding (1,1) {mustBeInteger, mustBeNonnegative}
    LeftPadding   (1,1) {mustBeInteger, mustBeNonnegative}
    RightPadding  (1,1) {mustBeInteger, mustBeNonnegative}

    gridObj matlab.ui.container.GridLayout
  end  % properties

  properties (Dependent)

    Text (1,1) string

    FontSize (1,1) {mustBeInteger, mustBePositive}

    % For detailed descriptions about interpreters, see the documentation.
    %   https://www.mathworks.com/help/matlab/ref/matlab.ui.control.label-properties.html
    Interpreter (1,1) {mustBeMember(Interpreter, ["latex", "none"])}

    WordWrap (1,1) matlab.lang.OnOffSwitchState

    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])}

    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])}

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp5.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject, [1 1]);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.Padding = [0 0 0 0];  % left bottom right top
      component.gridObj.ColumnSpacing = 0;
      component.gridObj.RowSpacing = 0;
      component.gridObj.Scrollable = "on";

      % The main element of this component.
      component.MainLabel = uilabel(component.gridObj);
      component.MainLabel.Layout.Row = 1;
      component.MainLabel.Layout.Column = 1;
      component.MainLabel.FontSize = component.CommonFontSize;

      % -----------------------------------------------------------------------
      % Default settings

      component.ComponentWidth = "1x";
      component.ComponentHeight = LiteApp5.Utility.Constant.Height{"oneline++"};

      component.LeftPadding = component.CommonPaddingLeft;
      component.RightPadding = component.CommonPaddingRight;
      component.TopPadding = 0;
      component.BottomPadding = 0;

      component.VerticalAlignment = "center";
      component.HorizontalAlignment = "left";

      component.WordWrap = "on";
      component.Interpreter = "latex";
      component.Text = "Label";

    end  % function

    function update(component)
      %%
      update@LiteApp5.Component.LiteAppComponentBase(component)

      component.baseGridObject.Padding = ...
        [component.LeftPadding, component.BottomPadding, component.RightPadding, component.TopPadding];

      component.gridObj.RowHeight{1} = component.ComponentHeight;
      component.gridObj.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        component.gridObj.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

  methods

    % -------------------------------------------------------------------------

    function x = get.Text(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainLabel.Text);
    end  % function

    function set.Text(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      component.MainLabel.Text = x;
    end  % function

    % -------------------------------------------------------------------------

    function x = get.FontSize(component)
      arguments (Output)
        x (1,1) {mustBeInteger, mustBePositive}
      end
      x = component.MainLabel.FontSize;
    end  % function

    function set.FontSize(component, x)
      arguments (Input)
        component
        x (1,1) {mustBeInteger, mustBePositive}
      end
      component.MainLabel.FontSize = x;
    end  % function

    % -------------------------------------------------------------------------

    function x = get.Interpreter(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainLabel.Interpreter);
    end  % function

    function set.Interpreter(component, x)
      arguments (Input)
        component
        x (1,1) {mustBeMember(x, ["latex", "none"])}
      end
      component.MainLabel.Interpreter = x;
    end  % function

    % -------------------------------------------------------------------------

    function state = get.WordWrap(component)
      arguments (Output)
        state (1,1) matlab.lang.OnOffSwitchState
      end
      state = component.MainLabel.WordWrap;
    end  % function

    function set.WordWrap(component, state)
      arguments (Input)
        component
        state (1,1) matlab.lang.OnOffSwitchState
      end
      component.MainLabel.WordWrap = state;
    end  % function

    % -------------------------------------------------------------------------

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

    % -------------------------------------------------------------------------

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

  end  % methods

end  % classdef
