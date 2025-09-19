function App = testapp_Label2_1_bare_minimum
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Theme = "dark";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

label_ui = LiteApp8.Component.Label2(main_grid);  % !test-target
label_ui.Theme = main_figure.Theme.BaseColorStyle;

% Highlight the entire area of the test target component.
label_ui.HighlightBackground = "on";

main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EnabledButtonUI = enabled_button_ui;
end % if
end  % function
