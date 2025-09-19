function App = testapp_Hyperlink2_2_inner_align
% Test the horizontal and vertical position of the main component within the component.
%
% Key properties of this test:
% - VerticalAlignment
% - HorizontalAlignment

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end

common_height = LiteApp7.Constant.Height{"oneline++"}*3;

main_figure = uifigure(Visible="off");
App.Window.MainFigure = main_figure;

main_figure.Position(3) = 700;  % width
main_figure.Position(4) = 300;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

main_layout = LiteApp7.LiteAppLayout(main_grid);

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);

%%
app_row = NewRow(main_layout, app_column);

link_11_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_11_ui.Text = "Testing" + newline + "hyperlink component";
link_11_ui.ComponentHeight = common_height;
link_11_ui.VerticalAlignment = "top";
link_11_ui.HorizontalAlignment = "left";
link_11_ui.HighlightBackground = "on";

link_12_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_12_ui.Text = "Testing" + newline + "hyperlink component";
link_12_ui.ComponentHeight = common_height;
link_12_ui.VerticalAlignment = "top";
link_12_ui.HorizontalAlignment = "center";
link_12_ui.HighlightBackground = "off";

link_13_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_13_ui.Text = "Testing" + newline + "hyperlink component";
link_13_ui.ComponentHeight = common_height;
link_13_ui.VerticalAlignment = "top";
link_13_ui.HorizontalAlignment = "right";
link_13_ui.HighlightBackground = "on";

%%
app_row = NewRow(main_layout, app_column);

link_21_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_21_ui.Text = "Testing" + newline + "hyperlink component";
link_21_ui.ComponentHeight = common_height;
link_21_ui.VerticalAlignment = "center";
link_21_ui.HorizontalAlignment = "left";
link_21_ui.HighlightBackground = "off";

link_22_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_22_ui.Text = "Testing" + newline + "hyperlink component";
link_22_ui.ComponentHeight = common_height;
link_22_ui.VerticalAlignment = "center";
link_22_ui.HorizontalAlignment = "center";
link_22_ui.HighlightBackground = "on";

link_23_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_23_ui.Text = "Testing" + newline + "hyperlink component";
link_23_ui.ComponentHeight = common_height;
link_23_ui.VerticalAlignment = "center";
link_23_ui.HorizontalAlignment = "right";
link_23_ui.HighlightBackground = "off";

%%
app_row = NewRow(main_layout, app_column);

link_31_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_31_ui.Text = "Testing" + newline + "hyperlink component";
link_31_ui.ComponentHeight = common_height;
link_31_ui.VerticalAlignment = "bottom";
link_31_ui.HorizontalAlignment = "left";
link_31_ui.HighlightBackground = "on";

link_32_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_32_ui.Text = "Testing" + newline + "hyperlink component";
link_32_ui.ComponentHeight = common_height;
link_32_ui.VerticalAlignment = "bottom";
link_32_ui.HorizontalAlignment = "center";
link_32_ui.HighlightBackground = "off";

link_33_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));  % !test-target
link_33_ui.Text = "Testing" + newline + "hyperlink component";
link_33_ui.ComponentHeight = common_height;
link_33_ui.VerticalAlignment = "bottom";
link_33_ui.HorizontalAlignment = "right";
link_33_ui.HighlightBackground = "on";

%%
main_figure.Visible = "on";
end  % function
