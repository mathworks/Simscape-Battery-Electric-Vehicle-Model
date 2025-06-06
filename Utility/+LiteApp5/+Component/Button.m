classdef Button < LiteApp5.Component.LiteAppComponentBase
  %% Button component

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainButton (1,1) matlab.ui.control.Button

    ButtonPushedCallback {LiteApp5.Utility.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = "1x"
    ButtonWidth (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = LiteApp5.Utility.Constant.Width{"unitwidth"} * 10
    HorizontalAlignment (1,1) {mustBeMember( HorizontalAlignment, ["left", "center", "right"])} = "center"

    ComponentHeight (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = LiteApp5.Utility.Constant.Height{"oneline++"}
    ButtonHeight (1,:) {LiteApp5.Utility.mustBeTextOrPositiveNumber} = LiteApp5.Utility.Constant.Height{"oneline+"}
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    Text (1,1) string

    % Icon image to show in button. This property supports uibutton's predefined icons only.
    % For more information, see the documentation about Icon property of uibutton.
    Icon (1,1) string {mustBeMember(Icon, ["none", "question", "info", "success", "warning", "error"])}

    Enable (1,1) matlab.lang.OnOffSwitchState

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp5.Component.LiteAppComponentBase(component)

      component.gridObj = uigridlayout(component.baseGridObject);
      component.gridObj.Layout.Row = 1;
      component.gridObj.Layout.Column = 1;
      component.gridObj.RowHeight = {'1x', 'fit', '1x'};
      component.gridObj.ColumnWidth = {'1x', 'fit', '1x'};
      component.gridObj.Padding = component.CommonPadding;
      component.gridObj.ColumnSpacing = component.CommonColumnSpacing;
      component.gridObj.RowSpacing = component.CommonRowSpacing;

      % The main element of this component.
      component.MainButton = uibutton(component.gridObj);
      component.MainButton.Layout.Row = 2;
      component.MainButton.Layout.Column = 2;
      component.MainButton.ButtonPushedFcn = @(sourceObject, eventData) buttonPushed(component);
      component.MainButton.FontSize = component.CommonFontSize;
      component.MainButton.Interpreter = "latex";

      % -----------------------------------------------------------------------
      % Default settings

      component.Text = "Button";
      component.Icon = "none";
      component.Enable = "on";

    end  % function

    function update(component)
      %%
      update@LiteApp5.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      switch component.VerticalAlignment
        case "top"
          component.gridObj.RowHeight = {0, component.ButtonHeight, '1x'};
        case "center"
          component.gridObj.RowHeight = {'1x', component.ButtonHeight, '1x'};
        case "bottom"
          component.gridObj.RowHeight = {'1x', component.ButtonHeight, 0};
      end  % switch

      switch component.HorizontalAlignment
        case "left"
          component.gridObj.ColumnWidth = {  0,  component.ButtonWidth, '1x'};
        case "center"
          component.gridObj.ColumnWidth = {'1x', component.ButtonWidth, '1x'};
        case "right"
          component.gridObj.ColumnWidth = {'1x', component.ButtonWidth,   0 };
      end  % switch

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
      x = string(component.MainButton.Text);
    end  % function

    function set.Text(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      component.MainButton.Text = x;
    end  % function

    % -------------------------------------------------------------------------

    function x = get.Icon(component)
      arguments (Output)
        x (1,1) string
      end
      tmp = string(component.MainButton.Icon);
      if tmp == ""
        x = "none";
      else
        x = tmp;
      end
    end  % function

    function set.Icon(component, x)
      arguments (Input)
        component
        x (1,1) string {mustBeMember(x, ["none", "question", "info", "success", "warning", "error"])}
      end
      if x == "none"
        component.MainButton.Icon = "";
      else
        component.MainButton.Icon = x;
      end
    end  % function

    % -------------------------------------------------------------------------

    function x = get.Enable(component)
      arguments (Output)
        x (1,1) matlab.lang.OnOffSwitchState
      end
      x = component.MainButton.Enable;
    end  % function

    function set.Enable(component, x)
      arguments (Input)
        component
        x (1,1) matlab.lang.OnOffSwitchState
      end
      component.MainButton.Enable = x;
    end  % function

  end  % methods

  properties (Access=private, Transient, NonCopyable)
    gridObj matlab.ui.container.GridLayout
  end  % properties

  methods (Access=private)
    function buttonPushed(component)
      if not(isempty(component.ButtonPushedCallback)) ...
          && isa(component.ButtonPushedCallback, 'function_handle')
        component.ButtonPushedCallback()
      end
    end  % function
  end  % methods

end  % classdef
