function App = Button_testapp_1_bare_minimum
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 300;  % width
main_figure.Position(4) = 80;  % height

main_figure.Theme = "dark";

layout = uigridlayout(main_figure, [1 1]);
layout.RowHeight = {'fit'};
layout.ColumnWidth = {'1x'};
layout.Padding = [0 0 0 0];
layout.ColumnSpacing = 0;
layout.RowSpacing = 0;

%%

button_ui_1 =  LiteApp8.Component.Button(layout);  % !test-target
button_ui_1.ButtonPushedCallback = @() disp("Testing button");

button_ui_1.Theme = main_figure.Theme.BaseColorStyle;

% Highlight the entire area of the test target component to make the component area clear.
button_ui_1.HighlightBackground = "on";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.ButtonUI = button_ui_1;
end  % if
end  % function
