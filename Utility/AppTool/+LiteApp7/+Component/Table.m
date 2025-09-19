classdef Table < LiteApp7.Component.LiteAppComponentBase
  %% Table component
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.
  %
  % Table Properties
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.control.table-properties.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    MainTable matlab.ui.control.Table

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "fit"

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight = {'fit'};
      component.baseGridObject.ColumnWidth = {'1x'};
      component.baseGridObject.Padding = [1 0 1 0];  % left bottom right top
      component.baseGridObject.ColumnSpacing = 1;
      component.baseGridObject.RowSpacing = 1;
      component.baseGridObject.Scrollable = "on";

      % The main element of this component.
      component.MainTable = uitable(component.baseGridObject);
      component.MainTable.Layout.Row = 1;
      component.MainTable.Layout.Column = 1;
      component.MainTable.FontSize = component.CommonFontSize;

      % -----------------------------------------------------------------------
      % Default settings

      component.MainTable.Data = zeros(2, 2);

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        component.baseGridObject.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
