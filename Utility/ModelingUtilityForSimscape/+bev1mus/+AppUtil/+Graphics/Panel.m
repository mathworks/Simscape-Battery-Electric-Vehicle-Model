classdef Panel < bev1mus.AppUtil.Component.ComponentBase
  % Panel component for graphics
  %
  % Use this as a container of graphics UI components.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainPanel (1,1) matlab.ui.container.Panel

    ComponentWidth (1,1) {bev1mus.CodeUtil.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {bev1mus.CodeUtil.mustBeStringOrPositiveInteger} = 200

    BorderType {mustBeMember(BorderType, ["line" "none"])} = "none"

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bev1mus.AppUtil.Component.ComponentBase(component)

      % This component does not use the main grid. Instead, the base grid is
      % directly used as the parent of the main component.

      % Modify the base grid's settings.
      % Set RowHeight "fit" and Scrollable "on" to show a vertical scrollbar if
      % the contained graphics is taller than the parent.
      component.base_grid.RowHeight = {'fit'};
      component.base_grid.Scrollable = "on";

      % The main element of this component.
      component.MainPanel = uipanel(component.main_grid);
      component.MainPanel.Layout.Row = 1;
      component.MainPanel.Layout.Column = 1;
      component.MainPanel.Title= "";
      component.MainPanel.FontSize = component.CommonFontSize;

      % Panel's AutoResizeChildren must be off when the panel contains graphics.
      component.MainPanel.AutoResizeChildren = "off";
    end  % function

    function update(component)
      %%
      update@bev1mus.AppUtil.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      component.MainPanel.BorderType = component.BorderType;

      % uipanel has the BackgroundColor property.
      % The BackgroundColor of main grid and base grid do not work because of uipanel's.
      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.MainPanel.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.MainPanel.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods
end  % classdef
