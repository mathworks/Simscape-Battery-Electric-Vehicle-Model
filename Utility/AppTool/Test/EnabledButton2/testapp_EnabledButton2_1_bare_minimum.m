function App = testapp_EnabledButton2_1_bare_minimum
% This test app directly uses uifigure and uigridlayout instead of LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 500;  % width
main_figure.Position(4) = 100;  % height
main_figure.Theme = "light";

layout = uigridlayout(main_figure, [1 1]);
layout.RowHeight = {'fit'};
layout.ColumnWidth = {'1x'};
layout.Padding = [0 0 0 0];
layout.ColumnSpacing = 0;
layout.RowSpacing = 0;

%%

enabled_button_ui = LiteApp8.Component.EnabledButton2(layout);  % !test-target

enabled_button_ui.ButtonPushedCallback = @() disp("Enabled button: ButtonPushedCallback");
enabled_button_ui.CheckBoxValueChangedCallback = @() disp("Enabled button: CheckBoxValueChangedCallback");

% Highlight the entire area of the test target component to make the component area clear.
enabled_button_ui.HighlightBackground = "on";

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
  App.EnabledButtonUI = enabled_button_ui;
end % if
end  % function
