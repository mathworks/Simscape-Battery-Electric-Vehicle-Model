function App = apptest_DropDown_2
% This test app directly uses uifigure.
% Component layout is handled with LiteAppLayout.
%
% Items can be modified programmaticaly.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 300;  % width
main_figure.Position(4) = 300;  % height

app_layout = LiteApp8.LiteAppLayout(main_figure);

%%

button_ui = LiteApp8.Component.Button(NewArea(app_layout));
button_ui.MainFigure = main_figure;
button_ui.Text = "Add an item";
button_ui.ButtonWidth = 140;
button_ui.ButtonPushedCallback = @() react_ButtonPushed();

drop_down_ui = LiteApp8.Component.DropDown(NewArea(app_layout));  % !test-target
drop_down_ui.MainFigure = main_figure;
drop_down_ui.Items = ["aa", "bb", "cc"];

  function react_ButtonPushed
    items = drop_down_ui.Items;
    % Modify the items programmatically via button click.
    drop_down_ui.Items = [items; "Added by button"];  % !test-target
  end  % nested function

%%
main_figure.Visible = "on";

drawnow
main_figure.Theme = "light";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.DropDownUI = drop_down_ui;
  App.ButtonUI = button_ui;
end % if
end  % function
