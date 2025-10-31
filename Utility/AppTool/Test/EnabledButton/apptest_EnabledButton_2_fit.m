function App = testapp_EnabledButton_2_fit
% This test app directly uses uifigure.
% Component layout is done with LiteAppLayout.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 500;  % width
main_figure.Position(4) = 100;  % height

main_figure.Theme = "dark";

app_layout = LiteApp8.LiteAppLayout(main_figure);

%% "fit" test

enabled_button_ui_1 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_1.HorizontalAlignment = "left";
enabled_button_ui_1.LiteAppTheme = main_figure.Theme.BaseColorStyle;
enabled_button_ui_1.HighlightBackground = "on";

enabled_button_ui_1.ButtonText = "Button text";
enabled_button_ui_1.ButtonUIWidth = "fit";
enabled_button_ui_1.ButtonWidth = "fit";

enabled_button_ui_1.CheckBoxText = "check box text";
enabled_button_ui_1.CheckBoxUIWidth = "fit";
enabled_button_ui_1.CheckBoxWidth = "fit";

enabled_button_ui_1.ButtonDisable = "on";


enabled_button_ui_2 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_2.HorizontalAlignment = "left";
enabled_button_ui_2.LiteAppTheme = main_figure.Theme.BaseColorStyle;
enabled_button_ui_2.HighlightBackground = "on";

enabled_button_ui_2.ButtonText = "Button text 2";
enabled_button_ui_2.ButtonUIWidth = "fit";
enabled_button_ui_2.ButtonWidth = "fit";

enabled_button_ui_2.CheckBoxText = "check box text 2";
enabled_button_ui_2.CheckBoxUIWidth = "fit";
enabled_button_ui_2.CheckBoxWidth = "fit";


enabled_button_ui_3 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_3.HorizontalAlignment = "left";
enabled_button_ui_3.LiteAppTheme = main_figure.Theme.BaseColorStyle;
enabled_button_ui_3.HighlightBackground = "on";

enabled_button_ui_3.ButtonText = "Button text three";
enabled_button_ui_3.ButtonUIWidth = "fit";
enabled_button_ui_3.ButtonWidth = "fit";

enabled_button_ui_3.CheckBoxText = "check box text three";
enabled_button_ui_3.CheckBoxUIWidth = "fit";
enabled_button_ui_3.CheckBoxWidth = "fit";

enabled_button_ui_3.ButtonEnable = "off";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EnabledButtonUI = enabled_button_ui_3;
end % if
end  % function
