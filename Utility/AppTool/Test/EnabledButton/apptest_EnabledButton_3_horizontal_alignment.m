function App = testapp_EnabledButton_3_horizontal_alignment
% This test app directly uses uifigure.
% Component layout is done with LiteAppLayout.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 800;  % width
main_figure.Position(4) = 200;  % height

main_figure.Theme = "light";

unit_ui_width = LiteApp8.Constant.Width{"unitwidth"};

app_layout = LiteApp8.LiteAppLayout(main_figure);

%%

enabled_button_ui_L1 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_L1.HorizontalAlignment = "left";
enabled_button_ui_L1.ButtonText = "Button text left 1";
enabled_button_ui_L1.ButtonUIWidth = unit_ui_width * 16;
enabled_button_ui_L1.ButtonWidth = unit_ui_width * 15;
enabled_button_ui_L1.CheckBoxText = "check box text left 1";

enabled_button_ui_L2 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_L2.HorizontalAlignment = "left";
enabled_button_ui_L2.ButtonText = "Button text left 2";
enabled_button_ui_L2.ButtonUIWidth = unit_ui_width * 16;
enabled_button_ui_L2.ButtonWidth = unit_ui_width * 15;
enabled_button_ui_L2.CheckBoxText = "check box text left 2";

enabled_button_ui_R1 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_R1.HorizontalAlignment = "right";
enabled_button_ui_R1.ButtonText = "Button text right 1";
enabled_button_ui_R1.ButtonUIWidth = unit_ui_width * 18;
enabled_button_ui_R1.ButtonWidth = unit_ui_width * 17;
enabled_button_ui_R1.CheckBoxText = "check box text right 1";

enabled_button_ui_R2 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_R2.HorizontalAlignment = "right";
enabled_button_ui_R2.ButtonText = "Button text right 2";
enabled_button_ui_R2.ButtonUIWidth = unit_ui_width * 18;
enabled_button_ui_R2.ButtonWidth = unit_ui_width * 17;
enabled_button_ui_R2.CheckBoxText = "check box text right 2";

enabled_button_ui_C1 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_C1.HorizontalAlignment = "center";
enabled_button_ui_C1.ButtonText = "Button text center 1";
enabled_button_ui_C1.ButtonUIWidth = unit_ui_width * 18;
enabled_button_ui_C1.ButtonWidth = unit_ui_width * 17;
enabled_button_ui_C1.CheckBoxText = "check box text center 1";

enabled_button_ui_C2 = LiteApp8.Component.EnabledButton(NewArea(app_layout));  % !test-target
enabled_button_ui_C2.HorizontalAlignment = "center";
enabled_button_ui_C2.ButtonText = "Button text center 2";
enabled_button_ui_C2.ButtonUIWidth = unit_ui_width * 18;
enabled_button_ui_C2.ButtonWidth = unit_ui_width * 17;
enabled_button_ui_C2.CheckBoxText = "check box text center 2";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EnabledButtonUI = enabled_button_ui_C2;
end % if
end  % function
