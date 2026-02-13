classdef PolarAxes < LiteApp8.Component.ComponentBase
  %% Axes component
  % Use this component to show a ploarplot.
  % The height of this component is fixed.
  % You can specify the height with ComponentHeight property.
  %
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2025 The MathWorks, Inc.

  properties

    MainPloarAxes (1,1) matlab.graphics.axis.PolarAxes

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = 200

    panelUI (1,1) matlab.ui.container.Panel

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight = {'fit'};
      component.base_grid.ColumnWidth = {'1x'};
      component.base_grid.Padding = [0 0 0 0];  % left bottom right top
      component.base_grid.ColumnSpacing = 0;
      component.base_grid.RowSpacing = 0;
      component.base_grid.Scrollable = "on";

      component.panelUI = uipanel(component.base_grid);
      component.panelUI.Layout.Row = 1;
      component.panelUI.Layout.Column = 1;
      component.panelUI.BorderType = "none";
      component.panelUI.Title= "";

      % Panle's AutoResizeChildren must be off when the panel contains polar axes.
      component.panelUI.AutoResizeChildren = "off";

      % The main element of this component.
      component.MainPloarAxes = polaraxes(component.panelUI);

    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        component.panelUI.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
