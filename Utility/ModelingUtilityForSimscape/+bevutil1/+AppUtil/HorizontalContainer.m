classdef HorizontalContainer < handle
  % Horizontal container for grid layouts
  %
  % This class provides a container for uigridlayouts to place UI components
  % from left to right. Calling the addHorizontalGridLayout function creates
  % a uigridlayout which is placed on the right of the current uigridlyaout.
  %
  % By default, the width of a UI component is configured to be "1x".
  % The height of a component is configured to be "fit".
  %
  % Documentation about uigridlayout
  % https://www.mathworks.com/help/matlab/ref/uigridlayout.html
  %
  % This class replaces the RowLayout class.
  % Do not use the RowLayout class. Instead, use this class.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties
    BaseGridLayout (:,1) matlab.ui.container.GridLayout
    CurrentColumn (1,1) {mustBeInteger, mustBeNonnegative} = 0
  end  % properties

  methods

    function container = HorizontalContainer(parent)
      %%
      arguments (Input)
        parent {mustBeA(parent, ["matlab.ui.Figure", "matlab.ui.container.GridLayout"])}
      end  % arguments

      container.BaseGridLayout = uigridlayout(parent, [1, 1]);
      container.BaseGridLayout.ColumnWidth{1} = "1x";
      container.BaseGridLayout.RowHeight{1} = "fit";
      container.BaseGridLayout.Padding = [0 0 0 0];
      container.BaseGridLayout.RowSpacing = 0;
      container.BaseGridLayout.ColumnSpacing = 0;
      container.BaseGridLayout.Scrollable = "off";
    end  % function

    function NewHorizontalGridLayout = addHorizontalGridLayout(container, NameValuePair)
      %%
      arguments (Input)
        container
        NameValuePair.Width (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "1x"
      end  % arguments

      arguments (Output)
        NewHorizontalGridLayout (1,1) matlab.ui.container.GridLayout
      end  % arguments

      % Grow horizontally.
      container.CurrentColumn = container.CurrentColumn + 1;

      container.BaseGridLayout.ColumnWidth{container.CurrentColumn} = NameValuePair.Width;

      NewHorizontalGridLayout = uigridlayout(container.BaseGridLayout, [1 1]);
      NewHorizontalGridLayout.Layout.Row = 1;
      NewHorizontalGridLayout.Layout.Column = container.CurrentColumn;
      NewHorizontalGridLayout.ColumnWidth{1} = NameValuePair.Width;
      NewHorizontalGridLayout.RowHeight{1} = "fit";
      NewHorizontalGridLayout.Padding = [0 0 0 0];
      NewHorizontalGridLayout.RowSpacing = 0;
      NewHorizontalGridLayout.ColumnSpacing = 0;
      NewHorizontalGridLayout.Scrollable = "off";
    end  % function

  end  % methods
end  % classdef
