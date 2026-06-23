function App = ContourQuiverApp
% A small but complete example app for math text, parameter handing, visualization, etc.
% This app uses various features from the App Util.
%
% The equation used for visualization is based on the following documentation.
% Combine Contour Plot and Quiver Plot
% https://mathworks.com/help/matlab/creating_plots/display-quiver-plot-over-contour-plot.html

% Copyright 2026 The MathWorks, Inc.

arguments (Output)
  App struct {mustBeScalarOrEmpty}
end  % arguments

main_figure = uifigure(Visible="off");

if not(isMATLABReleaseOlderThan("R2025a"))
  main_figure.Theme = "light";
end  % if

app_window = AppUtil1.AppWindow(main_figure, SourceFile=mfilename);
app_window.Name = CodeUtil1.i18n("Contour and Quiver");
app_window.Width = 480;
app_window.Height = 570;

app_v_container = app_window.MainVerticalContainer;

% -----------------------------------------------------------------------------

v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.ComponentHeight = AppUtil1.Constant.Height{"oneline+"} * 3;
label_ui.Text = CodeUtil1.i18n("Make a plot of the following function.") ...
  + newline + "$z(x, y) = x \exp ( -x^2 - y^2 )$";

% -----------------------------------------------------------------------------

v_layout = addVerticalGridLayout(app_v_container);

num_contour_ui = AppUtil1.Component.DoubleValueUI(v_layout);
num_contour_ui.NameText = CodeUtil1.i18n("Number of contours");
num_contour_ui.ValueChangedCallback = @() react_NumContourUI_ValueChanged();

current_num_contour_text = "10";
num_contour_ui.ValueText = current_num_contour_text;

  function react_NumContourUI_ValueChanged
    % When this callback runs, the value in the edit field is already updated.
    % If the new value is not acceptable, the previous value must be recovered.

    x = num_contour_ui.MainDoubleValue;

    % Basic error handling such as syntax error is managed by the DoubleValueUI.
    % This callback does additional checks specific to this application.
    try
      mustBeInteger(x)
    catch exception
      uialert(main_figure, exception.message, CodeUtil1.i18n("Error"))
      num_contour_ui.ValueText = current_num_contour_text;

      return

    end  % try, catch
    try
      mustBePositive(x)
    catch exception
      uialert(main_figure, exception.message, CodeUtil1.i18n("Error"))
      num_contour_ui.ValueText = current_num_contour_text;

      return

    end  % try, catch

    current_num_contour_text = num_contour_ui.ValueText;
    update_plot()

  end  % nested function

% -----------------------------------------------------------------------------

v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = CodeUtil1.i18n("Base workspace variable is supported.");
label_ui.HorizontalAlignment = "right";

% -----------------------------------------------------------------------------

v_layout = addVerticalGridLayout(app_v_container);

checkbox_ui = AppUtil1.Component.CheckBox(v_layout);
checkbox_ui.Text = CodeUtil1.i18n("Show contour values");
checkbox_ui.ValueChangedCallback = @() update_plot();

% -----------------------------------------------------------------------------
% "Update plot" button on the left.
% "Open in figure window..." hyperlink on the right.

v_layout = addVerticalGridLayout(app_v_container);

h_container = AppUtil1.HorizontalContainer(v_layout);

h_layout = addHorizontalGridLayout(h_container);
button_ui = AppUtil1.Component.Button(h_layout);
button_ui.HorizontalAlignment = "left";
button_ui.ComponentWidth = 140;
button_ui.Text = CodeUtil1.i18n("Update plot");
button_ui.ButtonPushedCallback = @() update_plot();

h_layout = addHorizontalGridLayout(h_container);
openfig_ui = AppUtil1.Component.Hyperlink(h_layout);
openfig_ui.HorizontalAlignment = "right";
openfig_ui.Text = CodeUtil1.i18n("Open in figure window");
openfig_ui.HyperlinkClickedCallback = @() update_plot(axes(figure));

% -----------------------------------------------------------------------------

v_layout = addVerticalGridLayout(app_v_container);

panel_ui = AppUtil1.Graphics.Panel(v_layout);
panel_ui.ComponentHeight = 360;

% Create an axes object outside of the update_plot callback
% to make sure that the object is created only once for an app.
plot_axes = axes(panel_ui.MainPanel);

  function update_plot(parent_axes)
    if nargin == 0
      ax = plot_axes;
      % Clear the contents of the axes to avoid overwriting contents.
      cla(ax)
    else
      ax = parent_axes;
    end  % if

    num_contours = num_contour_ui.MainDoubleValue;
    show_text = checkbox_ui.Value;

    [X, Y] = meshgrid(-2 : 0.2 : 2);
    Z = X .* exp( -X.^2 - Y.^2 );
    [U, V] = gradient(Z, 0.2, 0.2);

    contour(ax, X, Y, Z, num_contours, ShowText=show_text);

    hold(ax, "on")

    quiver(ax, X, Y, U, V)

    xlabel(ax, "x")
    ylabel(ax, "y")

  end  % nested function

update_plot()

% -----------------------------------------------------------------------------
movegui(main_figure, "center")
main_figure.Visible = "on";
drawnow
if nargout > 0
  App = struct;
  App.Window = app_window;
  App.NumContourUI = num_contour_ui;
  App.CheckBoxUI = checkbox_ui;
  App.ButtonUI = button_ui;
  App.OpenFigUI = openfig_ui;
  App.UpdatePlot = @update_plot;
end  % if
end  % function
