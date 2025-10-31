function App = apptest_Label_1_simplest
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout
% to keep the dependency of this code minimal.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 200;  % width
main_figure.Position(4) = 100;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

%%

label_ui = LiteApp8.Component.Label(main_grid);  % !test-target
label_ui.MainFigure = main_figure;

% Highlight the entire area of the test target component for visual inspection.
label_ui.HighlightBackground = "on";

%%
main_figure.Visible = "on";

drawnow
main_figure.Theme = "light";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end % if
end  % function
