function App = EditableDropDown_testapp_1
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 500;  % width
main_figure.Position(4) = 300;  % height
main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

%%

editable_drop_down_ui = LiteApp8.Component.EditableDropDown(main_grid);  % !test-target

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EditableDropDownUI = editable_drop_down_ui;
end % if
end  % function
