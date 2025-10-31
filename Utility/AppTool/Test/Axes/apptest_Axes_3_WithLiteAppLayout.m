function App = apptest_Axes_3_WithLiteAppLayout

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");

main_figure.Position(3) = 400;  % width
main_figure.Position(4) = 300;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

% main_grid.Scrollable = "on";

main_layout = LiteApp8.LiteAppLayout(main_grid);

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);

%%
app_row = NewRow(main_layout, app_column);

axes_ui = LiteApp8.Graphics.Axes(NewSlot(main_layout, app_row));  % !test-target

% Make axes UI taller than the app window.
% Vertical scrollbar must appear when the app window appears.
axes_ui.ComponentHeight = main_figure.Position(4) - 10;

main_figure.Visible = "on";
App.Window.MainFigure = main_figure;
end  % function
