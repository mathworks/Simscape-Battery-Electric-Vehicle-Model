function App = EditableDropDown_testapp_2
% This test app directly uses uifigure.
% Component layout is handled with LiteAppLayout.

% If Editable is "off" in an EditableDropDown component, interactive edit is disabled,
% but, it is still possible to modify the Items property programmaticaly.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 500;  % width
main_figure.Position(4) = 300;  % height
main_figure.Theme = "light";

layout = LiteApp8.LiteAppLayout(main_figure);

%%

button_ui = LiteApp8.Component.Button(NewArea(layout));
button_ui.ButtonPushedCallback = @() react_ButtonPushed();
button_ui.Text = "Added";

editable_drop_down_ui = LiteApp8.Component.EditableDropDown(NewArea(layout));  % !test-target

% Set Items before turning off MainDropDown's Editable property.
editable_drop_down_ui.Items = ["1", "2"];

editable_drop_down_ui.MainDropDown.Editable = "off";

% Set new Items after turning off MainDropDown's Editable property.
editable_drop_down_ui.Items = ["aa", "bb", "cc"];

  function react_ButtonPushed
    items = editable_drop_down_ui.Items;
    % Modify the items programmatically via button click.
    editable_drop_down_ui.Items = [items; button_ui.Text];  % !test-target
  end  % nested function

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EditableDropDownUI = editable_drop_down_ui;
  App.ButtonUI = button_ui;
end % if
end  % function
