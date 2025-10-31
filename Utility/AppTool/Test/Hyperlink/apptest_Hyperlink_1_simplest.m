function App = testapp_Hyperlink_1_bare_minimum
% This test directly uses uifigure and uigridlayout instead of the LiteAppLayout.
% This keeps the dependency of this code minimal.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end  % arguments

main_figure = uifigure(Visible="off");

main_figure.Theme = "light";

layout = uigridlayout(main_figure, [1 1]);
layout.RowHeight = {'fit'};
layout.ColumnWidth = {'1x'};
layout.Padding = [0 0 0 0];
layout.ColumnSpacing = 0;
layout.RowSpacing = 0;

link_ui = LiteApp8.Component.Hyperlink(layout);  % !test-target
link_ui.Theme = main_figure.Theme.BaseColorStyle;
link_ui.Text = "Click Here";
link_ui.HyperlinkClickedCallback = @() disp("Testing the hyperlink UI.");

% Highlight the entire area of the test target component.
link_ui.HighlightBackground = "on";

main_figure.Visible = "on";

if nargout > 0
  App.Window.MainFigure = main_figure;
  App.LinkUI = link_ui;
end  % if
end  % function
