function App = CheckBox_testapp_2_align_inside

% Test alignment within the component:
% - VerticalAlignment
% - HorizontalAlignment

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 760;  % width
main_figure.Position(4) = 300;  % height

main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

app_layout = LiteApp8.LiteAppLayout(main_grid);

build_ui(app_layout, NewArea(app_layout), "top",    [1 0 1], main_figure.Theme.BaseColorStyle)
build_ui(app_layout, NewArea(app_layout), "center", [0 1 0], main_figure.Theme.BaseColorStyle)
build_ui(app_layout, NewArea(app_layout), "bottom", [1 0 1], main_figure.Theme.BaseColorStyle)

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function

function build_ui(layout, area, vert, hilit, base_color_style)
%%
column = NewColumn(layout, area);

cb = LiteApp8.Component.CheckBox(column);  % #test-target
cb.ComponentHeight = LiteApp8.Constant.Height{"oneline"}*4;
cb.VerticalAlignment = vert;
cb.HorizontalAlignment = "left";
cb.ValueChangedCallback = @() disp(cb.Text);
cb.Text = ...
  "VerticalAlignment: " + cb.VerticalAlignment + newline + ...
  "HorizontalAlignment: " + cb.HorizontalAlignment;
cb.LiteAppTheme = base_color_style;
cb.HighlightBackground = hilit(1);

column = NewColumn(layout, area);

cb = LiteApp8.Component.CheckBox(column);  % #test-target
cb.ComponentHeight = LiteApp8.Constant.Height{"oneline"}*4;
cb.VerticalAlignment = vert;
cb.HorizontalAlignment = "center";
cb.ValueChangedCallback = @() disp(cb.Text);
cb.Text = ...
  "VerticalAlignment: " + cb.VerticalAlignment + newline + ...
  "HorizontalAlignment: " + cb.HorizontalAlignment;
cb.LiteAppTheme = base_color_style;
cb.HighlightBackground = hilit(2);

column = NewColumn(layout, area);

cb = LiteApp8.Component.CheckBox(column);  % #test-target
cb.ComponentHeight = LiteApp8.Constant.Height{"oneline"}*4;
cb.VerticalAlignment = vert;
cb.HorizontalAlignment = "right";
cb.ValueChangedCallback = @() disp(cb.Text);
cb.Text = ...
  "VerticalAlignment: " + cb.VerticalAlignment + newline + ...
  "HorizontalAlignment: " + cb.HorizontalAlignment;
cb.LiteAppTheme = base_color_style;
cb.HighlightBackground = hilit(3);

end  % function
