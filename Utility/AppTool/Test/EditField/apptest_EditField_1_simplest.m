function app = EditField_testapp_1
% This test directly uses uifigure and uigridlayout
% instead of LiteApp5.LiteAppLayout.
% This keeps the dependency of this test minimal.

% Copyright 2024 The MathWorks, Inc.

arguments (Output)
  app (1,1) struct
end

MainFigure = uifigure(Visible="off");
app.Window.MainFigure = MainFigure;

MainGrid = uigridlayout(MainFigure);
MainGrid.RowHeight = {'fit'};
MainGrid.ColumnWidth = {'1x'};
MainGrid.Padding = [0 0 0 0];
MainGrid.ColumnSpacing = 0;
MainGrid.RowSpacing = 0;

LiteApp5.Component.EditField(MainGrid);  % #test-target-all-default

MainFigure.Visible = "on";

end  % function
