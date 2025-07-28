classdef LiteAppLayout < handle
  %% LiteApp Layout
  % This class implements component placement logic using uigridlayout.
  %
  % There are four key elements in this layout logic: Area, Column, Row, and Slot.
  %
  % Area is the top level element of LiteAppLayout.
  % When you create a LiteAppLayout object, a new Area is created.
  % Areas are added from top to bottom in a window as you call NewArea method.
  % An Area can contain Columns or LiteApp6.Component.
  %
  % Column is the second level element of LiteAppLayout.
  % You can create a Column with NewColumn method.
  % Columns are added from left to right within an Area as you call NewColumn method.
  % A Column can contain Rows or LiteApp6.Component.
  %
  % Row is the third level element of LiteAppLayout.
  % You can create a Row with NewRow method.
  % Rows are added from top to bottom within a Column as you call NewRow method.
  % A Row can contain Slots or LiteApp6.Component.
  %
  % Slot is the fourth level element of LiteAppLayout.
  % You can create a Slot with NewSlot method.
  % Slots are added from left to right within a Row as you call NewSlot method.
  % A Slot can contain LiteApp6.Component.
  %
  % NewColumn and NewSlot can take the Width option.
  % The Width option is passed to uigridlayout as its ColumnWidth property.
  % You can use values that are supported by ColumnWidth,
  % such as "1x", "2x", "fit", 100, 200 etc.
  %
  % LiteAppLayout is one of LiteApp6.Component.
  % Any of Area, Column, Row, and Slot can take a LiteAppLayout object.
  % This lets you create a LiteAppLayout within a LiteAppLayout.
  %
  % Documentation
  %
  % - uigridlayout
  %   https://www.mathworks.com/help/matlab/ref/uigridlayout.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties
    AreaGrid (:,1) matlab.ui.container.GridLayout
    ColumnGrid cell
    RowGrid cell
    SlotGrid cell

    % Integers to build unique address for each grid cell.
    % See GridAddress function.
    A {mustBeInteger, mustBeNonnegative} = 0
    C {mustBeInteger, mustBeNonnegative} = 0
    R {mustBeInteger, mustBeNonnegative} = 0
    S {mustBeInteger, mustBeNonnegative} = 0

    AreaReady (1,1) logical
    ColumnReady (1,1) logical
    RowReady (1,1) logical
  end  % properties

  methods

    function layout = LiteAppLayout(parent)
      %%
      layout.AreaGrid = uigridlayout(parent, [1 1]);
      layout.AreaGrid.ColumnWidth{1} = "1x";
      layout.AreaGrid.RowHeight{1} = "fit";

      layout.AreaGrid.Padding = [0 0 0 0];
      layout.AreaGrid.RowSpacing = 0;
      layout.AreaGrid.ColumnSpacing = 0;

      layout.AreaGrid.Scrollable = "on";

      layout.AreaReady = false;
      layout.ColumnReady = false;
      layout.RowReady = false;
    end  % function

    function addr = GridAddress(layout)
      arguments (Output)
        addr (1,1) string
      end
      addr = layout.A + "." + layout.C + "." + layout.R + "." + layout.S;
    end % function

    function newGrid = NewArea(layout, NameValuePair)
      %%
      arguments (Input)
        layout (1,1)
        NameValuePair.Height (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "fit"
      end
      arguments (Output)
        newGrid (1,1) matlab.ui.container.GridLayout
      end

      layout.A = layout.A + 1;
      newAreaNumber = layout.A;

      layout.C = 0;
      layout.R = 0;
      layout.S = 0;

      layout.AreaReady = true;
      layout.ColumnReady = false;
      layout.RowReady = false;

      currentArea_GridLayout = layout.AreaGrid;

      % Add a new area at the bottom of the current area.
      currentArea_GridLayout.ColumnWidth{1} = "1x";
      currentArea_GridLayout.RowHeight{newAreaNumber} = NameValuePair.Height;

      newGrid = uigridlayout(layout.AreaGrid, [1 1]);
      newGrid.Layout.Row = newAreaNumber;
      newGrid.Layout.Column = 1;
      newGrid.RowHeight = {'fit'};
      newGrid.ColumnWidth = {'1x'};
      newGrid.Padding = [0 0 0 0];
      newGrid.RowSpacing = 0;
      newGrid.ColumnSpacing = 0;
      newGrid.UserData = "area";

      layout.ColumnGrid{newAreaNumber} = newGrid;
    end  % function

    function newGrid = NewColumn(layout, currentGrid, NameValuePair)
      %%
      arguments (Input)
        layout (1,1)
        currentGrid (1,1) matlab.ui.container.GridLayout
        % The Width option is passed to uigridlayout as ColumnWidth property.
        % You can pass values as long as it is supported by ColumnWidth,
        % such as "1x", "2x", "fit", 100, 200 etc.
        NameValuePair.Width (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "1x"
      end
      arguments (Output)
        newGrid (1,1) matlab.ui.container.GridLayout
      end

      currentAreaNumber = layout.A;

      layout.C = layout.C + 1;
      newColumnNumber = layout.C;

      layout.R = 0;
      layout.S = 0;

      if not(layout.AreaReady)
        error("Area must be ready before creating Column.")
      end
      layout.ColumnReady = true;
      layout.RowReady = false;

      currentAreaColumn_GridLayout = currentGrid;

      % Add a new column on the right in the current area.
      currentAreaColumn_GridLayout.ColumnWidth{newColumnNumber} = NameValuePair.Width;
      currentAreaColumn_GridLayout.RowHeight{1} = "fit";

      newGrid = uigridlayout(currentAreaColumn_GridLayout, [1 1]);
      newGrid.Layout.Row = 1;
      newGrid.Layout.Column = newColumnNumber;
      newGrid.RowHeight = {'fit'};
      newGrid.ColumnWidth = {'1x'};
      newGrid.Padding = [0 0 0 0];
      newGrid.RowSpacing = 0;
      newGrid.ColumnSpacing = 0;
      newGrid.UserData = "column";

      layout.RowGrid{currentAreaNumber, newColumnNumber} = newGrid;
    end  % function

    function newGrid = NewRow(layout, currentGrid, NameValuePair)
      %%
      arguments (Input)
        layout (1,1)
        currentGrid (1,1) matlab.ui.container.GridLayout
        NameValuePair.Height (1,1) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "fit"
      end
      arguments (Output)
        newGrid (1,1) matlab.ui.container.GridLayout
      end

      currentAreaNumber = layout.A;
      currentColumnNumber = layout.C;

      layout.R = layout.R + 1;
      newRowNumber = layout.R;

      layout.S = 0;

      if not(layout.AreaReady && layout.ColumnReady)
        error("Area and Column must be ready before creating Row.")
      end
      layout.RowReady = true;

      currentAreaColumnRow_GridLayout = currentGrid;

      % Add a new row at the bottom in the current column.
      currentAreaColumnRow_GridLayout.ColumnWidth{1} = "1x";
      currentAreaColumnRow_GridLayout.RowHeight{newRowNumber} = NameValuePair.Height;

      newGrid = uigridlayout(currentAreaColumnRow_GridLayout, [1 1]);
      newGrid.Layout.Row = newRowNumber;
      newGrid.Layout.Column = 1;
      newGrid.RowHeight = {'fit'};
      newGrid.ColumnWidth = {'1x'};
      newGrid.Padding = [0 0 0 0];
      newGrid.RowSpacing = 0;
      newGrid.ColumnSpacing = 0;
      newGrid.UserData = "row";

      layout.SlotGrid{currentAreaNumber, currentColumnNumber, newRowNumber} = newGrid;
    end  % function

    function newGrid = NewSlot(layout, currentGrid, NameValuePair)
      %%
      arguments (Input)
        layout (1,1)
        currentGrid (1,1) matlab.ui.container.GridLayout
        % The Width option is passed to uigridlayout as ColumnWidth property.
        % You can pass values as long as it is supported by ColumnWidth,
        % such as "1x", "2x", "fit", 100, 200 etc.
        NameValuePair.Width (1,:) {LiteApp6.Utility.mustBeStringOrPositiveInteger} = "1x"
      end
      arguments (Output)
        newGrid (1,1) matlab.ui.container.GridLayout
      end

      layout.S = layout.S + 1;
      newSlotNumber = layout.S;

      if not(layout.AreaReady && layout.ColumnReady && layout.RowReady)
        error("Area, Column, and Row must be ready before creating Slot.")
      end

      currentAreaColumnRowSlot_GridLayout = currentGrid;

      % Add a new element slot on the right in the current row.
      currentAreaColumnRowSlot_GridLayout.ColumnWidth{newSlotNumber} = NameValuePair.Width;
      currentAreaColumnRowSlot_GridLayout.RowHeight{1} = "fit";

      newGrid = uigridlayout(currentAreaColumnRowSlot_GridLayout, [1 1]);
      newGrid.Layout.Row = 1;
      newGrid.Layout.Column = newSlotNumber;
      newGrid.RowHeight = {'fit'};
      newGrid.ColumnWidth = {'1x'};
      newGrid.Padding = [0 0 0 0];
      newGrid.RowSpacing = 0;
      newGrid.ColumnSpacing = 0;
      newGrid.UserData = "slot";
    end  % function

  end  % methods
end  % classdef
