function App = testapp_AlignComponents_1_horizontal
% Test alignment with other UI components.
%
% This test does not automate the inspection process.
% You must visually inspect the alignment.
%
% By default, the ComponentHeight property of the following components are
% configured to have the "oneline++" height.
%
% - Button
% - CheckBox
% - DropDown
% - EditField
% - Hyperlink
% - Label
% - StateButton
%
% These components must align horizontally without specifying ComponentHeight.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");

main_figure.Position(3) = 1000;  % width
main_figure.Position(4) = 200;  % height

main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

main_layout = LiteApp8.LiteAppLayout(main_grid);

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

LiteApp8.Component.HorizontalLine(NewSlot(main_layout, app_row));

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";
label_ui.ThemeNameForBackGroundHighlight = main_figure.Theme.BaseColorStyle;
label_ui.HighlightBackground = "on";

link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";

editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";

dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";

state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

LiteApp8.Component.HorizontalLine(NewSlot(main_layout, app_row));

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";

link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";
link_ui.ThemeNameForBackGroundHighlight = main_figure.Theme.BaseColorStyle;
link_ui.HighlightBackground = "on";

editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";

dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";

state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

LiteApp8.Component.HorizontalLine(NewSlot(main_layout, app_row));

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";

link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";

editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";

dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";

checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";

button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";

state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

LiteApp8.Component.HorizontalLine(NewSlot(main_layout, app_row));

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";
link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";
label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";
dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";
checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";
button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";
state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";
link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";
label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";
dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";
checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";
button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";
state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Left label";
link_ui = LiteApp8.Component.Hyperlink(NewSlot(main_layout, app_row));
link_ui.Text = "Hyperlink text";
editfield_ui = LiteApp8.Component.EditField(NewSlot(main_layout, app_row));
editfield_ui.MainEditField.Placeholder = "(edit field)";
label_ui = LiteApp8.Component.Label(NewSlot(main_layout, app_row));
label_ui.Text = "Label text";
dropdown_ui = LiteApp8.Component.DropDown(NewSlot(main_layout, app_row));
dropdown_ui.Items = ["1", "2"];
dropdown_ui.Value = "1";
checkbox_ui = LiteApp8.Component.CheckBox(NewSlot(main_layout, app_row));
checkbox_ui.Text = "Check box";
button_ui = LiteApp8.Component.Button(NewSlot(main_layout, app_row));
button_ui.Text = "Button";
state_button_ui = LiteApp8.Component.StateButton(NewSlot(main_layout, app_row));
state_button_ui.Text = "State button";

% -----------------------------------------------------------------------------
app_row = NewRow(main_layout, app_column);

LiteApp8.Component.HorizontalLine(NewSlot(main_layout, app_row));

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function
