function App = apptest_DropDown_1
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 300;  % width
main_figure.Position(4) = 100;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

%%

drop_down_ui = LiteApp8.Component.DropDown(main_grid);  % !test-target
drop_down_ui.MainFigure = main_figure;

%%
main_figure.Visible = "on";

drawnow
main_figure.Theme = "light";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.DropDownUI = drop_down_ui;
end % if
end  % function
