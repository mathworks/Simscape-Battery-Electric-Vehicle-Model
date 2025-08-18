classdef Hyperlink < LiteApp7.Component.LiteAppComponentBase
  %% Hyperlink component

  % This components is based on uihyperlink.
  %   https://www.mathworks.com/help/matlab/ref/uihyperlink.html

  % Copyright 2023-2024 The MathWorks, Inc.

  properties

    MainHyperlink matlab.ui.control.Hyperlink

    HyperlinkClickedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x";
    HyperlinkWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit";
    HorizontalAlignment (1,1) {mustBeMember(HorizontalAlignment, ["left", "center", "right"])} = "left"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp7.Constant.Height{"oneline"};
    % HyperlinkHeight does not exist.
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

  end  % properties

  properties (Dependent)

    HyperlinkText (1,1) string

    URL (1,1) string

    % If Tooltip is "" (a 0-length string) and URL is not "",
    % URL is set to Tooltip.
    % This behavior is the same as uihyperlink.
    Tooltip (1,1) string

    WordWrap (1,1) matlab.lang.OnOffSwitchState

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight = {'fit'};
      component.baseGridObject.ColumnWidth = {0, 'fit', '1x'};
      component.baseGridObject.Padding = [4 0 4 0];  % left bottom right top

      % The main element of this component.
      component.MainHyperlink = uihyperlink(component.baseGridObject);
      component.MainHyperlink.Layout.Row = 1;
      component.MainHyperlink.Layout.Column = 2;
      component.MainHyperlink.FontSize = component.CommonFontSize;
      component.MainHyperlink.HyperlinkClickedFcn = ...
        @(souceObject, eventData) component.HyperlinkClickedCallback();

      % -----------------------------------------------------------------------
      % Default settings

      component.HyperlinkText = "Hyperlink text";
      component.URL = "";
      component.Tooltip = "";
      component.WordWrap = "off";
      component.VerticalAlignment = "center";

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      component.MainHyperlink.VerticalAlignment = char(component.VerticalAlignment);

      switch component.HorizontalAlignment
      case "left"
        component.baseGridObject.ColumnWidth = {   0, component.HyperlinkWidth, '1x'};
      case "center"
        component.baseGridObject.ColumnWidth = {'1x', component.HyperlinkWidth, '1x'};
      case "right"
        component.baseGridObject.ColumnWidth = {'1x', component.HyperlinkWidth,    0};
      end  % switch
    end  % function

  end  % methods

  methods

    % -------------------------------------------------------------------------

    function x = get.HyperlinkText(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainHyperlink.Text);
    end  % function

    function set.HyperlinkText(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      component.MainHyperlink.Text = x;
    end  % function

    % -------------------------------------------------------------------------

    function x = get.URL(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainHyperlink.URL);
    end  % function

    function set.URL(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      component.MainHyperlink.URL = x;
      % If Tooltip is "" (a 0-length string) and URL is not "",
      % URL is set to Tooltip.
      % This behavior is the same as uihyperlink.
      if x ~= "" && component.Tooltip == ""
        component.MainHyperlink.Tooltip = x;
      end  % if
    end  % function

    % -------------------------------------------------------------------------

    function x = get.Tooltip(component)
      arguments (Output)
        x (1,1) string
      end
      x = string(component.MainHyperlink.Tooltip);
    end  % function

    function set.Tooltip(component, x)
      arguments (Input)
        component
        x (1,1) string
      end
      % If Tooltip is "" (a 0-length string) and URL is not "",
      % URL is set to Tooltip.
      % This behavior is the same as uihyperlink.
      if x == "" && component.URL ~= ""
        component.MainHyperlink.Tooltip = component.URL;
      else
        component.MainHyperlink.Tooltip = x;
      end  % if
    end  % function

    % -------------------------------------------------------------------------

    function x = get.WordWrap(component)
      arguments (Output)
        x (1,1) string
      end
      x = component.MainHyperlink.WordWrap;
    end  % function

    function set.WordWrap(component, x)
      arguments (Input)
        component
        x (1,1) matlab.lang.OnOffSwitchState
      end
      component.MainHyperlink.WordWrap = x;
    end  % function

  end  % methods

end  % classdef
