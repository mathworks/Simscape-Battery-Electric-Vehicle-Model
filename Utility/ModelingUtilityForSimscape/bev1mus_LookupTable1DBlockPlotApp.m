function App = bev1mus_LookupTable1DBlockPlotApp(NameValuePair)
% App to visualize lookup table blocks in a model
%
% By default, the app opens with no model being linked. Use the "Open model" button
% to select a target model. To open the app with a model, use the ModelFilePath option.
%
% This app automatically finds Simscape LUT blocks and Simulink LUT blocks in the model.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ModelFilePath (1,:) string {mustBeScalarOrEmpty}
end  % arguments

arguments (Output)
  App (1,:) struct
end  % arguments

errorID = "LookupTable1DBlockPlotApp:";

if isfield(NameValuePair, "ModelFilePath")
  if not(isfile(NameValuePair.ModelFilePath))
    id = errorID + "InvalidModelFilePath";
    msg = bev1mus.CodeUtil.i18n("The file specified for ModelFilePath is not valid.");

    throw(MException(id, msg))

  end  % if
  model_file_path = NameValuePair.ModelFilePath;
else
  model_file_path = "";
end  % if

main_figure = uifigure(Visible="off");

app_window = bev1mus.AppUtil.AppWindow(main_figure, SourceFile=mfilename);
app_window.Width = 800;
app_window.Height = 500;
app_window.Name = bev1mus.CodeUtil.i18n("Lookup-Table 1D Block Plot App");

app_vertical_container = app_window.MainVerticalContainer;

column_grid = addVerticalGridLayout(app_vertical_container);
block_selector_ui = bev1mus.AppUtil.Component.BlockSelectorUI(column_grid);
block_selector_ui.GetOnly = true;
block_selector_ui.AutoGet = true;
block_selector_ui.FindBlockCallback = @bev1mus.ModelUtil.findLookupTable1DBlocks;
block_selector_ui.GetParametersFromBlockCallback = @() get_parameters_from_block();
block_selector_ui.ModelFileFullPath = model_file_path;

column_grid = addVerticalGridLayout(app_vertical_container);
open_fig_win_ui = bev1mus.AppUtil.Component.Hyperlink(column_grid);
open_fig_win_ui.Text = bev1mus.CodeUtil.i18n("Open in figure window");
open_fig_win_ui.HorizontalAlignment = "right";
open_fig_win_ui.HyperlinkClickedCallback = @() react_figwin();

column_grid = addVerticalGridLayout(app_vertical_container);
panel_ui = bev1mus.AppUtil.Graphics.Panel(column_grid);
panel_ui.ComponentHeight = 380;

  function react_figwin()
    if not(block_selector_ui.Initialized) || (block_selector_ui.BlockPath == "")

      return

    end  % if
    [~, block_name, ~] = fileparts(block_selector_ui.BlockPath);
    bev1mus.ModelUtil.plotLookupTable1DBlocks(gcs, Blocks=block_name, ParentType="Axes", ParentAxes=axes(figure))
  end  % nested function

  function get_parameters_from_block()
    if not(block_selector_ui.Initialized) || (block_selector_ui.BlockPath == "")

      return

    end  % if
    [~, block_name, ~] = fileparts(block_selector_ui.BlockPath);
    bev1mus.ModelUtil.plotLookupTable1DBlocks(gcs, Blocks=block_name, ParentType="Panel", ParentPanel=panel_ui.MainPanel)
  end  % nested function

%%
movegui(main_figure, "center")
main_figure.Visible = "on";
drawnow
% Call this after Visible="on" and drawnow.
get_parameters_from_block()
if nargout > 0
  App.Window = app_window;
end  % if
end  % function
