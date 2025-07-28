classdef PolarAxes < LiteApp6.Component.LiteAppComponentBase
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

    ComponentWidth (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = 200

    panelUI (1,1) matlab.ui.container.Panel

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp6.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight = {'fit'};
      component.baseGridObject.ColumnWidth = {'1x'};
      component.baseGridObject.Padding = [0 0 0 0];  % left bottom right top
      component.baseGridObject.ColumnSpacing = 0;
      component.baseGridObject.RowSpacing = 0;
      component.baseGridObject.Scrollable = "on";

      component.panelUI = uipanel(component.baseGridObject);
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
      update@LiteApp6.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      if component.HighlightBackground
        component.panelUI.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
