function App = testapp_AlignComponents_2_vertical
% Test alignment of UI components.
%
% This test does not automate the inspection process.
% You must visually inspect the alignment.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
App.Window.MainFigure = main_figure;

main_figure.Position(3) = 400;  % width
main_figure.Position(4) = 210;  % height
main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

main_layout = LiteApp7.LiteAppLayout(main_grid);
app_area = NewArea(main_layout);

% -----------------------------------------------------------------------------
app_column = NewColumn(main_layout, app_area);

app_row = NewRow(main_layout, app_column);
label_ui = LiteApp8.Component.Label2(NewSlot(main_layout, app_row));
label_ui.Text = "Label text 1";
label_ui.Theme = main_figure.Theme.BaseColorStyle;
label_ui.HighlightBackground = "on";

app_row = NewRow(main_layout, app_column);
link_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";

app_row = NewRow(main_layout, app_column);
editfield_ui = LiteApp7.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";

app_row = NewRow(main_layout, app_column);
label_ui = LiteApp8.Component.Label2(NewSlot(main_layout, app_row));
label_ui.Text = "Label text 2";

app_row = NewRow(main_layout, app_column);
dropdown_ui = LiteApp7.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

app_row = NewRow(main_layout, app_column);
checkbox_ui = LiteApp7.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

app_row = NewRow(main_layout, app_column);
button_ui = LiteApp7.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";

app_row = NewRow(main_layout, app_column);
state_button_ui = LiteApp7.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_column = NewColumn(main_layout, app_area);

app_row = NewRow(main_layout, app_column);
checkbox_ui = LiteApp7.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

app_row = NewRow(main_layout, app_column);
dropdown_ui = LiteApp7.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

app_row = NewRow(main_layout, app_column);
label_ui = LiteApp8.Component.Label2(NewSlot(main_layout, app_row));
label_ui.Text = "Label text 1";
label_ui.Theme = main_figure.Theme.BaseColorStyle;
label_ui.HighlightBackground = "on";

app_row = NewRow(main_layout, app_column);
button_ui = LiteApp7.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";

app_row = NewRow(main_layout, app_column);
editfield_ui = LiteApp7.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";

app_row = NewRow(main_layout, app_column);
link_ui = LiteApp8.Component.Hyperlink2(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";

app_row = NewRow(main_layout, app_column);
state_button_ui = LiteApp7.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

app_row = NewRow(main_layout, app_column);
label_ui = LiteApp8.Component.Label2(NewSlot(main_layout, app_row));
label_ui.Text = "Label text 2";
label_ui.Theme = main_figure.Theme.BaseColorStyle;
label_ui.HighlightBackground = "on";

%%
main_figure.Visible = "on";
end  % function
