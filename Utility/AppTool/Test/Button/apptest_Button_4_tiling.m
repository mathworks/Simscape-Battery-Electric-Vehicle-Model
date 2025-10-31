function App = Button_testapp_4_tiling
% Test the spacing among the same components.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

main_figure = uifigure(Visible="off");
main_figure.Position(3) = 900;  % width
main_figure.Position(4) = 300;  % height

main_figure.Theme = "light";

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

app_layout = LiteApp8.LiteAppLayout(main_grid);
app_area = NewArea(app_layout);

app_column = NewColumn(app_layout, app_area);
build_ui(app_layout, app_column, [1 0 1]);
build_ui(app_layout, app_column, [0 1 0]);
build_ui(app_layout, app_column, [1 0 1]);

app_column = NewColumn(app_layout, app_area);
build_ui(app_layout, app_column, [0 1 0]);
build_ui(app_layout, app_column, [1 0 1]);
build_ui(app_layout, app_column, [0 1 0]);

%%
main_figure.Visible = "on";

if nargout > 0
  App = struct;
  App.Window.MainFigure = main_figure;
end  % if
end  % function

function build_ui(app_layout, app_column, hilit)
%% Add 9 buttons in the 3-by-3 layout.
for row_count = 1 : 3
  app_row = NewRow(app_layout, app_column);

  % left
  ef_1 = LiteApp8.Component.Button(NewSlot(app_layout, app_row, Width=160));  % #test-target
  ef_1.HighlightBackground = hilit(1);

  % center
  ef_2 = LiteApp8.Component.Button(NewSlot(app_layout, app_row, Width="1x"));  % #test-target
  ef_2.HighlightBackground = hilit(2);

  % right
  ef_3 = LiteApp8.Component.Button(NewSlot(app_layout, app_row, Width="1x"));  % #test-target
  ef_3.HighlightBackground = hilit(3);
end  % for
end  % function
