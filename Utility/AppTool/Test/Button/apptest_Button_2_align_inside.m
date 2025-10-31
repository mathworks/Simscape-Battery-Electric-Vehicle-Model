function App = apptest_Button__align_inside
% Test the alignment/positioning of the main component within the component.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

common_height = LiteApp8.Constant.Height{"oneline++"}*3;

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 660;  % width
main_figure.Position(4) = 260;  % height

main_figure.Theme = "dark";

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
button_11_ui.ComponentHeight = common_height;
button_11_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_11_ui.VerticalAlignment = "top";
button_11_ui.HorizontalAlignment = "left";
button_11_ui.HighlightBackground = "on";

button_12_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_12_ui.ComponentHeight = common_height;
button_12_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_12_ui.VerticalAlignment = "top";
button_12_ui.HorizontalAlignment = "center";
button_12_ui.HighlightBackground = "off";

button_13_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_13_ui.ComponentHeight = common_height;
button_13_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_13_ui.VerticalAlignment = "top";
button_13_ui.HorizontalAlignment = "right";
button_13_ui.HighlightBackground = "on";

%%
app_row = NewRow(app_layout, app_column);

button_21_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_21_ui.ComponentHeight = common_height;
button_21_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_21_ui.VerticalAlignment = "center";
button_21_ui.HorizontalAlignment = "left";
button_21_ui.HighlightBackground = "off";

button_22_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_22_ui.ComponentHeight = common_height;
button_22_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_22_ui.VerticalAlignment = "center";
button_22_ui.HorizontalAlignment = "center";
button_22_ui.HighlightBackground = "on";

button_23_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_23_ui.ComponentHeight = common_height;
button_23_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_23_ui.VerticalAlignment = "center";
button_23_ui.HorizontalAlignment = "right";
button_23_ui.HighlightBackground = "off";

%%
app_row = NewRow(app_layout, app_column);

button_31_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_31_ui.ComponentHeight = common_height;
button_31_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_31_ui.VerticalAlignment = "bottom";
button_31_ui.HorizontalAlignment = "left";
button_31_ui.HighlightBackground = "on";

button_32_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_32_ui.ComponentHeight = common_height;
button_32_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_32_ui.VerticalAlignment = "bottom";
button_32_ui.HorizontalAlignment = "center";
button_32_ui.HighlightBackground = "off";

button_33_ui = LiteApp8.Component.Button(NewSlot(app_layout, app_row));  % !test-target
button_33_ui.ComponentHeight = common_height;
button_33_ui.LiteAppTheme = main_figure.Theme.BaseColorStyle;
button_33_ui.VerticalAlignment = "bottom";
button_33_ui.HorizontalAlignment = "right";
button_33_ui.HighlightBackground = "on";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function
