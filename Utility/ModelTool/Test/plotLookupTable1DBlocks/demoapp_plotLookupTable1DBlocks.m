function App = demoapp_plotLookupTable1DBlocks()

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,:) struct
end

model_name = "testmodel_plotLookupTable1DBlocks_refsub";
load_system(model_name)

main_figure = uifigure(Visible="off");
main_figure.Position(3:4) = [600 400];  % width, height

layout = LiteApp7.LiteAppLayout(main_figure);

panel_ui = LiteApp7.Graphics.Panel(NewArea(layout));
panel_ui.ComponentHeight = 390;
% panel_ui.HighlightBackground = "on";

ModelTool1.plotLookupTable1DBlocks( ...
  model_name + "/Subsystem", ...
  Blocks = ["PS smooth1" "SL smooth1"], ...
  ParentType = "Panel", ...
  ParentPanel = panel_ui.MainPanel )

main_figure.Visible = "on";

if nargout > 0
  App.Window.MainFigure = main_figure;
end  % if
end  % function
