function App = apptest_Align_EditField_DropDown_1_horizontal
% Test alignment of editfield and dropdown.
%
% This test does not automate the inspection process.
% You must visually inspect the alignment.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");

main_figure.Position(3) = 300;  % width
main_figure.Position(4) = 200;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

main_layout = LiteApp8.LiteAppLayout(main_grid);

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);

app_row = NewRow(main_layout, app_column);
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainFigure = main_figure;
editfield_ui.MainEditField.Placeholder = "(edit field)";

app_row = NewRow(main_layout, app_column);
dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.MainFigure = main_figure;
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

app_row = NewRow(main_layout, app_column);
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainFigure = main_figure;
editfield_ui.MainEditField.Placeholder = "(edit field)";

app_row = NewRow(main_layout, app_column);
dropdown_ui = LiteApp8.Component.EditableDropDown(NewSlot(main_layout, app_row));
dropdown_ui.MainFigure = main_figure;
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

app_row = NewRow(main_layout, app_column);
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainFigure = main_figure;
editfield_ui.MainEditField.Placeholder = "(edit field)";

%%
main_figure.Visible = "on";

drawnow
main_figure.Theme = "light";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function
