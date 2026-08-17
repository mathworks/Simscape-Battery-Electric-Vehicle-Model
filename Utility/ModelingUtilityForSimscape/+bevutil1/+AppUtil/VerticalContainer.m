classdef VerticalContainer < handle
  % Vertical container for grid layouts
  %
  % This class provides a container for uigridlayouts to stack UI components
  % from top to bottom. Calling the addVerticalGridLayout function creates
  % a uigridlayout which is placed below the current uigridlyaout.
  %
  % By default, the width of a UI component is configured to be "1x".
  % The height of a component is configured to be "fit".
  %
  % Documentation about uigridlayout
  % https://www.mathworks.com/help/matlab/ref/uigridlayout.html
  %
  % This class replaces the ColumnLayout class.
  % Do not use the ColumnLayout class. Instead, use this class.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties
    BaseGridLayout (1,1) matlab.ui.container.GridLayout
    CurrentRow (1,1) {mustBeInteger, mustBeNonnegative} = 0
  end  % properties

  methods

    function container = VerticalContainer(parent)
      %%
      arguments (Input)
        parent (1,1) {mustBeA(parent, ["matlab.ui.Figure", "matlab.ui.container.GridLayout"])}
      end  % arguments

      container.BaseGridLayout = uigridlayout(parent, [1, 1]);
      container.BaseGridLayout.ColumnWidth{1} = "1x";
      container.BaseGridLayout.RowHeight{1} = "fit";
      container.BaseGridLayout.Padding = [0 0 0 0];
      container.BaseGridLayout.RowSpacing = 0;
      container.BaseGridLayout.ColumnSpacing = 0;
      container.BaseGridLayout.Scrollable = "on";
    end  % function

    function NewVerticalGridLayout = addVerticalGridLayout(container, NameValuePair)
      %%
      arguments (Input)
        container
        NameValuePair.Height (1,1) {bevutil1.CodeUtil.mustBeStringOrPositiveInteger} = "fit"
        NameValuePair.Empty (1,1) logical = false
      end  % arguments

      arguments (Output)
        NewVerticalGridLayout (1,1) matlab.ui.container.GridLayout
      end  % arguments

      % Grow vertically.
      container.CurrentRow = container.CurrentRow + 1;

      container.BaseGridLayout.RowHeight{container.CurrentRow} = NameValuePair.Height;

      if NameValuePair.Empty
        clear NewVerticalGridLayout

        return

      end  % if

      NewVerticalGridLayout = uigridlayout(container.BaseGridLayout, [1 1]);
      NewVerticalGridLayout.Layout.Row = container.CurrentRow;
      NewVerticalGridLayout.Layout.Column = 1;
      NewVerticalGridLayout.ColumnWidth{1} = "1x";
      NewVerticalGridLayout.RowHeight{1} = NameValuePair.Height;
      NewVerticalGridLayout.Padding = [0 0 0 0];
      NewVerticalGridLayout.RowSpacing = 0;
      NewVerticalGridLayout.ColumnSpacing = 0;
      NewVerticalGridLayout.Scrollable = "off";
    end  % function

  end  % methods
end  % classdef
