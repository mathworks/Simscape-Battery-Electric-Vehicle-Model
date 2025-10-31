function App = CheckBox_testapp_1_bare_minimum
% This test directly uses uifigure and uigridlayout
% instead of LiteApp6.LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2024 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end

main_figure = uifigure(Visible="off");
App.Window.MainFigure = main_figure;

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

check_box_ui = LiteApp6.Component.CheckBox(main_grid);  % !test-target

% Highlight the entire area of the test target component.
check_box_ui.HighlightBackground = "on";

main_figure.Visible = "on";
end  % function
