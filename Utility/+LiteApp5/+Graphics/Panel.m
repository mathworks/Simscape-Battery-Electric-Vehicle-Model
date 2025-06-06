classdef Panel < LiteApp5.Component.LiteAppComponentBase
  %% Panel component for graphics
  % Use this as a container of graphics UI components.
  % For non-graphics components, use LiteApp5.Component.Panel.
  %
  % This is a large component.
  % - Both width and height must be adjustable.
  % - Scrollbars must appear as needed.

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainPanel (1,1) matlab.ui.container.Panel

    ComponentWidth (1,1) {LiteApp5.Utility.mustBeStringOrPositiveInteger} = "1x"

    ComponentHeight (1,1) {LiteApp5.Utility.mustBeStringOrPositiveInteger} = 200

    % "line" and "none" are valid for uifigure. Other options only work with figure.
    BorderType {mustBeMember(BorderType, ["line" "none"])} = "none"

  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp5.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight = {'fit'};
      component.baseGridObject.ColumnWidth = {'1x'};
      component.baseGridObject.Padding = [0 0 0 0];  % left bottom right top
      component.baseGridObject.ColumnSpacing = 0;
      component.baseGridObject.RowSpacing = 0;
      component.baseGridObject.Scrollable = "on";

      % The main element of this component.
      component.MainPanel = uipanel(component.baseGridObject);
      component.MainPanel.Layout.Row = 1;
      component.MainPanel.Layout.Column = 1;
      component.MainPanel.Title= "";
      component.MainPanel.FontSize = component.CommonFontSize;

      % Panle's AutoResizeChildren must be off when the panel contains graphics.
      component.MainPanel.AutoResizeChildren = "off";

    end  % function

    function update(component)
      %%
      update@LiteApp5.Component.LiteAppComponentBase(component)

      component.baseGridObject.RowHeight{1} = component.ComponentHeight;
      component.baseGridObject.ColumnWidth{1} = component.ComponentWidth;

      component.MainPanel.BorderType = component.BorderType;

      if component.HighlightBackground
        component.MainPanel.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
