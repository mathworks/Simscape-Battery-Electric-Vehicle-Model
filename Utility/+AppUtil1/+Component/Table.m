classdef Table < AppUtil1.Component.ComponentBase
  % Table component
  %
  % Table Properties
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table-properties.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties
    MainTable matlab.ui.control.Table

    ComponentWidth (1,1) {CodeUtil1.mustBeStringOrPositiveInteger} = "1x"
    ComponentHeight (1,1) {CodeUtil1.mustBeStringOrPositiveInteger} = "fit"
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@AppUtil1.Component.ComponentBase(component)

      component.base_grid.RowHeight = {'fit'};
      component.base_grid.ColumnWidth = {'1x'};
      component.base_grid.Padding = [1 0 1 0];  % left bottom right top
      component.base_grid.ColumnSpacing = 1;
      component.base_grid.RowSpacing = 1;
      component.base_grid.Scrollable = "on";

      % The main element of this component.
      component.MainTable = uitable(component.main_grid);
      component.MainTable.Layout.Row = 1;
      component.MainTable.Layout.Column = 1;
      component.MainTable.FontSize = component.CommonFontSize;

      % -----------------------------------------------------------------------
      % Default settings

      component.MainTable.Data = zeros(2, 2);

    end  % function

    function update(component)
      %%
      update@AppUtil1.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.MainTable.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.MainTable.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods
end  % classdef
