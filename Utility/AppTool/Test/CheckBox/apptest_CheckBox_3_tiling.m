function App = CheckBox_testapp_3_tiling

% Tile the same components.
% Visually inspect the spacing among them.

% Copyright 2024 The MathWorks, Inc.

arguments (Output)
  App (1,1) struct
end

main_figure = uifigure(Visible="off");
App.Window.MainFigure = main_figure;

main_figure.Position(3) = 900;  % width
main_figure.Position(4) = 300;  % height

main_grid = uigridlayout(main_figure, [1 1]);
main_grid.RowHeight = {'fit'};
main_grid.ColumnWidth = {'1x'};
main_grid.Padding = [0 0 0 0];
main_grid.ColumnSpacing = 0;
main_grid.RowSpacing = 0;

app_layout = LiteApp6.LiteAppLayout(main_grid);

area = NewArea(app_layout);

column = NewColumn(app_layout, area);
build_ui(app_layout, column, [1 0 1]);
build_ui(app_layout, column, [0 1 0]);
build_ui(app_layout, column, [1 0 1]);

column = NewColumn(app_layout, area);
build_ui(app_layout, column, [0 1 0]);
build_ui(app_layout, column, [1 0 1]);
build_ui(app_layout, column, [0 1 0]);

%%
main_figure.Visible = "on";
end

function build_ui(layout, column, hilit)
%%

for i = 1 : 3
  row = NewRow(layout, column);

  % left
  ef_1 = LiteApp6.Component.CheckBox(NewSlot(layout, row, Width=160));  % #test-target
  ef_1.HighlightBackground = hilit(1);

  % center
  ef_2 = LiteApp6.Component.CheckBox(NewSlot(layout, row, Width="1x"));  % #test-target
  ef_2.HighlightBackground = hilit(2);

  % right
  ef_3 = LiteApp6.Component.CheckBox(NewSlot(layout, row, Width="2x"));  % #test-target
  ef_3.HighlightBackground = hilit(3);
end  % for

end  % function
