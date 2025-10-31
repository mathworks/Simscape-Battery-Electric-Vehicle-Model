function App = apptest_Axes_4_WithLiteAppWindow

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (:,1) struct
end  % arguments

app_window = LiteApp8.LiteAppWindow;
app_window.Width = 300;
app_window.Height = 400;

main_layout = app_window.MainLayout;

app_area = NewArea(main_layout);
app_column = NewColumn(main_layout, app_area);
app_row = NewRow(main_layout, app_column);

%%

axes_ui = LiteApp8.Graphics.Axes(NewSlot(main_layout, app_row));  % !test-target

% Make axes UI taller than the app window.
% Vertical scrollbar must appear when the app window appears.
axes_ui.ComponentHeight = app_window.Height + 100;

%%
Show(app_window)

% if nargout > 0
  App.Window = app_window;
% end  % if
end  % function
