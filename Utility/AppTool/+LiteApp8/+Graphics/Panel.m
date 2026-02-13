classdef Panel < LiteApp8.Component.ComponentBase
  %% Panel component for graphics
  % Use this as a container of graphics UI components.
  % For non-graphics components, use LiteApp8.Component.Panel.
  %
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainPanel (1,1) matlab.ui.container.Panel

    ComponentWidth (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {CodeTool1.mustBeStringOrPositiveInteger} = 200

    % "line" and "none" are valid for uifigure. Other options only work with figure.
    BorderType {mustBeMember(BorderType, ["line" "none"])} = "none"

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

      % The main element of this component.
      component.MainPanel = uipanel(component.base_grid);
      component.MainPanel.Layout.Row = 1;
      component.MainPanel.Layout.Column = 1;
      component.MainPanel.Title= "";
      component.MainPanel.FontSize = component.CommonFontSize;

      % Panle's AutoResizeChildren must be off when the panel contains graphics.
      component.MainPanel.AutoResizeChildren = "off";

    end  % function

    function update(component)
      %%
      update@LiteApp8.Component.ComponentBase(component)

      component.base_grid.RowHeight{1} = component.ComponentHeight;
      component.base_grid.ColumnWidth{1} = component.ComponentWidth;

      component.MainPanel.BorderType = component.BorderType;

      if component.HighlightBackground
        component.MainPanel.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
