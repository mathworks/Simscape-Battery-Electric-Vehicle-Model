classdef Button < bev1mus.AppUtil.Component.ComponentBase
  % Button component
  %
  % The Text property uses the LaTeX interpreter by default.
  %
  % This component wraps uibutton and provides the button's width and height
  % as separate properties from the component's width and height.
  %
  % Use ComponentWidth and ComponentHeight to specify the size of this component.
  % Use ButtonWidth and ButtonHeight to specify the size of the button within this component.
  %
  % Use HorizontalAlignment and VerticalAlignment to position the button within the component.

  % Copyright 2023-2026 The MathWorks, Inc.

  properties
    MainButton (1,1) matlab.ui.control.Button

    ButtonPushedCallback {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = "1x"
    ButtonWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Width{"unitwidth"} * 10
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Height{"oneline++"}
    ButtonHeight (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Height{"oneline+"}
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"
  end  % properties

  properties (Dependent)
    Text (1,1) string

    % Icon image to show in button. This property supports uibutton's predefined icons only.
    % For more information, see the documentation about Icon property of uibutton.
    Icon (1,1) string {mustBeMember(Icon, ["none", "question", "info", "success", "warning", "error"])}
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bev1mus.AppUtil.Component.ComponentBase(component)

      component.main_grid = uigridlayout(component.base_grid);
      component.main_grid.Layout.Row = 1;
      component.main_grid.Layout.Column = 1;
      component.main_grid.RowHeight = {'1x', 'fit', '1x'};
      component.main_grid.ColumnWidth = {'1x', 'fit', '1x'};
      component.main_grid.Padding = component.CommonPadding;
      component.main_grid.ColumnSpacing = component.CommonColumnSpacing;
      component.main_grid.RowSpacing = component.CommonRowSpacing;

      % The main element of this component
      component.MainButton = uibutton(component.main_grid);
      component.MainButton.Layout.Row = 2;
      component.MainButton.Layout.Column = 2;
      component.MainButton.ButtonPushedFcn = @(sourceObject, eventData) react_ButtonPushed(component);
      component.MainButton.FontSize = component.CommonFontSize;
      if not(isMATLABReleaseOlderThan("R2024b"))
        % The Interpreter property is availabe in R2024b and newer.
        % See the Version History of the documentation.
        % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.button.html
        component.MainButton.Interpreter = "latex";
      end  % if

      % Default settings
      component.Text = "Button";
      component.Icon = "none";
    end  % function

    function update(component)
      %%
      update@bev1mus.AppUtil.Component.ComponentBase(component)

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
    end  % function

  end  % methods

  methods

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

    function react_ButtonPushed(component)
      if not(isempty(component.ButtonPushedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.ButtonPushedCallback()
      end  % if
      % To provide ButtonPushedFcn property in this component,
      % call notify(component, "ButtonPushed") here, and define ButtonPushed event variable.
      % This component does not implement it and instead provides simpler ButtonPushedCallback.
    end  % function

  end  % methods
end  % classdef
