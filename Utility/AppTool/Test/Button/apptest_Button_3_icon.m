function App = Button_testapp_3_icon
% Test the Icon property of the component.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

width_unit = LiteApp8.Constant.Width{"unitwidth"};
common_width = width_unit * 10;

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 500;  % width
main_figure.Position(4) = 100;  % height

main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

app_layout = LiteApp8.LiteAppLayout(main_grid);
app_area = NewArea(app_layout);
app_column = NewColumn(app_layout, app_area);

%%
app_row = NewRow(app_layout, app_column);

button_11_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_11_ui.Icon = "question";
button_11_ui.Text = button_11_ui.Icon;
button_11_ui.ButtonWidth = common_width;

button_12_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_12_ui.Icon = "info";
button_12_ui.Text = button_12_ui.Icon;
button_12_ui.ButtonWidth = common_width;

button_13_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_13_ui.Icon = "success";
button_13_ui.Text = button_13_ui.Icon;
button_13_ui.ButtonWidth = common_width;

%%
app_row = NewRow(app_layout, app_column);

button_21_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_21_ui.Icon = "warning";
button_21_ui.Text = button_21_ui.Icon;
button_21_ui.ButtonWidth = common_width;

button_22_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_22_ui.Icon = "error";
button_22_ui.Text = button_22_ui.Icon;
button_22_ui.ButtonWidth = common_width;

button_23_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_23_ui.Text = "disabled";
button_23_ui.ButtonWidth = common_width;
button_23_ui.MainButton.Enable = "off";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function
