classdef Hyperlink < LiteApp8.Component.ComponentBase
  % Hyperlink component

  % This components is based on uihyperlink.
  % https://www.mathworks.com/help/matlab/ref/uihyperlink.html

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainHyperlink matlab.ui.control.Hyperlink

    HyperlinkClickedCallback {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "1x";
    HyperlinkWidth (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = "fit";
    HorizontalAlignment (1,1) {mustBeMember(HorizontalAlignment, ["left", "center", "right"])} = "left"

    ComponentHeight (1,:) {CodeTool1.mustBeTextOrPositiveNumber} = LiteApp8.Constant.Height{"oneline++"};
    % HyperlinkHeight is fixed at 'fit'.
    VerticalAlignment (1,1) {mustBeMember( VerticalAlignment, ["top", "center", "bottom"])} = "center"

    % The main grid is used to configure the width of the main component
    % while the base grid is used to configure the width of the whole component.
    main_grid (1,1) matlab.ui.container.GridLayout

  end  % properties

  properties (Dependent)

    Text (1,1) string

    % When the hyperlink is clicked, the web site specified by URL opens in a new browser tab.
    % If HyperlinkClickedCallback is specified, it is safe to leave URL unspecified.
    URL (1,1) string

    % If Tooltip is "" (a 0-length string) and URL is not "",
    % URL is set to Tooltip.
    % This behavior is the same as uihyperlink.
    Tooltip (1,1) string

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

      % The main element of this component.
      component.MainHyperlink = uihyperlink(component.main_grid);
      component.MainHyperlink.Layout.Row = 2;
      component.MainHyperlink.Layout.Column = 2;
      component.MainHyperlink.FontSize = component.CommonFontSize;
      component.MainHyperlink.HyperlinkClickedFcn = @(souceObject, eventData) component.HyperlinkClickedCallback();

      % Default settings.
      component.Text = "Hyperlink text";
      component.URL = "";
      component.Tooltip = "";
      component.VerticalAlignment = "center";
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
          component.main_grid.ColumnWidth = {0, component.HyperlinkWidth, '1x'};
        case "center"
          component.main_grid.ColumnWidth = {'1x', component.HyperlinkWidth, '1x'};
        case "right"
          component.main_grid.ColumnWidth = {'1x', component.HyperlinkWidth, 0};
      end  % switch

      if component.HighlightBackground
        switch component.Theme
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
      x = string(component.MainHyperlink.Text);
    end  % function

    function set.Text(component, x)
      arguments (Input)
        component
        x (1,1) string
      end  % arguments
      component.MainHyperlink.Text = x;
    end  % function

    function x = get.URL(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainHyperlink.URL);
    end  % function

    function set.URL(component, x)
      arguments (Input)
        component
        x (1,1) string
      end  % arguments
      component.MainHyperlink.URL = x;
      % If Tooltip is "" (a 0-length string) and URL is not "",
      % URL is set to Tooltip.
      % This behavior is the same as uihyperlink.
      if x ~= "" && component.Tooltip == ""
        component.MainHyperlink.Tooltip = x;
      end  % if
    end  % function

    function x = get.Tooltip(component)
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = string(component.MainHyperlink.Tooltip);
    end  % function

    function set.Tooltip(component, x)
      arguments (Input)
        component
        x (1,1) string
      end  % arguments
      % If Tooltip is "" (a 0-length string) and URL is not "",
      % URL is set to Tooltip.
      % This behavior is the same as uihyperlink.
      if x == "" && component.URL ~= ""
        component.MainHyperlink.Tooltip = component.URL;
      else
        component.MainHyperlink.Tooltip = x;
      end  % if
    end  % function

  end  % methods
end  % classdef
