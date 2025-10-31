function App = TextArea_testapp_1

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end

main_figure = uifigure(Visible="off");

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

LiteApp5.Component.TextArea(main_grid);  % !test-target

main_figure.Visible = "on";

App.Window.MainFigure = main_figure;
end  % function
