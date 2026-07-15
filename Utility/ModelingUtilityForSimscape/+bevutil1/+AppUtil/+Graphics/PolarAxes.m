classdef PolarAxes < bevutil1.AppUtil.Component.ComponentBase
  %% Axes component
  % Use this component to show a polarplot.
  % The height of this component is fixed.
  % You can specify the height with ComponentHeight property.
  %
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties

    MainPolarAxes (1,1) matlab.graphics.axis.PolarAxes

    ComponentWidth (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = 200

    panel_ui (1,1) matlab.ui.container.Panel

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      % Modify the base grid's settings.
      % Set RowHeight "fit" and Scrollable "on" to show a vertical scrollbar if
      % the contained graphics is taller than the parent.
      component.base_grid.RowHeight = {'fit'};
      component.base_grid.Scrollable = "on";

      component.panel_ui = uipanel(component.main_grid);
      component.panel_ui.Layout.Row = 1;
      component.panel_ui.Layout.Column = 1;
      component.panel_ui.Title= "";
      component.panel_ui.FontSize = component.CommonFontSize;

      % Panel's AutoResizeChildren must be off when the panel contains graphics.
      component.panel_ui.AutoResizeChildren = "off";

      % The main element of this component.
      component.MainPolarAxes = polaraxes(component.panel_ui);

    end  % function

    function update(component)
      %%
      update@bevutil1.AppUtil.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      % uipanel has the BackgroundColor property.
      % The BackgroundColor of main grid and base grid do not work because of uipanel's.
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
