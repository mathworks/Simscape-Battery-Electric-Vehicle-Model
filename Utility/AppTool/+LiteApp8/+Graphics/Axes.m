classdef Axes < LiteApp8.Component.ComponentBase
  % Axes component
  %
  % Use this component to show a plot.
  % The height of this component is fixed.
  % You can specify the height with ComponentHeight property.
  %
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2025 The MathWorks, Inc.

  properties
    MainAxes (1,1) matlab.graphics.axis.Axes

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"
    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = 200
  end  % properties

  properties (Access=private)
    % The panel is used as a container of a graphics component.
    panel_ui (1,1) matlab.ui.container.Panel
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.panel_ui = uipanel(component.base_grid);
      component.panel_ui.Layout.Row = 1;
      component.panel_ui.Layout.Column = 1;
      component.panel_ui.BorderType = "none";
      component.panel_ui.Title= "";

      % Panel's AutoResizeChildren must be off when the panel contains axes.
      component.panel_ui.AutoResizeChildren = "off";

      % The main element of this component.
      component.MainAxes = axes(component.panel_ui);
    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
        case "light"
          component.panel_ui.BackgroundColor = component.LightThemeBackGroundColor;
        case "dark"
          component.panel_ui.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods
end  % classdef
