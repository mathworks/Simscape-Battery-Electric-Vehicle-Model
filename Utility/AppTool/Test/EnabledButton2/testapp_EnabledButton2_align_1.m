function App = testapp_EnabledButton2_align_1
% Test alignment with other UI components.
%
% This test does not automate the inspection process.
% You must visually inspect the alignment.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
App.Window.MainFigure = main_figure;

main_figure.Position(3) = 300;  % width
main_figure.Position(4) = 100;  % height
% main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

main_layout = LiteApp7.LiteAppLayout(main_grid);

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

button_ui = LiteApp7.Component.Button(NewSlot(main_layout, app_row, Width="fit"));
button_ui.Text = "Stand alone";

checkbox_ui = LiteApp7.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

ebutton2_ui = LiteApp8.Component.EnabledButton2(NewSlot(main_layout, app_row));
ebutton2_ui.ButtonText = "Composite";
ebutton2_ui.HorizontalAlignment = "left";
ebutton2_ui.CheckBoxText = "See if this long text is diplayed as expected.";

%%
main_figure.Visible = "on";
end  % function
